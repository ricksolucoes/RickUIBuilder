unit Rick.UIBuilder.Tests.Button;
(*
  ==============================================================================
  Unit: Rick.UIBuilder.Tests.Button
  ==============================================================================

  RESPONSABILIDADE

  Testes para TRickUIBuilderButtonBuilder (IRickUIBuilderButton),
  divididos em duas categorias:

  - TRickUIBuilderButtonChainingTests: unitario puro. Valida apenas
    que cada metodo encadeado retorna a mesma instancia do builder
    (sem depender de host FMX, sem chamar Build).

  - TRickUIBuilderButtonBuildTests: integracao (Category('Integration')).
    Exige um TForm host e valida o TRectangle efetivamente criado por
    Build, incluindo o comportamento de hover (HoverFillColor e
    OnHover coexistindo, conforme <remarks> de
    IRickUIBuilderButton.OnHover) simulado via disparo direto dos
    manipuladores OnMouseEnter/OnMouseLeave.

  ==============================================================================
*)

interface

uses
  DUnitX.TestFramework,
  System.UITypes,
  FMX.Forms, FMX.Types, FMX.Controls, FMX.Objects, FMX.StdCtrls,
  Rick.UIBuilder.Types,
  Rick.UIBuilder.Interfaces,
  Rick.UIBuilder.Button,
  Rick.UIBuilder.Button.HoverState;

type
  [TestFixture]
  TRickUIBuilderButtonChainingTests = class
  public
    [Test]
    procedure Caption_DeveRetornarAMesmaInstancia;
    [Test]
    procedure Position_DeveRetornarAMesmaInstancia;
    [Test]
    procedure FillColor_DeveRetornarAMesmaInstancia;
    [Test]
    procedure HoverFillColor_DeveRetornarAMesmaInstancia;
    [Test]
    procedure OnClick_DeveRetornarAMesmaInstancia;
    [Test]
    procedure Build_DevePermitirEncadeamentoCompletoAntesDeChamarBuild;
  end;

  [TestFixture]
  [Category('Integration')]
  TRickUIBuilderButtonBuildTests = class
  private
    FHostForm: TForm;
    FClickCount: Integer;
    FHoverEnterCount: Integer;
    FHoverLeaveCount: Integer;
    procedure HandleClick(Sender: TObject);
    procedure HandleHoverEnter(Sender: TObject);
    procedure HandleHoverLeave(Sender: TObject);
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
    procedure Build_DeveAplicarTagInformada;
    [Test]
    procedure Build_DeveCriarLabelDeCaptionComoFilho;
    [Test]
    procedure Build_DeveDispararOnClickInformado;
    [Test]
    procedure Build_HoverFillColor_DeveAlterarCorAoDispararMouseEnter;
    [Test]
    procedure Build_HoverFillColor_DeveRestaurarCorOriginalAoDispararMouseLeave;
    [Test]
    procedure Build_HoverFillColorEOnHover_DevemCoexistir;
    [Test]
    procedure Build_SemHoverFillColor_NaoDeveAlterarCorAoDispararMouseEnter;
    [Test]
    procedure Build_EnabledFalse_DeveAplicarDisabledOpacity;
    [Test]
    procedure Build_EnabledTrue_DeveAplicarOpacityInformada;
    [Test]
    procedure Build_DeveAplicarMarginDeslocandoPosicaoFinal;
  end;

implementation

{ TRickUIBuilderButtonChainingTests }

procedure TRickUIBuilderButtonChainingTests.Caption_DeveRetornarAMesmaInstancia;
var
  LBuilder: IRickUIBuilderButton;
  LResult: IRickUIBuilderButton;
begin
  LBuilder := TRickUIBuilderButtonBuilder.New;
  LResult  := LBuilder.Caption('Instalar');

  Assert.AreEqual<IRickUIBuilderButton>(LBuilder, LResult,
    'Caption deveria retornar a mesma instancia do builder.');
end;

procedure TRickUIBuilderButtonChainingTests.Position_DeveRetornarAMesmaInstancia;
var
  LBuilder: IRickUIBuilderButton;
  LResult: IRickUIBuilderButton;
begin
  LBuilder := TRickUIBuilderButtonBuilder.New;
  LResult  := LBuilder.Position(21, 290);

  Assert.AreEqual<IRickUIBuilderButton>(LBuilder, LResult,
    'Position deveria retornar a mesma instancia do builder.');
end;

procedure TRickUIBuilderButtonChainingTests.FillColor_DeveRetornarAMesmaInstancia;
var
  LBuilder: IRickUIBuilderButton;
  LResult: IRickUIBuilderButton;
begin
  LBuilder := TRickUIBuilderButtonBuilder.New;
  LResult  := LBuilder.FillColor(TAlphaColors.Dodgerblue);

  Assert.AreEqual<IRickUIBuilderButton>(LBuilder, LResult,
    'FillColor deveria retornar a mesma instancia do builder.');
end;

procedure TRickUIBuilderButtonChainingTests.HoverFillColor_DeveRetornarAMesmaInstancia;
var
  LBuilder: IRickUIBuilderButton;
  LResult: IRickUIBuilderButton;
begin
  LBuilder := TRickUIBuilderButtonBuilder.New;
  LResult  := LBuilder.HoverFillColor(TAlphaColors.Royalblue);

  Assert.AreEqual<IRickUIBuilderButton>(LBuilder, LResult,
    'HoverFillColor deveria retornar a mesma instancia do builder.');
end;

procedure TRickUIBuilderButtonChainingTests.OnClick_DeveRetornarAMesmaInstancia;
var
  LBuilder: IRickUIBuilderButton;
  LResult: IRickUIBuilderButton;
begin
  LBuilder := TRickUIBuilderButtonBuilder.New;
  LResult  := LBuilder.OnClick(nil);

  Assert.AreEqual<IRickUIBuilderButton>(LBuilder, LResult,
    'OnClick deveria retornar a mesma instancia do builder.');
end;

procedure TRickUIBuilderButtonChainingTests.Build_DevePermitirEncadeamentoCompletoAntesDeChamarBuild;
var
  LBuilder: IRickUIBuilderButton;
begin
  // Garante que a cadeia inteira compila e nao lanca excecao antes do
  // Build ser chamado - nenhum metodo aqui deveria exigir host FMX.
  LBuilder := TRickUIBuilderButtonBuilder.New
    .Caption('Instalar')
    .Position(21, 290)
    .Size(188, 40)
    .CornerRadius(16)
    .Margin(TRickUIBuilderSpacing.None)
    .Padding(TRickUIBuilderSpacing.None)
    .FillColor(TAlphaColors.Dodgerblue)
    .BorderColor(TAlphaColors.Null)
    .TextColor(TAlphaColors.White)
    .FontSize(16)
    .Bold(True)
    .HoverFillColor(TAlphaColors.Royalblue)
    .Enabled(True)
    .Tag(1)
    .OnClick(nil)
    .OnHover(nil, nil);

  Assert.IsNotNull(LBuilder, 'O encadeamento completo nao deveria retornar nil.');
end;

{ TRickUIBuilderButtonBuildTests }

procedure TRickUIBuilderButtonBuildTests.HandleClick(Sender: TObject);
begin
  Inc(FClickCount);
end;

procedure TRickUIBuilderButtonBuildTests.HandleHoverEnter(Sender: TObject);
begin
  Inc(FHoverEnterCount);
end;

procedure TRickUIBuilderButtonBuildTests.HandleHoverLeave(Sender: TObject);
begin
  Inc(FHoverLeaveCount);
end;

procedure TRickUIBuilderButtonBuildTests.Setup;
begin
  FHostForm        := TForm.CreateNew(nil);
  FClickCount      := 0;
  FHoverEnterCount := 0;
  FHoverLeaveCount := 0;
end;

procedure TRickUIBuilderButtonBuildTests.TearDown;
begin
  FHostForm.Free;
end;

procedure TRickUIBuilderButtonBuildTests.Build_DeveCriarComponenteDoTipoTRectangle;
var
  LButton: TRectangle;
begin
  LButton := TRickUIBuilderButtonBuilder.New
    .Caption('Instalar')
    .Build(FHostForm);

  Assert.IsNotNull(LButton, 'O Build nao deveria retornar nil.');
  Assert.IsTrue(LButton is TRectangle, 'O componente criado deveria ser TRectangle.');
end;

procedure TRickUIBuilderButtonBuildTests.Build_DeveDefinirParentCorretamente;
var
  LButton: TRectangle;
begin
  LButton := TRickUIBuilderButtonBuilder.New
    .Caption('Instalar')
    .Build(FHostForm);

  Assert.AreEqual<TFmxObject>(FHostForm, LButton.Parent,
    'O Parent do botao deveria ser o form host informado no Build.');
end;

procedure TRickUIBuilderButtonBuildTests.Build_DevePosicionarNasCoordenadasInformadas;
var
  LButton: TRectangle;
begin
  LButton := TRickUIBuilderButtonBuilder.New
    .Caption('Instalar')
    .Position(21, 290)
    .Build(FHostForm);

  Assert.AreEqual<Single>(21, LButton.Position.X, 'Posicao X incorreta.');
  Assert.AreEqual<Single>(290, LButton.Position.Y, 'Posicao Y incorreta.');
end;

procedure TRickUIBuilderButtonBuildTests.Build_DeveAplicarTagInformada;
var
  LButton: TRectangle;
begin
  LButton := TRickUIBuilderButtonBuilder.New
    .Caption('Config')
    .Tag(5)
    .Build(FHostForm);

  Assert.AreEqual<NativeInt>(5, LButton.Tag, 'Tag do botao incorreta.');
end;

procedure TRickUIBuilderButtonBuildTests.Build_DeveCriarLabelDeCaptionComoFilho;
var
  LButton: TRectangle;
  LFound: Boolean;
  I: Integer;
begin
  LButton := TRickUIBuilderButtonBuilder.New
    .Caption('Instalar')
    .Build(FHostForm);

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

procedure TRickUIBuilderButtonBuildTests.Build_DeveDispararOnClickInformado;
var
  LButton: TRectangle;
begin
  LButton := TRickUIBuilderButtonBuilder.New
    .Caption('Instalar')
    .OnClick(HandleClick)
    .Build(FHostForm);

  if Assigned(LButton.OnClick) then
    LButton.OnClick(LButton);

  Assert.AreEqual(1, FClickCount, 'OnClick informado nao foi disparado.');
end;

procedure TRickUIBuilderButtonBuildTests.Build_HoverFillColor_DeveAlterarCorAoDispararMouseEnter;
var
  LButton: TRectangle;
begin
  LButton := TRickUIBuilderButtonBuilder.New
    .Caption('Instalar')
    .FillColor(TAlphaColors.Dodgerblue)
    .HoverFillColor(TAlphaColors.Royalblue)
    .Build(FHostForm);

  if Assigned(LButton.OnMouseEnter) then
    LButton.OnMouseEnter(LButton);

  Assert.AreEqual<TAlphaColor>(TAlphaColors.Royalblue, LButton.Fill.Color,
    'Cor de hover nao foi aplicada ao disparar OnMouseEnter.');
end;

procedure TRickUIBuilderButtonBuildTests.Build_HoverFillColor_DeveRestaurarCorOriginalAoDispararMouseLeave;
var
  LButton: TRectangle;
begin
  LButton := TRickUIBuilderButtonBuilder.New
    .Caption('Instalar')
    .FillColor(TAlphaColors.Dodgerblue)
    .HoverFillColor(TAlphaColors.Royalblue)
    .Build(FHostForm);

  if Assigned(LButton.OnMouseEnter) then
    LButton.OnMouseEnter(LButton);

  if Assigned(LButton.OnMouseLeave) then
    LButton.OnMouseLeave(LButton);

  Assert.AreEqual<TAlphaColor>(TAlphaColors.Dodgerblue, LButton.Fill.Color,
    'Cor original nao foi restaurada ao disparar OnMouseLeave.');
end;

procedure TRickUIBuilderButtonBuildTests.Build_HoverFillColorEOnHover_DevemCoexistir;
var
  LButton: TRectangle;
begin
  LButton := TRickUIBuilderButtonBuilder.New
    .Caption('Instalar')
    .FillColor(TAlphaColors.Dodgerblue)
    .HoverFillColor(TAlphaColors.Royalblue)
    .OnHover(HandleHoverEnter, HandleHoverLeave)
    .Build(FHostForm);

  if Assigned(LButton.OnMouseEnter) then
    LButton.OnMouseEnter(LButton);

  if Assigned(LButton.OnMouseLeave) then
    LButton.OnMouseLeave(LButton);

  // Contrato definido em <remarks> de IRickUIBuilderButton.OnHover:
  // HoverFillColor e OnHover coexistem - a cor muda E o handler do
  // consumidor executa.
  Assert.AreEqual<TAlphaColor>(TAlphaColors.Dodgerblue, LButton.Fill.Color,
    'Cor original deveria ser restaurada apos o MouseLeave.');
  Assert.AreEqual(1, FHoverEnterCount, 'Handler de OnHover (Enter) nao foi chamado.');
  Assert.AreEqual(1, FHoverLeaveCount, 'Handler de OnHover (Leave) nao foi chamado.');
end;

procedure TRickUIBuilderButtonBuildTests.Build_SemHoverFillColor_NaoDeveAlterarCorAoDispararMouseEnter;
var
  LButton: TRectangle;
begin
  LButton := TRickUIBuilderButtonBuilder.New
    .Caption('Instalar')
    .FillColor(TAlphaColors.Dodgerblue)
    .Build(FHostForm);

  if Assigned(LButton.OnMouseEnter) then
    LButton.OnMouseEnter(LButton);

  Assert.AreEqual<TAlphaColor>(TAlphaColors.Dodgerblue, LButton.Fill.Color,
    'Cor nao deveria mudar quando HoverFillColor nao e configurado.');
end;

procedure TRickUIBuilderButtonBuildTests.Build_EnabledFalse_DeveAplicarDisabledOpacity;
var
  LButton: TRectangle;
begin
  LButton := TRickUIBuilderButtonBuilder.New
    .Caption('Instalar')
    .Enabled(False)
    .DisabledOpacity(0.45)
    .Build(FHostForm);

  Assert.IsFalse(LButton.Enabled, 'Enabled(False) nao foi aplicado.');
  Assert.AreEqual<Single>(0.45, LButton.Opacity,
    'DisabledOpacity nao foi aplicada quando Enabled e False.');
end;

procedure TRickUIBuilderButtonBuildTests.Build_EnabledTrue_DeveAplicarOpacityInformada;
var
  LButton: TRectangle;
begin
  LButton := TRickUIBuilderButtonBuilder.New
    .Caption('Instalar')
    .Enabled(True)
    .Opacity(1)
    .Build(FHostForm);

  Assert.IsTrue(LButton.Enabled, 'Enabled(True) nao foi aplicado.');
  Assert.AreEqual<Single>(1, LButton.Opacity,
    'Opacity informada nao foi aplicada quando Enabled e True.');
end;

procedure TRickUIBuilderButtonBuildTests.Build_DeveAplicarMarginDeslocandoPosicaoFinal;
var
  LButton: TRectangle;
begin
  LButton := TRickUIBuilderButtonBuilder.New
    .Caption('Instalar')
    .Position(10, 10)
    .Margin(TRickUIBuilderSpacing.Uniform(5))
    .Build(FHostForm);

  Assert.AreEqual<Single>(15, LButton.Position.X,
    'Margin.Left nao foi somado a Position.X.');
  Assert.AreEqual<Single>(15, LButton.Position.Y,
    'Margin.Top nao foi somado a Position.Y.');
end;

initialization
  TDUnitX.RegisterTestFixture(TRickUIBuilderButtonChainingTests);
  TDUnitX.RegisterTestFixture(TRickUIBuilderButtonBuildTests);

end.
