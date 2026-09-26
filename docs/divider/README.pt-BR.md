# Documentação Técnica do Divider

> [English](README.md) | [Português do Brasil](README.pt-BR.md)

## Visão geral

`TRickUIBuilder.Divider` cria um `TRectangle` usado como separador horizontal ou vertical. Não há Handle nem Behavior.

| Documento | Conteúdo |
|---|---|
| [API e exemplos](api-e-exemplos.pt-BR.md) | Métodos, defaults, orientação, Factory e exemplos. |

A regra central é que `Width` representa o comprimento lógico: no modo Horizontal vira a largura; no Vertical vira a altura. `Thickness` ocupa o eixo perpendicular.

## Mapa de manutenção

| Alteração | Leia primeiro |
|---|---|
| Fluent API ou geometria de orientação | `src/Rick.UIBuilder.Divider.pas`, `src/Rick.UIBuilder.Interfaces.pas` |
| Factory/config default | `src/Rick.UIBuilder.Factory.pas`, `src/Rick.UIBuilder.Types.pas` |
| Regressão de contrato | `tests/src/Rick.UIBuilder.Tests.Divider.pas` |

## Contratos testados

A fixture DUnitX atual `tests/src/Rick.UIBuilder.Tests.Divider.pas` cobre chaining da Fluent API, materialização/Parent, posição, `Margin`, cor, geometria horizontal e vertical, `Thickness` padrão de um pixel e `Visible`. Isso registra somente a cobertura atual.
