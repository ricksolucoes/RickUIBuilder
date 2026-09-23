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
| `DisabledOpacity` | `0.5` |
| `SearchTimeout` | `900` ms |
| `FullWindowCornerRadius` | `28` |
| `FullWindowPadding` | `16` |
| `SearchHeaderHeight` | `88` |
| `SearchFieldHeight` | `56` |
| `SearchFieldCornerRadius` | `16` |
| `SearchIconSize` | `24` |
| `NoResultsIconSize` | `64` |
| `SearchPlaceholder` | `Pesquisar...` |
| `NoResultsText` | `Nenhum registro encontrado` |
| `Enabled` | `True` |
| `RequestedStyleType` | `Adaptive` |
| `EffectiveStyleType` | `Desktop` antes da resolução de style |
| `PresentationMode` | `Auto` |

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
