{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Component.Common.Style                                }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Centralizar tokens visuais e geometria compartilhados pelas páginas         }
{  intermediárias de componente do Samples.                                    }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Expõe dimensões do formulário, header, conteúdo, cards e painel             }
{  informativo, além da paleta usada pela infraestrutura comum.                }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - Não possui dependências internas do projeto.                              }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - RickUIBuilder.Samples.Component.Common consome estas constantes para      }
{    construir a geometria e aparência compartilhadas pelas páginas derivadas. }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - A tipografia compartilhada permanece em                                  }
{    RickUIBuilder.Samples.App.Typography.                                     }
{  - Conteúdo específico de cada componente permanece em sua página concreta.  }
{  - Esta unit não depende de RickUIBuilder.Samples.Home.Style.                }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Este cabeçalho deve ser atualizado quando responsabilidade, geometria,      }
{  paleta, dependências ou restrições desta unit mudarem.                      }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.Component.Common.Style;

interface

const
  _COMPONENT_PAGE_WIDTH_ = 500;
  _COMPONENT_PAGE_HEIGHT_ = 500;
  _COMPONENT_PAGE_TOP_BAR_HEIGHT_ = 40;
  _COMPONENT_PAGE_CONTENT_LEFT_ = 24;
  _COMPONENT_PAGE_CONTENT_WIDTH_ = 452;
  _COMPONENT_PAGE_CARD_WIDTH_ = 220;
  _COMPONENT_PAGE_CARD_HEIGHT_ = 188;
  _COMPONENT_PAGE_CARD_TOP_ = 152;
  _COMPONENT_PAGE_CARD_GAP_ = 12;
  _COMPONENT_PAGE_CARD_RADIUS_ = 8;
  _COMPONENT_PAGE_INFO_TOP_ = 356;
  _COMPONENT_PAGE_INFO_HEIGHT_ = 126;


  _COMPONENT_PAGE_CARD_BACKGROUND_ = $FFFBFCFD;
  _COMPONENT_PAGE_BACKGROUND_ = $FFFAFCFE;
  _COMPONENT_PAGE_TOP_BAR_BACKGROUND_ = $FFF5F8FB;
  _COMPONENT_PAGE_BORDER_ = $FFD7E2EC;
  _COMPONENT_PAGE_TEXT_PRIMARY_ = $FF0D1B35;
  _COMPONENT_PAGE_TEXT_SECONDARY_ = $FF304A68;
  _COMPONENT_PAGE_PRIMARY_ = $FF1677F2;
  _COMPONENT_PAGE_ACTION_TEXT_ = $FFFFFFFF;
  _COMPONENT_PAGE_BACK_HOVER_ = $FFEAF1F7;
  _COMPONENT_PAGE_INFO_BACKGROUND_ = $FFE7F1FA;
  _COMPONENT_PAGE_FACTORY_ACCENT_ = $FF5E51F2;
  _COMPONENT_PAGE_FLUENT_ACCENT_ = $FF0A9F63;
  _COMPONENT_PAGE_INFO_ACCENT_ = $FF1677F2;

implementation

end.
