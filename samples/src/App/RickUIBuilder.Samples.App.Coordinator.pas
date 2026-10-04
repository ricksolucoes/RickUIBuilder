{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.App.Coordinator                                       }
{                                                                              }
{ Esta unit coordena a abertura, integração e lifetime das Component Pages e   }
{ Sample Pages concretas, incluindo Divider Factory/Fluent como destinos reais.         }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Coordenar o fluxo global e o lifetime das páginas modais do Samples.        }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Encerra a aplicação, resolve a Component Page concreta e conecta somente    }
{  intenções com Sample Pages reais de Text / Label, Button, Badge e Divider    }
{  nas abordagens Factory e Fluent Builder.                                    }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - RickUIBuilder.Samples.App.Types                                           }
{      Identifica o componente solicitado na navegação.                        }
{  - RickUIBuilder.Samples.Component.Common                                    }
{      Fornece TComponentCommon e a metaclasse das Component Pages.            }
{  - RickUIBuilder.Samples.Component.*                                         }
{      Fornecem as seis Component Pages concretas.                             }
{  - RickUIBuilder.Samples.Example.TextLabel.Factory/Fluent                    }
{      Fornecem os destinos concretos de Text / Label.                         }
{  - RickUIBuilder.Samples.Example.Button.Factory/Fluent                       }
{      Fornecem os destinos concretos de Button.                               }
{  - RickUIBuilder.Samples.Example.Badge.Factory/Fluent                        }
{      Fornecem os destinos concretos de Badge.                                }
{  - RickUIBuilder.Samples.Example.Divider.Factory/Fluent                      }
{      Fornecem os destinos concretos de Divider.                              }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - Home/Presenter solicitam OpenComponent.                                   }
{  - OpenComponent cria a Component Page, conecta intenções disponíveis e      }
{    aguarda ShowModal.                                                        }
{  - Os callbacks abrem somente Sample Pages concretas existentes.             }
{  - Ao fechar a Sample Page, a Component Page correspondente volta a ativa.   }
{                                                                              }
{  Ownership / lifetime                                                        }
{  --------------------                                                        }
{  - Component Pages e Sample Pages são criadas sem Owner.                     }
{  - O Coordinator libera cada instância em bloco finally após ShowModal.      }
{  - Os callbacks armazenados pelas Component Pages são non-owning; o          }
{    Coordinator possui lifetime superior durante toda a navegação.            }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - Não contém controles, snippets ou regras visuais das pages.               }
{  - Só conhece destinos que realmente existem no código final.                }
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
    procedure ButtonFactoryRequested(ASender: TObject);
    procedure ButtonFluentRequested(ASender: TObject);
    procedure BadgeFactoryRequested(ASender: TObject);
    procedure BadgeFluentRequested(ASender: TObject);
    procedure DividerFactoryRequested(ASender: TObject);
    procedure DividerFluentRequested(ASender: TObject);
    procedure OpenTextLabelFactory;
    procedure OpenTextLabelFluent;
    procedure OpenButtonFactory;
    procedure OpenButtonFluent;
    procedure OpenBadgeFactory;
    procedure OpenBadgeFluent;
    procedure OpenDividerFactory;
    procedure OpenDividerFluent;
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
  RickUIBuilder.Samples.Example.Badge.Factory,
  RickUIBuilder.Samples.Example.Badge.Fluent,
  RickUIBuilder.Samples.Example.Button.Factory,
  RickUIBuilder.Samples.Example.Button.Fluent,
  RickUIBuilder.Samples.Example.Divider.Factory,
  RickUIBuilder.Samples.Example.Divider.Fluent,
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
  case AComponent of
    TSampleComponent.TextLabel:
      begin
        TComponentTextLabel(APage).OnFactoryExamples := TextLabelFactoryRequested;
        TComponentTextLabel(APage).OnFluentExamples := TextLabelFluentRequested;
      end;
    TSampleComponent.Button:
      begin
        TComponentButton(APage).OnFactoryExamples := ButtonFactoryRequested;
        TComponentButton(APage).OnFluentExamples := ButtonFluentRequested;
      end;
    TSampleComponent.Badge:
      begin
        TComponentBadge(APage).OnFactoryExamples := BadgeFactoryRequested;
        TComponentBadge(APage).OnFluentExamples := BadgeFluentRequested;
      end;
    TSampleComponent.Divider:
      begin
        TComponentDivider(APage).OnFactoryExamples := DividerFactoryRequested;
        TComponentDivider(APage).OnFluentExamples := DividerFluentRequested;
      end;
  end;
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

procedure TSampleApplicationCoordinator.ButtonFactoryRequested(
  ASender: TObject);
begin
  OpenButtonFactory;
end;

procedure TSampleApplicationCoordinator.ButtonFluentRequested(
  ASender: TObject);
begin
  OpenButtonFluent;
end;

procedure TSampleApplicationCoordinator.BadgeFactoryRequested(
  ASender: TObject);
begin
  OpenBadgeFactory;
end;

procedure TSampleApplicationCoordinator.BadgeFluentRequested(
  ASender: TObject);
begin
  OpenBadgeFluent;
end;

procedure TSampleApplicationCoordinator.DividerFactoryRequested(
  ASender: TObject);
begin
  OpenDividerFactory;
end;

procedure TSampleApplicationCoordinator.DividerFluentRequested(
  ASender: TObject);
begin
  OpenDividerFluent;
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

procedure TSampleApplicationCoordinator.OpenButtonFactory;
var
  LPage: TExampleButtonFactory;
begin
  LPage := TExampleButtonFactory.Create(nil);
  try
    LPage.ShowModal;
  finally
    LPage.Free;
  end;
end;

procedure TSampleApplicationCoordinator.OpenButtonFluent;
var
  LPage: TExampleButtonFluent;
begin
  LPage := TExampleButtonFluent.Create(nil);
  try
    LPage.ShowModal;
  finally
    LPage.Free;
  end;
end;

procedure TSampleApplicationCoordinator.OpenBadgeFactory;
var
  LPage: TExampleBadgeFactory;
begin
  LPage := TExampleBadgeFactory.Create(nil);
  try
    LPage.ShowModal;
  finally
    LPage.Free;
  end;
end;

procedure TSampleApplicationCoordinator.OpenBadgeFluent;
var
  LPage: TExampleBadgeFluent;
begin
  LPage := TExampleBadgeFluent.Create(nil);
  try
    LPage.ShowModal;
  finally
    LPage.Free;
  end;
end;

procedure TSampleApplicationCoordinator.OpenDividerFactory;
var
  LPage: TExampleDividerFactory;
begin
  LPage := TExampleDividerFactory.Create(nil);
  try
    LPage.ShowModal;
  finally
    LPage.Free;
  end;
end;

procedure TSampleApplicationCoordinator.OpenDividerFluent;
var
  LPage: TExampleDividerFluent;
begin
  LPage := TExampleDividerFluent.Create(nil);
  try
    LPage.ShowModal;
  finally
    LPage.Free;
  end;
end;

end.
