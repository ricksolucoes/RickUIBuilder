unit Rick.UIBuilder.Edit.Rectangle.Size;

interface

uses
  FMX.Objects,

  Rick.UIBuilder.Edit.Interfaces;

type
  TRickUIBuilderEditRetangleSize = class(TInterfacedObject, IRickUIBuilderEditRetangleSize)
  private
    [weak]
    FParent: IRickUIBuilderEditRetangle;
    FControl: TRectangle;
  protected
    constructor Create(const AParent: IRickUIBuilderEditRetangle; AControl: TRectangle);

    function Width(AValue: Single): IRickUIBuilderEditRetangleSize;
    function Height(AValue: Single): IRickUIBuilderEditRetangleSize;
    function ToBack: IRickUIBuilderEditRetangle;
  public
    class function New(const AParent: IRickUIBuilderEditRetangle; AControl: TRectangle): IRickUIBuilderEditRetangleSize;
  end;

implementation

uses
  System.SysUtils;

constructor TRickUIBuilderEditRetangleSize.Create(const AParent: IRickUIBuilderEditRetangle; AControl: TRectangle);
begin
  inherited Create;
  FParent := AParent;
  FControl := AControl;
end;

class function TRickUIBuilderEditRetangleSize.New(const AParent: IRickUIBuilderEditRetangle; AControl: TRectangle): IRickUIBuilderEditRetangleSize;
begin
  Result := Self.Create(AParent, AControl);
end;

function TRickUIBuilderEditRetangleSize.Width(AValue: Single): IRickUIBuilderEditRetangleSize;
begin
  FControl.Width := AValue;
  Result := Self;
end;

function TRickUIBuilderEditRetangleSize.Height(AValue: Single): IRickUIBuilderEditRetangleSize;
begin
  FControl.Height := AValue;
  Result := Self;
end;

function TRickUIBuilderEditRetangleSize.ToBack: IRickUIBuilderEditRetangle;
begin
  if not Assigned(FParent) then
    raise Exception.Create('O Parent da interface não foi informado para retornar.');
  Result := FParent;
end;

end.
