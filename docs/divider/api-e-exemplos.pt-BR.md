# Divider — API e Exemplos

> [English](api-e-exemplos.md) | [Português do Brasil](api-e-exemplos.pt-BR.md)

## API e defaults

| Método | Default | Efeito |
|---|---:|---|
| `Position` | `0,0` | Posição-base. |
| `Width` | `100` | Comprimento lógico. |
| `Thickness` | `1` | Espessura no eixo perpendicular. |
| `Orientation` | `TOrientation.Horizontal` | Define a direção. |
| `Margin` | zero | Soma `Left/Top` à posição. |
| `Color` | `TAlphaColors.Lightgray` | Cor do fill. |
| `Opacity` | `1` | Opacidade final. |
| `Visible` | `True` | Visibilidade final. |
| `Build` | — | Retorna `TRectangle`. |

## Geometria

```text
Horizontal: Width = Width configurado; Height = Thickness
Vertical:   Width = Thickness;        Height = Width configurado
```

`Margin.Right/Bottom` não participam do cálculo de tamanho ou posição atual.

## Exemplos

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

`TRickUIBuilderFactory.CreateDivider` recebe `TRickUIBuilderDividerConfig` e cria inicialmente um divisor horizontal com `Height=1`. `Thickness`, `Orientation`, `Opacity` e `Visible` são recursos adicionais aplicados pelo Fluent Builder.

`Build(AParent)` usa `AParent` como Owner e Parent do `TRectangle`.
