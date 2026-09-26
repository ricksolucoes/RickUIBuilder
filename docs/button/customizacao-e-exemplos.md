# Button — Customization and Examples

> [English](customizacao-e-exemplos.md) | [Português do Brasil](customizacao-e-exemplos.pt-BR.md)

## Basic Button

```pascal
TRickUIBuilder.Button
  .Caption('Save')
  .Position(24, 24)
  .Size(140, 40)
  .OnClick(ButtonClick)
  .Build(Self);
```

## Border and typography

```pascal
TRickUIBuilder.Button
  .Caption('Continue')
  .BorderColor(TAlphaColors.Gray)
  .BorderThickness(1)
  .CornerRadius(8)
  .FontSize(14)
  .Bold
  .Build(Self);
```

## Hover

```pascal
TRickUIBuilder.Button
  .Caption('Open')
  .FillColor(TAlphaColors.Dodgerblue)
  .HoverFillColor(TAlphaColors.Royalblue)
  .OnHover(ButtonEnter, ButtonLeave)
  .Build(Self);
```

## Handle and runtime update

```pascal
LHandle := TRickUIBuilder.Button
  .Caption('Save')
  .HoverFillColor(TAlphaColors.Royalblue)
  .BuildHandle(Self);

LHandle.TextLabel.Text := 'Saved';
LHandle.HoverState.HoverFillColor(TAlphaColors.Cornflowerblue);
```

The new color is used on the next `MouseEnter`; the state setter does not repaint immediately.

## Disabled Button

```pascal
TRickUIBuilder.Button
  .Caption('Unavailable')
  .Enabled(False)
  .DisabledOpacity(0.35)
  .Build(Self);
```

In this case final opacity is `DisabledOpacity`, not `Opacity`.
