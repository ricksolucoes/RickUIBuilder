unit Rick.UIBuilder.Edit.Labels.Counter;

interface

uses
  FMX.Objects,
  FMX.StdCtrls,

  Rick.UIBuilder.Edit.Interfaces;

type
  TRickUIBuilderEditLabelCounter = class(TInterfacedObject, IRickUIBuilderEditLabelCounter)
  private
    [weak]
    FParent: IRickUIBuilderEditLabel;
    FControl: TLabel;
    FEnabled: Boolean;
  protected
    constructor Create(const AParent: IRickUIBuilderEditLabel; AHost: TRectangle);

    function Enabled(AValue: Boolean): IRickUIBuilderEditLabelCounter; overload;
    function Enabled: IRickUIBuilderEditLabelCounter; overload;
    function ToBack: IRickUIBuilderEditLabel;
  public
    class function New(const AParent: IRickUIBuilderEditLabel; AHost: TRectangle): IRickUIBuilderEditLabelCounter;
  end;

implementation

uses
  System.SysUtils,

  FMX.Types;

constructor TRickUIBuilderEditLabelCounter.Create(const AParent: IRickUIBuilderEditLabel; AHost: TRectangle);
begin
  inherited Create;
  FParent := AParent;
  FEnabled := False;
  FControl := TLabel.Create(AHost);
  FControl.Parent := AHost;
  FControl.SetBounds(AHost.Width - 72, AHost.Height - 20, 64, 16);
  FControl.TextSettings.HorzAlign := TTextAlign.Trailing;
  FControl.TextSettings.Font.Size := 11;
  FControl.Visible := False;
  FControl.HitTest := False;
end;

class function TRickUIBuilderEditLabelCounter.New(const AParent: IRickUIBuilderEditLabel; AHost: TRectangle): IRickUIBuilderEditLabelCounter;
begin
  Result := Self.Create(AParent, AHost);
end;

function TRickUIBuilderEditLabelCounter.Enabled(AValue: Boolean): IRickUIBuilderEditLabelCounter;
begin
  FEnabled := AValue;
  FControl.Visible := AValue;
  Result := Self;
end;

function TRickUIBuilderEditLabelCounter.Enabled: IRickUIBuilderEditLabelCounter;
begin
  Result := Enabled(True);
end;

function TRickUIBuilderEditLabelCounter.ToBack: IRickUIBuilderEditLabel;
begin
  if not Assigned(FParent) then
    raise Exception.Create('O Parent da interface não foi informado para retornar.');
  Result := FParent;
end;

end.
