unit Rick.UIBuilder.Tests.Factory;
(*
  ==============================================================================
  Unit: Rick.UIBuilder.Tests.Factory
  ==============================================================================

  RESPONSABILIDADE

  Testes de integracao (Category('Integration')) para
  TRickUIBuilderFactory. Cada teste desta unit exige um host FMX
  valido (TForm criado via TForm.CreateNew, nunca exibido), pois
  TRickUIBuilderFactory cria controles FMX reais.

  Cobertura: existencia e tipo do controle criado, Parent correto,
  posicao/tamanho aplicados conforme o Config informado, ausencia de
  qualquer dependencia de paleta de cores externa.

  ==============================================================================
*)

interface

uses
  DUnitX.TestFramework,
  System.UITypes,
  FMX.Forms, FMX.Types, FMX.Controls, FMX.Objects, FMX.StdCtrls,
  Rick.UIBuilder.Types,
  Rick.UIBuilder.Factory;

type
  [TestFixture]
  [Category('Integration')]
  TRickUIBuilderFactoryCreateTextTests = class
  private
    FHostForm: TForm;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure DeveCriarComponenteDoTipoTLabel;
    [Test]
    procedure DeveDefinirParentCorretamente;
    [Test]
    procedure DevePosicionarNasCoordenadasDoConfig;
    [Test]
    procedure DeveAplicarTamanhoDoConfig;
    [Test]
    procedure DeveAplicarTextoInformado;
  end;

  [TestFixture]
  [Category('Integration')]
  TRickUIBuilderFactoryCreateDividerTests = class
  private
    FHostForm: TForm;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure DeveCriarComponenteDoTipoTRectangle;
    [Test]
    procedure DeveCriarComAlturaFixaDeUmPixel;
    [Test]
    procedure DeveAplicarLarguraDoConfig;
    [Test]
    procedure NaoDeveResponderAHitTest;
  end;

  [TestFixture]
  [Category('Integration')]
  TRickUIBuilderFactoryCreateBadgeTests = class
  private
    FHostForm: TForm;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure DeveCriarContainerDoTipoTRectangle;
    [Test]
    procedure DeveCriarTextLabelComoFilhoDoContainer;
    [Test]
    procedure DeveAplicarTextoNoTextLabel;
    [Test]
    procedure DeveAplicarFormatoDePilula;
  end;

  [TestFixture]
  [Category('Integration')]
  TRickUIBuilderFactoryCreateButtonTests = class
  private
    FHostForm: TForm;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure DeveCriarComponenteDoTipoTRectangle;
    [Test]
    procedure DeveAplicarTagDoConfig;
    [Test]
    procedure DeveResponderAHitTest;
    [Test]
    procedure DeveCriarLabelDeCaptionComoFilho;
    [Test]
    procedure NaoDeveAplicarBordaQuandoBorderColorForNull;
    [Test]
    procedure DeveAplicarBordaQuandoBorderColorForInformada;
  end;

implementation

uses
  FMX.Graphics;

{ TRickUIBuilderFactoryCreateTextTests }

procedure TRickUIBuilderFactoryCreateTextTests.Setup;
begin
  FHostForm := TForm.CreateNew(nil);
end;

procedure TRickUIBuilderFactoryCreateTextTests.TearDown;
begin
  FHostForm.Free;
end;

procedure TRickUIBuilderFactoryCreateTextTests.DeveCriarComponenteDoTipoTLabel;
var
  LLabel: TLabel;
begin
  LLabel := TRickUIBuilderFactory.CreateText(FHostForm, FHostForm, 'Teste',
    TRickUIBuilderTextConfig.Default);

  Assert.IsNotNull(LLabel, 'CreateText nao deveria retornar nil.');
  Assert.IsTrue(LLabel is TLabel, 'O componente criado deveria ser TLabel.');
end;

procedure TRickUIBuilderFactoryCreateTextTests.DeveDefinirParentCorretamente;
var
  LLabel: TLabel;
begin
  LLabel := TRickUIBuilderFactory.CreateText(FHostForm, FHostForm, 'Teste',
    TRickUIBuilderTextConfig.Default);

  Assert.AreEqual<TFmxObject>(FHostForm, LLabel.Parent,
    'O Parent do label deveria ser o form host informado.');
end;

procedure TRickUIBuilderFactoryCreateTextTests.DevePosicionarNasCoordenadasDoConfig;
var
  LLabel: TLabel;
  LConfig: TRickUIBuilderTextConfig;
begin
  LConfig      := TRickUIBuilderTextConfig.Default;
  LConfig.Left := 21;
  LConfig.Top  := 48;

  LLabel := TRickUIBuilderFactory.CreateText(FHostForm, FHostForm, 'Teste', LConfig);

  Assert.AreEqual<Single>(21, LLabel.Position.X, 'Posicao X incorreta.');
  Assert.AreEqual<Single>(48, LLabel.Position.Y, 'Posicao Y incorreta.');
end;

procedure TRickUIBuilderFactoryCreateTextTests.DeveAplicarTamanhoDoConfig;
var
  LLabel: TLabel;
  LConfig: TRickUIBuilderTextConfig;
begin
  LConfig        := TRickUIBuilderTextConfig.Default;
  LConfig.Width  := 183;
  LConfig.Height := 30;

  LLabel := TRickUIBuilderFactory.CreateText(FHostForm, FHostForm, 'Teste', LConfig);

  Assert.AreEqual<Single>(183, LLabel.Width, 'Width incorreto.');
  Assert.AreEqual<Single>(30, LLabel.Height, 'Height incorreto.');
end;

procedure TRickUIBuilderFactoryCreateTextTests.DeveAplicarTextoInformado;
var
  LLabel: TLabel;
begin
  LLabel := TRickUIBuilderFactory.CreateText(FHostForm, FHostForm, 'EFCompras',
    TRickUIBuilderTextConfig.Default);

  Assert.AreEqual('EFCompras', LLabel.Text, 'Texto do label incorreto.');
end;

{ TRickUIBuilderFactoryCreateDividerTests }

procedure TRickUIBuilderFactoryCreateDividerTests.Setup;
begin
  FHostForm := TForm.CreateNew(nil);
end;

procedure TRickUIBuilderFactoryCreateDividerTests.TearDown;
begin
  FHostForm.Free;
end;

procedure TRickUIBuilderFactoryCreateDividerTests.DeveCriarComponenteDoTipoTRectangle;
var
  LDivider: TRectangle;
begin
  LDivider := TRickUIBuilderFactory.CreateDivider(FHostForm, FHostForm,
    TRickUIBuilderDividerConfig.Default);

  Assert.IsNotNull(LDivider, 'CreateDivider nao deveria retornar nil.');
  Assert.IsTrue(LDivider is TRectangle, 'O componente criado deveria ser TRectangle.');
end;

procedure TRickUIBuilderFactoryCreateDividerTests.DeveCriarComAlturaFixaDeUmPixel;
var
  LDivider: TRectangle;
begin
  LDivider := TRickUIBuilderFactory.CreateDivider(FHostForm, FHostForm,
    TRickUIBuilderDividerConfig.Default);

  Assert.AreEqual<Single>(1, LDivider.Height, 'Divider deveria ter altura fixa de 1px.');
end;

procedure TRickUIBuilderFactoryCreateDividerTests.DeveAplicarLarguraDoConfig;
var
  LDivider: TRectangle;
  LConfig: TRickUIBuilderDividerConfig;
begin
  LConfig       := TRickUIBuilderDividerConfig.Default;
  LConfig.Width := 385;

  LDivider := TRickUIBuilderFactory.CreateDivider(FHostForm, FHostForm, LConfig);

  Assert.AreEqual<Single>(385, LDivider.Width, 'Width do divisor incorreto.');
end;

procedure TRickUIBuilderFactoryCreateDividerTests.NaoDeveResponderAHitTest;
var
  LDivider: TRectangle;
begin
  LDivider := TRickUIBuilderFactory.CreateDivider(FHostForm, FHostForm,
    TRickUIBuilderDividerConfig.Default);

  Assert.IsFalse(LDivider.HitTest, 'Divisor nao deveria responder a HitTest.');
end;

{ TRickUIBuilderFactoryCreateBadgeTests }

procedure TRickUIBuilderFactoryCreateBadgeTests.Setup;
begin
  FHostForm := TForm.CreateNew(nil);
end;

procedure TRickUIBuilderFactoryCreateBadgeTests.TearDown;
begin
  FHostForm.Free;
end;

procedure TRickUIBuilderFactoryCreateBadgeTests.DeveCriarContainerDoTipoTRectangle;
var
  LContainer: TRectangle;
  LTextLabel: TLabel;
begin
  LContainer := TRickUIBuilderFactory.CreateBadge(FHostForm, FHostForm, 'Ativo',
    TRickUIBuilderBadgeConfig.Default, LTextLabel);

  Assert.IsNotNull(LContainer, 'CreateBadge nao deveria retornar nil.');
  Assert.IsTrue(LContainer is TRectangle, 'O container deveria ser TRectangle.');
end;

procedure TRickUIBuilderFactoryCreateBadgeTests.DeveCriarTextLabelComoFilhoDoContainer;
var
  LContainer: TRectangle;
  LTextLabel: TLabel;
begin
  LContainer := TRickUIBuilderFactory.CreateBadge(FHostForm, FHostForm, 'Ativo',
    TRickUIBuilderBadgeConfig.Default, LTextLabel);

  Assert.IsNotNull(LTextLabel, 'O TextLabel de saida nao deveria ser nil.');
  Assert.AreEqual<TFmxObject>(LContainer, LTextLabel.Parent,
    'O Parent do TextLabel deveria ser o Container do Badge.');
end;

procedure TRickUIBuilderFactoryCreateBadgeTests.DeveAplicarTextoNoTextLabel;
var
  LContainer: TRectangle;
  LTextLabel: TLabel;
begin
  LContainer := TRickUIBuilderFactory.CreateBadge(FHostForm, FHostForm, 'Executando',
    TRickUIBuilderBadgeConfig.Default, LTextLabel);

  Assert.IsNotNull(LContainer, 'CreateBadge deveria retornar o Container.');
  Assert.AreEqual('Executando', LTextLabel.Text, 'Texto do Badge incorreto.');
end;

procedure TRickUIBuilderFactoryCreateBadgeTests.DeveAplicarFormatoDePilula;
var
  LContainer: TRectangle;
  LTextLabel: TLabel;
  LConfig: TRickUIBuilderBadgeConfig;
begin
  LConfig        := TRickUIBuilderBadgeConfig.Default;
  LConfig.Height := 27;

  LContainer := TRickUIBuilderFactory.CreateBadge(FHostForm, FHostForm, 'Ativo',
    LConfig, LTextLabel);

  Assert.AreEqual<Single>(13.5, LContainer.XRadius,
    'XRadius deveria ser Height/2 para formato de pilula.');
  Assert.AreEqual<Single>(13.5, LContainer.YRadius,
    'YRadius deveria ser Height/2 para formato de pilula.');
end;

{ TRickUIBuilderFactoryCreateButtonTests }

procedure TRickUIBuilderFactoryCreateButtonTests.Setup;
begin
  FHostForm := TForm.CreateNew(nil);
end;

procedure TRickUIBuilderFactoryCreateButtonTests.TearDown;
begin
  FHostForm.Free;
end;

procedure TRickUIBuilderFactoryCreateButtonTests.DeveCriarComponenteDoTipoTRectangle;
var
  LButton: TRectangle;
begin
  LButton := TRickUIBuilderFactory.CreateButton(FHostForm, FHostForm, 'Instalar',
    TRickUIBuilderButtonConfig.Default);

  Assert.IsNotNull(LButton, 'CreateButton nao deveria retornar nil.');
  Assert.IsTrue(LButton is TRectangle, 'O componente criado deveria ser TRectangle.');
end;

procedure TRickUIBuilderFactoryCreateButtonTests.DeveAplicarTagDoConfig;
var
  LButton: TRectangle;
  LConfig: TRickUIBuilderButtonConfig;
begin
  LConfig     := TRickUIBuilderButtonConfig.Default;
  LConfig.Tag := 5;

  LButton := TRickUIBuilderFactory.CreateButton(FHostForm, FHostForm, 'Config', LConfig);

  Assert.AreEqual<NativeInt>(5, LButton.Tag, 'Tag do botao incorreta.');
end;

procedure TRickUIBuilderFactoryCreateButtonTests.DeveResponderAHitTest;
var
  LButton: TRectangle;
begin
  LButton := TRickUIBuilderFactory.CreateButton(FHostForm, FHostForm, 'Instalar',
    TRickUIBuilderButtonConfig.Default);

  Assert.IsTrue(LButton.HitTest, 'Botao deveria responder a HitTest.');
end;

procedure TRickUIBuilderFactoryCreateButtonTests.DeveCriarLabelDeCaptionComoFilho;
var
  LButton: TRectangle;
  LFound: Boolean;
  I: Integer;
begin
  LButton := TRickUIBuilderFactory.CreateButton(FHostForm, FHostForm, 'Instalar',
    TRickUIBuilderButtonConfig.Default);

  LFound := False;
  for I := 0 to LButton.ChildrenCount - 1 do
    if (LButton.Children[I] is TLabel) and
       (TLabel(LButton.Children[I]).Text = 'Instalar') then
    begin
      LFound := True;
      Break;
    end;

  Assert.IsTrue(LFound, 'O botao deveria conter um TLabel filho com o Caption informado.');
end;

procedure TRickUIBuilderFactoryCreateButtonTests.NaoDeveAplicarBordaQuandoBorderColorForNull;
var
  LButton: TRectangle;
  LConfig: TRickUIBuilderButtonConfig;
begin
  LConfig             := TRickUIBuilderButtonConfig.Default;
  LConfig.BorderColor := TAlphaColors.Null;

  LButton := TRickUIBuilderFactory.CreateButton(FHostForm, FHostForm, 'Iniciar', LConfig);

  Assert.AreEqual<TBrushKind>(TBrushKind.None, LButton.Stroke.Kind,
    'Stroke.Kind deveria ser None quando BorderColor e Null.');
end;

procedure TRickUIBuilderFactoryCreateButtonTests.DeveAplicarBordaQuandoBorderColorForInformada;
var
  LButton: TRectangle;
  LConfig: TRickUIBuilderButtonConfig;
begin
  LConfig             := TRickUIBuilderButtonConfig.Default;
  LConfig.BorderColor := TAlphaColors.Red;

  LButton := TRickUIBuilderFactory.CreateButton(FHostForm, FHostForm, 'Desinstalar', LConfig);

  Assert.AreEqual<TBrushKind>(TBrushKind.Solid, LButton.Stroke.Kind,
    'Stroke.Kind deveria ser Solid quando BorderColor e informada.');
  Assert.AreEqual<TAlphaColor>(TAlphaColors.Red, LButton.Stroke.Color,
    'Stroke.Color deveria refletir o BorderColor informado.');
end;

initialization
  TDUnitX.RegisterTestFixture(TRickUIBuilderFactoryCreateTextTests);
  TDUnitX.RegisterTestFixture(TRickUIBuilderFactoryCreateDividerTests);
  TDUnitX.RegisterTestFixture(TRickUIBuilderFactoryCreateBadgeTests);
  TDUnitX.RegisterTestFixture(TRickUIBuilderFactoryCreateButtonTests);

end.
