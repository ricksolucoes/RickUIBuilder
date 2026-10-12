unit Rick.UIBuilder.Edit.Config.Icons.Paths;

interface

uses
  FMX.Objects,

  Rick.UIBuilder.Edit.Interfaces;

type
  TRickUIBuilderEditConfigIconPaths = class(TInterfacedObject, IRickUIBuilderEditConfigIconPaths)
  private
    [weak]
    FParent: IRickUIBuilderEditConfigIcons;
    FAlert: TPath;
    FClear: TPath;
    FVisibility: TPath;
    FVisibilityOff: TPath;
    FRequirementMet: TPath;
    FRequirementNotMet: TPath;
  protected
    constructor Create(const AParent: IRickUIBuilderEditConfigIcons; const APaths: array of TPath);

    function Alert(const AValue: string): IRickUIBuilderEditConfigIconPaths;
    function Clear(const AValue: string): IRickUIBuilderEditConfigIconPaths;
    function Visibility(const AValue: string): IRickUIBuilderEditConfigIconPaths;
    function VisibilityOff(const AValue: string): IRickUIBuilderEditConfigIconPaths;
    function RequirementMet(const AValue: string): IRickUIBuilderEditConfigIconPaths;
    function RequirementNotMet(const AValue: string): IRickUIBuilderEditConfigIconPaths;
    function ToBack: IRickUIBuilderEditConfigIcons;
  public
    class function New(const AParent: IRickUIBuilderEditConfigIcons; const APaths: array of TPath): IRickUIBuilderEditConfigIconPaths;
  end;

implementation

uses
  System.SysUtils;

constructor TRickUIBuilderEditConfigIconPaths.Create(const AParent: IRickUIBuilderEditConfigIcons; const APaths: array of TPath);
begin
  inherited Create;
  FParent := AParent;
  FAlert := APaths[0];
  FClear := APaths[1];
  FVisibility := APaths[2];
  FVisibilityOff := APaths[3];
  FRequirementMet := APaths[4];
  FRequirementNotMet := APaths[5];
end;

class function TRickUIBuilderEditConfigIconPaths.New(const AParent: IRickUIBuilderEditConfigIcons; const APaths: array of TPath): IRickUIBuilderEditConfigIconPaths;
begin
  Result := Self.Create(AParent, APaths);
end;

function TRickUIBuilderEditConfigIconPaths.Alert(const AValue: string): IRickUIBuilderEditConfigIconPaths;
begin
  FAlert.Data.Data := AValue;
  Result := Self;
end;

function TRickUIBuilderEditConfigIconPaths.Clear(const AValue: string): IRickUIBuilderEditConfigIconPaths;
begin
  FClear.Data.Data := AValue;
  Result := Self;
end;

function TRickUIBuilderEditConfigIconPaths.Visibility(const AValue: string): IRickUIBuilderEditConfigIconPaths;
begin
  FVisibility.Data.Data := AValue;
  Result := Self;
end;

function TRickUIBuilderEditConfigIconPaths.VisibilityOff(const AValue: string): IRickUIBuilderEditConfigIconPaths;
begin
  FVisibilityOff.Data.Data := AValue;
  Result := Self;
end;

function TRickUIBuilderEditConfigIconPaths.RequirementMet(const AValue: string): IRickUIBuilderEditConfigIconPaths;
begin
  FRequirementMet.Data.Data := AValue;
  Result := Self;
end;

function TRickUIBuilderEditConfigIconPaths.RequirementNotMet(const AValue: string): IRickUIBuilderEditConfigIconPaths;
begin
  FRequirementNotMet.Data.Data := AValue;
  Result := Self;
end;

function TRickUIBuilderEditConfigIconPaths.ToBack: IRickUIBuilderEditConfigIcons;
begin
  if not Assigned(FParent) then
    raise Exception.Create('O Parent da interface não foi informado para retornar.');
  Result := FParent;
end;

end.
