{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.ComponentPage.Badge                                   }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Representar a página intermediária do componente Badge.                     }
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

unit RickUIBuilder.Samples.Component.Badge;

interface

uses
  System.Classes,
  RickUIBuilder.Samples.Component.Common;

type
  /// <summary>Página intermediária específica de Badge.</summary>
  TComponentBadge = class(TComponentCommon)
  public
    /// <summary>Cria a página com o conteúdo específico de Badge.</summary>
    constructor Create(AOwner: TComponent); override;
  end;

implementation

const
  _TITLE_ = 'Badge';
  _SUBTITLE_ = 'Crie badges compostos e configure sua apresentação com Rick.UIBuilder.';
  _INFO_ = 'Badge combina TRectangle + TLabel e pode ser criado pela Factory ou configurado pelo Fluent Builder, incluindo as opções visuais próprias do componente.';

constructor TComponentBadge.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AddIdentity(_TITLE_, _SUBTITLE_);
  AddFactoryApproach;
  AddFluentApproach;
  AddInfoPanel(_INFO_);
end;

end.
