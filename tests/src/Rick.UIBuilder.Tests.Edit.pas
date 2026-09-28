unit Rick.UIBuilder.Tests.Edit;
{$SCOPEDENUMS ON}

interface

uses
  DUnitX.TestFramework,
  FMX.Forms,
  Rick.UIBuilder.Types,
  Rick.UIBuilder.Interfaces;

type
  [TestFixture]
  TRickUIBuilderEditInputTests = class
  public
    [Test] procedure CPF_DeveAplicarMascaraDuranteFormatacao;
    [Test] procedure CPF_DeveAplicarMascaraProgressivamente;
    [Test] procedure CPF_DeveRejeitarLetrasDuranteDigitacao;
    [Test] procedure CPF_DeveLimitarOnzeDigitos;
    [Test] procedure CPF_PasteSemMascara_DeveSerRejeitado;
    [Test] procedure CPF_PasteComMascara_DeveSerAceito;
    [Test] procedure CNPJ_DeveAceitarBaseAlfanumerica;
    [Test] procedure CNPJ_DoisUltimosCaracteresDevemSerNumericos;
    [Test] procedure CEP_DeveAplicarMascara;
    [Test] procedure Telefone_DeveAdicionarDDDQuandoNecessario;
    [Test] procedure Celular_DeveAdicionarDDDQuandoNecessario;
    [Test] procedure Inteiro_NegativoDeveRespeitarConfiguracao;
    [Test] procedure Float_DeveRespeitarCasasDecimais;
    [Test] procedure Email_DeveConverterParaLowercase;
    [Test] procedure Email_DeveRejeitarCaracteresForaDoAddrSpec;
    [Test] procedure Email_DeveAceitarAtextConvencionadoNoLocalPart;
    [Test] procedure Email_DominioDeveRejeitarUnderscore;
    [Test] procedure Email_DeveRejeitarSegundoArroba;
    [Test] procedure Email_IncompletoDeveSerInvalido;
    [Test] procedure Email_CompletoDeveSerValido;
    [Test] procedure Email_DotAtomInvalidoDeveSerRejeitado;
    [Test] procedure Email_QuotedLocalPartDeveSerRejeitado;
    [Test] procedure Email_EAIDeveAceitarUTF8;
    [Test] procedure URL_SchemeEHostDevemSerLowercase;
    [Test] procedure URL_EntireValueDeveSerLowercase;
    [Test] procedure TextoComPontuacao_DeveAceitarSimbolosAprovados;
    [Test] procedure TextoSemAcentos_DeveRejeitarAcentos;
  end;

  [TestFixture]
  [Category('Integration')]
  TRickUIBuilderEditIntegrationTests = class
  private
    FHostForm: TForm;
  public
    [Setup] procedure Setup;
    [TearDown] procedure TearDown;
    [Test] procedure Facade_DeveCriarEditSingleLine;
    [Test] procedure Handle_DeveAlterarTextoELimpar;
    [Test] procedure Edit_DeveFiltrarDuranteChangeTracking;
    [Test] procedure Edit_ReadOnlyDeveBloquearEdicao;
    [Test] procedure Edit_DefaultDevePreservarAparenciaAtual;
    [Test] procedure Edit_MensagemDeveForcarAlturaMinima;
    [Test] procedure Edit_SemIconeVisivelDeveUsarTodaLarguraUtil;
    [Test] procedure Edit_AoSairDeveReposicionarVisualizacaoNoInicio;
  end;

implementation

uses
  Rick.UIBuilder,
  Rick.UIBuilder.Edit.Input;

function Config(APreset: TRickUIBuilderEditPreset): TRickUIBuilderEditConfig;
begin
  Result := TRickUIBuilderEditConfig.Default;
  Result.Preset := APreset;
end;

procedure TRickUIBuilderEditInputTests.CPF_DeveAplicarMascaraDuranteFormatacao;
var LConfig: TRickUIBuilderEditConfig;
begin
  LConfig := Config(TRickUIBuilderEditPreset.CPF);
  Assert.AreEqual('123.456.789-01',
    TRickUIBuilderEditInput.FormatTypedValue('12345678901', LConfig));
end;

procedure TRickUIBuilderEditInputTests.CPF_DeveAplicarMascaraProgressivamente;
var LConfig: TRickUIBuilderEditConfig;
begin
  LConfig := Config(TRickUIBuilderEditPreset.CPF);
  Assert.AreEqual('123.4',
    TRickUIBuilderEditInput.FormatTypedValue('1234', LConfig));
end;

procedure TRickUIBuilderEditInputTests.CPF_DeveRejeitarLetrasDuranteDigitacao;
var LConfig: TRickUIBuilderEditConfig;
begin
  LConfig := Config(TRickUIBuilderEditPreset.CPF);
  Assert.IsFalse(TRickUIBuilderEditInput.IsTypedValueAllowed('12A', LConfig));
end;

procedure TRickUIBuilderEditInputTests.CPF_DeveLimitarOnzeDigitos;
var LConfig: TRickUIBuilderEditConfig;
begin
  LConfig := Config(TRickUIBuilderEditPreset.CPF);
  Assert.AreEqual('123.456.789-01',
    TRickUIBuilderEditInput.FormatTypedValue('1234567890123', LConfig));
end;

procedure TRickUIBuilderEditInputTests.CPF_PasteSemMascara_DeveSerRejeitado;
var LConfig: TRickUIBuilderEditConfig;
begin
  LConfig := Config(TRickUIBuilderEditPreset.CPF);
  Assert.IsFalse(TRickUIBuilderEditInput.IsPasteAllowed('12345678901', LConfig));
end;

procedure TRickUIBuilderEditInputTests.CPF_PasteComMascara_DeveSerAceito;
var LConfig: TRickUIBuilderEditConfig;
begin
  LConfig := Config(TRickUIBuilderEditPreset.CPF);
  Assert.IsTrue(TRickUIBuilderEditInput.IsPasteAllowed('123.456.789-01', LConfig));
end;

procedure TRickUIBuilderEditInputTests.CNPJ_DeveAceitarBaseAlfanumerica;
var LConfig: TRickUIBuilderEditConfig;
begin
  LConfig := Config(TRickUIBuilderEditPreset.CNPJ);
  Assert.AreEqual('00.000.000/E08G-12',
    TRickUIBuilderEditInput.FormatTypedValue('00000000E08G12', LConfig));
end;

procedure TRickUIBuilderEditInputTests.CNPJ_DoisUltimosCaracteresDevemSerNumericos;
var LConfig: TRickUIBuilderEditConfig;
begin
  LConfig := Config(TRickUIBuilderEditPreset.CNPJ);
  Assert.IsFalse(TRickUIBuilderEditInput.IsPasteAllowed('00.000.000/E08G-AB', LConfig));
end;

procedure TRickUIBuilderEditInputTests.CEP_DeveAplicarMascara;
var LConfig: TRickUIBuilderEditConfig;
begin
  LConfig := Config(TRickUIBuilderEditPreset.CEP);
  Assert.AreEqual('12345-678', TRickUIBuilderEditInput.FormatTypedValue('12345678', LConfig));
end;

procedure TRickUIBuilderEditInputTests.Telefone_DeveAdicionarDDDQuandoNecessario;
var LConfig: TRickUIBuilderEditConfig;
begin
  LConfig := Config(TRickUIBuilderEditPreset.Phone);
  Assert.AreEqual('(21) 2345-6789', TRickUIBuilderEditInput.FormatTypedValue('2123456789', LConfig));
end;

procedure TRickUIBuilderEditInputTests.Celular_DeveAdicionarDDDQuandoNecessario;
var LConfig: TRickUIBuilderEditConfig;
begin
  LConfig := Config(TRickUIBuilderEditPreset.Mobile);
  Assert.AreEqual('(21) 9 1234-5678', TRickUIBuilderEditInput.FormatTypedValue('21912345678', LConfig));
end;

procedure TRickUIBuilderEditInputTests.Inteiro_NegativoDeveRespeitarConfiguracao;
var LConfig: TRickUIBuilderEditConfig;
begin
  LConfig := Config(TRickUIBuilderEditPreset.IntegerNumber);
  Assert.IsFalse(TRickUIBuilderEditInput.IsValueAllowed('-10', LConfig));
  LConfig.AllowNegative := True;
  Assert.IsTrue(TRickUIBuilderEditInput.IsValueAllowed('-10', LConfig));
end;

procedure TRickUIBuilderEditInputTests.Float_DeveRespeitarCasasDecimais;
var LConfig: TRickUIBuilderEditConfig;
begin
  LConfig := Config(TRickUIBuilderEditPreset.FloatNumber);
  LConfig.NumberFormatMode := TRickUIBuilderEditNumberFormatMode.Custom;
  LConfig.DecimalSeparator := ',';
  LConfig.DecimalPlaces := 2;
  Assert.IsTrue(TRickUIBuilderEditInput.IsValueAllowed('10,25', LConfig));
  Assert.IsFalse(TRickUIBuilderEditInput.IsValueAllowed('10,256', LConfig));
end;

procedure TRickUIBuilderEditInputTests.Email_DeveConverterParaLowercase;
var LConfig: TRickUIBuilderEditConfig;
begin
  LConfig := Config(TRickUIBuilderEditPreset.Email);
  Assert.AreEqual('nome@exemplo.com',
    TRickUIBuilderEditInput.FormatTypedValue('Nome@Exemplo.COM', LConfig));
end;

procedure TRickUIBuilderEditInputTests.Email_DeveRejeitarCaracteresForaDoAddrSpec;
var LConfig: TRickUIBuilderEditConfig;
begin
  LConfig := Config(TRickUIBuilderEditPreset.Email);
  Assert.IsFalse(TRickUIBuilderEditInput.IsTypedValueAllowed(
    '***))))((((%cccc', LConfig));
  Assert.IsFalse(TRickUIBuilderEditInput.IsTypedValueAllowed(
    '*&&&&&&&$%#*!!!!!{{', LConfig));
  Assert.IsFalse(TRickUIBuilderEditInput.IsTypedValueAllowed(
    'nome&sobrenome@example.com', LConfig));
  Assert.IsFalse(TRickUIBuilderEditInput.IsTypedValueAllowed(
    'nome%tag@example.com', LConfig));
end;

procedure TRickUIBuilderEditInputTests.Email_DeveAceitarAtextConvencionadoNoLocalPart;
var LConfig: TRickUIBuilderEditConfig;
begin
  LConfig := Config(TRickUIBuilderEditPreset.Email);
  Assert.IsTrue(TRickUIBuilderEditInput.IsTypedValueAllowed(
    'nome.sobrenome+tag@example.com', LConfig));
  Assert.IsTrue(TRickUIBuilderEditInput.IsTypedValueAllowed(
    'nome_sobrenome@example.com', LConfig));
  Assert.IsTrue(TRickUIBuilderEditInput.IsTypedValueAllowed(
    'nome-sobrenome@example.com', LConfig));
end;

procedure TRickUIBuilderEditInputTests.Email_DominioDeveRejeitarUnderscore;
var LConfig: TRickUIBuilderEditConfig;
begin
  LConfig := Config(TRickUIBuilderEditPreset.Email);
  Assert.IsFalse(TRickUIBuilderEditInput.IsTypedValueAllowed(
    'nome@dominio_invalido.com', LConfig));
end;

procedure TRickUIBuilderEditInputTests.Email_DeveRejeitarSegundoArroba;
var LConfig: TRickUIBuilderEditConfig;
begin
  LConfig := Config(TRickUIBuilderEditPreset.Email);
  Assert.IsFalse(TRickUIBuilderEditInput.IsTypedValueAllowed(
    'nome@@example.com', LConfig));
end;

procedure TRickUIBuilderEditInputTests.Email_IncompletoDeveSerInvalido;
var LConfig: TRickUIBuilderEditConfig;
begin
  LConfig := Config(TRickUIBuilderEditPreset.Email);
  Assert.IsFalse(TRickUIBuilderEditInput.IsCompleteValue('erwrwerw', LConfig));
  Assert.IsFalse(TRickUIBuilderEditInput.IsCompleteValue('nome@', LConfig));
end;

procedure TRickUIBuilderEditInputTests.Email_CompletoDeveSerValido;
var LConfig: TRickUIBuilderEditConfig;
begin
  LConfig := Config(TRickUIBuilderEditPreset.Email);
  Assert.IsTrue(TRickUIBuilderEditInput.IsCompleteValue(
    'nome.sobrenome+tag@example.com', LConfig));
end;

procedure TRickUIBuilderEditInputTests.Email_DotAtomInvalidoDeveSerRejeitado;
var LConfig: TRickUIBuilderEditConfig;
begin
  LConfig := Config(TRickUIBuilderEditPreset.Email);
  Assert.IsFalse(TRickUIBuilderEditInput.IsCompleteValue(
    '.nome@example.com', LConfig));
  Assert.IsFalse(TRickUIBuilderEditInput.IsCompleteValue(
    'nome..sobrenome@example.com', LConfig));
end;

procedure TRickUIBuilderEditInputTests.Email_QuotedLocalPartDeveSerRejeitado;
var LConfig: TRickUIBuilderEditConfig;
begin
  LConfig := Config(TRickUIBuilderEditPreset.Email);
  Assert.IsFalse(TRickUIBuilderEditInput.IsCompleteValue(
    '"Fred Bloggs"@example.com', LConfig));
end;

procedure TRickUIBuilderEditInputTests.Email_EAIDeveAceitarUTF8;
var LConfig: TRickUIBuilderEditConfig;
begin
  LConfig := Config(TRickUIBuilderEditPreset.Email);
  Assert.IsTrue(TRickUIBuilderEditInput.IsCompleteValue(
    'usuário@exemplo.com', LConfig));
end;

procedure TRickUIBuilderEditInputTests.URL_SchemeEHostDevemSerLowercase;
var LConfig: TRickUIBuilderEditConfig;
begin
  LConfig := Config(TRickUIBuilderEditPreset.URL);
  Assert.AreEqual('https://example.com/Path?Token=ABC',
    TRickUIBuilderEditInput.FormatTypedValue('HTTPS://Example.COM/Path?Token=ABC', LConfig));
end;

procedure TRickUIBuilderEditInputTests.URL_EntireValueDeveSerLowercase;
var LConfig: TRickUIBuilderEditConfig;
begin
  LConfig := Config(TRickUIBuilderEditPreset.URL);
  LConfig.UrlCaseMode := TRickUIBuilderEditUrlCaseMode.EntireValue;
  Assert.AreEqual('https://example.com/path?token=abc',
    TRickUIBuilderEditInput.FormatTypedValue('HTTPS://Example.COM/Path?Token=ABC', LConfig));
end;

procedure TRickUIBuilderEditInputTests.TextoComPontuacao_DeveAceitarSimbolosAprovados;
var LConfig: TRickUIBuilderEditConfig;
begin
  LConfig := Config(TRickUIBuilderEditPreset.TextPunctuationWithAccents);
  Assert.IsTrue(TRickUIBuilderEditInput.IsValueAllowed('Olá — teste: % #ok', LConfig));
end;

procedure TRickUIBuilderEditInputTests.TextoSemAcentos_DeveRejeitarAcentos;
var LConfig: TRickUIBuilderEditConfig;
begin
  LConfig := Config(TRickUIBuilderEditPreset.TextNoAccents);
  Assert.IsFalse(TRickUIBuilderEditInput.IsValueAllowed('João', LConfig));
end;

procedure TRickUIBuilderEditIntegrationTests.Setup;
begin
  FHostForm := TForm.CreateNew(nil);
end;

procedure TRickUIBuilderEditIntegrationTests.TearDown;
begin
  FHostForm.Free;
end;

procedure TRickUIBuilderEditIntegrationTests.Facade_DeveCriarEditSingleLine;
var LHandle: IRickUIBuilderEditHandle;
begin
  LHandle := TRickUIBuilder.Edit.LabelText('Nome').Build(FHostForm);
  Assert.IsNotNull(LHandle);
  Assert.IsNotNull(LHandle.EditControl);
end;

procedure TRickUIBuilderEditIntegrationTests.Handle_DeveAlterarTextoELimpar;
var LHandle: IRickUIBuilderEditHandle;
begin
  LHandle := TRickUIBuilder.Edit.Build(FHostForm);
  LHandle.Text('abc');
  Assert.AreEqual('abc', LHandle.Text);
  LHandle.Clear;
  Assert.AreEqual('', LHandle.Text);
end;

procedure TRickUIBuilderEditIntegrationTests.Edit_DeveFiltrarDuranteChangeTracking;
var LHandle: IRickUIBuilderEditHandle;
begin
  LHandle := TRickUIBuilder.Edit
    .Preset(TRickUIBuilderEditPreset.CPF)
    .Build(FHostForm);
  Assert.IsTrue(Assigned(LHandle.EditControl.OnChangeTracking));
  LHandle.EditControl.Text := '1234';
  Assert.AreEqual('123.4', LHandle.Text);
  LHandle.EditControl.Text := LHandle.Text + 'A';
  Assert.AreEqual('123.4', LHandle.Text);
end;

procedure TRickUIBuilderEditIntegrationTests.Edit_ReadOnlyDeveBloquearEdicao;
var
  LHandle: IRickUIBuilderEditHandle;
begin
  LHandle := TRickUIBuilder.Edit.Text('Somente leitura').ReadOnly.Build(FHostForm);
  Assert.IsTrue(LHandle.EditControl.ReadOnly);
  Assert.AreEqual('Somente leitura', LHandle.Text);
end;

procedure TRickUIBuilderEditIntegrationTests.Edit_DefaultDevePreservarAparenciaAtual;
var
  LConfig: TRickUIBuilderEditConfig;
begin
  LConfig := TRickUIBuilderEditConfig.Default;
  Assert.AreEqual(Integer(TRickUIBuilderEditAppearance.Outlined),
    Integer(LConfig.Appearance));
  Assert.IsFalse(LConfig.ReadOnly);
  Assert.AreEqual<Single>(12.0, LConfig.LabelFontSize);
  Assert.AreEqual<Single>(11.0, LConfig.ErrorFontSize);
end;


procedure TRickUIBuilderEditIntegrationTests.Edit_MensagemDeveForcarAlturaMinima;
var
  LHandle: IRickUIBuilderEditHandle;
begin
  LHandle := TRickUIBuilder.Edit
    .LabelText('Título').InvalidMessage('Mensagem').Size(300, 20)
    .Build(FHostForm);
  Assert.IsTrue(LHandle.Container.Height > 20);
end;

procedure TRickUIBuilderEditIntegrationTests.Edit_SemIconeVisivelDeveUsarTodaLarguraUtil;
var
  LHandle: IRickUIBuilderEditHandle;
begin
  LHandle := TRickUIBuilder.Edit.ClearButton.Size(300, 56).Build(FHostForm);
  Assert.AreEqual<Single>(284, LHandle.EditControl.Width);
  LHandle.Text('conteúdo');
  Assert.AreEqual<Single>(252, LHandle.EditControl.Width);
  LHandle.Clear;
  Assert.AreEqual<Single>(284, LHandle.EditControl.Width);
end;

procedure TRickUIBuilderEditIntegrationTests.Edit_AoSairDeveReposicionarVisualizacaoNoInicio;
var
  LHandle: IRickUIBuilderEditHandle;
begin
  LHandle := TRickUIBuilder.Edit
    .Text('https://chatgpt.com/g/g-p-6ab4204f8ae48191bc9bf0b66dbefdd4')
    .Build(FHostForm);
  LHandle.EditControl.CaretPosition := Length(LHandle.Text);
  Assert.IsTrue(Assigned(LHandle.EditControl.OnExit));
  LHandle.EditControl.OnExit(LHandle.EditControl);
  Assert.AreEqual(0, LHandle.EditControl.CaretPosition);
end;

initialization
  TDUnitX.RegisterTestFixture(TRickUIBuilderEditInputTests);
  TDUnitX.RegisterTestFixture(TRickUIBuilderEditIntegrationTests);

end.
