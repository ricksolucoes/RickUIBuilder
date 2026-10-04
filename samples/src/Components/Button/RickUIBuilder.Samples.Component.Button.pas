{ Esta unit implementa a Component Page de Button, apresentando Factory e Fluent Builder e encaminhando cada clique por callback non-owning para os destinos reais coordenados externamente. }
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
{  Define identidade, informação e as abordagens Factory e Fluent Builder.     }
{  Cada card encaminha somente uma intenção de navegação quando o callback     }
{  correspondente foi conectado pelo Coordinator.                             }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - RickUIBuilder.Samples.Component.Common                                    }
{      Fornece TComponentCommon, layout, cards e painel informativo.           }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - O Coordinator cria esta page, conecta Factory/Fluent e chama ShowModal.   }
{  - Os cliques são encaminhados aos callbacks externos; esta page não cria    }
{    diretamente nenhuma Sample Page.                                          }
{  - O retorno para a Home permanece implementado pela classe-base.            }
{                                                                              }
{  Ownership / lifetime                                                        }
{  --------------------                                                        }
{  - OnFactoryExamples e OnFluentExamples são eventos non-owning para o        }
{    Coordinator, cujo lifetime é superior durante a navegação.                }
{  - A page não possui Coordinator nem as Sample Pages de destino.             }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - Não implementa os samples Factory ou Fluent; somente emite intenções.     }
{  - Não conhece TExampleButtonFactory ou TExampleButtonFluent.                }
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
    FOnFluentExamples: TNotifyEvent;
    procedure FactoryExamplesRequested(ASender: TObject);
    procedure FluentExamplesRequested(ASender: TObject);
  public
    /// <summary>Cria a página com o conteúdo específico de Button.</summary>
    constructor Create(AOwner: TComponent); override;
    /// <summary>Intenção non-owning para abrir o destino Button - Factory.</summary>
    property OnFactoryExamples: TNotifyEvent read FOnFactoryExamples
      write FOnFactoryExamples;
    /// <summary>Intenção non-owning para abrir o destino Button - Fluent Builder.</summary>
    property OnFluentExamples: TNotifyEvent read FOnFluentExamples
      write FOnFluentExamples;
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
  AddFluentApproach(FluentExamplesRequested);
  AddInfoPanel(_INFO_);
end;

procedure TComponentButton.FactoryExamplesRequested(ASender: TObject);
begin
  if Assigned(FOnFactoryExamples) then
    FOnFactoryExamples(ASender);
end;

procedure TComponentButton.FluentExamplesRequested(ASender: TObject);
begin
  if Assigned(FOnFluentExamples) then
    FOnFluentExamples(ASender);
end;

end.
