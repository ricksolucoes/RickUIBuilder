{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Example.Divider.Factory.Runner                        }
{                                                                              }
{ Esta unit executa os quatro exemplos Divider - Factory diretamente no        }
{ ResultHost e mantém o exemplo Completo sincronizado com todos os campos      }
{ públicos de TRickUIBuilderDividerConfig.                                     }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Executar os exemplos reais da abordagem Factory de Divider.                 }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Materializa TRectangle por TRickUIBuilderFactory.CreateDivider usando       }
{  somente as opções públicas de TRickUIBuilderDividerConfig.                  }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - RickUIBuilder.Samples.App.Types                                           }
{      Fornece TDividerFactoryExample usado para selecionar a execução.        }
{  - Rick.UIBuilder.Factory                                                    }
{      Fornece TRickUIBuilderFactory.CreateDivider.                            }
{  - Rick.UIBuilder.Types                                                      }
{      Fornece TRickUIBuilderDividerConfig.                                    }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - TExampleDividerFactory limpa ResultHost e solicita Render.                }
{  - Cada método materializa somente o resultado do exemplo selecionado.       }
{  - Factory.Content fornece o snippet equivalente sem ser dependência direta. }
{                                                                              }
{  Ownership / lifetime                                                        }
{  --------------------                                                        }
{  - ResultHost é usado como Owner e Parent do TRectangle criado.              }
{  - ClearResult remove o filho visual antes da próxima materialização.        }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - Não cria navegação, não define textos da página e não conhece Fluent.     }
{  - Não cria helpers, handlers ou containers intermediários artificiais.      }
{  - O exemplo Completo deve atribuir todos os quatro campos públicos do       }
{    record.                                                                   }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Os valores executados devem permanecer sincronizados com os snippets        }
{  apresentados por Factory.Content.                                           }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.Example.Divider.Factory.Runner;

interface

uses
  FMX.Layouts,
  RickUIBuilder.Samples.App.Types;

type
  /// <summary>Executa o resultado visual dos exemplos Factory de Divider.</summary>
  TDividerFactoryRunner = class sealed
  strict private
    class procedure RenderBasic(const AHost: TLayout); static;
    class procedure RenderGeometry(const AHost: TLayout); static;
    class procedure RenderColor(const AHost: TLayout); static;
    class procedure RenderComplete(const AHost: TLayout); static;
  public
    class procedure Render(const AExample: TDividerFactoryExample;
      const AHost: TLayout); static;
  end;

implementation

uses
  System.UITypes,

  Rick.UIBuilder.Factory,
  Rick.UIBuilder.Types;

class procedure TDividerFactoryRunner.Render(
  const AExample: TDividerFactoryExample; const AHost: TLayout);
begin
  case AExample of
    TDividerFactoryExample.Basic: RenderBasic(AHost);
    TDividerFactoryExample.Geometry: RenderGeometry(AHost);
    TDividerFactoryExample.Color: RenderColor(AHost);
    TDividerFactoryExample.Complete: RenderComplete(AHost);
  end;
end;

class procedure TDividerFactoryRunner.RenderBasic(const AHost: TLayout);
var
  LConfig: TRickUIBuilderDividerConfig;
begin
  LConfig := TRickUIBuilderDividerConfig.Default;
  TRickUIBuilderFactory.CreateDivider(AHost, AHost, LConfig);
end;

class procedure TDividerFactoryRunner.RenderGeometry(const AHost: TLayout);
var
  LConfig: TRickUIBuilderDividerConfig;
begin
  LConfig := TRickUIBuilderDividerConfig.Default;
  LConfig.Left := 24;
  LConfig.Top := 32;
  LConfig.Width := 280;
  TRickUIBuilderFactory.CreateDivider(AHost, AHost, LConfig);
end;

class procedure TDividerFactoryRunner.RenderColor(const AHost: TLayout);
var
  LConfig: TRickUIBuilderDividerConfig;
begin
  LConfig := TRickUIBuilderDividerConfig.Default;
  LConfig.Color := TAlphaColors.Dodgerblue;
  TRickUIBuilderFactory.CreateDivider(AHost, AHost, LConfig);
end;

class procedure TDividerFactoryRunner.RenderComplete(const AHost: TLayout);
var
  LConfig: TRickUIBuilderDividerConfig;
begin
  LConfig := TRickUIBuilderDividerConfig.Default;
  LConfig.Left := 20;
  LConfig.Top := 28;
  LConfig.Width := 320;
  LConfig.Color := TAlphaColors.Dodgerblue;
  TRickUIBuilderFactory.CreateDivider(AHost, AHost, LConfig);
end;

end.
