# Button — Hover and Behavior

> [English](hover-e-comportamento.md) | [Português do Brasil](hover-e-comportamento.pt-BR.md)

## Responsibility split

`TRickUIBuilderButtonHoverState` stores live configuration. `TRickUIBuilderButtonHoverBehavior`, a `TComponent`, executes `MouseEnter/MouseLeave` and keeps a strong reference to the state interface.

## Public state

`IRickUIBuilderButtonHoverState` exposes setters/getters for `Button`, `FillColor`, `HoverFillColor`, `OnEnter`, and `OnLeave`, plus `HasHoverFillColor` and `Build(AOwner)`.

## MouseEnter

When `HasHoverFillColor=True`, Behavior applies the current `HoverFillColor` to `FButton`, then reads and invokes the current `OnEnter` handler.

## MouseLeave

When a hover color exists, Behavior restores the current `FillColor`, then reads and invokes the current `OnLeave` handler.

## Post-Build mutability

Behavior reads state on every event. Later changes to `FillColor`, `HoverFillColor`, `OnEnter`, and `OnLeave` therefore affect subsequent events without rebuilding. Setters do not repaint immediately: colors are consumed by the next corresponding event.

`Button(AValue)` is different: Behavior stores the `TRectangle` received by `Configure`. Changing `HoverState.Button` after `Build` does not retarget that Behavior.

## Builder

`HoverFillColor` and `OnHover` configure the same state used by Behavior. Even without an explicit hover color, the state is created and `OnHover` callbacks can run; color switching only happens when `HasHoverFillColor=True`.
