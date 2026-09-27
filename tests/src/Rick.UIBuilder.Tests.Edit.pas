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

initialization
  TDUnitX.RegisterTestFixture(TRickUIBuilderEditInputTests);
  TDUnitX.RegisterTestFixture(TRickUIBuilderEditIntegrationTests);

end.
