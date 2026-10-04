{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Component.Divider                                     }
{                                                                              }
{ Esta unit implementa a Component Page de Divider e encaminha por callback    }
{ non-owning a intenção Factory para o destino concreto existente.             }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Representar a página intermediária do componente Divider.                   }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Define identidade, informação e as abordagens Factory e Fluent Builder.     }
{  Somente Factory encaminha intenção de navegação nesta etapa.                }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - RickUIBuilder.Samples.Component.Common                                    }
{      Fornece TComponentCommon, layout, cards e painel informativo.           }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - O Coordinator cria esta page, conecta Factory e chama ShowModal.          }
{  - O clique Factory é encaminhado ao callback externo; esta page não cria    }
{    diretamente a Sample Page de destino.                                     }
{  - Fluent Builder permanece somente visual até existir destino concreto.     }
{  - O retorno para a Home permanece implementado pela classe-base.            }
{                                                                              }
{  Ownership / lifetime                                                        }
{  --------------------                                                        }
{  - OnFactoryExamples é evento non-owning para o Coordinator, cujo lifetime   }
{    é superior durante a navegação.                                           }
{  - A page não possui Coordinator nem Sample Page concreta.                   }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - Não implementa samples Factory/Fluent; somente emite a intenção Factory.  }
{  - Não conhece TExampleDividerFactory.                                       }
{  - Não habilita callback Fluent enquanto esse destino não existir.           }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Atualizar este cabeçalho quando conteúdo, eventos, fluxo ou destinos reais  }
{  desta page mudarem.                                                         }
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
  strict private
    FOnFactoryExamples: TNotifyEvent;
    procedure FactoryExamplesRequested(ASender: TObject);
  public
    /// <summary>Cria a página com o conteúdo específico de Divider.</summary>
    constructor Create(AOwner: TComponent); override;
    /// <summary>Intenção non-owning para abrir o destino Divider - Factory.</summary>
    property OnFactoryExamples: TNotifyEvent read FOnFactoryExamples
      write FOnFactoryExamples;
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
  AddFactoryApproach(FactoryExamplesRequested);
  AddFluentApproach;
  AddInfoPanel(_INFO_);
end;

procedure TComponentDivider.FactoryExamplesRequested(ASender: TObject);
begin
  if Assigned(FOnFactoryExamples) then
    FOnFactoryExamples(ASender);
end;

end.
