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

    function BuildLabelConfig: TRickUIBuilderTextConfig;
    procedure ApplyLabelFontCustomization(const AResult: TLabel);
    procedure ApplyLabelTextSettings(const AResult: TLabel);
    procedure ApplyLabelPadding(const AResult: TLabel);
    procedure ApplyLabelFinalProperties(const AResult: TLabel);

    procedure InitLayoutDefaults(const ADefault: TRickUIBuilderTextConfig);
    procedure InitFontDefaults(const ADefault: TRickUIBuilderTextConfig);
    procedure InitTextBehaviorDefaults;
    procedure InitVisualStateDefaults;
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

  InitLayoutDefaults(LDefault);
  InitFontDefaults(LDefault);
  InitTextBehaviorDefaults;
  InitVisualStateDefaults;
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
  LConfig := BuildLabelConfig;

  // AParent e utilizado tambem como Owner: TFmxObject herda de
  // TComponent, entao o ciclo de vida do TLabel fica atrelado ao
  // proprio Parent informado.
  Result := TRickUIBuilderFactory.CreateText(AParent, AParent, FText, LConfig);

  Result.Anchors := FAnchors;

  ApplyLabelFontCustomization(Result);
  ApplyLabelTextSettings(Result);
  ApplyLabelPadding(Result);
  ApplyLabelFinalProperties(Result);
end;

function TRickUIBuilderLabelBuilder.BuildLabelConfig: TRickUIBuilderTextConfig;
begin
  Result                 := TRickUIBuilderTextConfig.Default;
  // Margin e somado a posicao definida via Position, nao substitui -
  // ver <remarks> de IRickUIBuilderLabel.Margin.
  Result.Left            := FLeft + FMargin.Left;
  Result.Top             := FTop + FMargin.Top;
  Result.Width           := FWidth;
  Result.Height          := FHeight;
  Result.FontSize        := FFontSize;
  Result.FontColor       := FFontColor;
  Result.HorizontalAlign := FHorizontalAlign;
  Result.Bold            := FBold;
end;

procedure TRickUIBuilderLabelBuilder.ApplyLabelFontCustomization(
  const AResult: TLabel);
begin
  if FFontFamily <> '' then
    AResult.TextSettings.Font.Family := FFontFamily;

  if FItalic then
    AResult.TextSettings.Font.Style := AResult.TextSettings.Font.Style
      + [TFontStyle.fsItalic];
end;

procedure TRickUIBuilderLabelBuilder.ApplyLabelTextSettings(
  const AResult: TLabel);
begin
  AResult.TextSettings.VertAlign := FVerticalAlign;
  AResult.TextSettings.Trimming  := FTrimming;
  AResult.WordWrap                := FWordWrap;
end;

procedure TRickUIBuilderLabelBuilder.ApplyLabelPadding(
  const AResult: TLabel);
begin
  // Padding aplica-se ao espaco interno de renderizacao do texto,
  // sem alterar Width/Height do controle - ver <remarks> de
  // IRickUIBuilderLabel.Padding.
  AResult.Padding.Left   := FPadding.Left;
  AResult.Padding.Top    := FPadding.Top;
  AResult.Padding.Right  := FPadding.Right;
  AResult.Padding.Bottom := FPadding.Bottom;
end;

procedure TRickUIBuilderLabelBuilder.ApplyLabelFinalProperties(
  const AResult: TLabel);
begin
  AResult.Opacity := FOpacity;
  AResult.Visible := FVisible;
  AResult.HitTest := FHitTest;
  AResult.Tag     := FTag;
end;

procedure TRickUIBuilderLabelBuilder.InitLayoutDefaults(
  const ADefault: TRickUIBuilderTextConfig);
begin
  FText    := '';
  FLeft    := ADefault.Left;
  FTop     := ADefault.Top;
  FWidth   := ADefault.Width;
  FHeight  := ADefault.Height;
  FAnchors := [];
  FMargin  := TRickUIBuilderSpacing.None;
  FPadding := TRickUIBuilderSpacing.None;
end;

procedure TRickUIBuilderLabelBuilder.InitFontDefaults(
  const ADefault: TRickUIBuilderTextConfig);
begin
  FFontFamily := '';
  FFontSize   := ADefault.FontSize;
  FFontColor  := ADefault.FontColor;
  FBold       := ADefault.Bold;
  FItalic     := False;
end;

procedure TRickUIBuilderLabelBuilder.InitTextBehaviorDefaults;
begin
  FHorizontalAlign := TRickUIBuilderTextConfig.Default.HorizontalAlign;
  FVerticalAlign   := TTextAlign.Leading;
  FWordWrap        := False;
  FTrimming        := TTextTrimming.None;
end;

procedure TRickUIBuilderLabelBuilder.InitVisualStateDefaults;
begin
  FOpacity := 1;
  FVisible := True;
  FHitTest := False;
  FTag     := 0;
end;

end.
