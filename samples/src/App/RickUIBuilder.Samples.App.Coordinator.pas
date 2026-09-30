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
{  encerramento e abertura modal da página de componente.                      }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - RickUIBuilder.Samples.App.Types                                           }
{      Identifica o componente solicitado na navegação.                        }
{                                                                              }
{  - RickUIBuilder.Samples.ComponentPage                                       }
{      Página criada para apresentar as abordagens do componente.              }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - Recebe uma operação do Presenter e a converte em ação de aplicação.       }
{  - OpenComponent cria e libera a página modal; Close solicita                }
{    Application.Terminate.                                                    }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - Não contém controles ou layout da Home.                                   }
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
  /// <summary>Coordena o fluxo global atualmente necessario ao Samples.</summary>
  TSampleApplicationCoordinator = class
  public
    /// <summary>Encerra o loop principal da aplicação.</summary>
    function Close: TSampleApplicationCoordinator;
    /// <summary>Abre modalmente a página do componente solicitado.</summary>
    function OpenComponent(const AComponent: TSampleComponent): TSampleApplicationCoordinator;
  end;

implementation

uses
  FMX.Forms,
  RickUIBuilder.Samples.ComponentPage;

function TSampleApplicationCoordinator.Close: TSampleApplicationCoordinator;
begin
  Application.Terminate;
  Result := Self;
end;

function TSampleApplicationCoordinator.OpenComponent(
  const AComponent: TSampleComponent): TSampleApplicationCoordinator;
var
  LPage: TComponentPage;
begin
  LPage := TComponentPage.Create(nil, AComponent);
  try
    LPage.ShowModal;
  finally
    LPage.Free;
  end;
  Result := Self;
end;

end.
