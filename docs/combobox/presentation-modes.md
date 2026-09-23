# Presentation Modes

> [English](presentation-modes.md) | [Português do Brasil](presentation-modes.pt-BR.md)

## Source of truth

Presentation selection is resolved in `Rick.UIBuilder.ComboBox.Style.pas`; visual materialization is implemented in `Rick.UIBuilder.ComboBox.Presentation.pas`.

## StyleType and PresentationMode are independent

`TRickUIBuilderComboBoxStyleType` selects a visual/interaction profile. `TRickUIBuilderComboBoxPresentationMode` selects how the selection surface is shown. They are intentionally separate so `Custom` can use Anchored or FullWindow and an explicit presentation can override a style default.

## Auto resolution

```text
Desktop + Auto  → Anchored
Mobile  + Auto  → FullWindow
Adaptive         → Mobile on ANDROID/IOS, otherwise Desktop
Explicit PresentationMode → preserved
```

`Adaptive` is resolved at compile target level through conditional defines. After the effective style is known, `Auto` is converted to `FullWindow` for Mobile and `Anchored` for other effective styles.

## Desktop and Mobile defaults

Desktop defaults: `Height = 40`, `ItemHeight = 36`, `HorizontalPadding = 12`, `ArrowSize = 20`. Mobile defaults: `Height = 48`, `ItemHeight = 48`, `HorizontalPadding = 16`, `ArrowSize = 22`. Explicit builder overrides for height, item height, and arrow size are restored after style resolution.

## Anchored

Anchored uses the original parent as popup parent. The popup width is `PopupWidth` when greater than zero; otherwise it is anchor width plus `PopupWidthOffset`. Placement prefers below the anchor when there is enough space, otherwise above, otherwise the side with more available space. Height is limited by `PopupMaxHeight`.

## Overlay

Overlay also uses the original parent. Its origin is the current viewport origin and its width expands to the parent width when the parent is a `TControl`. Its height is limited by the available parent height. Overlay is a distinct behavior and must not be treated as an alias for FullWindow.

## FullWindow

FullWindow resolves a separate presentation host by walking the parent chain until a `TCommonCustomForm` is found. The popup is parented to that host, aligned client, and only the top-left/top-right corners are rounded. It contains the search header, virtualized result list, and empty state.

## Explicit overrides

When `PresentationMode` is not `Auto`, the resolver preserves it. This permits `Custom + Anchored`, `Custom + FullWindow`, or an explicitly requested mode under Desktop/Mobile. The explicit presentation decision takes precedence over the style default.

## Examples

```pascal
TRickUIBuilder.ComboBox
  .StyleType(TRickUIBuilderComboBoxStyleType.Mobile)
  .PresentationMode(TRickUIBuilderComboBoxPresentationMode.Auto)
  .Position(24, 80)
  .AddItem('Rio de Janeiro', 'RJ')
  .AddItem('Riviera de São Lourenço, SP', 'RIVIERA')
  .AddItem('Ribeirão Preto, SP', 'RAO')
  .SearchPlaceholder('Pesquisar cidade...')
  .NoResultsText('Nenhuma cidade encontrada')
  .Build(AParent);
```

```pascal
TRickUIBuilder.ComboBox
  .StyleType(TRickUIBuilderComboBoxStyleType.Custom)
  .PresentationMode(TRickUIBuilderComboBoxPresentationMode.FullWindow)
  .Column(TRickUIBuilderComboBoxColumn.Create(
    TRickUIBuilderComboBoxColumnSizeMode.Fixed, 86))
  .Column(TRickUIBuilderComboBoxColumn.Create(
    TRickUIBuilderComboBoxColumnSizeMode.Proportional, 1))
  .AddStructuredItem('Cliente ativo', 'ATV', ['ATV', 'Cliente ativo'])
  .AddStructuredItem('Cliente bloqueado', 'BLQ', ['BLQ', 'Cliente bloqueado'])
  .SearchPlaceholder('Pesquisar status...')
  .NoResultsText('Nenhum status encontrado')
  .Build(AParent);
```

## Maintenance constraints

Do not collapse Overlay and FullWindow into a single mode. Do not infer presentation from the current parent after style resolution. Keep `RequestedStyleType` and `EffectiveStyleType` distinct. Any change to Auto resolution must update style tests and the corresponding documentation.
