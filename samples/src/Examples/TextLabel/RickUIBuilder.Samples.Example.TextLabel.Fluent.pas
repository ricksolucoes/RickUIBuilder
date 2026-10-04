{ Esta unit coordena a página concreta Text / Label - Fluent Builder, criando a navegação dos oito TTextLabelFluentExample compartilhados, sincronizando conteúdo/snippet e delegando ao Runner a materialização do resultado no ResultHost. }
{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Example.TextLabel.Fluent                              }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Implementar a página concreta de exemplos de Text / Label usando a          }
{  abordagem Fluent Builder da API pública Rick.UIBuilder.                     }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Configura a Sample Page Base, cria a navegação dos exemplos Fluent,         }
{  sincroniza título/descrição/snippet e solicita a execução real no           }
{  ResultHost por meio de TRickUIBuilder.Label_.                               }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - RickUIBuilder.Samples.App.Types                                           }
{      Fornece TTextLabelFluentExample compartilhado com Content e Runner.     }
{  - RickUIBuilder.Samples.Example.Common                                      }
{      Fornece TExampleCommon e a infraestrutura visual compartilhada.         }
{  - RickUIBuilder.Samples.Example.Common.Navigation                           }
{      Fornece TExampleNavigationItem retornado pela API protegida da base.    }
{  - RickUIBuilder.Samples.Example.TextLabel.Fluent.Content                    }
{      Fornece captions, títulos, descrições e snippets dos exemplos.          }
{  - RickUIBuilder.Samples.Example.TextLabel.Fluent.Runner                     }
{      Executa a API Fluent real no ResultHost.                                }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - O Coordinator cria esta página quando Text / Label solicita Fluent.       }
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
{  - Esta page conhece somente Text / Label na abordagem Fluent Builder.       }
{  - Não contém implementação Factory nem exemplos de outro componente.        }
{  - Conteúdo textual e execução permanecem separados em units próprias.       }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Atualizar esta unit quando navegação ou coordenação dos exemplos desta      }
{  página mudar, sem mover conteúdo/execução para a View.                      }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.Example.TextLabel.Fluent;

interface

uses
  System.Classes,
  RickUIBuilder.Samples.App.Types,
  RickUIBuilder.Samples.Example.Common,
  RickUIBuilder.Samples.Example.Common.Navigation,
  RickUIBuilder.Samples.Example.TextLabel.Fluent.Content;

type
  /// <summary>Página concreta de exemplos Fluent Builder de Text / Label.</summary>
  TExampleTextLabelFluent = class(TExampleCommon)
  strict private
    function BuildNavigation: TExampleNavigationItem;
    function AddExampleItem(const AExample: TTextLabelFluentExample): TExampleNavigationItem;
    procedure NavigationRequested(ASender: TObject);
    procedure ShowExample(const AExample: TTextLabelFluentExample;
      const AItem: TExampleNavigationItem);
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses
  RickUIBuilder.Samples.Example.TextLabel.Fluent.Runner;

const
  _PARENT_TITLE_ = 'Text / Label';
  _PAGE_TITLE_ = 'Text / Label - Fluent Builder';
  _PAGE_SUBTITLE_ = 'Criação encadeada de TLabel com TRickUIBuilder.Label_.';

constructor TExampleTextLabelFluent.Create(AOwner: TComponent);
var
  LInitialItem: TExampleNavigationItem;
begin
  inherited Create(AOwner);
  ConfigurePage(_PARENT_TITLE_, _PAGE_TITLE_, _PAGE_SUBTITLE_);
  LInitialItem := BuildNavigation;
  ShowExample(TTextLabelFluentExample.Basic, LInitialItem);
end;

function TExampleTextLabelFluent.BuildNavigation: TExampleNavigationItem;
var
  LExample: TTextLabelFluentExample;
begin
  Result := nil;
  for LExample := Low(TTextLabelFluentExample) to High(TTextLabelFluentExample) do
  begin
    if LExample = TTextLabelFluentExample.Basic then
      Result := AddExampleItem(LExample)
    else
      AddExampleItem(LExample);
  end;
end;

function TExampleTextLabelFluent.AddExampleItem(
  const AExample: TTextLabelFluentExample): TExampleNavigationItem;
begin
  Result := AddNavigationItem(TTextLabelFluentContent.Caption(AExample));
  Result.Tag := Ord(AExample);
  Result.OnClick := NavigationRequested;
end;

procedure TExampleTextLabelFluent.NavigationRequested(ASender: TObject);
var
  LItem: TExampleNavigationItem;
  LExample: TTextLabelFluentExample;
begin
  LItem := ASender as TExampleNavigationItem;
  LExample := TTextLabelFluentExample(LItem.Tag);
  ShowExample(LExample, LItem);
end;

procedure TExampleTextLabelFluent.ShowExample(
  const AExample: TTextLabelFluentExample; const AItem: TExampleNavigationItem);
begin
  SelectNavigationItem(AItem);
  SetExampleIdentity(TTextLabelFluentContent.Title(AExample),
    TTextLabelFluentContent.Description(AExample));
  SetCodeText(TTextLabelFluentContent.Code(AExample));
  ClearResult;
  TTextLabelFluentRunner.Render(AExample, ResultHost);
end;

end.
