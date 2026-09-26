# Button — Customização e Exemplos

> [English](customizacao-e-exemplos.md) | [Português do Brasil](customizacao-e-exemplos.pt-BR.md)

## Button básico

```pascal
TRickUIBuilder.Button
  .Caption('Salvar')
  .Position(24, 24)
  .Size(140, 40)
  .OnClick(ButtonClick)
  .Build(Self);
```

## Borda e tipografia

```pascal
TRickUIBuilder.Button
  .Caption('Continuar')
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
  .Caption('Abrir')
  .FillColor(TAlphaColors.Dodgerblue)
  .HoverFillColor(TAlphaColors.Royalblue)
  .OnHover(ButtonEnter, ButtonLeave)
  .Build(Self);
```

## Handle e alteração runtime

```pascal
LHandle := TRickUIBuilder.Button
  .Caption('Salvar')
  .HoverFillColor(TAlphaColors.Royalblue)
  .BuildHandle(Self);

LHandle.TextLabel.Text := 'Salvo';
LHandle.HoverState.HoverFillColor(TAlphaColors.Cornflowerblue);
```

A nova cor será usada no próximo `MouseEnter`; o setter do estado não repinta imediatamente.

## Button desabilitado

```pascal
TRickUIBuilder.Button
  .Caption('Indisponível')
  .Enabled(False)
  .DisabledOpacity(0.35)
  .Build(Self);
```

Nesse caso a opacidade final é `DisabledOpacity`, não `Opacity`.
