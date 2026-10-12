# Edit architecture and maintenance

🇧🇷 [Português](arquitetura-e-manutencao.pt-BR.md)

This document records the permanent architectural decisions for the **new Edit** being built under `src/Edit/`.

It does not claim that migration is complete. The legacy Edit remains in the repository and continues to be the validated implementation until the new architecture is reviewed and accepted by the project owner.

For the detailed assembly/dependency blueprint, see [New Edit assembly and dependency map](montagem-e-dependencias.md).

## Migration boundary

The new implementation lives under:

```text
src/Edit/
```

The legacy implementation remains outside this directory and must not be removed or rewritten without explicit authorization.

Legacy code may be consulted as behavioral evidence, but it does not define the physical organization of the new implementation. The new implementation must not depend on legacy Edit units.

## Contract source of truth

The official contract is:

```text
src/Edit/Rick.UIBuilder.Edit.Interfaces.pas
```

Implementation must adapt to the current contract. Internal convenience does not authorize changing returns, parameters, overloads, GUIDs, members, spelling, fluent navigation, or adding auxiliary getter/state/handle members.

The interface changes only when the user explicitly requests a contract change in the current task.

## Entry point and composition root

The external entry point is `IRickUIBuilderEdit`.

The current root contract includes:

```delphi
function Parent(AParentConstructor: TFmxObject): IRickUIBuilderEdit;
function Build: IRickUIBuilderEdit;
```

The `IRickUIBuilderEdit` implementation is the logical composition root. The specialized tree originates from it and remains reachable only through navigation already defined by the contract.

Consumers must not need concrete classes, internal helpers, or parallel state paths.

## 1 → 1 → 1 organization

For the 28 public interfaces of the new Edit:

```text
1 public interface
        ↓
1 corresponding concrete class
        ↓
1 exclusive implementation unit
```

Therefore:

```text
28 public interfaces
=
28 concrete classes
=
28 implementation units
```

Nominal correspondence remains explicit:

```text
I<Name>
→ T<Name>
→ exclusive unit
```

A public implementation unit must not contain a second public implementation, interface, record, enum, DTO, or shared domain configuration type.

## Types

Public/shared new-Edit types belong in:

```text
src/Edit/Rick.UIBuilder.Edit.Types.pas
```

That boundary does not authorize settings records for convenience. Every new type requires a proven need.

## Dependency Injection and context

When a specialized interface depends on another contract's context:

- inject the parent contract;
- keep `FParent` only when return navigation requires it;
- place `[weak]` on its own line;
- retain the child interface strongly from the parent;
- do not reconstruct Parent/origin;
- do not use a service locator;
- do not create a central `Context` merely to transport state;
- do not duplicate state owned by another implementation.

Required formatting:

```delphi
[weak]
FParent: IRickUIBuilderEditDesigner;
```

Methods implementing the interface remain `protected`; the concrete class public surface stays minimal.

## State belongs to the contract that represents it

Each implementation retains only the context of its own responsibility.

When configuration can be applied directly to the FMX object configured by the interface, prefer that object as effective state.

When an interface represents multiple configured values simultaneously, those values may remain fields of that corresponding implementation.

Do not centralize the entire component state in an aggregate record or class simply to make `Build` easier.

## Helpers are not assumed

No helper class is mandatory by symmetry or convenience.

In particular, prior implementation attempts do not automatically authorize a central Context, custom `TEdit` subclass, `InputRules`, `Interaction`, `Materializer`, or aggregate settings records.

If implementation discovers a need the contract tree cannot satisfy, that need must be proven before creating a new abstraction.

## Lifetime

A parent retains specialized children through interfaces. A child keeps the parent contract as a weak reference when it must return up the chain.

Therefore, while the root `IRickUIBuilderEdit` remains referenced, the descendant interface tree can remain alive without a strong reference-counting cycle.

`Parent(AParentConstructor)` retains the assembly-location reference for `Build`; a plain `TFmxObject` reference does not transfer ownership or automatically extend the supplied object's lifetime.

Concrete FMX lifecycle behavior must be validated through code/test evidence before making ownership guarantees.

## Implementation strategy

```text
current contract
    ↓
dependency map
    ↓
relationship/lifetime proof
    ↓
1 → 1 → 1 implementations
    ↓
independent audit
    ↓
Delphi/DUnitX validation by project owner
```

Do not introduce a helper/type merely to unblock implementation. When difficulty appears, return to the contract map and demonstrate the actual dependency.

## Repository and delivery

- GitHub remains read-only for the agent;
- current `main` is rechecked before each increment;
- legacy remains until explicit validation;
- incremental ZIP contains only created/modified files;
- build/test/toxicity claims require actual execution.

## References

- [New Edit assembly and dependency map](montagem-e-dependencias.md)
- [Interface Contract Preservation Policy](../../.agents/references/interface-contract-preservation-policy.md)
- [Interface Implementation Unit Policy](../../.agents/references/interface-implementation-unit-policy.md)
