unit Rick.UIBuilder;
(*
  ==============================================================================
  Unit: Rick.UIBuilder
  ==============================================================================

  RESPONSABILIDADE

  Fachada unica do framework Rick.UIBuilder: TRickUIBuilder expoe, por
  um unico ponto de entrada, as tres abordagens de criacao de UI
  discutidas e implementadas nas fases anteriores:

  - Factory (Opcao A)       -> TRickUIBuilder.Factory
  - Builders fluentes (Opcao B) -> TRickUIBuilder.Label_/Button/Badge/Divider
  - Composicao (meio-termo) -> TRickUIBuilder.On(AParent)

  Esta unit NAO implementa nenhuma logica de criacao de controle -
  apenas encaminha para as units especificas de cada abordagem
  (Rick.UIBuilder.Factory, Rick.UIBuilder._Label, Rick.UIBuilder.Button,
  Rick.UIBuilder.Badge, Rick.UIBuilder.Divider, Rick.UIBuilder.Composition),
  escondendo do consumidor de qual unit interna cada abordagem vem.

  Ver docs/usage-guide.md para a tabela de decisao de quando utilizar
  cada uma das tres abordagens.

  ==============================================================================
*)

interface

uses
  FMX.Types,
  Rick.UIBuilder.Interfaces,
  Rick.UIBuilder.Factory,
  Rick.UIBuilder._Label,
  Rick.UIBuilder.Button,
  Rick.UIBuilder.Badge,
  Rick.UIBuilder.Divider,
  Rick.UIBuilder.Composition;

type
  /// <summary>
  ///    Referencia de classe (metaclasse) de TRickUIBuilderFactory,
  ///    utilizada apenas para que TRickUIBuilder.Factory possa expor
  ///    seus metodos estaticos sem exigir uma instancia.
  /// </summary>
  TRickUIBuilderFactoryClass = class of TRickUIBuilderFactory;

  /// <summary>
  ///    Ponto de entrada unico do framework Rick.UIBuilder. Nunca deve
  ///    ser instanciada - todos os seus membros sao estaticos.
  /// </summary>
  TRickUIBuilder = class sealed
  public
    /// <summary>
    ///    Cria uma nova instancia de IRickUIBuilderLabel (builder
    ///    fluente, Opcao B).
    /// </summary>
    /// <returns>
    ///    Uma nova instancia de IRickUIBuilderLabel pronta para
    ///    encadeamento.
    /// </returns>
    /// <remarks>
    ///    O nome deste metodo termina com underscore (Label_) porque
    ///    "Label" e uma palavra reservada do Object Pascal - ver a
    ///    mesma convencao aplicada na unit Rick.UIBuilder._Label.
    /// </remarks>
    class function Label_: IRickUIBuilderLabel; static;

    /// <summary>
    ///    Cria uma nova instancia de IRickUIBuilderButton (builder
    ///    fluente, Opcao B).
    /// </summary>
    /// <returns>
    ///    Uma nova instancia de IRickUIBuilderButton pronta para
    ///    encadeamento.
    /// </returns>
    class function Button: IRickUIBuilderButton; static;

    /// <summary>
    ///    Cria uma nova instancia de IRickUIBuilderBadge (builder
    ///    fluente, Opcao B).
    /// </summary>
    /// <returns>
    ///    Uma nova instancia de IRickUIBuilderBadge pronta para
    ///    encadeamento.
    /// </returns>
    class function Badge: IRickUIBuilderBadge; static;

    /// <summary>
    ///    Cria uma nova instancia de IRickUIBuilderDivider (builder
    ///    fluente, Opcao B).
    /// </summary>
    /// <returns>
    ///    Uma nova instancia de IRickUIBuilderDivider pronta para
    ///    encadeamento.
    /// </returns>
    class function Divider: IRickUIBuilderDivider; static;

    /// <summary>
    ///    Da acesso direto a TRickUIBuilderFactory (criacao direta,
    ///    Opcao A), para os cenarios em que um controle unico com
    ///    poucas variacoes nao justifica um builder fluente.
    /// </summary>
    /// <returns>
    ///    A referencia de classe de TRickUIBuilderFactory, permitindo
    ///    chamar seus metodos estaticos diretamente (ex.:
    ///    TRickUIBuilder.Factory.CreateText(...)) sem exigir uma
    ///    instancia.
    /// </returns>
    class function Factory: TRickUIBuilderFactoryClass; static;

    /// <summary>
    ///    Cria uma nova instancia de IRickUIBuilderComposer (abordagem
    ///    de composicao, meio-termo) associada ao Parent informado.
    /// </summary>
    /// <param name="AParent">
    ///    Controle ou formulario que sera o Parent de todos os
    ///    controles criados pelos metodos Add* do composer retornado.
    /// </param>
    /// <returns>
    ///    Uma nova instancia de IRickUIBuilderComposer pronta para
    ///    encadeamento.
    /// </returns>
    class function On(AParent: TFmxObject): IRickUIBuilderComposer; static;
  end;

implementation

{ TRickUIBuilder }

class function TRickUIBuilder.Label_: IRickUIBuilderLabel;
begin
  Result := TRickUIBuilderLabelBuilder.New;
end;

class function TRickUIBuilder.Button: IRickUIBuilderButton;
begin
  Result := TRickUIBuilderButtonBuilder.New;
end;

class function TRickUIBuilder.Badge: IRickUIBuilderBadge;
begin
  Result := TRickUIBuilderBadgeBuilder.New;
end;

class function TRickUIBuilder.Divider: IRickUIBuilderDivider;
begin
  Result := TRickUIBuilderDividerBuilder.New;
end;

class function TRickUIBuilder.Factory: TRickUIBuilderFactoryClass;
begin
  Result := TRickUIBuilderFactory;
end;

class function TRickUIBuilder.On(
  AParent: TFmxObject): IRickUIBuilderComposer;
begin
  Result := TRickUIBuilderComposer.New(AParent);
end;

end.
