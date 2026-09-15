unit Rick.UIBuilder.Tests.Divider;
(*
  ==============================================================================
  Unit: Rick.UIBuilder.Tests.Divider
  ==============================================================================

  RESPONSABILIDADE

  Testes para TRickUIBuilderDividerBuilder (IRickUIBuilderDivider),
  divididos em duas categorias:

  - TRickUIBuilderDividerChainingTests: unitario puro. Valida apenas
    que cada metodo encadeado retorna a mesma instancia do builder
    (sem depender de host FMX, sem chamar Build).

  - TRickUIBuilderDividerBuildTests: integracao (Category('Integration')).
    Exige um TForm host e valida o TRectangle efetivamente criado por
    Build, incluindo o comportamento de Thickness/Orientation.

  ==============================================================================
*)

interface

uses
  DUnitX.TestFramework,
  System.UITypes,
  FMX.Forms, FMX.Types, FMX.Objects,
  Rick.UIBuilder.Types,
  Rick.UIBuilder.Interfaces,
  Rick.UIBuilder.Divider;

type
  [TestFixture]
  TRickUIBuilderDividerChainingTests = class
  public
    [Test]
    procedure Position_DeveRetornarAMesmaInstancia;
    [Test]
    procedure Width_DeveRetornarAMesmaInstancia;
    [Test]
    procedure Thickness_DeveRetornarAMesmaInstancia;
    [Test]
    procedure Orientation_DeveRetornarAMesmaInstancia;
    [Test]
    procedure Color_DeveRetornarAMesmaInstancia;
    [Test]
    procedure Build_DevePermitirEncadeamentoCompletoAntesDeChamarBuild;
  end;

  [TestFixture]
  [Category('Integration')]
  TRickUIBuilderDividerBuildTests = class
  private
    FHostForm: TForm;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure Build_DeveCriarComponenteDoTipoTRectangle;
    [Test]
    procedure Build_DeveDefinirParentCorretamente;
    [Test]
    procedure Build_DevePosicionarNasCoordenadasInformadas;
    [Test]
    procedure Build_DeveAplicarMarginDeslocandoPosicaoFinal;
    [Test]
    procedure Build_DeveAplicarCorInformada;
    [Test]
    procedure Build_OrientationHorizontal_DeveUsarWidthComoComprimentoEThicknessComoAltura;
    [Test]
    procedure Build_OrientationVertical_DeveInverterWidthEHeight;
    [Test]
    procedure Build_DeveUsarThicknessPadraoDeUmPixelQuandoNaoInformado;
    [Test]
    procedure Build_DeveAplicarVisibleInformado;
  end;

implementation

uses
  FMX.Controls;

{ TRickUIBuilderDividerChainingTests }

procedure TRickUIBuilderDividerChainingTests.Position_DeveRetornarAMesmaInstancia;
var
  LBuilder: IRickUIBuilderDivider;
  LResult: IRickUIBuilderDivider;
begin
  LBuilder := TRickUIBuilderDividerBuilder.New;
  LResult  := LBuilder.Position(0, 89);

  Assert.AreEqual<IRickUIBuilderDivider>(LBuilder, LResult,
    'Position deveria retornar a mesma instancia do builder.');
end;

procedure TRickUIBuilderDividerChainingTests.Width_DeveRetornarAMesmaInstancia;
var
  LBuilder: IRickUIBuilderDivider;
  LResult: IRickUIBuilderDivider;
begin
  LBuilder := TRickUIBuilderDividerBuilder.New;
  LResult  := LBuilder.Width(385);

  Assert.AreEqual<IRickUIBuilderDivider>(LBuilder, LResult,
    'Width deveria retornar a mesma instancia do builder.');
end;

procedure TRickUIBuilderDividerChainingTests.Thickness_DeveRetornarAMesmaInstancia;
var
  LBuilder: IRickUIBuilderDivider;
  LResult: IRickUIBuilderDivider;
begin
  LBuilder := TRickUIBuilderDividerBuilder.New;
  LResult  := LBuilder.Thickness(2);

  Assert.AreEqual<IRickUIBuilderDivider>(LBuilder, LResult,
    'Thickness deveria retornar a mesma instancia do builder.');
end;

procedure TRickUIBuilderDividerChainingTests.Orientation_DeveRetornarAMesmaInstancia;
var
  LBuilder: IRickUIBuilderDivider;
  LResult: IRickUIBuilderDivider;
begin
  LBuilder := TRickUIBuilderDividerBuilder.New;
  LResult  := LBuilder.Orientation(TOrientation.Vertical);

  Assert.AreEqual<IRickUIBuilderDivider>(LBuilder, LResult,
    'Orientation deveria retornar a mesma instancia do builder.');
end;

procedure TRickUIBuilderDividerChainingTests.Color_DeveRetornarAMesmaInstancia;
var
  LBuilder: IRickUIBuilderDivider;
  LResult: IRickUIBuilderDivider;
begin
  LBuilder := TRickUIBuilderDividerBuilder.New;
  LResult  := LBuilder.Color(TAlphaColors.Gray);

  Assert.AreEqual<IRickUIBuilderDivider>(LBuilder, LResult,
    'Color deveria retornar a mesma instancia do builder.');
end;

procedure TRickUIBuilderDividerChainingTests.Build_DevePermitirEncadeamentoCompletoAntesDeChamarBuild;
var
  LBuilder: IRickUIBuilderDivider;
begin
  // Garante que a cadeia inteira compila e nao lanca excecao antes do
  // Build ser chamado - nenhum metodo aqui deveria exigir host FMX.
  LBuilder := TRickUIBuilderDividerBuilder.New
    .Position(21, 266)
    .Width(385)
    .Thickness(1)
    .Orientation(TOrientation.Horizontal)
    .Margin(TRickUIBuilderSpacing.None)
    .Color(TAlphaColors.Lightgray)
    .Opacity(1)
    .Visible(True);

  Assert.IsNotNull(LBuilder, 'O encadeamento completo nao deveria retornar nil.');
end;

{ TRickUIBuilderDividerBuildTests }

procedure TRickUIBuilderDividerBuildTests.Setup;
begin
  FHostForm := TForm.CreateNew(nil);
end;

procedure TRickUIBuilderDividerBuildTests.TearDown;
begin
  FHostForm.Free;
end;

procedure TRickUIBuilderDividerBuildTests.Build_DeveCriarComponenteDoTipoTRectangle;
var
  LDivider: TRectangle;
begin
  LDivider := TRickUIBuilderDividerBuilder.New.Build(FHostForm);

  Assert.IsNotNull(LDivider, 'O Build nao deveria retornar nil.');
  Assert.IsTrue(LDivider is TRectangle, 'O componente criado deveria ser TRectangle.');
end;

procedure TRickUIBuilderDividerBuildTests.Build_DeveDefinirParentCorretamente;
var
  LDivider: TRectangle;
begin
  LDivider := TRickUIBuilderDividerBuilder.New.Build(FHostForm);

  Assert.AreEqual<TFmxObject>(FHostForm, LDivider.Parent,
    'O Parent do divisor deveria ser o form host informado no Build.');
end;

procedure TRickUIBuilderDividerBuildTests.Build_DevePosicionarNasCoordenadasInformadas;
var
  LDivider: TRectangle;
begin
  LDivider := TRickUIBuilderDividerBuilder.New
    .Position(21, 266)
    .Build(FHostForm);

  Assert.AreEqual<Single>(21, LDivider.Position.X, 'Posicao X incorreta.');
  Assert.AreEqual<Single>(266, LDivider.Position.Y, 'Posicao Y incorreta.');
end;

procedure TRickUIBuilderDividerBuildTests.Build_DeveAplicarMarginDeslocandoPosicaoFinal;
var
  LDivider: TRectangle;
begin
  LDivider := TRickUIBuilderDividerBuilder.New
    .Position(10, 10)
    .Margin(TRickUIBuilderSpacing.Uniform(5))
    .Build(FHostForm);

  Assert.AreEqual<Single>(15, LDivider.Position.X,
    'Margin.Left nao foi somado a Position.X.');
  Assert.AreEqual<Single>(15, LDivider.Position.Y,
    'Margin.Top nao foi somado a Position.Y.');
end;

procedure TRickUIBuilderDividerBuildTests.Build_DeveAplicarCorInformada;
var
  LDivider: TRectangle;
begin
  LDivider := TRickUIBuilderDividerBuilder.New
    .Color(TAlphaColors.Gray)
    .Build(FHostForm);

  Assert.AreEqual<TAlphaColor>(TAlphaColors.Gray, LDivider.Fill.Color,
    'Cor do divisor incorreta.');
end;

procedure TRickUIBuilderDividerBuildTests.Build_OrientationHorizontal_DeveUsarWidthComoComprimentoEThicknessComoAltura;
var
  LDivider: TRectangle;
begin
  LDivider := TRickUIBuilderDividerBuilder.New
    .Width(385)
    .Thickness(2)
    .Orientation(TOrientation.Horizontal)
    .Build(FHostForm);

  Assert.AreEqual<Single>(385, LDivider.Width,
    'Width deveria ser o comprimento informado quando Horizontal.');
  Assert.AreEqual<Single>(2, LDivider.Height,
    'Height deveria ser a Thickness informada quando Horizontal.');
end;

procedure TRickUIBuilderDividerBuildTests.Build_OrientationVertical_DeveInverterWidthEHeight;
var
  LDivider: TRectangle;
begin
  LDivider := TRickUIBuilderDividerBuilder.New
    .Width(200)
    .Thickness(2)
    .Orientation(TOrientation.Vertical)
    .Build(FHostForm);

  // Ver <remarks> de IRickUIBuilderDivider.Orientation: quando
  // Vertical, Width vira a altura do controle e Thickness vira a
  // largura.
  Assert.AreEqual<Single>(2, LDivider.Width,
    'Width do controle deveria ser a Thickness quando Vertical.');
  Assert.AreEqual<Single>(200, LDivider.Height,
    'Height do controle deveria ser o Width informado quando Vertical.');
end;

procedure TRickUIBuilderDividerBuildTests.Build_DeveUsarThicknessPadraoDeUmPixelQuandoNaoInformado;
var
  LDivider: TRectangle;
begin
  LDivider := TRickUIBuilderDividerBuilder.New
    .Width(385)
    .Build(FHostForm);

  Assert.AreEqual<Single>(1, LDivider.Height,
    'Thickness padrao deveria ser 1px quando Thickness nao e chamado.');
end;

procedure TRickUIBuilderDividerBuildTests.Build_DeveAplicarVisibleInformado;
var
  LDivider: TRectangle;
begin
  LDivider := TRickUIBuilderDividerBuilder.New
    .Visible(False)
    .Build(FHostForm);

  Assert.IsFalse(LDivider.Visible, 'Visible(False) nao foi aplicado.');
end;

initialization
  TDUnitX.RegisterTestFixture(TRickUIBuilderDividerChainingTests);
  TDUnitX.RegisterTestFixture(TRickUIBuilderDividerBuildTests);

end.
