{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Home                                                  }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  View principal do catálogo de componentes do Samples.                       }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Constrói o header, título, descrição e grid 3 x 2; captura fechamento e     }
{  seleção de componente e comunica essas intenções ao Presenter.              }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - RickUIBuilder.Samples.App.Types                                           }
{      Identifica o componente associado a cada card.                          }
{                                                                              }
{  - RickUIBuilder.Samples.Home.Presenter.Intf                                 }
{      Boundary usado pela View para emitir intenções.                         }
{                                                                              }
{  - RickUIBuilder.Samples.Home.ComponentCard                                  }
{      Constrói os cards do catálogo.                                          }
{                                                                              }
{  - RickUIBuilder.Samples.Home.Icons                                          }
{      Fornece os paths SVG oficiais.                                          }
{                                                                              }
{  - RickUIBuilder.Samples.Home.Style                                          }
{      Fornece geometria e cores específicas da Home.                          }
{                                                                              }
{  - RickUIBuilder.Samples.App.Typography                                      }
{      Fornece a escala tipográfica compartilhada.                             }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - Interação do usuário -> TPageSamplesHome -> IHomePresenter -> coordenação }
{    da aplicação.                                                             }
{  - O header é filho direto do formulário e permanece alinhado ao topo; o     }
{    conteúdo centralizado fica abaixo dele.                                   }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - A View não executa comandos de aplicação, não cria páginas de destino e   }
{    não decide o fluxo global.                                                }
{  - O Presenter é recebido por injeção no construtor e mantido pela           }
{    interface.                                                                }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Este cabeçalho deve ser atualizado quando responsabilidade, dependências,   }
{  fluxo, ownership/lifetime ou restrições desta unit mudarem.                 }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.Home;

interface

uses
  System.Classes,
  FMX.Forms,
  FMX.Layouts,
  FMX.Objects,
  FMX.Types,
  RickUIBuilder.Samples.App.Types,
  RickUIBuilder.Samples.Home.Presenter.Intf;

type
  /// <summary>Pagina principal do catalogo de componentes do Samples.</summary>
  TPageSamplesHome = class(TForm)
  strict private
    FPresenter: IHomePresenter;
    FReference: TLayout;
    FCardsLayout: TLayout;
    /// <summary>Configura dimensões e aparência do formulário.</summary>
    procedure ConfigureForm;
    /// <summary>Monta a composição visual da Home.</summary>
    procedure BuildInterface;
    /// <summary>Cria o header superior sem margem externa.</summary>
    procedure BuildTopBar;
    /// <summary>Adiciona o ícone cottage ao header.</summary>
    procedure AddTopBarIcon(const AParent: TFmxObject);
    /// <summary>Adiciona o título Componentes ao header.</summary>
    procedure AddTopBarTitle(const AParent: TFmxObject);
    /// <summary>Adiciona a ação visual de fechamento.</summary>
    procedure AddTopBarClose(const AParent: TFmxObject);
    /// <summary>Configura hit area, cursor e eventos do fechamento.</summary>
    procedure ConfigureCloseAction(const AAction: TRectangle);
    /// <summary>Adiciona o SVG close_small à ação.</summary>
    procedure AddCloseIcon(const AAction: TRectangle);
    /// <summary>Cria título e descrição da página.</summary>
    procedure BuildHeader;
    /// <summary>Adiciona o título principal.</summary>
    procedure AddPageTitle;
    /// <summary>Adiciona a descrição aprovada da Home.</summary>
    procedure AddPageSubtitle;
    /// <summary>Cria o grid 3 x 2 de componentes.</summary>
    procedure BuildComponentCards;
    /// <summary>Adiciona a primeira linha do grid.</summary>
    procedure BuildFirstRow;
    /// <summary>Adiciona a segunda linha do grid.</summary>
    procedure BuildSecondRow;
    /// <summary>Cria e posiciona um card de componente.</summary>
    procedure AddCard(const AComponent: TSampleComponent; const AIconData,
      ATitle, ADescription: string; const AColumn, ARow: Integer);
    /// <summary>Centraliza horizontalmente a referência mantendo o header no topo.</summary>
    procedure LayoutReference;
    /// <summary>Reaplica o layout após redimensionamento.</summary>
    procedure FormResized(ASender: TObject);
    /// <summary>Encaminha ao Presenter a intenção de fechamento.</summary>
    procedure CloseRequested(ASender: TObject);
    /// <summary>Encaminha ao Presenter o componente selecionado.</summary>
    procedure ComponentRequested(ASender: TObject);
    /// <summary>Aplica feedback visual de hover ao fechamento.</summary>
    procedure CloseMouseEnter(ASender: TObject);
    /// <summary>Restaura a superfície do fechamento após hover.</summary>
    procedure CloseMouseLeave(ASender: TObject);
  public
    /// <summary>Cria a Home vinculada ao contrato de apresentação informado.</summary>
    constructor Create(AOwner: TComponent; const APresenter: IHomePresenter); reintroduce;
  end;

implementation

uses
  System.UITypes,
  FMX.Graphics,
  RickUIBuilder.Samples.App.Typography,
  RickUIBuilder.Samples.Home.ComponentCard,
  RickUIBuilder.Samples.Home.Icons,
  RickUIBuilder.Samples.Home.Style;

constructor TPageSamplesHome.Create(AOwner: TComponent;
  const APresenter: IHomePresenter);
begin
  inherited CreateNew(AOwner);
  FPresenter := APresenter;
  ConfigureForm;
  BuildInterface;
end;

procedure TPageSamplesHome.ConfigureForm;
begin
  Caption := 'Rick.UIBuilder - Samples';
  BorderStyle := TFmxFormBorderStyle.None;
  ClientWidth := _HOME_REFERENCE_WIDTH_;
  ClientHeight := _HOME_REFERENCE_HEIGHT_;
  Constraints.MinWidth := _HOME_REFERENCE_WIDTH_;
  Constraints.MinHeight := _HOME_REFERENCE_HEIGHT_;
  Position := TFormPosition.ScreenCenter;
  Fill.Kind := TBrushKind.Solid;
  Fill.Color := _HOME_BACKGROUND_;
  OnResize := FormResized;
end;

procedure TPageSamplesHome.BuildInterface;
begin
  FReference := TLayout.Create(Self);
  FReference.Parent := Self;
  FReference.SetBounds(0, 0, _HOME_REFERENCE_WIDTH_, _HOME_REFERENCE_HEIGHT_);
  BuildTopBar;
  BuildHeader;
  BuildComponentCards;
  LayoutReference;
end;

procedure TPageSamplesHome.BuildTopBar;
var
  LBar: TRectangle;
begin
  LBar := TRectangle.Create(Self);
  LBar.Parent := Self;
  LBar.Align := TAlignLayout.Top;
  LBar.Height := _HOME_TOP_BAR_HEIGHT_;
  LBar.Fill.Kind := TBrushKind.Solid;
  LBar.Fill.Color := _HOME_TOP_BAR_BACKGROUND_;
  LBar.Stroke.Kind := TBrushKind.Solid;
  LBar.Stroke.Color := _HOME_BORDER_;
  LBar.Stroke.Thickness := 1;
  AddTopBarIcon(LBar);
  AddTopBarTitle(LBar);
  AddTopBarClose(LBar);
end;

procedure TPageSamplesHome.AddTopBarIcon(const AParent: TFmxObject);
var
  LIcon: TPath;
begin
  LIcon := TPath.Create(AParent);
  LIcon.Parent := AParent;
  LIcon.SetBounds(16, 12, 16, 16);
  LIcon.Data.Data := _HOME_ICON_COTTAGE_;
  LIcon.WrapMode := TPathWrapMode.Fit;
  LIcon.Fill.Kind := TBrushKind.Solid;
  LIcon.Fill.Color := _HOME_TEXT_SECONDARY_;
  LIcon.Stroke.Kind := TBrushKind.None;
  LIcon.HitTest := False;
end;

procedure TPageSamplesHome.AddTopBarTitle(const AParent: TFmxObject);
var
  LTitle: TText;
begin
  LTitle := TText.Create(AParent);
  LTitle.Parent := AParent;
  LTitle.SetBounds(42, 0, 140, _HOME_TOP_BAR_HEIGHT_);
  LTitle.Text := 'Componentes';
  LTitle.TextSettings.Font.Size := _FONT_SIZE_NAVIGATION_;
  LTitle.TextSettings.Font.Style := [TFontStyle.fsBold];
  LTitle.TextSettings.FontColor := _HOME_TEXT_PRIMARY_;
  LTitle.TextSettings.HorzAlign := TTextAlign.Leading;
  LTitle.TextSettings.VertAlign := TTextAlign.Center;
  LTitle.HitTest := False;
end;

procedure TPageSamplesHome.AddTopBarClose(const AParent: TFmxObject);
var
  LAction: TRectangle;
begin
  LAction := TRectangle.Create(AParent);
  LAction.Parent := AParent;
  ConfigureCloseAction(LAction);
  AddCloseIcon(LAction);
end;

procedure TPageSamplesHome.ConfigureCloseAction(const AAction: TRectangle);
begin
  AAction.Align := TAlignLayout.Right;
  AAction.Width := 38;
  AAction.Margins.Top := 4;
  AAction.Margins.Right := 6;
  AAction.Margins.Bottom := 4;
  AAction.Fill.Kind := TBrushKind.Solid;
  AAction.Fill.Color := _HOME_TOP_BAR_BACKGROUND_;
  AAction.Stroke.Kind := TBrushKind.None;
  AAction.XRadius := 6;
  AAction.YRadius := 6;
  AAction.Cursor := crHandPoint;
  AAction.OnClick := CloseRequested;
  AAction.OnMouseEnter := CloseMouseEnter;
  AAction.OnMouseLeave := CloseMouseLeave;
end;

procedure TPageSamplesHome.AddCloseIcon(const AAction: TRectangle);
var
  LIcon: TPath;
begin
  LIcon := TPath.Create(AAction);
  LIcon.Parent := AAction;
  LIcon.SetBounds(11, 8, 16, 16);
  LIcon.Data.Data := _HOME_ICON_CLOSE_;
  LIcon.WrapMode := TPathWrapMode.Fit;
  LIcon.Fill.Kind := TBrushKind.Solid;
  LIcon.Fill.Color := _HOME_TEXT_SECONDARY_;
  LIcon.Stroke.Kind := TBrushKind.None;
  LIcon.HitTest := False;
end;

procedure TPageSamplesHome.BuildHeader;
begin
  AddPageTitle;
  AddPageSubtitle;
end;

procedure TPageSamplesHome.AddPageTitle;
var
  LTitle: TText;
begin
  LTitle := TText.Create(FReference);
  LTitle.Parent := FReference;
  LTitle.SetBounds(0, 52, _HOME_REFERENCE_WIDTH_, 32);
  LTitle.Text := 'Rick.UIBuilder';
  LTitle.TextSettings.Font.Size := _FONT_SIZE_PAGE_TITLE_;
  LTitle.TextSettings.Font.Style := [TFontStyle.fsBold];
  LTitle.TextSettings.FontColor := _HOME_TEXT_PRIMARY_;
  LTitle.TextSettings.HorzAlign := TTextAlign.Center;
  LTitle.TextSettings.VertAlign := TTextAlign.Center;
  LTitle.HitTest := False;
end;

procedure TPageSamplesHome.AddPageSubtitle;
var
  LDescription: TText;
begin
  LDescription := TText.Create(FReference);
  LDescription.Parent := FReference;
  LDescription.SetBounds(38, 86, _HOME_REFERENCE_WIDTH_ - 76, 38);
  LDescription.Text := 'Escolha um componente para conhecer as formas de criacao e os exemplos disponiveis na API publica atual.';
  LDescription.WordWrap := True;
  LDescription.TextSettings.Font.Size := _FONT_SIZE_PAGE_SUBTITLE_;
  LDescription.TextSettings.FontColor := _HOME_TEXT_SECONDARY_;
  LDescription.TextSettings.HorzAlign := TTextAlign.Center;
  LDescription.TextSettings.VertAlign := TTextAlign.Center;
  LDescription.HitTest := False;
end;

procedure TPageSamplesHome.BuildComponentCards;
begin
  FCardsLayout := TLayout.Create(FReference);
  FCardsLayout.Parent := FReference;
  FCardsLayout.SetBounds(22, 140, _HOME_GRID_WIDTH_, _HOME_GRID_HEIGHT_);
  BuildFirstRow;
  BuildSecondRow;
end;

procedure TPageSamplesHome.BuildFirstRow;
begin
  AddCard(TSampleComponent.TextLabel, _HOME_ICON_TEXT_, 'Text / Label',
    'Apresente textos com configuração visual consistente.', 0, 0);
  AddCard(TSampleComponent.Button, _HOME_ICON_BUTTON_, 'Button',
    'Crie botões interativos e configure sua apresentação.', 1, 0);
  AddCard(TSampleComponent.Badge, _HOME_ICON_BADGE_, 'Badge',
    'Destaque estados, categorias e informações curtas.', 2, 0);
end;

procedure TPageSamplesHome.BuildSecondRow;
begin
  AddCard(TSampleComponent.Divider, _HOME_ICON_DIVIDER_, 'Divider',
    'Separe visualmente seções e grupos de conteúdo.', 0, 1);
  AddCard(TSampleComponent.ComboBox, _HOME_ICON_COMBOBOX_, 'ComboBox',
    'Apresente seleções com opções e comportamentos configuráveis.', 1, 1);
  AddCard(TSampleComponent.Edit, _HOME_ICON_EDIT_, 'Edit',
    'Configure entrada de texto, presets e feedback visual.', 2, 1);
end;

procedure TPageSamplesHome.AddCard(const AComponent: TSampleComponent;
  const AIconData, ATitle, ADescription: string; const AColumn, ARow: Integer);
var
  LCard: TRectangle;
begin
  LCard := TComponentCard.New(FCardsLayout, AIconData, ATitle, ADescription,
    ComponentRequested);
  LCard.Tag := Ord(AComponent);
  LCard.Position.X := AColumn * (_HOME_CARD_WIDTH_ + _HOME_CARD_GAP_);
  LCard.Position.Y := ARow * (_HOME_CARD_HEIGHT_ + _HOME_CARD_ROW_GAP_);
end;

procedure TPageSamplesHome.LayoutReference;
begin
  FReference.Position.X := (ClientWidth - _HOME_REFERENCE_WIDTH_) / 2;
  FReference.Position.Y := 0;
end;

procedure TPageSamplesHome.FormResized(ASender: TObject);
begin
  if Assigned(FReference) then
    LayoutReference;
end;

procedure TPageSamplesHome.CloseRequested(ASender: TObject);
begin
  FPresenter.Close;
end;

procedure TPageSamplesHome.ComponentRequested(ASender: TObject);
var
  LAction: TRectangle;
  LCard: TRectangle;
begin
  LAction := TRectangle(ASender);
  LCard := TRectangle(LAction.Parent);
  FPresenter.OpenComponent(TSampleComponent(LCard.Tag));
end;

procedure TPageSamplesHome.CloseMouseEnter(ASender: TObject);
begin
  TRectangle(ASender).Fill.Color := _HOME_CLOSE_HOVER_;
end;

procedure TPageSamplesHome.CloseMouseLeave(ASender: TObject);
begin
  TRectangle(ASender).Fill.Color := _HOME_TOP_BAR_BACKGROUND_;
end;

end.
