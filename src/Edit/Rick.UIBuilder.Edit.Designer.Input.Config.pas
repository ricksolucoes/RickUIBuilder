unit Rick.UIBuilder.Edit.Designer.Input.Config;

{$SCOPEDENUMS ON}

interface

uses
  FMX.Edit,
  System.Classes,

  Rick.UIBuilder.Edit.Interfaces,
  Rick.UIBuilder.Edit.Types;

type
  TRickUIBuilderEditDesignerInputConfig = class(TComponent, IRickUIBuilderEditDesignerInputConfig)
  private
    [weak]
    FParent: IRickUIBuilderEditDesignerInput;
    FControl: TEdit;
    FPreset: TRickUIBuilderEditPreset;
    FCaseMode: TRickUIBuilderEditCaseMode;
    FUrlCaseMode: TRickUIBuilderEditUrlCaseMode;
    FApplyingText: Boolean;
    FLastAcceptedText: string;
    FPendingCaret: Integer;
    FCaretUpdateQueued: Boolean;
    FPendingGoToEnd: Boolean;
    FPreviousChangeTracking: TNotifyEvent;
    procedure ApplyPendingCaret;
    procedure QueueCaretUpdate(ACaret: Integer; AGoToEnd: Boolean = False);
    function IsAppendingAtEnd(const AOldText, ANewText: string): Boolean;
    function FormattedCaretPosition(const AValue: string;
      ARawCaret: Integer): Integer;
    procedure ApplyResolvedText(const AValue, AResolved: string);
    function IsEmailAtext(AChar: Char): Boolean;
    function IsEmailCharAllowed(AChar: Char; AIndex, AAtIndex: Integer): Boolean;
    function FindEmailSeparator(const AValue: string): Integer;
    function IsEmailAllowed(const AValue: string): Boolean;
    function IsCnpjBaseChar(AChar: Char): Boolean;
    function IsMaskSeparator(AChar: Char): Boolean;
    function IsCnpjTypingAllowed(const AValue: string): Boolean;
    function IsNumericMaskTypingAllowed(const AValue: string): Boolean;
    function IsMaskedTypingAllowed(const AValue: string): Boolean;
    function IsTypedValueAllowed(const AValue: string): Boolean;
    function OnlyDigits(const AValue: string): string;
    function OnlyAlphaNumeric(const AValue: string): string;
    function ApplyPattern(const ARaw, APattern: string): string;
    function FormatPhone(const AValue: string; AMobile: Boolean): string;
    function FormatMaskedValue(const AValue: string): string;
    function ApplyCase(const AValue: string): string;
    function FindUrlBoundary(const AValue: string): Integer;
    function ApplyUrlCase(const AValue: string): string;
    function FormatTypedValue(const AValue: string): string;
    function ResolveNumericValue(const AValue: string): string;
    function ResolveTextValue(const AValue: string): string;
    procedure HandleChangeTracking(ASender: TObject);
    procedure RefreshTracking;
  protected
    constructor Create(const AParent: IRickUIBuilderEditDesignerInput;
      AControl: TEdit); reintroduce;

    function Preset(AValue: TRickUIBuilderEditPreset): IRickUIBuilderEditDesignerInputConfig;
    function CaseMode(AValue: TRickUIBuilderEditCaseMode): IRickUIBuilderEditDesignerInputConfig;
    function UrlCaseMode(AValue: TRickUIBuilderEditUrlCaseMode): IRickUIBuilderEditDesignerInputConfig;
    function MaxLength(AValue: Integer): IRickUIBuilderEditDesignerInputConfig;
    function ToBack: IRickUIBuilderEditDesignerInput;
  public
    destructor Destroy; override;
    class function New(const AParent: IRickUIBuilderEditDesignerInput;
      AControl: TEdit): IRickUIBuilderEditDesignerInputConfig;
  end;

implementation

uses
  System.Character,
  System.SysUtils;

constructor TRickUIBuilderEditDesignerInputConfig.Create(
  const AParent: IRickUIBuilderEditDesignerInput; AControl: TEdit);
begin
  inherited Create(AControl);
  FParent := AParent;
  FControl := AControl;
  FPreset := TRickUIBuilderEditPreset.AllCharacters;
  FCaseMode := TRickUIBuilderEditCaseMode.Preserve;
  FUrlCaseMode := TRickUIBuilderEditUrlCaseMode.SchemeAndHost;
  FApplyingText := False;
  FLastAcceptedText := FControl.Text;
  FPendingCaret := 0;
  FCaretUpdateQueued := False;
  FPendingGoToEnd := False;
  FPreviousChangeTracking := FControl.OnChangeTracking;
  FControl.OnChangeTracking := HandleChangeTracking;
end;

destructor TRickUIBuilderEditDesignerInputConfig.Destroy;
begin
  if Assigned(FControl) and not (csDestroying in FControl.ComponentState) then
    FControl.OnChangeTracking := FPreviousChangeTracking;
  inherited;
end;

class function TRickUIBuilderEditDesignerInputConfig.New(
  const AParent: IRickUIBuilderEditDesignerInput;
  AControl: TEdit): IRickUIBuilderEditDesignerInputConfig;
begin
  Result := Self.Create(AParent, AControl);
end;

procedure TRickUIBuilderEditDesignerInputConfig.ApplyPendingCaret;
begin
  FCaretUpdateQueued := False;
  if csDestroying in FControl.ComponentState then
    Exit;
  if FPendingGoToEnd then
  begin
    FPendingGoToEnd := False;
    FControl.GoToTextEnd;
    Exit;
  end;
  if FPendingCaret > Length(FControl.Text) then
    FPendingCaret := Length(FControl.Text);
  FControl.CaretPosition := FPendingCaret;
  FControl.SelLength := 0;
end;

procedure TRickUIBuilderEditDesignerInputConfig.QueueCaretUpdate(
  ACaret: Integer; AGoToEnd: Boolean);
begin
  FPendingCaret := ACaret;
  FPendingGoToEnd := FPendingGoToEnd or AGoToEnd;
  if FCaretUpdateQueued then
    Exit;
  FCaretUpdateQueued := True;
  FControl.BeginInvoke(
    procedure
    begin
      ApplyPendingCaret;
    end, FControl);
end;

function TRickUIBuilderEditDesignerInputConfig.IsAppendingAtEnd(
  const AOldText, ANewText: string): Boolean;
begin
  Result := FControl.IsFocused and (FControl.SelLength = 0) and
    (FControl.CaretPosition = Length(ANewText)) and
    (Length(ANewText) > Length(AOldText)) and
    (Copy(ANewText, 1, Length(AOldText)) = AOldText);
end;

function TRickUIBuilderEditDesignerInputConfig.FormattedCaretPosition(
  const AValue: string; ARawCaret: Integer): Integer;
var
  LPrefix: string;
begin
  if ARawCaret < 0 then
    ARawCaret := 0;
  if ARawCaret > Length(AValue) then
    ARawCaret := Length(AValue);
  LPrefix := Copy(AValue, 1, ARawCaret);
  Result := Length(FormatTypedValue(LPrefix));
end;

procedure TRickUIBuilderEditDesignerInputConfig.ApplyResolvedText(
  const AValue, AResolved: string);
var
  LAppendAtEnd: Boolean;
  LCaret: Integer;
begin
  if AResolved = FControl.Text then
    Exit;
  LAppendAtEnd := IsAppendingAtEnd(FLastAcceptedText, AValue);
  LCaret := FormattedCaretPosition(AValue, FControl.CaretPosition);
  FApplyingText := True;
  try
    FControl.Text := AResolved;
    if LAppendAtEnd then
      FControl.GoToTextEnd
    else
      FControl.CaretPosition := LCaret;
    FControl.SelLength := 0;
    QueueCaretUpdate(LCaret, LAppendAtEnd);
  finally
    FApplyingText := False;
  end;
end;

function TRickUIBuilderEditDesignerInputConfig.IsEmailAtext(AChar: Char): Boolean;
begin
  Result := AChar.IsLetterOrDigit or CharInSet(AChar, ['_', '+', '-']);
end;

function TRickUIBuilderEditDesignerInputConfig.IsEmailCharAllowed(AChar: Char;
  AIndex, AAtIndex: Integer): Boolean;
begin
  if AChar = '@' then
    Exit(True);
  if (AAtIndex = 0) or (AIndex < AAtIndex) then
    Exit(IsEmailAtext(AChar) or (AChar = '.'));
  Result := AChar.IsLetterOrDigit or CharInSet(AChar, ['-', '.']);
end;

function TRickUIBuilderEditDesignerInputConfig.FindEmailSeparator(
  const AValue: string): Integer;
var
  LIndex: Integer;
begin
  Result := 0;
  for LIndex := 1 to Length(AValue) do
    if AValue[LIndex] = '@' then
    begin
      if Result > 0 then
        Exit(-1);
      Result := LIndex;
    end;
end;

function TRickUIBuilderEditDesignerInputConfig.IsEmailAllowed(
  const AValue: string): Boolean;
var
  LAtIndex: Integer;
  LIndex: Integer;
begin
  LAtIndex := FindEmailSeparator(AValue);
  if LAtIndex < 0 then
    Exit(False);
  for LIndex := 1 to Length(AValue) do
    if not IsEmailCharAllowed(AValue[LIndex], LIndex, LAtIndex) then
      Exit(False);
  Result := True;
end;

function TRickUIBuilderEditDesignerInputConfig.IsCnpjBaseChar(AChar: Char): Boolean;
begin
  Result := CharInSet(AChar, ['0'..'9', 'A'..'Z', 'a'..'z']);
end;

function TRickUIBuilderEditDesignerInputConfig.IsMaskSeparator(AChar: Char): Boolean;
begin
  case FPreset of
    TRickUIBuilderEditPreset.CPF: Result := CharInSet(AChar, ['.', '-']);
    TRickUIBuilderEditPreset.CNPJ: Result := CharInSet(AChar, ['.', '/', '-']);
    TRickUIBuilderEditPreset.CEP: Result := AChar = '-';
    TRickUIBuilderEditPreset.Phone,
    TRickUIBuilderEditPreset.Mobile: Result := CharInSet(AChar, ['(', ')', ' ', '-']);
  else
    Result := False;
  end;
end;

function TRickUIBuilderEditDesignerInputConfig.IsCnpjTypingAllowed(
  const AValue: string): Boolean;
var
  LAlphaIndex: Integer;
  LChar: Char;
begin
  LAlphaIndex := 0;
  for LChar in AValue do
  begin
    if IsCnpjBaseChar(LChar) then
    begin
      Inc(LAlphaIndex);
      if LAlphaIndex > 12 then
        if CharInSet(LChar, ['A'..'Z', 'a'..'z']) then
          Exit(False);
      Continue;
    end;
    if not IsMaskSeparator(LChar) then
      Exit(False);
  end;
  Result := True;
end;

function TRickUIBuilderEditDesignerInputConfig.IsNumericMaskTypingAllowed(
  const AValue: string): Boolean;
var
  LChar: Char;
begin
  for LChar in AValue do
  begin
    if IsCnpjBaseChar(LChar) then
    begin
      if CharInSet(LChar, ['A'..'Z', 'a'..'z']) then
        Exit(False);
      Continue;
    end;
    if not IsMaskSeparator(LChar) then
      Exit(False);
  end;
  Result := True;
end;

function TRickUIBuilderEditDesignerInputConfig.IsMaskedTypingAllowed(
  const AValue: string): Boolean;
begin
  if FPreset = TRickUIBuilderEditPreset.CNPJ then
    Exit(IsCnpjTypingAllowed(AValue));
  Result := IsNumericMaskTypingAllowed(AValue);
end;

function TRickUIBuilderEditDesignerInputConfig.IsTypedValueAllowed(
  const AValue: string): Boolean;
begin
  if FPreset in [TRickUIBuilderEditPreset.CPF, TRickUIBuilderEditPreset.CNPJ,
    TRickUIBuilderEditPreset.CEP, TRickUIBuilderEditPreset.Phone,
    TRickUIBuilderEditPreset.Mobile] then
    Exit(IsMaskedTypingAllowed(AValue));
  if FPreset = TRickUIBuilderEditPreset.Email then
    Exit(IsEmailAllowed(AValue));
  Result := True;
end;

function TRickUIBuilderEditDesignerInputConfig.OnlyDigits(
  const AValue: string): string;
var
  LChar: Char;
begin
  Result := EmptyStr;
  for LChar in AValue do
    if CharInSet(LChar, ['0'..'9']) then
      Result := Result + LChar;
end;

function TRickUIBuilderEditDesignerInputConfig.OnlyAlphaNumeric(
  const AValue: string): string;
var
  LChar: Char;
begin
  Result := EmptyStr;
  for LChar in AValue do
    if IsCnpjBaseChar(LChar) then
      Result := Result + UpCase(LChar);
end;

function TRickUIBuilderEditDesignerInputConfig.ApplyPattern(const ARaw,
  APattern: string): string;
var
  LIndex: Integer;
  LRawIndex: Integer;
begin
  Result := EmptyStr;
  LRawIndex := 1;
  for LIndex := 1 to Length(APattern) do
  begin
    if LRawIndex > Length(ARaw) then
      Break;
    if APattern[LIndex] = '0' then
    begin
      Result := Result + ARaw[LRawIndex];
      Inc(LRawIndex);
    end
    else
      Result := Result + APattern[LIndex];
  end;
end;

function TRickUIBuilderEditDesignerInputConfig.FormatPhone(
  const AValue: string; AMobile: Boolean): string;
var
  LDigits: string;
  LPattern: string;
begin
  LDigits := OnlyDigits(AValue);
  if AMobile then
  begin
    if Length(LDigits) > 9 then
      LPattern := '(00) 0 0000-0000'
    else
      LPattern := '0 0000-0000';
  end
  else if Length(LDigits) > 8 then
    LPattern := '(00) 0000-0000'
  else
    LPattern := '0000-0000';
  Result := ApplyPattern(LDigits, LPattern);
end;

function TRickUIBuilderEditDesignerInputConfig.FormatMaskedValue(
  const AValue: string): string;
var
  LRaw: string;
begin
  case FPreset of
    TRickUIBuilderEditPreset.CPF:
      Result := ApplyPattern(OnlyDigits(AValue), '000.000.000-00');
    TRickUIBuilderEditPreset.CNPJ:
      begin
        LRaw := OnlyAlphaNumeric(AValue);
        if Length(LRaw) > 12 then
          LRaw := Copy(LRaw, 1, 12) + OnlyDigits(Copy(LRaw, 13, 2));
        Result := ApplyPattern(LRaw, '00.000.000/0000-00');
      end;
    TRickUIBuilderEditPreset.CEP:
      Result := ApplyPattern(OnlyDigits(AValue), '00000-000');
    TRickUIBuilderEditPreset.Phone:
      Result := FormatPhone(AValue, False);
    TRickUIBuilderEditPreset.Mobile:
      Result := FormatPhone(AValue, True);
  else
    Result := AValue;
  end;
end;

function TRickUIBuilderEditDesignerInputConfig.ApplyCase(
  const AValue: string): string;
begin
  case FCaseMode of
    TRickUIBuilderEditCaseMode.Uppercase: Result := UpperCase(AValue);
    TRickUIBuilderEditCaseMode.Lowercase: Result := LowerCase(AValue);
  else
    Result := AValue;
  end;
end;

function TRickUIBuilderEditDesignerInputConfig.FindUrlBoundary(
  const AValue: string): Integer;
var
  LScheme: Integer;
begin
  LScheme := Pos('://', AValue);
  Result := Pos('/', AValue);
  if LScheme > 0 then
  begin
    if Result = LScheme + 1 then
      Result := Pos('/', Copy(AValue, LScheme + 3, MaxInt));
    if Result > 0 then
      Inc(Result, LScheme + 2);
  end;
  if Result = 0 then
    Result := Pos('?', AValue);
  if Result = 0 then
    Result := Pos('#', AValue);
end;

function TRickUIBuilderEditDesignerInputConfig.ApplyUrlCase(
  const AValue: string): string;
var
  LBoundary: Integer;
begin
  if FUrlCaseMode = TRickUIBuilderEditUrlCaseMode.EntireValue then
    Exit(LowerCase(AValue));
  LBoundary := FindUrlBoundary(AValue);
  if LBoundary = 0 then
    Exit(LowerCase(AValue));
  Result := LowerCase(Copy(AValue, 1, LBoundary - 1)) +
    Copy(AValue, LBoundary, MaxInt);
end;

function TRickUIBuilderEditDesignerInputConfig.FormatTypedValue(
  const AValue: string): string;
begin
  if FPreset in [TRickUIBuilderEditPreset.CPF, TRickUIBuilderEditPreset.CNPJ,
    TRickUIBuilderEditPreset.CEP, TRickUIBuilderEditPreset.Phone,
    TRickUIBuilderEditPreset.Mobile] then
    Result := FormatMaskedValue(AValue)
  else if FPreset = TRickUIBuilderEditPreset.Email then
    Result := LowerCase(AValue)
  else if FPreset = TRickUIBuilderEditPreset.URL then
    Result := ApplyUrlCase(AValue)
  else
    Result := ApplyCase(AValue);
end;

function TRickUIBuilderEditDesignerInputConfig.ResolveNumericValue(
  const AValue: string): string;
var
  LValue: string;
begin
  LValue := AValue;
  if FPreset = TRickUIBuilderEditPreset.IntegerNumber then
  begin
    if Assigned(FControl.OnValidate) then
      FControl.OnValidate(nil, LValue);
  end
  else if Assigned(FControl.OnValidating) then
    FControl.OnValidating(nil, LValue);
  if (AValue <> EmptyStr) and (LValue = EmptyStr) then
    Result := FLastAcceptedText
  else
    Result := LValue;
end;

function TRickUIBuilderEditDesignerInputConfig.ResolveTextValue(
  const AValue: string): string;
begin
  if not IsTypedValueAllowed(AValue) then
    Exit(FLastAcceptedText);
  Result := FormatTypedValue(AValue);
end;

procedure TRickUIBuilderEditDesignerInputConfig.HandleChangeTracking(
  ASender: TObject);
var
  LOriginal: string;
  LResolved: string;
begin
  if FApplyingText then
    Exit;
  if not Assigned(ASender) then
  begin
    if Assigned(FPreviousChangeTracking) then
      FPreviousChangeTracking(ASender);
    Exit;
  end;
  LOriginal := FControl.Text;
  if FPreset in [TRickUIBuilderEditPreset.IntegerNumber,
    TRickUIBuilderEditPreset.FloatNumber] then
    LResolved := ResolveNumericValue(LOriginal)
  else
    LResolved := ResolveTextValue(LOriginal);
  ApplyResolvedText(LOriginal, LResolved);
  FLastAcceptedText := FControl.Text;
  if Assigned(FPreviousChangeTracking) then
    FPreviousChangeTracking(ASender);
end;

procedure TRickUIBuilderEditDesignerInputConfig.RefreshTracking;
begin
  if Assigned(FControl.OnChangeTracking) then
    FControl.OnChangeTracking(nil);
end;

function TRickUIBuilderEditDesignerInputConfig.Preset(
  AValue: TRickUIBuilderEditPreset): IRickUIBuilderEditDesignerInputConfig;
begin
  FPreset := AValue;
  FLastAcceptedText := FControl.Text;
  if FPreset in [TRickUIBuilderEditPreset.IntegerNumber,
    TRickUIBuilderEditPreset.FloatNumber] then
    FParent.Number;
  Result := Self;
end;

function TRickUIBuilderEditDesignerInputConfig.CaseMode(
  AValue: TRickUIBuilderEditCaseMode): IRickUIBuilderEditDesignerInputConfig;
begin
  FCaseMode := AValue;
  FLastAcceptedText := FControl.Text;
  Result := Self;
end;

function TRickUIBuilderEditDesignerInputConfig.UrlCaseMode(
  AValue: TRickUIBuilderEditUrlCaseMode): IRickUIBuilderEditDesignerInputConfig;
begin
  FUrlCaseMode := AValue;
  FLastAcceptedText := FControl.Text;
  Result := Self;
end;

function TRickUIBuilderEditDesignerInputConfig.MaxLength(
  AValue: Integer): IRickUIBuilderEditDesignerInputConfig;
begin
  FControl.MaxLength := AValue;
  RefreshTracking;
  Result := Self;
end;

function TRickUIBuilderEditDesignerInputConfig.ToBack: IRickUIBuilderEditDesignerInput;
begin
  if not Assigned(FParent) then
    raise Exception.Create('O Parent da interface não foi informado para retornar.');
  Result := FParent;
end;

end.
