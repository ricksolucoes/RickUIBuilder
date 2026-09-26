# Badge — Comportamento e Exemplos

> [English](comportamento-e-exemplos.md) | [Português do Brasil](comportamento-e-exemplos.pt-BR.md)

## Badge retangular

```pascal
LBadge := TRickUIBuilder.Badge
  .Text('NOVO')
  .Position(24, 24)
  .Size(88, 28)
  .CornerRadius(6)
  .BackgroundColor(TAlphaColors.Lightgray)
  .Build(Self);
```

## Badge pill

```pascal
LBadge := TRickUIBuilder.Badge
  .Text('3')
  .Size(40, 24)
  .Pill
  .Build(Self);
```

## Atualização pós-Build

```pascal
LBadge.TextLabel.Text := '4';
LBadge.Container.Opacity := 0.8;
```

O Handle fornece acesso direto aos controles já materializados; essas alterações não passam novamente pelo Builder.

## Factory × Builder

`TRickUIBuilderFactory.CreateBadge` usa `TRickUIBuilderBadgeConfig` e cria o formato pill inicialmente. O Fluent Builder adiciona `Pill/CornerRadius`, margin, padding, borda, bold, opacity, visibility e tag. Portanto, os dois caminhos não devem ser tratados como APIs equivalentes.

## Ownership

No Fluent Builder, `AParent` é usado como Owner/Parent na criação. O Handle é non-owning e só deve ser usado enquanto os controles correspondentes estiverem vivos.
