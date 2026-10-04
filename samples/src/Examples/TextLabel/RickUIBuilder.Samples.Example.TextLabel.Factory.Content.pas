{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Example.TextLabel.Factory.Content                     }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Centralizar exclusivamente o conteúdo textual dos exemplos Factory de      }
{  Text / Label exibidos pela página concreta do Samples.                      }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Declara os exemplos disponíveis e fornece caption de navegação, título,     }
{  descrição e snippet Delphi correspondente a cada exemplo.                   }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - Não possui dependências internas do projeto.                              }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - TExampleTextLabelFactory consulta esta unit ao selecionar um exemplo.      }
{  - TTextLabelFactoryRunner executa o mesmo exemplo identificado pelo enum.    }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - Contém somente conteúdo de Text / Label na abordagem Factory.             }
{  - Não executa Factory, não cria controles e não conhece outras páginas.     }
{  - Os snippets devem permanecer coerentes com a execução real do Runner.     }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Atualizar esta unit quando a API pública Factory de Text / Label ou seus    }
{  exemplos mudarem, mantendo a cobertura documental sincronizada.             }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.Example.TextLabel.Factory.Content;

interface

{$SCOPEDENUMS ON}

type
  /// <summary>Identifica os exemplos Factory atualmente demonstrados.</summary>
  TTextLabelFactoryExample = (Basic, Geometry, Typography, Alignment, Complete);

  /// <summary>Conteúdo textual da página Text / Label - Factory.</summary>
  TTextLabelFactoryContent = class sealed
  public
    class function Caption(const AExample: TTextLabelFactoryExample): string; static;
    class function Title(const AExample: TTextLabelFactoryExample): string; static;
    class function Description(const AExample: TTextLabelFactoryExample): string; static;
    class function Code(const AExample: TTextLabelFactoryExample): string; static;
  end;

implementation

const
  _CAPTIONS_: array[TTextLabelFactoryExample] of string = (
    'Básico',
    'Geometria',
    'Tipografia',
    'Alinhamento',
    'Completo');

  _TITLES_: array[TTextLabelFactoryExample] of string = (
    'Criação básica',
    'Posição e tamanho',
    'Tipografia',
    'Alinhamento horizontal',
    'Configuração completa');

  _DESCRIPTIONS_: array[TTextLabelFactoryExample] of string = (
    'Cria um TLabel usando os defaults de TRickUIBuilderTextConfig.',
    'Configura Left, Top, Width e Height antes da materialização.',
    'Configura FontSize, FontColor e Bold no record de texto.',
    'Configura HorizontalAlign. TTextAlign exige FMX.Types no uses.',
    'Combina todas as opções públicas de TRickUIBuilderTextConfig.');

  _CODES_: array[TTextLabelFactoryExample] of string = (
    'var'#13#10 +
    '  LConfig: TRickUIBuilderTextConfig;'#13#10 +
    'begin'#13#10 +
    '  LConfig := TRickUIBuilderTextConfig.Default;'#13#10 +
    '  TRickUIBuilderFactory.CreateText('#13#10 +
    '    ResultHost, ResultHost, ''Texto básico'', LConfig);'#13#10 +
    'end;',

    'var'#13#10 +
    '  LConfig: TRickUIBuilderTextConfig;'#13#10 +
    'begin'#13#10 +
    '  LConfig := TRickUIBuilderTextConfig.Default;'#13#10 +
    '  LConfig.Left := 20;'#13#10 +
    '  LConfig.Top := 16;'#13#10 +
    '  LConfig.Width := 220;'#13#10 +
    '  LConfig.Height := 32;'#13#10 +
    '  TRickUIBuilderFactory.CreateText('#13#10 +
    '    ResultHost, ResultHost, ''Posição e tamanho'', LConfig);'#13#10 +
    'end;',

    '// TAlphaColors exige System.UITypes no uses.'#13#10 +
    'var'#13#10 +
    '  LConfig: TRickUIBuilderTextConfig;'#13#10 +
    'begin'#13#10 +
    '  LConfig := TRickUIBuilderTextConfig.Default;'#13#10 +
    '  LConfig.Left := 12;'#13#10 +
    '  LConfig.Top := 12;'#13#10 +
    '  LConfig.Width := 300;'#13#10 +
    '  LConfig.Height := 40;'#13#10 +
    '  LConfig.FontSize := 18;'#13#10 +
    '  LConfig.FontColor := TAlphaColors.Blue;'#13#10 +
    '  LConfig.Bold := True;'#13#10 +
    '  TRickUIBuilderFactory.CreateText('#13#10 +
    '    ResultHost, ResultHost, ''Texto em destaque'', LConfig);'#13#10 +
    'end;',

    '// TTextAlign exige FMX.Types no uses.'#13#10 +
    'var'#13#10 +
    '  LConfig: TRickUIBuilderTextConfig;'#13#10 +
    'begin'#13#10 +
    '  LConfig := TRickUIBuilderTextConfig.Default;'#13#10 +
    '  LConfig.Left := 12;'#13#10 +
    '  LConfig.Top := 16;'#13#10 +
    '  LConfig.Width := 300;'#13#10 +
    '  LConfig.Height := 32;'#13#10 +
    '  LConfig.HorizontalAlign := TTextAlign.Center;'#13#10 +
    '  TRickUIBuilderFactory.CreateText('#13#10 +
    '    ResultHost, ResultHost, ''Texto centralizado'', LConfig);'#13#10 +
    'end;',

    '// TAlphaColors exige System.UITypes e TTextAlign exige FMX.Types.'#13#10 +
    'var'#13#10 +
    '  LConfig: TRickUIBuilderTextConfig;'#13#10 +
    'begin'#13#10 +
    '  LConfig := TRickUIBuilderTextConfig.Default;'#13#10 +
    '  LConfig.Left := 24;'#13#10 +
    '  LConfig.Top := 10;'#13#10 +
    '  LConfig.Width := 320;'#13#10 +
    '  LConfig.Height := 42;'#13#10 +
    '  LConfig.FontSize := 16;'#13#10 +
    '  LConfig.FontColor := TAlphaColors.Green;'#13#10 +
    '  LConfig.HorizontalAlign := TTextAlign.Trailing;'#13#10 +
    '  LConfig.Bold := True;'#13#10 +
    '  TRickUIBuilderFactory.CreateText('#13#10 +
    '    ResultHost, ResultHost, ''Configuração completa'', LConfig);'#13#10 +
    'end;');

class function TTextLabelFactoryContent.Caption(
  const AExample: TTextLabelFactoryExample): string;
begin
  Result := _CAPTIONS_[AExample];
end;

class function TTextLabelFactoryContent.Title(
  const AExample: TTextLabelFactoryExample): string;
begin
  Result := _TITLES_[AExample];
end;

class function TTextLabelFactoryContent.Description(
  const AExample: TTextLabelFactoryExample): string;
begin
  Result := _DESCRIPTIONS_[AExample];
end;

class function TTextLabelFactoryContent.Code(
  const AExample: TTextLabelFactoryExample): string;
begin
  Result := _CODES_[AExample];
end;

end.
