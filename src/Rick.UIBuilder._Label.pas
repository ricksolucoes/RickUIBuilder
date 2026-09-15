unit Rick.UIBuilder._Label;

(*
  ==============================================================================
  Unit: Rick.UIBuilder.Label
  ==============================================================================

  RESPONSABILIDADE

  Implementa o builder fluente IRickUIBuilderLabel (Opcao B do framework
  Rick.UIBuilder): TRickUIBuilderLabelBuilder acumula estado em memoria a
  cada chamada encadeada e so cria o TLabel de fato ao chamar Build.

  A criacao real do controle e delegada a TRickUIBuilderFactory.CreateText
  (Opcao A) - esta unit NAO reimplementa a logica de instanciacao de
  TLabel, apenas acumula estado adicional que a Factory nao cobre
  (Anchors, Margin, Padding, FontFamily, Italic, VerticalAlign, WordWrap,
  Trimming, Opacity, Visible, HitTest, Tag) e aplica esse estado extra
  apos o Build da Factory.

  ==============================================================================
*)

interface

uses
  System.Classes,
  System.UITypes,
  FMX.Types,
  FMX.Controls,
  FMX.StdCtrls,
  Rick.UIBuilder.Types,
  Rick.UIBuilder.Interfaces,
  Rick.UIBuilder.Factory;

type
  /// <summary>
  ///    Implementacao de IRickUIBuilderLabel. Acumula estado em campos
  ///    privados a cada metodo encadeado; a criacao do TLabel so ocorre
  ///    ao chamar Build.
  /// </summary>
  TRickUIBuilderLabelBuilder = class(TInterfacedObject, IRickUIBuilderLabel)
  private
    FText            : string;
    FLeft            : Single;
    FTop             : Single;
    FWidth           : Single;
    FHeight          : Single;
    FAnchors         : TAnchors;
    FMargin          : TRickUIBuilderSpacing;
    FPadding         : TRickUIBuilderSpacing;
    FFontFamily      : string;
    FFontSize        : Single;
    FFontColor       : TAlphaColor;
    FBold            : Boolean;
    FItalic          : Boolean;
    FHorizontalAlign : TTextAlign;
    FVerticalAlign   : TTextAlign;
    FWordWrap        : Boolean;
    FTrimming        : TTextTrimming;
    FOpacity         : Single;
    FVisible         : Boolean;
    FHitTest         : Boolean;
    FTag             : NativeInt;
  protected
    function Text(const AValue: string): IRickUIBuilderLabel;
    function Position(ALeft, ATop: Single): IRickUIBuilderLabel;
    function Size(AWidth, AHeight: Single): IRickUIBuilderLabel;
    function Anchors(AValue: TAnchors): IRickUIBuilderLabel;
    function Margin(const AValue: TRickUIBuilderSpacing): IRickUIBuilderLabel;
    function Padding(const AValue: TRickUIBuilderSpacing): IRickUIBuilderLabel;
    function FontFamily(const AValue: string): IRickUIBuilderLabel;
    function FontSize(AValue: Single): IRickUIBuilderLabel;
    function FontColor(AValue: TAlphaColor): IRickUIBuilderLabel;
    function Bold(AValue: Boolean = True): IRickUIBuilderLabel;
    function Italic(AValue: Boolean = True): IRickUIBuilderLabel;
    function Align(AValue: TTextAlign): IRickUIBuilderLabel;
    function VerticalAlign(AValue: TTextAlign): IRickUIBuilderLabel;
    function WordWrap(AValue: Boolean = True): IRickUIBuilderLabel;
    function Trimming(AValue: TTextTrimming): IRickUIBuilderLabel;
    function Opacity(AValue: Single): IRickUIBuilderLabel;
    function Visible(AValue: Boolean = True): IRickUIBuilderLabel;
    function HitTest(AValue: Boolean = False): IRickUIBuilderLabel;
    function Tag(AValue: NativeInt): IRickUIBuilderLabel;

    function Build(AParent: TFmxObject): TLabel;

    constructor Create;
  public

    /// <summary>
    ///    Cria uma nova instancia de IRickUIBuilderLabel, ja com os
    ///    valores padrao equivalentes a TRickUIBuilderTextConfig.Default.
    /// </summary>
    /// <returns>
    ///    Uma nova instancia de IRickUIBuilderLabel pronta para
    ///    encadeamento.
    /// </returns>
    class function New: IRickUIBuilderLabel; static;

  end;

implementation

{ TRickUIBuilderLabelBuilder }

constructor TRickUIBuilderLabelBuilder.Create;
var
  LDefault: TRickUIBuilderTextConfig;
begin
  inherited Create;

  LDefault := TRickUIBuilderTextConfig.Default;

  FText            := '';
  FLeft            := LDefault.Left;
  FTop             := LDefault.Top;
  FWidth           := LDefault.Width;
  FHeight          := LDefault.Height;
  FAnchors         := [];
  FMargin          := TRickUIBuilderSpacing.None;
  FPadding         := TRickUIBuilderSpacing.None;
  FFontFamily      := '';
  FFontSize        := LDefault.FontSize;
  FFontColor       := LDefault.FontColor;
  FBold            := LDefault.Bold;
  FItalic          := False;
  FHorizontalAlign := LDefault.HorizontalAlign;
  FVerticalAlign   := TTextAlign.Leading;
  FWordWrap        := False;
  FTrimming        := TTextTrimming.None;
  FOpacity         := 1;
  FVisible         := True;
  FHitTest         := False;
  FTag             := 0;
end;

class function TRickUIBuilderLabelBuilder.New: IRickUIBuilderLabel;
begin
  Result := TRickUIBuilderLabelBuilder.Create;
end;

function TRickUIBuilderLabelBuilder.Text(
  const AValue: string): IRickUIBuilderLabel;
begin
  FText  := AValue;
  Result := Self;
end;

function TRickUIBuilderLabelBuilder.Position(ALeft,
  ATop: Single): IRickUIBuilderLabel;
begin
  FLeft  := ALeft;
  FTop   := ATop;
  Result := Self;
end;

function TRickUIBuilderLabelBuilder.Size(AWidth,
  AHeight: Single): IRickUIBuilderLabel;
begin
  FWidth  := AWidth;
  FHeight := AHeight;
  Result  := Self;
end;

function TRickUIBuilderLabelBuilder.Anchors(
  AValue: TAnchors): IRickUIBuilderLabel;
begin
  FAnchors := AValue;
  Result   := Self;
end;

function TRickUIBuilderLabelBuilder.Margin(
  const AValue: TRickUIBuilderSpacing): IRickUIBuilderLabel;
begin
  FMargin := AValue;
  Result  := Self;
end;

function TRickUIBuilderLabelBuilder.Padding(
  const AValue: TRickUIBuilderSpacing): IRickUIBuilderLabel;
begin
  FPadding := AValue;
  Result   := Self;
end;

function TRickUIBuilderLabelBuilder.FontFamily(
  const AValue: string): IRickUIBuilderLabel;
begin
  FFontFamily := AValue;
  Result      := Self;
end;

function TRickUIBuilderLabelBuilder.FontSize(
  AValue: Single): IRickUIBuilderLabel;
begin
  FFontSize := AValue;
  Result    := Self;
end;

function TRickUIBuilderLabelBuilder.FontColor(
  AValue: TAlphaColor): IRickUIBuilderLabel;
begin
  FFontColor := AValue;
  Result     := Self;
end;

function TRickUIBuilderLabelBuilder.Bold(
  AValue: Boolean): IRickUIBuilderLabel;
begin
  FBold  := AValue;
  Result := Self;
end;

function TRickUIBuilderLabelBuilder.Italic(
  AValue: Boolean): IRickUIBuilderLabel;
begin
  FItalic := AValue;
  Result  := Self;
end;

function TRickUIBuilderLabelBuilder.Align(
  AValue: TTextAlign): IRickUIBuilderLabel;
begin
  FHorizontalAlign := AValue;
  Result           := Self;
end;

function TRickUIBuilderLabelBuilder.VerticalAlign(
  AValue: TTextAlign): IRickUIBuilderLabel;
begin
  FVerticalAlign := AValue;
  Result         := Self;
end;

function TRickUIBuilderLabelBuilder.WordWrap(
  AValue: Boolean): IRickUIBuilderLabel;
begin
  FWordWrap := AValue;
  Result    := Self;
end;

function TRickUIBuilderLabelBuilder.Trimming(
  AValue: TTextTrimming): IRickUIBuilderLabel;
begin
  FTrimming := AValue;
  Result    := Self;
end;

function TRickUIBuilderLabelBuilder.Opacity(
  AValue: Single): IRickUIBuilderLabel;
begin
  FOpacity := AValue;
  Result   := Self;
end;

function TRickUIBuilderLabelBuilder.Visible(
  AValue: Boolean): IRickUIBuilderLabel;
begin
  FVisible := AValue;
  Result   := Self;
end;

function TRickUIBuilderLabelBuilder.HitTest(
  AValue: Boolean): IRickUIBuilderLabel;
begin
  FHitTest := AValue;
  Result   := Self;
end;

function TRickUIBuilderLabelBuilder.Tag(
  AValue: NativeInt): IRickUIBuilderLabel;
begin
  FTag   := AValue;
  Result := Self;
end;

function TRickUIBuilderLabelBuilder.Build(AParent: TFmxObject): TLabel;
var
  LConfig: TRickUIBuilderTextConfig;
begin
  LConfig                 := TRickUIBuilderTextConfig.Default;
  // Margin e somado a posicao definida via Position, nao substitui -
  // ver <remarks> de IRickUIBuilderLabel.Margin.
  LConfig.Left            := FLeft + FMargin.Left;
  LConfig.Top             := FTop + FMargin.Top;
  LConfig.Width           := FWidth;
  LConfig.Height          := FHeight;
  LConfig.FontSize        := FFontSize;
  LConfig.FontColor       := FFontColor;
  LConfig.HorizontalAlign := FHorizontalAlign;
  LConfig.Bold            := FBold;

  // AParent e utilizado tambem como Owner: TFmxObject herda de
  // TComponent, entao o ciclo de vida do TLabel fica atrelado ao
  // proprio Parent informado.
  Result := TRickUIBuilderFactory.CreateText(AParent, AParent, FText, LConfig);

  Result.Anchors := FAnchors;

  if FFontFamily <> '' then
    Result.TextSettings.Font.Family := FFontFamily;

  if FItalic then
    Result.TextSettings.Font.Style := Result.TextSettings.Font.Style
      + [TFontStyle.fsItalic];

  Result.TextSettings.VertAlign := FVerticalAlign;
  Result.TextSettings.Trimming  := FTrimming;
  Result.WordWrap                := FWordWrap;

  // Padding aplica-se ao espaco interno de renderizacao do texto,
  // sem alterar Width/Height do controle - ver <remarks> de
  // IRickUIBuilderLabel.Padding.
  Result.Padding.Left   := FPadding.Left;
  Result.Padding.Top    := FPadding.Top;
  Result.Padding.Right  := FPadding.Right;
  Result.Padding.Bottom := FPadding.Bottom;

  Result.Opacity  := FOpacity;
  Result.Visible  := FVisible;
  Result.HitTest  := FHitTest;
  Result.Tag      := FTag;
end;

end.
