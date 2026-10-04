{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Example.Divider.Fluent.Runner                         }
{                                                                              }
{ Esta unit executa os nove exemplos Divider - Fluent Builder diretamente no   }
{ ResultHost, preservando o encadeamento público de IRickUIBuilderDivider e    }
{ cobrindo os oito métodos configuráveis nos dois exemplos completos.          }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Executar os exemplos reais da abordagem Fluent Builder de Divider.          }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Materializa Divider por TRickUIBuilder.Divider, demonstra uso direto e por  }
{  IRickUIBuilderDivider, orientação horizontal/vertical e configurações       }
{  completas da interface principal.                                          }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - RickUIBuilder.Samples.App.Types                                           }
{      Fornece TDividerFluentExample usado para selecionar a execução.         }
{  - Rick.UIBuilder                                                            }
{      Fornece TRickUIBuilder.Divider, entrada pública do Fluent Builder.      }
{  - Rick.UIBuilder.Interfaces                                                 }
{      Fornece IRickUIBuilderDivider.                                          }
{  - Rick.UIBuilder.Types                                                      }
{      Fornece TRickUIBuilderSpacing usado por Margin.                         }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - TExampleDividerFluent limpa ResultHost e solicita Render.                 }
{  - Cada método executa somente o exemplo selecionado.                        }
{  - O código executado permanece equivalente ao snippet de Fluent.Content.    }
{                                                                              }
{  Ownership / lifetime                                                        }
{  --------------------                                                        }
{  - Build recebe diretamente ResultHost como Parent e Owner do TRectangle.    }
{  - O Runner não mantém estado nem referências após materializar o resultado. }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - Não cria container intermediário entre ResultHost e o Divider.            }
{  - Não usa TRickUIBuilderDividerBuilder ou outra implementação concreta.     }
{  - Não cria navegação e não mantém conteúdo textual da Sample Page.          }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Os valores e a organização Fluent devem permanecer sincronizados com os     }
{  snippets apresentados por Divider.Fluent.Content.                           }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.Example.Divider.Fluent.Runner;

interface

uses
  FMX.Layouts,
  RickUIBuilder.Samples.App.Types;

type
  /// <summary>Executa os resultados visuais dos exemplos Fluent de Divider.</summary>
  TDividerFluentRunner = class sealed
  strict private
    class procedure RenderFoundation(const AExample: TDividerFluentExample;
      const AHost: TLayout); static;
    class procedure RenderPresentation(const AExample: TDividerFluentExample;
      const AHost: TLayout); static;
    class procedure RenderAdvanced(const AExample: TDividerFluentExample;
      const AHost: TLayout); static;
    class procedure RenderBasic(const AHost: TLayout); static;
    class procedure RenderInterface(const AHost: TLayout); static;
    class procedure RenderGeometry(const AHost: TLayout); static;
    class procedure RenderOrientation(const AHost: TLayout); static;
    class procedure RenderLayout(const AHost: TLayout); static;
    class procedure RenderAppearance(const AHost: TLayout); static;
    class procedure RenderState(const AHost: TLayout); static;
    class procedure RenderCompleteDirect(const AHost: TLayout); static;
    class procedure RenderCompleteInterfaces(const AHost: TLayout); static;
  public
    class procedure Render(const AExample: TDividerFluentExample;
      const AHost: TLayout); static;
  end;

implementation

uses
  System.UITypes,

  FMX.Types,
  FMX.Controls,

  Rick.UIBuilder,
  Rick.UIBuilder.Interfaces,
  Rick.UIBuilder.Types;

class procedure TDividerFluentRunner.Render(
  const AExample: TDividerFluentExample; const AHost: TLayout);
begin
  if AExample <= TDividerFluentExample.Orientation then
    RenderFoundation(AExample, AHost)
  else if AExample <= TDividerFluentExample.State then
    RenderPresentation(AExample, AHost)
  else
    RenderAdvanced(AExample, AHost);
end;

class procedure TDividerFluentRunner.RenderFoundation(
  const AExample: TDividerFluentExample; const AHost: TLayout);
begin
  case AExample of
    TDividerFluentExample.Basic: RenderBasic(AHost);
    TDividerFluentExample.InterfaceUsage: RenderInterface(AHost);
    TDividerFluentExample.Geometry: RenderGeometry(AHost);
    TDividerFluentExample.Orientation: RenderOrientation(AHost);
  end;
end;

class procedure TDividerFluentRunner.RenderPresentation(
  const AExample: TDividerFluentExample; const AHost: TLayout);
begin
  case AExample of
    TDividerFluentExample.Layout: RenderLayout(AHost);
    TDividerFluentExample.Appearance: RenderAppearance(AHost);
    TDividerFluentExample.State: RenderState(AHost);
  end;
end;

class procedure TDividerFluentRunner.RenderAdvanced(
  const AExample: TDividerFluentExample; const AHost: TLayout);
begin
  case AExample of
    TDividerFluentExample.CompleteDirect: RenderCompleteDirect(AHost);
    TDividerFluentExample.CompleteInterfaces: RenderCompleteInterfaces(AHost);
  end;
end;

class procedure TDividerFluentRunner.RenderBasic(const AHost: TLayout);
begin
  TRickUIBuilder
    .Divider
      .Build(AHost);
end;

class procedure TDividerFluentRunner.RenderInterface(const AHost: TLayout);
var
  LDivider: IRickUIBuilderDivider;
begin
  LDivider := TRickUIBuilder.Divider;

  LDivider
    .Width(240)
      .Build(AHost);
end;

class procedure TDividerFluentRunner.RenderGeometry(const AHost: TLayout);
begin
  TRickUIBuilder
    .Divider
      .Position(20, 24)
        .Width(280)
        .Thickness(2)
          .Build(AHost);
end;

class procedure TDividerFluentRunner.RenderOrientation(const AHost: TLayout);
begin
  TRickUIBuilder
    .Divider
      .Position(20, 20)
        .Width(240)
        .Thickness(2)
          .Orientation(TOrientation.Horizontal)
            .Build(AHost);

  TRickUIBuilder
    .Divider
      .Position(300, 20)
        .Width(160)
        .Thickness(2)
          .Orientation(TOrientation.Vertical)
            .Build(AHost);
end;

class procedure TDividerFluentRunner.RenderLayout(const AHost: TLayout);
begin
  TRickUIBuilder
    .Divider
      .Position(20, 20)
        .Width(260)
          .Margin(TRickUIBuilderSpacing.Create(12, 8, 4, 2))
            .Build(AHost);
end;

class procedure TDividerFluentRunner.RenderAppearance(const AHost: TLayout);
begin
  TRickUIBuilder
    .Divider
      .Width(280)
        .Thickness(2)
          .Color(TAlphaColors.Dodgerblue)
            .Build(AHost);
end;

class procedure TDividerFluentRunner.RenderState(const AHost: TLayout);
begin
  TRickUIBuilder
    .Divider
      .Width(280)
        .Color(TAlphaColors.Gray)
          .Opacity(0.65)
          .Visible(True)
            .Build(AHost);
end;

class procedure TDividerFluentRunner.RenderCompleteDirect(const AHost: TLayout);
begin
  TRickUIBuilder
    .Divider
      .Position(20, 24)
        .Width(280)
        .Thickness(3)
        .Orientation(TOrientation.Horizontal)
          .Margin(TRickUIBuilderSpacing.Create(12, 8, 4, 2))
            .Color(TAlphaColors.Dodgerblue)
              .Opacity(0.90)
              .Visible(True)
                .Build(AHost);
end;

class procedure TDividerFluentRunner.RenderCompleteInterfaces(
  const AHost: TLayout);
var
  LDivider: IRickUIBuilderDivider;
begin
  LDivider := TRickUIBuilder.Divider;

  LDivider
    .Position(20, 24)
      .Width(280)
      .Thickness(3)
      .Orientation(TOrientation.Horizontal)
        .Margin(TRickUIBuilderSpacing.Create(12, 8, 4, 2))
          .Color(TAlphaColors.Dodgerblue)
            .Opacity(0.90)
            .Visible(True)
              .Build(AHost);
end;

end.
