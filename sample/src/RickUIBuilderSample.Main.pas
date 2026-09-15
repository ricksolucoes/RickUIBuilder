unit RickUIBuilderSample.Main;
(*
  ==============================================================================
  Unit: RickUIBuilderShowcase.Main
  ==============================================================================

  RESPONSABILIDADE

  Formulario de demonstracao (Showcase) do framework Rick.UIBuilder.
  Constroi, inteiramente em runtime (sem arquivo .fmx associado), uma
  tela dividida em 3 secoes - uma para cada abordagem do framework:

  1. Factory (Opcao A)        - TRickUIBuilder.Factory.Create*
  2. Builders fluentes (Opcao B) - TRickUIBuilder.Label_/Button/Badge/Divider
  3. Composicao (meio-termo)  - TRickUIBuilder.On(AParent)

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

    function AddSectionHeader(const ATitle: string; ATop: Single): Single;
    function AddSubHeader(const AText: string; ATop: Single): Single;

    procedure BuildFactorySection(var ATop: Single);
    procedure BuildFluentLabelDemo(var ATop: Single);
    procedure BuildFluentDividerDemo(var ATop: Single);
    procedure BuildFluentBadgeDemo(var ATop: Single);
    procedure BuildFluentButtonDemo(var ATop: Single);
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
  LTextConfig           := TRickUIBuilderTextConfig.Default;
  LTextConfig.Left      := _CONTENT_LEFT;
  LTextConfig.Top       := ATop;
  LTextConfig.Width     := _CONTENT_WIDTH;
  LTextConfig.Height    := 22;
  LTextConfig.FontColor := _TEXT_PRIMARY;
  TRickUIBuilder.Factory.CreateText(FScroll, FScroll,
    'CreateText: este texto foi criado por TRickUIBuilderFactory.CreateText.',
    LTextConfig);
  ATop := ATop + 30;

  // CreateDivider
  LDividerConf       := TRickUIBuilderDividerConfig.Default;
  LDividerConf.Left  := _CONTENT_LEFT;
  LDividerConf.Top   := ATop;
  LDividerConf.Width := _CONTENT_WIDTH;
  LDividerConf.Color := _DIVIDER;
  TRickUIBuilder.Factory.CreateDivider(FScroll, FScroll, LDividerConf);
  ATop := ATop + 16;

  // CreateBadge
  LBadgeConfig                 := TRickUIBuilderBadgeConfig.Default;
  LBadgeConfig.Left            := _CONTENT_LEFT;
  LBadgeConfig.Top             := ATop;
  LBadgeConfig.Width           := 110;
  LBadgeConfig.Height          := 27;
  LBadgeConfig.BackgroundColor := _SUCCESS_BG;
  LBadgeConfig.TextColor       := _SUCCESS_TEXT;
  TRickUIBuilder.Factory.CreateBadge(FScroll, FScroll, 'CreateBadge',
    LBadgeConfig, LBadgeText);
  ATop := ATop + 40;

  // CreateButton
  LButtonConfig             := TRickUIBuilderButtonConfig.Default;
  LButtonConfig.Left        := _CONTENT_LEFT;
  LButtonConfig.Top         := ATop;
  LButtonConfig.Width       := 180;
  LButtonConfig.Height      := 40;
  LButtonConfig.FillColor   := _PRIMARY;
  LButtonConfig.TextColor   := TAlphaColors.White;
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
  3) COMPOSICAO (MEIO-TERMO)
  ============================================================ }

procedure TPageSampleMain.BuildCompositionSection(var ATop: Single);
var
  LTextConfig   : TRickUIBuilderTextConfig;
  LDividerConf  : TRickUIBuilderDividerConfig;
  LButtonConfig : TRickUIBuilderButtonConfig;
  LBadgeConfig  : TRickUIBuilderBadgeConfig;
  LBadgeHandle  : IRickUIBuilderBadgeHandle;
begin
  ATop := AddSectionHeader('3. Composicao (meio-termo)', ATop);
  ATop := AddSubHeader('TRickUIBuilder.On(AParent).AddText/AddDivider/AddBadge/AddButton',
    ATop);

  LTextConfig           := TRickUIBuilderTextConfig.Default;
  LTextConfig.Left      := _CONTENT_LEFT;
  LTextConfig.Top       := ATop;
  LTextConfig.Width     := _CONTENT_WIDTH;
  LTextConfig.Height    := 22;
  LTextConfig.FontColor := _TEXT_PRIMARY;

  LDividerConf       := TRickUIBuilderDividerConfig.Default;
  LDividerConf.Left  := _CONTENT_LEFT;
  LDividerConf.Top   := ATop + 30;
  LDividerConf.Width := _CONTENT_WIDTH;
  LDividerConf.Color := _DIVIDER;

  LBadgeConfig                 := TRickUIBuilderBadgeConfig.Default;
  LBadgeConfig.Left            := _CONTENT_LEFT;
  LBadgeConfig.Top             := ATop + 46;
  LBadgeConfig.Width           := 130;
  LBadgeConfig.Height          := 27;
  LBadgeConfig.BackgroundColor := _SUCCESS_BG;
  LBadgeConfig.TextColor       := _SUCCESS_TEXT;

  LButtonConfig             := TRickUIBuilderButtonConfig.Default;
  LButtonConfig.Left        := _CONTENT_LEFT;
  LButtonConfig.Top         := ATop + 84;
  LButtonConfig.Width       := 180;
  LButtonConfig.Height      := 40;
  LButtonConfig.FillColor   := _PRIMARY;
  LButtonConfig.TextColor   := TAlphaColors.White;

  TRickUIBuilder.On(FScroll)
    .AddText('Sequencia inteira criada em uma unica cadeia fluente.', LTextConfig)
    .AddDivider(LDividerConf)
    .AddBadge('Composicao', LBadgeConfig, LBadgeHandle)
    .AddButton('Botao da composicao', LButtonConfig, nil);

  ATop := ATop + 140;
end;

end.
