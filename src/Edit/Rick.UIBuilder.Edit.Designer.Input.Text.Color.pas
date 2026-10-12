unit Rick.UIBuilder.Edit.Designer.Input.Text.Color;

interface

uses
  FMX.Edit,
  FMX.Objects,
  System.UITypes,

  Rick.UIBuilder.Edit.Interfaces,
  Rick.UIBuilder.Edit.VisualState;

type
  TRickUIBuilderEditDesignerInputTextColor = class(TInterfacedObject, IRickUIBuilderEditDesignerInputTextColor)
  private
    [weak]
    FParent: IRickUIBuilderEditDesignerInputText;
    FControl: TEdit;
    FBackground: TRectangle;
    FVisualState: TRickUIBuilderEditVisualState;
    FTextColor: TAlphaColor;
    FReadOnlyColor: TAlphaColor;
    procedure ApplyState(ASender: TObject);
  protected
    constructor Create(const AParent: IRickUIBuilderEditDesignerInputText; AControl: TEdit; ABackground: TRectangle; AVisualState: TRickUIBuilderEditVisualState);

    function Background(AValue: TAlphaColor): IRickUIBuilderEditDesignerInputTextColor;
    function Text(AValue: TAlphaColor): IRickUIBuilderEditDesignerInputTextColor;
    function ReadOnly(AValue: TAlphaColor): IRickUIBuilderEditDesignerInputTextColor;
    function ToBack: IRickUIBuilderEditDesignerInputText;
  public
    class function New(const AParent: IRickUIBuilderEditDesignerInputText; AControl: TEdit; ABackground: TRectangle; AVisualState: TRickUIBuilderEditVisualState): IRickUIBuilderEditDesignerInputTextColor;
  end;

implementation

uses
  System.SysUtils;

constructor TRickUIBuilderEditDesignerInputTextColor.Create(const AParent: IRickUIBuilderEditDesignerInputText; AControl: TEdit; ABackground: TRectangle; AVisualState: TRickUIBuilderEditVisualState);
begin
  inherited Create;
  FParent := AParent;
  FControl := AControl;
  FBackground := ABackground;
  FVisualState := AVisualState;
  FTextColor := TAlphaColors.Black;
  FReadOnlyColor := $FFB8B8B8;
  FVisualState.RegisterHandler(ApplyState, AParent);
  ApplyState(nil);
end;

class function TRickUIBuilderEditDesignerInputTextColor.New(const AParent: IRickUIBuilderEditDesignerInputText; AControl: TEdit; ABackground: TRectangle; AVisualState: TRickUIBuilderEditVisualState): IRickUIBuilderEditDesignerInputTextColor;
begin
  Result := Self.Create(AParent, AControl, ABackground, AVisualState);
end;

procedure TRickUIBuilderEditDesignerInputTextColor.ApplyState(ASender: TObject);
begin
  if FVisualState.IsReadOnly then
    FControl.TextSettings.FontColor := FReadOnlyColor
  else
    FControl.TextSettings.FontColor := FTextColor;
end;

function TRickUIBuilderEditDesignerInputTextColor.Background(AValue: TAlphaColor): IRickUIBuilderEditDesignerInputTextColor;
begin
  FBackground.Fill.Color := AValue;
  Result := Self;
end;

function TRickUIBuilderEditDesignerInputTextColor.Text(AValue: TAlphaColor): IRickUIBuilderEditDesignerInputTextColor;
begin
  FTextColor := AValue;
  ApplyState(nil);
  Result := Self;
end;

function TRickUIBuilderEditDesignerInputTextColor.ReadOnly(AValue: TAlphaColor): IRickUIBuilderEditDesignerInputTextColor;
begin
  FReadOnlyColor := AValue;
  ApplyState(nil);
  Result := Self;
end;

function TRickUIBuilderEditDesignerInputTextColor.ToBack: IRickUIBuilderEditDesignerInputText;
begin
  if not Assigned(FParent) then
    raise Exception.Create('O Parent da interface não foi informado para retornar.');
  Result := FParent;
end;

end.
