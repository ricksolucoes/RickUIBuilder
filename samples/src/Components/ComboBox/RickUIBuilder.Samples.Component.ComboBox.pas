{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.ComponentPage.ComboBox                                }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Representar a página intermediária do componente ComboBox.                  }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Define título, subtítulo, abordagens e texto informativo próprios.          }
{  Apresenta Factory e Fluent Builder como divisões visuais para destinos      }
{  futuros.                                                                    }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  RickUIBuilder.Samples.ComponentPage: fornece formulário, header, layout     }
{  comum, cards e painel informativo.                                          }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  TSampleApplicationCoordinator seleciona esta classe para o componente       }
{  correspondente e a exibe modalmente.                                        }
{  O retorno e o lifetime modal permanecem implementados na classe-base e no   }
{  Coordinator, respectivamente.                                               }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  A página contém Factory e Fluent Builder, sem implementar seus destinos     }
{  futuros.                                                                    }
{  Esta página não cria samples nem páginas de destino Factory/Fluent.         }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Este cabeçalho deve ser atualizado quando conteúdo, dependências, fluxo ou  }
{  restrições desta unit mudarem.                                              }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.Component.ComboBox;

interface

uses
  System.Classes,
  RickUIBuilder.Samples.Component.Common;

type
  /// <summary>Página intermediária específica de ComboBox.</summary>
  TComponentComboBox = class(TComponentCommon)
  public
    /// <summary>Cria a página com o conteúdo específico de ComboBox.</summary>
    constructor Create(AOwner: TComponent); override;
  end;

implementation

const
  _TITLE_ = 'ComboBox';
  _SUBTITLE_ = 'Crie seleções FireMonkey configuráveis com Rick.UIBuilder.';
  _INFO_ = 'ComboBox possui suporte à Factory e ao Fluent Builder. O Builder concentra configuração, itens e modos de apresentação, com superfícies de seleção materializadas quando necessárias.';

constructor TComponentComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AddIdentity(_TITLE_, _SUBTITLE_);
  AddFactoryApproach;
  AddFluentApproach;
  AddInfoPanel(_INFO_);
end;

end.
