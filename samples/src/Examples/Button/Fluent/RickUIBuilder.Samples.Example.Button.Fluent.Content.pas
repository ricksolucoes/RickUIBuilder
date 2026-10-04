{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Example.Button.Fluent.Content                         }
{                                                                              }
{ Esta unit centraliza o conteúdo didático dos doze exemplos                   }
{ Button - Fluent Builder e mantém cada snippet sincronizado com a execução    }
{ real do Runner, com foco principal em IRickUIBuilderButton.                  }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Centralizar exclusivamente captions, títulos, descrições e snippets dos     }
{  exemplos Button - Fluent Builder exibidos pela Sample Page.                 }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Associa cada TButtonFluentExample ao conteúdo correspondente. Os exemplos   }
{  completos cobrem a configuração pública relevante de IRickUIBuilderButton;  }
{  a variante por interfaces usa também IRickUIBuilderButtonHandle e           }
{  IRickUIBuilderButtonHoverState, mantendo-as como APIs secundárias.          }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - RickUIBuilder.Samples.App.Types                                           }
{      Fornece TButtonFluentExample compartilhado por Page, Content e Runner.  }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - TExampleButtonFluent consulta esta unit ao selecionar um exemplo.         }
{  - TButtonFluentRunner executa o mesmo exemplo identificado pelo enum.       }
{  - Snippet e Runner devem manter métodos, valores, callbacks e agrupamento   }
{    Fluent equivalentes, variando apenas ResultHost/AHost.                    }
{                                                                              }
{  Ownership / lifetime                                                        }
{  --------------------                                                        }
{  - Esta unit mantém apenas strings constantes; não cria controles FMX.       }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - Não executa TRickUIBuilder.Button e não cria controles.                   }
{  - Não documenta implementações concretas internas do Fluent Builder.        }
{  - Tipos auxiliares aparecem somente quando exigidos pela API principal.     }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Qualquer mudança na API demonstrada deve ser refletida simultaneamente      }
{  nesta unit e em Button.Fluent.Runner.                                       }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.Example.Button.Fluent.Content;

interface

uses
  RickUIBuilder.Samples.App.Types;

type
  /// <summary>Conteúdo textual da página Button - Fluent Builder.</summary>
  TButtonFluentContent = class sealed
  public
    class function Caption(const AExample: TButtonFluentExample): string; static;
    class function Title(const AExample: TButtonFluentExample): string; static;
    class function Description(const AExample: TButtonFluentExample): string; static;
    class function Code(const AExample: TButtonFluentExample): string; static;
  end;

implementation

const
  _CAPTIONS_: array[TButtonFluentExample] of string = (
    'Básico',
    'Interface',
    'Geometria',
    'Layout',
    'Aparência',
    'Tipografia',
    'Estado',
    'Hover',
    'Clique',
    'Resultado',
    'Completo - Direto',
    'Completo - Interfaces');

  _TITLES_: array[TButtonFluentExample] of string = (
    'Criação básica',
    'Uso explícito de IRickUIBuilderButton',
    'Posição e tamanho',
    'Layout externo e interno',
    'Aparência do Button',
    'Tipografia do caption',
    'Estado e identificação',
    'Hover funcional',
    'Clique funcional',
    'Acesso ao resultado materializado',
    'Configuração completa direta',
    'Configuração completa com interfaces');

  _DESCRIPTIONS_: array[TButtonFluentExample] of string = (
    'Cria um Button com Caption e Build sem manter uma variável de interface.',
    'Mantém IRickUIBuilderButton explicitamente e continua usando a mesma API Fluent.',
    'Configura Position e Size antes de materializar o Button.',
    'Configura Anchors, Margin e Padding; TRickUIBuilderSpacing aparece somente como tipo auxiliar.',
    'Configura CornerRadius, FillColor, BorderColor e BorderThickness.',
    'Configura TextColor, FontFamily, FontSize e Bold sem acessar o TLabel interno.',
    'Demonstra Enabled, DisabledOpacity, Cursor, Opacity, Visible e Tag em estados coerentes.',
    'Combina HoverFillColor e OnHover; a cor e a espessura da borda mudam durante o hover.',
    'Configura OnClick na cadeia Fluent; clicar muda a cor do próprio Button.',
    'Usa BuildHandle da interface principal e acessa o TLabel pelo handle non-owning retornado.',
    'Executa todos os 23 métodos configuráveis de IRickUIBuilderButton e finaliza com Build.',
    'Executa a configuração completa mantendo IRickUIBuilderButton e utiliza IRickUIBuilderButtonHandle e IRickUIBuilderButtonHoverState.');

  _CODES_: array[TButtonFluentExample] of string = (
    '// Cria o Button pela API Fluent principal do Rick.UIBuilder.'#13#10 +
    '// Build anexa o controle ao ResultHost exibido na aba Resultado.'#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .Button'#13#10 +
    '    .Caption(''Salvar'')'#13#10 +
    '      .Build(ResultHost);',
    '// Mantém IRickUIBuilderButton em uma variável sem perder o encadeamento Fluent.'#13#10 +
    '// O Button materializado pela interface aparece na aba Resultado.'#13#10 +
    'var'#13#10 +
    '  LButton: IRickUIBuilderButton;'#13#10 +
    'begin'#13#10 +
    '  LButton := TRickUIBuilder.Button;'#13#10 +
    ''#13#10 +
    '  LButton'#13#10 +
    '    .Caption(''Salvar pela interface'')'#13#10 +
    '      .Size(220, 52)'#13#10 +
    '        .Build(ResultHost);'#13#10 +
    'end;',
    '// Configura posição e tamanho pela interface Fluent do Button.'#13#10 +
    '// O controle será exibido diretamente no ResultHost da aba Resultado.'#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .Button'#13#10 +
    '    .Caption(''Geometria'')'#13#10 +
    '      .Position(24, 20)'#13#10 +
    '      .Size(210, 52)'#13#10 +
    '        .Build(ResultHost);',
    '// Configura anchors e os quatro lados de Margin e Padding.'#13#10 +
    '// TRickUIBuilderSpacing é auxiliar da API principal e o resultado aparece em Resultado.'#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .Button'#13#10 +
    '    .Caption(''Layout'')'#13#10 +
    '      .Position(16, 12)'#13#10 +
    '      .Size(220, 52)'#13#10 +
    '        .Anchors([TAnchorKind.akLeft, TAnchorKind.akTop])'#13#10 +
    '        .Margin(TRickUIBuilderSpacing.Create(8, 6, 4, 2))'#13#10 +
    '        .Padding(TRickUIBuilderSpacing.Create(10, 4, 6, 2))'#13#10 +
    '          .Build(ResultHost);',
    '// Configura forma, preenchimento e borda pela API Fluent do Button.'#13#10 +
    '// O resultado visual pode ser conferido na aba Resultado.'#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .Button'#13#10 +
    '    .Caption(''Aparência'')'#13#10 +
    '      .Size(220, 52)'#13#10 +
    '        .CornerRadius(10)'#13#10 +
    '          .FillColor(TAlphaColors.Dodgerblue)'#13#10 +
    '          .BorderColor(TAlphaColors.Gray)'#13#10 +
    '          .BorderThickness(2)'#13#10 +
    '            .Build(ResultHost);',
    '// Configura o caption sem acessar diretamente o TLabel interno.'#13#10 +
    '// Toda a tipografia é aplicada pela IRickUIBuilderButton e exibida em Resultado.'#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .Button'#13#10 +
    '    .Caption(''Tipografia'')'#13#10 +
    '      .Size(220, 52)'#13#10 +
    '        .TextColor(TAlphaColors.White)'#13#10 +
    '          .FontFamily(''Segoe UI'')'#13#10 +
    '          .FontSize(18)'#13#10 +
    '          .Bold(True)'#13#10 +
    '            .Build(ResultHost);',
    '// Demonstra estado habilitado e desabilitado com suas opacidades.'#13#10 +
    '// Visible, Cursor e Tag também são configurados pela API Fluent na aba Resultado.'#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .Button'#13#10 +
    '    .Caption(''Ativo'')'#13#10 +
    '      .Position(16, 12)'#13#10 +
    '      .Size(220, 52)'#13#10 +
    '        .Opacity(0.80)'#13#10 +
    '        .Visible(True)'#13#10 +
    '        .Cursor(crHandPoint)'#13#10 +
    '        .Tag(501)'#13#10 +
    '          .Build(ResultHost);'#13#10 +
    ''#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .Button'#13#10 +
    '    .Caption(''Desabilitado'')'#13#10 +
    '      .Position(16, 80)'#13#10 +
    '      .Size(220, 52)'#13#10 +
    '        .Enabled(False)'#13#10 +
    '        .DisabledOpacity(0.35)'#13#10 +
    '          .Build(ResultHost);',
    '// Combina HoverFillColor com callbacks adicionais de OnHover.'#13#10 +
    '// O receptor dos eventos permanece vivo enquanto a Sample Page estiver aberta.'#13#10 +
    '// Passe o mouse no Button da aba Resultado para conferir cor e borda.'#13#10 +
    'procedure TButtonFluentRunner.MouseEnter(ASender: TObject);'#13#10 +
    'begin'#13#10 +
    '  TRectangle(ASender).Stroke.Thickness := 4;'#13#10 +
    'end;'#13#10 +
    ''#13#10 +
    'procedure TButtonFluentRunner.MouseLeave(ASender: TObject);'#13#10 +
    'begin'#13#10 +
    '  TRectangle(ASender).Stroke.Thickness := 2;'#13#10 +
    'end;'#13#10 +
    ''#13#10 +
    'begin'#13#10 +
    '  TRickUIBuilder'#13#10 +
    '    .Button'#13#10 +
    '      .Caption(''Passe o mouse'')'#13#10 +
    '        .Size(220, 52)'#13#10 +
    '          .FillColor(TAlphaColors.Dodgerblue)'#13#10 +
    '          .BorderColor(TAlphaColors.Gray)'#13#10 +
    '          .BorderThickness(2)'#13#10 +
    '            .HoverFillColor(TAlphaColors.Green)'#13#10 +
    '              .OnHover(MouseEnter, MouseLeave)'#13#10 +
    '                .Build(ResultHost);'#13#10 +
    'end;',
    '// Configura OnClick dentro da própria cadeia Fluent do Button.'#13#10 +
    '// O receptor do evento permanece vivo enquanto a Sample Page estiver aberta.'#13#10 +
    '// Clique no Button da aba Resultado para alterar sua cor.'#13#10 +
    'procedure TButtonFluentRunner.ButtonClick(ASender: TObject);'#13#10 +
    'begin'#13#10 +
    '  TRectangle(ASender).Fill.Color := TAlphaColors.Green;'#13#10 +
    'end;'#13#10 +
    ''#13#10 +
    'begin'#13#10 +
    '  TRickUIBuilder'#13#10 +
    '    .Button'#13#10 +
    '      .Caption(''Clique aqui'')'#13#10 +
    '        .Size(220, 52)'#13#10 +
    '          .OnClick(ButtonClick)'#13#10 +
    '            .Build(ResultHost);'#13#10 +
    'end;',
    '// Usa BuildHandle, alternativa pública de materialização da IRickUIBuilderButton.'#13#10 +
    '// O handle permite acessar o TLabel criado sem assumir seu ownership.'#13#10 +
    'var'#13#10 +
    '  LHandle: IRickUIBuilderButtonHandle;'#13#10 +
    'begin'#13#10 +
    '  LHandle := TRickUIBuilder'#13#10 +
    '    .Button'#13#10 +
    '      .Caption(''Caption original'')'#13#10 +
    '        .Size(220, 52)'#13#10 +
    '          .BuildHandle(ResultHost);'#13#10 +
    ''#13#10 +
    '  LHandle.TextLabel.Text := ''Caption acessado'';'#13#10 +
    'end;',
    '// Exercita toda a configuração pública relevante de IRickUIBuilderButton diretamente.'#13#10 +
    '// O mesmo Runner recebe os eventos e permanece vivo durante a Sample Page.'#13#10 +
    '// Os grupos da cadeia Fluent permanecem visíveis e Build materializa no ResultHost.'#13#10 +
    'procedure TButtonFluentRunner.ButtonClick(ASender: TObject);'#13#10 +
    'begin'#13#10 +
    '  TRectangle(ASender).Fill.Color := TAlphaColors.Green;'#13#10 +
    'end;'#13#10 +
    ''#13#10 +
    'procedure TButtonFluentRunner.MouseEnter(ASender: TObject);'#13#10 +
    'begin'#13#10 +
    '  TRectangle(ASender).Stroke.Thickness := 4;'#13#10 +
    'end;'#13#10 +
    ''#13#10 +
    'procedure TButtonFluentRunner.MouseLeave(ASender: TObject);'#13#10 +
    'begin'#13#10 +
    '  TRectangle(ASender).Stroke.Thickness := 2;'#13#10 +
    'end;'#13#10 +
    ''#13#10 +
    'begin'#13#10 +
    '  TRickUIBuilder'#13#10 +
    '    .Button'#13#10 +
    '      .Caption(''Configuração completa'')'#13#10 +
    '        .Position(18, 20)'#13#10 +
    '        .Size(280, 62)'#13#10 +
    '          .Anchors([TAnchorKind.akLeft, TAnchorKind.akTop])'#13#10 +
    '          .Margin(TRickUIBuilderSpacing.Create(12, 8, 4, 2))'#13#10 +
    '          .Padding(TRickUIBuilderSpacing.Create(8, 4, 6, 2))'#13#10 +
    '            .CornerRadius(14)'#13#10 +
    '            .FillColor(TAlphaColors.Dodgerblue)'#13#10 +
    '            .BorderColor(TAlphaColors.Gray)'#13#10 +
    '            .BorderThickness(2)'#13#10 +
    '              .TextColor(TAlphaColors.White)'#13#10 +
    '              .FontFamily(''Segoe UI'')'#13#10 +
    '              .FontSize(17)'#13#10 +
    '              .Bold(True)'#13#10 +
    '                .HoverFillColor(TAlphaColors.Green)'#13#10 +
    '                .DisabledOpacity(0.45)'#13#10 +
    '                .Enabled(True)'#13#10 +
    '                .Cursor(crHandPoint)'#13#10 +
    '                .Opacity(0.92)'#13#10 +
    '                .Visible(True)'#13#10 +
    '                .Tag(2026)'#13#10 +
    '                  .OnClick(ButtonClick)'#13#10 +
    '                  .OnHover(MouseEnter, MouseLeave)'#13#10 +
    '                    .Build(ResultHost);'#13#10 +
    'end;',
    '// Mantém a configuração completa em IRickUIBuilderButton e usa todas as interfaces públicas do Button.'#13#10 +
    '// O mesmo Runner recebe os eventos e permanece vivo durante a Sample Page.'#13#10 +
    '// BuildHandle fornece Handle e HoverState; o resultado permanece no ResultHost.'#13#10 +
    'procedure TButtonFluentRunner.ButtonClick(ASender: TObject);'#13#10 +
    'begin'#13#10 +
    '  TRectangle(ASender).Fill.Color := TAlphaColors.Green;'#13#10 +
    'end;'#13#10 +
    ''#13#10 +
    'procedure TButtonFluentRunner.MouseEnter(ASender: TObject);'#13#10 +
    'begin'#13#10 +
    '  TRectangle(ASender).Stroke.Thickness := 4;'#13#10 +
    'end;'#13#10 +
    ''#13#10 +
    'procedure TButtonFluentRunner.MouseLeave(ASender: TObject);'#13#10 +
    'begin'#13#10 +
    '  TRectangle(ASender).Stroke.Thickness := 2;'#13#10 +
    'end;'#13#10 +
    ''#13#10 +
    'var'#13#10 +
    '  LButton: IRickUIBuilderButton;'#13#10 +
    '  LHandle: IRickUIBuilderButtonHandle;'#13#10 +
    '  LHoverState: IRickUIBuilderButtonHoverState;'#13#10 +
    'begin'#13#10 +
    '  LButton := TRickUIBuilder.Button;'#13#10 +
    ''#13#10 +
    '  LHandle := LButton'#13#10 +
    '    .Caption(''Completo com interfaces'')'#13#10 +
    '      .Position(18, 20)'#13#10 +
    '      .Size(280, 62)'#13#10 +
    '        .Anchors([TAnchorKind.akLeft, TAnchorKind.akTop])'#13#10 +
    '        .Margin(TRickUIBuilderSpacing.Create(12, 8, 4, 2))'#13#10 +
    '        .Padding(TRickUIBuilderSpacing.Create(8, 4, 6, 2))'#13#10 +
    '          .CornerRadius(14)'#13#10 +
    '          .FillColor(TAlphaColors.Dodgerblue)'#13#10 +
    '          .BorderColor(TAlphaColors.Gray)'#13#10 +
    '          .BorderThickness(2)'#13#10 +
    '            .TextColor(TAlphaColors.White)'#13#10 +
    '            .FontFamily(''Segoe UI'')'#13#10 +
    '            .FontSize(17)'#13#10 +
    '            .Bold(True)'#13#10 +
    '              .HoverFillColor(TAlphaColors.Green)'#13#10 +
    '              .DisabledOpacity(0.45)'#13#10 +
    '              .Enabled(True)'#13#10 +
    '              .Cursor(crHandPoint)'#13#10 +
    '              .Opacity(0.92)'#13#10 +
    '              .Visible(True)'#13#10 +
    '              .Tag(2026)'#13#10 +
    '                .OnClick(ButtonClick)'#13#10 +
    '                .OnHover(MouseEnter, MouseLeave)'#13#10 +
    '                  .BuildHandle(ResultHost);'#13#10 +
    ''#13#10 +
    '  LHandle.TextLabel.Text := ''Interfaces completas'';'#13#10 +
    '  LHoverState := LHandle.HoverState;'#13#10 +
    '  LHoverState'#13#10 +
    '    .FillColor(TAlphaColors.Dodgerblue)'#13#10 +
    '      .HoverFillColor(TAlphaColors.Green)'#13#10 +
    '        .OnEnter(MouseEnter)'#13#10 +
    '        .OnLeave(MouseLeave);'#13#10 +
    'end;');

class function TButtonFluentContent.Caption(
  const AExample: TButtonFluentExample): string;
begin
  Result := _CAPTIONS_[AExample];
end;

class function TButtonFluentContent.Title(
  const AExample: TButtonFluentExample): string;
begin
  Result := _TITLES_[AExample];
end;

class function TButtonFluentContent.Description(
  const AExample: TButtonFluentExample): string;
begin
  Result := _DESCRIPTIONS_[AExample];
end;

class function TButtonFluentContent.Code(
  const AExample: TButtonFluentExample): string;
begin
  Result := _CODES_[AExample];
end;

end.
