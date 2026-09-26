# Label — Comportamento e Exemplos

> [English](comportamento-e-exemplos.md) | [Português do Brasil](comportamento-e-exemplos.pt-BR.md)

## Exemplo básico

```pascal
TRickUIBuilder.Label_
  .Text('Título')
  .Position(24, 24)
  .Size(240, 32)
  .FontSize(18)
  .Bold
  .Build(Self);
```

## Layout e texto

```pascal
TRickUIBuilder.Label_
  .Text('Texto que pode ocupar mais de uma linha')
  .Position(20, 80)
  .Size(280, 64)
  .Margin(TRickUIBuilderSpacing.Create(8, 4, 0, 0))
  .Padding(TRickUIBuilderSpacing.Uniform(6))
  .WordWrap
  .Trimming(TTextTrimming.Character)
  .Build(Self);
```

Nesse exemplo a posição final é `(28, 84)`. O padding atua dentro dos `280 × 64`; ele não aumenta essas dimensões.

## Ownership

`Build(AParent)` passa `AParent` como Owner e Parent para a Factory. O lifetime do `TLabel` acompanha o Owner informado. O Builder não cria Handle nem serviço runtime adicional.
