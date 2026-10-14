unit Rick.UIBuilder.Tests.Edit.Interaction;

{$SCOPEDENUMS ON}

interface

uses
  DUnitX.TestFramework,
  FMX.Forms,
  FMX.Objects,
  FMX.StdCtrls,
  FMX.Types,

  Rick.UIBuilder.Edit.Interfaces;

type
  [TestFixture]
  [Category('Integration')]
  TRickUIBuilderEditInteractionTests = class
  private
    FHost: TForm;
    FEdit: IRickUIBuilderEdit;
    procedure BuildEdit;
    procedure ConfigureActionPaths;
    procedure SetInput(const AValue: string);
    function InputValue: string;
    function NormalizePathData(const AData: string): string;
    function FindPathByNormalizedData(AParent: TFmxObject; const ANormalizedData: string): TPath;
    function FindPathByData(AParent: TFmxObject; const AData: string): TPath;
    function FindCounterLabel(AParent: TFmxObject): TLabel;
    procedure ClickPath(APath: TPath);
    procedure AssertPathVisible(APath: TPath; AExpected: Boolean);
  public
    [Setup] procedure Setup;
    [TearDown] procedure TearDown;
    [Test] procedure ClearButton_DesabilitadoPorPadrao_DevePermanecerOculto;
    [Test] procedure ClearButton_Habilitado_DeveAcompanharPresencaDeTexto;
    [Test] procedure ClearButton_ClickDeveLimparTextoESeOcultar;
    [Test] procedure ClearButton_ReadOnlyDevePermanecerOculto;
    [Test] procedure Password_DesabilitadoPorPadrao_DeveOcultarPaths;
    [Test] procedure Password_Habilitado_DeveIniciarMascaradoComVisibilityOff;
    [Test] procedure Password_ClickDeveAlternarEstadoEPaths;
    [Test] procedure Counter_HabilitadoComMaxLength_DeveMostrarZeroDeLimite;
    [Test] procedure Counter_TextoAntesBuildDeveMostrarComprimento;
    [Test] procedure Counter_DeveAcompanharTextoEfetivo;
    [Test] procedure Counter_DesabilitadoDevePermanecerOculto;
    [Test] procedure RequirementIndicator_DesabilitadoPorPadrao_DeveOcultarPaths;
    [Test] procedure RequirementIndicator_NaoAtendidoDeveExibirNotMet;
    [Test] procedure RequirementIndicator_AtendidoDeveExibirMet;
    [Test] procedure RequirementIndicator_AposBuildDeveAcompanharRequirementMet;
  end;

implementation

uses
  System.SysUtils,

  Rick.UIBuilder.Edit.Builder;

const
  _CLEAR_PATH_ = 'M 0 0 L 10 0';
  _VISIBILITY_PATH_ = 'M 0 1 L 10 1';
  _VISIBILITY_OFF_PATH_ = 'M 0 2 L 10 2';
  _REQUIREMENT_MET_PATH_ = 'M 0 3 L 10 3';
  _REQUIREMENT_NOT_MET_PATH_ = 'M 0 4 L 10 4';

procedure TRickUIBuilderEditInteractionTests.Setup;
begin
  FHost := TForm.CreateNew(nil);
  FEdit := TRickUIBuilderEdit.New;
end;

procedure TRickUIBuilderEditInteractionTests.TearDown;
begin
  FEdit := nil;
  FHost.Free;
  FHost := nil;
end;

procedure TRickUIBuilderEditInteractionTests.BuildEdit;
begin
  FEdit.Parent(FHost).Build;
end;

procedure TRickUIBuilderEditInteractionTests.ConfigureActionPaths;
begin
  FEdit.Config.Icons.Paths
    .Clear(_CLEAR_PATH_)
    .Visibility(_VISIBILITY_PATH_)
    .VisibilityOff(_VISIBILITY_OFF_PATH_)
    .RequirementMet(_REQUIREMENT_MET_PATH_)
    .RequirementNotMet(_REQUIREMENT_NOT_MET_PATH_);
end;

procedure TRickUIBuilderEditInteractionTests.SetInput(const AValue: string);
begin
  FEdit.Designer.Input.Text.Value(AValue);
end;

function TRickUIBuilderEditInteractionTests.InputValue: string;
begin
  Result := FEdit.Designer.Input.Text.Value;
end;

function TRickUIBuilderEditInteractionTests.NormalizePathData(const AData: string): string;
var
  LPath: TPath;
begin
  LPath := TPath.Create(nil);
  try
    LPath.Data.Data := AData;
    Result := LPath.Data.Data;
  finally
    LPath.Free;
  end;
end;

function TRickUIBuilderEditInteractionTests.FindPathByNormalizedData(AParent: TFmxObject; const ANormalizedData: string): TPath;
var
  LChild: TFmxObject;
  LIndex: Integer;
begin
  Result := nil;
  if (AParent is TPath) and (TPath(AParent).Data.Data = ANormalizedData) then
    Exit(TPath(AParent));
  for LIndex := 0 to AParent.ChildrenCount - 1 do
  begin
    LChild := AParent.Children[LIndex];
    Result := FindPathByNormalizedData(LChild, ANormalizedData);
    if Assigned(Result) then
      Exit;
  end;
end;

function TRickUIBuilderEditInteractionTests.FindPathByData(AParent: TFmxObject; const AData: string): TPath;
begin
  Result := FindPathByNormalizedData(AParent, NormalizePathData(AData));
end;

function TRickUIBuilderEditInteractionTests.FindCounterLabel(AParent: TFmxObject): TLabel;
var
  LChild: TFmxObject;
  LIndex: Integer;
begin
  Result := nil;
  if (AParent is TLabel) and (TLabel(AParent).TextSettings.HorzAlign = TTextAlign.Trailing) then
    Exit(TLabel(AParent));
  for LIndex := 0 to AParent.ChildrenCount - 1 do
  begin
    LChild := AParent.Children[LIndex];
    Result := FindCounterLabel(LChild);
    if Assigned(Result) then
      Exit;
  end;
end;

procedure TRickUIBuilderEditInteractionTests.AssertPathVisible(APath: TPath; AExpected: Boolean);
begin
  Assert.IsNotNull(APath);
  Assert.IsTrue(APath.Visible = AExpected);
end;

procedure TRickUIBuilderEditInteractionTests.ClickPath(APath: TPath);
begin
  Assert.IsNotNull(APath);
  Assert.IsTrue(APath.Visible);
  Assert.IsTrue(Assigned(APath.OnClick));
  APath.OnClick(APath);
end;

procedure TRickUIBuilderEditInteractionTests.ClearButton_DesabilitadoPorPadrao_DevePermanecerOculto;
var
  LClear: TPath;
begin
  ConfigureActionPaths;
  SetInput('abc');
  BuildEdit;
  LClear := FindPathByData(FEdit.Rectangle.Control, _CLEAR_PATH_);
  Assert.IsNotNull(LClear);
  Assert.IsFalse(LClear.Visible);
end;

procedure TRickUIBuilderEditInteractionTests.ClearButton_Habilitado_DeveAcompanharPresencaDeTexto;
var
  LClear: TPath;
begin
  ConfigureActionPaths;
  FEdit.Designer.Config.ClearButton;
  BuildEdit;
  LClear := FindPathByData(FEdit.Rectangle.Control, _CLEAR_PATH_);
  Assert.IsNotNull(LClear);
  Assert.IsFalse(LClear.Visible);
  SetInput('abc');
  Assert.IsTrue(LClear.Visible);
  FEdit.Designer.Clear;
  Assert.IsFalse(LClear.Visible);
end;

procedure TRickUIBuilderEditInteractionTests.ClearButton_ClickDeveLimparTextoESeOcultar;
var
  LClear: TPath;
begin
  ConfigureActionPaths;
  FEdit.Designer.Config.ClearButton;
  SetInput('abc');
  BuildEdit;
  LClear := FindPathByData(FEdit.Rectangle.Control, _CLEAR_PATH_);
  ClickPath(LClear);
  Assert.AreEqual(EmptyStr, InputValue);
  Assert.IsFalse(LClear.Visible);
end;

procedure TRickUIBuilderEditInteractionTests.ClearButton_ReadOnlyDevePermanecerOculto;
var
  LClear: TPath;
begin
  ConfigureActionPaths;
  FEdit.Designer.Config.ClearButton.ReadOnly;
  SetInput('abc');
  BuildEdit;
  LClear := FindPathByData(FEdit.Rectangle.Control, _CLEAR_PATH_);
  Assert.IsNotNull(LClear);
  Assert.IsFalse(LClear.Visible);
end;

procedure TRickUIBuilderEditInteractionTests.Password_DesabilitadoPorPadrao_DeveOcultarPaths;
var
  LVisibility: TPath;
  LVisibilityOff: TPath;
begin
  ConfigureActionPaths;
  BuildEdit;
  LVisibility := FindPathByData(FEdit.Rectangle.Control, _VISIBILITY_PATH_);
  LVisibilityOff := FindPathByData(FEdit.Rectangle.Control, _VISIBILITY_OFF_PATH_);
  Assert.IsNotNull(LVisibility);
  Assert.IsNotNull(LVisibilityOff);
  Assert.IsFalse(LVisibility.Visible);
  Assert.IsFalse(LVisibilityOff.Visible);
end;

procedure TRickUIBuilderEditInteractionTests.Password_Habilitado_DeveIniciarMascaradoComVisibilityOff;
var
  LVisibility: TPath;
  LVisibilityOff: TPath;
begin
  ConfigureActionPaths;
  FEdit.Designer.Config.Password;
  BuildEdit;
  LVisibility := FindPathByData(FEdit.Rectangle.Control, _VISIBILITY_PATH_);
  LVisibilityOff := FindPathByData(FEdit.Rectangle.Control, _VISIBILITY_OFF_PATH_);
  Assert.IsNotNull(LVisibility);
  Assert.IsNotNull(LVisibilityOff);
  Assert.IsTrue(FEdit.Designer.Control.Password);
  Assert.IsFalse(LVisibility.Visible);
  Assert.IsTrue(LVisibilityOff.Visible);
end;

procedure TRickUIBuilderEditInteractionTests.Password_ClickDeveAlternarEstadoEPaths;
var
  LVisibility: TPath;
  LVisibilityOff: TPath;
begin
  ConfigureActionPaths;
  FEdit.Designer.Config.Password;
  BuildEdit;
  LVisibility := FindPathByData(FEdit.Rectangle.Control, _VISIBILITY_PATH_);
  LVisibilityOff := FindPathByData(FEdit.Rectangle.Control, _VISIBILITY_OFF_PATH_);
  AssertPathVisible(LVisibility, False);
  ClickPath(LVisibilityOff);
  Assert.IsFalse(FEdit.Designer.Control.Password);
  AssertPathVisible(LVisibilityOff, False);
  ClickPath(LVisibility);
  Assert.IsTrue(FEdit.Designer.Control.Password);
  AssertPathVisible(LVisibility, False);
  AssertPathVisible(LVisibilityOff, True);
end;

procedure TRickUIBuilderEditInteractionTests.Counter_HabilitadoComMaxLength_DeveMostrarZeroDeLimite;
var
  LCounter: TLabel;
begin
  FEdit.Labels.Counter.Enabled;
  FEdit.Designer.Input.Config.MaxLength(5);
  BuildEdit;
  LCounter := FindCounterLabel(FEdit.Rectangle.Control);
  Assert.IsNotNull(LCounter);
  Assert.IsTrue(LCounter.Visible);
  Assert.AreEqual('0/5', LCounter.Text);
end;

procedure TRickUIBuilderEditInteractionTests.Counter_TextoAntesBuildDeveMostrarComprimento;
var
  LCounter: TLabel;
begin
  FEdit.Labels.Counter.Enabled;
  FEdit.Designer.Input.Config.MaxLength(5);
  SetInput('abc');
  BuildEdit;
  LCounter := FindCounterLabel(FEdit.Rectangle.Control);
  Assert.IsNotNull(LCounter);
  Assert.AreEqual('3/5', LCounter.Text);
end;

procedure TRickUIBuilderEditInteractionTests.Counter_DeveAcompanharTextoEfetivo;
var
  LCounter: TLabel;
begin
  FEdit.Labels.Counter.Enabled;
  FEdit.Designer.Input.Config.MaxLength(5);
  BuildEdit;
  LCounter := FindCounterLabel(FEdit.Rectangle.Control);
  Assert.IsNotNull(LCounter);
  SetInput('abc');
  Assert.AreEqual('3/5', LCounter.Text);
  FEdit.Designer.Clear;
  Assert.AreEqual('0/5', LCounter.Text);
end;

procedure TRickUIBuilderEditInteractionTests.Counter_DesabilitadoDevePermanecerOculto;
var
  LCounter: TLabel;
begin
  FEdit.Labels.Counter.Enabled(False);
  FEdit.Designer.Input.Config.MaxLength(5);
  BuildEdit;
  LCounter := FindCounterLabel(FEdit.Rectangle.Control);
  Assert.IsNotNull(LCounter);
  Assert.IsFalse(LCounter.Visible);
end;

procedure TRickUIBuilderEditInteractionTests.RequirementIndicator_DesabilitadoPorPadrao_DeveOcultarPaths;
var
  LMet: TPath;
  LNotMet: TPath;
begin
  ConfigureActionPaths;
  BuildEdit;
  LMet := FindPathByData(FEdit.Rectangle.Control, _REQUIREMENT_MET_PATH_);
  LNotMet := FindPathByData(FEdit.Rectangle.Control, _REQUIREMENT_NOT_MET_PATH_);
  Assert.IsNotNull(LMet);
  Assert.IsNotNull(LNotMet);
  Assert.IsFalse(LMet.Visible);
  Assert.IsFalse(LNotMet.Visible);
end;

procedure TRickUIBuilderEditInteractionTests.RequirementIndicator_NaoAtendidoDeveExibirNotMet;
var
  LMet: TPath;
  LNotMet: TPath;
begin
  ConfigureActionPaths;
  FEdit.Designer.Validation.RequirementIndicator.RequirementMet(False);
  BuildEdit;
  LMet := FindPathByData(FEdit.Rectangle.Control, _REQUIREMENT_MET_PATH_);
  LNotMet := FindPathByData(FEdit.Rectangle.Control, _REQUIREMENT_NOT_MET_PATH_);
  Assert.IsNotNull(LMet);
  Assert.IsNotNull(LNotMet);
  Assert.IsFalse(LMet.Visible);
  Assert.IsTrue(LNotMet.Visible);
end;

procedure TRickUIBuilderEditInteractionTests.RequirementIndicator_AtendidoDeveExibirMet;
var
  LMet: TPath;
  LNotMet: TPath;
begin
  ConfigureActionPaths;
  FEdit.Designer.Validation.RequirementIndicator.RequirementMet(True);
  BuildEdit;
  LMet := FindPathByData(FEdit.Rectangle.Control, _REQUIREMENT_MET_PATH_);
  LNotMet := FindPathByData(FEdit.Rectangle.Control, _REQUIREMENT_NOT_MET_PATH_);
  Assert.IsNotNull(LMet);
  Assert.IsNotNull(LNotMet);
  Assert.IsTrue(LMet.Visible);
  Assert.IsFalse(LNotMet.Visible);
end;

procedure TRickUIBuilderEditInteractionTests.RequirementIndicator_AposBuildDeveAcompanharRequirementMet;
var
  LMet: TPath;
  LNotMet: TPath;
begin
  ConfigureActionPaths;
  FEdit.Designer.Validation.RequirementIndicator.RequirementMet(False);
  BuildEdit;
  LMet := FindPathByData(FEdit.Rectangle.Control, _REQUIREMENT_MET_PATH_);
  LNotMet := FindPathByData(FEdit.Rectangle.Control, _REQUIREMENT_NOT_MET_PATH_);
  Assert.IsNotNull(LMet);
  Assert.IsNotNull(LNotMet);
  Assert.IsTrue(LNotMet.Visible);
  FEdit.Designer.Validation.RequirementMet(True);
  Assert.IsTrue(LMet.Visible);
  Assert.IsFalse(LNotMet.Visible);
  FEdit.Designer.Validation.RequirementMet(False);
  Assert.IsFalse(LMet.Visible);
  Assert.IsTrue(LNotMet.Visible);
end;

initialization
  TDUnitX.RegisterTestFixture(TRickUIBuilderEditInteractionTests);

end.
