unit Rick.UIBuilder.ComboBox;
(*
  ============================================================================
  Unit: Rick.UIBuilder.ComboBox
  ============================================================================

  RESPONSABILIDADE

  Implementa o builder fluente publico do ComboBox. A unit acumula apenas
  configuracao, itens e eventos ate Build/BuildHandle; a materializacao visual
  continua delegada a Rick.UIBuilder.Factory e o comportamento runtime fica no
  handle especializado.
  ============================================================================
*)

interface

uses
  System.Classes,
  System.Generics.Collections,
  System.UITypes,
  FMX.Types,
  FMX.Objects,
  Rick.UIBuilder.Types,
  Rick.UIBuilder.Interfaces;

type
  TRickUIBuilderComboBoxBuilder = class(TInterfacedObject,
    IRickUIBuilderComboBox)
  strict private
    FConfig: TRickUIBuilderComboBoxConfig;
    FItems: TList<TRickUIBuilderComboBoxItem>;
    FColumns: TList<TRickUIBuilderComboBoxColumn>;
    FPlaceholder: string;
    FInitialIndex: Integer;
    FInitialText: string;
    FUseInitialText: Boolean;
    FHeightOverridden: Boolean;
    FItemHeightOverridden: Boolean;
    FArrowSizeOverridden: Boolean;
    FOnChange: TNotifyEvent;
    FOnOpen: TNotifyEvent;
    FOnClose: TNotifyEvent;
    FOnCustomizeItem: TRickUIBuilderComboBoxCustomizeItemEvent;
    function ResolvedConfig: TRickUIBuilderComboBoxConfig;
    function BuildCore(AParent: TFmxObject;
      out AHandle: IRickUIBuilderComboBoxHandle): TRectangle;
  protected
    constructor Create;
    function Position(ALeft, ATop: Single): IRickUIBuilderComboBox;
    function Size(AWidth, AHeight: Single): IRickUIBuilderComboBox;
    function Placeholder(const AValue: string): IRickUIBuilderComboBox;
    function Items(const AItems: array of string): IRickUIBuilderComboBox;
    function AddItem(const ADisplayText: string): IRickUIBuilderComboBox; overload;
    function AddItem(const ADisplayText,
      AValue: string): IRickUIBuilderComboBox; overload;
    function AddStructuredItem(const ADisplayText, AValue: string;
      const AColumns: array of string): IRickUIBuilderComboBox;
    function Column(
      const AValue: TRickUIBuilderComboBoxColumn): IRickUIBuilderComboBox;
    function ItemIndex(AValue: Integer): IRickUIBuilderComboBox;
    function SelectedText(const AValue: string): IRickUIBuilderComboBox;
    function StyleType(
      AValue: TRickUIBuilderComboBoxStyleType): IRickUIBuilderComboBox;
    function CustomConfig(
      const AValue: TRickUIBuilderComboBoxConfig): IRickUIBuilderComboBox;
    function PresentationMode(
      AValue: TRickUIBuilderComboBoxPresentationMode): IRickUIBuilderComboBox;
    function ItemHeight(AValue: Single): IRickUIBuilderComboBox;
    function PopupMaxHeight(AValue: Single): IRickUIBuilderComboBox;
    function PopupWidthOffset(AValue: Single): IRickUIBuilderComboBox;
    function ArrowColor(AValue: TAlphaColor): IRickUIBuilderComboBox;
    function ArrowSize(AValue: Single): IRickUIBuilderComboBox;
    function ArrowPosition(
      AValue: TRickUIBuilderComboBoxArrowPosition): IRickUIBuilderComboBox;
    function ArrowMargins(ALeft, ATop, ARight,
      ABottom: Single): IRickUIBuilderComboBox;
    function Enabled(AValue: Boolean = True): IRickUIBuilderComboBox;
    function ClosedArrowPath(const AValue: string): IRickUIBuilderComboBox;
    function OpenedArrowPath(const AValue: string): IRickUIBuilderComboBox;
    function SearchPlaceholder(const AValue: string): IRickUIBuilderComboBox;
    function NoResultsText(const AValue: string): IRickUIBuilderComboBox;
    function BackPath(const AValue: string): IRickUIBuilderComboBox;
    function ClearPath(const AValue: string): IRickUIBuilderComboBox;
    function NoResultsPath(const AValue: string): IRickUIBuilderComboBox;
    function OnChange(AValue: TNotifyEvent): IRickUIBuilderComboBox;
    function OnOpen(AValue: TNotifyEvent): IRickUIBuilderComboBox;
    function OnClose(AValue: TNotifyEvent): IRickUIBuilderComboBox;
    function OnCustomizeItem(
      AValue: TRickUIBuilderComboBoxCustomizeItemEvent): IRickUIBuilderComboBox;
    function Build(AParent: TFmxObject): TRectangle;
    function BuildHandle(AParent: TFmxObject): IRickUIBuilderComboBoxHandle;
  public
    destructor Destroy; override;
    class function New: IRickUIBuilderComboBox; static;
  end;

implementation

uses
  System.Math,
  FMX.StdCtrls,

  Rick.UIBuilder.Factory,
  Rick.UIBuilder.ComboBox.Data,
  Rick.UIBuilder.ComboBox.Handle,
  Rick.UIBuilder.ComboBox.Style;

constructor TRickUIBuilderComboBoxBuilder.Create;
begin
  inherited Create;
  FConfig := TRickUIBuilderComboBoxConfig.Default;
  FItems := TList<TRickUIBuilderComboBoxItem>.Create;
  FColumns := TList<TRickUIBuilderComboBoxColumn>.Create;
  FInitialIndex := -1;
end;

destructor TRickUIBuilderComboBoxBuilder.Destroy;
begin
  FColumns.Free;
  FItems.Free;
  inherited;
end;

class function TRickUIBuilderComboBoxBuilder.New: IRickUIBuilderComboBox;
begin
  Result := TRickUIBuilderComboBoxBuilder.Create;
end;

function TRickUIBuilderComboBoxBuilder.Position(ALeft,
  ATop: Single): IRickUIBuilderComboBox;
begin
  FConfig.Left := ALeft;
  FConfig.Top := ATop;
  Result := Self;
end;

function TRickUIBuilderComboBoxBuilder.Size(AWidth,
  AHeight: Single): IRickUIBuilderComboBox;
begin
  FConfig.Width := AWidth;
  FConfig.Height := AHeight;
  FHeightOverridden := True;
  Result := Self;
end;

function TRickUIBuilderComboBoxBuilder.Placeholder(
  const AValue: string): IRickUIBuilderComboBox;
begin
  FPlaceholder := AValue;
  Result := Self;
end;

function TRickUIBuilderComboBoxBuilder.Items(
  const AItems: array of string): IRickUIBuilderComboBox;
var
  LItem: string;
begin
  FItems.Clear;
  for LItem in AItems do
    FItems.Add(TRickUIBuilderComboBoxItem.Create(LItem));
  Result := Self;
end;

function TRickUIBuilderComboBoxBuilder.AddItem(
  const ADisplayText: string): IRickUIBuilderComboBox;
begin
  FItems.Add(TRickUIBuilderComboBoxItem.Create(ADisplayText));
  Result := Self;
end;

function TRickUIBuilderComboBoxBuilder.AddItem(const ADisplayText,
  AValue: string): IRickUIBuilderComboBox;
begin
  FItems.Add(TRickUIBuilderComboBoxItem.Create(ADisplayText, AValue));
  Result := Self;
end;

function TRickUIBuilderComboBoxBuilder.AddStructuredItem(const ADisplayText,
  AValue: string; const AColumns: array of string): IRickUIBuilderComboBox;
begin
  FItems.Add(TRickUIBuilderComboBoxItem.Structured(ADisplayText, AValue,
    AColumns));
  Result := Self;
end;

function TRickUIBuilderComboBoxBuilder.Column(
  const AValue: TRickUIBuilderComboBoxColumn): IRickUIBuilderComboBox;
begin
  FColumns.Add(AValue);
  Result := Self;
end;

function TRickUIBuilderComboBoxBuilder.ItemIndex(
  AValue: Integer): IRickUIBuilderComboBox;
begin
  FInitialIndex := AValue;
  FInitialText := '';
  FUseInitialText := False;
  Result := Self;
end;

function TRickUIBuilderComboBoxBuilder.SelectedText(
  const AValue: string): IRickUIBuilderComboBox;
begin
  FInitialText := AValue;
  FUseInitialText := True;
  Result := Self;
end;

function TRickUIBuilderComboBoxBuilder.StyleType(
  AValue: TRickUIBuilderComboBoxStyleType): IRickUIBuilderComboBox;
begin
  FConfig.RequestedStyleType := AValue;
  Result := Self;
end;

function TRickUIBuilderComboBoxBuilder.CustomConfig(
  const AValue: TRickUIBuilderComboBoxConfig): IRickUIBuilderComboBox;
begin
  FConfig := AValue;
  FConfig.RequestedStyleType := TRickUIBuilderComboBoxStyleType.Custom;
  FHeightOverridden := True;
  FItemHeightOverridden := True;
  FArrowSizeOverridden := True;
  Result := Self;
end;

function TRickUIBuilderComboBoxBuilder.PresentationMode(
  AValue: TRickUIBuilderComboBoxPresentationMode): IRickUIBuilderComboBox;
begin
  FConfig.PresentationMode := AValue;
  Result := Self;
end;

function TRickUIBuilderComboBoxBuilder.ItemHeight(
  AValue: Single): IRickUIBuilderComboBox;
begin
  FConfig.ItemHeight := AValue;
  FItemHeightOverridden := True;
  Result := Self;
end;

function TRickUIBuilderComboBoxBuilder.PopupMaxHeight(
  AValue: Single): IRickUIBuilderComboBox;
begin
  FConfig.PopupMaxHeight := AValue;
  Result := Self;
end;

function TRickUIBuilderComboBoxBuilder.PopupWidthOffset(
  AValue: Single): IRickUIBuilderComboBox;
begin
  FConfig.PopupWidthOffset := AValue;
  Result := Self;
end;

function TRickUIBuilderComboBoxBuilder.ArrowColor(
  AValue: TAlphaColor): IRickUIBuilderComboBox;
begin
  FConfig.ArrowColor := AValue;
  Result := Self;
end;

function TRickUIBuilderComboBoxBuilder.ArrowSize(
  AValue: Single): IRickUIBuilderComboBox;
begin
  FConfig.ArrowSize := AValue;
  FArrowSizeOverridden := True;
  Result := Self;
end;

function TRickUIBuilderComboBoxBuilder.ArrowPosition(
  AValue: TRickUIBuilderComboBoxArrowPosition): IRickUIBuilderComboBox;
begin
  FConfig.ArrowPosition := AValue;
  Result := Self;
end;

function TRickUIBuilderComboBoxBuilder.ArrowMargins(ALeft, ATop, ARight,
  ABottom: Single): IRickUIBuilderComboBox;
begin
  FConfig.ArrowMarginLeft := Max(0, ALeft);
  FConfig.ArrowMarginTop := Max(0, ATop);
  FConfig.ArrowMarginRight := Max(0, ARight);
  FConfig.ArrowMarginBottom := Max(0, ABottom);
  Result := Self;
end;

function TRickUIBuilderComboBoxBuilder.Enabled(
  AValue: Boolean): IRickUIBuilderComboBox;
begin
  FConfig.Enabled := AValue;
  Result := Self;
end;

function TRickUIBuilderComboBoxBuilder.ClosedArrowPath(
  const AValue: string): IRickUIBuilderComboBox;
begin
  FConfig.ClosedArrowPath := AValue;
  Result := Self;
end;

function TRickUIBuilderComboBoxBuilder.OpenedArrowPath(
  const AValue: string): IRickUIBuilderComboBox;
begin
  FConfig.OpenedArrowPath := AValue;
  Result := Self;
end;

function TRickUIBuilderComboBoxBuilder.SearchPlaceholder(
  const AValue: string): IRickUIBuilderComboBox;
begin
  FConfig.SearchPlaceholder := AValue;
  Result := Self;
end;

function TRickUIBuilderComboBoxBuilder.NoResultsText(
  const AValue: string): IRickUIBuilderComboBox;
begin
  FConfig.NoResultsText := AValue;
  Result := Self;
end;

function TRickUIBuilderComboBoxBuilder.BackPath(
  const AValue: string): IRickUIBuilderComboBox;
begin
  FConfig.BackPath := AValue;
  Result := Self;
end;

function TRickUIBuilderComboBoxBuilder.ClearPath(
  const AValue: string): IRickUIBuilderComboBox;
begin
  FConfig.ClearPath := AValue;
  Result := Self;
end;

function TRickUIBuilderComboBoxBuilder.NoResultsPath(
  const AValue: string): IRickUIBuilderComboBox;
begin
  FConfig.NoResultsPath := AValue;
  Result := Self;
end;

function TRickUIBuilderComboBoxBuilder.OnChange(
  AValue: TNotifyEvent): IRickUIBuilderComboBox;
begin
  FOnChange := AValue;
  Result := Self;
end;

function TRickUIBuilderComboBoxBuilder.OnOpen(
  AValue: TNotifyEvent): IRickUIBuilderComboBox;
begin
  FOnOpen := AValue;
  Result := Self;
end;

function TRickUIBuilderComboBoxBuilder.OnClose(
  AValue: TNotifyEvent): IRickUIBuilderComboBox;
begin
  FOnClose := AValue;
  Result := Self;
end;

function TRickUIBuilderComboBoxBuilder.OnCustomizeItem(
  AValue: TRickUIBuilderComboBoxCustomizeItemEvent): IRickUIBuilderComboBox;
begin
  FOnCustomizeItem := AValue;
  Result := Self;
end;

function TRickUIBuilderComboBoxBuilder.ResolvedConfig:
  TRickUIBuilderComboBoxConfig;
var
  LHeight: Single;
  LItemHeight: Single;
  LArrowSize: Single;
begin
  LHeight := FConfig.Height;
  LItemHeight := FConfig.ItemHeight;
  LArrowSize := FConfig.ArrowSize;
  Result := TRickUIBuilderComboBoxStyleResolver.Resolve(FConfig);

  if FHeightOverridden then
    Result.Height := LHeight;
  if FItemHeightOverridden then
    Result.ItemHeight := LItemHeight;
  if FArrowSizeOverridden then
    Result.ArrowSize := LArrowSize;
end;

function TRickUIBuilderComboBoxBuilder.BuildCore(AParent: TFmxObject;
  out AHandle: IRickUIBuilderComboBoxHandle): TRectangle;
var
  LConfig: TRickUIBuilderComboBoxConfig;
  LData: TRickUIBuilderComboBoxData;
  LImplementation: TRickUIBuilderComboBoxHandle;
  LTextLabel: TLabel;
  LArrow: TPath;
begin
  LConfig := ResolvedConfig;
  LData := TRickUIBuilderComboBoxData.Create;
  LData.AddRange(FItems.ToArray);
  if FUseInitialText then
    LData.TrySelectText(FInitialText)
  else
    LData.SelectIndex(FInitialIndex);

  AHandle := TRickUIBuilderComboBoxHandle.New(LConfig, LData,
    LImplementation);
  LImplementation.ConfigureColumns(FColumns.ToArray);
  LImplementation.ConfigurePlaceholder(FPlaceholder);
  LImplementation.ConfigureEvents(FOnChange, FOnOpen, FOnClose,
    FOnCustomizeItem);

  Result := TRickUIBuilderFactory.CreateComboBox(AParent, AParent, LConfig,
    LTextLabel, LArrow);
  LImplementation.AttachVisual(AParent, Result, LTextLabel, LArrow, AHandle);
end;

function TRickUIBuilderComboBoxBuilder.Build(
  AParent: TFmxObject): TRectangle;
var
  LHandle: IRickUIBuilderComboBoxHandle;
begin
  Result := BuildCore(AParent, LHandle);
end;

function TRickUIBuilderComboBoxBuilder.BuildHandle(
  AParent: TFmxObject): IRickUIBuilderComboBoxHandle;
var
  LContainer: TRectangle;
begin
  LContainer := BuildCore(AParent, Result);
  if not Assigned(LContainer) then
    Result := nil;
end;

end.
