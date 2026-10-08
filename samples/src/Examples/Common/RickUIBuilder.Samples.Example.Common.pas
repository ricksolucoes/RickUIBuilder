{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Example.Common                                        }
{                                                                              }
{ Esta unit orquestra a Sample Page Base, resolve o layout efetivo antes da     }
{ construção visual e expõe infraestrutura comum sem conhecer conteúdo         }
{ específico de componente ou abordagem.                                       }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Orquestrar a infraestrutura comum das páginas concretas de exemplos do      }
{  RickUIBuilder.Samples.                                                      }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Configura a janela FMX borderless menor que a Home, resolve defaults e      }
{  especializações de layout por herança, compõe a infraestrutura visual e     }
{  expõe operações protegidas para as páginas derivadas.                       }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - RickUIBuilder.Samples.App.Types                                           }
{      Fornece TExampleView usado para decidir a view estrutural ativa.        }
{  - RickUIBuilder.Samples.App.Typography                                      }
{      Fornece a escala tipográfica compartilhada pelo Samples.                }
{  - RickUIBuilder.Samples.Example.Common.Header                               }
{      Materializa o header e a ação visual de retorno.                        }
{  - RickUIBuilder.Samples.Example.Common.Navigation                           }
{      Materializa a navegação lateral e seu estado visual selecionado.        }
{  - RickUIBuilder.Samples.Example.Common.View.Selector                        }
{      Materializa e controla a seleção visual Código Delphi/Resultado.        }
{  - RickUIBuilder.Samples.Example.Common.Code.Panel                           }
{      Materializa exclusivamente a superfície de código read-only.            }
{  - RickUIBuilder.Samples.Example.Common.Result.Panel                         }
{      Materializa exclusivamente a superfície e o host do resultado.          }
{  - RickUIBuilder.Samples.Example.Common.Style                                }
{      Fornece TExamplePageLayout, defaults, cálculos derivados e paleta.      }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - Páginas concretas herdam TExampleCommon.                                  }
{  - A derivada define categorias, conteúdo, snippet e execução; a base apenas }
{    coordena os controles estruturais comuns.                                 }
{  - Código Delphi e Resultado são views mutuamente exclusivas; a seleção      }
{    ocorre na base sem alterar o conteúdo fornecido pela derivada.            }
{  - Back fecha somente a modal atual.                                         }
{                                                                              }
{  Ownership / lifetime                                                        }
{  --------------------                                                        }
{  - Controles estruturais são owned pela page ou por sua árvore visual.       }
{  - ResultHost pertence a TExampleResultPanel; derivadas apenas anexam        }
{    controles ao host e ClearResult libera esses filhos sem substituir a      }
{    infraestrutura.                                                           }
{  - A base não possui Coordinator, Presenter ou Component Page.               }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - Não conhece conteúdo específico de componente ou abordagem.               }
{  - Não contém catálogo global de exemplos ou case/if por componente.         }
{  - A base controla somente qual view estrutural fica visível.                }
{  - TTextAlign exige FMX.Types e TBrushKind exige FMX.Graphics explicitamente.}
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Atualizar este cabeçalho quando responsabilidade, dependências, fluxo,      }
{  ownership/lifetime ou restrições desta unit mudarem.                        }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.Example.Common;

interface

uses
  System.Classes,

  FMX.Forms,
  FMX.Layouts,
  FMX.Objects,

  RickUIBuilder.Samples.Example.Common.Header,
  RickUIBuilder.Samples.Example.Common.Navigation,
  RickUIBuilder.Samples.Example.Common.Code.Panel,
  RickUIBuilder.Samples.Example.Common.Result.Panel,
  RickUIBuilder.Samples.Example.Common.View.Selector,
  RickUIBuilder.Samples.Example.Common.Style;

type
  /// <summary>Base visual comum das páginas concretas de exemplos.</summary>
  TExampleCommon = class abstract(TForm)
  strict private
    FLayout: TExamplePageLayout;
    FHeader: TExampleHeader;
    FPageTitle: TText;
    FPageSubtitle: TText;
    FNavigation: TExampleNavigation;
    FContentHost: TLayout;
    FExampleTitle: TText;
    FExampleDescription: TText;
    FViewSelector: TExampleViewSelector;
    FCodePanel: TExampleCodePanel;
    FResultPanel: TExampleResultPanel;
    procedure ConfigureForm;
    procedure BuildInterface;
    procedure BuildHeader;
    procedure BuildPageIdentity;
    procedure AddPageTitle;
    procedure AddPageSubtitle;
    procedure BuildBody;
    procedure BuildNavigation(const AParent: TLayout);
    procedure BuildContent(const AParent: TLayout);
    procedure BuildExampleIdentity;
    procedure AddExampleTitle;
    procedure AddExampleDescription;
    procedure BuildViewSelector;
    procedure BuildCodePanel;
    procedure BuildResultPanel;
    procedure ViewSelectionChanged(ASender: TObject);
    procedure ApplySelectedView;
    procedure BackRequested(ASender: TObject);
    function GetResultHost: TLayout;
  strict protected
    /// <summary>
    /// Permite que a derivada ajuste os valores primários do layout antes da
    /// construção da interface. O override não deve depender de campos próprios
    /// inicializados após inherited Create.
    /// </summary>
    procedure ConfigureLayout(var ALayout: TExamplePageLayout); virtual;
    procedure ConfigurePage(const AParentTitle, ATitle, ASubtitle: string);
    function AddNavigationItem(const ACaption: string): TExampleNavigationItem;
    procedure SelectNavigationItem(const AItem: TExampleNavigationItem);
    procedure SetExampleIdentity(const ATitle, ADescription: string);
    procedure SetCodeText(const ACode: string);
    procedure ClearResult;
    /// <summary>
    /// Container estável fornecido por TExampleResultPanel para que a página
    /// derivada materialize os controles do resultado executável atual.
    /// </summary>
    /// <remarks>
    /// A derivada pode usar este layout como Parent dos controles do sample,
    /// mas não deve liberá-lo ou substituí-lo. ClearResult remove apenas os
    /// filhos antes da próxima materialização.
    /// </remarks>
    property ResultHost: TLayout read GetResultHost;
  public
    constructor Create(AOwner: TComponent); reintroduce; virtual;
  end;

implementation

uses
  System.UITypes,

  FMX.Types,
  FMX.Graphics,

  RickUIBuilder.Samples.App.Types,
  RickUIBuilder.Samples.App.Typography;

constructor TExampleCommon.Create(AOwner: TComponent);
begin
  inherited CreateNew(AOwner);
  FLayout := TExamplePageLayout.Default;
  ConfigureLayout(FLayout);
  ConfigureForm;
  BuildInterface;
end;

procedure TExampleCommon.ConfigureForm;
begin
  Caption := 'Rick.UIBuilder - Samples';
  BorderStyle := TFmxFormBorderStyle.None;
  ClientWidth :=  Round(FLayout.PageWidth);
  ClientHeight := Round(FLayout.PageHeight);
  Constraints.MinWidth := FLayout.PageWidth;
  Constraints.MinHeight := FLayout.PageHeight;
  Position := TFormPosition.ScreenCenter;
  Fill.Kind := TBrushKind.Solid;
  Fill.Color := _EXAMPLE_PAGE_BACKGROUND_;
end;

procedure TExampleCommon.BuildInterface;
begin
  BuildHeader;
  BuildPageIdentity;
  BuildBody;
end;

procedure TExampleCommon.BuildHeader;
var
  LHeader: TExampleHeader;
begin
  LHeader := TExampleHeader.Create(Self);
  LHeader.Parent := Self;
  LHeader.SetBackAction(BackRequested);
  FHeader := LHeader;
end;

procedure TExampleCommon.BuildPageIdentity;
begin
  AddPageTitle;
  AddPageSubtitle;
end;

procedure TExampleCommon.AddPageTitle;
begin
  FPageTitle := TText.Create(Self);
  FPageTitle.Parent := Self;
  FPageTitle.SetBounds(_EXAMPLE_PAGE_CONTENT_LEFT_, _EXAMPLE_PAGE_TITLE_TOP_,
    FLayout.ContentWidth, _EXAMPLE_PAGE_TITLE_HEIGHT_);
  FPageTitle.TextSettings.Font.Size := _FONT_SIZE_PAGE_TITLE_;
  FPageTitle.TextSettings.Font.Style := [TFontStyle.fsBold];
  FPageTitle.TextSettings.FontColor := _EXAMPLE_PAGE_TEXT_PRIMARY_;
  FPageTitle.TextSettings.HorzAlign := TTextAlign.Leading;
  FPageTitle.TextSettings.VertAlign := TTextAlign.Center;
  FPageTitle.HitTest := False;
end;

procedure TExampleCommon.AddPageSubtitle;
begin
  FPageSubtitle := TText.Create(Self);
  FPageSubtitle.Parent := Self;
  FPageSubtitle.SetBounds(_EXAMPLE_PAGE_CONTENT_LEFT_, _EXAMPLE_PAGE_SUBTITLE_TOP_,
    FLayout.ContentWidth, _EXAMPLE_PAGE_SUBTITLE_HEIGHT_);
  FPageSubtitle.WordWrap := True;
  FPageSubtitle.TextSettings.Font.Size := _FONT_SIZE_PAGE_SUBTITLE_;
  FPageSubtitle.TextSettings.FontColor := _EXAMPLE_PAGE_TEXT_SECONDARY_;
  FPageSubtitle.TextSettings.HorzAlign := TTextAlign.Leading;
  FPageSubtitle.TextSettings.VertAlign := TTextAlign.Leading;
  FPageSubtitle.HitTest := False;
end;

procedure TExampleCommon.BuildBody;
var
  LBody: TLayout;
begin
  LBody := TLayout.Create(Self);
  LBody.Parent := Self;
  LBody.SetBounds(_EXAMPLE_PAGE_CONTENT_LEFT_, _EXAMPLE_PAGE_BODY_TOP_,
    FLayout.ContentWidth, FLayout.BodyHeight);
  BuildNavigation(LBody);
  BuildContent(LBody);
end;

procedure TExampleCommon.BuildNavigation(const AParent: TLayout);
begin
  FNavigation := TExampleNavigation.Create(AParent, FLayout);
  FNavigation.Parent := AParent;
end;

procedure TExampleCommon.BuildContent(const AParent: TLayout);
begin
  FContentHost := TLayout.Create(AParent);
  FContentHost.Parent := AParent;
  FContentHost.SetBounds(FLayout.NavigationWidth + _EXAMPLE_PAGE_BODY_GAP_, 0,
    FLayout.MainWidth, FLayout.BodyHeight);
  BuildExampleIdentity;
  BuildViewSelector;
  BuildCodePanel;
  BuildResultPanel;
  ApplySelectedView;
end;

procedure TExampleCommon.BuildExampleIdentity;
begin
  AddExampleTitle;
  AddExampleDescription;
end;

procedure TExampleCommon.AddExampleTitle;
begin
  FExampleTitle := TText.Create(FContentHost);
  FExampleTitle.Parent := FContentHost;
  FExampleTitle.SetBounds(0, _EXAMPLE_PAGE_EXAMPLE_TITLE_TOP_,
    FLayout.MainWidth, _EXAMPLE_PAGE_EXAMPLE_TITLE_HEIGHT_);
  FExampleTitle.TextSettings.Font.Size := _FONT_SIZE_BODY_;
  FExampleTitle.TextSettings.Font.Style := [TFontStyle.fsBold];
  FExampleTitle.TextSettings.FontColor := _EXAMPLE_PAGE_TEXT_PRIMARY_;
  FExampleTitle.TextSettings.HorzAlign := TTextAlign.Leading;
  FExampleTitle.TextSettings.VertAlign := TTextAlign.Center;
  FExampleTitle.HitTest := False;
end;

procedure TExampleCommon.AddExampleDescription;
begin
  FExampleDescription := TText.Create(FContentHost);
  FExampleDescription.Parent := FContentHost;
  FExampleDescription.SetBounds(0, _EXAMPLE_PAGE_EXAMPLE_DESCRIPTION_TOP_,
    FLayout.MainWidth, _EXAMPLE_PAGE_EXAMPLE_DESCRIPTION_HEIGHT_);
  FExampleDescription.WordWrap := True;
  FExampleDescription.TextSettings.Font.Size := _FONT_SIZE_NAVIGATION_;
  FExampleDescription.TextSettings.FontColor := _EXAMPLE_PAGE_TEXT_SECONDARY_;
  FExampleDescription.TextSettings.HorzAlign := TTextAlign.Leading;
  FExampleDescription.TextSettings.VertAlign := TTextAlign.Leading;
  FExampleDescription.HitTest := False;
end;

procedure TExampleCommon.BuildViewSelector;
var
  LViewSelector: TExampleViewSelector;
begin
  LViewSelector := TExampleViewSelector.Create(FContentHost, FLayout);
  LViewSelector.Parent := FContentHost;
  LViewSelector.OnChange := ViewSelectionChanged;
  FViewSelector := LViewSelector;
end;

procedure TExampleCommon.BuildCodePanel;
var
  LCodePanel: TExampleCodePanel;
begin
  LCodePanel := TExampleCodePanel.Create(FContentHost, FLayout);
  LCodePanel.Parent := FContentHost;
  FCodePanel := LCodePanel;
end;

procedure TExampleCommon.BuildResultPanel;
var
  LResultPanel: TExampleResultPanel;
begin
  LResultPanel := TExampleResultPanel.Create(FContentHost, FLayout);
  LResultPanel.Parent := FContentHost;
  FResultPanel := LResultPanel;
end;

procedure TExampleCommon.ViewSelectionChanged(ASender: TObject);
begin
  ApplySelectedView;
end;

procedure TExampleCommon.ApplySelectedView;
begin
  FCodePanel.Visible := FViewSelector.SelectedView = TExampleView.CodeView;
  FResultPanel.Visible := FViewSelector.SelectedView = TExampleView.ResultView;
end;

procedure TExampleCommon.ConfigureLayout(var ALayout: TExamplePageLayout);
begin
end;

procedure TExampleCommon.ConfigurePage(const AParentTitle, ATitle,
  ASubtitle: string);
begin
  Caption := ATitle;
  FHeader.SetTitle(AParentTitle);
  FPageTitle.Text := ATitle;
  FPageSubtitle.Text := ASubtitle;
end;

function TExampleCommon.AddNavigationItem(
  const ACaption: string): TExampleNavigationItem;
begin
  Result := FNavigation.AddItem(ACaption);
end;

procedure TExampleCommon.SelectNavigationItem(
  const AItem: TExampleNavigationItem);
begin
  FNavigation.SelectItem(AItem);
end;

procedure TExampleCommon.SetExampleIdentity(const ATitle,
  ADescription: string);
begin
  FExampleTitle.Text := ATitle;
  FExampleDescription.Text := ADescription;
end;

procedure TExampleCommon.SetCodeText(const ACode: string);
begin
  FCodePanel.SetCodeText(ACode);
end;

procedure TExampleCommon.ClearResult;
begin
  FResultPanel.Clear;
end;

function TExampleCommon.GetResultHost: TLayout;
begin
  Result := FResultPanel.Host;
end;

procedure TExampleCommon.BackRequested(ASender: TObject);
begin
  Close;
end;

end.
