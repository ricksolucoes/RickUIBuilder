unit Rick.UIBuilder.Button;
(*
  ==============================================================================
  Unit: Rick.UIBuilder.Button
  ==============================================================================

  RESPONSABILIDADE

  Implementa exclusivamente o builder fluente IRickUIBuilderButton
  (Opcao B do framework Rick.UIBuilder): TRickUIBuilderButtonBuilder
  acumula estado em memoria a cada chamada encadeada e so cria o botao
  (TRectangle com TLabel interno) de fato ao chamar Build.

  A criacao real dos controles e delegada a TRickUIBuilderFactory.CreateButton
  (Opcao A) - esta unit NAO reimplementa a logica de instanciacao, apenas
  acumula estado adicional que a Factory nao cobre (Anchors, CornerRadius,
  Margin, Padding, BorderThickness, FontFamily, Bold, HoverFillColor,
  DisabledOpacity, Enabled, Cursor, Opacity, Visible, OnClick, OnHover)
  e aplica esse estado extra apos o Build da Factory.

  Esta unit NAO implementa o gerenciamento de estado de hover - essa
  responsabilidade vive isoladamente em Rick.UIBuilder.Button.HoverState,
  em observancia ao Principio de Responsabilidade Unica (SRP): "montar
  o botao" (esta unit) e "gerenciar o estado de hover do botao"
  (Rick.UIBuilder.Button.HoverState) sao responsabilidades distintas.

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
  Rick.UIBuilder.Button.HoverState;

type
  /// <summary>
  ///    Implementacao de IRickUIBuilderButton. Acumula estado em
  ///    campos privados a cada metodo encadeado; a criacao do botao
  ///    so ocorre ao chamar Build.
  /// </summary>
  TRickUIBuilderButtonBuilder = class(TInterfacedObject, IRickUIBuilderButton)
  private
    FCaption           : string;
    FLeft              : Single;
    FTop               : Single;
    FWidth             : Single;
    FHeight            : Single;
    FAnchors           : TAnchors;
    FCornerRadius      : Single;
    FMargin            : TRickUIBuilderSpacing;
    FPadding           : TRickUIBuilderSpacing;
    FFillColor         : TAlphaColor;
    FBorderColor       : TAlphaColor;
    FBorderThickness   : Single;
    FTextColor         : TAlphaColor;
    FFontFamily        : string;
    FFontSize          : Single;
    FBold              : Boolean;
    FHoverFillColor    : TAlphaColor;
    FHasHoverFillColor : Boolean;
    FDisabledOpacity   : Single;
    FEnabled           : Boolean;
    FCursor            : TCursor;
    FOpacity           : Single;
    FVisible           : Boolean;
    FTag               : NativeInt;
    FOnClick           : TNotifyEvent;
    FOnEnter           : TNotifyEvent;
    FOnLeave           : TNotifyEvent;
  protected
    constructor Create;

    function Caption(const AValue: string): IRickUIBuilderButton;
    function Position(ALeft, ATop: Single): IRickUIBuilderButton;
    function Size(AWidth, AHeight: Single): IRickUIBuilderButton;
    function Anchors(AValue: TAnchors): IRickUIBuilderButton;
    function CornerRadius(AValue: Single): IRickUIBuilderButton;
    function Margin(const AValue: TRickUIBuilderSpacing): IRickUIBuilderButton;
    function Padding(const AValue: TRickUIBuilderSpacing): IRickUIBuilderButton;
    function FillColor(AValue: TAlphaColor): IRickUIBuilderButton;
    function BorderColor(AValue: TAlphaColor): IRickUIBuilderButton;
    function BorderThickness(AValue: Single): IRickUIBuilderButton;
    function TextColor(AValue: TAlphaColor): IRickUIBuilderButton;
    function FontFamily(const AValue: string): IRickUIBuilderButton;
    function FontSize(AValue: Single): IRickUIBuilderButton;
    function Bold(AValue: Boolean = True): IRickUIBuilderButton;
    function HoverFillColor(AValue: TAlphaColor): IRickUIBuilderButton;
    function DisabledOpacity(AValue: Single): IRickUIBuilderButton;
    function Enabled(AValue: Boolean = True): IRickUIBuilderButton;
    function Cursor(AValue: TCursor): IRickUIBuilderButton;
    function Opacity(AValue: Single): IRickUIBuilderButton;
    function Visible(AValue: Boolean = True): IRickUIBuilderButton;
    function Tag(AValue: NativeInt): IRickUIBuilderButton;
    function OnClick(AHandler: TNotifyEvent): IRickUIBuilderButton;
    function OnHover(AEnter, ALeave: TNotifyEvent): IRickUIBuilderButton;

    function Build(AParent: TFmxObject): TRectangle;
  public
    /// <summary>
    ///    Cria uma nova instancia de IRickUIBuilderButton, ja com os
    ///    valores padrao equivalentes a TRickUIBuilderButtonConfig.Default.
    /// </summary>
    /// <returns>
    ///    Uma nova instancia de IRickUIBuilderButton pronta para
    ///    encadeamento.
    /// </returns>
    class function New: IRickUIBuilderButton; static;
  end;

implementation

uses
  FMX.Graphics;

{ TRickUIBuilderButtonBuilder }

constructor TRickUIBuilderButtonBuilder.Create;
var
  LDefault: TRickUIBuilderButtonConfig;
begin
  inherited Create;

  LDefault := TRickUIBuilderButtonConfig.Default;

  FCaption           := '';
  FLeft              := LDefault.Left;
  FTop               := LDefault.Top;
  FWidth             := LDefault.Width;
  FHeight            := LDefault.Height;
  FAnchors           := [];
  FCornerRadius      := 16;
  FMargin            := TRickUIBuilderSpacing.None;
  FPadding           := TRickUIBuilderSpacing.None;
  FFillColor         := LDefault.FillColor;
  FBorderColor       := LDefault.BorderColor;
  FBorderThickness   := 0;
  FTextColor         := LDefault.TextColor;
  FFontFamily        := '';
  FFontSize          := LDefault.FontSize;
  FBold              := False;
  FHoverFillColor    := TAlphaColors.Null;
  FHasHoverFillColor := False;
  FDisabledOpacity   := 0.45;
  FEnabled           := True;
  FCursor            := crHandPoint;
  FOpacity           := 1;
  FVisible           := True;
  FTag               := LDefault.Tag;
  FOnClick           := nil;
  FOnEnter           := nil;
  FOnLeave           := nil;
end;

class function TRickUIBuilderButtonBuilder.New: IRickUIBuilderButton;
begin
  Result := TRickUIBuilderButtonBuilder.Create;
end;

function TRickUIBuilderButtonBuilder.Caption(
  const AValue: string): IRickUIBuilderButton;
begin
  FCaption := AValue;
  Result   := Self;
end;

function TRickUIBuilderButtonBuilder.Position(ALeft,
  ATop: Single): IRickUIBuilderButton;
begin
  FLeft  := ALeft;
  FTop   := ATop;
  Result := Self;
end;

function TRickUIBuilderButtonBuilder.Size(AWidth,
  AHeight: Single): IRickUIBuilderButton;
begin
  FWidth  := AWidth;
  FHeight := AHeight;
  Result  := Self;
end;

function TRickUIBuilderButtonBuilder.Anchors(
  AValue: TAnchors): IRickUIBuilderButton;
begin
  FAnchors := AValue;
  Result   := Self;
end;

function TRickUIBuilderButtonBuilder.CornerRadius(
  AValue: Single): IRickUIBuilderButton;
begin
  FCornerRadius := AValue;
  Result        := Self;
end;

function TRickUIBuilderButtonBuilder.Margin(
  const AValue: TRickUIBuilderSpacing): IRickUIBuilderButton;
begin
  FMargin := AValue;
  Result  := Self;
end;

function TRickUIBuilderButtonBuilder.Padding(
  const AValue: TRickUIBuilderSpacing): IRickUIBuilderButton;
begin
  FPadding := AValue;
  Result   := Self;
end;

function TRickUIBuilderButtonBuilder.FillColor(
  AValue: TAlphaColor): IRickUIBuilderButton;
begin
  FFillColor := AValue;
  Result     := Self;
end;

function TRickUIBuilderButtonBuilder.BorderColor(
  AValue: TAlphaColor): IRickUIBuilderButton;
begin
  FBorderColor := AValue;
  Result       := Self;
end;

function TRickUIBuilderButtonBuilder.BorderThickness(
  AValue: Single): IRickUIBuilderButton;
begin
  FBorderThickness := AValue;
  Result           := Self;
end;

function TRickUIBuilderButtonBuilder.TextColor(
  AValue: TAlphaColor): IRickUIBuilderButton;
begin
  FTextColor := AValue;
  Result     := Self;
end;

function TRickUIBuilderButtonBuilder.FontFamily(
  const AValue: string): IRickUIBuilderButton;
begin
  FFontFamily := AValue;
  Result      := Self;
end;

function TRickUIBuilderButtonBuilder.FontSize(
  AValue: Single): IRickUIBuilderButton;
begin
  FFontSize := AValue;
  Result    := Self;
end;

function TRickUIBuilderButtonBuilder.Bold(
  AValue: Boolean): IRickUIBuilderButton;
begin
  FBold  := AValue;
  Result := Self;
end;

function TRickUIBuilderButtonBuilder.HoverFillColor(
  AValue: TAlphaColor): IRickUIBuilderButton;
begin
  FHoverFillColor    := AValue;
  FHasHoverFillColor := True;
  Result             := Self;
end;

function TRickUIBuilderButtonBuilder.DisabledOpacity(
  AValue: Single): IRickUIBuilderButton;
begin
  FDisabledOpacity := AValue;
  Result           := Self;
end;

function TRickUIBuilderButtonBuilder.Enabled(
  AValue: Boolean): IRickUIBuilderButton;
begin
  FEnabled := AValue;
  Result   := Self;
end;

function TRickUIBuilderButtonBuilder.Cursor(
  AValue: TCursor): IRickUIBuilderButton;
begin
  FCursor := AValue;
  Result  := Self;
end;

function TRickUIBuilderButtonBuilder.Opacity(
  AValue: Single): IRickUIBuilderButton;
begin
  FOpacity := AValue;
  Result   := Self;
end;

function TRickUIBuilderButtonBuilder.Visible(
  AValue: Boolean): IRickUIBuilderButton;
begin
  FVisible := AValue;
  Result   := Self;
end;

function TRickUIBuilderButtonBuilder.Tag(
  AValue: NativeInt): IRickUIBuilderButton;
begin
  FTag   := AValue;
  Result := Self;
end;

function TRickUIBuilderButtonBuilder.OnClick(
  AHandler: TNotifyEvent): IRickUIBuilderButton;
begin
  FOnClick := AHandler;
  Result   := Self;
end;

function TRickUIBuilderButtonBuilder.OnHover(AEnter,
  ALeave: TNotifyEvent): IRickUIBuilderButton;
begin
  FOnEnter := AEnter;
  FOnLeave := ALeave;
  Result   := Self;
end;

function TRickUIBuilderButtonBuilder.Build(AParent: TFmxObject): TRectangle;
var
  LConfig     : TRickUIBuilderButtonConfig;
  LHoverState : TRickUIBuilderButtonHoverState;
begin
  LConfig             := TRickUIBuilderButtonConfig.Default;
  // Margin e somado a posicao definida via Position, nao substitui -
  // ver <remarks> de IRickUIBuilderButton.Margin.
  LConfig.Left        := FLeft + FMargin.Left;
  LConfig.Top         := FTop + FMargin.Top;
  LConfig.Width       := FWidth;
  LConfig.Height      := FHeight;
  LConfig.FillColor   := FFillColor;
  LConfig.BorderColor := FBorderColor;
  LConfig.TextColor   := FTextColor;
  LConfig.Tag         := FTag;
  LConfig.FontSize    := FFontSize;

  // AParent e utilizado tambem como Owner: TFmxObject herda de
  // TComponent, entao o ciclo de vida dos controles fica atrelado ao
  // proprio Parent informado.
  Result := TRickUIBuilderFactory.CreateButton(AParent, AParent, FCaption,
    LConfig);

  Result.Anchors := FAnchors;
  Result.XRadius  := FCornerRadius;
  Result.YRadius  := FCornerRadius;

  if FBorderThickness > 0 then
    Result.Stroke.Thickness := FBorderThickness;

  if FFontFamily <> '' then
  begin
    if (Result.ChildrenCount > 0) and (Result.Children[0] is TLabel) then
      TLabel(Result.Children[0]).TextSettings.Font.Family := FFontFamily;
  end;

  if FBold then
  begin
    if (Result.ChildrenCount > 0) and (Result.Children[0] is TLabel) then
      TLabel(Result.Children[0]).TextSettings.Font.Style :=
        TLabel(Result.Children[0]).TextSettings.Font.Style + [TFontStyle.fsBold];
  end;

  if (Result.ChildrenCount > 0) and (Result.Children[0] is TLabel) then
  begin
    // Padding aplica-se ao espaco interno entre a borda do botao e o
    // label de Caption - ver <remarks> de IRickUIBuilderButton.Padding.
    TLabel(Result.Children[0]).Padding.Left   := FPadding.Left;
    TLabel(Result.Children[0]).Padding.Top    := FPadding.Top;
    TLabel(Result.Children[0]).Padding.Right  := FPadding.Right;
    TLabel(Result.Children[0]).Padding.Bottom := FPadding.Bottom;
  end;

  // O estado de hover e delegado a Rick.UIBuilder.Button.HoverState -
  // ver responsabilidade no cabecalho desta unit.
  LHoverState := TRickUIBuilderButtonHoverState.New(AParent, Result,
    FFillColor, FHoverFillColor, FHasHoverFillColor, FOnEnter, FOnLeave);

  Result.OnMouseEnter := LHoverState.HandleMouseEnter;
  Result.OnMouseLeave := LHoverState.HandleMouseLeave;

  if Assigned(FOnClick) then
    Result.OnClick := FOnClick;

  Result.Enabled := FEnabled;

  if FEnabled then
    Result.Opacity := FOpacity
  else
    Result.Opacity := FDisabledOpacity;

  Result.Cursor  := FCursor;
  Result.Visible := FVisible;
end;

end.
