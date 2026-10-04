{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Example.Badge.Fluent.Content                          }
{                                                                              }
{ Esta unit centraliza o conteúdo didático dos onze exemplos Badge - Fluent    }
{ Builder e mantém cada snippet sincronizado com a execução real do Runner,    }
{ com foco principal em IRickUIBuilderBadge.                                   }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Centralizar exclusivamente captions, títulos, descrições e snippets dos     }
{  exemplos Badge - Fluent Builder exibidos pela Sample Page.                  }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Associa cada TBadgeFluentExample ao conteúdo correspondente. Os dois        }
{  exemplos completos cobrem os quinze métodos configuráveis de                }
{  IRickUIBuilderBadge; a variante por interfaces usa também                   }
{  IRickUIBuilderBadgeHandle como API secundária retornada por Build.          }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - RickUIBuilder.Samples.App.Types                                           }
{      Fornece TBadgeFluentExample compartilhado por Page, Content e Runner.   }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - TExampleBadgeFluent consulta esta unit ao selecionar um exemplo.          }
{  - TBadgeFluentRunner executa o mesmo exemplo identificado pelo enum.        }
{  - Snippet e Runner mantêm métodos, valores e organização Fluent             }
{    equivalentes.                                                             }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - Contém somente conteúdo de Badge na abordagem Fluent Builder.             }
{  - Não cria controles e não executa a API Fluent.                            }
{  - IRickUIBuilderBadge é a API principal; Handle e Spacing são secundários.  }
{  - Pill(True) prevalece sobre CornerRadius; os completos usam Pill(False).   }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Atualizar esta unit quando a API pública Fluent de Badge ou seus exemplos   }
{  mudarem, mantendo snippets e Runner semanticamente sincronizados.           }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.Example.Badge.Fluent.Content;

interface

uses
  RickUIBuilder.Samples.App.Types;

type
  /// <summary>Conteúdo textual da página Badge - Fluent Builder.</summary>
  TBadgeFluentContent = class sealed
  public
    class function Caption(const AExample: TBadgeFluentExample): string; static;
    class function Title(const AExample: TBadgeFluentExample): string; static;
    class function Description(const AExample: TBadgeFluentExample): string; static;
    class function Code(const AExample: TBadgeFluentExample): string; static;
  end;

implementation

const
  _CAPTIONS_: array[TBadgeFluentExample] of string = (
    'Básico',
    'Interface',
    'Geometria',
    'Forma',
    'Layout',
    'Aparência',
    'Tipografia',
    'Estado',
    'Resultado',
    'Completo - Direto',
    'Completo - Interfaces');

  _TITLES_: array[TBadgeFluentExample] of string = (
    'Criação básica',
    'Uso explícito da interface',
    'Posição e tamanho',
    'Pill e raio dos cantos',
    'Margin e Padding',
    'Cores do Badge',
    'Tipografia do texto',
    'Estado e identificação',
    'Acesso ao resultado criado',
    'Configuração completa direta',
    'Configuração completa por interfaces');

  _DESCRIPTIONS_: array[TBadgeFluentExample] of string = (
    'Cria um Badge diretamente por TRickUIBuilder.Badge com Text e Build.',
    'Mantém o builder em IRickUIBuilderBadge e preserva o encadeamento Fluent.',
    'Configura Position e Size antes da materialização.',
    'Compara Pill(True) com Pill(False) combinado a CornerRadius.',
    'Configura Margin e Padding com todos os lados de TRickUIBuilderSpacing.',
    'Configura BackgroundColor e BorderColor pela interface principal.',
    'Configura TextColor, FontSize e Bold sem acessar o TLabel interno.',
    'Configura Opacity, Visible e Tag do container criado.',
    'Usa IRickUIBuilderBadgeHandle retornado por Build para acessar o resultado.',
    'Exercita os quinze métodos configuráveis de IRickUIBuilderBadge diretamente.',
    'Exercita a configuração completa mantendo IRickUIBuilderBadge e seu Handle.');

  _CODES_: array[TBadgeFluentExample] of string = (
    '// Cria o Badge pela entrada pública Fluent e define seu texto.'#13#10 +
    '// O resultado será exibido no ResultHost da aba Resultado.'#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .Badge'#13#10 +
    '    .Text(''Novo'')'#13#10 +
    '      .Build(ResultHost);',

    '// Mantém explicitamente o builder na interface pública IRickUIBuilderBadge.'#13#10 +
    '// O resultado será exibido no ResultHost da aba Resultado.'#13#10 +
    'var'#13#10 +
    '  LBadge: IRickUIBuilderBadge;'#13#10 +
    'begin'#13#10 +
    '  LBadge := TRickUIBuilder.Badge;'#13#10 +
    ''#13#10 +
    '  LBadge'#13#10 +
    '    .Text(''Interface'')'#13#10 +
    '      .Size(110, 28)'#13#10 +
    '        .Build(ResultHost);'#13#10 +
    'end;',

    '// Configura posição e tamanho pela API Fluent do Badge.'#13#10 +
    '// O resultado será exibido no ResultHost da aba Resultado.'#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .Badge'#13#10 +
    '    .Text(''Geometria'')'#13#10 +
    '      .Position(24, 20)'#13#10 +
    '      .Size(140, 32)'#13#10 +
    '        .Build(ResultHost);',

    '// Compara o formato Pill com CornerRadius quando Pill está desativado.'#13#10 +
    '// Os dois Badges serão exibidos no ResultHost da aba Resultado.'#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .Badge'#13#10 +
    '    .Text(''Pill'')'#13#10 +
    '      .Position(16, 12)'#13#10 +
    '      .Size(120, 30)'#13#10 +
    '        .Pill(True)'#13#10 +
    '          .Build(ResultHost);'#13#10 +
    ''#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .Badge'#13#10 +
    '    .Text(''Corner radius'')'#13#10 +
    '      .Position(16, 60)'#13#10 +
    '      .Size(140, 30)'#13#10 +
    '        .Pill(False)'#13#10 +
    '        .CornerRadius(6)'#13#10 +
    '          .Build(ResultHost);',

    '// Configura Margin e Padding com os quatro lados explícitos.'#13#10 +
    '// O resultado será exibido no ResultHost da aba Resultado.'#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .Badge'#13#10 +
    '    .Text(''Layout'')'#13#10 +
    '      .Position(16, 12)'#13#10 +
    '      .Size(140, 32)'#13#10 +
    '        .Margin(TRickUIBuilderSpacing.Create(8, 6, 4, 2))'#13#10 +
    '        .Padding(TRickUIBuilderSpacing.Create(10, 4, 6, 2))'#13#10 +
    '          .Build(ResultHost);',

    '// Configura as cores do container pela API Fluent do Badge.'#13#10 +
    '// O resultado será exibido no ResultHost da aba Resultado.'#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .Badge'#13#10 +
    '    .Text(''Aparência'')'#13#10 +
    '      .Size(140, 32)'#13#10 +
    '        .BackgroundColor(TAlphaColors.Gray)'#13#10 +
    '        .BorderColor(TAlphaColors.Dodgerblue)'#13#10 +
    '          .Build(ResultHost);',

    '// Configura o texto sem acessar diretamente o TLabel interno.'#13#10 +
    '// O resultado será exibido no ResultHost da aba Resultado.'#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .Badge'#13#10 +
    '    .Text(''Tipografia'')'#13#10 +
    '      .Size(150, 34)'#13#10 +
    '        .TextColor(TAlphaColors.Dodgerblue)'#13#10 +
    '        .FontSize(16)'#13#10 +
    '        .Bold(True)'#13#10 +
    '          .Build(ResultHost);',

    '// Configura estado e identificação do container criado pelo Badge.'#13#10 +
    '// O resultado será exibido no ResultHost da aba Resultado.'#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .Badge'#13#10 +
    '    .Text(''Estado'')'#13#10 +
    '      .Size(130, 32)'#13#10 +
    '        .Opacity(0.70)'#13#10 +
    '        .Visible(True)'#13#10 +
    '        .Tag(501)'#13#10 +
    '          .Build(ResultHost);',

    '// Usa o IRickUIBuilderBadgeHandle retornado por Build.'#13#10 +
    '// O texto atualizado pelo Handle será exibido na aba Resultado.'#13#10 +
    'var'#13#10 +
    '  LHandle: IRickUIBuilderBadgeHandle;'#13#10 +
    'begin'#13#10 +
    '  LHandle := TRickUIBuilder'#13#10 +
    '    .Badge'#13#10 +
    '      .Text(''Resultado'')'#13#10 +
    '        .Size(150, 32)'#13#10 +
    '          .Build(ResultHost);'#13#10 +
    ''#13#10 +
    '  LHandle.TextLabel.Text := ''Resultado acessado'';'#13#10 +
    'end;',

    '// Exercita os quinze métodos configuráveis de IRickUIBuilderBadge diretamente.'#13#10 +
    '// Pill(False) mantém CornerRadius ativo e o resultado aparece na aba Resultado.'#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .Badge'#13#10 +
    '    .Text(''Configuração completa'')'#13#10 +
    '      .Position(18, 20)'#13#10 +
    '      .Size(220, 38)'#13#10 +
    '        .Pill(False)'#13#10 +
    '        .CornerRadius(10)'#13#10 +
    '          .Margin(TRickUIBuilderSpacing.Create(12, 8, 4, 2))'#13#10 +
    '          .Padding(TRickUIBuilderSpacing.Create(8, 4, 6, 2))'#13#10 +
    '            .BackgroundColor(TAlphaColors.Dodgerblue)'#13#10 +
    '            .BorderColor(TAlphaColors.Gray)'#13#10 +
    '              .TextColor(TAlphaColors.White)'#13#10 +
    '              .FontSize(15)'#13#10 +
    '              .Bold(True)'#13#10 +
    '                .Opacity(0.92)'#13#10 +
    '                .Visible(True)'#13#10 +
    '                .Tag(2026)'#13#10 +
    '                  .Build(ResultHost);',

    '// Mantém a configuração completa em IRickUIBuilderBadge e usa o Handle público.'#13#10 +
    '// Pill(False) mantém CornerRadius ativo e o resultado aparece na aba Resultado.'#13#10 +
    'var'#13#10 +
    '  LBadge: IRickUIBuilderBadge;'#13#10 +
    '  LHandle: IRickUIBuilderBadgeHandle;'#13#10 +
    'begin'#13#10 +
    '  LBadge := TRickUIBuilder.Badge;'#13#10 +
    ''#13#10 +
    '  LHandle := LBadge'#13#10 +
    '    .Text(''Completo com interfaces'')'#13#10 +
    '      .Position(18, 20)'#13#10 +
    '      .Size(220, 38)'#13#10 +
    '        .Pill(False)'#13#10 +
    '        .CornerRadius(10)'#13#10 +
    '          .Margin(TRickUIBuilderSpacing.Create(12, 8, 4, 2))'#13#10 +
    '          .Padding(TRickUIBuilderSpacing.Create(8, 4, 6, 2))'#13#10 +
    '            .BackgroundColor(TAlphaColors.Dodgerblue)'#13#10 +
    '            .BorderColor(TAlphaColors.Gray)'#13#10 +
    '              .TextColor(TAlphaColors.White)'#13#10 +
    '              .FontSize(15)'#13#10 +
    '              .Bold(True)'#13#10 +
    '                .Opacity(0.92)'#13#10 +
    '                .Visible(True)'#13#10 +
    '                .Tag(2026)'#13#10 +
    '                  .Build(ResultHost);'#13#10 +
    ''#13#10 +
    '  LHandle.TextLabel.Text := ''Interfaces completas'';'#13#10 +
    'end;');

class function TBadgeFluentContent.Caption(
  const AExample: TBadgeFluentExample): string;
begin
  Result := _CAPTIONS_[AExample];
end;

class function TBadgeFluentContent.Title(
  const AExample: TBadgeFluentExample): string;
begin
  Result := _TITLES_[AExample];
end;

class function TBadgeFluentContent.Description(
  const AExample: TBadgeFluentExample): string;
begin
  Result := _DESCRIPTIONS_[AExample];
end;

class function TBadgeFluentContent.Code(
  const AExample: TBadgeFluentExample): string;
begin
  Result := _CODES_[AExample];
end;

end.
