unit Rick.UIBuilder.Edit.Labels.Main;

interface

uses
  FMX.Edit,
  FMX.Objects,

  Rick.UIBuilder.Edit.Interfaces;

type
  TRickUIBuilderEditLabelMain = class(TInterfacedObject, IRickUIBuilderEditLabelMain)
  private
    [weak]
    FParent: IRickUIBuilderEditLabel;
    FHost: TRectangle;
    FEdit: TEdit;
    FValidation: IRickUIBuilderEditDesignerValidation;
    FText: IRickUIBuilderEditLabelMainText;
  protected
    constructor Create(const AParent: IRickUIBuilderEditLabel; AHost: TRectangle;
      AEdit: TEdit; const AValidation: IRickUIBuilderEditDesignerValidation);

    function Text: IRickUIBuilderEditLabelMainText;
    function ToBack: IRickUIBuilderEditLabel;
  public
    class function New(const AParent: IRickUIBuilderEditLabel; AHost: TRectangle;
      AEdit: TEdit; const AValidation: IRickUIBuilderEditDesignerValidation): IRickUIBuilderEditLabelMain;
  end;

implementation

uses
  System.SysUtils,

  Rick.UIBuilder.Edit.Labels.Main.Text;

constructor TRickUIBuilderEditLabelMain.Create(
  const AParent: IRickUIBuilderEditLabel; AHost: TRectangle; AEdit: TEdit;
  const AValidation: IRickUIBuilderEditDesignerValidation);
begin
  inherited Create;
  FParent := AParent;
  FHost := AHost;
  FEdit := AEdit;
  FValidation := AValidation;
end;

class function TRickUIBuilderEditLabelMain.New(
  const AParent: IRickUIBuilderEditLabel; AHost: TRectangle; AEdit: TEdit;
  const AValidation: IRickUIBuilderEditDesignerValidation): IRickUIBuilderEditLabelMain;
begin
  Result := Self.Create(AParent, AHost, AEdit, AValidation);
end;

function TRickUIBuilderEditLabelMain.Text: IRickUIBuilderEditLabelMainText;
begin
  if not Assigned(FText) then
    FText := TRickUIBuilderEditLabelMainText.New(Self, FHost, FEdit, FValidation);
  Result := FText;
end;

function TRickUIBuilderEditLabelMain.ToBack: IRickUIBuilderEditLabel;
begin
  if not Assigned(FParent) then
    raise Exception.Create('O Parent da interface não foi informado para retornar.');
  Result := FParent;
end;

end.
