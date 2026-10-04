{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.ComponentPage.Edit                                    }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Representar a página intermediária do componente Edit.                      }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Define título, subtítulo, abordagens e texto informativo próprios.          }
{  Apresenta somente Fluent Builder porque Factory.CreateEdit não existe na    }
{  API atual.                                                                  }
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
{  Não criar Factory vazia/desabilitada enquanto Factory.CreateEdit não        }
{  existir.                                                                    }
{  Esta página não cria samples nem páginas de destino Factory/Fluent.         }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Este cabeçalho deve ser atualizado quando conteúdo, dependências, fluxo ou  }
{  restrições desta unit mudarem.                                              }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.Component.Edit;

interface

uses
  System.Classes,
  RickUIBuilder.Samples.Component.Common;

type
  /// <summary>Página intermediária específica de Edit.</summary>
  TComponentEdit = class(TComponentCommon)
  public
    /// <summary>Cria a página com o conteúdo específico de Edit.</summary>
    constructor Create(AOwner: TComponent); override;
  end;

implementation

const
  _TITLE_ = 'Edit';
  _SUBTITLE_ = 'Crie campos de texto de uma linha em runtime com Rick.UIBuilder.';
  _INFO_ = 'Edit é o builder de entrada de texto de uma linha do Rick.UIBuilder. No estado atual da API, ele está disponível pelo Fluent Builder e não possui Factory.CreateEdit.';

constructor TComponentEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AddIdentity(_TITLE_, _SUBTITLE_);
  AddCenteredFluentApproach;
  AddInfoPanel(_INFO_);
end;

end.
