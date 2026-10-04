{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Example.Divider.Factory                               }
{                                                                              }
{ Esta unit coordena a página concreta Divider - Factory, criando a navegação  }
{ dos quatro exemplos, sincronizando título/descrição/snippet e delegando ao   }
{ Runner a materialização real no ResultHost.                                  }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Implementar a página concreta de exemplos do componente Divider usando a    }
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
{      Fornece TDividerFactoryExample compartilhado com Content e Runner.      }
{  - RickUIBuilder.Samples.Example.Common                                      }
{      Fornece TExampleCommon e a infraestrutura visual compartilhada.         }
{  - RickUIBuilder.Samples.Example.Common.Navigation                           }
{      Fornece TExampleNavigationItem retornado pela API protegida da base.    }
{  - RickUIBuilder.Samples.Example.Divider.Factory.Content                     }
{      Fornece captions, títulos, descrições e snippets dos exemplos.          }
{  - RickUIBuilder.Samples.Example.Divider.Factory.Runner                      }
{      Executa a API Factory real de Divider no ResultHost.                    }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - O Coordinator cria esta página quando Divider solicita Factory.           }
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
{  - Esta page conhece somente Divider na abordagem Factory.                   }
{  - Não contém implementação Fluent Builder nem exemplos de outro componente. }
{  - Conteúdo textual e execução permanecem separados em units próprias.       }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Atualizar esta unit quando navegação ou coordenação dos exemplos desta      }
{  página mudar, sem mover conteúdo/execução para a View.                      }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.Example.Divider.Factory;

interface

uses
  System.Classes,

  RickUIBuilder.Samples.App.Types,

  RickUIBuilder.Samples.Example.Common,
  RickUIBuilder.Samples.Example.Common.Navigation,
  RickUIBuilder.Samples.Example.Divider.Factory.Content;

type
  /// <summary>Página concreta de exemplos Factory de Divider.</summary>
  TExampleDividerFactory = class(TExampleCommon)
  strict private
    function BuildNavigation: TExampleNavigationItem;
    function AddExampleItem(
      const AExample: TDividerFactoryExample): TExampleNavigationItem;
    procedure NavigationRequested(ASender: TObject);
    procedure ShowExample(const AExample: TDividerFactoryExample;
      const AItem: TExampleNavigationItem);
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses
  RickUIBuilder.Samples.Example.Divider.Factory.Runner;

const
  _PARENT_TITLE_ = 'Divider';
  _PAGE_TITLE_ = 'Divider - Factory';
  _PAGE_SUBTITLE_ = 'Criação direta de separadores horizontais com TRickUIBuilderFactory.CreateDivider.';

constructor TExampleDividerFactory.Create(AOwner: TComponent);
var
  LInitialItem: TExampleNavigationItem;
begin
  inherited Create(AOwner);
  ConfigurePage(_PARENT_TITLE_, _PAGE_TITLE_, _PAGE_SUBTITLE_);
  LInitialItem := BuildNavigation;
  ShowExample(TDividerFactoryExample.Basic, LInitialItem);
end;

function TExampleDividerFactory.BuildNavigation: TExampleNavigationItem;
var
  LExample: TDividerFactoryExample;
begin
  Result := nil;
  for LExample := Low(TDividerFactoryExample) to High(TDividerFactoryExample) do
  begin
    if LExample = TDividerFactoryExample.Basic then
      Result := AddExampleItem(LExample)
    else
      AddExampleItem(LExample);
  end;
end;

function TExampleDividerFactory.AddExampleItem(
  const AExample: TDividerFactoryExample): TExampleNavigationItem;
begin
  Result := AddNavigationItem(TDividerFactoryContent.Caption(AExample));
  Result.Tag := Ord(AExample);
  Result.OnClick := NavigationRequested;
end;

procedure TExampleDividerFactory.NavigationRequested(ASender: TObject);
var
  LItem: TExampleNavigationItem;
  LExample: TDividerFactoryExample;
begin
  LItem := ASender as TExampleNavigationItem;
  LExample := TDividerFactoryExample(LItem.Tag);
  ShowExample(LExample, LItem);
end;

procedure TExampleDividerFactory.ShowExample(
  const AExample: TDividerFactoryExample; const AItem: TExampleNavigationItem);
begin
  SelectNavigationItem(AItem);
  SetExampleIdentity(TDividerFactoryContent.Title(AExample),
    TDividerFactoryContent.Description(AExample));
  SetCodeText(TDividerFactoryContent.Code(AExample));
  ClearResult;
  TDividerFactoryRunner.Render(AExample, ResultHost);
end;

end.
