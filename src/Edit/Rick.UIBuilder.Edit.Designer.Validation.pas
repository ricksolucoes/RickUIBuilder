unit Rick.UIBuilder.Edit.Designer.Validation;

interface

uses
  FMX.Edit,
  FMX.Objects,
  FMX.StdCtrls,

  Rick.UIBuilder.Edit.Interfaces,
  Rick.UIBuilder.Edit.Types;

type
  TRickUIBuilderEditDesignerValidation = class(TInterfacedObject, IRickUIBuilderEditDesignerValidation)
  private
    [weak]
    FParent: IRickUIBuilderEditDesigner;
    FControl: TEdit;
    FAlertPath: TPath;
    FRequirementMetPath: TPath;
    FRequirementNotMetPath: TPath;
    FErrorLabel: TLabel;
    FRequired: Boolean;
    FRequirementIndicator: Boolean;
    FFeedback: TRickUIBuilderEditInvalidFeedback;
    FDefaultMessage: string;
    FHasInvalid: Boolean;
    FInvalid: Boolean;
    FAutomaticInvalid: Boolean;
    FInvalidMessage: string;
    FHasRequirementMet: Boolean;
    FRequirementMet: Boolean;
    FPreviousExit: TRickNotifyEvent;
    FPreviousChangeTracking: TRickNotifyEvent;
    procedure BindEvents;
    function FindErrorLabel: TLabel;
    function IsCompletionInvalid: Boolean;
    function ResolvedInvalidMessage: string;
    procedure SetAutomaticInvalid(AValue: Boolean);
    procedure UpdateRequirementPaths;
    procedure UpdateErrorFeedback(const AMessage: string);
    procedure UpdateValidationFeedback;
    procedure RefreshVisuals;
    procedure HandleExit(ASender: TObject);
    procedure HandleChangeTracking(ASender: TObject);
  protected
    constructor Create(const AParent: IRickUIBuilderEditDesigner; AControl: TEdit;
      const APaths: array of TPath);

    function Required(AValue: Boolean): IRickUIBuilderEditDesignerValidation; overload;
    function Required: IRickUIBuilderEditDesignerValidation; overload;
    function RequirementIndicator(AValue: Boolean): IRickUIBuilderEditDesignerValidation; overload;
    function RequirementIndicator: IRickUIBuilderEditDesignerValidation; overload;
    function Feedback(AValue: TRickUIBuilderEditInvalidFeedback): IRickUIBuilderEditDesignerValidation;
    function DefaultMessage(const AValue: string): IRickUIBuilderEditDesignerValidation;
    function Invalid(AValue: Boolean): IRickUIBuilderEditDesignerValidation; overload;
    function Invalid(const AMessage: string): IRickUIBuilderEditDesignerValidation; overload;
    function Invalid(AValue: Boolean; const AMessage: string): IRickUIBuilderEditDesignerValidation; overload;
    function HasInvalid: Boolean;
    function InvalidValue: Boolean;
    function InvalidMessage: string;
    function RequirementMet(AValue: Boolean): IRickUIBuilderEditDesignerValidation; overload;
    function RequirementMet: IRickUIBuilderEditDesignerValidation; overload;
    function HasRequirementMet: Boolean;
    function RequirementMetValue: Boolean;
    function ToBack: IRickUIBuilderEditDesigner;
  public
    class function New(const AParent: IRickUIBuilderEditDesigner; AControl: TEdit;
      const APaths: array of TPath): IRickUIBuilderEditDesignerValidation;
  end;

implementation

uses
  System.SysUtils;

constructor TRickUIBuilderEditDesignerValidation.Create(
  const AParent: IRickUIBuilderEditDesigner; AControl: TEdit;
  const APaths: array of TPath);
begin
  inherited Create;
  FParent := AParent;
  FControl := AControl;
  FAlertPath := APaths[0];
  FRequirementMetPath := APaths[4];
  FRequirementNotMetPath := APaths[5];
  FErrorLabel := nil;
  FRequired := False;
  FRequirementIndicator := False;
  FFeedback := TRickUIBuilderEditInvalidFeedback.AlertAndIcon;
  FDefaultMessage := EmptyStr;
  FHasInvalid := False;
  FInvalid := False;
  FAutomaticInvalid := False;
  FInvalidMessage := EmptyStr;
  FHasRequirementMet := False;
  FRequirementMet := False;
  BindEvents;
end;

procedure TRickUIBuilderEditDesignerValidation.BindEvents;
begin
  FPreviousExit := FControl.OnExit;
  FPreviousChangeTracking := FControl.OnChangeTracking;
  FControl.OnExit := HandleExit;
  FControl.OnChangeTracking := HandleChangeTracking;
end;

class function TRickUIBuilderEditDesignerValidation.New(
  const AParent: IRickUIBuilderEditDesigner; AControl: TEdit;
  const APaths: array of TPath): IRickUIBuilderEditDesignerValidation;
begin
  Result := Self.Create(AParent, AControl, APaths);
end;

function TRickUIBuilderEditDesignerValidation.FindErrorLabel: TLabel;
var
  LIndex: Integer;
begin
  Result := FErrorLabel;
  if Assigned(Result) then
    Exit;
  for LIndex := 0 to FControl.ComponentCount - 1 do
    if FControl.Components[LIndex] is TLabel then
    begin
      FErrorLabel := TLabel(FControl.Components[LIndex]);
      Exit(FErrorLabel);
    end;
end;

function TRickUIBuilderEditDesignerValidation.IsCompletionInvalid: Boolean;
var
  LValue: string;
begin
  if FControl.Text.Trim.IsEmpty then
    Exit(FRequired);
  if Assigned(FParent) then
    FParent.Input.Config;
  LValue := FControl.Text;
  if Assigned(FControl.OnValidating) then
    FControl.OnValidating(FControl.Owner, LValue);
  Result := LValue = EmptyStr;
end;

procedure TRickUIBuilderEditDesignerValidation.SetAutomaticInvalid(
  AValue: Boolean);
begin
  if FAutomaticInvalid = AValue then
    Exit;
  FAutomaticInvalid := AValue;
  UpdateValidationFeedback;
  RefreshVisuals;
end;

procedure TRickUIBuilderEditDesignerValidation.HandleExit(ASender: TObject);
begin
  if Assigned(ASender) then
    SetAutomaticInvalid(IsCompletionInvalid);
  if Assigned(FPreviousExit) then
    FPreviousExit(ASender);
end;

procedure TRickUIBuilderEditDesignerValidation.HandleChangeTracking(
  ASender: TObject);
begin
  if Assigned(ASender) and FAutomaticInvalid then
    SetAutomaticInvalid(False);
  if Assigned(FPreviousChangeTracking) then
    FPreviousChangeTracking(ASender);
end;

procedure TRickUIBuilderEditDesignerValidation.UpdateRequirementPaths;
begin
  FRequirementMetPath.Visible := FRequirementIndicator and FRequirementMet;
  FRequirementNotMetPath.Visible := FRequirementIndicator and not FRequirementMet;
end;

function TRickUIBuilderEditDesignerValidation.ResolvedInvalidMessage: string;
begin
  Result := FDefaultMessage;
  if FInvalid and (FInvalidMessage <> EmptyStr) then
    Result := FInvalidMessage;
end;

procedure TRickUIBuilderEditDesignerValidation.UpdateErrorFeedback(
  const AMessage: string);
var
  LErrorLabel: TLabel;
begin
  LErrorLabel := FindErrorLabel;
  if not Assigned(LErrorLabel) then
    Exit;
  LErrorLabel.Text := AMessage;
  LErrorLabel.Visible := InvalidValue and (AMessage <> EmptyStr) and
    (FFeedback <> TRickUIBuilderEditInvalidFeedback.IconOnly);
end;

procedure TRickUIBuilderEditDesignerValidation.UpdateValidationFeedback;
var
  LMessage: string;
begin
  LMessage := EmptyStr;
  if InvalidValue then
    LMessage := ResolvedInvalidMessage;
  UpdateErrorFeedback(LMessage);
  FAlertPath.Visible := InvalidValue and
    (FFeedback <> TRickUIBuilderEditInvalidFeedback.AlertOnly);
end;

procedure TRickUIBuilderEditDesignerValidation.RefreshVisuals;
begin
  if Assigned(FControl.OnEnter) then
    FControl.OnEnter(nil);
end;

function TRickUIBuilderEditDesignerValidation.Required(
  AValue: Boolean): IRickUIBuilderEditDesignerValidation;
begin
  FRequired := AValue;
  Result := Self;
end;

function TRickUIBuilderEditDesignerValidation.Required: IRickUIBuilderEditDesignerValidation;
begin
  Result := Required(True);
end;

function TRickUIBuilderEditDesignerValidation.RequirementIndicator(
  AValue: Boolean): IRickUIBuilderEditDesignerValidation;
begin
  FRequirementIndicator := AValue;
  UpdateRequirementPaths;
  Result := Self;
end;

function TRickUIBuilderEditDesignerValidation.RequirementIndicator: IRickUIBuilderEditDesignerValidation;
begin
  Result := RequirementIndicator(True);
end;

function TRickUIBuilderEditDesignerValidation.Feedback(
  AValue: TRickUIBuilderEditInvalidFeedback): IRickUIBuilderEditDesignerValidation;
begin
  FFeedback := AValue;
  UpdateValidationFeedback;
  Result := Self;
end;

function TRickUIBuilderEditDesignerValidation.DefaultMessage(
  const AValue: string): IRickUIBuilderEditDesignerValidation;
begin
  FDefaultMessage := AValue;
  UpdateValidationFeedback;
  Result := Self;
end;

function TRickUIBuilderEditDesignerValidation.Invalid(
  AValue: Boolean): IRickUIBuilderEditDesignerValidation;
begin
  Result := Invalid(AValue, EmptyStr);
end;

function TRickUIBuilderEditDesignerValidation.Invalid(
  const AMessage: string): IRickUIBuilderEditDesignerValidation;
begin
  Result := Invalid(True, AMessage);
end;

function TRickUIBuilderEditDesignerValidation.Invalid(AValue: Boolean;
  const AMessage: string): IRickUIBuilderEditDesignerValidation;
begin
  FHasInvalid := True;
  FInvalid := AValue;
  FInvalidMessage := AMessage;
  if not AValue then
    FAutomaticInvalid := False;
  UpdateValidationFeedback;
  RefreshVisuals;
  Result := Self;
end;

function TRickUIBuilderEditDesignerValidation.HasInvalid: Boolean;
begin
  Result := FHasInvalid;
end;

function TRickUIBuilderEditDesignerValidation.InvalidValue: Boolean;
begin
  Result := FInvalid or FAutomaticInvalid;
end;

function TRickUIBuilderEditDesignerValidation.InvalidMessage: string;
begin
  Result := FInvalidMessage;
end;

function TRickUIBuilderEditDesignerValidation.RequirementMet(
  AValue: Boolean): IRickUIBuilderEditDesignerValidation;
begin
  FHasRequirementMet := True;
  FRequirementMet := AValue;
  UpdateRequirementPaths;
  Result := Self;
end;

function TRickUIBuilderEditDesignerValidation.RequirementMet: IRickUIBuilderEditDesignerValidation;
begin
  Result := RequirementMet(True);
end;

function TRickUIBuilderEditDesignerValidation.HasRequirementMet: Boolean;
begin
  Result := FHasRequirementMet;
end;

function TRickUIBuilderEditDesignerValidation.RequirementMetValue: Boolean;
begin
  Result := FRequirementMet;
end;

function TRickUIBuilderEditDesignerValidation.ToBack: IRickUIBuilderEditDesigner;
begin
  if not Assigned(FParent) then
    raise Exception.Create('O Parent da interface não foi informado para retornar.');
  Result := FParent;
end;

end.
