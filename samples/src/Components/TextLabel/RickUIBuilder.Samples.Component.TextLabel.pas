{ Esta unit implementa a Component Page de Text / Label, apresentando Factory e Fluent Builder e encaminhando cada clique por callback non-owning para os destinos reais coordenados externamente. }
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
{  - Não conhece TExampleTextLabelFactory ou TExampleTextLabelFluent.          }
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
    FOnFluentExamples: TNotifyEvent;
    procedure FactoryExamplesRequested(ASender: TObject);
    procedure FluentExamplesRequested(ASender: TObject);
  public
    /// <summary>Cria a página com o conteúdo específico de Text / Label.</summary>
    constructor Create(AOwner: TComponent); override;
    property OnFactoryExamples: TNotifyEvent read FOnFactoryExamples
      write FOnFactoryExamples;
    property OnFluentExamples: TNotifyEvent read FOnFluentExamples
      write FOnFluentExamples;
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
  AddFluentApproach(FluentExamplesRequested);
  AddInfoPanel(_INFO_);
end;

procedure TComponentTextLabel.FactoryExamplesRequested(ASender: TObject);
begin
  if Assigned(FOnFactoryExamples) then
    FOnFactoryExamples(ASender);
end;

procedure TComponentTextLabel.FluentExamplesRequested(ASender: TObject);
begin
  if Assigned(FOnFluentExamples) then
    FOnFluentExamples(ASender);
end;

end.
