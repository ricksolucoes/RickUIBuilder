# Data, Selection, and Filtering

> [English](dados-selecao-e-filtro.md) | [Português do Brasil](dados-selecao-e-filtro.pt-BR.md)

## Source of truth

`Rick.UIBuilder.ComboBox.Data.pas` owns logical items, confirmed selection, filter text, and the mapping between filtered view indexes and source indexes. It contains no FMX visual controls.

## Item identity

A logical item is `TRickUIBuilderComboBoxItem` with `DisplayText`, `Value`, and optional `Columns`. `Value` is not required to be unique. `DisplayText` may also be duplicated. The stable identity used by the implementation is the source index in the current item array/list.

## Confirmed selection

`FItemIndex` stores the confirmed source index. `-1` means no selection. `SelectedText` and `SelectedValue` return empty strings when no valid source index is selected. `SelectIndex` accepts `-1` or a valid source index; invalid indexes do not change the current selection.

## SelectText behavior

`TrySelectText` performs a case-insensitive exact comparison with `DisplayText` and selects the first match. If no match exists, it returns `False` and preserves the current confirmed selection.

## Incremental prefix search

`FindPrefix` is separate from FullWindow filtering. It is used by keyboard incremental search in the runtime handle. The handle accumulates typed characters in a search buffer and resets that buffer after `SearchTimeout` (900 ms by default).

## Filtered view

```text
Source Items
    ↓
FilterText
    ↓
FilteredIndexes
    ↓
ViewIndex
    ↓
SourceIndex
```

When `FilterText` is empty, `ViewCount = Count` and `SourceIndexFromView(N) = N`. When a filter is active, `FFilteredIndexes` contains source indexes whose `DisplayText` satisfies `ContainsText(DisplayText, FilterText)`. This is case-insensitive substring matching through `System.StrUtils.ContainsText`.

## Index mapping example

```text
SourceIndex  DisplayText
0            Rio de Janeiro
1            São Paulo
2            Riviera
3            Salvador

FilterText = "ri"

ViewIndex    SourceIndex
0            0
1            2
```

Selection remains source-index based. A row representing `ViewIndex = 1` in this filtered example stores `Tag = 2`, and row confirmation selects source item 2.

## Filter mutation rules

`SetFilterText` stores the new text and rebuilds filtered indexes. `ClearFilter` clears only filter state. `Add` and both `AddRange` overloads rebuild the filtered index list when a filter is active. Filtering never removes, copies, or reorders `FItems`.

## Selection and filtering interaction

A confirmed source selection may be absent from the current filtered view. `Handle.UpdateTargetFromView` keeps the confirmed selection as target when it is visible; otherwise it targets the first visible source item, or `-1` when the view is empty. This changes only the transient target, not the confirmed `ItemIndex`.

## Maintenance constraints

Do not replace source-index selection with view-index selection. Do not mutate `FItems` to implement a filter. Do not use `Value` as a uniqueness key. Any change to matching semantics requires coordinated updates to data tests, FullWindow search tests, and selection/virtualization behavior.
