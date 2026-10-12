unit Rick.UIBuilder.Edit.Designer.Config;

interface

uses
  FMX.Edit,

  Rick.UIBuilder.Edit.Interfaces;

type
  TRickUIBuilderEditDesignerConfig = class(TInterfacedObject, IRickUIBuilderEditDesignerConfig)
  private
    [weak]
    FParent: IRickUIBuilderEditDesigner;
    FControl: TEdit;
    FClearButton: Boolean;
    FPassword: Boolean;
    FReadOnly: Boolean;
  protected
    constructor Create(const AParent: IRickUIBuilderEditDesigner; AControl: TEdit);

    function ClearButton(AValue: Boolean): IRickUIBuilderEditDesignerConfig; overload;
    function ClearButton: IRickUIBuilderEditDesignerConfig; overload;
    function Password(AValue: Boolean): IRickUIBuilderEditDesignerConfig; overload;
    function Password: IRickUIBuilderEditDesignerConfig; overload;
    function ReadOnly(AValue: Boolean): IRickUIBuilderEditDesignerConfig; overload;
    function ReadOnly: IRickUIBuilderEditDesignerConfig; overload;
    function ToBack: IRickUIBuilderEditDesigner;
  public
    class function New(const AParent: IRickUIBuilderEditDesigner; AControl: TEdit): IRickUIBuilderEditDesignerConfig;
  end;

implementation

uses
  System.SysUtils;

constructor TRickUIBuilderEditDesignerConfig.Create(const AParent: IRickUIBuilderEditDesigner; AControl: TEdit);
begin
  inherited Create;
  FParent := AParent;
  FControl := AControl;
  FClearButton := False;
  FPassword := False;
  FReadOnly := False;
end;

class function TRickUIBuilderEditDesignerConfig.New(const AParent: IRickUIBuilderEditDesigner; AControl: TEdit): IRickUIBuilderEditDesignerConfig;
begin
  Result := Self.Create(AParent, AControl);
end;

function TRickUIBuilderEditDesignerConfig.ClearButton(AValue: Boolean): IRickUIBuilderEditDesignerConfig;
begin
  FClearButton := AValue;
  Result := Self;
end;

function TRickUIBuilderEditDesignerConfig.ClearButton: IRickUIBuilderEditDesignerConfig;
begin
  Result := ClearButton(True);
end;

function TRickUIBuilderEditDesignerConfig.Password(AValue: Boolean): IRickUIBuilderEditDesignerConfig;
begin
  FPassword := AValue;
  FControl.Password := AValue;
  Result := Self;
end;

function TRickUIBuilderEditDesignerConfig.Password: IRickUIBuilderEditDesignerConfig;
begin
  Result := Password(True);
end;

function TRickUIBuilderEditDesignerConfig.ReadOnly(AValue: Boolean): IRickUIBuilderEditDesignerConfig;
begin
  FReadOnly := AValue;
  FControl.ReadOnly := AValue;
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
