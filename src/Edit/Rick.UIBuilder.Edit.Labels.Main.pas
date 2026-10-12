unit Rick.UIBuilder.Edit.Labels.Main;

interface

uses
  FMX.Objects,

  Rick.UIBuilder.Edit.Interfaces,
  Rick.UIBuilder.Edit.VisualState;

type
  TRickUIBuilderEditLabelMain = class(TInterfacedObject, IRickUIBuilderEditLabelMain)
  private
    [weak]
    FParent: IRickUIBuilderEditLabel;
    FHost: TRectangle;
    FVisualState: TRickUIBuilderEditVisualState;
    FText: IRickUIBuilderEditLabelMainText;
  protected
    constructor Create(const AParent: IRickUIBuilderEditLabel; AHost: TRectangle; AVisualState: TRickUIBuilderEditVisualState);

    function Text: IRickUIBuilderEditLabelMainText;
    function ToBack: IRickUIBuilderEditLabel;
  public
    class function New(const AParent: IRickUIBuilderEditLabel; AHost: TRectangle; AVisualState: TRickUIBuilderEditVisualState): IRickUIBuilderEditLabelMain;
  end;

implementation

uses
  System.SysUtils,

  Rick.UIBuilder.Edit.Labels.Main.Text;

constructor TRickUIBuilderEditLabelMain.Create(const AParent: IRickUIBuilderEditLabel; AHost: TRectangle; AVisualState: TRickUIBuilderEditVisualState);
begin
  inherited Create;
  FParent := AParent;
  FHost := AHost;
  FVisualState := AVisualState;
end;

class function TRickUIBuilderEditLabelMain.New(const AParent: IRickUIBuilderEditLabel; AHost: TRectangle; AVisualState: TRickUIBuilderEditVisualState): IRickUIBuilderEditLabelMain;
begin
  Result := Self.Create(AParent, AHost, AVisualState);
end;

function TRickUIBuilderEditLabelMain.Text: IRickUIBuilderEditLabelMainText;
begin
  if not Assigned(FText) then
    FText := TRickUIBuilderEditLabelMainText.New(Self, FHost, FVisualState);
  Result := FText;
end;

function TRickUIBuilderEditLabelMain.ToBack: IRickUIBuilderEditLabel;
begin
  if not Assigned(FParent) then
    raise Exception.Create('O Parent da interface não foi informado para retornar.');
  Result := FParent;
end;

end.
