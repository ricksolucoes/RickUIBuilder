{ Esta unit coordena a página concreta Button - Factory, criando a navegação dos oito exemplos, sincronizando título/descrição/snippet e delegando ao Runner a materialização e a interação real no ResultHost. }
{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Example.Button.Factory                                }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Implementar a página concreta de exemplos do componente Button usando a     }
{  abordagem Factory.                                                          }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Configura a Sample Page Base, cria a navegação dos exemplos Factory,        }
{  sincroniza conteúdo e solicita a execução real no ResultHost.               }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - RickUIBuilder.Samples.App.Types                                           }
{      Fornece TButtonFactoryExample compartilhado com Content e Runner.       }
{  - RickUIBuilder.Samples.Example.Common                                      }
{      Fornece TExampleCommon e a infraestrutura visual compartilhada.         }
{  - RickUIBuilder.Samples.Example.Common.Navigation                           }
{      Fornece TExampleNavigationItem retornado pela API protegida da base.    }
{  - RickUIBuilder.Samples.Example.Button.Factory.Content                      }
{      Fornece captions, títulos, descrições e snippets dos exemplos.          }
{  - RickUIBuilder.Samples.Example.Button.Factory.Runner                       }
{      Executa TRickUIBuilderFactory.CreateButton e a interação de clique.     }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - O Coordinator cria esta página quando Button solicita Factory.            }
{  - A seleção lateral atualiza estado visual, conteúdo e resultado executável.}
{  - Back é herdado da base e fecha somente esta modal.                        }
{                                                                              }
{  Ownership / lifetime                                                        }
{  --------------------                                                        }
{  - O Coordinator cria a página sem Owner e a libera após ShowModal.          }
{  - Os itens de navegação pertencem à árvore visual da base.                  }
{  - Os resultados são owned por ResultHost e substituídos via ClearResult.    }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - Esta page conhece somente Button na abordagem Factory.                    }
{  - Não contém implementação Fluent Builder nem exemplos de outro componente.}
{  - Conteúdo textual e execução permanecem separados em units próprias.       }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Atualizar esta unit quando navegação ou coordenação dos exemplos desta      }
{  página mudar, sem mover conteúdo/execução para a View.                      }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.Example.Button.Factory;

interface

uses
  System.Classes,

  RickUIBuilder.Samples.App.Types,

  RickUIBuilder.Samples.Example.Common,
  RickUIBuilder.Samples.Example.Common.Navigation,
  RickUIBuilder.Samples.Example.Button.Factory.Content;

type
  /// <summary>Página concreta de exemplos Factory de Button.</summary>
  TExampleButtonFactory = class(TExampleCommon)
  strict private
    function BuildNavigation: TExampleNavigationItem;
    function AddExampleItem(
      const AExample: TButtonFactoryExample): TExampleNavigationItem;
    procedure NavigationRequested(ASender: TObject);
    procedure ShowExample(const AExample: TButtonFactoryExample;
      const AItem: TExampleNavigationItem);
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses
  RickUIBuilder.Samples.Example.Button.Factory.Runner;

const
  _PARENT_TITLE_ = 'Button';
  _PAGE_TITLE_ = 'Button - Factory';
  _PAGE_SUBTITLE_ = 'Criação direta de TRectangle + TLabel com TRickUIBuilderFactory.CreateButton.';

constructor TExampleButtonFactory.Create(AOwner: TComponent);
var
  LInitialItem: TExampleNavigationItem;
begin
  inherited Create(AOwner);
  ConfigurePage(_PARENT_TITLE_, _PAGE_TITLE_, _PAGE_SUBTITLE_);
  LInitialItem := BuildNavigation;
  ShowExample(TButtonFactoryExample.Basic, LInitialItem);
end;

function TExampleButtonFactory.BuildNavigation: TExampleNavigationItem;
var
  LExample: TButtonFactoryExample;
begin
  Result := nil;
  for LExample := Low(TButtonFactoryExample) to High(TButtonFactoryExample) do
  begin
    if LExample = TButtonFactoryExample.Basic then
      Result := AddExampleItem(LExample)
    else
      AddExampleItem(LExample);
  end;
end;

function TExampleButtonFactory.AddExampleItem(
  const AExample: TButtonFactoryExample): TExampleNavigationItem;
begin
  Result := AddNavigationItem(TButtonFactoryContent.Caption(AExample));
  Result.Tag := Ord(AExample);
  Result.OnClick := NavigationRequested;
end;

procedure TExampleButtonFactory.NavigationRequested(ASender: TObject);
var
  LItem: TExampleNavigationItem;
  LExample: TButtonFactoryExample;
begin
  LItem := ASender as TExampleNavigationItem;
  LExample := TButtonFactoryExample(LItem.Tag);
  ShowExample(LExample, LItem);
end;

procedure TExampleButtonFactory.ShowExample(
  const AExample: TButtonFactoryExample; const AItem: TExampleNavigationItem);
begin
  SelectNavigationItem(AItem);
  SetExampleIdentity(TButtonFactoryContent.Title(AExample),
    TButtonFactoryContent.Description(AExample));
  SetCodeText(TButtonFactoryContent.Code(AExample));
  ClearResult;
  TButtonFactoryRunner.Render(AExample, ResultHost);
end;

end.
