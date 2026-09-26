# Badge — Behavior and Examples

> [English](comportamento-e-exemplos.md) | [Português do Brasil](comportamento-e-exemplos.pt-BR.md)

## Rectangular Badge

```pascal
LBadge := TRickUIBuilder.Badge
  .Text('NEW')
  .Position(24, 24)
  .Size(88, 28)
  .CornerRadius(6)
  .BackgroundColor(TAlphaColors.Lightgray)
  .Build(Self);
```

## Pill Badge

```pascal
LBadge := TRickUIBuilder.Badge
  .Text('3')
  .Size(40, 24)
  .Pill
  .Build(Self);
```

## Post-Build updates

```pascal
LBadge.TextLabel.Text := '4';
LBadge.Container.Opacity := 0.8;
```

The Handle provides direct access to already materialized controls; these changes do not go through the Builder again.

## Factory vs Builder

`TRickUIBuilderFactory.CreateBadge` uses `TRickUIBuilderBadgeConfig` and initially creates the pill shape. The Fluent Builder adds `Pill/CornerRadius`, margin, padding, border, bold, opacity, visibility, and tag. The two paths are therefore not equivalent APIs.

## Ownership

In the Fluent Builder, `AParent` is used as Owner/Parent during creation. The Handle is non-owning and must only be used while the corresponding controls are alive.
