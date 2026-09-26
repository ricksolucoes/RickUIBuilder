# Architecture and Dependencies

> [English](arquitetura-e-dependencias.md) | [Português do Brasil](arquitetura-e-dependencias.pt-BR.md)

## Scope and source of truth

This document describes the unit boundaries implemented by the ComboBox. Source of truth: `Rick.UIBuilder.pas`, `Rick.UIBuilder.Types.pas`, `Rick.UIBuilder.Interfaces.pas`, `Rick.UIBuilder.Factory.pas`, and all `Rick.UIBuilder.ComboBox*.pas` units.

## Dependency overview

```text
TRickUIBuilder.ComboBox
        ↓
TRickUIBuilderComboBoxBuilder
        ↓
TRickUIBuilderComboBoxConfig + TRickUIBuilderComboBoxData
        ↓
TRickUIBuilderFactory + TRickUIBuilderComboBoxHandle
        ↓
TRickUIBuilderComboBoxState
TRickUIBuilderComboBoxBehavior
TRickUIBuilderComboBoxPresentation
TRickUIBuilderComboBoxVirtualizer
```

The dependency direction is intentionally asymmetric. The data model is independent of FMX rendering. The handle coordinates state, presentation, data, and virtualization. Presentation materializes controls but delegates filtering and selection to the handle/data layers.

## Unit responsibilities

| Unit | Responsibility | Must not become |
|---|---|---|
| `Rick.UIBuilder.pas` | Framework facade; exposes `TRickUIBuilder.ComboBox`. | ComboBox implementation unit. |
| `Rick.UIBuilder.Types.pas` | Public enums, item/column/config records, default path constants. | Runtime state holder. |
| `Rick.UIBuilder.Interfaces.pas` | Public builder and handle contracts, customize-item callback type. | Implementation layer. |
| `Rick.UIBuilder.Factory.pas` | Creates the closed `TRectangle`, text label, and arrow path. | Popup or filtering service. |
| `Rick.UIBuilder.ComboBox.pas` | Fluent builder; resolves configuration and materializes the runtime graph. | Long-lived runtime controller. |
| `Rick.UIBuilder.ComboBox.Data.pas` | Source items, confirmed selection, filter text, filtered index view. | FMX rendering layer. |
| `Rick.UIBuilder.ComboBox.State.pas` | Open/close phase and transient target index. | Confirmed selection store. |
| `Rick.UIBuilder.ComboBox.Style.pas` | Resolves requested/effective style and `Auto` presentation. | Stateful runtime service. |
| `Rick.UIBuilder.ComboBox.Handle.pas` | Runtime coordinator for events, navigation, selection, search, and the services used by the materialized control. | Owner of the visual tree or lifetime observer. |
| `Rick.UIBuilder.ComboBox.Behavior.pas` | Owner-managed lifetime bridge; retains the handle interface, observes the visual container, and requests detach through a callback without depending on the concrete handle class. | Runtime coordinator or visual-tree owner. |
| `Rick.UIBuilder.ComboBox.Presentation.pas` | Lazy materialization and layout of Anchored, Overlay, and FullWindow surfaces. | Data filter implementation. |
| `Rick.UIBuilder.ComboBox.Virtualization.pas` | Row pool, viewport mapping, columns, visual states, custom slot. | Source collection owner. |

## Build-time dependency flow

```text
Consumer
↓
TRickUIBuilder.ComboBox
↓
Builder
↓
Style Resolver
↓
Data + Factory
↓
Handle + Behavior
↓
Presentation + Virtualizer (lazy when opened)
```

`TRickUIBuilderComboBoxBuilder.BuildCore` creates `TRickUIBuilderComboBoxData`, copies builder items into it, applies the initial selection, creates the handle, creates the closed visual control through `TRickUIBuilderFactory.CreateComboBox`, and then attaches runtime behavior.

## Runtime dependency flow

When the control opens, the handle asks `Presentation` to create/show the selection surface. After the presentation exposes its `TVertScrollBox`, the handle creates one `TRickUIBuilderComboBoxVirtualizer` for that surface. The virtualizer reads `Data.ViewCount` and `SourceIndexFromView` to bind rows.

## Public versus internal boundaries

Only types/interfaces in the centralized public units are part of the public contract. `Data`, `State`, `Style`, `Handle`, `Behavior`, `Presentation`, and `Virtualization` are implementation units. Future public capabilities should be added to the centralized contracts only when a real external consumer needs them.

## Architectural invariants

1. Do not create `Rick.UIBuilder.ComboBox.Types.pas` or `Rick.UIBuilder.ComboBox.Interfaces.pas`.
2. Do not implement a separate Mobile item engine; FullWindow reuses the same data model and virtualizer.
3. Do not move filtering into `Presentation`.
4. Do not store confirmed selection in `State`; confirmed selection belongs to `Data`.
5. Do not make `Virtualization` own `Data`.
6. Keep style resolution separate from presentation behavior.

## Impact guide

- Changing item identity or filtering impacts `Data`, `Handle`, `Virtualization`, and tests.
- Changing closed-control geometry impacts `Types`, builder overrides, `Factory`, `Handle` runtime arrow sizing, and tests.
- Changing FullWindow layout impacts `Presentation`, interaction tests, and manual Sample validation.
- Changing ownership/lifetime impacts `Handle`, `Behavior`, `Presentation`, `Virtualization`, and destruction tests.
