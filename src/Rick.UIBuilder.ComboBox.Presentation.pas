unit Rick.UIBuilder.ComboBox.Presentation;
(*
  ============================================================================
  Unit: Rick.UIBuilder.ComboBox.Presentation
  ============================================================================

  RESPONSABILIDADE

  Materializa de forma lazy as apresentacoes Anchored, Overlay e FullWindow.
  FullWindow utiliza a raiz visual da aplicacao como host, mantendo o Parent
  original apenas como ancora/lifecycle. Pesquisa e comandos visuais sao
  emitidos por eventos; esta unit nao filtra o modelo de dados.
  ============================================================================
*)

interface

uses
  System.Math,
  System.Types,
  System.UITypes,
  System.Classes,
  System.SysUtils,

  FMX.Edit,
  FMX.Types,
  FMX.Forms,
  FMX.Layouts,
  FMX.Objects,
  FMX.StdCtrls,
  FMX.Controls,

  Rick.UIBuilder.Types;

type
  TRickUIBuilderComboBoxPresentation = class(TComponent)
  strict private
    FOwner: TComponent;
    FParent: TFmxObject;
    FPresentationHost: TFmxObject;
    FAnchor: TRectangle;
    FConfig: TRickUIBuilderComboBoxConfig;
    FBackdrop: TRectangle;
    FPopup: TRectangle;
    FHeader: TRectangle;
    FSearchField: TRectangle;
    FBackHitArea: TLayout;
    FBackPath: TPath;
    FClearHitArea: TLayout;
    FClearPath: TPath;
    FSearchEdit: TEdit;
    FScrollBox: TVertScrollBox;
    FEmptyState: TRectangle;
    FEmptyPath: TPath;
    FEmptyLabel: TLabel;
    FOnDismiss: TNotifyEvent;
    FOnSearchChange: TNotifyEvent;
    FOnClear: TNotifyEvent;
    FOnSearchKeyDown: TKeyEvent;
    function IsFullWindow: Boolean;
    function ResolvePresentationHost: TFmxObject;
    procedure CreateBackdrop;
    procedure CreatePopupControl;
    procedure CreateStandardPopup;
    procedure CreateFullWindowPopup;
    procedure CreateFullWindowHeader;
    procedure CreateSearchField;
    procedure CreateBackHitArea;
    procedure CreateClearHitArea;
    procedure CreateSearchEdit;
    procedure ConfigureSearchEditAppearance;
    procedure ConfigureSearchEditFont;
    procedure CreateFullWindowList;
    procedure CreateEmptyState;
    procedure ConfigureEmptyPath;
    procedure ConfigureEmptyLabel;
    procedure ConfigureHitArea(AHitArea: TLayout; AOnClick: TNotifyEvent);
    procedure ReleasePopup(AFreeVisuals: Boolean);
    procedure ReleaseBackdrop;
    procedure RemoveObservedNotifications;
    procedure ConfigurePath(APath: TPath; const AData: string);
    procedure EnsureCreated;
    procedure UpdateBackdropBounds;
    procedure UpdateClearVisibility;
    procedure UnhookFullWindowEvents;
    function ViewportTop: Single;
    function ViewportLeft: Single;
    function DesiredHeight(AItemCount: Integer): Single;
    function PopupWidth: Single;
    function VisibleBottom: Single;
    procedure PlaceBelow(AHeight: Single);
    procedure PlaceAbove(AHeight: Single);
    procedure PlaceLimited(LBelow, LAbove: Single);
    procedure PlaceAnchored(AHeight: Single);
    procedure PlaceOverlay(AHeight: Single);
    procedure PrepareStandardPopup(AItemCount: Integer);
    procedure ShowPopup;
    procedure ClearFullWindowReferences;
    procedure ClearPopupReferences(AComponent: TComponent);
    procedure ClearHostReferences(AComponent: TComponent);
    procedure ClearVisualReference(AComponent: TComponent);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent; AParent: TFmxObject;
      AAnchor: TRectangle; const AConfig: TRickUIBuilderComboBoxConfig); reintroduce;
    destructor Destroy; override;
    procedure SetOnDismiss(AValue: TNotifyEvent);
    procedure SetOnSearchChange(AValue: TNotifyEvent);
    procedure SetOnClear(AValue: TNotifyEvent);
    procedure SetOnSearchKeyDown(AValue: TKeyEvent);
    procedure Open(AItemCount: Integer);
    procedure Close;
    procedure ResetSearch;
    procedure SyncSearchVisualState;
    procedure UpdateResultState(AItemCount: Integer);
    procedure Detach;
    function IsCreated: Boolean;
    function Backdrop: TRectangle;
    function Popup: TRectangle;
    function ScrollBox: TVertScrollBox;
    function SearchText: string;
  end;

implementation

uses
  FMX.Graphics;

constructor TRickUIBuilderComboBoxPresentation.Create(AOwner: TComponent;
  AParent: TFmxObject; AAnchor: TRectangle;
  const AConfig: TRickUIBuilderComboBoxConfig);
begin
  inherited Create(nil);
  FOwner := AOwner;
  FParent := AParent;
  FAnchor := AAnchor;
  FConfig := AConfig;
  FPresentationHost := ResolvePresentationHost;
  if FParent is TComponent then
    TComponent(FParent).FreeNotification(Self);
  if (FPresentationHost is TComponent) and (FPresentationHost <> FParent) then
    TComponent(FPresentationHost).FreeNotification(Self);
  if Assigned(FAnchor) then
    FAnchor.FreeNotification(Self);
end;

destructor TRickUIBuilderComboBoxPresentation.Destroy;
begin
  Detach;
  inherited;
end;

function TRickUIBuilderComboBoxPresentation.IsFullWindow: Boolean;
begin
  Result := FConfig.PresentationMode =
    TRickUIBuilderComboBoxPresentationMode.FullWindow;
end;

function TRickUIBuilderComboBoxPresentation.ResolvePresentationHost:
  TFmxObject;
var
  LCurrent: TFmxObject;
begin
  Result := FParent;
  LCurrent := FParent;
  while Assigned(LCurrent) do
  begin
    if LCurrent is TCommonCustomForm then
      Exit(LCurrent);
    LCurrent := LCurrent.Parent;
  end;
end;

procedure TRickUIBuilderComboBoxPresentation.ConfigurePath(APath: TPath;
  const AData: string);
begin
  APath.Data.Data := AData;
  APath.WrapMode := TPathWrapMode.Fit;
  APath.Fill.Kind := TBrushKind.Solid;
  APath.Fill.Color := FConfig.SearchIconColor;
  APath.Stroke.Kind := TBrushKind.None;
  APath.HitTest := False;
end;

procedure TRickUIBuilderComboBoxPresentation.ConfigureHitArea(
  AHitArea: TLayout; AOnClick: TNotifyEvent);
begin
  AHitArea.Width := FConfig.SearchFieldHeight;
  AHitArea.HitTest := True;
  AHitArea.Cursor := crHandPoint;
  AHitArea.OnClick := AOnClick;
end;

procedure TRickUIBuilderComboBoxPresentation.CreateBackdrop;
begin
  if IsFullWindow or not (FParent is TControl) then
    Exit;
  FBackdrop := TRectangle.Create(FOwner);
  FBackdrop.FreeNotification(Self);
  FBackdrop.Parent := FParent;
  FBackdrop.Fill.Color := TAlphaColors.Null;
  FBackdrop.Stroke.Kind := TBrushKind.None;
  FBackdrop.HitTest := True;
  FBackdrop.Visible := False;
  FBackdrop.OnClick := FOnDismiss;
end;

procedure TRickUIBuilderComboBoxPresentation.CreateStandardPopup;
begin
  FPopup := TRectangle.Create(FOwner);
  FPopup.Parent := FParent;
  FPopup.Fill.Color := FConfig.PopupColor;
  FPopup.Stroke.Color := FConfig.BorderColor;
  FPopup.XRadius := FConfig.CornerRadius;
  FPopup.YRadius := FConfig.CornerRadius;
  FScrollBox := TVertScrollBox.Create(FPopup);
  FScrollBox.Parent := FPopup;
  FScrollBox.Align := TAlignLayout.Client;
  FScrollBox.ShowScrollBars := True;
end;

procedure TRickUIBuilderComboBoxPresentation.ConfigureSearchEditAppearance;
begin
  FSearchEdit.ControlType := TControlType.Styled;
  FSearchEdit.StyleLookup := 'transparentedit';
  FSearchEdit.DisableFocusEffect := True;
  FSearchEdit.TextPrompt := FConfig.SearchPlaceholder;
end;

procedure TRickUIBuilderComboBoxPresentation.ConfigureSearchEditFont;
begin
  FSearchEdit.TextSettings.Font.Size := FConfig.FontSize + 2;
  FSearchEdit.TextSettings.Font.Style := FConfig.FontStyle;
  FSearchEdit.TextSettings.FontColor := FConfig.SearchTextColor;
  FSearchEdit.StyledSettings := FSearchEdit.StyledSettings -
    [TStyledSetting.Size, TStyledSetting.Style, TStyledSetting.FontColor];
  if FConfig.FontFamily = '' then
    Exit;
  FSearchEdit.TextSettings.Font.Family := FConfig.FontFamily;
  FSearchEdit.StyledSettings := FSearchEdit.StyledSettings - [TStyledSetting.Family];
end;

procedure TRickUIBuilderComboBoxPresentation.CreateSearchEdit;
begin
  FSearchEdit := TEdit.Create(FPopup);
  FSearchEdit.Parent := FSearchField;
  FSearchEdit.Align := TAlignLayout.Client;
  FSearchEdit.Margins.Left := 8;
  FSearchEdit.Margins.Right := 8;
  ConfigureSearchEditAppearance;
  ConfigureSearchEditFont;
  FSearchEdit.OnChangeTracking := FOnSearchChange;
  FSearchEdit.OnKeyDown := FOnSearchKeyDown;
end;

procedure TRickUIBuilderComboBoxPresentation.CreateSearchField;
var
  LVerticalMargin: Single;
begin
  FSearchField := TRectangle.Create(FPopup);
  FSearchField.Parent := FHeader;
  FSearchField.Align := TAlignLayout.Client;
  FSearchField.Margins.Left := FConfig.FullWindowPadding;
  FSearchField.Margins.Right := FConfig.FullWindowPadding;
  LVerticalMargin := Max(0,
    (FConfig.SearchHeaderHeight - FConfig.SearchFieldHeight) / 2);
  FSearchField.Margins.Top := LVerticalMargin;
  FSearchField.Margins.Bottom := LVerticalMargin;
  FSearchField.Fill.Color := FConfig.SearchFieldBackgroundColor;
  FSearchField.Stroke.Color := FConfig.SearchFieldBorderColor;
  FSearchField.XRadius := FConfig.SearchFieldCornerRadius;
  FSearchField.YRadius := FConfig.SearchFieldCornerRadius;
  FSearchField.ClipChildren := True;
end;

procedure TRickUIBuilderComboBoxPresentation.CreateBackHitArea;
begin
  FBackHitArea := TLayout.Create(FPopup);
  FBackHitArea.Parent := FSearchField;
  FBackHitArea.Align := TAlignLayout.Left;
  ConfigureHitArea(FBackHitArea, FOnDismiss);

  FBackPath := TPath.Create(FPopup);
  FBackPath.Parent := FBackHitArea;
  FBackPath.Align := TAlignLayout.Center;
  FBackPath.Width := FConfig.SearchIconSize;
  FBackPath.Height := FConfig.SearchIconSize;
  ConfigurePath(FBackPath, FConfig.BackPath);
end;

procedure TRickUIBuilderComboBoxPresentation.CreateClearHitArea;
begin
  FClearHitArea := TLayout.Create(FPopup);
  FClearHitArea.Parent := FSearchField;
  FClearHitArea.Align := TAlignLayout.Right;
  ConfigureHitArea(FClearHitArea, FOnClear);
  FClearHitArea.Visible := False;
  FClearHitArea.HitTest := False;

  FClearPath := TPath.Create(FPopup);
  FClearPath.Parent := FClearHitArea;
  FClearPath.Align := TAlignLayout.Center;
  FClearPath.Width := FConfig.SearchIconSize;
  FClearPath.Height := FConfig.SearchIconSize;
  ConfigurePath(FClearPath, FConfig.ClearPath);
  FClearPath.Visible := False;
end;

procedure TRickUIBuilderComboBoxPresentation.CreateFullWindowHeader;
begin
  FHeader := TRectangle.Create(FPopup);
  FHeader.Parent := FPopup;
  FHeader.Align := TAlignLayout.Top;
  FHeader.Height := FConfig.SearchHeaderHeight;
  FHeader.Fill.Color := FConfig.FullWindowBackgroundColor;
  FHeader.Stroke.Kind := TBrushKind.None;
  CreateSearchField;
  CreateBackHitArea;
  CreateClearHitArea;
  CreateSearchEdit;
end;

procedure TRickUIBuilderComboBoxPresentation.CreateFullWindowList;
begin
  FScrollBox := TVertScrollBox.Create(FPopup);
  FScrollBox.Parent := FPopup;
  FScrollBox.Align := TAlignLayout.Client;
  FScrollBox.ShowScrollBars := False;
end;

procedure TRickUIBuilderComboBoxPresentation.ConfigureEmptyPath;
begin
  FEmptyPath := TPath.Create(FPopup);
  FEmptyPath.Parent := FEmptyState;
  FEmptyPath.Align := TAlignLayout.Top;
  FEmptyPath.Height := FConfig.NoResultsIconSize;
  FEmptyPath.Margins.Top := FConfig.FullWindowPadding * 3;
  FEmptyPath.Data.Data := FConfig.NoResultsPath;
  FEmptyPath.WrapMode := TPathWrapMode.Fit;
  FEmptyPath.Fill.Color := FConfig.NoResultsIconColor;
  FEmptyPath.Stroke.Kind := TBrushKind.None;
end;

procedure TRickUIBuilderComboBoxPresentation.ConfigureEmptyLabel;
begin
  FEmptyLabel := TLabel.Create(FPopup);
  FEmptyLabel.Parent := FEmptyState;
  FEmptyLabel.Align := TAlignLayout.Top;
  FEmptyLabel.Height := 36;
  FEmptyLabel.Margins.Top := 12;
  FEmptyLabel.Text := FConfig.NoResultsText;
  FEmptyLabel.TextSettings.HorzAlign := TTextAlign.Center;
  FEmptyLabel.TextSettings.Font.Size := FConfig.FontSize;
  FEmptyLabel.TextSettings.Font.Style := FConfig.FontStyle;
  FEmptyLabel.TextSettings.FontColor := FConfig.NoResultsTextColor;
  FEmptyLabel.StyledSettings := FEmptyLabel.StyledSettings -
    [TStyledSetting.Size, TStyledSetting.Style, TStyledSetting.FontColor];
end;

procedure TRickUIBuilderComboBoxPresentation.CreateEmptyState;
begin
  FEmptyState := TRectangle.Create(FPopup);
  FEmptyState.Parent := FPopup;
  FEmptyState.Align := TAlignLayout.Client;
  FEmptyState.Fill.Color := TAlphaColors.Null;
  FEmptyState.Stroke.Kind := TBrushKind.None;
  FEmptyState.HitTest := False;
  FEmptyState.Visible := False;
  ConfigureEmptyPath;
  ConfigureEmptyLabel;
end;

procedure TRickUIBuilderComboBoxPresentation.CreateFullWindowPopup;
begin
  FPopup := TRectangle.Create(FOwner);
  FPopup.Parent := FPresentationHost;
  FPopup.Align := TAlignLayout.Client;
  FPopup.Fill.Color := FConfig.FullWindowBackgroundColor;
  FPopup.Stroke.Kind := TBrushKind.None;
  FPopup.Corners := [TCorner.TopLeft, TCorner.TopRight];
  FPopup.ClipChildren := True;
  FPopup.XRadius := FConfig.FullWindowCornerRadius;
  FPopup.YRadius := FConfig.FullWindowCornerRadius;
  CreateFullWindowHeader;
  CreateFullWindowList;
  CreateEmptyState;
end;

procedure TRickUIBuilderComboBoxPresentation.CreatePopupControl;
begin
  if IsFullWindow then
    CreateFullWindowPopup
  else
    CreateStandardPopup;
  FPopup.FreeNotification(Self);
  FScrollBox.FreeNotification(Self);
  FPopup.Visible := False;
  FPopup.HitTest := True;
end;

procedure TRickUIBuilderComboBoxPresentation.EnsureCreated;
begin
  if Assigned(FPopup) then
    Exit;
  CreateBackdrop;
  CreatePopupControl;
end;

function TRickUIBuilderComboBoxPresentation.ViewportTop: Single;
begin
  Result := 0;
  if FParent is TVertScrollBox then
    Result := TVertScrollBox(FParent).ViewportPosition.Y;
end;

function TRickUIBuilderComboBoxPresentation.ViewportLeft: Single;
begin
  Result := 0;
  if FParent is TVertScrollBox then
    Result := TVertScrollBox(FParent).ViewportPosition.X;
end;

procedure TRickUIBuilderComboBoxPresentation.UpdateBackdropBounds;
var
  LParent: TControl;
begin
  if not Assigned(FBackdrop) or not (FParent is TControl) then
    Exit;
  LParent := TControl(FParent);
  FBackdrop.SetBounds(ViewportLeft, ViewportTop, LParent.Width, LParent.Height);
end;

function TRickUIBuilderComboBoxPresentation.DesiredHeight(
  AItemCount: Integer): Single;
begin
  Result := AItemCount * FConfig.ItemHeight;
  Result := Min(FConfig.PopupMaxHeight, Result);
  if Result <= 0 then
    Result := FConfig.ItemHeight;
end;

function TRickUIBuilderComboBoxPresentation.PopupWidth: Single;
begin
  Result := FConfig.PopupWidth;
  if Result <= 0 then
    Result := FAnchor.Width + FConfig.PopupWidthOffset;
  Result := Max(1, Result);
end;

function TRickUIBuilderComboBoxPresentation.VisibleBottom: Single;
begin
  Result := ViewportTop;
  if FParent is TControl then
    Result := Result + TControl(FParent).Height;
end;

procedure TRickUIBuilderComboBoxPresentation.PlaceBelow(AHeight: Single);
begin
  FPopup.Position.Y := FAnchor.Position.Y + FAnchor.Height;
  FPopup.Height := AHeight;
end;

procedure TRickUIBuilderComboBoxPresentation.PlaceAbove(AHeight: Single);
begin
  FPopup.Position.Y := FAnchor.Position.Y - AHeight;
  FPopup.Height := AHeight;
end;

procedure TRickUIBuilderComboBoxPresentation.PlaceLimited(LBelow,
  LAbove: Single);
begin
  if LBelow >= LAbove then
    PlaceBelow(Max(1, LBelow))
  else
    PlaceAbove(Max(1, LAbove));
end;

procedure TRickUIBuilderComboBoxPresentation.PlaceAnchored(AHeight: Single);
var
  LBelow: Single;
  LAbove: Single;
begin
  FPopup.Width := PopupWidth;
  FPopup.Position.X := FAnchor.Position.X;
  if not (FParent is TControl) then
  begin
    PlaceBelow(AHeight);
    Exit;
  end;
  LBelow := Max(0, VisibleBottom - FAnchor.Position.Y - FAnchor.Height);
  LAbove := Max(0, FAnchor.Position.Y - ViewportTop);
  if LBelow >= AHeight then
    PlaceBelow(AHeight)
  else if LAbove >= AHeight then
    PlaceAbove(AHeight)
  else
    PlaceLimited(LBelow, LAbove);
end;

procedure TRickUIBuilderComboBoxPresentation.PlaceOverlay(AHeight: Single);
var
  LParent: TControl;
begin
  FPopup.Position.X := ViewportLeft;
  FPopup.Position.Y := ViewportTop;
  FPopup.Width := PopupWidth;
  FPopup.Height := AHeight;
  if not (FParent is TControl) then
    Exit;
  LParent := TControl(FParent);
  FPopup.Width := LParent.Width;
  FPopup.Height := Min(AHeight, LParent.Height);
end;

procedure TRickUIBuilderComboBoxPresentation.SetOnDismiss(AValue: TNotifyEvent);
begin
  FOnDismiss := AValue;
  if Assigned(FBackdrop) then
    FBackdrop.OnClick := AValue;
  if Assigned(FBackHitArea) then
    FBackHitArea.OnClick := AValue;
end;

procedure TRickUIBuilderComboBoxPresentation.SetOnSearchChange(
  AValue: TNotifyEvent);
begin
  FOnSearchChange := AValue;
  if Assigned(FSearchEdit) then
    FSearchEdit.OnChangeTracking := AValue;
end;

procedure TRickUIBuilderComboBoxPresentation.SetOnClear(AValue: TNotifyEvent);
begin
  FOnClear := AValue;
  if Assigned(FClearHitArea) then
    FClearHitArea.OnClick := AValue;
end;

procedure TRickUIBuilderComboBoxPresentation.SetOnSearchKeyDown(
  AValue: TKeyEvent);
begin
  FOnSearchKeyDown := AValue;
  if Assigned(FSearchEdit) then
    FSearchEdit.OnKeyDown := AValue;
end;

procedure TRickUIBuilderComboBoxPresentation.UpdateClearVisibility;
var
  LVisible: Boolean;
begin
  if not Assigned(FClearHitArea) or not Assigned(FSearchEdit) then
    Exit;
  LVisible := Length(FSearchEdit.Text) > 0;
  FClearHitArea.Visible := LVisible;
  FClearHitArea.HitTest := LVisible;
  if Assigned(FClearPath) then
    FClearPath.Visible := LVisible;
end;

procedure TRickUIBuilderComboBoxPresentation.UnhookFullWindowEvents;
begin
  if Assigned(FSearchEdit) then
  begin
    FSearchEdit.OnChangeTracking := nil;
    FSearchEdit.OnKeyDown := nil;
  end;
  if Assigned(FBackHitArea) then
    FBackHitArea.OnClick := nil;
  if Assigned(FClearHitArea) then
    FClearHitArea.OnClick := nil;
end;

procedure TRickUIBuilderComboBoxPresentation.ResetSearch;
begin
  if not Assigned(FSearchEdit) then
    Exit;
  FSearchEdit.OnChangeTracking := nil;
  try
    FSearchEdit.Text := '';
  finally
    FSearchEdit.OnChangeTracking := FOnSearchChange;
  end;
  UpdateClearVisibility;
end;

procedure TRickUIBuilderComboBoxPresentation.SyncSearchVisualState;
begin
  UpdateClearVisibility;
end;

function TRickUIBuilderComboBoxPresentation.SearchText: string;
begin
  Result := '';
  if Assigned(FSearchEdit) then
    Result := FSearchEdit.Text;
end;

procedure TRickUIBuilderComboBoxPresentation.UpdateResultState(
  AItemCount: Integer);
begin
  if not IsFullWindow or not Assigned(FScrollBox) then
    Exit;
  FScrollBox.Visible := AItemCount > 0;
  if Assigned(FEmptyState) then
    FEmptyState.Visible := AItemCount = 0;
end;

procedure TRickUIBuilderComboBoxPresentation.PrepareStandardPopup(
  AItemCount: Integer);
var
  LHeight: Single;
begin
  UpdateBackdropBounds;
  LHeight := DesiredHeight(AItemCount);
  if FConfig.PresentationMode = TRickUIBuilderComboBoxPresentationMode.Overlay then
    PlaceOverlay(LHeight)
  else
    PlaceAnchored(LHeight);
end;

procedure TRickUIBuilderComboBoxPresentation.ShowPopup;
begin
  if Assigned(FBackdrop) then
  begin
    FBackdrop.Visible := True;
    FBackdrop.BringToFront;
  end;
  FPopup.Visible := True;
  FPopup.BringToFront;
  if IsFullWindow and Assigned(FSearchEdit) then
    FSearchEdit.SetFocus;
end;

procedure TRickUIBuilderComboBoxPresentation.Open(AItemCount: Integer);
begin
  EnsureCreated;
  if IsFullWindow then
    UpdateResultState(AItemCount)
  else
    PrepareStandardPopup(AItemCount);
  ShowPopup;
end;

procedure TRickUIBuilderComboBoxPresentation.Close;
begin
  if Assigned(FPopup) then
    FPopup.Visible := False;
  if Assigned(FBackdrop) then
    FBackdrop.Visible := False;
end;

procedure TRickUIBuilderComboBoxPresentation.ClearFullWindowReferences;
begin
  FHeader := nil;
  FSearchField := nil;
  FBackHitArea := nil;
  FBackPath := nil;
  FClearHitArea := nil;
  FClearPath := nil;
  FSearchEdit := nil;
  FEmptyState := nil;
  FEmptyPath := nil;
  FEmptyLabel := nil;
end;

procedure TRickUIBuilderComboBoxPresentation.ReleasePopup(
  AFreeVisuals: Boolean);
begin
  if not Assigned(FPopup) then
    Exit;
  FPopup.RemoveFreeNotification(Self);
  if AFreeVisuals then
    FreeAndNil(FPopup)
  else
    FPopup := nil;
end;

procedure TRickUIBuilderComboBoxPresentation.ReleaseBackdrop;
begin
  if not Assigned(FBackdrop) then
    Exit;
  FBackdrop.OnClick := nil;
  FBackdrop.RemoveFreeNotification(Self);
  if Assigned(FParent) then
    FreeAndNil(FBackdrop)
  else
    FBackdrop := nil;
end;

procedure TRickUIBuilderComboBoxPresentation.RemoveObservedNotifications;
begin
  if Assigned(FAnchor) then
    FAnchor.RemoveFreeNotification(Self);
  if FParent is TComponent then
    TComponent(FParent).RemoveFreeNotification(Self);
  if (FPresentationHost is TComponent) and (FPresentationHost <> FParent) then
    TComponent(FPresentationHost).RemoveFreeNotification(Self);
end;

procedure TRickUIBuilderComboBoxPresentation.Detach;
var
  LFreeVisuals: Boolean;
begin
  LFreeVisuals := Assigned(FPresentationHost);
  UnhookFullWindowEvents;
  if Assigned(FScrollBox) then
    FScrollBox.RemoveFreeNotification(Self);
  ReleasePopup(LFreeVisuals);
  ReleaseBackdrop;
  RemoveObservedNotifications;
  FScrollBox := nil;
  FAnchor := nil;
  FParent := nil;
  FPresentationHost := nil;
  FOwner := nil;
  ClearFullWindowReferences;
end;

procedure TRickUIBuilderComboBoxPresentation.ClearPopupReferences(
  AComponent: TComponent);
begin
  if AComponent = FScrollBox then
    FScrollBox := nil;
  if AComponent = FPopup then
  begin
    FPopup := nil;
    FScrollBox := nil;
    ClearFullWindowReferences;
  end;
  if AComponent = FBackdrop then
    FBackdrop := nil;
end;

procedure TRickUIBuilderComboBoxPresentation.ClearHostReferences(
  AComponent: TComponent);
begin
  if AComponent = FAnchor then
    FAnchor := nil;
  if AComponent = FParent then
    FParent := nil;
  if AComponent = FPresentationHost then
    FPresentationHost := nil;
end;

procedure TRickUIBuilderComboBoxPresentation.ClearVisualReference(
  AComponent: TComponent);
begin
  ClearPopupReferences(AComponent);
  ClearHostReferences(AComponent);
end;

procedure TRickUIBuilderComboBoxPresentation.Notification(
  AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if Operation = opRemove then
    ClearVisualReference(AComponent);
end;

function TRickUIBuilderComboBoxPresentation.IsCreated: Boolean;
begin
  Result := Assigned(FPopup);
end;

function TRickUIBuilderComboBoxPresentation.Backdrop: TRectangle;
begin
  Result := FBackdrop;
end;

function TRickUIBuilderComboBoxPresentation.Popup: TRectangle;
begin
  Result := FPopup;
end;

function TRickUIBuilderComboBoxPresentation.ScrollBox: TVertScrollBox;
begin
  Result := FScrollBox;
end;

end.
