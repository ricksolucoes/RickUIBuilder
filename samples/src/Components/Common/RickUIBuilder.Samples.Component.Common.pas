{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Component.Common                                      }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Fornecer a infraestrutura visual comum das páginas intermediárias de        }
{  componente do Samples.                                                      }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Configura um formulário FMX borderless, cria o header com retorno, aplica   }
{  estilo/geometria comuns e materializa os cards Factory/Fluent. Um card só   }
{  se torna clicável quando a página concreta fornece callback para destino    }
{  realmente implementado.                                                     }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - RickUIBuilder.Samples.App.Typography                                      }
{      Fornece a escala tipográfica compartilhada pelo Samples.                }
{  - RickUIBuilder.Samples.Component.Common.Icons                              }
{      Fornece as geometrias vetoriais usadas pelos controles comuns.          }
{  - RickUIBuilder.Samples.Component.Common.Style                              }
{      Fornece dimensões, espaçamentos e cores da família de páginas.          }
{                                                                              }
{  Dependências técnicas FMX                                                   }
{  -------------------------                                                   }
{  - FMX.Types fornece TTextAlign, TAlignLayout e crHandPoint.                 }
{  - FMX.Graphics fornece TBrushKind. Essas units devem permanecer explícitas  }
{    no uses sempre que os respectivos tipos forem utilizados.                }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - Pages concretas de componente herdam desta classe e fornecem conteúdo e   }
{    capacidades próprios.                                                     }
{  - TSampleApplicationCoordinator cria a page concreta e a exibe modalmente.  }
{  - Pages com destino real podem encaminhar um TNotifyEvent ao card comum.    }
{  - O retorno fecha a modal; o Coordinator mantém ownership da instância.     }
{                                                                              }
{  Ownership / lifetime                                                        }
{  --------------------                                                        }
{  - A base não possui Coordinator, Presenter ou Home.                         }
{  - Controles visuais são owned pelo formulário ou por sua árvore visual.     }
{  - A instância modal é owned/liberada pelo Coordinator.                     }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - Não conhece TSampleComponent nem decide conteúdo específico.              }
{  - Não depende de Home.Style.                                                }
{  - Não cria Sample Pages concretas.                                          }
{  - Callbacks só são ligados quando o destino real existe.                    }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Atualizar este cabeçalho quando responsabilidade, dependências, fluxo,      }
{  ownership/lifetime ou restrições desta unit mudarem.                        }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.Component.Common;

interface

uses
  System.Classes,
  System.UITypes,
  FMX.Forms,
  FMX.Objects;

type
  /// <summary>Base visual comum das páginas intermediárias de componente.</summary>
  TComponentCommon = class abstract(TForm)
  strict private
    /// <summary>Configura a janela borderless e sua superfície base.</summary>
    procedure ConfigureForm;
    /// <summary>Cria o header superior comum.</summary>
    procedure BuildTopBar;
    /// <summary>Cria a área clicável responsável pelo retorno.</summary>
    procedure AddBackAction(const AParent: TRectangle);
    /// <summary>Configura hit area, cursor e eventos do retorno.</summary>
    procedure ConfigureBackAction(const AAction: TRectangle);
    /// <summary>Adiciona o SVG de retorno dentro da área clicável.</summary>
    procedure AddBackIcon(const AAction: TRectangle);
    /// <summary>Adiciona o texto Componentes ao header.</summary>
    procedure AddTopBarTitle(const AParent: TRectangle);
    /// <summary>Adiciona o título da página concreta.</summary>
    procedure AddTitle(const ATitle: string);
    /// <summary>Adiciona o subtítulo da página concreta.</summary>
    procedure AddSubtitle(const ASubtitle: string);
    /// <summary>Cria um card visual de abordagem.</summary>
    function AddApproach(const ACaption, ADescription, AIconData: string;
      const AAccent: TAlphaColor; const ALeft: Single;
      const AStrokedIcon: Boolean): TRectangle;
    /// <summary>Configura a superfície visual de um card.</summary>
    procedure ConfigureApproachSurface(const ASurface: TRectangle;
      const ALeft: Single);
    /// <summary>Adiciona o ícone vetorial do card.</summary>
    procedure AddApproachIcon(const ASurface: TRectangle; const AIconData: string;
      const AAccent: TAlphaColor; const AStrokedIcon: Boolean);
    /// <summary>Configura fill/stroke conforme a geometria do SVG.</summary>
    procedure ConfigureApproachIconPaint(const AIcon: TPath;
      const AAccent: TAlphaColor; const AStrokedIcon: Boolean);
    /// <summary>Adiciona o título do card.</summary>
    procedure AddApproachTitle(const ASurface: TRectangle; const ACaption: string);
    /// <summary>Adiciona a descrição curta do card.</summary>
    procedure AddApproachDescription(const ASurface: TRectangle;
      const ADescription: string);
    /// <summary>Adiciona a ação visual Ver exemplos.</summary>
    function AddExamplesAction(const ASurface: TRectangle): TRectangle;
    /// <summary>Configura a superfície visual da ação ainda sem destino.</summary>
    procedure ConfigureExamplesAction(const AAction: TRectangle);
    /// <summary>Conecta callback somente quando o destino real existe.</summary>
    procedure EnableExamplesAction(const AAction: TRectangle;
      const AOnClick: TNotifyEvent);
    /// <summary>Adiciona a legenda da ação.</summary>
    procedure AddExamplesActionText(const AAction: TRectangle);
    /// <summary>Adiciona o chevron vetorial da ação.</summary>
    procedure AddActionChevron(const AAction: TRectangle);
    /// <summary>Adiciona o ícone do painel informativo.</summary>
    procedure AddInfoIcon(const APanel: TRectangle);
    /// <summary>Adiciona o título do painel informativo.</summary>
    procedure AddInfoTitle(const APanel: TRectangle);
    /// <summary>Adiciona o texto técnico do painel informativo.</summary>
    procedure AddInfoText(const APanel: TRectangle; const AText: string);
    /// <summary>Fecha a janela modal atual.</summary>
    procedure BackRequested(ASender: TObject);
    /// <summary>Aplica feedback visual de hover ao retorno.</summary>
    procedure BackMouseEnter(ASender: TObject);
    /// <summary>Restaura a superfície do retorno após hover.</summary>
    procedure BackMouseLeave(ASender: TObject);
  strict protected
    /// <summary>Adiciona título e subtítulo específicos da página derivada.</summary>
    procedure AddIdentity(const ATitle, ASubtitle: string);
    /// <summary>Adiciona o card Factory sem destino navegável.</summary>
    procedure AddFactoryApproach; overload;
    /// <summary>Adiciona o card Factory ligado a um destino real.</summary>
    procedure AddFactoryApproach(const AOnClick: TNotifyEvent); overload;
    /// <summary>Adiciona o card Fluent Builder sem destino navegável.</summary>
    procedure AddFluentApproach; overload;
    /// <summary>Adiciona o card Fluent Builder ligado a um destino real.</summary>
    procedure AddFluentApproach(const AOnClick: TNotifyEvent); overload;
    /// <summary>Adiciona o card Fluent Builder centralizado.</summary>
    procedure AddCenteredFluentApproach; overload;
    /// <summary>Adiciona o card Fluent Builder centralizado ligado a destino real.</summary>
    procedure AddCenteredFluentApproach(const AOnClick: TNotifyEvent); overload;
    /// <summary>Adiciona o painel Sobre este componente.</summary>
    procedure AddInfoPanel(const AText: string);
  public
    /// <summary>Cria a infraestrutura comum da página intermediária.</summary>
    constructor Create(AOwner: TComponent); reintroduce; virtual;
  end;

  /// <summary>Metaclasse utilizada pelo Coordinator para criar a página concreta.</summary>
  TComponentPageClass = class of TComponentCommon;

implementation

uses
  FMX.Graphics,
  FMX.Types,
  RickUIBuilder.Samples.App.Typography,
  RickUIBuilder.Samples.Component.Common.Icons,
  RickUIBuilder.Samples.Component.Common.Style;

const
  _FACTORY_DESCRIPTION_ = 'Criação direta'#13#10'do componente.';
  _FLUENT_DESCRIPTION_ = 'API encadeada'#13#10'para configuração.';

constructor TComponentCommon.Create(AOwner: TComponent);
begin
  inherited CreateNew(AOwner);
  ConfigureForm;
  BuildTopBar;
end;

procedure TComponentCommon.ConfigureForm;
begin
  Caption := 'Rick.UIBuilder - Samples';
  BorderStyle := TFmxFormBorderStyle.None;
  ClientWidth := _COMPONENT_PAGE_WIDTH_;
  ClientHeight := _COMPONENT_PAGE_HEIGHT_;
  Constraints.MinWidth := _COMPONENT_PAGE_WIDTH_;
  Constraints.MinHeight := _COMPONENT_PAGE_HEIGHT_;
  Position := TFormPosition.ScreenCenter;
  Fill.Kind := TBrushKind.Solid;
  Fill.Color := _COMPONENT_PAGE_BACKGROUND_;
end;

procedure TComponentCommon.BuildTopBar;
var
  LBar: TRectangle;
begin
  LBar := TRectangle.Create(Self);
  LBar.Parent := Self;
  LBar.Align := TAlignLayout.Top;
  LBar.Height := _COMPONENT_PAGE_TOP_BAR_HEIGHT_;
  LBar.Fill.Kind := TBrushKind.Solid;
  LBar.Fill.Color := _COMPONENT_PAGE_TOP_BAR_BACKGROUND_;
  LBar.Stroke.Kind := TBrushKind.Solid;
  LBar.Stroke.Color := _COMPONENT_PAGE_BORDER_;
  AddBackAction(LBar);
  AddTopBarTitle(LBar);
end;

procedure TComponentCommon.AddBackAction(const AParent: TRectangle);
var
  LAction: TRectangle;
begin
  LAction := TRectangle.Create(AParent);
  LAction.Parent := AParent;
  ConfigureBackAction(LAction);
  AddBackIcon(LAction);
end;

procedure TComponentCommon.ConfigureBackAction(const AAction: TRectangle);
begin
  AAction.SetBounds(8, 4, 34, 32);
  AAction.Fill.Kind := TBrushKind.Solid;
  AAction.Fill.Color := _COMPONENT_PAGE_TOP_BAR_BACKGROUND_;
  AAction.Stroke.Kind := TBrushKind.None;
  AAction.XRadius := 6;
  AAction.YRadius := 6;
  AAction.Cursor := crHandPoint;
  AAction.OnClick := BackRequested;
  AAction.OnMouseEnter := BackMouseEnter;
  AAction.OnMouseLeave := BackMouseLeave;
end;

procedure TComponentCommon.AddBackIcon(const AAction: TRectangle);
var
  LIcon: TPath;
begin
  LIcon := TPath.Create(AAction);
  LIcon.Parent := AAction;
  LIcon.SetBounds(9, 8, 16, 16);
  LIcon.Data.Data := _COMPONENT_PAGE_ICON_BACK_;
  LIcon.WrapMode := TPathWrapMode.Fit;
  LIcon.Fill.Kind := TBrushKind.Solid;
  LIcon.Fill.Color := _COMPONENT_PAGE_TEXT_SECONDARY_;
  LIcon.Stroke.Kind := TBrushKind.None;
  LIcon.HitTest := False;
end;

procedure TComponentCommon.AddTopBarTitle(const AParent: TRectangle);
var
  LTitle: TText;
begin
  LTitle := TText.Create(AParent);
  LTitle.Parent := AParent;
  LTitle.SetBounds(48, 0, 120, _COMPONENT_PAGE_TOP_BAR_HEIGHT_);
  LTitle.Text := 'Componentes';
  LTitle.TextSettings.Font.Size := _FONT_SIZE_NAVIGATION_;
  LTitle.TextSettings.Font.Style := [TFontStyle.fsBold];
  LTitle.TextSettings.FontColor := _COMPONENT_PAGE_TEXT_PRIMARY_;
  LTitle.TextSettings.HorzAlign := TTextAlign.Leading;
  LTitle.TextSettings.VertAlign := TTextAlign.Center;
  LTitle.HitTest := False;
end;

procedure TComponentCommon.AddIdentity(const ATitle, ASubtitle: string);
begin
  Caption := ATitle;
  AddTitle(ATitle);
  AddSubtitle(ASubtitle);
end;

procedure TComponentCommon.AddTitle(const ATitle: string);
var
  LTitle: TText;
begin
  LTitle := TText.Create(Self);
  LTitle.Parent := Self;
  LTitle.SetBounds(_COMPONENT_PAGE_CONTENT_LEFT_, 56,
    _COMPONENT_PAGE_CONTENT_WIDTH_, 32);
  LTitle.Text := ATitle;
  LTitle.TextSettings.Font.Size := _FONT_SIZE_PAGE_TITLE_;
  LTitle.TextSettings.Font.Style := [TFontStyle.fsBold];
  LTitle.TextSettings.FontColor := _COMPONENT_PAGE_TEXT_PRIMARY_;
  LTitle.TextSettings.HorzAlign := TTextAlign.Leading;
  LTitle.TextSettings.VertAlign := TTextAlign.Center;
  LTitle.HitTest := False;
end;

procedure TComponentCommon.AddSubtitle(const ASubtitle: string);
var
  LSubtitle: TText;
begin
  LSubtitle := TText.Create(Self);
  LSubtitle.Parent := Self;
  LSubtitle.SetBounds(_COMPONENT_PAGE_CONTENT_LEFT_, 94,
    _COMPONENT_PAGE_CONTENT_WIDTH_, 46);
  LSubtitle.Text := ASubtitle;
  LSubtitle.WordWrap := True;
  LSubtitle.TextSettings.Font.Size := _FONT_SIZE_PAGE_SUBTITLE_;
  LSubtitle.TextSettings.FontColor := _COMPONENT_PAGE_TEXT_SECONDARY_;
  LSubtitle.TextSettings.HorzAlign := TTextAlign.Leading;
  LSubtitle.TextSettings.VertAlign := TTextAlign.Leading;
  LSubtitle.HitTest := False;
end;

procedure TComponentCommon.AddFactoryApproach;
begin
  AddFactoryApproach(nil);
end;

procedure TComponentCommon.AddFactoryApproach(const AOnClick: TNotifyEvent);
var
  LAction: TRectangle;
begin
  LAction := AddApproach('Factory', _FACTORY_DESCRIPTION_,
    _COMPONENT_PAGE_ICON_FACTORY_, _COMPONENT_PAGE_FACTORY_ACCENT_,
    _COMPONENT_PAGE_CONTENT_LEFT_, False);
  EnableExamplesAction(LAction, AOnClick);
end;

procedure TComponentCommon.AddFluentApproach;
begin
  AddFluentApproach(nil);
end;

procedure TComponentCommon.AddFluentApproach(const AOnClick: TNotifyEvent);
var
  LAction: TRectangle;
  LLeft: Single;
begin
  LLeft := _COMPONENT_PAGE_CONTENT_LEFT_ + _COMPONENT_PAGE_CARD_WIDTH_ +
    _COMPONENT_PAGE_CARD_GAP_;
  LAction := AddApproach('Fluent Builder', _FLUENT_DESCRIPTION_,
    _COMPONENT_PAGE_ICON_FLUENT_, _COMPONENT_PAGE_FLUENT_ACCENT_, LLeft, True);
  EnableExamplesAction(LAction, AOnClick);
end;

procedure TComponentCommon.AddCenteredFluentApproach;
begin
  AddCenteredFluentApproach(nil);
end;

procedure TComponentCommon.AddCenteredFluentApproach(const AOnClick: TNotifyEvent);
var
  LAction: TRectangle;
  LLeft: Single;
begin
  LLeft := (_COMPONENT_PAGE_WIDTH_ - _COMPONENT_PAGE_CARD_WIDTH_) / 2;
  LAction := AddApproach('Fluent Builder', _FLUENT_DESCRIPTION_,
    _COMPONENT_PAGE_ICON_FLUENT_, _COMPONENT_PAGE_FLUENT_ACCENT_, LLeft, True);
  EnableExamplesAction(LAction, AOnClick);
end;

function TComponentCommon.AddApproach(const ACaption, ADescription,
  AIconData: string; const AAccent: TAlphaColor; const ALeft: Single;
  const AStrokedIcon: Boolean): TRectangle;
var
  LSurface: TRectangle;
begin
  LSurface := TRectangle.Create(Self);
  LSurface.Parent := Self;
  ConfigureApproachSurface(LSurface, ALeft);
  AddApproachIcon(LSurface, AIconData, AAccent, AStrokedIcon);
  AddApproachTitle(LSurface, ACaption);
  AddApproachDescription(LSurface, ADescription);
  Result := AddExamplesAction(LSurface);
end;

procedure TComponentCommon.ConfigureApproachSurface(const ASurface: TRectangle;
  const ALeft: Single);
begin
  ASurface.SetBounds(ALeft, _COMPONENT_PAGE_CARD_TOP_, _COMPONENT_PAGE_CARD_WIDTH_,
    _COMPONENT_PAGE_CARD_HEIGHT_);
  ASurface.Fill.Kind := TBrushKind.Solid;
  ASurface.Fill.Color := _COMPONENT_PAGE_CARD_BACKGROUND_;
  ASurface.Stroke.Kind := TBrushKind.Solid;
  ASurface.Stroke.Color := _COMPONENT_PAGE_BORDER_;
  ASurface.XRadius := _COMPONENT_PAGE_CARD_RADIUS_;
  ASurface.YRadius := _COMPONENT_PAGE_CARD_RADIUS_;
  ASurface.HitTest := False;
end;

procedure TComponentCommon.AddApproachIcon(const ASurface: TRectangle;
  const AIconData: string; const AAccent: TAlphaColor;
  const AStrokedIcon: Boolean);
var
  LIcon: TPath;
begin
  LIcon := TPath.Create(ASurface);
  LIcon.Parent := ASurface;
  LIcon.SetBounds((_COMPONENT_PAGE_CARD_WIDTH_ - 40) / 2, 14, 40, 40);
  LIcon.Data.Data := AIconData;
  LIcon.WrapMode := TPathWrapMode.Fit;
  ConfigureApproachIconPaint(LIcon, AAccent, AStrokedIcon);
  LIcon.HitTest := False;
end;

procedure TComponentCommon.ConfigureApproachIconPaint(const AIcon: TPath;
  const AAccent: TAlphaColor; const AStrokedIcon: Boolean);
begin
  if AStrokedIcon then
  begin
    AIcon.Fill.Kind := TBrushKind.None;
    AIcon.Stroke.Kind := TBrushKind.Solid;
    AIcon.Stroke.Color := AAccent;
    AIcon.Stroke.Thickness := 2.2;
    Exit;
  end;
  AIcon.Fill.Kind := TBrushKind.Solid;
  AIcon.Fill.Color := AAccent;
  AIcon.Stroke.Kind := TBrushKind.None;
end;

procedure TComponentCommon.AddApproachTitle(const ASurface: TRectangle;
  const ACaption: string);
var
  LTitle: TText;
begin
  LTitle := TText.Create(ASurface);
  LTitle.Parent := ASurface;
  LTitle.SetBounds(12, 62, _COMPONENT_PAGE_CARD_WIDTH_ - 24, 24);
  LTitle.Text := ACaption;
  LTitle.TextSettings.Font.Size := _FONT_SIZE_CARD_TITLE_;
  LTitle.TextSettings.Font.Style := [TFontStyle.fsBold];
  LTitle.TextSettings.FontColor := _COMPONENT_PAGE_TEXT_PRIMARY_;
  LTitle.TextSettings.HorzAlign := TTextAlign.Center;
  LTitle.TextSettings.VertAlign := TTextAlign.Center;
  LTitle.HitTest := False;
end;

procedure TComponentCommon.AddApproachDescription(const ASurface: TRectangle;
  const ADescription: string);
var
  LDescription: TText;
begin
  LDescription := TText.Create(ASurface);
  LDescription.Parent := ASurface;
  LDescription.SetBounds(12, 90, _COMPONENT_PAGE_CARD_WIDTH_ - 24, 42);
  LDescription.Text := ADescription;
  LDescription.WordWrap := True;
  LDescription.TextSettings.Font.Size := _FONT_SIZE_BODY_;
  LDescription.TextSettings.FontColor := _COMPONENT_PAGE_TEXT_SECONDARY_;
  LDescription.TextSettings.HorzAlign := TTextAlign.Center;
  LDescription.TextSettings.VertAlign := TTextAlign.Center;
  LDescription.HitTest := False;
end;

function TComponentCommon.AddExamplesAction(
  const ASurface: TRectangle): TRectangle;
begin
  Result := TRectangle.Create(ASurface);
  Result.Parent := ASurface;
  ConfigureExamplesAction(Result);
  AddExamplesActionText(Result);
  AddActionChevron(Result);
end;

procedure TComponentCommon.ConfigureExamplesAction(const AAction: TRectangle);
begin
  AAction.SetBounds(12, 143, _COMPONENT_PAGE_CARD_WIDTH_ - 24, 33);
  AAction.Fill.Kind := TBrushKind.Solid;
  AAction.Fill.Color := _COMPONENT_PAGE_PRIMARY_;
  AAction.Stroke.Kind := TBrushKind.None;
  AAction.XRadius := 6;
  AAction.YRadius := 6;
  AAction.HitTest := False;
end;

procedure TComponentCommon.EnableExamplesAction(const AAction: TRectangle;
  const AOnClick: TNotifyEvent);
begin
  if not Assigned(AOnClick) then
    Exit;
  AAction.HitTest := True;
  AAction.Cursor := crHandPoint;
  AAction.OnClick := AOnClick;
end;

procedure TComponentCommon.AddExamplesActionText(const AAction: TRectangle);
var
  LText: TText;
begin
  LText := TText.Create(AAction);
  LText.Parent := AAction;
  LText.SetBounds(10, 0, AAction.Width - 20, AAction.Height);
  LText.Text := 'Ver exemplos';
  LText.TextSettings.Font.Size := _FONT_SIZE_ACTION_;
  LText.TextSettings.FontColor := _COMPONENT_PAGE_ACTION_TEXT_;
  LText.TextSettings.HorzAlign := TTextAlign.Center;
  LText.TextSettings.VertAlign := TTextAlign.Center;
  LText.HitTest := False;
end;

procedure TComponentCommon.AddActionChevron(const AAction: TRectangle);
var
  LChevron: TPath;
begin
  LChevron := TPath.Create(AAction);
  LChevron.Parent := AAction;
  LChevron.SetBounds(AAction.Width - 20, 11, 6, 11);
  LChevron.Data.Data := _COMPONENT_PAGE_ICON_CHEVRON_;
  LChevron.WrapMode := TPathWrapMode.Fit;
  LChevron.Fill.Kind := TBrushKind.Solid;
  LChevron.Fill.Color := _COMPONENT_PAGE_ACTION_TEXT_;
  LChevron.Stroke.Kind := TBrushKind.None;
  LChevron.HitTest := False;
end;

procedure TComponentCommon.AddInfoPanel(const AText: string);
var
  LPanel: TRectangle;
begin
  LPanel := TRectangle.Create(Self);
  LPanel.Parent := Self;
  LPanel.SetBounds(_COMPONENT_PAGE_CONTENT_LEFT_, _COMPONENT_PAGE_INFO_TOP_,
    _COMPONENT_PAGE_CONTENT_WIDTH_, _COMPONENT_PAGE_INFO_HEIGHT_);
  LPanel.Fill.Kind := TBrushKind.Solid;
  LPanel.Fill.Color := _COMPONENT_PAGE_INFO_BACKGROUND_;
  LPanel.Stroke.Kind := TBrushKind.Solid;
  LPanel.Stroke.Color := _COMPONENT_PAGE_BORDER_;
  LPanel.XRadius := 7;
  LPanel.YRadius := 7;
  LPanel.HitTest := False;
  AddInfoIcon(LPanel);
  AddInfoTitle(LPanel);
  AddInfoText(LPanel, AText);
end;

procedure TComponentCommon.AddInfoIcon(const APanel: TRectangle);
var
  LIcon: TPath;
begin
  LIcon := TPath.Create(APanel);
  LIcon.Parent := APanel;
  LIcon.SetBounds(14, 14, 20, 20);
  LIcon.Data.Data := _COMPONENT_PAGE_ICON_INFO_;
  LIcon.WrapMode := TPathWrapMode.Fit;
  LIcon.Fill.Kind := TBrushKind.Solid;
  LIcon.Fill.Color := _COMPONENT_PAGE_INFO_ACCENT_;
  LIcon.Stroke.Kind := TBrushKind.None;
  LIcon.HitTest := False;
end;

procedure TComponentCommon.AddInfoTitle(const APanel: TRectangle);
var
  LTitle: TText;
begin
  LTitle := TText.Create(APanel);
  LTitle.Parent := APanel;
  LTitle.SetBounds(44, 10, APanel.Width - 58, 24);
  LTitle.Text := 'Sobre este componente';
  LTitle.TextSettings.Font.Size := _FONT_SIZE_NAVIGATION_;
  LTitle.TextSettings.Font.Style := [TFontStyle.fsBold];
  LTitle.TextSettings.FontColor := _COMPONENT_PAGE_TEXT_PRIMARY_;
  LTitle.TextSettings.HorzAlign := TTextAlign.Leading;
  LTitle.TextSettings.VertAlign := TTextAlign.Center;
  LTitle.HitTest := False;
end;

procedure TComponentCommon.AddInfoText(const APanel: TRectangle;
  const AText: string);
var
  LText: TText;
begin
  LText := TText.Create(APanel);
  LText.Parent := APanel;
  LText.SetBounds(44, 36, APanel.Width - 58, 74);
  LText.Text := AText;
  LText.WordWrap := True;
  LText.TextSettings.Font.Size := _FONT_SIZE_BODY_;
  LText.TextSettings.FontColor := _COMPONENT_PAGE_TEXT_SECONDARY_;
  LText.TextSettings.HorzAlign := TTextAlign.Leading;
  LText.TextSettings.VertAlign := TTextAlign.Leading;
  LText.HitTest := False;
end;

procedure TComponentCommon.BackRequested(ASender: TObject);
begin
  Close;
end;

procedure TComponentCommon.BackMouseEnter(ASender: TObject);
begin
  TRectangle(ASender).Fill.Color := _COMPONENT_PAGE_BACK_HOVER_;
end;

procedure TComponentCommon.BackMouseLeave(ASender: TObject);
begin
  TRectangle(ASender).Fill.Color := _COMPONENT_PAGE_TOP_BAR_BACKGROUND_;
end;

end.
