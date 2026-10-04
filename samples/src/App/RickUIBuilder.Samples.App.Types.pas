{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.App.Types                                             }
{                                                                              }
{ Esta unit centraliza os enums compartilhados pelo Samples, identificando     }
{ componentes navegáveis, exemplos concretos de Text / Label, Button, Badge e  }
{ Divider e a view Código/Resultado ativa na Sample Page Base.                 }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Centralizar tipos enumerados compartilhados entre navegação, páginas de     }
{  componente e páginas de exemplos do RickUIBuilder.Samples.                  }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  - TSampleComponent identifica os seis componentes navegáveis da Home.       }
{  - TTextLabelFactoryExample identifica os cinco exemplos Text / Label        }
{    Factory e TTextLabelFluentExample os oito exemplos Fluent Builder.        }
{  - TButtonFactoryExample identifica os oito exemplos Button Factory e        }
{    TButtonFluentExample os doze exemplos Button Fluent Builder.              }
{  - TBadgeFactoryExample identifica os sete exemplos Badge - Factory e        }
{    TBadgeFluentExample os onze exemplos Badge Fluent Builder.                }
{  - TDividerFactoryExample identifica os quatro exemplos Divider - Factory.   }
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

  /// <summary>Identifica os exemplos da página Badge - Factory.</summary>
  TBadgeFactoryExample = (Basic, Geometry, Colors, Typography, TextAccess,
    StepByStep, Complete);

  /// <summary>Identifica os exemplos da página Badge - Fluent Builder.</summary>
  TBadgeFluentExample = (Basic, InterfaceUsage, Geometry, Shape, Layout,
    Appearance, Typography, State, ResultAccess, CompleteDirect,
    CompleteInterfaces);

  /// <summary>Identifica os exemplos da página Divider - Factory.</summary>
  TDividerFactoryExample = (Basic, Geometry, Color, Complete);

  /// <summary>Identifica os componentes navegáveis apresentados pelo Samples.</summary>
  TSampleComponent = (TextLabel, Button, Badge, Divider, ComboBox, Edit);

  /// <summary>Visualização ativa da área principal do exemplo.</summary>
  TExampleView = (CodeView, ResultView);

implementation

end.
