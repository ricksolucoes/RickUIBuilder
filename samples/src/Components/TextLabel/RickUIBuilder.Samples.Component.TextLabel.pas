{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Component.TextLabel                                   }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Representar a página intermediária do componente Text / Label.              }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Define identidade, informação e abordagens de Text / Label. O card Factory  }
{  encaminha uma intenção de navegação quando OnFactoryExamples foi conectado;}
{  Fluent Builder permanece somente visual enquanto seu destino não existe.    }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - RickUIBuilder.Samples.Component.Common                                    }
{      Fornece TComponentCommon, layout, cards e painel informativo.           }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - O Coordinator cria esta page, conecta OnFactoryExamples e chama ShowModal.}
{  - O clique Factory é capturado por FactoryExamplesRequested e apenas        }
{    encaminhado ao callback externo; a page não cria seu destino.             }
{  - O retorno para a Home permanece implementado pela classe-base.            }
{                                                                              }
{  Ownership / lifetime                                                        }
{  --------------------                                                        }
{  - OnFactoryExamples é referência de evento non-owning para o Coordinator.  }
{  - A page não possui Coordinator nem a Sample Page de destino.               }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - Não implementa samples Factory; somente emite a intenção de abertura.     }
{  - Não implementa destino Fluent Builder nesta etapa.                        }
{  - Não conhece TExampleTextLabelFactory diretamente.                         }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Atualizar este cabeçalho quando conteúdo, eventos, fluxo ou restrições      }
{  desta page mudarem.                                                         }
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
  strict private
    FOnFactoryExamples: TNotifyEvent;
    procedure FactoryExamplesRequested(ASender: TObject);
  public
    /// <summary>Cria a página com o conteúdo específico de Text / Label.</summary>
    constructor Create(AOwner: TComponent); override;
    property OnFactoryExamples: TNotifyEvent read FOnFactoryExamples
      write FOnFactoryExamples;
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
  AddFactoryApproach(FactoryExamplesRequested);
  AddFluentApproach;
  AddInfoPanel(_INFO_);
end;

procedure TComponentTextLabel.FactoryExamplesRequested(ASender: TObject);
begin
  if Assigned(FOnFactoryExamples) then
    FOnFactoryExamples(ASender);
end;

end.
