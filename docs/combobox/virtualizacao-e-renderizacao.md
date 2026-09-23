# Virtualization and Rendering

> [English](virtualizacao-e-renderizacao.md) | [Português do Brasil](virtualizacao-e-renderizacao.pt-BR.md)

## Source of truth

`Rick.UIBuilder.ComboBox.Virtualization.pas` implements the row pool and rendering pipeline. It receives a `TVertScrollBox`, a non-owning `TRickUIBuilderComboBoxData` reference, and a copy of `TRickUIBuilderComboBoxConfig`.

## Why virtualization exists

The number of logical items may exceed the number of visible rows. The virtualizer creates only enough row rectangles for the viewport plus a small buffer: `Ceil(ScrollBox.Height / ItemHeight) + 2`, capped by `Data.ViewCount`. Rows are rebound as the viewport changes.

## Visual pool ownership

Rows and the spacer are created with the `TVertScrollBox` as owner/parent. The virtualizer stores non-owning references to them and clears event handlers/references during detach/destruction. It does not manually free rows when the scroll box owns the visual tree.

## Render pipeline

```text
ResetRow
→ BindRow
→ BuildTextCells
→ CreateCustomSlot (when configured)
→ ApplyRowState
→ Display
```

`ResetRow` hides the row, resets `Tag`, restores the popup color, and frees existing child content. `BindRow` resolves `SourceIndexFromView`, stores the source index in `Row.Tag`, positions the row using the view index, builds text/columns, optionally creates the custom slot, and makes the row visible. `Refresh` then applies selected/target colors.

## View index versus source index

The row Y position is based on the view index because the filtered view controls order/visibility. The row `Tag` is the source index because selection, hover state, and callbacks operate on source identity. This distinction is mandatory when filters are active.

## Content height

A transparent spacer is positioned at `ViewCount * ItemHeight - 1` so the scroll box exposes the correct virtual content extent without materializing one control per item.

## Simple text rendering

When no usable structured columns exist, one client-aligned `TLabel` is created using config font, color, alignment, trimming, and horizontal padding. For effective Mobile style, the renderer intentionally uses simple `DisplayText` even when structured columns are present.

## Structured columns

Visible columns are processed in order. `Fixed` consumes its configured width. `Proportional` receives a weighted share of remaining width. `Auto` receives one unit of flexible weight. Missing `Item.Columns[N]` values render as empty strings. Column visibility and alignment are taken from `TRickUIBuilderComboBoxColumn`.

## Custom slot

When `OnCustomizeItem` is assigned, the virtualizer creates a client-aligned `TLayout` under the row and calls the callback with the **source index**, item record, and custom container. The callback-created controls should use that container as owner/parent. The slot itself has `HitTest = False` so the row remains the click target.

## Visual states

Selected source index uses `SelectedColor`. Target source index uses `HoverColor`. Other rows use `PopupColor`. Mouse enter uses hover color unless the row is selected; mouse leave reapplies the selected/target/default state.

## EnsureIndexVisible

The method first converts the source index to the current view index. If the source item is filtered out, no scroll occurs. Otherwise the viewport is adjusted only when the row lies above or below the visible viewport.

## Example

```pascal
LCodeColumn := TRickUIBuilderComboBoxColumn.Create(
  TRickUIBuilderComboBoxColumnSizeMode.Fixed, 90);
LDescriptionColumn := TRickUIBuilderComboBoxColumn.Create(
  TRickUIBuilderComboBoxColumnSizeMode.Proportional, 1);

TRickUIBuilder.ComboBox
  .Column(LCodeColumn)
  .Column(LDescriptionColumn)
  .AddStructuredItem('Notebook Core i7', '001', ['001', 'Notebook Core i7'])
  .AddStructuredItem('Monitor 27', '002', ['002', 'Monitor 27'])
  .SelectedText('Monitor 27')
  .Build(AParent);
```

```pascal
procedure TFormMain.CustomizeComboBoxItem(Sender: TObject; AIndex: Integer;
  const AItem: TRickUIBuilderComboBoxItem; AContainer: TControl);
var
  LBadge: TRectangle;
begin
  LBadge := TRectangle.Create(AContainer);
  LBadge.Parent := AContainer;
  LBadge.Align := TAlignLayout.Right;
  LBadge.Width := 72;
  LBadge.HitTest := False;
end;
```
