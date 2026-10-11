unit Rick.UIBuilder.Edit.State;
{$SCOPEDENUMS ON}

interface

uses
  System.SysUtils,
  Rick.UIBuilder.Interfaces;

type
  TRickUIBuilderEditState = class(TInterfacedObject, IRickUIBuilderEditState)
  strict private
    [weak]
    FParent: IRickUIBuilderEdit;
    FHasInvalid: Boolean;
    FInvalid: Boolean;
    FInvalidMessage: string;
    FHasRequirementMet: Boolean;
    FRequirementMet: Boolean;
  protected
    function Text(const AValue: string): IRickUIBuilderEditState;
    function Invalid(AValue: Boolean): IRickUIBuilderEditState; overload;
    function Invalid(const AMessage: string): IRickUIBuilderEditState; overload;
    function Invalid(AValue: Boolean; const AMessage: string): IRickUIBuilderEditState; overload;
    function RequirementMet(AValue: Boolean): IRickUIBuilderEditState;

    function HasInvalid: Boolean;
    function InvalidValue: Boolean;
    function InvalidMessage: string;
    function HasRequirementMet: Boolean;
    function RequirementMetValue: Boolean;

    function ToBack: IRickUIBuilderEdit;

    constructor Create(const AValue: IRickUIBuilderEdit);
  public
    destructor Destroy; override;
    class function New(const AValue: IRickUIBuilderEdit): IRickUIBuilderEditState;
  end;

implementation

constructor TRickUIBuilderEditState.Create(const AValue: IRickUIBuilderEdit);
begin
  inherited Create;
  FParent := AValue;
  FHasInvalid := False;
  FInvalid := False;
  FInvalidMessage := EmptyStr;
  FHasRequirementMet := False;
  FRequirementMet := False;
end;

destructor TRickUIBuilderEditState.Destroy;
begin
  inherited;
end;

class function TRickUIBuilderEditState.New(const AValue: IRickUIBuilderEdit): IRickUIBuilderEditState;
begin
  Result := Self.Create(AValue);
end;

function TRickUIBuilderEditState.Text(const AValue: string): IRickUIBuilderEditState;
begin
  ToBack.Text(AValue);
  Result := Self;
end;

function TRickUIBuilderEditState.Invalid(AValue: Boolean): IRickUIBuilderEditState;
begin
  Result := Invalid(AValue, EmptyStr);
end;

function TRickUIBuilderEditState.Invalid(const AMessage: string): IRickUIBuilderEditState;
begin
  Result := Invalid(True, AMessage);
end;

function TRickUIBuilderEditState.Invalid(AValue: Boolean; const AMessage: string): IRickUIBuilderEditState;
begin
  FHasInvalid := True;
  FInvalid := AValue;
  FInvalidMessage := AMessage;
  Result := Self;
end;

function TRickUIBuilderEditState.RequirementMet(AValue: Boolean): IRickUIBuilderEditState;
begin
  FHasRequirementMet := True;
  FRequirementMet := AValue;
  Result := Self;
end;

function TRickUIBuilderEditState.ToBack: IRickUIBuilderEdit;
begin
  if (not Assigned(FParent)) or (FParent = nil) then
    raise Exception.Create('O Parent da interface não foi informado para retornar.');

  Result := FParent;
end;

function TRickUIBuilderEditState.HasInvalid: Boolean;
begin
  Result := FHasInvalid;
end;

function TRickUIBuilderEditState.InvalidValue: Boolean;
begin
  Result := FInvalid;
end;

function TRickUIBuilderEditState.InvalidMessage: string;
begin
  Result := FInvalidMessage;
end;

function TRickUIBuilderEditState.HasRequirementMet: Boolean;
begin
  Result := FHasRequirementMet;
end;

function TRickUIBuilderEditState.RequirementMetValue: Boolean;
begin
  Result := FRequirementMet;
end;

end.
