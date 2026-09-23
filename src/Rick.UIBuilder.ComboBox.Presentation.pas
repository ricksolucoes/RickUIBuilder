unit Rick.UIBuilder.ComboBox.Presentation;
(*
  ============================================================================
  Unit: Rick.UIBuilder.ComboBox.Presentation
  ============================================================================

  RESPONSABILIDADE

  Cria de forma lazy a superficie visual da lista, calcula sua geometria em
  relacao ao Parent e mantem Anchored e Overlay separados do StyleType.
  ============================================================================
*)

interface

uses
  System.Classes,
  System.SysUtils,
  System.Math,
  System.Types,
  System.UITypes,
  FMX.Types,
  FMX.Controls,
  FMX.Layouts,
  FMX.Objects,
  Rick.UIBuilder.Types;

type
  TRickUIBuilderComboBoxPresentation = class(TComponent)
  strict private
    FOwner: TComponent;
    FParent: TFmxObject;
    FAnchor: TRectangle;
    FConfig: TRickUIBuilderComboBoxConfig;
    FBackdrop: TRectangle;
    FPopup: TRectangle;
    FScrollBox: TVertScrollBox;
    FOnDismiss: TNotifyEvent;
    procedure CreateBackdrop;
    procedure CreatePopupControl;
    procedure EnsureCreated;
    procedure UpdateBackdropBounds;
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
    procedure ClearVisualReference(AComponent: TComponent);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent; AParent: TFmxObject;
      AAnchor: TRectangle; const AConfig: TRickUIBuilderComboBoxConfig);
    destructor Destroy; override;
    procedure SetOnDismiss(AValue: TNotifyEvent);
    procedure Open(AItemCount: Integer);
    procedure Close;
    procedure Detach;
    function IsCreated: Boolean;
    function Backdrop: TRectangle;
    function Popup: TRectangle;
    function ScrollBox: TVertScrollBox;
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
  if FParent is TComponent then
    TComponent(FParent).FreeNotification(Self);
  if Assigned(FAnchor) then
    FAnchor.FreeNotification(Self);
end;

destructor TRickUIBuilderComboBoxPresentation.Destroy;
begin
  Detach;
  inherited;
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

procedure TRickUIBuilderComboBoxPresentation.CreateBackdrop;
begin
  if not (FParent is TControl) then
    Exit;

  FBackdrop := TRectangle.Create(FOwner);
  FBackdrop.FreeNotification(Self);
  FBackdrop.Parent := FParent;
  FBackdrop.Fill.Kind := TBrushKind.Solid;
  FBackdrop.Fill.Color := TAlphaColors.Null;
  FBackdrop.Stroke.Kind := TBrushKind.None;
  FBackdrop.HitTest := True;
  FBackdrop.Visible := False;
  FBackdrop.OnClick := FOnDismiss;
end;

procedure TRickUIBuilderComboBoxPresentation.CreatePopupControl;
begin
  FPopup := TRectangle.Create(FOwner);
  FPopup.FreeNotification(Self);
  FPopup.Parent := FParent;
  FPopup.Visible := False;
  FPopup.HitTest := True;
  FPopup.Fill.Kind := TBrushKind.Solid;
  FPopup.Fill.Color := FConfig.PopupColor;
  FPopup.Stroke.Kind := TBrushKind.Solid;
  FPopup.Stroke.Color := FConfig.BorderColor;
  FPopup.XRadius := FConfig.CornerRadius;
  FPopup.YRadius := FConfig.CornerRadius;

  FScrollBox := TVertScrollBox.Create(FPopup);
  FScrollBox.FreeNotification(Self);
  FScrollBox.Parent := FPopup;
  FScrollBox.Align := TAlignLayout.Client;
  FScrollBox.ShowScrollBars := True;
end;

procedure TRickUIBuilderComboBoxPresentation.EnsureCreated;
begin
  if Assigned(FPopup) then
    Exit;
  CreateBackdrop;
  CreatePopupControl;
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
  begin
    PlaceBelow(Max(1, LBelow));
    Exit;
  end;
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
end;

procedure TRickUIBuilderComboBoxPresentation.Open(AItemCount: Integer);
var
  LHeight: Single;
begin
  EnsureCreated;
  UpdateBackdropBounds;
  LHeight := DesiredHeight(AItemCount);

  if FConfig.PresentationMode =
    TRickUIBuilderComboBoxPresentationMode.Overlay then
    PlaceOverlay(LHeight)
  else
    PlaceAnchored(LHeight);

  if Assigned(FBackdrop) then
  begin
    FBackdrop.Visible := True;
    FBackdrop.BringToFront;
  end;

  FPopup.Visible := True;
  FPopup.BringToFront;
end;

procedure TRickUIBuilderComboBoxPresentation.Close;
begin
  if Assigned(FPopup) then
    FPopup.Visible := False;
  if Assigned(FBackdrop) then
    FBackdrop.Visible := False;
end;

procedure TRickUIBuilderComboBoxPresentation.Detach;
var
  LFreeVisuals: Boolean;
begin
  LFreeVisuals := Assigned(FParent);
  if Assigned(FScrollBox) then
    FScrollBox.RemoveFreeNotification(Self);

  if Assigned(FPopup) then
  begin
    FPopup.RemoveFreeNotification(Self);
    if LFreeVisuals then
      FreeAndNil(FPopup)
    else
      FPopup := nil;
  end;

  if Assigned(FBackdrop) then
  begin
    FBackdrop.OnClick := nil;
    FBackdrop.RemoveFreeNotification(Self);
    if LFreeVisuals then
      FreeAndNil(FBackdrop)
    else
      FBackdrop := nil;
  end;

  if Assigned(FAnchor) then
    FAnchor.RemoveFreeNotification(Self);
  if FParent is TComponent then
    TComponent(FParent).RemoveFreeNotification(Self);
  FScrollBox := nil;
  FAnchor := nil;
  FParent := nil;
  FOwner := nil;
end;

procedure TRickUIBuilderComboBoxPresentation.ClearVisualReference(
  AComponent: TComponent);
begin
  if AComponent = FScrollBox then
    FScrollBox := nil;
  if AComponent = FPopup then
  begin
    FPopup := nil;
    FScrollBox := nil;
  end;
  if AComponent = FBackdrop then
    FBackdrop := nil;
  if AComponent = FAnchor then
    FAnchor := nil;
  if AComponent = FParent then
    FParent := nil;
end;

procedure TRickUIBuilderComboBoxPresentation.Notification(
  AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if Operation <> opRemove then
    Exit;
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
