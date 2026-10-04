{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Example.Divider.Factory.Content                       }
{                                                                              }
{ Esta unit centraliza o conteúdo textual de Divider - Factory, documentando   }
{ quatro exemplos sincronizados com o Runner e um Completo que atribui         }
{ explicitamente todos os campos públicos de TRickUIBuilderDividerConfig.      }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Centralizar captions, títulos, descrições e snippets Delphi dos exemplos    }
{  Factory de Divider exibidos pela página concreta do Samples.                }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Associa cada TDividerFactoryExample ao conteúdo didático correspondente.    }
{  Os snippets começam com comentários curtos em `//`, apontam a aba Resultado }
{  e demonstram somente a API real de TRickUIBuilderFactory.CreateDivider.     }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - RickUIBuilder.Samples.App.Types                                           }
{      Fornece TDividerFactoryExample compartilhado por page, Content e Runner.}
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - TExampleDividerFactory consulta esta unit ao selecionar um exemplo.       }
{  - TDividerFactoryRunner executa a configuração equivalente no ResultHost.   }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - Contém somente conteúdo de Divider na abordagem Factory.                  }
{  - Não executa Factory, não cria controles e não conhece Fluent Builder.     }
{  - Height fixo, HitTest e Stroke são comportamento da Factory, não opções    }
{    configuráveis de TRickUIBuilderDividerConfig.                             }
{  - O exemplo Completo atribui todos os quatro campos públicos do record.     }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Atualizar esta unit quando a API pública Factory de Divider ou seus         }
{  exemplos mudarem, mantendo snippets e Runner semanticamente sincronizados.  }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.Example.Divider.Factory.Content;

interface

uses
  RickUIBuilder.Samples.App.Types;

type
  /// <summary>Conteúdo textual da página Divider - Factory.</summary>
  TDividerFactoryContent = class sealed
  public
    class function Caption(const AExample: TDividerFactoryExample): string; static;
    class function Title(const AExample: TDividerFactoryExample): string; static;
    class function Description(const AExample: TDividerFactoryExample): string; static;
    class function Code(const AExample: TDividerFactoryExample): string; static;
  end;

implementation

const
  _CAPTIONS_: array[TDividerFactoryExample] of string = (
    'Básico',
    'Geometria',
    'Cor',
    'Completo');

  _TITLES_: array[TDividerFactoryExample] of string = (
    'Criação básica',
    'Posição e largura',
    'Cor do Divider',
    'Configuração completa');

  _DESCRIPTIONS_: array[TDividerFactoryExample] of string = (
    'Cria um Divider horizontal usando TRickUIBuilderDividerConfig.Default.',
    'Configura Left, Top e Width antes da materialização.',
    'Configura Color do Divider criado pela Factory.',
    'Atribui explicitamente todos os campos públicos de TRickUIBuilderDividerConfig.');

  _CODES_: array[TDividerFactoryExample] of string = (
    '// Cria o Divider com os defaults públicos da Factory.'#13#10 +
    '// ResultHost hospeda a linha exibida na aba Resultado.'#13#10 +
    'var'#13#10 +
    '  LConfig: TRickUIBuilderDividerConfig;'#13#10 +
    'begin'#13#10 +
    '  LConfig := TRickUIBuilderDividerConfig.Default;'#13#10 +
    '  TRickUIBuilderFactory.CreateDivider('#13#10 +
    '    ResultHost, ResultHost, LConfig);'#13#10 +
    'end;',

    '// Define posição e largura antes de criar o Divider.'#13#10 +
    '// ResultHost hospeda a linha exibida na aba Resultado.'#13#10 +
    'var'#13#10 +
    '  LConfig: TRickUIBuilderDividerConfig;'#13#10 +
    'begin'#13#10 +
    '  LConfig := TRickUIBuilderDividerConfig.Default;'#13#10 +
    '  LConfig.Left := 24;'#13#10 +
    '  LConfig.Top := 32;'#13#10 +
    '  LConfig.Width := 280;'#13#10 +
    '  TRickUIBuilderFactory.CreateDivider('#13#10 +
    '    ResultHost, ResultHost, LConfig);'#13#10 +
    'end;',

    '// Configura a cor do Divider criado pela Factory.'#13#10 +
    '// ResultHost hospeda a linha exibida na aba Resultado.'#13#10 +
    'var'#13#10 +
    '  LConfig: TRickUIBuilderDividerConfig;'#13#10 +
    'begin'#13#10 +
    '  LConfig := TRickUIBuilderDividerConfig.Default;'#13#10 +
    '  LConfig.Color := TAlphaColors.Dodgerblue;'#13#10 +
    '  TRickUIBuilderFactory.CreateDivider('#13#10 +
    '    ResultHost, ResultHost, LConfig);'#13#10 +
    'end;',

    '// Configura todos os campos públicos de TRickUIBuilderDividerConfig.'#13#10 +
    '// ResultHost hospeda a linha exibida na aba Resultado.'#13#10 +
    'var'#13#10 +
    '  LConfig: TRickUIBuilderDividerConfig;'#13#10 +
    'begin'#13#10 +
    '  LConfig := TRickUIBuilderDividerConfig.Default;'#13#10 +
    '  LConfig.Left := 20;'#13#10 +
    '  LConfig.Top := 28;'#13#10 +
    '  LConfig.Width := 320;'#13#10 +
    '  LConfig.Color := TAlphaColors.Dodgerblue;'#13#10 +
    '  TRickUIBuilderFactory.CreateDivider('#13#10 +
    '    ResultHost, ResultHost, LConfig);'#13#10 +
    'end;');

class function TDividerFactoryContent.Caption(
  const AExample: TDividerFactoryExample): string;
begin
  Result := _CAPTIONS_[AExample];
end;

class function TDividerFactoryContent.Title(
  const AExample: TDividerFactoryExample): string;
begin
  Result := _TITLES_[AExample];
end;

class function TDividerFactoryContent.Description(
  const AExample: TDividerFactoryExample): string;
begin
  Result := _DESCRIPTIONS_[AExample];
end;

class function TDividerFactoryContent.Code(
  const AExample: TDividerFactoryExample): string;
begin
  Result := _CODES_[AExample];
end;

end.
