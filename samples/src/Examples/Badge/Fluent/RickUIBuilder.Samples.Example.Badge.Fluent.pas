{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Example.Badge.Fluent                                  }
{                                                                              }
{ Esta unit coordena a página Badge - Fluent Builder, criando a navegação dos  }
{ onze TBadgeFluentExample compartilhados, sincronizando conteúdo/snippet e    }
{ delegando ao Runner a materialização do resultado no ResultHost.             }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Implementar a página concreta de exemplos de Badge usando a abordagem       }
{  Fluent Builder da API pública Rick.UIBuilder.                               }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Configura a Sample Page Base, cria a navegação dos exemplos Fluent,         }
{  sincroniza título/descrição/snippet e solicita a execução real no           }
{  ResultHost por meio de TRickUIBuilder.Badge.                                }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - RickUIBuilder.Samples.App.Types                                           }
{      Fornece TBadgeFluentExample compartilhado com Content e Runner.         }
{  - RickUIBuilder.Samples.Example.Common                                      }
{      Fornece TExampleCommon e a infraestrutura visual compartilhada.         }
{  - RickUIBuilder.Samples.Example.Common.Navigation                           }
{      Fornece TExampleNavigationItem retornado pela API protegida da base.    }
{  - RickUIBuilder.Samples.Example.Common.Style                                }
{      Fornece TExamplePageLayout usado na especialização local da geometria.  }
{  - RickUIBuilder.Samples.Example.Badge.Fluent.Content                        }
{      Fornece captions, títulos, descrições e snippets dos exemplos.          }
{  - RickUIBuilder.Samples.Example.Badge.Fluent.Runner                         }
{      Executa a API Fluent real no ResultHost.                                }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - O Coordinator cria esta página quando Badge solicita Fluent Builder.      }
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
{  - Esta page conhece somente Badge na abordagem Fluent Builder.              }
{  - Não contém implementação Factory nem exemplos de outro componente.        }
{  - Conteúdo textual e execução permanecem separados em units próprias.       }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Atualizar esta unit quando navegação ou coordenação dos exemplos desta      }
{  página mudar, sem mover conteúdo/execução para a View.                      }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.Example.Badge.Fluent;

interface

uses
  System.Classes,

  RickUIBuilder.Samples.App.Types,

  RickUIBuilder.Samples.Example.Common,
  RickUIBuilder.Samples.Example.Common.Navigation,
  RickUIBuilder.Samples.Example.Common.Style,
  RickUIBuilder.Samples.Example.Badge.Fluent.Content;

type
  /// <summary>Página concreta de exemplos Fluent Builder de Badge.</summary>
  TExampleBadgeFluent = class(TExampleCommon)
  strict private
    function BuildNavigation: TExampleNavigationItem;
    function AddExampleItem(
      const AExample: TBadgeFluentExample): TExampleNavigationItem;
    procedure NavigationRequested(ASender: TObject);
    procedure ShowExample(const AExample: TBadgeFluentExample;
      const AItem: TExampleNavigationItem);
  strict protected
    procedure ConfigureLayout(var ALayout: TExamplePageLayout); override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses
  RickUIBuilder.Samples.Example.Badge.Fluent.Runner;

const
  _PARENT_TITLE_ = 'Badge';
  _PAGE_TITLE_ = 'Badge - Fluent Builder';
  _PAGE_SUBTITLE_ = 'Criação encadeada de Badge com TRickUIBuilder.Badge.';
  _BADGE_FLUENT_PAGE_WIDTH_ = 640;
  _BADGE_FLUENT_NAV_WIDTH_ = 170;

procedure TExampleBadgeFluent.ConfigureLayout(
  var ALayout: TExamplePageLayout);
begin
  inherited ConfigureLayout(ALayout);
  ALayout.PageWidth := _BADGE_FLUENT_PAGE_WIDTH_;
  ALayout.NavigationWidth := _BADGE_FLUENT_NAV_WIDTH_;
end;

constructor TExampleBadgeFluent.Create(AOwner: TComponent);
var
  LInitialItem: TExampleNavigationItem;
begin
  inherited Create(AOwner);
  ConfigurePage(_PARENT_TITLE_, _PAGE_TITLE_, _PAGE_SUBTITLE_);
  LInitialItem := BuildNavigation;
  ShowExample(TBadgeFluentExample.Basic, LInitialItem);
end;

function TExampleBadgeFluent.BuildNavigation: TExampleNavigationItem;
var
  LExample: TBadgeFluentExample;
begin
  Result := nil;
  for LExample := Low(TBadgeFluentExample) to High(TBadgeFluentExample) do
  begin
    if LExample = TBadgeFluentExample.Basic then
      Result := AddExampleItem(LExample)
    else
      AddExampleItem(LExample);
  end;
end;

function TExampleBadgeFluent.AddExampleItem(
  const AExample: TBadgeFluentExample): TExampleNavigationItem;
begin
  Result := AddNavigationItem(TBadgeFluentContent.Caption(AExample));
  Result.Tag := Ord(AExample);
  Result.OnClick := NavigationRequested;
end;

procedure TExampleBadgeFluent.NavigationRequested(ASender: TObject);
var
  LItem: TExampleNavigationItem;
  LExample: TBadgeFluentExample;
begin
  LItem := ASender as TExampleNavigationItem;
  LExample := TBadgeFluentExample(LItem.Tag);
  ShowExample(LExample, LItem);
end;

procedure TExampleBadgeFluent.ShowExample(
  const AExample: TBadgeFluentExample; const AItem: TExampleNavigationItem);
begin
  SelectNavigationItem(AItem);
  SetExampleIdentity(TBadgeFluentContent.Title(AExample),
    TBadgeFluentContent.Description(AExample));
  SetCodeText(TBadgeFluentContent.Code(AExample));
  ClearResult;
  TBadgeFluentRunner.Render(AExample, ResultHost);
end;

end.
