unit Rick.UIBuilder.Edit.Rectangle.Background;

interface

uses
  FMX.Objects,
  System.UITypes,

  Rick.UIBuilder.Edit.Interfaces,
  Rick.UIBuilder.Edit.VisualState;

type
  TRickUIBuilderEditRetangleBackground = class(TInterfacedObject, IRickUIBuilderEditRetangleBackground)
  private
    [weak]
    FParent: IRickUIBuilderEditRetangle;
    FControl: TRectangle;
    FVisualState: TRickUIBuilderEditVisualState;
    FNormalColor: TAlphaColor;
    FInvalidColor: TAlphaColor;
    FReadOnlyColor: TAlphaColor;
    procedure ApplyState(ASender: TObject);
  protected
    constructor Create(const AParent: IRickUIBuilderEditRetangle; AControl: TRectangle; AVisualState: TRickUIBuilderEditVisualState);

    function Normal(AValue: TAlphaColor): IRickUIBuilderEditRetangleBackground;
    function Invalid(AValue: TAlphaColor): IRickUIBuilderEditRetangleBackground;
    function ReadOnly(AValue: TAlphaColor): IRickUIBuilderEditRetangleBackground;
    function ToBack: IRickUIBuilderEditRetangle;
  public
    class function New(const AParent: IRickUIBuilderEditRetangle; AControl: TRectangle; AVisualState: TRickUIBuilderEditVisualState): IRickUIBuilderEditRetangleBackground;
  end;

implementation

uses
  System.SysUtils;

constructor TRickUIBuilderEditRetangleBackground.Create(const AParent: IRickUIBuilderEditRetangle; AControl: TRectangle; AVisualState: TRickUIBuilderEditVisualState);
begin
  inherited Create;
  FParent := AParent;
  FControl := AControl;
  FVisualState := AVisualState;
  FNormalColor := TAlphaColors.White;
  FInvalidColor := $FFFFF0F0;
  FReadOnlyColor := $FFF7F7F7;
  FVisualState.RegisterHandler(ApplyState, AParent);
  ApplyState(nil);
end;

class function TRickUIBuilderEditRetangleBackground.New(const AParent: IRickUIBuilderEditRetangle; AControl: TRectangle; AVisualState: TRickUIBuilderEditVisualState): IRickUIBuilderEditRetangleBackground;
begin
  Result := Self.Create(AParent, AControl, AVisualState);
end;

procedure TRickUIBuilderEditRetangleBackground.ApplyState(ASender: TObject);
begin
  if FVisualState.IsInvalid then
    FControl.Fill.Color := FInvalidColor
  else if FVisualState.IsReadOnly then
    FControl.Fill.Color := FReadOnlyColor
  else
    FControl.Fill.Color := FNormalColor;
end;

function TRickUIBuilderEditRetangleBackground.Normal(AValue: TAlphaColor): IRickUIBuilderEditRetangleBackground;
begin
  FNormalColor := AValue;
  ApplyState(nil);
  Result := Self;
end;

function TRickUIBuilderEditRetangleBackground.Invalid(AValue: TAlphaColor): IRickUIBuilderEditRetangleBackground;
begin
  FInvalidColor := AValue;
  ApplyState(nil);
  Result := Self;
end;

function TRickUIBuilderEditRetangleBackground.ReadOnly(AValue: TAlphaColor): IRickUIBuilderEditRetangleBackground;
begin
  FReadOnlyColor := AValue;
  ApplyState(nil);
  Result := Self;
end;

function TRickUIBuilderEditRetangleBackground.ToBack: IRickUIBuilderEditRetangle;
begin
  if not Assigned(FParent) then
    raise Exception.Create('O Parent da interface não foi informado para retornar.');
  Result := FParent;
end;

end.
