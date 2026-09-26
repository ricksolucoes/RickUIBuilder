# Label — API and Configuration

> [English](api-e-configuracao.md) | [Português do Brasil](api-e-configuracao.pt-BR.md)

## Fluent API

| Method | Effect |
|---|---|
| `Text` | Sets `TLabel.Text`. |
| `Position` | Sets the base position. |
| `Size` | Sets `Width` and `Height`. |
| `Anchors` | Sets `TLabel.Anchors`. |
| `Margin` | Adds `Left/Top` to the base position. |
| `Padding` | Sets the internal `TLabel` padding. |
| `FontFamily`, `FontSize`, `FontColor` | Configure the font. |
| `Bold`, `Italic` | Add the corresponding font styles. |
| `Align`, `VerticalAlign` | Configure horizontal and vertical alignment. |
| `WordWrap`, `Trimming` | Configure text handling. |
| `Opacity`, `Visible`, `HitTest`, `Tag` | Configure final control state. |
| `Build` | Materializes and returns the `TLabel`. |

## Builder defaults

| Option | Default |
|---|---|
| `Text` | `''` |
| `Position` | `0, 0` |
| `Size` | `100, 25` |
| `Anchors` | `[]` |
| `Margin`, `Padding` | `TRickUIBuilderSpacing.None` |
| `FontFamily` | `''` |
| `FontSize` | `12` |
| `FontColor` | `TAlphaColors.Black` |
| `Bold`, `Italic` | `False` |
| `Align` | `TTextAlign.Leading` |
| `VerticalAlign` | `TTextAlign.Leading` |
| `WordWrap` | `False` |
| `Trimming` | `TTextTrimming.None` |
| `Opacity` | `1` |
| `Visible` | `True` |
| `HitTest` | `False` |
| `Tag` | `0` |

`TRickUIBuilderTextConfig.Default` supplies only the Factory baseline: position, size, font size/color, horizontal alignment, and bold. The remaining defaults belong to the Builder.

## Margin and Padding

The materialized position is `Position + Margin.Left/Top`. `Margin.Right` and `Margin.Bottom` do not participate in position or size calculations in this implementation. `Padding` is copied to `TLabel.Padding` without changing the outer dimensions.

## Factory

`TRickUIBuilderFactory.CreateText` is the direct alternative based on `TRickUIBuilderTextConfig`. It does not automatically provide the additional Fluent Builder options.
