unit Rick.UIBuilder.Edit.Labels.Main;

interface

uses
  FMX.Objects,

  Rick.UIBuilder.Edit.Interfaces;

type
  TRickUIBuilderEditLabelMain = class(TInterfacedObject, IRickUIBuilderEditLabelMain)
  private
    [weak]
    FParent: IRickUIBuilderEditLabel;
    FHost: TRectangle;
    FText: IRickUIBuilderEditLabelMainText;
  protected
    constructor Create(const AParent: IRickUIBuilderEditLabel; AHost: TRectangle);

    function Text: IRickUIBuilderEditLabelMainText;
    function ToBack: IRickUIBuilderEditLabel;
  public
    class function New(const AParent: IRickUIBuilderEditLabel; AHost: TRectangle): IRickUIBuilderEditLabelMain;
  end;

implementation

uses
  System.SysUtils,

  Rick.UIBuilder.Edit.Labels.Main.Text;

constructor TRickUIBuilderEditLabelMain.Create(const AParent: IRickUIBuilderEditLabel; AHost: TRectangle);
begin
  inherited Create;
  FParent := AParent;
  FHost := AHost;
end;

class function TRickUIBuilderEditLabelMain.New(const AParent: IRickUIBuilderEditLabel; AHost: TRectangle): IRickUIBuilderEditLabelMain;
begin
  Result := Self.Create(AParent, AHost);
end;

function TRickUIBuilderEditLabelMain.Text: IRickUIBuilderEditLabelMainText;
begin
  if not Assigned(FText) then
    FText := TRickUIBuilderEditLabelMainText.New(Self, FHost);
  Result := FText;
end;

function TRickUIBuilderEditLabelMain.ToBack: IRickUIBuilderEditLabel;
begin
  if not Assigned(FParent) then
    raise Exception.Create('O Parent da interface não foi informado para retornar.');
  Result := FParent;
end;

end.
