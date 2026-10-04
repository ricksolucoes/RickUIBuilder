{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Example.Common.CodePanel                              }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Encapsular a faixa visual e a superfície de código da Sample Page Base.     }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Materializa os indicadores visuais Código Delphi/Resultado e o bloco        }
{  rolável de código monoespaçado preenchido pelas páginas derivadas.          }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - RickUIBuilder.Samples.App.Typography                                      }
{      Fornece o token tipográfico da faixa visual.                            }
{  - RickUIBuilder.Samples.Example.Common.Style                                }
{      Fornece geometria, fonte e paleta do painel de código.                  }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - TExampleCommon cria este painel dentro da área principal.                 }
{  - As páginas derivadas preenchem o snippet por SetCodeText.                 }
{                                                                              }
{  Ownership / lifetime                                                        }
{  --------------------                                                        }
{  - O painel e seus controles internos pertencem à árvore visual da base.     }
{  - O texto exibido fica no TText interno e é substituído por SetCodeText.    }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - A faixa Código Delphi/Resultado é somente visual nesta etapa.             }
{  - Esta unit não implementa tabs, execução de sample ou syntax highlighting. }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Este cabeçalho deve ser atualizado quando responsabilidade, dependências,   }
{  fluxo ou restrições desta unit mudarem.                                     }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.Example.Common.CodePanel;

interface

uses
  System.Classes,
  FMX.Layouts,
  FMX.Objects;

type
  /// <summary>Faixa visual e superfície rolável de código da página.</summary>
  TExampleCodePanel = class(TLayout)
  strict private
    FCodeText: TText;
    procedure ConfigureLayout;
    procedure BuildViewSelector;
    procedure AddViewSelector(const ACaption: string; const ALeft,
      AWidth: Single; const ASelected: Boolean);
    procedure ConfigureViewSelector(const ASurface: TRectangle;
      const ASelected: Boolean);
    procedure AddViewSelectorText(const ASurface: TRectangle;
      const ACaption: string; const ASelected: Boolean);
    procedure BuildCodeSurface;
    procedure ConfigureCodeSurface(const ASurface: TRectangle);
    procedure AddCodeScroll(const ASurface: TRectangle);
    procedure AddCodeText(const AScroll: TScrollBox);
  public
    constructor Create(AOwner: TComponent); override;
    procedure SetCodeText(const ACode: string);
  end;

implementation

uses
  System.UITypes,
  FMX.Graphics,
  FMX.Types,
  RickUIBuilder.Samples.App.Typography,
  RickUIBuilder.Samples.Example.Common.Style;

constructor TExampleCodePanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ConfigureLayout;
  BuildViewSelector;
  BuildCodeSurface;
end;

procedure TExampleCodePanel.ConfigureLayout;
begin
  SetBounds(0, _EXAMPLE_PAGE_CODE_PANEL_TOP_, _EXAMPLE_PAGE_MAIN_WIDTH_,
    _EXAMPLE_PAGE_CODE_PANEL_HEIGHT_);
end;

procedure TExampleCodePanel.BuildViewSelector;
begin
  AddViewSelector('Código Delphi', 0, 96, True);
  AddViewSelector('Resultado', 96, 78, False);
end;

procedure TExampleCodePanel.AddViewSelector(const ACaption: string;
  const ALeft, AWidth: Single; const ASelected: Boolean);
var
  LSurface: TRectangle;
begin
  LSurface := TRectangle.Create(Self);
  LSurface.Parent := Self;
  LSurface.SetBounds(ALeft, 0, AWidth, _EXAMPLE_PAGE_SELECTOR_HEIGHT_);
  ConfigureViewSelector(LSurface, ASelected);
  AddViewSelectorText(LSurface, ACaption, ASelected);
end;

procedure TExampleCodePanel.ConfigureViewSelector(const ASurface: TRectangle;
  const ASelected: Boolean);
begin
  ASurface.Fill.Kind := TBrushKind.Solid;
  ASurface.Fill.Color := _EXAMPLE_PAGE_SURFACE_BACKGROUND_;
  if ASelected then
    ASurface.Fill.Color := _EXAMPLE_PAGE_NAV_SELECTED_BACKGROUND_;
  ASurface.Stroke.Kind := TBrushKind.None;
  ASurface.HitTest := False;
end;

procedure TExampleCodePanel.AddViewSelectorText(const ASurface: TRectangle;
  const ACaption: string; const ASelected: Boolean);
var
  LText: TText;
begin
  LText := TText.Create(ASurface);
  LText.Parent := ASurface;
  LText.Align := TAlignLayout.Client;
  LText.Text := ACaption;
  LText.TextSettings.Font.Size := _FONT_SIZE_NAVIGATION_;
  LText.TextSettings.FontColor := _EXAMPLE_PAGE_TEXT_SECONDARY_;
  if ASelected then
    LText.TextSettings.FontColor := _EXAMPLE_PAGE_PRIMARY_;
  LText.TextSettings.HorzAlign := TTextAlign.Center;
  LText.TextSettings.VertAlign := TTextAlign.Center;
  LText.HitTest := False;
end;

procedure TExampleCodePanel.BuildCodeSurface;
var
  LSurface: TRectangle;
begin
  LSurface := TRectangle.Create(Self);
  LSurface.Parent := Self;
  LSurface.SetBounds(0, _EXAMPLE_PAGE_CODE_SURFACE_TOP_,
    _EXAMPLE_PAGE_MAIN_WIDTH_, _EXAMPLE_PAGE_CODE_HEIGHT_);
  ConfigureCodeSurface(LSurface);
  AddCodeScroll(LSurface);
end;

procedure TExampleCodePanel.ConfigureCodeSurface(const ASurface: TRectangle);
begin
  ASurface.Fill.Kind := TBrushKind.Solid;
  ASurface.Fill.Color := _EXAMPLE_PAGE_CODE_BACKGROUND_;
  ASurface.Stroke.Kind := TBrushKind.None;
  ASurface.XRadius := 6;
  ASurface.YRadius := 6;
end;

procedure TExampleCodePanel.AddCodeScroll(const ASurface: TRectangle);
var
  LScroll: TScrollBox;
begin
  LScroll := TScrollBox.Create(ASurface);
  LScroll.Parent := ASurface;
  LScroll.SetBounds(_EXAMPLE_PAGE_CODE_PADDING_, _EXAMPLE_PAGE_CODE_PADDING_,
    _EXAMPLE_PAGE_MAIN_WIDTH_ - (_EXAMPLE_PAGE_CODE_PADDING_ * 2),
    _EXAMPLE_PAGE_CODE_HEIGHT_ - (_EXAMPLE_PAGE_CODE_PADDING_ * 2));
  AddCodeText(LScroll);
end;

procedure TExampleCodePanel.AddCodeText(const AScroll: TScrollBox);
begin
  FCodeText := TText.Create(AScroll);
  FCodeText.Parent := AScroll;
  FCodeText.SetBounds(0, 0, _EXAMPLE_PAGE_CODE_CANVAS_WIDTH_,
    _EXAMPLE_PAGE_CODE_CANVAS_HEIGHT_);
  FCodeText.WordWrap := False;
  FCodeText.TextSettings.Font.Family := _EXAMPLE_PAGE_CODE_FONT_FAMILY_;
  FCodeText.TextSettings.Font.Size := _EXAMPLE_PAGE_CODE_FONT_SIZE_;
  FCodeText.TextSettings.FontColor := _EXAMPLE_PAGE_CODE_TEXT_;
  FCodeText.TextSettings.HorzAlign := TTextAlign.Leading;
  FCodeText.TextSettings.VertAlign := TTextAlign.Leading;
  FCodeText.HitTest := False;
end;

procedure TExampleCodePanel.SetCodeText(const ACode: string);
begin
  FCodeText.Text := ACode;
end;

end.
