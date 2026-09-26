# Badge — API, Configuration, and Handle

> [English](api-configuracao-e-handle.md) | [Português do Brasil](api-configuracao-e-handle.pt-BR.md)

## API

| Method | Effect |
|---|---|
| `Text`, `Position`, `Size` | Content and geometry. |
| `Pill` | When `True`, preserves the pill radius created by the Factory. |
| `CornerRadius` | Radius used when `Pill=False`. |
| `Margin` | Adds `Left/Top` to the base position. |
| `Padding` | Sets `TextLabel` padding. |
| `BackgroundColor`, `TextColor`, `BorderColor` | Badge colors. |
| `FontSize`, `Bold` | Text typography. |
| `Opacity`, `Visible`, `Tag` | Final container state. |
| `Build` | Returns `IRickUIBuilderBadgeHandle`. |

## Builder defaults

`Text=''`, position `0,0`, size `80×25`, `Pill=False`, `CornerRadius=0`, zero margin/padding, `Lightgray` background, `Black` text, `Null` border, `FontSize=12`, `Bold=False`, `Opacity=1`, `Visible=True`, `Tag=0`.

## Pill versus CornerRadius

The direct Factory uses `XRadius=YRadius=Height/2`. The Builder preserves that shape only when `Pill=True`. With `Pill=False`, it replaces both radii with `CornerRadius`.

## Border

`BorderColor=TAlphaColors.Null` keeps the stroke disabled. When a color is supplied, the Builder enables `Stroke.Kind=Solid` and applies the color. Badge currently exposes no public `BorderThickness`.

## Handle

`IRickUIBuilderBadgeHandle` exposes `Container: TRectangle` and `TextLabel: TLabel`. The Handle is a post-Build access reference; it does not assume ownership or extend the controls' lifetime.
