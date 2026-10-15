unit Rick.UIBuilder.Edit.Labels.Error;

interface

uses
  FMX.Edit,
  FMX.Objects,

  Rick.UIBuilder.Edit.Interfaces;

type
  TRickUIBuilderEditLabelError = class(TInterfacedObject, IRickUIBuilderEditLabelError)
  private
    [weak]
    FParent: IRickUIBuilderEditLabel;
    FHost: TRectangle;
    FEdit: TEdit;
    FValidation: IRickUIBuilderEditDesignerValidation;
    FText: IRickUIBuilderEditLabelErrorText;
  protected
    constructor Create(const AParent: IRickUIBuilderEditLabel; AHost: TRectangle;
      AEdit: TEdit; const AValidation: IRickUIBuilderEditDesignerValidation);

    function Text: IRickUIBuilderEditLabelErrorText;
    function ToBack: IRickUIBuilderEditLabel;
  public
    class function New(const AParent: IRickUIBuilderEditLabel; AHost: TRectangle;
      AEdit: TEdit; const AValidation: IRickUIBuilderEditDesignerValidation): IRickUIBuilderEditLabelError;
  end;

implementation

uses
  System.SysUtils,

  Rick.UIBuilder.Edit.Labels.Error.Text;

constructor TRickUIBuilderEditLabelError.Create(
  const AParent: IRickUIBuilderEditLabel; AHost: TRectangle; AEdit: TEdit;
  const AValidation: IRickUIBuilderEditDesignerValidation);
begin
  inherited Create;
  FParent := AParent;
  FHost := AHost;
  FEdit := AEdit;
  FValidation := AValidation;
end;

class function TRickUIBuilderEditLabelError.New(
  const AParent: IRickUIBuilderEditLabel; AHost: TRectangle; AEdit: TEdit;
  const AValidation: IRickUIBuilderEditDesignerValidation): IRickUIBuilderEditLabelError;
begin
  Result := Self.Create(AParent, AHost, AEdit, AValidation);
end;

function TRickUIBuilderEditLabelError.Text: IRickUIBuilderEditLabelErrorText;
begin
  if not Assigned(FText) then
    FText := TRickUIBuilderEditLabelErrorText.New(Self, FHost, FEdit,
      FValidation);
  Result := FText;
end;

function TRickUIBuilderEditLabelError.ToBack: IRickUIBuilderEditLabel;
begin
  if not Assigned(FParent) then
    raise Exception.Create('O Parent da interface não foi informado para retornar.');
  Result := FParent;
end;

end.
