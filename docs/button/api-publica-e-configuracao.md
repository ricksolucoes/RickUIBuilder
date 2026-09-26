# Button — Public API and Configuration

> [English](api-publica-e-configuracao.md) | [Português do Brasil](api-publica-e-configuracao.pt-BR.md)

## Fluent API

| Group | Methods |
|---|---|
| Content/geometry | `Caption`, `Position`, `Size`, `Anchors`, `CornerRadius`, `Margin`, `Padding` |
| Appearance | `FillColor`, `BorderColor`, `BorderThickness`, `TextColor`, `FontFamily`, `FontSize`, `Bold`, `HoverFillColor` |
| State | `DisabledOpacity`, `Enabled`, `Cursor`, `Opacity`, `Visible`, `Tag` |
| Events | `OnClick`, `OnHover` |
| Materialization | `Build`, `BuildHandle` |

## Builder defaults

Position `0,0`, size `120×40`, `CornerRadius=16`, zero margin/padding, `Dodgerblue` fill, `Null` border, `BorderThickness=0`, `White` text, `FontFamily=''`, `FontSize=16`, `Bold=False`, no explicit hover color, `DisabledOpacity=0.45`, `Enabled=True`, `Cursor=crHandPoint`, `Opacity=1`, `Visible=True`, `Tag=0`, and nil events.

`TRickUIBuilderButtonConfig.Default` is smaller: it contains position, size, fill, border color, text color, tag, and font size. The remaining defaults belong to the Builder.

## Border

The Factory enables a solid border with thickness `2` when `BorderColor <> TAlphaColors.Null`. The Builder then replaces the thickness only when `BorderThickness > 0`. Therefore setting only `BorderColor` keeps the Factory thickness of `2`.

## Enabled and opacity

When `Enabled=True`, the container receives `Opacity`. When `Enabled=False`, it receives `DisabledOpacity`. The Builder also sets `TRectangle.Enabled` to the configured value.

## Margin and Padding

`Margin.Left/Top` are added to `Position`. `Padding` is applied to the internal caption `TLabel` and does not resize the container.

## Factory vs Builder

`TRickUIBuilderFactory.CreateButton` materializes `TRectangle` + `TLabel` from `TRickUIBuilderButtonConfig`. The Fluent Builder adds anchors, radius, margin/padding, font family/bold, border thickness, enabled/opacity/cursor/visible, events, and the entire hover subsystem.
