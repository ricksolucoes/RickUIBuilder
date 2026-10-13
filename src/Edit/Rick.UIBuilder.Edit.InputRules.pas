unit Rick.UIBuilder.Edit.InputRules;

{$SCOPEDENUMS ON}

interface

uses
  FMX.Edit,
  System.Classes,

  Rick.UIBuilder.Edit.Types;

type
  TRickUIBuilderEditInputRules = class(TEdit)
  private
    FPreset: TRickUIBuilderEditPreset;
    FCaseMode: TRickUIBuilderEditCaseMode;
    FUrlCaseMode: TRickUIBuilderEditUrlCaseMode;
    FAllowNegative: Boolean;
    FDecimalPlaces: Integer;
    FFormatMode: TRickUIBuilderEditNumberFormatMode;
    FDecimalSeparator: Char;
    FThousandSeparator: Char;
    FUseThousandSeparator: Boolean;
    FInputConfigured: Boolean;
    FApplyingText: Boolean;
    FPendingCaret: Integer;
    FCaretUpdateQueued: Boolean;
    FPendingGoToEnd: Boolean;
    procedure ApplyPendingCaret;
    procedure QueueCaretUpdate(ACaret: Integer; AGoToEnd: Boolean = False);
    function IsAppendingAtEnd(const AOldText, ANewText: string): Boolean;
    function ChangedCaretPosition(const AOldText, ANewText: string; AOldCaret: Integer): Integer;
    function FormattedCaretPosition(const AValue: string; ARawCaret: Integer): Integer;
    procedure ApplyResolvedText(const AValue, AResolved: string; ACaret: Integer; AAppendAtEnd: Boolean);
    function DecimalSeparatorValue: Char;
    function ThousandSeparatorValue: Char;
    function IsNumberChar(AChar: Char): Boolean;
    function ValidateNumberCharacters(const AValue: string; out ADecimalIndex: Integer): Boolean;
    function ValidateNumber(const AValue: string): Boolean;
    function IsIntegerAllowed(const AValue: string): Boolean;
    function IsEmailAtext(AChar: Char): Boolean;
    function IsEmailCharAllowed(AChar: Char; AIndex, AAtIndex: Integer): Boolean;
    function FindEmailSeparator(const AValue: string): Integer;
    function IsEmailAllowed(const AValue: string): Boolean;
    function IsCnpjBaseChar(AChar: Char): Boolean;
    function IsMaskSeparator(AChar: Char): Boolean;
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
  protected
    procedure SetText(const AValue: string); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure SetPreset(AValue: TRickUIBuilderEditPreset);
    procedure SetCaseMode(AValue: TRickUIBuilderEditCaseMode);
    procedure SetUrlCaseMode(AValue: TRickUIBuilderEditUrlCaseMode);
    procedure SetAllowNegative(AValue: Boolean);
    procedure SetDecimalPlaces(AValue: Integer);
    procedure SetFormatMode(AValue: TRickUIBuilderEditNumberFormatMode);
    procedure SetDecimalSeparator(AValue: Char);
    procedure SetThousandSeparator(AValue: Char);
    procedure SetUseThousandSeparator(AValue: Boolean);
  end;

implementation

uses
  System.Character,
  System.SysUtils;

constructor TRickUIBuilderEditInputRules.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPreset := TRickUIBuilderEditPreset.AllCharacters;
  FCaseMode := TRickUIBuilderEditCaseMode.Preserve;
  FUrlCaseMode := TRickUIBuilderEditUrlCaseMode.SchemeAndHost;
  FAllowNegative := False;
  FDecimalPlaces := 2;
  FFormatMode := TRickUIBuilderEditNumberFormatMode.Locale;
  FDecimalSeparator := #0;
  FThousandSeparator := #0;
  FUseThousandSeparator := False;
  FInputConfigured := False;
end;

procedure TRickUIBuilderEditInputRules.SetPreset(AValue: TRickUIBuilderEditPreset);
begin
  FPreset := AValue;
  FInputConfigured := True;
end;

procedure TRickUIBuilderEditInputRules.SetCaseMode(AValue: TRickUIBuilderEditCaseMode);
begin
  FCaseMode := AValue;
  FInputConfigured := True;
end;

procedure TRickUIBuilderEditInputRules.SetUrlCaseMode(AValue: TRickUIBuilderEditUrlCaseMode);
begin
  FUrlCaseMode := AValue;
  FInputConfigured := True;
end;

procedure TRickUIBuilderEditInputRules.SetAllowNegative(AValue: Boolean);
begin
  FAllowNegative := AValue;
  FInputConfigured := True;
end;

procedure TRickUIBuilderEditInputRules.SetDecimalPlaces(AValue: Integer);
begin
  FDecimalPlaces := AValue;
  FInputConfigured := True;
end;

procedure TRickUIBuilderEditInputRules.SetFormatMode(AValue: TRickUIBuilderEditNumberFormatMode);
begin
  FFormatMode := AValue;
  FInputConfigured := True;
end;

procedure TRickUIBuilderEditInputRules.SetDecimalSeparator(AValue: Char);
begin
  FDecimalSeparator := AValue;
  FInputConfigured := True;
end;

procedure TRickUIBuilderEditInputRules.SetThousandSeparator(AValue: Char);
begin
  FThousandSeparator := AValue;
  FInputConfigured := True;
end;

procedure TRickUIBuilderEditInputRules.SetUseThousandSeparator(AValue: Boolean);
begin
  FUseThousandSeparator := AValue;
  FInputConfigured := True;
end;

procedure TRickUIBuilderEditInputRules.ApplyPendingCaret;
begin
  FCaretUpdateQueued := False;
  if csDestroying in ComponentState then
    Exit;
  if FPendingGoToEnd then
  begin
    FPendingGoToEnd := False;
    GoToTextEnd;
    Exit;
  end;
  if FPendingCaret > Length(Text) then
    FPendingCaret := Length(Text);
  CaretPosition := FPendingCaret;
  SelLength := 0;
end;

procedure TRickUIBuilderEditInputRules.QueueCaretUpdate(ACaret: Integer; AGoToEnd: Boolean);
begin
  FPendingCaret := ACaret;
  FPendingGoToEnd := FPendingGoToEnd or AGoToEnd;
  if FCaretUpdateQueued then
    Exit;
  FCaretUpdateQueued := True;
  BeginInvoke(
    procedure
    begin
      ApplyPendingCaret;
    end, Self);
end;

function TRickUIBuilderEditInputRules.IsAppendingAtEnd(const AOldText, ANewText: string): Boolean;
begin
  Result := IsFocused and (SelLength = 0) and
    (CaretPosition = Length(AOldText)) and
    (Length(ANewText) > Length(AOldText)) and
    (Copy(ANewText, 1, Length(AOldText)) = AOldText);
end;

function TRickUIBuilderEditInputRules.ChangedCaretPosition(const AOldText, ANewText: string; AOldCaret: Integer): Integer;
var
  LPrefix: Integer;
  LSuffix: Integer;
begin
  if AOldText = ANewText then
    Exit(AOldCaret);
  LPrefix := 0;
  while (LPrefix < Length(AOldText)) and (LPrefix < Length(ANewText)) and
    (AOldText[LPrefix + 1] = ANewText[LPrefix + 1]) do
    Inc(LPrefix);
  LSuffix := 0;
  while (LSuffix < Length(AOldText) - LPrefix) and
    (LSuffix < Length(ANewText) - LPrefix) and
    (AOldText[Length(AOldText) - LSuffix] = ANewText[Length(ANewText) - LSuffix]) do
    Inc(LSuffix);
  Result := Length(ANewText) - LSuffix;
end;

function TRickUIBuilderEditInputRules.FormattedCaretPosition(const AValue: string; ARawCaret: Integer): Integer;
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

procedure TRickUIBuilderEditInputRules.ApplyResolvedText(const AValue, AResolved: string; ACaret: Integer; AAppendAtEnd: Boolean);
begin
  FApplyingText := True;
  try
    inherited SetText(AResolved);
    ACaret := FormattedCaretPosition(AValue, ACaret);
    if AAppendAtEnd then
      GoToTextEnd
    else
      CaretPosition := ACaret;
    SelLength := 0;
    QueueCaretUpdate(ACaret, AAppendAtEnd);
  finally
    FApplyingText := False;
  end;
end;

function TRickUIBuilderEditInputRules.DecimalSeparatorValue: Char;
begin
  if FFormatMode = TRickUIBuilderEditNumberFormatMode.Locale then
    Exit(FormatSettings.DecimalSeparator);
  Result := FDecimalSeparator;
end;

function TRickUIBuilderEditInputRules.ThousandSeparatorValue: Char;
begin
  if FFormatMode = TRickUIBuilderEditNumberFormatMode.Locale then
    Exit(FormatSettings.ThousandSeparator);
  Result := FThousandSeparator;
end;

function TRickUIBuilderEditInputRules.IsNumberChar(AChar: Char): Boolean;
var
  LDecimal: Char;
  LThousand: Char;
begin
  LDecimal := DecimalSeparatorValue;
  LThousand := ThousandSeparatorValue;
  Result := CharInSet(AChar, ['0'..'9']);
  Result := Result or (FAllowNegative and (AChar = '-'));
  Result := Result or (AChar = LDecimal);
  Result := Result or (FUseThousandSeparator and (AChar = LThousand));
end;

function TRickUIBuilderEditInputRules.ValidateNumberCharacters(const AValue: string; out ADecimalIndex: Integer): Boolean;
var
  LIndex: Integer;
  LDecimal: Char;
begin
  ADecimalIndex := 0;
  LDecimal := DecimalSeparatorValue;
  for LIndex := 1 to Length(AValue) do
  begin
    if not IsNumberChar(AValue[LIndex]) then
      Exit(False);
    if (AValue[LIndex] = '-') and (LIndex <> 1) then
      Exit(False);
    if (AValue[LIndex] = LDecimal) and (ADecimalIndex > 0) then
      Exit(False);
    if AValue[LIndex] = LDecimal then
      ADecimalIndex := LIndex;
  end;
  Result := True;
end;

function TRickUIBuilderEditInputRules.ValidateNumber(const AValue: string): Boolean;
var
  LDecimalIndex: Integer;
begin
  if not ValidateNumberCharacters(AValue, LDecimalIndex) then
    Exit(False);
  if (LDecimalIndex = 0) or (FDecimalPlaces < 0) then
    Exit(True);
  Result := Length(AValue) - LDecimalIndex <= FDecimalPlaces;
end;

function TRickUIBuilderEditInputRules.IsIntegerAllowed(const AValue: string): Boolean;
var
  LIndex: Integer;
begin
  Result := True;
  for LIndex := 1 to Length(AValue) do
    if not (CharInSet(AValue[LIndex], ['0'..'9']) or
      (FAllowNegative and (AValue[LIndex] = '-') and (LIndex = 1))) then
      Exit(False);
end;

function TRickUIBuilderEditInputRules.IsEmailAtext(AChar: Char): Boolean;
begin
  Result := AChar.IsLetterOrDigit or CharInSet(AChar, ['_', '+', '-']);
end;

function TRickUIBuilderEditInputRules.IsEmailCharAllowed(AChar: Char; AIndex, AAtIndex: Integer): Boolean;
begin
  if AChar = '@' then
    Exit(True);
  if (AAtIndex = 0) or (AIndex < AAtIndex) then
    Exit(IsEmailAtext(AChar) or (AChar = '.'));
  Result := AChar.IsLetterOrDigit or CharInSet(AChar, ['-', '.']);
end;

function TRickUIBuilderEditInputRules.FindEmailSeparator(const AValue: string): Integer;
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

function TRickUIBuilderEditInputRules.IsEmailAllowed(const AValue: string): Boolean;
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

function TRickUIBuilderEditInputRules.IsCnpjBaseChar(AChar: Char): Boolean;
begin
  Result := CharInSet(AChar, ['0'..'9', 'A'..'Z', 'a'..'z']);
end;

function TRickUIBuilderEditInputRules.IsMaskSeparator(AChar: Char): Boolean;
begin
  case FPreset of
    TRickUIBuilderEditPreset.CPF: Result := CharInSet(AChar, ['.', '-']);
    TRickUIBuilderEditPreset.CNPJ: Result := CharInSet(AChar, ['.', '/', '-']);
    TRickUIBuilderEditPreset.CEP: Result := AChar = '-';
    TRickUIBuilderEditPreset.Phone, TRickUIBuilderEditPreset.Mobile: Result := CharInSet(AChar, ['(', ')', ' ', '-']);
  else
    Result := False;
  end;
end;

function TRickUIBuilderEditInputRules.IsMaskedTypingAllowed(const AValue: string): Boolean;
var
  LAlphaIndex: Integer;
  LChar: Char;
begin
  LAlphaIndex := 0;
  for LChar in AValue do
  begin
    if IsCnpjBaseChar(LChar) then
      Inc(LAlphaIndex)
    else if not IsMaskSeparator(LChar) then
      Exit(False);
    if (FPreset <> TRickUIBuilderEditPreset.CNPJ) and CharInSet(LChar, ['A'..'Z', 'a'..'z']) then
      Exit(False);
    if (FPreset = TRickUIBuilderEditPreset.CNPJ) and (LAlphaIndex > 12) and CharInSet(LChar, ['A'..'Z', 'a'..'z']) then
      Exit(False);
  end;
  Result := True;
end;

function TRickUIBuilderEditInputRules.IsTypedValueAllowed(const AValue: string): Boolean;
begin
  if FPreset in [TRickUIBuilderEditPreset.CPF, TRickUIBuilderEditPreset.CNPJ,
    TRickUIBuilderEditPreset.CEP, TRickUIBuilderEditPreset.Phone,
    TRickUIBuilderEditPreset.Mobile] then
    Exit(IsMaskedTypingAllowed(AValue));
  case FPreset of
    TRickUIBuilderEditPreset.IntegerNumber: Result := IsIntegerAllowed(AValue);
    TRickUIBuilderEditPreset.FloatNumber: Result := ValidateNumber(AValue);
    TRickUIBuilderEditPreset.Email: Result := IsEmailAllowed(AValue);
  else
    Result := True;
  end;
end;

function TRickUIBuilderEditInputRules.OnlyDigits(const AValue: string): string;
var
  LChar: Char;
begin
  Result := EmptyStr;
  for LChar in AValue do
    if CharInSet(LChar, ['0'..'9']) then
      Result := Result + LChar;
end;

function TRickUIBuilderEditInputRules.OnlyAlphaNumeric(const AValue: string): string;
var
  LChar: Char;
begin
  Result := EmptyStr;
  for LChar in AValue do
    if IsCnpjBaseChar(LChar) then
      Result := Result + UpCase(LChar);
end;

function TRickUIBuilderEditInputRules.ApplyPattern(const ARaw, APattern: string): string;
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

function TRickUIBuilderEditInputRules.FormatPhone(const AValue: string; AMobile: Boolean): string;
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

function TRickUIBuilderEditInputRules.FormatMaskedValue(const AValue: string): string;
var
  LRaw: string;
begin
  case FPreset of
    TRickUIBuilderEditPreset.CPF: Result := ApplyPattern(OnlyDigits(AValue), '000.000.000-00');
    TRickUIBuilderEditPreset.CNPJ:
      begin
        LRaw := OnlyAlphaNumeric(AValue);
        if Length(LRaw) > 12 then
          LRaw := Copy(LRaw, 1, 12) + OnlyDigits(Copy(LRaw, 13, 2));
        Result := ApplyPattern(LRaw, '00.000.000/0000-00');
      end;
    TRickUIBuilderEditPreset.CEP: Result := ApplyPattern(OnlyDigits(AValue), '00000-000');
    TRickUIBuilderEditPreset.Phone: Result := FormatPhone(AValue, False);
    TRickUIBuilderEditPreset.Mobile: Result := FormatPhone(AValue, True);
  else
    Result := AValue;
  end;
end;

function TRickUIBuilderEditInputRules.ApplyCase(const AValue: string): string;
begin
  case FCaseMode of
    TRickUIBuilderEditCaseMode.Uppercase: Result := UpperCase(AValue);
    TRickUIBuilderEditCaseMode.Lowercase: Result := LowerCase(AValue);
  else
    Result := AValue;
  end;
end;

function TRickUIBuilderEditInputRules.FindUrlBoundary(const AValue: string): Integer;
var
  LScheme: Integer;
begin
  LScheme := Pos('://', AValue);
  Result := Pos('/', AValue);
  if (LScheme > 0) and (Result = LScheme + 1) then
    Result := Pos('/', Copy(AValue, LScheme + 3, MaxInt));
  if (LScheme > 0) and (Result > 0) then
    Inc(Result, LScheme + 2);
  if Result = 0 then
    Result := Pos('?', AValue);
  if Result = 0 then
    Result := Pos('#', AValue);
end;

function TRickUIBuilderEditInputRules.ApplyUrlCase(const AValue: string): string;
var
  LBoundary: Integer;
begin
  if FUrlCaseMode = TRickUIBuilderEditUrlCaseMode.EntireValue then
    Exit(LowerCase(AValue));
  LBoundary := FindUrlBoundary(AValue);
  if LBoundary = 0 then
    Exit(LowerCase(AValue));
  Result := LowerCase(Copy(AValue, 1, LBoundary - 1)) + Copy(AValue, LBoundary, MaxInt);
end;

function TRickUIBuilderEditInputRules.FormatTypedValue(const AValue: string): string;
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

procedure TRickUIBuilderEditInputRules.SetText(const AValue: string);
var
  LAppendAtEnd: Boolean;
  LCaret: Integer;
  LOldText: string;
  LResolved: string;
begin
  if FApplyingText or not FInputConfigured then
  begin
    inherited SetText(AValue);
    Exit;
  end;
  if not IsTypedValueAllowed(AValue) then
    Exit;
  LOldText := Text;
  LAppendAtEnd := IsAppendingAtEnd(LOldText, AValue);
  LCaret := ChangedCaretPosition(LOldText, AValue, CaretPosition);
  LResolved := FormatTypedValue(AValue);
  ApplyResolvedText(AValue, LResolved, LCaret, LAppendAtEnd);
end;

end.
