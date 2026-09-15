unit Rick.UIBuilder.Tests.Badge;
(*
  ==============================================================================
  Unit: Rick.UIBuilder.Tests.Badge
  ==============================================================================

  RESPONSABILIDADE

  Testes para TRickUIBuilderBadgeBuilder (IRickUIBuilderBadge) e
  TRickUIBuilderBadgeHandle (IRickUIBuilderBadgeHandle), divididos em
  duas categorias:

  - TRickUIBuilderBadgeChainingTests: unitario puro. Valida apenas que
    cada metodo encadeado retorna a mesma instancia do builder (sem
    depender de host FMX, sem chamar Build).

  - TRickUIBuilderBadgeBuildTests: integracao (Category('Integration')).
    Exige um TForm host e valida o Container e o TextLabel
    efetivamente criados por Build, como dois objetos distintos.

  ==============================================================================
*)

interface

uses
  DUnitX.TestFramework,
  System.UITypes,
  FMX.Forms, FMX.Types, FMX.Controls, FMX.Objects, FMX.StdCtrls,
  Rick.UIBuilder.Types,
  Rick.UIBuilder.Interfaces,
  Rick.UIBuilder.Badge,
  Rick.UIBuilder.Badge.Handle;

type
  [TestFixture]
  TRickUIBuilderBadgeChainingTests = class
  public
    [Test]
    procedure Text_DeveRetornarAMesmaInstancia;
    [Test]
    procedure Position_DeveRetornarAMesmaInstancia;
    [Test]
    procedure Pill_DeveRetornarAMesmaInstancia;
    [Test]
    procedure BackgroundColor_DeveRetornarAMesmaInstancia;
    [Test]
    procedure Margin_DeveRetornarAMesmaInstancia;
    [Test]
    procedure Build_DevePermitirEncadeamentoCompletoAntesDeChamarBuild;
  end;

  [TestFixture]
  [Category('Integration')]
  TRickUIBuilderBadgeBuildTests = class
  private
    FHostForm: TForm;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure Build_DeveRetornarHandleNaoNulo;
    [Test]
    procedure Build_ContainerDeveSerDoTipoTRectangle;
    [Test]
    procedure Build_TextLabelDeveSerDoTipoTLabel;
    [Test]
    procedure Build_ContainerETextLabelDevemSerObjetosDistintos;
    [Test]
    procedure Build_TextLabelDeveTerContainerComoParent;
    [Test]
    procedure Build_ContainerDeveTerParentInformado;
    [Test]
    procedure Build_DeveAplicarTextoNoTextLabel;
    [Test]
    procedure Build_DevePosicionarNasCoordenadasInformadas;
    [Test]
    procedure Build_DeveAplicarMarginDeslocandoPosicaoFinal;
    [Test]
    procedure Build_PillTrue_DeveAplicarRaioIgualAMetadeDaHeight;
    [Test]
    procedure Build_PillFalse_DeveAplicarCornerRadiusInformado;
    [Test]
    procedure Build_DeveAplicarBackgroundColorInformada;
    [Test]
    procedure Build_DeveAplicarBorderColorQuandoInformada;
    [Test]
    procedure Build_NaoDeveAplicarBordaQuandoBorderColorForNull;
    [Test]
    procedure Build_DeveAplicarTagNoContainer;
  end;

implementation

uses
  FMX.Graphics;

{ TRickUIBuilderBadgeChainingTests }

procedure TRickUIBuilderBadgeChainingTests.Text_DeveRetornarAMesmaInstancia;
var
  LBuilder: IRickUIBuilderBadge;
  LResult: IRickUIBuilderBadge;
begin
  LBuilder := TRickUIBuilderBadgeBuilder.New;
  LResult  := LBuilder.Text('Ativo');

  Assert.AreEqual<IRickUIBuilderBadge>(LBuilder, LResult,
    'Text deveria retornar a mesma instancia do builder.');
end;

procedure TRickUIBuilderBadgeChainingTests.Position_DeveRetornarAMesmaInstancia;
var
  LBuilder: IRickUIBuilderBadge;
  LResult: IRickUIBuilderBadge;
begin
  LBuilder := TRickUIBuilderBadgeBuilder.New;
  LResult  := LBuilder.Position(300, 113);

  Assert.AreEqual<IRickUIBuilderBadge>(LBuilder, LResult,
    'Position deveria retornar a mesma instancia do builder.');
end;

procedure TRickUIBuilderBadgeChainingTests.Pill_DeveRetornarAMesmaInstancia;
var
  LBuilder: IRickUIBuilderBadge;
  LResult: IRickUIBuilderBadge;
begin
  LBuilder := TRickUIBuilderBadgeBuilder.New;
  LResult  := LBuilder.Pill(True);

  Assert.AreEqual<IRickUIBuilderBadge>(LBuilder, LResult,
    'Pill deveria retornar a mesma instancia do builder.');
end;

procedure TRickUIBuilderBadgeChainingTests.BackgroundColor_DeveRetornarAMesmaInstancia;
var
  LBuilder: IRickUIBuilderBadge;
  LResult: IRickUIBuilderBadge;
begin
  LBuilder := TRickUIBuilderBadgeBuilder.New;
  LResult  := LBuilder.BackgroundColor(TAlphaColors.Green);

  Assert.AreEqual<IRickUIBuilderBadge>(LBuilder, LResult,
    'BackgroundColor deveria retornar a mesma instancia do builder.');
end;

procedure TRickUIBuilderBadgeChainingTests.Margin_DeveRetornarAMesmaInstancia;
var
  LBuilder: IRickUIBuilderBadge;
  LResult: IRickUIBuilderBadge;
begin
  LBuilder := TRickUIBuilderBadgeBuilder.New;
  LResult  := LBuilder.Margin(TRickUIBuilderSpacing.Uniform(4));

  Assert.AreEqual<IRickUIBuilderBadge>(LBuilder, LResult,
    'Margin deveria retornar a mesma instancia do builder.');
end;

procedure TRickUIBuilderBadgeChainingTests.Build_DevePermitirEncadeamentoCompletoAntesDeChamarBuild;
var
  LBuilder: IRickUIBuilderBadge;
begin
  // Garante que a cadeia inteira compila e nao lanca excecao antes do
  // Build ser chamado - nenhum metodo aqui deveria exigir host FMX.
  LBuilder := TRickUIBuilderBadgeBuilder.New
    .Text('Executando')
    .Position(300, 113)
    .Size(110, 27)
    .Pill(True)
    .Margin(TRickUIBuilderSpacing.None)
    .Padding(TRickUIBuilderSpacing.Uniform(4))
    .BackgroundColor(TAlphaColors.Green)
    .TextColor(TAlphaColors.White)
    .FontSize(14)
    .Bold(True)
    .Tag(1);

  Assert.IsNotNull(LBuilder, 'O encadeamento completo nao deveria retornar nil.');
end;

{ TRickUIBuilderBadgeBuildTests }

procedure TRickUIBuilderBadgeBuildTests.Setup;
begin
  FHostForm := TForm.CreateNew(nil);
end;

procedure TRickUIBuilderBadgeBuildTests.TearDown;
begin
  FHostForm.Free;
end;

procedure TRickUIBuilderBadgeBuildTests.Build_DeveRetornarHandleNaoNulo;
var
  LHandle: IRickUIBuilderBadgeHandle;
begin
  LHandle := TRickUIBuilderBadgeBuilder.New
    .Text('Ativo')
    .Build(FHostForm);

  Assert.IsNotNull(LHandle, 'Build nao deveria retornar um handle nulo.');
end;

procedure TRickUIBuilderBadgeBuildTests.Build_ContainerDeveSerDoTipoTRectangle;
var
  LHandle: IRickUIBuilderBadgeHandle;
begin
  LHandle := TRickUIBuilderBadgeBuilder.New
    .Text('Ativo')
    .Build(FHostForm);

  Assert.IsNotNull(LHandle.Container, 'Container nao deveria ser nil.');
  Assert.IsTrue(LHandle.Container is TRectangle,
    'O Container deveria ser TRectangle.');
end;

procedure TRickUIBuilderBadgeBuildTests.Build_TextLabelDeveSerDoTipoTLabel;
var
  LHandle: IRickUIBuilderBadgeHandle;
begin
  LHandle := TRickUIBuilderBadgeBuilder.New
    .Text('Ativo')
    .Build(FHostForm);

  Assert.IsNotNull(LHandle.TextLabel, 'TextLabel nao deveria ser nil.');
  Assert.IsTrue(LHandle.TextLabel is TLabel,
    'O TextLabel deveria ser TLabel.');
end;

procedure TRickUIBuilderBadgeBuildTests.Build_ContainerETextLabelDevemSerObjetosDistintos;
var
  LHandle: IRickUIBuilderBadgeHandle;
begin
  LHandle := TRickUIBuilderBadgeBuilder.New
    .Text('Ativo')
    .Build(FHostForm);

  Assert.AreNotEqual<TFmxObject>(LHandle.Container, LHandle.TextLabel,
    'Container e TextLabel deveriam ser dois objetos distintos.');
end;

procedure TRickUIBuilderBadgeBuildTests.Build_TextLabelDeveTerContainerComoParent;
var
  LHandle: IRickUIBuilderBadgeHandle;
begin
  LHandle := TRickUIBuilderBadgeBuilder.New
    .Text('Ativo')
    .Build(FHostForm);

  Assert.AreEqual<TFmxObject>(LHandle.Container, LHandle.TextLabel.Parent,
    'O Parent do TextLabel deveria ser o Container do Badge.');
end;

procedure TRickUIBuilderBadgeBuildTests.Build_ContainerDeveTerParentInformado;
var
  LHandle: IRickUIBuilderBadgeHandle;
begin
  LHandle := TRickUIBuilderBadgeBuilder.New
    .Text('Ativo')
    .Build(FHostForm);

  Assert.AreEqual<TFmxObject>(FHostForm, LHandle.Container.Parent,
    'O Parent do Container deveria ser o form host informado no Build.');
end;

procedure TRickUIBuilderBadgeBuildTests.Build_DeveAplicarTextoNoTextLabel;
var
  LHandle: IRickUIBuilderBadgeHandle;
begin
  LHandle := TRickUIBuilderBadgeBuilder.New
    .Text('Executando')
    .Build(FHostForm);

  Assert.AreEqual('Executando', LHandle.TextLabel.Text,
    'Texto do Badge incorreto.');
end;

procedure TRickUIBuilderBadgeBuildTests.Build_DevePosicionarNasCoordenadasInformadas;
var
  LHandle: IRickUIBuilderBadgeHandle;
begin
  LHandle := TRickUIBuilderBadgeBuilder.New
    .Text('Ativo')
    .Position(300, 113)
    .Build(FHostForm);

  Assert.AreEqual<Single>(300, LHandle.Container.Position.X, 'Posicao X incorreta.');
  Assert.AreEqual<Single>(113, LHandle.Container.Position.Y, 'Posicao Y incorreta.');
end;

procedure TRickUIBuilderBadgeBuildTests.Build_DeveAplicarMarginDeslocandoPosicaoFinal;
var
  LHandle: IRickUIBuilderBadgeHandle;
begin
  LHandle := TRickUIBuilderBadgeBuilder.New
    .Text('Ativo')
    .Position(10, 10)
    .Margin(TRickUIBuilderSpacing.Uniform(5))
    .Build(FHostForm);

  Assert.AreEqual<Single>(15, LHandle.Container.Position.X,
    'Margin.Left nao foi somado a Position.X.');
  Assert.AreEqual<Single>(15, LHandle.Container.Position.Y,
    'Margin.Top nao foi somado a Position.Y.');
end;

procedure TRickUIBuilderBadgeBuildTests.Build_PillTrue_DeveAplicarRaioIgualAMetadeDaHeight;
var
  LHandle: IRickUIBuilderBadgeHandle;
begin
  LHandle := TRickUIBuilderBadgeBuilder.New
    .Text('Ativo')
    .Size(110, 27)
    .Pill(True)
    .Build(FHostForm);

  Assert.AreEqual<Single>(13.5, LHandle.Container.XRadius,
    'XRadius deveria ser Height/2 quando Pill e True.');
  Assert.AreEqual<Single>(13.5, LHandle.Container.YRadius,
    'YRadius deveria ser Height/2 quando Pill e True.');
end;

procedure TRickUIBuilderBadgeBuildTests.Build_PillFalse_DeveAplicarCornerRadiusInformado;
var
  LHandle: IRickUIBuilderBadgeHandle;
begin
  LHandle := TRickUIBuilderBadgeBuilder.New
    .Text('Ativo')
    .Size(110, 27)
    .Pill(False)
    .CornerRadius(6)
    .Build(FHostForm);

  Assert.AreEqual<Single>(6, LHandle.Container.XRadius,
    'XRadius deveria refletir CornerRadius quando Pill e False.');
  Assert.AreEqual<Single>(6, LHandle.Container.YRadius,
    'YRadius deveria refletir CornerRadius quando Pill e False.');
end;

procedure TRickUIBuilderBadgeBuildTests.Build_DeveAplicarBackgroundColorInformada;
var
  LHandle: IRickUIBuilderBadgeHandle;
begin
  LHandle := TRickUIBuilderBadgeBuilder.New
    .Text('Ativo')
    .BackgroundColor(TAlphaColors.Green)
    .Build(FHostForm);

  Assert.AreEqual<TAlphaColor>(TAlphaColors.Green, LHandle.Container.Fill.Color,
    'BackgroundColor nao foi aplicada ao Container.');
end;

procedure TRickUIBuilderBadgeBuildTests.Build_DeveAplicarBorderColorQuandoInformada;
var
  LHandle: IRickUIBuilderBadgeHandle;
begin
  LHandle := TRickUIBuilderBadgeBuilder.New
    .Text('Ativo')
    .BorderColor(TAlphaColors.Red)
    .Build(FHostForm);

  Assert.AreEqual<TBrushKind>(TBrushKind.Solid, LHandle.Container.Stroke.Kind,
    'Stroke.Kind deveria ser Solid quando BorderColor e informada.');
  Assert.AreEqual<TAlphaColor>(TAlphaColors.Red, LHandle.Container.Stroke.Color,
    'Stroke.Color deveria refletir o BorderColor informado.');
end;

procedure TRickUIBuilderBadgeBuildTests.Build_NaoDeveAplicarBordaQuandoBorderColorForNull;
var
  LHandle: IRickUIBuilderBadgeHandle;
begin
  LHandle := TRickUIBuilderBadgeBuilder.New
    .Text('Ativo')
    .Build(FHostForm);

  Assert.AreEqual<TBrushKind>(TBrushKind.None, LHandle.Container.Stroke.Kind,
    'Stroke.Kind deveria permanecer None quando BorderColor nao e informada.');
end;

procedure TRickUIBuilderBadgeBuildTests.Build_DeveAplicarTagNoContainer;
var
  LHandle: IRickUIBuilderBadgeHandle;
begin
  LHandle := TRickUIBuilderBadgeBuilder.New
    .Text('Ativo')
    .Tag(9)
    .Build(FHostForm);

  Assert.AreEqual<NativeInt>(9, LHandle.Container.Tag, 'Tag do Container incorreta.');
end;

initialization
  TDUnitX.RegisterTestFixture(TRickUIBuilderBadgeChainingTests);
  TDUnitX.RegisterTestFixture(TRickUIBuilderBadgeBuildTests);

end.
