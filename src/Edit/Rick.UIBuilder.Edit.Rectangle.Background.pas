unit Rick.UIBuilder.Edit.Rectangle.Background;

interface

uses
  FMX.Edit,
  FMX.Objects,
  System.Classes,
  System.UITypes,

  Rick.UIBuilder.Edit.Interfaces;

type
  TRickUIBuilderEditRetangleBackground = class(TComponent, IRickUIBuilderEditRetangleBackground)
  private
    [weak]
    FParent: IRickUIBuilderEditRetangle;
    FControl: TRectangle;
    FEdit: TEdit;
    FValidation: IRickUIBuilderEditDesignerValidation;
    FNormalColor: TAlphaColor;
    FInvalidColor: TAlphaColor;
    FReadOnlyColor: TAlphaColor;
    FPreviousEnter: TNotifyEvent;
    FPreviousExit: TNotifyEvent;
    procedure ApplyState;
    procedure HandleEnter(ASender: TObject);
    procedure HandleExit(ASender: TObject);
  protected
    constructor Create(const AParent: IRickUIBuilderEditRetangle;
      AControl: TRectangle; AEdit: TEdit;
      const AValidation: IRickUIBuilderEditDesignerValidation); reintroduce;

    function Normal(AValue: TAlphaColor): IRickUIBuilderEditRetangleBackground;
    function Invalid(AValue: TAlphaColor): IRickUIBuilderEditRetangleBackground;
    function ReadOnly(AValue: TAlphaColor): IRickUIBuilderEditRetangleBackground;
    function ToBack: IRickUIBuilderEditRetangle;
  public
    destructor Destroy; override;
    class function New(const AParent: IRickUIBuilderEditRetangle;
      AControl: TRectangle; AEdit: TEdit;
      const AValidation: IRickUIBuilderEditDesignerValidation): IRickUIBuilderEditRetangleBackground;
  end;

implementation

uses
  System.SysUtils;

constructor TRickUIBuilderEditRetangleBackground.Create(
  const AParent: IRickUIBuilderEditRetangle; AControl: TRectangle; AEdit: TEdit;
  const AValidation: IRickUIBuilderEditDesignerValidation);
begin
  inherited Create(AEdit);
  FParent := AParent;
  FControl := AControl;
  FEdit := AEdit;
  FValidation := AValidation;
  FNormalColor := TAlphaColors.White;
  FInvalidColor := $FFFFF0F0;
  FReadOnlyColor := $FFF7F7F7;
  FPreviousEnter := FEdit.OnEnter;
  FPreviousExit := FEdit.OnExit;
  FEdit.OnEnter := HandleEnter;
  FEdit.OnExit := HandleExit;
  ApplyState;
end;

destructor TRickUIBuilderEditRetangleBackground.Destroy;
begin
  if Assigned(FEdit) and not (csDestroying in FEdit.ComponentState) then
  begin
    FEdit.OnEnter := FPreviousEnter;
    FEdit.OnExit := FPreviousExit;
  end;
  inherited;
end;

class function TRickUIBuilderEditRetangleBackground.New(
  const AParent: IRickUIBuilderEditRetangle; AControl: TRectangle; AEdit: TEdit;
  const AValidation: IRickUIBuilderEditDesignerValidation): IRickUIBuilderEditRetangleBackground;
begin
  Result := Self.Create(AParent, AControl, AEdit, AValidation);
end;

procedure TRickUIBuilderEditRetangleBackground.ApplyState;
begin
  if FValidation.InvalidValue then
    FControl.Fill.Color := FInvalidColor
  else if FEdit.ReadOnly then
    FControl.Fill.Color := FReadOnlyColor
  else
    FControl.Fill.Color := FNormalColor;
end;

procedure TRickUIBuilderEditRetangleBackground.HandleEnter(ASender: TObject);
begin
  ApplyState;
  if Assigned(FPreviousEnter) then
    FPreviousEnter(ASender);
end;

procedure TRickUIBuilderEditRetangleBackground.HandleExit(ASender: TObject);
begin
  ApplyState;
  if Assigned(FPreviousExit) then
    FPreviousExit(ASender);
end;

function TRickUIBuilderEditRetangleBackground.Normal(
  AValue: TAlphaColor): IRickUIBuilderEditRetangleBackground;
begin
  FNormalColor := AValue;
  ApplyState;
  Result := Self;
end;

function TRickUIBuilderEditRetangleBackground.Invalid(
  AValue: TAlphaColor): IRickUIBuilderEditRetangleBackground;
begin
  FInvalidColor := AValue;
  ApplyState;
  Result := Self;
end;

function TRickUIBuilderEditRetangleBackground.ReadOnly(
  AValue: TAlphaColor): IRickUIBuilderEditRetangleBackground;
begin
  FReadOnlyColor := AValue;
  ApplyState;
  Result := Self;
end;

function TRickUIBuilderEditRetangleBackground.ToBack: IRickUIBuilderEditRetangle;
begin
  if not Assigned(FParent) then
    raise Exception.Create('O Parent da interface não foi informado para retornar.');
  Result := FParent;
end;

end.
