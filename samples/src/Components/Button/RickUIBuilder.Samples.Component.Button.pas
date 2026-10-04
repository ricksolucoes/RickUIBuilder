{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Component.Button                                      }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Representar a página intermediária do componente Button.                    }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Define título, subtítulo, abordagens e texto informativo próprios.          }
{  Apresenta Factory e Fluent Builder como divisões visuais para destinos      }
{  futuros.                                                                    }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - RickUIBuilder.Samples.Component.Common                                    }
{      Fornece TComponentCommon, header, layout, cards e painel informativo.   }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - TSampleApplicationCoordinator seleciona esta classe para o componente     }
{    correspondente e a exibe modalmente.                                      }
{  - O retorno e o lifetime modal permanecem na classe-base e no Coordinator,  }
{    respectivamente.                                                          }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - A página contém Factory e Fluent Builder, sem implementar seus destinos   }
{    futuros.                                                                  }
{  - Esta página não cria samples nem páginas de destino Factory/Fluent.       }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Este cabeçalho deve ser atualizado quando conteúdo, dependências, fluxo ou  }
{  restrições desta unit mudarem.                                              }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.Component.Button;

interface

uses
  System.Classes,
  RickUIBuilder.Samples.Component.Common;

type
  /// <summary>Página intermediária específica de Button.</summary>
  TComponentButton = class(TComponentCommon)
  public
    /// <summary>Cria a página com o conteúdo específico de Button.</summary>
    constructor Create(AOwner: TComponent); override;
  end;

implementation

const
  _TITLE_ = 'Button';
  _SUBTITLE_ = 'Crie e configure botões FireMonkey com Rick.UIBuilder.';
  _INFO_ = 'Button é composto por TRectangle + TLabel. A Factory materializa a estrutura visual e o Fluent Builder acrescenta configuração e comportamento de hover.';

constructor TComponentButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AddIdentity(_TITLE_, _SUBTITLE_);
  AddFactoryApproach;
  AddFluentApproach;
  AddInfoPanel(_INFO_);
end;

end.
