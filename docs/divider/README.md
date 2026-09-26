# Divider Technical Documentation

> [English](README.md) | [Português do Brasil](README.pt-BR.md)

## Overview

`TRickUIBuilder.Divider` creates a `TRectangle` used as a horizontal or vertical separator. There is no Handle or Behavior.

| Document | Content |
|---|---|
| [API and examples](api-e-exemplos.md) | Methods, defaults, orientation, Factory, and examples. |

The central rule is that `Width` represents logical length: in Horizontal mode it becomes width; in Vertical mode it becomes height. `Thickness` occupies the perpendicular axis.

## Maintenance map

| Change | Read first |
|---|---|
| Fluent API or orientation geometry | `src/Rick.UIBuilder.Divider.pas`, `src/Rick.UIBuilder.Interfaces.pas` |
| Factory/default config | `src/Rick.UIBuilder.Factory.pas`, `src/Rick.UIBuilder.Types.pas` |
| Contract regression | `tests/src/Rick.UIBuilder.Tests.Divider.pas` |

## Tested contracts

The current DUnitX fixture `tests/src/Rick.UIBuilder.Tests.Divider.pas` covers fluent chaining, materialization/Parent, position, `Margin`, color, horizontal and vertical geometry, the default one-pixel `Thickness`, and `Visible`. This records current coverage only.
