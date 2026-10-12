# New Edit assembly and dependency map

This document records the **implementation blueprint** for the new `Edit`, derived from the current contract in `src/Edit/Rick.UIBuilder.Edit.Interfaces.pas` and the active project governance.

It does not describe a completed implementation. Its purpose is to prevent implementation choices from being invented for convenience while coding.

## Decision sources

Implementation decisions must be derived only from:

1. the current `Rick.UIBuilder.Edit.Interfaces.pas` contract;
2. `api-and-interface-design`;
3. `interface-contract-preservation-policy.md`;
4. `interface-implementation-unit-policy.md`;
5. behavior proven by code/tests/documentation when required.

Previous experimental implementations or ZIPs are not architectural sources.

## Assembly principles

### 1. Single external entry point

The external entry point is `IRickUIBuilderEdit`.

Consumers may navigate specialized interfaces through the fluent API, but they must not need concrete classes, internal helpers, or parallel state mechanisms.

`IRickUIBuilderEdit` is the logical **composition root** of the new component.

### 2. The interface tree is the primary dependency tree

Preserve the relationship already defined by the contract:

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
├── Edit
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

Assembly originates at the root implementation. Each parent implementation creates and retains only the child contracts that belong to its own branch.

### 3. Downward references are strong; the return-to-parent reference is weak

The parent retains children through interfaces so the interface tree remains alive.

A child implementation receives its parent contract through injection when fluent navigation must return upward.

Required formatting:

```delphi
[weak]
FParent: IRickUIBuilderEditDesigner;
```

Do not write `[weak] FParent: ...` on one line.

The weak upward reference prevents a reference-counting cycle when the parent also owns the child interface.

### 4. Interface implementations remain `protected`

Concrete classes keep their public surface minimal.

Structural pattern:

```delphi
type
  TRickUIBuilderEditExample = class(TInterfacedObject, IRickUIBuilderEditExample)
  private
    [weak]
    FParent: IRickUIBuilderEditParent;
  protected
    constructor Create(const AParent: IRickUIBuilderEditParent);

    function Configure(AValue: Boolean): IRickUIBuilderEditExample;
    function ToBack: IRickUIBuilderEditParent;
  public
    class function New(const AParent: IRickUIBuilderEditParent): IRickUIBuilderEditExample;
  end;
```

Do not promote interface methods to `public` without proven need.

### 5. Each implementation owns only its contract context

There is no authorization for a central `Context` that aggregates the whole Edit state.

When a setting can be applied directly to the FMX object configured by that interface, prefer that object as the effective state.

When the contract represents multiple simultaneous configured values that cannot coexist in one runtime property—for example Normal/Invalid/ReadOnly colors—the corresponding implementation may retain those values in its own fields.

Do not duplicate the same state in multiple interfaces.

### 6. Dependency Injection carries the real dependency

Two different dependencies may be injected:

- the **parent contract**, for fluent navigation and `ToBack`;
- the **specific target object**, only when a specialized interface configures an internal object created by its parent and that object is not exposed by the public contract.

The second case does not authorize a context bag, service locator, or aggregate settings record. It is direct injection of the concrete dependency that the implementation actually configures.

### 7. Helpers require proven responsibility

The architecture still does not pre-approve:

- `TRickUIBuilderEditContext`;
- a custom `TEdit` subclass;
- `TRickUIBuilderEditInputRules`;
- `TRickUIBuilderEditInteraction`;
- `TRickUIBuilderEditMaterializer`;
- aggregate configuration records.

Increment 2B proved one specific cross-branch responsibility and introduced `TRickUIBuilderEditVisualState`. This internal helper **is not a Context**: it stores only the active Focus, Invalid and ReadOnly flags, broadcasts state-change notifications, and keeps the focus-event receiver alive after `Build`. Colors remain owned by the specialized contracts that represent them.

Any additional helper still requires a need proven by contract/behavior and cannot exist merely because it makes implementation easier.

### 8. `Parent` preserves the assembly location reference, not ownership

The current root contract is:

```delphi
function Parent(AParentConstructor: TFmxObject): IRickUIBuilderEdit;
function Build: IRickUIBuilderEdit;
```

The root implementation must retain the supplied reference so `Build` knows where to attach/materialize the component.

A plain `TFmxObject` reference **does not extend the lifetime** of the supplied object. Ownership of `AParentConstructor` remains external. The exact retention/clearing strategy must follow FMX lifecycle evidence before final implementation.

Because `Build` returns `IRickUIBuilderEdit`, the consumer can retain the root after assembly; that also keeps the child-interface tree alive while the root remains referenced.

## Class and dependency map

| Contract / nominal class | Created by | Injected parent dependency | Context owned by the implementation | Children retained | Architectural note |
|---|---|---|---|---|---|
| `IRickUIBuilderEdit` / `TRickUIBuilderEdit` | composition entry | none | `Parent` reference and five top-level branch references | Rectangle, Labels, Edit, Line, Config | only external composition root |
| `IRickUIBuilderEditRetangle` / `TRickUIBuilderEditRetangle` | root | `IRickUIBuilderEdit` | `TRectangle` exposed by `Control` and CornerRadius | Position, Size, Background, Border | `TRectangle` is the natural target for the branch |
| `IRickUIBuilderEditRetanglePosition` | Rectangle | `IRickUIBuilderEditRetangle` | no duplicated state when writing to `FParent.Control.Position` is sufficient | none | uses the control already exposed by parent contract |
| `IRickUIBuilderEditRetangleSize` | Rectangle | `IRickUIBuilderEditRetangle` | no duplicated state when writing to `FParent.Control` is sufficient | none | uses the control already exposed by parent contract |
| `IRickUIBuilderEditRetangleBackground` | Rectangle | `IRickUIBuilderEditRetangle` | Normal/Invalid/ReadOnly values owned by Background | none | receives `VisualState` through DI and resolves only the states it owns |
| `IRickUIBuilderEditRetangleBorder` | Rectangle | `IRickUIBuilderEditRetangle` | Thickness plus Normal/Focus/Invalid/ReadOnly colors | none | receives `VisualState` through DI; local precedence is Invalid > ReadOnly > Focus > Normal |
| `IRickUIBuilderEditLabel` | root | `IRickUIBuilderEdit` | label sub-contract references only | Main, Counter, Error | label branch grouping contract |
| `IRickUIBuilderEditLabelMain` | Labels | `IRickUIBuilderEditLabel` | Text reference | Text | must not accumulate state belonging to Text |
| `IRickUIBuilderEditLabelMainText` | Main | `IRickUIBuilderEditLabelMain` | Value, Size and internal main-text target | Color | exact FMX target class must be confirmed before coding |
| `IRickUIBuilderEditLabelMainTextColor` | MainText | `IRickUIBuilderEditLabelMainText` | Text/Invalid/ReadOnly colors | none | participates in `VisualState`; Invalid and ReadOnly still return `FParent` by contract |
| `IRickUIBuilderEditLabelCounter` | Labels | `IRickUIBuilderEditLabel` | Enabled and internal counter target | none | synchronization with Designer text needs proven mechanism |
| `IRickUIBuilderEditLabelError` | Labels | `IRickUIBuilderEditLabel` | Text reference | Text | error grouping contract |
| `IRickUIBuilderEditLabelErrorText` | Error | `IRickUIBuilderEditLabelError` | Value, Color, Spacing and error-message target | Font | Font receives only the target it actually configures |
| `IRickUIBuilderEditLabelErrorTextFont` | ErrorText | `IRickUIBuilderEditLabelErrorText` | Family, Size, Styles or direct application to injected target | none | no aggregate record is needed for three local values |
| `IRickUIBuilderEditDesigner` | root | `IRickUIBuilderEdit` | `TEdit` exposed by `Control` and child-contract references | Input, Validation, Config | logical owner of the edit control |
| `IRickUIBuilderEditDesignerInput` | Designer | `IRickUIBuilderEditDesigner` | input sub-contract references | Text, Number, Config | input-domain grouping contract |
| `IRickUIBuilderEditDesignerInputText` | Input | `IRickUIBuilderEditDesignerInput` | Value/Size applied to `TEdit` when possible | Color | Size and ToBack return `FParent.ToBack` (Designer) |
| `IRickUIBuilderEditDesignerInputTextColor` | Input.Text | `IRickUIBuilderEditDesignerInputText` | Background/Text/ReadOnly colors | none | participates in `VisualState` for ReadOnly only; no Invalid state is invented |
| `IRickUIBuilderEditDesignerInputNumber` | Input | `IRickUIBuilderEditDesignerInput` | AllowNegative, DecimalPlaces, FormatMode, separators and UseThousandSeparator | none | typing/formatting coordination requires proof |
| `IRickUIBuilderEditDesignerInputConfig` | Input | `IRickUIBuilderEditDesignerInput` | Preset, CaseMode, UrlCaseMode, MaxLength | none | typing/formatting coordination requires proof |
| `IRickUIBuilderEditDesignerValidation` | Designer | `IRickUIBuilderEditDesigner` | Required, RequirementIndicator, Feedback, DefaultMessage and Invalid/RequirementMet state | none | Invalid updates the corresponding `VisualState` flag; contractual getters remain local |
| `IRickUIBuilderEditDesignerConfig` | Designer | `IRickUIBuilderEditDesigner` | ClearButton, Password, ReadOnly | none | ReadOnly applies to `TEdit` and updates `VisualState`; auxiliary controls still need proof |
| `IRickUIBuilderEditLine` | root | `IRickUIBuilderEdit` | Thickness and internal line target | Color | exact FMX line type is not assumed yet |
| `IRickUIBuilderEditLineColor` | Line | `IRickUIBuilderEditLine` | Normal/Focus/Invalid/ReadOnly colors | none | participates in `VisualState` while retaining its own colors |
| `IRickUIBuilderEditConfig` | root | `IRickUIBuilderEdit` | Appearance and Icons reference | Icons | do not create `ConfigSettings` merely to mirror the tree |
| `IRickUIBuilderEditConfigIcons` | Config | `IRickUIBuilderEditConfig` | Size and internal icon targets | Colors, Paths | Colors/Paths receive only the targets they configure |
| `IRickUIBuilderEditConfigIconColors` | Icons | `IRickUIBuilderEditConfigIcons` | Default/Alert/Clear/Password/Requirement colors | none | no aggregate record if target objects can be injected directly |
| `IRickUIBuilderEditConfigIconPaths` | Icons | `IRickUIBuilderEditConfigIcons` | Alert/Clear/Visibility/VisibilityOff/RequirementMet/RequirementNotMet paths | none | state pairs may remain fields of this implementation |

## Contract-determined special flows

### MainText.Color

```text
MainText
  ↓ Color
MainTextColor
  ├─ Text(...)     → MainTextColor
  ├─ Invalid(...)  → MainText
  ├─ ReadOnly(...) → MainText
  └─ ToBack        → MainText
```

Therefore `TRickUIBuilderEditLabelMainTextColor` receives `IRickUIBuilderEditLabelMainText` as `FParent` and returns that contract wherever required.

### Designer.Input.Text

```text
Designer
  ↓ Input
Input
  ↓ Text
InputText
  ├─ Value(...) → InputText
  ├─ Color      → InputTextColor
  ├─ Size(...)  → Designer
  └─ ToBack     → Designer
```

`TRickUIBuilderEditDesignerInputText` receives `IRickUIBuilderEditDesignerInput` as `FParent`.

When it must return Designer, it uses the existing contract navigation:

```delphi
Result := FParent.ToBack;
```

Do not add a second parent, getter, Context, or alternate return path.

## Proven decision — visual-state transitions

Increment 2B resolves Focus, Invalid and ReadOnly coordination without changing public contracts or centralizing configuration.

`TRickUIBuilderEditVisualState` is created by the root and injected only into branches that participate in visual-state transitions. It keeps three active flags and a list of internal handlers. `Validation.Invalid`, `Designer.Config.ReadOnly` and `TEdit.OnEnter/OnExit` change those flags; each specialized contract receives the notification and chooses colors only among the states that contract actually owns.

For contracts that define every state, precedence is:

```text
Invalid > ReadOnly > Focus > Normal
```

Precedence does not invent missing states. For example, `Designer.Input.Text.Color` defines Text and ReadOnly colors but has no Invalid color; an Edit that is both Invalid and ReadOnly therefore preserves the ReadOnly text color.

The helper does not store colors, settings, all branch controls, or domain rules. After `Build`, it is owned by the root `TRectangle` and keeps alive only the parent contracts of registered subscribers, which is sufficient to preserve visual-state handler receivers. Their upward references remain `[weak]`, so the root is not retained and no cycle is created between FMX ownership and reference counting. Destroying the visual tree releases the helper and the retained subscribers.

No central Context, public getter, auxiliary interface, concrete-class cast, or service locator is introduced.

## Points still requiring proof before implementation

The following mechanisms remain unresolved and must not be solved by convenience while coding.

### 1. Input rules

`Input.Number` and `Input.Config` contain data that must cooperate during typing/formatting.

Before introducing a helper such as `InputRules`, prove why the existing `Designer → Input → Text/Number/Config` tree plus the existing `TEdit` cannot own this behavior through DI.

### 2. Other runtime events

Do not create `Interaction = class(TComponent)` by default.

The `OnEnter/OnExit` events required exclusively for visual-state transitions now belong to `TRickUIBuilderEditVisualState`. Future input, clear, password, or requirement-indicator events still require their own proof and do not authorize expanding `VisualState` into a generic interaction object.

### 3. Materialization

Do not create a `Materializer` by default.

First determine whether the root and natural branch owners can create/configure their objects without concentrating all construction responsibilities in another class.

### 4. Additional records

`Rick.UIBuilder.Edit.Types.pas` currently contains the contract enums.

No settings record is pre-authorized. A new record must represent a proven domain need that cannot be represented by the owning implementation state or direct DI.

## Gate before coding starts

Before implementing the first concrete unit, the design must answer with evidence:

- who creates the class;
- which parent contract it receives;
- which child interfaces it retains;
- which state belongs exclusively to it;
- which FMX object it configures;
- who owns/destroys that object;
- if runtime events exist, what keeps the receiver alive;
- how cross-cutting state transitions propagate without duplication;
- why any additional helper/type is necessary.

If any answer still depends on assumption, that point remains **Not confirmed** and must not generate code yet.
