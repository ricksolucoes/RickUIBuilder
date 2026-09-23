unit Rick.UIBuilder.ComboBox.Handle;
(*
  ============================================================================
  Unit: Rick.UIBuilder.ComboBox.Handle
  ============================================================================

  RESPONSABILIDADE

  Implementa IRickUIBuilderComboBoxHandle e concentra o comportamento runtime
  do ComboBox materializado. O modelo logico permanece vivo enquanto houver
  referencia ao handle; as referencias FMX sao non-owning e sao explicitamente
  desconectadas quando o container visual deixa de existir.

  Um TComponent interno, owned pelo mesmo Parent usado pelo Builder, mantem uma
  referencia forte ao handle e observa somente o container do ComboBox. Assim,
  Build sem handle externo continua funcional e a destruicao de outros
  componentes do mesmo Parent nao provoca detach indevido.
  ============================================================================
*)

interface

uses
  System.Classes,
  System.SysUtils,
  System.Types,
  System.UITypes,
  FMX.Types,
  FMX.Controls,
  FMX.Objects,
  FMX.StdCtrls,
  Rick.UIBuilder.Types,
  Rick.UIBuilder.Interfaces,
  Rick.UIBuilder.ComboBox.Data,
  Rick.UIBuilder.ComboBox.State,
  Rick.UIBuilder.ComboBox.Presentation,
  Rick.UIBuilder.ComboBox.Virtualization;

type
  TRickUIBuilderComboBoxHandle = class(TInterfacedObject,
    IRickUIBuilderComboBoxHandle)
  private
    FConfig: TRickUIBuilderComboBoxConfig;
    FPlaceholder: string;
    FColumns: TArray<TRickUIBuilderComboBoxColumn>;
    FOnChange: TNotifyEvent;
    FOnOpen: TNotifyEvent;
    FOnClose: TNotifyEvent;
    FOnCustomizeItem: TRickUIBuilderComboBoxCustomizeItemEvent;
    FData: TRickUIBuilderComboBoxData;
    FState: TRickUIBuilderComboBoxState;
    FPresentation: TRickUIBuilderComboBoxPresentation;
    FVirtualizer: TRickUIBuilderComboBoxVirtualizer;
    FParent: TFmxObject;
    FContainer: TRectangle;
    FTextLabel: TLabel;
    FArrow: TPath;
    FSearchTimer: TTimer;
    FSearchBuffer: string;
    procedure BindVisualReferences(AParent: TFmxObject; AContainer: TRectangle;
      ATextLabel: TLabel; AArrow: TPath);
    procedure ConfigureVisualEvents;
    procedure CreateRuntimeServices(AOwner: TComponent);
    procedure MainClick(Sender: TObject);
    procedure MainEnter(Sender: TObject);
    procedure MainExit(Sender: TObject);
    procedure DismissClick(Sender: TObject);
    procedure SearchChanged(Sender: TObject);
    procedure ClearSearchClick(Sender: TObject);
    procedure SearchEditKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: WideChar; Shift: TShiftState);
    function PageSize: Integer;
    procedure RowClick(Sender: TObject);
    procedure MainKeyDown(Sender: TObject; var Key: Word; var KeyChar: WideChar;
      Shift: TShiftState);
    procedure ClosedKeyDown(Key: Word; Shift: TShiftState);
    procedure OpenedKeyDown(Key: Word);
    procedure SearchTimeout(Sender: TObject);
    procedure UpdateDisplay;
    procedure UpdateArrow;
    function ArrowLeft(AWidth: Single): Single;
    function ArrowTop(AHeight: Single): Single;
    procedure UpdateTextBounds(AArrowLeft, AArrowWidth: Single);
    procedure UpdateArrowBounds(AWidth, AHeight: Single);
    function IsFullWindow: Boolean;
    function ViewCount: Integer;
    procedure RefreshPopup;
    procedure EnsurePresentation;
    procedure ResetFullWindowFilter;
    procedure UpdateTargetFromView;
    procedure SetTargetView(AViewIndex: Integer);
    procedure MoveTarget(ADelta: Integer);
    procedure SetTarget(AIndex: Integer);
    procedure ConfirmTarget;
    procedure SearchCharacter(AChar: WideChar);
    procedure NotifyChange(ALastIndex: Integer);
    procedure DetachVisual; overload;
    procedure DetachVisual(AUnhookContainer: Boolean); overload;
  protected
    function IsAttached: Boolean;
    function ItemIndex: Integer;
    function SelectedText: string;
    function SelectedValue: string;
    function Count: Integer;
    function SelectIndex(AIndex: Integer): Boolean;
    function SelectText(const AText: string): Boolean;
    procedure Add(const AText: string); overload;
    procedure Add(const ADisplayText, AValue: string); overload;
    procedure AddRange(const AItems: array of string);
    procedure Open;
    procedure Close;
    procedure SetArrowColor(AValue: TAlphaColor);
    procedure SetArrowSize(AWidth, AHeight: Single);
    procedure SetClosedArrowPath(const AValue: string);
    procedure SetOpenedArrowPath(const AValue: string);
  public
    constructor Create(const AConfig: TRickUIBuilderComboBoxConfig;
      AData: TRickUIBuilderComboBoxData);
    destructor Destroy; override;

    class function New(const AConfig: TRickUIBuilderComboBoxConfig;
      AData: TRickUIBuilderComboBoxData;
      out AImplementation: TRickUIBuilderComboBoxHandle):
      IRickUIBuilderComboBoxHandle; static;

    procedure ConfigureColumns(
      const AColumns: TArray<TRickUIBuilderComboBoxColumn>);
    procedure ConfigurePlaceholder(const AValue: string);
    procedure ConfigureEvents(AOnChange, AOnOpen, AOnClose: TNotifyEvent;
      AOnCustomizeItem: TRickUIBuilderComboBoxCustomizeItemEvent);
    procedure AttachVisual(AParent: TFmxObject; AContainer: TRectangle;
      ATextLabel: TLabel; AArrow: TPath;
      const ALifetime: IRickUIBuilderComboBoxHandle);
  end;

implementation

uses
  System.Math;

type
  TRickUIBuilderComboBoxBehavior = class(TComponent)
  private
    FContainer: TComponent;
    FHandle: TRickUIBuilderComboBoxHandle;
    FLifetime: IRickUIBuilderComboBoxHandle;
  protected
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
  public
    destructor Destroy; override;
    procedure Configure(AContainer: TComponent;
      AHandle: TRickUIBuilderComboBoxHandle;
      const ALifetime: IRickUIBuilderComboBoxHandle);
  end;

{ TRickUIBuilderComboBoxHandle }

constructor TRickUIBuilderComboBoxHandle.Create(
  const AConfig: TRickUIBuilderComboBoxConfig;
  AData: TRickUIBuilderComboBoxData);
begin
  inherited Create;
  FConfig := AConfig;
  FData := AData;
  FState := TRickUIBuilderComboBoxState.Create;
end;

destructor TRickUIBuilderComboBoxHandle.Destroy;
begin
  DetachVisual;
  FState.Free;
  FData.Free;
  inherited;
end;

class function TRickUIBuilderComboBoxHandle.New(
  const AConfig: TRickUIBuilderComboBoxConfig;
  AData: TRickUIBuilderComboBoxData;
  out AImplementation: TRickUIBuilderComboBoxHandle):
  IRickUIBuilderComboBoxHandle;
begin
  AImplementation := TRickUIBuilderComboBoxHandle.Create(AConfig, AData);
  Result := AImplementation;
end;

procedure TRickUIBuilderComboBoxHandle.ConfigureColumns(
  const AColumns: TArray<TRickUIBuilderComboBoxColumn>);
begin
  FColumns := Copy(AColumns, 0, Length(AColumns));
end;

procedure TRickUIBuilderComboBoxHandle.ConfigurePlaceholder(
  const AValue: string);
begin
  FPlaceholder := AValue;
end;

procedure TRickUIBuilderComboBoxHandle.ConfigureEvents(AOnChange, AOnOpen,
  AOnClose: TNotifyEvent;
  AOnCustomizeItem: TRickUIBuilderComboBoxCustomizeItemEvent);
begin
  FOnChange := AOnChange;
  FOnOpen := AOnOpen;
  FOnClose := AOnClose;
  FOnCustomizeItem := AOnCustomizeItem;
end;

procedure TRickUIBuilderComboBoxHandle.BindVisualReferences(
  AParent: TFmxObject; AContainer: TRectangle; ATextLabel: TLabel;
  AArrow: TPath);
begin
  FParent := AParent;
  FContainer := AContainer;
  FTextLabel := ATextLabel;
  FArrow := AArrow;
end;

procedure TRickUIBuilderComboBoxHandle.ConfigureVisualEvents;
begin
  FContainer.OnClick := MainClick;
  FContainer.OnKeyDown := MainKeyDown;
  FContainer.OnEnter := MainEnter;
  FContainer.OnExit := MainExit;
end;

procedure TRickUIBuilderComboBoxHandle.CreateRuntimeServices(
  AOwner: TComponent);
begin
  FSearchTimer := TTimer.Create(AOwner);
  FSearchTimer.Enabled := False;
  FSearchTimer.Interval := FConfig.SearchTimeout;
  FSearchTimer.OnTimer := SearchTimeout;
  FPresentation := TRickUIBuilderComboBoxPresentation.Create(AOwner,
    FParent, FContainer, FConfig);
  FPresentation.SetOnDismiss(DismissClick);
  FPresentation.SetOnSearchChange(SearchChanged);
  FPresentation.SetOnClear(ClearSearchClick);
  FPresentation.SetOnSearchKeyDown(SearchEditKeyDown);
end;

procedure TRickUIBuilderComboBoxHandle.AttachVisual(AParent: TFmxObject;
  AContainer: TRectangle; ATextLabel: TLabel; AArrow: TPath;
  const ALifetime: IRickUIBuilderComboBoxHandle);
var
  LBehavior: TRickUIBuilderComboBoxBehavior;
begin
  BindVisualReferences(AParent, AContainer, ATextLabel, AArrow);
  LBehavior := TRickUIBuilderComboBoxBehavior.Create(AParent);
  LBehavior.Configure(AContainer, Self, ALifetime);
  ConfigureVisualEvents;
  CreateRuntimeServices(LBehavior);
  UpdateDisplay;
  UpdateArrow;
end;

procedure TRickUIBuilderComboBoxHandle.DetachVisual;
begin
  DetachVisual(True);
end;

procedure TRickUIBuilderComboBoxHandle.DetachVisual(
  AUnhookContainer: Boolean);
begin
  if AUnhookContainer and Assigned(FContainer) then
  begin
    FContainer.OnClick := nil;
    FContainer.OnKeyDown := nil;
    FContainer.OnEnter := nil;
    FContainer.OnExit := nil;
  end;

  if Assigned(FSearchTimer) then
  begin
    FSearchTimer.Enabled := False;
    FSearchTimer.OnTimer := nil;
  end;
  FreeAndNil(FSearchTimer);
  FreeAndNil(FVirtualizer);
  FreeAndNil(FPresentation);
  if Assigned(FState) and FState.IsOpen then
    FState.FinishClose;

  FParent := nil;
  FContainer := nil;
  FTextLabel := nil;
  FArrow := nil;
end;

function TRickUIBuilderComboBoxHandle.IsAttached: Boolean;
begin
  Result := Assigned(FContainer);
end;

function TRickUIBuilderComboBoxHandle.ItemIndex: Integer;
begin
  Result := FData.ItemIndex;
end;

function TRickUIBuilderComboBoxHandle.SelectedText: string;
begin
  Result := FData.SelectedText;
end;

function TRickUIBuilderComboBoxHandle.SelectedValue: string;
begin
  Result := FData.SelectedValue;
end;

function TRickUIBuilderComboBoxHandle.Count: Integer;
begin
  Result := FData.Count;
end;

procedure TRickUIBuilderComboBoxHandle.NotifyChange(ALastIndex: Integer);
begin
  if (ALastIndex <> ItemIndex) and Assigned(FOnChange) then
    FOnChange(Self);
end;

function TRickUIBuilderComboBoxHandle.SelectIndex(AIndex: Integer): Boolean;
var
  LOldIndex: Integer;
begin
  LOldIndex := ItemIndex;
  Result := FData.SelectIndex(AIndex);
  if not Result then
    Exit;

  if FState.IsOpen then
    FState.SetTargetIndex(ItemIndex);
  UpdateDisplay;
  RefreshPopup;
  NotifyChange(LOldIndex);
end;

function TRickUIBuilderComboBoxHandle.SelectText(
  const AText: string): Boolean;
var
  LOldIndex: Integer;
begin
  LOldIndex := ItemIndex;
  Result := FData.TrySelectText(AText);
  if not Result then
    Exit;

  if FState.IsOpen then
    FState.SetTargetIndex(ItemIndex);
  UpdateDisplay;
  RefreshPopup;
  NotifyChange(LOldIndex);
end;

procedure TRickUIBuilderComboBoxHandle.Add(const AText: string);
begin
  FData.AddText(AText);
  if FState.IsOpen and Assigned(FPresentation) then
    FPresentation.Open(ViewCount);
  RefreshPopup;
end;

procedure TRickUIBuilderComboBoxHandle.Add(const ADisplayText,
  AValue: string);
begin
  FData.Add(TRickUIBuilderComboBoxItem.Create(ADisplayText, AValue));
  if FState.IsOpen and Assigned(FPresentation) then
    FPresentation.Open(ViewCount);
  RefreshPopup;
end;

procedure TRickUIBuilderComboBoxHandle.AddRange(
  const AItems: array of string);
begin
  FData.AddRange(AItems);
  if FState.IsOpen and Assigned(FPresentation) then
    FPresentation.Open(ViewCount);
  RefreshPopup;
end;

procedure TRickUIBuilderComboBoxHandle.UpdateDisplay;
begin
  if not IsAttached then
    Exit;

  if ItemIndex >= 0 then
  begin
    FTextLabel.Text := SelectedText;
    FTextLabel.TextSettings.FontColor := FConfig.TextColor;
  end
  else
  begin
    FTextLabel.Text := FPlaceholder;
    FTextLabel.TextSettings.FontColor := FConfig.PlaceholderColor;
  end;
end;

procedure TRickUIBuilderComboBoxHandle.UpdateArrow;
begin
  if not Assigned(FArrow) then
    Exit;

  if FState.IsOpen then
    FArrow.Data.Data := FConfig.OpenedArrowPath
  else
    FArrow.Data.Data := FConfig.ClosedArrowPath;
  FArrow.Fill.Color := FConfig.ArrowColor;
end;

function TRickUIBuilderComboBoxHandle.ArrowLeft(AWidth: Single): Single;
begin
  if FConfig.ArrowPosition = TRickUIBuilderComboBoxArrowPosition.Right then
    Result := FContainer.Width - Max(0, FConfig.ArrowMarginRight) - AWidth
  else
    Result := Max(0, FConfig.ArrowMarginLeft);
  Result := Max(0, Min(Result, Max(0, FContainer.Width - AWidth)));
end;

function TRickUIBuilderComboBoxHandle.ArrowTop(AHeight: Single): Single;
var
  LAvailable: Single;
begin
  LAvailable := Max(0, FContainer.Height - Max(0, FConfig.ArrowMarginTop) -
    Max(0, FConfig.ArrowMarginBottom));
  Result := Max(0, FConfig.ArrowMarginTop) +
    Max(0, (LAvailable - AHeight) / 2);
  Result := Max(0, Min(Result, Max(0, FContainer.Height - AHeight)));
end;

procedure TRickUIBuilderComboBoxHandle.UpdateTextBounds(AArrowLeft,
  AArrowWidth: Single);
var
  LLeft: Single;
  LRight: Single;
begin
  if not Assigned(FTextLabel) then
    Exit;
  LLeft := FConfig.HorizontalPadding;
  LRight := FContainer.Width - FConfig.HorizontalPadding;
  if FConfig.ArrowPosition = TRickUIBuilderComboBoxArrowPosition.Right then
    LRight := AArrowLeft - Max(0, FConfig.ArrowMarginLeft)
  else
    LLeft := AArrowLeft + AArrowWidth + Max(0, FConfig.ArrowMarginRight);
  FTextLabel.SetBounds(LLeft, 0, Max(1, LRight - LLeft), FContainer.Height);
end;

procedure TRickUIBuilderComboBoxHandle.UpdateArrowBounds(AWidth,
  AHeight: Single);
var
  LLeft: Single;
begin
  if not Assigned(FArrow) or not Assigned(FContainer) then
    Exit;
  LLeft := ArrowLeft(AWidth);
  FArrow.SetBounds(LLeft, ArrowTop(AHeight), AWidth, AHeight);
  UpdateTextBounds(LLeft, AWidth);
end;

function TRickUIBuilderComboBoxHandle.IsFullWindow: Boolean;
begin
  Result := FConfig.PresentationMode =
    TRickUIBuilderComboBoxPresentationMode.FullWindow;
end;

function TRickUIBuilderComboBoxHandle.ViewCount: Integer;
begin
  Result := FData.ViewCount;
end;

procedure TRickUIBuilderComboBoxHandle.ResetFullWindowFilter;
begin
  if not IsFullWindow then
    Exit;
  FData.ClearFilter;
  if Assigned(FPresentation) then
    FPresentation.ResetSearch;
end;

procedure TRickUIBuilderComboBoxHandle.UpdateTargetFromView;
var
  LSelectedView: Integer;
begin
  LSelectedView := FData.ViewIndexFromSource(ItemIndex);
  if LSelectedView >= 0 then
    FState.SetTargetIndex(ItemIndex)
  else if ViewCount > 0 then
    FState.SetTargetIndex(FData.SourceIndexFromView(0))
  else
    FState.SetTargetIndex(-1);
  if Assigned(FVirtualizer) and (FState.TargetIndex >= 0) then
    FVirtualizer.EnsureIndexVisible(FState.TargetIndex);
end;

procedure TRickUIBuilderComboBoxHandle.SetTargetView(AViewIndex: Integer);
var
  LSourceIndex: Integer;
begin
  LSourceIndex := FData.SourceIndexFromView(AViewIndex);
  if LSourceIndex >= 0 then
    SetTarget(LSourceIndex);
end;

procedure TRickUIBuilderComboBoxHandle.EnsurePresentation;
begin
  if not IsAttached or not Assigned(FPresentation) then
    Exit;

  FPresentation.Open(ViewCount);
  if Assigned(FVirtualizer) then
    Exit;

  FVirtualizer := TRickUIBuilderComboBoxVirtualizer.Create(
    FPresentation.ScrollBox, FData, FConfig);
  FVirtualizer.SetColumns(FColumns);
  FVirtualizer.SetOnRowClick(RowClick);
  FVirtualizer.SetOnCustomizeItem(FOnCustomizeItem);
end;

procedure TRickUIBuilderComboBoxHandle.RefreshPopup;
begin
  if not FState.IsOpen then
    Exit;
  if Assigned(FPresentation) then
    FPresentation.UpdateResultState(ViewCount);
  if Assigned(FVirtualizer) then
    FVirtualizer.Refresh(ItemIndex, FState.TargetIndex);
end;

procedure TRickUIBuilderComboBoxHandle.Open;
begin
  if not IsAttached or not FConfig.Enabled or FState.IsOpen then
    Exit;

  FState.BeginOpen(ItemIndex);
  ResetFullWindowFilter;
  EnsurePresentation;
  UpdateTargetFromView;
  FState.FinishOpen;
  UpdateArrow;
  RefreshPopup;
  if Assigned(FOnOpen) then
    FOnOpen(Self);
end;

procedure TRickUIBuilderComboBoxHandle.Close;
begin
  if not FState.IsOpen then
    Exit;

  FState.BeginClose;
  if Assigned(FPresentation) then
    FPresentation.Close;
  FState.FinishClose;
  UpdateArrow;
  if Assigned(FOnClose) then
    FOnClose(Self);
end;

procedure TRickUIBuilderComboBoxHandle.MainClick(Sender: TObject);
begin
  if FState.IsOpen then
    Close
  else
    Open;
end;

procedure TRickUIBuilderComboBoxHandle.MainEnter(Sender: TObject);
begin
  if Assigned(FContainer) then
    FContainer.Stroke.Color := FConfig.FocusColor;
end;

procedure TRickUIBuilderComboBoxHandle.MainExit(Sender: TObject);
begin
  if Assigned(FContainer) then
    FContainer.Stroke.Color := FConfig.BorderColor;
end;

procedure TRickUIBuilderComboBoxHandle.DismissClick(Sender: TObject);
begin
  Close;
end;

procedure TRickUIBuilderComboBoxHandle.SearchChanged(Sender: TObject);
begin
  if not IsFullWindow or not Assigned(FPresentation) then
    Exit;
  FPresentation.SyncSearchVisualState;
  FData.SetFilterText(FPresentation.SearchText);
  UpdateTargetFromView;
  RefreshPopup;
end;

procedure TRickUIBuilderComboBoxHandle.ClearSearchClick(Sender: TObject);
begin
  if not IsFullWindow or not Assigned(FPresentation) then
    Exit;
  FPresentation.ResetSearch;
  FData.ClearFilter;
  UpdateTargetFromView;
  RefreshPopup;
end;

procedure TRickUIBuilderComboBoxHandle.SearchEditKeyDown(Sender: TObject;
  var Key: Word; var KeyChar: WideChar; Shift: TShiftState);
begin
  if not FState.IsOpen then
    Exit;
  case Key of
    vkDown: MoveTarget(1);
    vkUp: MoveTarget(-1);
    vkPrior: MoveTarget(-PageSize);
    vkNext: MoveTarget(PageSize);
    vkReturn: ConfirmTarget;
    vkEscape, vkTab: Close;
  else
    Exit;
  end;
  Key := 0;
end;

function TRickUIBuilderComboBoxHandle.PageSize: Integer;
var
  LHeight: Single;
  LScrollBox: TControl;
begin
  LHeight := FConfig.PopupMaxHeight;
  LScrollBox := nil;
  if Assigned(FPresentation) then
    LScrollBox := FPresentation.ScrollBox();
  if Assigned(LScrollBox) then
    LHeight := LScrollBox.Height;
  Result := Max(1, Round(LHeight / Max(FConfig.ItemHeight, 1)));
end;

procedure TRickUIBuilderComboBoxHandle.RowClick(Sender: TObject);
begin
  if not (Sender is TControl) then
    Exit;
  SetTarget(TControl(Sender).Tag);
  ConfirmTarget;
end;

procedure TRickUIBuilderComboBoxHandle.SetTarget(AIndex: Integer);
begin
  if (AIndex < 0) or (AIndex >= Count) then
    Exit;
  FState.SetTargetIndex(AIndex);
  if Assigned(FVirtualizer) then
    FVirtualizer.EnsureIndexVisible(AIndex);
  RefreshPopup;
end;

procedure TRickUIBuilderComboBoxHandle.MoveTarget(ADelta: Integer);
var
  LViewIndex: Integer;
begin
  if ViewCount = 0 then
    Exit;
  LViewIndex := FData.ViewIndexFromSource(FState.TargetIndex);
  if LViewIndex < 0 then
    LViewIndex := 0
  else
    LViewIndex := EnsureRange(LViewIndex + ADelta, 0, ViewCount - 1);
  SetTargetView(LViewIndex);
end;

procedure TRickUIBuilderComboBoxHandle.ConfirmTarget;
var
  LTarget: Integer;
begin
  LTarget := FState.TargetIndex;
  if LTarget >= 0 then
    SelectIndex(LTarget);
  Close;
end;

procedure TRickUIBuilderComboBoxHandle.SearchCharacter(AChar: WideChar);
var
  LIndex: Integer;
begin
  FSearchBuffer := FSearchBuffer + AChar;
  if Assigned(FSearchTimer) then
  begin
    FSearchTimer.Enabled := False;
    FSearchTimer.Enabled := True;
  end;

  LIndex := FData.FindPrefix(FSearchBuffer);
  if LIndex < 0 then
    Exit;

  if FState.IsOpen then
    SetTarget(LIndex)
  else
    SelectIndex(LIndex);
end;

procedure TRickUIBuilderComboBoxHandle.SearchTimeout(Sender: TObject);
begin
  FSearchBuffer := '';
  if Assigned(FSearchTimer) then
    FSearchTimer.Enabled := False;
end;

procedure TRickUIBuilderComboBoxHandle.ClosedKeyDown(Key: Word;
  Shift: TShiftState);
begin
  if (Key = vkF4) or (Key = vkReturn) or (Key = vkSpace) or
    ((Key = vkDown) and (ssAlt in Shift)) then
    Open
  else if ((Key = vkDown) or (Key = vkRight)) and (Count > 0) then
    SelectIndex(Min(Count - 1, Max(0, ItemIndex + 1)))
  else if ((Key = vkUp) or (Key = vkLeft)) and (Count > 0) then
    SelectIndex(Max(0, ItemIndex - 1));
end;

procedure TRickUIBuilderComboBoxHandle.OpenedKeyDown(Key: Word);
begin
  case Key of
    vkDown: MoveTarget(1);
    vkUp: MoveTarget(-1);
    vkHome: SetTargetView(0);
    vkEnd: SetTargetView(ViewCount - 1);
    vkPrior: MoveTarget(-PageSize);
    vkNext: MoveTarget(PageSize);
    vkReturn, vkSpace: ConfirmTarget;
    vkEscape, vkTab: Close;
  end;
end;

procedure TRickUIBuilderComboBoxHandle.MainKeyDown(Sender: TObject;
  var Key: Word; var KeyChar: WideChar; Shift: TShiftState);
begin
  if (KeyChar >= #32) and (KeyChar <> #127) then
  begin
    SearchCharacter(KeyChar);
    Exit;
  end;

  if FState.IsOpen then
    OpenedKeyDown(Key)
  else
    ClosedKeyDown(Key, Shift);
end;

procedure TRickUIBuilderComboBoxHandle.SetArrowColor(AValue: TAlphaColor);
begin
  FConfig.ArrowColor := AValue;
  UpdateArrow;
end;

procedure TRickUIBuilderComboBoxHandle.SetArrowSize(AWidth,
  AHeight: Single);
begin
  if (AWidth <= 0) or (AHeight <= 0) then
    Exit;
  UpdateArrowBounds(AWidth, AHeight);
end;

procedure TRickUIBuilderComboBoxHandle.SetClosedArrowPath(
  const AValue: string);
begin
  FConfig.ClosedArrowPath := AValue;
  UpdateArrow;
end;

procedure TRickUIBuilderComboBoxHandle.SetOpenedArrowPath(
  const AValue: string);
begin
  FConfig.OpenedArrowPath := AValue;
  UpdateArrow;
end;

{ TRickUIBuilderComboBoxBehavior }

procedure TRickUIBuilderComboBoxBehavior.Configure(AContainer: TComponent;
  AHandle: TRickUIBuilderComboBoxHandle;
  const ALifetime: IRickUIBuilderComboBoxHandle);
begin
  FContainer := AContainer;
  FHandle := AHandle;
  FLifetime := ALifetime;
  if Assigned(FContainer) then
    FContainer.FreeNotification(Self);
end;

destructor TRickUIBuilderComboBoxBehavior.Destroy;
begin
  if Assigned(FContainer) then
    FContainer.RemoveFreeNotification(Self);
  if Assigned(FHandle) then
    FHandle.DetachVisual;
  FContainer := nil;
  FHandle := nil;
  FLifetime := nil;
  inherited;
end;

procedure TRickUIBuilderComboBoxBehavior.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation <> opRemove) or (AComponent <> FContainer) then
    Exit;

  if Assigned(FHandle) then
    FHandle.DetachVisual(False);
  FContainer := nil;
end;

end.
