unit Rick.UIBuilder.Button.HoverState;
(*
  ==============================================================================
  Unit: Rick.UIBuilder.Button.HoverState
  ==============================================================================

  RESPONSABILIDADE

  Implementa IRickUIBuilderButtonHoverState como configuracao fluente e
  materializa, em Build, o comportamento persistente de hover de um Button.

  A configuracao usa TInterfacedObject e permanece como a fonte viva dos
  valores usados depois de Build. O manipulador efetivo dos eventos permanece
  em um TComponent interno cujo Owner e informado em Build e mantem uma
  referencia ao estado, preservando o lifetime necessario para
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

type
  TRickUIBuilderButtonHoverBehavior = class(TComponent)
  strict private
    FButton: TRectangle;
    FState: TRickUIBuilderButtonHoverState;
    FStateLifetime: IRickUIBuilderButtonHoverState;
  public
    procedure Configure(AButton: TRectangle;
      AState: TRickUIBuilderButtonHoverState);
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
  LBehavior.Configure(FButton, Self);
  FButton.OnMouseEnter := LBehavior.HandleMouseEnter;
  FButton.OnMouseLeave := LBehavior.HandleMouseLeave;
  Result := Self;
end;

{ TRickUIBuilderButtonHoverBehavior }

procedure TRickUIBuilderButtonHoverBehavior.Configure(AButton: TRectangle;
  AState: TRickUIBuilderButtonHoverState);
begin
  FButton := AButton;
  FState := AState;
  FStateLifetime := AState;
end;

procedure TRickUIBuilderButtonHoverBehavior.HandleMouseEnter(Sender: TObject);
var
  LHandler: TNotifyEvent;
begin
  if FState.HasHoverFillColor then
    FButton.Fill.Color := FState.HoverFillColor;

  LHandler := FState.OnEnter();
  if Assigned(LHandler) then
    LHandler(Sender);
end;

procedure TRickUIBuilderButtonHoverBehavior.HandleMouseLeave(Sender: TObject);
var
  LHandler: TNotifyEvent;
begin
  if FState.HasHoverFillColor then
    FButton.Fill.Color := FState.FillColor;

  LHandler := FState.OnLeave();
  if Assigned(LHandler) then
    LHandler(Sender);
end;

end.
