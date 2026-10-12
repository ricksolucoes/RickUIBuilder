unit Rick.UIBuilder.Edit.Rectangle;

interface

uses
  FMX.Objects,

  Rick.UIBuilder.Edit.Interfaces,
  Rick.UIBuilder.Edit.VisualState;

type
  TRickUIBuilderEditRetangle = class(TInterfacedObject, IRickUIBuilderEditRetangle)
  private
    [weak]
    FParent: IRickUIBuilderEdit;
    FControl: TRectangle;
    FVisualState: TRickUIBuilderEditVisualState;
    FPosition: IRickUIBuilderEditRetanglePosition;
    FSize: IRickUIBuilderEditRetangleSize;
    FBackground: IRickUIBuilderEditRetangleBackground;
    FBorder: IRickUIBuilderEditRetangleBorder;
  protected
    constructor Create(const AParent: IRickUIBuilderEdit; AVisualState: TRickUIBuilderEditVisualState);

    function Position: IRickUIBuilderEditRetanglePosition;
    function Size: IRickUIBuilderEditRetangleSize;
    function Background: IRickUIBuilderEditRetangleBackground;
    function Border: IRickUIBuilderEditRetangleBorder;
    function CornerRadius(AValue: Single): IRickUIBuilderEditRetangle;
    function Control: TRectangle;
    function ToBack: IRickUIBuilderEdit;
  public
    class function New(const AParent: IRickUIBuilderEdit; AVisualState: TRickUIBuilderEditVisualState): IRickUIBuilderEditRetangle;
  end;

implementation

uses
  System.SysUtils,
  System.UITypes,

  Rick.UIBuilder.Edit.Rectangle.Background,
  Rick.UIBuilder.Edit.Rectangle.Border,
  Rick.UIBuilder.Edit.Rectangle.Position,
  Rick.UIBuilder.Edit.Rectangle.Size;

constructor TRickUIBuilderEditRetangle.Create(const AParent: IRickUIBuilderEdit; AVisualState: TRickUIBuilderEditVisualState);
begin
  inherited Create;
  FParent := AParent;
  FVisualState := AVisualState;
  FControl := TRectangle.Create(nil);
  FControl.SetBounds(0, 0, 280, 72);
  FControl.Fill.Color := TAlphaColors.White;
  FControl.Stroke.Color := $FFB0B0B0;
  FControl.Stroke.Thickness := 1;
  FControl.XRadius := 8;
  FControl.YRadius := 8;
end;

class function TRickUIBuilderEditRetangle.New(const AParent: IRickUIBuilderEdit; AVisualState: TRickUIBuilderEditVisualState): IRickUIBuilderEditRetangle;
begin
  Result := Self.Create(AParent, AVisualState);
end;

function TRickUIBuilderEditRetangle.Position: IRickUIBuilderEditRetanglePosition;
begin
  if not Assigned(FPosition) then
    FPosition := TRickUIBuilderEditRetanglePosition.New(Self, FControl);
  Result := FPosition;
end;

function TRickUIBuilderEditRetangle.Size: IRickUIBuilderEditRetangleSize;
begin
  if not Assigned(FSize) then
    FSize := TRickUIBuilderEditRetangleSize.New(Self, FControl);
  Result := FSize;
end;

function TRickUIBuilderEditRetangle.Background: IRickUIBuilderEditRetangleBackground;
begin
  if not Assigned(FBackground) then
    FBackground := TRickUIBuilderEditRetangleBackground.New(Self, FControl, FVisualState);
  Result := FBackground;
end;

function TRickUIBuilderEditRetangle.Border: IRickUIBuilderEditRetangleBorder;
begin
  if not Assigned(FBorder) then
    FBorder := TRickUIBuilderEditRetangleBorder.New(Self, FControl, FVisualState);
  Result := FBorder;
end;

function TRickUIBuilderEditRetangle.CornerRadius(AValue: Single): IRickUIBuilderEditRetangle;
begin
  FControl.XRadius := AValue;
  FControl.YRadius := AValue;
  Result := Self;
end;

function TRickUIBuilderEditRetangle.Control: TRectangle;
begin
  Result := FControl;
end;

function TRickUIBuilderEditRetangle.ToBack: IRickUIBuilderEdit;
begin
  if not Assigned(FParent) then
    raise Exception.Create('O Parent da interface não foi informado para retornar.');
  Result := FParent;
end;

end.
