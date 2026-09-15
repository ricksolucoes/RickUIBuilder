unit Rick.UIBuilder.Composition;
(*
  ==============================================================================
  Unit: Rick.UIBuilder.Composition
  ==============================================================================

  RESPONSABILIDADE

  Implementa exclusivamente o composer fluente IRickUIBuilderComposer
  (abordagem de composicao / meio-termo do framework Rick.UIBuilder):
  TRickUIBuilderComposer encadeia a criacao de multiplos controles no
  mesmo Parent, delegando cada criacao para TRickUIBuilderFactory
  (Opcao A) - esta unit NAO reimplementa nenhuma logica de
  instanciacao de controle, apenas oferece uma API fluente para
  compor sequencias curtas e fixas de controles em uma tela.

  Diferente dos builders IRickUIBuilderLabel/IRickUIBuilderButton/
  IRickUIBuilderBadge/IRickUIBuilderDivider, o composer NAO acumula
  estado ate um Build final - cada metodo Add* ja cria o controle
  imediatamente e devolve a propria instancia para encadeamento.

  Ver docs/usage-guide.md (tabela de decisao) para quando utilizar
  esta abordagem em vez da Factory direta ou dos builders fluentes.

  ==============================================================================
*)

interface

uses
  System.Classes,
  System.UITypes,
  FMX.Types,
  FMX.Controls,
  FMX.Objects,
  FMX.StdCtrls,
  Rick.UIBuilder.Types,
  Rick.UIBuilder.Interfaces,
  Rick.UIBuilder.Factory,
  Rick.UIBuilder.Badge.Handle;

type
  /// <summary>
  ///    Implementacao de IRickUIBuilderComposer. Cada metodo Add*
  ///    cria imediatamente o controle correspondente no Parent
  ///    associado a esta instancia, delegando para
  ///    TRickUIBuilderFactory.
  /// </summary>
  TRickUIBuilderComposer = class(TInterfacedObject, IRickUIBuilderComposer)
  strict private
    FParent : TFmxObject;
  protected
    constructor Create(AParent: TFmxObject);

    function AddText(const AText: string;
      const AConfig: TRickUIBuilderTextConfig): IRickUIBuilderComposer;
    function AddDivider(
      const AConfig: TRickUIBuilderDividerConfig): IRickUIBuilderComposer;
    function AddBadge(const AText: string;
      const AConfig: TRickUIBuilderBadgeConfig;
      out AHandle: IRickUIBuilderBadgeHandle): IRickUIBuilderComposer;
    function AddButton(const ACaption: string;
      const AConfig: TRickUIBuilderButtonConfig;
      AOnClick: TNotifyEvent): IRickUIBuilderComposer;
  public
    /// <summary>
    ///    Cria uma nova instancia de IRickUIBuilderComposer associada
    ///    a um Parent especifico. Todos os controles criados por
    ///    metodos Add* subsequentes terao este Parent (e o mesmo
    ///    objeto como Owner).
    /// </summary>
    /// <param name="AParent">
    ///    Controle ou formulario que sera o Parent de todos os
    ///    controles criados por esta instancia.
    /// </param>
    /// <returns>
    ///    Uma nova instancia de IRickUIBuilderComposer pronta para
    ///    encadeamento.
    /// </returns>
    class function New(AParent: TFmxObject): IRickUIBuilderComposer; static;
  end;

implementation

uses
  FMX.Graphics;

{ TRickUIBuilderComposer }

constructor TRickUIBuilderComposer.Create(AParent: TFmxObject);
begin
  inherited Create;
  FParent := AParent;
end;

class function TRickUIBuilderComposer.New(
  AParent: TFmxObject): IRickUIBuilderComposer;
begin
  Result := TRickUIBuilderComposer.Create(AParent);
end;

function TRickUIBuilderComposer.AddText(const AText: string;
  const AConfig: TRickUIBuilderTextConfig): IRickUIBuilderComposer;
begin
  // FParent e utilizado tambem como Owner: TFmxObject herda de
  // TComponent, entao o ciclo de vida do TLabel fica atrelado ao
  // proprio Parent associado a este composer.
  TRickUIBuilderFactory.CreateText(FParent, FParent, AText, AConfig);
  Result := Self;
end;

function TRickUIBuilderComposer.AddDivider(
  const AConfig: TRickUIBuilderDividerConfig): IRickUIBuilderComposer;
begin
  TRickUIBuilderFactory.CreateDivider(FParent, FParent, AConfig);
  Result := Self;
end;

function TRickUIBuilderComposer.AddBadge(const AText: string;
  const AConfig: TRickUIBuilderBadgeConfig;
  out AHandle: IRickUIBuilderBadgeHandle): IRickUIBuilderComposer;
var
  LContainer : TRectangle;
  LTextLabel : TLabel;
begin
  LContainer := TRickUIBuilderFactory.CreateBadge(FParent, FParent, AText,
    AConfig, LTextLabel);

  AHandle := TRickUIBuilderBadgeHandle.New(LContainer, LTextLabel);
  Result  := Self;
end;

function TRickUIBuilderComposer.AddButton(const ACaption: string;
  const AConfig: TRickUIBuilderButtonConfig;
  AOnClick: TNotifyEvent): IRickUIBuilderComposer;
var
  LButton: TRectangle;
begin
  LButton := TRickUIBuilderFactory.CreateButton(FParent, FParent, ACaption,
    AConfig);

  if Assigned(AOnClick) then
    LButton.OnClick := AOnClick;

  Result := Self;
end;

end.
