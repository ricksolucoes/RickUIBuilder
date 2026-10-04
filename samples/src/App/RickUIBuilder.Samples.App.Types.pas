{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.App.Types                                             }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Tipos compartilhados pela aplicação Samples.                                }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Declara TSampleComponent, enum que identifica os seis destinos de           }
{  componente atualmente navegáveis.                                           }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - Não possui dependências internas do projeto.                              }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - TPageSamplesHome associa cada card a um TSampleComponent; Presenter e     }
{    Coordinator transportam esse valor até a navegação.                       }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - Adicionar valores somente quando existir destino real correspondente no   }
{    Samples.                                                                  }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Este cabeçalho deve ser atualizado quando responsabilidade, dependências,   }
{  fluxo, ownership/lifetime ou restrições desta unit mudarem.                 }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.App.Types;

interface

{$SCOPEDENUMS ON}

type
  /// <summary>Identifica os exemplos Factory atualmente demonstrados.</summary>
  TTextLabelFactoryExample = (Basic, Geometry, Typography, Alignment, Complete);

  /// <summary>Identifica os componentes navegaveis apresentados pelo Samples.</summary>
  TSampleComponent = (TextLabel, Button, Badge, Divider, ComboBox, Edit);

  /// <summary>Visualização ativa da área principal do exemplo.</summary>
  TExampleView = (CodeView, ResultView);

implementation

end.
