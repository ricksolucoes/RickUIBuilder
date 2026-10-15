unit Rick.UIBuilder.Edit.Designer.Input.Config;

{$SCOPEDENUMS ON}

interface

uses
  FMX.Edit,
  FMX.Text,
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
    FPreviousValidating: TValidateTextEvent;
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
    function IsEmailLocalBoundaryValid(const AValue: string): Boolean;
    function IsEmailLocalPart(const AValue: string): Boolean;
    function IsHostLabelBoundaryValid(const AValue: string): Boolean;
    function IsHostLabel(const AValue: string): Boolean;
    function IsEmailDomain(const AValue: string): Boolean;
    function IsEmailComplete(const AValue: string): Boolean;
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
    function IsPortValid(const AValue: string): Boolean;
    function IsIPv4PartValid(const AValue: string): Boolean;
    function IsIPv4Valid(const AValue: string): Boolean;
    function IsIPv6Group(const AValue: string): Boolean;
    function HasMultipleDoubleColon(const AValue: string): Boolean;
    function CountIPv6Groups(const AValue: string): Integer;
    function IsIPv6Valid(const AValue: string): Boolean;
    function IsDomainHostValid(const AValue: string): Boolean;
    function IsUrlHostValid(const AValue: string): Boolean;
    function IsBracketedAuthorityValid(const AValue: string): Boolean;
    function IsHostPortAuthorityValid(const AValue: string): Boolean;
    function IsUrlAuthorityValid(const AValue: string): Boolean;
    function StripUrlScheme(var AValue: string): Boolean;
    function EarlierBoundary(AExisting, ACandidate: Integer): Integer;
    function FindAuthorityBoundary(const AValue: string): Integer;
    function IsUrlComplete(const AValue: string): Boolean;
    function HasCompleteMask(const AValue: string): Boolean;
    function IsCompleteValue(const AValue: string): Boolean;
    function FormatTypedValue(const AValue: string): string;
    function ResolveNumericValue(const AValue: string): string;
    function ResolveTextValue(const AValue: string): string;
    procedure HandleChangeTracking(ASender: TObject);
    procedure HandleValidating(ASender: TObject; var AText: string);
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
  System.StrUtils,
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
  FPreviousValidating := FControl.OnValidating;
  FControl.OnChangeTracking := HandleChangeTracking;
  FControl.OnValidating := HandleValidating;
end;

destructor TRickUIBuilderEditDesignerInputConfig.Destroy;
begin
  if Assigned(FControl) and not (csDestroying in FControl.ComponentState) then
  begin
    FControl.OnChangeTracking := FPreviousChangeTracking;
    FControl.OnValidating := FPreviousValidating;
  end;
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

function TRickUIBuilderEditDesignerInputConfig.IsEmailLocalBoundaryValid(
  const AValue: string): Boolean;
begin
  if AValue.IsEmpty then
    Exit(False);
  if AValue[1] = '.' then
    Exit(False);
  if AValue[Length(AValue)] = '.' then
    Exit(False);
  Result := Pos('..', AValue) = 0;
end;

function TRickUIBuilderEditDesignerInputConfig.IsEmailLocalPart(
  const AValue: string): Boolean;
var
  LChar: Char;
begin
  if not IsEmailLocalBoundaryValid(AValue) then
    Exit(False);
  for LChar in AValue do
    if not (IsEmailAtext(LChar) or (LChar = '.')) then
      Exit(False);
  Result := True;
end;

function TRickUIBuilderEditDesignerInputConfig.IsHostLabelBoundaryValid(
  const AValue: string): Boolean;
begin
  if AValue.IsEmpty then
    Exit(False);
  if Length(AValue) > 63 then
    Exit(False);
  if AValue[1] = '-' then
    Exit(False);
  Result := AValue[Length(AValue)] <> '-';
end;

function TRickUIBuilderEditDesignerInputConfig.IsHostLabel(
  const AValue: string): Boolean;
var
  LChar: Char;
begin
  if not IsHostLabelBoundaryValid(AValue) then
    Exit(False);
  for LChar in AValue do
    if not (LChar.IsLetterOrDigit or (LChar = '-')) then
      Exit(False);
  Result := True;
end;

function TRickUIBuilderEditDesignerInputConfig.IsEmailDomain(
  const AValue: string): Boolean;
var
  LLabel: string;
  LLabels: TArray<string>;
begin
  if AValue.IsEmpty then
    Exit(False);
  LLabels := AValue.Split(['.']);
  for LLabel in LLabels do
    if not IsHostLabel(LLabel) then
      Exit(False);
  Result := True;
end;

function TRickUIBuilderEditDesignerInputConfig.IsEmailComplete(
  const AValue: string): Boolean;
var
  LAtIndex: Integer;
  LDomain: string;
  LLocal: string;
begin
  LAtIndex := FindEmailSeparator(AValue);
  if LAtIndex <= 1 then
    Exit(False);
  LLocal := Copy(AValue, 1, LAtIndex - 1);
  LDomain := Copy(AValue, LAtIndex + 1, MaxInt);
  if TEncoding.UTF8.GetByteCount(LLocal) > 64 then
    Exit(False);
  if TEncoding.UTF8.GetByteCount(AValue) > 254 then
    Exit(False);
  Result := IsEmailLocalPart(LLocal) and IsEmailDomain(LDomain);
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

function TRickUIBuilderEditDesignerInputConfig.IsPortValid(
  const AValue: string): Boolean;
var
  LChar: Char;
  LPort: Integer;
begin
  if AValue.Trim.IsEmpty then
    Exit(False);
  for LChar in AValue do
    if not LChar.IsDigit then
      Exit(False);
  Result := TryStrToInt(AValue, LPort) and (LPort >= 0) and (LPort <= 65535);
end;

function TRickUIBuilderEditDesignerInputConfig.IsIPv4PartValid(
  const AValue: string): Boolean;
var
  LValue: Integer;
begin
  if AValue.Trim.IsEmpty then
    Exit(False);
  if Length(AValue) > 3 then
    Exit(False);
  if not TryStrToInt(AValue, LValue) then
    Exit(False);
  if LValue < 0 then
    Exit(False);
  Result := LValue <= 255;
end;

function TRickUIBuilderEditDesignerInputConfig.IsIPv4Valid(
  const AValue: string): Boolean;
var
  LPart: string;
  LParts: TArray<string>;
begin
  LParts := AValue.Split(['.']);
  if Length(LParts) <> 4 then
    Exit(False);
  for LPart in LParts do
    if not IsIPv4PartValid(LPart) then
      Exit(False);
  Result := True;
end;

function TRickUIBuilderEditDesignerInputConfig.IsIPv6Group(
  const AValue: string): Boolean;
var
  LChar: Char;
begin
  if AValue.IsEmpty or (Length(AValue) > 4) then
    Exit(False);
  for LChar in AValue do
    if not CharInSet(LChar, ['0'..'9', 'a'..'f', 'A'..'F']) then
      Exit(False);
  Result := True;
end;

function TRickUIBuilderEditDesignerInputConfig.HasMultipleDoubleColon(
  const AValue: string): Boolean;
var
  LFirst: Integer;
begin
  LFirst := Pos('::', AValue);
  if LFirst = 0 then
    Exit(False);
  Result := Pos('::', Copy(AValue, LFirst + 2, MaxInt)) > 0;
end;

function TRickUIBuilderEditDesignerInputConfig.CountIPv6Groups(
  const AValue: string): Integer;
var
  LPart: string;
  LParts: TArray<string>;
begin
  Result := 0;
  LParts := AValue.Split([':']);
  for LPart in LParts do
    if not LPart.IsEmpty then
    begin
      if not IsIPv6Group(LPart) then
        Exit(-1);
      Inc(Result);
    end;
end;

function TRickUIBuilderEditDesignerInputConfig.IsIPv6Valid(
  const AValue: string): Boolean;
var
  LCount: Integer;
  LHasCompression: Boolean;
begin
  if AValue.Trim.IsEmpty or HasMultipleDoubleColon(AValue) then
    Exit(False);
  LCount := CountIPv6Groups(AValue);
  if LCount < 0 then
    Exit(False);
  LHasCompression := Pos('::', AValue) > 0;
  if LHasCompression then
    Exit(LCount < 8);
  Result := LCount = 8;
end;

function TRickUIBuilderEditDesignerInputConfig.IsDomainHostValid(
  const AValue: string): Boolean;
var
  LLabel: string;
  LLabels: TArray<string>;
begin
  if AValue.Trim.IsEmpty then
    Exit(False);
  if SameText(AValue, 'localhost') then
    Exit(True);
  LLabels := AValue.Split(['.']);
  if Length(LLabels) < 2 then
    Exit(False);
  for LLabel in LLabels do
    if not IsHostLabel(LLabel) then
      Exit(False);
  Result := True;
end;

function TRickUIBuilderEditDesignerInputConfig.IsUrlHostValid(
  const AValue: string): Boolean;
begin
  if AValue.Trim.IsEmpty then
    Exit(False);
  if IsIPv4Valid(AValue) then
    Exit(True);
  if (Pos('.', AValue) > 0) and AValue[1].IsDigit then
    Exit(False);
  Result := IsDomainHostValid(AValue);
end;

function TRickUIBuilderEditDesignerInputConfig.IsBracketedAuthorityValid(
  const AValue: string): Boolean;
var
  LCloseBracket: Integer;
  LPort: string;
begin
  LCloseBracket := Pos(']', AValue);
  if LCloseBracket = 0 then
    Exit(False);
  if not IsIPv6Valid(Copy(AValue, 2, LCloseBracket - 2)) then
    Exit(False);
  LPort := Copy(AValue, LCloseBracket + 1, MaxInt);
  if LPort.IsEmpty then
    Exit(True);
  if LPort[1] <> ':' then
    Exit(False);
  Result := IsPortValid(Copy(LPort, 2, MaxInt));
end;

function TRickUIBuilderEditDesignerInputConfig.IsHostPortAuthorityValid(
  const AValue: string): Boolean;
var
  LColon: Integer;
  LHost: string;
  LPort: string;
begin
  LColon := LastDelimiter(':', AValue);
  if LColon = 0 then
    Exit(IsUrlHostValid(AValue));
  LHost := Copy(AValue, 1, LColon - 1);
  if Pos(':', LHost) > 0 then
    Exit(False);
  LPort := Copy(AValue, LColon + 1, MaxInt);
  Result := IsUrlHostValid(LHost) and IsPortValid(LPort);
end;

function TRickUIBuilderEditDesignerInputConfig.IsUrlAuthorityValid(
  const AValue: string): Boolean;
begin
  if AValue.Trim.IsEmpty or (Pos('@', AValue) > 0) then
    Exit(False);
  if AValue[1] = '[' then
    Exit(IsBracketedAuthorityValid(AValue));
  Result := IsHostPortAuthorityValid(AValue);
end;

function TRickUIBuilderEditDesignerInputConfig.StripUrlScheme(
  var AValue: string): Boolean;
begin
  Result := True;
  if Pos('://', AValue) = 0 then
    Exit;
  if StartsText('https://', AValue) then
    Delete(AValue, 1, Length('https://'))
  else if StartsText('http://', AValue) then
    Delete(AValue, 1, Length('http://'))
  else
    Result := False;
end;

function TRickUIBuilderEditDesignerInputConfig.EarlierBoundary(
  AExisting, ACandidate: Integer): Integer;
begin
  Result := AExisting;
  if ACandidate = 0 then
    Exit;
  if ACandidate < AExisting then
    Result := ACandidate;
end;

function TRickUIBuilderEditDesignerInputConfig.FindAuthorityBoundary(
  const AValue: string): Integer;
begin
  Result := Length(AValue) + 1;
  Result := EarlierBoundary(Result, Pos('/', AValue));
  Result := EarlierBoundary(Result, Pos('?', AValue));
  Result := EarlierBoundary(Result, Pos('#', AValue));
end;

function TRickUIBuilderEditDesignerInputConfig.IsUrlComplete(
  const AValue: string): Boolean;
var
  LAuthority: string;
  LValue: string;
begin
  LValue := AValue;
  if LValue.Trim.IsEmpty or (LValue <> LValue.Trim) then
    Exit(False);
  if not StripUrlScheme(LValue) then
    Exit(False);
  LAuthority := Copy(LValue, 1, FindAuthorityBoundary(LValue) - 1);
  Result := IsUrlAuthorityValid(LAuthority);
end;

function TRickUIBuilderEditDesignerInputConfig.HasCompleteMask(
  const AValue: string): Boolean;
begin
  case FPreset of
    TRickUIBuilderEditPreset.CPF: Result := Length(AValue) = 14;
    TRickUIBuilderEditPreset.CNPJ: Result := Length(AValue) = 18;
    TRickUIBuilderEditPreset.CEP: Result := Length(AValue) = 9;
    TRickUIBuilderEditPreset.Phone: Result := Length(AValue) in [9, 14];
    TRickUIBuilderEditPreset.Mobile: Result := Length(AValue) in [11, 16];
  else
    Result := True;
  end;
end;

function TRickUIBuilderEditDesignerInputConfig.IsCompleteValue(
  const AValue: string): Boolean;
var
  LFormatted: string;
begin
  if FPreset in [TRickUIBuilderEditPreset.CPF, TRickUIBuilderEditPreset.CNPJ,
    TRickUIBuilderEditPreset.CEP, TRickUIBuilderEditPreset.Phone,
    TRickUIBuilderEditPreset.Mobile] then
  begin
    LFormatted := FormatTypedValue(AValue);
    Exit((AValue = LFormatted) and HasCompleteMask(LFormatted));
  end;
  if FPreset = TRickUIBuilderEditPreset.Email then
    Exit(IsEmailComplete(AValue));
  if FPreset = TRickUIBuilderEditPreset.URL then
    Exit(IsUrlComplete(AValue));
  Result := True;
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

procedure TRickUIBuilderEditDesignerInputConfig.HandleValidating(
  ASender: TObject; var AText: string);
begin
  if ASender = FControl.Owner then
  begin
    if not IsCompleteValue(AText) then
      AText := EmptyStr;
    Exit;
  end;
  if Assigned(FPreviousValidating) then
    FPreviousValidating(ASender, AText);
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
