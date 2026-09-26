# Label Technical Documentation

> [English](README.md) | [Português do Brasil](README.pt-BR.md)

## Overview

`TRickUIBuilder.Label_` creates a FireMonkey `TLabel` at runtime through a fluent API. The builder accumulates configuration and materializes the control only in `Build(AParent)`. The trailing `_` is part of the public entry point to avoid an Object Pascal syntax conflict.

## Flow

```text
TRickUIBuilder.Label_
  → IRickUIBuilderLabel
  → TRickUIBuilderLabelBuilder
  → TRickUIBuilderTextConfig
  → TRickUIBuilderFactory.CreateText
  → TLabel
  → additional Builder properties
```

The Factory covers basic text configuration. The Builder adds `Anchors`, `Margin`, `Padding`, font family, italic, vertical alignment, `WordWrap`, `Trimming`, `Opacity`, `Visible`, `HitTest`, and `Tag`.

## Documentation map

| Document | Content |
|---|---|
| [API and configuration](api-e-configuracao.md) | Methods, defaults, Factory, and layout semantics. |
| [Behavior and examples](comportamento-e-exemplos.md) | Materialization, ownership, margin/padding, and examples. |

## Invariants

- `Build` uses `AParent` as both Owner and Parent of the `TLabel`.
- `Margin.Left/Top` are added to `Position`; `Right/Bottom` do not resize the Label.
- `Padding` affects the internal `TLabel` area and does not change `Width/Height`.
- Label has no Handle or Behavior.

## Maintenance map

| Change | Read first |
|---|---|
| Fluent API or Build semantics | `src/Rick.UIBuilder._Label.pas`, `src/Rick.UIBuilder.Interfaces.pas` |
| Shared text defaults/config | `src/Rick.UIBuilder.Types.pas`, `src/Rick.UIBuilder.Factory.pas` |
| Layout (`Margin`/`Padding`) | `src/Rick.UIBuilder._Label.pas` and [Behavior and examples](comportamento-e-exemplos.md) |
| Contract regression | `tests/src/Rick.UIBuilder.Tests._Label.pas` |

## Tested contracts

The current DUnitX fixture `tests/src/Rick.UIBuilder.Tests._Label.pas` covers fluent chaining and materialization contracts including Parent, position, size, text, font color, `Margin`, `Padding`, bold, `Tag`, and default values. This describes current test coverage; it is not a guarantee against future regressions.
