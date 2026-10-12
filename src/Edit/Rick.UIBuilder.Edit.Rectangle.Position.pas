unit Rick.UIBuilder.Edit.Rectangle.Position;

interface

uses
  FMX.Objects,

  Rick.UIBuilder.Edit.Interfaces;

type
  TRickUIBuilderEditRetanglePosition = class(TInterfacedObject, IRickUIBuilderEditRetanglePosition)
  private
    [weak]
    FParent: IRickUIBuilderEditRetangle;
    FControl: TRectangle;
  protected
    constructor Create(const AParent: IRickUIBuilderEditRetangle; AControl: TRectangle);

    function Left(AValue: Single): IRickUIBuilderEditRetanglePosition;
    function Top(AValue: Single): IRickUIBuilderEditRetanglePosition;
    function ToBack: IRickUIBuilderEditRetangle;
  public
    class function New(const AParent: IRickUIBuilderEditRetangle; AControl: TRectangle): IRickUIBuilderEditRetanglePosition;
  end;

implementation

uses
  System.SysUtils;

constructor TRickUIBuilderEditRetanglePosition.Create(const AParent: IRickUIBuilderEditRetangle; AControl: TRectangle);
begin
  inherited Create;
  FParent := AParent;
  FControl := AControl;
end;

class function TRickUIBuilderEditRetanglePosition.New(const AParent: IRickUIBuilderEditRetangle; AControl: TRectangle): IRickUIBuilderEditRetanglePosition;
begin
  Result := Self.Create(AParent, AControl);
end;

function TRickUIBuilderEditRetanglePosition.Left(AValue: Single): IRickUIBuilderEditRetanglePosition;
begin
  FControl.Position.X := AValue;
  Result := Self;
end;

function TRickUIBuilderEditRetanglePosition.Top(AValue: Single): IRickUIBuilderEditRetanglePosition;
begin
  FControl.Position.Y := AValue;
  Result := Self;
end;

function TRickUIBuilderEditRetanglePosition.ToBack: IRickUIBuilderEditRetangle;
begin
  if not Assigned(FParent) then
    raise Exception.Create('O Parent da interface não foi informado para retornar.');
  Result := FParent;
end;

end.
