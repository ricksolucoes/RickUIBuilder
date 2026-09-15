unit Rick.UIBuilder.Badge;
(*
  ==============================================================================
  Unit: Rick.UIBuilder.Badge
  ==============================================================================

  RESPONSABILIDADE

  Implementa exclusivamente o builder fluente IRickUIBuilderBadge
  (Opcao B do framework Rick.UIBuilder): TRickUIBuilderBadgeBuilder
  acumula estado em memoria a cada chamada encadeada e so cria o
  Container (TRectangle) e o TextLabel (TLabel) de fato ao chamar
  Build.

  A criacao real dos controles e delegada a TRickUIBuilderFactory.CreateBadge
  (Opcao A) - esta unit NAO reimplementa a logica de instanciacao, apenas
  acumula estado adicional que a Factory nao cobre (Pill/CornerRadius,
  Margin, Padding, BorderColor, Bold, Opacity, Visible, Tag) e aplica
  esse estado extra apos o Build da Factory.

  Esta unit NAO implementa IRickUIBuilderBadgeHandle - essa
  responsabilidade vive isoladamente em Rick.UIBuilder.BadgeHandle,
  em observancia ao Principio de Responsabilidade Unica (SRP):
  "montar o Badge" (esta unit) e "representar o Badge montado"
  (Rick.UIBuilder.BadgeHandle) sao responsabilidades distintas.

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
  ///    Implementacao de IRickUIBuilderBadge. Acumula estado em campos
  ///    privados a cada metodo encadeado; a criacao dos controles so
  ///    ocorre ao chamar Build.
  /// </summary>
  TRickUIBuilderBadgeBuilder = class(TInterfacedObject, IRickUIBuilderBadge)
  private
    FText            : string;
    FLeft            : Single;
    FTop             : Single;
    FWidth           : Single;
    FHeight          : Single;
    FPill            : Boolean;
    FCornerRadius    : Single;
    FMargin          : TRickUIBuilderSpacing;
    FPadding         : TRickUIBuilderSpacing;
    FBackgroundColor : TAlphaColor;
    FTextColor       : TAlphaColor;
    FBorderColor     : TAlphaColor;
    FFontSize        : Single;
    FBold            : Boolean;
    FOpacity         : Single;
    FVisible         : Boolean;
    FTag             : NativeInt;
  protected
    function Text(const AValue: string): IRickUIBuilderBadge;
    function Position(ALeft, ATop: Single): IRickUIBuilderBadge;
    function Size(AWidth, AHeight: Single): IRickUIBuilderBadge;
    function Pill(AValue: Boolean = True): IRickUIBuilderBadge;
    function CornerRadius(AValue: Single): IRickUIBuilderBadge;
    function Margin(const AValue: TRickUIBuilderSpacing): IRickUIBuilderBadge;
    function Padding(const AValue: TRickUIBuilderSpacing): IRickUIBuilderBadge;
    function BackgroundColor(AValue: TAlphaColor): IRickUIBuilderBadge;
    function TextColor(AValue: TAlphaColor): IRickUIBuilderBadge;
    function BorderColor(AValue: TAlphaColor): IRickUIBuilderBadge;
    function FontSize(AValue: Single): IRickUIBuilderBadge;
    function Bold(AValue: Boolean = True): IRickUIBuilderBadge;
    function Opacity(AValue: Single): IRickUIBuilderBadge;
    function Visible(AValue: Boolean = True): IRickUIBuilderBadge;
    function Tag(AValue: NativeInt): IRickUIBuilderBadge;

    function Build(AParent: TFmxObject): IRickUIBuilderBadgeHandle;

    constructor Create;
  public

    /// <summary>
    ///    Cria uma nova instancia de IRickUIBuilderBadge, ja com os
    ///    valores padrao equivalentes a TRickUIBuilderBadgeConfig.Default.
    /// </summary>
    /// <returns>
    ///    Uma nova instancia de IRickUIBuilderBadge pronta para
    ///    encadeamento.
    /// </returns>
    class function New: IRickUIBuilderBadge; static;
  end;

implementation

uses
  FMX.Graphics;

{ TRickUIBuilderBadgeBuilder }

constructor TRickUIBuilderBadgeBuilder.Create;
var
  LDefault: TRickUIBuilderBadgeConfig;
begin
  inherited Create;

  LDefault := TRickUIBuilderBadgeConfig.Default;

  FText            := '';
  FLeft            := LDefault.Left;
  FTop             := LDefault.Top;
  FWidth           := LDefault.Width;
  FHeight          := LDefault.Height;
  FPill            := False;
  FCornerRadius    := 0;
  FMargin          := TRickUIBuilderSpacing.None;
  FPadding         := TRickUIBuilderSpacing.None;
  FBackgroundColor := LDefault.BackgroundColor;
  FTextColor       := LDefault.TextColor;
  FBorderColor     := TAlphaColors.Null;
  FFontSize        := LDefault.FontSize;
  FBold            := False;
  FOpacity         := 1;
  FVisible         := True;
  FTag             := 0;
end;

class function TRickUIBuilderBadgeBuilder.New: IRickUIBuilderBadge;
begin
  Result := TRickUIBuilderBadgeBuilder.Create;
end;

function TRickUIBuilderBadgeBuilder.Text(
  const AValue: string): IRickUIBuilderBadge;
begin
  FText  := AValue;
  Result := Self;
end;

function TRickUIBuilderBadgeBuilder.Position(ALeft,
  ATop: Single): IRickUIBuilderBadge;
begin
  FLeft  := ALeft;
  FTop   := ATop;
  Result := Self;
end;

function TRickUIBuilderBadgeBuilder.Size(AWidth,
  AHeight: Single): IRickUIBuilderBadge;
begin
  FWidth  := AWidth;
  FHeight := AHeight;
  Result  := Self;
end;

function TRickUIBuilderBadgeBuilder.Pill(
  AValue: Boolean): IRickUIBuilderBadge;
begin
  FPill  := AValue;
  Result := Self;
end;

function TRickUIBuilderBadgeBuilder.CornerRadius(
  AValue: Single): IRickUIBuilderBadge;
begin
  FCornerRadius := AValue;
  Result        := Self;
end;

function TRickUIBuilderBadgeBuilder.Margin(
  const AValue: TRickUIBuilderSpacing): IRickUIBuilderBadge;
begin
  FMargin := AValue;
  Result  := Self;
end;

function TRickUIBuilderBadgeBuilder.Padding(
  const AValue: TRickUIBuilderSpacing): IRickUIBuilderBadge;
begin
  FPadding := AValue;
  Result   := Self;
end;

function TRickUIBuilderBadgeBuilder.BackgroundColor(
  AValue: TAlphaColor): IRickUIBuilderBadge;
begin
  FBackgroundColor := AValue;
  Result           := Self;
end;

function TRickUIBuilderBadgeBuilder.TextColor(
  AValue: TAlphaColor): IRickUIBuilderBadge;
begin
  FTextColor := AValue;
  Result     := Self;
end;

function TRickUIBuilderBadgeBuilder.BorderColor(
  AValue: TAlphaColor): IRickUIBuilderBadge;
begin
  FBorderColor := AValue;
  Result       := Self;
end;

function TRickUIBuilderBadgeBuilder.FontSize(
  AValue: Single): IRickUIBuilderBadge;
begin
  FFontSize := AValue;
  Result    := Self;
end;

function TRickUIBuilderBadgeBuilder.Bold(
  AValue: Boolean): IRickUIBuilderBadge;
begin
  FBold  := AValue;
  Result := Self;
end;

function TRickUIBuilderBadgeBuilder.Opacity(
  AValue: Single): IRickUIBuilderBadge;
begin
  FOpacity := AValue;
  Result   := Self;
end;

function TRickUIBuilderBadgeBuilder.Visible(
  AValue: Boolean): IRickUIBuilderBadge;
begin
  FVisible := AValue;
  Result   := Self;
end;

function TRickUIBuilderBadgeBuilder.Tag(
  AValue: NativeInt): IRickUIBuilderBadge;
begin
  FTag   := AValue;
  Result := Self;
end;

function TRickUIBuilderBadgeBuilder.Build(
  AParent: TFmxObject): IRickUIBuilderBadgeHandle;
var
  LConfig    : TRickUIBuilderBadgeConfig;
  LContainer : TRectangle;
  LTextLabel : TLabel;
begin
  LConfig                 := TRickUIBuilderBadgeConfig.Default;
  // Margin e somado a posicao definida via Position, nao substitui -
  // ver <remarks> de IRickUIBuilderBadge.Margin.
  LConfig.Left            := FLeft + FMargin.Left;
  LConfig.Top             := FTop + FMargin.Top;
  LConfig.Width           := FWidth;
  LConfig.Height          := FHeight;
  LConfig.BackgroundColor := FBackgroundColor;
  LConfig.TextColor       := FTextColor;
  LConfig.FontSize        := FFontSize;

  // AParent e utilizado tambem como Owner: TFmxObject herda de
  // TComponent, entao o ciclo de vida dos controles fica atrelado ao
  // proprio Parent informado.
  LContainer := TRickUIBuilderFactory.CreateBadge(AParent, AParent, FText,
    LConfig, LTextLabel);

  // A Factory ja aplica formato de pilula por padrao (XRadius/YRadius
  // = Height/2). Quando Pill e False, sobrescrevemos com CornerRadius
  // - ver <remarks> de IRickUIBuilderBadge.Pill.
  if not FPill then
  begin
    LContainer.XRadius := FCornerRadius;
    LContainer.YRadius := FCornerRadius;
  end;

  if not (FBorderColor = TAlphaColors.Null) then
  begin
    LContainer.Stroke.Kind  := TBrushKind.Solid;
    LContainer.Stroke.Color := FBorderColor;
  end;

  if FBold then
    LTextLabel.TextSettings.Font.Style := LTextLabel.TextSettings.Font.Style
      + [TFontStyle.fsBold];

  // Padding aplica-se ao espaco interno entre a borda do Container e
  // o TextLabel - ver <remarks> de IRickUIBuilderBadge.Padding.
  LTextLabel.Padding.Left   := FPadding.Left;
  LTextLabel.Padding.Top    := FPadding.Top;
  LTextLabel.Padding.Right  := FPadding.Right;
  LTextLabel.Padding.Bottom := FPadding.Bottom;

  LContainer.Opacity := FOpacity;
  LContainer.Visible := FVisible;
  LContainer.Tag     := FTag;

  Result := TRickUIBuilderBadgeHandle.New(LContainer, LTextLabel);
end;

end.
