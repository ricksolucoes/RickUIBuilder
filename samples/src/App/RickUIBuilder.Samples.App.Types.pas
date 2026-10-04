{ Esta unit centraliza os enums compartilhados pela navegação e pelas páginas de exemplos do RickUIBuilder.Samples, incluindo Button Factory e Fluent Builder. }
{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.App.Types                                             }
{                                                                              }
{ Esta unit centraliza os enums compartilhados pelo Samples, identificando     }
{ componentes navegáveis, os exemplos concretos de Text / Label e              }
{ Button - Factory/Fluent e a view Código/Resultado ativa na Sample Page Base. }
{                                                                               }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Centralizar tipos enumerados compartilhados entre navegação, páginas de     }
{  componente e páginas de exemplos do RickUIBuilder.Samples.                  }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  - TSampleComponent identifica os seis componentes navegáveis da Home.       }
{  - TTextLabelFactoryExample identifica os cinco exemplos da página           }
{    Text / Label - Factory.                                                   }
{  - TTextLabelFluentExample identifica os oito exemplos da página             }
{    Text / Label - Fluent Builder.                                            }
{  - TButtonFactoryExample identifica os oito exemplos da página               }
{    Button - Factory.                                                         }
{  - TButtonFluentExample identifica os doze exemplos da página                }
{    Button - Fluent Builder.                                                  }
{  - TExampleView identifica a view Código Delphi ou Resultado ativa.          }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - Não possui dependências internas do projeto.                              }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - Home, Presenter e Coordinator transportam TSampleComponent na navegação.  }
{  - As páginas concretas compartilham seus enums com as respectivas units     }
{    Content e Runner.                                                         }
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

  /// <summary>Identifica os exemplos da página Text / Label - Fluent Builder.</summary>
  TTextLabelFluentExample = (Basic, Geometry, Layout, Typography, Alignment,
    TextFlow, State, Complete);

  /// <summary>Identifica os exemplos da página Button - Factory.</summary>
  TButtonFactoryExample = (Basic, Geometry, Colors, Typography, Identification,
    CaptionAccess, Click, Complete);

  /// <summary>Identifica os exemplos da página Button - Fluent Builder.</summary>
  TButtonFluentExample = (Basic, InterfaceUsage, Geometry, Layout, Appearance,
    Typography, State, Hover, Click, ResultAccess, CompleteDirect,
    CompleteInterfaces);

  /// <summary>Identifica os componentes navegáveis apresentados pelo Samples.</summary>
  TSampleComponent = (TextLabel, Button, Badge, Divider, ComboBox, Edit);

  /// <summary>Visualização ativa da área principal do exemplo.</summary>
  TExampleView = (CodeView, ResultView);

implementation

end.
