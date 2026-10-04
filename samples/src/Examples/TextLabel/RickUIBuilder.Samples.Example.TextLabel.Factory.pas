{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Example.TextLabel.Factory                             }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Implementar a primeira página concreta de exemplos do Samples:              }
{  Text / Label usando a abordagem Factory.                                    }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Configura a Sample Page Base, cria a navegação dos exemplos Factory,        }
{  sincroniza título/descrição/snippet e solicita a execução real no ResultHost.}
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - RickUIBuilder.Samples.Example.Common                                      }
{      Fornece TExampleCommon e a infraestrutura visual compartilhada.         }
{  - RickUIBuilder.Samples.Example.Common.Navigation                           }
{      Fornece TExampleNavigationItem retornado pela API protegida da base.    }
{  - RickUIBuilder.Samples.Example.TextLabel.Factory.Content                   }
{      Fornece conteúdo e identificação dos exemplos desta página.             }
{  - RickUIBuilder.Samples.Example.TextLabel.Factory.Runner                    }
{      Executa a Factory real no ResultHost.                                   }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - O Coordinator cria esta página quando Text / Label solicita Factory.      }
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
{  - Esta page conhece somente Text / Label na abordagem Factory.              }
{  - Não contém implementação Fluent Builder nem exemplos de outro componente.}
{  - Conteúdo textual e execução permanecem separados em units próprias.       }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Atualizar esta unit quando navegação ou coordenação dos exemplos desta      }
{  página mudar, sem mover conteúdo/execução para a View.                      }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.Example.TextLabel.Factory;

interface

uses
  System.Classes,

  RickUIBuilder.Samples.App.Types,

  RickUIBuilder.Samples.Example.Common,
  RickUIBuilder.Samples.Example.Common.Navigation,
  RickUIBuilder.Samples.Example.TextLabel.Factory.Content;

type
  /// <summary>Página concreta de exemplos Factory de Text / Label.</summary>
  TExampleTextLabelFactory = class(TExampleCommon)
  strict private
    function BuildNavigation: TExampleNavigationItem;
    function AddExampleItem(const AExample: TTextLabelFactoryExample): TExampleNavigationItem;
    procedure NavigationRequested(ASender: TObject);
    procedure ShowExample(const AExample: TTextLabelFactoryExample;
      const AItem: TExampleNavigationItem);
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses
  RickUIBuilder.Samples.Example.TextLabel.Factory.Runner;

const
  _PARENT_TITLE_ = 'Text / Label';
  _PAGE_TITLE_ = 'Text / Label - Factory';
  _PAGE_SUBTITLE_ = 'Criação direta de TLabel com TRickUIBuilderFactory.CreateText.';

constructor TExampleTextLabelFactory.Create(AOwner: TComponent);
var
  LInitialItem: TExampleNavigationItem;
begin
  inherited Create(AOwner);
  ConfigurePage(_PARENT_TITLE_, _PAGE_TITLE_, _PAGE_SUBTITLE_);
  LInitialItem := BuildNavigation;
  ShowExample(TTextLabelFactoryExample.Basic, LInitialItem);
end;

function TExampleTextLabelFactory.BuildNavigation: TExampleNavigationItem;
var
  LExample: TTextLabelFactoryExample;
begin
  Result := nil;
  for LExample := Low(TTextLabelFactoryExample) to High(TTextLabelFactoryExample) do
  begin
    if LExample = TTextLabelFactoryExample.Basic then
      Result := AddExampleItem(LExample)
    else
      AddExampleItem(LExample);
  end;
end;

function TExampleTextLabelFactory.AddExampleItem(
  const AExample: TTextLabelFactoryExample): TExampleNavigationItem;
begin
  Result := AddNavigationItem(TTextLabelFactoryContent.Caption(AExample));
  Result.Tag := Ord(AExample);
  Result.OnClick := NavigationRequested;
end;

procedure TExampleTextLabelFactory.NavigationRequested(ASender: TObject);
var
  LItem: TExampleNavigationItem;
  LExample: TTextLabelFactoryExample;
begin
  LItem := ASender as TExampleNavigationItem;
  LExample := TTextLabelFactoryExample(LItem.Tag);
  ShowExample(LExample, LItem);
end;

procedure TExampleTextLabelFactory.ShowExample(
  const AExample: TTextLabelFactoryExample; const AItem: TExampleNavigationItem);
begin
  SelectNavigationItem(AItem);
  SetExampleIdentity(TTextLabelFactoryContent.Title(AExample),
    TTextLabelFactoryContent.Description(AExample));
  SetCodeText(TTextLabelFactoryContent.Code(AExample));
  ClearResult;
  TTextLabelFactoryRunner.Render(AExample, ResultHost);
end;

end.
