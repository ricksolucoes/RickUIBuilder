unit Rick.UIBuilder.Button.HoverState;
(*
  ==============================================================================
  Unit: Rick.UIBuilder.Button.HoverState
  ==============================================================================

  RESPONSABILIDADE

  Implementa IRickUIBuilderButtonHoverState como configuracao fluente e fonte
  viva dos valores usados pelo comportamento de hover depois de Build.

  Build delega a materializacao do comportamento persistente para
  Rick.UIBuilder.Button.HoverBehavior, mantendo nesta unit somente o estado e
  sua configuracao.

  ==============================================================================
*)

interface

uses
  System.Classes,
  System.UITypes,
  FMX.Objects,
  Rick.UIBuilder.Interfaces;

type
  /// <summary>
  ///    Implementacao fluente de IRickUIBuilderButtonHoverState.
  /// </summary>
  TRickUIBuilderButtonHoverState = class(TInterfacedObject,
    IRickUIBuilderButtonHoverState)
  strict private
    FButton            : TRectangle;
    FFillColor         : TAlphaColor;
    FHoverFillColor    : TAlphaColor;
    FHasHoverFillColor : Boolean;
    FOnEnter           : TNotifyEvent;
    FOnLeave           : TNotifyEvent;
  protected
    constructor Create;

    function Button(AValue: TRectangle): IRickUIBuilderButtonHoverState; overload;
    function Button: TRectangle; overload;
    function FillColor(AValue: TAlphaColor): IRickUIBuilderButtonHoverState; overload;
    function FillColor: TAlphaColor; overload;
    function HoverFillColor(AValue: TAlphaColor): IRickUIBuilderButtonHoverState; overload;
    function HoverFillColor: TAlphaColor; overload;
    function HasHoverFillColor: Boolean;
    function OnEnter(AValue: TNotifyEvent): IRickUIBuilderButtonHoverState; overload;
    function OnEnter: TNotifyEvent; overload;
    function OnLeave(AValue: TNotifyEvent): IRickUIBuilderButtonHoverState; overload;
    function OnLeave: TNotifyEvent; overload;
    function Build(AOwner: TComponent): IRickUIBuilderButtonHoverState;
  public
    /// <summary>
    ///    Cria uma configuracao de hover sem parametros, pronta para
    ///    encadeamento fluente.
    /// </summary>
    class function New: IRickUIBuilderButtonHoverState; static;
  end;

implementation

uses
  Rick.UIBuilder.Button.HoverBehavior;

{ TRickUIBuilderButtonHoverState }

constructor TRickUIBuilderButtonHoverState.Create;
begin
  inherited Create;
  FHasHoverFillColor := False;
end;

class function TRickUIBuilderButtonHoverState.New: IRickUIBuilderButtonHoverState;
begin
  Result := TRickUIBuilderButtonHoverState.Create;
end;

function TRickUIBuilderButtonHoverState.Button(
  AValue: TRectangle): IRickUIBuilderButtonHoverState;
begin
  FButton := AValue;
  Result := Self;
end;

function TRickUIBuilderButtonHoverState.Button: TRectangle;
begin
  Result := FButton;
end;

function TRickUIBuilderButtonHoverState.FillColor(
  AValue: TAlphaColor): IRickUIBuilderButtonHoverState;
begin
  FFillColor := AValue;
  Result := Self;
end;

function TRickUIBuilderButtonHoverState.FillColor: TAlphaColor;
begin
  Result := FFillColor;
end;

function TRickUIBuilderButtonHoverState.HoverFillColor(
  AValue: TAlphaColor): IRickUIBuilderButtonHoverState;
begin
  FHoverFillColor := AValue;
  FHasHoverFillColor := True;
  Result := Self;
end;

function TRickUIBuilderButtonHoverState.HoverFillColor: TAlphaColor;
begin
  Result := FHoverFillColor;
end;

function TRickUIBuilderButtonHoverState.HasHoverFillColor: Boolean;
begin
  Result := FHasHoverFillColor;
end;

function TRickUIBuilderButtonHoverState.OnEnter(
  AValue: TNotifyEvent): IRickUIBuilderButtonHoverState;
begin
  FOnEnter := AValue;
  Result := Self;
end;

function TRickUIBuilderButtonHoverState.OnEnter: TNotifyEvent;
begin
  Result := FOnEnter;
end;

function TRickUIBuilderButtonHoverState.OnLeave(
  AValue: TNotifyEvent): IRickUIBuilderButtonHoverState;
begin
  FOnLeave := AValue;
  Result := Self;
end;

function TRickUIBuilderButtonHoverState.OnLeave: TNotifyEvent;
begin
  Result := FOnLeave;
end;

function TRickUIBuilderButtonHoverState.Build(
  AOwner: TComponent): IRickUIBuilderButtonHoverState;
var
  LBehavior: TRickUIBuilderButtonHoverBehavior;
begin
  LBehavior := TRickUIBuilderButtonHoverBehavior.Create(AOwner);
  LBehavior.Configure(FButton, Self, HasHoverFillColor);
  FButton.OnMouseEnter := LBehavior.HandleMouseEnter;
  FButton.OnMouseLeave := LBehavior.HandleMouseLeave;
  Result := Self;
end;

end.
