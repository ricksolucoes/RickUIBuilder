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

The parent stores the child through its corresponding interface. `TInterfacedObject` implementations use reference counting; `TComponent` event receivers follow `TEdit` ownership. The upward `[weak]` reference avoids a strong cycle while preserving fluent navigation.

### 5. Dependency Injection carries the real dependency

Implementations may receive:

- the parent contract for `ToBack`;
- existing interfaces when behavior depends on another contract;
- FMX controls (`TEdit`, `TRectangle`, `TLabel`, `TPath`) when those controls are the real configured target.

There is no `Context`, service locator, aggregate settings record, or project-owned concrete helper used as a state bus between branches.

### 6. Runtime events remain in legitimate implementations

FMX events do not justify a helper class.

Implementations that must survive as event receivers are the concrete classes corresponding to existing interfaces. When needed, those implementations derive from `TComponent` and are owned by the runtime `TEdit`.

Handlers preserve and chain the previously installed handler:

- `OnChangeTracking`: input configuration, counter, and clear button;
- `OnEnter` / `OnExit`: visual contracts reacting to Focus/ReadOnly/Invalid;
- `OnClick`: clear and password visibility;
- `OnValidate` / `OnValidating`: cooperation between `Input.Config` and `Input.Number` over the same `TEdit`.

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
| `IRickUIBuilderEditDesignerInputConfig` | Preset, masks, CaseMode, UrlCaseMode, MaxLength and caret | `TEdit`, `IRickUIBuilderEditDesignerInput` |
| `IRickUIBuilderEditDesignerValidation` | Required, RequirementIndicator, Feedback, Invalid and RequirementMet | `TEdit`, alert/requirement paths, lazy error label |
| `IRickUIBuilderEditDesignerConfig` | ClearButton, Password, ReadOnly | `TEdit`, clear/visibility paths |
| `IRickUIBuilderEditLine` | Thickness and internal line target | `TEdit`, Validation |
| `IRickUIBuilderEditLineColor` | Normal/Focus/Invalid/ReadOnly | `TEdit`, Validation |
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

Implementations corresponding to interfaces that receive events may therefore be components owned by the `TEdit`. This does not create an extra class and does not retain the root through a strong parent reference.

Visual contracts that need to read `Invalid` retain `IRickUIBuilderEditDesignerValidation`; upward navigation references remain `[weak]`.

During `TEdit` destruction, receivers do not attempt to restore handlers on the owner while `csDestroying` is active.

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
