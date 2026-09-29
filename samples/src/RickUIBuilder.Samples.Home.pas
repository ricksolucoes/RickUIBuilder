unit RickUIBuilder.Samples.Home;
(*
  ==============================================================================
  Unit: RickUIBuilder.Samples.Home
  ==============================================================================

  OBJETIVO

  Orquestra a pagina inicial do RickUIBuilder.Samples. A Home apresenta as
  abordagens publicas confirmadas sem concentrar detalhes de componentes ou
  implementar navegacao antecipadamente.

  RESPONSABILIDADE

  - configurar a janela inicial;
  - compor cabecalho, area de abordagens e rodape;
  - definir o conteudo de Factory, Fluent Builder e Composition;
  - posicionar os cards das abordagens;
  - manter o layout da pagina durante redimensionamento.

  LIMITES

  - nao demonstra componentes;
  - nao conhece cenarios internos de componentes;
  - nao implementa links ou rotas nesta etapa;
  - nao concentra a construcao visual interna dos cards;
  - nao define Design System global do aplicativo.

  ==============================================================================
*)

interface

uses
  System.Classes,

  FMX.Forms,
  FMX.Layouts;

type
  /// <summary>
  ///   Representa a pagina inicial do Samples e orquestra a apresentacao das
  ///   abordagens publicas confirmadas do Rick.UIBuilder.
  /// </summary>
  TPageSamplesHome = class(TForm)
  strict private
    FContent: TLayout;
    FCardsLayout: TLayout;

    /// <summary>
    ///   Configura as propriedades estruturais da janela inicial.
    /// </summary>
    procedure ConfigureForm;

    /// <summary>
    ///   Monta os blocos semanticos da Home e aplica o layout inicial.
    /// </summary>
    procedure BuildInterface;

    /// <summary>
    ///   Apresenta o proposito do catalogo antes das abordagens disponiveis.
    /// </summary>
    procedure BuildHeader;

    /// <summary>
    ///   Adiciona o badge de identificacao do Rick.UIBuilder ao cabecalho.
    /// </summary>
    procedure AddHeaderBadge;

    /// <summary>
    ///   Adiciona o titulo principal da Home ao cabecalho.
    /// </summary>
    procedure AddHeaderTitle;

    /// <summary>
    ///   Adiciona a descricao introdutoria da Home ao cabecalho.
    /// </summary>
    procedure AddHeaderDescription;

    /// <summary>
    ///   Cria o container dos cards e delega a configuracao de cada abordagem.
    /// </summary>
    procedure BuildApproachCards;

    /// <summary>
    ///   Configura o conteudo e a posicao do card da Factory.
    /// </summary>
    procedure BuildFactoryCard;

    /// <summary>
    ///   Configura o conteudo e a posicao do card do Fluent Builder.
    /// </summary>
    procedure BuildFluentCard;

    /// <summary>
    ///   Configura o conteudo e a posicao do card de Composition.
    /// </summary>
    procedure BuildCompositionCard;

    /// <summary>
    ///   Apresenta o limite funcional desta primeira entrega da Home.
    /// </summary>
    procedure BuildFooter;

    /// <summary>
    ///   Centraliza o conteudo da Home e preserva a largura dos cards.
    /// </summary>
    procedure LayoutContent;

    /// <summary>
    ///   Reaplica o posicionamento da Home quando a janela e redimensionada.
    /// </summary>
    procedure FormResized(ASender: TObject);
  public
    /// <summary>
    ///   Cria a pagina principal e monta sua interface inicial.
    /// </summary>
    constructor Create(AOwner: TComponent); override;
  end;

var
  PageSamplesHome: TPageSamplesHome;

implementation

uses
  FMX.Graphics,
  FMX.Objects,
  FMX.Types,

  Rick.UIBuilder,
  RickUIBuilder.Samples.Home.ApproachCard,
  RickUIBuilder.Samples.Home.Style;

{ TPageSamplesHome }

constructor TPageSamplesHome.Create(AOwner: TComponent);
begin
  inherited CreateNew(AOwner);

  ConfigureForm;
  BuildInterface;
end;

procedure TPageSamplesHome.ConfigureForm;
begin
  Caption := 'Rick.UIBuilder - Samples';
  Width := 1120;
  Height := 720;
  Position := TFormPosition.ScreenCenter;
  Fill.Kind := TBrushKind.Solid;
  Fill.Color := _HOME_BACKGROUND_;
  OnResize := FormResized;
end;

procedure TPageSamplesHome.BuildInterface;
begin
  FContent := TLayout.Create(Self);
  FContent.Parent := Self;
  FContent.SetBounds(0, 0, _HOME_CONTENT_MAX_WIDTH_, ClientHeight);

  BuildHeader;
  BuildApproachCards;
  BuildFooter;
  LayoutContent;
end;

procedure TPageSamplesHome.BuildHeader;
begin
  AddHeaderBadge;
  AddHeaderTitle;
  AddHeaderDescription;
end;

procedure TPageSamplesHome.AddHeaderBadge;
begin
  TRickUIBuilder.Badge
    .Text('RICK.UIBUILDER')
    .Position(0, 36)
    .Size(126, 28)
    .Pill(True)
    .BackgroundColor(_HOME_PRIMARY_SOFT_)
    .TextColor(_HOME_PRIMARY_)
    .FontSize(11)
    .Bold(True)
    .Build(FContent);
end;

procedure TPageSamplesHome.AddHeaderTitle;
begin
  TRickUIBuilder.Label_
    .Text('Escolha como voce quer construir a interface')
    .Position(0, 82)
    .Size(_HOME_CONTENT_MAX_WIDTH_, 42)
    .FontSize(28)
    .FontColor(_HOME_TEXT_PRIMARY_)
    .Bold(True)
    .Build(FContent);
end;

procedure TPageSamplesHome.AddHeaderDescription;
begin
  TRickUIBuilder.Label_
    .Text('Explore cada abordagem separadamente, com exemplos focados nos ' +
      'recursos que a API publica oferece hoje.')
    .Position(0, 130)
    .Size(_HOME_CONTENT_MAX_WIDTH_, 48)
    .FontSize(14)
    .FontColor(_HOME_TEXT_SECONDARY_)
    .WordWrap(True)
    .Build(FContent);
end;

procedure TPageSamplesHome.BuildApproachCards;
begin
  FCardsLayout := TLayout.Create(Self);
  FCardsLayout.Parent := FContent;
  FCardsLayout.Position.Y := 206;
  FCardsLayout.Height := _HOME_CARD_HEIGHT_;

  BuildFactoryCard;
  BuildFluentCard;
  BuildCompositionCard;
end;

procedure TPageSamplesHome.BuildFactoryCard;
var
  LCard: TRectangle;
begin
  LCard := TApproachCard.New
    .Parent(FCardsLayout)
    .Tag('OPCAO A')
    .Title('Factory')
    .Description('Criacao direta para cenarios objetivos, usando ' +
      'configuracoes explicitas e uma chamada de criacao.')
    .Availability('Text  |  Button  |  Badge  |  Divider  |  ComboBox')
    .Build;
  LCard.Position.X := 0;
end;

procedure TPageSamplesHome.BuildFluentCard;
var
  LCard: TRectangle;
begin
  LCard := TApproachCard.New
    .Parent(FCardsLayout)
    .Tag('OPCAO B')
    .Title('Fluent Builder')
    .Description('Configuracao encadeada para composicoes que pedem leitura ' +
      'progressiva e maior variacao de propriedades.')
    .Availability('Label  |  Button  |  Badge  |  Divider  |  ComboBox  |  Edit')
    .Build;
  LCard.Position.X := _HOME_CARD_WIDTH_ + _HOME_CARD_GAP_;
end;

procedure TPageSamplesHome.BuildCompositionCard;
var
  LCard: TRectangle;
begin
  LCard := TApproachCard.New
    .Parent(FCardsLayout)
    .Tag('COMPOSICAO')
    .Title('On(AParent)')
    .Description('Ponto intermediario para adicionar controles a um Parent ' +
      'conhecido sem abrir mao de uma API orientada a composicao.')
    .Availability('TRickUIBuilder.On(AParent)')
    .Build;
  LCard.Position.X := (_HOME_CARD_WIDTH_ + _HOME_CARD_GAP_) * 2;
end;

procedure TPageSamplesHome.BuildFooter;
begin
  TRickUIBuilder.Label_
    .Text('A navegacao por abordagem sera adicionada nas proximas etapas.')
    .Position(0, 574)
    .Size(_HOME_CONTENT_MAX_WIDTH_, 24)
    .FontSize(12)
    .FontColor(_HOME_TEXT_SECONDARY_)
    .Build(FContent);
end;

procedure TPageSamplesHome.LayoutContent;
var
  LAvailableWidth: Single;
  LContentLeft: Single;
  LCardsWidth: Single;
begin
  LAvailableWidth := ClientWidth - (_HOME_CONTENT_MARGIN_ * 2);
  if LAvailableWidth > _HOME_CONTENT_MAX_WIDTH_ then
    LAvailableWidth := _HOME_CONTENT_MAX_WIDTH_;

  LContentLeft := (ClientWidth - LAvailableWidth) / 2;
  LCardsWidth := (_HOME_CARD_WIDTH_ * 3) + (_HOME_CARD_GAP_ * 2);

  FContent.Position.X := LContentLeft;
  FContent.Width := LAvailableWidth;
  FContent.Height := ClientHeight;

  FCardsLayout.Position.X := 0;
  FCardsLayout.Width := LCardsWidth;
end;

procedure TPageSamplesHome.FormResized(ASender: TObject);
begin
  if Assigned(FCardsLayout) then
    LayoutContent;
end;

end.
