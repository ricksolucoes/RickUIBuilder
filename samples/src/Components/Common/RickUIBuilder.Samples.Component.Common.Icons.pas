{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Component.Common.Icons                                }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Centralizar as geometrias vetoriais compartilhadas pelas páginas de         }
{  componente do Samples.                                                      }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Expõe os paths usados pelo header, cards Factory/Fluent Builder, painel     }
{  informativo e chevron visual da ação Ver exemplos.                          }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - Não possui dependências internas do projeto.                              }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - RickUIBuilder.Samples.Component.Common consome estas constantes ao criar  }
{    os controles visuais comuns das páginas derivadas.                        }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - Preservar a geometria dos SVGs aprovados para Factory, Fluent Builder e   }
{    informação.                                                               }
{  - Esta unit não contém layout, comportamento ou conteúdo específico de      }
{    componentes.                                                              }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Este cabeçalho deve ser atualizado quando responsabilidade, dependências,   }
{  fluxo ou restrições desta unit mudarem.                                     }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.Component.Common.Icons;

interface

const
  _COMPONENT_PAGE_ICON_BACK_ =
    'M20 11H7.83l5.59-5.59L12 4l-8 8 8 8 1.41-1.41L7.83 13H20v-2z';

  _COMPONENT_PAGE_ICON_FACTORY_ =
    'M80-80v-481l280-119v80l200-80v120h320v480H80Zm80-80h640v-320H480v-82l-200 ' +
    '80v-78l-120 53v347Zm280-80h80v-160h-80v160Zm-160 0h80v-160h-80v160Zm320 ' +
    '0h80v-160h-80v160Zm280-320H680l40-320h120l40 320ZM160-160h640-640Z';

  _COMPONENT_PAGE_ICON_FLUENT_ =
    'M10.0002 13C10.4297 13.5741 10.9776 14.0491 11.6067 14.3929C12.2359 ' +
    '14.7367 12.9317 14.9411 13.6468 14.9923C14.362 15.0435 15.0798 ' +
    '14.9403 15.7515 14.6897C16.4233 14.4392 17.0333 14.047 17.5402 ' +
    '13.54L20.5402 10.54C21.451 9.59695 21.955 8.33394 21.9436 ' +
    '7.02296C21.9322 5.71198 21.4063 4.45791 20.4793 3.53087C19.5523 ' +
    '2.60383 18.2982 2.07799 16.9872 2.0666C15.6762 2.0552 14.4132 ' +
    '2.55918 13.4702 3.46997L11.7502 5.17997M14.0002 11C13.5707 ' +
    '10.4258 13.0228 9.95078 12.3936 9.60703C11.7645 9.26327 11.0687 ' +
    '9.05885 10.3535 9.00763C9.63841 8.95641 8.92061 9.0596 8.24885 ' +
    '9.31018C7.5771 9.56077 6.96709 9.9529 6.4602 10.46L3.4602 ' +
    '13.46C2.54941 14.403 2.04544 15.666 2.05683 16.977C2.06822 18.288 ' +
    '2.59407 19.542 3.52111 20.4691C4.44815 21.3961 5.70221 21.9219 ' +
    '7.01319 21.9333C8.32418 21.9447 9.58719 21.4408 10.5302 20.53L12.2402 18.82';

  _COMPONENT_PAGE_ICON_INFO_ =
    'M453-280h60v-240h-60v240Zm50.5-323.2q9.5-9.2 9.5-22.8 0-14.45-9.48-24.22-9.48-9.78-23.5-9.78t-23.52 ' +
    '9.78Q447-640.45 447-626q0 13.6 9.48 22.8 9.48 9.2 23.5 9.2t23.52-9.2ZM480.27-80q-82.74 ' +
    '0-155.5-31.5Q252-143 197.5-197.5t-86-127.34Q80-397.68 80-480.5t31.5-155.66Q143-709 197.5-763t127.34-85.5Q397.68-880 ' +
    '480.5-880t155.66 31.5Q709-817 763-763t85.5 127Q880-563 880-480.27q0 82.74-31.5 155.5Q817-252 763-197.68q-54 ' +
    '54.31-127 86Q563-80 480.27-80Zm.23-60Q622-140 721-239.5t99-241Q820-622 721.19-721T480-820q-141 ' +
    '0-240.5 98.81T140-480q0 141 99.5 240.5t241 99.5Zm-.5-340Z';

  _COMPONENT_PAGE_ICON_CHEVRON_ =
    'm321-80-71-71 329-329-329-329 71-71 400 400L321-80Z';

implementation

end.
