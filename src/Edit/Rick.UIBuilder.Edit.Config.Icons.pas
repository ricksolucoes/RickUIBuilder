unit Rick.UIBuilder.Edit.Config.Icons;

interface

uses
  FMX.Objects,

  Rick.UIBuilder.Edit.Interfaces;

type
  TRickUIBuilderEditConfigIcons = class(TInterfacedObject, IRickUIBuilderEditConfigIcons)
  private
    [weak]
    FParent: IRickUIBuilderEditConfig;
    FAlert: TPath;
    FClear: TPath;
    FVisibility: TPath;
    FVisibilityOff: TPath;
    FRequirementMet: TPath;
    FRequirementNotMet: TPath;
    FColors: IRickUIBuilderEditConfigIconColors;
    FPaths: IRickUIBuilderEditConfigIconPaths;
    procedure ApplySize(AValue: Single);
  protected
    constructor Create(const AParent: IRickUIBuilderEditConfig;
      const APaths: array of TPath);

    function Size(AValue: Single): IRickUIBuilderEditConfigIcons;
    function Colors: IRickUIBuilderEditConfigIconColors;
    function Paths: IRickUIBuilderEditConfigIconPaths;
    function ToBack: IRickUIBuilderEditConfig;
  public
    class function New(const AParent: IRickUIBuilderEditConfig;
      const APaths: array of TPath): IRickUIBuilderEditConfigIcons;
  end;

implementation

uses
  System.SysUtils,

  Rick.UIBuilder.Edit.Config.Icons.Colors,
  Rick.UIBuilder.Edit.Config.Icons.Paths;

constructor TRickUIBuilderEditConfigIcons.Create(
  const AParent: IRickUIBuilderEditConfig; const APaths: array of TPath);
begin
  inherited Create;
  FParent := AParent;
  FAlert := APaths[0];
  FClear := APaths[1];
  FVisibility := APaths[2];
  FVisibilityOff := APaths[3];
  FRequirementMet := APaths[4];
  FRequirementNotMet := APaths[5];
  ApplySize(20);
end;

class function TRickUIBuilderEditConfigIcons.New(
  const AParent: IRickUIBuilderEditConfig;
  const APaths: array of TPath): IRickUIBuilderEditConfigIcons;
begin
  Result := Self.Create(AParent, APaths);
end;

procedure TRickUIBuilderEditConfigIcons.ApplySize(AValue: Single);
begin
  FAlert.SetBounds(0, 0, AValue, AValue);
  FClear.SetBounds(0, 0, AValue, AValue);
  FVisibility.SetBounds(0, 0, AValue, AValue);
  FVisibilityOff.SetBounds(0, 0, AValue, AValue);
  FRequirementMet.SetBounds(0, 0, AValue, AValue);
  FRequirementNotMet.SetBounds(0, 0, AValue, AValue);
end;

function TRickUIBuilderEditConfigIcons.Size(
  AValue: Single): IRickUIBuilderEditConfigIcons;
begin
  ApplySize(AValue);
  Result := Self;
end;

function TRickUIBuilderEditConfigIcons.Colors: IRickUIBuilderEditConfigIconColors;
begin
  if not Assigned(FColors) then
    FColors := TRickUIBuilderEditConfigIconColors.New(Self,
      [FAlert, FClear, FVisibility, FVisibilityOff, FRequirementMet,
      FRequirementNotMet]);
  Result := FColors;
end;

function TRickUIBuilderEditConfigIcons.Paths: IRickUIBuilderEditConfigIconPaths;
begin
  if not Assigned(FPaths) then
    FPaths := TRickUIBuilderEditConfigIconPaths.New(Self,
      [FAlert, FClear, FVisibility, FVisibilityOff, FRequirementMet,
      FRequirementNotMet]);
  Result := FPaths;
end;

function TRickUIBuilderEditConfigIcons.ToBack: IRickUIBuilderEditConfig;
begin
  if not Assigned(FParent) then
    raise Exception.Create('O Parent da interface não foi informado para retornar.');
  Result := FParent;
end;

end.
