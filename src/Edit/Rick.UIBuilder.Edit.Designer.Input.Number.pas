unit Rick.UIBuilder.Edit.Designer.Input.Number;

interface

uses
  FMX.Edit,
  FMX.Text,
  System.Classes,

  Rick.UIBuilder.Edit.Interfaces,
  Rick.UIBuilder.Edit.Types;

type
  TRickUIBuilderEditDesignerInputNumber = class(TComponent, IRickUIBuilderEditDesignerInputNumber)
  private
    [weak]
    FParent: IRickUIBuilderEditDesignerInput;
    FControl: TEdit;
    FAllowNegative: Boolean;
    FDecimalPlaces: Integer;
    FFormatMode: TRickUIBuilderEditNumberFormatMode;
    FDecimalSeparator: Char;
    FThousandSeparator: Char;
    FUseThousandSeparator: Boolean;
    FPreviousValidate: TValidateTextEvent;
    FPreviousValidating: TValidateTextEvent;
    function DecimalSeparatorValue: Char;
    function ThousandSeparatorValue: Char;
    function IsNumberChar(AChar: Char): Boolean;
    function ValidateNumberCharacter(AChar: Char; AIndex: Integer;
      var ADecimalIndex: Integer; ADecimal: Char): Boolean;
    function ValidateNumberCharacters(const AValue: string;
      out ADecimalIndex: Integer): Boolean;
    function ValidateNumber(const AValue: string): Boolean;
    function IsIntegerAllowed(const AValue: string): Boolean;
    procedure HandleValidate(ASender: TObject; var AText: string);
    procedure HandleValidating(ASender: TObject; var AText: string);
  protected
    constructor Create(const AParent: IRickUIBuilderEditDesignerInput;
      AControl: TEdit); reintroduce;

    function AllowNegative(AValue: Boolean): IRickUIBuilderEditDesignerInputNumber; overload;
    function AllowNegative: IRickUIBuilderEditDesignerInputNumber; overload;
    function DecimalPlaces(AValue: Integer): IRickUIBuilderEditDesignerInputNumber;
    function FormatMode(AValue: TRickUIBuilderEditNumberFormatMode): IRickUIBuilderEditDesignerInputNumber;
    function DecimalSeparator(AValue: Char): IRickUIBuilderEditDesignerInputNumber;
    function ThousandSeparator(AValue: Char): IRickUIBuilderEditDesignerInputNumber;
    function UseThousandSeparator(AValue: Boolean): IRickUIBuilderEditDesignerInputNumber; overload;
    function UseThousandSeparator: IRickUIBuilderEditDesignerInputNumber; overload;
    function ToBack: IRickUIBuilderEditDesignerInput;
  public
    destructor Destroy; override;
    class function New(const AParent: IRickUIBuilderEditDesignerInput;
      AControl: TEdit): IRickUIBuilderEditDesignerInputNumber;
  end;

implementation

uses
  System.SysUtils;

constructor TRickUIBuilderEditDesignerInputNumber.Create(
  const AParent: IRickUIBuilderEditDesignerInput; AControl: TEdit);
begin
  inherited Create(AControl);
  FParent := AParent;
  FControl := AControl;
  FAllowNegative := False;
  FDecimalPlaces := 2;
  FFormatMode := TRickUIBuilderEditNumberFormatMode.Locale;
  FDecimalSeparator := #0;
  FThousandSeparator := #0;
  FUseThousandSeparator := False;
  FPreviousValidate := FControl.OnValidate;
  FPreviousValidating := FControl.OnValidating;
  FControl.OnValidate := HandleValidate;
  FControl.OnValidating := HandleValidating;
end;

destructor TRickUIBuilderEditDesignerInputNumber.Destroy;
begin
  if Assigned(FControl) and not (csDestroying in FControl.ComponentState) then
  begin
    FControl.OnValidate := FPreviousValidate;
    FControl.OnValidating := FPreviousValidating;
  end;
  inherited;
end;

class function TRickUIBuilderEditDesignerInputNumber.New(
  const AParent: IRickUIBuilderEditDesignerInput;
  AControl: TEdit): IRickUIBuilderEditDesignerInputNumber;
begin
  Result := Self.Create(AParent, AControl);
end;

function TRickUIBuilderEditDesignerInputNumber.DecimalSeparatorValue: Char;
begin
  if FFormatMode = TRickUIBuilderEditNumberFormatMode.Locale then
    Exit(FormatSettings.DecimalSeparator);
  Result := FDecimalSeparator;
end;

function TRickUIBuilderEditDesignerInputNumber.ThousandSeparatorValue: Char;
begin
  if FFormatMode = TRickUIBuilderEditNumberFormatMode.Locale then
    Exit(FormatSettings.ThousandSeparator);
  Result := FThousandSeparator;
end;

function TRickUIBuilderEditDesignerInputNumber.IsNumberChar(AChar: Char): Boolean;
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

function TRickUIBuilderEditDesignerInputNumber.ValidateNumberCharacter(
  AChar: Char; AIndex: Integer; var ADecimalIndex: Integer;
  ADecimal: Char): Boolean;
begin
  if not IsNumberChar(AChar) then
    Exit(False);
  if AChar = '-' then
    Exit(AIndex = 1);
  if AChar <> ADecimal then
    Exit(True);
  if ADecimalIndex > 0 then
    Exit(False);
  ADecimalIndex := AIndex;
  Result := True;
end;

function TRickUIBuilderEditDesignerInputNumber.ValidateNumberCharacters(
  const AValue: string; out ADecimalIndex: Integer): Boolean;
var
  LIndex: Integer;
  LDecimal: Char;
begin
  ADecimalIndex := 0;
  LDecimal := DecimalSeparatorValue;
  for LIndex := 1 to Length(AValue) do
    if not ValidateNumberCharacter(AValue[LIndex], LIndex, ADecimalIndex,
      LDecimal) then
      Exit(False);
  Result := True;
end;

function TRickUIBuilderEditDesignerInputNumber.ValidateNumber(
  const AValue: string): Boolean;
var
  LDecimalIndex: Integer;
begin
  if not ValidateNumberCharacters(AValue, LDecimalIndex) then
    Exit(False);
  if (LDecimalIndex = 0) or (FDecimalPlaces < 0) then
    Exit(True);
  Result := Length(AValue) - LDecimalIndex <= FDecimalPlaces;
end;

function TRickUIBuilderEditDesignerInputNumber.IsIntegerAllowed(
  const AValue: string): Boolean;
var
  LIndex: Integer;
begin
  Result := True;
  for LIndex := 1 to Length(AValue) do
    if not (CharInSet(AValue[LIndex], ['0'..'9']) or
      (FAllowNegative and (AValue[LIndex] = '-') and (LIndex = 1))) then
      Exit(False);
end;

procedure TRickUIBuilderEditDesignerInputNumber.HandleValidate(
  ASender: TObject; var AText: string);
begin
  if not Assigned(ASender) then
  begin
    if not IsIntegerAllowed(AText) then
      AText := EmptyStr;
    Exit;
  end;
  if Assigned(FPreviousValidate) then
    FPreviousValidate(ASender, AText);
end;

procedure TRickUIBuilderEditDesignerInputNumber.HandleValidating(
  ASender: TObject; var AText: string);
begin
  if not Assigned(ASender) then
  begin
    if not ValidateNumber(AText) then
      AText := EmptyStr;
    Exit;
  end;
  if Assigned(FPreviousValidating) then
    FPreviousValidating(ASender, AText);
end;

function TRickUIBuilderEditDesignerInputNumber.AllowNegative(
  AValue: Boolean): IRickUIBuilderEditDesignerInputNumber;
begin
  FAllowNegative := AValue;
  Result := Self;
end;

function TRickUIBuilderEditDesignerInputNumber.AllowNegative: IRickUIBuilderEditDesignerInputNumber;
begin
  Result := AllowNegative(True);
end;

function TRickUIBuilderEditDesignerInputNumber.DecimalPlaces(
  AValue: Integer): IRickUIBuilderEditDesignerInputNumber;
begin
  FDecimalPlaces := AValue;
  Result := Self;
end;

function TRickUIBuilderEditDesignerInputNumber.FormatMode(
  AValue: TRickUIBuilderEditNumberFormatMode): IRickUIBuilderEditDesignerInputNumber;
begin
  FFormatMode := AValue;
  Result := Self;
end;

function TRickUIBuilderEditDesignerInputNumber.DecimalSeparator(
  AValue: Char): IRickUIBuilderEditDesignerInputNumber;
begin
  FDecimalSeparator := AValue;
  Result := Self;
end;

function TRickUIBuilderEditDesignerInputNumber.ThousandSeparator(
  AValue: Char): IRickUIBuilderEditDesignerInputNumber;
begin
  FThousandSeparator := AValue;
  Result := Self;
end;

function TRickUIBuilderEditDesignerInputNumber.UseThousandSeparator(
  AValue: Boolean): IRickUIBuilderEditDesignerInputNumber;
begin
  FUseThousandSeparator := AValue;
  Result := Self;
end;

function TRickUIBuilderEditDesignerInputNumber.UseThousandSeparator: IRickUIBuilderEditDesignerInputNumber;
begin
  Result := UseThousandSeparator(True);
end;

function TRickUIBuilderEditDesignerInputNumber.ToBack: IRickUIBuilderEditDesignerInput;
begin
  if not Assigned(FParent) then
    raise Exception.Create('O Parent da interface não foi informado para retornar.');
  Result := FParent;
end;

end.
