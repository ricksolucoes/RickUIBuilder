{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Example.ComboBox.Factory.Content                      }
{                                                                              }
{ Centraliza captions, títulos, descrições e snippets dos quinze exemplos      }
{ funcionais ComboBox - Factory.                                               }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Fornecer exemplos Delphi completos o suficiente para implementação direta,  }
{  sem depender dos helpers privados utilizados pelo Runner.                   }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Cobre dados, seleção, visual, presentation, callbacks, customização e       }
{  handle. Cada snippet explicita config, options, handle e ordem de criação.   }
{                                                                              }
{  Dependências internas                                                       }
{  ---------------------                                                       }
{  App.Types fornece TComboBoxFactoryExample compartilhado com Page/Runner.    }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  A Page consulta esta unit e o Runner executa comportamento semanticamente   }
{  equivalente no ResultHost.                                                  }
{                                                                              }
{  Restrições                                                                  }
{  ----------                                                                  }
{  Os snippets não podem depender de BasicOptions, TextItems ou outros helpers }
{  internos do Runner que o leitor não vê na aba Código Delphi.                }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Manter arrays na ordem do enum e snippets sincronizados com o Runner.       }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.Example.ComboBox.Factory.Content;

interface

uses
  RickUIBuilder.Samples.App.Types;

type
  TComboBoxFactoryContent = class sealed
  public
    class function Caption(
      const AExample: TComboBoxFactoryExample): string; static;
    class function Title(
      const AExample: TComboBoxFactoryExample): string; static;
    class function Description(
      const AExample: TComboBoxFactoryExample): string; static;
    class function Code(
      const AExample: TComboBoxFactoryExample): string; static;
  end;

implementation

const
  _CAPTIONS_: array[TComboBoxFactoryExample] of string = (
    'Básico',
    'Texto + Value',
    'Lista estruturada',
    'Seleção inicial',
    'Geometria e forma',
    'Tipografia e texto',
    'Cores',
    'Seta',
    'Estado',
    'Desktop / Anchored',
    'FullWindow e pesquisa',
    'Eventos',
    'Customização de item',
    'Handle runtime',
    'Completo');

  _TITLES_: array[TComboBoxFactoryExample] of string = (
    'Lista textual real',
    'DisplayText e Value',
    'Itens estruturados e colunas',
    'Seleção por índice e texto',
    'Geometria e forma',
    'Tipografia e texto',
    'Cores',
    'Seta',
    'Estado desabilitado',
    'Desktop com Anchored',
    'Mobile com FullWindow',
    'Callbacks',
    'OnCustomizeItem',
    'Handle runtime',
    'Referência exaustiva');

  _DESCRIPTIONS_: array[TComboBoxFactoryExample] of string = (
    'Criação completa com Items e Placeholder, sem helpers ocultos.',
    'DisplayText, Value e seleção textual inicial.',
    'Configuração explícita de Fixed, Proportional, Auto e itens estruturados.',
    'Dois controles completos: seleção inicial por Index e por Text.',
    'Geometria configurada sobre um ComboBox funcional.',
    'Tipografia, alinhamento e trimming com itens reais.',
    'Cores do controle fechado, popup, hover e seleção.',
    'Path, posição, tamanho e margens da seta.',
    'Enabled e DisabledOpacity com dados reais.',
    'StyleType Desktop com PresentationMode Anchored.',
    'Mobile + Auto com pesquisa, empty state e lista real.',
    'Handlers OnOpen, OnClose e OnChange com assinatura e lifetime visíveis.',
    'Callback OnCustomizeItem com criação completa do conteúdo adicional da row.',
    'Criação antes do uso do IRickUIBuilderComboBoxHandle e operações públicas.',
    '58/58 campos do config e 14/14 campos de FactoryOptions, sem helpers invisíveis.');

  _CODES_: array[TComboBoxFactoryExample] of string = (
    '// Exemplo completo da API Factory: Básico.'#13#10 +
    '// Confira o controle materializado na aba Resultado.'#13#10 +
    'var'#13#10 +
    '  LConfig: TRickUIBuilderComboBoxConfig;'#13#10 +
    '  LOptions: TRickUIBuilderComboBoxFactoryOptions;'#13#10 +
    '  LHandle: IRickUIBuilderComboBoxHandle;'#13#10 +
    'begin'#13#10 +
    '  LConfig := TRickUIBuilderComboBoxConfig.Default;'#13#10 +
    ''#13#10 +
    '  LOptions := TRickUIBuilderComboBoxFactoryOptions.Default;'#13#10 +
    '  LOptions.Placeholder := ''Escolha um tamanho'';'#13#10 +
    '  LOptions.Items := ['#13#10 +
    '    TRickUIBuilderComboBoxItem.Create(''Pequeno''),'#13#10 +
    '    TRickUIBuilderComboBoxItem.Create(''Médio''),'#13#10 +
    '    TRickUIBuilderComboBoxItem.Create(''Grande''),'#13#10 +
    '    TRickUIBuilderComboBoxItem.Create(''Extra grande'')'#13#10 +
    '  ];'#13#10 +
    ''#13#10 +
    '  TRickUIBuilderFactory.CreateComboBox('#13#10 +
    '    ResultHost, ResultHost, LConfig, LOptions, LHandle);'#13#10 +
    'end;',

    '// Exemplo completo da API Factory: Texto + Value.'#13#10 +
    '// Confira o controle materializado na aba Resultado.'#13#10 +
    'var'#13#10 +
    '  LConfig: TRickUIBuilderComboBoxConfig;'#13#10 +
    '  LOptions: TRickUIBuilderComboBoxFactoryOptions;'#13#10 +
    '  LHandle: IRickUIBuilderComboBoxHandle;'#13#10 +
    'begin'#13#10 +
    '  LConfig := TRickUIBuilderComboBoxConfig.Default;'#13#10 +
    ''#13#10 +
    '  LOptions := TRickUIBuilderComboBoxFactoryOptions.Default;'#13#10 +
    '  LOptions.Placeholder := ''Moeda'';'#13#10 +
    '  LOptions.Items := ['#13#10 +
    '    TRickUIBuilderComboBoxItem.Create(''Real brasileiro'', ''BRL''),'#13#10 +
    '    TRickUIBuilderComboBoxItem.Create(''Dólar americano'', ''USD''),'#13#10 +
    '    TRickUIBuilderComboBoxItem.Create(''Euro'', ''EUR'')'#13#10 +
    '  ];'#13#10 +
    '  LOptions.SelectionMode :='#13#10 +
    '    TRickUIBuilderComboBoxInitialSelectionMode.Text;'#13#10 +
    '  LOptions.SelectedText := ''Real brasileiro'';'#13#10 +
    ''#13#10 +
    '  TRickUIBuilderFactory.CreateComboBox('#13#10 +
    '    ResultHost, ResultHost, LConfig, LOptions, LHandle);'#13#10 +
    'end;',

    '// Exemplo completo da API Factory: Lista estruturada.'#13#10 +
    '// Confira o controle materializado na aba Resultado.'#13#10 +
    'var'#13#10 +
    '  LConfig: TRickUIBuilderComboBoxConfig;'#13#10 +
    '  LOptions: TRickUIBuilderComboBoxFactoryOptions;'#13#10 +
    '  LHandle: IRickUIBuilderComboBoxHandle;'#13#10 +
    '  LCodeColumn: TRickUIBuilderComboBoxColumn;'#13#10 +
    '  LNameColumn: TRickUIBuilderComboBoxColumn;'#13#10 +
    '  LPriceColumn: TRickUIBuilderComboBoxColumn;'#13#10 +
    'begin'#13#10 +
    '  LConfig := TRickUIBuilderComboBoxConfig.Default;'#13#10 +
    '  LConfig.Width := 360;'#13#10 +
    ''#13#10 +
    '  LCodeColumn := TRickUIBuilderComboBoxColumn.Create('#13#10 +
    '    TRickUIBuilderComboBoxColumnSizeMode.Fixed, 72);'#13#10 +
    '  LCodeColumn.Alignment := TTextAlign.Leading;'#13#10 +
    '  LCodeColumn.Visible := True;'#13#10 +
    ''#13#10 +
    '  LNameColumn := TRickUIBuilderComboBoxColumn.Create('#13#10 +
    '    TRickUIBuilderComboBoxColumnSizeMode.Proportional, 1);'#13#10 +
    '  LNameColumn.Alignment := TTextAlign.Leading;'#13#10 +
    '  LNameColumn.Visible := True;'#13#10 +
    ''#13#10 +
    '  LPriceColumn := TRickUIBuilderComboBoxColumn.Create('#13#10 +
    '    TRickUIBuilderComboBoxColumnSizeMode.Auto);'#13#10 +
    '  LPriceColumn.Alignment := TTextAlign.Trailing;'#13#10 +
    '  LPriceColumn.Visible := True;'#13#10 +
    ''#13#10 +
    '  LOptions := TRickUIBuilderComboBoxFactoryOptions.Default;'#13#10 +
    '  LOptions.Placeholder := ''Produto'';'#13#10 +
    '  LOptions.Columns := [LCodeColumn, LNameColumn, LPriceColumn];'#13#10 +
    '  LOptions.Items := ['#13#10 +
    '    TRickUIBuilderComboBoxItem.Structured('#13#10 +
    '      ''Notebook Core i7'', ''NBK'','#13#10 +
    '      [''001'', ''Notebook Core i7'', ''R$ 4.999'']),'#13#10 +
    '    TRickUIBuilderComboBoxItem.Structured('#13#10 +
    '      ''Monitor 27'', ''MON'','#13#10 +
    '      [''002'', ''Monitor 27 polegadas'', ''R$ 1.899''])'#13#10 +
    '  ];'#13#10 +
    ''#13#10 +
    '  TRickUIBuilderFactory.CreateComboBox('#13#10 +
    '    ResultHost, ResultHost, LConfig, LOptions, LHandle);'#13#10 +
    'end;',

    '// Exemplo completo da API Factory: Seleção inicial.'#13#10 +
    '// Confira o controle materializado na aba Resultado.'#13#10 +
    'var'#13#10 +
    '  LConfig: TRickUIBuilderComboBoxConfig;'#13#10 +
    '  LOptions: TRickUIBuilderComboBoxFactoryOptions;'#13#10 +
    '  LHandle: IRickUIBuilderComboBoxHandle;'#13#10 +
    'begin'#13#10 +
    '  LConfig := TRickUIBuilderComboBoxConfig.Default;'#13#10 +
    '  LConfig.Top := 12;'#13#10 +
    '  LOptions := TRickUIBuilderComboBoxFactoryOptions.Default;'#13#10 +
    '  LOptions.Placeholder := ''Pagamento'';'#13#10 +
    '  LOptions.Items := ['#13#10 +
    '    TRickUIBuilderComboBoxItem.Create(''Dinheiro''),'#13#10 +
    '    TRickUIBuilderComboBoxItem.Create(''Cartão''),'#13#10 +
    '    TRickUIBuilderComboBoxItem.Create(''PIX'')'#13#10 +
    '  ];'#13#10 +
    '  LOptions.SelectionMode :='#13#10 +
    '    TRickUIBuilderComboBoxInitialSelectionMode.Index;'#13#10 +
    '  LOptions.ItemIndex := 2;'#13#10 +
    '  TRickUIBuilderFactory.CreateComboBox('#13#10 +
    '    ResultHost, ResultHost, LConfig, LOptions, LHandle);'#13#10 +
    ''#13#10 +
    '  LConfig := TRickUIBuilderComboBoxConfig.Default;'#13#10 +
    '  LConfig.Top := 72;'#13#10 +
    '  LOptions := TRickUIBuilderComboBoxFactoryOptions.Default;'#13#10 +
    '  LOptions.Placeholder := ''Departamento'';'#13#10 +
    '  LOptions.Items := ['#13#10 +
    '    TRickUIBuilderComboBoxItem.Create(''Financeiro''),'#13#10 +
    '    TRickUIBuilderComboBoxItem.Create(''Tecnologia''),'#13#10 +
    '    TRickUIBuilderComboBoxItem.Create(''Operações'')'#13#10 +
    '  ];'#13#10 +
    '  LOptions.SelectionMode :='#13#10 +
    '    TRickUIBuilderComboBoxInitialSelectionMode.Text;'#13#10 +
    '  LOptions.SelectedText := ''Tecnologia'';'#13#10 +
    '  TRickUIBuilderFactory.CreateComboBox('#13#10 +
    '    ResultHost, ResultHost, LConfig, LOptions, LHandle);'#13#10 +
    'end;',

    '// Exemplo completo da API Factory: Geometria e forma.'#13#10 +
    '// Confira o controle materializado na aba Resultado.'#13#10 +
    'var'#13#10 +
    '  LConfig: TRickUIBuilderComboBoxConfig;'#13#10 +
    '  LOptions: TRickUIBuilderComboBoxFactoryOptions;'#13#10 +
    '  LHandle: IRickUIBuilderComboBoxHandle;'#13#10 +
    'begin'#13#10 +
    '  LConfig := TRickUIBuilderComboBoxConfig.Default;'#13#10 +
    '  LConfig.Left := 20;'#13#10 +
    '  LConfig.Top := 20;'#13#10 +
    '  LConfig.Width := 280;'#13#10 +
    '  LConfig.Height := 44;'#13#10 +
    '  LConfig.CornerRadius := 10;'#13#10 +
    '  LConfig.HorizontalPadding := 16;'#13#10 +
    ''#13#10 +
    '  LOptions := TRickUIBuilderComboBoxFactoryOptions.Default;'#13#10 +
    '  LOptions.Placeholder := ''Mês'';'#13#10 +
    '  LOptions.Items := ['#13#10 +
    '    TRickUIBuilderComboBoxItem.Create(''Janeiro''),'#13#10 +
    '    TRickUIBuilderComboBoxItem.Create(''Fevereiro'')'#13#10 +
    '  ];'#13#10 +
    ''#13#10 +
    '  TRickUIBuilderFactory.CreateComboBox('#13#10 +
    '    ResultHost, ResultHost, LConfig, LOptions, LHandle);'#13#10 +
    'end;',

    '// Exemplo completo da API Factory: Tipografia e texto.'#13#10 +
    '// Confira o controle materializado na aba Resultado.'#13#10 +
    'var'#13#10 +
    '  LConfig: TRickUIBuilderComboBoxConfig;'#13#10 +
    '  LOptions: TRickUIBuilderComboBoxFactoryOptions;'#13#10 +
    '  LHandle: IRickUIBuilderComboBoxHandle;'#13#10 +
    'begin'#13#10 +
    '  LConfig := TRickUIBuilderComboBoxConfig.Default;'#13#10 +
    '  LConfig.Width := 300;'#13#10 +
    '  LConfig.FontSize := 16;'#13#10 +
    '  LConfig.FontFamily := ''Arial'';'#13#10 +
    '  LConfig.FontStyle := [TFontStyle.fsBold];'#13#10 +
    '  LConfig.TextAlign := TTextAlign.Center;'#13#10 +
    '  LConfig.Trimming := TTextTrimming.Character;'#13#10 +
    ''#13#10 +
    '  LOptions := TRickUIBuilderComboBoxFactoryOptions.Default;'#13#10 +
    '  LOptions.Placeholder := ''Cliente'';'#13#10 +
    '  LOptions.Items := ['#13#10 +
    '    TRickUIBuilderComboBoxItem.Create('#13#10 +
    '      ''ACME Comércio e Distribuição Ltda.''),'#13#10 +
    '    TRickUIBuilderComboBoxItem.Create('#13#10 +
    '      ''Empresa Brasileira de Tecnologia Aplicada S.A.'')'#13#10 +
    '  ];'#13#10 +
    ''#13#10 +
    '  TRickUIBuilderFactory.CreateComboBox('#13#10 +
    '    ResultHost, ResultHost, LConfig, LOptions, LHandle);'#13#10 +
    'end;',

    '// Exemplo completo da API Factory: Cores.'#13#10 +
    '// Confira o controle materializado na aba Resultado.'#13#10 +
    'var'#13#10 +
    '  LConfig: TRickUIBuilderComboBoxConfig;'#13#10 +
    '  LOptions: TRickUIBuilderComboBoxFactoryOptions;'#13#10 +
    '  LHandle: IRickUIBuilderComboBoxHandle;'#13#10 +
    'begin'#13#10 +
    '  LConfig := TRickUIBuilderComboBoxConfig.Default;'#13#10 +
    '  LConfig.BackgroundColor := TAlphaColors.Dodgerblue;'#13#10 +
    '  LConfig.BorderColor := TAlphaColors.Gray;'#13#10 +
    '  LConfig.TextColor := TAlphaColors.White;'#13#10 +
    '  LConfig.ArrowColor := TAlphaColors.White;'#13#10 +
    '  LConfig.PopupColor := $FF163A5F;'#13#10 +
    '  LConfig.HoverColor := $FF245B8F;'#13#10 +
    '  LConfig.SelectedColor := $FF2F80C9;'#13#10 +
    ''#13#10 +
    '  LOptions := TRickUIBuilderComboBoxFactoryOptions.Default;'#13#10 +
    '  LOptions.Placeholder := ''Cor'';'#13#10 +
    '  LOptions.Items := ['#13#10 +
    '    TRickUIBuilderComboBoxItem.Create(''Azul''),'#13#10 +
    '    TRickUIBuilderComboBoxItem.Create(''Branco''),'#13#10 +
    '    TRickUIBuilderComboBoxItem.Create(''Cinza''),'#13#10 +
    '    TRickUIBuilderComboBoxItem.Create(''Verde'')'#13#10 +
    '  ];'#13#10 +
    '  LOptions.SelectionMode :='#13#10 +
    '    TRickUIBuilderComboBoxInitialSelectionMode.Index;'#13#10 +
    '  LOptions.ItemIndex := 1;'#13#10 +
    ''#13#10 +
    '  TRickUIBuilderFactory.CreateComboBox('#13#10 +
    '    ResultHost, ResultHost, LConfig, LOptions, LHandle);'#13#10 +
    'end;',

    '// Exemplo completo da API Factory: Seta.'#13#10 +
    '// Confira o controle materializado na aba Resultado.'#13#10 +
    'var'#13#10 +
    '  LConfig: TRickUIBuilderComboBoxConfig;'#13#10 +
    '  LOptions: TRickUIBuilderComboBoxFactoryOptions;'#13#10 +
    '  LHandle: IRickUIBuilderComboBoxHandle;'#13#10 +
    'begin'#13#10 +
    '  LConfig := TRickUIBuilderComboBoxConfig.Default;'#13#10 +
    '  LConfig.ArrowSize := 18;'#13#10 +
    '  LConfig.ArrowMarginLeft := 14;'#13#10 +
    '  LConfig.ArrowMarginTop := 4;'#13#10 +
    '  LConfig.ArrowMarginRight := 10;'#13#10 +
    '  LConfig.ArrowMarginBottom := 4;'#13#10 +
    '  LConfig.ArrowPosition :='#13#10 +
    '    TRickUIBuilderComboBoxArrowPosition.Left;'#13#10 +
    '  LConfig.ClosedArrowPath := RICK_COMBOBOX_ARROW_DOWN_PATH;'#13#10 +
    '  LConfig.OpenedArrowPath := RICK_COMBOBOX_ARROW_UP_PATH;'#13#10 +
    ''#13#10 +
    '  LOptions := TRickUIBuilderComboBoxFactoryOptions.Default;'#13#10 +
    '  LOptions.Placeholder := ''Direção'';'#13#10 +
    '  LOptions.Items := ['#13#10 +
    '    TRickUIBuilderComboBoxItem.Create(''Norte''),'#13#10 +
    '    TRickUIBuilderComboBoxItem.Create(''Sul''),'#13#10 +
    '    TRickUIBuilderComboBoxItem.Create(''Leste'')'#13#10 +
    '  ];'#13#10 +
    ''#13#10 +
    '  TRickUIBuilderFactory.CreateComboBox('#13#10 +
    '    ResultHost, ResultHost, LConfig, LOptions, LHandle);'#13#10 +
    'end;',

    '// Exemplo completo da API Factory: Estado.'#13#10 +
    '// Confira o controle materializado na aba Resultado.'#13#10 +
    'var'#13#10 +
    '  LConfig: TRickUIBuilderComboBoxConfig;'#13#10 +
    '  LOptions: TRickUIBuilderComboBoxFactoryOptions;'#13#10 +
    '  LHandle: IRickUIBuilderComboBoxHandle;'#13#10 +
    'begin'#13#10 +
    '  LConfig := TRickUIBuilderComboBoxConfig.Default;'#13#10 +
    '  LConfig.Enabled := False;'#13#10 +
    '  LConfig.DisabledOpacity := 0.45;'#13#10 +
    ''#13#10 +
    '  LOptions := TRickUIBuilderComboBoxFactoryOptions.Default;'#13#10 +
    '  LOptions.Placeholder := ''Plano indisponível'';'#13#10 +
    '  LOptions.Items := ['#13#10 +
    '    TRickUIBuilderComboBoxItem.Create(''Básico''),'#13#10 +
    '    TRickUIBuilderComboBoxItem.Create(''Profissional'')'#13#10 +
    '  ];'#13#10 +
    ''#13#10 +
    '  TRickUIBuilderFactory.CreateComboBox('#13#10 +
    '    ResultHost, ResultHost, LConfig, LOptions, LHandle);'#13#10 +
    'end;',

    '// Exemplo completo da API Factory: Desktop / Anchored.'#13#10 +
    '// Confira o controle materializado na aba Resultado.'#13#10 +
    'var'#13#10 +
    '  LConfig: TRickUIBuilderComboBoxConfig;'#13#10 +
    '  LOptions: TRickUIBuilderComboBoxFactoryOptions;'#13#10 +
    '  LHandle: IRickUIBuilderComboBoxHandle;'#13#10 +
    'begin'#13#10 +
    '  LConfig := TRickUIBuilderComboBoxConfig.Default;'#13#10 +
    '  LConfig.RequestedStyleType :='#13#10 +
    '    TRickUIBuilderComboBoxStyleType.Desktop;'#13#10 +
    '  LConfig.PresentationMode :='#13#10 +
    '    TRickUIBuilderComboBoxPresentationMode.Anchored;'#13#10 +
    ''#13#10 +
    '  LOptions := TRickUIBuilderComboBoxFactoryOptions.Default;'#13#10 +
    '  LOptions.Placeholder := ''Categoria'';'#13#10 +
    '  LOptions.Items := ['#13#10 +
    '    TRickUIBuilderComboBoxItem.Create(''Eletrônicos''),'#13#10 +
    '    TRickUIBuilderComboBoxItem.Create(''Casa''),'#13#10 +
    '    TRickUIBuilderComboBoxItem.Create(''Escritório'')'#13#10 +
    '  ];'#13#10 +
    ''#13#10 +
    '  TRickUIBuilderFactory.CreateComboBox('#13#10 +
    '    ResultHost, ResultHost, LConfig, LOptions, LHandle);'#13#10 +
    'end;',

    '// Exemplo completo da API Factory: FullWindow e pesquisa.'#13#10 +
    '// Confira o controle materializado na aba Resultado.'#13#10 +
    'var'#13#10 +
    '  LConfig: TRickUIBuilderComboBoxConfig;'#13#10 +
    '  LOptions: TRickUIBuilderComboBoxFactoryOptions;'#13#10 +
    '  LHandle: IRickUIBuilderComboBoxHandle;'#13#10 +
    'begin'#13#10 +
    '  LConfig := TRickUIBuilderComboBoxConfig.Default;'#13#10 +
    '  LConfig.RequestedStyleType :='#13#10 +
    '    TRickUIBuilderComboBoxStyleType.Mobile;'#13#10 +
    '  LConfig.PresentationMode :='#13#10 +
    '    TRickUIBuilderComboBoxPresentationMode.Auto;'#13#10 +
    '  LConfig.SearchPlaceholder := ''Pesquisar cidade...'';'#13#10 +
    '  LConfig.NoResultsText := ''Nenhuma cidade encontrada'';'#13#10 +
    ''#13#10 +
    '  LOptions := TRickUIBuilderComboBoxFactoryOptions.Default;'#13#10 +
    '  LOptions.Placeholder := ''Cidade'';'#13#10 +
    '  LOptions.Items := ['#13#10 +
    '    TRickUIBuilderComboBoxItem.Create(''Rio de Janeiro''),'#13#10 +
    '    TRickUIBuilderComboBoxItem.Create(''São Paulo''),'#13#10 +
    '    TRickUIBuilderComboBoxItem.Create(''Curitiba''),'#13#10 +
    '    TRickUIBuilderComboBoxItem.Create(''Belo Horizonte''),'#13#10 +
    '    TRickUIBuilderComboBoxItem.Create(''Recife'')'#13#10 +
    '  ];'#13#10 +
    ''#13#10 +
    '  TRickUIBuilderFactory.CreateComboBox('#13#10 +
    '    ResultHost, ResultHost, LConfig, LOptions, LHandle);'#13#10 +
    'end;',

    '// Exemplo completo da API Factory: Eventos.'#13#10 +
    '// Confira o controle materializado na aba Resultado.'#13#10 +
    '// Declare estes handlers na mesma classe que cria o ComboBox.'#13#10 +
    'procedure TMyForm.ComboOpened(ASender: TObject);'#13#10 +
    'begin'#13#10 +
    '  // Lista aberta.'#13#10 +
    'end;'#13#10 +
    ''#13#10 +
    'procedure TMyForm.ComboClosed(ASender: TObject);'#13#10 +
    'begin'#13#10 +
    '  // Lista fechada.'#13#10 +
    'end;'#13#10 +
    ''#13#10 +
    'procedure TMyForm.ComboChanged(ASender: TObject);'#13#10 +
    'var'#13#10 +
    '  LHandle: IRickUIBuilderComboBoxHandle;'#13#10 +
    'begin'#13#10 +
    '  if Supports(ASender, IRickUIBuilderComboBoxHandle, LHandle) then'#13#10 +
    '    Caption := LHandle.SelectedText + '' / '' + LHandle.SelectedValue;'#13#10 +
    'end;'#13#10 +
    ''#13#10 +
    'var'#13#10 +
    '  LConfig: TRickUIBuilderComboBoxConfig;'#13#10 +
    '  LOptions: TRickUIBuilderComboBoxFactoryOptions;'#13#10 +
    '  LHandle: IRickUIBuilderComboBoxHandle;'#13#10 +
    'begin'#13#10 +
    '  LConfig := TRickUIBuilderComboBoxConfig.Default;'#13#10 +
    ''#13#10 +
    '  LOptions := TRickUIBuilderComboBoxFactoryOptions.Default;'#13#10 +
    '  LOptions.Placeholder := ''Status do processo'';'#13#10 +
    '  LOptions.Items := ['#13#10 +
    '    TRickUIBuilderComboBoxItem.Create(''Pendente'', ''PEN''),'#13#10 +
    '    TRickUIBuilderComboBoxItem.Create(''Aprovado'', ''APR'')'#13#10 +
    '  ];'#13#10 +
    '  LOptions.OnOpen := ComboOpened;'#13#10 +
    '  LOptions.OnClose := ComboClosed;'#13#10 +
    '  LOptions.OnChange := ComboChanged;'#13#10 +
    ''#13#10 +
    '  TRickUIBuilderFactory.CreateComboBox('#13#10 +
    '    ResultHost, ResultHost, LConfig, LOptions, LHandle);'#13#10 +
    'end;',

    '// Exemplo completo da API Factory: Customização de item.'#13#10 +
    '// Confira o controle materializado na aba Resultado.'#13#10 +
    '// O callback deve pertencer a uma instância viva enquanto o ComboBox existir.'#13#10 +
    'procedure TMyForm.CustomizeItem(ASender: TObject; AIndex: Integer;'#13#10 +
    '  const AItem: TRickUIBuilderComboBoxItem; AContainer: TControl);'#13#10 +
    'var'#13#10 +
    '  LBadge: TRectangle;'#13#10 +
    '  LLabel: TLabel;'#13#10 +
    'begin'#13#10 +
    '  LBadge := TRectangle.Create(AContainer);'#13#10 +
    '  LBadge.Parent := AContainer;'#13#10 +
    '  LBadge.Align := TAlignLayout.Right;'#13#10 +
    '  LBadge.Width := 72;'#13#10 +
    '  LBadge.Margins.Right := 8;'#13#10 +
    '  LBadge.Margins.Top := 6;'#13#10 +
    '  LBadge.Margins.Bottom := 6;'#13#10 +
    '  LBadge.Fill.Color := TAlphaColors.Dodgerblue;'#13#10 +
    '  LBadge.Stroke.Kind := TBrushKind.None;'#13#10 +
    '  LBadge.XRadius := 8;'#13#10 +
    '  LBadge.YRadius := 8;'#13#10 +
    '  LBadge.HitTest := False;'#13#10 +
    ''#13#10 +
    '  LLabel := TLabel.Create(LBadge);'#13#10 +
    '  LLabel.Parent := LBadge;'#13#10 +
    '  LLabel.Align := TAlignLayout.Client;'#13#10 +
    '  if SameText(AItem.Value, ''NOVO'') then'#13#10 +
    '    LLabel.Text := ''Novo'''#13#10 +
    '  else'#13#10 +
    '    LLabel.Text := ''Ativo'';'#13#10 +
    '  LLabel.TextSettings.HorzAlign := TTextAlign.Center;'#13#10 +
    '  LLabel.TextSettings.VertAlign := TTextAlign.Center;'#13#10 +
    '  LLabel.TextSettings.FontColor := TAlphaColors.White;'#13#10 +
    '  LLabel.StyledSettings := LLabel.StyledSettings - [TStyledSetting.FontColor];'#13#10 +
    '  LLabel.HitTest := False;'#13#10 +
    'end;'#13#10 +
    ''#13#10 +
    'var'#13#10 +
    '  LConfig: TRickUIBuilderComboBoxConfig;'#13#10 +
    '  LOptions: TRickUIBuilderComboBoxFactoryOptions;'#13#10 +
    '  LHandle: IRickUIBuilderComboBoxHandle;'#13#10 +
    'begin'#13#10 +
    '  LConfig := TRickUIBuilderComboBoxConfig.Default;'#13#10 +
    '  LConfig.RequestedStyleType :='#13#10 +
    '    TRickUIBuilderComboBoxStyleType.Desktop;'#13#10 +
    '  LConfig.PresentationMode :='#13#10 +
    '    TRickUIBuilderComboBoxPresentationMode.Anchored;'#13#10 +
    ''#13#10 +
    '  LOptions := TRickUIBuilderComboBoxFactoryOptions.Default;'#13#10 +
    '  LOptions.Placeholder := ''Projeto'';'#13#10 +
    '  LOptions.Items := ['#13#10 +
    '    TRickUIBuilderComboBoxItem.Create(''Portal do cliente'', ''ATIVO''),'#13#10 +
    '    TRickUIBuilderComboBoxItem.Create(''Aplicativo mobile'', ''NOVO'')'#13#10 +
    '  ];'#13#10 +
    '  LOptions.OnCustomizeItem := CustomizeItem;'#13#10 +
    ''#13#10 +
    '  TRickUIBuilderFactory.CreateComboBox('#13#10 +
    '    ResultHost, ResultHost, LConfig, LOptions, LHandle);'#13#10 +
    'end;',

    '// Exemplo completo da API Factory: Handle runtime.'#13#10 +
    '// Confira o controle materializado na aba Resultado.'#13#10 +
    'var'#13#10 +
    '  LConfig: TRickUIBuilderComboBoxConfig;'#13#10 +
    '  LOptions: TRickUIBuilderComboBoxFactoryOptions;'#13#10 +
    '  LHandle: IRickUIBuilderComboBoxHandle;'#13#10 +
    'begin'#13#10 +
    '  LConfig := TRickUIBuilderComboBoxConfig.Default;'#13#10 +
    '  LConfig.Top := 110;'#13#10 +
    ''#13#10 +
    '  LOptions := TRickUIBuilderComboBoxFactoryOptions.Default;'#13#10 +
    '  LOptions.Placeholder := ''Periférico'';'#13#10 +
    '  LOptions.Items := ['#13#10 +
    '    TRickUIBuilderComboBoxItem.Create(''Impressora'', ''IMP''),'#13#10 +
    '    TRickUIBuilderComboBoxItem.Create(''Scanner'', ''SCN'')'#13#10 +
    '  ];'#13#10 +
    ''#13#10 +
    '  TRickUIBuilderFactory.CreateComboBox('#13#10 +
    '    ResultHost, ResultHost, LConfig, LOptions, LHandle);'#13#10 +
    ''#13#10 +
    '  LHandle.Add(''Leitor biométrico'');'#13#10 +
    '  LHandle.Add(''Mesa digitalizadora'', ''MESA'');'#13#10 +
    '  LHandle.AddRange([''Microfone USB'', ''Webcam 4K'']);'#13#10 +
    '  LHandle.SelectIndex(0);'#13#10 +
    '  LHandle.SelectText(''Mesa digitalizadora'');'#13#10 +
    '  LHandle.SetArrowColor(TAlphaColors.Dodgerblue);'#13#10 +
    '  LHandle.SetArrowSize(18, 12);'#13#10 +
    '  LHandle.SetClosedArrowPath(RICK_COMBOBOX_ARROW_DOWN_PATH);'#13#10 +
    '  LHandle.SetOpenedArrowPath(RICK_COMBOBOX_ARROW_UP_PATH);'#13#10 +
    '  LHandle.Open;'#13#10 +
    '  LHandle.Close;'#13#10 +
    '  LHandle.Open;'#13#10 +
    'end;',

    '// Exemplo completo da API Factory: Completo.'#13#10 +
    '// Confira o controle materializado na aba Resultado.'#13#10 +
    'var'#13#10 +
    '  LConfig: TRickUIBuilderComboBoxConfig;'#13#10 +
    '  LOptions: TRickUIBuilderComboBoxFactoryOptions;'#13#10 +
    '  LHandle: IRickUIBuilderComboBoxHandle;'#13#10 +
    '  LCodeColumn: TRickUIBuilderComboBoxColumn;'#13#10 +
    '  LNameColumn: TRickUIBuilderComboBoxColumn;'#13#10 +
    '  LPriceColumn: TRickUIBuilderComboBoxColumn;'#13#10 +
    'begin'#13#10 +
    '  LConfig := TRickUIBuilderComboBoxConfig.Default;'#13#10 +
    '  LConfig.Left := 16;'#13#10 +
    '  LConfig.Top := 16;'#13#10 +
    '  LConfig.Width := 360;'#13#10 +
    '  LConfig.Height := 44;'#13#10 +
    '  LConfig.ItemHeight := 40;'#13#10 +
    '  LConfig.PopupWidth := 380;'#13#10 +
    '  LConfig.PopupWidthOffset := 12;'#13#10 +
    '  LConfig.PopupMaxHeight := 260;'#13#10 +
    '  LConfig.CornerRadius := 10;'#13#10 +
    '  LConfig.HorizontalPadding := 14;'#13#10 +
    '  LConfig.ArrowSize := 18;'#13#10 +
    '  LConfig.ArrowMarginLeft := 8;'#13#10 +
    '  LConfig.ArrowMarginTop := 4;'#13#10 +
    '  LConfig.ArrowMarginRight := 12;'#13#10 +
    '  LConfig.ArrowMarginBottom := 4;'#13#10 +
    '  LConfig.ArrowPosition := TRickUIBuilderComboBoxArrowPosition.Right;'#13#10 +
    '  LConfig.FontSize := 14;'#13#10 +
    '  LConfig.FontFamily := '''';'#13#10 +
    '  LConfig.FontStyle := [TFontStyle.fsBold];'#13#10 +
    '  LConfig.TextAlign := TTextAlign.Leading;'#13#10 +
    '  LConfig.Trimming := TTextTrimming.Character;'#13#10 +
    '  LConfig.BackgroundColor := TAlphaColors.White;'#13#10 +
    '  LConfig.EditBackgroundColor := TAlphaColors.White;'#13#10 +
    '  LConfig.BorderColor := TAlphaColors.Gray;'#13#10 +
    '  LConfig.TextColor := TAlphaColors.Black;'#13#10 +
    '  LConfig.PlaceholderColor := TAlphaColors.Gray;'#13#10 +
    '  LConfig.ArrowColor := TAlphaColors.Dodgerblue;'#13#10 +
    '  LConfig.PopupColor := $FF163A5F;'#13#10 +
    '  LConfig.HoverColor := $FF245B8F;'#13#10 +
    '  LConfig.SelectedColor := $FF2F80C9;'#13#10 +
    '  LConfig.FocusColor := TAlphaColors.Dodgerblue;'#13#10 +
    '  LConfig.DisabledOpacity := 0.50;'#13#10 +
    '  LConfig.SearchTimeout := 900;'#13#10 +
    '  LConfig.FullWindowCornerRadius := 24;'#13#10 +
    '  LConfig.FullWindowPadding := 16;'#13#10 +
    '  LConfig.SearchHeaderHeight := 84;'#13#10 +
    '  LConfig.SearchFieldHeight := 52;'#13#10 +
    '  LConfig.SearchFieldCornerRadius := 14;'#13#10 +
    '  LConfig.SearchIconSize := 22;'#13#10 +
    '  LConfig.NoResultsIconSize := 60;'#13#10 +
    '  LConfig.FullWindowBackgroundColor := TAlphaColors.White;'#13#10 +
    '  LConfig.SearchFieldBackgroundColor := TAlphaColors.White;'#13#10 +
    '  LConfig.SearchFieldBorderColor := TAlphaColors.Gray;'#13#10 +
    '  LConfig.SearchTextColor := TAlphaColors.Black;'#13#10 +
    '  LConfig.SearchIconColor := TAlphaColors.Dodgerblue;'#13#10 +
    '  LConfig.NoResultsTextColor := TAlphaColors.Gray;'#13#10 +
    '  LConfig.NoResultsIconColor := TAlphaColors.Gray;'#13#10 +
    '  LConfig.SearchPlaceholder := ''Pesquisar produto...'';'#13#10 +
    '  LConfig.NoResultsText := ''Nenhum produto encontrado'';'#13#10 +
    '  LConfig.BackPath := RICK_COMBOBOX_BACK_PATH;'#13#10 +
    '  LConfig.ClearPath := RICK_COMBOBOX_CLEAR_PATH;'#13#10 +
    '  LConfig.NoResultsPath := RICK_COMBOBOX_NO_RESULTS_PATH;'#13#10 +
    '  LConfig.Enabled := True;'#13#10 +
    '  LConfig.RequestedStyleType := TRickUIBuilderComboBoxStyleType.Custom;'#13#10 +
    '  LConfig.EffectiveStyleType := TRickUIBuilderComboBoxStyleType.Custom;'#13#10 +
    '  LConfig.PresentationMode := TRickUIBuilderComboBoxPresentationMode.Anchored;'#13#10 +
    '  LConfig.ClosedArrowPath := RICK_COMBOBOX_ARROW_DOWN_PATH;'#13#10 +
    '  LConfig.OpenedArrowPath := RICK_COMBOBOX_ARROW_UP_PATH;'#13#10 +
    ''#13#10 +
    '  LCodeColumn := TRickUIBuilderComboBoxColumn.Create('#13#10 +
    '    TRickUIBuilderComboBoxColumnSizeMode.Fixed, 72);'#13#10 +
    '  LCodeColumn.Alignment := TTextAlign.Leading;'#13#10 +
    '  LCodeColumn.Visible := True;'#13#10 +
    '  LNameColumn := TRickUIBuilderComboBoxColumn.Create('#13#10 +
    '    TRickUIBuilderComboBoxColumnSizeMode.Proportional, 1);'#13#10 +
    '  LNameColumn.Alignment := TTextAlign.Leading;'#13#10 +
    '  LNameColumn.Visible := True;'#13#10 +
    '  LPriceColumn := TRickUIBuilderComboBoxColumn.Create('#13#10 +
    '    TRickUIBuilderComboBoxColumnSizeMode.Auto);'#13#10 +
    '  LPriceColumn.Alignment := TTextAlign.Trailing;'#13#10 +
    '  LPriceColumn.Visible := True;'#13#10 +
    ''#13#10 +
    '  LOptions := TRickUIBuilderComboBoxFactoryOptions.Default;'#13#10 +
    '  LOptions.Items := ['#13#10 +
    '    TRickUIBuilderComboBoxItem.Structured('#13#10 +
    '      ''Servidor compacto'', ''SRV'','#13#10 +
    '      [''900'', ''Servidor compacto'', ''R$ 8.499''])'#13#10 +
    '  ];'#13#10 +
    '  LOptions.Columns := [LCodeColumn, LNameColumn, LPriceColumn];'#13#10 +
    '  LOptions.Placeholder := ''Catálogo completo'';'#13#10 +
    '  LOptions.SelectionMode :='#13#10 +
    '    TRickUIBuilderComboBoxInitialSelectionMode.Text;'#13#10 +
    '  LOptions.ItemIndex := 1;'#13#10 +
    '  LOptions.SelectedText := ''Servidor compacto'';'#13#10 +
    '  LOptions.OnChange := nil;'#13#10 +
    '  LOptions.OnOpen := nil;'#13#10 +
    '  LOptions.OnClose := nil;'#13#10 +
    '  LOptions.OnCustomizeItem := nil;'#13#10 +
    '  LOptions.PreserveHeight := True;'#13#10 +
    '  LOptions.PreserveItemHeight := True;'#13#10 +
    '  LOptions.PreserveHorizontalPadding := True;'#13#10 +
    '  LOptions.PreserveArrowSize := True;'#13#10 +
    ''#13#10 +
    '  TRickUIBuilderFactory.CreateComboBox('#13#10 +
    '    ResultHost, ResultHost, LConfig, LOptions, LHandle);'#13#10 +
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
