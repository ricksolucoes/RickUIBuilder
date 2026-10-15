unit Rick.UIBuilder.Edit.Labels.Main.Text.Color;

interface

uses
  FMX.Edit,
  FMX.StdCtrls,
  System.Classes,
  System.UITypes,

  Rick.UIBuilder.Edit.Interfaces;

type
  TRickUIBuilderEditLabelMainTextColor = class(TComponent, IRickUIBuilderEditLabelMainTextColor)
  private
    [weak]
    FParent: IRickUIBuilderEditLabelMainText;
    FControl: TLabel;
    FEdit: TEdit;
    FValidation: IRickUIBuilderEditDesignerValidation;
    FTextColor: TAlphaColor;
    FInvalidColor: TAlphaColor;
    FReadOnlyColor: TAlphaColor;
    FPreviousEnter: TNotifyEvent;
    FPreviousExit: TNotifyEvent;
    procedure ApplyState;
    procedure HandleEnter(ASender: TObject);
    procedure HandleExit(ASender: TObject);
  protected
    constructor Create(const AParent: IRickUIBuilderEditLabelMainText;
      AControl: TLabel; AEdit: TEdit;
      const AValidation: IRickUIBuilderEditDesignerValidation); reintroduce;

    function Text(AValue: TAlphaColor): IRickUIBuilderEditLabelMainTextColor;
    function Invalid(AValue: TAlphaColor): IRickUIBuilderEditLabelMainText;
    function ReadOnly(AValue: TAlphaColor): IRickUIBuilderEditLabelMainText;
    function ToBack: IRickUIBuilderEditLabelMainText;
  public
    destructor Destroy; override;
    class function New(const AParent: IRickUIBuilderEditLabelMainText;
      AControl: TLabel; AEdit: TEdit;
      const AValidation: IRickUIBuilderEditDesignerValidation): IRickUIBuilderEditLabelMainTextColor;
  end;

implementation

uses
  System.SysUtils;

constructor TRickUIBuilderEditLabelMainTextColor.Create(
  const AParent: IRickUIBuilderEditLabelMainText; AControl: TLabel; AEdit: TEdit;
  const AValidation: IRickUIBuilderEditDesignerValidation);
begin
  inherited Create(AEdit);
  FParent := AParent;
  FControl := AControl;
  FEdit := AEdit;
  FValidation := AValidation;
  FTextColor := $FF606060;
  FInvalidColor := $FFD93025;
  FReadOnlyColor := $FFB8B8B8;
  FPreviousEnter := FEdit.OnEnter;
  FPreviousExit := FEdit.OnExit;
  FEdit.OnEnter := HandleEnter;
  FEdit.OnExit := HandleExit;
  ApplyState;
end;

destructor TRickUIBuilderEditLabelMainTextColor.Destroy;
begin
  if Assigned(FEdit) and not (csDestroying in FEdit.ComponentState) then
  begin
    FEdit.OnEnter := FPreviousEnter;
    FEdit.OnExit := FPreviousExit;
  end;
  inherited;
end;

class function TRickUIBuilderEditLabelMainTextColor.New(
  const AParent: IRickUIBuilderEditLabelMainText; AControl: TLabel; AEdit: TEdit;
  const AValidation: IRickUIBuilderEditDesignerValidation): IRickUIBuilderEditLabelMainTextColor;
begin
  Result := Self.Create(AParent, AControl, AEdit, AValidation);
end;

procedure TRickUIBuilderEditLabelMainTextColor.ApplyState;
begin
  if FValidation.InvalidValue then
    FControl.TextSettings.FontColor := FInvalidColor
  else if FEdit.ReadOnly then
    FControl.TextSettings.FontColor := FReadOnlyColor
  else
    FControl.TextSettings.FontColor := FTextColor;
end;

procedure TRickUIBuilderEditLabelMainTextColor.HandleEnter(ASender: TObject);
begin
  ApplyState;
  if Assigned(FPreviousEnter) then
    FPreviousEnter(ASender);
end;

procedure TRickUIBuilderEditLabelMainTextColor.HandleExit(ASender: TObject);
begin
  ApplyState;
  if Assigned(FPreviousExit) then
    FPreviousExit(ASender);
end;

function TRickUIBuilderEditLabelMainTextColor.Text(
  AValue: TAlphaColor): IRickUIBuilderEditLabelMainTextColor;
begin
  FTextColor := AValue;
  ApplyState;
  Result := Self;
end;

function TRickUIBuilderEditLabelMainTextColor.Invalid(
  AValue: TAlphaColor): IRickUIBuilderEditLabelMainText;
begin
  FInvalidColor := AValue;
  ApplyState;
  Result := ToBack;
end;

function TRickUIBuilderEditLabelMainTextColor.ReadOnly(
  AValue: TAlphaColor): IRickUIBuilderEditLabelMainText;
begin
  FReadOnlyColor := AValue;
  ApplyState;
  Result := ToBack;
end;

function TRickUIBuilderEditLabelMainTextColor.ToBack: IRickUIBuilderEditLabelMainText;
begin
  if not Assigned(FParent) then
    raise Exception.Create('O Parent da interface não foi informado para retornar.');
  Result := FParent;
end;

end.
