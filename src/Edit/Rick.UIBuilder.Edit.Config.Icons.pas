unit Rick.UIBuilder.Edit.Config.Icons;

interface

uses
  FMX.Objects,

  Rick.UIBuilder.Edit.InputRules,
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
    procedure CreatePaths(AHost: TRectangle);
    procedure HidePaths;
    procedure ApplySize(AValue: Single);
  protected
    constructor Create(const AParent: IRickUIBuilderEditConfig; AHost: TRectangle; AInputRules: TRickUIBuilderEditInputRules);

    function Size(AValue: Single): IRickUIBuilderEditConfigIcons;
    function Colors: IRickUIBuilderEditConfigIconColors;
    function Paths: IRickUIBuilderEditConfigIconPaths;
    function ToBack: IRickUIBuilderEditConfig;
  public
    class function New(const AParent: IRickUIBuilderEditConfig; AHost: TRectangle; AInputRules: TRickUIBuilderEditInputRules): IRickUIBuilderEditConfigIcons;
  end;

implementation

uses
  System.SysUtils,

  FMX.Types,

  Rick.UIBuilder.Edit.Config.Icons.Colors,
  Rick.UIBuilder.Edit.Config.Icons.Paths;

constructor TRickUIBuilderEditConfigIcons.Create(const AParent: IRickUIBuilderEditConfig; AHost: TRectangle; AInputRules: TRickUIBuilderEditInputRules);
begin
  inherited Create;
  FParent := AParent;
  CreatePaths(AHost);
  HidePaths;
  ApplySize(20);
  AInputRules.BindActionPaths(FAlert, FClear, FVisibility, FVisibilityOff, FRequirementMet, FRequirementNotMet);
end;

procedure TRickUIBuilderEditConfigIcons.CreatePaths(AHost: TRectangle);
begin
  FAlert := TPath.Create(AHost);
  FClear := TPath.Create(AHost);
  FVisibility := TPath.Create(AHost);
  FVisibilityOff := TPath.Create(AHost);
  FRequirementMet := TPath.Create(AHost);
  FRequirementNotMet := TPath.Create(AHost);
  FAlert.Parent := AHost;
  FClear.Parent := AHost;
  FVisibility.Parent := AHost;
  FVisibilityOff.Parent := AHost;
  FRequirementMet.Parent := AHost;
  FRequirementNotMet.Parent := AHost;
end;

procedure TRickUIBuilderEditConfigIcons.HidePaths;
begin
  FAlert.Visible := False;
  FClear.Visible := False;
  FVisibility.Visible := False;
  FVisibilityOff.Visible := False;
  FRequirementMet.Visible := False;
  FRequirementNotMet.Visible := False;
end;

class function TRickUIBuilderEditConfigIcons.New(const AParent: IRickUIBuilderEditConfig; AHost: TRectangle; AInputRules: TRickUIBuilderEditInputRules): IRickUIBuilderEditConfigIcons;
begin
  Result := Self.Create(AParent, AHost, AInputRules);
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

function TRickUIBuilderEditConfigIcons.Size(AValue: Single): IRickUIBuilderEditConfigIcons;
begin
  ApplySize(AValue);
  Result := Self;
end;

function TRickUIBuilderEditConfigIcons.Colors: IRickUIBuilderEditConfigIconColors;
begin
  if not Assigned(FColors) then
    FColors := TRickUIBuilderEditConfigIconColors.New(Self, [FAlert, FClear, FVisibility, FVisibilityOff, FRequirementMet, FRequirementNotMet]);
  Result := FColors;
end;

function TRickUIBuilderEditConfigIcons.Paths: IRickUIBuilderEditConfigIconPaths;
begin
  if not Assigned(FPaths) then
    FPaths := TRickUIBuilderEditConfigIconPaths.New(Self, [FAlert, FClear, FVisibility, FVisibilityOff, FRequirementMet, FRequirementNotMet]);
  Result := FPaths;
end;

function TRickUIBuilderEditConfigIcons.ToBack: IRickUIBuilderEditConfig;
begin
  if not Assigned(FParent) then
    raise Exception.Create('O Parent da interface não foi informado para retornar.');
  Result := FParent;
end;

end.
