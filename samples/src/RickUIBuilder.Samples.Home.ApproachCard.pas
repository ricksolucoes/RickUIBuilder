unit RickUIBuilder.Samples.Home.ApproachCard;

{
  ============================================================================
  Unit: RickUIBuilder.Samples.Home.ApproachCard
  ============================================================================

  OBJETIVO

  Construir a representacao visual comum de uma abordagem apresentada na Home
  por meio de um contrato fluent especifico desta feature.

  RESPONSABILIDADE

  - receber da Home os dados necessarios para representar uma abordagem;
  - manter o estado temporario da configuracao fluent;
  - materializar a superficie e o conteudo visual do card no Build;
  - manter os detalhes de composicao visual fora da unit orquestradora.

  LIMITES

  - nao conhece Factory, Fluent Builder ou Composition;
  - nao decide quais abordagens existem;
  - nao implementa navegacao;
  - nao conhece telas ou cenarios de componentes;
  - nao define conteudo de negocio da Home;
  - nao herda de controles FMX.

  LIFETIME E OWNERSHIP

  TApproachCard utiliza reference counting por meio de TInterfacedObject e
  existe somente durante a configuracao/construcao fluent. O TRectangle criado
  por Build utiliza FParent como Owner e Parent, ficando sob o ownership FMX.

  CONVENCAO DE INTERFACE

  Os metodos que implementam IApproachCard e o constructor Create permanecem
  em protected. A secao public da classe concreta expoe somente Destroy e New.
  A documentacao do contrato fica em IApproachCard e nao e duplicada nos
  metodos correspondentes de TApproachCard.

  ============================================================================
}

interface

uses
  FMX.Types,
  FMX.Objects;

type
  /// <summary>
  ///   Define o contrato fluent para configurar e construir um card de
  ///   abordagem da Home.
  /// </summary>
  /// <remarks>
  ///   O contrato recebe apenas dados de representacao. A identidade da
  ///   abordagem e seu posicionamento continuam sob responsabilidade da Home.
  /// </remarks>
  IApproachCard = interface
    ['{2705B0AE-BD73-4FDD-B46A-E6E9FA26CE5C}']
    /// <summary>
    ///   Define o objeto FMX que sera utilizado como Parent e Owner do card.
    /// </summary>
    function Parent(const AParent: TFmxObject): IApproachCard;

    /// <summary>
    ///   Define o texto curto apresentado no badge superior do card.
    /// </summary>
    function Tag(const ATagText: string): IApproachCard;

    /// <summary>
    ///   Define o titulo principal apresentado no card.
    /// </summary>
    function Title(const ATitle: string): IApproachCard;

    /// <summary>
    ///   Define a descricao resumida da abordagem representada.
    /// </summary>
    function Description(const ADescription: string): IApproachCard;

    /// <summary>
    ///   Define o texto que descreve os recursos atualmente disponiveis.
    /// </summary>
    function Availability(const AAvailability: string): IApproachCard;

    /// <summary>
    ///   Materializa o card configurado e devolve sua superficie para que a
    ///   Home possa posiciona-la no layout.
    /// </summary>
    function Build: TRectangle;
  end;

  /// <summary>
  ///   Mantem a configuracao temporaria de IApproachCard e materializa sua
  ///   composicao visual sem conhecer a identidade da abordagem representada.
  /// </summary>
  TApproachCard = class(TInterfacedObject, IApproachCard)
  private
    FParent: TFmxObject;
    FTagText: string;
    FTitle: string;
    FDescription: string;
    FAvailability: string;

    /// <summary>
    ///   Configura dimensoes, preenchimento, borda e raio da superficie do
    ///   card antes da inclusao de seu conteudo.
    /// </summary>
    procedure ConfigureSurface(const ACard: TRectangle);

    /// <summary>
    ///   Adiciona a identificacao curta configurada para o card.
    /// </summary>
    procedure AddTag(const ACard: TRectangle);

    /// <summary>
    ///   Adiciona o titulo configurado para o card.
    /// </summary>
    procedure AddTitle(const ACard: TRectangle);

    /// <summary>
    ///   Adiciona a descricao configurada para o card.
    /// </summary>
    procedure AddDescription(const ACard: TRectangle);

    /// <summary>
    ///   Adiciona a divisao visual e os recursos disponiveis configurados para
    ///   o card.
    /// </summary>
    procedure AddAvailability(const ACard: TRectangle);

    /// <summary>
    ///   Adiciona o divisor que separa a descricao da disponibilidade.
    /// </summary>
    procedure AddAvailabilityDivider(const ACard: TRectangle);

    /// <summary>
    ///   Adiciona o rotulo fixo que identifica a secao de disponibilidade.
    /// </summary>
    procedure AddAvailabilityLabel(const ACard: TRectangle);

    /// <summary>
    ///   Adiciona o texto configurado com os recursos atualmente disponiveis.
    /// </summary>
    procedure AddAvailabilityText(const ACard: TRectangle);
  protected
    function Parent(const AParent: TFmxObject): IApproachCard;
    function Tag(const ATagText: string): IApproachCard;
    function Title(const ATitle: string): IApproachCard;
    function Description(const ADescription: string): IApproachCard;
    function Availability(const AAvailability: string): IApproachCard;
    function Build: TRectangle;

    /// <summary>
    ///   Cria a instancia concreta utilizada pelo contrato fluent.
    /// </summary>
    constructor Create;
  public
    /// <summary>
    ///   Finaliza a instancia controlada por reference counting.
    /// </summary>
    destructor Destroy; override;

    /// <summary>
    ///   Inicia uma nova configuracao fluent de IApproachCard.
    /// </summary>
    class function New: IApproachCard;
  end;

implementation

uses
  FMX.Graphics,

  Rick.UIBuilder,
  RickUIBuilder.Samples.Home.Style;

{ TApproachCard }

procedure TApproachCard.ConfigureSurface(const ACard: TRectangle);
begin
  ACard.SetBounds(0, 0, _HOME_CARD_WIDTH_, _HOME_CARD_HEIGHT_);
  ACard.Fill.Kind := TBrushKind.Solid;
  ACard.Fill.Color := _HOME_CARD_BACKGROUND_;
  ACard.Stroke.Kind := TBrushKind.Solid;
  ACard.Stroke.Color := _HOME_BORDER_;
  ACard.Stroke.Thickness := 1;
  ACard.XRadius := _HOME_CARD_RADIUS_;
  ACard.YRadius := _HOME_CARD_RADIUS_;
end;

procedure TApproachCard.AddTag(const ACard: TRectangle);
begin
  TRickUIBuilder.Badge
    .Text(FTagText)
    .Position(22, 22)
    .Size(96, 26)
    .Pill(True)
    .BackgroundColor(_HOME_PRIMARY_SOFT_)
    .TextColor(_HOME_PRIMARY_)
    .FontSize(10)
    .Bold(True)
    .Build(ACard);
end;

procedure TApproachCard.AddTitle(const ACard: TRectangle);
begin
  TRickUIBuilder.Label_
    .Text(FTitle)
    .Position(22, 68)
    .Size(_HOME_CARD_WIDTH_ - 44, 32)
    .FontSize(20)
    .FontColor(_HOME_TEXT_PRIMARY_)
    .Bold(True)
    .Build(ACard);
end;

procedure TApproachCard.AddDescription(const ACard: TRectangle);
begin
  TRickUIBuilder.Label_
    .Text(FDescription)
    .Position(22, 112)
    .Size(_HOME_CARD_WIDTH_ - 44, 82)
    .FontSize(13)
    .FontColor(_HOME_TEXT_SECONDARY_)
    .WordWrap(True)
    .Build(ACard);
end;

procedure TApproachCard.AddAvailability(const ACard: TRectangle);
begin
  AddAvailabilityDivider(ACard);
  AddAvailabilityLabel(ACard);
  AddAvailabilityText(ACard);
end;

procedure TApproachCard.AddAvailabilityDivider(const ACard: TRectangle);
begin
  TRickUIBuilder.Divider
    .Position(22, 214)
    .Width(_HOME_CARD_WIDTH_ - 44)
    .Thickness(1)
    .Color(_HOME_BORDER_)
    .Build(ACard);
end;

procedure TApproachCard.AddAvailabilityLabel(const ACard: TRectangle);
begin
  TRickUIBuilder.Label_
    .Text('Disponivel hoje')
    .Position(22, 232)
    .Size(_HOME_CARD_WIDTH_ - 44, 18)
    .FontSize(11)
    .FontColor(_HOME_SUCCESS_TEXT_)
    .Bold(True)
    .Build(ACard);
end;

procedure TApproachCard.AddAvailabilityText(const ACard: TRectangle);
begin
  TRickUIBuilder.Label_
    .Text(FAvailability)
    .Position(22, 258)
    .Size(_HOME_CARD_WIDTH_ - 44, 48)
    .FontSize(12)
    .FontColor(_HOME_TEXT_PRIMARY_)
    .WordWrap(True)
    .Build(ACard);
end;

function TApproachCard.Parent(const AParent: TFmxObject): IApproachCard;
begin
  FParent := AParent;
  Result := Self;
end;

function TApproachCard.Tag(const ATagText: string): IApproachCard;
begin
  FTagText := ATagText;
  Result := Self;
end;

function TApproachCard.Title(const ATitle: string): IApproachCard;
begin
  FTitle := ATitle;
  Result := Self;
end;

function TApproachCard.Description(const ADescription: string): IApproachCard;
begin
  FDescription := ADescription;
  Result := Self;
end;

function TApproachCard.Availability(
  const AAvailability: string): IApproachCard;
begin
  FAvailability := AAvailability;
  Result := Self;
end;

function TApproachCard.Build: TRectangle;
begin
  Result := TRectangle.Create(FParent);
  Result.Parent := FParent;

  ConfigureSurface(Result);
  AddTag(Result);
  AddTitle(Result);
  AddDescription(Result);
  AddAvailability(Result);
end;

constructor TApproachCard.Create;
begin
  inherited Create;
end;

destructor TApproachCard.Destroy;
begin
  inherited;
end;

class function TApproachCard.New: IApproachCard;
begin
  Result := Self.Create;
end;

end.
