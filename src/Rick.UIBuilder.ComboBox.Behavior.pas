unit Rick.UIBuilder.ComboBox.Behavior;
(*
  ============================================================================
  Unit: Rick.UIBuilder.ComboBox.Behavior
  ============================================================================

  RESPONSABILIDADE

  Mantem o runtime do ComboBox vivo durante o lifetime definido pelo Owner e
  observa exclusivamente o container visual materializado. Quando o container
  ou o proprio behavior e destruido, solicita ao Handle que desconecte suas
  referencias FMX sem conhecer a implementacao concreta do Handle.

  ============================================================================
*)

interface

uses
  System.Classes,
  Rick.UIBuilder.Types,
  Rick.UIBuilder.Interfaces;

type
  TRickUIBuilderComboBoxBehavior = class(TComponent)
  strict private
    FContainer: TComponent;
    FLifetime: IRickUIBuilderComboBoxHandle;
    FDetachVisual: TRickUIBuilderBooleanProcedure;
  protected
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
  public
    destructor Destroy; override;
    procedure Configure(AContainer: TComponent;
      const ALifetime: IRickUIBuilderComboBoxHandle;
      ADetachVisual: TRickUIBuilderBooleanProcedure);
  end;

implementation

procedure TRickUIBuilderComboBoxBehavior.Configure(AContainer: TComponent;
  const ALifetime: IRickUIBuilderComboBoxHandle;
  ADetachVisual: TRickUIBuilderBooleanProcedure);
begin
  FContainer := AContainer;
  FLifetime := ALifetime;
  FDetachVisual := ADetachVisual;
  if Assigned(FContainer) then
    FContainer.FreeNotification(Self);
end;

destructor TRickUIBuilderComboBoxBehavior.Destroy;
begin
  if Assigned(FContainer) then
    FContainer.RemoveFreeNotification(Self);
  if Assigned(FDetachVisual) then
    FDetachVisual(True);
  FContainer := nil;
  FDetachVisual := nil;
  FLifetime := nil;
  inherited;
end;

procedure TRickUIBuilderComboBoxBehavior.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation <> opRemove) or (AComponent <> FContainer) then
    Exit;

  if Assigned(FDetachVisual) then
    FDetachVisual(False);
  FContainer := nil;
end;

end.
