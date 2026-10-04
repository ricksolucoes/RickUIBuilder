{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.App.Coordinator                                       }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Coordenação do fluxo global do Samples.                                     }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Executa operações de aplicação solicitadas pelos presenters, atualmente     }
{  encerramento e abertura modal da página concreta de cada componente.        }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - RickUIBuilder.Samples.App.Types                                           }
{      Identifica o componente solicitado na navegação.                        }
{                                                                              }
{  - RickUIBuilder.Samples.ComponentPage                                       }
{      Fornece a base/metaclasse comum para as páginas intermediárias.         }
{                                                                              }
{  - RickUIBuilder.Samples.ComponentPage.*                                     }
{      Fornecem as seis páginas concretas selecionadas pelo componente.        }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - Recebe uma operação do Presenter e a converte em ação de aplicação.       }
{  - OpenComponent resolve a classe concreta, cria a página modal, aguarda     }
{    ShowModal e libera a instância ao retornar.                               }
{  - Close solicita Application.Terminate.                                     }
{                                                                              }
{  Ownership / lifetime                                                        }
{  --------------------                                                        }
{  - O Coordinator é o responsável pela instância modal de Component Page.    }
{  - A página é criada sem Owner e sempre liberada no bloco finally.           }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - Não contém controles ou regras de layout das páginas.                     }
{  - Não conhece páginas futuras de samples Factory/Fluent Builder.            }
{  - Não é possuído pelo Presenter; seu lifetime é controlado pelo             }
{    Composition Root.                                                         }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Este cabeçalho deve ser atualizado quando responsabilidade, dependências,   }
{  fluxo, ownership/lifetime ou restrições desta unit mudarem.                 }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.App.Coordinator;

interface

uses
  RickUIBuilder.Samples.App.Types;

type
  /// <summary>Coordena o fluxo global atualmente necessário ao Samples.</summary>
  TSampleApplicationCoordinator = class
  public
    /// <summary>Encerra o loop principal da aplicação.</summary>
    function Close: TSampleApplicationCoordinator;
    /// <summary>Abre modalmente a página concreta do componente solicitado.</summary>
    function OpenComponent(const AComponent: TSampleComponent): TSampleApplicationCoordinator;
  end;

implementation

uses
  FMX.Forms,
  RickUIBuilder.Samples.Component.Edit,
  RickUIBuilder.Samples.Component.Badge,
  RickUIBuilder.Samples.Component.Common,
  RickUIBuilder.Samples.Component.Button,
  RickUIBuilder.Samples.Component.Divider,
  RickUIBuilder.Samples.Component.ComboBox,
  RickUIBuilder.Samples.Component.TextLabel;

const
  _COMPONENT_PAGE_CLASSES_: array[TSampleComponent] of TComponentPageClass = (
    TComponentTextLabel,
    TComponentButton,
    TComponentBadge,
    TComponentDivider,
    TComponentComboBox,
    TComponentEdit);

function TSampleApplicationCoordinator.Close: TSampleApplicationCoordinator;
begin
  Application.Terminate;
  Result := Self;
end;

function TSampleApplicationCoordinator.OpenComponent(
  const AComponent: TSampleComponent): TSampleApplicationCoordinator;
var
  LPage: TComponentCommon;
begin
  LPage := _COMPONENT_PAGE_CLASSES_[AComponent].Create(nil);
  try
    LPage.ShowModal;
  finally
    LPage.Free;
  end;
  Result := Self;
end;

end.
