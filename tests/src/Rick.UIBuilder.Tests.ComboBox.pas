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
  FMX.Edit,
  FMX.Graphics,
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
    [Test]
    procedure Filtro_DeveMapearViewParaSourceIndex;
    [Test]
    procedure ClearFilter_DeveRestaurarViewCompleta;
    [Test]
    procedure AddRangeComFiltro_DeveAtualizarView;
  end;

  [TestFixture]
  TRickUIBuilderComboBoxStyleTests = class
  public
    [Test]
    procedure Desktop_DeveResolverAnchoredQuandoPresentationForAuto;
    [Test]
    procedure Mobile_DeveResolverFullWindowQuandoPresentationForAuto;
    [Test]
    procedure OverridePresentation_DevePrevalecerSobreDefaultDoStyle;
  end;

  [TestFixture]
  [Category('Integration')]
  TRickUIBuilderComboBoxIntegrationTests = class
  private
    FHostForm: TForm;
    FScroll: TVertScrollBox;
    FChangeCount: Integer;
    function CountVisiblePopupRectangles(AContainer: TRectangle): Integer;
    function FindArrow(AContainer: TRectangle): TPath;
    function FindFullWindowPopup: TRectangle;
    function FindEdit(AParent: TFmxObject): TEdit;
    function NormalizePathData(const AData: string): string;
    function FindPath(AParent: TFmxObject; const AData: string): TPath;
    function FindLabel(AParent: TFmxObject; const AText: string): TLabel;
    function FindScrollBox(AParent: TFmxObject): TVertScrollBox;
    function RequireFullWindowPopup: TRectangle;
    function RequireEdit(AParent: TFmxObject): TEdit;
    function RequirePath(AParent: TFmxObject; const AData: string): TPath;
    function RequireScrollBox(AParent: TFmxObject): TVertScrollBox;
    function RequirePathHitArea(APath: TPath): TControl;
    procedure SetSearchText(AEdit: TEdit; const AText: string);
    procedure ClickPath(APath: TPath);
    procedure ClickVisibleRow(AScrollBox: TVertScrollBox; ATag: Integer);
    procedure AssertSearchFieldVisuals(AEdit: TEdit);
    procedure AssertHitAreas(ABack, AClear: TPath);
    procedure AssertClearHidden(AClear: TPath);
    procedure AssertClearVisible(AClear: TPath);
    function CountVisibleRows(AScrollBox: TVertScrollBox): Integer;
    function FindVisibleRowByTag(AScrollBox: TVertScrollBox;
      ATag: Integer): TRectangle;
    procedure ComboChange(Sender: TObject);
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
    [Test]
    procedure FullWindow_DeveUsarFormComoHostVisual;
    [Test]
    procedure FullWindow_DeveCriarEstruturaDeBuscaCompleta;
    [Test]
    procedure Clear_InicialmenteEComEditVazioDeveEstarOculto;
    [Test]
    procedure Clear_ComUmOuMaisCaracteresDeveFicarVisivel;
    [Test]
    procedure Clear_AoClicarDeveRestaurarFiltroSemAlterarSelecao;
    [Test]
    procedure Clear_AposEmptyStateDeveRestaurarLista;
    [Test]
    procedure ResultadoFiltrado_DeveSelecionarSourceIndexEValueOriginal;
    [Test]
    procedure EmptyState_DeveAceitarMensagemEPathCustomizados;
    [Test]
    procedure Back_DeveFecharFullWindowSemAlterarSelecao;
    [Test]
    procedure ParentDestruidoComFullWindowAberto_DeveDesanexarHandle;
    [Test]
    procedure CustomFullWindow_DeveUsarMesmaPresentationFullWindow;
    [Test]
    procedure FullWindowPathsDefault_DeveUsarAssetsFornecidos;
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

procedure TRickUIBuilderComboBoxDataTests.Filtro_DeveMapearViewParaSourceIndex;
begin
  FData.AddRange(['Rio de Janeiro', 'Sao Paulo', 'Riviera', 'Salvador']);
  FData.SetFilterText('ri');

  Assert.AreEqual(2, FData.ViewCount);
  Assert.AreEqual(0, FData.SourceIndexFromView(0));
  Assert.AreEqual(2, FData.SourceIndexFromView(1));
  Assert.AreEqual('Riviera', FData.ViewItem(1).DisplayText);
end;

procedure TRickUIBuilderComboBoxDataTests.ClearFilter_DeveRestaurarViewCompleta;
begin
  FData.AddRange(['Rio', 'Sao Paulo', 'Ribeirao']);
  FData.SetFilterText('ri');
  Assert.AreEqual(2, FData.ViewCount);

  FData.ClearFilter;
  Assert.AreEqual('', FData.FilterText);
  Assert.AreEqual(3, FData.ViewCount);
end;

procedure TRickUIBuilderComboBoxDataTests.AddRangeComFiltro_DeveAtualizarView;
begin
  FData.AddRange(['Rio', 'Sao Paulo']);
  FData.SetFilterText('ri');
  FData.AddRange(['Riviera', 'Salvador']);

  Assert.AreEqual(2, FData.ViewCount);
  Assert.AreEqual(2, FData.SourceIndexFromView(1));
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

procedure TRickUIBuilderComboBoxStyleTests.Mobile_DeveResolverFullWindowQuandoPresentationForAuto;
var
  LConfig: TRickUIBuilderComboBoxConfig;
begin
  LConfig := TRickUIBuilderComboBoxConfig.Default;
  LConfig.RequestedStyleType := TRickUIBuilderComboBoxStyleType.Mobile;
  LConfig.PresentationMode := TRickUIBuilderComboBoxPresentationMode.Auto;
  LConfig := TRickUIBuilderComboBoxStyleResolver.Resolve(LConfig);

  Assert.AreEqual(Integer(TRickUIBuilderComboBoxStyleType.Mobile),
    Integer(LConfig.EffectiveStyleType));
  Assert.AreEqual(Integer(TRickUIBuilderComboBoxPresentationMode.FullWindow),
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
  FChangeCount := 0;
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
    if not (LChild is TRectangle) then
      Continue;
    if (LChild <> AContainer) and TRectangle(LChild).Visible then
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

function TRickUIBuilderComboBoxIntegrationTests.FindFullWindowPopup: TRectangle;
var
  LIndex: Integer;
  LChild: TFmxObject;
begin
  Result := nil;
  for LIndex := 0 to FHostForm.ChildrenCount - 1 do
  begin
    LChild := FHostForm.Children[LIndex];
    if not (LChild is TRectangle) then
      Continue;
    if TRectangle(LChild).Visible then
      Exit(TRectangle(LChild));
  end;
end;

function TRickUIBuilderComboBoxIntegrationTests.FindEdit(
  AParent: TFmxObject): TEdit;
var
  LIndex: Integer;
begin
  Result := nil;
  if not Assigned(AParent) then
    Exit;
  if AParent is TEdit then
    Exit(TEdit(AParent));
  for LIndex := 0 to AParent.ChildrenCount - 1 do
  begin
    Result := FindEdit(AParent.Children[LIndex]);
    if Assigned(Result) then
      Exit;
  end;
end;

function TRickUIBuilderComboBoxIntegrationTests.NormalizePathData(
  const AData: string): string;
var
  LPathData: TPathData;
begin
  // TPathData reserializa o SVG; o teste compara a forma canonica, nao o texto de entrada.
  LPathData := TPathData.Create;
  try
    LPathData.Data := AData;
    Result := LPathData.Data;
  finally
    LPathData.Free;
  end;
end;

function TRickUIBuilderComboBoxIntegrationTests.FindPath(AParent: TFmxObject;
  const AData: string): TPath;
var
  LIndex: Integer;
begin
  Result := nil;
  if not Assigned(AParent) then
    Exit;
  if AParent is TPath then
    if TPath(AParent).Data.Data = NormalizePathData(AData) then
      Exit(TPath(AParent));
  for LIndex := 0 to AParent.ChildrenCount - 1 do
  begin
    Result := FindPath(AParent.Children[LIndex], AData);
    if Assigned(Result) then
      Exit;
  end;
end;

function TRickUIBuilderComboBoxIntegrationTests.FindLabel(AParent: TFmxObject;
  const AText: string): TLabel;
var
  LIndex: Integer;
begin
  Result := nil;
  if not Assigned(AParent) then
    Exit;
  if AParent is TLabel then
    if TLabel(AParent).Text = AText then
      Exit(TLabel(AParent));
  for LIndex := 0 to AParent.ChildrenCount - 1 do
  begin
    Result := FindLabel(AParent.Children[LIndex], AText);
    if Assigned(Result) then
      Exit;
  end;
end;

function TRickUIBuilderComboBoxIntegrationTests.FindScrollBox(
  AParent: TFmxObject): TVertScrollBox;
var
  LIndex: Integer;
begin
  Result := nil;
  if not Assigned(AParent) then
    Exit;
  if AParent is TVertScrollBox then
    Exit(TVertScrollBox(AParent));
  for LIndex := 0 to AParent.ChildrenCount - 1 do
  begin
    Result := FindScrollBox(AParent.Children[LIndex]);
    if Assigned(Result) then
      Exit;
  end;
end;

function TRickUIBuilderComboBoxIntegrationTests.RequireFullWindowPopup:
  TRectangle;
begin
  Result := FindFullWindowPopup;
  Assert.IsNotNull(Result, 'FullWindow deveria estar materializado.');
end;

function TRickUIBuilderComboBoxIntegrationTests.RequireEdit(
  AParent: TFmxObject): TEdit;
begin
  Result := FindEdit(AParent);
  Assert.IsNotNull(Result, 'FullWindow deveria conter SearchEdit.');
end;

function TRickUIBuilderComboBoxIntegrationTests.RequirePath(
  AParent: TFmxObject; const AData: string): TPath;
begin
  Result := FindPath(AParent, AData);
  Assert.IsNotNull(Result, 'FullWindow deveria conter o TPath solicitado.');
end;

function TRickUIBuilderComboBoxIntegrationTests.RequireScrollBox(
  AParent: TFmxObject): TVertScrollBox;
begin
  Result := FindScrollBox(AParent);
  Assert.IsNotNull(Result, 'FullWindow deveria conter a lista virtualizada.');
end;

function TRickUIBuilderComboBoxIntegrationTests.RequirePathHitArea(
  APath: TPath): TControl;
begin
  Result := nil;
  Assert.IsNotNull(APath, 'O TPath da hit area não pode ser nil.');
  if not Assigned(APath) then
    Exit;
  if APath.Parent is TControl then
    Result := TControl(APath.Parent);
  Assert.IsNotNull(Result, 'O TPath deveria possuir hit area.');
end;

procedure TRickUIBuilderComboBoxIntegrationTests.SetSearchText(
  AEdit: TEdit; const AText: string);
begin
  Assert.IsTrue(Assigned(AEdit.OnChangeTracking));
  AEdit.Text := AText;
  AEdit.OnChangeTracking(AEdit);
end;

procedure TRickUIBuilderComboBoxIntegrationTests.ClickPath(APath: TPath);
var
  LHitArea: TControl;
begin
  LHitArea := RequirePathHitArea(APath);
  Assert.IsTrue(Assigned(LHitArea.OnClick));
  LHitArea.OnClick(LHitArea);
end;

procedure TRickUIBuilderComboBoxIntegrationTests.ClickVisibleRow(
  AScrollBox: TVertScrollBox; ATag: Integer);
var
  LRow: TRectangle;
begin
  LRow := FindVisibleRowByTag(AScrollBox, ATag);
  Assert.IsNotNull(LRow, 'A view filtrada deveria conter o SourceIndex esperado.');
  Assert.IsTrue(Assigned(LRow.OnClick));
  LRow.OnClick(LRow);
end;

procedure TRickUIBuilderComboBoxIntegrationTests.AssertSearchFieldVisuals(
  AEdit: TEdit);
begin
  Assert.IsTrue(AEdit.Parent is TRectangle);
  Assert.AreEqual(Integer(TAlignLayout.Client), Integer(AEdit.Align));
  Assert.IsTrue(TRectangle(AEdit.Parent).ClipChildren);
  Assert.AreEqual('transparentedit', AEdit.StyleLookup);
end;

procedure TRickUIBuilderComboBoxIntegrationTests.AssertHitAreas(ABack,
  AClear: TPath);
var
  LBackArea: TControl;
  LClearArea: TControl;
begin
  LBackArea := RequirePathHitArea(ABack);
  LClearArea := RequirePathHitArea(AClear);
  Assert.IsTrue(ABack.Parent is TLayout);
  Assert.IsTrue(AClear.Parent is TLayout);
  Assert.IsFalse(ABack.HitTest);
  Assert.IsTrue(LBackArea.HitTest);
  Assert.IsTrue(LBackArea.Width > ABack.Width);
  Assert.IsTrue(Assigned(LBackArea.OnClick));
  Assert.IsFalse(AClear.HitTest);
  Assert.IsTrue(LClearArea.Width > AClear.Width);
  Assert.IsFalse(LClearArea.Visible);
  Assert.IsFalse(LClearArea.HitTest);
end;

procedure TRickUIBuilderComboBoxIntegrationTests.AssertClearHidden(
  AClear: TPath);
var
  LClearArea: TControl;
begin
  LClearArea := RequirePathHitArea(AClear);
  Assert.IsFalse(AClear.Visible);
  Assert.IsFalse(AClear.HitTest);
  Assert.IsFalse(LClearArea.Visible);
  Assert.IsFalse(LClearArea.HitTest);
end;

procedure TRickUIBuilderComboBoxIntegrationTests.AssertClearVisible(
  AClear: TPath);
var
  LClearArea: TControl;
begin
  LClearArea := RequirePathHitArea(AClear);
  Assert.IsTrue(AClear.Visible);
  Assert.IsFalse(AClear.HitTest);
  Assert.IsTrue(LClearArea.Visible);
  Assert.IsTrue(LClearArea.HitTest);
  Assert.IsTrue(Assigned(LClearArea.OnClick));
end;

function TRickUIBuilderComboBoxIntegrationTests.CountVisibleRows(
  AScrollBox: TVertScrollBox): Integer;
var
  LIndex: Integer;
  LChild: TFmxObject;
begin
  Result := 0;
  for LIndex := 0 to AScrollBox.Content.ChildrenCount - 1 do
  begin
    LChild := AScrollBox.Content.Children[LIndex];
    if not (LChild is TRectangle) then
      Continue;
    if TRectangle(LChild).Visible and (TRectangle(LChild).Opacity > 0) then
      Inc(Result);
  end;
end;

function TRickUIBuilderComboBoxIntegrationTests.FindVisibleRowByTag(
  AScrollBox: TVertScrollBox; ATag: Integer): TRectangle;
var
  LIndex: Integer;
  LChild: TFmxObject;
begin
  Result := nil;
  for LIndex := 0 to AScrollBox.Content.ChildrenCount - 1 do
  begin
    LChild := AScrollBox.Content.Children[LIndex];
    if not (LChild is TRectangle) then
      Continue;
    if TRectangle(LChild).Visible and (TRectangle(LChild).Tag = ATag) then
      Exit(TRectangle(LChild));
  end;
end;

procedure TRickUIBuilderComboBoxIntegrationTests.ComboChange(Sender: TObject);
begin
  Inc(FChangeCount);
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

procedure TRickUIBuilderComboBoxIntegrationTests.FullWindow_DeveUsarFormComoHostVisual;
var
  LHandle: IRickUIBuilderComboBoxHandle;
  LPopup: TRectangle;
begin
  LHandle := TRickUIBuilder.ComboBox.Items(['A', 'B'])
    .StyleType(TRickUIBuilderComboBoxStyleType.Mobile)
    .BuildHandle(FScroll);
  LHandle.Open;
  LPopup := FindFullWindowPopup;

  Assert.IsNotNull(LPopup);
  Assert.AreEqual<TFmxObject>(FHostForm, LPopup.Parent);
  Assert.AreEqual(Integer(TAlignLayout.Client), Integer(LPopup.Align));
  Assert.IsTrue(TCorner.TopLeft in LPopup.Corners);
  Assert.IsFalse(TCorner.BottomLeft in LPopup.Corners);
end;

procedure TRickUIBuilderComboBoxIntegrationTests.FullWindow_DeveCriarEstruturaDeBuscaCompleta;
var
  LHandle: IRickUIBuilderComboBoxHandle;
  LPopup: TRectangle;
  LEdit: TEdit;
  LBack: TPath;
  LClear: TPath;
  LList: TVertScrollBox;
begin
  LHandle := TRickUIBuilder.ComboBox.Items(['Rio', 'Sao Paulo'])
    .StyleType(TRickUIBuilderComboBoxStyleType.Mobile).BuildHandle(FScroll);
  LHandle.Open;
  LPopup := RequireFullWindowPopup;
  LEdit := RequireEdit(LPopup);
  LBack := RequirePath(LPopup, RICK_COMBOBOX_BACK_PATH);
  LClear := RequirePath(LPopup, RICK_COMBOBOX_CLEAR_PATH);
  LList := RequireScrollBox(LPopup);
  Assert.IsNotNull(LList);
  AssertSearchFieldVisuals(LEdit);
  AssertHitAreas(LBack, LClear);
end;


procedure TRickUIBuilderComboBoxIntegrationTests.Clear_InicialmenteEComEditVazioDeveEstarOculto;
var
  LHandle: IRickUIBuilderComboBoxHandle;
  LPopup: TRectangle;
  LEdit: TEdit;
  LClear: TPath;
begin
  LHandle := TRickUIBuilder.ComboBox.Items(['Rio', 'Sao Paulo'])
    .StyleType(TRickUIBuilderComboBoxStyleType.Mobile).BuildHandle(FScroll);
  LHandle.Open;
  LPopup := RequireFullWindowPopup;
  LEdit := RequireEdit(LPopup);
  LClear := RequirePath(LPopup, RICK_COMBOBOX_CLEAR_PATH);
  AssertClearHidden(LClear);
  SetSearchText(LEdit, '');
  AssertClearHidden(LClear);
end;




procedure TRickUIBuilderComboBoxIntegrationTests.Clear_ComUmOuMaisCaracteresDeveFicarVisivel;
var
  LHandle: IRickUIBuilderComboBoxHandle;
  LPopup: TRectangle;
  LEdit: TEdit;
  LClear: TPath;
begin
  LHandle := TRickUIBuilder.ComboBox.Items(['Rio', 'Ribeirao'])
    .StyleType(TRickUIBuilderComboBoxStyleType.Mobile).BuildHandle(FScroll);
  LHandle.Open;
  LPopup := RequireFullWindowPopup;
  LEdit := RequireEdit(LPopup);
  LClear := RequirePath(LPopup, RICK_COMBOBOX_CLEAR_PATH);
  SetSearchText(LEdit, ' ');
  AssertClearVisible(LClear);
  SetSearchText(LEdit, 'Ri');
  AssertClearVisible(LClear);
  SetSearchText(LEdit, '');
  AssertClearHidden(LClear);
end;




procedure TRickUIBuilderComboBoxIntegrationTests.Clear_AoClicarDeveRestaurarFiltroSemAlterarSelecao;
var
  LHandle: IRickUIBuilderComboBoxHandle;
  LPopup: TRectangle;
  LEdit: TEdit;
  LClear: TPath;
  LList: TVertScrollBox;
begin
  LHandle := TRickUIBuilder.ComboBox.Items(['Rio', 'Sao Paulo', 'Ribeirao'])
    .ItemIndex(1).StyleType(TRickUIBuilderComboBoxStyleType.Mobile)
    .OnChange(ComboChange).BuildHandle(FScroll);
  LHandle.Open;
  LPopup := RequireFullWindowPopup;
  LEdit := RequireEdit(LPopup);
  LClear := RequirePath(LPopup, RICK_COMBOBOX_CLEAR_PATH);
  LList := RequireScrollBox(LPopup);
  SetSearchText(LEdit, 'ri');
  Assert.AreEqual(2, CountVisibleRows(LList));
  ClickPath(LClear);
  Assert.AreEqual('', LEdit.Text);
  Assert.AreEqual(3, CountVisibleRows(LList));
  Assert.AreEqual(1, LHandle.ItemIndex);
  Assert.AreEqual(0, FChangeCount);
  Assert.IsTrue(LPopup.Visible);
end;




procedure TRickUIBuilderComboBoxIntegrationTests.Clear_AposEmptyStateDeveRestaurarLista;
var
  LHandle: IRickUIBuilderComboBoxHandle;
  LPopup: TRectangle;
  LEdit: TEdit;
  LClear: TPath;
  LList: TVertScrollBox;
begin
  LHandle := TRickUIBuilder.ComboBox.Items(['Rio', 'Curitiba'])
    .StyleType(TRickUIBuilderComboBoxStyleType.Mobile).BuildHandle(FScroll);
  LHandle.Open;
  LPopup := RequireFullWindowPopup;
  LEdit := RequireEdit(LPopup);
  LClear := RequirePath(LPopup, RICK_COMBOBOX_CLEAR_PATH);
  LList := RequireScrollBox(LPopup);
  SetSearchText(LEdit, 'xyz');
  Assert.IsFalse(LList.Visible);
  ClickPath(LClear);
  Assert.IsTrue(LList.Visible);
  Assert.AreEqual(2, CountVisibleRows(LList));
  Assert.IsFalse(RequirePathHitArea(LClear).Visible);
end;



procedure TRickUIBuilderComboBoxIntegrationTests.ResultadoFiltrado_DeveSelecionarSourceIndexEValueOriginal;
var
  LHandle: IRickUIBuilderComboBoxHandle;
  LPopup: TRectangle;
  LEdit: TEdit;
  LList: TVertScrollBox;
begin
  LHandle := TRickUIBuilder.ComboBox.AddItem('Sao Paulo', 'SP')
    .AddItem('Rio de Janeiro', 'RJ').AddItem('Ribeirao Preto', 'RP')
    .StyleType(TRickUIBuilderComboBoxStyleType.Mobile).BuildHandle(FScroll);
  LHandle.Open;
  LPopup := RequireFullWindowPopup;
  LEdit := RequireEdit(LPopup);
  LList := RequireScrollBox(LPopup);
  SetSearchText(LEdit, 'ri');
  ClickVisibleRow(LList, 2);
  Assert.AreEqual(2, LHandle.ItemIndex);
  Assert.AreEqual('RP', LHandle.SelectedValue);
  Assert.IsFalse(LPopup.Visible);
end;




procedure TRickUIBuilderComboBoxIntegrationTests.EmptyState_DeveAceitarMensagemEPathCustomizados;
var
  LHandle: IRickUIBuilderComboBoxHandle;
  LPopup: TRectangle;
  LEdit: TEdit;
  LLabel: TLabel;
  LPath: TPath;
begin
  LHandle := TRickUIBuilder.ComboBox.Items(['Rio'])
    .StyleType(TRickUIBuilderComboBoxStyleType.Mobile)
    .NoResultsText('Sem cidades').NoResultsPath(RICK_COMBOBOX_ARROW_UP_PATH)
    .BuildHandle(FScroll);
  LHandle.Open;
  LPopup := RequireFullWindowPopup;
  LEdit := RequireEdit(LPopup);
  SetSearchText(LEdit, 'xyz');
  LLabel := FindLabel(LPopup, 'Sem cidades');
  Assert.IsNotNull(LLabel, 'Empty State deveria conter a mensagem customizada.');
  Assert.IsTrue(LLabel.Parent is TControl);
  Assert.IsTrue(TControl(LLabel.Parent).Visible);
  LPath := RequirePath(LPopup, RICK_COMBOBOX_ARROW_UP_PATH);
  Assert.IsNotNull(LPath);
end;



procedure TRickUIBuilderComboBoxIntegrationTests.Back_DeveFecharFullWindowSemAlterarSelecao;
var
  LHandle: IRickUIBuilderComboBoxHandle;
  LPopup: TRectangle;
  LBack: TPath;
  LBackArea: TControl;
begin
  LHandle := TRickUIBuilder.ComboBox.Items(['A', 'B'])
    .ItemIndex(1).StyleType(TRickUIBuilderComboBoxStyleType.Mobile)
    .BuildHandle(FScroll);
  LHandle.Open;
  LPopup := RequireFullWindowPopup;
  LBack := RequirePath(LPopup, RICK_COMBOBOX_BACK_PATH);
  LBackArea := RequirePathHitArea(LBack);
  Assert.IsFalse(LBack.HitTest);
  Assert.IsTrue(LBackArea.HitTest);
  ClickPath(LBack);
  Assert.IsFalse(LPopup.Visible);
  Assert.AreEqual(1, LHandle.ItemIndex);
  Assert.AreEqual('B', LHandle.SelectedText);
end;



procedure TRickUIBuilderComboBoxIntegrationTests.ParentDestruidoComFullWindowAberto_DeveDesanexarHandle;
var
  LHandle: IRickUIBuilderComboBoxHandle;
begin
  LHandle := TRickUIBuilder.ComboBox.Items(['A', 'B'])
    .StyleType(TRickUIBuilderComboBoxStyleType.Mobile)
    .BuildHandle(FScroll);
  LHandle.Open;

  FScroll.Free;
  FScroll := nil;
  Assert.IsFalse(LHandle.IsAttached);
  Assert.AreEqual(2, LHandle.Count);
end;

procedure TRickUIBuilderComboBoxIntegrationTests.CustomFullWindow_DeveUsarMesmaPresentationFullWindow;
var
  LConfig: TRickUIBuilderComboBoxConfig;
  LHandle: IRickUIBuilderComboBoxHandle;
  LPopup: TRectangle;
begin
  LConfig := TRickUIBuilderComboBoxConfig.Default;
  LHandle := TRickUIBuilder.ComboBox.CustomConfig(LConfig)
    .PresentationMode(TRickUIBuilderComboBoxPresentationMode.FullWindow)
    .Items(['A', 'B']).BuildHandle(FScroll);
  LHandle.Open;
  LPopup := FindFullWindowPopup;
  Assert.IsNotNull(LPopup);
  Assert.AreEqual<TFmxObject>(FHostForm, LPopup.Parent);
end;

procedure TRickUIBuilderComboBoxIntegrationTests.FullWindowPathsDefault_DeveUsarAssetsFornecidos;
var
  LConfig: TRickUIBuilderComboBoxConfig;
begin
  LConfig := TRickUIBuilderComboBoxConfig.Default;
  Assert.AreEqual(RICK_COMBOBOX_BACK_PATH, LConfig.BackPath);
  Assert.AreEqual(RICK_COMBOBOX_CLEAR_PATH, LConfig.ClearPath);
  Assert.AreEqual(RICK_COMBOBOX_NO_RESULTS_PATH, LConfig.NoResultsPath);
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
