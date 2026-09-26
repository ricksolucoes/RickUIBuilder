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

## Maintenance map

| Change | Read first |
|---|---|
| Fluent API or shape semantics | `src/Rick.UIBuilder.Badge.pas`, `src/Rick.UIBuilder.Interfaces.pas` |
| Factory materialization/default shape | `src/Rick.UIBuilder.Factory.pas`, `src/Rick.UIBuilder.Types.pas`, and [Behavior and examples](comportamento-e-exemplos.md) |
| Handle/lifetime | `src/Rick.UIBuilder.Badge.Handle.pas` and [API, configuration, and handle](api-configuracao-e-handle.md) |
| Contract regression | `tests/src/Rick.UIBuilder.Tests.Badge.pas` |

## Tested contracts

The current DUnitX fixture `tests/src/Rick.UIBuilder.Tests.Badge.pas` covers fluent chaining, Handle/container/label materialization, Parent relationships, text and position, `Margin`, `Pill=True`, `Pill=False` with `CornerRadius`, background/border behavior, and `Tag`. This records current coverage only.
