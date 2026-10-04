{ Esta unit centraliza o conteúdo textual de Button - Factory, documentando oito exemplos sincronizados com o Runner, incluindo clique funcional e um Completo que atribui explicitamente todos os campos públicos de TRickUIBuilderButtonConfig. }
{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Example.Button.Factory.Content                        }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Centralizar captions, títulos, descrições e snippets Delphi dos exemplos    }
{  Factory de Button exibidos pela página concreta do Samples.                 }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Associa cada TButtonFactoryExample ao conteúdo didático correspondente.     }
{  Os snippets começam com comentários curtos em `//`, apontam a aba Resultado }
{  e demonstram somente a API real de TRickUIBuilderFactory.CreateButton.      }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - RickUIBuilder.Samples.App.Types                                           }
{      Fornece TButtonFactoryExample compartilhado por page, conteúdo e Runner.}
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - TExampleButtonFactory consulta esta unit ao selecionar um exemplo.        }
{  - TButtonFactoryRunner executa a configuração equivalente no ResultHost.    }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - Contém somente conteúdo de Button na abordagem Factory.                   }
{  - Não executa Factory, não cria controles e não conhece Fluent Builder.     }
{  - OnClick é demonstrado como evento do TRectangle retornado, não como campo  }
{    de TRickUIBuilderButtonConfig.                                             }
{  - O exemplo Completo atribui todos os nove campos públicos do record.       }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Atualizar esta unit quando a API pública Factory de Button ou seus exemplos }
{  mudarem, mantendo snippets e Runner semanticamente sincronizados.           }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.Example.Button.Factory.Content;

interface

uses
  RickUIBuilder.Samples.App.Types;

type
  /// <summary>Conteúdo textual da página Button - Factory.</summary>
  TButtonFactoryContent = class sealed
  public
    class function Caption(const AExample: TButtonFactoryExample): string; static;
    class function Title(const AExample: TButtonFactoryExample): string; static;
    class function Description(const AExample: TButtonFactoryExample): string; static;
    class function Code(const AExample: TButtonFactoryExample): string; static;
  end;

implementation

const
  _CAPTIONS_: array[TButtonFactoryExample] of string = (
    'Básico',
    'Geometria',
    'Cores',
    'Tipografia',
    'Identificação',
    'Caption interno',
    'Clique',
    'Completo');

  _TITLES_: array[TButtonFactoryExample] of string = (
    'Criação básica',
    'Posição e tamanho',
    'Cores do Button',
    'Tamanho do caption',
    'Identificação por Tag',
    'Acesso ao TLabel interno',
    'Resultado do clique',
    'Configuração completa');

  _DESCRIPTIONS_: array[TButtonFactoryExample] of string = (
    'Cria TRectangle + TLabel usando TRickUIBuilderButtonConfig.Default.',
    'Configura Left, Top, Width e Height antes da materialização.',
    'Configura FillColor, BorderColor e TextColor; a borda Factory usa espessura fixa 2 quando há cor.',
    'Configura FontSize do TLabel usado como caption.',
    'Configura Tag e confirma o valor aplicado por meio do TRectangle retornado.',
    'Usa a sobrecarga com out ATextLabel e altera o caption pela referência non-owning devolvida.',
    'Associa OnClick ao TRectangle retornado; clicar muda a cor do Button na aba Resultado.',
    'Atribui explicitamente todos os campos públicos de TRickUIBuilderButtonConfig.');

  _CODES_: array[TButtonFactoryExample] of string = (
    '// Cria o Button com os defaults públicos da Factory.'#13#10 +
    '// ResultHost hospeda o controle exibido na aba Resultado.'#13#10 +
    'var'#13#10 +
    '  LConfig: TRickUIBuilderButtonConfig;'#13#10 +
    'begin'#13#10 +
    '  LConfig := TRickUIBuilderButtonConfig.Default;'#13#10 +
    '  TRickUIBuilderFactory.CreateButton('#13#10 +
    '    ResultHost, ResultHost, ''Salvar'', LConfig);'#13#10 +
    'end;',

    '// Define posição e tamanho antes de criar o Button.'#13#10 +
    '// ResultHost hospeda o controle exibido na aba Resultado.'#13#10 +
    'var'#13#10 +
    '  LConfig: TRickUIBuilderButtonConfig;'#13#10 +
    'begin'#13#10 +
    '  LConfig := TRickUIBuilderButtonConfig.Default;'#13#10 +
    '  LConfig.Left := 24;'#13#10 +
    '  LConfig.Top := 20;'#13#10 +
    '  LConfig.Width := 210;'#13#10 +
    '  LConfig.Height := 52;'#13#10 +
    '  TRickUIBuilderFactory.CreateButton('#13#10 +
    '    ResultHost, ResultHost, ''Geometria'', LConfig);'#13#10 +
    'end;',

    '// Configura fill, borda e texto antes da materialização.'#13#10 +
    '// ResultHost hospeda o controle exibido na aba Resultado.'#13#10 +
    'var'#13#10 +
    '  LConfig: TRickUIBuilderButtonConfig;'#13#10 +
    'begin'#13#10 +
    '  LConfig := TRickUIBuilderButtonConfig.Default;'#13#10 +
    '  LConfig.FillColor := TAlphaColors.Dodgerblue;'#13#10 +
    '  LConfig.BorderColor := TAlphaColors.Gray;'#13#10 +
    '  LConfig.TextColor := TAlphaColors.White;'#13#10 +
    '  TRickUIBuilderFactory.CreateButton('#13#10 +
    '    ResultHost, ResultHost, ''Cores'', LConfig);'#13#10 +
    'end;',

    '// Ajusta FontSize do TLabel interno usado como caption.'#13#10 +
    '// ResultHost hospeda o controle exibido na aba Resultado.'#13#10 +
    'var'#13#10 +
    '  LConfig: TRickUIBuilderButtonConfig;'#13#10 +
    'begin'#13#10 +
    '  LConfig := TRickUIBuilderButtonConfig.Default;'#13#10 +
    '  LConfig.Width := 200;'#13#10 +
    '  LConfig.Height := 50;'#13#10 +
    '  LConfig.FontSize := 20;'#13#10 +
    '  TRickUIBuilderFactory.CreateButton('#13#10 +
    '    ResultHost, ResultHost, ''Tipografia'', LConfig);'#13#10 +
    'end;',

    '// Configura Tag e lê o valor aplicado no TRectangle retornado.'#13#10 +
    '// O resultado pode ser conferido visualmente na aba Resultado.'#13#10 +
    'var'#13#10 +
    '  LButton: TRectangle;'#13#10 +
    '  LTextLabel: TLabel;'#13#10 +
    '  LConfig: TRickUIBuilderButtonConfig;'#13#10 +
    'begin'#13#10 +
    '  LConfig := TRickUIBuilderButtonConfig.Default;'#13#10 +
    '  LConfig.Tag := 42;'#13#10 +
    '  LButton := TRickUIBuilderFactory.CreateButton('#13#10 +
    '    ResultHost, ResultHost, ''Identificação'', LConfig, LTextLabel);'#13#10 +
    '  LTextLabel.Text := Format(''Tag = %d'', [LButton.Tag]);'#13#10 +
    'end;',

    '// Usa a sobrecarga que devolve o TLabel interno em ATextLabel.'#13#10 +
    '// A alteração do caption aparece imediatamente na aba Resultado.'#13#10 +
    'var'#13#10 +
    '  LTextLabel: TLabel;'#13#10 +
    '  LConfig: TRickUIBuilderButtonConfig;'#13#10 +
    'begin'#13#10 +
    '  LConfig := TRickUIBuilderButtonConfig.Default;'#13#10 +
    '  TRickUIBuilderFactory.CreateButton('#13#10 +
    '    ResultHost, ResultHost, ''Caption original'', LConfig, LTextLabel);'#13#10 +
    '  LTextLabel.Text := ''Caption acessado'';'#13#10 +
    'end;',

    '// Associa OnClick ao TRectangle retornado pela Factory.'#13#10 +
    '// Clique no Button da aba Resultado para ver a mudança de cor.'#13#10 +
    'type'#13#10 +
    '  TButtonFactoryClickFeedback = class(TComponent)'#13#10 +
    '  public'#13#10 +
    '    procedure ButtonClick(ASender: TObject);'#13#10 +
    '  end;'#13#10 +
    #13#10 +
    'procedure TButtonFactoryClickFeedback.ButtonClick(ASender: TObject);'#13#10 +
    'begin'#13#10 +
    '  TRectangle(ASender).Fill.Color := TAlphaColors.Green;'#13#10 +
    'end;'#13#10 +
    #13#10 +
    'var'#13#10 +
    '  LButton: TRectangle;'#13#10 +
    '  LFeedback: TButtonFactoryClickFeedback;'#13#10 +
    '  LConfig: TRickUIBuilderButtonConfig;'#13#10 +
    'begin'#13#10 +
    '  LConfig := TRickUIBuilderButtonConfig.Default;'#13#10 +
    '  LButton := TRickUIBuilderFactory.CreateButton('#13#10 +
    '    ResultHost, ResultHost, ''Clique aqui'', LConfig);'#13#10 +
    '  LFeedback := TButtonFactoryClickFeedback.Create(LButton);'#13#10 +
    '  LButton.OnClick := LFeedback.ButtonClick;'#13#10 +
    'end;',

    '// Configura todos os campos públicos do record ButtonConfig.'#13#10 +
    '// ResultHost hospeda o controle exibido na aba Resultado.'#13#10 +
    'var'#13#10 +
    '  LTextLabel: TLabel;'#13#10 +
    '  LConfig: TRickUIBuilderButtonConfig;'#13#10 +
    'begin'#13#10 +
    '  LConfig := TRickUIBuilderButtonConfig.Default;'#13#10 +
    '  LConfig.Left := 18;'#13#10 +
    '  LConfig.Top := 20;'#13#10 +
    '  LConfig.Width := 240;'#13#10 +
    '  LConfig.Height := 54;'#13#10 +
    '  LConfig.FillColor := TAlphaColors.Dodgerblue;'#13#10 +
    '  LConfig.BorderColor := TAlphaColors.Gray;'#13#10 +
    '  LConfig.TextColor := TAlphaColors.White;'#13#10 +
    '  LConfig.Tag := 2026;'#13#10 +
    '  LConfig.FontSize := 17;'#13#10 +
    '  TRickUIBuilderFactory.CreateButton('#13#10 +
    '    ResultHost, ResultHost, ''Configuração completa'', LConfig, LTextLabel);'#13#10 +
    'end;');

class function TButtonFactoryContent.Caption(
  const AExample: TButtonFactoryExample): string;
begin
  Result := _CAPTIONS_[AExample];
end;

class function TButtonFactoryContent.Title(
  const AExample: TButtonFactoryExample): string;
begin
  Result := _TITLES_[AExample];
end;

class function TButtonFactoryContent.Description(
  const AExample: TButtonFactoryExample): string;
begin
  Result := _DESCRIPTIONS_[AExample];
end;

class function TButtonFactoryContent.Code(
  const AExample: TButtonFactoryExample): string;
begin
  Result := _CODES_[AExample];
end;

end.
