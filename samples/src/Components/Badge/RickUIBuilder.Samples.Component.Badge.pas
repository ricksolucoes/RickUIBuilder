{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Component.Badge                                       }
{                                                                              }
{ Esta unit implementa a Component Page de Badge e encaminha por callbacks     }
{ non-owning as intenções para os destinos concretos Factory e Fluent Builder. }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Representar a página intermediária do componente Badge.                     }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Define identidade, informação e as abordagens Factory e Fluent Builder.     }
{  Cada card encaminha sua intenção de navegação ao Coordinator.               }
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
{    diretamente as Sample Pages de destino.                                   }
{  - O retorno para a Home permanece implementado pela classe-base.            }
{                                                                              }
{  Ownership / lifetime                                                        }
{  --------------------                                                        }
{  - OnFactoryExamples e OnFluentExamples são eventos non-owning para o        }
{    Coordinator, cujo lifetime é superior durante a navegação.                }
{  - A page não possui Coordinator nem Sample Pages concretas.                 }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - Não implementa samples Factory/Fluent; somente emite as intenções.        }
{  - Não conhece TExampleBadgeFactory nem TExampleBadgeFluent.                 }
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
    FOnFluentExamples: TNotifyEvent;
    procedure FactoryExamplesRequested(ASender: TObject);
    procedure FluentExamplesRequested(ASender: TObject);
  public
    /// <summary>Cria a página com o conteúdo específico de Badge.</summary>
    constructor Create(AOwner: TComponent); override;
    /// <summary>Intenção non-owning para abrir o destino Badge - Factory.</summary>
    property OnFactoryExamples: TNotifyEvent read FOnFactoryExamples
      write FOnFactoryExamples;
    /// <summary>Intenção non-owning para abrir Badge - Fluent Builder.</summary>
    property OnFluentExamples: TNotifyEvent read FOnFluentExamples
      write FOnFluentExamples;
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
  AddFluentApproach(FluentExamplesRequested);
  AddInfoPanel(_INFO_);
end;

procedure TComponentBadge.FactoryExamplesRequested(ASender: TObject);
begin
  if Assigned(FOnFactoryExamples) then
    FOnFactoryExamples(ASender);
end;

procedure TComponentBadge.FluentExamplesRequested(ASender: TObject);
begin
  if Assigned(FOnFluentExamples) then
    FOnFluentExamples(ASender);
end;

end.
