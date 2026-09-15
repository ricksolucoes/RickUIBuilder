unit Rick.UIBuilder.Tests._Label;

(*
  ==============================================================================
  Unit: Rick.UIBuilder.Tests.Label
  ==============================================================================

  RESPONSABILIDADE

  Testes para TRickUIBuilderLabelBuilder (IRickUIBuilderLabel), divididos
  em duas categorias:

  - TRickUIBuilderLabelChainingTests: unitario puro. Valida apenas que
    cada metodo encadeado retorna a mesma instancia do builder (sem
    depender de host FMX, sem chamar Build).

  - TRickUIBuilderLabelBuildTests: integracao (Category('Integration')).
    Exige um TForm host e valida o TLabel efetivamente criado por Build.

  ==============================================================================
*)

interface

uses
  DUnitX.TestFramework,
  System.UITypes,
  FMX.Forms, FMX.Types, FMX.Controls, FMX.StdCtrls,
  Rick.UIBuilder.Types,
  Rick.UIBuilder.Interfaces,
  Rick.UIBuilder._Label;

type
  [TestFixture]
  TRickUIBuilderLabelChainingTests = class
  public
    [Test]
    procedure Text_DeveRetornarAMesmaInstancia;
    [Test]
    procedure Position_DeveRetornarAMesmaInstancia;
    [Test]
    procedure Size_DeveRetornarAMesmaInstancia;
    [Test]
    procedure FontColor_DeveRetornarAMesmaInstancia;
    [Test]
    procedure Margin_DeveRetornarAMesmaInstancia;
    [Test]
    procedure Build_DevePermitirEncadeamentoCompletoAntesDeChamarBuild;
  end;

  [TestFixture]
  [Category('Integration')]
  TRickUIBuilderLabelBuildTests = class
  private
    FHostForm: TForm;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure Build_DeveCriarComponenteDoTipoTLabel;
    [Test]
    procedure Build_DeveDefinirParentCorretamente;
    [Test]
    procedure Build_DevePosicionarNasCoordenadasInformadas;
    [Test]
    procedure Build_DeveAplicarTamanhoInformado;
    [Test]
    procedure Build_DeveAplicarTextoInformado;
    [Test]
    procedure Build_DeveAplicarCorDeFonteInformada;
    [Test]
    procedure Build_DeveAplicarMarginDeslocandoPosicaoFinal;
    [Test]
    procedure Build_DeveAplicarPaddingSemAlterarTamanho;
    [Test]
    procedure Build_DeveAplicarBoldQuandoInformado;
    [Test]
    procedure Build_DeveAplicarTagInformada;
    [Test]
    procedure Build_DeveUsarValoresPadraoQuandoNadaForConfigurado;
  end;

implementation

{ TRickUIBuilderLabelChainingTests }

procedure TRickUIBuilderLabelChainingTests.Text_DeveRetornarAMesmaInstancia;
var
  LBuilder: IRickUIBuilderLabel;
  LResult: IRickUIBuilderLabel;
begin
  LBuilder := TRickUIBuilderLabelBuilder.New;
  LResult  := LBuilder.Text('EFCompras');

  Assert.AreEqual<IRickUIBuilderLabel>(LBuilder, LResult,
    'Text deveria retornar a mesma instancia do builder.');
end;

procedure TRickUIBuilderLabelChainingTests.Position_DeveRetornarAMesmaInstancia;
var
  LBuilder: IRickUIBuilderLabel;
  LResult: IRickUIBuilderLabel;
begin
  LBuilder := TRickUIBuilderLabelBuilder.New;
  LResult  := LBuilder.Position(21, 48);

  Assert.AreEqual<IRickUIBuilderLabel>(LBuilder, LResult,
    'Position deveria retornar a mesma instancia do builder.');
end;

procedure TRickUIBuilderLabelChainingTests.Size_DeveRetornarAMesmaInstancia;
var
  LBuilder: IRickUIBuilderLabel;
  LResult: IRickUIBuilderLabel;
begin
  LBuilder := TRickUIBuilderLabelBuilder.New;
  LResult  := LBuilder.Size(183, 30);

  Assert.AreEqual<IRickUIBuilderLabel>(LBuilder, LResult,
    'Size deveria retornar a mesma instancia do builder.');
end;

procedure TRickUIBuilderLabelChainingTests.FontColor_DeveRetornarAMesmaInstancia;
var
  LBuilder: IRickUIBuilderLabel;
  LResult: IRickUIBuilderLabel;
begin
  LBuilder := TRickUIBuilderLabelBuilder.New;
  LResult  := LBuilder.FontColor(TAlphaColors.Red);

  Assert.AreEqual<IRickUIBuilderLabel>(LBuilder, LResult,
    'FontColor deveria retornar a mesma instancia do builder.');
end;

procedure TRickUIBuilderLabelChainingTests.Margin_DeveRetornarAMesmaInstancia;
var
  LBuilder: IRickUIBuilderLabel;
  LResult: IRickUIBuilderLabel;
begin
  LBuilder := TRickUIBuilderLabelBuilder.New;
  LResult  := LBuilder.Margin(TRickUIBuilderSpacing.Uniform(8));

  Assert.AreEqual<IRickUIBuilderLabel>(LBuilder, LResult,
    'Margin deveria retornar a mesma instancia do builder.');
end;

procedure TRickUIBuilderLabelChainingTests.Build_DevePermitirEncadeamentoCompletoAntesDeChamarBuild;
var
  LBuilder: IRickUIBuilderLabel;
begin
  // Garante que a cadeia inteira compila e nao lanca excecao antes do
  // Build ser chamado - nenhum metodo aqui deveria exigir host FMX.
  LBuilder := TRickUIBuilderLabelBuilder.New
    .Text('EFCompras')
    .Position(21, 18)
    .Size(183, 30)
    .FontSize(21)
    .FontColor(TAlphaColors.Black)
    .Bold(True)
    .Align(TTextAlign.Center)
    .Margin(TRickUIBuilderSpacing.Uniform(4))
    .Padding(TRickUIBuilderSpacing.None)
    .Tag(1);

  Assert.IsNotNull(LBuilder, 'O encadeamento completo nao deveria retornar nil.');
end;

{ TRickUIBuilderLabelBuildTests }

procedure TRickUIBuilderLabelBuildTests.Setup;
begin
  FHostForm := TForm.CreateNew(nil);
end;

procedure TRickUIBuilderLabelBuildTests.TearDown;
begin
  FHostForm.Free;
end;

procedure TRickUIBuilderLabelBuildTests.Build_DeveCriarComponenteDoTipoTLabel;
var
  LLabel: TLabel;
begin
  LLabel := TRickUIBuilderLabelBuilder.New
    .Text('Teste')
    .Build(FHostForm);

  Assert.IsNotNull(LLabel, 'O Build nao deveria retornar nil.');
  Assert.IsTrue(LLabel is TLabel, 'O componente criado deveria ser TLabel.');
end;

procedure TRickUIBuilderLabelBuildTests.Build_DeveDefinirParentCorretamente;
var
  LLabel: TLabel;
begin
  LLabel := TRickUIBuilderLabelBuilder.New
    .Text('Teste')
    .Build(FHostForm);

  Assert.AreEqual<TFmxObject>(FHostForm, LLabel.Parent,
    'O Parent do label deveria ser o form host informado no Build.');
end;

procedure TRickUIBuilderLabelBuildTests.Build_DevePosicionarNasCoordenadasInformadas;
var
  LLabel: TLabel;
begin
  LLabel := TRickUIBuilderLabelBuilder.New
    .Text('Teste')
    .Position(21, 48)
    .Build(FHostForm);

  Assert.AreEqual<Single>(21, LLabel.Position.X, 'Posicao X incorreta.');
  Assert.AreEqual<Single>(48, LLabel.Position.Y, 'Posicao Y incorreta.');
end;

procedure TRickUIBuilderLabelBuildTests.Build_DeveAplicarTamanhoInformado;
var
  LLabel: TLabel;
begin
  LLabel := TRickUIBuilderLabelBuilder.New
    .Text('Teste')
    .Size(183, 30)
    .Build(FHostForm);

  Assert.AreEqual<Single>(183, LLabel.Width, 'Width incorreto.');
  Assert.AreEqual<Single>(30, LLabel.Height, 'Height incorreto.');
end;

procedure TRickUIBuilderLabelBuildTests.Build_DeveAplicarTextoInformado;
var
  LLabel: TLabel;
begin
  LLabel := TRickUIBuilderLabelBuilder.New
    .Text('EFCompras')
    .Build(FHostForm);

  Assert.AreEqual('EFCompras', LLabel.Text, 'Texto do label incorreto.');
end;

procedure TRickUIBuilderLabelBuildTests.Build_DeveAplicarCorDeFonteInformada;
var
  LLabel: TLabel;
begin
  LLabel := TRickUIBuilderLabelBuilder.New
    .Text('Teste')
    .FontColor(TAlphaColors.Red)
    .Build(FHostForm);

  Assert.AreEqual<TAlphaColor>(TAlphaColors.Red, LLabel.TextSettings.FontColor,
    'Cor de fonte nao foi aplicada corretamente.');
end;

procedure TRickUIBuilderLabelBuildTests.Build_DeveAplicarMarginDeslocandoPosicaoFinal;
var
  LLabel: TLabel;
begin
  LLabel := TRickUIBuilderLabelBuilder.New
    .Text('Teste')
    .Position(10, 10)
    .Margin(TRickUIBuilderSpacing.Uniform(5))
    .Build(FHostForm);

  // Margin soma-se ao Position definido, conforme documentado em
  // IRickUIBuilderLabel.Margin.
  Assert.AreEqual<Single>(15, LLabel.Position.X,
    'Margin.Left nao foi somado a Position.X.');
  Assert.AreEqual<Single>(15, LLabel.Position.Y,
    'Margin.Top nao foi somado a Position.Y.');
end;

procedure TRickUIBuilderLabelBuildTests.Build_DeveAplicarPaddingSemAlterarTamanho;
var
  LLabel: TLabel;
begin
  LLabel := TRickUIBuilderLabelBuilder.New
    .Text('Teste')
    .Size(100, 25)
    .Padding(TRickUIBuilderSpacing.Uniform(8))
    .Build(FHostForm);

  Assert.AreEqual<Single>(8, LLabel.Padding.Left, 'Padding.Left incorreto.');
  Assert.AreEqual<Single>(8, LLabel.Padding.Top, 'Padding.Top incorreto.');
  Assert.AreEqual<Single>(8, LLabel.Padding.Right, 'Padding.Right incorreto.');
  Assert.AreEqual<Single>(8, LLabel.Padding.Bottom, 'Padding.Bottom incorreto.');

  // Padding nao deveria alterar Width/Height do controle, apenas a
  // area interna de renderizacao do texto.
  Assert.AreEqual<Single>(100, LLabel.Width, 'Width nao deveria mudar com Padding.');
  Assert.AreEqual<Single>(25, LLabel.Height, 'Height nao deveria mudar com Padding.');
end;

procedure TRickUIBuilderLabelBuildTests.Build_DeveAplicarBoldQuandoInformado;
var
  LLabel: TLabel;
begin
  LLabel := TRickUIBuilderLabelBuilder.New
    .Text('Teste')
    .Bold(True)
    .Build(FHostForm);

  Assert.IsTrue(TFontStyle.fsBold in LLabel.TextSettings.Font.Style,
    'Bold(True) deveria adicionar fsBold ao estilo da fonte.');
end;

procedure TRickUIBuilderLabelBuildTests.Build_DeveAplicarTagInformada;
var
  LLabel: TLabel;
begin
  LLabel := TRickUIBuilderLabelBuilder.New
    .Text('Teste')
    .Tag(7)
    .Build(FHostForm);

  Assert.AreEqual<NativeInt>(7, LLabel.Tag, 'Tag do label incorreta.');
end;

procedure TRickUIBuilderLabelBuildTests.Build_DeveUsarValoresPadraoQuandoNadaForConfigurado;
var
  LLabel: TLabel;
  LDefault: TRickUIBuilderTextConfig;
begin
  LDefault := TRickUIBuilderTextConfig.Default;

  LLabel := TRickUIBuilderLabelBuilder.New.Build(FHostForm);

  Assert.AreEqual<Single>(LDefault.Width, LLabel.Width,
    'Width deveria assumir o valor padrao quando Size nao e chamado.');
  Assert.AreEqual<Single>(LDefault.Height, LLabel.Height,
    'Height deveria assumir o valor padrao quando Size nao e chamado.');
  Assert.AreEqual<TAlphaColor>(LDefault.FontColor, LLabel.TextSettings.FontColor,
    'FontColor deveria assumir o valor padrao quando FontColor nao e chamado.');
  Assert.IsTrue(LLabel.Visible, 'Visible deveria ser True por padrao.');
end;

initialization
  TDUnitX.RegisterTestFixture(TRickUIBuilderLabelChainingTests);
  TDUnitX.RegisterTestFixture(TRickUIBuilderLabelBuildTests);

end.
