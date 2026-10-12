unit Rick.UIBuilder.Edit.Config.Icons.Colors;

interface

uses
  FMX.Objects,
  System.UITypes,

  Rick.UIBuilder.Edit.Interfaces;

type
  TRickUIBuilderEditConfigIconColors = class(TInterfacedObject, IRickUIBuilderEditConfigIconColors)
  private
    [weak]
    FParent: IRickUIBuilderEditConfigIcons;
    FAlert: TPath;
    FClear: TPath;
    FVisibility: TPath;
    FVisibilityOff: TPath;
    FRequirementMet: TPath;
    FRequirementNotMet: TPath;
    procedure SetPathColor(APath: TPath; AValue: TAlphaColor);
  protected
    constructor Create(const AParent: IRickUIBuilderEditConfigIcons; const APaths: array of TPath);

    function Default(AValue: TAlphaColor): IRickUIBuilderEditConfigIconColors;
    function Alert(AValue: TAlphaColor): IRickUIBuilderEditConfigIconColors;
    function Clear(AValue: TAlphaColor): IRickUIBuilderEditConfigIconColors;
    function Password(AValue: TAlphaColor): IRickUIBuilderEditConfigIconColors;
    function Requirement(AValue: TAlphaColor): IRickUIBuilderEditConfigIconColors;
    function ToBack: IRickUIBuilderEditConfigIcons;
  public
    class function New(const AParent: IRickUIBuilderEditConfigIcons; const APaths: array of TPath): IRickUIBuilderEditConfigIconColors;
  end;

implementation

uses
  System.SysUtils;

constructor TRickUIBuilderEditConfigIconColors.Create(const AParent: IRickUIBuilderEditConfigIcons; const APaths: array of TPath);
begin
  inherited Create;
  FParent := AParent;
  FAlert := APaths[0];
  FClear := APaths[1];
  FVisibility := APaths[2];
  FVisibilityOff := APaths[3];
  FRequirementMet := APaths[4];
  FRequirementNotMet := APaths[5];
  SetPathColor(FAlert, $FF606060);
  SetPathColor(FClear, $FF606060);
  SetPathColor(FVisibility, $FF606060);
  SetPathColor(FVisibilityOff, $FF606060);
  SetPathColor(FRequirementMet, $FF606060);
  SetPathColor(FRequirementNotMet, $FF606060);
end;

class function TRickUIBuilderEditConfigIconColors.New(const AParent: IRickUIBuilderEditConfigIcons; const APaths: array of TPath): IRickUIBuilderEditConfigIconColors;
begin
  Result := Self.Create(AParent, APaths);
end;

procedure TRickUIBuilderEditConfigIconColors.SetPathColor(APath: TPath; AValue: TAlphaColor);
begin
  APath.Fill.Color := AValue;
end;

function TRickUIBuilderEditConfigIconColors.Default(AValue: TAlphaColor): IRickUIBuilderEditConfigIconColors;
begin
  SetPathColor(FAlert, AValue);
  SetPathColor(FClear, AValue);
  SetPathColor(FVisibility, AValue);
  SetPathColor(FVisibilityOff, AValue);
  SetPathColor(FRequirementMet, AValue);
  SetPathColor(FRequirementNotMet, AValue);
  Result := Self;
end;

function TRickUIBuilderEditConfigIconColors.Alert(AValue: TAlphaColor): IRickUIBuilderEditConfigIconColors;
begin
  SetPathColor(FAlert, AValue);
  Result := Self;
end;

function TRickUIBuilderEditConfigIconColors.Clear(AValue: TAlphaColor): IRickUIBuilderEditConfigIconColors;
begin
  SetPathColor(FClear, AValue);
  Result := Self;
end;

function TRickUIBuilderEditConfigIconColors.Password(AValue: TAlphaColor): IRickUIBuilderEditConfigIconColors;
begin
  SetPathColor(FVisibility, AValue);
  SetPathColor(FVisibilityOff, AValue);
  Result := Self;
end;

function TRickUIBuilderEditConfigIconColors.Requirement(AValue: TAlphaColor): IRickUIBuilderEditConfigIconColors;
begin
  SetPathColor(FRequirementMet, AValue);
  SetPathColor(FRequirementNotMet, AValue);
  Result := Self;
end;

function TRickUIBuilderEditConfigIconColors.ToBack: IRickUIBuilderEditConfigIcons;
begin
  if not Assigned(FParent) then
    raise Exception.Create('O Parent da interface não foi informado para retornar.');
  Result := FParent;
end;

end.
