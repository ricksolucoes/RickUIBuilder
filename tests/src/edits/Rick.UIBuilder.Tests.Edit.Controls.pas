unit Rick.UIBuilder.Tests.Edit.Controls;

{$SCOPEDENUMS ON}

interface

uses
  DUnitX.TestFramework,

  Rick.UIBuilder.Edit.Interfaces;

type
  [TestFixture]
  [Category('Integration')]
  TRickUIBuilderEditControlsTests = class
  private
    FEdit: IRickUIBuilderEdit;
  public
    [Setup] procedure Setup;
    [TearDown] procedure TearDown;
    [Test] procedure Rectangle_SettersDiretosDevemAtualizarControl;
    [Test] procedure Designer_SettersDiretosDevemAtualizarEdit;
    [Test] procedure LabelMain_SettersDiretosDevemAtualizarLabel;
    [Test] procedure LabelError_SettersDiretosDevemAtualizarLabel;
    [Test] procedure Counter_EnabledDeveAlterarVisibilidade;
    [Test] procedure Line_SettersDiretosDevemAtualizarControle;
    [Test] procedure Icons_SettersDiretosDevemAtualizarPath;
  end;

implementation

uses
  System.SysUtils,
  System.UITypes,

  FMX.Objects,
  FMX.StdCtrls,
  FMX.Types,

  Rick.UIBuilder.Edit.Builder;

function FindLabelByText(AParent: TFmxObject; const AText: string): TLabel;
var
  LChild: TFmxObject;
  LIndex: Integer;
begin
  Result := nil;
  for LIndex := 0 to AParent.ChildrenCount - 1 do
  begin
    LChild := AParent.Children[LIndex];
    if (LChild is TLabel) and (TLabel(LChild).Text = AText) then
      Exit(TLabel(LChild));
  end;
end;

function FindFirstLabel(AParent: TFmxObject): TLabel;
var
  LIndex: Integer;
begin
  Result := nil;
  for LIndex := 0 to AParent.ChildrenCount - 1 do
    if AParent.Children[LIndex] is TLabel then
      Exit(TLabel(AParent.Children[LIndex]));
end;

function FindFirstRectangle(AParent: TFmxObject): TRectangle;
var
  LIndex: Integer;
begin
  Result := nil;
  for LIndex := 0 to AParent.ChildrenCount - 1 do
    if AParent.Children[LIndex] is TRectangle then
      Exit(TRectangle(AParent.Children[LIndex]));
end;

function FindPathByColor(AParent: TFmxObject; AColor: TAlphaColor): TPath;
var
  LIndex: Integer;
  LPath: TPath;
begin
  Result := nil;
  for LIndex := 0 to AParent.ChildrenCount - 1 do
    if AParent.Children[LIndex] is TPath then
    begin
      LPath := TPath(AParent.Children[LIndex]);
      if LPath.Fill.Color = AColor then
        Exit(LPath);
    end;
end;

procedure TRickUIBuilderEditControlsTests.Setup;
begin
  FEdit := TRickUIBuilderEdit.New;
end;

procedure TRickUIBuilderEditControlsTests.TearDown;
begin
  FEdit := nil;
end;

procedure TRickUIBuilderEditControlsTests.Rectangle_SettersDiretosDevemAtualizarControl;
var
  LControl: TRectangle;
  LRectangle: IRickUIBuilderEditRetangle;
begin
  LRectangle := FEdit.Rectangle;
  LRectangle.Position.Left(11).Top(13);
  LRectangle.Size.Width(301).Height(79);
  LRectangle.CornerRadius(9).Background.Normal(TAlphaColors.Blue).ToBack.Border.Thickness(2).Normal(TAlphaColors.Red);
  LControl := LRectangle.Control;
  Assert.AreEqual<Single>(11, LControl.Position.X);
  Assert.AreEqual<Single>(13, LControl.Position.Y);
  Assert.AreEqual<Single>(301, LControl.Width);
  Assert.AreEqual<Single>(79, LControl.Height);
  Assert.AreEqual<Single>(9, LControl.XRadius);
  Assert.AreEqual<TAlphaColor>(TAlphaColors.Blue, LControl.Fill.Color);
  Assert.AreEqual<Single>(2, LControl.Stroke.Thickness);
  Assert.AreEqual<TAlphaColor>(TAlphaColors.Red, LControl.Stroke.Color);
end;

procedure TRickUIBuilderEditControlsTests.Designer_SettersDiretosDevemAtualizarEdit;
var
  LDesigner: IRickUIBuilderEditDesigner;
  LText: IRickUIBuilderEditDesignerInputText;
begin
  LDesigner := FEdit.Edit;
  LText := LDesigner.Input.Text;
  LText.Value('Texto').Color.Text(TAlphaColors.Blue);
  Assert.AreEqual<TAlphaColor>(TAlphaColors.Blue, LDesigner.Control.TextSettings.FontColor);
  LText.Size(18).Config.Password.ReadOnly;
  LDesigner.Input.Config.MaxLength(12);
  Assert.AreEqual('Texto', LText.Value);
  Assert.AreEqual<Single>(18, LDesigner.Control.TextSettings.Font.Size);
  Assert.IsTrue(LDesigner.Control.Password);
  Assert.IsTrue(LDesigner.Control.ReadOnly);
  Assert.AreEqual<Integer>(12, LDesigner.Control.MaxLength);
  LDesigner.Clear;
  Assert.AreEqual(EmptyStr, LDesigner.Control.Text);
end;

procedure TRickUIBuilderEditControlsTests.LabelMain_SettersDiretosDevemAtualizarLabel;
var
  LLabel: TLabel;
begin
  FEdit.Labels.Main.Text.Value('Título').Size(15).Color.Text(TAlphaColors.Blue);
  LLabel := FindLabelByText(FEdit.Rectangle.Control, 'Título');
  Assert.IsNotNull(LLabel);
  Assert.AreEqual<Single>(15, LLabel.TextSettings.Font.Size);
  Assert.AreEqual<TAlphaColor>(TAlphaColors.Blue, LLabel.TextSettings.FontColor);
end;

procedure TRickUIBuilderEditControlsTests.LabelError_SettersDiretosDevemAtualizarLabel;
var
  LLabel: TLabel;
begin
  FEdit.Labels.Error.Text.Value('Erro').Color(TAlphaColors.Red).Spacing(7).Font.Size(13);
  LLabel := FindLabelByText(FEdit.Rectangle.Control, 'Erro');
  Assert.IsNotNull(LLabel);
  Assert.AreEqual<TAlphaColor>(TAlphaColors.Red, LLabel.TextSettings.FontColor);
  Assert.AreEqual<Single>(55, LLabel.Position.Y);
  Assert.AreEqual<Single>(13, LLabel.TextSettings.Font.Size);
end;

procedure TRickUIBuilderEditControlsTests.Counter_EnabledDeveAlterarVisibilidade;
var
  LLabel: TLabel;
begin
  FEdit.Labels.Counter.Enabled;
  LLabel := FindFirstLabel(FEdit.Rectangle.Control);
  Assert.IsNotNull(LLabel);
  Assert.IsTrue(LLabel.Visible);
end;

procedure TRickUIBuilderEditControlsTests.Line_SettersDiretosDevemAtualizarControle;
var
  LLine: TRectangle;
begin
  FEdit.Line.Thickness(3).Color.Normal(TAlphaColors.Blue);
  LLine := FindFirstRectangle(FEdit.Rectangle.Control);
  Assert.IsNotNull(LLine);
  Assert.AreEqual<Single>(3, LLine.Height);
  Assert.AreEqual<TAlphaColor>(TAlphaColors.Blue, LLine.Fill.Color);
end;

procedure TRickUIBuilderEditControlsTests.Icons_SettersDiretosDevemAtualizarPath;
const
  _ALERT_COLOR_: TAlphaColor = $FF123456;
var
  LPath: TPath;
begin
  FEdit.Config.Icons.Size(26).Colors.Alert(_ALERT_COLOR_).ToBack.Paths.Alert('M 0 0 L 10 0');
  LPath := FindPathByColor(FEdit.Rectangle.Control, _ALERT_COLOR_);
  Assert.IsNotNull(LPath);
  Assert.AreEqual<Single>(26, LPath.Width);
  Assert.AreEqual<Single>(26, LPath.Height);
  Assert.IsFalse(LPath.Data.Data.Trim.IsEmpty);
end;

initialization
  TDUnitX.RegisterTestFixture(TRickUIBuilderEditControlsTests);

end.
