{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Example.Divider.Fluent.Content                        }
{                                                                              }
{ Esta unit centraliza o conteúdo didático dos nove exemplos Divider - Fluent  }
{ Builder e mantém cada snippet sincronizado com a execução real do Runner,    }
{ com foco principal em IRickUIBuilderDivider.                                 }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Centralizar exclusivamente captions, títulos, descrições e snippets dos     }
{  exemplos Divider - Fluent Builder exibidos pela Sample Page.                }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Associa cada TDividerFluentExample ao conteúdo correspondente. Os dois      }
{  exemplos completos cobrem os oito métodos configuráveis de                  }
{  IRickUIBuilderDivider; a variante por interface mantém explicitamente a     }
{  interface pública durante o encadeamento.                                   }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - RickUIBuilder.Samples.App.Types                                           }
{      Fornece TDividerFluentExample compartilhado por Page, Content e Runner. }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - TExampleDividerFluent consulta esta unit ao selecionar um exemplo.        }
{  - TDividerFluentRunner executa o mesmo exemplo identificado pelo enum.      }
{  - Snippet e Runner mantêm métodos, valores e organização Fluent             }
{    equivalentes.                                                             }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - Contém somente conteúdo de Divider na abordagem Fluent Builder.           }
{  - Não cria controles e não executa a API Fluent.                            }
{  - IRickUIBuilderDivider é a API principal; Orientation e Spacing são        }
{    tipos auxiliares usados pelos métodos públicos da interface.              }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Atualizar esta unit quando a API pública Fluent de Divider ou seus exemplos }
{  mudarem, mantendo snippets e Runner semanticamente sincronizados.           }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.Example.Divider.Fluent.Content;

interface

uses
  RickUIBuilder.Samples.App.Types;

type
  /// <summary>Conteúdo textual da página Divider - Fluent Builder.</summary>
  TDividerFluentContent = class sealed
  public
    class function Caption(const AExample: TDividerFluentExample): string; static;
    class function Title(const AExample: TDividerFluentExample): string; static;
    class function Description(const AExample: TDividerFluentExample): string; static;
    class function Code(const AExample: TDividerFluentExample): string; static;
  end;

implementation

const
  _CAPTIONS_: array[TDividerFluentExample] of string = (
    'Básico',
    'Interface',
    'Geometria',
    'Orientação',
    'Layout',
    'Aparência',
    'Estado',
    'Completo - Direto',
    'Completo - Interfaces');

  _TITLES_: array[TDividerFluentExample] of string = (
    'Criação básica',
    'Uso explícito da interface',
    'Posição, comprimento e espessura',
    'Divisor horizontal e vertical',
    'Margin do Divider',
    'Cor do Divider',
    'Opacidade e visibilidade',
    'Configuração completa direta',
    'Configuração completa por interface');

  _DESCRIPTIONS_: array[TDividerFluentExample] of string = (
    'Cria um Divider diretamente por TRickUIBuilder.Divider e Build.',
    'Mantém o builder em IRickUIBuilderDivider e preserva o encadeamento Fluent.',
    'Configura Position, Width e Thickness antes da materialização.',
    'Compara Orientation Horizontal e Vertical preservando Width como comprimento.',
    'Configura Margin com todos os lados de TRickUIBuilderSpacing.',
    'Configura Color pela interface principal do Divider.',
    'Configura Opacity e Visible no TRectangle materializado.',
    'Exercita os oito métodos configuráveis de IRickUIBuilderDivider diretamente.',
    'Exercita os oito métodos mantendo IRickUIBuilderDivider explicitamente.');

  _CODES_: array[TDividerFluentExample] of string = (
    '// Cria o Divider pela entrada pública Fluent com os valores padrão.'#13#10 +
    '// O resultado será exibido no ResultHost da aba Resultado.'#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .Divider'#13#10 +
    '    .Build(ResultHost);',

    '// Mantém explicitamente o builder na interface pública IRickUIBuilderDivider.'#13#10 +
    '// O resultado será exibido no ResultHost da aba Resultado.'#13#10 +
    'var'#13#10 +
    '  LDivider: IRickUIBuilderDivider;'#13#10 +
    'begin'#13#10 +
    '  LDivider := TRickUIBuilder.Divider;'#13#10 +
    ''#13#10 +
    '  LDivider'#13#10 +
    '    .Width(240)'#13#10 +
    '      .Build(ResultHost);'#13#10 +
    'end;',

    '// Configura posição, comprimento e espessura pela API Fluent do Divider.'#13#10 +
    '// O resultado será exibido no ResultHost da aba Resultado.'#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .Divider'#13#10 +
    '    .Position(20, 24)'#13#10 +
    '      .Width(280)'#13#10 +
    '      .Thickness(2)'#13#10 +
    '        .Build(ResultHost);',

    '// Compara a mesma semântica de comprimento nas orientações Horizontal e Vertical.'#13#10 +
    '// Os dois Dividers serão exibidos no ResultHost da aba Resultado.'#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .Divider'#13#10 +
    '    .Position(20, 20)'#13#10 +
    '      .Width(240)'#13#10 +
    '      .Thickness(2)'#13#10 +
    '        .Orientation(TOrientation.Horizontal)'#13#10 +
    '          .Build(ResultHost);'#13#10 +
    ''#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .Divider'#13#10 +
    '    .Position(300, 20)'#13#10 +
    '      .Width(160)'#13#10 +
    '      .Thickness(2)'#13#10 +
    '        .Orientation(TOrientation.Vertical)'#13#10 +
    '          .Build(ResultHost);',

    '// Configura Margin com os quatro lados explícitos sobre a posição informada.'#13#10 +
    '// O resultado será exibido no ResultHost da aba Resultado.'#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .Divider'#13#10 +
    '    .Position(20, 20)'#13#10 +
    '      .Width(260)'#13#10 +
    '        .Margin(TRickUIBuilderSpacing.Create(12, 8, 4, 2))'#13#10 +
    '          .Build(ResultHost);',

    '// Configura a cor do Divider pela interface Fluent principal.'#13#10 +
    '// O resultado será exibido no ResultHost da aba Resultado.'#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .Divider'#13#10 +
    '    .Width(280)'#13#10 +
    '      .Thickness(2)'#13#10 +
    '        .Color(TAlphaColors.Dodgerblue)'#13#10 +
    '          .Build(ResultHost);',

    '// Configura opacidade e visibilidade inicial do Divider.'#13#10 +
    '// O resultado será exibido no ResultHost da aba Resultado.'#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .Divider'#13#10 +
    '    .Width(280)'#13#10 +
    '      .Color(TAlphaColors.Gray)'#13#10 +
    '        .Opacity(0.65)'#13#10 +
    '        .Visible(True)'#13#10 +
    '          .Build(ResultHost);',

    '// Exercita os oito métodos configuráveis de IRickUIBuilderDivider diretamente.'#13#10 +
    '// O resultado completo será exibido no ResultHost da aba Resultado.'#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .Divider'#13#10 +
    '    .Position(20, 24)'#13#10 +
    '      .Width(280)'#13#10 +
    '      .Thickness(3)'#13#10 +
    '      .Orientation(TOrientation.Horizontal)'#13#10 +
    '        .Margin(TRickUIBuilderSpacing.Create(12, 8, 4, 2))'#13#10 +
    '          .Color(TAlphaColors.Dodgerblue)'#13#10 +
    '            .Opacity(0.90)'#13#10 +
    '            .Visible(True)'#13#10 +
    '              .Build(ResultHost);',

    '// Mantém a configuração completa explicitamente em IRickUIBuilderDivider.'#13#10 +
    '// Os oito métodos são aplicados antes do Build exibido na aba Resultado.'#13#10 +
    'var'#13#10 +
    '  LDivider: IRickUIBuilderDivider;'#13#10 +
    'begin'#13#10 +
    '  LDivider := TRickUIBuilder.Divider;'#13#10 +
    ''#13#10 +
    '  LDivider'#13#10 +
    '    .Position(20, 24)'#13#10 +
    '      .Width(280)'#13#10 +
    '      .Thickness(3)'#13#10 +
    '      .Orientation(TOrientation.Horizontal)'#13#10 +
    '        .Margin(TRickUIBuilderSpacing.Create(12, 8, 4, 2))'#13#10 +
    '          .Color(TAlphaColors.Dodgerblue)'#13#10 +
    '            .Opacity(0.90)'#13#10 +
    '            .Visible(True)'#13#10 +
    '              .Build(ResultHost);'#13#10 +
    'end;');

class function TDividerFluentContent.Caption(
  const AExample: TDividerFluentExample): string;
begin
  Result := _CAPTIONS_[AExample];
end;

class function TDividerFluentContent.Title(
  const AExample: TDividerFluentExample): string;
begin
  Result := _TITLES_[AExample];
end;

class function TDividerFluentContent.Description(
  const AExample: TDividerFluentExample): string;
begin
  Result := _DESCRIPTIONS_[AExample];
end;

class function TDividerFluentContent.Code(
  const AExample: TDividerFluentExample): string;
begin
  Result := _CODES_[AExample];
end;

end.
