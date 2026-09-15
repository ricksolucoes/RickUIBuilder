unit Rick.UIBuilder.Divider;
(*
  ==============================================================================
  Unit: Rick.UIBuilder.Divider
  ==============================================================================

  RESPONSABILIDADE

  Implementa o builder fluente IRickUIBuilderDivider (Opcao B do
  framework Rick.UIBuilder): TRickUIBuilderDividerBuilder acumula estado
  em memoria a cada chamada encadeada e so cria o TRectangle de fato ao
  chamar Build.

  A criacao real do controle e delegada a TRickUIBuilderFactory.CreateDivider
  (Opcao A). Como a Factory cria sempre um divisor horizontal com altura
  fixa de 1px, este builder ajusta Width/Height apos o Build da Factory
  para suportar Thickness e Orientation (Horizontal/Vertical).

  ==============================================================================
*)

interface

uses
  System.Classes,
  System.UITypes,

  FMX.Types,
  FMX.Objects,
  FMX.Controls,

  Rick.UIBuilder.Types,
  Rick.UIBuilder.Interfaces,
  Rick.UIBuilder.Factory;

type
  /// <summary>
  ///    Implementacao de IRickUIBuilderDivider. Acumula estado em
  ///    campos privados a cada metodo encadeado; a criacao do
  ///    TRectangle so ocorre ao chamar Build.
  /// </summary>
  TRickUIBuilderDividerBuilder = class(TInterfacedObject, IRickUIBuilderDivider)
  private
    FLeft        : Single;
    FTop         : Single;
    FWidth       : Single;
    FThickness   : Single;
    FOrientation : TOrientation;
    FMargin      : TRickUIBuilderSpacing;
    FColor       : TAlphaColor;
    FOpacity     : Single;
    FVisible     : Boolean;
  protected
    function Position(ALeft, ATop: Single): IRickUIBuilderDivider;
    function Width(AValue: Single): IRickUIBuilderDivider;
    function Thickness(AValue: Single): IRickUIBuilderDivider;
    function Orientation(AValue: TOrientation): IRickUIBuilderDivider;
    function Margin(const AValue: TRickUIBuilderSpacing): IRickUIBuilderDivider;
    function Color(AValue: TAlphaColor): IRickUIBuilderDivider;
    function Opacity(AValue: Single): IRickUIBuilderDivider;
    function Visible(AValue: Boolean = True): IRickUIBuilderDivider;

    function Build(AParent: TFmxObject): TRectangle;

    constructor Create;
  public

    /// <summary>
    ///    Cria uma nova instancia de IRickUIBuilderDivider, ja com os
    ///    valores padrao equivalentes a TRickUIBuilderDividerConfig.Default.
    /// </summary>
    /// <returns>
    ///    Uma nova instancia de IRickUIBuilderDivider pronta para
    ///    encadeamento.
    /// </returns>
    class function New: IRickUIBuilderDivider; static;

  end;

implementation

{ TRickUIBuilderDividerBuilder }

constructor TRickUIBuilderDividerBuilder.Create;
var
  LDefault: TRickUIBuilderDividerConfig;
begin
  inherited Create;

  LDefault := TRickUIBuilderDividerConfig.Default;

  FLeft        := LDefault.Left;
  FTop         := LDefault.Top;
  FWidth       := LDefault.Width;
  FThickness   := 1;
  FOrientation := TOrientation.Horizontal;
  FMargin      := TRickUIBuilderSpacing.None;
  FColor       := LDefault.Color;
  FOpacity     := 1;
  FVisible     := True;
end;

class function TRickUIBuilderDividerBuilder.New: IRickUIBuilderDivider;
begin
  Result := TRickUIBuilderDividerBuilder.Create;
end;

function TRickUIBuilderDividerBuilder.Position(ALeft,
  ATop: Single): IRickUIBuilderDivider;
begin
  FLeft  := ALeft;
  FTop   := ATop;
  Result := Self;
end;

function TRickUIBuilderDividerBuilder.Width(
  AValue: Single): IRickUIBuilderDivider;
begin
  FWidth := AValue;
  Result := Self;
end;

function TRickUIBuilderDividerBuilder.Thickness(
  AValue: Single): IRickUIBuilderDivider;
begin
  FThickness := AValue;
  Result     := Self;
end;

function TRickUIBuilderDividerBuilder.Orientation(
  AValue: TOrientation): IRickUIBuilderDivider;
begin
  FOrientation := AValue;
  Result       := Self;
end;

function TRickUIBuilderDividerBuilder.Margin(
  const AValue: TRickUIBuilderSpacing): IRickUIBuilderDivider;
begin
  FMargin := AValue;
  Result  := Self;
end;

function TRickUIBuilderDividerBuilder.Color(
  AValue: TAlphaColor): IRickUIBuilderDivider;
begin
  FColor := AValue;
  Result := Self;
end;

function TRickUIBuilderDividerBuilder.Opacity(
  AValue: Single): IRickUIBuilderDivider;
begin
  FOpacity := AValue;
  Result   := Self;
end;

function TRickUIBuilderDividerBuilder.Visible(
  AValue: Boolean): IRickUIBuilderDivider;
begin
  FVisible := AValue;
  Result   := Self;
end;

function TRickUIBuilderDividerBuilder.Build(AParent: TFmxObject): TRectangle;
var
  LConfig: TRickUIBuilderDividerConfig;
begin
  LConfig       := TRickUIBuilderDividerConfig.Default;
  // Margin e somado a posicao definida via Position, nao substitui -
  // ver <remarks> de IRickUIBuilderDivider.Margin.
  LConfig.Left  := FLeft + FMargin.Left;
  LConfig.Top   := FTop + FMargin.Top;
  LConfig.Width := FWidth;
  LConfig.Color := FColor;

  // AParent e utilizado tambem como Owner: TFmxObject herda de
  // TComponent, entao o ciclo de vida do TRectangle fica atrelado ao
  // proprio Parent informado.
  Result := TRickUIBuilderFactory.CreateDivider(AParent, AParent, LConfig);

  // A Factory sempre cria um divisor horizontal com altura fixa de
  // 1px; aqui aplicamos Thickness e Orientation, invertendo Width e
  // Height quando o divisor e Vertical - ver <remarks> de
  // IRickUIBuilderDivider.Orientation.
  case FOrientation of
    TOrientation.Horizontal:
    begin
      Result.Width  := FWidth;
      Result.Height := FThickness;
    end;

    TOrientation.Vertical:
    begin
      Result.Width  := FThickness;
      Result.Height := FWidth;
    end;
  end;

  Result.Opacity := FOpacity;
  Result.Visible := FVisible;
end;

end.
