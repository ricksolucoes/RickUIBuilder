{ Esta unit implementa a Component Page de Button, habilitando somente o destino Factory realmente existente e mantendo Fluent Builder apenas visual até que sua Sample Page seja implementada. }
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
{  Define título, subtítulo, informação e as abordagens Factory e Fluent       }
{  Builder. Factory encaminha uma intenção de navegação quando o Coordinator   }
{  conecta OnFactoryExamples; Fluent Builder permanece sem destino navegável.  }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - RickUIBuilder.Samples.Component.Common                                    }
{      Fornece TComponentCommon, header, layout, cards e painel informativo.   }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - O Coordinator cria esta page, conecta Factory e chama ShowModal.          }
{  - O clique Factory é encaminhado ao callback externo; esta page não cria    }
{    diretamente TExampleButtonFactory.                                        }
{  - Fluent Builder continua somente visual enquanto não existir destino real. }
{  - O retorno para a Home permanece implementado pela classe-base.            }
{                                                                              }
{  Ownership / lifetime                                                        }
{  --------------------                                                        }
{  - OnFactoryExamples é um evento non-owning para o Coordinator, cujo         }
{    lifetime é superior durante a navegação.                                  }
{  - A page não possui Coordinator nem a Sample Page de destino.               }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - Não implementa os samples Factory; somente emite a intenção de navegação. }
{  - Não habilita ou antecipa destino Fluent Builder nesta etapa.              }
{  - Não conhece TExampleButtonFactory.                                        }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Atualizar este cabeçalho quando conteúdo, eventos, fluxo ou restrições      }
{  desta page mudarem.                                                         }
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
  strict private
    FOnFactoryExamples: TNotifyEvent;
    procedure FactoryExamplesRequested(ASender: TObject);
  public
    /// <summary>Cria a página com o conteúdo específico de Button.</summary>
    constructor Create(AOwner: TComponent); override;
    /// <summary>Intenção non-owning para abrir o destino Button - Factory.</summary>
    property OnFactoryExamples: TNotifyEvent read FOnFactoryExamples
      write FOnFactoryExamples;
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
  AddFactoryApproach(FactoryExamplesRequested);
  AddFluentApproach;
  AddInfoPanel(_INFO_);
end;

procedure TComponentButton.FactoryExamplesRequested(ASender: TObject);
begin
  if Assigned(FOnFactoryExamples) then
    FOnFactoryExamples(ASender);
end;

end.
