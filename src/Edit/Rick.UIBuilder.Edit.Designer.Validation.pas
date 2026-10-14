unit Rick.UIBuilder.Edit.Designer.Validation;

interface

uses
  Rick.UIBuilder.Edit.InputRules,
  Rick.UIBuilder.Edit.Interfaces,
  Rick.UIBuilder.Edit.Types,
  Rick.UIBuilder.Edit.VisualState;

type
  TRickUIBuilderEditDesignerValidation = class(TInterfacedObject, IRickUIBuilderEditDesignerValidation)
  private
    [weak]
    FParent: IRickUIBuilderEditDesigner;
    FRequired: Boolean;
    FRequirementIndicator: Boolean;
    FFeedback: TRickUIBuilderEditInvalidFeedback;
    FDefaultMessage: string;
    FHasInvalid: Boolean;
    FInvalid: Boolean;
    FInvalidMessage: string;
    FHasRequirementMet: Boolean;
    FRequirementMet: Boolean;
    FInputRules: TRickUIBuilderEditInputRules;
    FVisualState: TRickUIBuilderEditVisualState;
  protected
    constructor Create(const AParent: IRickUIBuilderEditDesigner; AInputRules: TRickUIBuilderEditInputRules; AVisualState: TRickUIBuilderEditVisualState);

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
    class function New(const AParent: IRickUIBuilderEditDesigner; AInputRules: TRickUIBuilderEditInputRules; AVisualState: TRickUIBuilderEditVisualState): IRickUIBuilderEditDesignerValidation;
  end;

implementation

uses
  System.SysUtils;

constructor TRickUIBuilderEditDesignerValidation.Create(const AParent: IRickUIBuilderEditDesigner; AInputRules: TRickUIBuilderEditInputRules; AVisualState: TRickUIBuilderEditVisualState);
begin
  inherited Create;
  FParent := AParent;
  FInputRules := AInputRules;
  FVisualState := AVisualState;
  FRequired := False;
  FRequirementIndicator := False;
  FFeedback := TRickUIBuilderEditInvalidFeedback.AlertAndIcon;
  FDefaultMessage := EmptyStr;
  FHasInvalid := False;
  FInvalid := False;
  FInvalidMessage := EmptyStr;
  FHasRequirementMet := False;
  FRequirementMet := False;
end;

class function TRickUIBuilderEditDesignerValidation.New(const AParent: IRickUIBuilderEditDesigner; AInputRules: TRickUIBuilderEditInputRules; AVisualState: TRickUIBuilderEditVisualState): IRickUIBuilderEditDesignerValidation;
begin
  Result := Self.Create(AParent, AInputRules, AVisualState);
end;

function TRickUIBuilderEditDesignerValidation.Required(AValue: Boolean): IRickUIBuilderEditDesignerValidation;
begin
  FRequired := AValue;
  Result := Self;
end;

function TRickUIBuilderEditDesignerValidation.Required: IRickUIBuilderEditDesignerValidation;
begin
  Result := Required(True);
end;

function TRickUIBuilderEditDesignerValidation.RequirementIndicator(AValue: Boolean): IRickUIBuilderEditDesignerValidation;
begin
  FRequirementIndicator := AValue;
  FInputRules.SetRequirementState(FRequirementIndicator, FRequirementMet);
  Result := Self;
end;

function TRickUIBuilderEditDesignerValidation.RequirementIndicator: IRickUIBuilderEditDesignerValidation;
begin
  Result := RequirementIndicator(True);
end;

function TRickUIBuilderEditDesignerValidation.Feedback(AValue: TRickUIBuilderEditInvalidFeedback): IRickUIBuilderEditDesignerValidation;
begin
  FFeedback := AValue;
  Result := Self;
end;

function TRickUIBuilderEditDesignerValidation.DefaultMessage(const AValue: string): IRickUIBuilderEditDesignerValidation;
begin
  FDefaultMessage := AValue;
  Result := Self;
end;

function TRickUIBuilderEditDesignerValidation.Invalid(AValue: Boolean): IRickUIBuilderEditDesignerValidation;
begin
  Result := Invalid(AValue, EmptyStr);
end;

function TRickUIBuilderEditDesignerValidation.Invalid(const AMessage: string): IRickUIBuilderEditDesignerValidation;
begin
  Result := Invalid(True, AMessage);
end;

function TRickUIBuilderEditDesignerValidation.Invalid(AValue: Boolean; const AMessage: string): IRickUIBuilderEditDesignerValidation;
begin
  FHasInvalid := True;
  FInvalid := AValue;
  FInvalidMessage := AMessage;
  FVisualState.SetInvalid(AValue);
  Result := Self;
end;

function TRickUIBuilderEditDesignerValidation.HasInvalid: Boolean;
begin
  Result := FHasInvalid;
end;

function TRickUIBuilderEditDesignerValidation.InvalidValue: Boolean;
begin
  Result := FInvalid;
end;

function TRickUIBuilderEditDesignerValidation.InvalidMessage: string;
begin
  Result := FInvalidMessage;
end;

function TRickUIBuilderEditDesignerValidation.RequirementMet(AValue: Boolean): IRickUIBuilderEditDesignerValidation;
begin
  FHasRequirementMet := True;
  FRequirementMet := AValue;
  FInputRules.SetRequirementState(FRequirementIndicator, FRequirementMet);
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
