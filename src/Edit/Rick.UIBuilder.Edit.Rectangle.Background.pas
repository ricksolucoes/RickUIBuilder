unit Rick.UIBuilder.Edit.Rectangle.Background;

interface

uses
  FMX.Objects,
  System.UITypes,

  Rick.UIBuilder.Edit.Interfaces;

type
  TRickUIBuilderEditRetangleBackground = class(TInterfacedObject, IRickUIBuilderEditRetangleBackground)
  private
    [weak]
    FParent: IRickUIBuilderEditRetangle;
    FControl: TRectangle;
    FNormalColor: TAlphaColor;
    FInvalidColor: TAlphaColor;
    FReadOnlyColor: TAlphaColor;
  protected
    constructor Create(const AParent: IRickUIBuilderEditRetangle; AControl: TRectangle);

    function Normal(AValue: TAlphaColor): IRickUIBuilderEditRetangleBackground;
    function Invalid(AValue: TAlphaColor): IRickUIBuilderEditRetangleBackground;
    function ReadOnly(AValue: TAlphaColor): IRickUIBuilderEditRetangleBackground;
    function ToBack: IRickUIBuilderEditRetangle;
  public
    class function New(const AParent: IRickUIBuilderEditRetangle; AControl: TRectangle): IRickUIBuilderEditRetangleBackground;
  end;

implementation

uses
  System.SysUtils;

constructor TRickUIBuilderEditRetangleBackground.Create(const AParent: IRickUIBuilderEditRetangle; AControl: TRectangle);
begin
  inherited Create;
  FParent := AParent;
  FControl := AControl;
  FNormalColor := TAlphaColors.White;
  FInvalidColor := $FFFFF0F0;
  FReadOnlyColor := $FFF7F7F7;
  FControl.Fill.Color := FNormalColor;
end;

class function TRickUIBuilderEditRetangleBackground.New(const AParent: IRickUIBuilderEditRetangle; AControl: TRectangle): IRickUIBuilderEditRetangleBackground;
begin
  Result := Self.Create(AParent, AControl);
end;

function TRickUIBuilderEditRetangleBackground.Normal(AValue: TAlphaColor): IRickUIBuilderEditRetangleBackground;
begin
  FNormalColor := AValue;
  FControl.Fill.Color := AValue;
  Result := Self;
end;

function TRickUIBuilderEditRetangleBackground.Invalid(AValue: TAlphaColor): IRickUIBuilderEditRetangleBackground;
begin
  FInvalidColor := AValue;
  Result := Self;
end;

function TRickUIBuilderEditRetangleBackground.ReadOnly(AValue: TAlphaColor): IRickUIBuilderEditRetangleBackground;
begin
  FReadOnlyColor := AValue;
  Result := Self;
end;

function TRickUIBuilderEditRetangleBackground.ToBack: IRickUIBuilderEditRetangle;
begin
  if not Assigned(FParent) then
    raise Exception.Create('O Parent da interface não foi informado para retornar.');
  Result := FParent;
end;

end.
