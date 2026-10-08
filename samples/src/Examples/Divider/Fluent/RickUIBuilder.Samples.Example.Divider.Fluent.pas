{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Example.Divider.Fluent                                }
{                                                                              }
{ Esta unit coordena a página Divider - Fluent Builder, criando a navegação    }
{ dos nove exemplos, sincronizando conteúdo/snippet e delegando ao Runner a    }
{ materialização real no ResultHost.                                           }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Implementar a página concreta de exemplos de Divider usando a abordagem     }
{  Fluent Builder da API pública Rick.UIBuilder.                               }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Configura a Sample Page Base, cria a navegação dos exemplos Fluent,         }
{  sincroniza título/descrição/snippet e solicita a execução real no           }
{  ResultHost por meio de TRickUIBuilder.Divider.                              }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - RickUIBuilder.Samples.App.Types                                           }
{      Fornece TDividerFluentExample compartilhado com Content e Runner.       }
{  - RickUIBuilder.Samples.Example.Common                                      }
{      Fornece TExampleCommon e a infraestrutura visual compartilhada.         }
{  - RickUIBuilder.Samples.Example.Common.Navigation                           }
{      Fornece TExampleNavigationItem retornado pela API protegida da base.    }
{  - RickUIBuilder.Samples.Example.Common.Style                                }
{      Fornece TExamplePageLayout usado na especialização local da geometria.  }
{  - RickUIBuilder.Samples.Example.Divider.Fluent.Content                      }
{      Fornece captions, títulos, descrições e snippets dos exemplos.          }
{  - RickUIBuilder.Samples.Example.Divider.Fluent.Runner                       }
{      Executa a API Fluent real no ResultHost.                                }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - O Coordinator cria esta página quando Divider solicita Fluent Builder.    }
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
{  - Esta page conhece somente Divider na abordagem Fluent Builder.            }
{  - Não contém implementação Factory nem exemplos de outro componente.        }
{  - Conteúdo textual e execução permanecem separados em units próprias.       }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Atualizar esta unit quando navegação ou coordenação dos exemplos desta      }
{  página mudar, sem mover conteúdo/execução para a View.                      }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.Example.Divider.Fluent;

interface

uses
  System.Classes,

  RickUIBuilder.Samples.App.Types,

  RickUIBuilder.Samples.Example.Common,
  RickUIBuilder.Samples.Example.Common.Navigation,
  RickUIBuilder.Samples.Example.Common.Style,
  RickUIBuilder.Samples.Example.Divider.Fluent.Content;

type
  /// <summary>Página concreta de exemplos Fluent Builder de Divider.</summary>
  TExampleDividerFluent = class(TExampleCommon)
  strict private
    function BuildNavigation: TExampleNavigationItem;
    function AddExampleItem(
      const AExample: TDividerFluentExample): TExampleNavigationItem;
    procedure NavigationRequested(ASender: TObject);
    procedure ShowExample(const AExample: TDividerFluentExample;
      const AItem: TExampleNavigationItem);
  strict protected
    procedure ConfigureLayout(var ALayout: TExamplePageLayout); override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses
  RickUIBuilder.Samples.Example.Divider.Fluent.Runner;

const
  _PARENT_TITLE_ = 'Divider';
  _PAGE_TITLE_ = 'Divider - Fluent Builder';
  _PAGE_SUBTITLE_ = 'Criação encadeada de separadores com TRickUIBuilder.Divider.';
  _DIVIDER_FLUENT_PAGE_WIDTH_ = 640;
  _DIVIDER_FLUENT_NAV_WIDTH_ = 170;

procedure TExampleDividerFluent.ConfigureLayout(
  var ALayout: TExamplePageLayout);
begin
  inherited ConfigureLayout(ALayout);
  ALayout.PageWidth := _DIVIDER_FLUENT_PAGE_WIDTH_;
  ALayout.NavigationWidth := _DIVIDER_FLUENT_NAV_WIDTH_;
end;

constructor TExampleDividerFluent.Create(AOwner: TComponent);
var
  LInitialItem: TExampleNavigationItem;
begin
  inherited Create(AOwner);
  ConfigurePage(_PARENT_TITLE_, _PAGE_TITLE_, _PAGE_SUBTITLE_);
  LInitialItem := BuildNavigation;
  ShowExample(TDividerFluentExample.Basic, LInitialItem);
end;

function TExampleDividerFluent.BuildNavigation: TExampleNavigationItem;
var
  LExample: TDividerFluentExample;
begin
  Result := nil;
  for LExample := Low(TDividerFluentExample) to High(TDividerFluentExample) do
  begin
    if LExample = TDividerFluentExample.Basic then
      Result := AddExampleItem(LExample)
    else
      AddExampleItem(LExample);
  end;
end;

function TExampleDividerFluent.AddExampleItem(
  const AExample: TDividerFluentExample): TExampleNavigationItem;
begin
  Result := AddNavigationItem(TDividerFluentContent.Caption(AExample));
  Result.Tag := Ord(AExample);
  Result.OnClick := NavigationRequested;
end;

procedure TExampleDividerFluent.NavigationRequested(ASender: TObject);
var
  LItem: TExampleNavigationItem;
  LExample: TDividerFluentExample;
begin
  LItem := ASender as TExampleNavigationItem;
  LExample := TDividerFluentExample(LItem.Tag);
  ShowExample(LExample, LItem);
end;

procedure TExampleDividerFluent.ShowExample(
  const AExample: TDividerFluentExample; const AItem: TExampleNavigationItem);
begin
  SelectNavigationItem(AItem);
  SetExampleIdentity(TDividerFluentContent.Title(AExample),
    TDividerFluentContent.Description(AExample));
  SetCodeText(TDividerFluentContent.Code(AExample));
  ClearResult;
  TDividerFluentRunner.Render(AExample, ResultHost);
end;

end.
