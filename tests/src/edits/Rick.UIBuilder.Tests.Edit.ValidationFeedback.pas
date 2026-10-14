unit Rick.UIBuilder.Tests.Edit.ValidationFeedback;

{$SCOPEDENUMS ON}

interface

uses
  DUnitX.TestFramework,
  FMX.Forms,
  FMX.Objects,
  FMX.StdCtrls,
  FMX.Types,
  System.UITypes,

  Rick.UIBuilder.Edit.Interfaces;

type
  [TestFixture]
  [Category('Integration')]
  TRickUIBuilderEditValidationFeedbackTests = class
  private
    FHost: TForm;
    FEdit: IRickUIBuilderEdit;
    procedure BuildEdit;
    procedure ConfigureFeedbackControls;
    function NormalizePathData(const AData: string): string;
    function FindPathByNormalizedData(AParent: TFmxObject; const ANormalizedData: string): TPath;
    function FindPathByData(AParent: TFmxObject; const AData: string): TPath;
    function FindLabelByColor(AParent: TFmxObject; AColor: TAlphaColor): TLabel;
    function AlertPath: TPath;
    function ErrorLabel: TLabel;
    procedure AssertFeedback(AErrorVisible, AAlertVisible: Boolean);
  public
    [Setup] procedure Setup;
    [TearDown] procedure TearDown;
    [Test] procedure FeedbackPadrao_ValidoDeveManterMensagemEAlertOcultos;
    [Test] procedure InvalidMensagem_PadraoDeveExibirMensagemEAlert;
    [Test] procedure FeedbackAlertOnly_DeveExibirSomenteMensagem;
    [Test] procedure FeedbackIconOnly_DeveExibirSomenteAlert;
    [Test] procedure InvalidFalse_AposInvalidDeveOcultarMensagemEAlert;
    [Test] procedure InvalidAposBuild_DeveAtualizarMensagemEAlert;
    [Test] procedure DefaultMessage_DeveSerFallbackParaInvalidSemMensagem;
    [Test] procedure MensagemExplicita_DevePrevalecerSobreDefaultMessage;
    [Test] procedure InvalidSemMensagemESemDefault_DeveExibirSomenteAlert;
    [Test] procedure ErrorText_EstiloConfiguradoDeveSerPreservado;
    [Test] procedure Alert_EstiloConfiguradoDeveSerPreservado;
    [Test] procedure FeedbackAposBuild_DeveAtualizarInvalidAtivo;
    [Test] procedure InvalidAntesDosControles_DeveAplicarFeedbackAoVincular;
  end;

implementation

uses
  System.SysUtils,

  Rick.UIBuilder.Edit.Builder,
  Rick.UIBuilder.Edit.Types;

const
  _ALERT_PATH_ = 'M 1 0 L 11 0';
  _ERROR_COLOR_: TAlphaColor = $FFAA1100;
  _ALERT_COLOR_: TAlphaColor = $FF0011AA;

procedure TRickUIBuilderEditValidationFeedbackTests.Setup;
begin
  FHost := TForm.CreateNew(nil);
  FEdit := TRickUIBuilderEdit.New;
end;

procedure TRickUIBuilderEditValidationFeedbackTests.TearDown;
begin
  FEdit := nil;
  FHost.Free;
  FHost := nil;
end;

procedure TRickUIBuilderEditValidationFeedbackTests.BuildEdit;
begin
  FEdit.Parent(FHost).Build;
end;

procedure TRickUIBuilderEditValidationFeedbackTests.ConfigureFeedbackControls;
begin
  FEdit.Labels.Error.Text.Color(_ERROR_COLOR_).Spacing(7).Font.Size(13);
  FEdit.Config.Icons.Size(24).Colors.Alert(_ALERT_COLOR_).ToBack.Paths.Alert(_ALERT_PATH_);
end;

function TRickUIBuilderEditValidationFeedbackTests.NormalizePathData(const AData: string): string;
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

function TRickUIBuilderEditValidationFeedbackTests.FindPathByNormalizedData(AParent: TFmxObject; const ANormalizedData: string): TPath;
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

function TRickUIBuilderEditValidationFeedbackTests.FindPathByData(AParent: TFmxObject; const AData: string): TPath;
begin
  Result := FindPathByNormalizedData(AParent, NormalizePathData(AData));
end;

function TRickUIBuilderEditValidationFeedbackTests.FindLabelByColor(AParent: TFmxObject; AColor: TAlphaColor): TLabel;
var
  LChild: TFmxObject;
  LIndex: Integer;
begin
  Result := nil;
  if (AParent is TLabel) and (TLabel(AParent).TextSettings.FontColor = AColor) then
    Exit(TLabel(AParent));
  for LIndex := 0 to AParent.ChildrenCount - 1 do
  begin
    LChild := AParent.Children[LIndex];
    Result := FindLabelByColor(LChild, AColor);
    if Assigned(Result) then
      Exit;
  end;
end;

function TRickUIBuilderEditValidationFeedbackTests.AlertPath: TPath;
begin
  Result := FindPathByData(FEdit.Rectangle.Control, _ALERT_PATH_);
  Assert.IsNotNull(Result);
end;

function TRickUIBuilderEditValidationFeedbackTests.ErrorLabel: TLabel;
begin
  Result := FindLabelByColor(FEdit.Rectangle.Control, _ERROR_COLOR_);
  Assert.IsNotNull(Result);
end;

procedure TRickUIBuilderEditValidationFeedbackTests.AssertFeedback(AErrorVisible, AAlertVisible: Boolean);
begin
  Assert.IsTrue(ErrorLabel.Visible = AErrorVisible);
  Assert.IsTrue(AlertPath.Visible = AAlertVisible);
end;

procedure TRickUIBuilderEditValidationFeedbackTests.FeedbackPadrao_ValidoDeveManterMensagemEAlertOcultos;
begin
  ConfigureFeedbackControls;
  BuildEdit;
  AssertFeedback(False, False);
end;

procedure TRickUIBuilderEditValidationFeedbackTests.InvalidMensagem_PadraoDeveExibirMensagemEAlert;
begin
  ConfigureFeedbackControls;
  FEdit.Designer.Validation.Invalid('Erro informado');
  BuildEdit;
  AssertFeedback(True, True);
  Assert.AreEqual('Erro informado', ErrorLabel.Text);
end;

procedure TRickUIBuilderEditValidationFeedbackTests.FeedbackAlertOnly_DeveExibirSomenteMensagem;
begin
  ConfigureFeedbackControls;
  FEdit.Designer.Validation.Feedback(TRickUIBuilderEditInvalidFeedback.AlertOnly).Invalid('Erro');
  BuildEdit;
  AssertFeedback(True, False);
end;

procedure TRickUIBuilderEditValidationFeedbackTests.FeedbackIconOnly_DeveExibirSomenteAlert;
begin
  ConfigureFeedbackControls;
  FEdit.Designer.Validation.Feedback(TRickUIBuilderEditInvalidFeedback.IconOnly).Invalid('Erro');
  BuildEdit;
  AssertFeedback(False, True);
end;

procedure TRickUIBuilderEditValidationFeedbackTests.InvalidFalse_AposInvalidDeveOcultarMensagemEAlert;
begin
  ConfigureFeedbackControls;
  FEdit.Designer.Validation.Invalid('Erro');
  BuildEdit;
  AssertFeedback(True, True);
  FEdit.Designer.Validation.Invalid(False);
  AssertFeedback(False, False);
end;

procedure TRickUIBuilderEditValidationFeedbackTests.InvalidAposBuild_DeveAtualizarMensagemEAlert;
begin
  ConfigureFeedbackControls;
  BuildEdit;
  FEdit.Designer.Validation.Invalid('Erro runtime');
  AssertFeedback(True, True);
  Assert.AreEqual('Erro runtime', ErrorLabel.Text);
end;

procedure TRickUIBuilderEditValidationFeedbackTests.DefaultMessage_DeveSerFallbackParaInvalidSemMensagem;
begin
  ConfigureFeedbackControls;
  FEdit.Designer.Validation.DefaultMessage('Mensagem padrão').Invalid(True);
  BuildEdit;
  AssertFeedback(True, True);
  Assert.AreEqual('Mensagem padrão', ErrorLabel.Text);
end;

procedure TRickUIBuilderEditValidationFeedbackTests.MensagemExplicita_DevePrevalecerSobreDefaultMessage;
begin
  ConfigureFeedbackControls;
  FEdit.Designer.Validation.DefaultMessage('Mensagem padrão').Invalid('Mensagem específica');
  BuildEdit;
  AssertFeedback(True, True);
  Assert.AreEqual('Mensagem específica', ErrorLabel.Text);
end;

procedure TRickUIBuilderEditValidationFeedbackTests.InvalidSemMensagemESemDefault_DeveExibirSomenteAlert;
begin
  ConfigureFeedbackControls;
  FEdit.Designer.Validation.Invalid(True);
  BuildEdit;
  AssertFeedback(False, True);
end;

procedure TRickUIBuilderEditValidationFeedbackTests.ErrorText_EstiloConfiguradoDeveSerPreservado;
var
  LError: TLabel;
begin
  ConfigureFeedbackControls;
  FEdit.Designer.Validation.Invalid('Erro');
  BuildEdit;
  LError := ErrorLabel;
  Assert.IsTrue(LError.Visible);
  Assert.AreEqual<TAlphaColor>(_ERROR_COLOR_, LError.TextSettings.FontColor);
  Assert.AreEqual<Single>(55, LError.Position.Y);
  Assert.AreEqual<Single>(13, LError.TextSettings.Font.Size);
end;

procedure TRickUIBuilderEditValidationFeedbackTests.Alert_EstiloConfiguradoDeveSerPreservado;
var
  LAlert: TPath;
begin
  ConfigureFeedbackControls;
  FEdit.Designer.Validation.Feedback(TRickUIBuilderEditInvalidFeedback.IconOnly).Invalid(True);
  BuildEdit;
  LAlert := AlertPath;
  Assert.IsTrue(LAlert.Visible);
  Assert.AreEqual<TAlphaColor>(_ALERT_COLOR_, LAlert.Fill.Color);
  Assert.AreEqual<Single>(24, LAlert.Width);
  Assert.AreEqual<Single>(24, LAlert.Height);
end;

procedure TRickUIBuilderEditValidationFeedbackTests.FeedbackAposBuild_DeveAtualizarInvalidAtivo;
begin
  ConfigureFeedbackControls;
  FEdit.Designer.Validation.Invalid('Erro');
  BuildEdit;
  FEdit.Designer.Validation.Feedback(TRickUIBuilderEditInvalidFeedback.IconOnly);
  AssertFeedback(False, True);
  FEdit.Designer.Validation.Feedback(TRickUIBuilderEditInvalidFeedback.AlertOnly);
  AssertFeedback(True, False);
end;

procedure TRickUIBuilderEditValidationFeedbackTests.InvalidAntesDosControles_DeveAplicarFeedbackAoVincular;
begin
  FEdit.Designer.Validation.Invalid('Erro antecipado');
  ConfigureFeedbackControls;
  BuildEdit;
  AssertFeedback(True, True);
  Assert.AreEqual('Erro antecipado', ErrorLabel.Text);
end;

initialization
  TDUnitX.RegisterTestFixture(TRickUIBuilderEditValidationFeedbackTests);

end.
