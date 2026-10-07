{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Example.ComboBox.Fluent                               }
{                                                                              }
{ Esta unit coordena a página ComboBox - Fluent Builder, mantendo navegação,   }
{ conteúdo e execução separados e preservando o Runner durante os callbacks.   }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Implementar a página concreta de exemplos de ComboBox usando a abordagem    }
{  Fluent Builder da API pública Rick.UIBuilder.                               }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Configura a Sample Page Base, cria a navegação de quinze exemplos Fluent,   }
{  sincroniza título/descrição/snippet e solicita a execução real com listas.  }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - RickUIBuilder.Samples.App.Types                                           }
{      Fornece TComboBoxFluentExample compartilhado com Content e Runner.      }
{  - RickUIBuilder.Samples.Example.Common                                      }
{      Fornece TExampleCommon e a infraestrutura visual compartilhada.         }
{  - RickUIBuilder.Samples.Example.Common.Navigation                           }
{      Fornece TExampleNavigationItem retornado pela API protegida da base.    }
{  - RickUIBuilder.Samples.Example.ComboBox.Fluent.Content                     }
{      Fornece captions, títulos, descrições e snippets dos exemplos.          }
{  - RickUIBuilder.Samples.Example.ComboBox.Fluent.Runner                      }
{      Executa a API Fluent real e recebe callbacks enquanto a página existe.  }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - O Coordinator cria esta página quando ComboBox solicita Fluent Builder.   }
{  - A seleção lateral atualiza identidade, snippet e resultado executável.    }
{  - Reset limpa referências non-owning antes de ClearResult destruir a view.  }
{                                                                              }
{  Ownership / lifetime                                                        }
{  --------------------                                                        }
{  - O Coordinator cria a página sem Owner e a libera após ShowModal.          }
{  - Os resultados visuais pertencem ao ResultHost.                            }
{  - A página mantém o Runner vivo enquanto controles com callbacks existirem. }
{  - O Runner é liberado após inherited Destroy liberar a árvore visual.       }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - Esta page conhece somente ComboBox na abordagem Fluent Builder.           }
{  - Não contém implementação Factory nem runtime concreto interno.            }
{  - Conteúdo textual e execução permanecem separados em units próprias.       }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Atualizar esta unit quando navegação, exemplos ou lifetime dos callbacks    }
{  mudarem, sem mover conteúdo ou execução para a View.                        }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.Example.ComboBox.Fluent;

interface

uses
  System.Classes,

  RickUIBuilder.Samples.App.Types,

  RickUIBuilder.Samples.Example.Common,
  RickUIBuilder.Samples.Example.Common.Navigation,
  RickUIBuilder.Samples.Example.ComboBox.Fluent.Content,
  RickUIBuilder.Samples.Example.ComboBox.Fluent.Runner;

type
  /// <summary>Página concreta de exemplos Fluent Builder de ComboBox.</summary>
  TExampleComboBoxFluent = class(TExampleCommon)
  strict private
    FRunner: TComboBoxFluentRunner;
    function BuildNavigation: TExampleNavigationItem;
    function AddExampleItem(
      const AExample: TComboBoxFluentExample): TExampleNavigationItem;
    procedure NavigationRequested(ASender: TObject);
    procedure ShowExample(const AExample: TComboBoxFluentExample;
      const AItem: TExampleNavigationItem);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

const
  _PARENT_TITLE_ = 'ComboBox';
  _PAGE_TITLE_ = 'ComboBox - Fluent Builder';
  _PAGE_SUBTITLE_ = 'Listas, seleção e runtime com TRickUIBuilder.ComboBox.';

constructor TExampleComboBoxFluent.Create(AOwner: TComponent);
var
  LInitialItem: TExampleNavigationItem;
begin
  inherited Create(AOwner);
  FRunner := TComboBoxFluentRunner.Create;
  ConfigurePage(_PARENT_TITLE_, _PAGE_TITLE_, _PAGE_SUBTITLE_);
  LInitialItem := BuildNavigation;
  ShowExample(TComboBoxFluentExample.Basic, LInitialItem);
end;

destructor TExampleComboBoxFluent.Destroy;
begin
  inherited Destroy;
  FRunner.Free;
end;

function TExampleComboBoxFluent.BuildNavigation: TExampleNavigationItem;
var
  LExample: TComboBoxFluentExample;
begin
  Result := nil;
  for LExample := Low(TComboBoxFluentExample) to High(TComboBoxFluentExample) do
  begin
    if LExample = TComboBoxFluentExample.Basic then
      Result := AddExampleItem(LExample)
    else
      AddExampleItem(LExample);
  end;
end;

function TExampleComboBoxFluent.AddExampleItem(
  const AExample: TComboBoxFluentExample): TExampleNavigationItem;
begin
  Result := AddNavigationItem(TComboBoxFluentContent.Caption(AExample));
  Result.Tag := Ord(AExample);
  Result.OnClick := NavigationRequested;
end;

procedure TExampleComboBoxFluent.NavigationRequested(ASender: TObject);
var
  LItem: TExampleNavigationItem;
  LExample: TComboBoxFluentExample;
begin
  LItem := ASender as TExampleNavigationItem;
  LExample := TComboBoxFluentExample(LItem.Tag);
  ShowExample(LExample, LItem);
end;

procedure TExampleComboBoxFluent.ShowExample(
  const AExample: TComboBoxFluentExample; const AItem: TExampleNavigationItem);
begin
  SelectNavigationItem(AItem);
  SetExampleIdentity(TComboBoxFluentContent.Title(AExample),
    TComboBoxFluentContent.Description(AExample));
  SetCodeText(TComboBoxFluentContent.Code(AExample));
  FRunner.Reset;
  ClearResult;
  FRunner.Render(AExample, ResultHost);
end;

end.
