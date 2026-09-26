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
