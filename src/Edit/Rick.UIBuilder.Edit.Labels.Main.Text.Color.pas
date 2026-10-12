unit Rick.UIBuilder.Edit.Labels.Main.Text.Color;

interface

uses
  FMX.StdCtrls,
  System.UITypes,

  Rick.UIBuilder.Edit.Interfaces;

type
  TRickUIBuilderEditLabelMainTextColor = class(TInterfacedObject, IRickUIBuilderEditLabelMainTextColor)
  private
    [weak]
    FParent: IRickUIBuilderEditLabelMainText;
    FControl: TLabel;
    FTextColor: TAlphaColor;
    FInvalidColor: TAlphaColor;
    FReadOnlyColor: TAlphaColor;
  protected
    constructor Create(const AParent: IRickUIBuilderEditLabelMainText; AControl: TLabel);

    function Text(AValue: TAlphaColor): IRickUIBuilderEditLabelMainTextColor;
    function Invalid(AValue: TAlphaColor): IRickUIBuilderEditLabelMainText;
    function ReadOnly(AValue: TAlphaColor): IRickUIBuilderEditLabelMainText;
    function ToBack: IRickUIBuilderEditLabelMainText;
  public
    class function New(const AParent: IRickUIBuilderEditLabelMainText; AControl: TLabel): IRickUIBuilderEditLabelMainTextColor;
  end;

implementation

uses
  System.SysUtils;

constructor TRickUIBuilderEditLabelMainTextColor.Create(const AParent: IRickUIBuilderEditLabelMainText; AControl: TLabel);
begin
  inherited Create;
  FParent := AParent;
  FControl := AControl;
  FTextColor := $FF606060;
  FInvalidColor := $FFD93025;
  FReadOnlyColor := $FFB8B8B8;
end;

class function TRickUIBuilderEditLabelMainTextColor.New(const AParent: IRickUIBuilderEditLabelMainText; AControl: TLabel): IRickUIBuilderEditLabelMainTextColor;
begin
  Result := Self.Create(AParent, AControl);
end;

function TRickUIBuilderEditLabelMainTextColor.Text(AValue: TAlphaColor): IRickUIBuilderEditLabelMainTextColor;
begin
  FTextColor := AValue;
  FControl.TextSettings.FontColor := AValue;
  Result := Self;
end;

function TRickUIBuilderEditLabelMainTextColor.Invalid(AValue: TAlphaColor): IRickUIBuilderEditLabelMainText;
begin
  FInvalidColor := AValue;
  Result := ToBack;
end;

function TRickUIBuilderEditLabelMainTextColor.ReadOnly(AValue: TAlphaColor): IRickUIBuilderEditLabelMainText;
begin
  FReadOnlyColor := AValue;
  Result := ToBack;
end;

function TRickUIBuilderEditLabelMainTextColor.ToBack: IRickUIBuilderEditLabelMainText;
begin
  if not Assigned(FParent) then
    raise Exception.Create('O Parent da interface não foi informado para retornar.');
  Result := FParent;
end;

end.
