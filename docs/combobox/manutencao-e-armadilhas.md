# Maintenance and Pitfalls

> [English](manutencao-e-armadilhas.md) | [Português do Brasil](manutencao-e-armadilhas.pt-BR.md)

## Purpose

Read this document before changing ComboBox internals. It records constraints that are easy to violate because several layers share indexes, FMX objects, and runtime events.

## Do not repeat resolved mistakes

- Do not treat filtered `ViewIndex` as the confirmed source `ItemIndex`.
- Do not implement filtering by deleting/reordering `FItems`.
- Do not create a separate Mobile list renderer.
- Do not turn Overlay into FullWindow.
- Do not assume the anchor parent is the FullWindow host.
- Do not put the interaction contract on the exact `TPath` geometry for Back/Clear.
- Do not use `Trim` for Clear visibility; the contract is `Length(Text) > 0`.
- Do not add guard clauses that merely hide a missing mandatory object; fix creation/lifetime when the object is required.
- Do not double-free FMX children that are already owner/parent managed.

## Index discipline

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

`ViewIndex` is an index into the current filtered/unfiltered view. `SourceIndex` identifies the logical item in `FItems`. Rows store source index in `Tag`; row Y position is based on view index. Selection APIs expose source index.

## Selection versus target

Confirmed selection lives in `Data.FItemIndex`. Keyboard/hover navigation while open uses `State.TargetIndex`. Moving the target must not fire `OnChange`. `ConfirmTarget` selects the target and then closes; Back/Escape can close without confirming the target.

## TPathData is not textual identity

Assigning SVG/path text to `TPathData.Data` parses it. Reading `Data` may return a canonical serialization rather than the original input string. For tests, normalize both expected and actual data through `TPathData`, or use another semantic identifier. Do not compare raw input text to serialized `Data` and assume equality.

## Path hit targets

Back/Clear paths use `HitTest = False`. Their `TLayout` parents own click behavior. This is required so the entire reserved touch/click area is interactive instead of only the visible glyph geometry.

## Search edit styling

The edit is embedded inside the rounded search rectangle. `transparentedit`, disabled focus effect, and `SearchField.ClipChildren = True` are part of the current visual integration. Changing edit style can reintroduce native underline/background drawing or overflow beyond the rounded field.

## Lifecycle and FreeNotification

Raw FMX references must be invalidated on component removal. Behavior, Presentation, and Virtualizer each observe different objects. Before changing destruction order, map owner, parent, FreeNotification source, and manual-free responsibility for every affected object.

## Build versus BuildHandle

Do not remove the behavior-held lifetime interface just because `BuildHandle` exists. `Build` intentionally works without the caller retaining a handle. Conversely, do not make the handle own the visual tree; retained handles are allowed to become detached.

## Style versus presentation

Style resolution may change height/item height/arrow size defaults. Presentation determines surface placement. Explicit builder overrides for selected geometry are restored after style resolution. Keep these mechanisms separate to avoid style changes unexpectedly changing explicit consumer values.

## Virtualization changes

Any row-pool change must preserve source-index `Tag`, filtered view mapping, `EnsureIndexVisible`, selected/target visual states, callback source index, and scroll content height. Test with lists larger than the viewport and with filters applied after scrolling.

## Documentation and test update rule

When changing a documented contract, update the implementation, DUnitX coverage, and the corresponding EN/pt-BR document pair in the same change. Keep headings/examples structurally equivalent between languages.

## Pre-change checklist

1. Identify the owning layer for the behavior being changed.
2. Read the corresponding document pair and source units.
3. Review current tests that protect that behavior.
4. Preserve index and ownership invariants.
5. Run the focused ComboBox tests, then the full suite.
6. Validate target-platform visuals when presentation/style changes.
7. Update both language documents before delivery.
