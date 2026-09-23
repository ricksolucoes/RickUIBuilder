program RickUIBuilder.Test;

{$IFNDEF TESTINSIGHT}
{$APPTYPE CONSOLE}
{$ENDIF}
{$STRONGLINKTYPES ON}

uses
  System.SysUtils,
  System.IOUtils,
  {$IFDEF TESTINSIGHT}
  TestInsight.DUnitX,
  {$ENDIF }
  DUnitX.Loggers.Console,
  DUnitX.Loggers.Xml.NUnit,
  DUnitX.TestFramework,
  Rick.UIBuilder.Tests.Types in 'src\Rick.UIBuilder.Tests.Types.pas',
  Rick.UIBuilder.Tests.Factory in 'src\Rick.UIBuilder.Tests.Factory.pas',
  Rick.UIBuilder.Tests._Label in 'src\Rick.UIBuilder.Tests._Label.pas',
  Rick.UIBuilder.Tests.Divider in 'src\Rick.UIBuilder.Tests.Divider.pas',
  Rick.UIBuilder.Tests.Badge in 'src\Rick.UIBuilder.Tests.Badge.pas',
  Rick.UIBuilder.Tests.Button in 'src\Rick.UIBuilder.Tests.Button.pas',
  Rick.UIBuilder.Tests.Composition in 'src\Rick.UIBuilder.Tests.Composition.pas',
  Rick.UIBuilder.Tests.Facade in 'src\Rick.UIBuilder.Tests.Facade.pas',
  Rick.UIBuilder.Tests.ComboBox in 'src\Rick.UIBuilder.Tests.ComboBox.pas';

var
  runner      : ITestRunner;
  results     : IRunResults;
  logger      : ITestLogger;
  nunitLogger : ITestLogger;
  xmlOutputPath : string;

begin
{$IFDEF TESTINSIGHT}
  // Se este define estiver ativo, o fluxo abaixo (incluindo o XML) NUNCA roda.
  // Garanta que TESTINSIGHT esteja OFF no build usado para gerar o relatório.
  TestInsight.DUnitX.RunRegisteredTests;
  exit;
{$ENDIF}
  try
    // Verifica/valida argumentos de linha de comando (ex: --xml=..., --format=...)
    TDUnitX.CheckCommandLine;

    // Cria o runner
    runner := TDUnitX.CreateRunner;
    runner.UseRTTI := True;
    runner.FailsOnNoAsserts := False;

    // Logger de console
    logger := TDUnitXConsoleLogger.Create(true);
    runner.AddLogger(logger);

    // --- Define explicitamente o caminho do XML ---
    // Se o usuário não passou --xml=... na linha de comando, força um caminho
    // absoluto e previsível, ao lado do executável.
    xmlOutputPath := TDUnitX.Options.XMLOutputFile;
    if xmlOutputPath.Trim.IsEmpty then
      xmlOutputPath := 'dunitx-results.xml';

    if not TPath.IsPathRooted(xmlOutputPath) then
      xmlOutputPath := TPath.Combine(TPath.GetDirectoryName(ParamStr(0)), xmlOutputPath);

    nunitLogger := TDUnitXXMLNUnitFileLogger.Create(xmlOutputPath);
    runner.AddLogger(nunitLogger);

    // --- Executa os testes ---
    results := runner.Execute;

    Writeln;

    // Confirma se o arquivo foi realmente criado
    if TFile.Exists(xmlOutputPath) then
      Writeln('XML gerado com sucesso: ', xmlOutputPath)
    else
      Writeln('ATENCAO: XML NAO foi encontrado apos a execucao em: ', xmlOutputPath);


    Writeln;

    if not results.AllPassed then
      System.ExitCode := EXIT_ERRORS;

    {$IFNDEF CI}
    if TDUnitX.Options.ExitBehavior = TDUnitXExitBehavior.Pause then
    begin
      System.Write('Done.. press <Enter> key to quit.');
      System.Readln;
    end;
    {$ENDIF}
  except
    on E: Exception do
    begin
      Writeln('ERRO FATAL: ', E.ClassName, ': ', E.Message);
      System.ExitCode := EXIT_ERRORS;
    end;
  end;
end.
