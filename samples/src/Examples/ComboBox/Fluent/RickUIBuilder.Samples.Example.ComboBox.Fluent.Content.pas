{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Example.ComboBox.Fluent.Content                       }
{                                                                              }
{ Esta unit centraliza o conteúdo textual dos quinze exemplos ComboBox -       }
{ Fluent Builder, todos baseados em listas reais e APIs públicas comprovadas.  }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Fornecer captions, títulos, descrições e snippets da página Fluent.         }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Os exemplos variam modelo de dados, seleção, presentation, eventos e        }
{  runtime. O Completo cobre 58/58 campos do config e 32 métodos configuráveis.}
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - RickUIBuilder.Samples.App.Types                                           }
{      Fornece TComboBoxFluentExample compartilhado por page, Content e Runner.}
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - TExampleComboBoxFluent consulta esta unit ao selecionar um exemplo.       }
{  - TComboBoxFluentRunner executa o snippet equivalente no ResultHost.        }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - Não cria controles e não executa o Builder.                               }
{  - Não usa classes concretas internas de Data/Handle/Presentation.           }
{  - Todo snippet começa com comentários didáticos e corresponde ao Runner.    }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Manter conteúdo e Runner semanticamente sincronizados quando a API mudar.   }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.Example.ComboBox.Fluent.Content;

interface

uses
  RickUIBuilder.Samples.App.Types;

type
  /// <summary>Conteúdo textual da página ComboBox - Fluent Builder.</summary>
  TComboBoxFluentContent = class sealed
  public
    class function Caption(const AExample: TComboBoxFluentExample): string; static;
    class function Title(const AExample: TComboBoxFluentExample): string; static;
    class function Description(const AExample: TComboBoxFluentExample): string; static;
    class function Code(const AExample: TComboBoxFluentExample): string; static;
  end;

implementation

const
  _CAPTIONS_: array[TComboBoxFluentExample] of string = (
    'Básico',
    'Interface',
    'Texto + Value',
    'Lista estruturada',
    'Seleção inicial',
    'Geometria e popup',
    'Desktop / Anchored',
    'FullWindow e pesquisa',
    'Configuração avançada',
    'Seta',
    'Estado',
    'Eventos',
    'Customização de item',
    'Handle runtime',
    'Completo');

  _TITLES_: array[TComboBoxFluentExample] of string = (
    'Lista textual com Items',
    'Uso explícito de IRickUIBuilderComboBox',
    'DisplayText separado do Value',
    'Itens estruturados e colunas',
    'ItemIndex e SelectedText',
    'Dimensões do controle e da lista',
    'Estilo Desktop com lista ancorada',
    'Mobile + Auto com pesquisa real',
    'CustomConfig com lista de clientes',
    'Configuração visual da seta',
    'Habilitado e desabilitado',
    'OnOpen, OnClose e OnChange',
    'OnCustomizeItem',
    'IRickUIBuilderComboBoxHandle',
    'Referência exaustiva');

  _DESCRIPTIONS_: array[TComboBoxFluentExample] of string = (
    'Cria uma lista textual de tamanhos com Items, Placeholder e Build.',
    'Mantém a interface principal em variável e adiciona prioridades uma a uma com AddItem(Text).',
    'Adiciona moedas com texto visual e código semântico independentes; a seleção inicial usa o DisplayText.',
    'Cria produtos com três colunas usando Fixed, Proportional e Auto, incluindo Alignment e Visible explícitos.',
    'Compara duas formas reais de seleção inicial em ComboBoxes com listas diferentes.',
    'Usa os meses do ano para demonstrar Position, Size, ItemHeight, PopupMaxHeight e PopupWidthOffset.',
    'Materializa categorias com StyleType Desktop e PresentationMode Anchored.',
    'Usa uma lista maior de cidades; Mobile + Auto resolve FullWindow e habilita pesquisa e estado sem resultados.',
    'Aplica um TRickUIBuilderComboBoxConfig customizado a uma lista com textos longos, preservando o runtime Fluent.',
    'Demonstra cor, tamanho, lado, margens e paths fechado/aberto em uma lista de direções.',
    'Compara dois ComboBoxes com listas reais, um habilitado e outro desabilitado.',
    'Usa status de processo e feedback visual para comprovar os três callbacks públicos.',
    'Personaliza cada row reciclada com um badge owned pelo container fornecido pelo callback.',
    'Usa BuildHandle para adicionar itens, selecionar, consultar estado, alterar a seta e abrir/fechar a lista em runtime.',
    'Configura 58/58 campos de TRickUIBuilderComboBoxConfig, os 32 métodos configuráveis da interface principal e finaliza com BuildHandle.');

  _CODES_: array[TComboBoxFluentExample] of string = (
    '// Cria uma lista textual simples usando Items.'#13#10 +
    '// O ComboBox funcional é materializado diretamente no ResultHost.'#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .ComboBox'#13#10 +
    '    .Placeholder(''Escolha um tamanho'')'#13#10 +
    '      .Items([''Pequeno'', ''Médio'', ''Grande'', ''Extra grande''])'#13#10 +
    '        .Build(ResultHost);',
    '// Mantém IRickUIBuilderComboBox explicitamente e adiciona itens um a um.'#13#10 +
    '// A lista de prioridades pode ser aberta e selecionada na aba Resultado.'#13#10 +
    'var'#13#10 +
    '  LCombo: IRickUIBuilderComboBox;'#13#10 +
    'begin'#13#10 +
    '  LCombo := TRickUIBuilder.ComboBox;'#13#10 +
    ''#13#10 +
    '  LCombo'#13#10 +
    '    .Placeholder(''Prioridade'')'#13#10 +
    '      .AddItem(''Baixa'')'#13#10 +
    '      .AddItem(''Média'')'#13#10 +
    '      .AddItem(''Alta'')'#13#10 +
    '        .Build(ResultHost);'#13#10 +
    'end;',
    '// Separa o texto exibido do Value semântico de cada item.'#13#10 +
    '// A seleção mostra Real brasileiro; o Value associado permanece BRL no runtime.'#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .ComboBox'#13#10 +
    '    .Placeholder(''Moeda'')'#13#10 +
    '      .AddItem(''Real brasileiro'', ''BRL'')'#13#10 +
    '      .AddItem(''Dólar americano'', ''USD'')'#13#10 +
    '      .AddItem(''Euro'', ''EUR'')'#13#10 +
    '        .SelectedText(''Real brasileiro'')'#13#10 +
    '          .Build(ResultHost);',
    '// Configura três modos de coluna e itens com dados estruturados.'#13#10 +
    '// Abra a lista no ResultHost para comparar Fixed, Proportional e Auto.'#13#10 +
    'function FixedColumn: TRickUIBuilderComboBoxColumn;'#13#10 +
    'begin'#13#10 +
    '  Result := TRickUIBuilderComboBoxColumn.Create('#13#10 +
    '    TRickUIBuilderComboBoxColumnSizeMode.Fixed, 72);'#13#10 +
    '  Result.SizeMode := TRickUIBuilderComboBoxColumnSizeMode.Fixed;'#13#10 +
    '  Result.SizeValue := 72;'#13#10 +
    '  Result.Alignment := TTextAlign.Leading;'#13#10 +
    '  Result.Visible := True;'#13#10 +
    'end;'#13#10 +
    ''#13#10 +
    'function ProportionalColumn: TRickUIBuilderComboBoxColumn;'#13#10 +
    'begin'#13#10 +
    '  Result := TRickUIBuilderComboBoxColumn.Create('#13#10 +
    '    TRickUIBuilderComboBoxColumnSizeMode.Proportional, 1);'#13#10 +
    '  Result.SizeMode := TRickUIBuilderComboBoxColumnSizeMode.Proportional;'#13#10 +
    '  Result.SizeValue := 1;'#13#10 +
    '  Result.Alignment := TTextAlign.Leading;'#13#10 +
    '  Result.Visible := True;'#13#10 +
    'end;'#13#10 +
    ''#13#10 +
    'function AutoColumn: TRickUIBuilderComboBoxColumn;'#13#10 +
    'begin'#13#10 +
    '  Result := TRickUIBuilderComboBoxColumn.Create('#13#10 +
    '    TRickUIBuilderComboBoxColumnSizeMode.Auto, 0);'#13#10 +
    '  Result.SizeMode := TRickUIBuilderComboBoxColumnSizeMode.Auto;'#13#10 +
    '  Result.SizeValue := 0;'#13#10 +
    '  Result.Alignment := TTextAlign.Trailing;'#13#10 +
    '  Result.Visible := True;'#13#10 +
    'end;'#13#10 +
    ''#13#10 +
    'begin'#13#10 +
    '  TRickUIBuilder'#13#10 +
    '    .ComboBox'#13#10 +
    '      .Size(360, 40)'#13#10 +
    '        .Placeholder(''Produto'')'#13#10 +
    '        .Column(FixedColumn)'#13#10 +
    '        .Column(ProportionalColumn)'#13#10 +
    '        .Column(AutoColumn)'#13#10 +
    '          .AddStructuredItem(''Notebook Core i7'', ''NBK'','#13#10 +
    '            [''001'', ''Notebook Core i7'', ''R$ 4.999''])'#13#10 +
    '          .AddStructuredItem(''Monitor 27'', ''MON'','#13#10 +
    '            [''002'', ''Monitor 27 polegadas'', ''R$ 1.899''])'#13#10 +
    '          .AddStructuredItem(''Teclado mecânico'', ''TEC'','#13#10 +
    '            [''003'', ''Teclado mecânico'', ''R$ 499''])'#13#10 +
    '            .Build(ResultHost);'#13#10 +
    'end;',
    '// Compara seleção inicial por índice e por texto em listas diferentes.'#13#10 +
    '// Os dois valores selecionados ficam visíveis no ResultHost.'#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .ComboBox'#13#10 +
    '    .Position(16, 12)'#13#10 +
    '    .Placeholder(''Forma de pagamento'')'#13#10 +
    '      .Items([''Dinheiro'', ''Cartão'', ''PIX'', ''Boleto''])'#13#10 +
    '        .ItemIndex(2)'#13#10 +
    '          .Build(ResultHost);'#13#10 +
    ''#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .ComboBox'#13#10 +
    '    .Position(16, 72)'#13#10 +
    '    .Placeholder(''Departamento'')'#13#10 +
    '      .Items([''Financeiro'', ''Comercial'', ''Tecnologia'', ''Operações''])'#13#10 +
    '        .SelectedText(''Tecnologia'')'#13#10 +
    '          .Build(ResultHost);',
    '// Ajusta geometria do controle e dimensões da superfície de seleção.'#13#10 +
    '// A lista de meses permite observar altura, largura e limite do popup.'#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .ComboBox'#13#10 +
    '    .Position(16, 16)'#13#10 +
    '    .Size(280, 44)'#13#10 +
    '      .Placeholder(''Mês'')'#13#10 +
    '        .Items([''Janeiro'', ''Fevereiro'', ''Março'', ''Abril'', ''Maio'', ''Junho'','#13#10 +
    '          ''Julho'', ''Agosto'', ''Setembro'', ''Outubro'', ''Novembro'', ''Dezembro''])'#13#10 +
    '          .ItemHeight(32)'#13#10 +
    '          .PopupMaxHeight(160)'#13#10 +
    '          .PopupWidthOffset(40)'#13#10 +
    '            .Build(ResultHost);',
    '// Força o perfil Desktop e a lista Anchored junto ao controle.'#13#10 +
    '// Abra as categorias no ResultHost para observar essa apresentação.'#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .ComboBox'#13#10 +
    '    .Placeholder(''Categoria'')'#13#10 +
    '      .Items([''Eletrônicos'', ''Casa'', ''Escritório'', ''Livros'', ''Games''])'#13#10 +
    '        .StyleType(TRickUIBuilderComboBoxStyleType.Desktop)'#13#10 +
    '        .PresentationMode(TRickUIBuilderComboBoxPresentationMode.Anchored)'#13#10 +
    '          .Build(ResultHost);',
    '// Mobile + Auto resolve a superfície FullWindow com pesquisa.'#13#10 +
    '// Abra a lista no ResultHost e filtre cidades pelo campo de busca.'#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .ComboBox'#13#10 +
    '    .Placeholder(''Cidade'')'#13#10 +
    '      .Items([''Rio de Janeiro'', ''Ribeirão Preto'', ''Rio das Ostras'','#13#10 +
    '        ''São Paulo'', ''Curitiba'', ''Belo Horizonte'', ''Florianópolis'','#13#10 +
    '        ''Porto Alegre'', ''Salvador'', ''Recife''])'#13#10 +
    '        .StyleType(TRickUIBuilderComboBoxStyleType.Mobile)'#13#10 +
    '        .PresentationMode(TRickUIBuilderComboBoxPresentationMode.Auto)'#13#10 +
    '          .SearchPlaceholder(''Pesquisar cidade...'')'#13#10 +
    '          .NoResultsText(''Nenhuma cidade encontrada'')'#13#10 +
    '            .Build(ResultHost);',
    '// CustomConfig aplica opções que não possuem método Fluent dedicado.'#13#10 +
    '// A lista usa textos longos para tornar tipografia, trimming e popup observáveis.'#13#10 +
    'function AdvancedConfig: TRickUIBuilderComboBoxConfig;'#13#10 +
    'begin'#13#10 +
    '  Result := TRickUIBuilderComboBoxConfig.Default;'#13#10 +
    '  Result.Width := 340;'#13#10 +
    '  Result.Height := 44;'#13#10 +
    '  Result.PopupWidth := 380;'#13#10 +
    '  Result.FontSize := 15;'#13#10 +
    '  Result.FontStyle := [TFontStyle.fsBold];'#13#10 +
    '  Result.TextAlign := TTextAlign.Leading;'#13#10 +
    '  Result.Trimming := TTextTrimming.Character;'#13#10 +
    '  Result.BackgroundColor := TAlphaColors.White;'#13#10 +
    '  Result.BorderColor := TAlphaColors.Dodgerblue;'#13#10 +
    '  Result.PlaceholderColor := TAlphaColors.Gray;'#13#10 +
    '  Result.PopupColor := TAlphaColors.White;'#13#10 +
    '  Result.HoverColor := $FFE8F3FF;'#13#10 +
    '  Result.SelectedColor := $FFD7EBFF;'#13#10 +
    '  Result.FocusColor := TAlphaColors.Dodgerblue;'#13#10 +
    'end;'#13#10 +
    ''#13#10 +
    'begin'#13#10 +
    '  TRickUIBuilder'#13#10 +
    '    .ComboBox'#13#10 +
    '      .CustomConfig(AdvancedConfig)'#13#10 +
    '        .Placeholder(''Cliente'')'#13#10 +
    '          .Items([''ACME Comércio e Distribuição Ltda.'','#13#10 +
    '            ''Empresa Brasileira de Tecnologia Aplicada S.A.'','#13#10 +
    '            ''Serviços Integrados do Atlântico''])'#13#10 +
    '            .Build(ResultHost);'#13#10 +
    'end;',
    '// Configura a seta fechada/aberta sem alterar a lista de dados.'#13#10 +
    '// Abra e feche o ComboBox no ResultHost para observar os dois paths.'#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .ComboBox'#13#10 +
    '    .Placeholder(''Direção'')'#13#10 +
    '      .Items([''Norte'', ''Sul'', ''Leste'', ''Oeste''])'#13#10 +
    '        .ArrowColor(TAlphaColors.Dodgerblue)'#13#10 +
    '        .ArrowSize(18)'#13#10 +
    '        .ArrowPosition(TRickUIBuilderComboBoxArrowPosition.Left)'#13#10 +
    '        .ArrowMargins(14, 4, 8, 4)'#13#10 +
    '          .ClosedArrowPath(RICK_COMBOBOX_ARROW_DOWN_PATH)'#13#10 +
    '          .OpenedArrowPath(RICK_COMBOBOX_ARROW_UP_PATH)'#13#10 +
    '            .Build(ResultHost);',
    '// Mantém dados reais tanto no controle habilitado quanto no desabilitado.'#13#10 +
    '// O primeiro abre normalmente; o segundo preserva a lista mas bloqueia interação.'#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .ComboBox'#13#10 +
    '    .Position(16, 12)'#13#10 +
    '    .Placeholder(''Nível de acesso'')'#13#10 +
    '      .Items([''Leitura'', ''Operação'', ''Administração''])'#13#10 +
    '        .Enabled(True)'#13#10 +
    '          .Build(ResultHost);'#13#10 +
    ''#13#10 +
    'TRickUIBuilder'#13#10 +
    '  .ComboBox'#13#10 +
    '    .Position(16, 72)'#13#10 +
    '    .Placeholder(''Plano indisponível'')'#13#10 +
    '      .Items([''Básico'', ''Profissional'', ''Enterprise''])'#13#10 +
    '        .Enabled(False)'#13#10 +
    '          .Build(ResultHost);',
    '// OnOpen, OnClose e OnChange atualizam um feedback no ResultHost.'#13#10 +
    '// O receptor permanece vivo enquanto a Sample Page estiver aberta.'#13#10 +
    'procedure TComboBoxFluentRunner.ComboChanged(ASender: TObject);'#13#10 +
    'var'#13#10 +
    '  LHandle: IRickUIBuilderComboBoxHandle;'#13#10 +
    'begin'#13#10 +
    '  if Supports(ASender, IRickUIBuilderComboBoxHandle, LHandle) then'#13#10 +
    '    SetStatus(''OnChange: '' + LHandle.SelectedText + '' / '' +'#13#10 +
    '      LHandle.SelectedValue)'#13#10 +
    '  else'#13#10 +
    '    SetStatus(''OnChange executado'');'#13#10 +
    'end;'#13#10 +
    ''#13#10 +
    'procedure TComboBoxFluentRunner.ComboOpened(ASender: TObject);'#13#10 +
    'begin'#13#10 +
    '  SetStatus(''OnOpen: lista aberta'');'#13#10 +
    'end;'#13#10 +
    ''#13#10 +
    'procedure TComboBoxFluentRunner.ComboClosed(ASender: TObject);'#13#10 +
    'begin'#13#10 +
    '  SetStatus(''OnClose: lista fechada'');'#13#10 +
    'end;'#13#10 +
    ''#13#10 +
    'begin'#13#10 +
    '  CreateStatusLabel(ResultHost, ''Abra a lista e selecione um status.'');'#13#10 +
    '  TRickUIBuilder'#13#10 +
    '    .ComboBox'#13#10 +
    '      .Placeholder(''Status do processo'')'#13#10 +
    '        .AddItem(''Pendente'', ''PEN'')'#13#10 +
    '        .AddItem(''Em análise'', ''ANA'')'#13#10 +
    '        .AddItem(''Aprovado'', ''APR'')'#13#10 +
    '        .AddItem(''Rejeitado'', ''REJ'')'#13#10 +
    '          .OnOpen(ComboOpened)'#13#10 +
    '          .OnClose(ComboClosed)'#13#10 +
    '          .OnChange(ComboChanged)'#13#10 +
    '            .Build(ResultHost);'#13#10 +
    'end;',
    '// OnCustomizeItem recebe um container reciclado owned pelo ComboBox.'#13#10 +
    '// Cada row cria seu próprio badge dentro desse container ao abrir a lista.'#13#10 +
    'procedure ConfigureCustomBadge(ABadge: TRectangle);'#13#10 +
    'begin'#13#10 +
    '  ABadge.Align := TAlignLayout.Right;'#13#10 +
    '  ABadge.Width := 72;'#13#10 +
    '  ABadge.Margins.Right := 8;'#13#10 +
    '  ABadge.Margins.Top := 6;'#13#10 +
    '  ABadge.Margins.Bottom := 6;'#13#10 +
    '  ABadge.Fill.Color := TAlphaColors.Dodgerblue;'#13#10 +
    '  ABadge.Stroke.Kind := TBrushKind.None;'#13#10 +
    '  ABadge.XRadius := 8;'#13#10 +
    '  ABadge.YRadius := 8;'#13#10 +
    '  ABadge.HitTest := False;'#13#10 +
    'end;'#13#10 +
    ''#13#10 +
    'procedure ConfigureCustomBadgeLabel(ALabel: TLabel; const AText: string);'#13#10 +
    'begin'#13#10 +
    '  ALabel.Align := TAlignLayout.Client;'#13#10 +
    '  ALabel.Text := AText;'#13#10 +
    '  ALabel.TextSettings.HorzAlign := TTextAlign.Center;'#13#10 +
    '  ALabel.TextSettings.VertAlign := TTextAlign.Center;'#13#10 +
    '  ALabel.TextSettings.FontColor := TAlphaColors.White;'#13#10 +
    '  ALabel.StyledSettings := ALabel.StyledSettings - [TStyledSetting.FontColor];'#13#10 +
    '  ALabel.HitTest := False;'#13#10 +
    'end;'#13#10 +
    ''#13#10 +
    'procedure TComboBoxFluentRunner.CustomizeItem(ASender: TObject;'#13#10 +
    '  AIndex: Integer; const AItem: TRickUIBuilderComboBoxItem;'#13#10 +
    '  AContainer: TControl);'#13#10 +
    'var'#13#10 +
    '  LBadge: TRectangle;'#13#10 +
    '  LLabel: TLabel;'#13#10 +
    '  LText: string;'#13#10 +
    'begin'#13#10 +
    '  if SameText(AItem.Value, ''NOVO'') then'#13#10 +
    '    LText := ''Novo'''#13#10 +
    '  else'#13#10 +
    '    LText := ''Ativo'';'#13#10 +
    '  LBadge := TRectangle.Create(AContainer);'#13#10 +
    '  LBadge.Parent := AContainer;'#13#10 +
    '  ConfigureCustomBadge(LBadge);'#13#10 +
    '  LLabel := TLabel.Create(LBadge);'#13#10 +
    '  LLabel.Parent := LBadge;'#13#10 +
    '  ConfigureCustomBadgeLabel(LLabel, LText);'#13#10 +
    'end;'#13#10 +
    ''#13#10 +
    'begin'#13#10 +
    '  TRickUIBuilder'#13#10 +
    '    .ComboBox'#13#10 +
    '      .Placeholder(''Projeto'')'#13#10 +
    '        .StyleType(TRickUIBuilderComboBoxStyleType.Desktop)'#13#10 +
    '        .PresentationMode(TRickUIBuilderComboBoxPresentationMode.Anchored)'#13#10 +
    '          .AddItem(''Portal do cliente'', ''ATIVO'')'#13#10 +
    '          .AddItem(''Aplicativo mobile'', ''NOVO'')'#13#10 +
    '          .AddItem(''Integração fiscal'', ''ATIVO'')'#13#10 +
    '          .AddItem(''Painel executivo'', ''NOVO'')'#13#10 +
    '            .OnCustomizeItem(CustomizeItem)'#13#10 +
    '              .Build(ResultHost);'#13#10 +
    'end;',
    '// BuildHandle expõe operações runtime sem depender da classe concreta interna.'#13#10 +
    '// A lista final fica aberta no ResultHost e o feedback mostra seleção e contagem.'#13#10 +
    'procedure ConfigureRuntimeHandle('#13#10 +
    '  const AHandle: IRickUIBuilderComboBoxHandle);'#13#10 +
    'begin'#13#10 +
    '  AHandle.Add(''Leitor biométrico'');'#13#10 +
    '  AHandle.Add(''Mesa digitalizadora'', ''MESA'');'#13#10 +
    '  AHandle.AddRange([''Microfone USB'', ''Webcam 4K'']);'#13#10 +
    '  AHandle.SelectIndex(0);'#13#10 +
    '  AHandle.SelectText(''Mesa digitalizadora'');'#13#10 +
    '  AHandle.SetArrowColor(TAlphaColors.Dodgerblue);'#13#10 +
    '  AHandle.SetArrowSize(18, 12);'#13#10 +
    '  AHandle.SetClosedArrowPath(RICK_COMBOBOX_ARROW_DOWN_PATH);'#13#10 +
    '  AHandle.SetOpenedArrowPath(RICK_COMBOBOX_ARROW_UP_PATH);'#13#10 +
    '  AHandle.Open;'#13#10 +
    '  AHandle.Close;'#13#10 +
    '  AHandle.Open;'#13#10 +
    'end;'#13#10 +
    ''#13#10 +
    'var'#13#10 +
    '  LHandle: IRickUIBuilderComboBoxHandle;'#13#10 +
    'begin'#13#10 +
    '  LHandle := TRickUIBuilder'#13#10 +
    '    .ComboBox'#13#10 +
    '      .Position(16, 110)'#13#10 +
    '      .Placeholder(''Periférico'')'#13#10 +
    '        .AddItem(''Impressora'', ''IMP'')'#13#10 +
    '        .AddItem(''Scanner'', ''SCN'')'#13#10 +
    '          .BuildHandle(ResultHost);'#13#10 +
    ''#13#10 +
    '  ConfigureRuntimeHandle(LHandle);'#13#10 +
    '  ShowRuntimeStatus(ResultHost, LHandle);'#13#10 +
    'end;',
    '// Configura integralmente o record e a interface Fluent principal do ComboBox.'#13#10 +
    '// A lista mistura Items, overloads de AddItem e item estruturado com três colunas.'#13#10 +
    '// BuildHandle materializa o resultado e mantém os callbacks no Runner da página.'#13#10 +
    'function FixedColumn: TRickUIBuilderComboBoxColumn;'#13#10 +
    'begin'#13#10 +
    '  Result := TRickUIBuilderComboBoxColumn.Create('#13#10 +
    '    TRickUIBuilderComboBoxColumnSizeMode.Fixed, 72);'#13#10 +
    '  Result.SizeMode := TRickUIBuilderComboBoxColumnSizeMode.Fixed;'#13#10 +
    '  Result.SizeValue := 72;'#13#10 +
    '  Result.Alignment := TTextAlign.Leading;'#13#10 +
    '  Result.Visible := True;'#13#10 +
    'end;'#13#10 +
    ''#13#10 +
    'function ProportionalColumn: TRickUIBuilderComboBoxColumn;'#13#10 +
    'begin'#13#10 +
    '  Result := TRickUIBuilderComboBoxColumn.Create('#13#10 +
    '    TRickUIBuilderComboBoxColumnSizeMode.Proportional, 1);'#13#10 +
    '  Result.SizeMode := TRickUIBuilderComboBoxColumnSizeMode.Proportional;'#13#10 +
    '  Result.SizeValue := 1;'#13#10 +
    '  Result.Alignment := TTextAlign.Leading;'#13#10 +
    '  Result.Visible := True;'#13#10 +
    'end;'#13#10 +
    ''#13#10 +
    'function AutoColumn: TRickUIBuilderComboBoxColumn;'#13#10 +
    'begin'#13#10 +
    '  Result := TRickUIBuilderComboBoxColumn.Create('#13#10 +
    '    TRickUIBuilderComboBoxColumnSizeMode.Auto, 0);'#13#10 +
    '  Result.SizeMode := TRickUIBuilderComboBoxColumnSizeMode.Auto;'#13#10 +
    '  Result.SizeValue := 0;'#13#10 +
    '  Result.Alignment := TTextAlign.Trailing;'#13#10 +
    '  Result.Visible := True;'#13#10 +
    'end;'#13#10 +
    ''#13#10 +
    'procedure ConfigureCompleteGeometry(var AConfig: TRickUIBuilderComboBoxConfig);'#13#10 +
    'begin'#13#10 +
    '  AConfig.Left := 16;'#13#10 +
    '  AConfig.Top := 16;'#13#10 +
    '  AConfig.Width := 360;'#13#10 +
    '  AConfig.Height := 44;'#13#10 +
    '  AConfig.ItemHeight := 40;'#13#10 +
    '  AConfig.PopupWidth := 380;'#13#10 +
    '  AConfig.PopupWidthOffset := 12;'#13#10 +
    '  AConfig.PopupMaxHeight := 260;'#13#10 +
    '  AConfig.CornerRadius := 10;'#13#10 +
    '  AConfig.HorizontalPadding := 14;'#13#10 +
    'end;'#13#10 +
    ''#13#10 +
    'procedure ConfigureCompleteArrowTypography(var AConfig: TRickUIBuilderComboBoxConfig);'#13#10 +
    'begin'#13#10 +
    '  AConfig.ArrowSize := 18;'#13#10 +
    '  AConfig.ArrowMarginLeft := 8;'#13#10 +
    '  AConfig.ArrowMarginTop := 4;'#13#10 +
    '  AConfig.ArrowMarginRight := 12;'#13#10 +
    '  AConfig.ArrowMarginBottom := 4;'#13#10 +
    '  AConfig.ArrowPosition := TRickUIBuilderComboBoxArrowPosition.Right;'#13#10 +
    '  AConfig.FontSize := 14;'#13#10 +
    '  AConfig.FontFamily := '''';'#13#10 +
    '  AConfig.FontStyle := [TFontStyle.fsBold];'#13#10 +
    '  AConfig.TextAlign := TTextAlign.Leading;'#13#10 +
    '  AConfig.Trimming := TTextTrimming.Character;'#13#10 +
    'end;'#13#10 +
    ''#13#10 +
    'procedure ConfigureCompleteColors(var AConfig: TRickUIBuilderComboBoxConfig);'#13#10 +
    'begin'#13#10 +
    '  AConfig.BackgroundColor := TAlphaColors.White;'#13#10 +
    '  AConfig.EditBackgroundColor := TAlphaColors.White;'#13#10 +
    '  AConfig.BorderColor := TAlphaColors.Gray;'#13#10 +
    '  AConfig.TextColor := TAlphaColors.Black;'#13#10 +
    '  AConfig.PlaceholderColor := TAlphaColors.Gray;'#13#10 +
    '  AConfig.ArrowColor := TAlphaColors.Dodgerblue;'#13#10 +
    '  AConfig.PopupColor := TAlphaColors.White;'#13#10 +
    '  AConfig.HoverColor := $FFE8F3FF;'#13#10 +
    '  AConfig.SelectedColor := $FFD7EBFF;'#13#10 +
    '  AConfig.FocusColor := TAlphaColors.Dodgerblue;'#13#10 +
    '  AConfig.DisabledOpacity := 0.50;'#13#10 +
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
    '  AConfig.SearchFieldBorderColor := TAlphaColors.Gray;'#13#10 +
    '  AConfig.SearchTextColor := TAlphaColors.Black;'#13#10 +
    '  AConfig.SearchIconColor := TAlphaColors.Dodgerblue;'#13#10 +
    '  AConfig.NoResultsTextColor := TAlphaColors.Gray;'#13#10 +
    '  AConfig.NoResultsIconColor := TAlphaColors.Gray;'#13#10 +
    'end;'#13#10 +
    ''#13#10 +
    'procedure ConfigureCompleteContentBehavior(var AConfig: TRickUIBuilderComboBoxConfig);'#13#10 +
    'begin'#13#10 +
    '  AConfig.SearchPlaceholder := ''Pesquisar produto...'';'#13#10 +
    '  AConfig.NoResultsText := ''Nenhum produto encontrado'';'#13#10 +
    '  AConfig.BackPath := RICK_COMBOBOX_BACK_PATH;'#13#10 +
    '  AConfig.ClearPath := RICK_COMBOBOX_CLEAR_PATH;'#13#10 +
    '  AConfig.NoResultsPath := RICK_COMBOBOX_NO_RESULTS_PATH;'#13#10 +
    '  AConfig.Enabled := True;'#13#10 +
    '  AConfig.RequestedStyleType := TRickUIBuilderComboBoxStyleType.Custom;'#13#10 +
    '  AConfig.EffectiveStyleType := TRickUIBuilderComboBoxStyleType.Custom;'#13#10 +
    '  AConfig.PresentationMode := TRickUIBuilderComboBoxPresentationMode.Anchored;'#13#10 +
    '  AConfig.ClosedArrowPath := RICK_COMBOBOX_ARROW_DOWN_PATH;'#13#10 +
    '  AConfig.OpenedArrowPath := RICK_COMBOBOX_ARROW_UP_PATH;'#13#10 +
    '  AConfig.SearchTimeout := 900;'#13#10 +
    'end;'#13#10 +
    ''#13#10 +
    'procedure ConfigureCompleteData(const ACombo: IRickUIBuilderComboBox);'#13#10 +
    'begin'#13#10 +
    '  ACombo'#13#10 +
    '    .Items([''Adaptador USB-C'', ''Cabo de rede''])'#13#10 +
    '      .AddItem(''Fonte universal'')'#13#10 +
    '      .AddItem(''Estação docking'', ''DOCK'')'#13#10 +
    '      .AddStructuredItem(''Servidor compacto'', ''SRV'','#13#10 +
    '        [''900'', ''Servidor compacto'', ''R$ 8.499''])'#13#10 +
    '        .Column(FixedColumn)'#13#10 +
    '        .Column(ProportionalColumn)'#13#10 +
    '        .Column(AutoColumn);'#13#10 +
    'end;'#13#10 +
    ''#13#10 +
    'procedure ConfigureCompletePresentation(const ACombo: IRickUIBuilderComboBox);'#13#10 +
    'begin'#13#10 +
    '  ACombo'#13#10 +
    '    .Position(16, 16)'#13#10 +
    '    .Size(360, 44)'#13#10 +
    '      .Placeholder(''Catálogo completo'')'#13#10 +
    '        .ItemIndex(1)'#13#10 +
    '        .SelectedText(''Servidor compacto'')'#13#10 +
    '          .StyleType(TRickUIBuilderComboBoxStyleType.Custom)'#13#10 +
    '          .PresentationMode(TRickUIBuilderComboBoxPresentationMode.Anchored)'#13#10 +
    '            .ItemHeight(40)'#13#10 +
    '            .PopupMaxHeight(260)'#13#10 +
    '            .PopupWidthOffset(12)'#13#10 +
    '              .ArrowColor(TAlphaColors.Dodgerblue)'#13#10 +
    '              .ArrowSize(18)'#13#10 +
    '              .ArrowPosition(TRickUIBuilderComboBoxArrowPosition.Right)'#13#10 +
    '              .ArrowMargins(8, 4, 12, 4)'#13#10 +
    '                .Enabled(True);'#13#10 +
    'end;'#13#10 +
    ''#13#10 +
    'procedure TComboBoxFluentRunner.ConfigureCompleteEvents('#13#10 +
    '  const ACombo: IRickUIBuilderComboBox);'#13#10 +
    'begin'#13#10 +
    '  ACombo'#13#10 +
    '    .ClosedArrowPath(RICK_COMBOBOX_ARROW_DOWN_PATH)'#13#10 +
    '    .OpenedArrowPath(RICK_COMBOBOX_ARROW_UP_PATH)'#13#10 +
    '      .SearchPlaceholder(''Pesquisar produto...'')'#13#10 +
    '      .NoResultsText(''Nenhum produto encontrado'')'#13#10 +
    '        .BackPath(RICK_COMBOBOX_BACK_PATH)'#13#10 +
    '        .ClearPath(RICK_COMBOBOX_CLEAR_PATH)'#13#10 +
    '        .NoResultsPath(RICK_COMBOBOX_NO_RESULTS_PATH)'#13#10 +
    '          .OnChange(ComboChanged)'#13#10 +
    '          .OnOpen(ComboOpened)'#13#10 +
    '          .OnClose(ComboClosed)'#13#10 +
    '          .OnCustomizeItem(CustomizeItem);'#13#10 +
    'end;'#13#10 +
    ''#13#10 +
    'function CompleteConfig: TRickUIBuilderComboBoxConfig;'#13#10 +
    'begin'#13#10 +
    '  Result := TRickUIBuilderComboBoxConfig.Default;'#13#10 +
    '  ConfigureCompleteGeometry(Result);'#13#10 +
    '  ConfigureCompleteArrowTypography(Result);'#13#10 +
    '  ConfigureCompleteColors(Result);'#13#10 +
    '  ConfigureCompleteFullWindowGeometry(Result);'#13#10 +
    '  ConfigureCompleteFullWindowColors(Result);'#13#10 +
    '  ConfigureCompleteContentBehavior(Result);'#13#10 +
    'end;'#13#10 +
    ''#13#10 +
    'var'#13#10 +
    '  LCombo: IRickUIBuilderComboBox;'#13#10 +
    '  LConfig: TRickUIBuilderComboBoxConfig;'#13#10 +
    '  LHandle: IRickUIBuilderComboBoxHandle;'#13#10 +
    'begin'#13#10 +
    '  LConfig := CompleteConfig;'#13#10 +
    '  CreateStatusLabel(ResultHost, ''Configuração completa pronta para interação.'');'#13#10 +
    '  LCombo := TRickUIBuilder.ComboBox;'#13#10 +
    '  LCombo.CustomConfig(LConfig);'#13#10 +
    '  ConfigureCompleteData(LCombo);'#13#10 +
    '  ConfigureCompletePresentation(LCombo);'#13#10 +
    '  ConfigureCompleteEvents(LCombo);'#13#10 +
    '  LHandle := LCombo.BuildHandle(ResultHost);'#13#10 +
    '  SetStatus(Format(''Itens: %d | Selecionado: %s | Value: %s'','#13#10 +
    '    [LHandle.Count, LHandle.SelectedText, LHandle.SelectedValue]));'#13#10 +
    'end;');

class function TComboBoxFluentContent.Caption(
  const AExample: TComboBoxFluentExample): string;
begin
  Result := _CAPTIONS_[AExample];
end;

class function TComboBoxFluentContent.Title(
  const AExample: TComboBoxFluentExample): string;
begin
  Result := _TITLES_[AExample];
end;

class function TComboBoxFluentContent.Description(
  const AExample: TComboBoxFluentExample): string;
begin
  Result := _DESCRIPTIONS_[AExample];
end;

class function TComboBoxFluentContent.Code(
  const AExample: TComboBoxFluentExample): string;
begin
  Result := _CODES_[AExample];
end;

end.
