{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Example.Common.ResultPanel                            }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Encapsular a região de resultado executável da Sample Page Base.            }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Materializa o título Resultado, a superfície visual e o host onde as páginas }
{  derivadas criam os controles reais de cada sample.                            }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - RickUIBuilder.Samples.App.Typography                                      }
{      Fornece o token tipográfico do título da região.                        }
{  - RickUIBuilder.Samples.Example.Common.Style                                }
{      Fornece geometria e paleta da superfície de resultado.                  }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - TExampleCommon cria o painel e expõe seu Host às páginas derivadas.         }
{  - Clear remove os filhos visuais antes de um novo resultado.                }
{                                                                              }
{  Ownership / lifetime                                                        }
{  --------------------                                                        }
{  - O painel é owned pela área principal da Sample Page.                      }
{  - Host é owned pela superfície interna e owns os controles de cada resultado.}
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - Não cria controles de sample nem conhece Factory/Fluent Builder.          }
{  - Não afirma ausência de leaks; apenas executa a limpeza visual definida.   }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Este cabeçalho deve ser atualizado quando responsabilidade, dependências,   }
{  fluxo, ownership/lifetime ou restrições desta unit mudarem.                 }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.Example.Common.ResultPanel;

interface

uses
  System.Classes,
  FMX.Layouts;

type
  /// <summary>Região visual que hospeda o resultado executável do sample.</summary>
  TExampleResultPanel = class(TLayout)
  strict private
    FHost: TLayout;
    procedure ConfigureLayout;
    procedure AddTitle;
    procedure AddSurface;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Clear;
    property Host: TLayout read FHost;
  end;

implementation

uses
  System.UITypes,
  FMX.Graphics,
  FMX.Objects,
  FMX.Types,
  RickUIBuilder.Samples.App.Typography,
  RickUIBuilder.Samples.Example.Common.Style;

constructor TExampleResultPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ConfigureLayout;
  AddTitle;
  AddSurface;
end;

procedure TExampleResultPanel.ConfigureLayout;
begin
  SetBounds(0, _EXAMPLE_PAGE_RESULT_PANEL_TOP_, _EXAMPLE_PAGE_MAIN_WIDTH_,
    _EXAMPLE_PAGE_RESULT_PANEL_HEIGHT_);
end;

procedure TExampleResultPanel.AddTitle;
var
  LTitle: TText;
begin
  LTitle := TText.Create(Self);
  LTitle.Parent := Self;
  LTitle.SetBounds(0, 0, _EXAMPLE_PAGE_MAIN_WIDTH_,
    _EXAMPLE_PAGE_RESULT_TITLE_HEIGHT_);
  LTitle.Text := 'Resultado';
  LTitle.TextSettings.Font.Size := _FONT_SIZE_BODY_;
  LTitle.TextSettings.Font.Style := [TFontStyle.fsBold];
  LTitle.TextSettings.FontColor := _EXAMPLE_PAGE_TEXT_PRIMARY_;
  LTitle.TextSettings.HorzAlign := TTextAlign.Leading;
  LTitle.TextSettings.VertAlign := TTextAlign.Center;
  LTitle.HitTest := False;
end;

procedure TExampleResultPanel.AddSurface;
var
  LSurface: TRectangle;
begin
  LSurface := TRectangle.Create(Self);
  LSurface.Parent := Self;
  LSurface.SetBounds(0, _EXAMPLE_PAGE_RESULT_SURFACE_TOP_,
    _EXAMPLE_PAGE_MAIN_WIDTH_, _EXAMPLE_PAGE_RESULT_HEIGHT_);
  LSurface.Fill.Kind := TBrushKind.Solid;
  LSurface.Fill.Color := _EXAMPLE_PAGE_SURFACE_BACKGROUND_;
  LSurface.Stroke.Kind := TBrushKind.Solid;
  LSurface.Stroke.Color := _EXAMPLE_PAGE_BORDER_;
  LSurface.XRadius := 6;
  LSurface.YRadius := 6;
  FHost := TLayout.Create(LSurface);
  FHost.Parent := LSurface;
  FHost.SetBounds(8, 8, _EXAMPLE_PAGE_MAIN_WIDTH_ - 16,
    _EXAMPLE_PAGE_RESULT_HEIGHT_ - 16);
end;

procedure TExampleResultPanel.Clear;
begin
  while FHost.ChildrenCount > 0 do
    FHost.Children[0].Free;
end;

end.
