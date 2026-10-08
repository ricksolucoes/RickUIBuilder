{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Example.Edit.Fluent                                   }
{                                                                              }
{ Esta unit coordena a página Edit - Fluent Builder, preservando separação     }
{ entre navegação, conteúdo textual e execução dos vinte e nove exemplos.      }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Implementar a página concreta de exemplos Fluent Builder do componente Edit.}
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Configura a Sample Page Base, cria a navegação dos exemplos e mantém o      }
{  Runner vivo para callbacks interativos de clipboard e ações runtime.        }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - RickUIBuilder.Samples.App.Types                                           }
{      Fornece TEditFluentExample compartilhado com Content e Runner.          }
{  - RickUIBuilder.Samples.Example.Common                                      }
{      Fornece TExampleCommon e a infraestrutura visual compartilhada.         }
{  - RickUIBuilder.Samples.Example.Edit.Fluent.Content                         }
{      Fornece captions, títulos, descrições e snippets.                       }
{  - RickUIBuilder.Samples.Example.Edit.Fluent.Runner                          }
{      Executa a API pública real e mantém handlers válidos enquanto a página  }
{      existir.                                                                }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - O Coordinator cria esta página quando Edit solicita Fluent Builder.       }
{  - A seleção lateral atualiza identidade, snippet e resultado executável.    }
{  - Reset libera os Handles do resultado anterior antes de ClearResult.        }
{                                                                              }
{  Ownership / lifetime                                                        }
{  --------------------                                                        }
{  - O Coordinator cria a página sem Owner e a libera após ShowModal.          }
{  - ResultHost owns os controles materializados pelos exemplos.               }
{  - A página mantém o Runner vivo enquanto botões apontam para seus handlers. }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - Esta page conhece somente Edit na abordagem Fluent Builder.               }
{  - Não simula Factory inexistente e não usa implementações internas do Edit. }
{  - Conteúdo textual e execução permanecem em units próprias.                 }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Atualizar navegação e lifetime quando a API pública ou os exemplos mudarem. }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.Example.Edit.Fluent;

interface

uses
  System.Classes,

  RickUIBuilder.Samples.App.Types,
  RickUIBuilder.Samples.Example.Common,
  RickUIBuilder.Samples.Example.Common.Navigation,
  RickUIBuilder.Samples.Example.Edit.Fluent.Content,
  RickUIBuilder.Samples.Example.Edit.Fluent.Runner;

type
  /// <summary>Página concreta de exemplos Fluent Builder de Edit.</summary>
  TExampleEditFluent = class(TExampleCommon)
  strict private
    FRunner: TEditFluentRunner;
    function BuildNavigation: TExampleNavigationItem;
    function AddExampleItem(const AExample: TEditFluentExample): TExampleNavigationItem;
    procedure NavigationRequested(ASender: TObject);
    procedure ShowExample(const AExample: TEditFluentExample;
      const AItem: TExampleNavigationItem);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

const
  _PARENT_TITLE_ = 'Edit';
  _PAGE_TITLE_ = 'Edit - Fluent Builder';
  _PAGE_SUBTITLE_ = 'Presets, validação e runtime com TRickUIBuilder.Edit.';

constructor TExampleEditFluent.Create(AOwner: TComponent);
var
  LInitialItem: TExampleNavigationItem;
begin
  inherited Create(AOwner);
  FRunner := TEditFluentRunner.Create;
  ConfigurePage(_PARENT_TITLE_, _PAGE_TITLE_, _PAGE_SUBTITLE_);
  LInitialItem := BuildNavigation;
  ShowExample(TEditFluentExample.Basic, LInitialItem);
end;

destructor TExampleEditFluent.Destroy;
begin
  FRunner.Reset;
  inherited Destroy;
  FRunner.Free;
end;

function TExampleEditFluent.BuildNavigation: TExampleNavigationItem;
var
  LExample: TEditFluentExample;
begin
  Result := nil;
  for LExample := Low(TEditFluentExample) to High(TEditFluentExample) do
  begin
    if LExample = TEditFluentExample.Basic then
      Result := AddExampleItem(LExample)
    else
      AddExampleItem(LExample);
  end;
end;

function TExampleEditFluent.AddExampleItem(
  const AExample: TEditFluentExample): TExampleNavigationItem;
begin
  Result := AddNavigationItem(TEditFluentContent.Caption(AExample));
  Result.Tag := Ord(AExample);
  Result.OnClick := NavigationRequested;
end;

procedure TExampleEditFluent.NavigationRequested(ASender: TObject);
var
  LItem: TExampleNavigationItem;
  LExample: TEditFluentExample;
begin
  LItem := ASender as TExampleNavigationItem;
  LExample := TEditFluentExample(LItem.Tag);
  ShowExample(LExample, LItem);
end;

procedure TExampleEditFluent.ShowExample(const AExample: TEditFluentExample;
  const AItem: TExampleNavigationItem);
begin
  SelectNavigationItem(AItem);
  SetExampleIdentity(TEditFluentContent.Title(AExample),
    TEditFluentContent.Description(AExample));
  SetCodeText(TEditFluentContent.Code(AExample));
  FRunner.Reset;
  ClearResult;
  FRunner.Render(AExample, ResultHost);
end;

end.
