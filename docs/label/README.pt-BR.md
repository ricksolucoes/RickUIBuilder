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
