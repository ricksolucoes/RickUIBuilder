unit Rick.UIBuilder.Edit.Designer.Input.Text;

interface

uses
  FMX.Edit,
  FMX.Objects,

  Rick.UIBuilder.Edit.Interfaces;

type
  TRickUIBuilderEditDesignerInputText = class(TInterfacedObject, IRickUIBuilderEditDesignerInputText)
  private
    [weak]
    FParent: IRickUIBuilderEditDesignerInput;
    FControl: TEdit;
    FBackground: TRectangle;
    FColor: IRickUIBuilderEditDesignerInputTextColor;
  protected
    constructor Create(const AParent: IRickUIBuilderEditDesignerInput; AControl: TEdit; ABackground: TRectangle);

    function Value(const AValue: string): IRickUIBuilderEditDesignerInputText; overload;
    function Value: string; overload;
    function Color: IRickUIBuilderEditDesignerInputTextColor;
    function Size(AValue: Single): IRickUIBuilderEditDesigner;
    function ToBack: IRickUIBuilderEditDesigner;
  public
    class function New(const AParent: IRickUIBuilderEditDesignerInput; AControl: TEdit; ABackground: TRectangle): IRickUIBuilderEditDesignerInputText;
  end;

implementation

uses
  System.SysUtils,

  Rick.UIBuilder.Edit.Designer.Input.Text.Color;

constructor TRickUIBuilderEditDesignerInputText.Create(const AParent: IRickUIBuilderEditDesignerInput; AControl: TEdit; ABackground: TRectangle);
begin
  inherited Create;
  FParent := AParent;
  FControl := AControl;
  FBackground := ABackground;
end;

class function TRickUIBuilderEditDesignerInputText.New(const AParent: IRickUIBuilderEditDesignerInput; AControl: TEdit; ABackground: TRectangle): IRickUIBuilderEditDesignerInputText;
begin
  Result := Self.Create(AParent, AControl, ABackground);
end;

function TRickUIBuilderEditDesignerInputText.Value(const AValue: string): IRickUIBuilderEditDesignerInputText;
begin
  FControl.Text := AValue;
  Result := Self;
end;

function TRickUIBuilderEditDesignerInputText.Value: string;
begin
  Result := FControl.Text;
end;

function TRickUIBuilderEditDesignerInputText.Color: IRickUIBuilderEditDesignerInputTextColor;
begin
  if not Assigned(FColor) then
    FColor := TRickUIBuilderEditDesignerInputTextColor.New(Self, FControl, FBackground);
  Result := FColor;
end;

function TRickUIBuilderEditDesignerInputText.Size(AValue: Single): IRickUIBuilderEditDesigner;
begin
  FControl.TextSettings.Font.Size := AValue;
  Result := ToBack;
end;

function TRickUIBuilderEditDesignerInputText.ToBack: IRickUIBuilderEditDesigner;
begin
  if not Assigned(FParent) then
    raise Exception.Create('O Parent da interface não foi informado para retornar.');
  Result := FParent.ToBack;
end;

end.
