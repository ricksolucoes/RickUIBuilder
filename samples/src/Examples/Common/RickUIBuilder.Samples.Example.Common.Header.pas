{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Example.Common.Header                                 }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Materializar o header reutilizável das páginas de exemplos do Samples.      }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Cria a superfície superior, a ação de retorno, o ícone vetorial e o texto   }
{  que identifica a Component Page de origem.                                  }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - RickUIBuilder.Samples.App.Typography                                      }
{      Fornece o token tipográfico usado no título do header.                  }
{  - RickUIBuilder.Samples.Example.Common.Icons                                }
{      Fornece a geometria vetorial da seta de retorno.                        }
{  - RickUIBuilder.Samples.Example.Common.Style                                }
{      Fornece dimensões e cores da família de páginas de exemplos.            }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - TExampleCommon cria esta superfície e associa seu callback de retorno.    }
{  - Futuras páginas derivadas apenas informam, por TExampleCommon, o nome da  }
{    Component Page de origem exibido neste header.                            }
{                                                                              }
{  Ownership / lifetime                                                        }
{  --------------------                                                        }
{  - O header é owned pela página que o cria.                                  }
{  - A ação e o ícone são owned pelo próprio header.                           }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - Não conhece componente concreto, abordagem ou destino de navegação.       }
{  - O callback de retorno é recebido externamente; esta unit não fecha forms. }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Este cabeçalho deve ser atualizado quando responsabilidade, dependências,   }
{  fluxo, ownership/lifetime ou restrições desta unit mudarem.                 }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.Example.Common.Header;

interface

uses
  System.Classes,
  FMX.Objects;

type
  /// <summary>Header comum com retorno e contexto da página de origem.</summary>
  TExampleHeader = class(TRectangle)
  strict private
    FTitle: TText;
    FBackAction: TRectangle;
    procedure ConfigureSurface;
    procedure BuildBackAction;
    procedure ConfigureBackAction;
    procedure AddBackIcon;
    procedure BuildTitle;
    procedure BackMouseEnter(ASender: TObject);
    procedure BackMouseLeave(ASender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    procedure SetTitle(const ATitle: string);
    procedure SetBackAction(const AOnClick: TNotifyEvent);
  end;

implementation

uses
  System.UITypes,
  FMX.Graphics,
  FMX.Types,
  RickUIBuilder.Samples.App.Typography,
  RickUIBuilder.Samples.Example.Common.Icons,
  RickUIBuilder.Samples.Example.Common.Style;

constructor TExampleHeader.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ConfigureSurface;
  BuildBackAction;
  BuildTitle;
end;

procedure TExampleHeader.ConfigureSurface;
begin
  Align := TAlignLayout.Top;
  Height := _EXAMPLE_PAGE_TOP_BAR_HEIGHT_;
  Fill.Kind := TBrushKind.Solid;
  Fill.Color := _EXAMPLE_PAGE_TOP_BAR_BACKGROUND_;
  Stroke.Kind := TBrushKind.Solid;
  Stroke.Color := _EXAMPLE_PAGE_BORDER_;
end;

procedure TExampleHeader.BuildBackAction;
begin
  FBackAction := TRectangle.Create(Self);
  FBackAction.Parent := Self;
  ConfigureBackAction;
  AddBackIcon;
end;

procedure TExampleHeader.ConfigureBackAction;
begin
  FBackAction.SetBounds(8, 4, 34, 32);
  FBackAction.Fill.Kind := TBrushKind.Solid;
  FBackAction.Fill.Color := _EXAMPLE_PAGE_TOP_BAR_BACKGROUND_;
  FBackAction.Stroke.Kind := TBrushKind.None;
  FBackAction.XRadius := 6;
  FBackAction.YRadius := 6;
  FBackAction.Cursor := crHandPoint;
  FBackAction.OnMouseEnter := BackMouseEnter;
  FBackAction.OnMouseLeave := BackMouseLeave;
end;

procedure TExampleHeader.AddBackIcon;
var
  LIcon: TPath;
begin
  LIcon := TPath.Create(FBackAction);
  LIcon.Parent := FBackAction;
  LIcon.SetBounds(9, 8, 16, 16);
  LIcon.Data.Data := _EXAMPLE_PAGE_ICON_BACK_;
  LIcon.WrapMode := TPathWrapMode.Fit;
  LIcon.Fill.Kind := TBrushKind.Solid;
  LIcon.Fill.Color := _EXAMPLE_PAGE_TEXT_SECONDARY_;
  LIcon.Stroke.Kind := TBrushKind.None;
  LIcon.HitTest := False;
end;

procedure TExampleHeader.BuildTitle;
begin
  FTitle := TText.Create(Self);
  FTitle.Parent := Self;
  FTitle.SetBounds(48, 0, 240, _EXAMPLE_PAGE_TOP_BAR_HEIGHT_);
  FTitle.TextSettings.Font.Size := _FONT_SIZE_NAVIGATION_;
  FTitle.TextSettings.Font.Style := [TFontStyle.fsBold];
  FTitle.TextSettings.FontColor := _EXAMPLE_PAGE_TEXT_PRIMARY_;
  FTitle.TextSettings.HorzAlign := TTextAlign.Leading;
  FTitle.TextSettings.VertAlign := TTextAlign.Center;
  FTitle.HitTest := False;
end;

procedure TExampleHeader.SetTitle(const ATitle: string);
begin
  FTitle.Text := ATitle;
end;

procedure TExampleHeader.SetBackAction(const AOnClick: TNotifyEvent);
begin
  FBackAction.OnClick := AOnClick;
end;

procedure TExampleHeader.BackMouseEnter(ASender: TObject);
begin
  TRectangle(ASender).Fill.Color := _EXAMPLE_PAGE_BACK_HOVER_;
end;

procedure TExampleHeader.BackMouseLeave(ASender: TObject);
begin
  TRectangle(ASender).Fill.Color := _EXAMPLE_PAGE_TOP_BAR_BACKGROUND_;
end;

end.
