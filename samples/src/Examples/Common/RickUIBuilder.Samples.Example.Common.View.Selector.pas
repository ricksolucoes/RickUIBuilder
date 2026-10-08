{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Example.Common.View.Selector                          }
{                                                                              }
{ Esta unit implementa o seletor reutilizável Código Delphi/Resultado usando   }
{ a largura principal calculada pelo layout efetivo da Sample Page Base.       }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Encapsular o seletor reutilizável entre Código Delphi e Resultado da        }
{  Sample Page Base.                                                           }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Materializa as duas opções visuais, mantém exatamente uma selecionada e     }
{  notifica a base quando o usuário alterna a visualização ativa.              }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - RickUIBuilder.Samples.App.Types                                           }
{      Fornece TExampleView, estado compartilhado da seleção Código/Resultado. }
{  - RickUIBuilder.Samples.App.Typography                                      }
{      Fornece o token tipográfico das opções do seletor.                      }
{  - RickUIBuilder.Samples.Example.Common.Style                                }
{      Fornece geometria e paleta do seletor.                                  }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - TExampleCommon cria TExampleViewSelector e recebe OnChange.               }
{  - A seleção determina qual painel estrutural fica visível: código ou        }
{    resultado.                                                                }
{                                                                              }
{  Ownership / lifetime                                                        }
{  --------------------                                                        }
{  - O seletor e seus controles internos pertencem à árvore visual da base.    }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - Não conhece componente, abordagem, snippet ou execução de sample.         }
{  - Não cria nem destrói TExampleCodePanel ou TExampleResultPanel.            }
{  - TTextAlign exige FMX.Types e TBrushKind exige FMX.Graphics explicitamente.}
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Atualizar este cabeçalho quando responsabilidade, dependências, fluxo ou    }
{  restrições desta unit mudarem.                                              }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.Example.Common.View.Selector;

interface

uses
  System.Classes,

  FMX.Layouts,
  FMX.Objects,

  RickUIBuilder.Samples.App.Types,
  RickUIBuilder.Samples.Example.Common.Style;

type

  /// <summary>Seletor comum entre a visualização de código e de resultado.</summary>
  TExampleViewSelector = class(TLayout)
  strict private
    FLayout: TExamplePageLayout;
    FCodeSurface: TRectangle;
    FCodeText: TText;
    FResultSurface: TRectangle;
    FResultText: TText;
    FSelectedView: TExampleView;
    FOnChange: TNotifyEvent;
    procedure ConfigureLayout;
    procedure BuildSelectors;
    procedure BuildSelector(var ASurface: TRectangle; var AText: TText;
      const ACaption: string; const ALeft, AWidth: Single);
    procedure ApplySelection;
    procedure ConfigureSelector(const ASurface: TRectangle; const AText: TText;
      const ASelected: Boolean);
    procedure CodeRequested(ASender: TObject);
    procedure ResultRequested(ASender: TObject);
    procedure ChangeView(const AView: TExampleView);
  public
    constructor Create(AOwner: TComponent;
      const ALayout: TExamplePageLayout); reintroduce;
    property SelectedView: TExampleView read FSelectedView;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

implementation

uses
  System.UITypes,
  FMX.Graphics,
  FMX.Types,
  RickUIBuilder.Samples.App.Typography;

constructor TExampleViewSelector.Create(AOwner: TComponent;
  const ALayout: TExamplePageLayout);
begin
  inherited Create(AOwner);
  FLayout := ALayout;
  FSelectedView := TExampleView.CodeView;
  ConfigureLayout;
  BuildSelectors;
  ApplySelection;
end;

procedure TExampleViewSelector.ConfigureLayout;
begin
  SetBounds(0, _EXAMPLE_PAGE_VIEW_SELECTOR_TOP_, FLayout.MainWidth,
    _EXAMPLE_PAGE_SELECTOR_HEIGHT_);
end;

procedure TExampleViewSelector.BuildSelectors;
begin
  BuildSelector(FCodeSurface, FCodeText, 'Código Delphi', 0,
    _EXAMPLE_PAGE_CODE_SELECTOR_WIDTH_);
  BuildSelector(FResultSurface, FResultText, 'Resultado',
    _EXAMPLE_PAGE_CODE_SELECTOR_WIDTH_, _EXAMPLE_PAGE_RESULT_SELECTOR_WIDTH_);
  FCodeSurface.OnClick := CodeRequested;
  FResultSurface.OnClick := ResultRequested;
end;

procedure TExampleViewSelector.BuildSelector(var ASurface: TRectangle;
  var AText: TText; const ACaption: string; const ALeft, AWidth: Single);
begin
  ASurface := TRectangle.Create(Self);
  ASurface.Parent := Self;
  ASurface.SetBounds(ALeft, 0, AWidth, _EXAMPLE_PAGE_SELECTOR_HEIGHT_);
  ASurface.Stroke.Kind := TBrushKind.None;
  ASurface.Cursor := crHandPoint;

  AText := TText.Create(ASurface);
  AText.Parent := ASurface;
  AText.Align := TAlignLayout.Client;
  AText.Text := ACaption;
  AText.TextSettings.Font.Size := _FONT_SIZE_NAVIGATION_;
  AText.TextSettings.HorzAlign := TTextAlign.Center;
  AText.TextSettings.VertAlign := TTextAlign.Center;
  AText.HitTest := False;
end;

procedure TExampleViewSelector.ApplySelection;
begin
  ConfigureSelector(FCodeSurface, FCodeText,
    FSelectedView = TExampleView.CodeView);
  ConfigureSelector(FResultSurface, FResultText,
    FSelectedView = TExampleView.ResultView);
end;

procedure TExampleViewSelector.ConfigureSelector(const ASurface: TRectangle;
  const AText: TText; const ASelected: Boolean);
begin
  ASurface.Fill.Kind := TBrushKind.Solid;
  ASurface.Fill.Color := _EXAMPLE_PAGE_BACKGROUND_;
  AText.TextSettings.FontColor := _EXAMPLE_PAGE_TEXT_SECONDARY_;
  if not ASelected then
    Exit;
  ASurface.Fill.Color := _EXAMPLE_PAGE_SELECTOR_SELECTED_BACKGROUND_;
  AText.TextSettings.FontColor := _EXAMPLE_PAGE_PRIMARY_;
end;

procedure TExampleViewSelector.CodeRequested(ASender: TObject);
begin
  ChangeView(TExampleView.CodeView);
end;

procedure TExampleViewSelector.ResultRequested(ASender: TObject);
begin
  ChangeView(TExampleView.ResultView);
end;

procedure TExampleViewSelector.ChangeView(const AView: TExampleView);
begin
  if FSelectedView = AView then
    Exit;
  FSelectedView := AView;
  ApplySelection;
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

end.
