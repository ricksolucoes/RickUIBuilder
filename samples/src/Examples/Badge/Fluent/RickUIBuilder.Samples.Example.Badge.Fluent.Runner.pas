{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Example.Badge.Fluent.Runner                           }
{                                                                              }
{ Esta unit executa os onze exemplos Badge - Fluent Builder diretamente no     }
{ ResultHost, preservando o encadeamento de IRickUIBuilderBadge e o acesso     }
{ secundário ao resultado por IRickUIBuilderBadgeHandle.                       }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Executar os exemplos reais da abordagem Fluent Builder de Badge.            }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Materializa Badge por TRickUIBuilder.Badge, demonstra uso direto e por      }
{  IRickUIBuilderBadge e cobre o handle retornado por Build. Os dois exemplos  }
{  completos exercitam os quinze métodos configuráveis da interface            }
{  principal.                                                                  }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - RickUIBuilder.Samples.App.Types                                           }
{      Fornece TBadgeFluentExample usado para selecionar a execução.           }
{  - Rick.UIBuilder                                                            }
{      Fornece TRickUIBuilder.Badge, entrada pública do Fluent Builder.        }
{  - Rick.UIBuilder.Interfaces                                                 }
{      Fornece IRickUIBuilderBadge e IRickUIBuilderBadgeHandle.                }
{  - Rick.UIBuilder.Types                                                      }
{      Fornece TRickUIBuilderSpacing usado por Margin e Padding.               }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - TExampleBadgeFluent limpa ResultHost e solicita Render.                   }
{  - Cada método executa somente o exemplo selecionado.                        }
{  - O código executado permanece equivalente ao snippet de Fluent.Content.    }
{                                                                              }
{  Ownership / lifetime                                                        }
{  --------------------                                                        }
{  - Build recebe diretamente ResultHost como Parent e Owner dos controles.    }
{  - IRickUIBuilderBadgeHandle é non-owning e só é usado enquanto o resultado  }
{    materializado permanece vivo no ResultHost.                               }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - Não cria container intermediário entre ResultHost e o Badge.              }
{  - Não usa TRickUIBuilderBadgeBuilder nem implementações concretas de handle.}
{  - Não cria navegação e não mantém conteúdo textual da Sample Page.          }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Os valores e a organização Fluent devem permanecer sincronizados com os     }
{  snippets apresentados por Badge.Fluent.Content.                             }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.Example.Badge.Fluent.Runner;

interface

uses
  FMX.Layouts,
  RickUIBuilder.Samples.App.Types;

type
  /// <summary>Executa os resultados visuais dos exemplos Fluent de Badge.</summary>
  TBadgeFluentRunner = class sealed
  strict private
    class procedure RenderFoundation(const AExample: TBadgeFluentExample;
      const AHost: TLayout); static;
    class procedure RenderPresentation(const AExample: TBadgeFluentExample;
      const AHost: TLayout); static;
    class procedure RenderAdvanced(const AExample: TBadgeFluentExample;
      const AHost: TLayout); static;
    class procedure RenderBasic(const AHost: TLayout); static;
    class procedure RenderInterface(const AHost: TLayout); static;
    class procedure RenderGeometry(const AHost: TLayout); static;
    class procedure RenderShape(const AHost: TLayout); static;
    class procedure RenderLayout(const AHost: TLayout); static;
    class procedure RenderAppearance(const AHost: TLayout); static;
    class procedure RenderTypography(const AHost: TLayout); static;
    class procedure RenderState(const AHost: TLayout); static;
    class procedure RenderResult(const AHost: TLayout); static;
    class procedure RenderCompleteDirect(const AHost: TLayout); static;
    class procedure RenderCompleteInterfaces(const AHost: TLayout); static;
  public
    class procedure Render(const AExample: TBadgeFluentExample;
      const AHost: TLayout); static;
  end;

implementation

uses
  System.UITypes,

  Rick.UIBuilder,
  Rick.UIBuilder.Interfaces,
  Rick.UIBuilder.Types;

class procedure TBadgeFluentRunner.Render(const AExample: TBadgeFluentExample;
  const AHost: TLayout);
begin
  if AExample <= TBadgeFluentExample.Shape then
    RenderFoundation(AExample, AHost)
  else if AExample <= TBadgeFluentExample.State then
    RenderPresentation(AExample, AHost)
  else
    RenderAdvanced(AExample, AHost);
end;

class procedure TBadgeFluentRunner.RenderFoundation(
  const AExample: TBadgeFluentExample; const AHost: TLayout);
begin
  case AExample of
    TBadgeFluentExample.Basic: RenderBasic(AHost);
    TBadgeFluentExample.InterfaceUsage: RenderInterface(AHost);
    TBadgeFluentExample.Geometry: RenderGeometry(AHost);
    TBadgeFluentExample.Shape: RenderShape(AHost);
  end;
end;

class procedure TBadgeFluentRunner.RenderPresentation(
  const AExample: TBadgeFluentExample; const AHost: TLayout);
begin
  case AExample of
    TBadgeFluentExample.Layout: RenderLayout(AHost);
    TBadgeFluentExample.Appearance: RenderAppearance(AHost);
    TBadgeFluentExample.Typography: RenderTypography(AHost);
    TBadgeFluentExample.State: RenderState(AHost);
  end;
end;

class procedure TBadgeFluentRunner.RenderAdvanced(
  const AExample: TBadgeFluentExample; const AHost: TLayout);
begin
  case AExample of
    TBadgeFluentExample.ResultAccess: RenderResult(AHost);
    TBadgeFluentExample.CompleteDirect: RenderCompleteDirect(AHost);
    TBadgeFluentExample.CompleteInterfaces: RenderCompleteInterfaces(AHost);
  end;
end;

class procedure TBadgeFluentRunner.RenderBasic(const AHost: TLayout);
begin
  TRickUIBuilder
    .Badge
      .Text('Novo')
        .Build(AHost);
end;

class procedure TBadgeFluentRunner.RenderInterface(const AHost: TLayout);
var
  LBadge: IRickUIBuilderBadge;
begin
  LBadge := TRickUIBuilder.Badge;

  LBadge
    .Text('Interface')
      .Size(110, 28)
        .Build(AHost);
end;

class procedure TBadgeFluentRunner.RenderGeometry(const AHost: TLayout);
begin
  TRickUIBuilder
    .Badge
      .Text('Geometria')
        .Position(24, 20)
        .Size(140, 32)
          .Build(AHost);
end;

class procedure TBadgeFluentRunner.RenderShape(const AHost: TLayout);
begin
  TRickUIBuilder
    .Badge
      .Text('Pill')
        .Position(16, 12)
        .Size(120, 30)
          .Pill(True)
            .Build(AHost);

  TRickUIBuilder
    .Badge
      .Text('Corner radius')
        .Position(16, 60)
        .Size(140, 30)
          .Pill(False)
          .CornerRadius(6)
            .Build(AHost);
end;

class procedure TBadgeFluentRunner.RenderLayout(const AHost: TLayout);
begin
  TRickUIBuilder
    .Badge
      .Text('Layout')
        .Position(16, 12)
        .Size(140, 32)
          .Margin(TRickUIBuilderSpacing.Create(8, 6, 4, 2))
          .Padding(TRickUIBuilderSpacing.Create(10, 4, 6, 2))
            .Build(AHost);
end;

class procedure TBadgeFluentRunner.RenderAppearance(const AHost: TLayout);
begin
  TRickUIBuilder
    .Badge
      .Text('Aparência')
        .Size(140, 32)
          .BackgroundColor(TAlphaColors.Gray)
          .BorderColor(TAlphaColors.Dodgerblue)
            .Build(AHost);
end;

class procedure TBadgeFluentRunner.RenderTypography(const AHost: TLayout);
begin
  TRickUIBuilder
    .Badge
      .Text('Tipografia')
        .Size(150, 34)
          .TextColor(TAlphaColors.Dodgerblue)
          .FontSize(16)
          .Bold(True)
            .Build(AHost);
end;

class procedure TBadgeFluentRunner.RenderState(const AHost: TLayout);
begin
  TRickUIBuilder
    .Badge
      .Text('Estado')
        .Size(130, 32)
          .Opacity(0.70)
          .Visible(True)
          .Tag(501)
            .Build(AHost);
end;

class procedure TBadgeFluentRunner.RenderResult(const AHost: TLayout);
var
  LHandle: IRickUIBuilderBadgeHandle;
begin
  LHandle := TRickUIBuilder
    .Badge
      .Text('Resultado')
        .Size(150, 32)
          .Build(AHost);

  LHandle.TextLabel.Text := 'Resultado acessado';
end;

class procedure TBadgeFluentRunner.RenderCompleteDirect(const AHost: TLayout);
begin
  TRickUIBuilder
    .Badge
      .Text('Configuração completa')
        .Position(18, 20)
        .Size(220, 38)
          .Pill(False)
          .CornerRadius(10)
            .Margin(TRickUIBuilderSpacing.Create(12, 8, 4, 2))
            .Padding(TRickUIBuilderSpacing.Create(8, 4, 6, 2))
              .BackgroundColor(TAlphaColors.Dodgerblue)
              .BorderColor(TAlphaColors.Gray)
                .TextColor(TAlphaColors.White)
                .FontSize(15)
                .Bold(True)
                  .Opacity(0.92)
                  .Visible(True)
                  .Tag(2026)
                    .Build(AHost);
end;

class procedure TBadgeFluentRunner.RenderCompleteInterfaces(
  const AHost: TLayout);
var
  LBadge: IRickUIBuilderBadge;
  LHandle: IRickUIBuilderBadgeHandle;
begin
  LBadge := TRickUIBuilder.Badge;

  LHandle := LBadge
    .Text('Completo com interfaces')
      .Position(18, 20)
      .Size(220, 38)
        .Pill(False)
        .CornerRadius(10)
          .Margin(TRickUIBuilderSpacing.Create(12, 8, 4, 2))
          .Padding(TRickUIBuilderSpacing.Create(8, 4, 6, 2))
            .BackgroundColor(TAlphaColors.Dodgerblue)
            .BorderColor(TAlphaColors.Gray)
              .TextColor(TAlphaColors.White)
              .FontSize(15)
              .Bold(True)
                .Opacity(0.92)
                .Visible(True)
                .Tag(2026)
                  .Build(AHost);

  LHandle.TextLabel.Text := 'Interfaces completas';
end;

end.
