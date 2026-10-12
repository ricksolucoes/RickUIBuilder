unit Rick.UIBuilder.Edit.Designer;

interface

uses
  FMX.Edit,
  FMX.Objects,

  Rick.UIBuilder.Edit.Interfaces;

type
  TRickUIBuilderEditDesigner = class(TInterfacedObject, IRickUIBuilderEditDesigner)
  private
    [weak]
    FParent: IRickUIBuilderEdit;
    FHost: TRectangle;
    FBackground: TRectangle;
    FControl: TEdit;
    FInput: IRickUIBuilderEditDesignerInput;
    FValidation: IRickUIBuilderEditDesignerValidation;
    FConfig: IRickUIBuilderEditDesignerConfig;
  protected
    constructor Create(const AParent: IRickUIBuilderEdit; AHost: TRectangle);

    function Input: IRickUIBuilderEditDesignerInput;
    function Validation: IRickUIBuilderEditDesignerValidation;
    function Config: IRickUIBuilderEditDesignerConfig;
    function Clear: IRickUIBuilderEditDesigner;
    function Control: TEdit;
    function ToBack: IRickUIBuilderEdit;
  public
    class function New(const AParent: IRickUIBuilderEdit; AHost: TRectangle): IRickUIBuilderEditDesigner;
  end;

implementation

uses
  FMX.Graphics,
  System.SysUtils,
  System.UITypes,

  FMX.Types,

  Rick.UIBuilder.Edit.Designer.Config,
  Rick.UIBuilder.Edit.Designer.Input,
  Rick.UIBuilder.Edit.Designer.Validation;

constructor TRickUIBuilderEditDesigner.Create(const AParent: IRickUIBuilderEdit; AHost: TRectangle);
begin
  inherited Create;
  FParent := AParent;
  FHost := AHost;
  FBackground := TRectangle.Create(AHost);
  FBackground.Parent := AHost;
  FBackground.SetBounds(8, 24, AHost.Width - 16, 24);
  FBackground.Fill.Color := $00000000;
  FBackground.Stroke.Kind := TBrushKind.None;
  FBackground.HitTest := False;
  FBackground.SendToBack;
  FControl := TEdit.Create(AHost);
  FControl.Parent := AHost;
  FControl.SetBounds(8, 24, AHost.Width - 16, 24);
  FControl.StyleLookup := 'transparentedit';
  FControl.StyledSettings := FControl.StyledSettings - [TStyledSetting.Size, TStyledSetting.FontColor];
  FControl.TextSettings.Font.Size := 14;
  FControl.TextSettings.FontColor := TAlphaColors.Black;
end;

class function TRickUIBuilderEditDesigner.New(const AParent: IRickUIBuilderEdit; AHost: TRectangle): IRickUIBuilderEditDesigner;
begin
  Result := Self.Create(AParent, AHost);
end;

function TRickUIBuilderEditDesigner.Input: IRickUIBuilderEditDesignerInput;
begin
  if not Assigned(FInput) then
    FInput := TRickUIBuilderEditDesignerInput.New(Self, FControl, FBackground);
  Result := FInput;
end;

function TRickUIBuilderEditDesigner.Validation: IRickUIBuilderEditDesignerValidation;
begin
  if not Assigned(FValidation) then
    FValidation := TRickUIBuilderEditDesignerValidation.New(Self);
  Result := FValidation;
end;

function TRickUIBuilderEditDesigner.Config: IRickUIBuilderEditDesignerConfig;
begin
  if not Assigned(FConfig) then
    FConfig := TRickUIBuilderEditDesignerConfig.New(Self, FControl);
  Result := FConfig;
end;

function TRickUIBuilderEditDesigner.Clear: IRickUIBuilderEditDesigner;
begin
  FControl.Text := EmptyStr;
  Result := Self;
end;

function TRickUIBuilderEditDesigner.Control: TEdit;
begin
  Result := FControl;
end;

function TRickUIBuilderEditDesigner.ToBack: IRickUIBuilderEdit;
begin
  if not Assigned(FParent) then
    raise Exception.Create('O Parent da interface não foi informado para retornar.');
  Result := FParent;
end;

end.
