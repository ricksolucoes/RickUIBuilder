unit Rick.UIBuilder.Button.HoverBehavior;
(*
  ==============================================================================
  Unit: Rick.UIBuilder.Button.HoverBehavior
  ==============================================================================

  RESPONSABILIDADE

  Materializa e executa o comportamento runtime de hover de um Button. Mantem
  o estado de hover vivo durante o lifetime definido pelo Owner e consulta os
  valores atuais do estado a cada evento de MouseEnter/MouseLeave.

  ==============================================================================
*)

interface

uses
  System.Classes,
  FMX.Objects,
  Rick.UIBuilder.Types,
  Rick.UIBuilder.Interfaces;

type
  TRickUIBuilderButtonHoverBehavior = class(TComponent)
  strict private
    FButton: TRectangle;
    FState: IRickUIBuilderButtonHoverState;
    FHasHoverFillColor: TRickUIBuilderBooleanCallback;
  public
    procedure Configure(AButton: TRectangle;
      const AState: IRickUIBuilderButtonHoverState;
      AHasHoverFillColor: TRickUIBuilderBooleanCallback);
    procedure HandleMouseEnter(Sender: TObject);
    procedure HandleMouseLeave(Sender: TObject);
  end;

implementation

procedure TRickUIBuilderButtonHoverBehavior.Configure(AButton: TRectangle;
  const AState: IRickUIBuilderButtonHoverState;
  AHasHoverFillColor: TRickUIBuilderBooleanCallback);
begin
  FButton := AButton;
  FState := AState;
  FHasHoverFillColor := AHasHoverFillColor;
end;

procedure TRickUIBuilderButtonHoverBehavior.HandleMouseEnter(Sender: TObject);
var
  LHandler: TNotifyEvent;
begin
  if FHasHoverFillColor() then
    FButton.Fill.Color := FState.HoverFillColor;

  LHandler := FState.OnEnter();
  if Assigned(LHandler) then
    LHandler(Sender);
end;

procedure TRickUIBuilderButtonHoverBehavior.HandleMouseLeave(Sender: TObject);
var
  LHandler: TNotifyEvent;
begin
  if FHasHoverFillColor() then
    FButton.Fill.Color := FState.FillColor;

  LHandler := FState.OnLeave();
  if Assigned(LHandler) then
    LHandler(Sender);
end;

end.
