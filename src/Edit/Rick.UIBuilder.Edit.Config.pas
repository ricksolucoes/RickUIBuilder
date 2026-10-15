unit Rick.UIBuilder.Edit.Config;

interface

uses
  FMX.Objects,

  Rick.UIBuilder.Edit.Interfaces,
  Rick.UIBuilder.Edit.Types;

type
  TRickUIBuilderEditConfig = class(TInterfacedObject, IRickUIBuilderEditConfig)
  private
    [weak]
    FParent: IRickUIBuilderEdit;
    FHost: TRectangle;
    FPaths: array[0..5] of TPath;
    FAppearance: TRickUIBuilderEditAppearance;
    FIcons: IRickUIBuilderEditConfigIcons;
  protected
    constructor Create(const AParent: IRickUIBuilderEdit; AHost: TRectangle;
      const APaths: array of TPath);

    function Appearance(AValue: TRickUIBuilderEditAppearance): IRickUIBuilderEditConfig;
    function Icons: IRickUIBuilderEditConfigIcons;
    function ToBack: IRickUIBuilderEdit;
  public
    class function New(const AParent: IRickUIBuilderEdit; AHost: TRectangle;
      const APaths: array of TPath): IRickUIBuilderEditConfig;
  end;

implementation

uses
  System.SysUtils,

  Rick.UIBuilder.Edit.Config.Icons;

constructor TRickUIBuilderEditConfig.Create(const AParent: IRickUIBuilderEdit;
  AHost: TRectangle; const APaths: array of TPath);
var
  LIndex: Integer;
begin
  inherited Create;
  FParent := AParent;
  FHost := AHost;
  for LIndex := Low(FPaths) to High(FPaths) do
    FPaths[LIndex] := APaths[LIndex];
  FAppearance := TRickUIBuilderEditAppearance.Outlined;
end;

class function TRickUIBuilderEditConfig.New(const AParent: IRickUIBuilderEdit;
  AHost: TRectangle; const APaths: array of TPath): IRickUIBuilderEditConfig;
begin
  Result := Self.Create(AParent, AHost, APaths);
end;

function TRickUIBuilderEditConfig.Appearance(
  AValue: TRickUIBuilderEditAppearance): IRickUIBuilderEditConfig;
begin
  FAppearance := AValue;
  Result := Self;
end;

function TRickUIBuilderEditConfig.Icons: IRickUIBuilderEditConfigIcons;
begin
  if not Assigned(FIcons) then
    FIcons := TRickUIBuilderEditConfigIcons.New(Self, FPaths);
  Result := FIcons;
end;

function TRickUIBuilderEditConfig.ToBack: IRickUIBuilderEdit;
begin
  if not Assigned(FParent) then
    raise Exception.Create('O Parent da interface não foi informado para retornar.');
  Result := FParent;
end;

end.
