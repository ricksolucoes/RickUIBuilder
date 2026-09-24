unit RickUIBuilderSample.Main;
(*
  ==============================================================================
  Unit: RickUIBuilderShowcase.Main
  ==============================================================================

  RESPONSABILIDADE

  Formulario de demonstracao (Showcase) do framework Rick.UIBuilder.
  Constroi, inteiramente em runtime (sem arquivo .fmx associado), uma
  tela dividida em secoes para as abordagens do framework e o ComboBox:

  1. Factory (Opcao A)        - TRickUIBuilder.Factory.Create*
  2. Builders fluentes (Opcao B) - TRickUIBuilder.Label_/Button/Badge/Divider
  3. ComboBox - matriz visual  - TRickUIBuilder.ComboBox
  4. Composicao (meio-termo)  - TRickUIBuilder.On(AParent)

  Este formulario NAO e um exemplo de tela de producao - e uma
  vitrine deliberadamente simples, cujo unico objetivo e permitir a
  verificacao visual manual descrita em docs/showcase-checklist.md a
  cada release do framework.

  Este projeto (Showcase) e um CONSUMIDOR do framework Rick.UIBuilder,
  assim como EFCompras seria - por isso define sua propria paleta de
  cores localmente (constantes desta unit), nunca dentro do
  framework.

  ==============================================================================
*)

interface

uses
  System.SysUtils,
  System.Classes,
  System.UITypes,

  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Objects,
  FMX.StdCtrls,
  FMX.Layouts,
  FMX.Graphics,

  Rick.UIBuilder,
  Rick.UIBuilder.Types,
  Rick.UIBuilder.Interfaces;

type
  TPageSampleMain = class(TForm)
  strict private
    FScroll          : TVertScrollBox;
    FClickCountLabel : TLabel;
    FClickCount      : Integer;

    FHoverStateBadgeHandle : IRickUIBuilderBadgeHandle;
    FComboBoxHandle        : IRickUIBuilderComboBoxHandle;

    function CreateFactoryTextConfig(ATop: Single): TRickUIBuilderTextConfig;
    function CreateFactoryDividerConfig(ATop: Single): TRickUIBuilderDividerConfig;
    function CreateFactoryBadgeConfig(ATop: Single): TRickUIBuilderBadgeConfig;
    function CreateFactoryButtonConfig(ATop: Single): TRickUIBuilderButtonConfig;

    function CreateCompositionTextConfig(ATop: Single): TRickUIBuilderTextConfig;
    function CreateCompositionDividerConfig(ATop: Single): TRickUIBuilderDividerConfig;
    function CreateCompositionBadgeConfig(ATop: Single): TRickUIBuilderBadgeConfig;
    function CreateCompositionButtonConfig(ATop: Single): TRickUIBuilderButtonConfig;

    function AddSectionHeader(const ATitle: string; ATop: Single): Single;
    function AddSubHeader(const AText: string; ATop: Single): Single;

    procedure BuildFactorySection(var ATop: Single);
    procedure BuildFluentLabelDemo(var ATop: Single);
    procedure BuildFluentDividerDemo(var ATop: Single);
    procedure BuildFluentBadgeDemo(var ATop: Single);
    procedure BuildFluentButtonDemo(var ATop: Single);
    function DesktopComboBoxConfig: TRickUIBuilderComboBoxConfig;
    function MobileComboBoxConfig: TRickUIBuilderComboBoxConfig;
    function AdaptiveComboBoxConfig: TRickUIBuilderComboBoxConfig;
    function CustomComboBoxConfig: TRickUIBuilderComboBoxConfig;
    function CustomFullWindowComboBoxConfig: TRickUIBuilderComboBoxConfig;
    procedure BuildDesktopComboBoxDemo(var ATop: Single);
    procedure BuildMobileComboBoxDemo(var ATop: Single);
    procedure BuildAdaptiveComboBoxDemo(var ATop: Single);
    procedure BuildCustomComboBoxDemo(var ATop: Single);
    procedure BuildCustomFullWindowComboBoxDemo(var ATop: Single);
    procedure ConfigureComboStatusBadge(ABadge: TRectangle;
      AColor: TAlphaColor);
    procedure ConfigureComboStatusLabel(ALabel: TLabel; const AText: string);
    procedure AddComboStatusBadge(AContainer: TControl; const AText: string;
      AColor: TAlphaColor);
    procedure CustomizeComboBoxItem(Sender: TObject; AIndex: Integer;
      const AItem: TRickUIBuilderComboBoxItem; AContainer: TControl);
    procedure ConfigureComboBoxRuntime;
    procedure BuildComboBoxDemo(var ATop: Single);
    procedure BuildCompositionSection(var ATop: Single);

    procedure DemoButtonClick(Sender: TObject);
    procedure ConfigureForm;
    procedure BuildInterface;
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  PageSampleMain: TPageSampleMain;

implementation

{$R *.fmx}

const
  // Paleta local do Showcase - o framework Rick.UIBuilder nao conhece
  // nem impoe nenhuma destas cores.
  _BACKGROUND       = $FFF4F5F7;
  _CARD_BG          = $FFFFFFFF;
  _BORDER           = $FFE0E3E8;
  _TEXT_PRIMARY     = $FF1A1D21;
  _TEXT_SECONDARY   = $FF6B7280;
  _DIVIDER          = $FFE0E3E8;

  _PRIMARY          = $FF2563EB;
  _PRIMARY_HOVER    = $FF1D4ED8;
  _SUCCESS_BG       = $FFDCFCE7;
  _SUCCESS_TEXT     = $FF166534;
  _DANGER_BG        = $FFFEE2E2;
  _DANGER_TEXT      = $FF991B1B;

  _COMBO_BLUE_BG    = $FFEFF6FF;
  _COMBO_BLUE       = $FF2563EB;
  _COMBO_GREEN_BG   = $FFF0FDF4;
  _COMBO_GREEN      = $FF15803D;
  _COMBO_PURPLE_BG  = $FFFAF5FF;
  _COMBO_PURPLE     = $FF7E22CE;
  _COMBO_ORANGE_BG  = $FFFFF7ED;
  _COMBO_ORANGE     = $FFC2410C;
  _COMBO_TEAL_BG     = $FFF0FDFA;
  _COMBO_TEAL        = $FF0F766E;

  _CONTENT_LEFT     = 24;
  _CONTENT_WIDTH    = 552;

{ TShowcaseForm }

constructor TPageSampleMain.Create(AOwner: TComponent);
begin
  inherited CreateNew(AOwner);

  ConfigureForm;
  BuildInterface;
end;

procedure TPageSampleMain.ConfigureForm;
begin
  Caption  := 'Rick.UIBuilder - Showcase';
  Width    := 640;
  Height   := 720;
  Position := TFormPosition.ScreenCenter;

  Fill.Kind  := TBrushKind.Solid;
  Fill.Color := _BACKGROUND;
end;

procedure TPageSampleMain.BuildInterface;
var
  LTop: Single;
begin
  FScroll        := TVertScrollBox.Create(Self);
  FScroll.Parent := Self;
  FScroll.Align  := TAlignLayout.Client;

  LTop := 16;

  BuildFactorySection(LTop);
  BuildFluentLabelDemo(LTop);
  BuildFluentDividerDemo(LTop);
  BuildFluentBadgeDemo(LTop);
  BuildFluentButtonDemo(LTop);
  BuildComboBoxDemo(LTop);
  BuildCompositionSection(LTop);
end;

function TPageSampleMain.AddSectionHeader(const ATitle: string;
  ATop: Single): Single;
var
  LConfig: TRickUIBuilderTextConfig;
begin
  LConfig                 := TRickUIBuilderTextConfig.Default;
  LConfig.Left            := _CONTENT_LEFT;
  LConfig.Top             := ATop;
  LConfig.Width           := _CONTENT_WIDTH;
  LConfig.Height          := 28;
  LConfig.FontSize        := 19;
  LConfig.FontColor       := _TEXT_PRIMARY;
  LConfig.Bold            := True;

  TRickUIBuilder.Factory.CreateText(FScroll, FScroll, ATitle, LConfig);

  Result := ATop + 36;
end;

function TPageSampleMain.AddSubHeader(const AText: string; ATop: Single): Single;
var
  LConfig: TRickUIBuilderTextConfig;
begin
  LConfig           := TRickUIBuilderTextConfig.Default;
  LConfig.Left      := _CONTENT_LEFT;
  LConfig.Top       := ATop;
  LConfig.Width     := _CONTENT_WIDTH;
  LConfig.Height    := 20;
  LConfig.FontSize  := 13;
  LConfig.FontColor := _TEXT_SECONDARY;

  TRickUIBuilder.Factory.CreateText(FScroll, FScroll, AText, LConfig);

  Result := ATop + 26;
end;

{ ============================================================
  1) FACTORY (OPCAO A)
  ============================================================ }

function TPageSampleMain.CreateFactoryTextConfig(
  ATop: Single): TRickUIBuilderTextConfig;
begin
  Result           := TRickUIBuilderTextConfig.Default;
  Result.Left      := _CONTENT_LEFT;
  Result.Top       := ATop;
  Result.Width     := _CONTENT_WIDTH;
  Result.Height    := 22;
  Result.FontColor := _TEXT_PRIMARY;
end;

function TPageSampleMain.CreateFactoryDividerConfig(
  ATop: Single): TRickUIBuilderDividerConfig;
begin
  Result       := TRickUIBuilderDividerConfig.Default;
  Result.Left  := _CONTENT_LEFT;
  Result.Top   := ATop;
  Result.Width := _CONTENT_WIDTH;
  Result.Color := _DIVIDER;
end;

function TPageSampleMain.CreateFactoryBadgeConfig(
  ATop: Single): TRickUIBuilderBadgeConfig;
begin
  Result                 := TRickUIBuilderBadgeConfig.Default;
  Result.Left            := _CONTENT_LEFT;
  Result.Top             := ATop;
  Result.Width           := 110;
  Result.Height          := 27;
  Result.BackgroundColor := _SUCCESS_BG;
  Result.TextColor       := _SUCCESS_TEXT;
end;

function TPageSampleMain.CreateFactoryButtonConfig(
  ATop: Single): TRickUIBuilderButtonConfig;
begin
  Result           := TRickUIBuilderButtonConfig.Default;
  Result.Left      := _CONTENT_LEFT;
  Result.Top       := ATop;
  Result.Width     := 180;
  Result.Height    := 40;
  Result.FillColor := _PRIMARY;
  Result.TextColor := TAlphaColors.White;
end;

procedure TPageSampleMain.BuildFactorySection(var ATop: Single);
var
  LTextConfig   : TRickUIBuilderTextConfig;
  LDividerConf  : TRickUIBuilderDividerConfig;
  LBadgeConfig  : TRickUIBuilderBadgeConfig;
  LButtonConfig : TRickUIBuilderButtonConfig;
  LBadgeText    : TLabel;
begin
  ATop := AddSectionHeader('1. Factory (Opcao A)', ATop);
  ATop := AddSubHeader('TRickUIBuilder.Factory.Create* - criacao direta via record de config',
    ATop);

  // CreateText
  LTextConfig := CreateFactoryTextConfig(ATop);
  TRickUIBuilder.Factory.CreateText(FScroll, FScroll,
    'CreateText: este texto foi criado por TRickUIBuilderFactory.CreateText.',
    LTextConfig);
  ATop := ATop + 30;

  // CreateDivider
  LDividerConf := CreateFactoryDividerConfig(ATop);
  TRickUIBuilder.Factory.CreateDivider(FScroll, FScroll, LDividerConf);
  ATop := ATop + 16;

  // CreateBadge
  LBadgeConfig := CreateFactoryBadgeConfig(ATop);
  TRickUIBuilder.Factory.CreateBadge(FScroll, FScroll, 'CreateBadge',
    LBadgeConfig, LBadgeText);
  ATop := ATop + 40;

  // CreateButton
  LButtonConfig := CreateFactoryButtonConfig(ATop);
  TRickUIBuilder.Factory.CreateButton(FScroll, FScroll, 'CreateButton',
    LButtonConfig);
  ATop := ATop + 56;
end;

{ ============================================================
  2) BUILDERS FLUENTES (OPCAO B)
  ============================================================ }

procedure TPageSampleMain.BuildFluentLabelDemo(var ATop: Single);
begin
  ATop := AddSectionHeader('2. Builders fluentes (Opcao B)', ATop);
  ATop := AddSubHeader('IRickUIBuilderLabel - Text, FontSize, Bold, FontColor, Margin',
    ATop);

  TRickUIBuilder.Label_
    .Text('Label via builder fluente, em negrito e com Margin aplicada.')
    .Position(_CONTENT_LEFT, ATop)
    .Size(_CONTENT_WIDTH, 22)
    .FontSize(14)
    .FontColor(_TEXT_PRIMARY)
    .Bold(True)
    .Margin(TRickUIBuilderSpacing.Uniform(0))
    .Build(FScroll);

  ATop := ATop + 34;
end;

procedure TPageSampleMain.BuildFluentDividerDemo(var ATop: Single);
begin
  ATop := AddSubHeader('IRickUIBuilderDivider - Thickness e Orientation', ATop);

  TRickUIBuilder.Divider
    .Position(_CONTENT_LEFT, ATop)
    .Width(_CONTENT_WIDTH)
    .Thickness(2)
    .Orientation(TOrientation.Horizontal)
    .Color(_PRIMARY)
    .Build(FScroll);

  ATop := ATop + 20;
end;

procedure TPageSampleMain.BuildFluentBadgeDemo(var ATop: Single);
begin
  ATop := AddSubHeader('IRickUIBuilderBadge - Pill(True) vs Pill(False)+CornerRadius',
    ATop);

  TRickUIBuilder.Badge
    .Text('Pill (True)')
    .Position(_CONTENT_LEFT, ATop)
    .Size(110, 27)
    .Pill(True)
    .BackgroundColor(_SUCCESS_BG)
    .TextColor(_SUCCESS_TEXT)
    .Build(FScroll);

  FHoverStateBadgeHandle := TRickUIBuilder.Badge
    .Text('Pill (False)')
    .Position(_CONTENT_LEFT + 120, ATop)
    .Size(110, 27)
    .Pill(False)
    .CornerRadius(6)
    .BackgroundColor(_DANGER_BG)
    .TextColor(_DANGER_TEXT)
    .Build(FScroll);

  ATop := ATop + 44;
end;

procedure TPageSampleMain.DemoButtonClick(Sender: TObject);
begin
  Inc(FClickCount);
  FClickCountLabel.Text := Format('Cliques: %d', [FClickCount]);
end;

procedure TPageSampleMain.BuildFluentButtonDemo(var ATop: Single);
begin
  ATop := AddSubHeader('IRickUIBuilderButton - HoverFillColor + OnHover + OnClick',
    ATop);

  TRickUIBuilder.Button
    .Caption('Passe o mouse e clique')
    .Position(_CONTENT_LEFT, ATop)
    .Size(220, 40)
    .FillColor(_PRIMARY)
    .HoverFillColor(_PRIMARY_HOVER)
    .TextColor(TAlphaColors.White)
    .OnClick(DemoButtonClick)
    .Build(FScroll);

  FClickCountLabel := TRickUIBuilder.Label_
    .Text('Cliques: 0')
    .Position(_CONTENT_LEFT + 232, ATop + 10)
    .Size(150, 22)
    .FontColor(_TEXT_SECONDARY)
    .Build(FScroll);

  ATop := ATop + 56;
end;

{ ============================================================
  3) COMBOBOX - ESTILOS, APRESENTACOES E TIPOS DE LISTA
  ============================================================ }

function TPageSampleMain.DesktopComboBoxConfig: TRickUIBuilderComboBoxConfig;
begin
  Result := TRickUIBuilderComboBoxConfig.Default;
  Result.Width := _CONTENT_WIDTH;
  Result.BackgroundColor := _COMBO_BLUE_BG;
  Result.BorderColor := _COMBO_BLUE;
  Result.PopupColor := TAlphaColors.White;
  Result.HoverColor := $FFDBEAFE;
  Result.SelectedColor := $FFBFDBFE;
  Result.ArrowColor := _COMBO_BLUE;
end;

function TPageSampleMain.MobileComboBoxConfig: TRickUIBuilderComboBoxConfig;
begin
  Result := TRickUIBuilderComboBoxConfig.Default;
  Result.Width := _CONTENT_WIDTH;
  Result.Height := 48;
  Result.ItemHeight := 48;
  Result.BackgroundColor := _COMBO_GREEN_BG;
  Result.BorderColor := _COMBO_GREEN;
  Result.PopupColor := $FFF7FFF9;
  Result.HoverColor := $FFDCFCE7;
  Result.SelectedColor := $FFBBF7D0;
  Result.ArrowColor := _COMBO_GREEN;
  Result.FullWindowBackgroundColor := TAlphaColors.White;
  Result.SearchFieldBorderColor := $FF98A2B3;
  Result.SearchIconColor := _COMBO_GREEN;
  Result.NoResultsIconColor := _COMBO_GREEN;
end;

function TPageSampleMain.AdaptiveComboBoxConfig: TRickUIBuilderComboBoxConfig;
begin
  Result := TRickUIBuilderComboBoxConfig.Default;
  Result.Width := _CONTENT_WIDTH;
{$IF Defined(ANDROID) or Defined(IOS)}
  Result.Height := 48;
  Result.ItemHeight := 48;
{$ENDIF}
  Result.BackgroundColor := _COMBO_PURPLE_BG;
  Result.BorderColor := _COMBO_PURPLE;
  Result.PopupColor := $FFFEFBFF;
  Result.HoverColor := $FFF3E8FF;
  Result.SelectedColor := $FFE9D5FF;
  Result.ArrowColor := _COMBO_PURPLE;
end;

function TPageSampleMain.CustomComboBoxConfig: TRickUIBuilderComboBoxConfig;
begin
  Result := TRickUIBuilderComboBoxConfig.Default;
  Result.Width := _CONTENT_WIDTH;
  Result.Height := 44;
  Result.ItemHeight := 40;
  Result.BackgroundColor := _COMBO_ORANGE_BG;
  Result.BorderColor := _COMBO_ORANGE;
  Result.PopupColor := $FFFFFCF8;
  Result.HoverColor := $FFFFEDD5;
  Result.SelectedColor := $FFFED7AA;
  Result.ArrowColor := _COMBO_ORANGE;
end;

function TPageSampleMain.CustomFullWindowComboBoxConfig:
  TRickUIBuilderComboBoxConfig;
begin
  Result := TRickUIBuilderComboBoxConfig.Default;
  Result.Width := _CONTENT_WIDTH;
  Result.BackgroundColor := _COMBO_TEAL_BG;
  Result.BorderColor := _COMBO_TEAL;
  Result.PopupColor := TAlphaColors.White;
  Result.HoverColor := $FFCCFBF1;
  Result.SelectedColor := $FF99F6E4;
  Result.ArrowColor := _COMBO_TEAL;
  Result.SearchIconColor := _COMBO_TEAL;
  Result.NoResultsIconColor := _COMBO_TEAL;
end;

procedure TPageSampleMain.BuildDesktopComboBoxDemo(var ATop: Single);
begin
  ATop := AddSubHeader('Desktop + Anchored - lista textual simples', ATop);
  TRickUIBuilder.ComboBox
    .CustomConfig(DesktopComboBoxConfig)
    .StyleType(TRickUIBuilderComboBoxStyleType.Desktop)
    .PresentationMode(TRickUIBuilderComboBoxPresentationMode.Anchored)
    .Position(_CONTENT_LEFT, ATop)
    .Size(_CONTENT_WIDTH, 42)
    .Items(['Pequeno', 'Medio', 'Grande', 'Extra grande'])
    .ItemIndex(1)
    .ArrowPosition(TRickUIBuilderComboBoxArrowPosition.Right)
    .ArrowMargins(8, 4, 16, 4)
    .ArrowSize(14)
    .Build(FScroll);
  ATop := ATop + 58;
end;

procedure TPageSampleMain.BuildMobileComboBoxDemo(var ATop: Single);
begin
  ATop := AddSubHeader('Mobile + Auto - FullWindow com pesquisa em tempo real', ATop);
  TRickUIBuilder.ComboBox
    .CustomConfig(MobileComboBoxConfig)
    .StyleType(TRickUIBuilderComboBoxStyleType.Mobile)
    .PresentationMode(TRickUIBuilderComboBoxPresentationMode.Auto)
    .Position(_CONTENT_LEFT, ATop)
    .AddItem('Rio de Janeiro', 'RJ')
    .AddItem('Riviera de São Lourenço, SP', 'RIVIERA')
    .AddItem('Ribeirão Preto, SP', 'RAO')
    .AddItem('Copacabana, Rio de Janeiro, RJ', 'COPA')
    .AddItem('Rio das Ostras, RJ', 'RIO_OSTRAS')
    .ItemIndex(0)
    .SearchPlaceholder('Pesquisar cidade...')
    .NoResultsText('Nenhuma cidade encontrada')
    .ArrowPosition(TRickUIBuilderComboBoxArrowPosition.Right)
    .ArrowMargins(10, 6, 18, 6)
    .ArrowSize(16)
    .Build(FScroll);
  ATop := ATop + 64;
end;

procedure TPageSampleMain.BuildAdaptiveComboBoxDemo(var ATop: Single);
var
  LCodeColumn: TRickUIBuilderComboBoxColumn;
  LDescriptionColumn: TRickUIBuilderComboBoxColumn;
begin
  ATop := AddSubHeader('Adaptive + Auto - lista estruturada em duas colunas', ATop);
  LCodeColumn := TRickUIBuilderComboBoxColumn.Create(
    TRickUIBuilderComboBoxColumnSizeMode.Fixed, 90);
  LDescriptionColumn := TRickUIBuilderComboBoxColumn.Create(
    TRickUIBuilderComboBoxColumnSizeMode.Proportional, 1);
  FComboBoxHandle := TRickUIBuilder.ComboBox
    .CustomConfig(AdaptiveComboBoxConfig)
    .StyleType(TRickUIBuilderComboBoxStyleType.Adaptive)
    .PresentationMode(TRickUIBuilderComboBoxPresentationMode.Auto)
    .Position(_CONTENT_LEFT, ATop)
    .Column(LCodeColumn)
    .Column(LDescriptionColumn)
    .AddStructuredItem('Notebook Core i7', '001', ['001', 'Notebook Core i7'])
    .AddStructuredItem('Monitor 27', '002', ['002', 'Monitor 27'])
    .AddStructuredItem('Teclado mecanico', '003', ['003', 'Teclado mecanico'])
    .SelectedText('Monitor 27')
    .ArrowPosition(TRickUIBuilderComboBoxArrowPosition.Right)
    .ArrowMargins(8, 4, 14, 4)
    .ArrowSize(14)
    .BuildHandle(FScroll);
  ATop := ATop + 58;
end;

procedure TPageSampleMain.ConfigureComboStatusBadge(ABadge: TRectangle;
  AColor: TAlphaColor);
begin
  ABadge.Align := TAlignLayout.Right;
  ABadge.Width := 72;
  ABadge.Margins.Left := 4;
  ABadge.Margins.Top := 7;
  ABadge.Margins.Right := 8;
  ABadge.Margins.Bottom := 7;
  ABadge.Fill.Color := AColor;
  ABadge.Stroke.Kind := TBrushKind.None;
  ABadge.XRadius := 8;
  ABadge.YRadius := 8;
  ABadge.HitTest := False;
end;

procedure TPageSampleMain.ConfigureComboStatusLabel(ALabel: TLabel;
  const AText: string);
begin
  ALabel.Align := TAlignLayout.Client;
  ALabel.Text := AText;
  ALabel.TextSettings.HorzAlign := TTextAlign.Center;
  ALabel.TextSettings.VertAlign := TTextAlign.Center;
  ALabel.TextSettings.FontColor := TAlphaColors.White;
  ALabel.StyledSettings := ALabel.StyledSettings - [TStyledSetting.FontColor];
  ALabel.HitTest := False;
end;

procedure TPageSampleMain.AddComboStatusBadge(AContainer: TControl;
  const AText: string; AColor: TAlphaColor);
var
  LBadge: TRectangle;
  LLabel: TLabel;
begin
  LBadge := TRectangle.Create(AContainer);
  LBadge.Parent := AContainer;
  ConfigureComboStatusBadge(LBadge, AColor);
  LLabel := TLabel.Create(LBadge);
  LLabel.Parent := LBadge;
  ConfigureComboStatusLabel(LLabel, AText);
end;

procedure TPageSampleMain.CustomizeComboBoxItem(Sender: TObject; AIndex: Integer;
  const AItem: TRickUIBuilderComboBoxItem; AContainer: TControl);
begin
  if Odd(AIndex) then
    AddComboStatusBadge(AContainer, 'Novo', _COMBO_ORANGE)
  else
    AddComboStatusBadge(AContainer, 'Ativo', _SUCCESS_TEXT);
end;

procedure TPageSampleMain.BuildCustomComboBoxDemo(var ATop: Single);
var
  LCodeColumn: TRickUIBuilderComboBoxColumn;
  LDescriptionColumn: TRickUIBuilderComboBoxColumn;
  LStatusColumn: TRickUIBuilderComboBoxColumn;
begin
  ATop := AddSubHeader(
    'Custom + Anchored - tres colunas, owner-draw e seta a esquerda', ATop);
  LCodeColumn := TRickUIBuilderComboBoxColumn.Create(
    TRickUIBuilderComboBoxColumnSizeMode.Fixed, 78);
  LDescriptionColumn := TRickUIBuilderComboBoxColumn.Create(
    TRickUIBuilderComboBoxColumnSizeMode.Proportional, 1);
  LStatusColumn := TRickUIBuilderComboBoxColumn.Create(
    TRickUIBuilderComboBoxColumnSizeMode.Fixed, 92);
  TRickUIBuilder.ComboBox.CustomConfig(CustomComboBoxConfig)
    .StyleType(TRickUIBuilderComboBoxStyleType.Custom)
    .PresentationMode(TRickUIBuilderComboBoxPresentationMode.Anchored)
    .Position(_CONTENT_LEFT, ATop).Column(LCodeColumn)
    .Column(LDescriptionColumn).Column(LStatusColumn)
    .AddStructuredItem('Financeiro', 'FIN', ['FIN', 'Financeiro', ''])
    .AddStructuredItem('Comercial', 'COM', ['COM', 'Comercial', ''])
    .AddStructuredItem('Tecnologia', 'TEC', ['TEC', 'Tecnologia', ''])
    .AddStructuredItem('Operacoes', 'OPE', ['OPE', 'Operacoes', ''])
    .ItemIndex(2).ArrowPosition(TRickUIBuilderComboBoxArrowPosition.Left)
    .ArrowMargins(14, 5, 10, 5).ArrowSize(14)
    .OnCustomizeItem(CustomizeComboBoxItem).Build(FScroll);
  ATop := ATop + 60;
end;

procedure TPageSampleMain.BuildCustomFullWindowComboBoxDemo(
  var ATop: Single);
begin
  ATop := AddSubHeader(
    'Custom + FullWindow - mesmas colunas em apresentacao de tela cheia', ATop);
  TRickUIBuilder.ComboBox.CustomConfig(CustomFullWindowComboBoxConfig)
    .StyleType(TRickUIBuilderComboBoxStyleType.Custom)
    .PresentationMode(TRickUIBuilderComboBoxPresentationMode.FullWindow)
    .Position(_CONTENT_LEFT, ATop)
    .Column(TRickUIBuilderComboBoxColumn.Create(
      TRickUIBuilderComboBoxColumnSizeMode.Fixed, 86))
    .Column(TRickUIBuilderComboBoxColumn.Create(
      TRickUIBuilderComboBoxColumnSizeMode.Proportional, 1))
    .AddStructuredItem('Cliente ativo', 'ATV', ['ATV', 'Cliente ativo'])
    .AddStructuredItem('Cliente bloqueado', 'BLQ', ['BLQ', 'Cliente bloqueado'])
    .AddStructuredItem('Cliente pendente', 'PEN', ['PEN', 'Cliente pendente'])
    .ItemIndex(0).SearchPlaceholder('Pesquisar status...')
    .NoResultsText('Nenhum status encontrado')
    .OnCustomizeItem(CustomizeComboBoxItem)
    .ArrowPosition(TRickUIBuilderComboBoxArrowPosition.Right)
    .ArrowMargins(8, 5, 14, 5).ArrowSize(14).Build(FScroll);
  ATop := ATop + 62;
end;

procedure TPageSampleMain.ConfigureComboBoxRuntime;
begin
  FComboBoxHandle.SetArrowColor(_COMBO_PURPLE);
  FComboBoxHandle.Add('Mouse sem fio', '004');
  FComboBoxHandle.AddRange(['Headset', 'Webcam']);
end;

procedure TPageSampleMain.BuildComboBoxDemo(var ATop: Single);
begin
  ATop := AddSectionHeader('3. ComboBox - matriz visual', ATop);
  ATop := AddSubHeader(
    'Anchored e FullWindow; pesquisa, Value, colunas e owner-draw',
    ATop);
  BuildDesktopComboBoxDemo(ATop);
  BuildMobileComboBoxDemo(ATop);
  BuildAdaptiveComboBoxDemo(ATop);
  ConfigureComboBoxRuntime;
  BuildCustomComboBoxDemo(ATop);
  BuildCustomFullWindowComboBoxDemo(ATop);
  ATop := ATop + 8;
end;

{ ============================================================
  4) COMPOSICAO (MEIO-TERMO)
  ============================================================ }
function TPageSampleMain.CreateCompositionTextConfig(
  ATop: Single): TRickUIBuilderTextConfig;
begin
  Result           := TRickUIBuilderTextConfig.Default;
  Result.Left      := _CONTENT_LEFT;
  Result.Top       := ATop;
  Result.Width     := _CONTENT_WIDTH;
  Result.Height    := 22;
  Result.FontColor := _TEXT_PRIMARY;
end;

function TPageSampleMain.CreateCompositionDividerConfig(
  ATop: Single): TRickUIBuilderDividerConfig;
begin
  Result       := TRickUIBuilderDividerConfig.Default;
  Result.Left  := _CONTENT_LEFT;
  Result.Top   := ATop + 30;
  Result.Width := _CONTENT_WIDTH;
  Result.Color := _DIVIDER;
end;

function TPageSampleMain.CreateCompositionBadgeConfig(
  ATop: Single): TRickUIBuilderBadgeConfig;
begin
  Result                 := TRickUIBuilderBadgeConfig.Default;
  Result.Left            := _CONTENT_LEFT;
  Result.Top             := ATop + 46;
  Result.Width           := 130;
  Result.Height          := 27;
  Result.BackgroundColor := _SUCCESS_BG;
  Result.TextColor       := _SUCCESS_TEXT;
end;

function TPageSampleMain.CreateCompositionButtonConfig(
  ATop: Single): TRickUIBuilderButtonConfig;
begin
  Result           := TRickUIBuilderButtonConfig.Default;
  Result.Left      := _CONTENT_LEFT;
  Result.Top       := ATop + 84;
  Result.Width     := 180;
  Result.Height    := 40;
  Result.FillColor := _PRIMARY;
  Result.TextColor := TAlphaColors.White;
end;

procedure TPageSampleMain.BuildCompositionSection(var ATop: Single);
var
  LTextConfig   : TRickUIBuilderTextConfig;
  LDividerConf  : TRickUIBuilderDividerConfig;
  LButtonConfig : TRickUIBuilderButtonConfig;
  LBadgeConfig  : TRickUIBuilderBadgeConfig;
  LBadgeHandle  : IRickUIBuilderBadgeHandle;
begin
  ATop := AddSectionHeader('4. Composicao (meio-termo)', ATop);
  ATop := AddSubHeader('TRickUIBuilder.On(AParent).AddText/AddDivider/AddBadge/AddButton',
    ATop);

  LTextConfig   := CreateCompositionTextConfig(ATop);
  LDividerConf  := CreateCompositionDividerConfig(ATop);
  LBadgeConfig  := CreateCompositionBadgeConfig(ATop);
  LButtonConfig := CreateCompositionButtonConfig(ATop);

  TRickUIBuilder.On(FScroll)
    .AddText('Sequencia inteira criada em uma unica cadeia fluente.', LTextConfig)
    .AddDivider(LDividerConf)
    .AddBadge('Composicao', LBadgeConfig, LBadgeHandle)
    .AddButton('Botao da composicao', LButtonConfig, nil);

  ATop := ATop + 140;
end;

end.
