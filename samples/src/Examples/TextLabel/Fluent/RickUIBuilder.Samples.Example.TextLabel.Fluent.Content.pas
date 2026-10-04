{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Example.TextLabel.Fluent.Content                      }
{                                                                              }
{ Esta unit mantém o conteúdo didático dos exemplos Text / Label - Fluent      }
{ Builder, associando cada TTextLabelFluentExample a caption, título,          }
{ descrição e snippet comentado coerentes com a execução real e garantindo     }
{ que o exemplo Completo exponha toda a API pública configurável de            }
{ IRickUIBuilderLabel.                                                         }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Centralizar exclusivamente o conteúdo textual dos exemplos Fluent Builder   }
{  de Text / Label exibidos pela página concreta do Samples.                   }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Associa cada TTextLabelFluentExample a caption, título, descrição e         }
{  snippet Delphi. O exemplo Completo chama todos os métodos públicos          }
{  configuráveis de IRickUIBuilderLabel e usa todos os lados dos records       }
{  TRickUIBuilderSpacing fornecidos a Margin e Padding.                        }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - RickUIBuilder.Samples.App.Types                                           }
{      Fornece TTextLabelFluentExample compartilhado por page, conteúdo e      }
{      Runner.                                                                 }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - TExampleTextLabelFluent consulta esta unit ao selecionar um exemplo.      }
{  - TTextLabelFluentRunner executa o mesmo exemplo identificado pelo enum     }
{    compartilhado em App.Types.                                               }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - Contém somente conteúdo de Text / Label na abordagem Fluent Builder.      }
{  - Não executa o builder e não cria controles.                               }
{  - Snippets devem permanecer coerentes com a execução real do Runner.        }
{  - O exemplo Completo deve acompanhar qualquer expansão pública futura da    }
{    configuração Fluent de Text / Label.                                      }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Atualizar esta unit quando a API pública Fluent de Text / Label mudar,      }
{  mantendo a cobertura e o exemplo Completo sincronizados.                    }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.Example.TextLabel.Fluent.Content;

interface

uses
  RickUIBuilder.Samples.App.Types;

type
  /// <summary>Conteúdo textual da página Text / Label - Fluent Builder.</summary>
  TTextLabelFluentContent = class sealed
  public
    class function Caption(const AExample: TTextLabelFluentExample): string; static;
    class function Title(const AExample: TTextLabelFluentExample): string; static;
    class function Description(const AExample: TTextLabelFluentExample): string; static;
    class function Code(const AExample: TTextLabelFluentExample): string; static;
  end;

implementation

const
  _CAPTIONS_: array[TTextLabelFluentExample] of string = (
    'Básico',
    'Geometria',
    'Layout',
    'Tipografia',
    'Alinhamento',
    'Fluxo de texto',
    'Estado',
    'Completo');

  _TITLES_: array[TTextLabelFluentExample] of string = (
    'Criação básica',
    'Posição e tamanho',
    'Layout externo e interno',
    'Tipografia',
    'Alinhamento horizontal e vertical',
    'Quebra e tratamento de texto',
    'Estado e identificação',
    'Configuração completa');

  _DESCRIPTIONS_: array[TTextLabelFluentExample] of string = (
    'Cria um TLabel com Label_, Text e Build.',
    'Configura Position e Size antes de materializar o controle.',
    'Configura Anchors, Margin e Padding; os spacings usam os quatro lados.',
    'Configura FontFamily, FontSize, FontColor, Bold e Italic.',
    'Configura Align e VerticalAlign com TTextAlign.',
    'Configura WordWrap e Trimming para o comportamento do texto.',
    'Configura Opacity, Visible, HitTest e Tag.',
    'Executa todos os métodos públicos configuráveis de IRickUIBuilderLabel.');

  _CODES_: array[TTextLabelFluentExample] of string = (
    '// Cria o TLabel pela API fluente principal do Rick.UIBuilder.'#13#10 +
    '// Build anexa o controle ao ResultHost exibido em Resultado.'#13#10 +
    'TRickUIBuilder.Label_'#13#10 +
    '  .Text(''Texto básico'')'#13#10 +
    '  .Build(ResultHost);',

    '// Define posição e tamanho antes de materializar o TLabel.'#13#10 +
    '// O resultado pode ser conferido na aba Resultado.'#13#10 +
    'TRickUIBuilder.Label_'#13#10 +
    '  .Text(''Posição e tamanho'')'#13#10 +
    '  .Position(20, 16)'#13#10 +
    '  .Size(260, 36)'#13#10 +
    '  .Build(ResultHost);',

    '// Configura anchors (System.UITypes) e os quatro lados dos spacings.'#13#10 +
    '// TRickUIBuilderSpacing pertence a Rick.UIBuilder.Types.'#13#10 +
    'TRickUIBuilder.Label_'#13#10 +
    '  .Text(''Layout configurado'')'#13#10 +
    '  .Position(16, 12)'#13#10 +
    '  .Size(300, 48)'#13#10 +
    '  .Anchors([TAnchorKind.akLeft, TAnchorKind.akTop])'#13#10 +
    '  .Margin(TRickUIBuilderSpacing.Create(8, 6, 4, 2))'#13#10 +
    '  .Padding(TRickUIBuilderSpacing.Create(10, 4, 6, 2))'#13#10 +
    '  .Build(ResultHost);',

    '// Combina família, tamanho, cor, negrito e itálico.'#13#10 +
    '// TAlphaColors requer System.UITypes; confira em Resultado.'#13#10 +
    'TRickUIBuilder.Label_'#13#10 +
    '  .Text(''Tipografia fluente'')'#13#10 +
    '  .Position(16, 12)'#13#10 +
    '  .Size(320, 44)'#13#10 +
    '  .FontFamily(''Segoe UI'')'#13#10 +
    '  .FontSize(18)'#13#10 +
    '  .FontColor(TAlphaColors.Blue)'#13#10 +
    '  .Bold(True)'#13#10 +
    '  .Italic(True)'#13#10 +
    '  .Build(ResultHost);',

    '// Configura alinhamento horizontal e vertical do TLabel.'#13#10 +
    '// TTextAlign requer FMX.Types; confira em Resultado.'#13#10 +
    'TRickUIBuilder.Label_'#13#10 +
    '  .Text(''Texto centralizado'')'#13#10 +
    '  .Position(16, 12)'#13#10 +
    '  .Size(320, 56)'#13#10 +
    '  .Align(TTextAlign.Center)'#13#10 +
    '  .VerticalAlign(TTextAlign.Center)'#13#10 +
    '  .Build(ResultHost);',

    '// Permite quebra de linha e configura a estratégia de trimming.'#13#10 +
    '// TTextTrimming requer FMX.Types; confira em Resultado.'#13#10 +
    'TRickUIBuilder.Label_'#13#10 +
    '  .Text(''Texto longo com quebra automática de linha.'')'#13#10 +
    '  .Position(16, 8)'#13#10 +
    '  .Size(260, 64)'#13#10 +
    '  .WordWrap(True)'#13#10 +
    '  .Trimming(TTextTrimming.None)'#13#10 +
    '  .Build(ResultHost);',

    '// Configura estado visual, interação e identificação do controle.'#13#10 +
    '// Tag não altera o visual; o TLabel resultante aparece em Resultado.'#13#10 +
    'TRickUIBuilder.Label_'#13#10 +
    '  .Text(''Estado configurado'')'#13#10 +
    '  .Position(16, 12)'#13#10 +
    '  .Size(300, 40)'#13#10 +
    '  .Opacity(0.70)'#13#10 +
    '  .Visible(True)'#13#10 +
    '  .HitTest(False)'#13#10 +
    '  .Tag(501)'#13#10 +
    '  .Build(ResultHost);',

    '// Exercita toda a API pública configurável de IRickUIBuilderLabel.'#13#10 +
    '// Margin/Padding usam os quatro lados; Build exibe no ResultHost.'#13#10 +
    'TRickUIBuilder.Label_'#13#10 +
    '  .Text(''Configuração completa'')'#13#10 +
    '  .Position(20, 12)'#13#10 +
    '  .Size(340, 72)'#13#10 +
    '  .Anchors([TAnchorKind.akLeft, TAnchorKind.akTop])'#13#10 +
    '  .Margin(TRickUIBuilderSpacing.Create(12, 8, 4, 2))'#13#10 +
    '  .Padding(TRickUIBuilderSpacing.Create(8, 4, 6, 2))'#13#10 +
    '  .FontFamily(''Segoe UI'')'#13#10 +
    '  .FontSize(16)'#13#10 +
    '  .FontColor(TAlphaColors.Green)'#13#10 +
    '  .Bold(True)'#13#10 +
    '  .Italic(True)'#13#10 +
    '  .Align(TTextAlign.Center)'#13#10 +
    '  .VerticalAlign(TTextAlign.Center)'#13#10 +
    '  .WordWrap(True)'#13#10 +
    '  .Trimming(TTextTrimming.None)'#13#10 +
    '  .Opacity(0.90)'#13#10 +
    '  .Visible(True)'#13#10 +
    '  .HitTest(False)'#13#10 +
    '  .Tag(1001)'#13#10 +
    '  .Build(ResultHost);');

class function TTextLabelFluentContent.Caption(
  const AExample: TTextLabelFluentExample): string;
begin
  Result := _CAPTIONS_[AExample];
end;

class function TTextLabelFluentContent.Title(
  const AExample: TTextLabelFluentExample): string;
begin
  Result := _TITLES_[AExample];
end;

class function TTextLabelFluentContent.Description(
  const AExample: TTextLabelFluentExample): string;
begin
  Result := _DESCRIPTIONS_[AExample];
end;

class function TTextLabelFluentContent.Code(
  const AExample: TTextLabelFluentExample): string;
begin
  Result := _CODES_[AExample];
end;

end.
