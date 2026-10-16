unit Rick.UIBuilder.Tests.Edit.CompletionValidation;

{$SCOPEDENUMS ON}

interface

uses
  DUnitX.TestFramework,
  FMX.Forms,
  FMX.StdCtrls,
  FMX.Types,
  System.UITypes,

  Rick.UIBuilder.Edit.Interfaces,
  Rick.UIBuilder.Edit.Types;

type
  [TestFixture]
  [Category('Integration')]
  TRickUIBuilderEditCompletionValidationTests = class
  private
    FHost: TForm;
    FEdit: IRickUIBuilderEdit;
    procedure PrepareValidation;
    procedure BuildEdit;
    procedure ExitEdit;
    procedure ConfigureInput(APreset: TRickUIBuilderEditPreset; const AValue: string);
    function FindLabelByColor(AParent: TFmxObject; AColor: TAlphaColor): TLabel;
    function ErrorLabel: TLabel;
    procedure AssertInvalidFeedback;
    procedure AssertValidFeedback;
    procedure AssertCompletion(APreset: TRickUIBuilderEditPreset; const AValue: string; AExpectedInvalid: Boolean);
  public
    [Setup] procedure Setup;
    [TearDown] procedure TearDown;
    [Test] procedure Optional_URLVaziaDevePermanecerValida;
    [Test] procedure Required_VazioDeveInvalidarAoSair;
    [Test] procedure Required_EspacosDevemInvalidarAoSair;
    [Test] procedure Required_PreenchidoDevePermanecerValido;
    [Test] procedure Required_DesabilitadoAposHabilitarDevePermanecerValido;
    [Test] procedure CPF_IncompletoDeveInvalidarAoSair;
    [Test] procedure CPF_CompletoDevePermanecerValido;
    [Test] procedure CNPJ_IncompletoDeveInvalidarAoSair;
    [Test] procedure CNPJ_CompletoDevePermanecerValido;
    [Test] procedure CEP_IncompletoDeveInvalidarAoSair;
    [Test] procedure CEP_CompletoDevePermanecerValido;
    [Test] procedure Phone_IncompletoDeveInvalidarAoSair;
    [Test] procedure Phone_CompletoDevePermanecerValido;
    [Test] procedure Mobile_IncompletoDeveInvalidarAoSair;
    [Test] procedure Mobile_CompletoDevePermanecerValido;
    [Test] procedure Email_IncompletoDeveInvalidarAoSair;
    [Test] procedure Email_CompletoDevePermanecerValido;
    [Test] procedure URL_IncompletaDeveInvalidarAoSair;
    [Test] procedure URL_CompletaDevePermanecerValida;
    [Test] procedure InvalidAutomatico_CorrecaoDeveLimparFeedback;
    [Test] procedure InvalidExplicito_CorrecaoNaoDeveLimparFeedback;
  end;

implementation

uses
  FMX.Edit,
  System.SysUtils,

  Rick.UIBuilder.Edit.Builder;

const
  _ERROR_COLOR_: TAlphaColor = $FFB51C1C;
  _DEFAULT_MESSAGE_ = 'Valor incompleto';

procedure TRickUIBuilderEditCompletionValidationTests.Setup;
begin
  FHost := TForm.CreateNew(nil);
  FEdit := TRickUIBuilderEdit.New;
end;

procedure TRickUIBuilderEditCompletionValidationTests.TearDown;
begin
  FEdit := nil;
  FHost.Free;
  FHost := nil;
end;

procedure TRickUIBuilderEditCompletionValidationTests.PrepareValidation;
begin
  FEdit.Labels.Error.Text.Color(_ERROR_COLOR_);
  FEdit.Designer.Validation.DefaultMessage(_DEFAULT_MESSAGE_);
end;

procedure TRickUIBuilderEditCompletionValidationTests.BuildEdit;
begin
  FEdit.Parent(FHost).Build;
end;

procedure TRickUIBuilderEditCompletionValidationTests.ExitEdit;
var
  LControl: TEdit;
begin
  LControl := FEdit.Designer.Control;
  Assert.IsTrue(Assigned(LControl.OnExit));
  LControl.OnExit(LControl);
end;

procedure TRickUIBuilderEditCompletionValidationTests.ConfigureInput(APreset: TRickUIBuilderEditPreset; const AValue: string);
begin
  FEdit.Designer.Input.Config.Preset(APreset);
  FEdit.Designer.Input.Text.Value(AValue);
end;

function TRickUIBuilderEditCompletionValidationTests.FindLabelByColor(AParent: TFmxObject; AColor: TAlphaColor): TLabel;
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

function TRickUIBuilderEditCompletionValidationTests.ErrorLabel: TLabel;
begin
  Result := FindLabelByColor(FEdit.Rectangle.Control, _ERROR_COLOR_);
  Assert.IsNotNull(Result);
end;

procedure TRickUIBuilderEditCompletionValidationTests.AssertInvalidFeedback;
begin
  Assert.IsTrue(ErrorLabel.Visible);
  Assert.AreEqual(_DEFAULT_MESSAGE_, ErrorLabel.Text);
end;

procedure TRickUIBuilderEditCompletionValidationTests.AssertValidFeedback;
begin
  Assert.IsFalse(ErrorLabel.Visible);
end;

procedure TRickUIBuilderEditCompletionValidationTests.AssertCompletion(APreset: TRickUIBuilderEditPreset; const AValue: string; AExpectedInvalid: Boolean);
begin
  PrepareValidation;
  ConfigureInput(APreset, AValue);
  BuildEdit;
  ExitEdit;
  if AExpectedInvalid then
    AssertInvalidFeedback
  else
    AssertValidFeedback;
end;

procedure TRickUIBuilderEditCompletionValidationTests.Optional_URLVaziaDevePermanecerValida;
begin
  AssertCompletion(TRickUIBuilderEditPreset.URL, EmptyStr, False);
end;

procedure TRickUIBuilderEditCompletionValidationTests.Required_VazioDeveInvalidarAoSair;
begin
  PrepareValidation;
  FEdit.Designer.Validation.Required;
  BuildEdit;
  ExitEdit;
  AssertInvalidFeedback;
end;

procedure TRickUIBuilderEditCompletionValidationTests.Required_EspacosDevemInvalidarAoSair;
begin
  PrepareValidation;
  FEdit.Designer.Validation.Required;
  FEdit.Designer.Input.Text.Value('   ');
  BuildEdit;
  ExitEdit;
  AssertInvalidFeedback;
end;

procedure TRickUIBuilderEditCompletionValidationTests.Required_PreenchidoDevePermanecerValido;
begin
  PrepareValidation;
  FEdit.Designer.Validation.Required;
  FEdit.Designer.Input.Text.Value('Preenchido');
  BuildEdit;
  ExitEdit;
  AssertValidFeedback;
end;

procedure TRickUIBuilderEditCompletionValidationTests.
  Required_DesabilitadoAposHabilitarDevePermanecerValido;
begin
  PrepareValidation;
  FEdit.Designer.Validation.Required.Required(False);
  BuildEdit;
  ExitEdit;
  AssertValidFeedback;
end;

procedure TRickUIBuilderEditCompletionValidationTests.CPF_IncompletoDeveInvalidarAoSair;
begin
  AssertCompletion(TRickUIBuilderEditPreset.CPF, '123456', True);
end;

procedure TRickUIBuilderEditCompletionValidationTests.CPF_CompletoDevePermanecerValido;
begin
  AssertCompletion(TRickUIBuilderEditPreset.CPF, '12345678901', False);
end;

procedure TRickUIBuilderEditCompletionValidationTests.CNPJ_IncompletoDeveInvalidarAoSair;
begin
  AssertCompletion(TRickUIBuilderEditPreset.CNPJ, '123456780001', True);
end;

procedure TRickUIBuilderEditCompletionValidationTests.CNPJ_CompletoDevePermanecerValido;
begin
  AssertCompletion(TRickUIBuilderEditPreset.CNPJ, '12345678000199', False);
end;

procedure TRickUIBuilderEditCompletionValidationTests.CEP_IncompletoDeveInvalidarAoSair;
begin
  AssertCompletion(TRickUIBuilderEditPreset.CEP, '12345', True);
end;

procedure TRickUIBuilderEditCompletionValidationTests.CEP_CompletoDevePermanecerValido;
begin
  AssertCompletion(TRickUIBuilderEditPreset.CEP, '12345678', False);
end;

procedure TRickUIBuilderEditCompletionValidationTests.Phone_IncompletoDeveInvalidarAoSair;
begin
  AssertCompletion(TRickUIBuilderEditPreset.Phone, '112345', True);
end;

procedure TRickUIBuilderEditCompletionValidationTests.Phone_CompletoDevePermanecerValido;
begin
  AssertCompletion(TRickUIBuilderEditPreset.Phone, '1123456789', False);
end;

procedure TRickUIBuilderEditCompletionValidationTests.Mobile_IncompletoDeveInvalidarAoSair;
begin
  AssertCompletion(TRickUIBuilderEditPreset.Mobile, '11912345', True);
end;

procedure TRickUIBuilderEditCompletionValidationTests.Mobile_CompletoDevePermanecerValido;
begin
  AssertCompletion(TRickUIBuilderEditPreset.Mobile, '11912345678', False);
end;

procedure TRickUIBuilderEditCompletionValidationTests.Email_IncompletoDeveInvalidarAoSair;
begin
  AssertCompletion(TRickUIBuilderEditPreset.Email, 'usuario@', True);
end;

procedure TRickUIBuilderEditCompletionValidationTests.Email_CompletoDevePermanecerValido;
begin
  AssertCompletion(TRickUIBuilderEditPreset.Email, 'usuario@example.com', False);
end;

procedure TRickUIBuilderEditCompletionValidationTests.URL_IncompletaDeveInvalidarAoSair;
begin
  AssertCompletion(TRickUIBuilderEditPreset.URL, 'https://', True);
end;

procedure TRickUIBuilderEditCompletionValidationTests.URL_CompletaDevePermanecerValida;
begin
  AssertCompletion(TRickUIBuilderEditPreset.URL, 'https://example.com', False);
end;

procedure TRickUIBuilderEditCompletionValidationTests.InvalidAutomatico_CorrecaoDeveLimparFeedback;
begin
  PrepareValidation;
  FEdit.Designer.Validation.Required;
  BuildEdit;
  ExitEdit;
  AssertInvalidFeedback;
  FEdit.Designer.Input.Text.Value('Corrigido');
  AssertValidFeedback;
end;

procedure TRickUIBuilderEditCompletionValidationTests.InvalidExplicito_CorrecaoNaoDeveLimparFeedback;
begin
  PrepareValidation;
  FEdit.Designer.Validation.Invalid('Erro explícito');
  BuildEdit;
  FEdit.Designer.Input.Text.Value('Corrigido');
  ExitEdit;
  Assert.IsTrue(ErrorLabel.Visible);
  Assert.AreEqual('Erro explícito', ErrorLabel.Text);
end;

initialization
  TDUnitX.RegisterTestFixture(TRickUIBuilderEditCompletionValidationTests);

end.
