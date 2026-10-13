unit Rick.UIBuilder.Edit.Builder;

interface

uses
  FMX.Objects,
  FMX.Types,

  Rick.UIBuilder.Edit.Interfaces,
  Rick.UIBuilder.Edit.VisualState;

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
    FVisualState: TRickUIBuilderEditVisualState;
    procedure PrepareVisualState;
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
  FVisualState := TRickUIBuilderEditVisualState.Create(nil);
  FBuilt := False;
end;

destructor TRickUIBuilderEdit.Destroy;
begin
  if (not FBuilt) and Assigned(FRootControl) then
  begin
    FRootControl.Free;
    FVisualState := nil;
  end
  else if Assigned(FVisualState) and not Assigned(FVisualState.Owner) then
    FVisualState.Free;
  FVisualState := nil;
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
    FRectangle := TRickUIBuilderEditRetangle.New(Self, FVisualState);
    FRootControl := FRectangle.Control;
    FVisualState.Attach(FRootControl);
  end;
  Result := FRectangle;
end;

function TRickUIBuilderEdit.Labels: IRickUIBuilderEditLabel;
begin
  if not Assigned(FLabels) then
    FLabels := TRickUIBuilderEditLabel.New(Self, Rectangle.Control, FVisualState);
  Result := FLabels;
end;

function TRickUIBuilderEdit.Designer: IRickUIBuilderEditDesigner;
begin
  if not Assigned(FDesigner) then
    FDesigner := TRickUIBuilderEditDesigner.New(Self, Rectangle.Control, FVisualState);
  Result := FDesigner;
end;

function TRickUIBuilderEdit.Line: IRickUIBuilderEditLine;
begin
  if not Assigned(FLine) then
    FLine := TRickUIBuilderEditLine.New(Self, Rectangle.Control, FVisualState);
  Result := FLine;
end;

function TRickUIBuilderEdit.Config: IRickUIBuilderEditConfig;
begin
  if not Assigned(FConfig) then
    FConfig := TRickUIBuilderEditConfig.New(Self, Rectangle.Control);
  Result := FConfig;
end;

function TRickUIBuilderEdit.Parent(AParentConstructor: TFmxObject): IRickUIBuilderEdit;
begin
  FParentConstructor := AParentConstructor;
  Result := Self;
end;

procedure TRickUIBuilderEdit.PrepareVisualState;
begin
  Rectangle.Background;
  Rectangle.Border;
  Labels.Main.Text.Color;
  Designer.Input.Text.Color;
  Line.Color;
  FVisualState.Apply;
end;

function TRickUIBuilderEdit.Build: IRickUIBuilderEdit;
begin
  Rectangle;
  Labels;
  Designer;
  Line;
  Config;
  PrepareVisualState;
  if Assigned(FParentConstructor) then
  begin
    FRootControl.Parent := FParentConstructor;
    FBuilt := True;
  end;
  Result := Self;
end;

end.
