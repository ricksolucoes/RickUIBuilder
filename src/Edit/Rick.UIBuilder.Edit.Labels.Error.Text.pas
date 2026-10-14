unit Rick.UIBuilder.Edit.Labels.Error.Text;

interface

uses
  FMX.Objects,
  FMX.StdCtrls,
  System.UITypes,

  Rick.UIBuilder.Edit.InputRules,
  Rick.UIBuilder.Edit.Interfaces;

type
  TRickUIBuilderEditLabelErrorText = class(TInterfacedObject, IRickUIBuilderEditLabelErrorText)
  private
    [weak]
    FParent: IRickUIBuilderEditLabelError;
    FControl: TLabel;
    FFont: IRickUIBuilderEditLabelErrorTextFont;
  protected
    constructor Create(const AParent: IRickUIBuilderEditLabelError; AHost: TRectangle; AInputRules: TRickUIBuilderEditInputRules);

    function Value(AValue: string): IRickUIBuilderEditLabelErrorText;
    function Color(AValue: TAlphaColor): IRickUIBuilderEditLabelErrorText;
    function Spacing(AValue: Single): IRickUIBuilderEditLabelErrorText;
    function Font: IRickUIBuilderEditLabelErrorTextFont;
    function ToBack: IRickUIBuilderEditLabelError;
  public
    class function New(const AParent: IRickUIBuilderEditLabelError; AHost: TRectangle; AInputRules: TRickUIBuilderEditInputRules): IRickUIBuilderEditLabelErrorText;
  end;

implementation

uses
  System.SysUtils,

  FMX.Types,

  Rick.UIBuilder.Edit.Labels.Error.Text.Font;

constructor TRickUIBuilderEditLabelErrorText.Create(const AParent: IRickUIBuilderEditLabelError; AHost: TRectangle; AInputRules: TRickUIBuilderEditInputRules);
begin
  inherited Create;
  FParent := AParent;
  FControl := TLabel.Create(AHost);
  FControl.Parent := AHost;
  FControl.SetBounds(12, 52, AHost.Width - 24, 18);
  FControl.StyledSettings := FControl.StyledSettings - [TStyledSetting.Family, TStyledSetting.Size, TStyledSetting.Style, TStyledSetting.FontColor];
  FControl.TextSettings.Font.Size := 11;
  FControl.TextSettings.FontColor := $FFD93025;
  FControl.Visible := False;
  FControl.HitTest := False;
  AInputRules.BindErrorLabel(FControl);
end;

class function TRickUIBuilderEditLabelErrorText.New(const AParent: IRickUIBuilderEditLabelError; AHost: TRectangle; AInputRules: TRickUIBuilderEditInputRules): IRickUIBuilderEditLabelErrorText;
begin
  Result := Self.Create(AParent, AHost, AInputRules);
end;

function TRickUIBuilderEditLabelErrorText.Value(AValue: string): IRickUIBuilderEditLabelErrorText;
begin
  FControl.Text := AValue;
  Result := Self;
end;

function TRickUIBuilderEditLabelErrorText.Color(AValue: TAlphaColor): IRickUIBuilderEditLabelErrorText;
begin
  FControl.TextSettings.FontColor := AValue;
  Result := Self;
end;

function TRickUIBuilderEditLabelErrorText.Spacing(AValue: Single): IRickUIBuilderEditLabelErrorText;
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
