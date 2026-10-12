# Edit architecture and maintenance

🇧🇷 [Português](arquitetura-e-manutencao.pt-BR.md)

This document records the architectural decisions already established for the **new Edit** being built under `src/Edit/`. It is maintenance documentation, not a claim that the migration is already complete.

The legacy Edit remains in the repository and continues to be the validated implementation until the new architecture is fully reviewed and accepted by the project owner.

## Migration boundary

The new implementation lives under:

```text
src/Edit/
```

The legacy implementation remains outside that directory and must not be removed or rewritten as part of the new architecture unless a task explicitly authorizes it.

The legacy code may be consulted as behavioral evidence, but it does not define the physical organization of the new implementation. The new implementation must not depend on legacy Edit units.

## Contract source of truth

The official interface contract for the new Edit is:

```text
src/Edit/Rick.UIBuilder.Edit.Interfaces.pas
```

All public interfaces of the new Edit remain in that unit.

During implementation, this file is **read-only by default**. The implementation must adapt to the existing contract. Changing an interface is allowed only when the user explicitly requests a contract change in the current task.

Implementation convenience is not authorization to change:

- a method return type;
- a parameter;
- an overload;
- a GUID;
- a member name;
- public spelling;
- fluent navigation;
- or to add a getter/state/runtime/handle member.

If the contract looks unusual, preserve it until an explicit contract-change task says otherwise.

## Types boundary

Records, enums, and other shared domain types of the new Edit remain in:

```text
src/Edit/Rick.UIBuilder.Edit.Types.pas
```

Do not declare shared domain records, enums, DTOs, or configuration types inside concrete implementation units.

## One public interface, one implementation, one unit

The new Edit has a specific physical-organization rule:

```text
1 public interface
        ↓
1 corresponding concrete class
        ↓
1 exclusive implementation unit
```

For the current contract this means:

```text
28 public interfaces
=
28 concrete classes
=
28 implementation units
```

Nominal correspondence is preserved:

```text
I<Name>
→ T<Name>
→ exclusive implementation unit
```

Example:

```text
IRickUIBuilderEditRetangle
→ TRickUIBuilderEditRetangle
→ Rick.UIBuilder.Edit.Rectangle.pas
```

Do not regroup sibling implementations such as Rectangle.Position, Rectangle.Size, Rectangle.Background, and Rectangle.Border into a single implementation unit.

This 1 → 1 → 1 rule is a decision for the new Edit. It must not be generalized automatically to unrelated RickUIBuilder components.

## Internal infrastructure is not part of the 28 implementations

The new Edit also uses internal infrastructure classes that do not correspond to public interfaces. Known examples from the implementation work include:

```text
Rick.UIBuilder.Edit.Context.pas
Rick.UIBuilder.Edit.InputRules.pas
Rick.UIBuilder.Edit.Control.pas
Rick.UIBuilder.Edit.Interaction.pas
Rick.UIBuilder.Edit.Materializer.pas
```

These units are helpers/infrastructure. They are not counted among the 28 public implementations.

Do not create interfaces for helpers merely to make the architecture symmetrical. Introduce a new abstraction only when a real responsibility and an authorized scope justify it.

## Implementation adapts to the contract

When an implementation needs context, state, or another level of the fluent chain, do not change the interface to make navigation easier.

The expected direction is:

```text
official contract
        ↓
concrete implementation
        ↓
uses existing contracts/origin
for the required context
```

Not:

```text
implementation needs something
        ↓
change public interface
        ↓
add a convenient return/getter/path
```

If the required information already belongs to another interface, depend on that existing contract. When there is a clear parent/origin, pass the required contract to the specialized implementation through Dependency Injection when appropriate.

Do not replace that relationship with:

- a new public getter;
- a new interface only for transporting state;
- duplicated state;
- a global or service locator;
- reconstruction of the parent;
- or a second path to the same context.

Dependency Inversion here means depending on the correct existing contract. It does not mean creating another interface for symmetry.

## Fluent return example

If an existing specialized interface must return to its origin contract, the implementation needs access to that origin contract.

Conceptually:

```text
MainText
   ↓ Color
MainTextColor
   ↓ Invalid(...)
MainText
```

If `Invalid(...)` is declared to return `IRickUIBuilderEditLabelMainText`, the concrete Color implementation must be able to return that existing contract. It must not change the method to return `IRickUIBuilderEditLabelMainTextColor` simply because that is easier internally.

The same principle applies throughout the new Edit: the public interface defines the navigation; implementation follows it.

## Migration strategy

The migration is deliberately incremental:

```text
legacy remains available
        ↓
new contract/types established under src/Edit/
        ↓
new implementations are built and audited
        ↓
Delphi/DUnitX validation by the project owner
        ↓
only then can legacy replacement/removal be considered
```

Do not remove legacy code early. Do not change Samples, tests, facade, package/project files, or legacy behavior as part of an implementation increment unless the current task explicitly includes them.

## Repository and delivery rules

For AI-assisted work in this project:

- GitHub is read-only for the agent;
- the current `main` must be rechecked before a new implementation increment;
- repository mutations are not performed by the agent;
- the project owner receives the files/ZIP first and performs the final Delphi/DUnitX validation;
- incremental ZIPs contain only files created or actually modified by the task, preserving repository-relative paths;
- files used only as ChatGPT Project sources are not repository files unless the repository itself contains them.

Before packaging an Edit implementation increment, audit dependencies, referenced types, helper units, `Types`, implementation units, and only the package/project files actually changed by that increment.

## Governance references

Process rules live under `.agents/`, not in this document. The detailed policies are:

- [`.agents/references/interface-contract-preservation-policy.md`](../../.agents/references/interface-contract-preservation-policy.md) — protects existing contracts;
- [`.agents/references/interface-implementation-unit-policy.md`](../../.agents/references/interface-implementation-unit-policy.md) — protects the new Edit's physical 1 → 1 → 1 organization.

This document records the component architecture and maintenance boundaries so they remain recoverable independently of conversation history.
