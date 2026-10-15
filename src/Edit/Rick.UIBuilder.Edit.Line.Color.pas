unit Rick.UIBuilder.Edit.Line.Color;

interface

uses
  FMX.Edit,
  FMX.Objects,
  System.Classes,
  System.UITypes,

  Rick.UIBuilder.Edit.Interfaces;

type
  TRickUIBuilderEditLineColor = class(TComponent, IRickUIBuilderEditLineColor)
  private
    [weak]
    FParent: IRickUIBuilderEditLine;
    FControl: TRectangle;
    FEdit: TEdit;
    FValidation: IRickUIBuilderEditDesignerValidation;
    FNormalColor: TAlphaColor;
    FFocusColor: TAlphaColor;
    FInvalidColor: TAlphaColor;
    FReadOnlyColor: TAlphaColor;
    FFocused: Boolean;
    FPreviousEnter: TNotifyEvent;
    FPreviousExit: TNotifyEvent;
    procedure ApplyState;
    procedure BindEdit(AEdit: TEdit);
    procedure FindExistingEdit;
    procedure ResolveValidation;
    procedure HandleEnter(ASender: TObject);
    procedure HandleExit(ASender: TObject);
  protected
    constructor Create(const AParent: IRickUIBuilderEditLine;
      AControl: TRectangle); reintroduce;
    procedure Notification(AComponent: TComponent;
      AOperation: TOperation); override;

    function Normal(AValue: TAlphaColor): IRickUIBuilderEditLineColor;
    function Focus(AValue: TAlphaColor): IRickUIBuilderEditLineColor;
    function Invalid(AValue: TAlphaColor): IRickUIBuilderEditLineColor;
    function ReadOnly(AValue: TAlphaColor): IRickUIBuilderEditLineColor;
    function ToBack: IRickUIBuilderEditLine;
  public
    destructor Destroy; override;
    class function New(const AParent: IRickUIBuilderEditLine;
      AControl: TRectangle): IRickUIBuilderEditLineColor;
  end;

implementation

uses
  System.SysUtils;

constructor TRickUIBuilderEditLineColor.Create(
  const AParent: IRickUIBuilderEditLine; AControl: TRectangle);
begin
  inherited Create(AControl.Owner);
  FParent := AParent;
  FControl := AControl;
  FNormalColor := $FFB0B0B0;
  FFocusColor := TAlphaColors.Black;
  FInvalidColor := $FFD93025;
  FReadOnlyColor := $FFD8D8D8;
  FFocused := False;
  FindExistingEdit;
  ApplyState;
end;

destructor TRickUIBuilderEditLineColor.Destroy;
begin
  if Assigned(FEdit) and not (csDestroying in FEdit.ComponentState) then
  begin
    FEdit.RemoveFreeNotification(Self);
    FEdit.OnEnter := FPreviousEnter;
    FEdit.OnExit := FPreviousExit;
  end;
  inherited;
end;

class function TRickUIBuilderEditLineColor.New(
  const AParent: IRickUIBuilderEditLine;
  AControl: TRectangle): IRickUIBuilderEditLineColor;
begin
  Result := Self.Create(AParent, AControl);
end;

procedure TRickUIBuilderEditLineColor.BindEdit(AEdit: TEdit);
begin
  if Assigned(FEdit) or not Assigned(AEdit) then
    Exit;
  FEdit := AEdit;
  FEdit.FreeNotification(Self);
  FPreviousEnter := FEdit.OnEnter;
  FPreviousExit := FEdit.OnExit;
  FEdit.OnEnter := HandleEnter;
  FEdit.OnExit := HandleExit;
end;

procedure TRickUIBuilderEditLineColor.FindExistingEdit;
var
  LIndex: Integer;
begin
  if not Assigned(Owner) then
    Exit;
  for LIndex := 0 to Owner.ComponentCount - 1 do
    if Owner.Components[LIndex] is TEdit then
    begin
      BindEdit(TEdit(Owner.Components[LIndex]));
      Exit;
    end;
end;

procedure TRickUIBuilderEditLineColor.ResolveValidation;
begin
  if Assigned(FValidation) or not Assigned(FEdit) or not Assigned(FParent) then
    Exit;
  FValidation := FParent.ToBack.Designer.Validation;
end;

procedure TRickUIBuilderEditLineColor.Notification(AComponent: TComponent;
  AOperation: TOperation);
begin
  inherited;
  if (AOperation = opInsert) and (AComponent is TEdit) then
    BindEdit(TEdit(AComponent))
  else if (AOperation = opRemove) and (AComponent = FEdit) then
  begin
    FEdit := nil;
    FValidation := nil;
    FFocused := False;
  end;
end;

procedure TRickUIBuilderEditLineColor.ApplyState;
begin
  ResolveValidation;
  if Assigned(FValidation) and FValidation.InvalidValue then
    FControl.Fill.Color := FInvalidColor
  else if Assigned(FEdit) and FEdit.ReadOnly then
    FControl.Fill.Color := FReadOnlyColor
  else if FFocused then
    FControl.Fill.Color := FFocusColor
  else
    FControl.Fill.Color := FNormalColor;
end;

procedure TRickUIBuilderEditLineColor.HandleEnter(ASender: TObject);
begin
  if Assigned(ASender) then
    FFocused := True;
  ApplyState;
  if Assigned(FPreviousEnter) then
    FPreviousEnter(ASender);
end;

procedure TRickUIBuilderEditLineColor.HandleExit(ASender: TObject);
begin
  if Assigned(ASender) then
    FFocused := False;
  ApplyState;
  if Assigned(FPreviousExit) then
    FPreviousExit(ASender);
end;

function TRickUIBuilderEditLineColor.Normal(
  AValue: TAlphaColor): IRickUIBuilderEditLineColor;
begin
  FNormalColor := AValue;
  ApplyState;
  Result := Self;
end;

function TRickUIBuilderEditLineColor.Focus(
  AValue: TAlphaColor): IRickUIBuilderEditLineColor;
begin
  FFocusColor := AValue;
  ApplyState;
  Result := Self;
end;

function TRickUIBuilderEditLineColor.Invalid(
  AValue: TAlphaColor): IRickUIBuilderEditLineColor;
begin
  FInvalidColor := AValue;
  ApplyState;
  Result := Self;
end;

function TRickUIBuilderEditLineColor.ReadOnly(
  AValue: TAlphaColor): IRickUIBuilderEditLineColor;
begin
  FReadOnlyColor := AValue;
  ApplyState;
  Result := Self;
end;

function TRickUIBuilderEditLineColor.ToBack: IRickUIBuilderEditLine;
begin
  if not Assigned(FParent) then
    raise Exception.Create('O Parent da interface não foi informado para retornar.');
  Result := FParent;
end;

end.
