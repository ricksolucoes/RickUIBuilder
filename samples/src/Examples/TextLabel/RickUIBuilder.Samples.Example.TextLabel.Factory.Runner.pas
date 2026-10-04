{ Esta unit executa os exemplos Text / Label - Factory no ResultHost via TRickUIBuilderFactory.CreateText, mantendo o exemplo Completo sincronizado com todos os campos públicos de TRickUIBuilderTextConfig. }
{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Example.TextLabel.Factory.Runner                      }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Executar os exemplos reais da abordagem Factory de Text / Label.            }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Materializa TLabel no ResultHost usando TRickUIBuilderFactory.CreateText e  }
{  TRickUIBuilderTextConfig, cobrindo as opções públicas da configuração.       }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - RickUIBuilder.Samples.App.Types                                           }
{      Fornece TTextLabelFactoryExample usado para selecionar a execução.      }
{  - Rick.UIBuilder.Factory                                                    }
{      Fornece TRickUIBuilderFactory.CreateText usado em todos os exemplos.    }
{  - Rick.UIBuilder.Types                                                      }
{      Fornece TRickUIBuilderTextConfig e seus defaults.                       }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - TExampleTextLabelFactory limpa ResultHost e solicita Render.              }
{  - Cada método cria somente o controle correspondente ao exemplo selecionado.}
{  - Factory.Content fornece o snippet equivalente, mas não é dependência      }
{    direta desta unit.                                                        }
{                                                                              }
{  Ownership / lifetime                                                        }
{  --------------------                                                        }
{  - ResultHost é usado simultaneamente como Owner e Parent do TLabel criado.  }
{  - TExampleResultPanel.Clear libera o resultado antes da próxima execução.   }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - Não cria navegação, não define textos da página e não conhece Fluent.     }
{  - TTextAlign exige FMX.Types explicitamente no uses desta unit.             }
{  - TAlphaColors exige System.UITypes explicitamente no uses desta unit.      }
{  - O exemplo Completo deve atribuir todos os campos públicos do record.      }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Os valores executados devem permanecer sincronizados com os snippets        }
{  apresentados por Factory.Content.                                           }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.Example.TextLabel.Factory.Runner;

interface

uses
  FMX.Layouts,
  RickUIBuilder.Samples.App.Types;

type
  /// <summary>Executa o resultado visual dos exemplos Factory de Text / Label.</summary>
  TTextLabelFactoryRunner = class sealed
  strict private
    class procedure RenderBasic(const AHost: TLayout); static;
    class procedure RenderGeometry(const AHost: TLayout); static;
    class procedure RenderTypography(const AHost: TLayout); static;
    class procedure RenderAlignment(const AHost: TLayout); static;
    class procedure RenderComplete(const AHost: TLayout); static;
  public
    class procedure Render(const AExample: TTextLabelFactoryExample;
      const AHost: TLayout); static;
  end;

implementation

uses
  System.UITypes,
  FMX.Types,
  Rick.UIBuilder.Factory,
  Rick.UIBuilder.Types;

class procedure TTextLabelFactoryRunner.Render(
  const AExample: TTextLabelFactoryExample; const AHost: TLayout);
begin
  case AExample of
    TTextLabelFactoryExample.Basic: RenderBasic(AHost);
    TTextLabelFactoryExample.Geometry: RenderGeometry(AHost);
    TTextLabelFactoryExample.Typography: RenderTypography(AHost);
    TTextLabelFactoryExample.Alignment: RenderAlignment(AHost);
    TTextLabelFactoryExample.Complete: RenderComplete(AHost);
  end;
end;

class procedure TTextLabelFactoryRunner.RenderBasic(const AHost: TLayout);
var
  LConfig: TRickUIBuilderTextConfig;
begin
  LConfig := TRickUIBuilderTextConfig.Default;
  TRickUIBuilderFactory.CreateText(AHost, AHost, 'Texto básico', LConfig);
end;

class procedure TTextLabelFactoryRunner.RenderGeometry(const AHost: TLayout);
var
  LConfig: TRickUIBuilderTextConfig;
begin
  LConfig := TRickUIBuilderTextConfig.Default;
  LConfig.Left := 20;
  LConfig.Top := 16;
  LConfig.Width := 220;
  LConfig.Height := 32;
  TRickUIBuilderFactory.CreateText(AHost, AHost, 'Posição e tamanho', LConfig);
end;

class procedure TTextLabelFactoryRunner.RenderTypography(const AHost: TLayout);
var
  LConfig: TRickUIBuilderTextConfig;
begin
  LConfig := TRickUIBuilderTextConfig.Default;
  LConfig.Left := 12;
  LConfig.Top := 12;
  LConfig.Width := 300;
  LConfig.Height := 40;
  LConfig.FontSize := 18;
  LConfig.FontColor := TAlphaColors.Blue;
  LConfig.Bold := True;
  TRickUIBuilderFactory.CreateText(AHost, AHost, 'Texto em destaque', LConfig);
end;

class procedure TTextLabelFactoryRunner.RenderAlignment(const AHost: TLayout);
var
  LConfig: TRickUIBuilderTextConfig;
begin
  LConfig := TRickUIBuilderTextConfig.Default;
  LConfig.Left := 12;
  LConfig.Top := 16;
  LConfig.Width := 300;
  LConfig.Height := 32;
  LConfig.HorizontalAlign := TTextAlign.Center;
  TRickUIBuilderFactory.CreateText(AHost, AHost, 'Texto centralizado', LConfig);
end;

class procedure TTextLabelFactoryRunner.RenderComplete(const AHost: TLayout);
var
  LConfig: TRickUIBuilderTextConfig;
begin
  LConfig := TRickUIBuilderTextConfig.Default;
  LConfig.Left := 24;
  LConfig.Top := 10;
  LConfig.Width := 320;
  LConfig.Height := 42;
  LConfig.FontSize := 16;
  LConfig.FontColor := TAlphaColors.Green;
  LConfig.HorizontalAlign := TTextAlign.Trailing;
  LConfig.Bold := True;
  TRickUIBuilderFactory.CreateText(AHost, AHost, 'Configuração completa', LConfig);
end;

end.
