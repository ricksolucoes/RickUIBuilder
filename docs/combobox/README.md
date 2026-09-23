# ComboBox Technical Documentation

> [English](README.md) | [Português do Brasil](README.pt-BR.md)

## Overview

This directory is the technical reference for the RickUIBuilder ComboBox implementation. It documents the public API, internal unit responsibilities, presentation modes, filtering, virtualization, runtime lifetime, customization, tests, and maintenance constraints. The implementation is runtime-only FireMonkey UI: the closed control is created immediately, while selection surfaces are created lazily when needed.

## Architecture at a glance

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
TRickUIBuilderComboBoxPresentation
TRickUIBuilderComboBoxVirtualizer
```

The builder accumulates configuration and logical items. `Build` or `BuildHandle` resolves the style, creates the closed control through the factory, creates the data model and runtime handle, and attaches a behavior component that keeps the runtime alive while the visual tree exists.

## Documentation map

| Document | Purpose |
|---|---|
| [Architecture and dependencies](arquitetura-e-dependencias.md) | Unit boundaries, dependency direction, and architectural invariants. |
| [Public API and configuration](api-publica-e-configuracao.md) | Builder, handle, records, enums, defaults, and configuration semantics. |
| [Data, selection, and filtering](dados-selecao-e-filtro.md) | Item identity, selection, filter view, and index mapping. |
| [Presentation modes](presentation-modes.md) | `Auto`, `Anchored`, `Overlay`, and `FullWindow`. |
| [FullWindow and search](fullwindow-e-pesquisa.md) | Search UI, clear/back behavior, empty state, and host resolution. |
| [Virtualization and rendering](virtualizacao-e-renderizacao.md) | Row pool, columns, row state, and custom content. |
| [Lifecycle, ownership, and handle](lifecycle-ownership-e-handle.md) | Behavior lifetime, `FreeNotification`, detach rules, and non-owning references. |
| [Customization and examples](customizacao-e-exemplos.md) | Progressive usage examples based on the implemented API. |
| [Tests and contracts](testes-e-contratos.md) | Validated behavior and the current DUnitX baseline. |
| [Maintenance and pitfalls](manutencao-e-armadilhas.md) | Invariants that must be preserved during future changes. |

## Recommended reading paths

For API work, read **Public API and configuration** first. For filtering or selection changes, read **Data, selection, and filtering** plus **Virtualization and rendering**. For Mobile or FullWindow work, read **Presentation modes**, **FullWindow and search**, and **Lifecycle, ownership, and handle**. For ownership or destruction changes, read the lifecycle document before editing code.

## Public entry points

The public fluent entry point is `TRickUIBuilder.ComboBox`, which returns `IRickUIBuilderComboBox`. Runtime control after materialization is exposed through `IRickUIBuilderComboBoxHandle` when `BuildHandle` is used.

## Implementation invariants

- Public ComboBox types remain in `Rick.UIBuilder.Types.pas`.
- Public ComboBox interfaces remain in `Rick.UIBuilder.Interfaces.pas`.
- `Data` does not own or manipulate FMX controls.
- `Presentation` does not filter the logical item collection.
- `Virtualization` renders the current data view; it does not own the source collection.
- `FullWindow` reuses the same data and virtualizer used by the other presentation modes.
- `ViewIndex` and `SourceIndex` are distinct whenever a filter is active.
- The visual `TPath` is not the interaction target for Back/Clear; the containing hit area is.

## Validated baseline

The documented implementation is based on the state validated on 2026-09-22 by DUnitX: **197 tests found, 197 passed, 0 failed, 0 errored, 0 leaked**. This count is a baseline for this documented state, not a permanent project invariant.
