{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Example.Badge.Factory.Runner                          }
{                                                                              }
{ Esta unit executa os sete exemplos Badge - Factory diretamente no            }
{ ResultHost e mantém o exemplo Completo sincronizado com todos os campos      }
{ públicos de TRickUIBuilderBadgeConfig.                                       }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Executar os exemplos reais da abordagem Factory de Badge.                   }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Materializa TRectangle + TLabel por TRickUIBuilderFactory.CreateBadge e     }
{  demonstra também as APIs auxiliares públicas de construção do Badge.        }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - RickUIBuilder.Samples.App.Types                                           }
{      Fornece TBadgeFactoryExample usado para selecionar a execução.          }
{  - Rick.UIBuilder.Factory                                                    }
{      Fornece CreateBadge, CreateBadgeContainer, BuildBadgeTextConfig e       }
{      CreateText usados pelos exemplos.                                       }
{  - Rick.UIBuilder.Types                                                      }
{      Fornece TRickUIBuilderBadgeConfig e TRickUIBuilderTextConfig.           }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - TExampleBadgeFactory limpa ResultHost e solicita Render.                  }
{  - Cada método materializa somente o resultado do exemplo selecionado.       }
{  - Factory.Content fornece o snippet equivalente sem ser dependência direta. }
{                                                                              }
{  Ownership / lifetime                                                        }
{  --------------------                                                        }
{  - ResultHost é usado como Owner e Parent dos controles raiz criados.        }
{  - O TLabel interno usa ResultHost como Owner e o TRectangle como Parent.    }
{  - ClearResult remove os filhos visuais antes da próxima materialização.     }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - Não cria navegação, não define textos da página e não conhece Fluent.     }
{  - Não cria helpers, handlers ou containers intermediários artificiais.      }
{  - O exemplo Completo deve atribuir todos os sete campos públicos do record. }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Os valores executados devem permanecer sincronizados com os snippets        }
{  apresentados por Factory.Content.                                           }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.Example.Badge.Factory.Runner;

interface

uses
  FMX.Layouts,
  RickUIBuilder.Samples.App.Types;

type
  /// <summary>Executa o resultado visual dos exemplos Factory de Badge.</summary>
  TBadgeFactoryRunner = class sealed
  strict private
    class procedure RenderPrimary(const AExample: TBadgeFactoryExample;
      const AHost: TLayout); static;
    class procedure RenderAdvanced(const AExample: TBadgeFactoryExample;
      const AHost: TLayout); static;
    class procedure RenderBasic(const AHost: TLayout); static;
    class procedure RenderGeometry(const AHost: TLayout); static;
    class procedure RenderColors(const AHost: TLayout); static;
    class procedure RenderTypography(const AHost: TLayout); static;
    class procedure RenderTextAccess(const AHost: TLayout); static;
    class procedure RenderStepByStep(const AHost: TLayout); static;
    class procedure RenderComplete(const AHost: TLayout); static;
  public
    class procedure Render(const AExample: TBadgeFactoryExample;
      const AHost: TLayout); static;
  end;

implementation

uses
  System.SysUtils,
  System.UITypes,

  FMX.Objects,
  FMX.StdCtrls,

  Rick.UIBuilder.Factory,
  Rick.UIBuilder.Types;

class procedure TBadgeFactoryRunner.Render(
  const AExample: TBadgeFactoryExample; const AHost: TLayout);
begin
  if AExample <= TBadgeFactoryExample.Typography then
    RenderPrimary(AExample, AHost)
  else
    RenderAdvanced(AExample, AHost);
end;

class procedure TBadgeFactoryRunner.RenderPrimary(
  const AExample: TBadgeFactoryExample; const AHost: TLayout);
begin
  case AExample of
    TBadgeFactoryExample.Basic: RenderBasic(AHost);
    TBadgeFactoryExample.Geometry: RenderGeometry(AHost);
    TBadgeFactoryExample.Colors: RenderColors(AHost);
    TBadgeFactoryExample.Typography: RenderTypography(AHost);
  end;
end;

class procedure TBadgeFactoryRunner.RenderAdvanced(
  const AExample: TBadgeFactoryExample; const AHost: TLayout);
begin
  case AExample of
    TBadgeFactoryExample.TextAccess: RenderTextAccess(AHost);
    TBadgeFactoryExample.StepByStep: RenderStepByStep(AHost);
    TBadgeFactoryExample.Complete: RenderComplete(AHost);
  end;
end;

class procedure TBadgeFactoryRunner.RenderBasic(const AHost: TLayout);
var
  LTextLabel: TLabel;
  LConfig: TRickUIBuilderBadgeConfig;
begin
  LConfig := TRickUIBuilderBadgeConfig.Default;
  TRickUIBuilderFactory.CreateBadge(AHost, AHost, 'Novo', LConfig, LTextLabel);
end;

class procedure TBadgeFactoryRunner.RenderGeometry(const AHost: TLayout);
var
  LTextLabel: TLabel;
  LConfig: TRickUIBuilderBadgeConfig;
begin
  LConfig := TRickUIBuilderBadgeConfig.Default;
  LConfig.Left := 24;
  LConfig.Top := 20;
  LConfig.Width := 160;
  LConfig.Height := 36;
  TRickUIBuilderFactory.CreateBadge(AHost, AHost, 'Geometria', LConfig,
    LTextLabel);
end;

class procedure TBadgeFactoryRunner.RenderColors(const AHost: TLayout);
var
  LTextLabel: TLabel;
  LConfig: TRickUIBuilderBadgeConfig;
begin
  LConfig := TRickUIBuilderBadgeConfig.Default;
  LConfig.BackgroundColor := TAlphaColors.Dodgerblue;
  LConfig.TextColor := TAlphaColors.White;
  TRickUIBuilderFactory.CreateBadge(AHost, AHost, 'Cores', LConfig, LTextLabel);
end;

class procedure TBadgeFactoryRunner.RenderTypography(const AHost: TLayout);
var
  LTextLabel: TLabel;
  LConfig: TRickUIBuilderBadgeConfig;
begin
  LConfig := TRickUIBuilderBadgeConfig.Default;
  LConfig.Width := 160;
  LConfig.Height := 36;
  LConfig.FontSize := 16;
  TRickUIBuilderFactory.CreateBadge(AHost, AHost, 'Tipografia', LConfig,
    LTextLabel);
end;

class procedure TBadgeFactoryRunner.RenderTextAccess(const AHost: TLayout);
var
  LBadge: TRectangle;
  LTextLabel: TLabel;
  LConfig: TRickUIBuilderBadgeConfig;
begin
  LConfig := TRickUIBuilderBadgeConfig.Default;
  LBadge := TRickUIBuilderFactory.CreateBadge(AHost, AHost, 'Original', LConfig,
    LTextLabel);
  LTextLabel.Text := Format('Largura: %.0f', [LBadge.Width]);
end;

class procedure TBadgeFactoryRunner.RenderStepByStep(const AHost: TLayout);
var
  LContainer: TRectangle;
  LBadgeConfig: TRickUIBuilderBadgeConfig;
  LTextConfig: TRickUIBuilderTextConfig;
begin
  LBadgeConfig := TRickUIBuilderBadgeConfig.Default;
  LBadgeConfig.Width := 180;
  LBadgeConfig.Height := 34;
  LBadgeConfig.BackgroundColor := TAlphaColors.Green;
  LBadgeConfig.TextColor := TAlphaColors.White;
  LBadgeConfig.FontSize := 14;
  LContainer := TRickUIBuilderFactory.CreateBadgeContainer(AHost, AHost,
    LBadgeConfig);
  LTextConfig := TRickUIBuilderFactory.BuildBadgeTextConfig(LBadgeConfig);
  TRickUIBuilderFactory.CreateText(AHost, LContainer, 'Em etapas', LTextConfig);
end;

class procedure TBadgeFactoryRunner.RenderComplete(const AHost: TLayout);
var
  LTextLabel: TLabel;
  LConfig: TRickUIBuilderBadgeConfig;
begin
  LConfig := TRickUIBuilderBadgeConfig.Default;
  LConfig.Left := 18;
  LConfig.Top := 20;
  LConfig.Width := 190;
  LConfig.Height := 38;
  LConfig.BackgroundColor := TAlphaColors.Dodgerblue;
  LConfig.TextColor := TAlphaColors.White;
  LConfig.FontSize := 15;
  TRickUIBuilderFactory.CreateBadge(AHost, AHost, 'Configuração completa',
    LConfig, LTextLabel);
end;

end.
