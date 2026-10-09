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
  FMX.Forms, FMX.Types, FMX.Controls, FMX.Objects, FMX.StdCtrls, FMX.Layouts,
  Rick.UIBuilder.Types,
  Rick.UIBuilder.Interfaces,
  Rick.UIBuilder.Factory,
  Rick.UIBuilder;

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
  TRickUIBuilderFactoryCreateComboBoxTests = class
  private
    FHostForm: TForm;
    FOnChangeCount: Integer;
    FOnOpenCount: Integer;
    FOnCloseCount: Integer;
    FCustomizeCount: Integer;
    FCustomizedFirstItem: Boolean;
    procedure HandleChange(Sender: TObject);
    procedure HandleOpen(Sender: TObject);
    procedure HandleClose(Sender: TObject);
    procedure CustomizeItem(Sender: TObject; AIndex: Integer;
      const AItem: TRickUIBuilderComboBoxItem; AContainer: TControl);
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure Default_DeveCriarHandleSemSelecao;
    [Test]
    procedure Items_DevePopularHandleComItensTextuais;
    [Test]
    procedure Items_DevePreservarDisplayTextEValue;
    [Test]
    procedure SelectionModeIndex_DeveAplicarSelecaoInicial;
    [Test]
    procedure SelectionModeText_DeveSelecionarSemDiferenciarMaiusculas;
    [Test]
    procedure SelecaoInvalida_DevePermanecerSemSelecao;
    [Test]
    procedure TextoInexistente_DevePermanecerSemSelecao;
    [Test]
    procedure Placeholder_DeveSerExibidoSemSelecao;
    [Test]
    procedure Columns_DeveAplicarConfiguracaoEstruturada;
    [Test]
    procedure Callbacks_DeveEncaminharEventosAoRuntime;
    [Test]
    procedure FactorySemHandleExterno_DeveManterRuntimeAtivo;
    [Test]
    procedure ParentDestruido_DeveDesanexarHandleEPreservarDados;
    [Test]
    procedure SiblingDestruido_NaoDeveDesanexarHandle;
    [Test]
    procedure PopupAberto_ParentDestruido_DeveDesanexarHandle;
    [Test]
    procedure FactoryEFluent_DevemPreservarContratoCompartilhado;
    [Test]
    procedure FactoryDesktop_DeveResolverDefaultsDeEstilo;
    [Test]
    procedure FactoryMobileAuto_DeveResolverFullWindow;
    [Test]
    procedure FactoryOverrides_DevePreservarDimensoesExplicitas;
    [Test]
    procedure FactoryPreserveFlag_DevePermitirValorIgualAoDefaultNoMobile;
    [Test]
    procedure FluentOverrides_DevePreservarDimensoesExplicitas;
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
    procedure DeveRetornarTextLabelCriadoNaSobrecargaComOut;
    [Test]
    procedure NaoDeveAplicarBordaQuandoBorderColorForNull;
    [Test]
    procedure DeveAplicarBordaQuandoBorderColorForInformada;
  end;

implementation

uses
  FMX.Graphics,
  FMX.Edit;

function FindDirectLabel(AParent: TFmxObject): TLabel;
var
  LIndex: Integer;
begin
  Result := nil;
  for LIndex := 0 to AParent.ChildrenCount - 1 do
    if AParent.Children[LIndex] is TLabel then
      Exit(TLabel(AParent.Children[LIndex]));
end;


function FindDirectPath(AParent: TFmxObject): TPath;
var
  LIndex: Integer;
begin
  Result := nil;
  for LIndex := 0 to AParent.ChildrenCount - 1 do
    if AParent.Children[LIndex] is TPath then
      Exit(TPath(AParent.Children[LIndex]));
end;

function FindEdit(AParent: TFmxObject): TEdit;
var
  LIndex: Integer;
  LFound: TEdit;
begin
  Result := nil;
  for LIndex := 0 to AParent.ChildrenCount - 1 do
  begin
    if AParent.Children[LIndex] is TEdit then
      Exit(TEdit(AParent.Children[LIndex]));
    LFound := FindEdit(AParent.Children[LIndex]);
    if Assigned(LFound) then
      Exit(LFound);
  end;
end;

function FindVertScrollBox(AParent: TFmxObject): TVertScrollBox;
var
  LIndex: Integer;
  LFound: TVertScrollBox;
begin
  Result := nil;
  for LIndex := 0 to AParent.ChildrenCount - 1 do
  begin
    if AParent.Children[LIndex] is TVertScrollBox then
      Exit(TVertScrollBox(AParent.Children[LIndex]));
    LFound := FindVertScrollBox(AParent.Children[LIndex]);
    if Assigned(LFound) then
      Exit(LFound);
  end;
end;

function FindFirstRow(AScrollBox: TVertScrollBox): TRectangle;
var
  LIndex: Integer;
  LRectangle: TRectangle;
begin
  Result := nil;
  for LIndex := 0 to AScrollBox.Content.ChildrenCount - 1 do
    if AScrollBox.Content.Children[LIndex] is TRectangle then
    begin
      LRectangle := TRectangle(AScrollBox.Content.Children[LIndex]);
      if LRectangle.Visible and Assigned(LRectangle.OnClick) then
        Exit(LRectangle);
    end;
end;

function DirectLabelAt(AParent: TFmxObject; AIndex: Integer): TLabel;
var
  LChildIndex: Integer;
  LLabelIndex: Integer;
begin
  Result := nil;
  LLabelIndex := 0;
  for LChildIndex := 0 to AParent.ChildrenCount - 1 do
    if AParent.Children[LChildIndex] is TLabel then
    begin
      if LLabelIndex = AIndex then
        Exit(TLabel(AParent.Children[LChildIndex]));
      Inc(LLabelIndex);
    end;
end;

function DirectLabelCount(AParent: TFmxObject): Integer;
var
  LIndex: Integer;
begin
  Result := 0;
  for LIndex := 0 to AParent.ChildrenCount - 1 do
    if AParent.Children[LIndex] is TLabel then
      Inc(Result);
end;

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

{ TRickUIBuilderFactoryCreateComboBoxTests }

procedure TRickUIBuilderFactoryCreateComboBoxTests.Setup;
begin
  FHostForm := TForm.CreateNew(nil);
  FOnChangeCount := 0;
  FOnOpenCount := 0;
  FOnCloseCount := 0;
  FCustomizeCount := 0;
  FCustomizedFirstItem := False;
end;

procedure TRickUIBuilderFactoryCreateComboBoxTests.TearDown;
begin
  FHostForm.Free;
end;

procedure TRickUIBuilderFactoryCreateComboBoxTests.HandleChange(Sender: TObject);
begin
  Inc(FOnChangeCount);
end;

procedure TRickUIBuilderFactoryCreateComboBoxTests.HandleOpen(Sender: TObject);
begin
  Inc(FOnOpenCount);
end;

procedure TRickUIBuilderFactoryCreateComboBoxTests.HandleClose(Sender: TObject);
begin
  Inc(FOnCloseCount);
end;

procedure TRickUIBuilderFactoryCreateComboBoxTests.CustomizeItem(Sender: TObject;
  AIndex: Integer; const AItem: TRickUIBuilderComboBoxItem;
  AContainer: TControl);
begin
  Inc(FCustomizeCount);
  FCustomizedFirstItem := FCustomizedFirstItem or
    ((AIndex = 0) and (AItem.DisplayText = 'Primeiro') and
    Assigned(AContainer));
end;

procedure TRickUIBuilderFactoryCreateComboBoxTests.Default_DeveCriarHandleSemSelecao;
var
  LHandle: IRickUIBuilderComboBoxHandle;
  LContainer: TRectangle;
begin
  LContainer := TRickUIBuilderFactory.CreateComboBox(FHostForm, FHostForm,
    TRickUIBuilderComboBoxConfig.Default,
    TRickUIBuilderComboBoxFactoryOptions.Default, LHandle);

  Assert.IsNotNull(LContainer);
  Assert.IsNotNull(LHandle);
  Assert.AreEqual(-1, LHandle.ItemIndex);
  Assert.AreEqual(0, LHandle.Count);
end;

procedure TRickUIBuilderFactoryCreateComboBoxTests.Items_DevePopularHandleComItensTextuais;
var
  LOptions: TRickUIBuilderComboBoxFactoryOptions;
  LHandle: IRickUIBuilderComboBoxHandle;
begin
  LOptions := TRickUIBuilderComboBoxFactoryOptions.Default;
  LOptions.Items := TArray<TRickUIBuilderComboBoxItem>.Create(
    TRickUIBuilderComboBoxItem.Create('Primeiro'),
    TRickUIBuilderComboBoxItem.Create('Segundo'));

  TRickUIBuilderFactory.CreateComboBox(FHostForm, FHostForm,
    TRickUIBuilderComboBoxConfig.Default, LOptions, LHandle);

  Assert.AreEqual(2, LHandle.Count);
  Assert.IsTrue(LHandle.SelectIndex(1));
  Assert.AreEqual('Segundo', LHandle.SelectedText);
end;

procedure TRickUIBuilderFactoryCreateComboBoxTests.Items_DevePreservarDisplayTextEValue;
var
  LOptions: TRickUIBuilderComboBoxFactoryOptions;
  LHandle: IRickUIBuilderComboBoxHandle;
begin
  LOptions := TRickUIBuilderComboBoxFactoryOptions.Default;
  LOptions.Items := TArray<TRickUIBuilderComboBoxItem>.Create(
    TRickUIBuilderComboBoxItem.Create('Sao Paulo', 'SP'),
    TRickUIBuilderComboBoxItem.Create('Rio de Janeiro', 'RJ'));

  TRickUIBuilderFactory.CreateComboBox(FHostForm, FHostForm,
    TRickUIBuilderComboBoxConfig.Default, LOptions, LHandle);

  Assert.IsTrue(LHandle.SelectIndex(1));
  Assert.AreEqual('Rio de Janeiro', LHandle.SelectedText);
  Assert.AreEqual('RJ', LHandle.SelectedValue);
end;

procedure TRickUIBuilderFactoryCreateComboBoxTests.SelectionModeIndex_DeveAplicarSelecaoInicial;
var
  LOptions: TRickUIBuilderComboBoxFactoryOptions;
  LHandle: IRickUIBuilderComboBoxHandle;
begin
  LOptions := TRickUIBuilderComboBoxFactoryOptions.Default;
  LOptions.Items := TArray<TRickUIBuilderComboBoxItem>.Create(
    TRickUIBuilderComboBoxItem.Create('A'),
    TRickUIBuilderComboBoxItem.Create('B'));
  LOptions.SelectionMode := TRickUIBuilderComboBoxInitialSelectionMode.Index;
  LOptions.ItemIndex := 1;

  TRickUIBuilderFactory.CreateComboBox(FHostForm, FHostForm,
    TRickUIBuilderComboBoxConfig.Default, LOptions, LHandle);

  Assert.AreEqual(1, LHandle.ItemIndex);
  Assert.AreEqual('B', LHandle.SelectedText);
end;

procedure TRickUIBuilderFactoryCreateComboBoxTests.SelectionModeText_DeveSelecionarSemDiferenciarMaiusculas;
var
  LOptions: TRickUIBuilderComboBoxFactoryOptions;
  LHandle: IRickUIBuilderComboBoxHandle;
begin
  LOptions := TRickUIBuilderComboBoxFactoryOptions.Default;
  LOptions.Items := TArray<TRickUIBuilderComboBoxItem>.Create(
    TRickUIBuilderComboBoxItem.Create('Primeiro'),
    TRickUIBuilderComboBoxItem.Create('Segundo'));
  LOptions.SelectionMode := TRickUIBuilderComboBoxInitialSelectionMode.Text;
  LOptions.SelectedText := 'sEgUnDo';

  TRickUIBuilderFactory.CreateComboBox(FHostForm, FHostForm,
    TRickUIBuilderComboBoxConfig.Default, LOptions, LHandle);

  Assert.AreEqual(1, LHandle.ItemIndex);
  Assert.AreEqual('Segundo', LHandle.SelectedText);
end;

procedure TRickUIBuilderFactoryCreateComboBoxTests.SelecaoInvalida_DevePermanecerSemSelecao;
var
  LOptions: TRickUIBuilderComboBoxFactoryOptions;
  LHandle: IRickUIBuilderComboBoxHandle;
begin
  LOptions := TRickUIBuilderComboBoxFactoryOptions.Default;
  LOptions.Items := TArray<TRickUIBuilderComboBoxItem>.Create(
    TRickUIBuilderComboBoxItem.Create('A'));
  LOptions.SelectionMode := TRickUIBuilderComboBoxInitialSelectionMode.Index;
  LOptions.ItemIndex := 99;

  TRickUIBuilderFactory.CreateComboBox(FHostForm, FHostForm,
    TRickUIBuilderComboBoxConfig.Default, LOptions, LHandle);

  Assert.AreEqual(-1, LHandle.ItemIndex);
  Assert.AreEqual('', LHandle.SelectedText);
end;

procedure TRickUIBuilderFactoryCreateComboBoxTests.TextoInexistente_DevePermanecerSemSelecao;
var
  LOptions: TRickUIBuilderComboBoxFactoryOptions;
  LHandle: IRickUIBuilderComboBoxHandle;
begin
  LOptions := TRickUIBuilderComboBoxFactoryOptions.Default;
  LOptions.Items := TArray<TRickUIBuilderComboBoxItem>.Create(
    TRickUIBuilderComboBoxItem.Create('A'));
  LOptions.SelectionMode := TRickUIBuilderComboBoxInitialSelectionMode.Text;
  LOptions.SelectedText := 'Inexistente';

  TRickUIBuilderFactory.CreateComboBox(FHostForm, FHostForm,
    TRickUIBuilderComboBoxConfig.Default, LOptions, LHandle);

  Assert.AreEqual(-1, LHandle.ItemIndex);
  Assert.AreEqual('', LHandle.SelectedText);
end;

procedure TRickUIBuilderFactoryCreateComboBoxTests.Placeholder_DeveSerExibidoSemSelecao;
var
  LOptions: TRickUIBuilderComboBoxFactoryOptions;
  LHandle: IRickUIBuilderComboBoxHandle;
  LContainer: TRectangle;
  LLabel: TLabel;
begin
  LOptions := TRickUIBuilderComboBoxFactoryOptions.Default;
  LOptions.Placeholder := 'Selecione um item';
  LContainer := TRickUIBuilderFactory.CreateComboBox(FHostForm, FHostForm,
    TRickUIBuilderComboBoxConfig.Default, LOptions, LHandle);
  LLabel := FindDirectLabel(LContainer);

  Assert.IsNotNull(LLabel);
  Assert.AreEqual('Selecione um item', LLabel.Text);
end;

procedure TRickUIBuilderFactoryCreateComboBoxTests.Columns_DeveAplicarConfiguracaoEstruturada;
var
  LOptions: TRickUIBuilderComboBoxFactoryOptions;
  LHandle: IRickUIBuilderComboBoxHandle;
  LScrollBox: TVertScrollBox;
  LRow: TRectangle;
  LSecond: TLabel;
  LThird: TLabel;
begin
  LOptions := TRickUIBuilderComboBoxFactoryOptions.Default;
  LOptions.Items := TArray<TRickUIBuilderComboBoxItem>.Create(
    TRickUIBuilderComboBoxItem.Structured('Item', '1',
      ['Fixo', 'Peso 2', 'Auto', 'Oculto']));
  LOptions.Columns := TArray<TRickUIBuilderComboBoxColumn>.Create(
    TRickUIBuilderComboBoxColumn.Create(
      TRickUIBuilderComboBoxColumnSizeMode.Fixed, 60),
    TRickUIBuilderComboBoxColumn.Create(
      TRickUIBuilderComboBoxColumnSizeMode.Proportional, 2),
    TRickUIBuilderComboBoxColumn.Create(
      TRickUIBuilderComboBoxColumnSizeMode.Auto),
    TRickUIBuilderComboBoxColumn.Create(
      TRickUIBuilderComboBoxColumnSizeMode.Auto));
  LOptions.Columns[1].Alignment := TTextAlign.Center;
  LOptions.Columns[2].Alignment := TTextAlign.Trailing;
  LOptions.Columns[3].Visible := False;

  TRickUIBuilderFactory.CreateComboBox(FHostForm, FHostForm,
    TRickUIBuilderComboBoxConfig.Default, LOptions, LHandle);
  LHandle.Open;
  LScrollBox := FindVertScrollBox(FHostForm);
  Assert.IsNotNull(LScrollBox, 'O popup deve expor um TVertScrollBox.');
  LRow := FindFirstRow(LScrollBox);
  Assert.IsNotNull(LRow, 'A primeira row deve existir em TVertScrollBox.Content.');
  Assert.AreEqual(3, DirectLabelCount(LRow));
  LSecond := DirectLabelAt(LRow, 1);
  LThird := DirectLabelAt(LRow, 2);

  Assert.AreEqual<Single>(60, DirectLabelAt(LRow, 0).Width);
  Assert.IsTrue(LSecond.Width > LThird.Width);
  Assert.AreEqual<TTextAlign>(TTextAlign.Center,
    LSecond.TextSettings.HorzAlign);
  Assert.AreEqual<TTextAlign>(TTextAlign.Trailing,
    LThird.TextSettings.HorzAlign);
end;

procedure TRickUIBuilderFactoryCreateComboBoxTests.Callbacks_DeveEncaminharEventosAoRuntime;
var
  LOptions: TRickUIBuilderComboBoxFactoryOptions;
  LHandle: IRickUIBuilderComboBoxHandle;
begin
  LOptions := TRickUIBuilderComboBoxFactoryOptions.Default;
  LOptions.Items := TArray<TRickUIBuilderComboBoxItem>.Create(
    TRickUIBuilderComboBoxItem.Create('Primeiro'),
    TRickUIBuilderComboBoxItem.Create('Segundo'));
  LOptions.OnChange := HandleChange;
  LOptions.OnOpen := HandleOpen;
  LOptions.OnClose := HandleClose;
  LOptions.OnCustomizeItem := CustomizeItem;
  TRickUIBuilderFactory.CreateComboBox(FHostForm, FHostForm,
    TRickUIBuilderComboBoxConfig.Default, LOptions, LHandle);

  LHandle.Open;
  Assert.IsTrue(LHandle.SelectIndex(1));
  LHandle.Close;

  Assert.AreEqual(1, FOnOpenCount);
  Assert.AreEqual(1, FOnChangeCount);
  Assert.AreEqual(1, FOnCloseCount);
  Assert.IsTrue(FCustomizeCount > 0);
  Assert.IsTrue(FCustomizedFirstItem);
end;

procedure TRickUIBuilderFactoryCreateComboBoxTests.FactorySemHandleExterno_DeveManterRuntimeAtivo;
var
  LOptions: TRickUIBuilderComboBoxFactoryOptions;
  LHandle: IRickUIBuilderComboBoxHandle;
  LContainer: TRectangle;
begin
  LOptions := TRickUIBuilderComboBoxFactoryOptions.Default;
  LOptions.Items := TArray<TRickUIBuilderComboBoxItem>.Create(
    TRickUIBuilderComboBoxItem.Create('A'));
  LContainer := TRickUIBuilderFactory.CreateComboBox(FHostForm, FHostForm,
    TRickUIBuilderComboBoxConfig.Default, LOptions, LHandle);
  LHandle := nil;

  Assert.IsTrue(Assigned(LContainer.OnClick));
  LContainer.OnClick(LContainer);
  Assert.IsNotNull(FindVertScrollBox(FHostForm));
end;

procedure TRickUIBuilderFactoryCreateComboBoxTests.ParentDestruido_DeveDesanexarHandleEPreservarDados;
var
  LOptions: TRickUIBuilderComboBoxFactoryOptions;
  LHandle: IRickUIBuilderComboBoxHandle;
begin
  LOptions := TRickUIBuilderComboBoxFactoryOptions.Default;
  LOptions.Items := TArray<TRickUIBuilderComboBoxItem>.Create(
    TRickUIBuilderComboBoxItem.Create('A'),
    TRickUIBuilderComboBoxItem.Create('B'));
  TRickUIBuilderFactory.CreateComboBox(FHostForm, FHostForm,
    TRickUIBuilderComboBoxConfig.Default, LOptions, LHandle);

  FHostForm.Free;
  FHostForm := nil;

  Assert.IsFalse(LHandle.IsAttached);
  Assert.AreEqual(2, LHandle.Count);
end;

procedure TRickUIBuilderFactoryCreateComboBoxTests.SiblingDestruido_NaoDeveDesanexarHandle;
var
  LOptions: TRickUIBuilderComboBoxFactoryOptions;
  LHandle: IRickUIBuilderComboBoxHandle;
  LSibling: TRectangle;
begin
  LOptions := TRickUIBuilderComboBoxFactoryOptions.Default;
  TRickUIBuilderFactory.CreateComboBox(FHostForm, FHostForm,
    TRickUIBuilderComboBoxConfig.Default, LOptions, LHandle);
  LSibling := TRectangle.Create(FHostForm);
  LSibling.Parent := FHostForm;
  LSibling.Free;

  Assert.IsTrue(LHandle.IsAttached);
end;

procedure TRickUIBuilderFactoryCreateComboBoxTests.PopupAberto_ParentDestruido_DeveDesanexarHandle;
var
  LOptions: TRickUIBuilderComboBoxFactoryOptions;
  LHandle: IRickUIBuilderComboBoxHandle;
begin
  LOptions := TRickUIBuilderComboBoxFactoryOptions.Default;
  LOptions.Items := TArray<TRickUIBuilderComboBoxItem>.Create(
    TRickUIBuilderComboBoxItem.Create('A'));
  TRickUIBuilderFactory.CreateComboBox(FHostForm, FHostForm,
    TRickUIBuilderComboBoxConfig.Default, LOptions, LHandle);
  LHandle.Open;

  FHostForm.Free;
  FHostForm := nil;

  Assert.IsFalse(LHandle.IsAttached);
  Assert.AreEqual(1, LHandle.Count);
end;

procedure TRickUIBuilderFactoryCreateComboBoxTests.FactoryEFluent_DevemPreservarContratoCompartilhado;
var
  LOptions: TRickUIBuilderComboBoxFactoryOptions;
  LFactoryHandle: IRickUIBuilderComboBoxHandle;
  LFluentHandle: IRickUIBuilderComboBoxHandle;
begin
  LOptions := TRickUIBuilderComboBoxFactoryOptions.Default;
  LOptions.Items := TArray<TRickUIBuilderComboBoxItem>.Create(
    TRickUIBuilderComboBoxItem.Create('Primeiro'),
    TRickUIBuilderComboBoxItem.Create('Segundo'));
  LOptions.SelectionMode := TRickUIBuilderComboBoxInitialSelectionMode.Index;
  LOptions.ItemIndex := 1;
  TRickUIBuilderFactory.CreateComboBox(FHostForm, FHostForm,
    TRickUIBuilderComboBoxConfig.Default, LOptions, LFactoryHandle);
  LFluentHandle := TRickUIBuilder.ComboBox.Items(['Primeiro', 'Segundo'])
    .ItemIndex(1).BuildHandle(FHostForm);

  Assert.AreEqual(LFactoryHandle.Count, LFluentHandle.Count);
  Assert.AreEqual(LFactoryHandle.ItemIndex, LFluentHandle.ItemIndex);
  Assert.AreEqual(LFactoryHandle.SelectedText, LFluentHandle.SelectedText);
end;

procedure TRickUIBuilderFactoryCreateComboBoxTests.FactoryDesktop_DeveResolverDefaultsDeEstilo;
var
  LConfig: TRickUIBuilderComboBoxConfig;
  LOptions: TRickUIBuilderComboBoxFactoryOptions;
  LHandle: IRickUIBuilderComboBoxHandle;
  LContainer: TRectangle;
  LArrow: TPath;
begin
  LConfig := TRickUIBuilderComboBoxConfig.Default;
  LConfig.RequestedStyleType := TRickUIBuilderComboBoxStyleType.Desktop;
  LOptions := TRickUIBuilderComboBoxFactoryOptions.Default;

  LContainer := TRickUIBuilderFactory.CreateComboBox(FHostForm, FHostForm,
    LConfig, LOptions, LHandle);
  LArrow := FindDirectPath(LContainer);

  Assert.AreEqual<Single>(40, LContainer.Height);
  Assert.IsNotNull(LArrow);
  Assert.AreEqual<Single>(20, LArrow.Width);
end;

procedure TRickUIBuilderFactoryCreateComboBoxTests.FactoryMobileAuto_DeveResolverFullWindow;
var
  LConfig: TRickUIBuilderComboBoxConfig;
  LOptions: TRickUIBuilderComboBoxFactoryOptions;
  LHandle: IRickUIBuilderComboBoxHandle;
begin
  LConfig := TRickUIBuilderComboBoxConfig.Default;
  LConfig.RequestedStyleType := TRickUIBuilderComboBoxStyleType.Mobile;
  LConfig.PresentationMode := TRickUIBuilderComboBoxPresentationMode.Auto;
  LOptions := TRickUIBuilderComboBoxFactoryOptions.Default;
  LOptions.Items := TArray<TRickUIBuilderComboBoxItem>.Create(
    TRickUIBuilderComboBoxItem.Create('A'));

  TRickUIBuilderFactory.CreateComboBox(FHostForm, FHostForm, LConfig,
    LOptions, LHandle);
  LHandle.Open;

  Assert.IsNotNull(FindEdit(FHostForm));
end;

procedure TRickUIBuilderFactoryCreateComboBoxTests.FactoryOverrides_DevePreservarDimensoesExplicitas;
var
  LConfig: TRickUIBuilderComboBoxConfig;
  LOptions: TRickUIBuilderComboBoxFactoryOptions;
  LHandle: IRickUIBuilderComboBoxHandle;
  LContainer: TRectangle;
  LArrow: TPath;
  LScrollBox: TVertScrollBox;
  LRow: TRectangle;
begin
  LConfig := TRickUIBuilderComboBoxConfig.Default;
  LConfig.RequestedStyleType := TRickUIBuilderComboBoxStyleType.Desktop;
  LConfig.Height := 77;
  LConfig.ItemHeight := 55;
  LConfig.ArrowSize := 31;
  LConfig.HorizontalPadding := 19;
  LOptions := TRickUIBuilderComboBoxFactoryOptions.Default;
  LOptions.Items := TArray<TRickUIBuilderComboBoxItem>.Create(
    TRickUIBuilderComboBoxItem.Create('A'));
  LContainer := TRickUIBuilderFactory.CreateComboBox(FHostForm, FHostForm,
    LConfig, LOptions, LHandle);
  LArrow := FindDirectPath(LContainer);
  LHandle.Open;
  LScrollBox := FindVertScrollBox(FHostForm);
  Assert.IsNotNull(LScrollBox);
  LRow := FindFirstRow(LScrollBox);

  Assert.AreEqual<Single>(77, LContainer.Height);
  Assert.IsNotNull(LArrow);
  Assert.AreEqual<Single>(31, LArrow.Width);
  Assert.AreEqual<Single>(19, TLabel(LContainer.Children[0]).Position.X);
  Assert.IsNotNull(LRow);
  Assert.AreEqual<Single>(55, LRow.Height);
end;

procedure TRickUIBuilderFactoryCreateComboBoxTests.FactoryPreserveFlag_DevePermitirValorIgualAoDefaultNoMobile;
var
  LConfig: TRickUIBuilderComboBoxConfig;
  LOptions: TRickUIBuilderComboBoxFactoryOptions;
  LHandle: IRickUIBuilderComboBoxHandle;
  LContainer: TRectangle;
  LArrow: TPath;
begin
  LConfig := TRickUIBuilderComboBoxConfig.Default;
  LConfig.RequestedStyleType := TRickUIBuilderComboBoxStyleType.Mobile;
  LOptions := TRickUIBuilderComboBoxFactoryOptions.Default;
  LOptions.PreserveHeight := True;
  LOptions.PreserveArrowSize := True;

  LContainer := TRickUIBuilderFactory.CreateComboBox(FHostForm, FHostForm,
    LConfig, LOptions, LHandle);
  LArrow := FindDirectPath(LContainer);

  Assert.AreEqual<Single>(40, LContainer.Height);
  Assert.IsNotNull(LArrow);
  Assert.AreEqual<Single>(20, LArrow.Width);
end;

procedure TRickUIBuilderFactoryCreateComboBoxTests.FluentOverrides_DevePreservarDimensoesExplicitas;
var
  LHandle: IRickUIBuilderComboBoxHandle;
  LContainer: TRectangle;
  LArrow: TPath;
  LScrollBox: TVertScrollBox;
  LRow: TRectangle;
begin
  LContainer := TRickUIBuilder.ComboBox.Items(['A', 'B'])
    .StyleType(TRickUIBuilderComboBoxStyleType.Desktop)
    .Size(220, 77)
    .ItemHeight(55)
    .ArrowSize(31)
    .Build(FHostForm);
  LArrow := FindDirectPath(LContainer);

  Assert.AreEqual<Single>(77, LContainer.Height);
  Assert.IsNotNull(LArrow);
  Assert.AreEqual<Single>(31, LArrow.Width);

  LHandle := TRickUIBuilder.ComboBox.Items(['A', 'B'])
    .StyleType(TRickUIBuilderComboBoxStyleType.Desktop)
    .ItemHeight(55)
    .BuildHandle(FHostForm);
  LHandle.Open;
  LScrollBox := FindVertScrollBox(FHostForm);
  Assert.IsNotNull(LScrollBox);
  LRow := FindFirstRow(LScrollBox);
  Assert.IsNotNull(LRow);
  Assert.AreEqual<Single>(55, LRow.Height);
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

procedure TRickUIBuilderFactoryCreateButtonTests.DeveRetornarTextLabelCriadoNaSobrecargaComOut;
var
  LButton: TRectangle;
  LTextLabel: TLabel;
begin
  LButton := TRickUIBuilderFactory.CreateButton(FHostForm, FHostForm, 'Instalar',
    TRickUIBuilderButtonConfig.Default, LTextLabel);

  Assert.IsNotNull(LTextLabel, 'O TextLabel de saida nao deveria ser nil.');
  Assert.AreEqual<TFmxObject>(LButton, LTextLabel.Parent,
    'O TextLabel retornado deveria pertencer ao Button criado.');
  Assert.AreEqual('Instalar', LTextLabel.Text,
    'O TextLabel retornado deveria conter o Caption informado.');
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
