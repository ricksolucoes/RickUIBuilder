{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Home.Presenter.Intf                                   }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Contrato de apresentação da Home.                                           }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Define as operações pelas quais a Home comunica intenção de fechar o        }
{  Samples ou abrir um componente.                                             }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - RickUIBuilder.Samples.App.Types                                           }
{      Fornece TSampleComponent usado por OpenComponent.                       }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - TPageSamplesHome depende deste contrato; THomePresenter o implementa e    }
{    delega as operações ao Coordinator.                                       }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - Contratos do Samples usam function, não procedure.                        }
{  - O contrato não expõe tipos visuais FMX nem conhece a View concreta.       }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Este cabeçalho deve ser atualizado quando responsabilidade, dependências,   }
{  fluxo, ownership/lifetime ou restrições desta unit mudarem.                 }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.Home.Presenter.Intf;

interface

uses
  RickUIBuilder.Samples.App.Types;

type
  /// <summary>Contrato das intencoes emitidas pela Home.</summary>
  IHomePresenter = interface
    ['{8C0C0A2B-E31C-4D48-8A63-29DAB91C61C5}']
    /// <summary>Solicita o encerramento do Samples.</summary>
    function Close: IHomePresenter;
    /// <summary>Solicita a abertura do componente informado.</summary>
    function OpenComponent(const AComponent: TSampleComponent): IHomePresenter;
  end;

implementation

end.
