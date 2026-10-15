unit Rick.UIBuilder.Edit.Labels.Main.Text;

interface

uses
  FMX.Edit,
  FMX.Objects,
  FMX.StdCtrls,

  Rick.UIBuilder.Edit.Interfaces;

type
  TRickUIBuilderEditLabelMainText = class(TInterfacedObject, IRickUIBuilderEditLabelMainText)
  private
    [weak]
    FParent: IRickUIBuilderEditLabelMain;
    FControl: TLabel;
    FEdit: TEdit;
    FValidation: IRickUIBuilderEditDesignerValidation;
    FColor: IRickUIBuilderEditLabelMainTextColor;
  protected
    constructor Create(const AParent: IRickUIBuilderEditLabelMain;
      AHost: TRectangle; AEdit: TEdit;
      const AValidation: IRickUIBuilderEditDesignerValidation);

    function Value(const AValue: string): IRickUIBuilderEditLabelMainText;
    function Size(AValue: Single): IRickUIBuilderEditLabelMainText;
    function Color: IRickUIBuilderEditLabelMainTextColor;
    function ToBack: IRickUIBuilderEditLabelMain;
  public
    class function New(const AParent: IRickUIBuilderEditLabelMain;
      AHost: TRectangle; AEdit: TEdit;
      const AValidation: IRickUIBuilderEditDesignerValidation): IRickUIBuilderEditLabelMainText;
  end;

implementation

uses
  FMX.Types,
  System.SysUtils,

  Rick.UIBuilder.Edit.Labels.Main.Text.Color;

constructor TRickUIBuilderEditLabelMainText.Create(
  const AParent: IRickUIBuilderEditLabelMain; AHost: TRectangle; AEdit: TEdit;
  const AValidation: IRickUIBuilderEditDesignerValidation);
begin
  inherited Create;
  FParent := AParent;
  FEdit := AEdit;
  FValidation := AValidation;
  FControl := TLabel.Create(AHost);
  FControl.Parent := AHost;
  FControl.SetBounds(12, 3, AHost.Width - 24, 18);
  FControl.StyledSettings := FControl.StyledSettings - [TStyledSetting.Size,
    TStyledSetting.FontColor];
  FControl.TextSettings.Font.Size := 12;
  FControl.TextSettings.FontColor := $FF606060;
  FControl.HitTest := False;
end;

class function TRickUIBuilderEditLabelMainText.New(
  const AParent: IRickUIBuilderEditLabelMain; AHost: TRectangle; AEdit: TEdit;
  const AValidation: IRickUIBuilderEditDesignerValidation): IRickUIBuilderEditLabelMainText;
begin
  Result := Self.Create(AParent, AHost, AEdit, AValidation);
end;

function TRickUIBuilderEditLabelMainText.Value(
  const AValue: string): IRickUIBuilderEditLabelMainText;
begin
  FControl.Text := AValue;
  Result := Self;
end;

function TRickUIBuilderEditLabelMainText.Size(
  AValue: Single): IRickUIBuilderEditLabelMainText;
begin
  FControl.TextSettings.Font.Size := AValue;
  Result := Self;
end;

function TRickUIBuilderEditLabelMainText.Color: IRickUIBuilderEditLabelMainTextColor;
begin
  if not Assigned(FColor) then
    FColor := TRickUIBuilderEditLabelMainTextColor.New(Self, FControl, FEdit,
      FValidation);
  Result := FColor;
end;

function TRickUIBuilderEditLabelMainText.ToBack: IRickUIBuilderEditLabelMain;
begin
  if not Assigned(FParent) then
    raise Exception.Create('O Parent da interface não foi informado para retornar.');
  Result := FParent;
end;

end.
