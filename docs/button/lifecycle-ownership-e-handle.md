# Button — Lifecycle, Ownership, and Handle

> [English](lifecycle-ownership-e-handle.md) | [Português do Brasil](lifecycle-ownership-e-handle.pt-BR.md)

## Build and BuildHandle

Both call `BuildCore`. The flow creates `TRectangle` + `TLabel` through the Factory, applies additional state, and materializes Hover Behavior.

`Build(AParent)` returns only the `TRectangle`. `BuildHandle(AParent)` returns `IRickUIBuilderButtonHandle` with `Container`, `TextLabel`, and the same `HoverState` used by Behavior.

## Control ownership

The Fluent Builder calls the Factory using `AParent` as Owner and Parent of the container and as Owner of the label. The Handle is non-owning: releasing the interface does not free controls; keeping the interface alive does not keep controls alive.

## Hover lifetime

`HoverState.Build(AOwner)` creates `TRickUIBuilderButtonHoverBehavior` owned by `AOwner`. Behavior keeps `FState` as a strong interface reference, so state remains alive even if the caller releases its own reference.

The state does not own the Button. Behavior also does not change `TRectangle` ownership.

## Compatibility Handle

`TRickUIBuilderButtonHandle.New(Container, TextLabel)` remains available and produces a Handle with `HoverState=nil`. The overload used by `BuildHandle` also receives hover state.

## Usage rule

Do not use the Handle's `Container` or `TextLabel` after their Owner has been destroyed. The Handle does not automatically detect destruction of those controls.

## Independent Button destruction

`TRickUIBuilderButtonHoverBehavior` stores `FButton: TRectangle` and a strong `FState` interface reference. In the current implementation it does **not** call `FButton.FreeNotification(Self)` and does not override `Notification` to observe independent destruction of that Button. This differs from runtime components that explicitly monitor a visual container.

The normal Fluent Builder path creates the Button and the Hover Behavior with the same `AParent` ownership context, but direct/manual assembly must still respect the lifetime relationship: do not destroy the configured Button independently while a Behavior that references it can still receive events. This is a description of the current lifetime contract, not an ownership transfer by the Behavior.
