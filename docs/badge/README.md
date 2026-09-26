# Badge Technical Documentation

> [English](README.md) | [Português do Brasil](README.pt-BR.md)

## Overview

`TRickUIBuilder.Badge` materializes a Badge composed of `TRectangle` + `TLabel` and returns `IRickUIBuilderBadgeHandle`.

```text
TRickUIBuilder.Badge → Builder → Factory.CreateBadge
                                  ├─ TRectangle
                                  └─ TLabel
                         ↓
                  BadgeHandle (non-owning)
```

## Documentation map

| Document | Content |
|---|---|
| [API, configuration, and handle](api-configuracao-e-handle.md) | Methods, defaults, Pill/CornerRadius, and Handle. |
| [Behavior and examples](comportamento-e-exemplos.md) | Factory vs Builder, layout, and examples. |

## Invariants

- The Factory initially creates a pill-shaped container (`Height / 2`).
- The Builder defaults to `Pill=False` and then replaces the radius with configured `CornerRadius` (`0` by default).
- The Handle does not own the FMX controls.
- `Padding` is applied to the internal `TextLabel`.
