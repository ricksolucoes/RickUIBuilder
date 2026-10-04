{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Example.Badge.Factory.Content                         }
{                                                                              }
{ Esta unit centraliza o conteúdo textual de Badge - Factory, documentando     }
{ sete exemplos sincronizados com o Runner e um Completo que atribui           }
{ explicitamente todos os campos públicos de TRickUIBuilderBadgeConfig.        }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Centralizar captions, títulos, descrições e snippets Delphi dos exemplos    }
{  Factory de Badge exibidos pela página concreta do Samples.                  }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Associa cada TBadgeFactoryExample ao conteúdo didático correspondente.      }
{  Os snippets começam com comentários curtos em `//`, apontam a aba Resultado }
{  e demonstram somente APIs públicas reais usadas pela Factory de Badge.      }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - RickUIBuilder.Samples.App.Types                                           }
{      Fornece TBadgeFactoryExample compartilhado por page, conteúdo e Runner. }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - TExampleBadgeFactory consulta esta unit ao selecionar um exemplo.         }
{  - TBadgeFactoryRunner executa a configuração equivalente no ResultHost.     }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - Contém somente conteúdo de Badge na abordagem Factory.                    }
{  - Não executa Factory, não cria controles e não conhece Fluent Builder.     }
{  - CreateBadge é a operação principal; APIs auxiliares aparecem somente no   }
{    exemplo Construção em etapas.                                             }
{  - O exemplo Completo atribui todos os sete campos públicos do record.       }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Atualizar esta unit quando a API pública Factory de Badge ou seus exemplos  }
{  mudarem, mantendo snippets e Runner semanticamente sincronizados.           }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.Example.Badge.Factory.Content;

interface

uses
  RickUIBuilder.Samples.App.Types;

type
  /// <summary>Conteúdo textual da página Badge - Factory.</summary>
  TBadgeFactoryContent = class sealed
  public
    class function Caption(const AExample: TBadgeFactoryExample): string; static;
    class function Title(const AExample: TBadgeFactoryExample): string; static;
    class function Description(const AExample: TBadgeFactoryExample): string; static;
    class function Code(const AExample: TBadgeFactoryExample): string; static;
  end;

implementation

const
  _CAPTIONS_: array[TBadgeFactoryExample] of string = (
    'Básico',
    'Geometria',
    'Cores',
    'Tipografia',
    'Texto interno',
    'Construção em etapas',
    'Completo');

  _TITLES_: array[TBadgeFactoryExample] of string = (
    'Criação básica',
    'Posição e tamanho',
    'Cores do Badge',
    'Tamanho do texto',
    'Acesso ao resultado criado',
    'Construção de baixo nível',
    'Configuração completa');

  _DESCRIPTIONS_: array[TBadgeFactoryExample] of string = (
    'Cria TRectangle + TLabel usando TRickUIBuilderBadgeConfig.Default.',
    'Configura Left, Top, Width e Height antes da materialização.',
    'Configura BackgroundColor e TextColor do Badge.',
    'Configura FontSize do TLabel interno criado pela Factory.',
    'Usa o TRectangle retornado e o out ATextLabel disponibilizados por CreateBadge.',
    'Demonstra CreateBadgeContainer e BuildBadgeTextConfig, usados internamente por CreateBadge.',
    'Atribui explicitamente todos os campos públicos de TRickUIBuilderBadgeConfig.');

  _CODES_: array[TBadgeFactoryExample] of string = (
    '// Cria o Badge com os defaults públicos da Factory.'#13#10 +
    '// ResultHost hospeda o controle exibido na aba Resultado.'#13#10 +
    'var'#13#10 +
    '  LTextLabel: TLabel;'#13#10 +
    '  LConfig: TRickUIBuilderBadgeConfig;'#13#10 +
    'begin'#13#10 +
    '  LConfig := TRickUIBuilderBadgeConfig.Default;'#13#10 +
    '  TRickUIBuilderFactory.CreateBadge('#13#10 +
    '    ResultHost, ResultHost, ''Novo'', LConfig, LTextLabel);'#13#10 +
    'end;',

    '// Define posição e tamanho antes de criar o Badge.'#13#10 +
    '// ResultHost hospeda o controle exibido na aba Resultado.'#13#10 +
    'var'#13#10 +
    '  LTextLabel: TLabel;'#13#10 +
    '  LConfig: TRickUIBuilderBadgeConfig;'#13#10 +
    'begin'#13#10 +
    '  LConfig := TRickUIBuilderBadgeConfig.Default;'#13#10 +
    '  LConfig.Left := 24;'#13#10 +
    '  LConfig.Top := 20;'#13#10 +
    '  LConfig.Width := 160;'#13#10 +
    '  LConfig.Height := 36;'#13#10 +
    '  TRickUIBuilderFactory.CreateBadge('#13#10 +
    '    ResultHost, ResultHost, ''Geometria'', LConfig, LTextLabel);'#13#10 +
    'end;',

    '// Configura as cores de fundo e texto do Badge.'#13#10 +
    '// ResultHost hospeda o controle exibido na aba Resultado.'#13#10 +
    'var'#13#10 +
    '  LTextLabel: TLabel;'#13#10 +
    '  LConfig: TRickUIBuilderBadgeConfig;'#13#10 +
    'begin'#13#10 +
    '  LConfig := TRickUIBuilderBadgeConfig.Default;'#13#10 +
    '  LConfig.BackgroundColor := TAlphaColors.Dodgerblue;'#13#10 +
    '  LConfig.TextColor := TAlphaColors.White;'#13#10 +
    '  TRickUIBuilderFactory.CreateBadge('#13#10 +
    '    ResultHost, ResultHost, ''Cores'', LConfig, LTextLabel);'#13#10 +
    'end;',

    '// Ajusta FontSize do TLabel interno criado para o Badge.'#13#10 +
    '// ResultHost hospeda o controle exibido na aba Resultado.'#13#10 +
    'var'#13#10 +
    '  LTextLabel: TLabel;'#13#10 +
    '  LConfig: TRickUIBuilderBadgeConfig;'#13#10 +
    'begin'#13#10 +
    '  LConfig := TRickUIBuilderBadgeConfig.Default;'#13#10 +
    '  LConfig.Width := 160;'#13#10 +
    '  LConfig.Height := 36;'#13#10 +
    '  LConfig.FontSize := 16;'#13#10 +
    '  TRickUIBuilderFactory.CreateBadge('#13#10 +
    '    ResultHost, ResultHost, ''Tipografia'', LConfig, LTextLabel);'#13#10 +
    'end;',

    '// Usa o retorno e o out ATextLabel fornecidos por CreateBadge.'#13#10 +
    '// O texto atualizado pode ser conferido na aba Resultado.'#13#10 +
    'var'#13#10 +
    '  LBadge: TRectangle;'#13#10 +
    '  LTextLabel: TLabel;'#13#10 +
    '  LConfig: TRickUIBuilderBadgeConfig;'#13#10 +
    'begin'#13#10 +
    '  LConfig := TRickUIBuilderBadgeConfig.Default;'#13#10 +
    '  LBadge := TRickUIBuilderFactory.CreateBadge('#13#10 +
    '    ResultHost, ResultHost, ''Original'', LConfig, LTextLabel);'#13#10 +
    '  LTextLabel.Text := Format(''Largura: %.0f'', [LBadge.Width]);'#13#10 +
    'end;',

    '// Monta container e configuração de texto pelas APIs auxiliares.'#13#10 +
    '// O Badge composto pode ser conferido na aba Resultado.'#13#10 +
    'var'#13#10 +
    '  LContainer: TRectangle;'#13#10 +
    '  LBadgeConfig: TRickUIBuilderBadgeConfig;'#13#10 +
    '  LTextConfig: TRickUIBuilderTextConfig;'#13#10 +
    'begin'#13#10 +
    '  LBadgeConfig := TRickUIBuilderBadgeConfig.Default;'#13#10 +
    '  LBadgeConfig.Width := 180;'#13#10 +
    '  LBadgeConfig.Height := 34;'#13#10 +
    '  LBadgeConfig.BackgroundColor := TAlphaColors.Green;'#13#10 +
    '  LBadgeConfig.TextColor := TAlphaColors.White;'#13#10 +
    '  LBadgeConfig.FontSize := 14;'#13#10 +
    '  LContainer := TRickUIBuilderFactory.CreateBadgeContainer('#13#10 +
    '    ResultHost, ResultHost, LBadgeConfig);'#13#10 +
    '  LTextConfig := TRickUIBuilderFactory.BuildBadgeTextConfig(LBadgeConfig);'#13#10 +
    '  TRickUIBuilderFactory.CreateText('#13#10 +
    '    ResultHost, LContainer, ''Em etapas'', LTextConfig);'#13#10 +
    'end;',

    '// Configura todos os campos públicos de TRickUIBuilderBadgeConfig.'#13#10 +
    '// ResultHost hospeda o controle exibido na aba Resultado.'#13#10 +
    'var'#13#10 +
    '  LTextLabel: TLabel;'#13#10 +
    '  LConfig: TRickUIBuilderBadgeConfig;'#13#10 +
    'begin'#13#10 +
    '  LConfig := TRickUIBuilderBadgeConfig.Default;'#13#10 +
    '  LConfig.Left := 18;'#13#10 +
    '  LConfig.Top := 20;'#13#10 +
    '  LConfig.Width := 190;'#13#10 +
    '  LConfig.Height := 38;'#13#10 +
    '  LConfig.BackgroundColor := TAlphaColors.Dodgerblue;'#13#10 +
    '  LConfig.TextColor := TAlphaColors.White;'#13#10 +
    '  LConfig.FontSize := 15;'#13#10 +
    '  TRickUIBuilderFactory.CreateBadge('#13#10 +
    '    ResultHost, ResultHost, ''Configuração completa'', LConfig, LTextLabel);'#13#10 +
    'end;');

class function TBadgeFactoryContent.Caption(
  const AExample: TBadgeFactoryExample): string;
begin
  Result := _CAPTIONS_[AExample];
end;

class function TBadgeFactoryContent.Title(
  const AExample: TBadgeFactoryExample): string;
begin
  Result := _TITLES_[AExample];
end;

class function TBadgeFactoryContent.Description(
  const AExample: TBadgeFactoryExample): string;
begin
  Result := _DESCRIPTIONS_[AExample];
end;

class function TBadgeFactoryContent.Code(
  const AExample: TBadgeFactoryExample): string;
begin
  Result := _CODES_[AExample];
end;

end.
