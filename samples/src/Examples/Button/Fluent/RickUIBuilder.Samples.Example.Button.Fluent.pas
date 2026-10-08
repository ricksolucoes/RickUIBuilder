{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Example.Button.Fluent                                 }
{                                                                              }
{ Esta unit coordena a página Button - Fluent Builder, mantendo navegação,     }
{ conteúdo e execução separados e delegando ao Runner a materialização dos     }
{ doze exemplos no ResultHost.                                                 }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Implementar a página concreta de exemplos de Button usando a abordagem      }
{  Fluent Builder da API pública Rick.UIBuilder.                               }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Configura a Sample Page Base com layout especializado para a navegação      }
{  desta página, cria os exemplos Fluent e solicita a execução real no         }
{  ResultHost por meio de TRickUIBuilder.Button.                               }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - RickUIBuilder.Samples.App.Types                                           }
{      Fornece TButtonFluentExample compartilhado com Content e Runner.        }
{  - RickUIBuilder.Samples.Example.Common                                      }
{      Fornece TExampleCommon e a infraestrutura visual compartilhada.         }
{  - RickUIBuilder.Samples.Example.Common.Navigation                           }
{      Fornece TExampleNavigationItem retornado pela API protegida da base.    }
{  - RickUIBuilder.Samples.Example.Common.Style                                }
{      Fornece TExamplePageLayout especializado por herança nesta página.      }
{  - RickUIBuilder.Samples.Example.Button.Fluent.Content                       }
{      Fornece captions, títulos, descrições e snippets dos exemplos.          }
{  - RickUIBuilder.Samples.Example.Button.Fluent.Runner                        }
{      Executa a API Fluent real no ResultHost.                                }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - O Coordinator cria esta página quando Button solicita Fluent Builder.     }
{  - A seleção lateral atualiza estado visual, conteúdo e resultado executável.}
{  - Back é herdado da base e fecha somente esta modal.                        }
{                                                                              }
{  Ownership / lifetime                                                        }
{  --------------------                                                        }
{  - O Coordinator cria a página sem Owner e a libera após ShowModal.          }
{  - Os itens de navegação pertencem à árvore visual da base.                  }
{  - Os controles visuais são materializados diretamente no ResultHost.        }
{  - A página mantém uma instância do Runner durante todo o lifetime da modal. }
{  - O Runner é liberado após a árvore visual, preservando handlers até o fim. }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - Esta page conhece somente Button na abordagem Fluent Builder.             }
{  - Não contém implementação Factory nem exemplos de outro componente.        }
{  - Conteúdo textual e execução permanecem separados em units próprias.       }
{  - O Runner recebe os eventos dos exemplos sem depender de TComponent.       }
{  - Somente esta página amplia janela e navegação; as demais usam os defaults. }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Atualizar esta unit quando navegação ou coordenação dos exemplos desta      }
{  página mudar, sem mover conteúdo/execução para a View.                      }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.Example.Button.Fluent;

interface

uses
  System.Classes,
  RickUIBuilder.Samples.App.Types,
  RickUIBuilder.Samples.Example.Common,
  RickUIBuilder.Samples.Example.Common.Navigation,
  RickUIBuilder.Samples.Example.Common.Style,
  RickUIBuilder.Samples.Example.Button.Fluent.Content,
  RickUIBuilder.Samples.Example.Button.Fluent.Runner;

type
  /// <summary>Página concreta de exemplos Fluent Builder de Button.</summary>
  TExampleButtonFluent = class(TExampleCommon)
  strict private
    FRunner: TButtonFluentRunner;
    function BuildNavigation: TExampleNavigationItem;
    function AddExampleItem(const AExample: TButtonFluentExample): TExampleNavigationItem;
    procedure NavigationRequested(ASender: TObject);
    procedure ShowExample(const AExample: TButtonFluentExample;
      const AItem: TExampleNavigationItem);
  strict protected
    procedure ConfigureLayout(var ALayout: TExamplePageLayout); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

const
  _PARENT_TITLE_ = 'Button';
  _PAGE_TITLE_ = 'Button - Fluent Builder';
  _PAGE_SUBTITLE_ = 'Criação encadeada de Button com TRickUIBuilder.Button.';
  _BUTTON_FLUENT_PAGE_WIDTH_ = 640;
  _BUTTON_FLUENT_PAGE_HEIGHT_ = 530;
  _BUTTON_FLUENT_NAV_WIDTH_ = 170;

procedure TExampleButtonFluent.ConfigureLayout(
  var ALayout: TExamplePageLayout);
begin
  inherited ConfigureLayout(ALayout);
  ALayout.PageWidth := _BUTTON_FLUENT_PAGE_WIDTH_;
  ALayout.PageHeight := _BUTTON_FLUENT_PAGE_HEIGHT_;
  ALayout.NavigationWidth := _BUTTON_FLUENT_NAV_WIDTH_;
end;

constructor TExampleButtonFluent.Create(AOwner: TComponent);
var
  LInitialItem: TExampleNavigationItem;
begin
  inherited Create(AOwner);
  FRunner := TButtonFluentRunner.Create;
  ConfigurePage(_PARENT_TITLE_, _PAGE_TITLE_, _PAGE_SUBTITLE_);
  LInitialItem := BuildNavigation;
  ShowExample(TButtonFluentExample.Basic, LInitialItem);
end;


destructor TExampleButtonFluent.Destroy;
begin
  inherited Destroy;
  FRunner.Free;
end;

function TExampleButtonFluent.BuildNavigation: TExampleNavigationItem;
var
  LExample: TButtonFluentExample;
begin
  Result := nil;
  for LExample := Low(TButtonFluentExample) to High(TButtonFluentExample) do
  begin
    if LExample = TButtonFluentExample.Basic then
      Result := AddExampleItem(LExample)
    else
      AddExampleItem(LExample);
  end;
end;

function TExampleButtonFluent.AddExampleItem(
  const AExample: TButtonFluentExample): TExampleNavigationItem;
begin
  Result := AddNavigationItem(TButtonFluentContent.Caption(AExample));
  Result.Tag := Ord(AExample);
  Result.OnClick := NavigationRequested;
end;

procedure TExampleButtonFluent.NavigationRequested(ASender: TObject);
var
  LItem: TExampleNavigationItem;
  LExample: TButtonFluentExample;
begin
  LItem := ASender as TExampleNavigationItem;
  LExample := TButtonFluentExample(LItem.Tag);
  ShowExample(LExample, LItem);
end;

procedure TExampleButtonFluent.ShowExample(
  const AExample: TButtonFluentExample; const AItem: TExampleNavigationItem);
begin
  SelectNavigationItem(AItem);
  SetExampleIdentity(TButtonFluentContent.Title(AExample),
    TButtonFluentContent.Description(AExample));
  SetCodeText(TButtonFluentContent.Code(AExample));
  ClearResult;
  FRunner.Render(AExample, ResultHost);
end;

end.
