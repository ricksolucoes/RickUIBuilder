unit Rick.UIBuilder.Tests.ComboBox;
(*
  ============================================================================
  Unit: Rick.UIBuilder.Tests.ComboBox
  ============================================================================

  RESPONSABILIDADE

  Testa modelo de dados, resolucao de estilo e a integracao visual real do
  ComboBox em TForm -> TVertScrollBox, cobrindo especificamente a regressao em
  que a logica podia existir sem o controle permanecer materializado na tela.
  ============================================================================
*)

interface

uses
  DUnitX.TestFramework,
  System.UITypes,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Layouts,
  FMX.Objects,
  FMX.StdCtrls,
  Rick.UIBuilder,
  Rick.UIBuilder.Types,
  Rick.UIBuilder.Interfaces,
  Rick.UIBuilder.Factory,
  Rick.UIBuilder.ComboBox.Data,
  Rick.UIBuilder.ComboBox.Style;

type
  [TestFixture]
  TRickUIBuilderComboBoxDataTests = class
  private
    FData: TRickUIBuilderComboBoxData;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure NovaLista_DeveIniciarSemSelecao;
    [Test]
    procedure TextoDuplicado_DeveSelecionarPrimeiraOcorrencia;
    [Test]
    procedure Value_DeveSerIndependenteDoDisplayText;
    [Test]
    procedure IndiceInvalido_NaoDeveAlterarSelecao;
    [Test]
    procedure AddRange_DevePreservarSelecaoExistente;
  end;

  [TestFixture]
  TRickUIBuilderComboBoxStyleTests = class
  public
    [Test]
    procedure Desktop_DeveResolverAnchoredQuandoPresentationForAuto;
    [Test]
    procedure Mobile_DeveResolverOverlayQuandoPresentationForAuto;
    [Test]
    procedure OverridePresentation_DevePrevalecerSobreDefaultDoStyle;
  end;

  [TestFixture]
  [Category('Integration')]
  TRickUIBuilderComboBoxIntegrationTests = class
  private
    FHostForm: TForm;
    FScroll: TVertScrollBox;
    function CountVisiblePopupRectangles(AContainer: TRectangle): Integer;
    function FindArrow(AContainer: TRectangle): TPath;
    procedure AssertClosedVisualTree(AContainer: TRectangle);
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure Factory_DeveCriarControleFechadoNoScrollBox;
    [Test]
    procedure Builder_DevePermanecerVisivelNoScrollBox;
    [Test]
    procedure BuildSemHandle_DeveManterRuntimeAposBuilderSairDeEscopo;
    [Test]
    procedure Facade_DeveCriarSelecaoInicial;
    [Test]
    procedure Runtime_DeveSelecionarAdicionarEConsultar;
    [Test]
    procedure RemoverOutroComponente_NaoDeveDesanexarHandle;
    [Test]
    procedure Handle_DeveDesanexarQuandoParentForDestruido;
    [Test]
    procedure PopupAberto_DeveDesanexarQuandoParentForDestruido;
    [Test]
    procedure Seta_DeveTrocarPathAoAbrirEFechar;
    [Test]
    procedure AddRangeComPopupAberto_DevePreservarSelecao;
    [Test]
    procedure SetaDireita_DeveRespeitarMargensCustomizadas;
    [Test]
    procedure SetaEsquerda_DeveReservarAreaDoTexto;
    [Test]
    procedure PathsDefault_DeveUsarSetasIndependentes;
  end;

implementation

{ TRickUIBuilderComboBoxDataTests }

procedure TRickUIBuilderComboBoxDataTests.Setup;
begin
  FData := TRickUIBuilderComboBoxData.Create;
end;

procedure TRickUIBuilderComboBoxDataTests.TearDown;
begin
  FData.Free;
end;

procedure TRickUIBuilderComboBoxDataTests.NovaLista_DeveIniciarSemSelecao;
begin
  Assert.AreEqual(-1, FData.ItemIndex);
  Assert.AreEqual('', FData.SelectedText);
  Assert.AreEqual('', FData.SelectedValue);
end;

procedure TRickUIBuilderComboBoxDataTests.TextoDuplicado_DeveSelecionarPrimeiraOcorrencia;
begin
  FData.Add(TRickUIBuilderComboBoxItem.Create('Notebook', '001'));
  FData.Add(TRickUIBuilderComboBoxItem.Create('Notebook', '002'));

  Assert.IsTrue(FData.TrySelectText('notebook'));
  Assert.AreEqual(0, FData.ItemIndex);
  Assert.AreEqual('001', FData.SelectedValue);
end;

procedure TRickUIBuilderComboBoxDataTests.Value_DeveSerIndependenteDoDisplayText;
begin
  FData.Add(TRickUIBuilderComboBoxItem.Create('Notebook Core i7', '001'));
  Assert.IsTrue(FData.SelectIndex(0));
  Assert.AreEqual('Notebook Core i7', FData.SelectedText);
  Assert.AreEqual('001', FData.SelectedValue);
end;

procedure TRickUIBuilderComboBoxDataTests.IndiceInvalido_NaoDeveAlterarSelecao;
begin
  FData.AddText('A');
  FData.AddText('B');
  Assert.IsTrue(FData.SelectIndex(1));

  Assert.IsFalse(FData.SelectIndex(2));
  Assert.AreEqual(1, FData.ItemIndex);
end;

procedure TRickUIBuilderComboBoxDataTests.AddRange_DevePreservarSelecaoExistente;
begin
  FData.AddText('A');
  FData.AddText('B');
  FData.SelectIndex(1);
  FData.AddRange(['C', 'D']);

  Assert.AreEqual(4, FData.Count);
  Assert.AreEqual(1, FData.ItemIndex);
  Assert.AreEqual('B', FData.SelectedText);
end;

{ TRickUIBuilderComboBoxStyleTests }

procedure TRickUIBuilderComboBoxStyleTests.Desktop_DeveResolverAnchoredQuandoPresentationForAuto;
var
  LConfig: TRickUIBuilderComboBoxConfig;
begin
  LConfig := TRickUIBuilderComboBoxConfig.Default;
  LConfig.RequestedStyleType := TRickUIBuilderComboBoxStyleType.Desktop;
  LConfig.PresentationMode := TRickUIBuilderComboBoxPresentationMode.Auto;
  LConfig := TRickUIBuilderComboBoxStyleResolver.Resolve(LConfig);

  Assert.AreEqual(Integer(TRickUIBuilderComboBoxStyleType.Desktop),
    Integer(LConfig.EffectiveStyleType));
  Assert.AreEqual(Integer(TRickUIBuilderComboBoxPresentationMode.Anchored),
    Integer(LConfig.PresentationMode));
end;

procedure TRickUIBuilderComboBoxStyleTests.Mobile_DeveResolverOverlayQuandoPresentationForAuto;
var
  LConfig: TRickUIBuilderComboBoxConfig;
begin
  LConfig := TRickUIBuilderComboBoxConfig.Default;
  LConfig.RequestedStyleType := TRickUIBuilderComboBoxStyleType.Mobile;
  LConfig.PresentationMode := TRickUIBuilderComboBoxPresentationMode.Auto;
  LConfig := TRickUIBuilderComboBoxStyleResolver.Resolve(LConfig);

  Assert.AreEqual(Integer(TRickUIBuilderComboBoxStyleType.Mobile),
    Integer(LConfig.EffectiveStyleType));
  Assert.AreEqual(Integer(TRickUIBuilderComboBoxPresentationMode.Overlay),
    Integer(LConfig.PresentationMode));
end;

procedure TRickUIBuilderComboBoxStyleTests.OverridePresentation_DevePrevalecerSobreDefaultDoStyle;
var
  LConfig: TRickUIBuilderComboBoxConfig;
begin
  LConfig := TRickUIBuilderComboBoxConfig.Default;
  LConfig.RequestedStyleType := TRickUIBuilderComboBoxStyleType.Mobile;
  LConfig.PresentationMode := TRickUIBuilderComboBoxPresentationMode.Anchored;
  LConfig := TRickUIBuilderComboBoxStyleResolver.Resolve(LConfig);

  Assert.AreEqual(Integer(TRickUIBuilderComboBoxPresentationMode.Anchored),
    Integer(LConfig.PresentationMode));
end;

{ TRickUIBuilderComboBoxIntegrationTests }

procedure TRickUIBuilderComboBoxIntegrationTests.Setup;
begin
  FHostForm := TForm.CreateNew(nil);
  FHostForm.Width := 640;
  FHostForm.Height := 480;
  FScroll := TVertScrollBox.Create(FHostForm);
  FScroll.Parent := FHostForm;
  FScroll.Align := TAlignLayout.Client;
end;

procedure TRickUIBuilderComboBoxIntegrationTests.TearDown;
begin
  FHostForm.Free;
  FHostForm := nil;
  FScroll := nil;
end;

function TRickUIBuilderComboBoxIntegrationTests.CountVisiblePopupRectangles(
  AContainer: TRectangle): Integer;
var
  LIndex: Integer;
  LChild: TFmxObject;
begin
  Result := 0;
  for LIndex := 0 to FScroll.Content.ChildrenCount - 1 do
  begin
    LChild := FScroll.Content.Children[LIndex];
    if (LChild is TRectangle) and (LChild <> AContainer) and
      TRectangle(LChild).Visible then
      Inc(Result);
  end;
end;

function TRickUIBuilderComboBoxIntegrationTests.FindArrow(
  AContainer: TRectangle): TPath;
var
  LIndex: Integer;
begin
  Result := nil;
  for LIndex := 0 to AContainer.ChildrenCount - 1 do
    if AContainer.Children[LIndex] is TPath then
      Exit(TPath(AContainer.Children[LIndex]));
end;

procedure TRickUIBuilderComboBoxIntegrationTests.AssertClosedVisualTree(
  AContainer: TRectangle);
var
  LIndex: Integer;
  LChild: TFmxObject;
  LHasLabel: Boolean;
  LHasPath: Boolean;
begin
  LHasLabel := False;
  LHasPath := False;
  for LIndex := 0 to AContainer.ChildrenCount - 1 do
  begin
    LChild := AContainer.Children[LIndex];
    LHasLabel := LHasLabel or (LChild is TLabel);
    LHasPath := LHasPath or (LChild is TPath);
  end;
  Assert.IsTrue(LHasLabel, 'O ComboBox fechado deve possuir TLabel.');
  Assert.IsTrue(LHasPath, 'O ComboBox fechado deve possuir TPath.');
end;

procedure TRickUIBuilderComboBoxIntegrationTests.Factory_DeveCriarControleFechadoNoScrollBox;
var
  LConfig: TRickUIBuilderComboBoxConfig;
  LContainer: TRectangle;
  LLabel: TLabel;
  LArrow: TPath;
begin
  LConfig := TRickUIBuilderComboBoxConfig.Default;
  LConfig.Left := 24;
  LConfig.Top := 80;
  LConfig.Width := 260;
  LConfig.Height := 42;
  LContainer := TRickUIBuilder.Factory.CreateComboBox(FScroll, FScroll,
    LConfig, LLabel, LArrow);

  Assert.AreEqual<TFmxObject>(FScroll.Content, LContainer.Parent);
  Assert.IsTrue(LContainer.Visible);
  Assert.AreEqual<Single>(260, LContainer.Width);
  Assert.AreEqual<Single>(42, LContainer.Height);
  Assert.AreEqual<TFmxObject>(LContainer, LLabel.Parent);
  Assert.AreEqual<TFmxObject>(LContainer, LArrow.Parent);
end;

procedure TRickUIBuilderComboBoxIntegrationTests.Builder_DevePermanecerVisivelNoScrollBox;
var
  LContainer: TRectangle;
begin
  LContainer := TRickUIBuilder.ComboBox
    .Position(24, 120)
    .Size(280, 42)
    .Items(['Primeiro', 'Segundo'])
    .ItemIndex(0)
    .Build(FScroll);

  Assert.AreEqual<TFmxObject>(FScroll.Content, LContainer.Parent);
  Assert.IsTrue(LContainer.Visible);
  Assert.AreEqual<Single>(24, LContainer.Position.X);
  Assert.AreEqual<Single>(120, LContainer.Position.Y);
  AssertClosedVisualTree(LContainer);
end;

procedure TRickUIBuilderComboBoxIntegrationTests.BuildSemHandle_DeveManterRuntimeAposBuilderSairDeEscopo;
var
  LContainer: TRectangle;
begin
  LContainer := TRickUIBuilder.ComboBox
    .Items(['A', 'B', 'C'])
    .Build(FScroll);

  Assert.IsTrue(Assigned(LContainer.OnClick));
  LContainer.OnClick(LContainer);
  Assert.IsTrue(CountVisiblePopupRectangles(LContainer) > 0,
    'A abertura deve materializar popup/backdrop no mesmo host visual.');
end;

procedure TRickUIBuilderComboBoxIntegrationTests.Facade_DeveCriarSelecaoInicial;
var
  LHandle: IRickUIBuilderComboBoxHandle;
begin
  LHandle := TRickUIBuilder.ComboBox
    .Items(['Primeiro', 'Segundo', 'Terceiro'])
    .ItemIndex(1)
    .BuildHandle(FScroll);

  Assert.IsNotNull(LHandle);
  Assert.AreEqual(1, LHandle.ItemIndex);
  Assert.AreEqual('Segundo', LHandle.SelectedText);
  Assert.IsTrue(LHandle.IsAttached);
end;

procedure TRickUIBuilderComboBoxIntegrationTests.Runtime_DeveSelecionarAdicionarEConsultar;
var
  LHandle: IRickUIBuilderComboBoxHandle;
begin
  LHandle := TRickUIBuilder.ComboBox
    .AddItem('Notebook Core i7', '001')
    .AddItem('Monitor', '002')
    .BuildHandle(FScroll);

  Assert.IsTrue(LHandle.SelectText('monitor'));
  Assert.AreEqual('002', LHandle.SelectedValue);
  LHandle.Add('Mouse', '003');
  LHandle.AddRange(['Teclado', 'Headset']);
  Assert.AreEqual(5, LHandle.Count);
  Assert.AreEqual('Monitor', LHandle.SelectedText);
end;

procedure TRickUIBuilderComboBoxIntegrationTests.RemoverOutroComponente_NaoDeveDesanexarHandle;
var
  LHandle: IRickUIBuilderComboBoxHandle;
  LOther: TRectangle;
begin
  LHandle := TRickUIBuilder.ComboBox
    .Items(['A', 'B'])
    .BuildHandle(FScroll);
  LOther := TRectangle.Create(FScroll);
  LOther.Parent := FScroll;
  LOther.Free;

  Assert.IsTrue(LHandle.IsAttached,
    'Remover outro componente do mesmo Owner nao pode desanexar o ComboBox.');
end;

procedure TRickUIBuilderComboBoxIntegrationTests.Handle_DeveDesanexarQuandoParentForDestruido;
var
  LHandle: IRickUIBuilderComboBoxHandle;
begin
  LHandle := TRickUIBuilder.ComboBox
    .Items(['A', 'B'])
    .BuildHandle(FScroll);

  FScroll.Free;
  FScroll := nil;
  Assert.IsFalse(LHandle.IsAttached);
  Assert.AreEqual(2, LHandle.Count);
end;

procedure TRickUIBuilderComboBoxIntegrationTests.PopupAberto_DeveDesanexarQuandoParentForDestruido;
var
  LHandle: IRickUIBuilderComboBoxHandle;
begin
  LHandle := TRickUIBuilder.ComboBox
    .Items(['A', 'B', 'C'])
    .BuildHandle(FScroll);
  LHandle.Open;

  FScroll.Free;
  FScroll := nil;
  Assert.IsFalse(LHandle.IsAttached);
  Assert.AreEqual(3, LHandle.Count);
end;

procedure TRickUIBuilderComboBoxIntegrationTests.Seta_DeveTrocarPathAoAbrirEFechar;
var
  LContainer: TRectangle;
  LArrow: TPath;
  LClosedPath: string;
begin
  LContainer := TRickUIBuilder.ComboBox.Items(['A']).Build(FScroll);
  LArrow := FindArrow(LContainer);
  Assert.IsNotNull(LArrow);
  LClosedPath := LArrow.Data.Data;

  LContainer.OnClick(LContainer);
  Assert.AreNotEqual(LClosedPath, LArrow.Data.Data);
  LContainer.OnClick(LContainer);
  Assert.AreEqual(LClosedPath, LArrow.Data.Data);
end;

procedure TRickUIBuilderComboBoxIntegrationTests.AddRangeComPopupAberto_DevePreservarSelecao;
var
  LHandle: IRickUIBuilderComboBoxHandle;
begin
  LHandle := TRickUIBuilder.ComboBox
    .Items(['A', 'B'])
    .ItemIndex(1)
    .BuildHandle(FScroll);
  LHandle.Open;
  LHandle.AddRange(['C', 'D']);

  Assert.AreEqual(4, LHandle.Count);
  Assert.AreEqual(1, LHandle.ItemIndex);
  Assert.AreEqual('B', LHandle.SelectedText);
end;

procedure TRickUIBuilderComboBoxIntegrationTests.SetaDireita_DeveRespeitarMargensCustomizadas;
var
  LConfig: TRickUIBuilderComboBoxConfig;
  LContainer: TRectangle;
  LLabel: TLabel;
  LArrow: TPath;
begin
  LConfig := TRickUIBuilderComboBoxConfig.Default;
  LConfig.Width := 300;
  LConfig.Height := 42;
  LConfig.ArrowSize := 14;
  LConfig.ArrowPosition := TRickUIBuilderComboBoxArrowPosition.Right;
  LConfig.ArrowMarginLeft := 8;
  LConfig.ArrowMarginRight := 16;
  LContainer := TRickUIBuilder.Factory.CreateComboBox(FScroll, FScroll,
    LConfig, LLabel, LArrow);

  Assert.AreEqual<Single>(270, LArrow.Position.X);
  Assert.AreEqual<Single>(16, LContainer.Width - LArrow.Position.X - LArrow.Width);
  Assert.IsTrue(LLabel.Position.X + LLabel.Width <= LArrow.Position.X - 8);
end;

procedure TRickUIBuilderComboBoxIntegrationTests.SetaEsquerda_DeveReservarAreaDoTexto;
var
  LContainer: TRectangle;
  LArrow: TPath;
  LLabel: TLabel;
begin
  LContainer := TRickUIBuilder.ComboBox
    .Size(300, 42)
    .Items(['A'])
    .ArrowPosition(TRickUIBuilderComboBoxArrowPosition.Left)
    .ArrowMargins(14, 4, 10, 4)
    .ArrowSize(14)
    .Build(FScroll);
  LArrow := FindArrow(LContainer);
  LLabel := TLabel(LContainer.Children[0]);

  Assert.AreEqual<Single>(14, LArrow.Position.X);
  Assert.AreEqual<Single>(38, LLabel.Position.X);
end;

procedure TRickUIBuilderComboBoxIntegrationTests.PathsDefault_DeveUsarSetasIndependentes;
var
  LConfig: TRickUIBuilderComboBoxConfig;
begin
  LConfig := TRickUIBuilderComboBoxConfig.Default;
  Assert.AreNotEqual(LConfig.ClosedArrowPath, LConfig.OpenedArrowPath);
  Assert.AreEqual(RICK_COMBOBOX_ARROW_DOWN_PATH, LConfig.ClosedArrowPath);
  Assert.AreEqual(RICK_COMBOBOX_ARROW_UP_PATH, LConfig.OpenedArrowPath);
end;

initialization
  TDUnitX.RegisterTestFixture(TRickUIBuilderComboBoxDataTests);
  TDUnitX.RegisterTestFixture(TRickUIBuilderComboBoxStyleTests);
  TDUnitX.RegisterTestFixture(TRickUIBuilderComboBoxIntegrationTests);

end.
