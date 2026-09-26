# Label — Behavior and Examples

> [English](comportamento-e-exemplos.md) | [Português do Brasil](comportamento-e-exemplos.pt-BR.md)

## Basic example

```pascal
TRickUIBuilder.Label_
  .Text('Title')
  .Position(24, 24)
  .Size(240, 32)
  .FontSize(18)
  .Bold
  .Build(Self);
```

## Layout and text

```pascal
TRickUIBuilder.Label_
  .Text('Text that may span more than one line')
  .Position(20, 80)
  .Size(280, 64)
  .Margin(TRickUIBuilderSpacing.Create(8, 4, 0, 0))
  .Padding(TRickUIBuilderSpacing.Uniform(6))
  .WordWrap
  .Trimming(TTextTrimming.Character)
  .Build(Self);
```

The final position is `(28, 84)`. Padding acts inside the `280 × 64` bounds; it does not increase them.

## Ownership

`Build(AParent)` passes `AParent` as both Owner and Parent to the Factory. The `TLabel` lifetime follows that Owner. The Builder creates no Handle or additional runtime service.
