unit Rick.UIBuilder.Edit;
{$SCOPEDENUMS ON}

interface

uses
  System.UITypes,

  FMX.Edit,
  FMX.Types,
  FMX.Layouts,
  FMX.Objects,
  FMX.StdCtrls,
  FMX.Controls,

  Rick.UIBuilder.Types,
  Rick.UIBuilder.Interfaces,
  Rick.UIBuilder.Edit.Behavior;

type
  TRickUIBuilderEditBuilder = class(TInterfacedObject, IRickUIBuilderEdit)
  strict private type
    TActionControls = record
      Alert: TPath;
      ClearArea: TLayout;
      ClearIcon: TPath;
      PasswordArea: TLayout;
      PasswordIcon: TPath;
      Requirement: TPath;
    end;
  strict private
    FConfig: TRickUIBuilderEditConfig;
    function CreateContainer(AParent: TFmxObject): TRectangle;
    function CreateLabel(AContainer: TRectangle): TLabel;
    function CreateEditBackground(AContainer: TRectangle): TRectangle;
    function CreateEdit(AContainer: TRectangle): TEdit;
    function CreateCounter(AContainer: TRectangle): TLabel;
    function CreateErrorLabel(AContainer: TRectangle): TLabel;
    function CreatePath(AParent: TFmxObject; const AData: string;
      AColor: TAlphaColor): TPath;
    function CreateActionArea(AContainer: TRectangle; ALeft: Single): TLayout;
    function CreateAlert(AContainer: TRectangle): TPath;
    function CreateRequirement(AContainer: TRectangle; ALeft: Single): TPath;
    function ActionCount: Integer;
    function EditAreaWidth: Single;
    function CreateActions(AContainer: TRectangle): TActionControls;
    function CreateBehavior(AParent: TFmxObject; AContainer: TRectangle;
      AEdit: TEdit; ALabel, ACounter, AError: TLabel)
    : TRickUIBuilderEditBehavior;
  protected
    function Text(const AValue: string): IRickUIBuilderEdit;
    function LabelText(const AValue: string): IRickUIBuilderEdit;
    function Position(ALeft, ATop: Single): IRickUIBuilderEdit;
    function Size(AWidth, AHeight: Single): IRickUIBuilderEdit;
    function Preset(AValue: TRickUIBuilderEditPreset): IRickUIBuilderEdit;
    function CaseMode(AValue: TRickUIBuilderEditCaseMode): IRickUIBuilderEdit;
    function UrlCaseMode(AValue: TRickUIBuilderEditUrlCaseMode)
    : IRickUIBuilderEdit;
    function MaxLength(AValue: Integer): IRickUIBuilderEdit;
    function CharacterCounter(AValue: Boolean = True): IRickUIBuilderEdit;
    function AllowNegative(AValue: Boolean = True): IRickUIBuilderEdit;
    function DecimalPlaces(AValue: Integer): IRickUIBuilderEdit;
    function NumberFormatMode(AValue: TRickUIBuilderEditNumberFormatMode)
    : IRickUIBuilderEdit;
    function DecimalSeparator(AValue: Char): IRickUIBuilderEdit;
    function ThousandSeparator(AValue: Char): IRickUIBuilderEdit;
    function UseThousandSeparator(AValue: Boolean = True): IRickUIBuilderEdit;
    function ClearButton(AValue: Boolean = True): IRickUIBuilderEdit;
    function RequirementIndicator(AValue: Boolean = True): IRickUIBuilderEdit;
    function Password(AValue: Boolean = True): IRickUIBuilderEdit;
    function InvalidFeedback(AValue: TRickUIBuilderEditInvalidFeedback)
    : IRickUIBuilderEdit;
    function InvalidMessage(const AValue: string): IRickUIBuilderEdit;
    function BackgroundColor(AValue: TAlphaColor): IRickUIBuilderEdit;
    function EditBackgroundColor(AValue: TAlphaColor): IRickUIBuilderEdit;
    function BorderColor(AValue: TAlphaColor): IRickUIBuilderEdit;
    function FocusBorderColor(AValue: TAlphaColor): IRickUIBuilderEdit;
    function InvalidBorderColor(AValue: TAlphaColor): IRickUIBuilderEdit;
    function InvalidBackgroundColor(AValue: TAlphaColor): IRickUIBuilderEdit;
    function TextColor(AValue: TAlphaColor): IRickUIBuilderEdit;
    function LabelColor(AValue: TAlphaColor): IRickUIBuilderEdit;
    function InvalidLabelColor(AValue: TAlphaColor): IRickUIBuilderEdit;
    function IconColor(AValue: TAlphaColor): IRickUIBuilderEdit;
    function AlertIconColor(AValue: TAlphaColor): IRickUIBuilderEdit;
    function ClearIconColor(AValue: TAlphaColor): IRickUIBuilderEdit;
    function PasswordIconColor(AValue: TAlphaColor): IRickUIBuilderEdit;
    function RequirementIconColor(AValue: TAlphaColor): IRickUIBuilderEdit;
    function CornerRadius(AValue: Single): IRickUIBuilderEdit;
    function BorderThickness(AValue: Single): IRickUIBuilderEdit;
    function FontSize(AValue: Single): IRickUIBuilderEdit;
    function IconSize(AValue: Single): IRickUIBuilderEdit;
    function AlertPath(const AValue: string): IRickUIBuilderEdit;
    function ClearPath(const AValue: string): IRickUIBuilderEdit;
    function VisibilityPath(const AValue: string): IRickUIBuilderEdit;
    function VisibilityOffPath(const AValue: string): IRickUIBuilderEdit;
    function RequirementMetPath(const AValue: string): IRickUIBuilderEdit;
    function RequirementNotMetPath(const AValue: string): IRickUIBuilderEdit;
    function Build(AParent: TFmxObject): IRickUIBuilderEditHandle;

    constructor Create;

  public
    class function New: IRickUIBuilderEdit; static;
  end;

implementation

uses
  System.Classes,

  FMX.Graphics,

  Rick.UIBuilder.Edit.Input,
  Rick.UIBuilder.Edit.Handle;

type
  TRickUIBuilderRuntimeEdit = class(TEdit)
  strict private
    FInputConfig: TRickUIBuilderEditConfig;
    FInputConfigured: Boolean;
    FApplyingText: Boolean;
    FPendingCaret: Integer;
    FCaretUpdateQueued: Boolean;
    FPendingGoToEnd: Boolean;
    procedure ApplyPendingCaret;
    procedure QueueCaretUpdate(ACaret: Integer; AGoToEnd: Boolean = False);
    function IsAppendingAtEnd(const AOldText, ANewText: string): Boolean;
    function ChangedCaretPosition(const AOldText, ANewText: string;
      AOldCaret: Integer): Integer;
    function FormattedCaretPosition(const AValue: string;
      ARawCaret: Integer): Integer;
    procedure ApplyResolvedText(const AValue, AResolved: string;
      ACaret: Integer; AAppendAtEnd: Boolean);
  protected
    procedure SetText(const Value: string); override;
  public
    procedure ConfigureInput(const AConfig: TRickUIBuilderEditConfig);
  end;

procedure TRickUIBuilderRuntimeEdit.ConfigureInput(
  const AConfig: TRickUIBuilderEditConfig);
begin
  FInputConfig := AConfig;
  FInputConfigured := True;
end;

procedure TRickUIBuilderRuntimeEdit.ApplyPendingCaret;
begin
  FCaretUpdateQueued := False;
  if csDestroying in ComponentState then
    Exit;
  if FPendingGoToEnd then
  begin
    FPendingGoToEnd := False;
    GoToTextEnd;
    Exit;
  end;
  if FPendingCaret > Length(Text) then
    FPendingCaret := Length(Text);
  CaretPosition := FPendingCaret;
  SelLength := 0;
end;

procedure TRickUIBuilderRuntimeEdit.QueueCaretUpdate(ACaret: Integer;
  AGoToEnd: Boolean);
begin
  FPendingCaret := ACaret;
  FPendingGoToEnd := FPendingGoToEnd or AGoToEnd;
  if FCaretUpdateQueued then
    Exit;
  FCaretUpdateQueued := True;
  BeginInvoke(
    procedure
    begin
      ApplyPendingCaret;
    end, Self);
end;

function TRickUIBuilderRuntimeEdit.IsAppendingAtEnd(const AOldText,
  ANewText: string): Boolean;
begin
  Result := IsFocused and (SelLength = 0) and
    (CaretPosition = Length(AOldText)) and
    (Length(ANewText) > Length(AOldText)) and
    (Copy(ANewText, 1, Length(AOldText)) = AOldText);
end;

function TRickUIBuilderRuntimeEdit.ChangedCaretPosition(const AOldText,
  ANewText: string; AOldCaret: Integer): Integer;
var
  LPrefix, LSuffix: Integer;
begin
  if AOldText = ANewText then
    Exit(AOldCaret);
  LPrefix := 0;
  while (LPrefix < Length(AOldText)) and (LPrefix < Length(ANewText)) and
    (AOldText[LPrefix + 1] = ANewText[LPrefix + 1]) do
    Inc(LPrefix);
  LSuffix := 0;
  while (LSuffix < Length(AOldText) - LPrefix) and
    (LSuffix < Length(ANewText) - LPrefix) and
    (AOldText[Length(AOldText) - LSuffix] =
      ANewText[Length(ANewText) - LSuffix]) do
    Inc(LSuffix);
  Result := Length(ANewText) - LSuffix;
end;

function TRickUIBuilderRuntimeEdit.FormattedCaretPosition(const AValue: string;
  ARawCaret: Integer): Integer;
var
  LPrefix: string;
begin
  if ARawCaret < 0 then
    ARawCaret := 0;
  if ARawCaret > Length(AValue) then
    ARawCaret := Length(AValue);
  LPrefix := Copy(AValue, 1, ARawCaret);
  Result := Length(TRickUIBuilderEditInput.FormatTypedValue(LPrefix,
    FInputConfig));
end;

procedure TRickUIBuilderRuntimeEdit.ApplyResolvedText(const AValue,
  AResolved: string; ACaret: Integer; AAppendAtEnd: Boolean);
begin
  FApplyingText := True;
  try
    inherited SetText(AResolved);
    ACaret := FormattedCaretPosition(AValue, ACaret);
    if AAppendAtEnd then
      GoToTextEnd
    else
      CaretPosition := ACaret;
    SelLength := 0;
    QueueCaretUpdate(ACaret, AAppendAtEnd);
  finally
    FApplyingText := False;
  end;
end;

procedure TRickUIBuilderRuntimeEdit.SetText(const Value: string);
var
  LAppendAtEnd: Boolean;
  LCaret: Integer;
  LOldText, LResolved: string;
begin
  if FApplyingText or not FInputConfigured then
  begin
    inherited SetText(Value);
    Exit;
  end;
  if not TRickUIBuilderEditInput.IsTypedValueAllowed(Value, FInputConfig) then
    Exit;
  LOldText := Text;
  LAppendAtEnd := IsAppendingAtEnd(LOldText, Value);
  LCaret := ChangedCaretPosition(LOldText, Value, CaretPosition);
  LResolved := TRickUIBuilderEditInput.FormatTypedValue(Value, FInputConfig);
  if not TRickUIBuilderEditInput.IsValueAllowed(LResolved, FInputConfig) then
    Exit;
  ApplyResolvedText(Value, LResolved, LCaret, LAppendAtEnd);
end;

constructor TRickUIBuilderEditBuilder.Create;
begin
  inherited Create;
  FConfig := TRickUIBuilderEditConfig.Default;
end;

class function TRickUIBuilderEditBuilder.New: IRickUIBuilderEdit;
begin
  Result := TRickUIBuilderEditBuilder.Create;
end;

function TRickUIBuilderEditBuilder.Text(const AValue: string)
: IRickUIBuilderEdit;
begin
  FConfig.Text := AValue;
  Result := Self;
end;

function TRickUIBuilderEditBuilder.LabelText(const AValue: string)
: IRickUIBuilderEdit;
begin
  FConfig.LabelText := AValue;
  Result := Self;
end;

function TRickUIBuilderEditBuilder.Position(ALeft, ATop: Single)
: IRickUIBuilderEdit;
begin
  FConfig.Left := ALeft;
  FConfig.Top := ATop;
  Result := Self;
end;

function TRickUIBuilderEditBuilder.Size(AWidth, AHeight: Single)
: IRickUIBuilderEdit;
begin
  FConfig.Width := AWidth;
  FConfig.Height := AHeight;
  Result := Self;
end;

function TRickUIBuilderEditBuilder.Preset(AValue: TRickUIBuilderEditPreset)
: IRickUIBuilderEdit;
begin
  FConfig.Preset := AValue;
  Result := Self;
end;

function TRickUIBuilderEditBuilder.CaseMode(AValue: TRickUIBuilderEditCaseMode)
: IRickUIBuilderEdit;
begin
  FConfig.CaseMode := AValue;
  Result := Self;
end;

function TRickUIBuilderEditBuilder.UrlCaseMode
(AValue: TRickUIBuilderEditUrlCaseMode): IRickUIBuilderEdit;
begin
  FConfig.UrlCaseMode := AValue;
  Result := Self;
end;

function TRickUIBuilderEditBuilder.MaxLength(AValue: Integer)
: IRickUIBuilderEdit;
begin
  FConfig.MaxLength := AValue;
  Result := Self;
end;

function TRickUIBuilderEditBuilder.CharacterCounter(AValue: Boolean)
: IRickUIBuilderEdit;
begin
  FConfig.ShowCounter := AValue;
  Result := Self;
end;

function TRickUIBuilderEditBuilder.AllowNegative(AValue: Boolean)
: IRickUIBuilderEdit;
begin
  FConfig.AllowNegative := AValue;
  Result := Self;
end;

function TRickUIBuilderEditBuilder.DecimalPlaces(AValue: Integer)
: IRickUIBuilderEdit;
begin
  FConfig.DecimalPlaces := AValue;
  Result := Self;
end;

function TRickUIBuilderEditBuilder.NumberFormatMode
(AValue: TRickUIBuilderEditNumberFormatMode): IRickUIBuilderEdit;
begin
  FConfig.NumberFormatMode := AValue;
  Result := Self;
end;

function TRickUIBuilderEditBuilder.DecimalSeparator(AValue: Char)
: IRickUIBuilderEdit;
begin
  FConfig.DecimalSeparator := AValue;
  Result := Self;
end;

function TRickUIBuilderEditBuilder.ThousandSeparator(AValue: Char)
: IRickUIBuilderEdit;
begin
  FConfig.ThousandSeparator := AValue;
  Result := Self;
end;

function TRickUIBuilderEditBuilder.UseThousandSeparator(AValue: Boolean)
: IRickUIBuilderEdit;
begin
  FConfig.UseThousandSeparator := AValue;
  Result := Self;
end;

function TRickUIBuilderEditBuilder.ClearButton(AValue: Boolean)
: IRickUIBuilderEdit;
begin
  FConfig.ShowClearButton := AValue;
  Result := Self;
end;

function TRickUIBuilderEditBuilder.RequirementIndicator(AValue: Boolean)
: IRickUIBuilderEdit;
begin
  FConfig.ShowRequirementIndicator := AValue;
  Result := Self;
end;

function TRickUIBuilderEditBuilder.Password(AValue: Boolean)
: IRickUIBuilderEdit;
begin
  FConfig.Password := AValue;
  Result := Self;
end;

function TRickUIBuilderEditBuilder.InvalidFeedback
(AValue: TRickUIBuilderEditInvalidFeedback): IRickUIBuilderEdit;
begin
  FConfig.InvalidFeedback := AValue;
  Result := Self;
end;

function TRickUIBuilderEditBuilder.InvalidMessage(const AValue: string)
: IRickUIBuilderEdit;
begin
  FConfig.InvalidMessage := AValue;
  Result := Self;
end;

function TRickUIBuilderEditBuilder.BackgroundColor(AValue: TAlphaColor)
: IRickUIBuilderEdit;
begin
  FConfig.BackgroundColor := AValue;
  Result := Self;
end;

function TRickUIBuilderEditBuilder.EditBackgroundColor(AValue: TAlphaColor)
: IRickUIBuilderEdit;
begin
  FConfig.EditBackgroundColor := AValue;
  Result := Self;
end;

function TRickUIBuilderEditBuilder.BorderColor(AValue: TAlphaColor)
: IRickUIBuilderEdit;
begin
  FConfig.BorderColor := AValue;
  Result := Self;
end;

function TRickUIBuilderEditBuilder.FocusBorderColor(AValue: TAlphaColor)
: IRickUIBuilderEdit;
begin
  FConfig.FocusBorderColor := AValue;
  Result := Self;
end;

function TRickUIBuilderEditBuilder.InvalidBorderColor(AValue: TAlphaColor)
: IRickUIBuilderEdit;
begin
  FConfig.InvalidBorderColor := AValue;
  Result := Self;
end;

function TRickUIBuilderEditBuilder.InvalidBackgroundColor(AValue: TAlphaColor)
: IRickUIBuilderEdit;
begin
  FConfig.InvalidBackgroundColor := AValue;
  Result := Self;
end;

function TRickUIBuilderEditBuilder.TextColor(AValue: TAlphaColor)
: IRickUIBuilderEdit;
begin
  FConfig.TextColor := AValue;
  Result := Self;
end;

function TRickUIBuilderEditBuilder.LabelColor(AValue: TAlphaColor)
: IRickUIBuilderEdit;
begin
  FConfig.LabelColor := AValue;
  Result := Self;
end;

function TRickUIBuilderEditBuilder.InvalidLabelColor(AValue: TAlphaColor)
: IRickUIBuilderEdit;
begin
  FConfig.InvalidLabelColor := AValue;
  Result := Self;
end;

function TRickUIBuilderEditBuilder.IconColor(AValue: TAlphaColor)
: IRickUIBuilderEdit;
begin
  FConfig.IconColor := AValue;
  FConfig.AlertIconColor := AValue;
  FConfig.ClearIconColor := AValue;
  FConfig.PasswordIconColor := AValue;
  FConfig.RequirementIconColor := AValue;
  Result := Self;
end;

function TRickUIBuilderEditBuilder.AlertIconColor(AValue: TAlphaColor)
: IRickUIBuilderEdit;
begin
  FConfig.AlertIconColor := AValue;
  Result := Self;
end;

function TRickUIBuilderEditBuilder.ClearIconColor(AValue: TAlphaColor)
: IRickUIBuilderEdit;
begin
  FConfig.ClearIconColor := AValue;
  Result := Self;
end;

function TRickUIBuilderEditBuilder.PasswordIconColor(AValue: TAlphaColor)
: IRickUIBuilderEdit;
begin
  FConfig.PasswordIconColor := AValue;
  Result := Self;
end;

function TRickUIBuilderEditBuilder.RequirementIconColor(AValue: TAlphaColor)
: IRickUIBuilderEdit;
begin
  FConfig.RequirementIconColor := AValue;
  Result := Self;
end;

function TRickUIBuilderEditBuilder.CornerRadius(AValue: Single)
: IRickUIBuilderEdit;
begin
  FConfig.CornerRadius := AValue;
  Result := Self;
end;

function TRickUIBuilderEditBuilder.BorderThickness(AValue: Single)
: IRickUIBuilderEdit;
begin
  FConfig.BorderThickness := AValue;
  Result := Self;
end;

function TRickUIBuilderEditBuilder.FontSize(AValue: Single): IRickUIBuilderEdit;
begin
  FConfig.FontSize := AValue;
  Result := Self;
end;

function TRickUIBuilderEditBuilder.IconSize(AValue: Single): IRickUIBuilderEdit;
begin
  FConfig.IconSize := AValue;
  Result := Self;
end;

function TRickUIBuilderEditBuilder.AlertPath(const AValue: string)
: IRickUIBuilderEdit;
begin
  FConfig.AlertPath := AValue;
  Result := Self;
end;

function TRickUIBuilderEditBuilder.ClearPath(const AValue: string)
: IRickUIBuilderEdit;
begin
  FConfig.ClearPath := AValue;
  Result := Self;
end;

function TRickUIBuilderEditBuilder.VisibilityPath(const AValue: string)
: IRickUIBuilderEdit;
begin
  FConfig.VisibilityPath := AValue;
  Result := Self;
end;

function TRickUIBuilderEditBuilder.VisibilityOffPath(const AValue: string)
: IRickUIBuilderEdit;
begin
  FConfig.VisibilityOffPath := AValue;
  Result := Self;
end;

function TRickUIBuilderEditBuilder.RequirementMetPath(const AValue: string)
: IRickUIBuilderEdit;
begin
  FConfig.RequirementMetPath := AValue;
  Result := Self;
end;

function TRickUIBuilderEditBuilder.RequirementNotMetPath(const AValue: string)
: IRickUIBuilderEdit;
begin
  FConfig.RequirementNotMetPath := AValue;
  Result := Self;
end;

function TRickUIBuilderEditBuilder.CreateContainer(AParent: TFmxObject)
: TRectangle;
begin
  Result := TRectangle.Create(AParent);
  Result.Parent := AParent;
  Result.SetBounds(FConfig.Left, FConfig.Top, FConfig.Width, FConfig.Height);
  Result.XRadius := FConfig.CornerRadius;
  Result.YRadius := FConfig.CornerRadius;
  Result.Fill.Color := FConfig.BackgroundColor;
  Result.Stroke.Color := FConfig.BorderColor;
  Result.Stroke.Thickness := FConfig.BorderThickness;
end;

function TRickUIBuilderEditBuilder.CreateLabel(AContainer: TRectangle): TLabel;
begin
  Result := TLabel.Create(AContainer);
  Result.Parent := AContainer;
  Result.SetBounds(12, 3, FConfig.Width - 24, 18);
  Result.Text := FConfig.LabelText;
  Result.TextSettings.Font.Size := FConfig.FontSize - 2;
  Result.TextSettings.FontColor := FConfig.LabelColor;
  Result.HitTest := False;
end;

function TRickUIBuilderEditBuilder.ActionCount: Integer;
begin
  Result := 0;
  if FConfig.InvalidFeedback <> TRickUIBuilderEditInvalidFeedback.AlertOnly then
    Inc(Result);
  if FConfig.ShowClearButton then
    Inc(Result);
  if FConfig.Password then
    Inc(Result);
  if FConfig.ShowRequirementIndicator then
    Inc(Result);
end;

function TRickUIBuilderEditBuilder.EditAreaWidth: Single;
begin
  Result := FConfig.Width - 16 - (ActionCount * 32);
  if Result < 40 then
    Result := 40;
end;

function TRickUIBuilderEditBuilder.CreateEditBackground(
  AContainer: TRectangle): TRectangle;
begin
  Result := TRectangle.Create(AContainer);
  Result.Parent := AContainer;
  Result.SetBounds(8, 20, EditAreaWidth, 36);
  Result.Fill.Color := FConfig.EditBackgroundColor;
  Result.Stroke.Kind := TBrushKind.None;
  Result.HitTest := False;
end;

function TRickUIBuilderEditBuilder.CreateEdit(AContainer: TRectangle): TEdit;
var
  LEdit: TRickUIBuilderRuntimeEdit;
begin
  LEdit := TRickUIBuilderRuntimeEdit.Create(AContainer);
  LEdit.ConfigureInput(FConfig);
  Result := LEdit;
  Result.Parent := AContainer;
  Result.SetBounds(8, 20, EditAreaWidth, 36);
  Result.StyleLookup := 'transparentedit';
  Result.TextSettings.Font.Size := FConfig.FontSize;
  Result.TextSettings.FontColor := FConfig.TextColor;
  Result.Password := FConfig.Password;
end;

function TRickUIBuilderEditBuilder.CreateCounter
(AContainer: TRectangle): TLabel;
begin
  Result := TLabel.Create(AContainer);
  Result.Parent := AContainer;
  Result.SetBounds(FConfig.Width - 72, FConfig.Height - 20, 64, 16);
  Result.TextSettings.HorzAlign := TTextAlign.Trailing;
  Result.TextSettings.Font.Size := FConfig.FontSize - 3;
  Result.HitTest := False;
end;

function TRickUIBuilderEditBuilder.CreateErrorLabel
(AContainer: TRectangle): TLabel;
begin
  Result := TLabel.Create(AContainer);
  Result.Parent := AContainer;
  Result.SetBounds(12, FConfig.Height - 20, FConfig.Width - 92, 16);
  Result.TextSettings.Font.Size := FConfig.FontSize - 3;
  Result.TextSettings.FontColor := FConfig.InvalidLabelColor;
  Result.Visible := False;
  Result.HitTest := False;
end;

function TRickUIBuilderEditBuilder.CreatePath(AParent: TFmxObject;
  const AData: string; AColor: TAlphaColor): TPath;
begin
  Result := TPath.Create(AParent);
  Result.Parent := AParent;
  Result.Align := TAlignLayout.Center;
  Result.Width := FConfig.IconSize;
  Result.Height := FConfig.IconSize;
  Result.Data.Data := AData;
  Result.WrapMode := TPathWrapMode.Fit;
  Result.Fill.Color := AColor;
  Result.Stroke.Kind := TBrushKind.None;
  Result.HitTest := False;
end;

function TRickUIBuilderEditBuilder.CreateActionArea(AContainer: TRectangle;
  ALeft: Single): TLayout;
begin
  Result := TLayout.Create(AContainer);
  Result.Parent := AContainer;
  Result.SetBounds(ALeft, 20, 32, 36);
  Result.HitTest := True;
  Result.Cursor := crHandPoint;
  Result.BringToFront;
end;

function TRickUIBuilderEditBuilder.CreateAlert(AContainer: TRectangle): TPath;
begin
  Result := CreatePath(AContainer, FConfig.AlertPath, FConfig.AlertIconColor);
  Result.Align := TAlignLayout.None;
  Result.SetBounds(FConfig.Width - 32 + ((32 - FConfig.IconSize) / 2), 28,
    FConfig.IconSize, FConfig.IconSize);
  Result.Visible := False;
end;

function TRickUIBuilderEditBuilder.CreateRequirement(AContainer: TRectangle;
  ALeft: Single): TPath;
begin
  Result := CreatePath(AContainer, FConfig.RequirementNotMetPath,
    FConfig.RequirementIconColor);
  Result.Align := TAlignLayout.None;
  Result.SetBounds(ALeft + ((32 - FConfig.IconSize) / 2), 28,
    FConfig.IconSize, FConfig.IconSize);
end;

function TRickUIBuilderEditBuilder.CreateActions(
  AContainer: TRectangle): TActionControls;
var
  X: Single;
begin
  X := FConfig.Width - 40;
  Result.ClearArea := CreateActionArea(AContainer, X);
  Result.ClearIcon := CreatePath(Result.ClearArea, FConfig.ClearPath,
    FConfig.ClearIconColor);
  if FConfig.ShowClearButton then
    X := X - 32;
  Result.PasswordArea := CreateActionArea(AContainer, X);
  Result.PasswordIcon := CreatePath(Result.PasswordArea,
    FConfig.VisibilityOffPath, FConfig.PasswordIconColor);
  if FConfig.Password then
    X := X - 32;
  Result.Requirement := CreateRequirement(AContainer, X);
  if FConfig.ShowRequirementIndicator then
    X := X - 32;
  Result.Alert := CreateAlert(AContainer);
  Result.Alert.SetBounds(X + ((32 - FConfig.IconSize) / 2), 28,
    FConfig.IconSize, FConfig.IconSize);
end;

function TRickUIBuilderEditBuilder.CreateBehavior(AParent: TFmxObject;
  AContainer: TRectangle; AEdit: TEdit; ALabel, ACounter, AError: TLabel)
: TRickUIBuilderEditBehavior;
begin
  Result := TRickUIBuilderEditBehavior.Create(AParent);
  Result.Configure(FConfig, AContainer, AEdit, ALabel, ACounter, AError);
end;

function TRickUIBuilderEditBuilder.Build(AParent: TFmxObject)
: IRickUIBuilderEditHandle;
var
  C, EditBackground: TRectangle;
  E: TEdit;
  L, Count, Err: TLabel;
  Actions: TActionControls;
  Behavior: TRickUIBuilderEditBehavior;
begin
  C := CreateContainer(AParent);
  L := CreateLabel(C);
  EditBackground := CreateEditBackground(C);
  EditBackground.SendToBack;
  E := CreateEdit(C);
  Count := CreateCounter(C);
  Err := CreateErrorLabel(C);
  Actions := CreateActions(C);
  Behavior := CreateBehavior(AParent, C, E, L, Count, Err);
  Behavior.ConfigureIcons(Actions.Alert, Actions.ClearArea, Actions.ClearIcon,
    Actions.PasswordArea, Actions.PasswordIcon, Actions.Requirement);
  Behavior.SetText(FConfig.Text);
  Result := TRickUIBuilderEditHandle.New(C, E, Behavior);
end;

end.
