unit Rick.UIBuilder.Types;
(*
  ==============================================================================
  Unit: Rick.UIBuilder.Types
  ==============================================================================

  RESPONSABILIDADE

  Define os records de configuracao utilizados pela abordagem de criacao
  direta (Factory / Opcao A) do framework Rick.UIBuilder, alem do record
  de espacamento (TRickUIBuilderSpacing) compartilhado por todas as
  abordagens (Factory, Builders fluentes e Composition).

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
