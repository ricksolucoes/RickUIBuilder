unit Rick.UIBuilder.Edit.Behavior;
{$SCOPEDENUMS ON}

interface

uses
  System.Classes,
  System.SysUtils,
  System.UITypes,

  FMX.Edit,
  FMX.Types,
  FMX.Objects,
  FMX.Layouts,
  FMX.StdCtrls,
  FMX.Controls,

  Rick.UIBuilder.Types;

type
  TRickUIBuilderEditBehavior = class(TComponent)
  strict private
    FConfig: TRickUIBuilderEditConfig;
    FContainer: TRectangle;
    FEdit: TEdit;
    FLabel: TLabel;
    FCounter: TLabel;
    FErrorLabel: TLabel;
    FAlertPath: TPath;
    FClearArea: TLayout;
    FClearPath: TPath;
    FPasswordArea: TLayout;
    FPasswordPath: TPath;
    FRequirementPath: TPath;
    FLastValidText: string;
    FUpdating: Boolean;
    FInvalid: Boolean;
    FInvalidFromInput: Boolean;
    FRequirementMet: Boolean;
    procedure ApplyNormalState;
    procedure ApplyFocusState;
    procedure ApplyInvalidState;
    procedure UpdateCounter;
    procedure UpdateClearVisibility;
    procedure UpdatePasswordIcon;
    procedure UpdateRequirementIcon;
    procedure AcceptCurrentText;
    procedure SignalInvalidInput;
    function ShouldShowErrorLabel(const AMessage: string): Boolean;
    function ShouldShowAlertIcon: Boolean;
    procedure HandleEnter(Sender: TObject);
    procedure HandleExit(Sender: TObject);
    function ResolveChangedText(const AText: string; out AResolved: string): Boolean;
    function IsOverflowAttempt(const AText: string): Boolean;
    procedure HandleChange(Sender: TObject);
    procedure QueueCaretToEnd;
    procedure HandleClear(Sender: TObject);
    procedure HandlePassword(Sender: TObject);
  public
    procedure Configure(const AConfig: TRickUIBuilderEditConfig;
      AContainer: TRectangle; AEdit: TEdit; ALabel, ACounter,
      AErrorLabel: TLabel);
    procedure ConfigureIcons(AAlertPath: TPath; AClearArea: TLayout;
      AClearPath: TPath; APasswordArea: TLayout; APasswordPath,
      ARequirementPath: TPath);
    procedure SetText(const AValue: string);
    procedure Clear;
    procedure SetInvalid(AValue: Boolean; const AMessage: string = '');
    procedure SetRequirementMet(AValue: Boolean);
  end;

implementation

uses
  Rick.UIBuilder.Edit.Input;

procedure TRickUIBuilderEditBehavior.Configure(
  const AConfig: TRickUIBuilderEditConfig; AContainer: TRectangle;
  AEdit: TEdit; ALabel, ACounter, AErrorLabel: TLabel);
begin
  FConfig := AConfig;
  FContainer := AContainer;
  FEdit := AEdit;
  FLabel := ALabel;
  FCounter := ACounter;
  FErrorLabel := AErrorLabel;
  FEdit.OnEnter := HandleEnter;
  FEdit.OnExit := HandleExit;
  FEdit.OnChangeTracking := HandleChange;
  FLastValidText := FEdit.Text;
  UpdateCounter;
end;

procedure TRickUIBuilderEditBehavior.ConfigureIcons(AAlertPath: TPath;
  AClearArea: TLayout; AClearPath: TPath; APasswordArea: TLayout;
  APasswordPath, ARequirementPath: TPath);
begin
  FAlertPath := AAlertPath;
  FClearArea := AClearArea;
  FClearPath := AClearPath;
  FPasswordArea := APasswordArea;
  FPasswordPath := APasswordPath;
  FRequirementPath := ARequirementPath;
  if Assigned(FClearArea) then
    FClearArea.OnClick := HandleClear;
  if Assigned(FClearPath) then
  begin
    FClearPath.HitTest := True;
    FClearPath.Cursor := crHandPoint;
    FClearPath.OnClick := HandleClear;
  end;
  if Assigned(FPasswordArea) then
    FPasswordArea.OnClick := HandlePassword;
  if Assigned(FPasswordPath) then
  begin
    FPasswordPath.HitTest := True;
    FPasswordPath.Cursor := crHandPoint;
    FPasswordPath.OnClick := HandlePassword;
  end;
  UpdateClearVisibility;
  UpdatePasswordIcon;
  UpdateRequirementIcon;
end;

function TRickUIBuilderEditBehavior.ResolveChangedText(
  const AText: string; out AResolved: string): Boolean;
begin
  Result := TRickUIBuilderEditInput.IsTypedValueAllowed(AText, FConfig);
  if not Result then
    Exit;
  AResolved := TRickUIBuilderEditInput.FormatTypedValue(AText, FConfig);
  Result := TRickUIBuilderEditInput.IsValueAllowed(AResolved, FConfig);
end;

function TRickUIBuilderEditBehavior.IsOverflowAttempt(
  const AText: string): Boolean;
begin
  Result := (Length(AText) > Length(FLastValidText)) and
    TRickUIBuilderEditInput.IsCompleteValue(FLastValidText, FConfig);
end;

procedure TRickUIBuilderEditBehavior.HandleChange(Sender: TObject);
var
  LResolved: string;
  LTypingAtEnd: Boolean;
begin
  if FUpdating then
    Exit;
  LTypingAtEnd := (FEdit.SelLength = 0) and
    (Length(FEdit.Text) > Length(FLastValidText)) and
    (Copy(FEdit.Text, 1, Length(FLastValidText)) = FLastValidText);
  if not ResolveChangedText(FEdit.Text, LResolved) then
  begin
    if IsOverflowAttempt(FEdit.Text) then
    begin
      SetText(FLastValidText);
      Exit;
    end;
    SetText(FLastValidText);
    SignalInvalidInput;
    Exit;
  end;
  if LResolved <> FEdit.Text then
  begin
    SetText(LResolved);
    if LTypingAtEnd then
      QueueCaretToEnd;
  end
  else
    AcceptCurrentText;
  if FInvalidFromInput then
    SetInvalid(False);
end;

procedure TRickUIBuilderEditBehavior.QueueCaretToEnd;
begin
  FEdit.BeginInvoke(
    procedure
    begin
      if not (csDestroying in FEdit.ComponentState) then
      begin
        FEdit.GoToTextEnd;
        FEdit.SelLength := 0;
      end;
    end, FEdit);
end;

procedure TRickUIBuilderEditBehavior.SetText(const AValue: string);
var
  LValue: string;
begin
  LValue := TRickUIBuilderEditInput.FormatTypedValue(AValue, FConfig);
  if not TRickUIBuilderEditInput.IsValueAllowed(LValue, FConfig) then
    Exit;
  FUpdating := True;
  try
    FEdit.Text := LValue;
    FLastValidText := LValue;
    UpdateCounter;
    UpdateClearVisibility;
  finally
    FUpdating := False;
  end;
end;

procedure TRickUIBuilderEditBehavior.Clear;
begin
  SetText('');
  FEdit.SetFocus;
end;

procedure TRickUIBuilderEditBehavior.HandleClear(Sender: TObject);
begin
  Clear;
end;

procedure TRickUIBuilderEditBehavior.HandlePassword(Sender: TObject);
begin
  FEdit.Password := not FEdit.Password;
  UpdatePasswordIcon;
  FEdit.SetFocus;
end;

procedure TRickUIBuilderEditBehavior.HandleEnter(Sender: TObject);
begin
  if FInvalid then
    ApplyInvalidState
  else
    ApplyFocusState;
end;

procedure TRickUIBuilderEditBehavior.HandleExit(Sender: TObject);
begin
  if (FEdit.Text <> '') and
    not TRickUIBuilderEditInput.IsCompleteValue(FEdit.Text, FConfig) then
    SignalInvalidInput;
  if FInvalid then
    ApplyInvalidState
  else
    ApplyNormalState;
end;

procedure TRickUIBuilderEditBehavior.ApplyNormalState;
begin
  FContainer.Fill.Color := FConfig.BackgroundColor;
  FContainer.Stroke.Color := FConfig.BorderColor;
  FLabel.TextSettings.FontColor := FConfig.LabelColor;
end;

procedure TRickUIBuilderEditBehavior.ApplyFocusState;
begin
  FContainer.Fill.Color := FConfig.BackgroundColor;
  FContainer.Stroke.Color := FConfig.FocusBorderColor;
  FLabel.TextSettings.FontColor := FConfig.LabelColor;
end;

procedure TRickUIBuilderEditBehavior.ApplyInvalidState;
begin
  FContainer.Fill.Color := FConfig.InvalidBackgroundColor;
  FContainer.Stroke.Color := FConfig.InvalidBorderColor;
  FLabel.TextSettings.FontColor := FConfig.InvalidLabelColor;
end;

function TRickUIBuilderEditBehavior.ShouldShowErrorLabel(
  const AMessage: string): Boolean;
begin
  Result := (AMessage <> '') and
    (FConfig.InvalidFeedback <> TRickUIBuilderEditInvalidFeedback.IconOnly);
end;

function TRickUIBuilderEditBehavior.ShouldShowAlertIcon: Boolean;
begin
  Result := FConfig.InvalidFeedback <>
    TRickUIBuilderEditInvalidFeedback.AlertOnly;
end;

procedure TRickUIBuilderEditBehavior.SetInvalid(AValue: Boolean;
  const AMessage: string);
begin
  FInvalid := AValue;
  FInvalidFromInput := False;
  FErrorLabel.Text := AMessage;
  FErrorLabel.Visible := AValue and ShouldShowErrorLabel(AMessage);
  if Assigned(FAlertPath) then
    FAlertPath.Visible := AValue and ShouldShowAlertIcon;
  if AValue then
    ApplyInvalidState
  else if FEdit.IsFocused then
    ApplyFocusState
  else
    ApplyNormalState;
end;

procedure TRickUIBuilderEditBehavior.SignalInvalidInput;
begin
  SetInvalid(True, FConfig.InvalidMessage);
  FInvalidFromInput := True;
end;

procedure TRickUIBuilderEditBehavior.SetRequirementMet(AValue: Boolean);
begin
  FRequirementMet := AValue;
  UpdateRequirementIcon;
end;

procedure TRickUIBuilderEditBehavior.AcceptCurrentText;
begin
  FLastValidText := FEdit.Text;
  UpdateCounter;
  UpdateClearVisibility;
end;

procedure TRickUIBuilderEditBehavior.UpdateCounter;
begin
  if not Assigned(FCounter) then
    Exit;
  FCounter.Visible := FConfig.ShowCounter and (FConfig.MaxLength > 0);
  if FCounter.Visible then
    FCounter.Text := Format('%d/%d', [Length(FEdit.Text), FConfig.MaxLength]);
end;

procedure TRickUIBuilderEditBehavior.UpdateClearVisibility;
begin
  if Assigned(FClearArea) then
    FClearArea.Visible := FConfig.ShowClearButton and (FEdit.Text <> '');
end;

procedure TRickUIBuilderEditBehavior.UpdatePasswordIcon;
begin
  if not Assigned(FPasswordArea) then
    Exit;
  FPasswordArea.Visible := FConfig.Password;
  if not FPasswordArea.Visible then
    Exit;
  if FEdit.Password then
    FPasswordPath.Data.Data := FConfig.VisibilityOffPath
  else
    FPasswordPath.Data.Data := FConfig.VisibilityPath;
end;

procedure TRickUIBuilderEditBehavior.UpdateRequirementIcon;
begin
  if not Assigned(FRequirementPath) then
    Exit;
  FRequirementPath.Visible := FConfig.ShowRequirementIndicator;
  if not FRequirementPath.Visible then
    Exit;
  if FRequirementMet then
    FRequirementPath.Data.Data := FConfig.RequirementMetPath
  else
    FRequirementPath.Data.Data := FConfig.RequirementNotMetPath;
end;

end.
