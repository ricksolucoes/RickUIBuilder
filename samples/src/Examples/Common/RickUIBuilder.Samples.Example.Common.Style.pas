{ Esta unit centraliza a geometria e os tokens visuais da Sample Page Base, incluindo o viewport compartilhado de Código/Resultado, a ação Copiar código com feedback visual, a paleta de leitura do snippet e a superfície de Resultado expandida até o limite útil da área principal. }
{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Example.Common.Style                                  }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Centralizar tokens visuais e geometria compartilhados pela base das páginas }
{  de exemplos do Samples.                                                     }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Define dimensões da janela, header, identidade, corpo, navegação lateral,   }
{  seletor Código/Resultado, superfície de código selecionável/copiável e      }
{  superfície de resultado que ocupa toda a altura útil da view ativa.         }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - Não possui dependências internas do projeto.                              }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - As units Example.Common e seus controles estruturais consomem estes       }
{    tokens para manter uma geometria única na família de páginas.             }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - A janela deve permanecer estritamente menor que a Home de 644 x 534.      }
{  - Tipografia compartilhada permanece em RickUIBuilder.Samples.App.Typography.}
{  - Esta unit não contém conteúdo específico de componente ou abordagem.      }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Este cabeçalho deve ser atualizado quando geometria, paleta, dependências   }
{  ou restrições desta unit mudarem.                                           }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.Example.Common.Style;

interface

const
  _EXAMPLE_PAGE_WIDTH_ = 620;
  _EXAMPLE_PAGE_HEIGHT_ = 510;
  _EXAMPLE_PAGE_TOP_BAR_HEIGHT_ = 40;

  _EXAMPLE_PAGE_CONTENT_LEFT_ = 16;
  _EXAMPLE_PAGE_CONTENT_WIDTH_ = 588;
  _EXAMPLE_PAGE_TITLE_TOP_ = 52;
  _EXAMPLE_PAGE_TITLE_HEIGHT_ = 30;
  _EXAMPLE_PAGE_SUBTITLE_TOP_ = 84;
  _EXAMPLE_PAGE_SUBTITLE_HEIGHT_ = 30;

  _EXAMPLE_PAGE_BODY_TOP_ = 124;
  _EXAMPLE_PAGE_BODY_HEIGHT_ = 370;
  _EXAMPLE_PAGE_NAV_WIDTH_ = 142;
  _EXAMPLE_PAGE_BODY_GAP_ = 14;
  _EXAMPLE_PAGE_MAIN_WIDTH_ = 432;

  _EXAMPLE_PAGE_NAV_PADDING_ = 6;
  _EXAMPLE_PAGE_NAV_ITEM_WIDTH_ = 130;
  _EXAMPLE_PAGE_NAV_ITEM_HEIGHT_ = 28;
  _EXAMPLE_PAGE_NAV_ITEM_GAP_ = 3;
  _EXAMPLE_PAGE_NAV_ITEM_RADIUS_ = 4;
  _EXAMPLE_PAGE_NAV_INDICATOR_WIDTH_ = 2;
  _EXAMPLE_PAGE_NAV_INDICATOR_TOP_ = 2;
  _EXAMPLE_PAGE_NAV_INDICATOR_HEIGHT_ = 24;

  _EXAMPLE_PAGE_EXAMPLE_TITLE_TOP_ = 0;
  _EXAMPLE_PAGE_EXAMPLE_TITLE_HEIGHT_ = 24;
  _EXAMPLE_PAGE_EXAMPLE_DESCRIPTION_TOP_ = 24;
  _EXAMPLE_PAGE_EXAMPLE_DESCRIPTION_HEIGHT_ = 30;

  _EXAMPLE_PAGE_VIEW_SELECTOR_TOP_ = 58;
  _EXAMPLE_PAGE_SELECTOR_HEIGHT_ = 30;
  _EXAMPLE_PAGE_CODE_SELECTOR_WIDTH_ = 96;
  _EXAMPLE_PAGE_RESULT_SELECTOR_WIDTH_ = 78;
  _EXAMPLE_PAGE_VIEW_CONTENT_TOP_ = 92;
  _EXAMPLE_PAGE_VIEW_CONTENT_HEIGHT_ = 278;

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
  _EXAMPLE_PAGE_RESULT_SURFACE_HEIGHT_ = _EXAMPLE_PAGE_VIEW_CONTENT_HEIGHT_ -
    _EXAMPLE_PAGE_RESULT_SURFACE_TOP_;
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
  _EXAMPLE_PAGE_CODE_BACKGROUND_ = $FF111D2E;
  _EXAMPLE_PAGE_CODE_TEXT_ = $FFDCE6F1;
  _EXAMPLE_PAGE_CODE_SELECTION_ = $FF31577E;
  _EXAMPLE_PAGE_CODE_COPY_BACKGROUND_ = $FF25354A;
  _EXAMPLE_PAGE_CODE_COPY_SUCCESS_BACKGROUND_ = $FF197044;
  _EXAMPLE_PAGE_CODE_COPY_TEXT_ = $FFF0F5FA;

implementation

end.
