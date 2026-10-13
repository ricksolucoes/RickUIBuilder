unit Rick.UIBuilder.Tests.Edit.VisualState;

{$SCOPEDENUMS ON}

interface

uses
  DUnitX.TestFramework,
  FMX.Forms,
  System.UITypes,

  Rick.UIBuilder.Edit.Interfaces;

type
  [TestFixture]
  [Category('Integration')]
  TRickUIBuilderEditVisualStateTests = class
  private
    FHost: TForm;
    FEdit: IRickUIBuilderEdit;
    procedure ConfigureColors;
    procedure BuildEdit;
    procedure TriggerEnter;
    procedure TriggerExit;
    function MainLabel: TObject;
    function LineControl: TObject;
    procedure AssertVisual(AFill, ABorder, ALabel, ALine, AEditText: TAlphaColor);
  public
    [Setup] procedure Setup;
    [TearDown] procedure TearDown;
    [Test] procedure Normal_DeveAplicarValoresConfigurados;
    [Test] procedure Focus_DeveAplicarERestaurarCores;
    [Test] procedure Invalid_DeveAplicarCoresDeEstado;
    [Test] procedure ReadOnly_DeveAplicarCoresDeEstado;
    [Test] procedure Estados_DevemRespeitarPrecedenciaPorContrato;
    [Test] procedure Build_InterfaceLiberada_DeveManterHandlerVisualAtivo;
  end;

implementation

uses
  FMX.Edit,
  FMX.Objects,
  FMX.StdCtrls,
  FMX.Types,

  Rick.UIBuilder.Edit.Builder;

const
  _NORMAL_COLOR_: TAlphaColor = $FF112233;
  _FOCUS_COLOR_: TAlphaColor = $FF2255AA;
  _INVALID_COLOR_: TAlphaColor = $FFCC3344;
  _READ_ONLY_COLOR_: TAlphaColor = $FF8899AA;
  _LINE_THICKNESS_: Single = 3;
  _MAIN_TEXT_ = 'Main label';

procedure TRickUIBuilderEditVisualStateTests.Setup;
begin
  FHost := TForm.CreateNew(nil);
  FEdit := TRickUIBuilderEdit.New;
end;

procedure TRickUIBuilderEditVisualStateTests.TearDown;
begin
  FEdit := nil;
  FHost.Free;
  FHost := nil;
end;

procedure TRickUIBuilderEditVisualStateTests.ConfigureColors;
var
  LMainColor: IRickUIBuilderEditLabelMainTextColor;
begin
  FEdit.Rectangle.Background.Normal(_NORMAL_COLOR_).Invalid(_INVALID_COLOR_).ReadOnly(_READ_ONLY_COLOR_);
  FEdit.Rectangle.Border.Normal(_NORMAL_COLOR_).Focus(_FOCUS_COLOR_).Invalid(_INVALID_COLOR_).ReadOnly(_READ_ONLY_COLOR_);
  FEdit.Labels.Main.Text.Value(_MAIN_TEXT_);
  LMainColor := FEdit.Labels.Main.Text.Color;
  LMainColor.Text(_NORMAL_COLOR_);
  LMainColor.Invalid(_INVALID_COLOR_);
  LMainColor.ReadOnly(_READ_ONLY_COLOR_);
  FEdit.Designer.Input.Text.Color.Text(_NORMAL_COLOR_).ReadOnly(_READ_ONLY_COLOR_);
  FEdit.Line.Thickness(_LINE_THICKNESS_);
  FEdit.Line.Color.Normal(_NORMAL_COLOR_).Focus(_FOCUS_COLOR_).Invalid(_INVALID_COLOR_).ReadOnly(_READ_ONLY_COLOR_);
end;

procedure TRickUIBuilderEditVisualStateTests.BuildEdit;
begin
  FEdit.Parent(FHost).Build;
end;

function TRickUIBuilderEditVisualStateTests.MainLabel: TObject;
var
  LChild: TFmxObject;
  LIndex: Integer;
begin
  Result := nil;
  for LIndex := 0 to FEdit.Rectangle.Control.ChildrenCount - 1 do
  begin
    LChild := FEdit.Rectangle.Control.Children[LIndex];
    if (LChild is TLabel) and (TLabel(LChild).Text = _MAIN_TEXT_) then
      Exit(LChild);
  end;
end;

function TRickUIBuilderEditVisualStateTests.LineControl: TObject;
var
  LChild: TFmxObject;
  LIndex: Integer;
begin
  Result := nil;
  for LIndex := 0 to FEdit.Rectangle.Control.ChildrenCount - 1 do
  begin
    LChild := FEdit.Rectangle.Control.Children[LIndex];
    if (LChild is TRectangle) and (TRectangle(LChild).Height = _LINE_THICKNESS_) then
      Exit(LChild);
  end;
end;

procedure TRickUIBuilderEditVisualStateTests.TriggerEnter;
var
  LControl: TEdit;
begin
  LControl := FEdit.Designer.Control;
  Assert.IsTrue(Assigned(LControl.OnEnter));
  LControl.OnEnter(LControl);
end;

procedure TRickUIBuilderEditVisualStateTests.TriggerExit;
var
  LControl: TEdit;
begin
  LControl := FEdit.Designer.Control;
  Assert.IsTrue(Assigned(LControl.OnExit));
  LControl.OnExit(LControl);
end;

procedure TRickUIBuilderEditVisualStateTests.AssertVisual(AFill, ABorder, ALabel, ALine, AEditText: TAlphaColor);
var
  LLabel: TLabel;
  LLine: TRectangle;
begin
  LLabel := TLabel(MainLabel);
  LLine := TRectangle(LineControl);
  Assert.IsNotNull(LLabel);
  Assert.IsNotNull(LLine);
  Assert.AreEqual<TAlphaColor>(AFill, FEdit.Rectangle.Control.Fill.Color);
  Assert.AreEqual<TAlphaColor>(ABorder, FEdit.Rectangle.Control.Stroke.Color);
  Assert.AreEqual<TAlphaColor>(ALabel, LLabel.TextSettings.FontColor);
  Assert.AreEqual<TAlphaColor>(ALine, LLine.Fill.Color);
  Assert.AreEqual<TAlphaColor>(AEditText, FEdit.Designer.Control.TextSettings.FontColor);
end;

procedure TRickUIBuilderEditVisualStateTests.Normal_DeveAplicarValoresConfigurados;
begin
  ConfigureColors;
  BuildEdit;
  AssertVisual(_NORMAL_COLOR_, _NORMAL_COLOR_, _NORMAL_COLOR_, _NORMAL_COLOR_, _NORMAL_COLOR_);
end;

procedure TRickUIBuilderEditVisualStateTests.Focus_DeveAplicarERestaurarCores;
begin
  ConfigureColors;
  BuildEdit;
  TriggerEnter;
  AssertVisual(_NORMAL_COLOR_, _FOCUS_COLOR_, _NORMAL_COLOR_, _FOCUS_COLOR_, _NORMAL_COLOR_);
  TriggerExit;
  AssertVisual(_NORMAL_COLOR_, _NORMAL_COLOR_, _NORMAL_COLOR_, _NORMAL_COLOR_, _NORMAL_COLOR_);
end;

procedure TRickUIBuilderEditVisualStateTests.Invalid_DeveAplicarCoresDeEstado;
begin
  ConfigureColors;
  FEdit.Designer.Validation.Invalid(True);
  BuildEdit;
  AssertVisual(_INVALID_COLOR_, _INVALID_COLOR_, _INVALID_COLOR_, _INVALID_COLOR_, _NORMAL_COLOR_);
end;

procedure TRickUIBuilderEditVisualStateTests.ReadOnly_DeveAplicarCoresDeEstado;
begin
  ConfigureColors;
  FEdit.Designer.Config.ReadOnly(True);
  BuildEdit;
  AssertVisual(_READ_ONLY_COLOR_, _READ_ONLY_COLOR_, _READ_ONLY_COLOR_, _READ_ONLY_COLOR_, _READ_ONLY_COLOR_);
end;

procedure TRickUIBuilderEditVisualStateTests.Estados_DevemRespeitarPrecedenciaPorContrato;
begin
  ConfigureColors;
  BuildEdit;
  TriggerEnter;
  FEdit.Designer.Config.ReadOnly(True);
  FEdit.Designer.Validation.Invalid(True);
  AssertVisual(_INVALID_COLOR_, _INVALID_COLOR_, _INVALID_COLOR_, _INVALID_COLOR_, _READ_ONLY_COLOR_);
  FEdit.Designer.Validation.Invalid(False);
  AssertVisual(_READ_ONLY_COLOR_, _READ_ONLY_COLOR_, _READ_ONLY_COLOR_, _READ_ONLY_COLOR_, _READ_ONLY_COLOR_);
  FEdit.Designer.Config.ReadOnly(False);
  AssertVisual(_NORMAL_COLOR_, _FOCUS_COLOR_, _NORMAL_COLOR_, _FOCUS_COLOR_, _NORMAL_COLOR_);
end;

procedure TRickUIBuilderEditVisualStateTests.Build_InterfaceLiberada_DeveManterHandlerVisualAtivo;
var
  LControl: TEdit;
  LRoot: TRectangle;
begin
  ConfigureColors;
  BuildEdit;
  LControl := FEdit.Designer.Control;
  LRoot := FEdit.Rectangle.Control;
  FEdit := nil;
  Assert.IsTrue(Assigned(LControl.OnEnter));
  LControl.OnEnter(LControl);
  Assert.AreEqual<TAlphaColor>(_FOCUS_COLOR_, LRoot.Stroke.Color);
  Assert.IsTrue(LRoot.Parent = FHost);
end;

initialization
  TDUnitX.RegisterTestFixture(TRickUIBuilderEditVisualStateTests);

end.
