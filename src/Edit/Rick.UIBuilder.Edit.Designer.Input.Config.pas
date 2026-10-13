unit Rick.UIBuilder.Edit.Designer.Input.Config;

interface

uses
  Rick.UIBuilder.Edit.InputRules,
  Rick.UIBuilder.Edit.Interfaces,
  Rick.UIBuilder.Edit.Types;

type
  TRickUIBuilderEditDesignerInputConfig = class(TInterfacedObject, IRickUIBuilderEditDesignerInputConfig)
  private
    [weak]
    FParent: IRickUIBuilderEditDesignerInput;
    FInputRules: TRickUIBuilderEditInputRules;
  protected
    constructor Create(const AParent: IRickUIBuilderEditDesignerInput; AInputRules: TRickUIBuilderEditInputRules);

    function Preset(AValue: TRickUIBuilderEditPreset): IRickUIBuilderEditDesignerInputConfig;
    function CaseMode(AValue: TRickUIBuilderEditCaseMode): IRickUIBuilderEditDesignerInputConfig;
    function UrlCaseMode(AValue: TRickUIBuilderEditUrlCaseMode): IRickUIBuilderEditDesignerInputConfig;
    function MaxLength(AValue: Integer): IRickUIBuilderEditDesignerInputConfig;
    function ToBack: IRickUIBuilderEditDesignerInput;
  public
    class function New(const AParent: IRickUIBuilderEditDesignerInput; AInputRules: TRickUIBuilderEditInputRules): IRickUIBuilderEditDesignerInputConfig;
  end;

implementation

uses
  System.SysUtils;

constructor TRickUIBuilderEditDesignerInputConfig.Create(const AParent: IRickUIBuilderEditDesignerInput; AInputRules: TRickUIBuilderEditInputRules);
begin
  inherited Create;
  FParent := AParent;
  FInputRules := AInputRules;
end;

class function TRickUIBuilderEditDesignerInputConfig.New(const AParent: IRickUIBuilderEditDesignerInput; AInputRules: TRickUIBuilderEditInputRules): IRickUIBuilderEditDesignerInputConfig;
begin
  Result := Self.Create(AParent, AInputRules);
end;

function TRickUIBuilderEditDesignerInputConfig.Preset(AValue: TRickUIBuilderEditPreset): IRickUIBuilderEditDesignerInputConfig;
begin
  FInputRules.SetPreset(AValue);
  Result := Self;
end;

function TRickUIBuilderEditDesignerInputConfig.CaseMode(AValue: TRickUIBuilderEditCaseMode): IRickUIBuilderEditDesignerInputConfig;
begin
  FInputRules.SetCaseMode(AValue);
  Result := Self;
end;

function TRickUIBuilderEditDesignerInputConfig.UrlCaseMode(AValue: TRickUIBuilderEditUrlCaseMode): IRickUIBuilderEditDesignerInputConfig;
begin
  FInputRules.SetUrlCaseMode(AValue);
  Result := Self;
end;

function TRickUIBuilderEditDesignerInputConfig.MaxLength(AValue: Integer): IRickUIBuilderEditDesignerInputConfig;
begin
  FInputRules.MaxLength := AValue;
  Result := Self;
end;

function TRickUIBuilderEditDesignerInputConfig.ToBack: IRickUIBuilderEditDesignerInput;
begin
  if not Assigned(FParent) then
    raise Exception.Create('O Parent da interface não foi informado para retornar.');
  Result := FParent;
end;

end.
