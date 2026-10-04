{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Component.Divider                                     }
{                                                                              }
{ Esta unit implementa a Component Page de Divider e encaminha por callbacks   }
{ non-owning as intenções Factory e Fluent Builder para seus destinos reais.   }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Representar a página intermediária do componente Divider.                   }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Define identidade, informação e as abordagens Factory e Fluent Builder,     }
{  encaminhando cada ação para o callback correspondente.                      }
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
{  - Não implementa samples Factory/Fluent; somente emite intenções.           }
{  - Não conhece TExampleDividerFactory nem TExampleDividerFluent.             }
{  - Não cria rotas, registry ou abstrações adicionais de navegação.           }
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
    FOnFluentExamples: TNotifyEvent;
    procedure FactoryExamplesRequested(ASender: TObject);
    procedure FluentExamplesRequested(ASender: TObject);
  public
    /// <summary>Cria a página com o conteúdo específico de Divider.</summary>
    constructor Create(AOwner: TComponent); override;
    /// <summary>Intenção non-owning para abrir o destino Divider - Factory.</summary>
    property OnFactoryExamples: TNotifyEvent read FOnFactoryExamples
      write FOnFactoryExamples;
    /// <summary>Intenção non-owning para abrir Divider - Fluent Builder.</summary>
    property OnFluentExamples: TNotifyEvent read FOnFluentExamples
      write FOnFluentExamples;
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
  AddFluentApproach(FluentExamplesRequested);
  AddInfoPanel(_INFO_);
end;

procedure TComponentDivider.FactoryExamplesRequested(ASender: TObject);
begin
  if Assigned(FOnFactoryExamples) then
    FOnFactoryExamples(ASender);
end;

procedure TComponentDivider.FluentExamplesRequested(ASender: TObject);
begin
  if Assigned(FOnFluentExamples) then
    FOnFluentExamples(ASender);
end;

end.
