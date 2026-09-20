unit Rick.UIBuilder.Tests.Button;
(*
  ==============================================================================
  Unit: Rick.UIBuilder.Tests.Button
  ==============================================================================

  RESPONSABILIDADE

  Testes de IRickUIBuilderButton e IRickUIBuilderButtonHoverState,
  divididos em tres categorias:

  - TRickUIBuilderButtonChainingTests: unitario puro. Valida apenas
    que cada metodo encadeado retorna a mesma instancia do builder
    (sem depender de host FMX, sem chamar Build).

  - TRickUIBuilderButtonHoverStateTests: integracao. Valida a interface
    fluente de hover, seus overloads e o lifetime do behavior criado em Build.

  - TRickUIBuilderButtonBuildTests: integracao (Category('Integration')).
    Exige um TForm host e valida os controles efetivamente criados por
    Build e BuildHandle, incluindo o comportamento de hover (HoverFillColor e
    OnHover coexistindo, conforme <remarks> de
    IRickUIBuilderButton.OnHover) simulado via disparo direto dos
    manipuladores OnMouseEnter/OnMouseLeave.

  ==============================================================================
*)

interface

uses
  DUnitX.TestFramework,
  System.Classes,
  System.UITypes,
  FMX.Forms, FMX.Types, FMX.Controls, FMX.Objects, FMX.StdCtrls,
  Rick.UIBuilder.Types,
  Rick.UIBuilder.Interfaces,
  Rick.UIBuilder.Button,
  Rick.UIBuilder.Button.Handle,
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
  TRickUIBuilderButtonHoverStateTests = class
  private
    FHostForm: TForm;
    FButton: TRectangle;
    FEnterCount: Integer;
    FLeaveCount: Integer;
    procedure HandleEnter(Sender: TObject);
    procedure HandleLeave(Sender: TObject);
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure New_DeveRetornarInterfaceNaoNula;
    [Test]
    procedure Button_Input_DeveRetornarMesmaInstancia;
    [Test]
    procedure Button_Output_DeveRetornarValorConfigurado;
    [Test]
    procedure FillColor_Input_DeveRetornarMesmaInstancia;
    [Test]
    procedure FillColor_Output_DeveRetornarValorConfigurado;
    [Test]
    procedure HoverFillColor_Input_DeveRetornarMesmaInstancia;
    [Test]
    procedure HoverFillColor_Output_DeveRetornarValorConfigurado;
    [Test]
    procedure OnEnter_Input_DeveRetornarMesmaInstancia;
    [Test]
    procedure OnEnter_Output_DeveRetornarHandlerConfigurado;
    [Test]
    procedure OnLeave_Input_DeveRetornarMesmaInstancia;
    [Test]
    procedure OnLeave_Output_DeveRetornarHandlerConfigurado;
    [Test]
    procedure Build_DeveManterHoverAtivoAposLiberarInterface;
    [Test]
    procedure Build_DeveAplicarHoverFillColor;
    [Test]
    procedure Build_DeveRestaurarFillColor;
    [Test]
    procedure Build_DeveExecutarOnEnter;
    [Test]
    procedure Build_DeveExecutarOnLeave;
    [Test]
    procedure Build_SemHoverFillColor_NaoDeveAlterarCor;
    [Test]
    procedure Build_DevePermitirHoverFillColorEOnHoverSimultaneamente;
    [Test]
    procedure Build_DeveAtrelarBehaviorAoOwnerInformado;
    [Test]
    procedure HoverFillColor_AposBuild_DeveSerUsadaNoProximoMouseEnter;
    [Test]
    procedure FillColor_AposBuild_DeveSerUsadaNoProximoMouseLeave;
    [Test]
    procedure OnEnter_AposBuild_DeveUsarHandlerAtual;
    [Test]
    procedure OnLeave_AposBuild_DeveUsarHandlerAtual;
    [Test]
    procedure Button_AlteradoAposBuild_NaoDeveRetargetBehaviorJaCriado;
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
    [Test]
    procedure BuildHandle_DeveRetornarHandleComControlesNaoNulos;
    [Test]
    procedure BuildHandle_DeveExporControlesDaArvoreVisual;
    [Test]
    procedure BuildHandle_DevePreservarParentEOwnership;
    [Test]
    procedure BuildHandle_DeveExporCaptionConfigurado;
    [Test]
    procedure BuildHandle_AlterarTextLabelDeveAfetarSomenteSeuButton;
    [Test]
    procedure BuildHandle_LiberadoNaoDeveLiberarControles;
    [Test]
    procedure BuildHandle_DevePreservarEstiloDoTextLabel;
    [Test]
    procedure BuildHandle_DevePreservarEstadoVisualDoContainer;
    [Test]
    procedure BuildHandle_DeveExporHoverStateNaoNulo;
    [Test]
    procedure BuildHandle_HoverStateButton_DeveCorresponderAoContainer;
    [Test]
    procedure BuildHandle_HoverStateMutavel_DeveControlarHoverDoMesmoContainer;
    [Test]
    procedure ButtonHandle_NewSemHoverState_DevePreservarApiAntiga;
    [Test]
    procedure BuildHandle_Liberado_DeveManterHoverBehaviorAtivo;
  end;

implementation

uses
  FMX.Graphics;

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

{ TRickUIBuilderButtonHoverStateTests }

procedure TRickUIBuilderButtonHoverStateTests.HandleEnter(Sender: TObject);
begin
  Inc(FEnterCount);
end;

procedure TRickUIBuilderButtonHoverStateTests.HandleLeave(Sender: TObject);
begin
  Inc(FLeaveCount);
end;

procedure TRickUIBuilderButtonHoverStateTests.Setup;
begin
  FHostForm := TForm.CreateNew(nil);
  FButton := TRectangle.Create(FHostForm);
  FButton.Parent := FHostForm;
  FButton.Fill.Color := TAlphaColors.Dodgerblue;
  FEnterCount := 0;
  FLeaveCount := 0;
end;

procedure TRickUIBuilderButtonHoverStateTests.TearDown;
begin
  FHostForm.Free;
end;

procedure TRickUIBuilderButtonHoverStateTests.New_DeveRetornarInterfaceNaoNula;
var
  LState: IRickUIBuilderButtonHoverState;
begin
  LState := TRickUIBuilderButtonHoverState.New;

  Assert.IsNotNull(LState, 'New nao deveria retornar nil.');
end;

procedure TRickUIBuilderButtonHoverStateTests.Button_Input_DeveRetornarMesmaInstancia;
var
  LState: IRickUIBuilderButtonHoverState;
  LResult: IRickUIBuilderButtonHoverState;
begin
  LState := TRickUIBuilderButtonHoverState.New;
  LResult := LState.Button(FButton);

  Assert.AreEqual<IRickUIBuilderButtonHoverState>(LState, LResult,
    'Button(AValue) deveria retornar a mesma instancia.');
end;

procedure TRickUIBuilderButtonHoverStateTests.Button_Output_DeveRetornarValorConfigurado;
var
  LState: IRickUIBuilderButtonHoverState;
begin
  LState := TRickUIBuilderButtonHoverState.New.Button(FButton);

  Assert.AreEqual<TFmxObject>(FButton, LState.Button,
    'Button deveria retornar o TRectangle configurado.');
end;

procedure TRickUIBuilderButtonHoverStateTests.FillColor_Input_DeveRetornarMesmaInstancia;
var
  LState: IRickUIBuilderButtonHoverState;
  LResult: IRickUIBuilderButtonHoverState;
begin
  LState := TRickUIBuilderButtonHoverState.New;
  LResult := LState.FillColor(TAlphaColors.Dodgerblue);

  Assert.AreEqual<IRickUIBuilderButtonHoverState>(LState, LResult,
    'FillColor(AValue) deveria retornar a mesma instancia.');
end;

procedure TRickUIBuilderButtonHoverStateTests.FillColor_Output_DeveRetornarValorConfigurado;
var
  LState: IRickUIBuilderButtonHoverState;
begin
  LState := TRickUIBuilderButtonHoverState.New.FillColor(TAlphaColors.Dodgerblue);

  Assert.AreEqual<TAlphaColor>(TAlphaColors.Dodgerblue, LState.FillColor,
    'FillColor deveria retornar a cor configurada.');
end;

procedure TRickUIBuilderButtonHoverStateTests.HoverFillColor_Input_DeveRetornarMesmaInstancia;
var
  LState: IRickUIBuilderButtonHoverState;
  LResult: IRickUIBuilderButtonHoverState;
begin
  LState := TRickUIBuilderButtonHoverState.New;
  LResult := LState.HoverFillColor(TAlphaColors.Royalblue);

  Assert.AreEqual<IRickUIBuilderButtonHoverState>(LState, LResult,
    'HoverFillColor(AValue) deveria retornar a mesma instancia.');
end;

procedure TRickUIBuilderButtonHoverStateTests.HoverFillColor_Output_DeveRetornarValorConfigurado;
var
  LState: IRickUIBuilderButtonHoverState;
begin
  LState := TRickUIBuilderButtonHoverState.New.HoverFillColor(TAlphaColors.Royalblue);

  Assert.AreEqual<TAlphaColor>(TAlphaColors.Royalblue, LState.HoverFillColor,
    'HoverFillColor deveria retornar a cor configurada.');
end;

procedure TRickUIBuilderButtonHoverStateTests.OnEnter_Input_DeveRetornarMesmaInstancia;
var
  LState: IRickUIBuilderButtonHoverState;
  LResult: IRickUIBuilderButtonHoverState;
begin
  LState := TRickUIBuilderButtonHoverState.New;
  LResult := LState.OnEnter(HandleEnter);

  Assert.AreEqual<IRickUIBuilderButtonHoverState>(LState, LResult,
    'OnEnter(AValue) deveria retornar a mesma instancia.');
end;

procedure TRickUIBuilderButtonHoverStateTests.OnEnter_Output_DeveRetornarHandlerConfigurado;
var
  LHandler: TNotifyEvent;
  LState: IRickUIBuilderButtonHoverState;
begin
  LState := TRickUIBuilderButtonHoverState.New.OnEnter(HandleEnter);
  LHandler := LState.OnEnter;
  LHandler(FButton);

  Assert.AreEqual(1, FEnterCount, 'OnEnter deveria retornar o handler configurado.');
end;

procedure TRickUIBuilderButtonHoverStateTests.OnLeave_Input_DeveRetornarMesmaInstancia;
var
  LState: IRickUIBuilderButtonHoverState;
  LResult: IRickUIBuilderButtonHoverState;
begin
  LState := TRickUIBuilderButtonHoverState.New;
  LResult := LState.OnLeave(HandleLeave);

  Assert.AreEqual<IRickUIBuilderButtonHoverState>(LState, LResult,
    'OnLeave(AValue) deveria retornar a mesma instancia.');
end;

procedure TRickUIBuilderButtonHoverStateTests.OnLeave_Output_DeveRetornarHandlerConfigurado;
var
  LHandler: TNotifyEvent;
  LState: IRickUIBuilderButtonHoverState;
begin
  LState := TRickUIBuilderButtonHoverState.New.OnLeave(HandleLeave);
  LHandler := LState.OnLeave;
  LHandler(FButton);

  Assert.AreEqual(1, FLeaveCount, 'OnLeave deveria retornar o handler configurado.');
end;

procedure TRickUIBuilderButtonHoverStateTests.Build_DeveManterHoverAtivoAposLiberarInterface;
var
  LState: IRickUIBuilderButtonHoverState;
begin
  LState := TRickUIBuilderButtonHoverState.New.Button(FButton)
    .FillColor(TAlphaColors.Dodgerblue).HoverFillColor(TAlphaColors.Royalblue);
  LState.Build(FHostForm);
  LState := nil;
  FButton.OnMouseEnter(FButton);

  Assert.AreEqual<TAlphaColor>(TAlphaColors.Royalblue, FButton.Fill.Color,
    'Hover deveria permanecer ativo apos liberar a interface de configuracao.');
end;

procedure TRickUIBuilderButtonHoverStateTests.Build_DeveAplicarHoverFillColor;
begin
  TRickUIBuilderButtonHoverState.New.Button(FButton)
    .FillColor(TAlphaColors.Dodgerblue).HoverFillColor(TAlphaColors.Royalblue)
    .Build(FHostForm);
  FButton.OnMouseEnter(FButton);

  Assert.AreEqual<TAlphaColor>(TAlphaColors.Royalblue, FButton.Fill.Color,
    'Build deveria aplicar HoverFillColor no MouseEnter.');
end;

procedure TRickUIBuilderButtonHoverStateTests.Build_DeveRestaurarFillColor;
begin
  TRickUIBuilderButtonHoverState.New.Button(FButton)
    .FillColor(TAlphaColors.Dodgerblue).HoverFillColor(TAlphaColors.Royalblue)
    .Build(FHostForm);
  FButton.OnMouseEnter(FButton);
  FButton.OnMouseLeave(FButton);

  Assert.AreEqual<TAlphaColor>(TAlphaColors.Dodgerblue, FButton.Fill.Color,
    'Build deveria restaurar FillColor no MouseLeave.');
end;

procedure TRickUIBuilderButtonHoverStateTests.Build_DeveExecutarOnEnter;
begin
  TRickUIBuilderButtonHoverState.New.Button(FButton).OnEnter(HandleEnter)
    .Build(FHostForm);
  FButton.OnMouseEnter(FButton);

  Assert.AreEqual(1, FEnterCount, 'OnEnter configurado nao foi executado.');
end;

procedure TRickUIBuilderButtonHoverStateTests.Build_DeveExecutarOnLeave;
begin
  TRickUIBuilderButtonHoverState.New.Button(FButton).OnLeave(HandleLeave)
    .Build(FHostForm);
  FButton.OnMouseLeave(FButton);

  Assert.AreEqual(1, FLeaveCount, 'OnLeave configurado nao foi executado.');
end;

procedure TRickUIBuilderButtonHoverStateTests.Build_SemHoverFillColor_NaoDeveAlterarCor;
begin
  TRickUIBuilderButtonHoverState.New.Button(FButton)
    .FillColor(TAlphaColors.Dodgerblue).Build(FHostForm);
  FButton.OnMouseEnter(FButton);

  Assert.AreEqual<TAlphaColor>(TAlphaColors.Dodgerblue, FButton.Fill.Color,
    'Sem HoverFillColor a cor do Button nao deveria ser alterada.');
end;

procedure TRickUIBuilderButtonHoverStateTests.Build_DevePermitirHoverFillColorEOnHoverSimultaneamente;
begin
  TRickUIBuilderButtonHoverState.New.Button(FButton)
    .FillColor(TAlphaColors.Dodgerblue).HoverFillColor(TAlphaColors.Royalblue)
    .OnEnter(HandleEnter).OnLeave(HandleLeave).Build(FHostForm);
  FButton.OnMouseEnter(FButton);
  FButton.OnMouseLeave(FButton);

  Assert.AreEqual<TAlphaColor>(TAlphaColors.Dodgerblue, FButton.Fill.Color);
  Assert.AreEqual(1, FEnterCount, 'OnEnter deveria coexistir com HoverFillColor.');
  Assert.AreEqual(1, FLeaveCount, 'OnLeave deveria coexistir com HoverFillColor.');
end;

procedure TRickUIBuilderButtonHoverStateTests.Build_DeveAtrelarBehaviorAoOwnerInformado;
var
  LComponentCount: Integer;
begin
  LComponentCount := FHostForm.ComponentCount;
  TRickUIBuilderButtonHoverState.New.Button(FButton).Build(FHostForm);

  Assert.AreEqual(LComponentCount + 1, FHostForm.ComponentCount,
    'Build deveria criar um behavior owned pelo componente informado.');
end;

procedure TRickUIBuilderButtonHoverStateTests.HoverFillColor_AposBuild_DeveSerUsadaNoProximoMouseEnter;
var
  LState: IRickUIBuilderButtonHoverState;
begin
  LState := TRickUIBuilderButtonHoverState.New.Button(FButton)
    .FillColor(TAlphaColors.Dodgerblue).HoverFillColor(TAlphaColors.Royalblue);
  LState.Build(FHostForm);
  LState.HoverFillColor(TAlphaColors.Red);
  FButton.OnMouseEnter(FButton);

  Assert.AreEqual<TAlphaColor>(TAlphaColors.Red, FButton.Fill.Color,
    'MouseEnter deveria usar o HoverFillColor atual do estado.');
end;

procedure TRickUIBuilderButtonHoverStateTests.FillColor_AposBuild_DeveSerUsadaNoProximoMouseLeave;
var
  LState: IRickUIBuilderButtonHoverState;
begin
  LState := TRickUIBuilderButtonHoverState.New.Button(FButton)
    .FillColor(TAlphaColors.Dodgerblue).HoverFillColor(TAlphaColors.Royalblue);
  LState.Build(FHostForm);
  FButton.OnMouseEnter(FButton);
  LState.FillColor(TAlphaColors.Green);
  FButton.OnMouseLeave(FButton);

  Assert.AreEqual<TAlphaColor>(TAlphaColors.Green, FButton.Fill.Color,
    'MouseLeave deveria usar o FillColor atual do estado.');
end;

procedure TRickUIBuilderButtonHoverStateTests.OnEnter_AposBuild_DeveUsarHandlerAtual;
var
  LState: IRickUIBuilderButtonHoverState;
begin
  LState := TRickUIBuilderButtonHoverState.New.Button(FButton);
  LState.Build(FHostForm);
  LState.OnEnter(HandleEnter);
  FButton.OnMouseEnter(FButton);

  Assert.AreEqual(1, FEnterCount,
    'MouseEnter deveria usar o handler configurado depois de Build.');
end;

procedure TRickUIBuilderButtonHoverStateTests.OnLeave_AposBuild_DeveUsarHandlerAtual;
var
  LState: IRickUIBuilderButtonHoverState;
begin
  LState := TRickUIBuilderButtonHoverState.New.Button(FButton);
  LState.Build(FHostForm);
  LState.OnLeave(HandleLeave);
  FButton.OnMouseLeave(FButton);

  Assert.AreEqual(1, FLeaveCount,
    'MouseLeave deveria usar o handler configurado depois de Build.');
end;

procedure TRickUIBuilderButtonHoverStateTests.Button_AlteradoAposBuild_NaoDeveRetargetBehaviorJaCriado;
var
  LSecondButton: TRectangle;
  LState: IRickUIBuilderButtonHoverState;
begin
  LSecondButton := TRectangle.Create(FHostForm);
  LSecondButton.Parent := FHostForm;
  LSecondButton.Fill.Color := TAlphaColors.Green;
  LState := TRickUIBuilderButtonHoverState.New.Button(FButton)
    .FillColor(TAlphaColors.Dodgerblue).HoverFillColor(TAlphaColors.Royalblue);
  LState.Build(FHostForm);
  LState.Button(LSecondButton);
  FButton.OnMouseEnter(FButton);

  Assert.AreEqual<TAlphaColor>(TAlphaColors.Royalblue, FButton.Fill.Color);
  Assert.AreEqual<TAlphaColor>(TAlphaColors.Green, LSecondButton.Fill.Color);
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

procedure TRickUIBuilderButtonBuildTests.BuildHandle_DeveRetornarHandleComControlesNaoNulos;
var
  LHandle: IRickUIBuilderButtonHandle;
begin
  LHandle := TRickUIBuilderButtonBuilder.New.Caption('Instalar')
    .BuildHandle(FHostForm);

  Assert.IsNotNull(LHandle, 'BuildHandle nao deveria retornar nil.');
  Assert.IsNotNull(LHandle.Container, 'Container nao deveria ser nil.');
  Assert.IsNotNull(LHandle.TextLabel, 'TextLabel nao deveria ser nil.');
end;

procedure TRickUIBuilderButtonBuildTests.BuildHandle_DeveExporControlesDaArvoreVisual;
var
  LHandle: IRickUIBuilderButtonHandle;
begin
  LHandle := TRickUIBuilderButtonBuilder.New.Caption('Instalar')
    .BuildHandle(FHostForm);

  Assert.AreEqual<TFmxObject>(LHandle.Container, FHostForm.Children[0],
    'Container deveria ser o TRectangle inserido no Parent.');
  Assert.AreEqual<TFmxObject>(LHandle.TextLabel, LHandle.Container.Children[0],
    'TextLabel deveria ser o TLabel visual criado para o Button.');
end;

procedure TRickUIBuilderButtonBuildTests.BuildHandle_DevePreservarParentEOwnership;
var
  LHandle: IRickUIBuilderButtonHandle;
begin
  LHandle := TRickUIBuilderButtonBuilder.New.Caption('Instalar')
    .BuildHandle(FHostForm);

  Assert.AreEqual<TFmxObject>(FHostForm, LHandle.Container.Parent,
    'Parent do Container incorreto.');
  Assert.AreEqual<TFmxObject>(LHandle.Container, LHandle.TextLabel.Parent,
    'Parent do TextLabel deveria ser o Container.');
  Assert.AreEqual<TComponent>(FHostForm, LHandle.Container.Owner,
    'Owner do Container deveria permanecer o Parent informado.');
  Assert.AreEqual<TComponent>(FHostForm, LHandle.TextLabel.Owner,
    'Owner do TextLabel deveria permanecer o Parent informado.');
end;

procedure TRickUIBuilderButtonBuildTests.BuildHandle_DeveExporCaptionConfigurado;
var
  LHandle: IRickUIBuilderButtonHandle;
begin
  LHandle := TRickUIBuilderButtonBuilder.New.Caption('Salvar')
    .BuildHandle(FHostForm);

  Assert.AreEqual('Salvar', LHandle.TextLabel.Text,
    'TextLabel deveria conter o Caption configurado.');
end;

procedure TRickUIBuilderButtonBuildTests.BuildHandle_AlterarTextLabelDeveAfetarSomenteSeuButton;
var
  LFirst: IRickUIBuilderButtonHandle;
  LSecond: IRickUIBuilderButtonHandle;
begin
  LFirst := TRickUIBuilderButtonBuilder.New.Caption('Primeiro').BuildHandle(FHostForm);
  LSecond := TRickUIBuilderButtonBuilder.New.Caption('Segundo').BuildHandle(FHostForm);
  LFirst.TextLabel.Text := 'Alterado';

  Assert.AreNotEqual<TFmxObject>(LFirst.Container, LSecond.Container,
    'Dois Buttons deveriam possuir Containers independentes.');
  Assert.AreNotEqual<TFmxObject>(LFirst.TextLabel, LSecond.TextLabel,
    'Dois Buttons deveriam possuir TextLabels independentes.');
  Assert.AreEqual('Alterado', LFirst.TextLabel.Text, 'Primeiro TextLabel incorreto.');
  Assert.AreEqual('Segundo', LSecond.TextLabel.Text, 'Segundo TextLabel foi alterado.');
end;

procedure TRickUIBuilderButtonBuildTests.BuildHandle_LiberadoNaoDeveLiberarControles;
var
  LContainer: TRectangle;
  LTextLabel: TLabel;
  LHandle: IRickUIBuilderButtonHandle;
begin
  LHandle := TRickUIBuilderButtonBuilder.New.Caption('Instalar').BuildHandle(FHostForm);
  LContainer := LHandle.Container;
  LTextLabel := LHandle.TextLabel;
  LHandle := nil;
  LTextLabel.Text := 'Ainda vivo';

  Assert.AreEqual<TFmxObject>(FHostForm, LContainer.Parent,
    'Liberar o Handle nao deveria liberar o Container.');
  Assert.AreEqual('Ainda vivo', LTextLabel.Text,
    'Liberar o Handle nao deveria liberar o TextLabel.');
end;

procedure TRickUIBuilderButtonBuildTests.BuildHandle_DevePreservarEstiloDoTextLabel;
var
  LHandle: IRickUIBuilderButtonHandle;
begin
  LHandle := TRickUIBuilderButtonBuilder.New.Caption('Instalar')
    .FontFamily('Arial').Bold.Padding(TRickUIBuilderSpacing.Uniform(4))
    .BuildHandle(FHostForm);

  Assert.AreEqual('Arial', LHandle.TextLabel.TextSettings.Font.Family,
    'FontFamily nao foi aplicada ao TextLabel retornado.');
  Assert.IsTrue(TFontStyle.fsBold in LHandle.TextLabel.TextSettings.Font.Style,
    'Bold nao foi aplicado ao TextLabel retornado.');
  Assert.AreEqual<Single>(4, LHandle.TextLabel.Padding.Left,
    'Padding nao foi aplicado ao TextLabel retornado.');
end;

procedure TRickUIBuilderButtonBuildTests.BuildHandle_DevePreservarEstadoVisualDoContainer;
var
  LHandle: IRickUIBuilderButtonHandle;
begin
  LHandle := TRickUIBuilderButtonBuilder.New.Caption('Instalar')
    .CornerRadius(9).BorderColor(TAlphaColors.Red).BorderThickness(3)
    .Cursor(crDefault).Visible(False).BuildHandle(FHostForm);

  Assert.AreEqual<Single>(9, LHandle.Container.XRadius, 'XRadius incorreto.');
  Assert.AreEqual<Single>(9, LHandle.Container.YRadius, 'YRadius incorreto.');
  Assert.AreEqual<Single>(3, LHandle.Container.Stroke.Thickness,
    'BorderThickness incorreto.');
  Assert.AreEqual<TCursor>(crDefault, LHandle.Container.Cursor, 'Cursor incorreto.');
  Assert.IsFalse(LHandle.Container.Visible, 'Visible(False) nao foi aplicado.');
end;

procedure TRickUIBuilderButtonBuildTests.BuildHandle_DeveExporHoverStateNaoNulo;
var
  LHandle: IRickUIBuilderButtonHandle;
begin
  LHandle := TRickUIBuilderButtonBuilder.New.Caption('Instalar')
    .BuildHandle(FHostForm);

  Assert.IsNotNull(LHandle.HoverState,
    'BuildHandle deveria expor o HoverState associado ao Button.');
end;

procedure TRickUIBuilderButtonBuildTests.BuildHandle_HoverStateButton_DeveCorresponderAoContainer;
var
  LHandle: IRickUIBuilderButtonHandle;
begin
  LHandle := TRickUIBuilderButtonBuilder.New.Caption('Instalar')
    .BuildHandle(FHostForm);

  Assert.AreEqual<TFmxObject>(LHandle.Container, LHandle.HoverState.Button,
    'HoverState deveria referenciar o mesmo Container criado pelo BuildHandle.');
end;

procedure TRickUIBuilderButtonBuildTests.BuildHandle_HoverStateMutavel_DeveControlarHoverDoMesmoContainer;
var
  LHandle: IRickUIBuilderButtonHandle;
begin
  LHandle := TRickUIBuilderButtonBuilder.New.Caption('Instalar')
    .FillColor(TAlphaColors.Dodgerblue).HoverFillColor(TAlphaColors.Royalblue)
    .BuildHandle(FHostForm);
  LHandle.HoverState.HoverFillColor(TAlphaColors.Red);
  LHandle.Container.OnMouseEnter(LHandle.Container);
  Assert.AreEqual<TAlphaColor>(TAlphaColors.Red, LHandle.Container.Fill.Color,
    'HoverFillColor mutavel deveria afetar o mesmo Container.');
  LHandle.HoverState.FillColor(TAlphaColors.Green);
  LHandle.Container.OnMouseLeave(LHandle.Container);

  Assert.AreEqual<TAlphaColor>(TAlphaColors.Green, LHandle.Container.Fill.Color,
    'FillColor mutavel deveria afetar o mesmo Container.');
end;

procedure TRickUIBuilderButtonBuildTests.ButtonHandle_NewSemHoverState_DevePreservarApiAntiga;
var
  LContainer: TRectangle;
  LHandle: IRickUIBuilderButtonHandle;
  LTextLabel: TLabel;
begin
  LContainer := TRectangle.Create(FHostForm);
  LTextLabel := TLabel.Create(FHostForm);
  LHandle := TRickUIBuilderButtonHandle.New(LContainer, LTextLabel);

  Assert.AreEqual<TFmxObject>(LContainer, LHandle.Container);
  Assert.AreEqual<TFmxObject>(LTextLabel, LHandle.TextLabel);
  Assert.IsTrue(LHandle.HoverState = nil,
    'Sobrecarga antiga de New nao deveria inventar um HoverState.');
end;

procedure TRickUIBuilderButtonBuildTests.BuildHandle_Liberado_DeveManterHoverBehaviorAtivo;
var
  LContainer: TRectangle;
  LHandle: IRickUIBuilderButtonHandle;
begin
  LHandle := TRickUIBuilderButtonBuilder.New.Caption('Instalar')
    .FillColor(TAlphaColors.Dodgerblue).HoverFillColor(TAlphaColors.Royalblue)
    .BuildHandle(FHostForm);
  LContainer := LHandle.Container;
  LHandle := nil;
  LContainer.OnMouseEnter(LContainer);

  Assert.AreEqual<TAlphaColor>(TAlphaColors.Royalblue, LContainer.Fill.Color,
    'Behavior deveria continuar vivo enquanto o Owner existir.');
end;

initialization
  TDUnitX.RegisterTestFixture(TRickUIBuilderButtonChainingTests);
  TDUnitX.RegisterTestFixture(TRickUIBuilderButtonHoverStateTests);
  TDUnitX.RegisterTestFixture(TRickUIBuilderButtonBuildTests);

end.
