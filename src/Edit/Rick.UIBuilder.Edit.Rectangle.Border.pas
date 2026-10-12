unit Rick.UIBuilder.Edit.Rectangle.Border;

interface

uses
  FMX.Objects,
  System.UITypes,

  Rick.UIBuilder.Edit.Interfaces,
  Rick.UIBuilder.Edit.VisualState;

type
  TRickUIBuilderEditRetangleBorder = class(TInterfacedObject, IRickUIBuilderEditRetangleBorder)
  private
    [weak]
    FParent: IRickUIBuilderEditRetangle;
    FControl: TRectangle;
    FVisualState: TRickUIBuilderEditVisualState;
    FNormalColor: TAlphaColor;
    FFocusColor: TAlphaColor;
    FInvalidColor: TAlphaColor;
    FReadOnlyColor: TAlphaColor;
    procedure ApplyState(ASender: TObject);
  protected
    constructor Create(const AParent: IRickUIBuilderEditRetangle; AControl: TRectangle; AVisualState: TRickUIBuilderEditVisualState);

    function Thickness(AValue: Single): IRickUIBuilderEditRetangleBorder;
    function Normal(AValue: TAlphaColor): IRickUIBuilderEditRetangleBorder;
    function Focus(AValue: TAlphaColor): IRickUIBuilderEditRetangleBorder;
    function Invalid(AValue: TAlphaColor): IRickUIBuilderEditRetangleBorder;
    function ReadOnly(AValue: TAlphaColor): IRickUIBuilderEditRetangleBorder;
    function ToBack: IRickUIBuilderEditRetangle;
  public
    class function New(const AParent: IRickUIBuilderEditRetangle; AControl: TRectangle; AVisualState: TRickUIBuilderEditVisualState): IRickUIBuilderEditRetangleBorder;
  end;

implementation

uses
  System.SysUtils;

constructor TRickUIBuilderEditRetangleBorder.Create(const AParent: IRickUIBuilderEditRetangle; AControl: TRectangle; AVisualState: TRickUIBuilderEditVisualState);
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

class function TRickUIBuilderEditRetangleBorder.New(const AParent: IRickUIBuilderEditRetangle; AControl: TRectangle; AVisualState: TRickUIBuilderEditVisualState): IRickUIBuilderEditRetangleBorder;
begin
  Result := Self.Create(AParent, AControl, AVisualState);
end;

procedure TRickUIBuilderEditRetangleBorder.ApplyState(ASender: TObject);
begin
  if FVisualState.IsInvalid then
    FControl.Stroke.Color := FInvalidColor
  else if FVisualState.IsReadOnly then
    FControl.Stroke.Color := FReadOnlyColor
  else if FVisualState.IsFocused then
    FControl.Stroke.Color := FFocusColor
  else
    FControl.Stroke.Color := FNormalColor;
end;

function TRickUIBuilderEditRetangleBorder.Thickness(AValue: Single): IRickUIBuilderEditRetangleBorder;
begin
  FControl.Stroke.Thickness := AValue;
  Result := Self;
end;

function TRickUIBuilderEditRetangleBorder.Normal(AValue: TAlphaColor): IRickUIBuilderEditRetangleBorder;
begin
  FNormalColor := AValue;
  ApplyState(nil);
  Result := Self;
end;

function TRickUIBuilderEditRetangleBorder.Focus(AValue: TAlphaColor): IRickUIBuilderEditRetangleBorder;
begin
  FFocusColor := AValue;
  ApplyState(nil);
  Result := Self;
end;

function TRickUIBuilderEditRetangleBorder.Invalid(AValue: TAlphaColor): IRickUIBuilderEditRetangleBorder;
begin
  FInvalidColor := AValue;
  ApplyState(nil);
  Result := Self;
end;

function TRickUIBuilderEditRetangleBorder.ReadOnly(AValue: TAlphaColor): IRickUIBuilderEditRetangleBorder;
begin
  FReadOnlyColor := AValue;
  ApplyState(nil);
  Result := Self;
end;

function TRickUIBuilderEditRetangleBorder.ToBack: IRickUIBuilderEditRetangle;
begin
  if not Assigned(FParent) then
    raise Exception.Create('O Parent da interface não foi informado para retornar.');
  Result := FParent;
end;

end.
