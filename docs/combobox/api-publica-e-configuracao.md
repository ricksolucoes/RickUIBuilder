# Public API and Configuration

> [English](api-publica-e-configuracao.md) | [Português do Brasil](api-publica-e-configuracao.pt-BR.md)

## Source of truth

Public contracts are defined in `Rick.UIBuilder.Interfaces.pas` and `Rick.UIBuilder.Types.pas`. The fluent implementation is in `Rick.UIBuilder.ComboBox.pas`. The facade entry point is `TRickUIBuilder.ComboBox`.

## Builder entry point

```pascal
TRickUIBuilder.ComboBox
  .Position(24, 80)
  .Size(320, 42)
  .Items(['Small', 'Medium', 'Large'])
  .ItemIndex(0)
  .Build(AParent);
```

Every call to `TRickUIBuilder.ComboBox` returns a new independent builder instance. The builder accumulates state until `Build` or `BuildHandle` is called.

## IRickUIBuilderComboBox

| Group | Methods | Effect |
|---|---|---|
| Geometry | `Position`, `Size`, `ItemHeight`, `PopupMaxHeight`, `PopupWidthOffset` | Configures closed control and selection surface sizing. |
| Data | `Items`, `AddItem`, `AddStructuredItem`, `Column` | Defines logical items and optional structured columns. |
| Initial selection | `ItemIndex`, `SelectedText` | Chooses the initial confirmed selection. |
| Style/presentation | `StyleType`, `CustomConfig`, `PresentationMode` | Selects style profile and presentation behavior. |
| Arrow | `ArrowColor`, `ArrowSize`, `ArrowPosition`, `ArrowMargins`, `ClosedArrowPath`, `OpenedArrowPath` | Configures the closed-control arrow. |
| FullWindow | `SearchPlaceholder`, `NoResultsText`, `BackPath`, `ClearPath`, `NoResultsPath` | Configures search and empty-state content. |
| State/events | `Enabled`, `OnChange`, `OnOpen`, `OnClose`, `OnCustomizeItem` | Enables behavior and hooks runtime callbacks. |
| Materialization | `Build`, `BuildHandle` | Creates the control and runtime services. |

## Build versus BuildHandle

`Build(AParent)` returns the main `TRectangle`. The runtime remains alive because an internal behavior component retains the handle interface while the visual container exists. `BuildHandle(AParent)` returns `IRickUIBuilderComboBoxHandle`, allowing runtime access after materialization. The handle does not own the FMX visual tree and reports `IsAttached = False` after the visual container is destroyed.

## IRickUIBuilderComboBoxHandle

| Method | Behavior |
|---|---|
| `IsAttached` | Reports whether the main visual container reference is still valid. |
| `ItemIndex` | Confirmed source index, or `-1`. |
| `SelectedText` | Confirmed `DisplayText`, or empty string. |
| `SelectedValue` | Confirmed `Value`, or empty string. |
| `Count` | Number of source items. |
| `SelectIndex` | Selects `-1` or a valid source index; invalid values return `False`. |
| `SelectText` | Selects the first case-insensitive exact `DisplayText` match. |
| `Add` | Adds text-only or `DisplayText`/`Value` item. |
| `AddRange` | Adds multiple text-only items without rebuilding the control. |
| `Open`, `Close` | Controls the selection surface. |
| `SetArrowColor`, `SetArrowSize` | Changes arrow visual properties at runtime. |
| `SetClosedArrowPath`, `SetOpenedArrowPath` | Replaces arrow path data at runtime. |

## Public enums

- `TRickUIBuilderComboBoxStyleType`: `Desktop`, `Mobile`, `Adaptive`, `Custom`.
- `TRickUIBuilderComboBoxPresentationMode`: `Auto`, `Anchored`, `Overlay`, `FullWindow`.
- `TRickUIBuilderComboBoxArrowPosition`: `Left`, `Right`.
- `TRickUIBuilderComboBoxColumnSizeMode`: `Auto`, `Fixed`, `Proportional`.

Scoped enum syntax is used: refer to members as `Type.Member`.

## Item and column records

`TRickUIBuilderComboBoxItem` stores `DisplayText`, `Value`, and `Columns`. `Create(ADisplayText)` sets `Value = DisplayText`. `Create(ADisplayText, AValue)` keeps them independent. `Structured` additionally copies column data. `TRickUIBuilderComboBoxColumn.Create` sets the chosen sizing mode/value, `Alignment = Leading`, and `Visible = True`.

## Default configuration

| Field | Default |
|---|---:|
| `Width` / `Height` | `220` / `40` |
| `ItemHeight` | `36` |
| `PopupWidth` | `0` (resolved from anchor width) |
| `PopupWidthOffset` | `0` |
| `PopupMaxHeight` | `240` |
| `CornerRadius` | `6` |
| `HorizontalPadding` | `12` |
| `ArrowSize` | `20` |
| Arrow margins L/T/R/B | `8 / 0 / 12 / 0` |
| `ArrowPosition` | `Right` |
| `FontSize` | `14` |
| `FontFamily` | `''` |
| `FontStyle` | `[]` |
| `TextAlign` | `TTextAlign.Leading` |
| `Trimming` | `TTextTrimming.None` |
| `BackgroundColor` | `TAlphaColors.White` |
| `BorderColor` | `$FFD0D5DD` |
| `TextColor` | `$FF1D2939` |
| `PlaceholderColor` | `$FF667085` |
| `ArrowColor` | `$FF667085` |
| `PopupColor` | `TAlphaColors.White` |
| `HoverColor` | `$FFF2F4F7` |
| `SelectedColor` | `$FFEFF8FF` |
| `FocusColor` | `$FF2E90FA` |
| `DisabledOpacity` | `0.5` |
| `SearchTimeout` | `900` ms |
| `FullWindowCornerRadius` | `28` |
| `FullWindowPadding` | `16` |
| `SearchHeaderHeight` | `88` |
| `SearchFieldHeight` | `56` |
| `SearchFieldCornerRadius` | `16` |
| `SearchIconSize` | `24` |
| `NoResultsIconSize` | `64` |
| `FullWindowBackgroundColor` | `TAlphaColors.White` |
| `SearchFieldBackgroundColor` | `TAlphaColors.White` |
| `SearchFieldBorderColor` | `$FF98A2B3` |
| `SearchTextColor` | `$FF1D2939` |
| `SearchIconColor` | `$FF1D2939` |
| `NoResultsTextColor` | `$FF667085` |
| `NoResultsIconColor` | `$FF98A2B3` |
| `SearchPlaceholder` | `Pesquisar...` |
| `NoResultsText` | `Nenhum registro encontrado` |
| `Enabled` | `True` |
| `RequestedStyleType` | `Adaptive` |
| `EffectiveStyleType` | `Desktop` before style resolution |
| `PresentationMode` | `Auto` |

## Advanced record configuration

Not every `TRickUIBuilderComboBoxConfig` field has a dedicated fluent method. For those cases, use `TRickUIBuilderComboBoxConfig.Default` as the baseline and apply the record through `CustomConfig`.

The main advanced fields are:

| Group | Fields | Semantics |
|---|---|---|
| Typography | `FontFamily`, `FontStyle`, `TextAlign`, `Trimming` | Configure font family, styles, horizontal alignment, and trimming for ComboBox text. |
| Placeholder | `PlaceholderColor` | Defines the color used when there is no confirmed selection and the placeholder is displayed. |
| Popup | `PopupWidth`, `PopupWidthOffset`, `PopupColor` | Control width and color of the non-FullWindow selection surface. |
| Visual states | `HoverColor`, `SelectedColor`, `FocusColor` | Define colors used for hover, selection, and focus. |
| FullWindow — geometry | `FullWindowCornerRadius`, `FullWindowPadding`, `SearchHeaderHeight`, `SearchFieldHeight`, `SearchFieldCornerRadius`, `SearchIconSize`, `NoResultsIconSize` | Size the FullWindow presentation and its search/empty-state elements. |
| FullWindow — colors | `FullWindowBackgroundColor`, `SearchFieldBackgroundColor`, `SearchFieldBorderColor`, `SearchTextColor`, `SearchIconColor`, `NoResultsTextColor`, `NoResultsIconColor` | Define colors for the FullWindow surface, search field, and no-results state. |

`PopupWidth` and `PopupWidthOffset` work together: when `PopupWidth > 0`, that value is used directly. When `PopupWidth <= 0`, width is calculated as `Anchor.Width + PopupWidthOffset`. The final result is clamped to at least `1`.

### Events

- `OnChange` fires when the confirmed selection actually changes.
- `OnOpen` fires at the end of an effective open operation, after state, presentation, arrow, and popup have been updated. Calls to `Open` while detached, with `Enabled = False`, or while already open do not fire the event.
- `OnClose` fires at the end of an effective close operation, after presentation is closed, state is finalized, and the arrow is updated. Calling `Close` while already closed does not fire the event.

### Keyboard navigation

On the closed main control:

| Input | Action |
|---|---|
| `F4`, `Enter`, `Space`, `Alt+Down` | Opens the ComboBox. |
| `Down`, `Right` | Selects the next item within bounds. |
| `Up`, `Left` | Selects the previous item within bounds. |
| Printable character | Runs incremental prefix search and confirms the matching item. |

On the open main control:

| Input | Action |
|---|---|
| `Down`, `Up` | Moves the visual target. |
| `Home`, `End` | Moves the target to the first or last item in the view. |
| `PageUp`, `PageDown` | Moves the target by one page calculated from available height and `ItemHeight`. |
| `Enter`, `Space` | Confirms the target and closes. |
| `Escape`, `Tab` | Closes. |
| Printable character | Runs incremental prefix search and moves the target to the match. |

In the FullWindow search field, `Down`, `Up`, `PageUp`, `PageDown`, `Enter`, `Escape`, and `Tab` are handled by the ComboBox runtime. `Home`, `End`, and `Space` are not part of that specific key map.

Incremental search uses `SearchTimeout` to clear its accumulated buffer; the current default is `900` ms. It is separate from the textual filter shown by the FullWindow presentation.

### Runtime arrow changes

`SetArrowSize(AWidth, AHeight)` accepts independent width and height values. If either value is `<= 0`, the call is ignored. `SetClosedArrowPath` and `SetOpenedArrowPath` update the stored path and immediately reapply the appearance for the current open/closed state.

## CustomConfig and style defaults

`CustomConfig` copies the entire record, forces `RequestedStyleType = Custom`, and marks height, item height, and arrow size as explicit overrides. A later `StyleType(...)` call may change the requested style, as demonstrated by the Sample. During `ResolvedConfig`, Desktop/Mobile defaults are applied by the resolver, then explicit builder overrides for height, item height, and arrow size are restored.

## Runtime example

```pascal
FComboBoxHandle := TRickUIBuilder.ComboBox
  .Position(24, 80)
  .Size(320, 42)
  .AddItem('Rio de Janeiro', 'RJ')
  .AddItem('São Paulo', 'SP')
  .BuildHandle(AParent);
```

```pascal
if FComboBoxHandle.IsAttached then
begin
  FComboBoxHandle.Add('Mouse sem fio', '004');
  FComboBoxHandle.AddRange(['Headset', 'Webcam']);
  FComboBoxHandle.SetArrowColor($FF7E22CE);
end;
```
