unit Rick.UIBuilder.Edit.Labels.Main.Text.Color;

interface

uses
  FMX.StdCtrls,
  System.UITypes,

  Rick.UIBuilder.Edit.Interfaces,
  Rick.UIBuilder.Edit.VisualState;

type
  TRickUIBuilderEditLabelMainTextColor = class(TInterfacedObject, IRickUIBuilderEditLabelMainTextColor)
  private
    [weak]
    FParent: IRickUIBuilderEditLabelMainText;
    FControl: TLabel;
    FVisualState: TRickUIBuilderEditVisualState;
    FTextColor: TAlphaColor;
    FInvalidColor: TAlphaColor;
    FReadOnlyColor: TAlphaColor;
    procedure ApplyState(ASender: TObject);
  protected
    constructor Create(const AParent: IRickUIBuilderEditLabelMainText; AControl: TLabel; AVisualState: TRickUIBuilderEditVisualState);

    function Text(AValue: TAlphaColor): IRickUIBuilderEditLabelMainTextColor;
    function Invalid(AValue: TAlphaColor): IRickUIBuilderEditLabelMainText;
    function ReadOnly(AValue: TAlphaColor): IRickUIBuilderEditLabelMainText;
    function ToBack: IRickUIBuilderEditLabelMainText;
  public
    class function New(const AParent: IRickUIBuilderEditLabelMainText; AControl: TLabel; AVisualState: TRickUIBuilderEditVisualState): IRickUIBuilderEditLabelMainTextColor;
  end;

implementation

uses
  System.SysUtils;

constructor TRickUIBuilderEditLabelMainTextColor.Create(const AParent: IRickUIBuilderEditLabelMainText; AControl: TLabel; AVisualState: TRickUIBuilderEditVisualState);
begin
  inherited Create;
  FParent := AParent;
  FControl := AControl;
  FVisualState := AVisualState;
  FTextColor := $FF606060;
  FInvalidColor := $FFD93025;
  FReadOnlyColor := $FFB8B8B8;
  FVisualState.RegisterHandler(ApplyState, AParent);
  ApplyState(nil);
end;

class function TRickUIBuilderEditLabelMainTextColor.New(const AParent: IRickUIBuilderEditLabelMainText; AControl: TLabel; AVisualState: TRickUIBuilderEditVisualState): IRickUIBuilderEditLabelMainTextColor;
begin
  Result := Self.Create(AParent, AControl, AVisualState);
end;

procedure TRickUIBuilderEditLabelMainTextColor.ApplyState(ASender: TObject);
begin
  if FVisualState.IsInvalid then
    FControl.TextSettings.FontColor := FInvalidColor
  else if FVisualState.IsReadOnly then
    FControl.TextSettings.FontColor := FReadOnlyColor
  else
    FControl.TextSettings.FontColor := FTextColor;
end;

function TRickUIBuilderEditLabelMainTextColor.Text(AValue: TAlphaColor): IRickUIBuilderEditLabelMainTextColor;
begin
  FTextColor := AValue;
  ApplyState(nil);
  Result := Self;
end;

function TRickUIBuilderEditLabelMainTextColor.Invalid(AValue: TAlphaColor): IRickUIBuilderEditLabelMainText;
begin
  FInvalidColor := AValue;
  ApplyState(nil);
  Result := ToBack;
end;

function TRickUIBuilderEditLabelMainTextColor.ReadOnly(AValue: TAlphaColor): IRickUIBuilderEditLabelMainText;
begin
  FReadOnlyColor := AValue;
  ApplyState(nil);
  Result := ToBack;
end;

function TRickUIBuilderEditLabelMainTextColor.ToBack: IRickUIBuilderEditLabelMainText;
begin
  if not Assigned(FParent) then
    raise Exception.Create('O Parent da interface não foi informado para retornar.');
  Result := FParent;
end;

end.
