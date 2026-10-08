{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Example.Common.Code.Panel                              }
{                                                                              }
{ Esta unit implementa a superfície de código read-only usando largura e altura }
{ calculadas pelo layout efetivo da Sample Page Base.                           }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Encapsular a superfície reutilizável de código Delphi da Sample Page Base.  }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Materializa um TMemo somente leitura e selecionável sobre a superfície      }
{  escura aprovada, preserva WordWrap desabilitado, permite Ctrl+C da seleção  }
{  e fornece a ação Copiar código para enviar o snippet completo ao clipboard. }
{  Após uma cópia bem-sucedida, a própria ação informa temporariamente Copiado.}
{  O background do TMemo é normalizado ao tema escuro após a aplicação do      }
{  style FMX, evitando a superfície branca do estilo padrão.                   }
{  As scrollbars pertencem ao próprio TMemo e ficam em modo AutoHide, evitando }
{  canvas artificialmente maior que force rolagem sem necessidade.             }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - RickUIBuilder.Samples.Example.Common.Style                                }
{      Fornece geometria, fonte e paleta do painel, feedback e ação Copiar.     }
{                                                                              }
{  Dependências FMX/RTL relevantes                                             }
{  --------------------------------                                            }
{  - FMX.Memo fornece TMemo para seleção e scroll nativos.                     }
{  - FMX.Platform fornece IFMXClipboardService para copiar o snippet completo. }
{  - FMX.Types fornece TTimer, TTextAlign e alinhamentos usados pela unit.      }
{  - FMX.Graphics é explícita porque a unit utiliza TBrushKind.                }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - TExampleCommon cria este painel dentro da área principal.                 }
{  - As páginas derivadas preenchem o snippet por SetCodeText.                 }
{  - O usuário pode selecionar texto diretamente no TMemo ou copiar tudo pela  }
{    ação Copiar código sem alterar o conteúdo, que permanece read-only.       }
{  - O feedback de cópia pertence ao painel e volta automaticamente ao estado  }
{    normal após o intervalo visual definido no Style comum.                   }
{  - TExampleCommon controla a visibilidade do painel conforme o seletor comum.}
{                                                                              }
{  Ownership / lifetime                                                        }
{  --------------------                                                        }
{  - O painel owns a superfície, o TMemo, a ação visual e o timer de feedback. }
{  - O clipboard é obtido como serviço da plataforma apenas durante a cópia.   }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - Não implementa seleção de view, resultado, execução ou syntax highlight.  }
{  - Não cria canvas fixa para forçar rolagem; o conteúdo do TMemo determina   }
{    quando a rolagem é necessária.                                            }
{  - Não permite edição do snippet apresentado.                                }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Este cabeçalho deve ser atualizado quando responsabilidade, dependências,   }
{  fluxo, ownership/lifetime ou restrições desta unit mudarem.                 }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.Example.Common.Code.Panel;

interface

uses
  System.Classes,
  FMX.Layouts,
  FMX.Memo,
  FMX.Objects,
  FMX.Types,

  RickUIBuilder.Samples.Example.Common.Style;

type
  /// <summary>
  /// Superfície de código somente leitura, selecionável, copiável e com scroll
  /// sob demanda.
  /// </summary>
  TExampleCodePanel = class(TLayout)
  strict private
    FLayout: TExamplePageLayout;
    FCodeMemo: TMemo;
    FCopyAction: TRectangle;
    FCopyCaption: TText;
    FCopyResetTimer: TTimer;
    procedure ConfigureLayout;
    procedure BuildCodeSurface;
    procedure ConfigureCodeSurface(const ASurface: TRectangle);
    procedure AddCopyAction(const ASurface: TRectangle);
    procedure ConfigureCopyAction(const AAction: TRectangle);
    procedure AddCopyCaption(const AAction: TRectangle);
    procedure ConfigureCopyFeedback;
    procedure AddCodeMemo(const ASurface: TRectangle);
    procedure ConfigureCodeMemo;
    procedure ConfigureCodeText;
    procedure CodeMemoStyleApplied(ASender: TObject);
    procedure ApplyCodeMemoBackground;
    function TryConfigureMemoBackground(const ABackground: TFmxObject): Boolean;
    function EnsureMemoBackgroundOverlay(const ABackground: TFmxObject): TRectangle;
    procedure ConfigureMemoBackgroundRectangle(const ABackground: TRectangle);
    procedure CopyCode(ASender: TObject);
    procedure ShowCopiedFeedback;
    procedure ResetCopyFeedback(ASender: TObject);
  public
    constructor Create(AOwner: TComponent;
      const ALayout: TExamplePageLayout); reintroduce;
    procedure SetCodeText(const ACode: string);
  end;

implementation

uses
  System.Rtti,
  System.UITypes,
  FMX.BehaviorManager,
  FMX.Graphics,
  FMX.Platform;

const
  _CODE_MEMO_BACKGROUND_STYLE_ = 'samplecodebackground';
  _COPY_CAPTION_ = 'Copiar código';
  _COPIED_CAPTION_ = 'Copiado';

constructor TExampleCodePanel.Create(AOwner: TComponent;
  const ALayout: TExamplePageLayout);
begin
  inherited Create(AOwner);
  FLayout := ALayout;
  ConfigureLayout;
  BuildCodeSurface;
end;

procedure TExampleCodePanel.ConfigureLayout;
begin
  SetBounds(0, _EXAMPLE_PAGE_VIEW_CONTENT_TOP_, FLayout.MainWidth,
    FLayout.ViewContentHeight);
end;

procedure TExampleCodePanel.BuildCodeSurface;
var
  LSurface: TRectangle;
begin
  LSurface := TRectangle.Create(Self);
  LSurface.Parent := Self;
  LSurface.SetBounds(0, 0, FLayout.MainWidth,
    FLayout.ViewContentHeight);
  ConfigureCodeSurface(LSurface);
  AddCopyAction(LSurface);
  AddCodeMemo(LSurface);
  ConfigureCopyFeedback;
end;

procedure TExampleCodePanel.ConfigureCodeSurface(const ASurface: TRectangle);
begin
  ASurface.Fill.Kind := TBrushKind.Solid;
  ASurface.Fill.Color := _EXAMPLE_PAGE_CODE_BACKGROUND_;
  ASurface.Stroke.Kind := TBrushKind.None;
  ASurface.XRadius := 6;
  ASurface.YRadius := 6;
end;

procedure TExampleCodePanel.AddCopyAction(const ASurface: TRectangle);
var
  LAction: TRectangle;
begin
  LAction := TRectangle.Create(ASurface);
  LAction.Parent := ASurface;
  LAction.SetBounds(FLayout.MainWidth - _EXAMPLE_PAGE_CODE_PADDING_ -
    _EXAMPLE_PAGE_CODE_COPY_WIDTH_, _EXAMPLE_PAGE_CODE_COPY_TOP_,
    _EXAMPLE_PAGE_CODE_COPY_WIDTH_, _EXAMPLE_PAGE_CODE_COPY_HEIGHT_);
  ConfigureCopyAction(LAction);
  AddCopyCaption(LAction);
  FCopyAction := LAction;
end;

procedure TExampleCodePanel.ConfigureCopyAction(const AAction: TRectangle);
begin
  AAction.Fill.Kind := TBrushKind.Solid;
  AAction.Fill.Color := _EXAMPLE_PAGE_CODE_COPY_BACKGROUND_;
  AAction.Stroke.Kind := TBrushKind.None;
  AAction.XRadius := _EXAMPLE_PAGE_CODE_COPY_RADIUS_;
  AAction.YRadius := _EXAMPLE_PAGE_CODE_COPY_RADIUS_;
  AAction.Cursor := crHandPoint;
  AAction.OnClick := CopyCode;
end;

procedure TExampleCodePanel.AddCopyCaption(const AAction: TRectangle);
var
  LCaption: TText;
begin
  LCaption := TText.Create(AAction);
  LCaption.Parent := AAction;
  LCaption.Align := TAlignLayout.Contents;
  LCaption.Text := _COPY_CAPTION_;
  LCaption.TextSettings.Font.Size := _EXAMPLE_PAGE_CODE_COPY_FONT_SIZE_;
  LCaption.TextSettings.FontColor := _EXAMPLE_PAGE_CODE_COPY_TEXT_;
  LCaption.TextSettings.HorzAlign := TTextAlign.Center;
  LCaption.TextSettings.VertAlign := TTextAlign.Center;
  LCaption.HitTest := False;
  FCopyCaption := LCaption;
end;

procedure TExampleCodePanel.ConfigureCopyFeedback;
begin
  FCopyResetTimer := TTimer.Create(Self);
  FCopyResetTimer.Enabled := False;
  FCopyResetTimer.Interval := _EXAMPLE_PAGE_CODE_COPY_FEEDBACK_MS_;
  FCopyResetTimer.OnTimer := ResetCopyFeedback;
end;

procedure TExampleCodePanel.AddCodeMemo(const ASurface: TRectangle);
begin
  FCodeMemo := TMemo.Create(ASurface);
  FCodeMemo.Parent := ASurface;
  FCodeMemo.SetBounds(_EXAMPLE_PAGE_CODE_PADDING_, _EXAMPLE_PAGE_CODE_MEMO_TOP_,
    FLayout.MainWidth - (_EXAMPLE_PAGE_CODE_PADDING_ * 2),
    FLayout.ViewContentHeight - _EXAMPLE_PAGE_CODE_MEMO_TOP_ -
    _EXAMPLE_PAGE_CODE_PADDING_);
  ConfigureCodeMemo;
  ConfigureCodeText;
end;

procedure TExampleCodePanel.ConfigureCodeMemo;
begin
  FCodeMemo.ReadOnly := True;
  FCodeMemo.WordWrap := False;
  FCodeMemo.ShowScrollBars := True;
  FCodeMemo.AutoHide := TBehaviorBoolean.True;
  FCodeMemo.StyledSettings := [];
  FCodeMemo.OnApplyStyleLookup := CodeMemoStyleApplied;
  FCodeMemo.ApplyStyleLookup;
end;

procedure TExampleCodePanel.ConfigureCodeText;
begin
  FCodeMemo.TextSettings.Font.Family := _EXAMPLE_PAGE_CODE_FONT_FAMILY_;
  FCodeMemo.TextSettings.Font.Size := _EXAMPLE_PAGE_CODE_FONT_SIZE_;
  FCodeMemo.TextSettings.FontColor := _EXAMPLE_PAGE_CODE_TEXT_;
  FCodeMemo.TextSettings.HorzAlign := TTextAlign.Leading;
  FCodeMemo.TextSettings.VertAlign := TTextAlign.Leading;
  FCodeMemo.SelectionFill.Kind := TBrushKind.Solid;
  FCodeMemo.SelectionFill.Color := _EXAMPLE_PAGE_CODE_SELECTION_;
end;

procedure TExampleCodePanel.CodeMemoStyleApplied(ASender: TObject);
begin
  ApplyCodeMemoBackground;
end;

procedure TExampleCodePanel.ApplyCodeMemoBackground;
var
  LBackground: TFmxObject;
  LOverlay: TRectangle;
begin
  LBackground := FCodeMemo.FindStyleResource('background');
  if LBackground = nil then
    Exit;
  if TryConfigureMemoBackground(LBackground) then
    Exit;
  LOverlay := EnsureMemoBackgroundOverlay(LBackground);
  ConfigureMemoBackgroundRectangle(LOverlay);
  LOverlay.SendToBack;
end;

function TExampleCodePanel.TryConfigureMemoBackground(
  const ABackground: TFmxObject): Boolean;
begin
  Result := ABackground is TRectangle;
  if not Result then
    Exit;
  ConfigureMemoBackgroundRectangle(TRectangle(ABackground));
end;

function TExampleCodePanel.EnsureMemoBackgroundOverlay(
  const ABackground: TFmxObject): TRectangle;
begin
  Result := ABackground.FindStyleResource(
    _CODE_MEMO_BACKGROUND_STYLE_) as TRectangle;
  if Result <> nil then
    Exit;
  Result := TRectangle.Create(ABackground);
  Result.Parent := ABackground;
  Result.StyleName := _CODE_MEMO_BACKGROUND_STYLE_;
  Result.Align := TAlignLayout.Contents;
  Result.HitTest := False;
end;

procedure TExampleCodePanel.ConfigureMemoBackgroundRectangle(
  const ABackground: TRectangle);
begin
  ABackground.Fill.Kind := TBrushKind.Solid;
  ABackground.Fill.Color := _EXAMPLE_PAGE_CODE_BACKGROUND_;
  ABackground.Stroke.Kind := TBrushKind.None;
end;

procedure TExampleCodePanel.CopyCode(ASender: TObject);
var
  LClipboard: IFMXClipboardService;
begin
  if not TPlatformServices.Current.SupportsPlatformService(
    IFMXClipboardService, IInterface(LClipboard)) then
    Exit;
  LClipboard.SetClipboard(TValue.From<string>(FCodeMemo.Text));
  ShowCopiedFeedback;
end;

procedure TExampleCodePanel.ShowCopiedFeedback;
begin
  FCopyCaption.Text := _COPIED_CAPTION_;
  FCopyAction.Fill.Color := _EXAMPLE_PAGE_CODE_COPY_SUCCESS_BACKGROUND_;
  FCopyResetTimer.Enabled := False;
  FCopyResetTimer.Enabled := True;
end;

procedure TExampleCodePanel.ResetCopyFeedback(ASender: TObject);
begin
  FCopyResetTimer.Enabled := False;
  FCopyCaption.Text := _COPY_CAPTION_;
  FCopyAction.Fill.Color := _EXAMPLE_PAGE_CODE_COPY_BACKGROUND_;
end;

procedure TExampleCodePanel.SetCodeText(const ACode: string);
begin
  FCodeMemo.Text := ACode;
  FCodeMemo.SelStart := 0;
  FCodeMemo.SelLength := 0;
  ResetCopyFeedback(nil);
end;

end.
