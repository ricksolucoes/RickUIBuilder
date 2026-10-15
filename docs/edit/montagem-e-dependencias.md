# New Edit assembly and dependency map

This document records the **current implementation blueprint** for the new `Edit`, derived from the contract in `src/Edit/Rick.UIBuilder.Edit.Interfaces.pas` and the implementation under `src/Edit/`.

The architecture is strict: the 28 public interfaces have exactly 28 corresponding concrete classes, each in its own implementation unit. There are no project-owned production helper classes outside that set.

## Decision sources

Implementation decisions are derived from:

1. the current `Rick.UIBuilder.Edit.Interfaces.pas` contract;
2. behavior proven by the new Edit tests;
3. active project governance;
4. the FMX controls and events actually used by the implementation.

Previous experimental implementations or ZIPs are not architectural sources.

## Assembly principles

### 1. Single external entry point

The external entry point is `IRickUIBuilderEdit`.

`IRickUIBuilderEdit` is the logical **composition root**. Its implementation creates the shared visual tree and connects the five public branches defined by the contract.

Consumers do not need concrete classes, internal helpers, or parallel state mechanisms.

### 2. The interface tree is the primary responsibility tree

```text
IRickUIBuilderEdit
├── Rectangle
│   ├── Position
│   ├── Size
│   ├── Background
│   └── Border
├── Labels
│   ├── Main
│   │   └── Text
│   │       └── Color
│   ├── Counter
│   └── Error
│       └── Text
│           └── Font
├── Designer
│   ├── Input
│   │   ├── Text
│   │   │   └── Color
│   │   ├── Number
│   │   └── Config
│   ├── Validation
│   └── Config
├── Line
│   └── Color
└── Config
    └── Icons
        ├── Colors
        └── Paths
```

Each state is retained by the implementation corresponding to the contract that represents it. Shared FMX controls are composition infrastructure, not RickUIBuilder domain classes.

### 3. 1 → 1 → 1 correspondence

```text
1 public interface
        ↓
1 corresponding concrete class
        ↓
1 exclusive unit
```

Expected structural state:

```text
28 public interfaces
28 project-owned production classes
28 implementation units
+ Rick.UIBuilder.Edit.Interfaces.pas
+ Rick.UIBuilder.Edit.Types.pas
=
30 .pas files under src/Edit/
```

`Rick.UIBuilder.Edit.InputRules.pas` and `Rick.UIBuilder.Edit.VisualState.pas` are not part of the final architecture.

### 4. Navigation references

When a child must return its parent contract, it keeps `FParent` weak:

```delphi
[weak]
FParent: IRickUIBuilderEditDesigner;
```

The parent stores the child through its corresponding interface. `TInterfacedObject` implementations use reference counting; `TComponent` event receivers are owned by the FMX runtime tree appropriate to their lifetime. The upward `[weak]` reference avoids a strong cycle while preserving fluent navigation.

### 5. Dependency Injection carries the real dependency

Implementations may receive:

- the parent contract for `ToBack`;
- existing interfaces when behavior depends on another contract;
- FMX controls (`TEdit`, `TRectangle`, `TLabel`, `TPath`) when those controls are the real configured target.

There is no `Context`, service locator, aggregate settings record, or project-owned concrete helper used as a state bus between branches.

### 6. Runtime events remain in legitimate implementations

FMX events do not justify a helper class.

Event receivers remain the concrete classes corresponding to existing interfaces. When lifetime must follow the FMX tree directly, those implementations derive from `TComponent` and are owned by the appropriate control. `Designer.Validation` remains a `TInterfacedObject` and is kept alive by existing interface references; `Line.Color` is owned by the root `TRectangle` so it can exist before the `TEdit` and observe its insertion through `TComponent.Notification`.

Handlers preserve and chain the previously installed handler:

- `OnChangeTracking`: input configuration, counter, clear button, and clearing automatic invalid state when the value is edited again;
- `OnEnter` / `OnExit`: visual contracts reacting to Focus/ReadOnly/Invalid and completion validation when the control exits;
- `OnClick`: clear and password visibility;
- `OnValidate` / `OnValidating`: cooperation between `Input.Config` and `Input.Number` for numeric rules; `Validation` also uses `OnValidating` as an internal completion query identified by the `TEdit` owner in `Sender` as an internal marker.

There is no project-owned event dispatcher.

### 7. Shared FMX controls

The implementation reuses only framework controls when behavior crosses contract branches:

- the root `TRectangle`, materialized by Rectangle;
- the runtime `TEdit`, materialized by Designer;
- six `TPath` instances created by the composition root and shared by Config/Validation/Designer.Config;
- one lazy error `TLabel`, materialized exclusively by `Labels.Error.Text`, owned by the runtime `TEdit` and visually parented to the root rectangle; Validation only finds and updates it when it already exists.

These objects use FMX ownership and do not carry domain state outside the responsibilities defined by the contracts. The error label is reused through `TEdit.Components`; no project-owned context, tag, service locator, or helper is used.

## Class and dependency map

| Contract / class | Primary responsibility | Relevant legitimate dependencies |
|---|---|---|
| `IRickUIBuilderEdit` / `TRickUIBuilderEdit` | composition root, `Parent`, `Build`, shared controls | interfaces of the five branches + FMX controls |
| `IRickUIBuilderEditRetangle` / `TRickUIBuilderEditRetangle` | `TRectangle`, CornerRadius and children | `IRickUIBuilderEdit` |
| `IRickUIBuilderEditRetanglePosition` | Position | `IRickUIBuilderEditRetangle`, `TRectangle` |
| `IRickUIBuilderEditRetangleSize` | Size | `IRickUIBuilderEditRetangle`, `TRectangle` |
| `IRickUIBuilderEditRetangleBackground` | Normal/Invalid/ReadOnly colors | `TEdit`, `TRectangle`, `IRickUIBuilderEditDesignerValidation` |
| `IRickUIBuilderEditRetangleBorder` | Thickness and Normal/Focus/Invalid/ReadOnly colors | `TEdit`, `TRectangle`, Validation |
| `IRickUIBuilderEditLabel` | groups Main/Counter/Error | `TEdit`, Validation |
| `IRickUIBuilderEditLabelMain` | groups Main.Text | `TEdit`, Validation |
| `IRickUIBuilderEditLabelMainText` | main label text/size | `TLabel`, `TEdit`, Validation |
| `IRickUIBuilderEditLabelMainTextColor` | Text/Invalid/ReadOnly colors | `TLabel`, `TEdit`, Validation |
| `IRickUIBuilderEditLabelCounter` | Enabled and counter synchronization | `TEdit`, `TLabel`, `OnChangeTracking` |
| `IRickUIBuilderEditLabelError` | groups Error.Text | `TEdit`, root `TRectangle` |
| `IRickUIBuilderEditLabelErrorText` | Value/Color/Spacing | lazy `TEdit`-owned `TLabel` |
| `IRickUIBuilderEditLabelErrorTextFont` | Family/Size/Styles | `TLabel` |
| `IRickUIBuilderEditDesigner` | creates `TEdit`; groups Input/Validation/Config | shared paths |
| `IRickUIBuilderEditDesignerInput` | groups Text/Number/Config | `TEdit`, background |
| `IRickUIBuilderEditDesignerInputText` | Value/Size | `TEdit` |
| `IRickUIBuilderEditDesignerInputTextColor` | Background/Text/ReadOnly | `TEdit`, background |
| `IRickUIBuilderEditDesignerInputNumber` | numeric rules | `TEdit`, `OnValidate`, `OnValidating` |
| `IRickUIBuilderEditDesignerInputConfig` | Preset, masks, CaseMode, UrlCaseMode, MaxLength, caret and preset completion | `TEdit`, `IRickUIBuilderEditDesignerInput`, `OnValidating` |
| `IRickUIBuilderEditDesignerValidation` | Required, Completion Validation, Feedback, Invalid and RequirementMet | `TEdit`, `OnExit`, `OnChangeTracking`, alert/requirement paths, lazy error label |
| `IRickUIBuilderEditDesignerConfig` | ClearButton, Password, ReadOnly | `TEdit`, clear/visibility paths |
| `IRickUIBuilderEditLine` | Thickness and internal line target | root `TRectangle` |
| `IRickUIBuilderEditLineColor` | Normal/Focus/Invalid/ReadOnly | root `TRectangle`; lazily observed `TEdit`; Validation resolved once the control exists |
| `IRickUIBuilderEditConfig` | Appearance and Icons | shared paths |
| `IRickUIBuilderEditConfigIcons` | Size and Colors/Paths grouping | shared paths |
| `IRickUIBuilderEditConfigIconColors` | path colors | `TPath` |
| `IRickUIBuilderEditConfigIconPaths` | path data | `TPath` |

## Visual-state flow

There is no `TRickUIBuilderEditVisualState`.

State comes from the legitimate implementation that owns it:

```text
Invalid
→ IRickUIBuilderEditDesignerValidation.InvalidValue

ReadOnly
→ TEdit.ReadOnly

Focus
→ local handler only in contracts that expose a Focus variation
```

Preserved precedence:

```text
Background:
Invalid > ReadOnly > Normal

Border:
Invalid > ReadOnly > Focus > Normal

Line:
Invalid > ReadOnly > Focus > Normal

Main label:
Invalid > ReadOnly > Normal

Input text:
ReadOnly > Normal
```

`Designer.Validation.Invalid(...)` and `Designer.Config.ReadOnly(...)` request a visual refresh through the existing `OnEnter` handler chain, using `Sender = nil` only for the internal refresh. Focus-aware contracts do not change their local focus flag when `Sender` is `nil`.

## Input flow

There is no `TRickUIBuilderEditInputRules`.

The runtime target is a normal `TEdit` created by `TRickUIBuilderEditDesigner`.

`IRickUIBuilderEditDesignerInputConfig` owns the text-oriented rules represented by its contract:

- CPF;
- alphanumeric CNPJ;
- CEP;
- Phone;
- Mobile;
- Email;
- URL;
- `CaseMode`;
- `UrlCaseMode`;
- `MaxLength`;
- text transformation and caret preservation.

`IRickUIBuilderEditDesignerInputNumber` owns:

- `AllowNegative`;
- `DecimalPlaces`;
- `FormatMode`;
- `DecimalSeparator`;
- `ThousandSeparator`;
- `UseThousandSeparator`;
- IntegerNumber and FloatNumber validation.

For numeric presets, `Input.Config` materializes `Input.Number` through the existing parent interface. Both contracts operate on the same `TEdit`; numeric validation is exposed through the control validation cycle, without a concrete-class cast or intermediary project-owned class.

## Completion Validation

`IRickUIBuilderEditDesignerValidation` chains `OnExit` to decide automatic invalid state. Empty values are evaluated with `Trim`: when `Required` is active, empty or whitespace-only input is invalid; otherwise empty input remains valid.

For non-empty values, Validation materializes `Input.Config` through the existing interface navigation and queries completion through the same `TEdit.OnValidating`, passing the edit owner in `Sender` as an internal marker. `Input.Config` recognizes only that owner identity as a completion query; ordinary FMX validation uses the edit itself as sender and internal numeric calls keep `Sender=nil` and follow the normal `Input.Number` chain. This requires no GUID, `Supports`, concrete-class cast, tag, Context object, or auxiliary helper.

`Input.Config` keeps the preset rule it already owns: masks must be complete, Email requires a valid local part and domain, and URL requires a valid authority with a supported scheme when a scheme is present.

Automatic invalid state is separate from consumer-supplied `Invalid(...)`. A later edit clears only the automatic state through `OnChangeTracking`; an explicit `Invalid(...)` remains active until explicitly changed. `InvalidValue` exposes the effective state to visual contracts without changing `HasInvalid` or `InvalidMessage`, which continue to describe the explicit contract state.

## Counter, clear, password and requirement

These responsibilities are no longer centralized in a generic runtime object:

```text
Counter
→ IRickUIBuilderEditLabelCounter

ClearButton / Password / ReadOnly
→ IRickUIBuilderEditDesignerConfig

RequirementIndicator / RequirementMet
→ IRickUIBuilderEditDesignerValidation
```

The `TPath` instances are the same objects configured by `IRickUIBuilderEditConfigIcons`, so visual configuration and behavior act on the same FMX controls without duplicated state.

## Validation feedback

`IRickUIBuilderEditDesignerValidation` is the source of truth for:

- `Feedback`;
- `DefaultMessage`;
- `Invalid`;
- `InvalidMessage`;
- `RequirementIndicator`;
- `RequirementMet`.

`Labels.Error.Text` is the only implementation that materializes the lazy `TLabel` owned by the runtime `TEdit`. If `Invalid` was configured first, Error.Text reapplies the existing state through `IRickUIBuilderEditDesignerValidation`, using only the existing public contract; afterwards Validation finds and updates the same control. Styling does not reset active message/visibility state. The same alert `TPath` is configured by `Config.Icons` and has its visibility determined by Validation. This preserves either configuration/materialization order without a context class.

## Event receiver lifetime

The component must keep reacting to events after the root interface is released while the FMX tree remains alive.

Receivers that need FMX ownership remain `TComponent`: `Input.Config` and the control-bound visual contracts are owned by the `TEdit`; `Line.Color` is owned by the root `TRectangle` because it may be materialized before the `TEdit`.

`Designer.Validation` remains a `TInterfacedObject`. While the builder exists, Designer retains its interface. After `Build`, the visual receivers materialized by the composition root retain `IRickUIBuilderEditDesignerValidation`, keeping the `OnExit`/`OnChangeTracking` receiver alive for the FMX tree lifetime. This avoids turning Validation into a non-reference-counted `TComponent`.

`Line.Color` continues to use `TComponent.Notification` and free notification exclusively to observe a `TEdit` created after it. Upward navigation references remain `[weak]`.

## Rules that remain prohibited

Do not introduce:

- `TRickUIBuilderEditContext`;
- `TRickUIBuilderEditVisualState`;
- `TRickUIBuilderEditInputRules`;
- generic `Interaction`;
- generic `Runtime`;
- `Coordinator`;
- `Manager`;
- `Materializer`;
- service locator;
- aggregate settings record;
- a new interface merely to justify an auxiliary class.

Future evolution must continue to place responsibility in the implementation corresponding to an existing interface unless the user explicitly authorizes a contract change.
