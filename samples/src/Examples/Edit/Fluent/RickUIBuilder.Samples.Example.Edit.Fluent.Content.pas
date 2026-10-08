{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Example.Edit.Fluent.Content                           }
{                                                                              }
{ Esta unit centraliza o conteúdo textual dos vinte e nove exemplos Edit -     }
{ Fluent Builder, incluindo todos os 14 presets públicos de entrada.           }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Fornecer captions, títulos, descrições e snippets da página Fluent.         }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Os exemplos cobrem presets individualmente, validação, clipboard, aparência }
{  e Handle runtime; o Completo referencia os 62 métodos configuráveis.        }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - RickUIBuilder.Samples.App.Types                                           }
{      Fornece TEditFluentExample compartilhado por Page, Content e Runner.    }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - TExampleEditFluent consulta esta unit ao selecionar um exemplo.           }
{  - TEditFluentRunner executa o comportamento correspondente no ResultHost.   }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - Não cria controles e não executa o Builder.                               }
{  - Todo snippet começa com comentários didáticos.                            }
{  - Helpers citados em exemplos interativos correspondem aos helpers do       }
{    Runner e não representam APIs do Rick.UIBuilder.                          }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Manter captions, descrições e snippets sincronizados com o Runner.          }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.Example.Edit.Fluent.Content;

interface

uses
  RickUIBuilder.Samples.App.Types;

type
  /// <summary>Conteúdo textual da página Edit - Fluent Builder.</summary>
  TEditFluentContent = class sealed
  public
    class function Caption(const AExample: TEditFluentExample): string; static;
    class function Title(const AExample: TEditFluentExample): string; static;
    class function Description(const AExample: TEditFluentExample): string; static;
    class function Code(const AExample: TEditFluentExample): string; static;
  end;

implementation

const
  _CAPTIONS_: array[TEditFluentExample] of string = (
    'Básico',
    'Interface',
    'Todos os caracteres',
    'CPF',
    'CNPJ',
    'CEP',
    'E-mail',
    'URL',
    'Telefone',
    'Celular',
    'Número inteiro',
    'Decimal - Locale',
    'Decimal ajustado',
    'Texto sem acentos',
    'Sem acento/pont.',
    'Texto com acentos',
    'Com acento/pont.',
    'Caixa do texto',
    'Obrigatoriedade',
    'Limite e contador',
    'Senha',
    'Feedback inválido',
    'Requisito',
    'Copiar/colar',
    'Aparência',
    'Somente leitura',
    'Edit customizado',
    'Handle runtime',
    'Completo');

  _TITLES_: array[TEditFluentExample] of string = (
    'Criação mínima do Edit',
    'Uso explícito de IRickUIBuilderEdit',
    'Preset sem restrição de caracteres',
    'CPF com máscara progressiva',
    'CNPJ alfanumérico com máscara',
    'CEP com máscara',
    'E-mail e validação',
    'URL e modos de lowercase',
    'Telefone com DDD opcional',
    'Celular com DDD opcional',
    'Inteiros positivos e negativos',
    'Float conforme locale',
    'Float com formatação customizada',
    'Texto sem acentos',
    'Texto sem acentos com pontuação',
    'Texto com acentos',
    'Texto com acentos e pontuação',
    'Preserve, Uppercase e Lowercase',
    'Required e campo opcional',
    'MaxLength, contador e ClearButton',
    'Password e alternância visual',
    'Três modos de feedback inválido',
    'Requisito controlado externamente',
    'Paste operacional de CPF e CNPJ',
    'Outlined e Underline',
    'ReadOnly com paleta própria',
    'Edit customizado por Fluent Builder',
    'IRickUIBuilderEditHandle',
    'Referência exaustiva da API Fluent');

  _DESCRIPTIONS_: array[TEditFluentExample] of string = (
    'Cria um Edit com texto, label, posição e tamanho usando Build.',
    'Mantém o builder na interface pública antes de materializar o Edit.',
    'Demonstra explicitamente o preset AllCharacters com conteúdo misto.',
    'Demonstra CPF formatado e permite nova digitação progressiva.',
    'Demonstra CNPJ com base alfanumérica e dois dígitos finais numéricos.',
    'Demonstra a máscara pública de CEP.',
    'Demonstra lowercase automático e feedback de e-mail inválido.',
    'Compara SchemeAndHost e EntireValue em dois Edits URL.',
    'Demonstra o preset Phone e sua formatação com DDD.',
    'Demonstra o preset Mobile e sua formatação com DDD.',
    'Compara inteiro sem negativo e inteiro com AllowNegative.',
    'Usa FloatNumber com NumberFormatMode.Locale e duas casas decimais.',
    'Usa FloatNumber Custom com separadores e milhar explícitos.',
    'Exercita o preset que rejeita acentos.',
    'Exercita texto sem acentos com a pontuação aceita pela política.',
    'Exercita texto que aceita acentos sem depender de pontuação ampliada.',
    'Exercita texto com acentos e pontuação.',
    'Compara os três valores públicos de TRickUIBuilderEditCaseMode.',
    'Compara Required com um campo opcional.',
    'Combina MaxLength, CharacterCounter e ClearButton no mesmo campo.',
    'Exibe Password com conteúdo inicial e ação de mostrar/ocultar do próprio Edit.',
    'Compara AlertOnly, IconOnly e AlertAndIcon usando SetInvalid.',
    'Usa RequirementIndicator e alterna o estado pelo Handle.',
    'Reproduz a validação operacional do Sample legado para paste mascarado de CPF e CNPJ.',
    'Compara as duas aparências públicas Outlined e Underline.',
    'Demonstra ReadOnly e suas cores específicas.',
    'Personaliza cores, bordas, tipografia, ícones, paths e feedback do Edit.',
    'Demonstra Text getter/setter, Clear, SetInvalid e SetRequirementMet em runtime.',
    'Cobre os 62 métodos configuráveis de IRickUIBuilderEdit e finaliza com Build.');

  _CODES_: array[TEditFluentExample] of string = (
    '// Demonstra a API pública deste exemplo.'#13#10 +
    '// O resultado correspondente é exibido no ResultHost.'#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .Edit'#13#10 +
    '    .Text(''Rick.UIBuilder'')'#13#10 +
    '    .LabelText(''Nome'')'#13#10 +
    '      .Position(16, 16)'#13#10 +
    '      .Size(340, 64)'#13#10 +
    '        .Build(ResultHost);',
    '// Demonstra a API pública deste exemplo.'#13#10 +
    '// O resultado correspondente é exibido no ResultHost.'#13#10 +
    'var'#13#10 +
    '  LEdit: IRickUIBuilderEdit;'#13#10 +
    'begin'#13#10 +
    '  LEdit := TRickUIBuilder.Edit;'#13#10 +
    '  LEdit'#13#10 +
    '    .Text(''IRickUIBuilderEdit'')'#13#10 +
    '    .LabelText(''Interface pública'')'#13#10 +
    '      .Position(16, 16)'#13#10 +
    '      .Size(340, 64)'#13#10 +
    '        .Build(ResultHost);'#13#10 +
    'end;',
    '// Demonstra a API pública deste exemplo.'#13#10 +
    '// O resultado correspondente é exibido no ResultHost.'#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .Edit'#13#10 +
    '    .Text(''ABC áé 123 !@#$%'')'#13#10 +
    '    .LabelText(''Todos os caracteres'')'#13#10 +
    '      .Position(16, 16)'#13#10 +
    '      .Size(340, 64)'#13#10 +
    '        .Preset(TRickUIBuilderEditPreset.AllCharacters)'#13#10 +
    '          .ClearButton'#13#10 +
    '            .Build(ResultHost);',
    '// Demonstra a API pública deste exemplo.'#13#10 +
    '// O resultado correspondente é exibido no ResultHost.'#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .Edit'#13#10 +
    '    .Text(''123.456.789-01'')'#13#10 +
    '    .LabelText(''CPF - 000.000.000-00'')'#13#10 +
    '      .Position(16, 16)'#13#10 +
    '      .Size(340, 64)'#13#10 +
    '        .Preset(TRickUIBuilderEditPreset.CPF)'#13#10 +
    '          .ClearButton'#13#10 +
    '            .Build(ResultHost);',
    '// Demonstra a API pública deste exemplo.'#13#10 +
    '// O resultado correspondente é exibido no ResultHost.'#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .Edit'#13#10 +
    '    .Text(''12.ABC.345/01DE-35'')'#13#10 +
    '    .LabelText(''CNPJ alfanumérico - AA.AAA.AAA/AAAA-00'')'#13#10 +
    '      .Position(16, 16)'#13#10 +
    '      .Size(340, 64)'#13#10 +
    '        .Preset(TRickUIBuilderEditPreset.CNPJ)'#13#10 +
    '          .ClearButton'#13#10 +
    '            .Build(ResultHost);',
    '// Demonstra a API pública deste exemplo.'#13#10 +
    '// O resultado correspondente é exibido no ResultHost.'#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .Edit'#13#10 +
    '    .Text(''20040-020'')'#13#10 +
    '    .LabelText(''CEP - 00000-000'')'#13#10 +
    '      .Position(16, 16)'#13#10 +
    '      .Size(340, 64)'#13#10 +
    '        .Preset(TRickUIBuilderEditPreset.CEP)'#13#10 +
    '          .ClearButton'#13#10 +
    '            .Build(ResultHost);',
    '// Demonstra a API pública deste exemplo.'#13#10 +
    '// O resultado correspondente é exibido no ResultHost.'#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .Edit'#13#10 +
    '    .Text(''Nome@Exemplo.COM'')'#13#10 +
    '    .LabelText(''E-mail - lowercase automático'')'#13#10 +
    '      .Position(16, 16)'#13#10 +
    '      .Size(340, 72)'#13#10 +
    '        .Preset(TRickUIBuilderEditPreset.Email)'#13#10 +
    '          .ClearButton'#13#10 +
    '            .InvalidFeedback(TRickUIBuilderEditInvalidFeedback.AlertAndIcon)'#13#10 +
    '            .InvalidMessage(''E-mail incompleto ou inválido'')'#13#10 +
    '              .Build(ResultHost);',
    '// Demonstra a API pública deste exemplo.'#13#10 +
    '// O resultado correspondente é exibido no ResultHost.'#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .Edit'#13#10 +
    '    .Text(''HTTPS://Example.COM/Path?Token=ABC'')'#13#10 +
    '    .LabelText(''URL - scheme + host'')'#13#10 +
    '      .Position(16, 12)'#13#10 +
    '      .Size(380, 64)'#13#10 +
    '        .Preset(TRickUIBuilderEditPreset.URL)'#13#10 +
    '        .UrlCaseMode(TRickUIBuilderEditUrlCaseMode.SchemeAndHost)'#13#10 +
    '          .Build(ResultHost);'#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .Edit'#13#10 +
    '    .Text(''HTTPS://Example.COM/Path?Token=ABC'')'#13#10 +
    '    .LabelText(''URL - conteúdo inteiro'')'#13#10 +
    '      .Position(16, 92)'#13#10 +
    '      .Size(380, 64)'#13#10 +
    '        .Preset(TRickUIBuilderEditPreset.URL)'#13#10 +
    '        .UrlCaseMode(TRickUIBuilderEditUrlCaseMode.EntireValue)'#13#10 +
    '          .Build(ResultHost);',
    '// Demonstra a API pública deste exemplo.'#13#10 +
    '// O resultado correspondente é exibido no ResultHost.'#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .Edit'#13#10 +
    '    .Text(''(21) 3333-4444'')'#13#10 +
    '    .LabelText(''Telefone - DDD opcional'')'#13#10 +
    '      .Position(16, 16)'#13#10 +
    '      .Size(340, 64)'#13#10 +
    '        .Preset(TRickUIBuilderEditPreset.Phone)'#13#10 +
    '          .ClearButton'#13#10 +
    '            .Build(ResultHost);',
    '// Demonstra a API pública deste exemplo.'#13#10 +
    '// O resultado correspondente é exibido no ResultHost.'#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .Edit'#13#10 +
    '    .Text(''(21) 99999-8888'')'#13#10 +
    '    .LabelText(''Celular - DDD opcional'')'#13#10 +
    '      .Position(16, 16)'#13#10 +
    '      .Size(340, 64)'#13#10 +
    '        .Preset(TRickUIBuilderEditPreset.Mobile)'#13#10 +
    '          .ClearButton'#13#10 +
    '            .Build(ResultHost);',
    '// Demonstra a API pública deste exemplo.'#13#10 +
    '// O resultado correspondente é exibido no ResultHost.'#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .Edit'#13#10 +
    '    .Text(''150'')'#13#10 +
    '    .LabelText(''Inteiro positivo'')'#13#10 +
    '      .Position(16, 12)'#13#10 +
    '      .Size(340, 64)'#13#10 +
    '        .Preset(TRickUIBuilderEditPreset.IntegerNumber)'#13#10 +
    '          .AllowNegative(False)'#13#10 +
    '            .Build(ResultHost);'#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .Edit'#13#10 +
    '    .Text(''-42'')'#13#10 +
    '    .LabelText(''Inteiro com negativo'')'#13#10 +
    '      .Position(16, 92)'#13#10 +
    '      .Size(340, 64)'#13#10 +
    '        .Preset(TRickUIBuilderEditPreset.IntegerNumber)'#13#10 +
    '          .AllowNegative(True)'#13#10 +
    '            .Build(ResultHost);',
    '// Demonstra a API pública deste exemplo.'#13#10 +
    '// O resultado correspondente é exibido no ResultHost.'#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .Edit'#13#10 +
    '    .LabelText(''Float - formatação do locale'')'#13#10 +
    '      .Position(16, 16)'#13#10 +
    '      .Size(340, 64)'#13#10 +
    '        .Preset(TRickUIBuilderEditPreset.FloatNumber)'#13#10 +
    '          .DecimalPlaces(2)'#13#10 +
    '          .NumberFormatMode(TRickUIBuilderEditNumberFormatMode.Locale)'#13#10 +
    '            .Build(ResultHost);',
    '// Demonstra a API pública deste exemplo.'#13#10 +
    '// O resultado correspondente é exibido no ResultHost.'#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .Edit'#13#10 +
    '    .LabelText(''Float custom - negativo e milhar'')'#13#10 +
    '      .Position(16, 16)'#13#10 +
    '      .Size(340, 64)'#13#10 +
    '        .Preset(TRickUIBuilderEditPreset.FloatNumber)'#13#10 +
    '          .AllowNegative'#13#10 +
    '          .DecimalPlaces(2)'#13#10 +
    '          .NumberFormatMode(TRickUIBuilderEditNumberFormatMode.Custom)'#13#10 +
    '          .DecimalSeparator('','')'#13#10 +
    '          .ThousandSeparator(''.'')'#13#10 +
    '          .UseThousandSeparator'#13#10 +
    '            .Build(ResultHost);',
    '// Demonstra a API pública deste exemplo.'#13#10 +
    '// O resultado correspondente é exibido no ResultHost.'#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .Edit'#13#10 +
    '    .Text(''Cafe sem acentos'')'#13#10 +
    '    .LabelText(''Texto sem acentos'')'#13#10 +
    '      .Position(16, 16)'#13#10 +
    '      .Size(340, 64)'#13#10 +
    '        .Preset(TRickUIBuilderEditPreset.TextNoAccents)'#13#10 +
    '          .ClearButton'#13#10 +
    '            .Build(ResultHost);',
    '// Demonstra a API pública deste exemplo.'#13#10 +
    '// O resultado correspondente é exibido no ResultHost.'#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .Edit'#13#10 +
    '    .Text(''Cafe, preco: 12.50!'')'#13#10 +
    '    .LabelText(''Sem acentos + pontuação'')'#13#10 +
    '      .Position(16, 16)'#13#10 +
    '      .Size(340, 64)'#13#10 +
    '        .Preset(TRickUIBuilderEditPreset.TextPunctuationNoAccents)'#13#10 +
    '          .ClearButton'#13#10 +
    '            .Build(ResultHost);',
    '// Demonstra a API pública deste exemplo.'#13#10 +
    '// O resultado correspondente é exibido no ResultHost.'#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .Edit'#13#10 +
    '    .Text(''Café, ação e coração'')'#13#10 +
    '    .LabelText(''Texto com acentos'')'#13#10 +
    '      .Position(16, 16)'#13#10 +
    '      .Size(340, 64)'#13#10 +
    '        .Preset(TRickUIBuilderEditPreset.TextWithAccents)'#13#10 +
    '          .ClearButton'#13#10 +
    '            .Build(ResultHost);',
    '// Demonstra a API pública deste exemplo.'#13#10 +
    '// O resultado correspondente é exibido no ResultHost.'#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .Edit'#13#10 +
    '    .Text(''Olá, João! Café: R$ 12,50.'')'#13#10 +
    '    .LabelText(''Com acentos + pontuação'')'#13#10 +
    '      .Position(16, 16)'#13#10 +
    '      .Size(360, 64)'#13#10 +
    '        .Preset(TRickUIBuilderEditPreset.TextPunctuationWithAccents)'#13#10 +
    '          .ClearButton'#13#10 +
    '            .Build(ResultHost);',
    '// Demonstra a API pública deste exemplo.'#13#10 +
    '// O resultado correspondente é exibido no ResultHost.'#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .Edit'#13#10 +
    '    .Text(''Rick UiBuilder'')'#13#10 +
    '    .LabelText(''Preserve'')'#13#10 +
    '      .Position(16, 8)'#13#10 +
    '      .Size(340, 56)'#13#10 +
    '        .CaseMode(TRickUIBuilderEditCaseMode.Preserve)'#13#10 +
    '          .Build(ResultHost);'#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .Edit'#13#10 +
    '    .Text(''rick uibuilder'')'#13#10 +
    '    .LabelText(''Uppercase'')'#13#10 +
    '      .Position(16, 76)'#13#10 +
    '      .Size(340, 56)'#13#10 +
    '        .CaseMode(TRickUIBuilderEditCaseMode.Uppercase)'#13#10 +
    '          .Build(ResultHost);'#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .Edit'#13#10 +
    '    .Text(''RICK UIBUILDER'')'#13#10 +
    '    .LabelText(''Lowercase'')'#13#10 +
    '      .Position(16, 144)'#13#10 +
    '      .Size(340, 56)'#13#10 +
    '        .CaseMode(TRickUIBuilderEditCaseMode.Lowercase)'#13#10 +
    '          .Build(ResultHost);',
    '// Demonstra a API pública deste exemplo.'#13#10 +
    '// O resultado correspondente é exibido no ResultHost.'#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .Edit'#13#10 +
    '    .LabelText(''Campo obrigatório'')'#13#10 +
    '      .Position(16, 12)'#13#10 +
    '      .Size(360, 72)'#13#10 +
    '        .Required(True)'#13#10 +
    '        .InvalidFeedback(TRickUIBuilderEditInvalidFeedback.AlertAndIcon)'#13#10 +
    '        .InvalidMessage(''Este campo é obrigatório'')'#13#10 +
    '          .Build(ResultHost);'#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .Edit'#13#10 +
    '    .LabelText(''Campo opcional'')'#13#10 +
    '      .Position(16, 104)'#13#10 +
    '      .Size(360, 64)'#13#10 +
    '        .Required(False)'#13#10 +
    '          .Build(ResultHost);',
    '// Demonstra a API pública deste exemplo.'#13#10 +
    '// O resultado correspondente é exibido no ResultHost.'#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .Edit'#13#10 +
    '    .Text(''Rick.UIBuilder'')'#13#10 +
    '    .LabelText(''Máximo 20 caracteres'')'#13#10 +
    '      .Position(16, 16)'#13#10 +
    '      .Size(360, 68)'#13#10 +
    '        .MaxLength(20)'#13#10 +
    '        .CharacterCounter(True)'#13#10 +
    '        .ClearButton(True)'#13#10 +
    '          .Build(ResultHost);',
    '// Demonstra a API pública deste exemplo.'#13#10 +
    '// O resultado correspondente é exibido no ResultHost.'#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .Edit'#13#10 +
    '    .Text(''SenhaSegura123'')'#13#10 +
    '    .LabelText(''Senha - mostrar/ocultar'')'#13#10 +
    '      .Position(16, 16)'#13#10 +
    '      .Size(360, 64)'#13#10 +
    '        .ClearButton(True)'#13#10 +
    '        .Password(True)'#13#10 +
    '          .Build(ResultHost);',
    '// Compara os três modos de feedback e permite alternar o terceiro estado.'#13#10 +
    '// O resultado correspondente é exibido no ResultHost.'#13#10 +
    'var'#13#10 +
    '  LHandle: IRickUIBuilderEditHandle;'#13#10 +
    'begin'#13#10 +
    '  LHandle := TRickUIBuilder'#13#10 +
    '    .Edit'#13#10 +
    '      .LabelText(''Somente mensagem'')'#13#10 +
    '        .Position(8, 4)'#13#10 +
    '        .Size(190, 60)'#13#10 +
    '          .InvalidFeedback(TRickUIBuilderEditInvalidFeedback.AlertOnly)'#13#10 +
    '            .Build(ResultHost);'#13#10 +
    '  LHandle.SetInvalid(True, ''Valor inválido'');'#13#10 +
    ''#13#10 +
    '  LHandle := TRickUIBuilder'#13#10 +
    '    .Edit'#13#10 +
    '      .LabelText(''Somente ícone'')'#13#10 +
    '        .Position(210, 4)'#13#10 +
    '        .Size(190, 60)'#13#10 +
    '          .InvalidFeedback(TRickUIBuilderEditInvalidFeedback.IconOnly)'#13#10 +
    '            .Build(ResultHost);'#13#10 +
    '  LHandle.SetInvalid(True, ''Valor inválido'');'#13#10 +
    ''#13#10 +
    '  FInvalidHandle := TRickUIBuilder'#13#10 +
    '    .Edit'#13#10 +
    '      .LabelText(''Mensagem + ícone'')'#13#10 +
    '        .Position(8, 100)'#13#10 +
    '        .Size(248, 68)'#13#10 +
    '          .InvalidFeedback(TRickUIBuilderEditInvalidFeedback.AlertAndIcon)'#13#10 +
    '            .Build(ResultHost);'#13#10 +
    '  FInvalidHandle.SetInvalid(True, ''Valor inválido'');'#13#10 +
    '  AddButton(ResultHost, ''Inválido'', 268, 114, 64, MarkInvalid);'#13#10 +
    '  AddButton(ResultHost, ''Válido'', 336, 114, 64, MarkValid);'#13#10 +
    'end;'#13#10 +
    ''#13#10 +
    'procedure MarkInvalid(ASender: TObject);'#13#10 +
    'begin'#13#10 +
    '  FInvalidHandle.SetInvalid(True, ''Valor inválido definido pelo Sample'');'#13#10 +
    'end;'#13#10 +
    ''#13#10 +
    'procedure MarkValid(ASender: TObject);'#13#10 +
    'begin'#13#10 +
    '  FInvalidHandle.SetInvalid(False);'#13#10 +
    'end;',
    '// RequirementIndicator representa um estado externo controlado pelo Handle.'#13#10 +
    '// Os botões alteram esse estado no resultado real.'#13#10 +
    'begin'#13#10 +
    '  FRequirementHandle := TRickUIBuilder'#13#10 +
    '    .Edit'#13#10 +
    '      .LabelText(''Requisito externo'')'#13#10 +
    '        .Position(16, 16)'#13#10 +
    '        .Size(360, 64)'#13#10 +
    '          .RequirementIndicator(True)'#13#10 +
    '            .Build(ResultHost);'#13#10 +
    '  AddButton(ResultHost, ''Atendido'', 16, 96, 100, RequirementMet);'#13#10 +
    '  AddButton(ResultHost, ''Não atendido'', 124, 96, 116, RequirementNotMet);'#13#10 +
    'end;'#13#10 +
    ''#13#10 +
    'procedure RequirementMet(ASender: TObject);'#13#10 +
    'begin'#13#10 +
    '  FRequirementHandle.SetRequirementMet(True);'#13#10 +
    'end;'#13#10 +
    ''#13#10 +
    'procedure RequirementNotMet(ASender: TObject);'#13#10 +
    'begin'#13#10 +
    '  FRequirementHandle.SetRequirementMet(False);'#13#10 +
    'end;',
    '// Reproduz o fluxo operacional do Sample legado para CPF e CNPJ.'#13#10 +
    '// Cada controle é criado por uma cadeia Fluent explícita no ResultHost.'#13#10 +
    'begin'#13#10 +
    '  FCopyCPFValid := TRickUIBuilder'#13#10 +
    '    .Edit'#13#10 +
    '      .Text(''123.456.789-01'')'#13#10 +
    '      .LabelText(''CPF válido'')'#13#10 +
    '        .Position(4, 4)'#13#10 +
    '        .Size(118, 52)'#13#10 +
    '          .ReadOnly'#13#10 +
    '            .ReadOnlyBackgroundColor($FFF5F5F5)'#13#10 +
    '            .ReadOnlyBorderColor($FFD8D8D8)'#13#10 +
    '            .ReadOnlyTextColor($FF707070)'#13#10 +
    '              .Build(ResultHost);'#13#10 +
    ''#13#10 +
    '  FCopyCPFInvalid := TRickUIBuilder'#13#10 +
    '    .Edit'#13#10 +
    '      .Text(''12345678901'')'#13#10 +
    '      .LabelText(''CPF sem máscara'')'#13#10 +
    '        .Position(4, 68)'#13#10 +
    '        .Size(118, 52)'#13#10 +
    '          .ReadOnly'#13#10 +
    '            .ReadOnlyBackgroundColor($FFF5F5F5)'#13#10 +
    '            .ReadOnlyBorderColor($FFD8D8D8)'#13#10 +
    '            .ReadOnlyTextColor($FF707070)'#13#10 +
    '              .Build(ResultHost);'#13#10 +
    ''#13#10 +
    '  FPasteCPF := TRickUIBuilder'#13#10 +
    '    .Edit'#13#10 +
    '      .LabelText(''Alvo CPF'')'#13#10 +
    '        .Position(4, 132)'#13#10 +
    '        .Size(118, 52)'#13#10 +
    '          .Preset(TRickUIBuilderEditPreset.CPF)'#13#10 +
    '            .ClearButton'#13#10 +
    '              .Build(ResultHost);'#13#10 +
    '  AddButton(ResultHost, ''Copiar'', 126, 14, 70, CopyCPFValid);'#13#10 +
    '  AddButton(ResultHost, ''Copiar'', 126, 80, 70, CopyCPFInvalid);'#13#10 +
    '  AddButton(ResultHost, ''Colar'', 126, 144, 70, PasteCPF);'#13#10 +
    ''#13#10 +
    '  FCopyCNPJValid := TRickUIBuilder'#13#10 +
    '    .Edit'#13#10 +
    '      .Text(''12.ABC.345/01DE-35'')'#13#10 +
    '      .LabelText(''CNPJ válido'')'#13#10 +
    '        .Position(208, 4)'#13#10 +
    '        .Size(118, 52)'#13#10 +
    '          .ReadOnly'#13#10 +
    '            .ReadOnlyBackgroundColor($FFF5F5F5)'#13#10 +
    '            .ReadOnlyBorderColor($FFD8D8D8)'#13#10 +
    '            .ReadOnlyTextColor($FF707070)'#13#10 +
    '              .Build(ResultHost);'#13#10 +
    ''#13#10 +
    '  FCopyCNPJInvalid := TRickUIBuilder'#13#10 +
    '    .Edit'#13#10 +
    '      .Text(''12ABC34501DE35'')'#13#10 +
    '      .LabelText(''CNPJ sem máscara'')'#13#10 +
    '        .Position(208, 68)'#13#10 +
    '        .Size(118, 52)'#13#10 +
    '          .ReadOnly'#13#10 +
    '            .ReadOnlyBackgroundColor($FFF5F5F5)'#13#10 +
    '            .ReadOnlyBorderColor($FFD8D8D8)'#13#10 +
    '            .ReadOnlyTextColor($FF707070)'#13#10 +
    '              .Build(ResultHost);'#13#10 +
    ''#13#10 +
    '  FPasteCNPJ := TRickUIBuilder'#13#10 +
    '    .Edit'#13#10 +
    '      .LabelText(''Alvo CNPJ'')'#13#10 +
    '        .Position(208, 132)'#13#10 +
    '        .Size(118, 52)'#13#10 +
    '          .Preset(TRickUIBuilderEditPreset.CNPJ)'#13#10 +
    '            .ClearButton'#13#10 +
    '              .Build(ResultHost);'#13#10 +
    '  AddButton(ResultHost, ''Copiar'', 330, 14, 70, CopyCNPJValid);'#13#10 +
    '  AddButton(ResultHost, ''Copiar'', 330, 80, 70, CopyCNPJInvalid);'#13#10 +
    '  AddButton(ResultHost, ''Colar'', 330, 144, 70, PasteCNPJ);'#13#10 +
    'end;'#13#10 +
    ''#13#10 +
    'procedure CopyCPFValid(ASender: TObject);'#13#10 +
    'begin'#13#10 +
    '  FCopyCPFValid.EditControl.SelectAll;'#13#10 +
    '  FCopyCPFValid.EditControl.CopyToClipboard;'#13#10 +
    'end;'#13#10 +
    ''#13#10 +
    'procedure CopyCPFInvalid(ASender: TObject);'#13#10 +
    'begin'#13#10 +
    '  FCopyCPFInvalid.EditControl.SelectAll;'#13#10 +
    '  FCopyCPFInvalid.EditControl.CopyToClipboard;'#13#10 +
    'end;'#13#10 +
    ''#13#10 +
    'procedure PasteCPF(ASender: TObject);'#13#10 +
    'begin'#13#10 +
    '  FPasteCPF.EditControl.SetFocus;'#13#10 +
    '  FPasteCPF.EditControl.SelectAll;'#13#10 +
    '  FPasteCPF.EditControl.PasteFromClipboard;'#13#10 +
    'end;'#13#10 +
    ''#13#10 +
    'procedure CopyCNPJValid(ASender: TObject);'#13#10 +
    'begin'#13#10 +
    '  FCopyCNPJValid.EditControl.SelectAll;'#13#10 +
    '  FCopyCNPJValid.EditControl.CopyToClipboard;'#13#10 +
    'end;'#13#10 +
    ''#13#10 +
    'procedure CopyCNPJInvalid(ASender: TObject);'#13#10 +
    'begin'#13#10 +
    '  FCopyCNPJInvalid.EditControl.SelectAll;'#13#10 +
    '  FCopyCNPJInvalid.EditControl.CopyToClipboard;'#13#10 +
    'end;'#13#10 +
    ''#13#10 +
    'procedure PasteCNPJ(ASender: TObject);'#13#10 +
    'begin'#13#10 +
    '  FPasteCNPJ.EditControl.SetFocus;'#13#10 +
    '  FPasteCNPJ.EditControl.SelectAll;'#13#10 +
    '  FPasteCNPJ.EditControl.PasteFromClipboard;'#13#10 +
    'end;',
    '// Demonstra a API pública deste exemplo.'#13#10 +
    '// O resultado correspondente é exibido no ResultHost.'#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .Edit'#13#10 +
    '    .Text(''Borda completa'')'#13#10 +
    '    .LabelText(''Outlined'')'#13#10 +
    '      .Position(16, 12)'#13#10 +
    '      .Size(360, 64)'#13#10 +
    '        .Appearance(TRickUIBuilderEditAppearance.Outlined)'#13#10 +
    '          .Build(ResultHost);'#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .Edit'#13#10 +
    '    .Text(''Linha inferior'')'#13#10 +
    '    .LabelText(''Underline'')'#13#10 +
    '      .Position(16, 92)'#13#10 +
    '      .Size(360, 64)'#13#10 +
    '        .Appearance(TRickUIBuilderEditAppearance.Underline)'#13#10 +
    '          .UnderlineThickness(2)'#13#10 +
    '            .Build(ResultHost);',
    '// Demonstra a API pública deste exemplo.'#13#10 +
    '// O resultado correspondente é exibido no ResultHost.'#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .Edit'#13#10 +
    '    .Text(''Informação fornecida'')'#13#10 +
    '    .LabelText(''Somente leitura'')'#13#10 +
    '      .Position(16, 16)'#13#10 +
    '      .Size(360, 64)'#13#10 +
    '        .ReadOnly(True)'#13#10 +
    '          .ReadOnlyBackgroundColor($FFF5F5F5)'#13#10 +
    '          .ReadOnlyBorderColor($FFD8D8D8)'#13#10 +
    '          .ReadOnlyTextColor($FF8A8A8A)'#13#10 +
    '          .ReadOnlyLabelColor($FF8A8A8A)'#13#10 +
    '            .Build(ResultHost);',
    '// Combina cores, fontes, ícones, paths válidos e espaçamento de erro.'#13#10 +
    '// Cada Edit mantém sua cadeia Fluent completa até o Build no ResultHost.'#13#10 +
    'var'#13#10 +
    '  LHandle: IRickUIBuilderEditHandle;'#13#10 +
    '  LDefaults: TRickUIBuilderEditConfig;'#13#10 +
    'begin'#13#10 +
    '  LDefaults := TRickUIBuilderEditConfig.Default;'#13#10 +
    ''#13#10 +
    '  LHandle := TRickUIBuilder'#13#10 +
    '    .Edit'#13#10 +
    '      .Text(''Visual personalizado'')'#13#10 +
    '      .LabelText(''Edit customizado'')'#13#10 +
    '        .Position(16, 8)'#13#10 +
    '        .Size(360, 76)'#13#10 +
    '          .ClearButton(True)'#13#10 +
    '          .RequirementIndicator(True)'#13#10 +
    '          .InvalidFeedback(TRickUIBuilderEditInvalidFeedback.AlertAndIcon)'#13#10 +
    '            .Appearance(TRickUIBuilderEditAppearance.Outlined)'#13#10 +
    '              .BackgroundColor(TAlphaColors.White)'#13#10 +
    '              .EditBackgroundColor($FFF2F7FF)'#13#10 +
    '              .BorderColor($FF7A9CC6)'#13#10 +
    '              .FocusBorderColor(TAlphaColors.Dodgerblue)'#13#10 +
    '              .InvalidBorderColor($FFD32F2F)'#13#10 +
    '              .InvalidBackgroundColor($FFFFF1F1)'#13#10 +
    '                .TextColor($FF17365D)'#13#10 +
    '                .LabelColor($FF6B4F1D)'#13#10 +
    '                .InvalidLabelColor($FFD32F2F)'#13#10 +
    '                  .FontSize(15)'#13#10 +
    '                  .LabelFontSize(12)'#13#10 +
    '                    .ErrorTextColor($FFD32F2F)'#13#10 +
    '                    .ErrorFontFamily(''Arial'')'#13#10 +
    '                    .ErrorFontSize(11)'#13#10 +
    '                    .ErrorFontStyles([TFontStyle.fsBold])'#13#10 +
    '                    .ErrorSpacing(6)'#13#10 +
    '                      .CornerRadius(10)'#13#10 +
    '                      .BorderThickness(2)'#13#10 +
    '                        .IconColor($FF245A9C)'#13#10 +
    '                        .AlertIconColor($FFD32F2F)'#13#10 +
    '                        .ClearIconColor($FF245A9C)'#13#10 +
    '                        .PasswordIconColor($FF245A9C)'#13#10 +
    '                        .RequirementIconColor($FF287A46)'#13#10 +
    '                        .IconSize(18)'#13#10 +
    '                          .AlertPath(LDefaults.AlertPath)'#13#10 +
    '                          .ClearPath(LDefaults.ClearPath)'#13#10 +
    '                          .VisibilityPath(LDefaults.VisibilityPath)'#13#10 +
    '                          .VisibilityOffPath(LDefaults.VisibilityOffPath)'#13#10 +
    '                          .RequirementMetPath(LDefaults.RequirementMetPath)'#13#10 +
    '                          .RequirementNotMetPath(LDefaults.RequirementNotMetPath)'#13#10 +
    '                            .Build(ResultHost);'#13#10 +
    '  LHandle.SetInvalid(True,'#13#10 +
    '    ''Mensagem com tipografia e espaçamento customizados'');'#13#10 +
    ''#13#10 +
    '  TRickUIBuilder'#13#10 +
    '    .Edit'#13#10 +
    '      .Text(''Senha visual'')'#13#10 +
    '      .LabelText(''Senha customizada'')'#13#10 +
    '        .Position(16, 104)'#13#10 +
    '        .Size(360, 68)'#13#10 +
    '          .Password(True)'#13#10 +
    '            .Appearance(TRickUIBuilderEditAppearance.Outlined)'#13#10 +
    '              .BackgroundColor(TAlphaColors.White)'#13#10 +
    '              .EditBackgroundColor($FFF2F7FF)'#13#10 +
    '              .BorderColor($FF7A9CC6)'#13#10 +
    '              .FocusBorderColor(TAlphaColors.Dodgerblue)'#13#10 +
    '              .InvalidBorderColor($FFD32F2F)'#13#10 +
    '              .InvalidBackgroundColor($FFFFF1F1)'#13#10 +
    '                .TextColor($FF17365D)'#13#10 +
    '                .LabelColor($FF6B4F1D)'#13#10 +
    '                .InvalidLabelColor($FFD32F2F)'#13#10 +
    '                  .FontSize(15)'#13#10 +
    '                  .LabelFontSize(12)'#13#10 +
    '                    .ErrorTextColor($FFD32F2F)'#13#10 +
    '                    .ErrorFontFamily(''Arial'')'#13#10 +
    '                    .ErrorFontSize(11)'#13#10 +
    '                    .ErrorFontStyles([TFontStyle.fsBold])'#13#10 +
    '                    .ErrorSpacing(6)'#13#10 +
    '                      .CornerRadius(10)'#13#10 +
    '                      .BorderThickness(2)'#13#10 +
    '                        .IconColor($FF245A9C)'#13#10 +
    '                        .AlertIconColor($FFD32F2F)'#13#10 +
    '                        .ClearIconColor($FF245A9C)'#13#10 +
    '                        .PasswordIconColor($FF245A9C)'#13#10 +
    '                        .RequirementIconColor($FF287A46)'#13#10 +
    '                        .IconSize(18)'#13#10 +
    '                          .AlertPath(LDefaults.AlertPath)'#13#10 +
    '                          .ClearPath(LDefaults.ClearPath)'#13#10 +
    '                          .VisibilityPath(LDefaults.VisibilityPath)'#13#10 +
    '                          .VisibilityOffPath(LDefaults.VisibilityOffPath)'#13#10 +
    '                          .RequirementMetPath(LDefaults.RequirementMetPath)'#13#10 +
    '                          .RequirementNotMetPath(LDefaults.RequirementNotMetPath)'#13#10 +
    '                            .Build(ResultHost);'#13#10 +
    'end;',
    '// Usa somente IRickUIBuilderEditHandle para alterar o Edit em runtime.'#13#10 +
    '// Os botões exercitam getter/setter, Clear, invalid e requisito.'#13#10 +
    'begin'#13#10 +
    '  FRuntimeHandle := TRickUIBuilder'#13#10 +
    '    .Edit'#13#10 +
    '      .Text(''Valor inicial'')'#13#10 +
    '      .LabelText(''Handle runtime'')'#13#10 +
    '        .Position(16, 8)'#13#10 +
    '        .Size(360, 64)'#13#10 +
    '          .RequirementIndicator(True)'#13#10 +
    '            .Build(ResultHost);'#13#10 +
    '  CreateRuntimeStatus(ResultHost);'#13#10 +
    '  AddButton(ResultHost, ''Texto'', 16, 124, 58, RuntimeSetText);'#13#10 +
    '  AddButton(ResultHost, ''Limpar'', 78, 124, 62, RuntimeClear);'#13#10 +
    '  AddButton(ResultHost, ''Inválido'', 144, 124, 68, RuntimeInvalid);'#13#10 +
    '  AddButton(ResultHost, ''Válido'', 216, 124, 60, RuntimeValid);'#13#10 +
    '  AddButton(ResultHost, ''Req. OK'', 280, 124, 62, RuntimeRequirementMet);'#13#10 +
    '  AddButton(ResultHost, ''Req. não'', 346, 124, 62, RuntimeRequirementNotMet);'#13#10 +
    '  AddButton(ResultHost, ''Ler Text'', 16, 164, 82, RuntimeShowText);'#13#10 +
    'end;'#13#10 +
    ''#13#10 +
    'procedure RuntimeSetText(ASender: TObject);'#13#10 +
    'begin'#13#10 +
    '  FRuntimeHandle.Text(''Texto alterado pelo Handle'');'#13#10 +
    '  SetRuntimeStatus(''Text setter aplicado'');'#13#10 +
    'end;'#13#10 +
    ''#13#10 +
    'procedure RuntimeClear(ASender: TObject);'#13#10 +
    'begin'#13#10 +
    '  FRuntimeHandle.Clear;'#13#10 +
    '  SetRuntimeStatus(''Clear executado'');'#13#10 +
    'end;'#13#10 +
    ''#13#10 +
    'procedure RuntimeInvalid(ASender: TObject);'#13#10 +
    'begin'#13#10 +
    '  FRuntimeHandle.SetInvalid(True, ''Inválido via Handle'');'#13#10 +
    '  SetRuntimeStatus(''Estado inválido'');'#13#10 +
    'end;'#13#10 +
    ''#13#10 +
    'procedure RuntimeValid(ASender: TObject);'#13#10 +
    'begin'#13#10 +
    '  FRuntimeHandle.SetInvalid(False);'#13#10 +
    '  SetRuntimeStatus(''Estado válido'');'#13#10 +
    'end;'#13#10 +
    ''#13#10 +
    'procedure RuntimeRequirementMet(ASender: TObject);'#13#10 +
    'begin'#13#10 +
    '  FRuntimeHandle.SetRequirementMet(True);'#13#10 +
    '  SetRuntimeStatus(''Requisito atendido'');'#13#10 +
    'end;'#13#10 +
    ''#13#10 +
    'procedure RuntimeRequirementNotMet(ASender: TObject);'#13#10 +
    'begin'#13#10 +
    '  FRuntimeHandle.SetRequirementMet(False);'#13#10 +
    '  SetRuntimeStatus(''Requisito não atendido'');'#13#10 +
    'end;'#13#10 +
    ''#13#10 +
    'procedure RuntimeShowText(ASender: TObject);'#13#10 +
    'begin'#13#10 +
    '  SetRuntimeStatus(''Text getter: '' + FRuntimeHandle.Text);'#13#10 +
    'end;',
    '// Referência exaustiva: cobre os 62 métodos configuráveis antes de Build.'#13#10 +
    '// A cadeia Fluent permanece contínua até o resultado no ResultHost.'#13#10 +
    'var'#13#10 +
    '  LDefaults: TRickUIBuilderEditConfig;'#13#10 +
    'begin'#13#10 +
    '  LDefaults := TRickUIBuilderEditConfig.Default;'#13#10 +
    ''#13#10 +
    '  TRickUIBuilder'#13#10 +
    '    .Edit'#13#10 +
    '      .Text(''Referência completa'')'#13#10 +
    '      .LabelText(''Edit completo'')'#13#10 +
    '        .Position(16, 16)'#13#10 +
    '        .Size(380, 86)'#13#10 +
    '          .Preset(TRickUIBuilderEditPreset.AllCharacters)'#13#10 +
    '          .CaseMode(TRickUIBuilderEditCaseMode.Preserve)'#13#10 +
    '          .UrlCaseMode(TRickUIBuilderEditUrlCaseMode.SchemeAndHost)'#13#10 +
    '            .MaxLength(80)'#13#10 +
    '            .CharacterCounter(True)'#13#10 +
    '            .ClearButton(True)'#13#10 +
    '            .Password(False)'#13#10 +
    '              .AllowNegative(True)'#13#10 +
    '              .DecimalPlaces(2)'#13#10 +
    '              .NumberFormatMode(TRickUIBuilderEditNumberFormatMode.Custom)'#13#10 +
    '              .DecimalSeparator('','')'#13#10 +
    '              .ThousandSeparator(''.'')'#13#10 +
    '              .UseThousandSeparator(True)'#13#10 +
    '                .Required(True)'#13#10 +
    '                .RequirementIndicator(True)'#13#10 +
    '                .InvalidFeedback('#13#10 +
    '                  TRickUIBuilderEditInvalidFeedback.AlertAndIcon)'#13#10 +
    '                .InvalidMessage(''Valor inválido'')'#13#10 +
    '                  .Appearance(TRickUIBuilderEditAppearance.Underline)'#13#10 +
    '                  .ReadOnly(False)'#13#10 +
    '                    .BackgroundColor(TAlphaColors.White)'#13#10 +
    '                    .EditBackgroundColor($FFF7FAFE)'#13#10 +
    '                    .BorderColor($FF9AA9B8)'#13#10 +
    '                    .FocusBorderColor(TAlphaColors.Dodgerblue)'#13#10 +
    '                    .InvalidBorderColor($FFD93025)'#13#10 +
    '                    .InvalidBackgroundColor($FFFFF0F0)'#13#10 +
    '                      .TextColor(TAlphaColors.Black)'#13#10 +
    '                      .LabelColor($FF506070)'#13#10 +
    '                      .InvalidLabelColor($FFD93025)'#13#10 +
    '                        .FontSize(14)'#13#10 +
    '                        .LabelFontSize(12)'#13#10 +
    '                          .ErrorTextColor($FFD93025)'#13#10 +
    '                          .ErrorFontFamily(''Arial'')'#13#10 +
    '                          .ErrorFontSize(11)'#13#10 +
    '                          .ErrorFontStyles([TFontStyle.fsBold])'#13#10 +
    '                          .ErrorSpacing(6)'#13#10 +
    '                            .ReadOnlyBackgroundColor($FFF7F7F7)'#13#10 +
    '                            .ReadOnlyBorderColor($FFD8D8D8)'#13#10 +
    '                            .ReadOnlyTextColor($FF888888)'#13#10 +
    '                            .ReadOnlyLabelColor($FF888888)'#13#10 +
    '                              .UnderlineColor($FFB0B0B0)'#13#10 +
    '                              .FocusUnderlineColor(TAlphaColors.Dodgerblue)'#13#10 +
    '                              .InvalidUnderlineColor($FFD93025)'#13#10 +
    '                              .ReadOnlyUnderlineColor($FFD8D8D8)'#13#10 +
    '                              .UnderlineThickness(2)'#13#10 +
    '                                .CornerRadius(8)'#13#10 +
    '                                .BorderThickness(1)'#13#10 +
    '                                  .IconColor($FF506070)'#13#10 +
    '                                  .AlertIconColor($FFD93025)'#13#10 +
    '                                  .ClearIconColor($FF245A9C)'#13#10 +
    '                                  .PasswordIconColor($FF245A9C)'#13#10 +
    '                                  .RequirementIconColor($FF287A46)'#13#10 +
    '                                  .IconSize(20)'#13#10 +
    '                                    .AlertPath(LDefaults.AlertPath)'#13#10 +
    '                                    .ClearPath(LDefaults.ClearPath)'#13#10 +
    '                                    .VisibilityPath(LDefaults.VisibilityPath)'#13#10 +
    '                                    .VisibilityOffPath('#13#10 +
    '                                      LDefaults.VisibilityOffPath)'#13#10 +
    '                                    .RequirementMetPath('#13#10 +
    '                                      LDefaults.RequirementMetPath)'#13#10 +
    '                                    .RequirementNotMetPath('#13#10 +
    '                                      LDefaults.RequirementNotMetPath)'#13#10 +
    '                                        .Build(ResultHost);'#13#10 +
    'end;');

class function TEditFluentContent.Caption(const AExample: TEditFluentExample): string;
begin
  Result := _CAPTIONS_[AExample];
end;

class function TEditFluentContent.Title(const AExample: TEditFluentExample): string;
begin
  Result := _TITLES_[AExample];
end;

class function TEditFluentContent.Description(const AExample: TEditFluentExample): string;
begin
  Result := _DESCRIPTIONS_[AExample];
end;

class function TEditFluentContent.Code(const AExample: TEditFluentExample): string;
begin
  Result := _CODES_[AExample];
end;

end.
