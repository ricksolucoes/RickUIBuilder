unit Rick.UIBuilder.Edit.Config;

interface

uses
  FMX.Objects,

  Rick.UIBuilder.Edit.InputRules,
  Rick.UIBuilder.Edit.Interfaces,
  Rick.UIBuilder.Edit.Types;

type
  TRickUIBuilderEditConfig = class(TInterfacedObject, IRickUIBuilderEditConfig)
  private
    [weak]
    FParent: IRickUIBuilderEdit;
    FHost: TRectangle;
    FInputRules: TRickUIBuilderEditInputRules;
    FAppearance: TRickUIBuilderEditAppearance;
    FIcons: IRickUIBuilderEditConfigIcons;
  protected
    constructor Create(const AParent: IRickUIBuilderEdit; AHost: TRectangle; AInputRules: TRickUIBuilderEditInputRules);

    function Appearance(AValue: TRickUIBuilderEditAppearance): IRickUIBuilderEditConfig;
    function Icons: IRickUIBuilderEditConfigIcons;
    function ToBack: IRickUIBuilderEdit;
  public
    class function New(const AParent: IRickUIBuilderEdit; AHost: TRectangle; AInputRules: TRickUIBuilderEditInputRules): IRickUIBuilderEditConfig;
  end;

implementation

uses
  System.SysUtils,

  Rick.UIBuilder.Edit.Config.Icons;

constructor TRickUIBuilderEditConfig.Create(const AParent: IRickUIBuilderEdit; AHost: TRectangle; AInputRules: TRickUIBuilderEditInputRules);
begin
  inherited Create;
  FParent := AParent;
  FHost := AHost;
  FInputRules := AInputRules;
  FAppearance := TRickUIBuilderEditAppearance.Outlined;
end;

class function TRickUIBuilderEditConfig.New(const AParent: IRickUIBuilderEdit; AHost: TRectangle; AInputRules: TRickUIBuilderEditInputRules): IRickUIBuilderEditConfig;
begin
  Result := Self.Create(AParent, AHost, AInputRules);
end;

function TRickUIBuilderEditConfig.Appearance(AValue: TRickUIBuilderEditAppearance): IRickUIBuilderEditConfig;
begin
  FAppearance := AValue;
  Result := Self;
end;

function TRickUIBuilderEditConfig.Icons: IRickUIBuilderEditConfigIcons;
begin
  if not Assigned(FIcons) then
    FIcons := TRickUIBuilderEditConfigIcons.New(Self, FHost, FInputRules);
  Result := FIcons;
end;

function TRickUIBuilderEditConfig.ToBack: IRickUIBuilderEdit;
begin
  if not Assigned(FParent) then
    raise Exception.Create('O Parent da interface não foi informado para retornar.');
  Result := FParent;
end;

end.
