unit Rick.UIBuilder.Edit.Line.Color;

interface

uses
  FMX.Objects,
  System.UITypes,

  Rick.UIBuilder.Edit.Interfaces,
  Rick.UIBuilder.Edit.VisualState;

type
  TRickUIBuilderEditLineColor = class(TInterfacedObject, IRickUIBuilderEditLineColor)
  private
    [weak]
    FParent: IRickUIBuilderEditLine;
    FControl: TRectangle;
    FVisualState: TRickUIBuilderEditVisualState;
    FNormalColor: TAlphaColor;
    FFocusColor: TAlphaColor;
    FInvalidColor: TAlphaColor;
    FReadOnlyColor: TAlphaColor;
    procedure ApplyState(ASender: TObject);
  protected
    constructor Create(const AParent: IRickUIBuilderEditLine; AControl: TRectangle; AVisualState: TRickUIBuilderEditVisualState);

    function Normal(AValue: TAlphaColor): IRickUIBuilderEditLineColor;
    function Focus(AValue: TAlphaColor): IRickUIBuilderEditLineColor;
    function Invalid(AValue: TAlphaColor): IRickUIBuilderEditLineColor;
    function ReadOnly(AValue: TAlphaColor): IRickUIBuilderEditLineColor;
    function ToBack: IRickUIBuilderEditLine;
  public
    class function New(const AParent: IRickUIBuilderEditLine; AControl: TRectangle; AVisualState: TRickUIBuilderEditVisualState): IRickUIBuilderEditLineColor;
  end;

implementation

uses
  System.SysUtils;

constructor TRickUIBuilderEditLineColor.Create(const AParent: IRickUIBuilderEditLine; AControl: TRectangle; AVisualState: TRickUIBuilderEditVisualState);
begin
  inherited Create;
  FParent := AParent;
  FControl := AControl;
  FVisualState := AVisualState;
  FNormalColor := $FFB0B0B0;
  FFocusColor := TAlphaColors.Black;
  FInvalidColor := $FFD93025;
  FReadOnlyColor := $FFD8D8D8;
  FVisualState.RegisterHandler(ApplyState, AParent);
  ApplyState(nil);
end;

class function TRickUIBuilderEditLineColor.New(const AParent: IRickUIBuilderEditLine; AControl: TRectangle; AVisualState: TRickUIBuilderEditVisualState): IRickUIBuilderEditLineColor;
begin
  Result := Self.Create(AParent, AControl, AVisualState);
end;

procedure TRickUIBuilderEditLineColor.ApplyState(ASender: TObject);
begin
  if FVisualState.IsInvalid then
    FControl.Fill.Color := FInvalidColor
  else if FVisualState.IsReadOnly then
    FControl.Fill.Color := FReadOnlyColor
  else if FVisualState.IsFocused then
    FControl.Fill.Color := FFocusColor
  else
    FControl.Fill.Color := FNormalColor;
end;

function TRickUIBuilderEditLineColor.Normal(AValue: TAlphaColor): IRickUIBuilderEditLineColor;
begin
  FNormalColor := AValue;
  ApplyState(nil);
  Result := Self;
end;

function TRickUIBuilderEditLineColor.Focus(AValue: TAlphaColor): IRickUIBuilderEditLineColor;
begin
  FFocusColor := AValue;
  ApplyState(nil);
  Result := Self;
end;

function TRickUIBuilderEditLineColor.Invalid(AValue: TAlphaColor): IRickUIBuilderEditLineColor;
begin
  FInvalidColor := AValue;
  ApplyState(nil);
  Result := Self;
end;

function TRickUIBuilderEditLineColor.ReadOnly(AValue: TAlphaColor): IRickUIBuilderEditLineColor;
begin
  FReadOnlyColor := AValue;
  ApplyState(nil);
  Result := Self;
end;

function TRickUIBuilderEditLineColor.ToBack: IRickUIBuilderEditLine;
begin
  if not Assigned(FParent) then
    raise Exception.Create('O Parent da interface não foi informado para retornar.');
  Result := FParent;
end;

end.
