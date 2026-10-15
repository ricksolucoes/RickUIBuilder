unit Rick.UIBuilder.Edit.Designer.Config;

interface

uses
  FMX.Edit,
  FMX.Objects,
  System.Classes,

  Rick.UIBuilder.Edit.Interfaces;

type
  TRickUIBuilderEditDesignerConfig = class(TComponent, IRickUIBuilderEditDesignerConfig)
  private
    [weak]
    FParent: IRickUIBuilderEditDesigner;
    FControl: TEdit;
    FClearPath: TPath;
    FVisibilityPath: TPath;
    FVisibilityOffPath: TPath;
    FClearButtonEnabled: Boolean;
    FPasswordEnabled: Boolean;
    FPreviousChangeTracking: TNotifyEvent;
    procedure HandleChangeTracking(ASender: TObject);
    procedure HandleClearClick(ASender: TObject);
    procedure HandlePasswordClick(ASender: TObject);
    procedure UpdateClearPath;
    procedure UpdatePasswordPaths;
    procedure RefreshVisuals;
  protected
    constructor Create(const AParent: IRickUIBuilderEditDesigner; AControl: TEdit;
      const APaths: array of TPath); reintroduce;

    function ClearButton(AValue: Boolean): IRickUIBuilderEditDesignerConfig; overload;
    function ClearButton: IRickUIBuilderEditDesignerConfig; overload;
    function Password(AValue: Boolean): IRickUIBuilderEditDesignerConfig; overload;
    function Password: IRickUIBuilderEditDesignerConfig; overload;
    function ReadOnly(AValue: Boolean): IRickUIBuilderEditDesignerConfig; overload;
    function ReadOnly: IRickUIBuilderEditDesignerConfig; overload;
    function ToBack: IRickUIBuilderEditDesigner;
  public
    destructor Destroy; override;
    class function New(const AParent: IRickUIBuilderEditDesigner; AControl: TEdit;
      const APaths: array of TPath): IRickUIBuilderEditDesignerConfig;
  end;

implementation

uses
  System.SysUtils;

constructor TRickUIBuilderEditDesignerConfig.Create(
  const AParent: IRickUIBuilderEditDesigner; AControl: TEdit;
  const APaths: array of TPath);
begin
  inherited Create(AControl);
  FParent := AParent;
  FControl := AControl;
  FClearPath := APaths[1];
  FVisibilityPath := APaths[2];
  FVisibilityOffPath := APaths[3];
  FClearButtonEnabled := False;
  FPasswordEnabled := False;
  FPreviousChangeTracking := FControl.OnChangeTracking;
  FControl.OnChangeTracking := HandleChangeTracking;
  FClearPath.OnClick := HandleClearClick;
  FVisibilityPath.OnClick := HandlePasswordClick;
  FVisibilityOffPath.OnClick := HandlePasswordClick;
  FClearPath.HitTest := True;
  FVisibilityPath.HitTest := True;
  FVisibilityOffPath.HitTest := True;
  UpdateClearPath;
  UpdatePasswordPaths;
end;

destructor TRickUIBuilderEditDesignerConfig.Destroy;
begin
  if Assigned(FControl) and not (csDestroying in FControl.ComponentState) then
    FControl.OnChangeTracking := FPreviousChangeTracking;
  inherited;
end;

class function TRickUIBuilderEditDesignerConfig.New(
  const AParent: IRickUIBuilderEditDesigner; AControl: TEdit;
  const APaths: array of TPath): IRickUIBuilderEditDesignerConfig;
begin
  Result := Self.Create(AParent, AControl, APaths);
end;

procedure TRickUIBuilderEditDesignerConfig.HandleChangeTracking(ASender: TObject);
begin
  if Assigned(FPreviousChangeTracking) then
    FPreviousChangeTracking(ASender);
  UpdateClearPath;
end;

procedure TRickUIBuilderEditDesignerConfig.HandleClearClick(ASender: TObject);
begin
  if not FClearButtonEnabled or FControl.ReadOnly then
    Exit;
  FControl.Text := EmptyStr;
  FControl.SetFocus;
end;

procedure TRickUIBuilderEditDesignerConfig.HandlePasswordClick(ASender: TObject);
begin
  if not FPasswordEnabled then
    Exit;
  FControl.Password := not FControl.Password;
  UpdatePasswordPaths;
  FControl.SetFocus;
end;

procedure TRickUIBuilderEditDesignerConfig.UpdateClearPath;
begin
  FClearPath.Visible := FClearButtonEnabled and not FControl.ReadOnly and
    (FControl.Text <> EmptyStr);
end;

procedure TRickUIBuilderEditDesignerConfig.UpdatePasswordPaths;
begin
  FVisibilityPath.Visible := FPasswordEnabled and not FControl.Password;
  FVisibilityOffPath.Visible := FPasswordEnabled and FControl.Password;
end;

procedure TRickUIBuilderEditDesignerConfig.RefreshVisuals;
begin
  if Assigned(FControl.OnEnter) then
    FControl.OnEnter(nil);
end;

function TRickUIBuilderEditDesignerConfig.ClearButton(
  AValue: Boolean): IRickUIBuilderEditDesignerConfig;
begin
  FClearButtonEnabled := AValue;
  UpdateClearPath;
  Result := Self;
end;

function TRickUIBuilderEditDesignerConfig.ClearButton: IRickUIBuilderEditDesignerConfig;
begin
  Result := ClearButton(True);
end;

function TRickUIBuilderEditDesignerConfig.Password(
  AValue: Boolean): IRickUIBuilderEditDesignerConfig;
begin
  FPasswordEnabled := AValue;
  FControl.Password := AValue;
  UpdatePasswordPaths;
  Result := Self;
end;

function TRickUIBuilderEditDesignerConfig.Password: IRickUIBuilderEditDesignerConfig;
begin
  Result := Password(True);
end;

function TRickUIBuilderEditDesignerConfig.ReadOnly(
  AValue: Boolean): IRickUIBuilderEditDesignerConfig;
begin
  FControl.ReadOnly := AValue;
  UpdateClearPath;
  RefreshVisuals;
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
