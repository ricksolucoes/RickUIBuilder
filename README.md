<div align="center">

# 📱RickUIBuilder

[![Delphi](https://img.shields.io/badge/Delphi-FireMonkey-E62431?style=flat-square)](#requirements)
[![FMX](https://img.shields.io/badge/UI-FMX-0E7490?style=flat-square)](#overview)
[![Tests](https://img.shields.io/badge/Tests-DUnitX-2EA44F?style=flat-square)](#tests)
[![License](https://img.shields.io/badge/License-Revocable%20Software%20License-8250DF?style=flat-square)](LICENSE)

**English** | [Português (Brasil)](README.pt-BR.md)

</div>

RickUIBuilder is a Delphi FireMonkey (FMX) library for creating and composing UI controls in code. It supports three complementary usage styles: direct creation through a factory, fluent builders for richer component configuration, and composition for creating short sequences of controls on the same parent.

The library is distributed as source code. To use it, add the `src` directory to your Delphi project's Search Path.

## Contents

- [Overview](#overview)
- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Getting Started](#getting-started)
- [Factory](#factory)
- [Label Builder](#label-builder)
- [Button Builder](#button-builder)
- [Badge Builder](#badge-builder)
- [Divider Builder](#divider-builder)
- [ComboBox Builder](#combobox-builder)
- [Composition](#composition)
- [Working with Interfaces](#working-with-interfaces)
- [Sample Application](#sample-application)
- [Tests](#tests)
- [AI-assisted Maintenance](#ai-assisted-maintenance)
- [License](#license)

<a name="overview"></a>
## 📖 Overview

`Rick.UIBuilder` exposes `TRickUIBuilder`, the main entry point for the library:

```text
TRickUIBuilder
├── Factory   -> direct control creation
├── Label_    -> fluent Label builder
├── Button    -> fluent Button builder
├── Badge     -> fluent Badge builder
├── Divider   -> fluent Divider builder
├── ComboBox  -> fluent, stateful ComboBox builder
└── On(...)   -> UI composition
```

The three creation styles are intended for different levels of configuration:

| Style | Entry point | Typical use |
| --- | --- | --- |
| Factory | `TRickUIBuilder.Factory` or `TRickUIBuilderFactory` | Create a control directly from a configuration record |
| Fluent Builders | `Label_`, `Button`, `Badge`, `Divider`, `ComboBox` | Configure a component through a readable fluent chain before calling `Build` |
| Composition | `TRickUIBuilder.On(AParent)` | Create a short sequence of controls on the same parent |

Using an `IRickUIBuilder*` interface explicitly is **not a fourth creation style**. It is an alternative way to hold and use the same fluent builders through their public contracts.

<a name="features"></a>
## ✨ Features

- Direct creation of FMX text, buttons, badges, and dividers through `TRickUIBuilderFactory`.
- Fluent Label, Button, Badge, Divider, and ComboBox builders.
- UI composition through `TRickUIBuilder.On(AParent)`.
- Configuration records with reusable defaults for direct Factory creation.
- Shared spacing support through `TRickUIBuilderSpacing`.
- Button click and mutable hover configuration, including runtime access through `IRickUIBuilderButtonHandle`.
- ComboBox support for independent `DisplayText` and `Value`, simple or structured items, columns, selection, and runtime mutation through `IRickUIBuilderComboBoxHandle`.
- ComboBox presentation modes `Auto`, `Anchored`, `Overlay`, and `FullWindow`, with Desktop, Mobile, Adaptive, and Custom style profiles.
- FullWindow search with clear/back hit areas, filtered-view mapping, empty state, and custom SVG paths.
- Virtualized ComboBox item rendering with optional `OnCustomizeItem` content.
- Explicit public interfaces for fluent builders, generated-control handles, mutable hover state, ComboBox runtime control, and composition.
- Detailed ComboBox architecture and maintenance documentation under [`docs/combobox`](docs/combobox/README.md).

<a name="requirements"></a>
## 🧰 Requirements

- Delphi with FireMonkey (FMX) support.
- The RickUIBuilder `src` directory available to the consuming project.

<a name="installation"></a>
## 📦 Installation

Clone or copy RickUIBuilder and add its `src` directory to the Delphi project's **Search Path**:

```text
<path-to-RickUIBuilder>\src
```

No package installation is required for normal use.

<a name="getting-started"></a>
## 🚀 Getting Started

The most direct entry point for fluent usage is `Rick.UIBuilder`:

```pascal
uses
  System.UITypes,
  Rick.UIBuilder;

procedure TMainForm.BuildUI;
begin
  TRickUIBuilder.Label_
    .Text('Hello from RickUIBuilder')
    .Position(24, 24)
    .Size(280, 28)
    .FontSize(16)
    .FontColor(TAlphaColors.Black)
    .Bold
    .Build(Self);
end;
```

`Label_` intentionally uses a trailing underscore because `Label` conflicts with Object Pascal syntax.

The sections below show the available approaches in more detail.

---

<a name="factory"></a>
## 🏭 Factory

**Implementation unit:** `Rick.UIBuilder.Factory`

`TRickUIBuilderFactory` creates FMX controls immediately from configuration records. Each method receives an `AOwner`, an `AParent`, and the configuration required by that control.

The same Factory is also exposed through:

```pascal
TRickUIBuilder.Factory
```

### Available Factory methods

| Method | Result |
| --- | --- |
| `CreateText` | `TLabel` |
| `CreateDivider` | `TRectangle` |
| `CreateBadge` | Badge `TRectangle` plus its internal `TLabel` through an `out` parameter |
| `CreateButton` | Button `TRectangle`; an additive overload also returns the internal caption `TLabel` through an `out` parameter |

### Configuration records

Factory creation uses records from `Rick.UIBuilder.Types`. Start from `Default`, change only the values required by the current UI, and pass the resulting record to the Factory.

| Record | Available configuration |
| --- | --- |
| `TRickUIBuilderTextConfig` | `Left`, `Top`, `Width`, `Height`, `FontSize`, `FontColor`, `HorizontalAlign`, `Bold` |
| `TRickUIBuilderButtonConfig` | `Left`, `Top`, `Width`, `Height`, `FillColor`, `BorderColor`, `TextColor`, `Tag`, `FontSize` |
| `TRickUIBuilderBadgeConfig` | `Left`, `Top`, `Width`, `Height`, `BackgroundColor`, `TextColor`, `FontSize` |
| `TRickUIBuilderDividerConfig` | `Left`, `Top`, `Width`, `Color` |

The examples below intentionally change only a few fields. The remaining fields can be configured when the screen requires them.

```pascal
uses
  System.UITypes,
  FMX.StdCtrls,
  Rick.UIBuilder.Factory,
  Rick.UIBuilder.Types;

procedure TMainForm.BuildWithFactory;
var
  LTextConfig: TRickUIBuilderTextConfig;
  LButtonConfig: TRickUIBuilderButtonConfig;
  LBadgeConfig: TRickUIBuilderBadgeConfig;
  LDividerConfig: TRickUIBuilderDividerConfig;
  LBadgeText: TLabel;
begin
  LTextConfig := TRickUIBuilderTextConfig.Default;
  LTextConfig.Left := 24;
  LTextConfig.Top := 24;
  LTextConfig.FontSize := 16;
  TRickUIBuilderFactory.CreateText(
    Self,
    Self,
    'Created with the Factory',
    LTextConfig
  );

  LDividerConfig := TRickUIBuilderDividerConfig.Default;
  LDividerConfig.Left := 24;
  LDividerConfig.Top := 64;
  LDividerConfig.Width := 280;
  TRickUIBuilderFactory.CreateDivider(Self, Self, LDividerConfig);

  LBadgeConfig := TRickUIBuilderBadgeConfig.Default;
  LBadgeConfig.Left := 24;
  LBadgeConfig.Top := 80;
  LBadgeConfig.BackgroundColor := TAlphaColors.Lightgray;
  TRickUIBuilderFactory.CreateBadge(
    Self,
    Self,
    'Active',
    LBadgeConfig,
    LBadgeText
  );

  LButtonConfig := TRickUIBuilderButtonConfig.Default;
  LButtonConfig.Left := 24;
  LButtonConfig.Top := 120;
  LButtonConfig.Width := 160;
  TRickUIBuilderFactory.CreateButton(
    Self,
    Self,
    'Continue',
    LButtonConfig
  );
end;
```

`AOwner` controls the lifetime of the created controls, while `AParent` defines where they are placed in the FMX visual tree.

For buttons, the direct Factory method creates the visual control but does not attach the fluent builder's hover behavior. Use the Button Builder when you need `HoverFillColor`, `OnHover`, or the other builder-only options. The original `CreateButton(...): TRectangle` overload remains available; use the overload with `out ATextLabel: TLabel` only when direct Factory code also needs the exact caption label created for that button. Both controls remain owned by the `AOwner` passed to the Factory.

---

<a name="label-builder"></a>
## 🔤 Label Builder

**Implementation unit:** `Rick.UIBuilder._Label`

Use `TRickUIBuilder.Label_` to configure a `TLabel` fluently and create it only when `Build` is called.

### What can be configured

- Text, position, size, and anchors.
- Margin and padding.
- Font family, size, color, bold, and italic styles.
- Horizontal and vertical text alignment.
- Word wrapping and text trimming.
- Opacity, visibility, hit testing, and tag.

`TRickUIBuilderSpacing` is used by `Margin` and `Padding`. It provides `Uniform`, `Create`, and `None` helpers. `Margin` is added to the position configured with `Position`; `Padding` affects the internal text area without changing the control's configured width and height.

```pascal
uses
  System.UITypes,
  FMX.Types,
  Rick.UIBuilder,
  Rick.UIBuilder.Types;

procedure TMainForm.BuildLabel;
begin
  TRickUIBuilder.Label_
    .Text('A more complete fluent label')
    .Position(24, 24)
    .Size(320, 48)
    .FontSize(16)
    .FontColor(TAlphaColors.Black)
    .Bold
    .Align(TTextAlign.Center)
    .VerticalAlign(TTextAlign.Center)
    .WordWrap
    .Margin(TRickUIBuilderSpacing.Uniform(4))
    .Padding(TRickUIBuilderSpacing.Create(8, 4, 8, 4))
    .Opacity(1)
    .Visible
    .Build(Self);
end;
```

---

<a name="button-builder"></a>
## 🔘 Button Builder

**Implementation unit:** `Rick.UIBuilder.Button`

Use `TRickUIBuilder.Button` when a button requires richer visual or behavioral configuration than direct Factory creation.

### What can be configured

- Caption, position, size, and anchors.
- Corner radius, margin, and padding.
- Fill color, border color, and border thickness.
- Text color, font family, font size, and bold text.
- Hover fill color and custom enter/leave handlers.
- Enabled state and disabled opacity.
- Cursor, opacity, visibility, and tag.
- Click handler.

```pascal
uses
  System.Classes,
  System.UITypes,
  Rick.UIBuilder,
  Rick.UIBuilder.Types;

procedure TMainForm.SaveClick(Sender: TObject);
begin
  // Application-specific action.
end;

procedure TMainForm.BuildButton;
begin
  TRickUIBuilder.Button
    .Caption('Save')
    .Position(24, 24)
    .Size(160, 44)
    .CornerRadius(10)
    .FillColor(TAlphaColors.Dodgerblue)
    .BorderColor(TAlphaColors.Black)
    .BorderThickness(1)
    .TextColor(TAlphaColors.White)
    .FontSize(15)
    .Bold
    .HoverFillColor(TAlphaColors.Lightgray)
    .Padding(TRickUIBuilderSpacing.Create(12, 6, 12, 6))
    .OnClick(SaveClick)
    .Build(Self);
end;
```

When `Enabled(False)` is used, the builder applies the configured `DisabledOpacity`. When enabled, the normal `Opacity` value is used.

### Button hover state

The Button Builder configures hover through its public fluent API (`HoverFillColor` and `OnHover`). RickUIBuilder also exposes `IRickUIBuilderButtonHoverState` when the hover state itself needs to be configured explicitly.

`TRickUIBuilderButtonHoverState.New` takes no parameters. Configuration is performed through fluent input overloads, while the corresponding parameterless overloads return the currently configured values:

| Setting | Input overload | Output overload |
| --- | --- | --- |
| Button | `Button(AValue: TRectangle)` | `Button: TRectangle` |
| Normal fill | `FillColor(AValue: TAlphaColor)` | `FillColor: TAlphaColor` |
| Hover fill | `HoverFillColor(AValue: TAlphaColor)` | `HoverFillColor: TAlphaColor` |
| Mouse enter handler | `OnEnter(AValue: TNotifyEvent)` | `OnEnter: TNotifyEvent` |
| Mouse leave handler | `OnLeave(AValue: TNotifyEvent)` | `OnLeave: TNotifyEvent` |

Each input overload returns `IRickUIBuilderButtonHoverState`, so configuration remains chainable. `Build(AOwner)` materializes the persistent hover behavior and returns the same interface contract. The behavior keeps that same state alive and reads the current `FillColor`, `HoverFillColor`, `OnEnter`, and `OnLeave` values when the corresponding mouse event is fired. Updating these values after `Build` therefore affects subsequent hover events without rebuilding the button.

The setters do not repaint the button immediately. A new `HoverFillColor` is used by the next `MouseEnter`, and a new `FillColor` is used by the next `MouseLeave`. Changing `Button(AValue)` after `Build` also does not retarget a behavior that has already been materialized; that behavior remains attached to the button used by its own `Build`.

```pascal
uses
  System.UITypes,
  FMX.Objects,
  Rick.UIBuilder.Button.HoverState,
  Rick.UIBuilder.Interfaces;

procedure TMainForm.ConfigureButtonHover(const AButton: TRectangle);
var
  LHoverState: IRickUIBuilderButtonHoverState;
begin
  LHoverState := TRickUIBuilderButtonHoverState.New
    .Button(AButton)
    .FillColor(AButton.Fill.Color)
    .HoverFillColor(TAlphaColors.Lightgray);

  LHoverState.Build(Self);

  // Later: the already-built behavior will use these values
  // on the next corresponding mouse events.
  LHoverState
    .FillColor(TAlphaColors.Teal)
    .HoverFillColor(TAlphaColors.Aqua);
end;
```

The caller's configuration reference may be released after `Build`. The materialized event behavior is owned by the `AOwner` passed to `Build`, keeps the hover state alive, and remains active while that Owner remains alive. `Build` does not change the Button's ownership; the supplied Owner must therefore remain alive for as long as the Button can fire the configured hover events.

### Accessing the generated controls

The existing `Build(AParent): TRectangle` API is preserved and remains the simplest choice when the caller only needs the button container. When code also needs post-build access, call `BuildHandle` instead. It returns an `IRickUIBuilderButtonHandle` with `Container`, `TextLabel`, and the same mutable `HoverState` used by the button's materialized behavior.

```pascal
uses
  Rick.UIBuilder,
  Rick.UIBuilder.Interfaces;

procedure TMainForm.BuildButtonWithHandle;
var
  LHandle: IRickUIBuilderButtonHandle;
begin
  LHandle := TRickUIBuilder.Button
    .Caption('Save')
    .Size(160, 44)
    .BuildHandle(Self);

  LHandle.TextLabel.Text := 'Saved';

  LHandle.HoverState
    .FillColor(TAlphaColors.Teal)
    .HoverFillColor(TAlphaColors.Aqua);
end;
```

`BuildHandle` supplies a non-nil `HoverState` associated with the same button. The compatibility overload `TRickUIBuilderButtonHandle.New(Container, TextLabel)` is preserved for direct callers and has no hover state to expose, so its `HoverState` result is `nil`.

The handle is **non-owning** with respect to the FMX controls. Releasing the interface does not free either control, and holding the interface does not keep those controls alive. The handle may keep the logical hover-state interface referenced, but that state does not own the button. Ownership and lifetime stay with the `Owner` used during creation (the fluent builder uses the `AParent` passed to `Build`/`BuildHandle` as Owner and Parent for the container, and as Owner for the caption label). Therefore, do not access `Container`, `TextLabel`, or their hover state after the control Owner has been destroyed.

Use `Build` when only the `TRectangle` is required. Use `BuildHandle` when code must access the generated `TLabel` explicitly without depending on the button's `Children` layout.

Existing source calls to `Build(AParent): TRectangle` remain unchanged. Public interface layouts have evolved (`IRickUIBuilderButton` includes `BuildHandle`, and `IRickUIBuilderButtonHandle` now includes `HoverState`), so dependent Delphi units/packages should be rebuilt against this version; binary compatibility with DCUs/DCPs/BPLs compiled against an older interface layout is not asserted.

---

<a name="badge-builder"></a>
## 🏷️ Badge Builder

**Implementation unit:** `Rick.UIBuilder.Badge`

Use `TRickUIBuilder.Badge` to create a badge composed of a `TRectangle` container and an internal `TLabel`.

### What can be configured

- Text, position, and size.
- Pill mode or an explicit corner radius.
- Margin and padding.
- Background, text, and border colors.
- Font size and bold text.
- Opacity, visibility, and tag.

`Build` returns an `IRickUIBuilderBadgeHandle`, which exposes both the generated `Container` and `TextLabel` when the caller needs to update them after creation.

```pascal
uses
  System.UITypes,
  Rick.UIBuilder,
  Rick.UIBuilder.Types;

procedure TMainForm.BuildBadge;
begin
  TRickUIBuilder.Badge
    .Text('Active')
    .Position(24, 24)
    .Size(100, 28)
    .Pill
    .BackgroundColor(TAlphaColors.Lightgray)
    .TextColor(TAlphaColors.Black)
    .BorderColor(TAlphaColors.Dodgerblue)
    .FontSize(12)
    .Bold
    .Padding(TRickUIBuilderSpacing.Create(8, 2, 8, 2))
    .Build(Self);
end;
```

When `Pill(True)` is used, the Factory's pill shape is preserved. With `Pill(False)`, the value supplied through `CornerRadius` is applied instead.

---

<a name="divider-builder"></a>
## ➖ Divider Builder

**Implementation unit:** `Rick.UIBuilder.Divider`

Use `TRickUIBuilder.Divider` to create horizontal or vertical separators with configurable length, thickness, color, opacity, and visibility.

### What can be configured

- Position and length.
- Thickness.
- Horizontal or vertical orientation.
- Margin.
- Color, opacity, and visibility.

For a vertical divider, the value supplied to `Width` becomes the divider's length, while `Thickness` becomes its visual width.

```pascal
uses
  System.UITypes,
  FMX.Types,
  Rick.UIBuilder,
  Rick.UIBuilder.Types;

procedure TMainForm.BuildDivider;
begin
  TRickUIBuilder.Divider
    .Position(24, 24)
    .Width(240)
    .Thickness(2)
    .Orientation(TOrientation.Horizontal)
    .Margin(TRickUIBuilderSpacing.Uniform(4))
    .Color(TAlphaColors.Lightgray)
    .Opacity(1)
    .Build(Self);
end;
```

---

<a name="combobox-builder"></a>
## 🔽 ComboBox Builder

**Implementation units:** `Rick.UIBuilder.ComboBox` and the specialized `Rick.UIBuilder.ComboBox.*` units.

`TRickUIBuilder.ComboBox` creates a runtime-only FMX ComboBox with a fluent configuration API. The closed control is materialized by `Build` or `BuildHandle`; the selection surface is created lazily when opened. The same logical data model and virtualizer are reused across `Anchored`, `Overlay`, and `FullWindow` presentations.

### Core capabilities

- Simple textual items through `Items` and `AddItem`.
- Independent `DisplayText` and `Value`.
- Structured items with additional visual columns.
- Initial selection by `ItemIndex` or `SelectedText`.
- Desktop, Mobile, Adaptive, and Custom style profiles.
- `Auto`, `Anchored`, `Overlay`, and `FullWindow` presentation modes.
- FullWindow search, clear action, back action, and empty state.
- Virtualized row rendering and optional `OnCustomizeItem` content.
- Arrow position, margins, size, color, and open/closed paths.
- Runtime selection, mutation, open/close, and arrow updates through `IRickUIBuilderComboBoxHandle`.

```pascal
uses
  Rick.UIBuilder,
  Rick.UIBuilder.Interfaces,
  Rick.UIBuilder.Types;

procedure TMainForm.BuildCityComboBox;
begin
  FComboBoxHandle := TRickUIBuilder.ComboBox
    .StyleType(TRickUIBuilderComboBoxStyleType.Mobile)
    .PresentationMode(TRickUIBuilderComboBoxPresentationMode.Auto)
    .Position(24, 24)
    .AddItem('Rio de Janeiro', 'RJ')
    .AddItem('Riviera de São Lourenço, SP', 'RIVIERA')
    .AddItem('Ribeirão Preto, SP', 'RAO')
    .ItemIndex(0)
    .SearchPlaceholder('Search city...')
    .NoResultsText('No city found')
    .BuildHandle(Self);
end;
```

`Build` returns the generated closed-control `TRectangle` and keeps the runtime behavior alive while that visual tree exists. `BuildHandle` returns `IRickUIBuilderComboBoxHandle`, which does not own the visual tree and reports `IsAttached = False` after the associated visual structure is destroyed.

For structured lists, use `TRickUIBuilderComboBoxColumn` and `AddStructuredItem`. The source collection remains stable while filtering: the filtered view maps `ViewIndex` back to the original `SourceIndex` before committing selection.

For the complete public API, internal dependency map, FullWindow behavior, filtering rules, virtualization, ownership, tests, and maintenance invariants, read the [ComboBox technical documentation](docs/combobox/README.md).

---

<a name="composition"></a>
## 📚 Detailed component documentation

Complete references for the builders are organized by component:

- [Label](docs/label/README.md) — API, defaults, layout, margin/padding, and ownership.
- [Button](docs/button/README.md) — API, hover, Behavior, Handle, lifecycle, and examples.
- [Badge](docs/badge/README.md) — API, Pill/CornerRadius, Handle, ownership, and examples.
- [Divider](docs/divider/README.md) — API, orientation, geometry, Factory, and examples.
- [ComboBox](docs/combobox/README.md) — complete ComboBox technical documentation.

## 🧩 Composition

**Implementation unit:** `Rick.UIBuilder.Composition`

`TRickUIBuilder.On(AParent)` creates a composer associated with a single FMX parent. Unlike the fluent component builders, the composer does **not** wait for a final `Build`: every `Add*` call creates its control immediately and returns the same composer for continued chaining.

### Available operations

| Method | Creates |
| --- | --- |
| `AddText` | `TLabel` |
| `AddDivider` | Divider `TRectangle` |
| `AddBadge` | Badge and an `IRickUIBuilderBadgeHandle` |
| `AddButton` | Button `TRectangle` with an optional click handler |

Composition uses the same configuration records as the Factory.

```pascal
uses
  System.UITypes,
  Rick.UIBuilder,
  Rick.UIBuilder.Interfaces,
  Rick.UIBuilder.Types;

procedure TMainForm.BuildComposedUI;
var
  LText: TRickUIBuilderTextConfig;
  LDivider: TRickUIBuilderDividerConfig;
  LBadge: TRickUIBuilderBadgeConfig;
  LButton: TRickUIBuilderButtonConfig;
  LBadgeHandle: IRickUIBuilderBadgeHandle;
begin
  LText := TRickUIBuilderTextConfig.Default;
  LText.Left := 24;
  LText.Top := 24;
  LText.Width := 280;
  LText.FontSize := 16;

  LDivider := TRickUIBuilderDividerConfig.Default;
  LDivider.Left := 24;
  LDivider.Top := 60;
  LDivider.Width := 280;

  LBadge := TRickUIBuilderBadgeConfig.Default;
  LBadge.Left := 24;
  LBadge.Top := 76;
  LBadge.BackgroundColor := TAlphaColors.Lightgray;

  LButton := TRickUIBuilderButtonConfig.Default;
  LButton.Left := 24;
  LButton.Top := 116;
  LButton.Width := 160;

  TRickUIBuilder.On(Self)
    .AddText('Composed UI', LText)
    .AddDivider(LDivider)
    .AddBadge('Ready', LBadge, LBadgeHandle)
    .AddButton('Continue', LButton, nil);
end;
```

The records above contain additional fields beyond those changed in the example. Start from `Default` and override only the values required by the current screen.

---

<a name="working-with-interfaces"></a>
## 🔌 Working with Interfaces

**Unit:** `Rick.UIBuilder.Interfaces`

RickUIBuilder exposes public contracts for the fluent builders, mutable button hover state, generated-control handles, ComboBox runtime control, and the composer:

| Interface | Role |
| --- | --- |
| `IRickUIBuilderLabel` | Label fluent builder contract |
| `IRickUIBuilderButton` | Button fluent builder contract |
| `IRickUIBuilderButtonHoverState` | Mutable hover state with input/output overloads; `Build(AOwner)` materializes behavior that reads the current values on subsequent mouse events |
| `IRickUIBuilderButtonHandle` | Non-owning access to the generated button container and caption label, plus the associated mutable hover state |
| `IRickUIBuilderBadge` | Badge fluent builder contract |
| `IRickUIBuilderBadgeHandle` | Access to the generated badge container and text label |
| `IRickUIBuilderDivider` | Divider fluent builder contract |
| `IRickUIBuilderComboBox` | ComboBox fluent builder contract |
| `IRickUIBuilderComboBoxHandle` | Non-owning runtime contract for selection, data mutation, open/close, and arrow updates |
| `IRickUIBuilderComposer` | Composition contract |

Using an interface explicitly does not create a different implementation. It simply stores the same builder returned by `TRickUIBuilder` behind its public contract.

`IRickUIBuilderButtonHoverState` is the exception in purpose, not in interface style: it represents the explicit hover state rather than a visual component builder. Its `New` factory is parameterless, its setter/getter pairs use overloads, and its `Build(AOwner)` materializes the Owner-managed event behavior. The behavior keeps the state alive, so the caller does not need to retain a reference merely for lifetime; when the caller does keep the state (directly or through `IRickUIBuilderButtonHandle.HoverState`), changes to fill colors and enter/leave handlers are consumed by subsequent mouse events.

A minimal example:

```pascal
uses
  Rick.UIBuilder,
  Rick.UIBuilder.Interfaces;

procedure TMainForm.BuildThroughInterface;
var
  LButton: IRickUIBuilderButton;
begin
  LButton := TRickUIBuilder.Button;

  LButton
    .Caption('Save')
    .Size(120, 40)
    .Build(Self);
end;
```

This style is useful when code should explicitly depend on the interface contract while retaining the same fluent builder behavior.

---

<a name="sample-application"></a>
## 🎨 Sample Application

The `sample` project demonstrates the framework usage styles and the current ComboBox matrix:

- Factory.
- Fluent Builders.
- Composition.
- Desktop ComboBox with `Anchored` presentation.
- Mobile ComboBox with `Auto` resolving to FullWindow and real-time search.
- Adaptive ComboBox with structured columns and a retained runtime handle.
- Custom ComboBox with multiple columns, `OnCustomizeItem`, and left-positioned arrow.
- Custom FullWindow ComboBox using the same data and rendering pipeline.
- Runtime ComboBox updates through `IRickUIBuilderComboBoxHandle`.

Open:

```text
sample\RickUIBuilder.Sample.dproj
```

The detailed ComboBox design is documented separately under [`docs/combobox`](docs/combobox/README.md).

<a name="tests"></a>
## ✅ Tests

The project includes a DUnitX suite covering the main RickUIBuilder areas, including Types, Factory, Label, Button, Badge, Divider, Composition, Facade, and ComboBox data/integration/style behavior. The current source declares **197** `[Test]` methods.

### Latest verified DUnitX result

The supplied NUnit XML identifies `RickUIBuilder.Test.exe` and records a real execution at **2026-09-22 23:46:29** with assembly result `Success` / `success="True"`:

| DUnitX result | Value |
| --- | ---: |
| Tests Found | **197** |
| Tests Passed | **197** |
| Tests Ignored | **0** |
| Tests Failed | **0** |
| Tests Errored | **0** |
| Inconclusive | **0** |
| Not run | **0** |
| Skipped | **0** |
| Invalid | **0** |
| Tests Leaked | **0** |

The ComboBox coverage includes data selection/filter mapping, runtime handle behavior, Parent/Popup lifecycle, arrow behavior, FullWindow host resolution, FullWindow search structure, clear/back actions, filtered selection, empty state, custom FullWindow, path defaults, and style/presentation resolution.

### Method Toxicity Metrics

RAD Studio Method Toxicity Metrics was run for the three current projects. The supplied reports contain **404 measured library methods**, **252 measured test methods**, and **35 measured sample methods**.

| Project | Methods | Max `Length` | Max `Parameters` | Max `If Depth` | Max `Cyclomatic Complexity` | Max `Toxicity` | Gate violations |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `RickUIBuilder.dproj` / library package | **404** | **20** | **5** | **3** | **4** | **0.554** | **0** |
| `RickUIBuilder.Test.dproj` | **252** | **14** | **2** | **2** | **6** | **0.571** | **0** |
| `RickUIBuilder.Sample.dproj` | **35** | **14** | **4** | **1** | **2** | **0.338** | **0** |

The project quality gates are `Length <= 20`, `Parameters <= 6`, `If Depth <= 5`, `Cyclomatic Complexity <= 6`, and `Toxicity < 1`. No row in the three supplied reports exceeds those limits.

The highest measured toxicity in each project is:

| Project | Method | Toxicity |
| --- | --- | ---: |
| Library | `TRickUIBuilderComboBoxVirtualizer.CreateColumnLabel` | **0.554** |
| Tests | `TRickUIBuilderComboBoxIntegrationTests.FindPath` and `FindLabel` | **0.571** |
| Sample | `TPageSampleMain.CustomizeComboBoxItem` | **0.338** |

These are real RAD Studio values from the supplied CSV reports, not source-code estimates. They are revision-specific and must be measured again after future Delphi code changes.

<a name="ai-assisted-maintenance"></a>
## 🤖 AI-assisted Maintenance

Repository-level AI guidance starts at [`AGENTS.md`](AGENTS.md). The project-wide engineering system lives under [`.agents/`](.agents/README.md) and uses [`ricksolucoes/agent-skills`](https://github.com/ricksolucoes/agent-skills) as a **behavioral and depth benchmark**, not merely as a naming or folder-layout reference.

The local adaptation preserves the same engineering model — skills as executable workflows, specialist personas, anti-rationalization, red flags, evidence-based verification, progressive disclosure, brownfield adoption, and a reusable Definition of Done — while replacing Web/TypeScript-specific mechanics with Delphi/Object Pascal, FireMonkey, DUnitX, RAD Studio, ownership/lifetime, and Method Toxicity practices that are actually relevant to RickUIBuilder.

- `skills/<name>/SKILL.md` contains detailed intent-triggered workflows with entry conditions, decision points, project-specific techniques, common rationalizations, red flags, and verifiable exit criteria.
- `agents/` contains specialist personas such as Delphi engineer, code reviewer, test engineer, technical writer, and quality auditor. Personas provide a perspective and output contract; they do not route other personas.
- `references/` centralizes the Definition of Done, project constraints, component map, Delphi/FMX quality rules, testing/documentation policies, Method Toxicity baseline, orchestration patterns, and the explicit adaptation contract with `agent-skills`.
- `templates/` contains reusable artifacts for specifications, change plans, iterative debugging Attempt Logs, ADRs, audits, and delivery reports.

The governance applies to **all RickUIBuilder elements** — Factory, Label, Button, Badge, Divider, ComboBox, Composition, shared contracts, Sample/tests, and future components. The generic `component-maintenance` workflow discovers each component's real contracts and complexity instead of imposing the ComboBox architecture on simpler controls.

The ComboBox remains the first component with dedicated deep documentation under [`docs/combobox`](docs/combobox/README.md). Those documents are domain knowledge loaded only when a ComboBox task requires them; they are not the framework-wide engineering model.

The adaptation policy and the differences intentionally kept from the upstream project are documented in [`.agents/references/agent-skills-adaptation.md`](.agents/references/agent-skills-adaptation.md).

<a name="license"></a>
## 🔐 License

Copyright © 2026 **RickSoluções**. All rights reserved.

RickUIBuilder is **proprietary software** distributed under a **Revocable Limited Use License**. The license grants limited, non-exclusive, non-transferable, and revocable permission to use, study, test, and modify the Software while that authorization remains valid.

The license does **not** automatically grant redistribution, sublicensing, publication, hosting, commercialization, SaaS use, or incorporation into commercial products or services. Commercial, enterprise, OEM, SaaS, redistribution, hosting, and other rights may be granted separately in writing by RickSoluções.

- 📄 **Official license (English):** [`LICENSE`](LICENSE)
- 🇧🇷 **Portuguese translation:** [`LICENSE-pt-BR`](LICENSE-pt-BR)

> [!IMPORTANT]
> Public access to the source code does not make RickUIBuilder open source and does not grant rights beyond those expressly provided by the applicable license.

## 👤 Maintainer

**RickSoluções**  
Owner and maintainer of **RickUIBuilder**.

---

<div align="center">

### 📱 RickUIBuilder

**Framework for building modern FMX visual components with reusable builders, interfaces, runtime handles, and composition helpers.**

[⬆ Back to top](#rickuibuilder)

</div>