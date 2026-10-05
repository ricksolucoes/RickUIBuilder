{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Example.ComboBox.Factory.Content                      }
{                                                                              }
{ Esta unit centraliza o conteúdo textual de ComboBox - Factory, documentando  }
{ sete exemplos comprováveis e a limitação atual: CreateComboBox materializa   }
{ somente o controle fechado, sem lista/popup/seleção.                         }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Centralizar captions, títulos, descrições e snippets Delphi dos exemplos    }
{  Factory de ComboBox exibidos pela página concreta do Samples.               }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Os seis exemplos focados demonstram somente efeitos executados pela Factory }
{  atual. O Completo explicita os 58 campos públicos do config, distinguindo   }
{  os 24 consumidos pelo controle fechado dos campos reservados ao runtime.    }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - RickUIBuilder.Samples.App.Types                                           }
{      Fornece TComboBoxFactoryExample compartilhado por page, Content e       }
{      Runner.                                                                 }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - TExampleComboBoxFactory consulta esta unit ao selecionar um exemplo.      }
{  - TComboBoxFactoryRunner executa a configuração equivalente no ResultHost.  }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - Não executa Factory, não cria controles e não conhece o Fluent Builder.   }
{  - Não apresenta Items, popup, seleção ou pesquisa como recursos Factory.    }
{  - Campos de runtime aparecem somente no Completo por exaustividade do       }
{    record e são identificados como não consumidos por CreateComboBox.        }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Atualizar esta unit quando a API Factory real mudar, mantendo snippets e    }
{  Runner semanticamente sincronizados.                                        }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.Example.ComboBox.Factory.Content;

interface

uses
  RickUIBuilder.Samples.App.Types;

type
  /// <summary>Conteúdo textual da página ComboBox - Factory.</summary>
  TComboBoxFactoryContent = class sealed
  public
    class function Caption(const AExample: TComboBoxFactoryExample): string; static;
    class function Title(const AExample: TComboBoxFactoryExample): string; static;
    class function Description(const AExample: TComboBoxFactoryExample): string; static;
    class function Code(const AExample: TComboBoxFactoryExample): string; static;
  end;

implementation

const
  _CAPTIONS_: array[TComboBoxFactoryExample] of string = (
    'Básico',
    'Geometria e forma',
    'Tipografia e texto',
    'Cores',
    'Seta',
    'Estado',
    'Completo');

  _TITLES_: array[TComboBoxFactoryExample] of string = (
    'Controle fechado básico',
    'Geometria e forma',
    'Tipografia e texto',
    'Cores do controle fechado',
    'Posição, margens e path da seta',
    'Estado desabilitado',
    'Configuração pública completa');

  _DESCRIPTIONS_: array[TComboBoxFactoryExample] of string = (
    'Cria o TRectangle fechado e usa os retornos TLabel/TPath. A Factory atual não materializa lista.',
    'Demonstra Left, Top, Width, Height, CornerRadius e HorizontalPadding aplicados pela Factory.',
    'Demonstra FontSize, FontFamily, FontStyle, TextAlign e Trimming; a família depende da fonte instalada.',
    'Demonstra BackgroundColor, BorderColor, TextColor e ArrowColor no controle fechado.',
    'Demonstra ArrowSize, quatro margens, ArrowPosition e ClosedArrowPath, todos consumidos pela Factory.',
    'Demonstra Enabled=False e DisabledOpacity aplicados ao TRectangle principal.',
    'Atribui 58/58 campos públicos do config. CreateComboBox usa diretamente 24 deles; os demais pertencem ao runtime e não são apresentados como efeito Factory.');

  _CODES_: array[TComboBoxFactoryExample] of string = (
    '// Cria o controle fechado com os defaults públicos da Factory.'#13#10 +
    '// ResultHost recebe o TRectangle; TLabel e TPath são retornados por out.'#13#10 +
    'var'#13#10 +
    '  LTextLabel: TLabel;'#13#10 +
    '  LArrow: TPath;'#13#10 +
    '  LConfig: TRickUIBuilderComboBoxConfig;'#13#10 +
    'begin'#13#10 +
    '  LConfig := TRickUIBuilderComboBoxConfig.Default;'#13#10 +
    '  TRickUIBuilderFactory.CreateComboBox(ResultHost, ResultHost, LConfig,'#13#10 +
    '    LTextLabel, LArrow);'#13#10 +
    '  LTextLabel.Text := ''Selecione...'';'#13#10 +
    'end;',

    '// Configura posição, tamanho, raio e espaço interno do controle fechado.'#13#10 +
    '// ResultHost exibe o resultado materializado pela Factory.'#13#10 +
    'var'#13#10 +
    '  LTextLabel: TLabel;'#13#10 +
    '  LArrow: TPath;'#13#10 +
    '  LConfig: TRickUIBuilderComboBoxConfig;'#13#10 +
    'begin'#13#10 +
    '  LConfig := TRickUIBuilderComboBoxConfig.Default;'#13#10 +
    '  LConfig.Left := 20;'#13#10 +
    '  LConfig.Top := 20;'#13#10 +
    '  LConfig.Width := 280;'#13#10 +
    '  LConfig.Height := 44;'#13#10 +
    '  LConfig.CornerRadius := 10;'#13#10 +
    '  LConfig.HorizontalPadding := 16;'#13#10 +
    '  TRickUIBuilderFactory.CreateComboBox(ResultHost, ResultHost, LConfig,'#13#10 +
    '    LTextLabel, LArrow);'#13#10 +
    '  LTextLabel.Text := ''Geometria e forma'';'#13#10 +
    'end;',

    '// Configura fonte, estilo, alinhamento e trimming do TLabel interno.'#13#10 +
    '// ResultHost exibe o texto aplicado ao controle fechado.'#13#10 +
    'var'#13#10 +
    '  LTextLabel: TLabel;'#13#10 +
    '  LArrow: TPath;'#13#10 +
    '  LConfig: TRickUIBuilderComboBoxConfig;'#13#10 +
    'begin'#13#10 +
    '  LConfig := TRickUIBuilderComboBoxConfig.Default;'#13#10 +
    '  LConfig.Width := 250;'#13#10 +
    '  LConfig.FontSize := 16;'#13#10 +
    '  LConfig.FontFamily := ''Arial'';'#13#10 +
    '  LConfig.FontStyle := [TFontStyle.fsBold];'#13#10 +
    '  LConfig.TextAlign := TTextAlign.Center;'#13#10 +
    '  LConfig.Trimming := TTextTrimming.Character;'#13#10 +
    '  TRickUIBuilderFactory.CreateComboBox(ResultHost, ResultHost, LConfig,'#13#10 +
    '    LTextLabel, LArrow);'#13#10 +
    '  LTextLabel.Text := ''Texto longo para demonstrar alinhamento e trimming'';'#13#10 +
    'end;',

    '// Configura as quatro cores efetivamente usadas pelo controle fechado.'#13#10 +
    '// ResultHost exibe fundo, borda, texto e seta com as cores escolhidas.'#13#10 +
    'var'#13#10 +
    '  LTextLabel: TLabel;'#13#10 +
    '  LArrow: TPath;'#13#10 +
    '  LConfig: TRickUIBuilderComboBoxConfig;'#13#10 +
    'begin'#13#10 +
    '  LConfig := TRickUIBuilderComboBoxConfig.Default;'#13#10 +
    '  LConfig.BackgroundColor := TAlphaColors.Dodgerblue;'#13#10 +
    '  LConfig.BorderColor := TAlphaColors.Gray;'#13#10 +
    '  LConfig.TextColor := TAlphaColors.White;'#13#10 +
    '  LConfig.ArrowColor := TAlphaColors.White;'#13#10 +
    '  TRickUIBuilderFactory.CreateComboBox(ResultHost, ResultHost, LConfig,'#13#10 +
    '    LTextLabel, LArrow);'#13#10 +
    '  LTextLabel.Text := ''Cores'';'#13#10 +
    'end;',

    '// Move a seta para a esquerda e configura tamanho, margens e path fechado.'#13#10 +
    '// ResultHost permite observar também a área reservada ao texto.'#13#10 +
    'var'#13#10 +
    '  LTextLabel: TLabel;'#13#10 +
    '  LArrow: TPath;'#13#10 +
    '  LConfig: TRickUIBuilderComboBoxConfig;'#13#10 +
    'begin'#13#10 +
    '  LConfig := TRickUIBuilderComboBoxConfig.Default;'#13#10 +
    '  LConfig.Width := 280;'#13#10 +
    '  LConfig.ArrowSize := 18;'#13#10 +
    '  LConfig.ArrowMarginLeft := 14;'#13#10 +
    '  LConfig.ArrowMarginTop := 4;'#13#10 +
    '  LConfig.ArrowMarginRight := 10;'#13#10 +
    '  LConfig.ArrowMarginBottom := 4;'#13#10 +
    '  LConfig.ArrowPosition := TRickUIBuilderComboBoxArrowPosition.Left;'#13#10 +
    '  LConfig.ClosedArrowPath := RICK_COMBOBOX_ARROW_UP_PATH;'#13#10 +
    '  TRickUIBuilderFactory.CreateComboBox(ResultHost, ResultHost, LConfig,'#13#10 +
    '    LTextLabel, LArrow);'#13#10 +
    '  LTextLabel.Text := ''Seta à esquerda'';'#13#10 +
    'end;',

    '// Desabilita o controle e aplica a opacidade usada nesse estado.'#13#10 +
    '// ResultHost exibe o efeito de Enabled=False no controle fechado.'#13#10 +
    'var'#13#10 +
    '  LTextLabel: TLabel;'#13#10 +
    '  LArrow: TPath;'#13#10 +
    '  LConfig: TRickUIBuilderComboBoxConfig;'#13#10 +
    'begin'#13#10 +
    '  LConfig := TRickUIBuilderComboBoxConfig.Default;'#13#10 +
    '  LConfig.Enabled := False;'#13#10 +
    '  LConfig.DisabledOpacity := 0.45;'#13#10 +
    '  TRickUIBuilderFactory.CreateComboBox(ResultHost, ResultHost, LConfig,'#13#10 +
    '    LTextLabel, LArrow);'#13#10 +
    '  LTextLabel.Text := ''Desabilitado'';'#13#10 +
    'end;',

    '// Configura os 58 campos públicos do record, como referência exaustiva.'#13#10 +
    '// CreateComboBox usa o subconjunto do controle fechado; ResultHost mostra esse resultado.'#13#10 +
    'var'#13#10 +
    '  LTextLabel: TLabel;'#13#10 +
    '  LArrow: TPath;'#13#10 +
    '  LConfig: TRickUIBuilderComboBoxConfig;'#13#10 +
    'procedure ConfigureCompleteGeometry(var AConfig: TRickUIBuilderComboBoxConfig);'#13#10 +
    'begin'#13#10 +
    '  AConfig.Left := 18;'#13#10 +
    '  AConfig.Top := 20;'#13#10 +
    '  AConfig.Width := 320;'#13#10 +
    '  AConfig.Height := 44;'#13#10 +
    '  AConfig.ItemHeight := 40;'#13#10 +
    '  AConfig.PopupWidth := 340;'#13#10 +
    '  AConfig.PopupWidthOffset := 12;'#13#10 +
    '  AConfig.PopupMaxHeight := 280;'#13#10 +
    '  AConfig.CornerRadius := 10;'#13#10 +
    '  AConfig.HorizontalPadding := 16;'#13#10 +
    'end;'#13#10 +
    ''#13#10 +
    'procedure ConfigureCompleteArrowTypography(var AConfig: TRickUIBuilderComboBoxConfig);'#13#10 +
    'begin'#13#10 +
    '  AConfig.ArrowSize := 18;'#13#10 +
    '  AConfig.ArrowMarginLeft := 10;'#13#10 +
    '  AConfig.ArrowMarginTop := 4;'#13#10 +
    '  AConfig.ArrowMarginRight := 14;'#13#10 +
    '  AConfig.ArrowMarginBottom := 4;'#13#10 +
    '  AConfig.ArrowPosition := TRickUIBuilderComboBoxArrowPosition.Right;'#13#10 +
    '  AConfig.FontSize := 15;'#13#10 +
    '  AConfig.FontFamily := ''Arial'';'#13#10 +
    '  AConfig.FontStyle := [TFontStyle.fsBold];'#13#10 +
    '  AConfig.TextAlign := TTextAlign.Center;'#13#10 +
    '  AConfig.Trimming := TTextTrimming.Character;'#13#10 +
    'end;'#13#10 +
    ''#13#10 +
    'procedure ConfigureCompleteColors(var AConfig: TRickUIBuilderComboBoxConfig);'#13#10 +
    'begin'#13#10 +
    '  AConfig.BackgroundColor := TAlphaColors.Dodgerblue;'#13#10 +
    '  AConfig.EditBackgroundColor := $FFF7F7F7;'#13#10 +
    '  AConfig.BorderColor := TAlphaColors.Gray;'#13#10 +
    '  AConfig.TextColor := TAlphaColors.White;'#13#10 +
    '  AConfig.PlaceholderColor := $FFD0D5DD;'#13#10 +
    '  AConfig.ArrowColor := TAlphaColors.White;'#13#10 +
    '  AConfig.PopupColor := TAlphaColors.White;'#13#10 +
    '  AConfig.HoverColor := $FFF2F4F7;'#13#10 +
    '  AConfig.SelectedColor := $FFEFF8FF;'#13#10 +
    '  AConfig.FocusColor := $FF2E90FA;'#13#10 +
    '  AConfig.DisabledOpacity := 0.50;'#13#10 +
    '  AConfig.SearchTimeout := 750;'#13#10 +
    'end;'#13#10 +
    ''#13#10 +
    'procedure ConfigureCompleteFullWindowGeometry(var AConfig: TRickUIBuilderComboBoxConfig);'#13#10 +
    'begin'#13#10 +
    '  AConfig.FullWindowCornerRadius := 24;'#13#10 +
    '  AConfig.FullWindowPadding := 16;'#13#10 +
    '  AConfig.SearchHeaderHeight := 84;'#13#10 +
    '  AConfig.SearchFieldHeight := 52;'#13#10 +
    '  AConfig.SearchFieldCornerRadius := 14;'#13#10 +
    '  AConfig.SearchIconSize := 22;'#13#10 +
    '  AConfig.NoResultsIconSize := 60;'#13#10 +
    'end;'#13#10 +
    ''#13#10 +
    'procedure ConfigureCompleteFullWindowColors(var AConfig: TRickUIBuilderComboBoxConfig);'#13#10 +
    'begin'#13#10 +
    '  AConfig.FullWindowBackgroundColor := TAlphaColors.White;'#13#10 +
    '  AConfig.SearchFieldBackgroundColor := TAlphaColors.White;'#13#10 +
    '  AConfig.SearchFieldBorderColor := $FF98A2B3;'#13#10 +
    '  AConfig.SearchTextColor := $FF1D2939;'#13#10 +
    '  AConfig.SearchIconColor := $FF1D2939;'#13#10 +
    '  AConfig.NoResultsTextColor := $FF667085;'#13#10 +
    '  AConfig.NoResultsIconColor := $FF98A2B3;'#13#10 +
    'end;'#13#10 +
    ''#13#10 +
    'procedure ConfigureCompleteContentBehavior(var AConfig: TRickUIBuilderComboBoxConfig);'#13#10 +
    'begin'#13#10 +
    '  AConfig.SearchPlaceholder := ''Pesquisar item...'';'#13#10 +
    '  AConfig.NoResultsText := ''Nenhum item encontrado'';'#13#10 +
    '  AConfig.BackPath := RICK_COMBOBOX_BACK_PATH;'#13#10 +
    '  AConfig.ClearPath := RICK_COMBOBOX_CLEAR_PATH;'#13#10 +
    '  AConfig.NoResultsPath := RICK_COMBOBOX_NO_RESULTS_PATH;'#13#10 +
    '  AConfig.Enabled := True;'#13#10 +
    '  AConfig.RequestedStyleType := TRickUIBuilderComboBoxStyleType.Adaptive;'#13#10 +
    '  AConfig.EffectiveStyleType := TRickUIBuilderComboBoxStyleType.Desktop;'#13#10 +
    '  AConfig.PresentationMode := TRickUIBuilderComboBoxPresentationMode.Auto;'#13#10 +
    '  AConfig.ClosedArrowPath := RICK_COMBOBOX_ARROW_DOWN_PATH;'#13#10 +
    '  AConfig.OpenedArrowPath := RICK_COMBOBOX_ARROW_UP_PATH;'#13#10 +
    'end;'#13#10 +
    ''#13#10 +
    'begin'#13#10 +
    '  LConfig := TRickUIBuilderComboBoxConfig.Default;'#13#10 +
    '  ConfigureCompleteGeometry(LConfig);'#13#10 +
    '  ConfigureCompleteArrowTypography(LConfig);'#13#10 +
    '  ConfigureCompleteColors(LConfig);'#13#10 +
    '  ConfigureCompleteFullWindowGeometry(LConfig);'#13#10 +
    '  ConfigureCompleteFullWindowColors(LConfig);'#13#10 +
    '  ConfigureCompleteContentBehavior(LConfig);'#13#10 +
    '  TRickUIBuilderFactory.CreateComboBox(ResultHost, ResultHost, LConfig,'#13#10 +
    '    LTextLabel, LArrow);'#13#10 +
    '  LTextLabel.Text := ''Configuração completa'';'#13#10 +
    'end;');

class function TComboBoxFactoryContent.Caption(
  const AExample: TComboBoxFactoryExample): string;
begin
  Result := _CAPTIONS_[AExample];
end;

class function TComboBoxFactoryContent.Title(
  const AExample: TComboBoxFactoryExample): string;
begin
  Result := _TITLES_[AExample];
end;

class function TComboBoxFactoryContent.Description(
  const AExample: TComboBoxFactoryExample): string;
begin
  Result := _DESCRIPTIONS_[AExample];
end;

class function TComboBoxFactoryContent.Code(
  const AExample: TComboBoxFactoryExample): string;
begin
  Result := _CODES_[AExample];
end;

end.
