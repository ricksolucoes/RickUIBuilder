unit Rick.UIBuilder.Edit.Designer.Input.Number;

interface

uses
  Rick.UIBuilder.Edit.Interfaces,
  Rick.UIBuilder.Edit.Types;

type
  TRickUIBuilderEditDesignerInputNumber = class(TInterfacedObject, IRickUIBuilderEditDesignerInputNumber)
  private
    [weak]
    FParent: IRickUIBuilderEditDesignerInput;
    FAllowNegative: Boolean;
    FDecimalPlaces: Integer;
    FFormatMode: TRickUIBuilderEditNumberFormatMode;
    FDecimalSeparator: Char;
    FThousandSeparator: Char;
    FUseThousandSeparator: Boolean;
  protected
    constructor Create(const AParent: IRickUIBuilderEditDesignerInput);

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
    class function New(const AParent: IRickUIBuilderEditDesignerInput): IRickUIBuilderEditDesignerInputNumber;
  end;

implementation

uses
  System.SysUtils;

constructor TRickUIBuilderEditDesignerInputNumber.Create(const AParent: IRickUIBuilderEditDesignerInput);
begin
  inherited Create;
  FParent := AParent;
  FAllowNegative := False;
  FDecimalPlaces := 2;
  FFormatMode := TRickUIBuilderEditNumberFormatMode.Locale;
  FDecimalSeparator := #0;
  FThousandSeparator := #0;
  FUseThousandSeparator := False;
end;

class function TRickUIBuilderEditDesignerInputNumber.New(const AParent: IRickUIBuilderEditDesignerInput): IRickUIBuilderEditDesignerInputNumber;
begin
  Result := Self.Create(AParent);
end;

function TRickUIBuilderEditDesignerInputNumber.AllowNegative(AValue: Boolean): IRickUIBuilderEditDesignerInputNumber;
begin
  FAllowNegative := AValue;
  Result := Self;
end;

function TRickUIBuilderEditDesignerInputNumber.AllowNegative: IRickUIBuilderEditDesignerInputNumber;
begin
  Result := AllowNegative(True);
end;

function TRickUIBuilderEditDesignerInputNumber.DecimalPlaces(AValue: Integer): IRickUIBuilderEditDesignerInputNumber;
begin
  FDecimalPlaces := AValue;
  Result := Self;
end;

function TRickUIBuilderEditDesignerInputNumber.FormatMode(AValue: TRickUIBuilderEditNumberFormatMode): IRickUIBuilderEditDesignerInputNumber;
begin
  FFormatMode := AValue;
  Result := Self;
end;

function TRickUIBuilderEditDesignerInputNumber.DecimalSeparator(AValue: Char): IRickUIBuilderEditDesignerInputNumber;
begin
  FDecimalSeparator := AValue;
  Result := Self;
end;

function TRickUIBuilderEditDesignerInputNumber.ThousandSeparator(AValue: Char): IRickUIBuilderEditDesignerInputNumber;
begin
  FThousandSeparator := AValue;
  Result := Self;
end;

function TRickUIBuilderEditDesignerInputNumber.UseThousandSeparator(AValue: Boolean): IRickUIBuilderEditDesignerInputNumber;
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
