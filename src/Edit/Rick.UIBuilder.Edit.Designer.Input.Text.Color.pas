unit Rick.UIBuilder.Edit.Designer.Input.Text.Color;

interface

uses
  FMX.Edit,
  FMX.Objects,
  System.UITypes,

  Rick.UIBuilder.Edit.Interfaces;

type
  TRickUIBuilderEditDesignerInputTextColor = class(TInterfacedObject, IRickUIBuilderEditDesignerInputTextColor)
  private
    [weak]
    FParent: IRickUIBuilderEditDesignerInputText;
    FControl: TEdit;
    FBackground: TRectangle;
    FReadOnlyColor: TAlphaColor;
  protected
    constructor Create(const AParent: IRickUIBuilderEditDesignerInputText; AControl: TEdit; ABackground: TRectangle);

    function Background(AValue: TAlphaColor): IRickUIBuilderEditDesignerInputTextColor;
    function Text(AValue: TAlphaColor): IRickUIBuilderEditDesignerInputTextColor;
    function ReadOnly(AValue: TAlphaColor): IRickUIBuilderEditDesignerInputTextColor;
    function ToBack: IRickUIBuilderEditDesignerInputText;
  public
    class function New(const AParent: IRickUIBuilderEditDesignerInputText; AControl: TEdit; ABackground: TRectangle): IRickUIBuilderEditDesignerInputTextColor;
  end;

implementation

uses
  System.SysUtils;

constructor TRickUIBuilderEditDesignerInputTextColor.Create(const AParent: IRickUIBuilderEditDesignerInputText; AControl: TEdit; ABackground: TRectangle);
begin
  inherited Create;
  FParent := AParent;
  FControl := AControl;
  FBackground := ABackground;
  FReadOnlyColor := $FFB8B8B8;
end;

class function TRickUIBuilderEditDesignerInputTextColor.New(const AParent: IRickUIBuilderEditDesignerInputText; AControl: TEdit; ABackground: TRectangle): IRickUIBuilderEditDesignerInputTextColor;
begin
  Result := Self.Create(AParent, AControl, ABackground);
end;

function TRickUIBuilderEditDesignerInputTextColor.Background(AValue: TAlphaColor): IRickUIBuilderEditDesignerInputTextColor;
begin
  FBackground.Fill.Color := AValue;
  Result := Self;
end;

function TRickUIBuilderEditDesignerInputTextColor.Text(AValue: TAlphaColor): IRickUIBuilderEditDesignerInputTextColor;
begin
  FControl.TextSettings.FontColor := AValue;
  Result := Self;
end;

function TRickUIBuilderEditDesignerInputTextColor.ReadOnly(AValue: TAlphaColor): IRickUIBuilderEditDesignerInputTextColor;
begin
  FReadOnlyColor := AValue;
  if FControl.ReadOnly then
    FControl.TextSettings.FontColor := AValue;
  Result := Self;
end;

function TRickUIBuilderEditDesignerInputTextColor.ToBack: IRickUIBuilderEditDesignerInputText;
begin
  if not Assigned(FParent) then
    raise Exception.Create('O Parent da interface não foi informado para retornar.');
  Result := FParent;
end;

end.
