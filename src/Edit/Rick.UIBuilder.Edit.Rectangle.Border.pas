unit Rick.UIBuilder.Edit.Rectangle.Border;

interface

uses
  FMX.Edit,
  FMX.Objects,
  System.Classes,
  System.UITypes,

  Rick.UIBuilder.Edit.Interfaces;

type
  TRickUIBuilderEditRetangleBorder = class(TComponent, IRickUIBuilderEditRetangleBorder)
  private
    [weak]
    FParent: IRickUIBuilderEditRetangle;
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
    procedure HandleEnter(ASender: TObject);
    procedure HandleExit(ASender: TObject);
  protected
    constructor Create(const AParent: IRickUIBuilderEditRetangle;
      AControl: TRectangle; AEdit: TEdit;
      const AValidation: IRickUIBuilderEditDesignerValidation); reintroduce;

    function Thickness(AValue: Single): IRickUIBuilderEditRetangleBorder;
    function Normal(AValue: TAlphaColor): IRickUIBuilderEditRetangleBorder;
    function Focus(AValue: TAlphaColor): IRickUIBuilderEditRetangleBorder;
    function Invalid(AValue: TAlphaColor): IRickUIBuilderEditRetangleBorder;
    function ReadOnly(AValue: TAlphaColor): IRickUIBuilderEditRetangleBorder;
    function ToBack: IRickUIBuilderEditRetangle;
  public
    destructor Destroy; override;
    class function New(const AParent: IRickUIBuilderEditRetangle;
      AControl: TRectangle; AEdit: TEdit;
      const AValidation: IRickUIBuilderEditDesignerValidation): IRickUIBuilderEditRetangleBorder;
  end;

implementation

uses
  System.SysUtils;

constructor TRickUIBuilderEditRetangleBorder.Create(
  const AParent: IRickUIBuilderEditRetangle; AControl: TRectangle; AEdit: TEdit;
  const AValidation: IRickUIBuilderEditDesignerValidation);
begin
  inherited Create(AEdit);
  FParent := AParent;
  FControl := AControl;
  FEdit := AEdit;
  FValidation := AValidation;
  FNormalColor := $FFB0B0B0;
  FFocusColor := TAlphaColors.Black;
  FInvalidColor := $FFD93025;
  FReadOnlyColor := $FFD8D8D8;
  FFocused := False;
  FPreviousEnter := FEdit.OnEnter;
  FPreviousExit := FEdit.OnExit;
  FEdit.OnEnter := HandleEnter;
  FEdit.OnExit := HandleExit;
  ApplyState;
end;

destructor TRickUIBuilderEditRetangleBorder.Destroy;
begin
  if Assigned(FEdit) and not (csDestroying in FEdit.ComponentState) then
  begin
    FEdit.OnEnter := FPreviousEnter;
    FEdit.OnExit := FPreviousExit;
  end;
  inherited;
end;

class function TRickUIBuilderEditRetangleBorder.New(
  const AParent: IRickUIBuilderEditRetangle; AControl: TRectangle; AEdit: TEdit;
  const AValidation: IRickUIBuilderEditDesignerValidation): IRickUIBuilderEditRetangleBorder;
begin
  Result := Self.Create(AParent, AControl, AEdit, AValidation);
end;

procedure TRickUIBuilderEditRetangleBorder.ApplyState;
begin
  if FValidation.InvalidValue then
    FControl.Stroke.Color := FInvalidColor
  else if FEdit.ReadOnly then
    FControl.Stroke.Color := FReadOnlyColor
  else if FFocused then
    FControl.Stroke.Color := FFocusColor
  else
    FControl.Stroke.Color := FNormalColor;
end;

procedure TRickUIBuilderEditRetangleBorder.HandleEnter(ASender: TObject);
begin
  if Assigned(ASender) then
    FFocused := True;
  ApplyState;
  if Assigned(FPreviousEnter) then
    FPreviousEnter(ASender);
end;

procedure TRickUIBuilderEditRetangleBorder.HandleExit(ASender: TObject);
begin
  if Assigned(ASender) then
    FFocused := False;
  ApplyState;
  if Assigned(FPreviousExit) then
    FPreviousExit(ASender);
end;

function TRickUIBuilderEditRetangleBorder.Thickness(
  AValue: Single): IRickUIBuilderEditRetangleBorder;
begin
  FControl.Stroke.Thickness := AValue;
  Result := Self;
end;

function TRickUIBuilderEditRetangleBorder.Normal(
  AValue: TAlphaColor): IRickUIBuilderEditRetangleBorder;
begin
  FNormalColor := AValue;
  ApplyState;
  Result := Self;
end;

function TRickUIBuilderEditRetangleBorder.Focus(
  AValue: TAlphaColor): IRickUIBuilderEditRetangleBorder;
begin
  FFocusColor := AValue;
  ApplyState;
  Result := Self;
end;

function TRickUIBuilderEditRetangleBorder.Invalid(
  AValue: TAlphaColor): IRickUIBuilderEditRetangleBorder;
begin
  FInvalidColor := AValue;
  ApplyState;
  Result := Self;
end;

function TRickUIBuilderEditRetangleBorder.ReadOnly(
  AValue: TAlphaColor): IRickUIBuilderEditRetangleBorder;
begin
  FReadOnlyColor := AValue;
  ApplyState;
  Result := Self;
end;

function TRickUIBuilderEditRetangleBorder.ToBack: IRickUIBuilderEditRetangle;
begin
  if not Assigned(FParent) then
    raise Exception.Create('O Parent da interface não foi informado para retornar.');
  Result := FParent;
end;

end.
