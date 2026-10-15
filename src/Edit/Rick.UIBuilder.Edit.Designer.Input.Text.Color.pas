unit Rick.UIBuilder.Edit.Designer.Input.Text.Color;

interface

uses
  FMX.Edit,
  FMX.Objects,
  System.Classes,
  System.UITypes,

  Rick.UIBuilder.Edit.Interfaces;

type
  TRickUIBuilderEditDesignerInputTextColor = class(TComponent, IRickUIBuilderEditDesignerInputTextColor)
  private
    [weak]
    FParent: IRickUIBuilderEditDesignerInputText;
    FControl: TEdit;
    FBackground: TRectangle;
    FTextColor: TAlphaColor;
    FReadOnlyColor: TAlphaColor;
    FPreviousEnter: TNotifyEvent;
    FPreviousExit: TNotifyEvent;
    procedure ApplyState;
    procedure HandleEnter(ASender: TObject);
    procedure HandleExit(ASender: TObject);
  protected
    constructor Create(const AParent: IRickUIBuilderEditDesignerInputText;
      AControl: TEdit; ABackground: TRectangle); reintroduce;

    function Background(AValue: TAlphaColor): IRickUIBuilderEditDesignerInputTextColor;
    function Text(AValue: TAlphaColor): IRickUIBuilderEditDesignerInputTextColor;
    function ReadOnly(AValue: TAlphaColor): IRickUIBuilderEditDesignerInputTextColor;
    function ToBack: IRickUIBuilderEditDesignerInputText;
  public
    destructor Destroy; override;
    class function New(const AParent: IRickUIBuilderEditDesignerInputText;
      AControl: TEdit; ABackground: TRectangle): IRickUIBuilderEditDesignerInputTextColor;
  end;

implementation

uses
  System.SysUtils;

constructor TRickUIBuilderEditDesignerInputTextColor.Create(
  const AParent: IRickUIBuilderEditDesignerInputText; AControl: TEdit;
  ABackground: TRectangle);
begin
  inherited Create(AControl);
  FParent := AParent;
  FControl := AControl;
  FBackground := ABackground;
  FTextColor := TAlphaColors.Black;
  FReadOnlyColor := $FFB8B8B8;
  FPreviousEnter := FControl.OnEnter;
  FPreviousExit := FControl.OnExit;
  FControl.OnEnter := HandleEnter;
  FControl.OnExit := HandleExit;
  ApplyState;
end;

destructor TRickUIBuilderEditDesignerInputTextColor.Destroy;
begin
  if Assigned(FControl) and not (csDestroying in FControl.ComponentState) then
  begin
    FControl.OnEnter := FPreviousEnter;
    FControl.OnExit := FPreviousExit;
  end;
  inherited;
end;

class function TRickUIBuilderEditDesignerInputTextColor.New(
  const AParent: IRickUIBuilderEditDesignerInputText; AControl: TEdit;
  ABackground: TRectangle): IRickUIBuilderEditDesignerInputTextColor;
begin
  Result := Self.Create(AParent, AControl, ABackground);
end;

procedure TRickUIBuilderEditDesignerInputTextColor.ApplyState;
begin
  if FControl.ReadOnly then
    FControl.TextSettings.FontColor := FReadOnlyColor
  else
    FControl.TextSettings.FontColor := FTextColor;
end;

procedure TRickUIBuilderEditDesignerInputTextColor.HandleEnter(ASender: TObject);
begin
  ApplyState;
  if Assigned(FPreviousEnter) then
    FPreviousEnter(ASender);
end;

procedure TRickUIBuilderEditDesignerInputTextColor.HandleExit(ASender: TObject);
begin
  ApplyState;
  if Assigned(FPreviousExit) then
    FPreviousExit(ASender);
end;

function TRickUIBuilderEditDesignerInputTextColor.Background(
  AValue: TAlphaColor): IRickUIBuilderEditDesignerInputTextColor;
begin
  FBackground.Fill.Color := AValue;
  Result := Self;
end;

function TRickUIBuilderEditDesignerInputTextColor.Text(
  AValue: TAlphaColor): IRickUIBuilderEditDesignerInputTextColor;
begin
  FTextColor := AValue;
  ApplyState;
  Result := Self;
end;

function TRickUIBuilderEditDesignerInputTextColor.ReadOnly(
  AValue: TAlphaColor): IRickUIBuilderEditDesignerInputTextColor;
begin
  FReadOnlyColor := AValue;
  ApplyState;
  Result := Self;
end;

function TRickUIBuilderEditDesignerInputTextColor.ToBack: IRickUIBuilderEditDesignerInputText;
begin
  if not Assigned(FParent) then
    raise Exception.Create('O Parent da interface não foi informado para retornar.');
  Result := FParent;
end;

end.
