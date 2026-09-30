{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Home.Presenter                                        }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Implementação do contrato IHomePresenter.                                   }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Recebe as intenções da Home e as delega ao TSampleApplicationCoordinator    }
{  sem introduzir dependência de controles FMX.                                }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - RickUIBuilder.Samples.Home.Presenter.Intf                                 }
{      Contrato implementado.                                                  }
{                                                                              }
{  - RickUIBuilder.Samples.App.Coordinator                                     }
{      Executa o fluxo global solicitado.                                      }
{                                                                              }
{  - RickUIBuilder.Samples.App.Types                                           }
{      Fornece TSampleComponent transportado na navegação.                     }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - A Home chama IHomePresenter; THomePresenter delega ao Coordinator e       }
{    retorna a interface sem alterar configuração contratual.                  }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - FCoordinator é referência não-owning.                                     }
{  - O Presenter não referencia a Home e não cria páginas.                     }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Este cabeçalho deve ser atualizado quando responsabilidade, dependências,   }
{  fluxo, ownership/lifetime ou restrições desta unit mudarem.                 }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.Home.Presenter;

interface

uses
  RickUIBuilder.Samples.App.Coordinator,
  RickUIBuilder.Samples.App.Types,
  RickUIBuilder.Samples.Home.Presenter.Intf;

type
  /// <summary>Implementa as intencoes da Home sem depender de controles FMX.</summary>
  THomePresenter = class(TInterfacedObject, IHomePresenter)
  strict private
    FCoordinator: TSampleApplicationCoordinator;
  protected
    constructor Create(const ACoordinator: TSampleApplicationCoordinator);
    function Close: IHomePresenter;
    function OpenComponent(const AComponent: TSampleComponent): IHomePresenter;
  public
    /// <summary>Libera a implementação sem destruir o Coordinator não-owning.</summary>
    destructor Destroy; override;
    /// <summary>Cria uma implementação do contrato para o Coordinator informado.</summary>
    class function New(const ACoordinator: TSampleApplicationCoordinator): IHomePresenter; static;
  end;

implementation

constructor THomePresenter.Create(
  const ACoordinator: TSampleApplicationCoordinator);
begin
  inherited Create;
  FCoordinator := ACoordinator;
end;

destructor THomePresenter.Destroy;
begin
  FCoordinator := nil;
  inherited;
end;

class function THomePresenter.New(
  const ACoordinator: TSampleApplicationCoordinator): IHomePresenter;
begin
  Result := THomePresenter.Create(ACoordinator);
end;

function THomePresenter.Close: IHomePresenter;
begin
  FCoordinator.Close;
  Result := Self;
end;

function THomePresenter.OpenComponent(
  const AComponent: TSampleComponent): IHomePresenter;
begin
  FCoordinator.OpenComponent(AComponent);
  Result := Self;
end;

end.
