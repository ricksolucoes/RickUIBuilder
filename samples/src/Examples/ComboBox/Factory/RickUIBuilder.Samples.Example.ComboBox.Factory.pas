{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Example.ComboBox.Factory                              }
{                                                                              }
{ Coordena a página ComboBox - Factory com quinze exemplos funcionais.         }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Integrar navegação, conteúdo e execução dos exemplos Factory de ComboBox.   }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Configura layout 640x510, navegação de 180 px, sincroniza snippet/resultado }
{  e mantém o Runner durante callbacks of object.                              }
{                                                                              }
{  Dependências internas                                                       }
{  ---------------------                                                       }
{  - App.Types fornece TComboBoxFactoryExample.                                }
{  - Example.Common/Navigation/Style fornecem infraestrutura visual.           }
{  - Factory.Content fornece textos/snippets; Factory.Runner executa a API.    }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  Seleção lateral -> ShowExample -> Reset -> ClearResult -> Runner.Render.    }
{                                                                              }
{  Ownership / lifetime                                                        }
{  --------------------                                                        }
{  A página owns FRunner; ResultHost owns os resultados. O Runner é liberado   }
{  somente após inherited Destroy liberar a árvore visual e seus callbacks.    }
{                                                                              }
{  Restrições                                                                  }
{  ----------                                                                  }
{  Não contém regras de materialização do ComboBox nem classes runtime internas.}
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Manter enum, Content, Runner e navegação sincronizados.                     }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.Example.ComboBox.Factory;

interface

uses
  System.Classes,
  RickUIBuilder.Samples.App.Types,
  RickUIBuilder.Samples.Example.Common,
  RickUIBuilder.Samples.Example.Common.Navigation,
  RickUIBuilder.Samples.Example.Common.Style,
  RickUIBuilder.Samples.Example.ComboBox.Factory.Content,
  RickUIBuilder.Samples.Example.ComboBox.Factory.Runner;

type
  TExampleComboBoxFactory = class(TExampleCommon)
  strict private
    FRunner: TComboBoxFactoryRunner;
    function BuildNavigation: TExampleNavigationItem;
    function AddExampleItem(const AExample: TComboBoxFactoryExample): TExampleNavigationItem;
    procedure NavigationRequested(ASender: TObject);
    procedure ShowExample(const AExample: TComboBoxFactoryExample; const AItem: TExampleNavigationItem);
  strict protected
    procedure ConfigureLayout(var ALayout: TExamplePageLayout); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

const
  _PARENT_TITLE_ = 'ComboBox';
  _PAGE_TITLE_ = 'ComboBox - Factory';
  _PAGE_SUBTITLE_ = 'Listas, seleção e runtime com TRickUIBuilderFactory.CreateComboBox.';
  _PAGE_WIDTH_ = 640;
  _NAV_WIDTH_ = 180;

procedure TExampleComboBoxFactory.ConfigureLayout(var ALayout: TExamplePageLayout);
begin
  inherited ConfigureLayout(ALayout);
  ALayout.PageWidth := _PAGE_WIDTH_;
  ALayout.NavigationWidth := _NAV_WIDTH_;
end;

constructor TExampleComboBoxFactory.Create(AOwner: TComponent);
var
  LInitialItem: TExampleNavigationItem;
begin
  inherited Create(AOwner);
  FRunner := TComboBoxFactoryRunner.Create;
  ConfigurePage(_PARENT_TITLE_, _PAGE_TITLE_, _PAGE_SUBTITLE_);
  LInitialItem := BuildNavigation;
  ShowExample(TComboBoxFactoryExample.Basic, LInitialItem);
end;

destructor TExampleComboBoxFactory.Destroy;
begin
  inherited Destroy;
  FRunner.Free;
end;

function TExampleComboBoxFactory.BuildNavigation: TExampleNavigationItem;
var
  LExample: TComboBoxFactoryExample;
begin
  Result := nil;
  for LExample := Low(TComboBoxFactoryExample) to High(TComboBoxFactoryExample) do
    if LExample = TComboBoxFactoryExample.Basic then
      Result := AddExampleItem(LExample)
    else
      AddExampleItem(LExample);
end;

function TExampleComboBoxFactory.AddExampleItem(const AExample: TComboBoxFactoryExample): TExampleNavigationItem;
begin
  Result := AddNavigationItem(TComboBoxFactoryContent.Caption(AExample));
  Result.Tag := Ord(AExample);
  Result.OnClick := NavigationRequested;
end;

procedure TExampleComboBoxFactory.NavigationRequested(ASender: TObject);
var
  LItem: TExampleNavigationItem;
begin
  LItem := ASender as TExampleNavigationItem;
  ShowExample(TComboBoxFactoryExample(LItem.Tag), LItem);
end;

procedure TExampleComboBoxFactory.ShowExample(const AExample: TComboBoxFactoryExample;
  const AItem: TExampleNavigationItem);
begin
  SelectNavigationItem(AItem);
  SetExampleIdentity(TComboBoxFactoryContent.Title(AExample), TComboBoxFactoryContent.Description(AExample));
  SetCodeText(TComboBoxFactoryContent.Code(AExample));
  FRunner.Reset;
  ClearResult;
  FRunner.Render(AExample, ResultHost);
end;

end.
