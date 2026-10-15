unit Rick.UIBuilder.Edit.Designer.Input;

interface

uses
  FMX.Edit,
  FMX.Objects,

  Rick.UIBuilder.Edit.Interfaces;

type
  TRickUIBuilderEditDesignerInput = class(TInterfacedObject, IRickUIBuilderEditDesignerInput)
  private
    [weak]
    FParent: IRickUIBuilderEditDesigner;
    FControl: TEdit;
    FBackground: TRectangle;
    FText: IRickUIBuilderEditDesignerInputText;
    FNumber: IRickUIBuilderEditDesignerInputNumber;
    FConfig: IRickUIBuilderEditDesignerInputConfig;
  protected
    constructor Create(const AParent: IRickUIBuilderEditDesigner; AControl: TEdit;
      ABackground: TRectangle);

    function Text: IRickUIBuilderEditDesignerInputText;
    function Number: IRickUIBuilderEditDesignerInputNumber;
    function Config: IRickUIBuilderEditDesignerInputConfig;
    function ToBack: IRickUIBuilderEditDesigner;
  public
    class function New(const AParent: IRickUIBuilderEditDesigner; AControl: TEdit;
      ABackground: TRectangle): IRickUIBuilderEditDesignerInput;
  end;

implementation

uses
  System.SysUtils,

  Rick.UIBuilder.Edit.Designer.Input.Config,
  Rick.UIBuilder.Edit.Designer.Input.Number,
  Rick.UIBuilder.Edit.Designer.Input.Text;

constructor TRickUIBuilderEditDesignerInput.Create(
  const AParent: IRickUIBuilderEditDesigner; AControl: TEdit;
  ABackground: TRectangle);
begin
  inherited Create;
  FParent := AParent;
  FControl := AControl;
  FBackground := ABackground;
end;

class function TRickUIBuilderEditDesignerInput.New(
  const AParent: IRickUIBuilderEditDesigner; AControl: TEdit;
  ABackground: TRectangle): IRickUIBuilderEditDesignerInput;
begin
  Result := Self.Create(AParent, AControl, ABackground);
end;

function TRickUIBuilderEditDesignerInput.Text: IRickUIBuilderEditDesignerInputText;
begin
  if not Assigned(FText) then
    FText := TRickUIBuilderEditDesignerInputText.New(Self, FControl, FBackground);
  Result := FText;
end;

function TRickUIBuilderEditDesignerInput.Number: IRickUIBuilderEditDesignerInputNumber;
begin
  if not Assigned(FNumber) then
    FNumber := TRickUIBuilderEditDesignerInputNumber.New(Self, FControl);
  Result := FNumber;
end;

function TRickUIBuilderEditDesignerInput.Config: IRickUIBuilderEditDesignerInputConfig;
begin
  if not Assigned(FConfig) then
    FConfig := TRickUIBuilderEditDesignerInputConfig.New(Self, FControl);
  Result := FConfig;
end;

function TRickUIBuilderEditDesignerInput.ToBack: IRickUIBuilderEditDesigner;
begin
  if not Assigned(FParent) then
    raise Exception.Create('O Parent da interface não foi informado para retornar.');
  Result := FParent;
end;

end.
