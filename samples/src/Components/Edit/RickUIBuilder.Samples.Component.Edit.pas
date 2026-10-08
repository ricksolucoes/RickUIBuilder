{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Component.Edit                                        }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Representar a página intermediária do componente Edit.                      }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Define título, subtítulo, abordagem e texto informativo próprios.           }
{  Apresenta somente Fluent Builder centralizado e emite callback para a Sample }
{  Page concreta quando o usuário solicita Ver exemplos.                       }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - RickUIBuilder.Samples.Component.Common                                    }
{      Fornece TComponentCommon, header, layout, cards e painel informativo.   }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - TSampleApplicationCoordinator seleciona esta classe para o componente     }
{    correspondente e a exibe modalmente.                                      }
{  - O retorno e o lifetime modal permanecem na classe-base e no Coordinator,  }
{    respectivamente.                                                          }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - A página apresenta Fluent Builder centralizado e não cria opção Factory,  }
{    pois a API atual não expõe Factory.CreateEdit.                            }
{  - Esta página não cria Sample Pages diretamente; apenas emite a intenção.    }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Este cabeçalho deve ser atualizado quando conteúdo, dependências, fluxo ou  }
{  restrições desta unit mudarem.                                              }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.Component.Edit;

interface

uses
  System.Classes,
  RickUIBuilder.Samples.Component.Common;

type
  /// <summary>Página intermediária específica de Edit.</summary>
  TComponentEdit = class(TComponentCommon)
  strict private
    FOnFluentExamples: TNotifyEvent;
    procedure FluentExamplesRequested(ASender: TObject);
  public
    /// <summary>Cria a página com o conteúdo específico de Edit.</summary>
    constructor Create(AOwner: TComponent); override;
    property OnFluentExamples: TNotifyEvent read FOnFluentExamples
      write FOnFluentExamples;
  end;

implementation

const
  _TITLE_ = 'Edit';
  _SUBTITLE_ = 'Crie campos de texto de uma linha em runtime com Rick.UIBuilder.';
  _INFO_ = 'Edit é o builder de entrada de texto de uma linha do Rick.UIBuilder. No estado atual da API, ele está disponível pelo Fluent Builder e não possui Factory.CreateEdit.';

constructor TComponentEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AddIdentity(_TITLE_, _SUBTITLE_);
  AddCenteredFluentApproach(FluentExamplesRequested);
  AddInfoPanel(_INFO_);
end;

procedure TComponentEdit.FluentExamplesRequested(ASender: TObject);
begin
  if Assigned(FOnFluentExamples) then
    FOnFluentExamples(Self);
end;

end.
