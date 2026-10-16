unit Rick.UIBuilder.Tests.Edit.InputRules;

{$SCOPEDENUMS ON}

interface

uses
  DUnitX.TestFramework,
  FMX.Forms,

  Rick.UIBuilder.Edit.Interfaces;

type
  [TestFixture]
  [Category('Integration')]
  TRickUIBuilderEditInputRulesTests = class
  private
    FHost: TForm;
    FEdit: IRickUIBuilderEdit;
    procedure BuildEdit;
    procedure TypeInput(const AValue: string);
    procedure ClearInput;
    function InputValue: string;
    procedure AssertTextExact(const AExpected, AActual: string);
  public
    [Setup] procedure Setup;
    [TearDown] procedure TearDown;
    [Test] procedure CPF_DeveAplicarMascaraProgressivamente;
    [Test] procedure CPF_DeveRejeitarLetraDuranteEntrada;
    [Test] procedure CNPJ_DeveAplicarMascaraComBaseAlfanumerica;
    [Test] procedure CEP_DeveAplicarMascara;
    [Test] procedure Phone_DeveAplicarMascaraComDDD;
    [Test] procedure Mobile_DeveAplicarMascaraComDDD;
    [Test] procedure IntegerNumber_DeveRejeitarNegativoPorPadrao;
    [Test] procedure IntegerNumber_DeveAceitarNegativoQuandoConfigurado;
    [Test] procedure IntegerNumber_DeveRejeitarCaracterNaoNumerico;
    [Test] procedure FloatNumber_DeveRespeitarCasasDecimaisESeparadorCustomizado;
    [Test] procedure FloatNumber_DeveRejeitarSeparadorDeMilharQuandoDesabilitado;
    [Test] procedure FloatNumber_DeveRespeitarSeparadorDeMilharCustomizado;
    [Test] procedure Email_DeveConverterParaLowercase;
    [Test] procedure Email_DeveRejeitarCaracteresForaDoAddrSpec;
    [Test] procedure URL_SchemeAndHost_DevePreservarPathEQuery;
    [Test] procedure URL_EntireValue_DeveConverterTudoParaLowercase;
    [Test] procedure CaseMode_UppercaseDeveConverterTexto;
    [Test] procedure CaseMode_LowercaseDeveConverterTexto;
    [Test] procedure CaseMode_PreserveDeveManterTexto;
    [Test] procedure MaxLength_DeveLimitarTexto;
  end;

implementation

uses
  System.SysUtils,

  Rick.UIBuilder.Edit.Builder,
  Rick.UIBuilder.Edit.Types;

procedure TRickUIBuilderEditInputRulesTests.Setup;
begin
  FHost := TForm.CreateNew(nil);
  FEdit := TRickUIBuilderEdit.New;
end;

procedure TRickUIBuilderEditInputRulesTests.TearDown;
begin
  FEdit := nil;
  FHost.Free;
  FHost := nil;
end;

procedure TRickUIBuilderEditInputRulesTests.BuildEdit;
begin
  FEdit.Parent(FHost).Build;
end;

procedure TRickUIBuilderEditInputRulesTests.TypeInput(const AValue: string);
var
  LChar: Char;
begin
  for LChar in AValue do
    FEdit.Designer.Control.Text := FEdit.Designer.Control.Text + LChar;
end;

procedure TRickUIBuilderEditInputRulesTests.ClearInput;
begin
  FEdit.Designer.Clear;
end;

function TRickUIBuilderEditInputRulesTests.InputValue: string;
begin
  Result := FEdit.Designer.Input.Text.Value;
end;

procedure TRickUIBuilderEditInputRulesTests.AssertTextExact(const AExpected, AActual: string);
begin
  Assert.AreEqual<Integer>(0, CompareStr(AExpected, AActual));
end;

procedure TRickUIBuilderEditInputRulesTests.CPF_DeveAplicarMascaraProgressivamente;
begin
  FEdit.Designer.Input.Config.Preset(TRickUIBuilderEditPreset.CPF);
  BuildEdit;
  TypeInput('1234');
  AssertTextExact('123.4', InputValue);
end;

procedure TRickUIBuilderEditInputRulesTests.CPF_DeveRejeitarLetraDuranteEntrada;
begin
  FEdit.Designer.Input.Config.Preset(TRickUIBuilderEditPreset.CPF);
  BuildEdit;
  TypeInput('1234');
  AssertTextExact('123.4', InputValue);
  TypeInput('A');
  AssertTextExact('123.4', InputValue);
end;

procedure TRickUIBuilderEditInputRulesTests.CNPJ_DeveAplicarMascaraComBaseAlfanumerica;
begin
  FEdit.Designer.Input.Config.Preset(TRickUIBuilderEditPreset.CNPJ);
  BuildEdit;
  TypeInput('00000000E08G12');
  AssertTextExact('00.000.000/E08G-12', InputValue);
end;

procedure TRickUIBuilderEditInputRulesTests.CEP_DeveAplicarMascara;
begin
  FEdit.Designer.Input.Config.Preset(TRickUIBuilderEditPreset.CEP);
  BuildEdit;
  TypeInput('12345678');
  AssertTextExact('12345-678', InputValue);
end;

procedure TRickUIBuilderEditInputRulesTests.Phone_DeveAplicarMascaraComDDD;
begin
  FEdit.Designer.Input.Config.Preset(TRickUIBuilderEditPreset.Phone);
  BuildEdit;
  TypeInput('2123456789');
  AssertTextExact('(21) 2345-6789', InputValue);
end;

procedure TRickUIBuilderEditInputRulesTests.Mobile_DeveAplicarMascaraComDDD;
begin
  FEdit.Designer.Input.Config.Preset(TRickUIBuilderEditPreset.Mobile);
  BuildEdit;
  TypeInput('21912345678');
  AssertTextExact('(21) 9 1234-5678', InputValue);
end;

procedure TRickUIBuilderEditInputRulesTests.IntegerNumber_DeveRejeitarNegativoPorPadrao;
begin
  FEdit.Designer.Input.Config.Preset(TRickUIBuilderEditPreset.IntegerNumber);
  BuildEdit;
  TypeInput('10');
  AssertTextExact('10', InputValue);
  ClearInput;
  TypeInput('-10');
  AssertTextExact('10', InputValue);
end;

procedure TRickUIBuilderEditInputRulesTests.IntegerNumber_DeveAceitarNegativoQuandoConfigurado;
begin
  FEdit.Designer.Input.Config.Preset(TRickUIBuilderEditPreset.IntegerNumber);
  FEdit.Designer.Input.Number.AllowNegative(True);
  BuildEdit;
  TypeInput('-10');
  AssertTextExact('-10', InputValue);
  ClearInput;
  FEdit.Designer.Input.Number.AllowNegative(False);
  TypeInput('-10');
  AssertTextExact('10', InputValue);
end;

procedure TRickUIBuilderEditInputRulesTests.IntegerNumber_DeveRejeitarCaracterNaoNumerico;
begin
  FEdit.Designer.Input.Config.Preset(TRickUIBuilderEditPreset.IntegerNumber);
  BuildEdit;
  TypeInput('12A3');
  AssertTextExact('123', InputValue);
end;

procedure TRickUIBuilderEditInputRulesTests.FloatNumber_DeveRespeitarCasasDecimaisESeparadorCustomizado;
begin
  FEdit.Designer.Input.Config.Preset(TRickUIBuilderEditPreset.FloatNumber);
  FEdit.Designer.Input.Number.FormatMode(TRickUIBuilderEditNumberFormatMode.Custom).DecimalSeparator(',').DecimalPlaces(2);
  BuildEdit;
  TypeInput('10,256');
  AssertTextExact('10,25', InputValue);
end;

procedure TRickUIBuilderEditInputRulesTests.FloatNumber_DeveRejeitarSeparadorDeMilharQuandoDesabilitado;
begin
  FEdit.Designer.Input.Config.Preset(TRickUIBuilderEditPreset.FloatNumber);
  FEdit.Designer.Input.Number.FormatMode(TRickUIBuilderEditNumberFormatMode.Custom).DecimalSeparator(',').ThousandSeparator('.');
  BuildEdit;
  TypeInput('1.234,56');
  AssertTextExact('1234,56', InputValue);
end;

procedure TRickUIBuilderEditInputRulesTests.FloatNumber_DeveRespeitarSeparadorDeMilharCustomizado;
begin
  FEdit.Designer.Input.Config.Preset(TRickUIBuilderEditPreset.FloatNumber);
  FEdit.Designer.Input.Number.FormatMode(TRickUIBuilderEditNumberFormatMode.Custom).DecimalSeparator(',').ThousandSeparator('.').UseThousandSeparator(True);
  BuildEdit;
  TypeInput('1.234,56');
  AssertTextExact('1.234,56', InputValue);
  ClearInput;
  FEdit.Designer.Input.Number.UseThousandSeparator(False);
  TypeInput('1.234,56');
  AssertTextExact('1234,56', InputValue);
end;

procedure TRickUIBuilderEditInputRulesTests.Email_DeveConverterParaLowercase;
begin
  FEdit.Designer.Input.Config.Preset(TRickUIBuilderEditPreset.Email);
  BuildEdit;
  TypeInput('Nome@Exemplo.COM');
  AssertTextExact('nome@exemplo.com', InputValue);
end;

procedure TRickUIBuilderEditInputRulesTests.Email_DeveRejeitarCaracteresForaDoAddrSpec;
begin
  FEdit.Designer.Input.Config.Preset(TRickUIBuilderEditPreset.Email);
  BuildEdit;
  TypeInput('nome');
  TypeInput('&');
  AssertTextExact('nome', InputValue);
  TypeInput('sobrenome@example.com');
  AssertTextExact('nomesobrenome@example.com', InputValue);
end;

procedure TRickUIBuilderEditInputRulesTests.URL_SchemeAndHost_DevePreservarPathEQuery;
begin
  FEdit.Designer.Input.Config.Preset(TRickUIBuilderEditPreset.URL).UrlCaseMode(TRickUIBuilderEditUrlCaseMode.SchemeAndHost);
  BuildEdit;
  TypeInput('HTTPS://Example.COM/Path?Token=ABC');
  AssertTextExact('https://example.com/Path?Token=ABC', InputValue);
end;

procedure TRickUIBuilderEditInputRulesTests.URL_EntireValue_DeveConverterTudoParaLowercase;
begin
  FEdit.Designer.Input.Config.Preset(TRickUIBuilderEditPreset.URL).UrlCaseMode(TRickUIBuilderEditUrlCaseMode.EntireValue);
  BuildEdit;
  TypeInput('HTTPS://Example.COM/Path?Token=ABC');
  AssertTextExact('https://example.com/path?token=abc', InputValue);
end;

procedure TRickUIBuilderEditInputRulesTests.CaseMode_UppercaseDeveConverterTexto;
begin
  FEdit.Designer.Input.Config.Preset(TRickUIBuilderEditPreset.AllCharacters).CaseMode(TRickUIBuilderEditCaseMode.Uppercase);
  BuildEdit;
  TypeInput('Texto Misto');
  AssertTextExact('TEXTO MISTO', InputValue);
end;

procedure TRickUIBuilderEditInputRulesTests.CaseMode_LowercaseDeveConverterTexto;
begin
  FEdit.Designer.Input.Config.Preset(TRickUIBuilderEditPreset.AllCharacters).CaseMode(TRickUIBuilderEditCaseMode.Lowercase);
  BuildEdit;
  TypeInput('Texto Misto');
  AssertTextExact('texto misto', InputValue);
end;

procedure TRickUIBuilderEditInputRulesTests.CaseMode_PreserveDeveManterTexto;
begin
  FEdit.Designer.Input.Config.Preset(TRickUIBuilderEditPreset.AllCharacters).CaseMode(TRickUIBuilderEditCaseMode.Preserve);
  BuildEdit;
  TypeInput('Texto Misto');
  AssertTextExact('Texto Misto', InputValue);
end;

procedure TRickUIBuilderEditInputRulesTests.MaxLength_DeveLimitarTexto;
begin
  FEdit.Designer.Input.Config.MaxLength(5);
  BuildEdit;
  TypeInput('abcdef');
  AssertTextExact('abcde', InputValue);
end;

initialization
  TDUnitX.RegisterTestFixture(TRickUIBuilderEditInputRulesTests);

end.
