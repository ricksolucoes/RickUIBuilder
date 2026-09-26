# API Pública e Configuração

> [English](api-publica-e-configuracao.md) | [Português do Brasil](api-publica-e-configuracao.pt-BR.md)

## Fonte de verdade

Os contratos públicos são definidos em `Rick.UIBuilder.Interfaces.pas` e `Rick.UIBuilder.Types.pas`. A implementação fluente está em `Rick.UIBuilder.ComboBox.pas`. O ponto de entrada da facade é `TRickUIBuilder.ComboBox`.

## Ponto de entrada do builder

```pascal
TRickUIBuilder.ComboBox
  .Position(24, 80)
  .Size(320, 42)
  .Items(['Small', 'Medium', 'Large'])
  .ItemIndex(0)
  .Build(AParent);
```

Cada chamada a `TRickUIBuilder.ComboBox` retorna uma nova instância independente do builder. O builder acumula estado até a chamada de `Build` ou `BuildHandle`.

## IRickUIBuilderComboBox

| Grupo | Métodos | Efeito |
|---|---|---|
| Geometria | `Position`, `Size`, `ItemHeight`, `PopupMaxHeight`, `PopupWidthOffset` | Configura dimensionamento do controle fechado e da superfície de seleção. |
| Dados | `Items`, `AddItem`, `AddStructuredItem`, `Column` | Define itens lógicos e colunas estruturadas opcionais. |
| Seleção inicial | `ItemIndex`, `SelectedText` | Define a seleção confirmada inicial. |
| Style/presentation | `StyleType`, `CustomConfig`, `PresentationMode` | Seleciona perfil visual e comportamento de apresentação. |
| Seta | `ArrowColor`, `ArrowSize`, `ArrowPosition`, `ArrowMargins`, `ClosedArrowPath`, `OpenedArrowPath` | Configura a seta do controle fechado. |
| FullWindow | `SearchPlaceholder`, `NoResultsText`, `BackPath`, `ClearPath`, `NoResultsPath` | Configura conteúdo de pesquisa e empty state. |
| Estado/eventos | `Enabled`, `OnChange`, `OnOpen`, `OnClose`, `OnCustomizeItem` | Habilita comportamento e conecta callbacks runtime. |
| Materialização | `Build`, `BuildHandle` | Cria o controle e os serviços runtime. |

## Build versus BuildHandle

`Build(AParent)` retorna o `TRectangle` principal. O runtime permanece vivo porque um behavior component interno retém a interface do handle enquanto o container visual existir. `BuildHandle(AParent)` retorna `IRickUIBuilderComboBoxHandle`, permitindo acesso runtime após a materialização. O handle não possui a árvore visual FMX e passa a reportar `IsAttached = False` depois que o container visual é destruído.

## IRickUIBuilderComboBoxHandle

| Método | Comportamento |
|---|---|
| `IsAttached` | Informa se a referência ao container visual principal ainda é válida. |
| `ItemIndex` | Índice de origem confirmado, ou `-1`. |
| `SelectedText` | `DisplayText` confirmado, ou string vazia. |
| `SelectedValue` | `Value` confirmado, ou string vazia. |
| `Count` | Quantidade de itens da coleção de origem. |
| `SelectIndex` | Seleciona `-1` ou um source index válido; valores inválidos retornam `False`. |
| `SelectText` | Seleciona a primeira correspondência exata case-insensitive de `DisplayText`. |
| `Add` | Adiciona item textual ou item `DisplayText`/`Value`. |
| `AddRange` | Adiciona vários itens textuais sem refazer o Build. |
| `Open`, `Close` | Controla a superfície de seleção. |
| `SetArrowColor`, `SetArrowSize` | Altera propriedades visuais da seta em runtime. |
| `SetClosedArrowPath`, `SetOpenedArrowPath` | Substitui path data da seta em runtime. |

## Enums públicos

- `TRickUIBuilderComboBoxStyleType`: `Desktop`, `Mobile`, `Adaptive`, `Custom`.
- `TRickUIBuilderComboBoxPresentationMode`: `Auto`, `Anchored`, `Overlay`, `FullWindow`.
- `TRickUIBuilderComboBoxArrowPosition`: `Left`, `Right`.
- `TRickUIBuilderComboBoxColumnSizeMode`: `Auto`, `Fixed`, `Proportional`.

A sintaxe de scoped enums é utilizada: referencie membros como `Type.Member`.

## Records de item e coluna

`TRickUIBuilderComboBoxItem` armazena `DisplayText`, `Value` e `Columns`. `Create(ADisplayText)` define `Value = DisplayText`. `Create(ADisplayText, AValue)` mantém ambos independentes. `Structured` também copia os dados das colunas. `TRickUIBuilderComboBoxColumn.Create` define modo/valor de dimensionamento, `Alignment = Leading` e `Visible = True`.

## Configuração padrão

| Campo | Default |
|---|---:|
| `Width` / `Height` | `220` / `40` |
| `ItemHeight` | `36` |
| `PopupWidth` | `0` (resolvido pela largura do anchor) |
| `PopupWidthOffset` | `0` |
| `PopupMaxHeight` | `240` |
| `CornerRadius` | `6` |
| `HorizontalPadding` | `12` |
| `ArrowSize` | `20` |
| Margens L/T/R/B da seta | `8 / 0 / 12 / 0` |
| `ArrowPosition` | `Right` |
| `FontSize` | `14` |
| `FontFamily` | `''` |
| `FontStyle` | `[]` |
| `TextAlign` | `TTextAlign.Leading` |
| `Trimming` | `TTextTrimming.None` |
| `BackgroundColor` | `TAlphaColors.White` |
| `BorderColor` | `$FFD0D5DD` |
| `TextColor` | `$FF1D2939` |
| `PlaceholderColor` | `$FF667085` |
| `ArrowColor` | `$FF667085` |
| `PopupColor` | `TAlphaColors.White` |
| `HoverColor` | `$FFF2F4F7` |
| `SelectedColor` | `$FFEFF8FF` |
| `FocusColor` | `$FF2E90FA` |
| `DisabledOpacity` | `0.5` |
| `SearchTimeout` | `900` ms |
| `FullWindowCornerRadius` | `28` |
| `FullWindowPadding` | `16` |
| `SearchHeaderHeight` | `88` |
| `SearchFieldHeight` | `56` |
| `SearchFieldCornerRadius` | `16` |
| `SearchIconSize` | `24` |
| `NoResultsIconSize` | `64` |
| `FullWindowBackgroundColor` | `TAlphaColors.White` |
| `SearchFieldBackgroundColor` | `TAlphaColors.White` |
| `SearchFieldBorderColor` | `$FF98A2B3` |
| `SearchTextColor` | `$FF1D2939` |
| `SearchIconColor` | `$FF1D2939` |
| `NoResultsTextColor` | `$FF667085` |
| `NoResultsIconColor` | `$FF98A2B3` |
| `SearchPlaceholder` | `Pesquisar...` |
| `NoResultsText` | `Nenhum registro encontrado` |
| `Enabled` | `True` |
| `RequestedStyleType` | `Adaptive` |
| `EffectiveStyleType` | `Desktop` antes da resolução de style |
| `PresentationMode` | `Auto` |

## Configurações avançadas do record

Nem todos os campos de `TRickUIBuilderComboBoxConfig` possuem um método fluente dedicado. Para esses casos, use `TRickUIBuilderComboBoxConfig.Default` como base e aplique o record com `CustomConfig`.

Os principais campos avançados são:

| Grupo | Campos | Semântica |
|---|---|---|
| Tipografia | `FontFamily`, `FontStyle`, `TextAlign`, `Trimming` | Configuram família, estilos, alinhamento horizontal e trimming do texto exibido pelo ComboBox. |
| Placeholder | `PlaceholderColor` | Define a cor usada quando não existe seleção confirmada e o placeholder é exibido. |
| Popup | `PopupWidth`, `PopupWidthOffset`, `PopupColor` | Controlam largura e cor da superfície de seleção não FullWindow. |
| Estados visuais | `HoverColor`, `SelectedColor`, `FocusColor` | Definem as cores usadas para hover, seleção e foco. |
| FullWindow — geometria | `FullWindowCornerRadius`, `FullWindowPadding`, `SearchHeaderHeight`, `SearchFieldHeight`, `SearchFieldCornerRadius`, `SearchIconSize`, `NoResultsIconSize` | Dimensionam a apresentação FullWindow e seus elementos de pesquisa/empty state. |
| FullWindow — cores | `FullWindowBackgroundColor`, `SearchFieldBackgroundColor`, `SearchFieldBorderColor`, `SearchTextColor`, `SearchIconColor`, `NoResultsTextColor`, `NoResultsIconColor` | Definem as cores da superfície FullWindow, campo de pesquisa e estado sem resultados. |

`PopupWidth` e `PopupWidthOffset` têm semântica conjunta: quando `PopupWidth > 0`, esse valor é usado diretamente. Quando `PopupWidth <= 0`, a largura é calculada como `Anchor.Width + PopupWidthOffset`. O resultado final é limitado a no mínimo `1`.

### Eventos

- `OnChange` é disparado quando a seleção confirmada realmente muda.
- `OnOpen` é disparado ao final de uma abertura efetiva, depois que estado, apresentação, seta e popup foram atualizados. Chamadas a `Open` sem attachment, com `Enabled = False` ou quando o ComboBox já está aberto não disparam o evento.
- `OnClose` é disparado ao final de um fechamento efetivo, depois que a presentation foi fechada, o estado foi finalizado e a seta foi atualizada. Chamar `Close` quando o ComboBox já está fechado não dispara o evento.

### Navegação por teclado

No controle principal fechado:

| Entrada | Ação |
|---|---|
| `F4`, `Enter`, `Space`, `Alt+Down` | Abre o ComboBox. |
| `Down`, `Right` | Seleciona o próximo item, respeitando os limites. |
| `Up`, `Left` | Seleciona o item anterior, respeitando os limites. |
| Caractere imprimível | Executa busca incremental por prefixo e confirma a correspondência encontrada. |

No controle principal aberto:

| Entrada | Ação |
|---|---|
| `Down`, `Up` | Move o target visual. |
| `Home`, `End` | Move o target para o primeiro ou último item da view. |
| `PageUp`, `PageDown` | Move o target por uma página calculada a partir da altura disponível e de `ItemHeight`. |
| `Enter`, `Space` | Confirma o target e fecha. |
| `Escape`, `Tab` | Fecha. |
| Caractere imprimível | Executa busca incremental por prefixo e move o target para a correspondência. |

No campo de pesquisa FullWindow, `Down`, `Up`, `PageUp`, `PageDown`, `Enter`, `Escape` e `Tab` são tratados pelo runtime do ComboBox. `Home`, `End` e `Space` não fazem parte desse mapa específico.

A busca incremental usa `SearchTimeout` para limpar o buffer acumulado; o default atual é `900` ms. Ela é distinta do filtro textual exibido na apresentação FullWindow.

### Alterações runtime da seta

`SetArrowSize(AWidth, AHeight)` aceita largura e altura independentes. Se qualquer uma delas for `<= 0`, a chamada é ignorada. `SetClosedArrowPath` e `SetOpenedArrowPath` atualizam o path armazenado e reaplicam imediatamente a aparência correspondente ao estado aberto/fechado atual.

## CustomConfig e defaults de style

`CustomConfig` copia o record inteiro, força `RequestedStyleType = Custom` e marca height, item height e arrow size como overrides explícitos. Uma chamada posterior de `StyleType(...)` pode alterar o style solicitado, como demonstrado no Sample. Durante `ResolvedConfig`, defaults Desktop/Mobile são aplicados pelo resolver e, depois, overrides explícitos do builder para height, item height e arrow size são restaurados.

## Exemplo runtime

```pascal
FComboBoxHandle := TRickUIBuilder.ComboBox
  .Position(24, 80)
  .Size(320, 42)
  .AddItem('Rio de Janeiro', 'RJ')
  .AddItem('São Paulo', 'SP')
  .BuildHandle(AParent);
```

```pascal
if FComboBoxHandle.IsAttached then
begin
  FComboBoxHandle.Add('Mouse sem fio', '004');
  FComboBoxHandle.AddRange(['Headset', 'Webcam']);
  FComboBoxHandle.SetArrowColor($FF7E22CE);
end;
```
