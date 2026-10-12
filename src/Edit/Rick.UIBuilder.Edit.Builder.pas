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
    FEdit: IRickUIBuilderEditDesigner;
    FLine: IRickUIBuilderEditLine;
    FConfig: IRickUIBuilderEditConfig;
  protected
    constructor Create;

    function Rectangle: IRickUIBuilderEditRetangle;
    function Labels: IRickUIBuilderEditLabel;
    function Edit: IRickUIBuilderEditDesigner;
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

function TRickUIBuilderEdit.Labels: IRickUIBuilderEditLabel;
begin
  if not Assigned(FLabels) then
    FLabels := TRickUIBuilderEditLabel.New(Self, Rectangle.Control);
  Result := FLabels;
end;

function TRickUIBuilderEdit.Edit: IRickUIBuilderEditDesigner;
begin
  if not Assigned(FEdit) then
    FEdit := TRickUIBuilderEditDesigner.New(Self, Rectangle.Control);
  Result := FEdit;
end;

function TRickUIBuilderEdit.Line: IRickUIBuilderEditLine;
begin
  if not Assigned(FLine) then
    FLine := TRickUIBuilderEditLine.New(Self, Rectangle.Control);
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

function TRickUIBuilderEdit.Build: IRickUIBuilderEdit;
begin
  Rectangle;
  Labels;
  Edit;
  Line;
  Config;
  if Assigned(FParentConstructor) then
  begin
    FRootControl.Parent := FParentConstructor;
    FBuilt := True;
  end;
  Result := Self;
end;

end.
