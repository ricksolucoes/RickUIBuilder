{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Component.Badge                                       }
{                                                                              }
{ Esta unit implementa a Component Page de Badge, habilitando o destino        }
{ Factory real por callback non-owning e mantendo Fluent Builder somente       }
{ visual enquanto sua Sample Page não existir.                                 }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Representar a página intermediária do componente Badge.                     }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Define identidade, informação e as abordagens Factory e Fluent Builder.     }
{  Factory encaminha uma intenção de navegação ao Coordinator; Fluent Builder  }
{  permanece sem callback nesta etapa.                                         }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - RickUIBuilder.Samples.Component.Common                                    }
{      Fornece TComponentCommon, layout, cards e painel informativo.           }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - O Coordinator cria esta page, conecta Factory e chama ShowModal.          }
{  - O clique em Factory é encaminhado ao callback externo; esta page não cria }
{    diretamente a Sample Page de destino.                                     }
{  - O retorno para a Home permanece implementado pela classe-base.            }
{                                                                              }
{  Ownership / lifetime                                                        }
{  --------------------                                                        }
{  - OnFactoryExamples é um evento non-owning para o Coordinator, cujo         }
{    lifetime é superior durante a navegação.                                  }
{  - A page não possui Coordinator nem a Sample Page Badge - Factory.          }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - Não implementa os samples Factory; somente emite a intenção.              }
{  - Não habilita Fluent Builder sem destino concreto.                         }
{  - Não conhece TExampleBadgeFactory.                                         }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Atualizar este cabeçalho quando conteúdo, eventos, fluxo ou destinos reais  }
{  desta page mudarem.                                                         }
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
  strict private
    FOnFactoryExamples: TNotifyEvent;
    procedure FactoryExamplesRequested(ASender: TObject);
  public
    /// <summary>Cria a página com o conteúdo específico de Badge.</summary>
    constructor Create(AOwner: TComponent); override;
    /// <summary>Intenção non-owning para abrir o destino Badge - Factory.</summary>
    property OnFactoryExamples: TNotifyEvent read FOnFactoryExamples
      write FOnFactoryExamples;
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
  AddFactoryApproach(FactoryExamplesRequested);
  AddFluentApproach;
  AddInfoPanel(_INFO_);
end;

procedure TComponentBadge.FactoryExamplesRequested(ASender: TObject);
begin
  if Assigned(FOnFactoryExamples) then
    FOnFactoryExamples(ASender);
end;

end.
