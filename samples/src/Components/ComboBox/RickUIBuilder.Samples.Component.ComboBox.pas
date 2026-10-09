{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Component.ComboBox                                    }
{                                                                              }
{ Esta unit implementa a Component Page de ComboBox e encaminha por callback   }
{ non-owning as intenções Factory e Fluent para destinos concretos.            }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Representar a página intermediária do componente ComboBox.                  }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Define identidade, informação e Factory/Fluent Builder, ambos com destinos  }
{  reais e callbacks encaminhados ao Coordinator.                              }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - RickUIBuilder.Samples.Component.Common                                    }
{      Fornece TComponentCommon, layout, cards e painel informativo.           }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - O Coordinator cria esta page, conecta Factory/Fluent e chama ShowModal.   }
{  - Os cliques são encaminhados a callbacks externos; esta page não cria      }
{    diretamente Sample Pages concretas.                                       }
{                                                                              }
{  Ownership / lifetime                                                        }
{  --------------------                                                        }
{  - OnFactoryExamples e OnFluentExamples são eventos non-owning para o        }
{    Coordinator, cujo lifetime é superior durante a navegação.                }
{  - A page não possui Coordinator nem Sample Pages concretas.                 }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - Não implementa samples; somente emite intenções Factory/Fluent.           }
{  - Não conhece TExampleComboBoxFactory nem TExampleComboBoxFluent.           }
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
    FOnFluentExamples: TNotifyEvent;
    procedure FactoryExamplesRequested(ASender: TObject);
    procedure FluentExamplesRequested(ASender: TObject);
  public
    /// <summary>Cria a página com o conteúdo específico de ComboBox.</summary>
    constructor Create(AOwner: TComponent); override;
    /// <summary>Intenção non-owning para abrir ComboBox - Factory.</summary>
    property OnFactoryExamples: TNotifyEvent read FOnFactoryExamples
      write FOnFactoryExamples;
    /// <summary>Intenção non-owning para abrir ComboBox - Fluent Builder.</summary>
    property OnFluentExamples: TNotifyEvent read FOnFluentExamples
      write FOnFluentExamples;
  end;

implementation

const
  _TITLE_ = 'ComboBox';
  _SUBTITLE_ = 'Crie seleções FireMonkey configuráveis com Rick.UIBuilder.';
  _INFO_ = 'Factory e Fluent Builder demonstram listas, seleção, apresentação, eventos e runtime do ComboBox por suas APIs públicas.';

constructor TComponentComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AddIdentity(_TITLE_, _SUBTITLE_);
  AddFactoryApproach(FactoryExamplesRequested);
  AddFluentApproach(FluentExamplesRequested);
  AddInfoPanel(_INFO_);
end;

procedure TComponentComboBox.FactoryExamplesRequested(ASender: TObject);
begin
  if Assigned(FOnFactoryExamples) then
    FOnFactoryExamples(ASender);
end;

procedure TComponentComboBox.FluentExamplesRequested(ASender: TObject);
begin
  if Assigned(FOnFluentExamples) then
    FOnFluentExamples(ASender);
end;

end.
