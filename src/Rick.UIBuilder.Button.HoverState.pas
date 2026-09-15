unit Rick.UIBuilder.Button.HoverState;
(*
  ==============================================================================
  Unit: Rick.UIBuilder.Button.HoverState
  ==============================================================================

  RESPONSABILIDADE

  Implementa exclusivamente TRickUIBuilderButtonHoverState: o estado de
  hover (FillColor/HoverFillColor e os manipuladores informados via
  IRickUIBuilderButton.OnHover) de um botao criado por
  TRickUIBuilderButtonBuilder.Build.

  Esta unit NAO conhece TRickUIBuilderButtonBuilder nem qualquer logica
  de construcao do botao - responde somente por reagir a
  OnMouseEnter/OnMouseLeave, em observancia ao Principio de
  Responsabilidade Unica (SRP): "montar o botao" e "gerenciar o estado
  de hover do botao" sao responsabilidades distintas e vivem em units
  distintas.

  NOTA SOBRE CICLO DE VIDA

  TRickUIBuilderButtonBuilder e um TInterfacedObject: assim que a
  cadeia fluente termina, sua contagem de referencia pode chegar a
  zero e o builder ser destruido. Por isso, os manipuladores de
  OnMouseEnter/OnMouseLeave do botao NAO podem apontar para metodos do
  builder - isso deixaria o botao com um manipulador de evento
  pendurado em um objeto ja destruido.

  TRickUIBuilderButtonHoverState resolve isso sendo um TComponent cujo
  Owner e o mesmo Owner do botao: seu ciclo de vida fica atrelado ao
  formulario/parent, exatamente como qualquer outro controle criado
  pelo framework, sem exigir Free manual do consumidor.

  ==============================================================================
*)

interface

uses
  System.Classes,
  System.UITypes,
  FMX.Objects;

type
  /// <summary>
  ///    Mantem o estado de hover de um botao criado pelo framework
  ///    (FillColor original, HoverFillColor e os manipuladores
  ///    informados pelo consumidor via OnHover) vivo pelo mesmo ciclo
  ///    de vida do botao.
  /// </summary>
  TRickUIBuilderButtonHoverState = class(TComponent)
  strict private
    FButton            : TRectangle;
    FFillColor         : TAlphaColor;
    FHoverFillColor    : TAlphaColor;
    FHasHoverFillColor : Boolean;
    FOnEnter           : TNotifyEvent;
    FOnLeave           : TNotifyEvent;
  protected
    constructor Create(AOwner: TComponent; AButton: TRectangle;
      AFillColor, AHoverFillColor: TAlphaColor; AHasHoverFillColor: Boolean;
      AOnEnter, AOnLeave: TNotifyEvent); reintroduce;
  public
    /// <summary>
    ///    Cria uma nova instancia de TRickUIBuilderButtonHoverState,
    ///    atrelada ao Owner informado.
    /// </summary>
    /// <param name="AOwner">
    ///    Componente responsavel pelo ciclo de vida desta instancia -
    ///    deve ser o mesmo Owner utilizado para criar o botao.
    /// </param>
    /// <param name="AButton">
    ///    Botao cujo Fill.Color sera alternado entre AFillColor e
    ///    AHoverFillColor.
    /// </param>
    /// <param name="AFillColor">
    ///    Cor original do botao, restaurada em HandleMouseLeave.
    /// </param>
    /// <param name="AHoverFillColor">
    ///    Cor aplicada em HandleMouseEnter, quando AHasHoverFillColor
    ///    e True.
    /// </param>
    /// <param name="AHasHoverFillColor">
    ///    Indica se HoverFillColor foi configurado no builder de
    ///    origem. Quando False, a cor do botao nunca e alterada por
    ///    esta instancia.
    /// </param>
    /// <param name="AOnEnter">
    ///    Manipulador adicional informado pelo consumidor via
    ///    IRickUIBuilderButton.OnHover, executado apos a troca de cor.
    /// </param>
    /// <param name="AOnLeave">
    ///    Manipulador adicional informado pelo consumidor via
    ///    IRickUIBuilderButton.OnHover, executado apos a restauracao
    ///    da cor.
    /// </param>
    /// <returns>
    ///    Uma nova instancia de TRickUIBuilderButtonHoverState.
    /// </returns>
    class function New(AOwner: TComponent; AButton: TRectangle;
      AFillColor, AHoverFillColor: TAlphaColor; AHasHoverFillColor: Boolean;
      AOnEnter, AOnLeave: TNotifyEvent): TRickUIBuilderButtonHoverState; static;

    /// <summary>
    ///    Manipulador destinado a OnMouseEnter do botao: aplica
    ///    HoverFillColor (quando configurado) e, em seguida, executa
    ///    o manipulador informado via OnHover.
    /// </summary>
    /// <param name="Sender">
    ///    Objeto que disparou o evento, repassado ao manipulador de
    ///    OnHover sem alteracao.
    /// </param>
    procedure HandleMouseEnter(Sender: TObject);

    /// <summary>
    ///    Manipulador destinado a OnMouseLeave do botao: restaura a
    ///    cor original (quando HoverFillColor foi configurado) e, em
    ///    seguida, executa o manipulador informado via OnHover.
    /// </summary>
    /// <param name="Sender">
    ///    Objeto que disparou o evento, repassado ao manipulador de
    ///    OnHover sem alteracao.
    /// </param>
    procedure HandleMouseLeave(Sender: TObject);
  end;

implementation

{ TRickUIBuilderButtonHoverState }

constructor TRickUIBuilderButtonHoverState.Create(AOwner: TComponent;
  AButton: TRectangle; AFillColor, AHoverFillColor: TAlphaColor;
  AHasHoverFillColor: Boolean; AOnEnter, AOnLeave: TNotifyEvent);
begin
  inherited Create(AOwner);
  FButton            := AButton;
  FFillColor         := AFillColor;
  FHoverFillColor    := AHoverFillColor;
  FHasHoverFillColor := AHasHoverFillColor;
  FOnEnter           := AOnEnter;
  FOnLeave           := AOnLeave;
end;

class function TRickUIBuilderButtonHoverState.New(AOwner: TComponent;
  AButton: TRectangle; AFillColor, AHoverFillColor: TAlphaColor;
  AHasHoverFillColor: Boolean; AOnEnter,
  AOnLeave: TNotifyEvent): TRickUIBuilderButtonHoverState;
begin
  Result := TRickUIBuilderButtonHoverState.Create(AOwner, AButton, AFillColor,
    AHoverFillColor, AHasHoverFillColor, AOnEnter, AOnLeave);
end;

procedure TRickUIBuilderButtonHoverState.HandleMouseEnter(Sender: TObject);
begin
  if FHasHoverFillColor then
    FButton.Fill.Color := FHoverFillColor;

  // HoverFillColor e OnHover coexistem: a cor muda automaticamente e,
  // em seguida, o manipulador informado pelo consumidor tambem e
  // executado - ver <remarks> de IRickUIBuilderButton.OnHover.
  if Assigned(FOnEnter) then
    FOnEnter(Sender);
end;

procedure TRickUIBuilderButtonHoverState.HandleMouseLeave(Sender: TObject);
begin
  if FHasHoverFillColor then
    FButton.Fill.Color := FFillColor;

  if Assigned(FOnLeave) then
    FOnLeave(Sender);
end;

end.
