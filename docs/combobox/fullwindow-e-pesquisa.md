# FullWindow and Search

> [English](fullwindow-e-pesquisa.md) | [Português do Brasil](fullwindow-e-pesquisa.pt-BR.md)

## Source of truth

`Rick.UIBuilder.ComboBox.Presentation.pas` materializes the FullWindow visual tree. `Rick.UIBuilder.ComboBox.Handle.pas` owns the search/clear/back behavior. `Rick.UIBuilder.ComboBox.Data.pas` owns the actual filter state.

## Visual tree

```text
FullWindow Popup
│
├── Header
│   └── SearchField
│       ├── BackHitArea
│       │   └── BackPath
│       ├── SearchEdit
│       └── ClearHitArea
│           └── ClearPath
│
├── TVertScrollBox
│
└── EmptyState
    ├── EmptyPath
    └── EmptyLabel
```

The FullWindow popup is created lazily on first open. It is aligned to the resolved presentation host rather than to the anchor parent.

## Anchor parent and presentation host

The closed control remains attached to the caller-provided parent. FullWindow walks that parent chain and uses the first `TCommonCustomForm` as the presentation host. This prevents a FullWindow surface from being constrained to a nested `TVertScrollBox`/`TScrollContent` hierarchy.

## Search field composition

`SearchField` is the visual frame (`TRectangle`). `SearchEdit` is the editing control. The edit uses `ControlType = Styled`, `StyleLookup = transparentedit`, and `DisableFocusEffect = True`. `SearchField.ClipChildren = True` prevents styled edit content from painting outside the rounded field.

## Back and Clear hit areas

`BackPath` and `ClearPath` are visual-only (`HitTest = False`). Their containing `TLayout` controls receive the click handlers. Hit-area width is `SearchFieldHeight`, while the icon itself uses `SearchIconSize`; therefore the touch/click target can be larger than the glyph.

## Search flow

```text
SearchEdit
↓
OnChangeTracking
↓
Handle.SearchChanged
↓
Data.SetFilterText
↓
Filtered View
↓
UpdateTargetFromView
↓
Virtualizer.Refresh
↓
Presentation.UpdateResultState
```

`SearchChanged` first synchronizes Clear visibility, then updates `Data.FilterText`, updates the transient target according to the filtered view, and refreshes presentation/virtualization. The source collection remains unchanged.

## Clear visibility contract

```text
Length(SearchEdit.Text) = 0
→ ClearHitArea.Visible = False
→ ClearHitArea.HitTest = False

Length(SearchEdit.Text) > 0
→ ClearHitArea.Visible = True
→ ClearHitArea.HitTest = True
```

The implementation uses `Length(SearchEdit.Text) > 0`, not `Trim`. A single space therefore counts as content and keeps the Clear hit area visible.

## Clear click behavior

`Handle.ClearSearchClick` calls `Presentation.ResetSearch`, clears `Data.FilterText`, recalculates the target, and refreshes the popup. It does not clear confirmed selection, does not fire `OnChange` unless a selection actually changes elsewhere, does not close FullWindow, and does not rebuild the control.

## Back behavior

The Back hit area delegates to `Handle.DismissClick`, which calls `Close`. Closing hides the presentation and restores the closed-arrow state; it does not confirm a transient target. Confirmed `ItemIndex`, `SelectedText`, and `SelectedValue` remain unchanged.

## Empty state

`Presentation.UpdateResultState(ViewCount)` shows the result `TVertScrollBox` when `ViewCount > 0` and shows `EmptyState` when `ViewCount = 0`. The empty state contains `NoResultsPath` and `NoResultsText`, styled with the corresponding config colors and icon size.

## Keyboard behavior inside SearchEdit

While FullWindow is open, the edit-specific key handler processes Up, Down, PageUp, PageDown, Enter, Escape, and Tab. Other keys are left to the edit. Enter confirms the current target; Escape/Tab close. Home/End and Space are intentionally not consumed by the edit-specific handler.

## Reopen behavior

`Handle.Open` calls `ResetFullWindowFilter` before materializing/refreshing the presentation. FullWindow therefore reopens with empty search text and the full data view, while preserving confirmed selection.

## Example

```pascal
TRickUIBuilder.ComboBox
  .StyleType(TRickUIBuilderComboBoxStyleType.Mobile)
  .PresentationMode(TRickUIBuilderComboBoxPresentationMode.Auto)
  .Position(24, 80)
  .AddItem('Rio de Janeiro', 'RJ')
  .AddItem('Riviera de São Lourenço, SP', 'RIVIERA')
  .AddItem('Ribeirão Preto, SP', 'RAO')
  .SearchPlaceholder('Pesquisar cidade...')
  .NoResultsText('Nenhuma cidade encontrada')
  .Build(AParent);
```
