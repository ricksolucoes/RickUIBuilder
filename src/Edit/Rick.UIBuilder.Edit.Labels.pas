unit Rick.UIBuilder.Edit.Labels;

interface

uses
  FMX.Objects,

  Rick.UIBuilder.Edit.InputRules,
  Rick.UIBuilder.Edit.Interfaces,
  Rick.UIBuilder.Edit.VisualState;

type
  TRickUIBuilderEditLabel = class(TInterfacedObject, IRickUIBuilderEditLabel)
  private
    [weak]
    FParent: IRickUIBuilderEdit;
    FHost: TRectangle;
    FInputRules: TRickUIBuilderEditInputRules;
    FVisualState: TRickUIBuilderEditVisualState;
    FMain: IRickUIBuilderEditLabelMain;
    FCounter: IRickUIBuilderEditLabelCounter;
    FError: IRickUIBuilderEditLabelError;
  protected
    constructor Create(const AParent: IRickUIBuilderEdit; AHost: TRectangle; AInputRules: TRickUIBuilderEditInputRules; AVisualState: TRickUIBuilderEditVisualState);

    function Main: IRickUIBuilderEditLabelMain;
    function Counter: IRickUIBuilderEditLabelCounter;
    function Error: IRickUIBuilderEditLabelError;
    function ToBack: IRickUIBuilderEdit;
  public
    class function New(const AParent: IRickUIBuilderEdit; AHost: TRectangle; AInputRules: TRickUIBuilderEditInputRules; AVisualState: TRickUIBuilderEditVisualState): IRickUIBuilderEditLabel;
  end;

implementation

uses
  System.SysUtils,

  Rick.UIBuilder.Edit.Labels.Counter,
  Rick.UIBuilder.Edit.Labels.Error,
  Rick.UIBuilder.Edit.Labels.Main;

constructor TRickUIBuilderEditLabel.Create(const AParent: IRickUIBuilderEdit; AHost: TRectangle; AInputRules: TRickUIBuilderEditInputRules; AVisualState: TRickUIBuilderEditVisualState);
begin
  inherited Create;
  FParent := AParent;
  FHost := AHost;
  FInputRules := AInputRules;
  FVisualState := AVisualState;
end;

class function TRickUIBuilderEditLabel.New(const AParent: IRickUIBuilderEdit; AHost: TRectangle; AInputRules: TRickUIBuilderEditInputRules; AVisualState: TRickUIBuilderEditVisualState): IRickUIBuilderEditLabel;
begin
  Result := Self.Create(AParent, AHost, AInputRules, AVisualState);
end;

function TRickUIBuilderEditLabel.Main: IRickUIBuilderEditLabelMain;
begin
  if not Assigned(FMain) then
    FMain := TRickUIBuilderEditLabelMain.New(Self, FHost, FVisualState);
  Result := FMain;
end;

function TRickUIBuilderEditLabel.Counter: IRickUIBuilderEditLabelCounter;
begin
  if not Assigned(FCounter) then
    FCounter := TRickUIBuilderEditLabelCounter.New(Self, FHost, FInputRules);
  Result := FCounter;
end;

function TRickUIBuilderEditLabel.Error: IRickUIBuilderEditLabelError;
begin
  if not Assigned(FError) then
    FError := TRickUIBuilderEditLabelError.New(Self, FHost, FInputRules);
  Result := FError;
end;

function TRickUIBuilderEditLabel.ToBack: IRickUIBuilderEdit;
begin
  if not Assigned(FParent) then
    raise Exception.Create('O Parent da interface não foi informado para retornar.');
  Result := FParent;
end;

end.
