unit Rick.UIBuilder.Edit.Line.Color;

interface

uses
  FMX.Objects,
  System.UITypes,

  Rick.UIBuilder.Edit.Interfaces;

type
  TRickUIBuilderEditLineColor = class(TInterfacedObject, IRickUIBuilderEditLineColor)
  private
    [weak]
    FParent: IRickUIBuilderEditLine;
    FControl: TRectangle;
    FNormalColor: TAlphaColor;
    FFocusColor: TAlphaColor;
    FInvalidColor: TAlphaColor;
    FReadOnlyColor: TAlphaColor;
  protected
    constructor Create(const AParent: IRickUIBuilderEditLine; AControl: TRectangle);

    function Normal(AValue: TAlphaColor): IRickUIBuilderEditLineColor;
    function Focus(AValue: TAlphaColor): IRickUIBuilderEditLineColor;
    function Invalid(AValue: TAlphaColor): IRickUIBuilderEditLineColor;
    function ReadOnly(AValue: TAlphaColor): IRickUIBuilderEditLineColor;
    function ToBack: IRickUIBuilderEditLine;
  public
    class function New(const AParent: IRickUIBuilderEditLine; AControl: TRectangle): IRickUIBuilderEditLineColor;
  end;

implementation

uses
  System.SysUtils;

constructor TRickUIBuilderEditLineColor.Create(const AParent: IRickUIBuilderEditLine; AControl: TRectangle);
begin
  inherited Create;
  FParent := AParent;
  FControl := AControl;
  FNormalColor := $FFB0B0B0;
  FFocusColor := TAlphaColors.Black;
  FInvalidColor := $FFD93025;
  FReadOnlyColor := $FFD8D8D8;
end;

class function TRickUIBuilderEditLineColor.New(const AParent: IRickUIBuilderEditLine; AControl: TRectangle): IRickUIBuilderEditLineColor;
begin
  Result := Self.Create(AParent, AControl);
end;

function TRickUIBuilderEditLineColor.Normal(AValue: TAlphaColor): IRickUIBuilderEditLineColor;
begin
  FNormalColor := AValue;
  FControl.Fill.Color := AValue;
  Result := Self;
end;

function TRickUIBuilderEditLineColor.Focus(AValue: TAlphaColor): IRickUIBuilderEditLineColor;
begin
  FFocusColor := AValue;
  Result := Self;
end;

function TRickUIBuilderEditLineColor.Invalid(AValue: TAlphaColor): IRickUIBuilderEditLineColor;
begin
  FInvalidColor := AValue;
  Result := Self;
end;

function TRickUIBuilderEditLineColor.ReadOnly(AValue: TAlphaColor): IRickUIBuilderEditLineColor;
begin
  FReadOnlyColor := AValue;
  Result := Self;
end;

function TRickUIBuilderEditLineColor.ToBack: IRickUIBuilderEditLine;
begin
  if not Assigned(FParent) then
    raise Exception.Create('O Parent da interface não foi informado para retornar.');
  Result := FParent;
end;

end.
