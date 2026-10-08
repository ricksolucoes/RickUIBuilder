{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Example.Common.Style                                  }
{                                                                              }
{ Esta unit centraliza os tokens visuais e o layout efetivo da Sample Page     }
{ Base, preservando defaults comuns e cálculos derivados para especializações  }
{ controladas pelas páginas concretas.                                         }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Centralizar geometria, paleta e o contrato de layout compartilhado pela     }
{  família de páginas de exemplos do Samples.                                  }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Define os defaults da janela e navegação, expõe TExamplePageLayout para     }
{  especialização controlada e calcula larguras/alturas derivadas usadas pela  }
{  base, código, resultado, seletor e navegação.                                }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - Não possui dependências internas do projeto.                              }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - TExampleCommon inicia TExamplePageLayout com Default e permite que uma    }
{    derivada ajuste somente os valores primários antes da construção visual.  }
{  - As units estruturais recebem o layout efetivo e usam métricas derivadas.  }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - O default permanece 620 x 510, menor que a Home de 644 x 534.             }
{  - Toda especialização deve continuar estritamente menor que a Home.         }
{  - Tipografia compartilhada permanece em RickUIBuilder.Samples.App.Typography.}
{  - Esta unit não contém conteúdo específico de componente ou abordagem.      }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Atualizar defaults e cálculos derivados em conjunto quando o contrato de    }
{  layout da Sample Page Base mudar.                                           }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.Example.Common.Style;

interface

type
  /// <summary>
  /// Valores primários do layout de uma Sample Page e métricas derivadas usadas
  /// pela infraestrutura comum.
  /// </summary>
  TExamplePageLayout = record
  public
    PageWidth: Single;
    PageHeight: Single;
    NavigationWidth: Single;
    NavigationItemHeight: Single;
    class function Default: TExamplePageLayout; static;
    function ContentWidth: Single;
    function BodyHeight: Single;
    function NavigationItemWidth: Single;
    function NavigationIndicatorHeight: Single;
    function MainWidth: Single;
    function ViewContentHeight: Single;
    function ResultSurfaceHeight: Single;
  end;

const
  _EXAMPLE_PAGE_WIDTH_ = 620;
  _EXAMPLE_PAGE_HEIGHT_ = 510;
  _EXAMPLE_PAGE_TOP_BAR_HEIGHT_ = 40;

  _EXAMPLE_PAGE_CONTENT_LEFT_ = 16;
  _EXAMPLE_PAGE_CONTENT_RIGHT_ = 16;
  _EXAMPLE_PAGE_CONTENT_BOTTOM_ = 16;
  _EXAMPLE_PAGE_TITLE_TOP_ = 52;
  _EXAMPLE_PAGE_TITLE_HEIGHT_ = 30;
  _EXAMPLE_PAGE_SUBTITLE_TOP_ = 84;
  _EXAMPLE_PAGE_SUBTITLE_HEIGHT_ = 30;

  _EXAMPLE_PAGE_BODY_TOP_ = 124;
  _EXAMPLE_PAGE_NAV_WIDTH_ = 142;
  _EXAMPLE_PAGE_BODY_GAP_ = 14;

  _EXAMPLE_PAGE_NAV_PADDING_ = 6;
  _EXAMPLE_PAGE_NAV_ITEM_HEIGHT_ = 28;
  _EXAMPLE_PAGE_NAV_ITEM_GAP_ = 3;
  _EXAMPLE_PAGE_NAV_ITEM_RADIUS_ = 4;
  _EXAMPLE_PAGE_NAV_INDICATOR_WIDTH_ = 2;
  _EXAMPLE_PAGE_NAV_INDICATOR_TOP_ = 2;

  _EXAMPLE_PAGE_EXAMPLE_TITLE_TOP_ = 0;
  _EXAMPLE_PAGE_EXAMPLE_TITLE_HEIGHT_ = 24;
  _EXAMPLE_PAGE_EXAMPLE_DESCRIPTION_TOP_ = 24;
  _EXAMPLE_PAGE_EXAMPLE_DESCRIPTION_HEIGHT_ = 30;

  _EXAMPLE_PAGE_VIEW_SELECTOR_TOP_ = 58;
  _EXAMPLE_PAGE_SELECTOR_HEIGHT_ = 30;
  _EXAMPLE_PAGE_CODE_SELECTOR_WIDTH_ = 96;
  _EXAMPLE_PAGE_RESULT_SELECTOR_WIDTH_ = 78;
  _EXAMPLE_PAGE_VIEW_CONTENT_TOP_ = 92;

  _EXAMPLE_PAGE_CODE_PADDING_ = 10;
  _EXAMPLE_PAGE_CODE_COPY_TOP_ = 8;
  _EXAMPLE_PAGE_CODE_COPY_WIDTH_ = 96;
  _EXAMPLE_PAGE_CODE_COPY_HEIGHT_ = 24;
  _EXAMPLE_PAGE_CODE_COPY_RADIUS_ = 4;
  _EXAMPLE_PAGE_CODE_COPY_FONT_SIZE_ = 11;
  _EXAMPLE_PAGE_CODE_COPY_FEEDBACK_MS_ = 1500;
  _EXAMPLE_PAGE_CODE_MEMO_TOP_ = 38;
  _EXAMPLE_PAGE_CODE_FONT_SIZE_ = 12;
  _EXAMPLE_PAGE_CODE_FONT_FAMILY_ = 'Consolas';

  _EXAMPLE_PAGE_RESULT_TITLE_HEIGHT_ = 24;
  _EXAMPLE_PAGE_RESULT_SURFACE_TOP_ = 28;
  _EXAMPLE_PAGE_RESULT_PADDING_ = 8;

  _EXAMPLE_PAGE_BACKGROUND_ = $FFFAFCFE;
  _EXAMPLE_PAGE_TOP_BAR_BACKGROUND_ = $FFF5F8FB;
  _EXAMPLE_PAGE_SURFACE_BACKGROUND_ = $FFFBFCFD;
  _EXAMPLE_PAGE_BORDER_ = $FFD7E2EC;
  _EXAMPLE_PAGE_TEXT_PRIMARY_ = $FF0D1B35;
  _EXAMPLE_PAGE_TEXT_SECONDARY_ = $FF304A68;
  _EXAMPLE_PAGE_PRIMARY_ = $FF1677F2;
  _EXAMPLE_PAGE_BACK_HOVER_ = $FFEAF1F7;
  _EXAMPLE_PAGE_NAV_SELECTED_BACKGROUND_ = $FFDCEAFA;
  _EXAMPLE_PAGE_SELECTOR_SELECTED_BACKGROUND_ = $FFE7F1FA;
  _EXAMPLE_PAGE_RESULT_BACKGROUND_ = $FFF2F6F9;
  _EXAMPLE_PAGE_RESULT_BORDER_ = $FFDCE5EE;
  _EXAMPLE_PAGE_CODE_BACKGROUND_ =  $FF192A42;
  _EXAMPLE_PAGE_CODE_TEXT_ = $FFDCE6F1;
  _EXAMPLE_PAGE_CODE_SELECTION_ = $FF31577E;
  _EXAMPLE_PAGE_CODE_COPY_BACKGROUND_ = $FF25354A;
  _EXAMPLE_PAGE_CODE_COPY_SUCCESS_BACKGROUND_ = $FF197044;
  _EXAMPLE_PAGE_CODE_COPY_TEXT_ = $FFF0F5FA;

implementation

class function TExamplePageLayout.Default: TExamplePageLayout;
begin
  Result.PageWidth := _EXAMPLE_PAGE_WIDTH_;
  Result.PageHeight := _EXAMPLE_PAGE_HEIGHT_;
  Result.NavigationWidth := _EXAMPLE_PAGE_NAV_WIDTH_;
  Result.NavigationItemHeight := _EXAMPLE_PAGE_NAV_ITEM_HEIGHT_;
end;

function TExamplePageLayout.ContentWidth: Single;
begin
  Result := PageWidth - _EXAMPLE_PAGE_CONTENT_LEFT_ -
    _EXAMPLE_PAGE_CONTENT_RIGHT_;
end;

function TExamplePageLayout.BodyHeight: Single;
begin
  Result := PageHeight - _EXAMPLE_PAGE_BODY_TOP_ -
    _EXAMPLE_PAGE_CONTENT_BOTTOM_;
end;

function TExamplePageLayout.NavigationItemWidth: Single;
begin
  Result := NavigationWidth - (_EXAMPLE_PAGE_NAV_PADDING_ * 2);
end;

function TExamplePageLayout.NavigationIndicatorHeight: Single;
begin
  Result := NavigationItemHeight - (_EXAMPLE_PAGE_NAV_INDICATOR_TOP_ * 2);
end;

function TExamplePageLayout.MainWidth: Single;
begin
  Result := ContentWidth - NavigationWidth - _EXAMPLE_PAGE_BODY_GAP_;
end;

function TExamplePageLayout.ViewContentHeight: Single;
begin
  Result := BodyHeight - _EXAMPLE_PAGE_VIEW_CONTENT_TOP_;
end;

function TExamplePageLayout.ResultSurfaceHeight: Single;
begin
  Result := ViewContentHeight - _EXAMPLE_PAGE_RESULT_SURFACE_TOP_;
end;

end.
