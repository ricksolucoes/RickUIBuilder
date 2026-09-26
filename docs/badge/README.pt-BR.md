# Documentação Técnica do Badge

> [English](README.md) | [Português do Brasil](README.pt-BR.md)

## Visão geral

`TRickUIBuilder.Badge` materializa um Badge composto por `TRectangle` + `TLabel` e retorna `IRickUIBuilderBadgeHandle`.

```text
TRickUIBuilder.Badge → Builder → Factory.CreateBadge
                                  ├─ TRectangle
                                  └─ TLabel
                         ↓
                  BadgeHandle (non-owning)
```

## Mapa

| Documento | Conteúdo |
|---|---|
| [API, configuração e handle](api-configuracao-e-handle.pt-BR.md) | Métodos, defaults, Pill/CornerRadius e Handle. |
| [Comportamento e exemplos](comportamento-e-exemplos.pt-BR.md) | Factory × Builder, layout e exemplos. |

## Invariantes

- A Factory cria inicialmente o container em formato pill (`Height / 2`).
- O Builder tem `Pill=False` por padrão e, nesse caso, substitui o raio pelo `CornerRadius` configurado (`0` por padrão).
- O Handle não possui os controles FMX.
- `Padding` é aplicado ao `TextLabel` interno.
