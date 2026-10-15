unit Rick.UIBuilder.Edit.Line;

interface

uses
  FMX.Objects,

  Rick.UIBuilder.Edit.Interfaces;

type
  TRickUIBuilderEditLine = class(TInterfacedObject, IRickUIBuilderEditLine)
  private
    [weak]
    FParent: IRickUIBuilderEdit;
    FControl: TRectangle;
    FColor: IRickUIBuilderEditLineColor;
  protected
    constructor Create(const AParent: IRickUIBuilderEdit; AHost: TRectangle);

    function Thickness(AValue: Single): IRickUIBuilderEditLine;
    function Color: IRickUIBuilderEditLineColor;
    function ToBack: IRickUIBuilderEdit;
  public
    class function New(const AParent: IRickUIBuilderEdit;
      AHost: TRectangle): IRickUIBuilderEditLine;
  end;

implementation

uses
  FMX.Graphics,
  FMX.Types,
  System.SysUtils,

  Rick.UIBuilder.Edit.Line.Color;

constructor TRickUIBuilderEditLine.Create(const AParent: IRickUIBuilderEdit;
  AHost: TRectangle);
begin
  inherited Create;
  FParent := AParent;
  FControl := TRectangle.Create(AHost);
  FControl.Parent := AHost;
  FControl.SetBounds(8, 47, AHost.Width - 16, 1);
  FControl.Fill.Color := $FFB0B0B0;
  FControl.Stroke.Kind := TBrushKind.None;
  FControl.HitTest := False;
  FControl.Visible := False;
end;

class function TRickUIBuilderEditLine.New(const AParent: IRickUIBuilderEdit;
  AHost: TRectangle): IRickUIBuilderEditLine;
begin
  Result := Self.Create(AParent, AHost);
end;

function TRickUIBuilderEditLine.Thickness(AValue: Single): IRickUIBuilderEditLine;
begin
  FControl.Height := AValue;
  Result := Self;
end;

function TRickUIBuilderEditLine.Color: IRickUIBuilderEditLineColor;
begin
  if not Assigned(FColor) then
    FColor := TRickUIBuilderEditLineColor.New(Self, FControl);
  Result := FColor;
end;

function TRickUIBuilderEditLine.ToBack: IRickUIBuilderEdit;
begin
  if not Assigned(FParent) then
    raise Exception.Create('O Parent da interface não foi informado para retornar.');
  Result := FParent;
end;

end.
