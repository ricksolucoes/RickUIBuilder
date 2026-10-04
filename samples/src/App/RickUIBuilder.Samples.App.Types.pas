{ Esta unit centraliza os enums compartilhados pelo Samples, identificando componentes navegáveis, os exemplos atuais de Text / Label - Factory e a view Código/Resultado ativa na Sample Page Base. }
{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.App.Types                                             }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Centralizar tipos enumerados compartilhados entre navegação, páginas de     }
{  componente e páginas de exemplos do RickUIBuilder.Samples.                  }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  - TSampleComponent identifica os seis componentes navegáveis da Home.       }
{  - TTextLabelFactoryExample identifica os cinco exemplos atuais da página    }
{    concreta Text / Label - Factory.                                          }
{  - TExampleView identifica qual view estrutural da Sample Page Base está     }
{    ativa: Código Delphi ou Resultado.                                        }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - Não possui dependências internas do projeto.                              }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - Home, Presenter e Coordinator transportam TSampleComponent na navegação.  }
{  - TextLabel.Factory, Factory.Content e Factory.Runner compartilham           }
{    TTextLabelFactoryExample para manter seleção, conteúdo e execução         }
{    sincronizados.                                                            }
{  - Example.Common e Example.Common.View.Selector usam TExampleView para      }
{    coordenar a alternância Código Delphi/Resultado.                          }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - Adicionar ou mover tipos somente quando houver consumidores reais.        }
{  - Esta unit não implementa navegação, renderização ou execução de samples.  }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Atualizar este cabeçalho quando os tipos compartilhados ou seus             }
{  consumidores mudarem.                                                       }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.App.Types;

interface

{$SCOPEDENUMS ON}

type
  /// <summary>Identifica os exemplos da página Text / Label - Factory.</summary>
  TTextLabelFactoryExample = (Basic, Geometry, Typography, Alignment, Complete);

  /// <summary>Identifica os componentes navegáveis apresentados pelo Samples.</summary>
  TSampleComponent = (TextLabel, Button, Badge, Divider, ComboBox, Edit);

  /// <summary>Visualização ativa da área principal do exemplo.</summary>
  TExampleView = (CodeView, ResultView);

implementation

end.
