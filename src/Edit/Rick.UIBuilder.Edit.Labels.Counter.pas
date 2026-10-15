unit Rick.UIBuilder.Edit.Labels.Counter;

interface

uses
  FMX.Edit,
  FMX.Objects,
  FMX.StdCtrls,
  System.Classes,

  Rick.UIBuilder.Edit.Interfaces;

type
  TRickUIBuilderEditLabelCounter = class(TComponent, IRickUIBuilderEditLabelCounter)
  private
    [weak]
    FParent: IRickUIBuilderEditLabel;
    FControl: TLabel;
    FEdit: TEdit;
    FPreviousChangeTracking: TNotifyEvent;
    procedure HandleChangeTracking(ASender: TObject);
    procedure UpdateCounter;
  protected
    constructor Create(const AParent: IRickUIBuilderEditLabel; AHost: TRectangle;
      AEdit: TEdit); reintroduce;

    function Enabled(AValue: Boolean): IRickUIBuilderEditLabelCounter; overload;
    function Enabled: IRickUIBuilderEditLabelCounter; overload;
    function ToBack: IRickUIBuilderEditLabel;
  public
    destructor Destroy; override;
    class function New(const AParent: IRickUIBuilderEditLabel; AHost: TRectangle;
      AEdit: TEdit): IRickUIBuilderEditLabelCounter;
  end;

implementation

uses
  FMX.Types,
  System.SysUtils;

constructor TRickUIBuilderEditLabelCounter.Create(
  const AParent: IRickUIBuilderEditLabel; AHost: TRectangle; AEdit: TEdit);
begin
  inherited Create(AEdit);
  FParent := AParent;
  FEdit := AEdit;
  FControl := TLabel.Create(AHost);
  FControl.Parent := AHost;
  FControl.SetBounds(AHost.Width - 72, AHost.Height - 20, 64, 16);
  FControl.TextSettings.HorzAlign := TTextAlign.Trailing;
  FControl.TextSettings.Font.Size := 11;
  FControl.Visible := False;
  FControl.HitTest := False;
  FPreviousChangeTracking := FEdit.OnChangeTracking;
  FEdit.OnChangeTracking := HandleChangeTracking;
  UpdateCounter;
end;

destructor TRickUIBuilderEditLabelCounter.Destroy;
begin
  if Assigned(FEdit) and not (csDestroying in FEdit.ComponentState) then
    FEdit.OnChangeTracking := FPreviousChangeTracking;
  inherited;
end;

class function TRickUIBuilderEditLabelCounter.New(
  const AParent: IRickUIBuilderEditLabel; AHost: TRectangle;
  AEdit: TEdit): IRickUIBuilderEditLabelCounter;
begin
  Result := Self.Create(AParent, AHost, AEdit);
end;

procedure TRickUIBuilderEditLabelCounter.HandleChangeTracking(ASender: TObject);
begin
  if Assigned(FPreviousChangeTracking) then
    FPreviousChangeTracking(ASender);
  UpdateCounter;
end;

procedure TRickUIBuilderEditLabelCounter.UpdateCounter;
begin
  if (not FControl.Visible) or (FEdit.MaxLength <= 0) then
  begin
    FControl.Text := EmptyStr;
    Exit;
  end;
  FControl.Text := Format('%d/%d', [Length(FEdit.Text), FEdit.MaxLength]);
end;

function TRickUIBuilderEditLabelCounter.Enabled(
  AValue: Boolean): IRickUIBuilderEditLabelCounter;
begin
  FControl.Visible := AValue;
  UpdateCounter;
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
