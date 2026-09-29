unit Rick.UIBuilder.Edit.Input;
{$SCOPEDENUMS ON}

interface

uses
  System.SysUtils,
  System.Character,
  Rick.UIBuilder.Types;

type
  TRickUIBuilderEditInput = class sealed
  strict private
    class function IsBasicLetter(AChar: Char): Boolean; static;
    class function IsPunctuation(AChar: Char): Boolean; static;
    class function IsTextChar(AChar: Char; AAccents,
      APunctuation: Boolean): Boolean; static;
    class function IsCnpjBaseChar(AChar: Char): Boolean; static;
    class function OnlyDigits(const AValue: string): string; static;
    class function OnlyAlphaNumeric(const AValue: string): string; static;
    class function ApplyPattern(const ARaw, APattern: string): string; static;
    class function FormatPhone(const ARaw: string; AMobile: Boolean): string; static;
    class function DecimalSeparator(const AConfig: TRickUIBuilderEditConfig): Char; static;
    class function ThousandSeparator(const AConfig: TRickUIBuilderEditConfig): Char; static;
    class function IsNumberChar(AChar: Char; const AConfig: TRickUIBuilderEditConfig): Boolean; static;
    class function ValidateNumber(const AValue: string;
      const AConfig: TRickUIBuilderEditConfig): Boolean; static;
    class function ValidateNumberCharacters(const AValue: string;
      const AConfig: TRickUIBuilderEditConfig; out ADecimalIndex: Integer): Boolean; static;
    class function FindUrlBoundary(const AValue: string): Integer; static;
    class function ApplyCase(const AValue: string;
      AMode: TRickUIBuilderEditCaseMode): string; static;
    class function ApplyUrlCase(const AValue: string;
      AMode: TRickUIBuilderEditUrlCaseMode): string; static;

    class function FormatCPF(const AValue: string;
      const AConfig: TRickUIBuilderEditConfig): string; static;
    class function FormatCEP(const AValue: string;
      const AConfig: TRickUIBuilderEditConfig): string; static;
    class function FormatPhoneFixed(const AValue: string;
      const AConfig: TRickUIBuilderEditConfig): string; static;
    class function FormatPhoneMobile(const AValue: string;
      const AConfig: TRickUIBuilderEditConfig): string; static;
    class function FormatCNPJ(const AValue: string;
      const AConfig: TRickUIBuilderEditConfig): string; static;

    class function FormatMaskedValue(const AValue: string;
      const AConfig: TRickUIBuilderEditConfig): string; static;
    class function IsIntegerAllowed(const AValue: string;
      const AConfig: TRickUIBuilderEditConfig): Boolean; static;
    class function IsTextAllowed(const AValue: string;
      const AConfig: TRickUIBuilderEditConfig): Boolean; static;
    class function IsEmailAtext(AChar: Char): Boolean; static;
    class function IsEmailAllowed(const AValue: string): Boolean; static;
    class function IsEmailComplete(const AValue: string): Boolean; static;
    class function IsEmailLocalPart(const AValue: string): Boolean; static;
    class function IsEmailDomain(const AValue: string): Boolean; static;
    class function FindEmailSeparator(const AValue: string): Integer; static;
    class function IsUrlComplete(const AValue: string): Boolean; static;
    class function IsUrlAuthorityValid(const AValue: string): Boolean; static;
    class function IsUrlHostValid(const AValue: string): Boolean; static;
    class function IsDomainHostValid(const AValue: string): Boolean; static;
    class function IsIPv4Valid(const AValue: string): Boolean; static;
    class function IsIPv6Valid(const AValue: string): Boolean; static;
    class function IsPortValid(const AValue: string): Boolean; static;
    class function HasCompleteMask(const AValue: string;
      APreset: TRickUIBuilderEditPreset): Boolean; static;
    class function IsMaskedTypingAllowed(const AValue: string;
      APreset: TRickUIBuilderEditPreset): Boolean; static;
    class function IsMaskSeparator(AChar: Char;
      APreset: TRickUIBuilderEditPreset): Boolean; static;
  public
    class function FormatTypedValue(const AValue: string;
      const AConfig: TRickUIBuilderEditConfig): string; static;
    class function IsValueAllowed(const AValue: string;
      const AConfig: TRickUIBuilderEditConfig): Boolean; static;
    class function IsTypedValueAllowed(const AValue: string;
      const AConfig: TRickUIBuilderEditConfig): Boolean; static;
    class function IsPasteAllowed(const AValue: string;
      const AConfig: TRickUIBuilderEditConfig): Boolean; static;
    class function IsCompleteValue(const AValue: string;
      const AConfig: TRickUIBuilderEditConfig): Boolean; static;
  end;

implementation

uses
  System.StrUtils;

class function TRickUIBuilderEditInput.IsBasicLetter(AChar: Char): Boolean;
begin
  Result := ((AChar >= 'A') and (AChar <= 'Z')) or
    ((AChar >= 'a') and (AChar <= 'z'));
end;

class function TRickUIBuilderEditInput.IsPunctuation(AChar: Char): Boolean;
const
  CAscii = '.,;:!?-()[]{}"''`/\|_+=<>*' +
    '@#$%&~^';
  CUnicode = '—«»’§°ºª';
begin
  Result := (Pos(AChar, CAscii) > 0) or (Pos(AChar, CUnicode) > 0);
end;

class function TRickUIBuilderEditInput.IsTextChar(AChar: Char; AAccents,
  APunctuation: Boolean): Boolean;
begin
  Result := (AChar = ' ') or IsBasicLetter(AChar);

  if AAccents then
    Result := Result or AChar.IsLetter;

  if APunctuation then
    Result := Result or IsPunctuation(AChar);
end;

class function TRickUIBuilderEditInput.IsCnpjBaseChar(AChar: Char): Boolean;
begin
  Result := ((AChar >= '0') and (AChar <= '9')) or
    ((AChar >= 'A') and (AChar <= 'Z')) or
    ((AChar >= 'a') and (AChar <= 'z'));
end;

class function TRickUIBuilderEditInput.OnlyDigits(const AValue: string): string;
var
  LChar: Char;
begin
  Result := '';
  for LChar in AValue do
    if CharInSet(LChar, ['0'..'9']) then
      Result := Result + LChar;
end;

class function TRickUIBuilderEditInput.OnlyAlphaNumeric(
  const AValue: string): string;
var
  LChar: Char;
begin
  Result := '';
  for LChar in AValue do
    if IsCnpjBaseChar(LChar) then
      Result := Result + UpCase(LChar);
end;

class function TRickUIBuilderEditInput.ApplyPattern(const ARaw,
  APattern: string): string;
var
  I: Integer;
  LRawIndex: Integer;
begin
  Result := '';
  LRawIndex := 1;
  for I := 1 to Length(APattern) do
  begin
    if LRawIndex > Length(ARaw) then
      Break;
    if APattern[I] = '0' then
    begin
      Result := Result + ARaw[LRawIndex];
      Inc(LRawIndex);
    end
    else
      Result := Result + APattern[I];
  end;
end;

class function TRickUIBuilderEditInput.FormatPhone(const ARaw: string;
  AMobile: Boolean): string;
var
  LDigits: string;
  LPattern: string;
begin
  LDigits := OnlyDigits(ARaw);
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

class function TRickUIBuilderEditInput.DecimalSeparator(
  const AConfig: TRickUIBuilderEditConfig): Char;
begin
  if AConfig.NumberFormatMode = TRickUIBuilderEditNumberFormatMode.Locale then
    Exit(FormatSettings.DecimalSeparator);
  Result := AConfig.DecimalSeparator;
end;

class function TRickUIBuilderEditInput.ThousandSeparator(
  const AConfig: TRickUIBuilderEditConfig): Char;
begin
  if AConfig.NumberFormatMode = TRickUIBuilderEditNumberFormatMode.Locale then
    Exit(FormatSettings.ThousandSeparator);
  Result := AConfig.ThousandSeparator;
end;

class function TRickUIBuilderEditInput.IsNumberChar(AChar: Char;
  const AConfig: TRickUIBuilderEditConfig): Boolean;
var
  LDecimal: Char;
  LThousand: Char;
begin
  LDecimal := DecimalSeparator(AConfig);
  LThousand := ThousandSeparator(AConfig);
  Result := CharInSet(AChar, ['0'..'9']);
  Result := Result or (AConfig.AllowNegative and (AChar = '-'));
  Result := Result or (AChar = LDecimal);
  Result := Result or (AConfig.UseThousandSeparator and (AChar = LThousand));
end;

class function TRickUIBuilderEditInput.ValidateNumberCharacters(
  const AValue: string; const AConfig: TRickUIBuilderEditConfig;
  out ADecimalIndex: Integer): Boolean;
var
  I: Integer;
  LDecimal: Char;
begin
  ADecimalIndex := 0;
  LDecimal := DecimalSeparator(AConfig);
  for I := 1 to Length(AValue) do
  begin
    if not IsNumberChar(AValue[I], AConfig) then
      Exit(False);
    if (AValue[I] = '-') and (I <> 1) then
      Exit(False);
    if (AValue[I] = LDecimal) and (ADecimalIndex > 0) then
      Exit(False);
    if AValue[I] = LDecimal then
      ADecimalIndex := I;
  end;
  Result := True;
end;

class function TRickUIBuilderEditInput.ValidateNumber(const AValue: string;
  const AConfig: TRickUIBuilderEditConfig): Boolean;
var
  LDecimalIndex: Integer;
begin
  if not ValidateNumberCharacters(AValue, AConfig, LDecimalIndex) then
    Exit(False);
  if (LDecimalIndex = 0) or (AConfig.DecimalPlaces < 0) then
    Exit(True);
  Result := Length(AValue) - LDecimalIndex <= AConfig.DecimalPlaces;
end;

class function TRickUIBuilderEditInput.ApplyCase(const AValue: string;
  AMode: TRickUIBuilderEditCaseMode): string;
begin
  case AMode of
    TRickUIBuilderEditCaseMode.Uppercase: Result := UpperCase(AValue);
    TRickUIBuilderEditCaseMode.Lowercase: Result := LowerCase(AValue);
  else
    Result := AValue;
  end;
end;

class function TRickUIBuilderEditInput.FindUrlBoundary(
  const AValue: string): Integer;
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

class function TRickUIBuilderEditInput.ApplyUrlCase(const AValue: string;
  AMode: TRickUIBuilderEditUrlCaseMode): string;
var
  LBoundary: Integer;
begin
  if AMode = TRickUIBuilderEditUrlCaseMode.EntireValue then
    Exit(LowerCase(AValue));
  LBoundary := FindUrlBoundary(AValue);
  if LBoundary = 0 then
    Exit(LowerCase(AValue));
  Result := LowerCase(Copy(AValue, 1, LBoundary - 1)) +
    Copy(AValue, LBoundary, MaxInt);
end;

class function TRickUIBuilderEditInput.FormatCPF(const AValue: string;
  const AConfig: TRickUIBuilderEditConfig): string;
begin
  Result := ApplyPattern(OnlyDigits(AValue), '000.000.000-00');
end;

class function TRickUIBuilderEditInput.FormatCEP(const AValue: string;
  const AConfig: TRickUIBuilderEditConfig): string;
begin
  Result := ApplyPattern(OnlyDigits(AValue), '00000-000');
end;

class function TRickUIBuilderEditInput.FormatPhoneFixed(const AValue: string;
  const AConfig: TRickUIBuilderEditConfig): string;
begin
  Result := FormatPhone(AValue, False);
end;

class function TRickUIBuilderEditInput.FormatPhoneMobile(const AValue: string;
  const AConfig: TRickUIBuilderEditConfig): string;
begin
  Result := FormatPhone(AValue, True);
end;

class function TRickUIBuilderEditInput.FormatCNPJ(const AValue: string;
  const AConfig: TRickUIBuilderEditConfig): string;
var
  LRaw: string;
begin
  LRaw := OnlyAlphaNumeric(AValue);
  if Length(LRaw) > 12 then
    LRaw := Copy(LRaw, 1, 12) + OnlyDigits(Copy(LRaw, 13, 2));
  Result := ApplyPattern(LRaw, '00.000.000/0000-00');
end;

class function TRickUIBuilderEditInput.FormatMaskedValue(const AValue: string;
  const AConfig: TRickUIBuilderEditConfig): string;
const
  _MAP: array[TRickUIBuilderEditPreset] of TRickUIBuilderEditFormatterFunc = (
    nil,                  // AllCharacters
    FormatCPF,            // CPF
    FormatCNPJ,           // CNPJ
    FormatCEP,            // CEP
    nil,                  // Email
    nil,                  // URL
    FormatPhoneFixed,     // Phone
    FormatPhoneMobile,    // Mobile
    nil,                  // IntegerNumber
    nil,                  // FloatNumber
    nil,                  // TextNoAccents
    nil,                  // TextPunctuationNoAccents
    nil,                  // TextWithAccents
    nil                   // TextPunctuationWithAccents
  );
var
  LFormatter: TRickUIBuilderEditFormatterFunc;
begin
  LFormatter := _MAP[AConfig.Preset];
  if not Assigned(LFormatter) then
    Exit(AValue);
  Result := LFormatter(AValue, AConfig);
end;

class function TRickUIBuilderEditInput.FormatTypedValue(const AValue: string;
  const AConfig: TRickUIBuilderEditConfig): string;
begin
  if AConfig.Preset in [TRickUIBuilderEditPreset.CPF,
    TRickUIBuilderEditPreset.CNPJ, TRickUIBuilderEditPreset.CEP,
    TRickUIBuilderEditPreset.Phone, TRickUIBuilderEditPreset.Mobile] then
    Result := FormatMaskedValue(AValue, AConfig)
  else if AConfig.Preset = TRickUIBuilderEditPreset.Email then
    Result := LowerCase(AValue)
  else if AConfig.Preset = TRickUIBuilderEditPreset.URL then
    Result := ApplyUrlCase(AValue, AConfig.UrlCaseMode)
  else
    Result := ApplyCase(AValue, AConfig.CaseMode);
  if (AConfig.MaxLength > 0) and (Length(Result) > AConfig.MaxLength) then
    SetLength(Result, AConfig.MaxLength);
end;

class function TRickUIBuilderEditInput.IsIntegerAllowed(const AValue: string;
  const AConfig: TRickUIBuilderEditConfig): Boolean;
var
  I: Integer;
begin
  Result := True;
  for I := 1 to Length(AValue) do
    if not (CharInSet(AValue[I], ['0'..'9']) or
      (AConfig.AllowNegative and (AValue[I] = '-') and (I = 1))) then
      Exit(False);
end;

class function TRickUIBuilderEditInput.IsTextAllowed(const AValue: string;
  const AConfig: TRickUIBuilderEditConfig): Boolean;
var
  LChar: Char;
  LAccents, LPunctuation: Boolean;
begin
  LAccents := AConfig.Preset in [TRickUIBuilderEditPreset.TextWithAccents,
    TRickUIBuilderEditPreset.TextPunctuationWithAccents];
  LPunctuation := AConfig.Preset in [TRickUIBuilderEditPreset.TextPunctuationNoAccents,
    TRickUIBuilderEditPreset.TextPunctuationWithAccents];
  Result := True;
  for LChar in AValue do
    if not IsTextChar(LChar, LAccents, LPunctuation) then
      Exit(False);
end;

class function TRickUIBuilderEditInput.IsEmailAtext(AChar: Char): Boolean;
begin
  Result := AChar.IsLetterOrDigit or CharInSet(AChar, ['_', '+', '-']);
end;

class function TRickUIBuilderEditInput.FindEmailSeparator(
  const AValue: string): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 1 to Length(AValue) do
    if AValue[I] = '@' then
    begin
      if Result > 0 then
        Exit(-1);
      Result := I;
    end;
end;

class function TRickUIBuilderEditInput.IsEmailAllowed(
  const AValue: string): Boolean;
var
  I, LAtIndex: Integer;
  LChar: Char;
begin
  LAtIndex := FindEmailSeparator(AValue);
  if LAtIndex < 0 then
    Exit(False);

  for I := 1 to Length(AValue) do
  begin
    LChar := AValue[I];
    if LChar = '@' then
      Continue;

    if (LAtIndex = 0) or (I < LAtIndex) then
    begin
      if not (IsEmailAtext(LChar) or (LChar = '.')) then
        Exit(False);
    end
    else if not (LChar.IsLetterOrDigit or CharInSet(LChar, ['-', '.'])) then
      Exit(False);
  end;
  Result := True;
end;

class function TRickUIBuilderEditInput.IsEmailLocalPart(
  const AValue: string): Boolean;
var
  I: Integer;
begin
  if (AValue = '') or (AValue[1] = '.') or
    (AValue[Length(AValue)] = '.') or (Pos('..', AValue) > 0) then
    Exit(False);

  for I := 1 to Length(AValue) do
    if not (IsEmailAtext(AValue[I]) or (AValue[I] = '.')) then
      Exit(False);
  Result := True;
end;

class function TRickUIBuilderEditInput.IsEmailDomain(
  const AValue: string): Boolean;
var
  I, LLabelStart, LLabelLength: Integer;
  LChar: Char;
begin
  if AValue = '' then
    Exit(False);

  LLabelStart := 1;
  for I := 1 to Length(AValue) + 1 do
  begin
    if (I > Length(AValue)) or (AValue[I] = '.') then
    begin
      LLabelLength := I - LLabelStart;
      if (LLabelLength = 0) or (LLabelLength > 63) then
        Exit(False);
      if (AValue[LLabelStart] = '-') or (AValue[I - 1] = '-') then
        Exit(False);
      LLabelStart := I + 1;
      Continue;
    end;

    LChar := AValue[I];
    if not (LChar.IsLetterOrDigit or (LChar = '-')) then
      Exit(False);
  end;
  Result := True;
end;

class function TRickUIBuilderEditInput.IsEmailComplete(
  const AValue: string): Boolean;
var
  LAtIndex: Integer;
  LLocal, LDomain: string;
begin
  LAtIndex := FindEmailSeparator(AValue);
  if LAtIndex <= 1 then
    Exit(False);

  LLocal := Copy(AValue, 1, LAtIndex - 1);
  LDomain := Copy(AValue, LAtIndex + 1, MaxInt);
  if (LLocal = '') or (LDomain = '') then
    Exit(False);
  if TEncoding.UTF8.GetByteCount(LLocal) > 64 then
    Exit(False);
  if TEncoding.UTF8.GetByteCount(AValue) > 254 then
    Exit(False);

  Result := IsEmailLocalPart(LLocal) and IsEmailDomain(LDomain);
end;

class function TRickUIBuilderEditInput.IsPortValid(
  const AValue: string): Boolean;
var
  LPort: Integer;
  LChar: Char;
begin
  if AValue.Trim.IsEmpty then
    Exit(False);
  for LChar in AValue do
    if not LChar.IsDigit then
      Exit(False);
  Result := TryStrToInt(AValue, LPort) and (LPort >= 0) and (LPort <= 65535);
end;

class function TRickUIBuilderEditInput.IsIPv4Valid(
  const AValue: string): Boolean;
var
  LParts: TArray<string>;
  LPart: string;
  LValue: Integer;
begin
  LParts := AValue.Split(['.']);
  if Length(LParts) <> 4 then
    Exit(False);
  for LPart in LParts do
  begin
    if LPart.Trim.IsEmpty or (Length(LPart) > 3) then
      Exit(False);
    if not TryStrToInt(LPart, LValue) or (LValue < 0) or (LValue > 255) then
      Exit(False);
  end;
  Result := True;
end;

class function TRickUIBuilderEditInput.IsIPv6Valid(
  const AValue: string): Boolean;
var
  LParts: TArray<string>;
  LPart: string;
  LDoubleColon, LIndex, LCount: Integer;
  LChar: Char;
begin
  if AValue.Trim.IsEmpty then
    Exit(False);
  LDoubleColon := Pos('::', AValue);
  if (LDoubleColon > 0) and
    (Pos('::', Copy(AValue, LDoubleColon + 2, MaxInt)) > 0) then
    Exit(False);
  LParts := AValue.Split([':']);
  LCount := 0;
  for LIndex := 0 to High(LParts) do
  begin
    LPart := LParts[LIndex];
    if LPart.IsEmpty then
      Continue;
    if Length(LPart) > 4 then
      Exit(False);
    for LChar in LPart do
      if not CharInSet(LChar, ['0'..'9', 'a'..'f', 'A'..'F']) then
        Exit(False);
    Inc(LCount);
  end;
  if LDoubleColon > 0 then
    Result := LCount < 8
  else
    Result := LCount = 8;
end;

class function TRickUIBuilderEditInput.IsDomainHostValid(
  const AValue: string): Boolean;
var
  LLabels: TArray<string>;
  LLabel: string;
  LChar: Char;
begin
  if AValue.Trim.IsEmpty then
    Exit(False);
  if SameText(AValue, 'localhost') then
    Exit(True);
  LLabels := AValue.Split(['.']);
  if Length(LLabels) < 2 then
    Exit(False);
  for LLabel in LLabels do
  begin
    if LLabel.Trim.IsEmpty or (Length(LLabel) > 63) then
      Exit(False);
    if (LLabel[1] = '-') or (LLabel[Length(LLabel)] = '-') then
      Exit(False);
    for LChar in LLabel do
      if not (LChar.IsLetterOrDigit or (LChar = '-')) then
        Exit(False);
  end;
  Result := True;
end;

class function TRickUIBuilderEditInput.IsUrlHostValid(
  const AValue: string): Boolean;
var
  LChar: Char;
  LHasDot: Boolean;
begin
  if AValue.Trim.IsEmpty then
    Exit(False);
  LHasDot := False;
  for LChar in AValue do
    if LChar = '.' then
      LHasDot := True;
  if LHasDot and IsIPv4Valid(AValue) then
    Exit(True);
  if LHasDot and AValue[1].IsDigit then
    Exit(False);
  Result := IsDomainHostValid(AValue);
end;

class function TRickUIBuilderEditInput.IsUrlAuthorityValid(
  const AValue: string): Boolean;
var
  LCloseBracket, LColon: Integer;
  LHost, LPort: string;
begin
  if AValue.Trim.IsEmpty or (Pos('@', AValue) > 0) then
    Exit(False);
  if AValue[1] = '[' then
  begin
    LCloseBracket := Pos(']', AValue);
    if LCloseBracket = 0 then
      Exit(False);
    LHost := Copy(AValue, 2, LCloseBracket - 2);
    if not IsIPv6Valid(LHost) then
      Exit(False);
    LPort := Copy(AValue, LCloseBracket + 1, MaxInt);
    if LPort.IsEmpty then
      Exit(True);
    if LPort[1] <> ':' then
      Exit(False);
    Exit(IsPortValid(Copy(LPort, 2, MaxInt)));
  end;

  LColon := LastDelimiter(':', AValue);
  if LColon > 0 then
  begin
    LHost := Copy(AValue, 1, LColon - 1);
    LPort := Copy(AValue, LColon + 1, MaxInt);
    if Pos(':', LHost) > 0 then
      Exit(False);
    Result := IsUrlHostValid(LHost) and IsPortValid(LPort);
    Exit;
  end;
  Result := IsUrlHostValid(AValue);
end;

class function TRickUIBuilderEditInput.IsUrlComplete(
  const AValue: string): Boolean;
var
  LValue, LAuthority: string;
  LBoundary: Integer;
begin
  LValue := AValue;
  if LValue.Trim.IsEmpty or (LValue <> LValue.Trim) then
    Exit(False);

  if Pos('://', LValue) > 0 then
  begin
    if StartsText('https://', LValue) then
      Delete(LValue, 1, Length('https://'))
    else if StartsText('http://', LValue) then
      Delete(LValue, 1, Length('http://'))
    else
      Exit(False);
  end;

  LBoundary := Length(LValue) + 1;
  if Pos('/', LValue) > 0 then
    LBoundary := Pos('/', LValue);
  if (Pos('?', LValue) > 0) and (Pos('?', LValue) < LBoundary) then
    LBoundary := Pos('?', LValue);
  if (Pos('#', LValue) > 0) and (Pos('#', LValue) < LBoundary) then
    LBoundary := Pos('#', LValue);

  LAuthority := Copy(LValue, 1, LBoundary - 1);
  Result := IsUrlAuthorityValid(LAuthority);
end;

class function TRickUIBuilderEditInput.IsValueAllowed(const AValue: string;
  const AConfig: TRickUIBuilderEditConfig): Boolean;
begin
  if (AConfig.MaxLength > 0) and (Length(AValue) > AConfig.MaxLength) then
    Exit(False);
  case AConfig.Preset of
    TRickUIBuilderEditPreset.IntegerNumber:
      Result := IsIntegerAllowed(AValue, AConfig);
    TRickUIBuilderEditPreset.FloatNumber:
      Result := ValidateNumber(AValue, AConfig);
    TRickUIBuilderEditPreset.Email:
      Result := IsEmailAllowed(AValue);
    TRickUIBuilderEditPreset.TextNoAccents,
    TRickUIBuilderEditPreset.TextPunctuationNoAccents,
    TRickUIBuilderEditPreset.TextWithAccents,
    TRickUIBuilderEditPreset.TextPunctuationWithAccents:
      Result := IsTextAllowed(AValue, AConfig);
  else
    Result := True;
  end;
end;

class function TRickUIBuilderEditInput.IsMaskSeparator(AChar: Char;
  APreset: TRickUIBuilderEditPreset): Boolean;
begin
  case APreset of
    TRickUIBuilderEditPreset.CPF: Result := CharInSet(AChar, ['.', '-']);
    TRickUIBuilderEditPreset.CNPJ: Result := CharInSet(AChar, ['.', '/', '-']);
    TRickUIBuilderEditPreset.CEP: Result := AChar = '-';
    TRickUIBuilderEditPreset.Phone,
    TRickUIBuilderEditPreset.Mobile:
      Result := CharInSet(AChar, ['(', ')', ' ', '-']);
  else
    Result := False;
  end;
end;

class function TRickUIBuilderEditInput.IsMaskedTypingAllowed(
  const AValue: string; APreset: TRickUIBuilderEditPreset): Boolean;
var
  LChar: Char;
  LAlphaIndex: Integer;
begin
  LAlphaIndex := 0;
  for LChar in AValue do
  begin
    if IsCnpjBaseChar(LChar) then
      Inc(LAlphaIndex)
    else if not IsMaskSeparator(LChar, APreset) then
      Exit(False);
    if (APreset <> TRickUIBuilderEditPreset.CNPJ) and
      IsBasicLetter(LChar) then
      Exit(False);
    if (APreset = TRickUIBuilderEditPreset.CNPJ) and
      (LAlphaIndex > 12) and IsBasicLetter(LChar) then
      Exit(False);
  end;
  Result := True;
end;

class function TRickUIBuilderEditInput.HasCompleteMask(const AValue: string;
  APreset: TRickUIBuilderEditPreset): Boolean;
begin
  case APreset of
    TRickUIBuilderEditPreset.CPF: Result := Length(AValue) = 14;
    TRickUIBuilderEditPreset.CNPJ: Result := Length(AValue) = 18;
    TRickUIBuilderEditPreset.CEP: Result := Length(AValue) = 9;
    TRickUIBuilderEditPreset.Phone: Result := Length(AValue) in [9, 14];
    TRickUIBuilderEditPreset.Mobile: Result := Length(AValue) in [11, 16];
  else
    Result := True;
  end;
end;

class function TRickUIBuilderEditInput.IsTypedValueAllowed(
  const AValue: string; const AConfig: TRickUIBuilderEditConfig): Boolean;
begin
  if AConfig.Preset in [TRickUIBuilderEditPreset.CPF,
    TRickUIBuilderEditPreset.CNPJ, TRickUIBuilderEditPreset.CEP,
    TRickUIBuilderEditPreset.Phone, TRickUIBuilderEditPreset.Mobile] then
    Exit(IsMaskedTypingAllowed(AValue, AConfig.Preset));
  Result := IsValueAllowed(AValue, AConfig);
end;

class function TRickUIBuilderEditInput.IsPasteAllowed(const AValue: string;
  const AConfig: TRickUIBuilderEditConfig): Boolean;
var
  LFormatted: string;
begin
  if not IsValueAllowed(AValue, AConfig) then
    Exit(False);
  case AConfig.Preset of
    TRickUIBuilderEditPreset.CPF,
    TRickUIBuilderEditPreset.CNPJ,
    TRickUIBuilderEditPreset.CEP,
    TRickUIBuilderEditPreset.Phone,
    TRickUIBuilderEditPreset.Mobile:
      begin
        LFormatted := FormatTypedValue(AValue, AConfig);
        Result := HasCompleteMask(AValue, AConfig.Preset) and
          (AValue = LFormatted);
      end;
  else
    Result := True;
  end;
end;


class function TRickUIBuilderEditInput.IsCompleteValue(const AValue: string;
  const AConfig: TRickUIBuilderEditConfig): Boolean;
var
  LFormatted: string;
begin
  if AValue.Trim.IsEmpty then
    Exit(not AConfig.Required);
  case AConfig.Preset of
    TRickUIBuilderEditPreset.CPF,
    TRickUIBuilderEditPreset.CNPJ,
    TRickUIBuilderEditPreset.CEP,
    TRickUIBuilderEditPreset.Phone,
    TRickUIBuilderEditPreset.Mobile:
      begin
        LFormatted := FormatTypedValue(AValue, AConfig);
        Result := (AValue = LFormatted) and
          HasCompleteMask(LFormatted, AConfig.Preset);
      end;
    TRickUIBuilderEditPreset.Email:
      Result := IsEmailComplete(AValue);
    TRickUIBuilderEditPreset.URL:
      Result := IsUrlComplete(AValue);
  else
    Result := True;
  end;
end;


end.
