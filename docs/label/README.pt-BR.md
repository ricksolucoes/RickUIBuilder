# Documentação Técnica do Label

> [English](README.md) | [Português do Brasil](README.pt-BR.md)

## Visão geral

`TRickUIBuilder.Label_` cria `TLabel` FireMonkey em runtime por meio de uma Fluent API. O builder acumula configuração e só materializa o controle em `Build(AParent)`. O `_` faz parte do ponto de entrada público para evitar conflito com a sintaxe do Object Pascal.

## Fluxo

```text
TRickUIBuilder.Label_
  → IRickUIBuilderLabel
  → TRickUIBuilderLabelBuilder
  → TRickUIBuilderTextConfig
  → TRickUIBuilderFactory.CreateText
  → TLabel
  → propriedades adicionais do Builder
```

A Factory cobre a configuração textual básica. O Builder complementa `Anchors`, `Margin`, `Padding`, família da fonte, itálico, alinhamento vertical, `WordWrap`, `Trimming`, `Opacity`, `Visible`, `HitTest` e `Tag`.

## Mapa

| Documento | Conteúdo |
|---|---|
| [API e configuração](api-e-configuracao.pt-BR.md) | Métodos, defaults, Factory e semântica de layout. |
| [Comportamento e exemplos](comportamento-e-exemplos.pt-BR.md) | Materialização, ownership, margin/padding e exemplos. |

## Invariantes

- `Build` usa `AParent` como Owner e Parent do `TLabel`.
- `Margin.Left/Top` são somados a `Position`; `Right/Bottom` não redimensionam o Label.
- `Padding` atua na área interna do `TLabel` e não altera `Width/Height`.
- Não existe Handle ou Behavior para Label.

## Mapa de manutenção

| Alteração | Leia primeiro |
|---|---|
| Fluent API ou semântica de Build | `src/Rick.UIBuilder._Label.pas`, `src/Rick.UIBuilder.Interfaces.pas` |
| Config/defaults compartilhados de texto | `src/Rick.UIBuilder.Types.pas`, `src/Rick.UIBuilder.Factory.pas` |
| Layout (`Margin`/`Padding`) | `src/Rick.UIBuilder._Label.pas` e [Comportamento e exemplos](comportamento-e-exemplos.pt-BR.md) |
| Regressão de contrato | `tests/src/Rick.UIBuilder.Tests._Label.pas` |

## Contratos testados

A fixture DUnitX atual `tests/src/Rick.UIBuilder.Tests._Label.pas` cobre chaining da Fluent API e contratos de materialização, incluindo Parent, posição, tamanho, texto, cor da fonte, `Margin`, `Padding`, bold, `Tag` e valores padrão. Isso descreve a cobertura atual dos testes; não é garantia contra regressões futuras.
