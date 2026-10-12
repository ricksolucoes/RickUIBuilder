unit Rick.UIBuilder.Edit.Labels.Error.Text.Font;

interface

uses
  FMX.StdCtrls,
  System.UITypes,

  Rick.UIBuilder.Edit.Interfaces;

type
  TRickUIBuilderEditLabelErrorTextFont = class(TInterfacedObject, IRickUIBuilderEditLabelErrorTextFont)
  private
    [weak]
    FParent: IRickUIBuilderEditLabelErrorText;
    FControl: TLabel;
  protected
    constructor Create(const AParent: IRickUIBuilderEditLabelErrorText; AControl: TLabel);

    function Family(const AValue: string): IRickUIBuilderEditLabelErrorTextFont;
    function Size(AValue: Single): IRickUIBuilderEditLabelErrorTextFont;
    function Styles(AValue: TFontStyles): IRickUIBuilderEditLabelErrorTextFont;
    function ToBack: IRickUIBuilderEditLabelErrorText;
  public
    class function New(const AParent: IRickUIBuilderEditLabelErrorText; AControl: TLabel): IRickUIBuilderEditLabelErrorTextFont;
  end;

implementation

uses
  System.SysUtils;

constructor TRickUIBuilderEditLabelErrorTextFont.Create(const AParent: IRickUIBuilderEditLabelErrorText; AControl: TLabel);
begin
  inherited Create;
  FParent := AParent;
  FControl := AControl;
end;

class function TRickUIBuilderEditLabelErrorTextFont.New(const AParent: IRickUIBuilderEditLabelErrorText; AControl: TLabel): IRickUIBuilderEditLabelErrorTextFont;
begin
  Result := Self.Create(AParent, AControl);
end;

function TRickUIBuilderEditLabelErrorTextFont.Family(const AValue: string): IRickUIBuilderEditLabelErrorTextFont;
begin
  FControl.TextSettings.Font.Family := AValue;
  Result := Self;
end;

function TRickUIBuilderEditLabelErrorTextFont.Size(AValue: Single): IRickUIBuilderEditLabelErrorTextFont;
begin
  FControl.TextSettings.Font.Size := AValue;
  Result := Self;
end;

function TRickUIBuilderEditLabelErrorTextFont.Styles(AValue: TFontStyles): IRickUIBuilderEditLabelErrorTextFont;
begin
  FControl.TextSettings.Font.Style := AValue;
  Result := Self;
end;

function TRickUIBuilderEditLabelErrorTextFont.ToBack: IRickUIBuilderEditLabelErrorText;
begin
  if not Assigned(FParent) then
    raise Exception.Create('O Parent da interface não foi informado para retornar.');
  Result := FParent;
end;

end.
