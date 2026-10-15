unit Rick.UIBuilder.Edit.Builder;

interface

uses
  FMX.Objects,
  FMX.Types,

  Rick.UIBuilder.Edit.Interfaces;

type
  TRickUIBuilderEdit = class(TInterfacedObject, IRickUIBuilderEdit)
  private
    FParentConstructor: TFmxObject;
    FRootControl: TRectangle;
    FBuilt: Boolean;
    FRectangle: IRickUIBuilderEditRetangle;
    FLabels: IRickUIBuilderEditLabel;
    FDesigner: IRickUIBuilderEditDesigner;
    FLine: IRickUIBuilderEditLine;
    FConfig: IRickUIBuilderEditConfig;
    FPaths: array[0..5] of TPath;
    procedure EnsureSharedControls;
    procedure CreateSharedPaths;
    procedure PrepareVisualAppearance;
  protected
    constructor Create;

    function Rectangle: IRickUIBuilderEditRetangle;
    function Labels: IRickUIBuilderEditLabel;
    function Designer: IRickUIBuilderEditDesigner;
    function Line: IRickUIBuilderEditLine;
    function Config: IRickUIBuilderEditConfig;
    function Parent(AParentConstructor: TFmxObject): IRickUIBuilderEdit;
    function Build: IRickUIBuilderEdit;
  public
    destructor Destroy; override;
    class function New: IRickUIBuilderEdit;
  end;

implementation

uses
  Rick.UIBuilder.Edit.Config,
  Rick.UIBuilder.Edit.Designer,
  Rick.UIBuilder.Edit.Labels,
  Rick.UIBuilder.Edit.Line,
  Rick.UIBuilder.Edit.Rectangle;

constructor TRickUIBuilderEdit.Create;
begin
  inherited Create;
  FParentConstructor := nil;
  FRootControl := nil;
  FBuilt := False;
end;

destructor TRickUIBuilderEdit.Destroy;
begin
  FConfig := nil;
  FLine := nil;
  FLabels := nil;
  FDesigner := nil;
  FRectangle := nil;
  if (not FBuilt) and Assigned(FRootControl) then
    FRootControl.Free;
  FRootControl := nil;
  inherited;
end;

class function TRickUIBuilderEdit.New: IRickUIBuilderEdit;
begin
  Result := Self.Create;
end;

function TRickUIBuilderEdit.Rectangle: IRickUIBuilderEditRetangle;
begin
  if not Assigned(FRectangle) then
  begin
    FRectangle := TRickUIBuilderEditRetangle.New(Self);
    FRootControl := FRectangle.Control;
  end;
  Result := FRectangle;
end;

procedure TRickUIBuilderEdit.CreateSharedPaths;
var
  LIndex: Integer;
begin
  for LIndex := Low(FPaths) to High(FPaths) do
  begin
    FPaths[LIndex] := TPath.Create(FRootControl);
    FPaths[LIndex].Parent := FRootControl;
    FPaths[LIndex].Visible := False;
  end;
end;

procedure TRickUIBuilderEdit.EnsureSharedControls;
begin
  Rectangle;
  if not Assigned(FPaths[0]) then
    CreateSharedPaths;
end;

function TRickUIBuilderEdit.Designer: IRickUIBuilderEditDesigner;
begin
  if not Assigned(FDesigner) then
  begin
    EnsureSharedControls;
    FDesigner := TRickUIBuilderEditDesigner.New(Self, FRootControl, FPaths);
  end;
  Result := FDesigner;
end;

function TRickUIBuilderEdit.Labels: IRickUIBuilderEditLabel;
begin
  if not Assigned(FLabels) then
  begin
    EnsureSharedControls;
    FLabels := TRickUIBuilderEditLabel.New(Self, FRootControl, Designer.Control,
      Designer.Validation);
  end;
  Result := FLabels;
end;

function TRickUIBuilderEdit.Line: IRickUIBuilderEditLine;
begin
  if not Assigned(FLine) then
  begin
    EnsureSharedControls;
    FLine := TRickUIBuilderEditLine.New(Self, FRootControl, Designer.Control,
      Designer.Validation);
  end;
  Result := FLine;
end;

function TRickUIBuilderEdit.Config: IRickUIBuilderEditConfig;
begin
  if not Assigned(FConfig) then
  begin
    EnsureSharedControls;
    FConfig := TRickUIBuilderEditConfig.New(Self, FRootControl, FPaths);
  end;
  Result := FConfig;
end;

function TRickUIBuilderEdit.Parent(AParentConstructor: TFmxObject): IRickUIBuilderEdit;
begin
  FParentConstructor := AParentConstructor;
  Result := Self;
end;

procedure TRickUIBuilderEdit.PrepareVisualAppearance;
begin
  Rectangle.Background;
  Rectangle.Border;
  Labels.Main.Text.Color;
  Designer.Input.Text.Color;
  Line.Color;
  if Assigned(Designer.Control.OnEnter) then
    Designer.Control.OnEnter(nil);
end;

function TRickUIBuilderEdit.Build: IRickUIBuilderEdit;
begin
  Rectangle;
  Designer;
  Labels;
  Line;
  Config;
  PrepareVisualAppearance;
  if Assigned(FParentConstructor) then
  begin
    FRootControl.Parent := FParentConstructor;
    FBuilt := True;
  end;
  Result := Self;
end;

end.
