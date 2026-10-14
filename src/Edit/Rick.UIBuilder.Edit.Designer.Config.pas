unit Rick.UIBuilder.Edit.Designer.Config;

interface

uses
  Rick.UIBuilder.Edit.InputRules,
  Rick.UIBuilder.Edit.Interfaces,
  Rick.UIBuilder.Edit.VisualState;

type
  TRickUIBuilderEditDesignerConfig = class(TInterfacedObject, IRickUIBuilderEditDesignerConfig)
  private
    [weak]
    FParent: IRickUIBuilderEditDesigner;
    FControl: TRickUIBuilderEditInputRules;
    FVisualState: TRickUIBuilderEditVisualState;
  protected
    constructor Create(const AParent: IRickUIBuilderEditDesigner; AControl: TRickUIBuilderEditInputRules; AVisualState: TRickUIBuilderEditVisualState);

    function ClearButton(AValue: Boolean): IRickUIBuilderEditDesignerConfig; overload;
    function ClearButton: IRickUIBuilderEditDesignerConfig; overload;
    function Password(AValue: Boolean): IRickUIBuilderEditDesignerConfig; overload;
    function Password: IRickUIBuilderEditDesignerConfig; overload;
    function ReadOnly(AValue: Boolean): IRickUIBuilderEditDesignerConfig; overload;
    function ReadOnly: IRickUIBuilderEditDesignerConfig; overload;
    function ToBack: IRickUIBuilderEditDesigner;
  public
    class function New(const AParent: IRickUIBuilderEditDesigner; AControl: TRickUIBuilderEditInputRules; AVisualState: TRickUIBuilderEditVisualState): IRickUIBuilderEditDesignerConfig;
  end;

implementation

uses
  System.SysUtils;

constructor TRickUIBuilderEditDesignerConfig.Create(const AParent: IRickUIBuilderEditDesigner; AControl: TRickUIBuilderEditInputRules; AVisualState: TRickUIBuilderEditVisualState);
begin
  inherited Create;
  FParent := AParent;
  FControl := AControl;
  FVisualState := AVisualState;
end;

class function TRickUIBuilderEditDesignerConfig.New(const AParent: IRickUIBuilderEditDesigner; AControl: TRickUIBuilderEditInputRules; AVisualState: TRickUIBuilderEditVisualState): IRickUIBuilderEditDesignerConfig;
begin
  Result := Self.Create(AParent, AControl, AVisualState);
end;

function TRickUIBuilderEditDesignerConfig.ClearButton(AValue: Boolean): IRickUIBuilderEditDesignerConfig;
begin
  FControl.SetClearButtonEnabled(AValue);
  Result := Self;
end;

function TRickUIBuilderEditDesignerConfig.ClearButton: IRickUIBuilderEditDesignerConfig;
begin
  Result := ClearButton(True);
end;

function TRickUIBuilderEditDesignerConfig.Password(AValue: Boolean): IRickUIBuilderEditDesignerConfig;
begin
  FControl.SetPasswordEnabled(AValue);
  Result := Self;
end;

function TRickUIBuilderEditDesignerConfig.Password: IRickUIBuilderEditDesignerConfig;
begin
  Result := Password(True);
end;

function TRickUIBuilderEditDesignerConfig.ReadOnly(AValue: Boolean): IRickUIBuilderEditDesignerConfig;
begin
  FControl.SetReadOnlyValue(AValue);
  FVisualState.SetReadOnly(AValue);
  Result := Self;
end;

function TRickUIBuilderEditDesignerConfig.ReadOnly: IRickUIBuilderEditDesignerConfig;
begin
  Result := ReadOnly(True);
end;

function TRickUIBuilderEditDesignerConfig.ToBack: IRickUIBuilderEditDesigner;
begin
  if not Assigned(FParent) then
    raise Exception.Create('O Parent da interface não foi informado para retornar.');
  Result := FParent;
end;

end.
