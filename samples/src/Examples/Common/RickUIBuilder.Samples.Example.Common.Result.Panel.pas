{ Esta unit implementa a view de Resultado ocupando toda a área útil restante e fornece o ResultHost, container estável onde as páginas derivadas materializam e substituem os controles executáveis de cada sample. }
{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Example.Common.Result.Panel                            }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Encapsular a região de resultado executável da Sample Page Base.            }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Materializa o título Resultado e uma superfície que preenche toda a view    }
{  disponível abaixo do seletor Código/Resultado. Dentro dela mantém ResultHost,}
{  layout estável usado pelas páginas derivadas como Parent dos controles reais.}
{  Clear libera apenas os filhos do ResultHost e preserva a infraestrutura.    }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - RickUIBuilder.Samples.App.Typography                                      }
{      Fornece o token tipográfico do título da região.                        }
{  - RickUIBuilder.Samples.Example.Common.Style                                }
{      Fornece geometria e paleta da superfície expandida de resultado.        }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - TExampleCommon cria o painel e expõe seu Host às páginas derivadas.        }
{  - A derivada chama ClearResult antes de materializar um novo exemplo.        }
{  - O Runner cria os controles do sample usando ResultHost como Parent; o host }
{    permanece o mesmo durante toda a vida da página.                          }
{  - TExampleCommon controla a visibilidade do painel conforme o seletor comum. }
{                                                                              }
{  Ownership / lifetime                                                        }
{  --------------------                                                        }
{  - O painel é owned pela área principal da Sample Page.                      }
{  - A superfície interna owns ResultHost.                                     }
{  - ResultHost owns os controles visuais materializados pelo sample.          }
{  - A derivada não deve liberar ou substituir ResultHost; somente seus filhos }
{    são removidos por Clear antes da próxima materialização.                  }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - Não cria controles de sample nem conhece Factory/Fluent Builder.          }
{  - Não controla a seleção Código Delphi/Resultado.                           }
{  - TTextAlign exige FMX.Types e TBrushKind exige FMX.Graphics explicitamente.}
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Este cabeçalho deve ser atualizado quando responsabilidade, dependências,   }
{  fluxo, ownership/lifetime ou restrições desta unit mudarem.                 }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.Example.Common.Result.Panel;

interface

uses
  System.Classes,
  FMX.Layouts,
  FMX.Objects;

type
  /// <summary>Região visual que hospeda o resultado executável do sample.</summary>
  TExampleResultPanel = class(TLayout)
  strict private
    FHost: TLayout;
    procedure ConfigureLayout;
    procedure AddTitle;
    procedure AddSurface;
    procedure ConfigureSurface(const ASurface: TRectangle);
    procedure BuildHost(const ASurface: TRectangle);
  public
    constructor Create(AOwner: TComponent); override;
    /// <summary>
    /// Remove e libera os controles materializados no ResultHost, preservando
    /// o próprio host para que o próximo sample reutilize a mesma infraestrutura.
    /// </summary>
    procedure Clear;
    /// <summary>
    /// Container owned pela superfície de resultado. Páginas derivadas podem
    /// usá-lo como Parent dos controles do sample, mas não devem liberá-lo,
    /// substituí-lo ou transferir sua ownership.
    /// </summary>
    property Host: TLayout read FHost;
  end;

implementation

uses
  System.UITypes,
  FMX.Graphics,
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
  SetBounds(0, _EXAMPLE_PAGE_VIEW_CONTENT_TOP_, _EXAMPLE_PAGE_MAIN_WIDTH_,
    _EXAMPLE_PAGE_VIEW_CONTENT_HEIGHT_);
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
    _EXAMPLE_PAGE_MAIN_WIDTH_, _EXAMPLE_PAGE_RESULT_SURFACE_HEIGHT_);
  ConfigureSurface(LSurface);
  BuildHost(LSurface);
end;

procedure TExampleResultPanel.ConfigureSurface(const ASurface: TRectangle);
begin
  ASurface.Fill.Kind := TBrushKind.Solid;
  ASurface.Fill.Color := _EXAMPLE_PAGE_RESULT_BACKGROUND_;
  ASurface.Stroke.Kind := TBrushKind.Solid;
  ASurface.Stroke.Color := _EXAMPLE_PAGE_RESULT_BORDER_;
  ASurface.XRadius := 6;
  ASurface.YRadius := 6;
end;

procedure TExampleResultPanel.BuildHost(const ASurface: TRectangle);
begin
  FHost := TLayout.Create(ASurface);
  FHost.Parent := ASurface;
  FHost.SetBounds(_EXAMPLE_PAGE_RESULT_PADDING_, _EXAMPLE_PAGE_RESULT_PADDING_,
    _EXAMPLE_PAGE_MAIN_WIDTH_ - (_EXAMPLE_PAGE_RESULT_PADDING_ * 2),
    _EXAMPLE_PAGE_RESULT_SURFACE_HEIGHT_ - (_EXAMPLE_PAGE_RESULT_PADDING_ * 2));
end;

procedure TExampleResultPanel.Clear;
begin
  while FHost.ChildrenCount > 0 do
    FHost.Children[0].Free;
end;

end.
