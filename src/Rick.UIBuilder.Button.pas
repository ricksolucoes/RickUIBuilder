unit Rick.UIBuilder.Button;
(*
  ==============================================================================
  Unit: Rick.UIBuilder.Button
  ==============================================================================

  RESPONSABILIDADE

  Implementa exclusivamente o builder fluente IRickUIBuilderButton
  (Opcao B do framework Rick.UIBuilder): TRickUIBuilderButtonBuilder
  acumula estado em memoria a cada chamada encadeada e so cria o botao
  (TRectangle com TLabel interno) de fato ao chamar Build ou BuildHandle.

  A criacao real dos controles e delegada a TRickUIBuilderFactory.CreateButton
  (Opcao A) - esta unit NAO reimplementa a logica de instanciacao, apenas
  acumula estado adicional que a Factory nao cobre (Anchors, CornerRadius,
  Margin, Padding, BorderThickness, FontFamily, Bold, HoverFillColor,
  DisabledOpacity, Enabled, Cursor, Opacity, Visible, OnClick, OnHover)
  e aplica esse estado extra apos o Build da Factory.

  Esta unit NAO implementa IRickUIBuilderButtonHandle nem o gerenciamento
  de estado de hover. O handle vive em Rick.UIBuilder.Button.Handle e o
  estado de hover vive em Rick.UIBuilder.Button.HoverState.

  O gerenciamento de hover permanece isolado em Rick.UIBuilder.Button.HoverState,
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
  Rick.UIBuilder.Button.Handle,
  Rick.UIBuilder.Button.HoverState;

type
  /// <summary>
  ///    Implementacao de IRickUIBuilderButton. Acumula estado em
  ///    campos privados a cada metodo encadeado; a criacao do botao
  ///    so ocorre ao chamar Build ou BuildHandle.
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

    function BuildConfig: TRickUIBuilderButtonConfig;
    function BuildCore(AParent: TFmxObject; out ATextLabel: TLabel;
      out AHoverState: IRickUIBuilderButtonHoverState): TRectangle;
    procedure ApplyContainerState(AButton: TRectangle);
    procedure ApplyTextState(ATextLabel: TLabel);
    function AttachBehavior(AParent: TFmxObject; AButton: TRectangle):
      IRickUIBuilderButtonHoverState;

    procedure InitLayoutDefaults(const ADefault: TRickUIBuilderButtonConfig);
    procedure InitAppearanceDefaults(const ADefault: TRickUIBuilderButtonConfig);
    procedure InitInteractionDefaults(const ADefault: TRickUIBuilderButtonConfig);
    procedure InitEventDefaults;
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
    function BuildHandle(AParent: TFmxObject): IRickUIBuilderButtonHandle;
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

  InitLayoutDefaults(LDefault);
  InitAppearanceDefaults(LDefault);
  InitInteractionDefaults(LDefault);
  InitEventDefaults;
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

function TRickUIBuilderButtonBuilder.BuildConfig: TRickUIBuilderButtonConfig;
begin
  Result             := TRickUIBuilderButtonConfig.Default;
  Result.Left        := FLeft + FMargin.Left;
  Result.Top         := FTop + FMargin.Top;
  Result.Width       := FWidth;
  Result.Height      := FHeight;
  Result.FillColor   := FFillColor;
  Result.BorderColor := FBorderColor;
  Result.TextColor   := FTextColor;
  Result.Tag         := FTag;
  Result.FontSize    := FFontSize;
end;

procedure TRickUIBuilderButtonBuilder.ApplyContainerState(AButton: TRectangle);
begin
  AButton.Anchors := FAnchors;
  AButton.XRadius := FCornerRadius;
  AButton.YRadius := FCornerRadius;

  if FBorderThickness > 0 then
    AButton.Stroke.Thickness := FBorderThickness;

  AButton.Enabled := FEnabled;
  if FEnabled then
    AButton.Opacity := FOpacity
  else
    AButton.Opacity := FDisabledOpacity;

  AButton.Cursor := FCursor;
  AButton.Visible := FVisible;
end;

procedure TRickUIBuilderButtonBuilder.ApplyTextState(ATextLabel: TLabel);
begin
  if FFontFamily <> '' then
    ATextLabel.TextSettings.Font.Family := FFontFamily;

  if FBold then
    ATextLabel.TextSettings.Font.Style := ATextLabel.TextSettings.Font.Style
      + [TFontStyle.fsBold];

  ATextLabel.Padding.Left := FPadding.Left;
  ATextLabel.Padding.Top := FPadding.Top;
  ATextLabel.Padding.Right := FPadding.Right;
  ATextLabel.Padding.Bottom := FPadding.Bottom;
end;

function TRickUIBuilderButtonBuilder.AttachBehavior(AParent: TFmxObject;
  AButton: TRectangle): IRickUIBuilderButtonHoverState;
begin
  Result := TRickUIBuilderButtonHoverState.New
    .Button(AButton).FillColor(FFillColor).OnEnter(FOnEnter).OnLeave(FOnLeave);

  if FHasHoverFillColor then
    Result.HoverFillColor(FHoverFillColor);

  Result.Build(AParent);
  if Assigned(FOnClick) then
    AButton.OnClick := FOnClick;
end;

function TRickUIBuilderButtonBuilder.BuildCore(AParent: TFmxObject;
  out ATextLabel: TLabel;
  out AHoverState: IRickUIBuilderButtonHoverState): TRectangle;
var
  LConfig: TRickUIBuilderButtonConfig;
begin
  LConfig := BuildConfig;
  Result := TRickUIBuilderFactory.CreateButton(AParent, AParent, FCaption,
    LConfig, ATextLabel);
  ApplyContainerState(Result);
  ApplyTextState(ATextLabel);
  AHoverState := AttachBehavior(AParent, Result);
end;

function TRickUIBuilderButtonBuilder.Build(AParent: TFmxObject): TRectangle;
var
  LHoverState: IRickUIBuilderButtonHoverState;
  LTextLabel: TLabel;
begin
  Result := BuildCore(AParent, LTextLabel, LHoverState);
end;

function TRickUIBuilderButtonBuilder.BuildHandle(
  AParent: TFmxObject): IRickUIBuilderButtonHandle;
var
  LContainer: TRectangle;
  LHoverState: IRickUIBuilderButtonHoverState;
  LTextLabel: TLabel;
begin
  LContainer := BuildCore(AParent, LTextLabel, LHoverState);
  Result := TRickUIBuilderButtonHandle.New(LContainer, LTextLabel, LHoverState);
end;

procedure TRickUIBuilderButtonBuilder.InitLayoutDefaults(
  const ADefault: TRickUIBuilderButtonConfig);
begin
  FCaption      := '';
  FLeft         := ADefault.Left;
  FTop          := ADefault.Top;
  FWidth        := ADefault.Width;
  FHeight       := ADefault.Height;
  FAnchors      := [];
  FCornerRadius := 16;
  FMargin       := TRickUIBuilderSpacing.None;
  FPadding      := TRickUIBuilderSpacing.None;
end;

procedure TRickUIBuilderButtonBuilder.InitAppearanceDefaults(
  const ADefault: TRickUIBuilderButtonConfig);
begin
  FFillColor         := ADefault.FillColor;
  FBorderColor       := ADefault.BorderColor;
  FBorderThickness   := 0;
  FTextColor         := ADefault.TextColor;
  FFontFamily        := '';
  FFontSize          := ADefault.FontSize;
  FBold              := False;
  FHoverFillColor    := TAlphaColors.Null;
  FHasHoverFillColor := False;
  FDisabledOpacity   := 0.45;
end;

procedure TRickUIBuilderButtonBuilder.InitInteractionDefaults(
  const ADefault: TRickUIBuilderButtonConfig);
begin
  FEnabled := True;
  FCursor  := crHandPoint;
  FOpacity := 1;
  FVisible := True;
  FTag     := ADefault.Tag;
end;

procedure TRickUIBuilderButtonBuilder.InitEventDefaults;
begin
  FOnClick := nil;
  FOnEnter := nil;
  FOnLeave := nil;
end;

end.
