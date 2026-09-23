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
  ///    junto ao controle e Overlay utiliza a area disponivel do Parent.
  /// </summary>
  TRickUIBuilderComboBoxPresentationMode = (
    Auto,
    Anchored,
    Overlay
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

const
  /// <summary>Path vetorial padrao da seta para baixo, normalizado do SVG fornecido.</summary>
  RICK_COMBOBOX_ARROW_DOWN_PATH =
    'M 12,15.4 L 6,9.4 L 7.075,8.325 L 12,13.25 L 16.925,8.325 L 18,9.4 L 12,15.4 Z';
  /// <summary>Path vetorial padrao da seta para cima, normalizado do SVG fornecido.</summary>
  RICK_COMBOBOX_ARROW_UP_PATH =
    'M 12,10.15 L 7.075,15.075 L 6,14 L 12,8 L 18,14 L 16.925,15.075 L 12,10.15 Z';

implementation

{ TRickUIBuilderTextConfig }

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
