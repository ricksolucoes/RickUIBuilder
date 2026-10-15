unit Rick.UIBuilder.Edit.Labels;

interface

uses
  FMX.Edit,
  FMX.Objects,

  Rick.UIBuilder.Edit.Interfaces;

type
  TRickUIBuilderEditLabel = class(TInterfacedObject, IRickUIBuilderEditLabel)
  private
    [weak]
    FParent: IRickUIBuilderEdit;
    FHost: TRectangle;
    FEdit: TEdit;
    FValidation: IRickUIBuilderEditDesignerValidation;
    FMain: IRickUIBuilderEditLabelMain;
    FCounter: IRickUIBuilderEditLabelCounter;
    FError: IRickUIBuilderEditLabelError;
  protected
    constructor Create(const AParent: IRickUIBuilderEdit; AHost: TRectangle;
      AEdit: TEdit; const AValidation: IRickUIBuilderEditDesignerValidation);

    function Main: IRickUIBuilderEditLabelMain;
    function Counter: IRickUIBuilderEditLabelCounter;
    function Error: IRickUIBuilderEditLabelError;
    function ToBack: IRickUIBuilderEdit;
  public
    class function New(const AParent: IRickUIBuilderEdit; AHost: TRectangle;
      AEdit: TEdit; const AValidation: IRickUIBuilderEditDesignerValidation): IRickUIBuilderEditLabel;
  end;

implementation

uses
  System.SysUtils,

  Rick.UIBuilder.Edit.Labels.Counter,
  Rick.UIBuilder.Edit.Labels.Error,
  Rick.UIBuilder.Edit.Labels.Main;

constructor TRickUIBuilderEditLabel.Create(const AParent: IRickUIBuilderEdit;
  AHost: TRectangle; AEdit: TEdit;
  const AValidation: IRickUIBuilderEditDesignerValidation);
begin
  inherited Create;
  FParent := AParent;
  FHost := AHost;
  FEdit := AEdit;
  FValidation := AValidation;
end;

class function TRickUIBuilderEditLabel.New(const AParent: IRickUIBuilderEdit;
  AHost: TRectangle; AEdit: TEdit;
  const AValidation: IRickUIBuilderEditDesignerValidation): IRickUIBuilderEditLabel;
begin
  Result := Self.Create(AParent, AHost, AEdit, AValidation);
end;

function TRickUIBuilderEditLabel.Main: IRickUIBuilderEditLabelMain;
begin
  if not Assigned(FMain) then
    FMain := TRickUIBuilderEditLabelMain.New(Self, FHost, FEdit, FValidation);
  Result := FMain;
end;

function TRickUIBuilderEditLabel.Counter: IRickUIBuilderEditLabelCounter;
begin
  if not Assigned(FCounter) then
    FCounter := TRickUIBuilderEditLabelCounter.New(Self, FHost, FEdit);
  Result := FCounter;
end;

function TRickUIBuilderEditLabel.Error: IRickUIBuilderEditLabelError;
begin
  if not Assigned(FError) then
    FError := TRickUIBuilderEditLabelError.New(Self, FHost, FEdit, FValidation);
  Result := FError;
end;

function TRickUIBuilderEditLabel.ToBack: IRickUIBuilderEdit;
begin
  if not Assigned(FParent) then
    raise Exception.Create('O Parent da interface não foi informado para retornar.');
  Result := FParent;
end;

end.
