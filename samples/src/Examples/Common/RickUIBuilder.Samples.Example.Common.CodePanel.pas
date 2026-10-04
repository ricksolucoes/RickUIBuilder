{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Example.Common.CodePanel                              }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Encapsular a superfície de código reutilizável da Sample Page Base.         }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Materializa exclusivamente o bloco rolável de código monoespaçado           }
{  preenchido pelas páginas derivadas. A seleção Código Delphi/Resultado       }
{  pertence a TExampleViewSelector.                                            }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - RickUIBuilder.Samples.Example.Common.Style                                }
{      Fornece geometria, fonte e paleta do painel de código.                  }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - TExampleCommon cria este painel dentro da área principal.                 }
{  - As páginas derivadas preenchem o snippet por SetCodeText.                 }
{  - TExampleCommon controla sua visibilidade conforme o seletor comum.        }
{                                                                              }
{  Ownership / lifetime                                                        }
{  --------------------                                                        }
{  - O painel e seus controles internos pertencem à árvore visual da base.     }
{  - O texto exibido fica no TText interno e é substituído por SetCodeText.    }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - Não implementa seleção de view, resultado, execução ou syntax highlight.  }
{  - TTextAlign exige FMX.Types e TBrushKind exige FMX.Graphics explicitamente.}
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
  /// <summary>Superfície rolável de código da página.</summary>
  TExampleCodePanel = class(TLayout)
  strict private
    FCodeText: TText;
    procedure ConfigureLayout;
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
  FMX.Graphics,
  FMX.Types,
  RickUIBuilder.Samples.Example.Common.Style;

constructor TExampleCodePanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ConfigureLayout;
  BuildCodeSurface;
end;

procedure TExampleCodePanel.ConfigureLayout;
begin
  SetBounds(0, _EXAMPLE_PAGE_VIEW_CONTENT_TOP_, _EXAMPLE_PAGE_MAIN_WIDTH_,
    _EXAMPLE_PAGE_VIEW_CONTENT_HEIGHT_);
end;

procedure TExampleCodePanel.BuildCodeSurface;
var
  LSurface: TRectangle;
begin
  LSurface := TRectangle.Create(Self);
  LSurface.Parent := Self;
  LSurface.SetBounds(0, 0, _EXAMPLE_PAGE_MAIN_WIDTH_,
    _EXAMPLE_PAGE_VIEW_CONTENT_HEIGHT_);
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
    _EXAMPLE_PAGE_VIEW_CONTENT_HEIGHT_ - (_EXAMPLE_PAGE_CODE_PADDING_ * 2));
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
