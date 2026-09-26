# Divider — API and Examples

> [English](api-e-exemplos.md) | [Português do Brasil](api-e-exemplos.pt-BR.md)

## API and defaults

| Method | Default | Effect |
|---|---:|---|
| `Position` | `0,0` | Base position. |
| `Width` | `100` | Logical length. |
| `Thickness` | `1` | Thickness on the perpendicular axis. |
| `Orientation` | `TOrientation.Horizontal` | Sets direction. |
| `Margin` | zero | Adds `Left/Top` to position. |
| `Color` | `TAlphaColors.Lightgray` | Fill color. |
| `Opacity` | `1` | Final opacity. |
| `Visible` | `True` | Final visibility. |
| `Build` | — | Returns `TRectangle`. |

## Geometry

```text
Horizontal: Width = configured Width; Height = Thickness
Vertical:   Width = Thickness;        Height = configured Width
```

`Margin.Right/Bottom` do not participate in the current size or position calculation.

## Examples

```pascal
TRickUIBuilder.Divider
  .Position(24, 80)
  .Width(280)
  .Thickness(2)
  .Build(Self);

TRickUIBuilder.Divider
  .Position(320, 24)
  .Width(160)
  .Thickness(1)
  .Orientation(TOrientation.Vertical)
  .Build(Self);
```

## Factory

`TRickUIBuilderFactory.CreateDivider` receives `TRickUIBuilderDividerConfig` and initially creates a horizontal divider with `Height=1`. `Thickness`, `Orientation`, `Opacity`, and `Visible` are additional Fluent Builder features.

`Build(AParent)` uses `AParent` as both Owner and Parent of the `TRectangle`.
