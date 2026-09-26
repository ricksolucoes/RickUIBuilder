# Lifecycle, Ownership, and Handle

> [English](lifecycle-ownership-e-handle.md) | [Português do Brasil](lifecycle-ownership-e-handle.pt-BR.md)

## Source of truth

Read `Rick.UIBuilder.ComboBox.Handle.pas`, `Rick.UIBuilder.ComboBox.Behavior.pas`, `Rick.UIBuilder.ComboBox.Presentation.pas`, and `Rick.UIBuilder.ComboBox.Virtualization.pas` together before changing ownership or destruction behavior.

## Ownership model

The builder creates the logical data model and transfers practical lifetime responsibility to `TRickUIBuilderComboBoxHandle`, whose destructor frees `FData` and `FState`. The closed FMX controls are created with the caller-provided `AParent` as owner and parent. Visual references inside the handle are non-owning.

## Behavior component

`TRickUIBuilderComboBoxBehavior` is created with `AParent` as owner. It stores a strong `IRickUIBuilderComboBoxHandle` reference (`FLifetime`) and a `TRickUIBuilderBooleanProcedure` detach callback (`FDetachVisual`). `FLifetime` keeps the runtime handle alive when the caller uses `Build` without retaining the local handle interface returned internally by `BuildCore`; the callback only lets the behavior request visual detachment and does not replace that strong interface reference. The behavior therefore does not depend on the concrete `TRickUIBuilderComboBoxHandle` class.

## Build lifetime flow

```text
BuildCore
↓
Create Data
↓
Create Handle interface + implementation pointer
↓
Create closed FMX controls
↓
Create Behavior owned by AParent
↓
Behavior retains IRickUIBuilderComboBoxHandle
↓
Visual tree remains interactive after builder scope ends
```

## Handle attachment

`AttachVisual` stores non-owning parent/container/label/arrow references, configures container events, creates the behavior, then creates the search timer and presentation services using the behavior as lifetime owner/context. `IsAttached` is defined by whether `FContainer` is still assigned.

## Detachment

`DetachVisual` unhooks closed-control events, disables/frees the search timer, frees the virtualizer and presentation services, closes internal state when needed, and clears all non-owning visual references. It does not free the caller-owned closed visual controls.

## Container destruction notification

Behavior subscribes to `FContainer.FreeNotification`. When the container is removed, behavior invokes `FDetachVisual(False)` before clearing its container reference. Passing `False` avoids touching events on a container already in removal. When the behavior itself is destroyed while the container is still available, its destructor removes the free notification and invokes `FDetachVisual(True)`, allowing the handle to unhook the container events during normal owner-driven teardown.

## Presentation notifications

Presentation observes the anchor, original parent, and separate FullWindow host when applicable. Popup/scrollbox references are also tracked. During notification it clears affected raw references so later detach code does not dereference destroyed controls.

## FullWindow ownership nuance

The FullWindow popup is created with the behavior-side owner stored in `FOwner` but parented to the resolved presentation host. During detach, `Presentation` frees visuals only when the presentation host is still known. If the host is already being destroyed, it clears references and allows the FMX ownership/parent destruction path to complete without a second free.

## Virtualizer lifetime

The virtualizer is manually owned by the handle (`FreeAndNil(FVirtualizer)`). Its rows/spacer are owned by the scroll box. On scroll-box removal notification, the virtualizer clears references/pool metadata rather than freeing visual children that belong to the FMX tree.

## Handle after visual destruction

A retained `IRickUIBuilderComboBoxHandle` may outlive the visual tree. In that state `IsAttached = False`. Logical data remains owned by the handle until the interface is released, but UI operations that depend on attachment must not assume a live container.

## Change checklist

Before changing lifecycle code, validate at least: Build without retained handle; retained handle after parent destruction; popup open during parent destruction; FullWindow open during parent destruction; removal of unrelated sibling controls; normal open/close/reopen; and no double-free between owner, parent, presentation, and handle.
