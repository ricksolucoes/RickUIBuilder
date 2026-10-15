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
    procedure HandleEnter(ASender: TObject);
    procedure HandleExit(ASender: TObject);
  protected
    constructor Create(const AParent: IRickUIBuilderEditLine;
      AControl: TRectangle; AEdit: TEdit;
      const AValidation: IRickUIBuilderEditDesignerValidation); reintroduce;

    function Normal(AValue: TAlphaColor): IRickUIBuilderEditLineColor;
    function Focus(AValue: TAlphaColor): IRickUIBuilderEditLineColor;
    function Invalid(AValue: TAlphaColor): IRickUIBuilderEditLineColor;
    function ReadOnly(AValue: TAlphaColor): IRickUIBuilderEditLineColor;
    function ToBack: IRickUIBuilderEditLine;
  public
    destructor Destroy; override;
    class function New(const AParent: IRickUIBuilderEditLine;
      AControl: TRectangle; AEdit: TEdit;
      const AValidation: IRickUIBuilderEditDesignerValidation): IRickUIBuilderEditLineColor;
  end;

implementation

uses
  System.SysUtils;

constructor TRickUIBuilderEditLineColor.Create(
  const AParent: IRickUIBuilderEditLine; AControl: TRectangle; AEdit: TEdit;
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

destructor TRickUIBuilderEditLineColor.Destroy;
begin
  if Assigned(FEdit) and not (csDestroying in FEdit.ComponentState) then
  begin
    FEdit.OnEnter := FPreviousEnter;
    FEdit.OnExit := FPreviousExit;
  end;
  inherited;
end;

class function TRickUIBuilderEditLineColor.New(
  const AParent: IRickUIBuilderEditLine; AControl: TRectangle; AEdit: TEdit;
  const AValidation: IRickUIBuilderEditDesignerValidation): IRickUIBuilderEditLineColor;
begin
  Result := Self.Create(AParent, AControl, AEdit, AValidation);
end;

procedure TRickUIBuilderEditLineColor.ApplyState;
begin
  if FValidation.InvalidValue then
    FControl.Fill.Color := FInvalidColor
  else if FEdit.ReadOnly then
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
