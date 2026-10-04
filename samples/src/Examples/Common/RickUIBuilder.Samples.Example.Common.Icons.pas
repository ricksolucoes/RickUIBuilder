{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Example.Common.Icons                                  }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Centralizar as geometrias vetoriais usadas pela Sample Page Base.           }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Expõe o path do ícone de retorno utilizado no header da página de exemplos. }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - Não possui dependências internas do projeto.                              }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - RickUIBuilder.Samples.Example.Common.Header consome esta geometria para }
{    materializar a ação de retorno do header comum.                           }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - Esta unit não contém layout, comportamento ou conteúdo de exemplos.       }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Este cabeçalho deve ser atualizado quando geometria, colaboração ou         }
{  restrições desta unit mudarem.                                              }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.Example.Common.Icons;

interface

const
  _EXAMPLE_PAGE_ICON_BACK_ =
    'M20 11H7.83l5.59-5.59L12 4l-8 8 8 8 1.41-1.41L7.83 13H20v-2z';

implementation

end.
