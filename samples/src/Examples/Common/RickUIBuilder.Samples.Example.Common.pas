{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Example.Common                                        }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Orquestrar a infraestrutura comum das futuras páginas concretas de exemplos }
{  do RickUIBuilder.Samples.                                                   }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Configura a janela FMX borderless menor que a Home, compõe header,          }
{  identidade, navegação lateral e área principal e expõe operações protegidas }
{  para que futuras derivadas preencham conteúdo sem duplicar a estrutura.     }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - RickUIBuilder.Samples.App.Typography                                      }
{      Fornece a escala tipográfica compartilhada pelo Samples.                }
{  - RickUIBuilder.Samples.Example.Common.Header                               }
{      Materializa o header e a ação visual de retorno.                        }
{  - RickUIBuilder.Samples.Example.Common.Navigation                           }
{      Materializa a navegação lateral e seu estado visual selecionado.        }
{  - RickUIBuilder.Samples.Example.Common.CodePanel                            }
{      Materializa a faixa Código Delphi/Resultado e a superfície de código.   }
{  - RickUIBuilder.Samples.Example.Common.ResultPanel                          }
{      Materializa o host destinado ao resultado executável futuro.            }
{  - RickUIBuilder.Samples.Example.Common.Style                                }
{      Fornece dimensões, espaçamentos e paleta específicos desta família.     }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - Futuras páginas concretas herdarão TExampleCommon.                        }
{  - A derivada define componente/abordagem, categorias, exemplo, código e     }
{    execução; a base apenas coordena os controles estruturais comuns.         }
{  - Back fecha apenas a modal atual quando a integração futura utilizar o     }
{    fluxo modal previsto pela arquitetura do Samples.                         }
{                                                                              }
{  Ownership / lifetime                                                        }
{  --------------------                                                        }
{  - Os controles estruturais são owned pela página ou por sua árvore visual.  }
{  - ResultHost pertence a TExampleResultPanel; ClearResult libera seus filhos }
{    visuais antes da substituição por um novo exemplo.                        }
{  - A base não possui Coordinator, Presenter ou Component Page.               }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - Não conhece Button, Badge, Divider, ComboBox, Edit ou Text / Label.       }
{  - Não conhece Factory ou Fluent Builder como regra de execução específica.  }
{  - Não contém catálogo global de exemplos ou case/if por componente.         }
{  - A faixa Código Delphi/Resultado é somente visual nesta etapa.             }
{  - Nenhuma página concreta ou sample real é criada por esta unit.            }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Este cabeçalho deve ser atualizado quando responsabilidade, dependências,   }
{  fluxo, ownership/lifetime ou restrições desta unit mudarem.                 }
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
  RickUIBuilder.Samples.Example.Common.CodePanel,
  RickUIBuilder.Samples.Example.Common.ResultPanel;

type
  /// <summary>Base visual comum das futuras páginas concretas de exemplos.</summary>
  TExampleCommon = class abstract(TForm)
  strict private
    FHeader: TExampleHeader;
    FPageTitle: TText;
    FPageSubtitle: TText;
    FNavigation: TExampleNavigation;
    FContentHost: TLayout;
    FExampleTitle: TText;
    FExampleDescription: TText;
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
    procedure BuildCodePanel;
    procedure BuildResultPanel;
    procedure BackRequested(ASender: TObject);
    function GetResultHost: TLayout;
  strict protected
    procedure ConfigurePage(const AParentTitle, ATitle, ASubtitle: string);
    function AddNavigationItem(const ACaption: string): TExampleNavigationItem;
    procedure SelectNavigationItem(const AItem: TExampleNavigationItem);
    procedure SetExampleIdentity(const ATitle, ADescription: string);
    procedure SetCodeText(const ACode: string);
    procedure ClearResult;
    property ResultHost: TLayout read GetResultHost;
  public
    constructor Create(AOwner: TComponent); reintroduce; virtual;
  end;

implementation

uses
  System.UITypes,
  FMX.Graphics,
  RickUIBuilder.Samples.App.Typography,
  RickUIBuilder.Samples.Example.Common.Style;

constructor TExampleCommon.Create(AOwner: TComponent);
begin
  inherited CreateNew(AOwner);
  ConfigureForm;
  BuildInterface;
end;

procedure TExampleCommon.ConfigureForm;
begin
  Caption := 'Rick.UIBuilder - Samples';
  BorderStyle := TFmxFormBorderStyle.None;
  ClientWidth := _EXAMPLE_PAGE_WIDTH_;
  ClientHeight := _EXAMPLE_PAGE_HEIGHT_;
  Constraints.MinWidth := _EXAMPLE_PAGE_WIDTH_;
  Constraints.MinHeight := _EXAMPLE_PAGE_HEIGHT_;
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
    _EXAMPLE_PAGE_CONTENT_WIDTH_, _EXAMPLE_PAGE_TITLE_HEIGHT_);
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
    _EXAMPLE_PAGE_CONTENT_WIDTH_, _EXAMPLE_PAGE_SUBTITLE_HEIGHT_);
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
    _EXAMPLE_PAGE_CONTENT_WIDTH_, _EXAMPLE_PAGE_BODY_HEIGHT_);
  BuildNavigation(LBody);
  BuildContent(LBody);
end;

procedure TExampleCommon.BuildNavigation(const AParent: TLayout);
begin
  FNavigation := TExampleNavigation.Create(AParent);
  FNavigation.Parent := AParent;
end;

procedure TExampleCommon.BuildContent(const AParent: TLayout);
begin
  FContentHost := TLayout.Create(AParent);
  FContentHost.Parent := AParent;
  FContentHost.SetBounds(_EXAMPLE_PAGE_NAV_WIDTH_ + _EXAMPLE_PAGE_BODY_GAP_, 0,
    _EXAMPLE_PAGE_MAIN_WIDTH_, _EXAMPLE_PAGE_BODY_HEIGHT_);
  BuildExampleIdentity;
  BuildCodePanel;
  BuildResultPanel;
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
    _EXAMPLE_PAGE_MAIN_WIDTH_, _EXAMPLE_PAGE_EXAMPLE_TITLE_HEIGHT_);
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
    _EXAMPLE_PAGE_MAIN_WIDTH_, _EXAMPLE_PAGE_EXAMPLE_DESCRIPTION_HEIGHT_);
  FExampleDescription.WordWrap := True;
  FExampleDescription.TextSettings.Font.Size := _FONT_SIZE_NAVIGATION_;
  FExampleDescription.TextSettings.FontColor := _EXAMPLE_PAGE_TEXT_SECONDARY_;
  FExampleDescription.TextSettings.HorzAlign := TTextAlign.Leading;
  FExampleDescription.TextSettings.VertAlign := TTextAlign.Leading;
  FExampleDescription.HitTest := False;
end;

procedure TExampleCommon.BuildCodePanel;
var
  LCodePanel: TExampleCodePanel;
begin
  LCodePanel := TExampleCodePanel.Create(FContentHost);
  LCodePanel.Parent := FContentHost;
  FCodePanel := LCodePanel;
end;

procedure TExampleCommon.BuildResultPanel;
var
  LResultPanel: TExampleResultPanel;
begin
  LResultPanel := TExampleResultPanel.Create(FContentHost);
  LResultPanel.Parent := FContentHost;
  FResultPanel := LResultPanel;
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
