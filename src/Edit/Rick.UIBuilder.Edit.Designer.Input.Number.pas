unit Rick.UIBuilder.Edit.Designer.Input.Number;

interface

uses
  Rick.UIBuilder.Edit.InputRules,
  Rick.UIBuilder.Edit.Interfaces,
  Rick.UIBuilder.Edit.Types;

type
  TRickUIBuilderEditDesignerInputNumber = class(TInterfacedObject, IRickUIBuilderEditDesignerInputNumber)
  private
    [weak]
    FParent: IRickUIBuilderEditDesignerInput;
    FInputRules: TRickUIBuilderEditInputRules;
  protected
    constructor Create(const AParent: IRickUIBuilderEditDesignerInput; AInputRules: TRickUIBuilderEditInputRules);

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
    class function New(const AParent: IRickUIBuilderEditDesignerInput; AInputRules: TRickUIBuilderEditInputRules): IRickUIBuilderEditDesignerInputNumber;
  end;

implementation

uses
  System.SysUtils;

constructor TRickUIBuilderEditDesignerInputNumber.Create(const AParent: IRickUIBuilderEditDesignerInput; AInputRules: TRickUIBuilderEditInputRules);
begin
  inherited Create;
  FParent := AParent;
  FInputRules := AInputRules;
end;

class function TRickUIBuilderEditDesignerInputNumber.New(const AParent: IRickUIBuilderEditDesignerInput; AInputRules: TRickUIBuilderEditInputRules): IRickUIBuilderEditDesignerInputNumber;
begin
  Result := Self.Create(AParent, AInputRules);
end;

function TRickUIBuilderEditDesignerInputNumber.AllowNegative(AValue: Boolean): IRickUIBuilderEditDesignerInputNumber;
begin
  FInputRules.SetAllowNegative(AValue);
  Result := Self;
end;

function TRickUIBuilderEditDesignerInputNumber.AllowNegative: IRickUIBuilderEditDesignerInputNumber;
begin
  Result := AllowNegative(True);
end;

function TRickUIBuilderEditDesignerInputNumber.DecimalPlaces(AValue: Integer): IRickUIBuilderEditDesignerInputNumber;
begin
  FInputRules.SetDecimalPlaces(AValue);
  Result := Self;
end;

function TRickUIBuilderEditDesignerInputNumber.FormatMode(AValue: TRickUIBuilderEditNumberFormatMode): IRickUIBuilderEditDesignerInputNumber;
begin
  FInputRules.SetFormatMode(AValue);
  Result := Self;
end;

function TRickUIBuilderEditDesignerInputNumber.DecimalSeparator(AValue: Char): IRickUIBuilderEditDesignerInputNumber;
begin
  FInputRules.SetDecimalSeparator(AValue);
  Result := Self;
end;

function TRickUIBuilderEditDesignerInputNumber.ThousandSeparator(AValue: Char): IRickUIBuilderEditDesignerInputNumber;
begin
  FInputRules.SetThousandSeparator(AValue);
  Result := Self;
end;

function TRickUIBuilderEditDesignerInputNumber.UseThousandSeparator(AValue: Boolean): IRickUIBuilderEditDesignerInputNumber;
begin
  FInputRules.SetUseThousandSeparator(AValue);
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
