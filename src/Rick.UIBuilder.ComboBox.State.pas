unit Rick.UIBuilder.ComboBox.State;
{$SCOPEDENUMS ON}
(*
  ============================================================================
  Unit: Rick.UIBuilder.ComboBox.State
  ============================================================================

  RESPONSABILIDADE

  Mantem o estado minimo de abertura e o TargetIndex usado durante navegacao.
  SelectedIndex permanece no Data Model e so muda quando a selecao e
  confirmada.
  ============================================================================
*)

interface

type
  TRickUIBuilderComboBoxPhase = (
    Closed,
    Opening,
    Opened,
    Closing
  );

  TRickUIBuilderComboBoxState = class
  strict private
    FPhase: TRickUIBuilderComboBoxPhase;
    FTargetIndex: Integer;
  public
    constructor Create;
    procedure BeginOpen(ASelectedIndex: Integer);
    procedure FinishOpen;
    procedure BeginClose;
    procedure FinishClose;
    procedure SetTargetIndex(AValue: Integer);
    function IsOpen: Boolean;
    function TargetIndex: Integer;
  end;

implementation

constructor TRickUIBuilderComboBoxState.Create;
begin
  inherited Create;
  FPhase := TRickUIBuilderComboBoxPhase.Closed;
  FTargetIndex := -1;
end;

procedure TRickUIBuilderComboBoxState.BeginOpen(ASelectedIndex: Integer);
begin
  FTargetIndex := ASelectedIndex;
  FPhase := TRickUIBuilderComboBoxPhase.Opening;
end;

procedure TRickUIBuilderComboBoxState.FinishOpen;
begin
  FPhase := TRickUIBuilderComboBoxPhase.Opened;
end;

procedure TRickUIBuilderComboBoxState.BeginClose;
begin
  FPhase := TRickUIBuilderComboBoxPhase.Closing;
end;

procedure TRickUIBuilderComboBoxState.FinishClose;
begin
  FPhase := TRickUIBuilderComboBoxPhase.Closed;
end;

procedure TRickUIBuilderComboBoxState.SetTargetIndex(AValue: Integer);
begin
  FTargetIndex := AValue;
end;

function TRickUIBuilderComboBoxState.IsOpen: Boolean;
begin
  Result := FPhase in [TRickUIBuilderComboBoxPhase.Opening,
    TRickUIBuilderComboBoxPhase.Opened];
end;

function TRickUIBuilderComboBoxState.TargetIndex: Integer;
begin
  Result := FTargetIndex;
end;

end.
