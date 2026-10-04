{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.ComponentPage.Divider                                 }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Representar a página intermediária do componente Divider.                   }
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

unit RickUIBuilder.Samples.Component.Divider;

interface

uses
  System.Classes,
  RickUIBuilder.Samples.Component.Common;

type
  /// <summary>Página intermediária específica de Divider.</summary>
  TComponentDivider = class(TComponentCommon)
  public
    /// <summary>Cria a página com o conteúdo específico de Divider.</summary>
    constructor Create(AOwner: TComponent); override;
  end;

implementation

const
  _TITLE_ = 'Divider';
  _SUBTITLE_ = 'Crie separadores horizontais ou verticais com Rick.UIBuilder.';
  _INFO_ = 'Divider usa TRectangle como separador horizontal ou vertical e pode ser criado pela Factory ou configurado pelo Fluent Builder.';

constructor TComponentDivider.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AddIdentity(_TITLE_, _SUBTITLE_);
  AddFactoryApproach;
  AddFluentApproach;
  AddInfoPanel(_INFO_);
end;

end.
