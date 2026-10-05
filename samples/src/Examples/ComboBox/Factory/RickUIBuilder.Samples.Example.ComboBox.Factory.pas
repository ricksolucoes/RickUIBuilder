{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Example.ComboBox.Factory                              }
{                                                                              }
{ Esta unit coordena a página concreta ComboBox - Factory, criando a navegação }
{ dos sete exemplos comprováveis e delegando ao Runner a materialização real   }
{ do controle fechado no ResultHost.                                           }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Implementar a página concreta de exemplos do ComboBox usando a abordagem    }
{  Factory disponível no código atual.                                         }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Configura a Sample Page Base, cria a navegação dos exemplos Factory,        }
{  sincroniza conteúdo e solicita a execução real no ResultHost.               }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - RickUIBuilder.Samples.App.Types                                           }
{      Fornece TComboBoxFactoryExample compartilhado com Content e Runner.     }
{  - RickUIBuilder.Samples.Example.Common                                      }
{      Fornece TExampleCommon e a infraestrutura visual compartilhada.         }
{  - RickUIBuilder.Samples.Example.Common.Navigation                           }
{      Fornece TExampleNavigationItem retornado pela API protegida da base.    }
{  - RickUIBuilder.Samples.Example.ComboBox.Factory.Content                    }
{      Fornece captions, títulos, descrições e snippets dos exemplos.          }
{  - RickUIBuilder.Samples.Example.ComboBox.Factory.Runner                     }
{      Executa CreateComboBox diretamente no ResultHost.                       }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - O Coordinator cria esta página quando ComboBox solicita Factory.          }
{  - A seleção lateral atualiza identidade, snippet e resultado executável.    }
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
{  - Esta page conhece somente ComboBox na abordagem Factory.                  }
{  - A Factory atual cria o controle fechado; lista/popup não são simulados.   }
{  - Conteúdo textual e execução permanecem separados em units próprias.       }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Atualizar esta unit quando navegação ou coordenação dos exemplos desta      }
{  página mudar, sem antecipar capacidades ainda ausentes da Factory.          }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.Example.ComboBox.Factory;

interface

uses
  System.Classes,

  RickUIBuilder.Samples.App.Types,

  RickUIBuilder.Samples.Example.Common,
  RickUIBuilder.Samples.Example.Common.Navigation,
  RickUIBuilder.Samples.Example.ComboBox.Factory.Content;

type
  /// <summary>Página concreta de exemplos Factory de ComboBox.</summary>
  TExampleComboBoxFactory = class(TExampleCommon)
  strict private
    function BuildNavigation: TExampleNavigationItem;
    function AddExampleItem(
      const AExample: TComboBoxFactoryExample): TExampleNavigationItem;
    procedure NavigationRequested(ASender: TObject);
    procedure ShowExample(const AExample: TComboBoxFactoryExample;
      const AItem: TExampleNavigationItem);
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses
  RickUIBuilder.Samples.Example.ComboBox.Factory.Runner;

const
  _PARENT_TITLE_ = 'ComboBox';
  _PAGE_TITLE_ = 'ComboBox - Factory';
  _PAGE_SUBTITLE_ = 'Criação direta do controle fechado com TRickUIBuilderFactory.CreateComboBox.';

constructor TExampleComboBoxFactory.Create(AOwner: TComponent);
var
  LInitialItem: TExampleNavigationItem;
begin
  inherited Create(AOwner);
  ConfigurePage(_PARENT_TITLE_, _PAGE_TITLE_, _PAGE_SUBTITLE_);
  LInitialItem := BuildNavigation;
  ShowExample(TComboBoxFactoryExample.Basic, LInitialItem);
end;

function TExampleComboBoxFactory.BuildNavigation: TExampleNavigationItem;
var
  LExample: TComboBoxFactoryExample;
begin
  Result := nil;
  for LExample := Low(TComboBoxFactoryExample) to High(TComboBoxFactoryExample) do
  begin
    if LExample = TComboBoxFactoryExample.Basic then
      Result := AddExampleItem(LExample)
    else
      AddExampleItem(LExample);
  end;
end;

function TExampleComboBoxFactory.AddExampleItem(
  const AExample: TComboBoxFactoryExample): TExampleNavigationItem;
begin
  Result := AddNavigationItem(TComboBoxFactoryContent.Caption(AExample));
  Result.Tag := Ord(AExample);
  Result.OnClick := NavigationRequested;
end;

procedure TExampleComboBoxFactory.NavigationRequested(ASender: TObject);
var
  LItem: TExampleNavigationItem;
  LExample: TComboBoxFactoryExample;
begin
  LItem := ASender as TExampleNavigationItem;
  LExample := TComboBoxFactoryExample(LItem.Tag);
  ShowExample(LExample, LItem);
end;

procedure TExampleComboBoxFactory.ShowExample(
  const AExample: TComboBoxFactoryExample; const AItem: TExampleNavigationItem);
begin
  SelectNavigationItem(AItem);
  SetExampleIdentity(TComboBoxFactoryContent.Title(AExample),
    TComboBoxFactoryContent.Description(AExample));
  SetCodeText(TComboBoxFactoryContent.Code(AExample));
  ClearResult;
  TComboBoxFactoryRunner.Render(AExample, ResultHost);
end;

end.
