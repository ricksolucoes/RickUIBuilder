{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.ComponentPage.TextLabel                               }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Representar a página intermediária do componente Text / Label.              }
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

unit RickUIBuilder.Samples.Component.TextLabel;

interface

uses
  System.Classes,
  RickUIBuilder.Samples.Component.Common;

type
  /// <summary>Página intermediária específica de Text / Label.</summary>
  TComponentTextLabel = class(TComponentCommon)
  public
    /// <summary>Cria a página com o conteúdo específico de Text / Label.</summary>
    constructor Create(AOwner: TComponent); override;
  end;

implementation

const
  _TITLE_ = 'Text / Label';
  _SUBTITLE_ = 'Crie e configure textos FireMonkey com Rick.UIBuilder.';
  _INFO_ = 'Text / Label cria TLabel em runtime. A Factory cobre a configuração textual básica e o Fluent Builder complementa a configuração visual e de layout.';

constructor TComponentTextLabel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AddIdentity(_TITLE_, _SUBTITLE_);
  AddFactoryApproach;
  AddFluentApproach;
  AddInfoPanel(_INFO_);
end;

end.
