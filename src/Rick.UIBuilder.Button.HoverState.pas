unit Rick.UIBuilder.Button.HoverState;
(*
  ==============================================================================
  Unit: Rick.UIBuilder.Button.HoverState
  ==============================================================================

  RESPONSABILIDADE

  Implementa IRickUIBuilderButtonHoverState como configuracao fluente e
  materializa, em Build, o comportamento persistente de hover de um Button.

  A configuracao usa TInterfacedObject e pode ser liberada depois de Build.
  O manipulador efetivo dos eventos permanece em um TComponent interno cujo
  Owner e informado em Build, preservando o lifetime necessario para
  OnMouseEnter/OnMouseLeave sem expor TComponent como contrato publico.

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

type
  TRickUIBuilderButtonHoverBehavior = class(TComponent)
  strict private
    FButton            : TRectangle;
    FFillColor         : TAlphaColor;
    FHoverFillColor    : TAlphaColor;
    FHasHoverFillColor : Boolean;
    FOnEnter           : TNotifyEvent;
    FOnLeave           : TNotifyEvent;
  public
    procedure Configure(AButton: TRectangle; AFillColor, AHoverFillColor: TAlphaColor;
      AHasHoverFillColor: Boolean; AOnEnter, AOnLeave: TNotifyEvent);
    procedure HandleMouseEnter(Sender: TObject);
    procedure HandleMouseLeave(Sender: TObject);
  end;

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
  LBehavior.Configure(FButton, FFillColor, FHoverFillColor,
    FHasHoverFillColor, FOnEnter, FOnLeave);
  FButton.OnMouseEnter := LBehavior.HandleMouseEnter;
  FButton.OnMouseLeave := LBehavior.HandleMouseLeave;
  Result := Self;
end;

{ TRickUIBuilderButtonHoverBehavior }

procedure TRickUIBuilderButtonHoverBehavior.Configure(AButton: TRectangle;
  AFillColor, AHoverFillColor: TAlphaColor; AHasHoverFillColor: Boolean;
  AOnEnter, AOnLeave: TNotifyEvent);
begin
  FButton := AButton;
  FFillColor := AFillColor;
  FHoverFillColor := AHoverFillColor;
  FHasHoverFillColor := AHasHoverFillColor;
  FOnEnter := AOnEnter;
  FOnLeave := AOnLeave;
end;

procedure TRickUIBuilderButtonHoverBehavior.HandleMouseEnter(Sender: TObject);
begin
  if FHasHoverFillColor then
    FButton.Fill.Color := FHoverFillColor;

  if Assigned(FOnEnter) then
    FOnEnter(Sender);
end;

procedure TRickUIBuilderButtonHoverBehavior.HandleMouseLeave(Sender: TObject);
begin
  if FHasHoverFillColor then
    FButton.Fill.Color := FFillColor;

  if Assigned(FOnLeave) then
    FOnLeave(Sender);
end;

end.
