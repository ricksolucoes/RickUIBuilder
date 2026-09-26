# Button Technical Documentation

> [English](README.md) | [Português do Brasil](README.pt-BR.md)

## Overview

Button is a composed control with runtime hover behavior separated from its configurable state.

```text
TRickUIBuilder.Button → Builder → Factory.CreateButton → TRectangle + TLabel
                           └→ HoverState → HoverBehavior
                           └→ BuildHandle → ButtonHandle
```

## Documentation map

| Document | Content |
|---|---|
| [Public API and configuration](api-publica-e-configuracao.md) | Fluent API, defaults, and Factory vs Builder. |
| [Hover and behavior](hover-e-comportamento.md) | Live state, events, and post-Build mutability. |
| [Lifecycle, ownership, and handle](lifecycle-ownership-e-handle.md) | `Build`, `BuildHandle`, ownership, and lifetime. |
| [Customization and examples](customizacao-e-exemplos.md) | Progressive examples. |

## Invariants

- `Build` and `BuildHandle` use the same `BuildCore`.
- Behavior reads the current `FillColor`, `HoverFillColor`, `OnEnter`, and `OnLeave` on every event.
- Changing `HoverState.Button` after Build does not retarget an existing Behavior.
- The Handle is non-owning with respect to FMX controls.
- Direct Factory creation does not add the Fluent Builder hover subsystem.

## Maintenance map

| Change | Read first |
|---|---|
| Fluent API/configuration | `src/Rick.UIBuilder.Button.pas`, `src/Rick.UIBuilder.Interfaces.pas`, and `src/Rick.UIBuilder.Types.pas` when shared config is affected |
| Hover state/events | `src/Rick.UIBuilder.Button.HoverState.pas`, `src/Rick.UIBuilder.Button.HoverBehavior.pas`, `src/Rick.UIBuilder.Button.pas`, and [Hover and behavior](hover-e-comportamento.md) |
| Handle/lifetime | `src/Rick.UIBuilder.Button.Handle.pas`, HoverState/Behavior, and [Lifecycle, ownership, and handle](lifecycle-ownership-e-handle.md) |
| Factory materialization | `src/Rick.UIBuilder.Factory.pas` and [Public API and configuration](api-publica-e-configuracao.md) |
| Contract regression | `tests/src/Rick.UIBuilder.Tests.Button.pas` |

## Tested contracts

The current DUnitX fixture `tests/src/Rick.UIBuilder.Tests.Button.pas` covers fluent chaining, visual materialization, click/hover behavior, enabled opacity, margin, `BuildHandle`, non-owning Handle behavior, live post-Build changes to `FillColor`, `HoverFillColor`, `OnEnter` and `OnLeave`, non-retargeting after changing `HoverState.Button`, and hover behavior remaining active after external Handle/state references are released. This is the current test baseline, not a guarantee of future behavior by itself.
