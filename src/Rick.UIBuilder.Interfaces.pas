unit Rick.UIBuilder.Interfaces;
(*
  ==============================================================================
  Unit: Rick.UIBuilder.Interfaces
  ==============================================================================

  RESPONSABILIDADE

  Define os contratos (interfaces) dos builders fluentes do framework
  Rick.UIBuilder (Opcao B): IRickUIBuilderLabel, IRickUIBuilderButton
  (com seu IRickUIBuilderButtonHandle), IRickUIBuilderButtonHoverState,
  IRickUIBuilderBadge (com seu IRickUIBuilderBadgeHandle) e
  IRickUIBuilderDivider.

  Cada interface e autocontida (sem heranca entre interfaces): em Object
  Pascal, encadeamento fluente com heranca de interface obrigaria a
  repetir os metodos na interface filha mesmo assim, entao a heranca nao
  economiza nada aqui - so adicionaria complexidade.

  Esta unit NAO contem implementacao. As implementacoes concretas vivem
  em Rick.UIBuilder.Label, Rick.UIBuilder.Button, Rick.UIBuilder.Badge e
  Rick.UIBuilder.Divider, e delegam a criacao real dos controles para
  Rick.UIBuilder.Factory (evita duplicar a logica de criacao).

  ==============================================================================
*)

interface

uses
  System.UITypes,
  System.Classes,
  FMX.Types,
  FMX.Controls,
  FMX.Objects,
  FMX.StdCtrls,
  Rick.UIBuilder.Types;

type
  /// <summary>
  ///    Builder fluente para criacao de um TLabel. Cada metodo retorna
  ///    a propria instancia, permitindo encadeamento. A criacao real do
  ///    controle so ocorre ao chamar Build.
  /// </summary>
  IRickUIBuilderLabel = interface
    ['{7A1E4C2B-9F3D-4A6E-8B1C-2D3E4F5A6B7C}']

    /// <summary>
    ///    Define o texto exibido pelo label.
    /// </summary>
    /// <param name="AValue">
    ///    Texto a ser exibido no controle.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    function Text(const AValue: string): IRickUIBuilderLabel;

    /// <summary>
    ///    Define a posicao (Left, Top) do label dentro do seu Parent.
    /// </summary>
    /// <param name="ALeft">
    ///    Distancia a partir da borda esquerda do Parent.
    /// </param>
    /// <param name="ATop">
    ///    Distancia a partir da borda superior do Parent.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    function Position(ALeft, ATop: Single): IRickUIBuilderLabel;

    /// <summary>
    ///    Define a largura e altura do label.
    /// </summary>
    /// <param name="AWidth">
    ///    Largura do controle.
    /// </param>
    /// <param name="AHeight">
    ///    Altura do controle.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    function Size(AWidth, AHeight: Single): IRickUIBuilderLabel;

    /// <summary>
    ///    Define as ancoras do label em relacao ao seu Parent.
    /// </summary>
    /// <param name="AValue">
    ///    Conjunto de ancoras (TAnchors) a ser aplicado.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    function Anchors(AValue: TAnchors): IRickUIBuilderLabel;

    /// <summary>
    ///    Define o espacamento externo aplicado ao label apos sua criacao.
    /// </summary>
    /// <param name="AValue">
    ///    Espacamento a ser somado a posicao definida em Position.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    /// <remarks>
    ///    O Margin e somado, nao substitui, os valores de Left/Top
    ///    definidos via Position. Se Position nao for chamado, a soma
    ///    parte de (0,0).
    /// </remarks>
    function Margin(const AValue: TRickUIBuilderSpacing): IRickUIBuilderLabel;

    /// <summary>
    ///    Define o espacamento interno entre a area do controle e o
    ///    texto renderizado.
    /// </summary>
    /// <param name="AValue">
    ///    Espacamento a ser aplicado como inset do texto dentro de
    ///    Width/Height.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    /// <remarks>
    ///    Padding reduz a area efetiva de renderizacao do texto; nao
    ///    altera Width/Height do controle criado.
    /// </remarks>
    function Padding(const AValue: TRickUIBuilderSpacing): IRickUIBuilderLabel;

    /// <summary>
    ///    Define a familia de fonte utilizada pelo texto.
    /// </summary>
    /// <param name="AValue">
    ///    Nome da familia de fonte.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    function FontFamily(const AValue: string): IRickUIBuilderLabel;

    /// <summary>
    ///    Define o tamanho da fonte do texto.
    /// </summary>
    /// <param name="AValue">
    ///    Tamanho da fonte, em pontos.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    function FontSize(AValue: Single): IRickUIBuilderLabel;

    /// <summary>
    ///    Define a cor da fonte do texto.
    /// </summary>
    /// <param name="AValue">
    ///    Cor a ser aplicada ao texto.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    function FontColor(AValue: TAlphaColor): IRickUIBuilderLabel;

    /// <summary>
    ///    Define se o texto e exibido em negrito.
    /// </summary>
    /// <param name="AValue">
    ///    True para negrito. O padrao, quando o metodo nao e chamado,
    ///    e False.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    function Bold(AValue: Boolean = True): IRickUIBuilderLabel;

    /// <summary>
    ///    Define se o texto e exibido em italico.
    /// </summary>
    /// <param name="AValue">
    ///    True para italico. O padrao, quando o metodo nao e chamado,
    ///    e False.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    function Italic(AValue: Boolean = True): IRickUIBuilderLabel;

    /// <summary>
    ///    Define o alinhamento horizontal do texto.
    /// </summary>
    /// <param name="AValue">
    ///    Alinhamento horizontal a ser aplicado.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    function Align(AValue: TTextAlign): IRickUIBuilderLabel;

    /// <summary>
    ///    Define o alinhamento vertical do texto.
    /// </summary>
    /// <param name="AValue">
    ///    Alinhamento vertical a ser aplicado.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    function VerticalAlign(AValue: TTextAlign): IRickUIBuilderLabel;

    /// <summary>
    ///    Define se o texto deve quebrar linha automaticamente quando
    ///    excede a largura do controle.
    /// </summary>
    /// <param name="AValue">
    ///    True para permitir quebra de linha. O padrao, quando o metodo
    ///    nao e chamado, e False.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    function WordWrap(AValue: Boolean = True): IRickUIBuilderLabel;

    /// <summary>
    ///    Define o comportamento de corte de texto quando o conteudo
    ///    excede a area disponivel.
    /// </summary>
    /// <param name="AValue">
    ///    Estrategia de corte (TTextTrimming) a ser aplicada.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    function Trimming(AValue: TTextTrimming): IRickUIBuilderLabel;

    /// <summary>
    ///    Define a opacidade do controle.
    /// </summary>
    /// <param name="AValue">
    ///    Valor entre 0 (totalmente transparente) e 1 (totalmente opaco).
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    function Opacity(AValue: Single): IRickUIBuilderLabel;

    /// <summary>
    ///    Define a visibilidade inicial do controle.
    /// </summary>
    /// <param name="AValue">
    ///    True para visivel. O padrao, quando o metodo nao e chamado,
    ///    e True.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    function Visible(AValue: Boolean = True): IRickUIBuilderLabel;

    /// <summary>
    ///    Define se o controle responde a eventos de mouse/toque.
    /// </summary>
    /// <param name="AValue">
    ///    True para habilitar HitTest. O padrao, quando o metodo nao e
    ///    chamado, e False, ja que labels geralmente sao apenas
    ///    exibicao.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    function HitTest(AValue: Boolean = False): IRickUIBuilderLabel;

    /// <summary>
    ///    Define o valor de Tag do controle, util para identificacao
    ///    em manipuladores de evento compartilhados.
    /// </summary>
    /// <param name="AValue">
    ///    Valor numerico a ser atribuido a Tag.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    function Tag(AValue: NativeInt): IRickUIBuilderLabel;

    /// <summary>
    ///    Cria efetivamente o TLabel com todas as configuracoes
    ///    acumuladas ate este ponto.
    /// </summary>
    /// <param name="AParent">
    ///    Controle ou formulario que sera o Parent do TLabel criado.
    /// </param>
    /// <returns>
    ///    A instancia de TLabel criada e ja anexada a AParent.
    /// </returns>
    function Build(AParent: TFmxObject): TLabel;
  end;

  /// <summary>
  ///    Configura fluentemente o estado de hover de um Button. O objeto
  ///    de configuracao e reference-counted; Build materializa o
  ///    comportamento persistente com lifetime controlado por AOwner.
  /// </summary>
  /// <remarks>
  ///    Depois de Build, FillColor, HoverFillColor, OnEnter e OnLeave
  ///    permanecem mutaveis. O behavior materializado consulta os valores
  ///    atuais quando os eventos de mouse sao disparados.
  /// </remarks>
  IRickUIBuilderButtonHoverState = interface
    ['{1DDCEF34-0EBE-4734-98C5-F9DF13CAE728}']

    /// <summary>
    ///    Define o TRectangle usado em uma futura materializacao do hover.
    /// </summary>
    /// <param name="AValue">Button usado por um proximo Build.</param>
    /// <returns>A propria interface para encadeamento fluente.</returns>
    /// <remarks>
    ///    Alterar Button depois de Build nao retargeta behaviors ja
    ///    materializados; cada behavior permanece ligado ao Button usado
    ///    no respectivo Build.
    /// </remarks>
    function Button(AValue: TRectangle): IRickUIBuilderButtonHoverState; overload;

    /// <summary>
    ///    Retorna o TRectangle atualmente configurado.
    /// </summary>
    /// <returns>O Button configurado ou nil quando ainda nao definido.</returns>
    function Button: TRectangle; overload;

    /// <summary>
    ///    Define a cor normal restaurada ao sair do hover.
    /// </summary>
    /// <param name="AValue">Cor normal do Button.</param>
    /// <returns>A propria interface para encadeamento fluente.</returns>
    /// <remarks>
    ///    Depois de Build, o novo valor e usado no proximo MouseLeave.
    /// </remarks>
    function FillColor(AValue: TAlphaColor): IRickUIBuilderButtonHoverState; overload;

    /// <summary>
    ///    Retorna a cor normal atualmente configurada.
    /// </summary>
    /// <returns>A cor normal configurada.</returns>
    function FillColor: TAlphaColor; overload;

    /// <summary>
    ///    Define a cor aplicada durante o hover e marca essa configuracao
    ///    como explicitamente informada.
    /// </summary>
    /// <param name="AValue">Cor aplicada durante o hover.</param>
    /// <returns>A propria interface para encadeamento fluente.</returns>
    /// <remarks>
    ///    Depois de Build, o novo valor e usado no proximo MouseEnter.
    /// </remarks>
    function HoverFillColor(AValue: TAlphaColor):
      IRickUIBuilderButtonHoverState; overload;

    /// <summary>
    ///    Retorna a cor de hover atualmente configurada.
    /// </summary>
    /// <returns>A cor de hover configurada.</returns>
    function HoverFillColor: TAlphaColor; overload;

    /// <summary>
    ///    Define o manipulador adicional executado apos a entrada no hover.
    /// </summary>
    /// <param name="AValue">Manipulador executado no MouseEnter.</param>
    /// <returns>A propria interface para encadeamento fluente.</returns>
    /// <remarks>
    ///    Depois de Build, o novo handler e usado no proximo MouseEnter.
    /// </remarks>
    function OnEnter(AValue: TNotifyEvent): IRickUIBuilderButtonHoverState; overload;

    /// <summary>
    ///    Retorna o manipulador de entrada atualmente configurado.
    /// </summary>
    /// <returns>O manipulador de entrada configurado.</returns>
    function OnEnter: TNotifyEvent; overload;

    /// <summary>
    ///    Define o manipulador adicional executado apos a saida do hover.
    /// </summary>
    /// <param name="AValue">Manipulador executado no MouseLeave.</param>
    /// <returns>A propria interface para encadeamento fluente.</returns>
    /// <remarks>
    ///    Depois de Build, o novo handler e usado no proximo MouseLeave.
    /// </remarks>
    function OnLeave(AValue: TNotifyEvent): IRickUIBuilderButtonHoverState; overload;

    /// <summary>
    ///    Retorna o manipulador de saida atualmente configurado.
    /// </summary>
    /// <returns>O manipulador de saida configurado.</returns>
    function OnLeave: TNotifyEvent; overload;

    /// <summary>
    ///    Materializa o comportamento de hover e o atrela ao lifetime
    ///    do componente informado como Owner.
    /// </summary>
    /// <param name="AOwner">Owner do comportamento materializado.</param>
    /// <returns>A propria interface para encadeamento fluente.</returns>
    /// <remarks>
    ///    O behavior mantem o estado vivo enquanto AOwner permanecer vivo
    ///    e consulta os valores atuais de cor e handlers a cada evento.
    ///    A interface do chamador pode ser liberada apos Build. AOwner deve
    ///    permanecer vivo enquanto Button puder disparar os eventos;
    ///    Build nao altera o ownership do Button.
    /// </remarks>
    function Build(AOwner: TComponent): IRickUIBuilderButtonHoverState;
  end;

  /// <summary>
  ///    Representa o acesso pos-Build a um Button: o retangulo container,
  ///    o label de Caption interno e o estado de hover associado.
  /// </summary>
  /// <remarks>
  ///    O handle nao e proprietario dos controles e nao altera o
  ///    modelo de ownership utilizado na criacao. Container e TextLabel
  ///    permanecem validos somente enquanto seus Owners mantiverem os
  ///    controles vivos. HoverState mantem apenas o estado logico vivo;
  ///    ele nao assume ownership do Button.
  /// </remarks>
  IRickUIBuilderButtonHandle = interface
    ['{8B51C5CF-2849-41FC-8765-242C5169FEA6}']

    /// <summary>
    ///    Retorna o retangulo que forma o Button.
    /// </summary>
    /// <returns>
    ///    O TRectangle criado como container do Button.
    /// </returns>
    function Container: TRectangle;

    /// <summary>
    ///    Retorna o label de Caption interno do Button.
    /// </summary>
    /// <returns>
    ///    O TLabel criado como filho do Container.
    /// </returns>
    function TextLabel: TLabel;

    /// <summary>
    ///    Retorna o estado de hover associado ao Button.
    /// </summary>
    /// <returns>
    ///    O IRickUIBuilderButtonHoverState utilizado pelo behavior do Button.
    ///    Pode ser nil em handles criados diretamente pela sobrecarga de
    ///    compatibilidade de TRickUIBuilderButtonHandle.New sem HoverState.
    /// </returns>
    function HoverState: IRickUIBuilderButtonHoverState;
  end;

  /// <summary>
  ///    Builder fluente para criacao de um botao customizado
  ///    (TRectangle com TLabel interno). Cada metodo retorna a propria
  ///    instancia, permitindo encadeamento. A criacao real do controle
  ///    so ocorre ao chamar Build ou BuildHandle.
  /// </summary>
  IRickUIBuilderButton = interface
    ['{3F8B2A1D-6C4E-4D9F-A2B3-5C6D7E8F9A0B}']

    /// <summary>
    ///    Define o texto exibido no botao.
    /// </summary>
    /// <param name="AValue">
    ///    Texto a ser exibido no controle.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    function Caption(const AValue: string): IRickUIBuilderButton;

    /// <summary>
    ///    Define a posicao (Left, Top) do botao dentro do seu Parent.
    /// </summary>
    /// <param name="ALeft">
    ///    Distancia a partir da borda esquerda do Parent.
    /// </param>
    /// <param name="ATop">
    ///    Distancia a partir da borda superior do Parent.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    function Position(ALeft, ATop: Single): IRickUIBuilderButton;

    /// <summary>
    ///    Define a largura e altura do botao.
    /// </summary>
    /// <param name="AWidth">
    ///    Largura do controle.
    /// </param>
    /// <param name="AHeight">
    ///    Altura do controle.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    function Size(AWidth, AHeight: Single): IRickUIBuilderButton;

    /// <summary>
    ///    Define as ancoras do botao em relacao ao seu Parent.
    /// </summary>
    /// <param name="AValue">
    ///    Conjunto de ancoras (TAnchors) a ser aplicado.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    function Anchors(AValue: TAnchors): IRickUIBuilderButton;

    /// <summary>
    ///    Define o raio dos cantos do botao.
    /// </summary>
    /// <param name="AValue">
    ///    Raio, em pixels, aplicado a XRadius e YRadius do retangulo.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    function CornerRadius(AValue: Single): IRickUIBuilderButton;

    /// <summary>
    ///    Define o espacamento externo aplicado ao botao apos sua
    ///    criacao.
    /// </summary>
    /// <param name="AValue">
    ///    Espacamento a ser somado a posicao definida em Position.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    /// <remarks>
    ///    O Margin e somado, nao substitui, os valores de Left/Top
    ///    definidos via Position. Se Position nao for chamado, a soma
    ///    parte de (0,0).
    /// </remarks>
    function Margin(const AValue: TRickUIBuilderSpacing): IRickUIBuilderButton;

    /// <summary>
    ///    Define o espacamento interno entre a borda do botao e o
    ///    label de Caption.
    /// </summary>
    /// <param name="AValue">
    ///    Espacamento a ser aplicado entre a borda do retangulo e o
    ///    label interno.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    function Padding(const AValue: TRickUIBuilderSpacing): IRickUIBuilderButton;

    /// <summary>
    ///    Define a cor de preenchimento do botao em estado normal
    ///    (fora de hover).
    /// </summary>
    /// <param name="AValue">
    ///    Cor de preenchimento.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    function FillColor(AValue: TAlphaColor): IRickUIBuilderButton;

    /// <summary>
    ///    Define a cor da borda do botao.
    /// </summary>
    /// <param name="AValue">
    ///    Cor da borda. Utilize TAlphaColors.Null para nenhuma borda.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    function BorderColor(AValue: TAlphaColor): IRickUIBuilderButton;

    /// <summary>
    ///    Define a espessura da borda do botao.
    /// </summary>
    /// <param name="AValue">
    ///    Espessura, em pixels. O padrao, quando o metodo nao e
    ///    chamado, e 0 (sem borda).
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    function BorderThickness(AValue: Single): IRickUIBuilderButton;

    /// <summary>
    ///    Define a cor do texto exibido no botao.
    /// </summary>
    /// <param name="AValue">
    ///    Cor a ser aplicada ao Caption.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    function TextColor(AValue: TAlphaColor): IRickUIBuilderButton;

    /// <summary>
    ///    Define a familia de fonte utilizada pelo Caption.
    /// </summary>
    /// <param name="AValue">
    ///    Nome da familia de fonte.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    function FontFamily(const AValue: string): IRickUIBuilderButton;

    /// <summary>
    ///    Define o tamanho da fonte do Caption.
    /// </summary>
    /// <param name="AValue">
    ///    Tamanho da fonte, em pontos.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    function FontSize(AValue: Single): IRickUIBuilderButton;

    /// <summary>
    ///    Define se o Caption e exibido em negrito.
    /// </summary>
    /// <param name="AValue">
    ///    True para negrito. O padrao, quando o metodo nao e chamado,
    ///    e False.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    function Bold(AValue: Boolean = True): IRickUIBuilderButton;

    /// <summary>
    ///    Define a cor de preenchimento aplicada quando o mouse esta
    ///    sobre o botao.
    /// </summary>
    /// <param name="AValue">
    ///    Cor de preenchimento em estado de hover.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    /// <remarks>
    ///    Quando definida, o builder anexa automaticamente os
    ///    manipuladores OnMouseEnter/OnMouseLeave do controle criado
    ///    para alternar entre FillColor e HoverFillColor. Se OnHover
    ///    tambem for definido, ambos os comportamentos sao executados.
    /// </remarks>
    function HoverFillColor(AValue: TAlphaColor): IRickUIBuilderButton;

    /// <summary>
    ///    Define a opacidade aplicada ao botao quando Enabled for False.
    /// </summary>
    /// <param name="AValue">
    ///    Valor entre 0 e 1 aplicado como Opacity quando o botao
    ///    estiver desabilitado.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    function DisabledOpacity(AValue: Single): IRickUIBuilderButton;

    /// <summary>
    ///    Define se o botao inicia habilitado para interacao.
    /// </summary>
    /// <param name="AValue">
    ///    True para habilitado. O padrao, quando o metodo nao e
    ///    chamado, e True.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    function Enabled(AValue: Boolean = True): IRickUIBuilderButton;

    /// <summary>
    ///    Define o cursor do mouse exibido sobre o botao.
    /// </summary>
    /// <param name="AValue">
    ///    Cursor a ser aplicado.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    function Cursor(AValue: TCursor): IRickUIBuilderButton;

    /// <summary>
    ///    Define a opacidade geral do controle.
    /// </summary>
    /// <param name="AValue">
    ///    Valor entre 0 (totalmente transparente) e 1 (totalmente
    ///    opaco).
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    function Opacity(AValue: Single): IRickUIBuilderButton;

    /// <summary>
    ///    Define a visibilidade inicial do controle.
    /// </summary>
    /// <param name="AValue">
    ///    True para visivel. O padrao, quando o metodo nao e chamado,
    ///    e True.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    function Visible(AValue: Boolean = True): IRickUIBuilderButton;

    /// <summary>
    ///    Define o valor de Tag do controle, util para identificacao
    ///    em manipuladores de evento compartilhados.
    /// </summary>
    /// <param name="AValue">
    ///    Valor numerico a ser atribuido a Tag.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    function Tag(AValue: NativeInt): IRickUIBuilderButton;

    /// <summary>
    ///    Define o manipulador de evento disparado ao clicar no botao.
    /// </summary>
    /// <param name="AHandler">
    ///    Metodo a ser atribuido a OnClick do controle criado.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    function OnClick(AHandler: TNotifyEvent): IRickUIBuilderButton;

    /// <summary>
    ///    Define manipuladores de evento adicionais para entrada e
    ///    saida do mouse sobre o botao.
    /// </summary>
    /// <param name="AEnter">
    ///    Metodo a ser atribuido a OnMouseEnter do controle criado.
    /// </param>
    /// <param name="ALeave">
    ///    Metodo a ser atribuido a OnMouseLeave do controle criado.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    /// <remarks>
    ///    Estes manipuladores sao adicionais aos aplicados
    ///    automaticamente por HoverFillColor, quando ambos forem
    ///    utilizados: primeiro o builder alterna a cor, em seguida
    ///    invoca o manipulador informado aqui.
    /// </remarks>
    function OnHover(AEnter, ALeave: TNotifyEvent): IRickUIBuilderButton;

    /// <summary>
    ///    Cria efetivamente o botao (TRectangle com TLabel interno)
    ///    com todas as configuracoes acumuladas ate este ponto.
    /// </summary>
    /// <param name="AParent">
    ///    Controle ou formulario que sera o Parent do botao criado.
    /// </param>
    /// <returns>
    ///    O TRectangle criado, ja anexado a AParent, com o TLabel de
    ///    Caption criado como seu filho.
    /// </returns>
    function Build(AParent: TFmxObject): TRectangle;

    /// <summary>
    ///    Cria o mesmo Button de Build e devolve acesso explicito ao
    ///    Container e ao TextLabel criados.
    /// </summary>
    /// <param name="AParent">
    ///    Controle ou formulario que sera o Parent do Button criado.
    /// </param>
    /// <returns>
    ///    Um IRickUIBuilderButtonHandle com as referencias exatas ao
    ///    TRectangle e ao TLabel criados para este Button.
    /// </returns>
    /// <remarks>
    ///    O handle nao assume ownership dos controles. A destruicao do
    ///    handle nao libera Container nem TextLabel, e o handle nao deve
    ///    ser usado depois que os Owners desses controles forem destruidos.
    ///    Use Build quando somente o TRectangle for necessario.
    /// </remarks>
    function BuildHandle(AParent: TFmxObject): IRickUIBuilderButtonHandle;
  end;

  /// <summary>
  ///    Representa os dois controles resultantes da criacao de um
  ///    Badge: o retangulo container e o label de texto interno.
  ///    Necessario porque Build de um Badge nao pode devolver um unico
  ///    TControl.
  /// </summary>
  IRickUIBuilderBadgeHandle = interface
    ['{9D2C4E6A-1B3F-4A5C-9D7E-8F0A1B2C3D4E}']

    /// <summary>
    ///    Retorna o retangulo que forma o fundo do Badge.
    /// </summary>
    /// <returns>
    ///    O TRectangle criado como container do Badge.
    /// </returns>
    function Container: TRectangle;

    /// <summary>
    ///    Retorna o label de texto interno do Badge.
    /// </summary>
    /// <returns>
    ///    O TLabel criado como filho do Container, contendo o texto
    ///    do Badge.
    /// </returns>
    function TextLabel: TLabel;
  end;

  /// <summary>
  ///    Builder fluente para criacao de um Badge (retangulo com texto
  ///    interno). Cada metodo retorna a propria instancia, permitindo
  ///    encadeamento. A criacao real dos controles so ocorre ao chamar
  ///    Build.
  /// </summary>
  IRickUIBuilderBadge = interface
    ['{5E8A1C3D-7B9F-4E2A-8C4D-6E7F8A9B0C1D}']

    /// <summary>
    ///    Define o texto exibido pelo Badge.
    /// </summary>
    /// <param name="AValue">
    ///    Texto a ser exibido no controle.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    function Text(const AValue: string): IRickUIBuilderBadge;

    /// <summary>
    ///    Define a posicao (Left, Top) do Badge dentro do seu Parent.
    /// </summary>
    /// <param name="ALeft">
    ///    Distancia a partir da borda esquerda do Parent.
    /// </param>
    /// <param name="ATop">
    ///    Distancia a partir da borda superior do Parent.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    function Position(ALeft, ATop: Single): IRickUIBuilderBadge;

    /// <summary>
    ///    Define a largura e altura do Badge.
    /// </summary>
    /// <param name="AWidth">
    ///    Largura do controle.
    /// </param>
    /// <param name="AHeight">
    ///    Altura do controle.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    function Size(AWidth, AHeight: Single): IRickUIBuilderBadge;

    /// <summary>
    ///    Define se o Badge deve ter cantos totalmente arredondados
    ///    (formato de pilula).
    /// </summary>
    /// <param name="AValue">
    ///    True para aplicar formato de pilula. O padrao, quando o
    ///    metodo nao e chamado, e False.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    /// <remarks>
    ///    Pill e um atalho que aplica XRadius e YRadius iguais a
    ///    metade de Height. Quando Pill(True) e utilizado, qualquer
    ///    valor definido via CornerRadius e ignorado.
    /// </remarks>
    function Pill(AValue: Boolean = True): IRickUIBuilderBadge;

    /// <summary>
    ///    Define o raio dos cantos do Badge, para uso quando Pill
    ///    nao for utilizado.
    /// </summary>
    /// <param name="AValue">
    ///    Raio, em pixels, aplicado a XRadius e YRadius do retangulo.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    function CornerRadius(AValue: Single): IRickUIBuilderBadge;

    /// <summary>
    ///    Define o espacamento externo aplicado ao Badge apos sua
    ///    criacao.
    /// </summary>
    /// <param name="AValue">
    ///    Espacamento a ser somado a posicao definida em Position.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    /// <remarks>
    ///    O Margin e somado, nao substitui, os valores de Left/Top
    ///    definidos via Position. Se Position nao for chamado, a soma
    ///    parte de (0,0).
    /// </remarks>
    function Margin(const AValue: TRickUIBuilderSpacing): IRickUIBuilderBadge;

    /// <summary>
    ///    Define o espacamento interno entre a borda do Badge e o
    ///    label de texto.
    /// </summary>
    /// <param name="AValue">
    ///    Espacamento a ser aplicado entre a borda do retangulo e o
    ///    label interno.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    function Padding(const AValue: TRickUIBuilderSpacing): IRickUIBuilderBadge;

    /// <summary>
    ///    Define a cor de fundo do Badge.
    /// </summary>
    /// <param name="AValue">
    ///    Cor de preenchimento do retangulo.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    function BackgroundColor(AValue: TAlphaColor): IRickUIBuilderBadge;

    /// <summary>
    ///    Define a cor do texto exibido no Badge.
    /// </summary>
    /// <param name="AValue">
    ///    Cor a ser aplicada ao texto.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    function TextColor(AValue: TAlphaColor): IRickUIBuilderBadge;

    /// <summary>
    ///    Define a cor da borda do Badge.
    /// </summary>
    /// <param name="AValue">
    ///    Cor da borda. Utilize TAlphaColors.Null para nenhuma borda.
    ///    O padrao, quando o metodo nao e chamado, e sem borda.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    function BorderColor(AValue: TAlphaColor): IRickUIBuilderBadge;

    /// <summary>
    ///    Define o tamanho da fonte do texto do Badge.
    /// </summary>
    /// <param name="AValue">
    ///    Tamanho da fonte, em pontos.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    function FontSize(AValue: Single): IRickUIBuilderBadge;

    /// <summary>
    ///    Define se o texto do Badge e exibido em negrito.
    /// </summary>
    /// <param name="AValue">
    ///    True para negrito. O padrao, quando o metodo nao e chamado,
    ///    e False.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    function Bold(AValue: Boolean = True): IRickUIBuilderBadge;

    /// <summary>
    ///    Define a opacidade geral do Badge.
    /// </summary>
    /// <param name="AValue">
    ///    Valor entre 0 (totalmente transparente) e 1 (totalmente
    ///    opaco).
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    function Opacity(AValue: Single): IRickUIBuilderBadge;

    /// <summary>
    ///    Define a visibilidade inicial do Badge.
    /// </summary>
    /// <param name="AValue">
    ///    True para visivel. O padrao, quando o metodo nao e chamado,
    ///    e True.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    function Visible(AValue: Boolean = True): IRickUIBuilderBadge;

    /// <summary>
    ///    Define o valor de Tag do Container criado, util para
    ///    identificacao em manipuladores de evento compartilhados.
    /// </summary>
    /// <param name="AValue">
    ///    Valor numerico a ser atribuido a Tag.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    function Tag(AValue: NativeInt): IRickUIBuilderBadge;

    /// <summary>
    ///    Cria efetivamente o Badge (Container e TextLabel) com todas
    ///    as configuracoes acumuladas ate este ponto.
    /// </summary>
    /// <param name="AParent">
    ///    Controle ou formulario que sera o Parent do Container criado.
    /// </param>
    /// <returns>
    ///    Um IRickUIBuilderBadgeHandle contendo o Container e o
    ///    TextLabel criados.
    /// </returns>
    function Build(AParent: TFmxObject): IRickUIBuilderBadgeHandle;
  end;

  /// <summary>
  ///    Builder fluente para criacao de um divisor (linha horizontal
  ///    ou vertical). Cada metodo retorna a propria instancia,
  ///    permitindo encadeamento. A criacao real do controle so ocorre
  ///    ao chamar Build.
  /// </summary>
  IRickUIBuilderDivider = interface
    ['{2C5D8E1A-4F6B-4C3D-9E1A-7B8C9D0E1F2A}']

    /// <summary>
    ///    Define a posicao (Left, Top) do divisor dentro do seu
    ///    Parent.
    /// </summary>
    /// <param name="ALeft">
    ///    Distancia a partir da borda esquerda do Parent.
    /// </param>
    /// <param name="ATop">
    ///    Distancia a partir da borda superior do Parent.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    function Position(ALeft, ATop: Single): IRickUIBuilderDivider;

    /// <summary>
    ///    Define o comprimento do divisor.
    /// </summary>
    /// <param name="AValue">
    ///    Comprimento, em pixels, na direcao definida por Orientation.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    function Width(AValue: Single): IRickUIBuilderDivider;

    /// <summary>
    ///    Define a espessura do divisor.
    /// </summary>
    /// <param name="AValue">
    ///    Espessura, em pixels. O padrao, quando o metodo nao e
    ///    chamado, e 1.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    function Thickness(AValue: Single): IRickUIBuilderDivider;

    /// <summary>
    ///    Define a orientacao do divisor.
    /// </summary>
    /// <param name="AValue">
    ///    Horizontal ou Vertical. O padrao, quando o metodo nao e
    ///    chamado, e Horizontal.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    /// <remarks>
    ///    Quando Orientation e Vertical, o valor definido em Width e
    ///    aplicado como altura do controle, e Thickness como largura -
    ///    o divisor gira o sentido de desenho, nao a semantica dos
    ///    metodos.
    /// </remarks>
    function Orientation(AValue: TOrientation): IRickUIBuilderDivider;

    /// <summary>
    ///    Define o espacamento externo aplicado ao divisor apos sua
    ///    criacao.
    /// </summary>
    /// <param name="AValue">
    ///    Espacamento a ser somado a posicao definida em Position.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    /// <remarks>
    ///    O Margin e somado, nao substitui, os valores de Left/Top
    ///    definidos via Position. Se Position nao for chamado, a soma
    ///    parte de (0,0).
    /// </remarks>
    function Margin(const AValue: TRickUIBuilderSpacing): IRickUIBuilderDivider;

    /// <summary>
    ///    Define a cor do divisor.
    /// </summary>
    /// <param name="AValue">
    ///    Cor de preenchimento do divisor.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    function Color(AValue: TAlphaColor): IRickUIBuilderDivider;

    /// <summary>
    ///    Define a opacidade do divisor.
    /// </summary>
    /// <param name="AValue">
    ///    Valor entre 0 (totalmente transparente) e 1 (totalmente
    ///    opaco).
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    function Opacity(AValue: Single): IRickUIBuilderDivider;

    /// <summary>
    ///    Define a visibilidade inicial do divisor.
    /// </summary>
    /// <param name="AValue">
    ///    True para visivel. O padrao, quando o metodo nao e chamado,
    ///    e True.
    /// </param>
    /// <returns>
    ///    A propria instancia do builder, permitindo encadeamento fluente.
    /// </returns>
    function Visible(AValue: Boolean = True): IRickUIBuilderDivider;

    /// <summary>
    ///    Cria efetivamente o divisor (TRectangle) com todas as
    ///    configuracoes acumuladas ate este ponto.
    /// </summary>
    /// <param name="AParent">
    ///    Controle ou formulario que sera o Parent do divisor criado.
    /// </param>
    /// <returns>
    ///    O TRectangle criado, ja anexado a AParent.
    /// </returns>
    function Build(AParent: TFmxObject): TRectangle;
  end;

  /// <summary>
  ///    Composer fluente para a abordagem de composicao (meio-termo)
  ///    do framework Rick.UIBuilder: encadeia a criacao de multiplos
  ///    controles no mesmo Parent, delegando cada criacao para
  ///    TRickUIBuilderFactory. Ao contrario dos builders IRickUIBuilderLabel,
  ///    IRickUIBuilderButton, IRickUIBuilderBadge e IRickUIBuilderDivider,
  ///    cada metodo aqui ja cria o controle imediatamente - nao ha um
  ///    Build final.
  /// </summary>
  IRickUIBuilderComposer = interface
    ['{4B7E9D2C-6A3F-4B8D-9E5C-1F2A3B4C5D6E}']

    /// <summary>
    ///    Cria um TLabel no Parent associado a este composer.
    /// </summary>
    /// <param name="AText">
    ///    Texto a ser exibido no controle.
    /// </param>
    /// <param name="AConfig">
    ///    Configuracao de geometria e tipografia a ser aplicada.
    /// </param>
    /// <returns>
    ///    A propria instancia do composer, permitindo encadeamento
    ///    fluente.
    /// </returns>
    function AddText(const AText: string;
      const AConfig: TRickUIBuilderTextConfig): IRickUIBuilderComposer;

    /// <summary>
    ///    Cria um divisor (TRectangle de 1px de altura) no Parent
    ///    associado a este composer.
    /// </summary>
    /// <param name="AConfig">
    ///    Configuracao de geometria e cor a ser aplicada.
    /// </param>
    /// <returns>
    ///    A propria instancia do composer, permitindo encadeamento
    ///    fluente.
    /// </returns>
    function AddDivider(
      const AConfig: TRickUIBuilderDividerConfig): IRickUIBuilderComposer;

    /// <summary>
    ///    Cria um Badge (TRectangle com TLabel interno) no Parent
    ///    associado a este composer.
    /// </summary>
    /// <param name="AText">
    ///    Texto a ser exibido dentro do Badge.
    /// </param>
    /// <param name="AConfig">
    ///    Configuracao de geometria e cor a ser aplicada.
    /// </param>
    /// <param name="AHandle">
    ///    Parametro de saida com o handle do Badge criado (Container
    ///    e TextLabel), para que o chamador possa manipula-lo
    ///    posteriormente.
    /// </param>
    /// <returns>
    ///    A propria instancia do composer, permitindo encadeamento
    ///    fluente.
    /// </returns>
    function AddBadge(const AText: string;
      const AConfig: TRickUIBuilderBadgeConfig;
      out AHandle: IRickUIBuilderBadgeHandle): IRickUIBuilderComposer;

    /// <summary>
    ///    Cria um botao customizado (TRectangle com TLabel interno)
    ///    no Parent associado a este composer.
    /// </summary>
    /// <param name="ACaption">
    ///    Texto a ser exibido no botao.
    /// </param>
    /// <param name="AConfig">
    ///    Configuracao de geometria, cor e Tag a ser aplicada.
    /// </param>
    /// <param name="AOnClick">
    ///    Manipulador a ser atribuido a OnClick do botao criado.
    ///    Pode ser nil quando o botao nao precisa reagir a clique.
    /// </param>
    /// <returns>
    ///    A propria instancia do composer, permitindo encadeamento
    ///    fluente.
    /// </returns>
    function AddButton(const ACaption: string;
      const AConfig: TRickUIBuilderButtonConfig;
      AOnClick: TNotifyEvent): IRickUIBuilderComposer;
  end;

implementation

end.
