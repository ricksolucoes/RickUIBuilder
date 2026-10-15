unit Rick.UIBuilder.Edit.Labels.Error.Text;

interface

uses
  FMX.Edit,
  FMX.Objects,
  FMX.StdCtrls,
  System.UITypes,

  Rick.UIBuilder.Edit.Interfaces;

type
  TRickUIBuilderEditLabelErrorText = class(TInterfacedObject, IRickUIBuilderEditLabelErrorText)
  private
    [weak]
    FParent: IRickUIBuilderEditLabelError;
    FEdit: TEdit;
    FControl: TLabel;
    FValidation: IRickUIBuilderEditDesignerValidation;
    FFont: IRickUIBuilderEditLabelErrorTextFont;
    function FindControl: TLabel;
    procedure PrepareControl(AHost: TRectangle);
    procedure RefreshValidationFeedback;
  protected
    constructor Create(const AParent: IRickUIBuilderEditLabelError;
      AHost: TRectangle; AEdit: TEdit;
      const AValidation: IRickUIBuilderEditDesignerValidation);

    function Value(AValue: string): IRickUIBuilderEditLabelErrorText;
    function Color(AValue: TAlphaColor): IRickUIBuilderEditLabelErrorText;
    function Spacing(AValue: Single): IRickUIBuilderEditLabelErrorText;
    function Font: IRickUIBuilderEditLabelErrorTextFont;
    function ToBack: IRickUIBuilderEditLabelError;
  public
    class function New(const AParent: IRickUIBuilderEditLabelError;
      AHost: TRectangle; AEdit: TEdit;
      const AValidation: IRickUIBuilderEditDesignerValidation): IRickUIBuilderEditLabelErrorText;
  end;

implementation

uses
  FMX.Types,
  System.SysUtils,

  Rick.UIBuilder.Edit.Labels.Error.Text.Font;

constructor TRickUIBuilderEditLabelErrorText.Create(
  const AParent: IRickUIBuilderEditLabelError; AHost: TRectangle; AEdit: TEdit;
  const AValidation: IRickUIBuilderEditDesignerValidation);
begin
  inherited Create;
  FParent := AParent;
  FEdit := AEdit;
  FValidation := AValidation;
  FControl := FindControl;
  if not Assigned(FControl) then
  begin
    FControl := TLabel.Create(FEdit);
    FControl.Parent := AHost;
    FControl.Visible := False;
    FControl.HitTest := False;
  end;
  PrepareControl(AHost);
  RefreshValidationFeedback;
end;

class function TRickUIBuilderEditLabelErrorText.New(
  const AParent: IRickUIBuilderEditLabelError; AHost: TRectangle; AEdit: TEdit;
  const AValidation: IRickUIBuilderEditDesignerValidation): IRickUIBuilderEditLabelErrorText;
begin
  Result := Self.Create(AParent, AHost, AEdit, AValidation);
end;

function TRickUIBuilderEditLabelErrorText.FindControl: TLabel;
var
  LIndex: Integer;
begin
  Result := nil;
  for LIndex := 0 to FEdit.ComponentCount - 1 do
    if FEdit.Components[LIndex] is TLabel then
      Exit(TLabel(FEdit.Components[LIndex]));
end;

procedure TRickUIBuilderEditLabelErrorText.PrepareControl(AHost: TRectangle);
begin
  FControl.SetBounds(12, 52, AHost.Width - 24, 18);
  FControl.StyledSettings := FControl.StyledSettings - [TStyledSetting.Family,
    TStyledSetting.Size, TStyledSetting.Style, TStyledSetting.FontColor];
  FControl.TextSettings.Font.Size := 11;
  FControl.TextSettings.FontColor := $FFD93025;
  FControl.HitTest := False;
end;

procedure TRickUIBuilderEditLabelErrorText.RefreshValidationFeedback;
begin
  if not FValidation.HasInvalid then
    Exit;
  FValidation.Invalid(FValidation.InvalidValue, FValidation.InvalidMessage);
end;

function TRickUIBuilderEditLabelErrorText.Value(
  AValue: string): IRickUIBuilderEditLabelErrorText;
begin
  FControl.Text := AValue;
  Result := Self;
end;

function TRickUIBuilderEditLabelErrorText.Color(
  AValue: TAlphaColor): IRickUIBuilderEditLabelErrorText;
begin
  FControl.TextSettings.FontColor := AValue;
  Result := Self;
end;

function TRickUIBuilderEditLabelErrorText.Spacing(
  AValue: Single): IRickUIBuilderEditLabelErrorText;
begin
  FControl.Position.Y := 48 + AValue;
  Result := Self;
end;

function TRickUIBuilderEditLabelErrorText.Font: IRickUIBuilderEditLabelErrorTextFont;
begin
  if not Assigned(FFont) then
    FFont := TRickUIBuilderEditLabelErrorTextFont.New(Self, FControl);
  Result := FFont;
end;

function TRickUIBuilderEditLabelErrorText.ToBack: IRickUIBuilderEditLabelError;
begin
  if not Assigned(FParent) then
    raise Exception.Create('O Parent da interface não foi informado para retornar.');
  Result := FParent;
end;

end.
