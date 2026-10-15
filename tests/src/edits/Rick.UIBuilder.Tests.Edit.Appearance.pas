unit Rick.UIBuilder.Tests.Edit.Appearance;

{$SCOPEDENUMS ON}

interface

uses
  DUnitX.TestFramework,
  FMX.Forms,
  FMX.Objects,
  System.UITypes,

  Rick.UIBuilder.Edit.Interfaces;

type
  [TestFixture]
  [Category('Integration')]
  TRickUIBuilderEditAppearanceTests = class
  private
    FHost: TForm;
    FEdit: IRickUIBuilderEdit;
    procedure ConfigureUnderline;
    procedure BuildEdit;
    function UnderlineControl: TRectangle;
    procedure TriggerEnter;
    procedure TriggerExit;
    procedure AssertUnderline(AColor: TAlphaColor);
  public
    [Setup] procedure Setup;
    [TearDown] procedure TearDown;
    [Test] procedure Outlined_PadraoDeveExibirBordaEOcultarLinha;
    [Test] procedure Underline_DeveOcultarBordaEExibirLinhaNormal;
    [Test] procedure Underline_ThicknessDeveDefinirAlturaDaLinha;
    [Test] procedure Underline_FocusDeveUsarCorDeFocoERestaurarNormal;
    [Test] procedure Underline_InvalidDevePrevalecerAoEntrarESair;
    [Test] procedure Underline_EstadosDevemRespeitarPrecedenciaDoLegado;
  end;

implementation

uses
  FMX.Edit,
  FMX.Graphics,
  FMX.Types,

  Rick.UIBuilder.Edit.Builder,
  Rick.UIBuilder.Edit.Types;

const
  _UNDERLINE_THICKNESS_: Single = 4;
  _NORMAL_COLOR_: TAlphaColor = $FF112233;
  _FOCUS_COLOR_: TAlphaColor = $FF2255AA;
  _INVALID_COLOR_: TAlphaColor = $FFCC3344;
  _READ_ONLY_COLOR_: TAlphaColor = $FF8899AA;

procedure TRickUIBuilderEditAppearanceTests.Setup;
begin
  FHost := TForm.CreateNew(nil);
  FEdit := TRickUIBuilderEdit.New;
end;

procedure TRickUIBuilderEditAppearanceTests.TearDown;
begin
  FEdit := nil;
  FHost.Free;
  FHost := nil;
end;

procedure TRickUIBuilderEditAppearanceTests.ConfigureUnderline;
begin
  FEdit.Config.Appearance(TRickUIBuilderEditAppearance.Underline);
  FEdit.Line.Thickness(_UNDERLINE_THICKNESS_);
  FEdit.Line.Color
    .Normal(_NORMAL_COLOR_)
    .Focus(_FOCUS_COLOR_)
    .Invalid(_INVALID_COLOR_)
    .ReadOnly(_READ_ONLY_COLOR_);
end;

procedure TRickUIBuilderEditAppearanceTests.BuildEdit;
begin
  FEdit.Parent(FHost).Build;
end;

function TRickUIBuilderEditAppearanceTests.UnderlineControl: TRectangle;
var
  LChild: TFmxObject;
  LIndex: Integer;
begin
  Result := nil;
  for LIndex := 0 to FEdit.Rectangle.Control.ChildrenCount - 1 do
  begin
    LChild := FEdit.Rectangle.Control.Children[LIndex];
    if (LChild is TRectangle) and
      (TRectangle(LChild).Height = _UNDERLINE_THICKNESS_) then
      Exit(TRectangle(LChild));
  end;
end;

procedure TRickUIBuilderEditAppearanceTests.TriggerEnter;
var
  LControl: TEdit;
begin
  LControl := FEdit.Designer.Control;
  Assert.IsTrue(Assigned(LControl.OnEnter));
  LControl.OnEnter(LControl);
end;

procedure TRickUIBuilderEditAppearanceTests.TriggerExit;
var
  LControl: TEdit;
begin
  LControl := FEdit.Designer.Control;
  Assert.IsTrue(Assigned(LControl.OnExit));
  LControl.OnExit(LControl);
end;

procedure TRickUIBuilderEditAppearanceTests.AssertUnderline(
  AColor: TAlphaColor);
var
  LLine: TRectangle;
begin
  LLine := UnderlineControl;
  Assert.IsNotNull(LLine);
  Assert.IsTrue(LLine.Visible);
  Assert.AreEqual<Single>(_UNDERLINE_THICKNESS_, LLine.Height);
  Assert.AreEqual<TAlphaColor>(AColor, LLine.Fill.Color);
  Assert.AreEqual(Integer(TBrushKind.None),
    Integer(FEdit.Rectangle.Control.Stroke.Kind));
end;

procedure TRickUIBuilderEditAppearanceTests.
  Outlined_PadraoDeveExibirBordaEOcultarLinha;
var
  LLine: TRectangle;
begin
  FEdit.Line.Thickness(_UNDERLINE_THICKNESS_);
  BuildEdit;
  LLine := UnderlineControl;
  Assert.IsNotNull(LLine);
  Assert.IsFalse(LLine.Visible);
  Assert.AreNotEqual(Integer(TBrushKind.None),
    Integer(FEdit.Rectangle.Control.Stroke.Kind));
end;

procedure TRickUIBuilderEditAppearanceTests.
  Underline_DeveOcultarBordaEExibirLinhaNormal;
begin
  ConfigureUnderline;
  BuildEdit;
  AssertUnderline(_NORMAL_COLOR_);
end;

procedure TRickUIBuilderEditAppearanceTests.
  Underline_ThicknessDeveDefinirAlturaDaLinha;
var
  LLine: TRectangle;
begin
  ConfigureUnderline;
  BuildEdit;
  LLine := UnderlineControl;
  Assert.IsNotNull(LLine);
  Assert.IsTrue(LLine.Visible);
  Assert.AreEqual<Single>(_UNDERLINE_THICKNESS_, LLine.Height);
end;

procedure TRickUIBuilderEditAppearanceTests.
  Underline_FocusDeveUsarCorDeFocoERestaurarNormal;
begin
  ConfigureUnderline;
  BuildEdit;
  TriggerEnter;
  AssertUnderline(_FOCUS_COLOR_);
  TriggerExit;
  AssertUnderline(_NORMAL_COLOR_);
end;

procedure TRickUIBuilderEditAppearanceTests.
  Underline_InvalidDevePrevalecerAoEntrarESair;
begin
  ConfigureUnderline;
  BuildEdit;
  TriggerEnter;
  FEdit.Designer.Validation.Invalid(True);
  AssertUnderline(_INVALID_COLOR_);
  TriggerExit;
  AssertUnderline(_INVALID_COLOR_);
  FEdit.Designer.Validation.Invalid(False);
  AssertUnderline(_NORMAL_COLOR_);
end;

procedure TRickUIBuilderEditAppearanceTests.
  Underline_EstadosDevemRespeitarPrecedenciaDoLegado;
begin
  ConfigureUnderline;
  BuildEdit;
  TriggerEnter;
  FEdit.Designer.Config.ReadOnly(True);
  FEdit.Designer.Validation.Invalid(True);
  AssertUnderline(_INVALID_COLOR_);
  FEdit.Designer.Validation.Invalid(False);
  AssertUnderline(_READ_ONLY_COLOR_);
  FEdit.Designer.Config.ReadOnly(False);
  AssertUnderline(_FOCUS_COLOR_);
end;

initialization
  TDUnitX.RegisterTestFixture(TRickUIBuilderEditAppearanceTests);

end.
