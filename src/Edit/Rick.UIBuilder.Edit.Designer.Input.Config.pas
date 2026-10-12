unit Rick.UIBuilder.Edit.Designer.Input.Config;

interface

uses
  FMX.Edit,

  Rick.UIBuilder.Edit.Interfaces,
  Rick.UIBuilder.Edit.Types;

type
  TRickUIBuilderEditDesignerInputConfig = class(TInterfacedObject, IRickUIBuilderEditDesignerInputConfig)
  private
    [weak]
    FParent: IRickUIBuilderEditDesignerInput;
    FControl: TEdit;
    FPreset: TRickUIBuilderEditPreset;
    FCaseMode: TRickUIBuilderEditCaseMode;
    FUrlCaseMode: TRickUIBuilderEditUrlCaseMode;
    FMaxLength: Integer;
  protected
    constructor Create(const AParent: IRickUIBuilderEditDesignerInput; AControl: TEdit);

    function Preset(AValue: TRickUIBuilderEditPreset): IRickUIBuilderEditDesignerInputConfig;
    function CaseMode(AValue: TRickUIBuilderEditCaseMode): IRickUIBuilderEditDesignerInputConfig;
    function UrlCaseMode(AValue: TRickUIBuilderEditUrlCaseMode): IRickUIBuilderEditDesignerInputConfig;
    function MaxLength(AValue: Integer): IRickUIBuilderEditDesignerInputConfig;
    function ToBack: IRickUIBuilderEditDesignerInput;
  public
    class function New(const AParent: IRickUIBuilderEditDesignerInput; AControl: TEdit): IRickUIBuilderEditDesignerInputConfig;
  end;

implementation

uses
  System.SysUtils;

constructor TRickUIBuilderEditDesignerInputConfig.Create(const AParent: IRickUIBuilderEditDesignerInput; AControl: TEdit);
begin
  inherited Create;
  FParent := AParent;
  FControl := AControl;
  FPreset := TRickUIBuilderEditPreset.AllCharacters;
  FCaseMode := TRickUIBuilderEditCaseMode.Preserve;
  FUrlCaseMode := TRickUIBuilderEditUrlCaseMode.SchemeAndHost;
  FMaxLength := 0;
end;

class function TRickUIBuilderEditDesignerInputConfig.New(const AParent: IRickUIBuilderEditDesignerInput; AControl: TEdit): IRickUIBuilderEditDesignerInputConfig;
begin
  Result := Self.Create(AParent, AControl);
end;

function TRickUIBuilderEditDesignerInputConfig.Preset(AValue: TRickUIBuilderEditPreset): IRickUIBuilderEditDesignerInputConfig;
begin
  FPreset := AValue;
  Result := Self;
end;

function TRickUIBuilderEditDesignerInputConfig.CaseMode(AValue: TRickUIBuilderEditCaseMode): IRickUIBuilderEditDesignerInputConfig;
begin
  FCaseMode := AValue;
  Result := Self;
end;

function TRickUIBuilderEditDesignerInputConfig.UrlCaseMode(AValue: TRickUIBuilderEditUrlCaseMode): IRickUIBuilderEditDesignerInputConfig;
begin
  FUrlCaseMode := AValue;
  Result := Self;
end;

function TRickUIBuilderEditDesignerInputConfig.MaxLength(AValue: Integer): IRickUIBuilderEditDesignerInputConfig;
begin
  FMaxLength := AValue;
  FControl.MaxLength := AValue;
  Result := Self;
end;

function TRickUIBuilderEditDesignerInputConfig.ToBack: IRickUIBuilderEditDesignerInput;
begin
  if not Assigned(FParent) then
    raise Exception.Create('O Parent da interface não foi informado para retornar.');
  Result := FParent;
end;

end.
