{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples                                                       }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Define o ponto de entrada executável da aplicação de exemplos do            }
{  Rick.UIBuilder.                                                             }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  - Inicializa a aplicação FMX.                                               }
{  - Permite desabilitar o uso do DirectX por meio do parâmetro de linha de    }
{    comando -nodx, garantindo compatibilidade com ambientes de acesso remoto  }
{    nos quais a renderização FMX baseada em DirectX pode não ser capturada    }
{    corretamente.                                                             }
{  - Registra explicitamente as units que compõem o projeto Samples.           }
{  - Delega a inicialização e execução da aplicação para TSampleApplication.   }
{  - Propaga o código de saída retornado pela aplicação para ExitCode.         }
{                                                                              }
{  Organização do projeto                                                      }
{  ----------------------                                                      }
{  As units do Samples são organizadas fisicamente por responsabilidade:       }
{                                                                              }
{  - src\App                                                                   }
{      Contém bootstrap, coordenação da aplicação, tipos compartilhados e      }
{      definições tipográficas comuns.                                         }
{                                                                              }
{  - src\Home                                                                  }
{      Contém a Home, seus elementos visuais, Presenter, contrato, ícones      }
{      e estilo específico.                                                    }
{                                                                              }
{  - src\Components\Common                                                     }
{      Contém a base visual, os ícones e o estilo compartilhados pelas páginas }
{      de componentes.                                                         }
{                                                                              }
{  - src\Components\<Componente>                                               }
{      Contém a página intermediária concreta de cada componente navegável.    }
{                                                                              }
{  - src\Examples\Common                                                       }
{      Contém a base visual e os controles estruturais comuns de header,       }
{      navegação, código e resultado, além de ícones e tokens visuais.         }
{                                                                              }
{  - src\Examples\TextLabel\<Abordagem>                                        }
{      Contém as páginas concretas Text / Label - Factory e Fluent Builder,    }
{      separadas fisicamente por abordagem.                                    }
{                                                                              }
{  - src\Examples\Button\<Abordagem>                                           }
{      Contém as páginas concretas Button - Factory e Fluent Builder,          }
{      separadas fisicamente por abordagem.                                    }
{                                                                              }
{  - src\Examples\Badge\<Abordagem>                                            }
{      Contém as páginas concretas Badge - Factory e Fluent Builder,           }
{      separadas fisicamente por abordagem.                                    }
{                                                                              }
{  - src\Examples\Divider\<Abordagem>                                          }
{      Contém as páginas concretas Divider - Factory e Fluent Builder.         }
{                                                                              }
{  - src\Examples\ComboBox\<Abordagem>                                         }
{      Contém as páginas concretas ComboBox - Factory e Fluent Builder.        }
{                                                                              }
{  - src\Examples\Edit\Fluent                                                 }
{      Contém a página concreta Edit - Fluent Builder, conteúdo e Runner.      }
{                                                                              }
{  Dependências principais                                                     }
{  -----------------------                                                     }
{  - FMX.Forms                                                                 }
{      Fornece a infraestrutura da aplicação FireMonkey.                       }
{                                                                              }
{  - FMX.Types                                                                 }
{      Fornece GlobalUseDX usado pelo fallback -nodx.                          }
{                                                                              }
{  - System.SysUtils                                                           }
{      Fornece FindCmdLineSwitch para detectar o parâmetro -nodx.              }
{                                                                              }
{  - RickUIBuilder.Samples.App.Bootstrap                                       }
{      Disponibiliza TSampleApplication, responsável pelo Composition Root     }
{      e pelo ciclo principal de execução do Samples.                          }
{                                                                              }
{  Fluxo de inicialização                                                      }
{  ----------------------                                                      }
{                                                                              }
{      RickUIBuilder.Samples                                                   }
{               |                                                              }
{               v                                                              }
{      Verificação do parâmetro -nodx                                          }
{               |                                                              }
{               v                                                              }
{      GlobalUseDX := False, quando solicitado                                 }
{               |                                                              }
{               v                                                              }
{      Application.Initialize                                                  }
{               |                                                              }
{               v                                                              }
{      TSampleApplication.Run                                                  }
{               |                                                              }
{               v                                                              }
{            ExitCode                                                          }
{                                                                              }
{  Restrições arquiteturais                                                    }
{  ------------------------                                                    }
{  - Este arquivo deve permanecer somente como ponto de entrada da aplicação.  }
{  - Regras de navegação, composição e criação das Views não devem ser         }
{    implementadas diretamente neste arquivo.                                  }
{  - As units internas do Samples devem permanecer explicitamente registradas  }
{    no projeto e não devem depender do Search Path para serem localizadas.    }
{  - Alterações na estrutura física das units devem manter os caminhos deste   }
{    arquivo e do .dproj sincronizados.                                        }
{                                                                              }
{  Compatibilidade com acesso remoto                                           }
{  ---------------------------------                                           }
{  Algumas soluções de acesso remoto podem não capturar corretamente           }
{  superfícies gráficas utilizadas pelo FireMonkey quando o DirectX está       }
{  habilitado, especialmente em controles e telas criados dinamicamente em     }
{  runtime.                                                                    }
{                                                                              }
{  Para esses cenários, a aplicação aceita o parâmetro -nodx, que desabilita   }
{  o backend DirectX antes da inicialização do FMX.                            }
{                                                                              }
{  Exemplo:                                                                    }
{                                                                              }
{      RickUIBuilder.Samples.exe -nodx                                         }
{                                                                              }
{  Na ausência do parâmetro, o comportamento gráfico padrão do FireMonkey é    }
{  preservado.                                                                 }
{                                                                              }
{******************************************************************************}

program RickUIBuilder.Samples;

uses
  FMX.Forms,
  FMX.Types,
  System.SysUtils,
  System.StartUpCopy,
  RickUIBuilder.Samples.App.Bootstrap in 'src\App\RickUIBuilder.Samples.App.Bootstrap.pas',
  RickUIBuilder.Samples.App.Coordinator in 'src\App\RickUIBuilder.Samples.App.Coordinator.pas',
  RickUIBuilder.Samples.App.Types in 'src\App\RickUIBuilder.Samples.App.Types.pas',
  RickUIBuilder.Samples.App.Typography in 'src\App\RickUIBuilder.Samples.App.Typography.pas',
  RickUIBuilder.Samples.Home in 'src\Home\RickUIBuilder.Samples.Home.pas',
  RickUIBuilder.Samples.Home.ComponentCard in 'src\Home\RickUIBuilder.Samples.Home.ComponentCard.pas',
  RickUIBuilder.Samples.Home.Icons in 'src\Home\RickUIBuilder.Samples.Home.Icons.pas',
  RickUIBuilder.Samples.Home.Presenter.Intf in 'src\Home\RickUIBuilder.Samples.Home.Presenter.Intf.pas',
  RickUIBuilder.Samples.Home.Presenter in 'src\Home\RickUIBuilder.Samples.Home.Presenter.pas',
  RickUIBuilder.Samples.Home.Style in 'src\Home\RickUIBuilder.Samples.Home.Style.pas',
  RickUIBuilder.Samples.Component.Common in 'src\Components\Common\RickUIBuilder.Samples.Component.Common.pas',
  RickUIBuilder.Samples.Component.Common.Icons in 'src\Components\Common\RickUIBuilder.Samples.Component.Common.Icons.pas',
  RickUIBuilder.Samples.Component.TextLabel in 'src\Components\TextLabel\RickUIBuilder.Samples.Component.TextLabel.pas',
  RickUIBuilder.Samples.Component.Button in 'src\Components\Button\RickUIBuilder.Samples.Component.Button.pas',
  RickUIBuilder.Samples.Component.Badge in 'src\Components\Badge\RickUIBuilder.Samples.Component.Badge.pas',
  RickUIBuilder.Samples.Component.Divider in 'src\Components\Divider\RickUIBuilder.Samples.Component.Divider.pas',
  RickUIBuilder.Samples.Component.ComboBox in 'src\Components\ComboBox\RickUIBuilder.Samples.Component.ComboBox.pas',
  RickUIBuilder.Samples.Component.Edit in 'src\Components\Edit\RickUIBuilder.Samples.Component.Edit.pas',
  RickUIBuilder.Samples.Component.Common.Style in 'src\Components\Common\RickUIBuilder.Samples.Component.Common.Style.pas',
  RickUIBuilder.Samples.Example.Common in 'src\Examples\Common\RickUIBuilder.Samples.Example.Common.pas',
  RickUIBuilder.Samples.Example.Common.Header in 'src\Examples\Common\RickUIBuilder.Samples.Example.Common.Header.pas',
  RickUIBuilder.Samples.Example.Common.Navigation in 'src\Examples\Common\RickUIBuilder.Samples.Example.Common.Navigation.pas',
  RickUIBuilder.Samples.Example.Common.View.Selector in 'src\Examples\Common\RickUIBuilder.Samples.Example.Common.View.Selector.pas',
  RickUIBuilder.Samples.Example.Common.Code.Panel in 'src\Examples\Common\RickUIBuilder.Samples.Example.Common.Code.Panel.pas',
  RickUIBuilder.Samples.Example.Common.Result.Panel in 'src\Examples\Common\RickUIBuilder.Samples.Example.Common.Result.Panel.pas',
  RickUIBuilder.Samples.Example.Common.Icons in 'src\Examples\Common\RickUIBuilder.Samples.Example.Common.Icons.pas',
  RickUIBuilder.Samples.Example.Common.Style in 'src\Examples\Common\RickUIBuilder.Samples.Example.Common.Style.pas',
  RickUIBuilder.Samples.Example.Button.Factory in 'src\Examples\Button\Factory\RickUIBuilder.Samples.Example.Button.Factory.pas',
  RickUIBuilder.Samples.Example.Button.Factory.Content in 'src\Examples\Button\Factory\RickUIBuilder.Samples.Example.Button.Factory.Content.pas',
  RickUIBuilder.Samples.Example.Button.Factory.Runner in 'src\Examples\Button\Factory\RickUIBuilder.Samples.Example.Button.Factory.Runner.pas',
  RickUIBuilder.Samples.Example.Button.Fluent in 'src\Examples\Button\Fluent\RickUIBuilder.Samples.Example.Button.Fluent.pas',
  RickUIBuilder.Samples.Example.Button.Fluent.Content in 'src\Examples\Button\Fluent\RickUIBuilder.Samples.Example.Button.Fluent.Content.pas',
  RickUIBuilder.Samples.Example.Button.Fluent.Runner in 'src\Examples\Button\Fluent\RickUIBuilder.Samples.Example.Button.Fluent.Runner.pas',
  RickUIBuilder.Samples.Example.Badge.Factory in 'src\Examples\Badge\Factory\RickUIBuilder.Samples.Example.Badge.Factory.pas',
  RickUIBuilder.Samples.Example.Badge.Factory.Content in 'src\Examples\Badge\Factory\RickUIBuilder.Samples.Example.Badge.Factory.Content.pas',
  RickUIBuilder.Samples.Example.Badge.Factory.Runner in 'src\Examples\Badge\Factory\RickUIBuilder.Samples.Example.Badge.Factory.Runner.pas',
  RickUIBuilder.Samples.Example.Badge.Fluent in 'src\Examples\Badge\Fluent\RickUIBuilder.Samples.Example.Badge.Fluent.pas',
  RickUIBuilder.Samples.Example.Badge.Fluent.Content in 'src\Examples\Badge\Fluent\RickUIBuilder.Samples.Example.Badge.Fluent.Content.pas',
  RickUIBuilder.Samples.Example.Badge.Fluent.Runner in 'src\Examples\Badge\Fluent\RickUIBuilder.Samples.Example.Badge.Fluent.Runner.pas',
  RickUIBuilder.Samples.Example.Divider.Factory in 'src\Examples\Divider\Factory\RickUIBuilder.Samples.Example.Divider.Factory.pas',
  RickUIBuilder.Samples.Example.Divider.Factory.Content in 'src\Examples\Divider\Factory\RickUIBuilder.Samples.Example.Divider.Factory.Content.pas',
  RickUIBuilder.Samples.Example.Divider.Factory.Runner in 'src\Examples\Divider\Factory\RickUIBuilder.Samples.Example.Divider.Factory.Runner.pas',
  RickUIBuilder.Samples.Example.Divider.Fluent in 'src\Examples\Divider\Fluent\RickUIBuilder.Samples.Example.Divider.Fluent.pas',
  RickUIBuilder.Samples.Example.Divider.Fluent.Content in 'src\Examples\Divider\Fluent\RickUIBuilder.Samples.Example.Divider.Fluent.Content.pas',
  RickUIBuilder.Samples.Example.Divider.Fluent.Runner in 'src\Examples\Divider\Fluent\RickUIBuilder.Samples.Example.Divider.Fluent.Runner.pas',
  RickUIBuilder.Samples.Example.ComboBox.Factory in 'src\Examples\ComboBox\Factory\RickUIBuilder.Samples.Example.ComboBox.Factory.pas',
  RickUIBuilder.Samples.Example.ComboBox.Factory.Content in 'src\Examples\ComboBox\Factory\RickUIBuilder.Samples.Example.ComboBox.Factory.Content.pas',
  RickUIBuilder.Samples.Example.ComboBox.Factory.Runner in 'src\Examples\ComboBox\Factory\RickUIBuilder.Samples.Example.ComboBox.Factory.Runner.pas',
  RickUIBuilder.Samples.Example.ComboBox.Fluent in 'src\Examples\ComboBox\Fluent\RickUIBuilder.Samples.Example.ComboBox.Fluent.pas',
  RickUIBuilder.Samples.Example.ComboBox.Fluent.Content in 'src\Examples\ComboBox\Fluent\RickUIBuilder.Samples.Example.ComboBox.Fluent.Content.pas',
  RickUIBuilder.Samples.Example.ComboBox.Fluent.Runner in 'src\Examples\ComboBox\Fluent\RickUIBuilder.Samples.Example.ComboBox.Fluent.Runner.pas',
  RickUIBuilder.Samples.Example.Edit.Fluent in 'src\Examples\Edit\Fluent\RickUIBuilder.Samples.Example.Edit.Fluent.pas',
  RickUIBuilder.Samples.Example.Edit.Fluent.Content in 'src\Examples\Edit\Fluent\RickUIBuilder.Samples.Example.Edit.Fluent.Content.pas',
  RickUIBuilder.Samples.Example.Edit.Fluent.Runner in 'src\Examples\Edit\Fluent\RickUIBuilder.Samples.Example.Edit.Fluent.Runner.pas',
  RickUIBuilder.Samples.Example.TextLabel.Factory.Content in 'src\Examples\TextLabel\Factory\RickUIBuilder.Samples.Example.TextLabel.Factory.Content.pas',
  RickUIBuilder.Samples.Example.TextLabel.Factory in 'src\Examples\TextLabel\Factory\RickUIBuilder.Samples.Example.TextLabel.Factory.pas',
  RickUIBuilder.Samples.Example.TextLabel.Factory.Runner in 'src\Examples\TextLabel\Factory\RickUIBuilder.Samples.Example.TextLabel.Factory.Runner.pas',
  RickUIBuilder.Samples.Example.TextLabel.Fluent.Content in 'src\Examples\TextLabel\Fluent\RickUIBuilder.Samples.Example.TextLabel.Fluent.Content.pas',
  RickUIBuilder.Samples.Example.TextLabel.Fluent in 'src\Examples\TextLabel\Fluent\RickUIBuilder.Samples.Example.TextLabel.Fluent.pas',
  RickUIBuilder.Samples.Example.TextLabel.Fluent.Runner in 'src\Examples\TextLabel\Fluent\RickUIBuilder.Samples.Example.TextLabel.Fluent.Runner.pas';

{$R *.res}

begin
  { O parâmetro -nodx permite iniciar a aplicação com o DirectX desabilitado.  }
  { A identificação do parâmetro não diferencia letras maiúsculas de           }
  { minúsculas, portanto -nodx, -NODX e variações equivalentes são aceitas.    }
  { Esta opção foi adicionada para ambientes de acesso remoto, nos quais       }
  { controles FMX criados em runtime podem não ser capturados ou exibidos      }
  { corretamente quando o backend gráfico DirectX está ativo.                  }
  { Quando o parâmetro não é informado, o comportamento padrão do FMX é        }
  { mantido.                                                                   }
 if System.SysUtils.FindCmdLineSwitch('nodx', True) then
    FMX.Types.GlobalUseDX := False;

  Application.Initialize;
  ExitCode := TSampleApplication.Run;
end.
