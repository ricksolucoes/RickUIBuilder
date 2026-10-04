{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Example.Badge.Factory                                 }
{                                                                              }
{ Esta unit coordena a página concreta Badge - Factory, criando a navegação    }
{ dos sete exemplos, sincronizando título/descrição/snippet e delegando ao     }
{ Runner a materialização real no ResultHost.                                  }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Implementar a página concreta de exemplos do componente Badge usando a      }
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
{      Fornece TBadgeFactoryExample compartilhado com Content e Runner.        }
{  - RickUIBuilder.Samples.Example.Common                                      }
{      Fornece TExampleCommon e a infraestrutura visual compartilhada.         }
{  - RickUIBuilder.Samples.Example.Common.Navigation                           }
{      Fornece TExampleNavigationItem retornado pela API protegida da base.    }
{  - RickUIBuilder.Samples.Example.Badge.Factory.Content                       }
{      Fornece captions, títulos, descrições e snippets dos exemplos.          }
{  - RickUIBuilder.Samples.Example.Badge.Factory.Runner                        }
{      Executa a API Factory real de Badge no ResultHost.                      }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - O Coordinator cria esta página quando Badge solicita Factory.             }
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
{  - Esta page conhece somente Badge na abordagem Factory.                     }
{  - Não contém implementação Fluent Builder nem exemplos de outro componente. }
{  - Conteúdo textual e execução permanecem separados em units próprias.       }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Atualizar esta unit quando navegação ou coordenação dos exemplos desta      }
{  página mudar, sem mover conteúdo/execução para a View.                      }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.Example.Badge.Factory;

interface

uses
  System.Classes,

  RickUIBuilder.Samples.App.Types,

  RickUIBuilder.Samples.Example.Common,
  RickUIBuilder.Samples.Example.Common.Navigation,
  RickUIBuilder.Samples.Example.Badge.Factory.Content;

type
  /// <summary>Página concreta de exemplos Factory de Badge.</summary>
  TExampleBadgeFactory = class(TExampleCommon)
  strict private
    function BuildNavigation: TExampleNavigationItem;
    function AddExampleItem(
      const AExample: TBadgeFactoryExample): TExampleNavigationItem;
    procedure NavigationRequested(ASender: TObject);
    procedure ShowExample(const AExample: TBadgeFactoryExample;
      const AItem: TExampleNavigationItem);
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses
  RickUIBuilder.Samples.Example.Badge.Factory.Runner;

const
  _PARENT_TITLE_ = 'Badge';
  _PAGE_TITLE_ = 'Badge - Factory';
  _PAGE_SUBTITLE_ = 'Criação direta de TRectangle + TLabel com TRickUIBuilderFactory.CreateBadge.';

constructor TExampleBadgeFactory.Create(AOwner: TComponent);
var
  LInitialItem: TExampleNavigationItem;
begin
  inherited Create(AOwner);
  ConfigurePage(_PARENT_TITLE_, _PAGE_TITLE_, _PAGE_SUBTITLE_);
  LInitialItem := BuildNavigation;
  ShowExample(TBadgeFactoryExample.Basic, LInitialItem);
end;

function TExampleBadgeFactory.BuildNavigation: TExampleNavigationItem;
var
  LExample: TBadgeFactoryExample;
begin
  Result := nil;
  for LExample := Low(TBadgeFactoryExample) to High(TBadgeFactoryExample) do
  begin
    if LExample = TBadgeFactoryExample.Basic then
      Result := AddExampleItem(LExample)
    else
      AddExampleItem(LExample);
  end;
end;

function TExampleBadgeFactory.AddExampleItem(
  const AExample: TBadgeFactoryExample): TExampleNavigationItem;
begin
  Result := AddNavigationItem(TBadgeFactoryContent.Caption(AExample));
  Result.Tag := Ord(AExample);
  Result.OnClick := NavigationRequested;
end;

procedure TExampleBadgeFactory.NavigationRequested(ASender: TObject);
var
  LItem: TExampleNavigationItem;
  LExample: TBadgeFactoryExample;
begin
  LItem := ASender as TExampleNavigationItem;
  LExample := TBadgeFactoryExample(LItem.Tag);
  ShowExample(LExample, LItem);
end;

procedure TExampleBadgeFactory.ShowExample(
  const AExample: TBadgeFactoryExample; const AItem: TExampleNavigationItem);
begin
  SelectNavigationItem(AItem);
  SetExampleIdentity(TBadgeFactoryContent.Title(AExample),
    TBadgeFactoryContent.Description(AExample));
  SetCodeText(TBadgeFactoryContent.Code(AExample));
  ClearResult;
  TBadgeFactoryRunner.Render(AExample, ResultHost);
end;

end.
