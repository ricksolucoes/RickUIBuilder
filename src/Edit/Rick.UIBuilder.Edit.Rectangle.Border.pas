unit Rick.UIBuilder.Edit.Rectangle.Border;

interface

uses
  FMX.Objects,
  System.UITypes,

  Rick.UIBuilder.Edit.Interfaces;

type
  TRickUIBuilderEditRetangleBorder = class(TInterfacedObject, IRickUIBuilderEditRetangleBorder)
  private
    [weak]
    FParent: IRickUIBuilderEditRetangle;
    FControl: TRectangle;
    FNormalColor: TAlphaColor;
    FFocusColor: TAlphaColor;
    FInvalidColor: TAlphaColor;
    FReadOnlyColor: TAlphaColor;
  protected
    constructor Create(const AParent: IRickUIBuilderEditRetangle; AControl: TRectangle);

    function Thickness(AValue: Single): IRickUIBuilderEditRetangleBorder;
    function Normal(AValue: TAlphaColor): IRickUIBuilderEditRetangleBorder;
    function Focus(AValue: TAlphaColor): IRickUIBuilderEditRetangleBorder;
    function Invalid(AValue: TAlphaColor): IRickUIBuilderEditRetangleBorder;
    function ReadOnly(AValue: TAlphaColor): IRickUIBuilderEditRetangleBorder;
    function ToBack: IRickUIBuilderEditRetangle;
  public
    class function New(const AParent: IRickUIBuilderEditRetangle; AControl: TRectangle): IRickUIBuilderEditRetangleBorder;
  end;

implementation

uses
  System.SysUtils;

constructor TRickUIBuilderEditRetangleBorder.Create(const AParent: IRickUIBuilderEditRetangle; AControl: TRectangle);
begin
  inherited Create;
  FParent := AParent;
  FControl := AControl;
  FNormalColor := $FFB0B0B0;
  FFocusColor := TAlphaColors.Black;
  FInvalidColor := $FFD93025;
  FReadOnlyColor := $FFD8D8D8;
end;

class function TRickUIBuilderEditRetangleBorder.New(const AParent: IRickUIBuilderEditRetangle; AControl: TRectangle): IRickUIBuilderEditRetangleBorder;
begin
  Result := Self.Create(AParent, AControl);
end;

function TRickUIBuilderEditRetangleBorder.Thickness(AValue: Single): IRickUIBuilderEditRetangleBorder;
begin
  FControl.Stroke.Thickness := AValue;
  Result := Self;
end;

function TRickUIBuilderEditRetangleBorder.Normal(AValue: TAlphaColor): IRickUIBuilderEditRetangleBorder;
begin
  FNormalColor := AValue;
  FControl.Stroke.Color := AValue;
  Result := Self;
end;

function TRickUIBuilderEditRetangleBorder.Focus(AValue: TAlphaColor): IRickUIBuilderEditRetangleBorder;
begin
  FFocusColor := AValue;
  Result := Self;
end;

function TRickUIBuilderEditRetangleBorder.Invalid(AValue: TAlphaColor): IRickUIBuilderEditRetangleBorder;
begin
  FInvalidColor := AValue;
  Result := Self;
end;

function TRickUIBuilderEditRetangleBorder.ReadOnly(AValue: TAlphaColor): IRickUIBuilderEditRetangleBorder;
begin
  FReadOnlyColor := AValue;
  Result := Self;
end;

function TRickUIBuilderEditRetangleBorder.ToBack: IRickUIBuilderEditRetangle;
begin
  if not Assigned(FParent) then
    raise Exception.Create('O Parent da interface não foi informado para retornar.');
  Result := FParent;
end;

end.
