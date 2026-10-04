{ Esta unit coordena o fluxo e o lifetime das páginas modais do Samples, resolve a Component Page concreta e conecta os dois destinos reais de Text / Label: Factory e Fluent Builder. }
{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.App.Coordinator                                       }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Coordenar o fluxo global e o lifetime das páginas modais do Samples.        }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Encerra a aplicação, resolve a Component Page concreta e, para Text / Label,}
{  conecta as intenções Factory e Fluent aos destinos concretos existentes.    }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - RickUIBuilder.Samples.App.Types                                           }
{      Identifica o componente solicitado na navegação.                        }
{  - RickUIBuilder.Samples.Component.Common                                    }
{      Fornece TComponentCommon e a metaclasse das Component Pages.            }
{  - RickUIBuilder.Samples.Component.*                                         }
{      Fornecem as seis Component Pages concretas.                             }
{  - RickUIBuilder.Samples.Example.TextLabel.Factory                           }
{      Fornece o destino concreto Text / Label - Factory.                      }
{  - RickUIBuilder.Samples.Example.TextLabel.Fluent                            }
{      Fornece o destino concreto Text / Label - Fluent Builder.               }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - Home/Presenter solicitam OpenComponent.                                   }
{  - OpenComponent cria a Component Page, conecta intenções disponíveis e      }
{    aguarda ShowModal.                                                        }
{  - Os callbacks de Text / Label abrem a Sample Page correspondente modal.    }
{  - Ao fechar a Sample Page, a Component Page de Text / Label volta a ativa.  }
{                                                                              }
{  Ownership / lifetime                                                        }
{  --------------------                                                        }
{  - Component Pages e Sample Pages são criadas sem Owner.                     }
{  - O Coordinator libera cada instância em bloco finally após ShowModal.      }
{  - Os callbacks armazenados pela Component Page são non-owning; o            }
{    Coordinator possui lifetime superior durante toda a navegação.            }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - Não contém controles, snippets ou regras visuais das pages.               }
{  - Só conhece destinos que realmente existem no código final.               }
{  - Não executa Factory/Fluent; somente coordena a navegação.                 }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Atualizar este cabeçalho quando destinos, callbacks, ownership ou fluxo     }
{  modal mudarem.                                                              }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.App.Coordinator;

interface

uses
  RickUIBuilder.Samples.App.Types;

type
  /// <summary>Coordena o fluxo global atualmente necessário ao Samples.</summary>
  TSampleApplicationCoordinator = class
  strict private
    procedure ConfigureComponentPage(const AComponent: TSampleComponent;
      const APage: TObject);
    procedure TextLabelFactoryRequested(ASender: TObject);
    procedure TextLabelFluentRequested(ASender: TObject);
    procedure OpenTextLabelFactory;
    procedure OpenTextLabelFluent;
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
  RickUIBuilder.Samples.Component.TextLabel,
  RickUIBuilder.Samples.Example.TextLabel.Factory,
  RickUIBuilder.Samples.Example.TextLabel.Fluent;

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
    ConfigureComponentPage(AComponent, LPage);
    LPage.ShowModal;
  finally
    LPage.Free;
  end;
  Result := Self;
end;

procedure TSampleApplicationCoordinator.ConfigureComponentPage(
  const AComponent: TSampleComponent; const APage: TObject);
begin
  if AComponent <> TSampleComponent.TextLabel then
    Exit;
  TComponentTextLabel(APage).OnFactoryExamples := TextLabelFactoryRequested;
  TComponentTextLabel(APage).OnFluentExamples := TextLabelFluentRequested;
end;

procedure TSampleApplicationCoordinator.TextLabelFactoryRequested(
  ASender: TObject);
begin
  OpenTextLabelFactory;
end;

procedure TSampleApplicationCoordinator.TextLabelFluentRequested(
  ASender: TObject);
begin
  OpenTextLabelFluent;
end;

procedure TSampleApplicationCoordinator.OpenTextLabelFactory;
var
  LPage: TExampleTextLabelFactory;
begin
  LPage := TExampleTextLabelFactory.Create(nil);
  try
    LPage.ShowModal;
  finally
    LPage.Free;
  end;
end;

procedure TSampleApplicationCoordinator.OpenTextLabelFluent;
var
  LPage: TExampleTextLabelFluent;
begin
  LPage := TExampleTextLabelFluent.Create(nil);
  try
    LPage.ShowModal;
  finally
    LPage.Free;
  end;
end;

end.
