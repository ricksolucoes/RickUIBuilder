{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Component.ComboBox                                    }
{                                                                              }
{ Esta unit implementa a Component Page de ComboBox e encaminha por callback   }
{ non-owning a intenção Factory para o destino concreto atualmente existente.  }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Representar a página intermediária do componente ComboBox.                  }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Define identidade, informação e Factory/Fluent Builder. Factory possui      }
{  destino real; Fluent permanece somente visual até existir Sample Page.      }
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
{    diretamente TExampleComboBoxFactory.                                      }
{  - Fluent Builder permanece sem callback enquanto não houver destino real.   }
{                                                                              }
{  Ownership / lifetime                                                        }
{  --------------------                                                        }
{  - OnFactoryExamples é evento non-owning para o Coordinator, cujo lifetime   }
{    é superior durante a navegação.                                           }
{  - A page não possui Coordinator nem Sample Pages concretas.                 }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - Não implementa samples; somente emite a intenção Factory.                 }
{  - Não conhece TExampleComboBoxFactory.                                      }
{  - Não cria callback Fluent sem destino concreto.                            }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Atualizar este cabeçalho quando conteúdo, eventos ou destinos reais desta   }
{  page mudarem.                                                               }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.Component.ComboBox;

interface

uses
  System.Classes,
  RickUIBuilder.Samples.Component.Common;

type
  /// <summary>Página intermediária específica de ComboBox.</summary>
  TComponentComboBox = class(TComponentCommon)
  strict private
    FOnFactoryExamples: TNotifyEvent;
    procedure FactoryExamplesRequested(ASender: TObject);
  public
    /// <summary>Cria a página com o conteúdo específico de ComboBox.</summary>
    constructor Create(AOwner: TComponent); override;
    /// <summary>Intenção non-owning para abrir ComboBox - Factory.</summary>
    property OnFactoryExamples: TNotifyEvent read FOnFactoryExamples
      write FOnFactoryExamples;
  end;

implementation

const
  _TITLE_ = 'ComboBox';
  _SUBTITLE_ = 'Crie seleções FireMonkey configuráveis com Rick.UIBuilder.';
  _INFO_ = 'A Factory atual materializa o controle fechado do ComboBox. Itens, lista, seleção e modos de apresentação pertencem ao Builder/runtime no estado atual da API.';

constructor TComponentComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AddIdentity(_TITLE_, _SUBTITLE_);
  AddFactoryApproach(FactoryExamplesRequested);
  AddFluentApproach;
  AddInfoPanel(_INFO_);
end;

procedure TComponentComboBox.FactoryExamplesRequested(ASender: TObject);
begin
  if Assigned(FOnFactoryExamples) then
    FOnFactoryExamples(ASender);
end;

end.
