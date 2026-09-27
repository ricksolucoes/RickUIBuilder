unit Rick.UIBuilder.Types;
{$SCOPEDENUMS ON}
(*
  ==============================================================================
  Unit: Rick.UIBuilder.Types
  ==============================================================================

  RESPONSABILIDADE

  Define os tipos publicos de configuracao utilizados pelo framework
  Rick.UIBuilder, incluindo os records da Factory, os contratos de dados e
  estilo do ComboBox e o espacamento (TRickUIBuilderSpacing) compartilhado
  pelas abordagens Factory, Builders fluentes e Composition.

  Esta unit NAO depende de FMX.Forms, FMX.Controls ou qualquer unit de
  UI concreta - apenas dos tipos base necessarios para descrever geometria,
  cor e tipografia (System.UITypes, FMX.Types).

  Esta unit NAO conhece paleta de cores de nenhum projeto consumidor.
  Os valores em "Default" sao neutros (preto, cinza, branco); a identidade
  visual de cada projeto deve ser aplicada pelo consumidor, preenchendo os
  campos apos obter o valor padrao.

  ==============================================================================
*)

interface

uses
  System.UITypes,
  FMX.Types;

type
  /// <summary>
  ///    Agrupa as configuracoes necessarias para criar um controle de
  ///    texto (TLabel) atraves de TRickUIBuilderFactory.CreateText.
  /// </summary>
  TRickUIBuilderTextConfig = record
    Left              : Single;
    Top               : Single;
    Width             : Single;
    Height            : Single;
    FontSize          : Single;
    FontColor         : TAlphaColor;
    HorizontalAlign   : TTextAlign;
    Bold              : Boolean;

    /// <summary>
    ///    Cria uma instancia de TRickUIBuilderTextConfig preenchida com
    ///    valores padrao neutros, prontos para serem ajustados pelo
    ///    consumidor conforme a identidade visual do projeto.
    /// </summary>
    /// <returns>
    ///    Um TRickUIBuilderTextConfig com Width 100, Height 25, FontSize 12,
    ///    FontColor preto, HorizontalAlign Leading e Bold False.
    /// </returns>
    class function Default: TRickUIBuilderTextConfig; static;
  end;

  /// <summary>
  ///    Agrupa as configuracoes necessarias para criar um Badge
  ///    (retangulo com texto interno) atraves de
  ///    TRickUIBuilderFactory.CreateBadge.
  /// </summary>
  TRickUIBuilderBadgeConfig = record
    Left              : Single;
    Top               : Single;
    Width             : Single;
    Height            : Single;
    BackgroundColor   : TAlphaColor;
    TextColor         : TAlphaColor;
    FontSize          : Single;

    /// <summary>
    ///    Cria uma instancia de TRickUIBuilderBadgeConfig preenchida com
    ///    valores padrao neutros, prontos para serem ajustados pelo
    ///    consumidor conforme a identidade visual do projeto.
    /// </summary>
    /// <returns>
    ///    Um TRickUIBuilderBadgeConfig com Width 80, Height 25,
    ///    BackgroundColor cinza claro, TextColor preto e FontSize 12.
    /// </returns>
    class function Default: TRickUIBuilderBadgeConfig; static;
  end;

  /// <summary>
  ///    Agrupa as configuracoes necessarias para criar um botao
  ///    customizado (retangulo com texto interno) atraves de
  ///    TRickUIBuilderFactory.CreateButton.
  /// </summary>
  TRickUIBuilderButtonConfig = record
    Left              : Single;
    Top               : Single;
    Width             : Single;
    Height            : Single;
    FillColor         : TAlphaColor;
    BorderColor       : TAlphaColor;
    TextColor         : TAlphaColor;
    Tag               : NativeInt;
    FontSize          : Single;

    /// <summary>
    ///    Cria uma instancia de TRickUIBuilderButtonConfig preenchida com
    ///    valores padrao neutros, prontos para serem ajustados pelo
    ///    consumidor conforme a identidade visual do projeto.
    /// </summary>
    /// <returns>
    ///    Um TRickUIBuilderButtonConfig com Width 120, Height 40,
    ///    FillColor azul, BorderColor transparente, TextColor branco,
    ///    Tag 0 e FontSize 16.
    /// </returns>
    /// <remarks>
    ///    O valor de FontSize retornado aqui (16) segue o padrao tipico
    ///    de botoes de acao; ajuste conforme a hierarquia visual de cada
    ///    tela.
    /// </remarks>
    class function Default: TRickUIBuilderButtonConfig; static;
  end;

  /// <summary>
  ///    Agrupa as configuracoes necessarias para criar um divisor
  ///    (linha horizontal ou vertical) atraves de
  ///    TRickUIBuilderFactory.CreateDivider.
  /// </summary>
  TRickUIBuilderDividerConfig = record
    Left              : Single;
    Top               : Single;
    Width             : Single;
    Color             : TAlphaColor;

    /// <summary>
    ///    Cria uma instancia de TRickUIBuilderDividerConfig preenchida
    ///    com valores padrao neutros, prontos para serem ajustados pelo
    ///    consumidor conforme a identidade visual do projeto.
    /// </summary>
    /// <returns>
    ///    Um TRickUIBuilderDividerConfig com Width 100 e Color cinza claro.
    /// </returns>
    class function Default: TRickUIBuilderDividerConfig; static;
  end;

  /// <summary>
  ///    Perfis de experiencia visual e de interacao disponiveis para o
  ///    ComboBox. O valor Adaptive e resolvido em runtime para Desktop ou
  ///    Mobile sem criar implementacoes independentes do componente.
  /// </summary>
  TRickUIBuilderComboBoxStyleType = (
    Desktop,
    Mobile,
    Adaptive,
    Custom
  );

  /// <summary>
  ///    Define como a superficie de selecao do ComboBox sera apresentada.
  ///    Auto permite ao StyleType escolher o default; Anchored mantem a lista
  ///    junto ao controle, Overlay utiliza a area disponivel do Parent e
  ///    FullWindow ocupa o host visual raiz da aplicacao.
  /// </summary>
  TRickUIBuilderComboBoxPresentationMode = (
    Auto,
    Anchored,
    Overlay,
    FullWindow
  );

  /// <summary>
  ///    Define em qual lateral do controle principal a seta do ComboBox sera
  ///    ancorada. As margens da seta continuam independentes da lateral.
  /// </summary>
  TRickUIBuilderComboBoxArrowPosition = (
    Left,
    Right
  );

  /// <summary>
  ///    Estrategia de dimensionamento de uma coluna visual do ComboBox.
  /// </summary>
  TRickUIBuilderComboBoxColumnSizeMode = (
    Auto,
    Fixed,
    Proportional
  );

  /// <summary>
  ///    Configuracao publica de uma coluna adicional exibida nos itens do
  ///    ComboBox. Nao representa cabecalho nem identidade do item.
  /// </summary>
  TRickUIBuilderComboBoxColumn = record
    SizeMode: TRickUIBuilderComboBoxColumnSizeMode;
    SizeValue: Single;
    Alignment: TTextAlign;
    Visible: Boolean;

    /// <summary>
    ///    Cria uma coluna com o modo de dimensionamento informado.
    /// </summary>
    class function Create(ASizeMode: TRickUIBuilderComboBoxColumnSizeMode;
      ASizeValue: Single = 0): TRickUIBuilderComboBoxColumn; static;
  end;

  /// <summary>
  ///    Item logico do ComboBox. DisplayText e o texto principal apresentado
  ///    ao usuario, Value e um valor semantico sem requisito de unicidade e
  ///    Columns armazena dados visuais adicionais para apresentacao rica.
  /// </summary>
  TRickUIBuilderComboBoxItem = record
    DisplayText: string;
    Value: string;
    Columns: TArray<string>;

    /// <summary>
    ///    Cria um item textual simples usando o proprio texto tambem como
    ///    Value.
    /// </summary>
    class function Create(
      const ADisplayText: string): TRickUIBuilderComboBoxItem; overload; static;

    /// <summary>
    ///    Cria um item com DisplayText e Value independentes.
    /// </summary>
    class function Create(const ADisplayText,
      AValue: string): TRickUIBuilderComboBoxItem; overload; static;

    /// <summary>
    ///    Cria um item estruturado com dados adicionais para colunas.
    /// </summary>
    class function Structured(const ADisplayText, AValue: string;
      const AColumns: array of string): TRickUIBuilderComboBoxItem; static;
  end;

  /// <summary>
  ///    Configuracao materializada do ComboBox. O record concentra apenas
  ///    tokens publicos de geometria, tipografia, cores, estilo, apresentacao
  ///    e paths; estado de selecao, popup e virtualizacao permanecem internos.
  /// </summary>
  TRickUIBuilderComboBoxConfig = record
    Left: Single;
    Top: Single;
    Width: Single;
    Height: Single;
    ItemHeight: Single;
    PopupWidth: Single;
    PopupWidthOffset: Single;
    PopupMaxHeight: Single;
    CornerRadius: Single;
    HorizontalPadding: Single;
    ArrowSize: Single;
    ArrowMarginLeft: Single;
    ArrowMarginTop: Single;
    ArrowMarginRight: Single;
    ArrowMarginBottom: Single;
    ArrowPosition: TRickUIBuilderComboBoxArrowPosition;
    FontSize: Single;
    FontFamily: string;
    FontStyle: TFontStyles;
    TextAlign: TTextAlign;
    Trimming: TTextTrimming;
    BackgroundColor: TAlphaColor;
    EditBackgroundColor: TAlphaColor;
    BorderColor: TAlphaColor;
    TextColor: TAlphaColor;
    PlaceholderColor: TAlphaColor;
    ArrowColor: TAlphaColor;
    PopupColor: TAlphaColor;
    HoverColor: TAlphaColor;
    SelectedColor: TAlphaColor;
    FocusColor: TAlphaColor;
    DisabledOpacity: Single;
    SearchTimeout: Cardinal;
    FullWindowCornerRadius: Single;
    FullWindowPadding: Single;
    SearchHeaderHeight: Single;
    SearchFieldHeight: Single;
    SearchFieldCornerRadius: Single;
    SearchIconSize: Single;
    NoResultsIconSize: Single;
    FullWindowBackgroundColor: TAlphaColor;
    SearchFieldBackgroundColor: TAlphaColor;
    SearchFieldBorderColor: TAlphaColor;
    SearchTextColor: TAlphaColor;
    SearchIconColor: TAlphaColor;
    NoResultsTextColor: TAlphaColor;
    NoResultsIconColor: TAlphaColor;
    SearchPlaceholder: string;
    NoResultsText: string;
    BackPath: string;
    ClearPath: string;
    NoResultsPath: string;
    Enabled: Boolean;
    RequestedStyleType: TRickUIBuilderComboBoxStyleType;
    EffectiveStyleType: TRickUIBuilderComboBoxStyleType;
    PresentationMode: TRickUIBuilderComboBoxPresentationMode;
    ClosedArrowPath: string;
    OpenedArrowPath: string;

    /// <summary>
    ///    Retorna os defaults neutros do ComboBox. Overrides explicitos do
    ///    Builder podem substituir esses valores antes do Build.
    /// </summary>
    class function Default: TRickUIBuilderComboBoxConfig; static;
  end;


  TRickUIBuilderEditPreset = (
    AllCharacters,
    CPF,
    CNPJ,
    CEP,
    Email,
    URL,
    Phone,
    Mobile,
    IntegerNumber,
    FloatNumber,
    TextNoAccents,
    TextPunctuationNoAccents,
    TextWithAccents,
    TextPunctuationWithAccents
  );

  TRickUIBuilderEditCaseMode = (
    Preserve,
    Uppercase,
    Lowercase
  );

  TRickUIBuilderEditUrlCaseMode = (
    SchemeAndHost,
    EntireValue
  );

  TRickUIBuilderEditNumberFormatMode = (
    Locale,
    Custom
  );

  TRickUIBuilderEditInvalidFeedback = (
    AlertOnly,
    IconOnly,
    AlertAndIcon
  );

  TRickUIBuilderEditConfig = record
  private
    class procedure InitBehavior(var AValue: TRickUIBuilderEditConfig); static;
    class procedure InitVisual(var AValue: TRickUIBuilderEditConfig); static;
    class procedure InitPaths(var AValue: TRickUIBuilderEditConfig); static;
  public
    Left: Single;
    Top: Single;
    Width: Single;
    Height: Single;
    LabelText: string;
    Text: string;
    MaxLength: Integer;
    Preset: TRickUIBuilderEditPreset;
    CaseMode: TRickUIBuilderEditCaseMode;
    UrlCaseMode: TRickUIBuilderEditUrlCaseMode;
    NumberFormatMode: TRickUIBuilderEditNumberFormatMode;
    InvalidFeedback: TRickUIBuilderEditInvalidFeedback;
    InvalidMessage: string;
    AllowNegative: Boolean;
    DecimalPlaces: Integer;
    DecimalSeparator: Char;
    ThousandSeparator: Char;
    UseThousandSeparator: Boolean;
    ShowCounter: Boolean;
    ShowClearButton: Boolean;
    ShowRequirementIndicator: Boolean;
    Password: Boolean;
    BackgroundColor: TAlphaColor;
    EditBackgroundColor: TAlphaColor;
    BorderColor: TAlphaColor;
    FocusBorderColor: TAlphaColor;
    InvalidBorderColor: TAlphaColor;
    InvalidBackgroundColor: TAlphaColor;
    TextColor: TAlphaColor;
    LabelColor: TAlphaColor;
    InvalidLabelColor: TAlphaColor;
    IconColor: TAlphaColor;
    AlertIconColor: TAlphaColor;
    ClearIconColor: TAlphaColor;
    PasswordIconColor: TAlphaColor;
    RequirementIconColor: TAlphaColor;
    CornerRadius: Single;
    BorderThickness: Single;
    FontSize: Single;
    IconSize: Single;
    AlertPath: string;
    ClearPath: string;
    VisibilityPath: string;
    VisibilityOffPath: string;
    RequirementMetPath: string;
    RequirementNotMetPath: string;
    class function Default: TRickUIBuilderEditConfig; static;
  end;

  /// <summary>
  ///    Representa um espacamento com valores independentes para cada
  ///    lado (esquerda, topo, direita, base). Utilizado pelos metodos
  ///    Margin e Padding em todos os builders fluentes do framework.
  /// </summary>
  TRickUIBuilderSpacing = record
    Left              : Single;
    Top               : Single;
    Right             : Single;
    Bottom            : Single;

    /// <summary>
    ///    Cria um espacamento com valores independentes para cada lado.
    /// </summary>
    /// <param name="ALeft">
    ///    Espacamento aplicado a esquerda.
    /// </param>
    /// <param name="ATop">
    ///    Espacamento aplicado ao topo.
    /// </param>
    /// <param name="ARight">
    ///    Espacamento aplicado a direita.
    /// </param>
    /// <param name="ABottom">
    ///    Espacamento aplicado a base.
    /// </param>
    /// <returns>
    ///    Um TRickUIBuilderSpacing com os valores informados em cada lado.
    /// </returns>
    class function Create(ALeft, ATop, ARight,
      ABottom: Single): TRickUIBuilderSpacing; static;

    /// <summary>
    ///    Cria um espacamento com o mesmo valor aplicado nos 4 lados.
    /// </summary>
    /// <param name="AValue">
    ///    Valor a ser aplicado em Left, Top, Right e Bottom.
    /// </param>
    /// <returns>
    ///    Um TRickUIBuilderSpacing com AValue em todos os lados.
    /// </returns>
    class function Uniform(AValue: Single): TRickUIBuilderSpacing; static;

    /// <summary>
    ///    Cria um espacamento nulo, sem deslocamento em nenhum lado.
    /// </summary>
    /// <returns>
    ///    Um TRickUIBuilderSpacing com Left, Top, Right e Bottom iguais
    ///    a zero.
    /// </returns>
    /// <remarks>
    ///    Equivalente ao valor implicito assumido pelos builders quando
    ///    Margin ou Padding nao sao chamados.
    /// </remarks>
    class function None: TRickUIBuilderSpacing; static;
  end;


  /// <summary>
  ///   Representa um callback associado a uma instancia que retorna um valor
  ///   Boolean.
  /// </summary>
  /// <returns>
  ///   O valor Boolean determinado pela implementacao do callback.
  /// </returns>
  TRickUIBuilderBooleanCallback = function: Boolean of object;

  /// <summary>
  ///    Representa um callback associado a uma instancia que recebe um valor
  ///    Boolean. A semantica do valor e definida pelo ponto de uso.
  /// </summary>
  /// <param name="AValue">
  ///    Valor Boolean fornecido ao callback.
  /// </param>
  TRickUIBuilderBooleanProcedure = procedure(AValue: Boolean) of object;

  TRickUIBuilderEditFormatterFunc = function(const AValue: string;
    const AConfig: TRickUIBuilderEditConfig): string;

const
  /// <summary>Path vetorial padrao da seta para baixo, normalizado do SVG fornecido.</summary>
  RICK_COMBOBOX_ARROW_DOWN_PATH =
    'M 12,15.4 L 6,9.4 L 7.075,8.325 L 12,13.25 L 16.925,8.325 L 18,9.4 L 12,15.4 Z';
  /// <summary>Path vetorial padrao da seta para cima, normalizado do SVG fornecido.</summary>
  RICK_COMBOBOX_ARROW_UP_PATH =
    'M 12,10.15 L 7.075,15.075 L 6,14 L 12,8 L 18,14 L 16.925,15.075 L 12,10.15 Z';
  /// <summary>Path vetorial padrao do comando de voltar do FullWindow.</summary>
  RICK_COMBOBOX_BACK_PATH =
    'M400-240 160-480l241-241 43 42-169 169h526v60H275l168 168-43 42Z';
  /// <summary>Path vetorial padrao do comando de limpar a pesquisa.</summary>
  RICK_COMBOBOX_CLEAR_PATH =
    'm330-288 150-150 150 150 42-42-150-150 150-150-42-42-150 150-150-150-42 42 150 150-150 150 42 42ZM480-80q-82 0-155-31.5t-127.5-86Q143-252 111.5-325T80-480q0-83 31.5-156t86-127Q252-817 325-848.5T480-880q83 0 156 31.5T763-763q54 54 85.5 127T880-480q0 82-31.5 155T763-197.5q-54 54.5-127 86T480-80Zm0-60q142 0 241-99.5T820-480q0-142-99-241t-241-99q-141 0-240.5 99T140-480q0 141 99.5 240.5T480-140Zm0-340Z';
  /// <summary>Path vetorial padrao do estado sem resultados.</summary>
  RICK_COMBOBOX_NO_RESULTS_PATH =
    'M244.5-414.5Q233-426 233-443t11.5-28.5Q256-483 273-483t28.5 11.5Q313-460 313-443t-11.5 28.5Q290-403 273-403t-28.5-11.5ZM819-240l-60-60h61v-520H238l-60-60h642q23 0 41.5 18.5T880-820v520q0 23-17.5 41.5T819-240ZM525-533l-60-60h261v60H525ZM860-28 648-240H240L80-80v-729l-24-23 41-44L903-70l-43 42ZM364-525Zm135-35Zm-254.5 25.5Q233-546 233-563t11.5-28.5Q256-603 273-603t28.5 11.5Q313-580 313-563t-11.5 28.5Q290-523 273-523t-28.5-11.5ZM405-653l-24-24v-36h345v60H405Zm-265-96v529l74-80h374L140-749Z';

implementation

{ TRickUIBuilderTextConfig }


class function TRickUIBuilderEditConfig.Default: TRickUIBuilderEditConfig;
begin
  Result.Left := 0;
  Result.Top := 0;
  Result.Width := 280;
  Result.Height := 72;
  Result.LabelText := '';
  Result.Text := '';
  InitBehavior(Result);
  InitVisual(Result);
  InitPaths(Result);
end;

class procedure TRickUIBuilderEditConfig.InitBehavior(
  var AValue: TRickUIBuilderEditConfig);
begin
  AValue.MaxLength := 0;
  AValue.Preset := TRickUIBuilderEditPreset.AllCharacters;
  AValue.CaseMode := TRickUIBuilderEditCaseMode.Preserve;
  AValue.UrlCaseMode := TRickUIBuilderEditUrlCaseMode.SchemeAndHost;
  AValue.NumberFormatMode := TRickUIBuilderEditNumberFormatMode.Locale;
  AValue.InvalidFeedback := TRickUIBuilderEditInvalidFeedback.AlertAndIcon;
  AValue.InvalidMessage := '';
  AValue.AllowNegative := False;
  AValue.DecimalPlaces := 2;
  AValue.DecimalSeparator := #0;
  AValue.ThousandSeparator := #0;
  AValue.UseThousandSeparator := False;
  AValue.ShowCounter := False;
  AValue.ShowClearButton := False;
  AValue.ShowRequirementIndicator := False;
  AValue.Password := False;
end;

class procedure TRickUIBuilderEditConfig.InitVisual(
  var AValue: TRickUIBuilderEditConfig);
begin
  AValue.BackgroundColor := TAlphaColors.White;
  AValue.EditBackgroundColor := $00000000;
  AValue.BorderColor := $FFB0B0B0;
  AValue.FocusBorderColor := TAlphaColors.Black;
  AValue.InvalidBorderColor := $FFD93025;
  AValue.InvalidBackgroundColor := $FFFFF0F0;
  AValue.TextColor := TAlphaColors.Black;
  AValue.LabelColor := $FF606060;
  AValue.InvalidLabelColor := $FFD93025;
  AValue.IconColor := $FF606060;
  AValue.AlertIconColor := AValue.IconColor;
  AValue.ClearIconColor := AValue.IconColor;
  AValue.PasswordIconColor := AValue.IconColor;
  AValue.RequirementIconColor := AValue.IconColor;
  AValue.CornerRadius := 8;
  AValue.BorderThickness := 1;
  AValue.FontSize := 14;
  AValue.IconSize := 20;
end;

class procedure TRickUIBuilderEditConfig.InitPaths(
  var AValue: TRickUIBuilderEditConfig);
begin
  AValue.AlertPath := 'M378-246 154-470l43-43 181 181 384-384 43 43-427 427ZM588-96.5Q532-152 532-230q0-79 56-135t134-56q78 0 134 56t56 135q0 78-56 133.5T722-41q-78 0-134-55.5ZM722-117q9 0 15.5-6t6.5-16q0-10-6.5-16t-15.5-6q-10 0-16 6t-6 16q0 10 6 16t16 6Zm-18-85h35v-143h-35v143Z';
  AValue.ClearPath := 'm330-288 150-150 150 150 42-42-150-150 150-150-42-42-150 150-150-150-42 42 150 150-150 150 42 42ZM480-80q-82 0-155-31.5t-127.5-86Q143-252 111.5-325T80-480q0-83 31.5-156t86-127Q252-817 325-848.5T480-880q83 0 156 31.5T763-763q54 54 85.5 127T880-480q0 82-31.5 155T763-197.5q-54 54.5-127 86T480-80Zm0-60q142 0 241-99.5T820-480q0-142-99-241t-241-99q-141 0-240.5 99T140-480q0 141 99.5 240.5T480-140Zm0-340Z';
  AValue.VisibilityPath := 'M600.5-379.5Q650-429 650-500t-49.5-120.5Q551-670 480-670t-120.5 49.5Q310-571 310-500t49.5 120.5Q409-330 480-330t120.5-49.5Zm-200-41Q368-453 368-500t32.5-79.5Q433-612 480-612t79.5 32.5Q592-547 592-500t-32.5 79.5Q527-388 480-388t-79.5-32.5ZM216-283Q98-366 40-500q58-134 176-217t264-83q146 0 264 83t176 217q-58 134-176 217t-264 83q-146 0-264-83Zm264-217Zm222.5 174.5Q804-391 857-500q-53-109-154.5-174.5T480-740q-121 0-222.5 65.5T102-500q54 109 155.5 174.5T480-260q121 0 222.5-65.5Z';
  AValue.VisibilityOffPath := 'm629-419-44-44q26-71-27-118t-115-24l-44-44q17-11 38-16t43-5q71 0 120.5 49.5T650-500q0 22-5.5 43.5T629-419Zm129 129-40-40q49-36 85.5-80.5T857-500q-50-111-150-175.5T490-740q-42 0-86 8t-69 19l-46-47q35-16 89.5-28T485-800q143 0 261.5 81.5T920-500q-26 64-67 117t-95 93Zm58 226L648-229q-35 14-79 21.5t-89 7.5q-146 0-265-81.5T40-500q20-52 55.5-101.5T182-696L56-822l42-43 757 757-39 44ZM223-654q-37 27-71.5 71T102-500q51 111 153.5 175.5T488-260q33 0 65-4t48-12l-64-64q-11 5-27 7.5t-30 2.5q-70 0-120-49t-50-121q0-15 2.5-30t7.5-27l-97-97Zm305 142Zm-116 58Z';
  AValue.RequirementMetPath := 'M480-80q-85 0-158-30.5T195-195q-54-54-84.5-127T80-480q0-84 30.5-157T195-764q54-54 127-85t158-31q75 0 140 24t117 66l-43 43q-44-35-98-54t-116-19q-145 0-242.5 97.5T140-480q0 145 97.5 242.5T480-140q145 0 242.5-97.5T820-480q0-30-4.5-58.5T802-594l46-46q16 37 24 77t8 83q0 85-31 158t-85 127q-54 54-127 84.5T480-80Zm-59-218L256-464l45-45 120 120 414-414 46 45-460 460Z';
  AValue.RequirementNotMetPath := 'M833-41 718-156q-50 36-110 56T480-80q-85 0-158-30.5T195-195q-54-54-84.5-127T80-480q0-68 20-128t56-110L26-848l43-43L876-84l-43 43Zm-353-99q55 0 104-15.5t91-43.5L498-376l-77 78-165-166 45-45 120 120 32-32-254-254q-28 42-43.5 91T140-480q0 145 97.5 242.5T480-140Zm324-102-43-43q28-42 43.5-91T820-480q0-145-97.5-242.5T480-820q-55 0-104 15.5T285-761l-43-43q50-36 110-56t128-20q84 0 157 31t127 85q54 54 85 127t31 157q0 68-20 128t-56 110ZM585-462l-46-45 119-119 46 45-119 119Zm-62-61Zm-86 86Z';
end;

class function TRickUIBuilderTextConfig.Default: TRickUIBuilderTextConfig;
begin
  Result.Left             := 0;
  Result.Top              := 0;
  Result.Width            := 100;
  Result.Height           := 25;
  Result.FontSize         := 12;
  Result.FontColor        := TAlphaColors.Black;
  Result.HorizontalAlign  := TTextAlign.Leading;
  Result.Bold             := False;
end;

{ TRickUIBuilderBadgeConfig }

class function TRickUIBuilderBadgeConfig.Default: TRickUIBuilderBadgeConfig;
begin
  Result.Left             := 0;
  Result.Top              := 0;
  Result.Width            := 80;
  Result.Height           := 25;
  Result.BackgroundColor  := TAlphaColors.Lightgray;
  Result.TextColor        := TAlphaColors.Black;
  Result.FontSize         := 12;
end;

{ TRickUIBuilderButtonConfig }

class function TRickUIBuilderButtonConfig.Default: TRickUIBuilderButtonConfig;
begin
  Result.Left         := 0;
  Result.Top          := 0;
  Result.Width        := 120;
  Result.Height       := 40;
  Result.FillColor    := TAlphaColors.Dodgerblue;
  Result.BorderColor  := TAlphaColors.Null;
  Result.TextColor    := TAlphaColors.White;
  Result.Tag          := 0;
  Result.FontSize     := 16;
end;

{ TRickUIBuilderDividerConfig }

class function TRickUIBuilderDividerConfig.Default: TRickUIBuilderDividerConfig;
begin
  Result.Left   := 0;
  Result.Top    := 0;
  Result.Width  := 100;
  Result.Color  := TAlphaColors.Lightgray;
end;

{ TRickUIBuilderComboBoxColumn }

class function TRickUIBuilderComboBoxColumn.Create(
  ASizeMode: TRickUIBuilderComboBoxColumnSizeMode;
  ASizeValue: Single): TRickUIBuilderComboBoxColumn;
begin
  Result.SizeMode := ASizeMode;
  Result.SizeValue := ASizeValue;
  Result.Alignment := TTextAlign.Leading;
  Result.Visible := True;
end;

{ TRickUIBuilderComboBoxItem }

class function TRickUIBuilderComboBoxItem.Create(
  const ADisplayText: string): TRickUIBuilderComboBoxItem;
begin
  Result := Create(ADisplayText, ADisplayText);
end;

class function TRickUIBuilderComboBoxItem.Create(const ADisplayText,
  AValue: string): TRickUIBuilderComboBoxItem;
begin
  Result.DisplayText := ADisplayText;
  Result.Value := AValue;
  SetLength(Result.Columns, 0);
end;

class function TRickUIBuilderComboBoxItem.Structured(const ADisplayText,
  AValue: string; const AColumns: array of string): TRickUIBuilderComboBoxItem;
var
  LIndex: Integer;
begin
  Result := Create(ADisplayText, AValue);
  SetLength(Result.Columns, Length(AColumns));
  for LIndex := 0 to High(AColumns) do
    Result.Columns[LIndex] := AColumns[LIndex];
end;

{ TRickUIBuilderComboBoxConfig }

procedure InitComboBoxGeometry(var AConfig: TRickUIBuilderComboBoxConfig);
begin
  AConfig.Left := 0;
  AConfig.Top := 0;
  AConfig.Width := 220;
  AConfig.Height := 40;
  AConfig.ItemHeight := 36;
  AConfig.PopupWidth := 0;
  AConfig.PopupWidthOffset := 0;
  AConfig.PopupMaxHeight := 240;
  AConfig.CornerRadius := 6;
  AConfig.HorizontalPadding := 12;
  AConfig.ArrowSize := 20;
  AConfig.ArrowMarginLeft := 8;
  AConfig.ArrowMarginTop := 0;
  AConfig.ArrowMarginRight := 12;
  AConfig.ArrowMarginBottom := 0;
  AConfig.ArrowPosition := TRickUIBuilderComboBoxArrowPosition.Right;
  AConfig.FontSize := 14;
end;

procedure InitComboBoxTypography(var AConfig: TRickUIBuilderComboBoxConfig);
begin
  AConfig.FontFamily := '';
  AConfig.FontStyle := [];
  AConfig.TextAlign := TTextAlign.Leading;
  AConfig.Trimming := TTextTrimming.None;
end;

procedure InitComboBoxColors(var AConfig: TRickUIBuilderComboBoxConfig);
begin
  AConfig.BackgroundColor := TAlphaColors.White;
  AConfig.BorderColor := $FFD0D5DD;
  AConfig.TextColor := $FF1D2939;
  AConfig.PlaceholderColor := $FF667085;
  AConfig.ArrowColor := $FF667085;
  AConfig.PopupColor := TAlphaColors.White;
  AConfig.HoverColor := $FFF2F4F7;
  AConfig.SelectedColor := $FFEFF8FF;
  AConfig.FocusColor := $FF2E90FA;
  AConfig.DisabledOpacity := 0.5;
end;

procedure InitComboBoxFullWindowGeometry(
  var AConfig: TRickUIBuilderComboBoxConfig);
begin
  AConfig.FullWindowCornerRadius := 28;
  AConfig.FullWindowPadding := 16;
  AConfig.SearchHeaderHeight := 88;
  AConfig.SearchFieldHeight := 56;
  AConfig.SearchFieldCornerRadius := 16;
  AConfig.SearchIconSize := 24;
  AConfig.NoResultsIconSize := 64;
end;

procedure InitComboBoxFullWindowColors(
  var AConfig: TRickUIBuilderComboBoxConfig);
begin
  AConfig.FullWindowBackgroundColor := TAlphaColors.White;
  AConfig.SearchFieldBackgroundColor := TAlphaColors.White;
  AConfig.SearchFieldBorderColor := $FF98A2B3;
  AConfig.SearchTextColor := $FF1D2939;
  AConfig.SearchIconColor := $FF1D2939;
  AConfig.NoResultsTextColor := $FF667085;
  AConfig.NoResultsIconColor := $FF98A2B3;
end;

procedure InitComboBoxFullWindowContent(
  var AConfig: TRickUIBuilderComboBoxConfig);
begin
  AConfig.SearchPlaceholder := 'Pesquisar...';
  AConfig.NoResultsText := 'Nenhum registro encontrado';
  AConfig.BackPath := RICK_COMBOBOX_BACK_PATH;
  AConfig.ClearPath := RICK_COMBOBOX_CLEAR_PATH;
  AConfig.NoResultsPath := RICK_COMBOBOX_NO_RESULTS_PATH;
end;

procedure InitComboBoxBehavior(var AConfig: TRickUIBuilderComboBoxConfig);
begin
  AConfig.SearchTimeout := 900;
  AConfig.Enabled := True;
  AConfig.RequestedStyleType := TRickUIBuilderComboBoxStyleType.Adaptive;
  AConfig.EffectiveStyleType := TRickUIBuilderComboBoxStyleType.Desktop;
  AConfig.PresentationMode := TRickUIBuilderComboBoxPresentationMode.Auto;
  AConfig.ClosedArrowPath := RICK_COMBOBOX_ARROW_DOWN_PATH;
  AConfig.OpenedArrowPath := RICK_COMBOBOX_ARROW_UP_PATH;
end;

class function TRickUIBuilderComboBoxConfig.Default:
  TRickUIBuilderComboBoxConfig;
begin
  InitComboBoxGeometry(Result);
  InitComboBoxTypography(Result);
  InitComboBoxColors(Result);
  InitComboBoxFullWindowGeometry(Result);
  InitComboBoxFullWindowColors(Result);
  InitComboBoxFullWindowContent(Result);
  InitComboBoxBehavior(Result);
end;

{ TRickUIBuilderSpacing }

class function TRickUIBuilderSpacing.Create(ALeft, ATop, ARight,
  ABottom: Single): TRickUIBuilderSpacing;
begin
  Result.Left   := ALeft;
  Result.Top    := ATop;
  Result.Right  := ARight;
  Result.Bottom := ABottom;
end;

class function TRickUIBuilderSpacing.Uniform(
  AValue: Single): TRickUIBuilderSpacing;
begin
  Result := TRickUIBuilderSpacing.Create(AValue, AValue, AValue, AValue);
end;

class function TRickUIBuilderSpacing.None: TRickUIBuilderSpacing;
begin
  Result := TRickUIBuilderSpacing.Create(0, 0, 0, 0);
end;

end.