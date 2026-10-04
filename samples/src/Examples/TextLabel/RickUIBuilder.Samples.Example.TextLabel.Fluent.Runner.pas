{ Esta unit executa os exemplos Text / Label - Fluent Builder no ResultHost usando exclusivamente a API pública TRickUIBuilder.Label_; o exemplo Completo chama todos os métodos configuráveis de IRickUIBuilderLabel e utiliza os quatro lados de cada TRickUIBuilderSpacing empregado. }
{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Example.TextLabel.Fluent.Runner                       }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Executar os exemplos reais da abordagem Fluent Builder de Text / Label.     }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Materializa TLabel no ResultHost por TRickUIBuilder.Label_, cobrindo a API  }
{  pública configurável de IRickUIBuilderLabel. O exemplo Completo chama       }
{  Text, Position, Size, Anchors, Margin, Padding, FontFamily, FontSize,        }
{  FontColor, Bold, Italic, Align, VerticalAlign, WordWrap, Trimming,          }
{  Opacity, Visible, HitTest, Tag e Build.                                     }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - RickUIBuilder.Samples.App.Types                                           }
{      Fornece TTextLabelFluentExample usado para selecionar a execução.       }
{  - Rick.UIBuilder                                                            }
{      Fornece TRickUIBuilder.Label_, entrada pública do Fluent Builder.       }
{  - Rick.UIBuilder.Types                                                      }
{      Fornece TRickUIBuilderSpacing usado por Margin e Padding.               }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - TExampleTextLabelFluent limpa ResultHost e solicita Render.               }
{  - Cada método materializa somente o controle do exemplo selecionado.        }
{  - Fluent.Content fornece o snippet equivalente sem ser dependência direta.  }
{                                                                              }
{  Ownership / lifetime                                                        }
{  --------------------                                                        }
{  - Build(ResultHost) usa ResultHost como Parent e Owner do TLabel criado.    }
{  - TExampleResultPanel.Clear libera o resultado antes da próxima execução.   }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - Não cria navegação, não define textos da página e não conhece Factory.    }
{  - TTextAlign/TTextTrimming exigem FMX.Types explicitamente.                 }
{  - TAnchorKind e TAlphaColors exigem System.UITypes explicitamente.          }
{  - O exemplo Completo deve permanecer exaustivo para a API pública Fluent.   }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Os valores executados devem permanecer sincronizados com os snippets        }
{  apresentados por Fluent.Content e com a API pública vigente.                }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.Example.TextLabel.Fluent.Runner;

interface

uses
  FMX.Layouts,
  RickUIBuilder.Samples.App.Types;

type
  /// <summary>Executa o resultado visual dos exemplos Fluent de Text / Label.</summary>
  TTextLabelFluentRunner = class sealed
  strict private
    class procedure RenderFoundation(const AExample: TTextLabelFluentExample;
      const AHost: TLayout); static;
    class procedure RenderBehavior(const AExample: TTextLabelFluentExample;
      const AHost: TLayout); static;
    class procedure RenderBasic(const AHost: TLayout); static;
    class procedure RenderGeometry(const AHost: TLayout); static;
    class procedure RenderLayout(const AHost: TLayout); static;
    class procedure RenderTypography(const AHost: TLayout); static;
    class procedure RenderAlignment(const AHost: TLayout); static;
    class procedure RenderTextFlow(const AHost: TLayout); static;
    class procedure RenderState(const AHost: TLayout); static;
    class procedure RenderComplete(const AHost: TLayout); static;
  public
    class procedure Render(const AExample: TTextLabelFluentExample;
      const AHost: TLayout); static;
  end;

implementation

uses
  System.UITypes,
  FMX.Types,
  Rick.UIBuilder,
  Rick.UIBuilder.Types;

class procedure TTextLabelFluentRunner.Render(
  const AExample: TTextLabelFluentExample; const AHost: TLayout);
begin
  if AExample <= TTextLabelFluentExample.Typography then
    RenderFoundation(AExample, AHost)
  else
    RenderBehavior(AExample, AHost);
end;

class procedure TTextLabelFluentRunner.RenderFoundation(
  const AExample: TTextLabelFluentExample; const AHost: TLayout);
begin
  case AExample of
    TTextLabelFluentExample.Basic: RenderBasic(AHost);
    TTextLabelFluentExample.Geometry: RenderGeometry(AHost);
    TTextLabelFluentExample.Layout: RenderLayout(AHost);
    TTextLabelFluentExample.Typography: RenderTypography(AHost);
  end;
end;

class procedure TTextLabelFluentRunner.RenderBehavior(
  const AExample: TTextLabelFluentExample; const AHost: TLayout);
begin
  case AExample of
    TTextLabelFluentExample.Alignment: RenderAlignment(AHost);
    TTextLabelFluentExample.TextFlow: RenderTextFlow(AHost);
    TTextLabelFluentExample.State: RenderState(AHost);
    TTextLabelFluentExample.Complete: RenderComplete(AHost);
  end;
end;

class procedure TTextLabelFluentRunner.RenderBasic(const AHost: TLayout);
begin
  TRickUIBuilder.Label_
    .Text('Texto básico')
    .Build(AHost);
end;

class procedure TTextLabelFluentRunner.RenderGeometry(const AHost: TLayout);
begin
  TRickUIBuilder.Label_
    .Text('Posição e tamanho')
    .Position(20, 16)
    .Size(260, 36)
    .Build(AHost);
end;

class procedure TTextLabelFluentRunner.RenderLayout(const AHost: TLayout);
begin
  TRickUIBuilder.Label_.Text('Layout configurado').Position(16, 12).Size(300, 48)
    .Anchors([TAnchorKind.akLeft, TAnchorKind.akTop])
    .Margin(TRickUIBuilderSpacing.Create(8, 6, 4, 2))
    .Padding(TRickUIBuilderSpacing.Create(10, 4, 6, 2)).Build(AHost);
end;

class procedure TTextLabelFluentRunner.RenderTypography(const AHost: TLayout);
begin
  TRickUIBuilder.Label_.Text('Tipografia fluente').Position(16, 12).Size(320, 44)
    .FontFamily('Segoe UI').FontSize(18).FontColor(TAlphaColors.Blue)
    .Bold(True).Italic(True).Build(AHost);
end;

class procedure TTextLabelFluentRunner.RenderAlignment(const AHost: TLayout);
begin
  TRickUIBuilder.Label_.Text('Texto centralizado').Position(16, 12).Size(320, 56)
    .Align(TTextAlign.Center).VerticalAlign(TTextAlign.Center).Build(AHost);
end;

class procedure TTextLabelFluentRunner.RenderTextFlow(const AHost: TLayout);
begin
  TRickUIBuilder.Label_.Text('Texto longo com quebra automática de linha.')
    .Position(16, 8).Size(260, 64).WordWrap(True)
    .Trimming(TTextTrimming.None).Build(AHost);
end;

class procedure TTextLabelFluentRunner.RenderState(const AHost: TLayout);
begin
  TRickUIBuilder.Label_.Text('Estado configurado').Position(16, 12).Size(300, 40)
    .Opacity(0.70).Visible(True).HitTest(False).Tag(501).Build(AHost);
end;

class procedure TTextLabelFluentRunner.RenderComplete(const AHost: TLayout);
begin
  TRickUIBuilder.Label_.Text('Configuração completa').Position(20, 12).Size(340, 72)
    .Anchors([TAnchorKind.akLeft, TAnchorKind.akTop])
    .Margin(TRickUIBuilderSpacing.Create(12, 8, 4, 2))
    .Padding(TRickUIBuilderSpacing.Create(8, 4, 6, 2))
    .FontFamily('Segoe UI').FontSize(16).FontColor(TAlphaColors.Green)
    .Bold(True).Italic(True).Align(TTextAlign.Center).VerticalAlign(TTextAlign.Center)
    .WordWrap(True).Trimming(TTextTrimming.None).Opacity(0.90)
    .Visible(True).HitTest(False).Tag(1001).Build(AHost);
end;

end.
