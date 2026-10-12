unit Rick.UIBuilder.Edit.Labels.Error;

interface

uses
  FMX.Objects,

  Rick.UIBuilder.Edit.Interfaces;

type
  TRickUIBuilderEditLabelError = class(TInterfacedObject, IRickUIBuilderEditLabelError)
  private
    [weak]
    FParent: IRickUIBuilderEditLabel;
    FHost: TRectangle;
    FText: IRickUIBuilderEditLabelErrorText;
  protected
    constructor Create(const AParent: IRickUIBuilderEditLabel; AHost: TRectangle);

    function Text: IRickUIBuilderEditLabelErrorText;
    function ToBack: IRickUIBuilderEditLabel;
  public
    class function New(const AParent: IRickUIBuilderEditLabel; AHost: TRectangle): IRickUIBuilderEditLabelError;
  end;

implementation

uses
  System.SysUtils,

  Rick.UIBuilder.Edit.Labels.Error.Text;

constructor TRickUIBuilderEditLabelError.Create(const AParent: IRickUIBuilderEditLabel; AHost: TRectangle);
begin
  inherited Create;
  FParent := AParent;
  FHost := AHost;
end;

class function TRickUIBuilderEditLabelError.New(const AParent: IRickUIBuilderEditLabel; AHost: TRectangle): IRickUIBuilderEditLabelError;
begin
  Result := Self.Create(AParent, AHost);
end;

function TRickUIBuilderEditLabelError.Text: IRickUIBuilderEditLabelErrorText;
begin
  if not Assigned(FText) then
    FText := TRickUIBuilderEditLabelErrorText.New(Self, FHost);
  Result := FText;
end;

function TRickUIBuilderEditLabelError.ToBack: IRickUIBuilderEditLabel;
begin
  if not Assigned(FParent) then
    raise Exception.Create('O Parent da interface não foi informado para retornar.');
  Result := FParent;
end;

end.
