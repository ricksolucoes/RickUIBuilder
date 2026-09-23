unit Rick.UIBuilder.ComboBox.Virtualization;
(*
  ============================================================================
  Unit: Rick.UIBuilder.ComboBox.Virtualization
  ============================================================================

  RESPONSABILIDADE

  Mantem um pool visual proporcional ao viewport, reciclando cada linha pelo
  ciclo Reset -> Bind -> State -> Custom Content. O Data Model permanece
  independente e continua contendo todos os itens logicos.
  ============================================================================
*)

interface

uses
  System.Classes,
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Generics.Collections,
  FMX.Types,
  FMX.Controls,
  FMX.Layouts,
  FMX.Objects,
  FMX.StdCtrls,
  Rick.UIBuilder.Types,
  Rick.UIBuilder.Interfaces,
  Rick.UIBuilder.ComboBox.Data;

type
  TRickUIBuilderComboBoxVirtualizer = class(TComponent)
  strict private
    FScrollBox: TVertScrollBox;
    FData: TRickUIBuilderComboBoxData;
    FConfig: TRickUIBuilderComboBoxConfig;
    FColumns: TArray<TRickUIBuilderComboBoxColumn>;
    FRows: TList<TRectangle>;
    FSpacer: TRectangle;
    FOnRowClick: TNotifyEvent;
    FOnCustomizeItem: TRickUIBuilderComboBoxCustomizeItemEvent;
    FSelectedIndex: Integer;
    FTargetIndex: Integer;
    FRefreshing: Boolean;
    procedure EnsurePool;
    procedure RowMouseEnter(Sender: TObject);
    procedure RowMouseLeave(Sender: TObject);
    procedure ResetRow(ARow: TRectangle);
    procedure BindRow(ARow: TRectangle; AIndex: Integer);
    procedure CreateCustomSlot(ARow: TRectangle; ASourceIndex: Integer;
      const AItem: TRickUIBuilderComboBoxItem);
    procedure BuildTextCells(ARow: TRectangle;
      const AItem: TRickUIBuilderComboBoxItem);
    procedure BuildSimpleText(ARow: TRectangle; const AText: string);
    procedure BuildColumnText(ARow: TRectangle;
      const AItem: TRickUIBuilderComboBoxItem);
    procedure CreateColumnLabel(ARow: TRectangle; AColumnIndex: Integer;
      ALeft, AWidth: Single; const AText: string);
    function VisibleColumnCount: Integer;
    function FixedColumnsWidth: Single;
    function FlexibleColumnsWeight: Single;
    function ColumnWidth(AIndex: Integer; AAvailableWidth: Single): Single;
    procedure ApplyRowState(ARow: TRectangle; AIndex, ASelectedIndex,
      ATargetIndex: Integer);
    function RequiredPoolSize: Integer;
    function FirstVisibleIndex: Integer;
    procedure UpdateContentHeight;
    procedure DetachVisualPool;
    procedure ViewportChanged(Sender: TObject; const AOldPosition,
      ANewPosition: TPointF; const AContentSizeChanged: Boolean);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AScrollBox: TVertScrollBox;
      AData: TRickUIBuilderComboBoxData;
      const AConfig: TRickUIBuilderComboBoxConfig);
    destructor Destroy; override;
    procedure SetColumns(const AColumns: TArray<TRickUIBuilderComboBoxColumn>);
    procedure SetOnRowClick(AValue: TNotifyEvent);
    procedure SetOnCustomizeItem(AValue: TRickUIBuilderComboBoxCustomizeItemEvent);
    procedure Refresh(ASelectedIndex, ATargetIndex: Integer);
    procedure EnsureIndexVisible(AIndex: Integer);
  end;

implementation

uses
  System.Math,
  FMX.Graphics;

constructor TRickUIBuilderComboBoxVirtualizer.Create(
  AScrollBox: TVertScrollBox; AData: TRickUIBuilderComboBoxData;
  const AConfig: TRickUIBuilderComboBoxConfig);
begin
  inherited Create(nil);
  FScrollBox := AScrollBox;
  FData := AData;
  FConfig := AConfig;
  FRows := TList<TRectangle>.Create;
  FScrollBox.FreeNotification(Self);

  FSpacer := TRectangle.Create(FScrollBox);
  FSpacer.Parent := FScrollBox;
  FSpacer.SetBounds(0, 0, 1, 1);
  FSpacer.Fill.Color := TAlphaColors.Null;
  FSpacer.Stroke.Kind := TBrushKind.None;
  FSpacer.Opacity := 0;
  FSpacer.HitTest := False;
  FScrollBox.OnViewportPositionChange := ViewportChanged;
end;

destructor TRickUIBuilderComboBoxVirtualizer.Destroy;
begin
  if Assigned(FScrollBox) then
  begin
    FScrollBox.OnViewportPositionChange := nil;
    FScrollBox.RemoveFreeNotification(Self);
  end;
  DetachVisualPool;
  FRows.Free;
  inherited;
end;

procedure TRickUIBuilderComboBoxVirtualizer.DetachVisualPool;
var
  LRow: TRectangle;
begin
  if Assigned(FScrollBox) then
    for LRow in FRows do
    begin
      LRow.OnClick := nil;
      LRow.OnMouseEnter := nil;
      LRow.OnMouseLeave := nil;
    end;
  FRows.Clear;
  FSpacer := nil;
end;

procedure TRickUIBuilderComboBoxVirtualizer.Notification(
  AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if (Operation <> opRemove) or (AComponent <> FScrollBox) then
    Exit;

  FScrollBox := nil;
  FRows.Clear;
  FSpacer := nil;
end;

procedure TRickUIBuilderComboBoxVirtualizer.SetColumns(
  const AColumns: TArray<TRickUIBuilderComboBoxColumn>);
begin
  FColumns := Copy(AColumns, 0, Length(AColumns));
end;

procedure TRickUIBuilderComboBoxVirtualizer.SetOnCustomizeItem(
  AValue: TRickUIBuilderComboBoxCustomizeItemEvent);
begin
  FOnCustomizeItem := AValue;
end;

procedure TRickUIBuilderComboBoxVirtualizer.SetOnRowClick(
  AValue: TNotifyEvent);
begin
  FOnRowClick := AValue;
end;

function TRickUIBuilderComboBoxVirtualizer.RequiredPoolSize: Integer;
begin
  Result := Ceil(FScrollBox.Height / Max(FConfig.ItemHeight, 1)) + 2;
  Result := Min(Result, FData.ViewCount);
end;

procedure TRickUIBuilderComboBoxVirtualizer.EnsurePool;
var
  LRow: TRectangle;
begin
  while FRows.Count < RequiredPoolSize do
  begin
    LRow := TRectangle.Create(FScrollBox);
    LRow.Parent := FScrollBox;
    LRow.Height := FConfig.ItemHeight;
    LRow.Fill.Kind := TBrushKind.Solid;
    LRow.Fill.Color := FConfig.PopupColor;
    LRow.Stroke.Kind := TBrushKind.None;
    LRow.Cursor := crHandPoint;
    LRow.OnClick := FOnRowClick;
    LRow.OnMouseEnter := RowMouseEnter;
    LRow.OnMouseLeave := RowMouseLeave;
    FRows.Add(LRow);
  end;
end;

procedure TRickUIBuilderComboBoxVirtualizer.RowMouseEnter(Sender: TObject);
begin
  if not (Sender is TRectangle) then
    Exit;
  if TRectangle(Sender).Tag <> FSelectedIndex then
    TRectangle(Sender).Fill.Color := FConfig.HoverColor;
end;

procedure TRickUIBuilderComboBoxVirtualizer.RowMouseLeave(Sender: TObject);
var
  LRow: TRectangle;
begin
  if not (Sender is TRectangle) then
    Exit;
  LRow := TRectangle(Sender);
  ApplyRowState(LRow, LRow.Tag, FSelectedIndex, FTargetIndex);
end;

procedure TRickUIBuilderComboBoxVirtualizer.ResetRow(ARow: TRectangle);
begin
  ARow.Visible := False;
  ARow.Tag := -1;
  ARow.Fill.Color := FConfig.PopupColor;
  while ARow.ChildrenCount > 0 do
    ARow.Children[0].Free;
end;

function TRickUIBuilderComboBoxVirtualizer.VisibleColumnCount: Integer;
var
  LColumn: TRickUIBuilderComboBoxColumn;
begin
  Result := 0;
  for LColumn in FColumns do
    if LColumn.Visible then
      Inc(Result);
end;

function TRickUIBuilderComboBoxVirtualizer.FixedColumnsWidth: Single;
var
  LColumn: TRickUIBuilderComboBoxColumn;
begin
  Result := 0;
  for LColumn in FColumns do
    if LColumn.Visible and
      (LColumn.SizeMode = TRickUIBuilderComboBoxColumnSizeMode.Fixed) then
      Result := Result + Max(0, LColumn.SizeValue);
end;

function TRickUIBuilderComboBoxVirtualizer.FlexibleColumnsWeight: Single;
var
  LColumn: TRickUIBuilderComboBoxColumn;
begin
  Result := 0;
  for LColumn in FColumns do
    if LColumn.Visible and
      (LColumn.SizeMode <> TRickUIBuilderComboBoxColumnSizeMode.Fixed) then
      if LColumn.SizeMode =
        TRickUIBuilderComboBoxColumnSizeMode.Proportional then
        Result := Result + Max(0.01, LColumn.SizeValue)
      else
        Result := Result + 1;
end;

function TRickUIBuilderComboBoxVirtualizer.ColumnWidth(AIndex: Integer;
  AAvailableWidth: Single): Single;
var
  LRemaining: Single;
  LWeight: Single;
begin
  if FColumns[AIndex].SizeMode =
    TRickUIBuilderComboBoxColumnSizeMode.Fixed then
    Exit(Max(0, FColumns[AIndex].SizeValue));

  LRemaining := Max(0, AAvailableWidth - FixedColumnsWidth);
  LWeight := FlexibleColumnsWeight;
  if LWeight <= 0 then
    Exit(0);

  if FColumns[AIndex].SizeMode =
    TRickUIBuilderComboBoxColumnSizeMode.Proportional then
    Result := LRemaining * Max(0.01, FColumns[AIndex].SizeValue) / LWeight
  else
    Result := LRemaining / LWeight;
end;

procedure TRickUIBuilderComboBoxVirtualizer.BuildSimpleText(
  ARow: TRectangle; const AText: string);
var
  LLabel: TLabel;
begin
  LLabel := TLabel.Create(ARow);
  LLabel.Parent := ARow;
  LLabel.Align := TAlignLayout.Client;
  LLabel.Margins.Left := FConfig.HorizontalPadding;
  LLabel.Margins.Right := FConfig.HorizontalPadding;
  LLabel.Text := AText;
  LLabel.TextSettings.Font.Size := FConfig.FontSize;
  LLabel.TextSettings.Font.Style := FConfig.FontStyle;
  LLabel.TextSettings.FontColor := FConfig.TextColor;
  LLabel.TextSettings.HorzAlign := FConfig.TextAlign;
  LLabel.TextSettings.VertAlign := TTextAlign.Center;
  LLabel.TextSettings.Trimming := FConfig.Trimming;
  LLabel.StyledSettings := LLabel.StyledSettings -
    [TStyledSetting.Size, TStyledSetting.Style, TStyledSetting.FontColor];
  if FConfig.FontFamily <> '' then
  begin
    LLabel.TextSettings.Font.Family := FConfig.FontFamily;
    LLabel.StyledSettings := LLabel.StyledSettings - [TStyledSetting.Family];
  end;
  LLabel.HitTest := False;
end;

procedure TRickUIBuilderComboBoxVirtualizer.CreateColumnLabel(
  ARow: TRectangle; AColumnIndex: Integer; ALeft, AWidth: Single;
  const AText: string);
var
  LLabel: TLabel;
begin
  LLabel := TLabel.Create(ARow);
  LLabel.Parent := ARow;
  LLabel.SetBounds(ALeft, 0, AWidth, ARow.Height);
  LLabel.Margins.Left := FConfig.HorizontalPadding;
  LLabel.Text := AText;
  LLabel.TextSettings.Font.Size := FConfig.FontSize;
  LLabel.TextSettings.Font.Style := FConfig.FontStyle;
  LLabel.TextSettings.FontColor := FConfig.TextColor;
  LLabel.TextSettings.HorzAlign := FColumns[AColumnIndex].Alignment;
  LLabel.TextSettings.VertAlign := TTextAlign.Center;
  LLabel.TextSettings.Trimming := FConfig.Trimming;
  LLabel.StyledSettings := LLabel.StyledSettings -
    [TStyledSetting.Size, TStyledSetting.Style, TStyledSetting.FontColor];
  if FConfig.FontFamily <> '' then
  begin
    LLabel.TextSettings.Font.Family := FConfig.FontFamily;
    LLabel.StyledSettings := LLabel.StyledSettings - [TStyledSetting.Family];
  end;
  LLabel.HitTest := False;
end;

procedure TRickUIBuilderComboBoxVirtualizer.BuildColumnText(
  ARow: TRectangle; const AItem: TRickUIBuilderComboBoxItem);
var
  LIndex: Integer;
  LLeft: Single;
  LWidth: Single;
  LText: string;
begin
  LLeft := 0;
  for LIndex := 0 to High(FColumns) do
  begin
    if not FColumns[LIndex].Visible then
      Continue;
    LText := '';
    if LIndex <= High(AItem.Columns) then
      LText := AItem.Columns[LIndex];
    LWidth := ColumnWidth(LIndex, ARow.Width);
    CreateColumnLabel(ARow, LIndex, LLeft, LWidth, LText);
    LLeft := LLeft + LWidth;
  end;
end;

procedure TRickUIBuilderComboBoxVirtualizer.BuildTextCells(
  ARow: TRectangle; const AItem: TRickUIBuilderComboBoxItem);
begin
  if FConfig.EffectiveStyleType = TRickUIBuilderComboBoxStyleType.Mobile then
  begin
    BuildSimpleText(ARow, AItem.DisplayText);
    Exit;
  end;

  if (Length(AItem.Columns) = 0) or (VisibleColumnCount = 0) then
    BuildSimpleText(ARow, AItem.DisplayText)
  else
    BuildColumnText(ARow, AItem);
end;

procedure TRickUIBuilderComboBoxVirtualizer.ApplyRowState(ARow: TRectangle;
  AIndex, ASelectedIndex, ATargetIndex: Integer);
begin
  if AIndex = ASelectedIndex then
    ARow.Fill.Color := FConfig.SelectedColor
  else if AIndex = ATargetIndex then
    ARow.Fill.Color := FConfig.HoverColor
  else
    ARow.Fill.Color := FConfig.PopupColor;
end;

procedure TRickUIBuilderComboBoxVirtualizer.BindRow(ARow: TRectangle;
  AIndex: Integer);
var
  LItem: TRickUIBuilderComboBoxItem;
  LSourceIndex: Integer;
begin
  ResetRow(ARow);
  LSourceIndex := FData.SourceIndexFromView(AIndex);
  if LSourceIndex < 0 then
    Exit;

  LItem := FData.Item(LSourceIndex);
  ARow.Tag := LSourceIndex;
  ARow.Position.Y := AIndex * FConfig.ItemHeight;
  ARow.Width := FScrollBox.Width;
  ARow.Height := FConfig.ItemHeight;
  BuildTextCells(ARow, LItem);

  if Assigned(FOnCustomizeItem) then
    CreateCustomSlot(ARow, LSourceIndex, LItem);
  ARow.Visible := True;
end;

procedure TRickUIBuilderComboBoxVirtualizer.CreateCustomSlot(
  ARow: TRectangle; ASourceIndex: Integer;
  const AItem: TRickUIBuilderComboBoxItem);
var
  LCustomSlot: TLayout;
begin
  LCustomSlot := TLayout.Create(ARow);
  LCustomSlot.Parent := ARow;
  LCustomSlot.Align := TAlignLayout.Client;
  LCustomSlot.HitTest := False;
  FOnCustomizeItem(Self, ASourceIndex, AItem, LCustomSlot);
end;

function TRickUIBuilderComboBoxVirtualizer.FirstVisibleIndex: Integer;
begin
  Result := Floor(FScrollBox.ViewportPosition.Y / Max(FConfig.ItemHeight, 1));
  Result := Max(0, Result - 1);
  Result := Min(Result, Max(0, FData.ViewCount - RequiredPoolSize));
end;

procedure TRickUIBuilderComboBoxVirtualizer.UpdateContentHeight;
begin
  if not Assigned(FSpacer) then
    Exit;
  FSpacer.Position.Y := Max(0, FData.ViewCount * FConfig.ItemHeight - 1);
end;

procedure TRickUIBuilderComboBoxVirtualizer.Refresh(ASelectedIndex,
  ATargetIndex: Integer);
var
  LPoolIndex: Integer;
  LLogicalIndex: Integer;
begin
  if FRefreshing or not Assigned(FScrollBox) then
    Exit;

  FRefreshing := True;
  try
    FSelectedIndex := ASelectedIndex;
    FTargetIndex := ATargetIndex;
    UpdateContentHeight;
    EnsurePool;
    LLogicalIndex := FirstVisibleIndex;

    for LPoolIndex := 0 to FRows.Count - 1 do
    begin
      BindRow(FRows[LPoolIndex], LLogicalIndex + LPoolIndex);
      if FRows[LPoolIndex].Visible then
        ApplyRowState(FRows[LPoolIndex], FRows[LPoolIndex].Tag,
          ASelectedIndex, ATargetIndex);
    end;
  finally
    FRefreshing := False;
  end;
end;

procedure TRickUIBuilderComboBoxVirtualizer.EnsureIndexVisible(
  AIndex: Integer);
var
  LTop: Single;
  LBottom: Single;
  LViewportTop: Single;
  LViewportBottom: Single;
  LPosition: TPointF;
  LViewIndex: Integer;
begin
  LViewIndex := FData.ViewIndexFromSource(AIndex);
  if LViewIndex < 0 then
    Exit;

  LTop := LViewIndex * FConfig.ItemHeight;
  LBottom := LTop + FConfig.ItemHeight;
  LViewportTop := FScrollBox.ViewportPosition.Y;
  LViewportBottom := LViewportTop + FScrollBox.Height;
  LPosition := FScrollBox.ViewportPosition;
  if LTop < LViewportTop then
    LPosition.Y := LTop
  else if LBottom > LViewportBottom then
    LPosition.Y := LBottom - FScrollBox.Height;
  FScrollBox.ViewportPosition := LPosition;
end;

procedure TRickUIBuilderComboBoxVirtualizer.ViewportChanged(Sender: TObject;
  const AOldPosition, ANewPosition: TPointF;
  const AContentSizeChanged: Boolean);
begin
  Refresh(FSelectedIndex, FTargetIndex);
end;

end.
