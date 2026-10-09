# Documentação Técnica do ComboBox

> [English](README.md) | [Português do Brasil](README.pt-BR.md)

## Visão geral

Este diretório é a referência técnica da implementação do ComboBox do RickUIBuilder. Ele documenta a API pública, responsabilidades internas das units, modos de apresentação, filtro, virtualização, lifetime em runtime, customização, testes e restrições de manutenção. A implementação é uma UI FireMonkey criada em runtime: o controle fechado é criado imediatamente, enquanto as superfícies de seleção são materializadas de forma lazy quando necessárias.

## Arquitetura resumida

```text
TRickUIBuilder.ComboBox ──┐
                            ├─→ TRickUIBuilderFactory.CreateComboBox
Factory direta ─────────────┘        ↓
TRickUIBuilderComboBoxConfig + TRickUIBuilderComboBoxFactoryOptions
                                      ↓
TRickUIBuilderComboBoxData + TRickUIBuilderComboBoxHandle
        ↓
TRickUIBuilderComboBoxState
TRickUIBuilderComboBoxPresentation
TRickUIBuilderComboBoxVirtualizer
```

O builder acumula estado e, em `Build`/`BuildHandle`, traduz esse estado para `TRickUIBuilderComboBoxConfig` + `TRickUIBuilderComboBoxFactoryOptions`. A Factory é o boundary comum de materialização: resolve style/presentation, cria `Data` e `Handle`, cria o controle fechado e anexa o behavior que mantém o runtime vivo enquanto a árvore visual existir. A criação direta chama o mesmo boundary sem passar pelo builder.

## Mapa da documentação

| Documento | Finalidade |
|---|---|
| [Arquitetura e dependências](arquitetura-e-dependencias.pt-BR.md) | Limites entre units, direção das dependências e invariantes arquiteturais. |
| [API pública e configuração](api-publica-e-configuracao.pt-BR.md) | Builder, handle, records, enums, defaults e semântica da configuração. |
| [Dados, seleção e filtro](dados-selecao-e-filtro.pt-BR.md) | Identidade do item, seleção, view filtrada e mapeamento de índices. |
| [Presentation Modes](presentation-modes.pt-BR.md) | `Auto`, `Anchored`, `Overlay` e `FullWindow`. |
| [FullWindow e pesquisa](fullwindow-e-pesquisa.pt-BR.md) | UI de pesquisa, comportamento de clear/back, empty state e resolução do host. |
| [Virtualização e renderização](virtualizacao-e-renderizacao.pt-BR.md) | Pool de rows, colunas, estado visual e conteúdo customizado. |
| [Lifecycle, ownership e handle](lifecycle-ownership-e-handle.pt-BR.md) | Lifetime do behavior, `FreeNotification`, regras de detach e referências non-owning. |
| [Customização e exemplos](customizacao-e-exemplos.pt-BR.md) | Exemplos progressivos baseados na API implementada. |
| [Testes e contratos](testes-e-contratos.pt-BR.md) | Contratos declarados, cobertura atual no código-fonte e baseline DUnitX histórica. |
| [Manutenção e armadilhas](manutencao-e-armadilhas.pt-BR.md) | Invariantes que devem ser preservadas em alterações futuras. |

## Trilhas de leitura recomendadas

Para alterações de API, leia primeiro **API pública e configuração**. Para mudanças de filtro ou seleção, leia **Dados, seleção e filtro** junto com **Virtualização e renderização**. Para Mobile ou FullWindow, leia **Presentation Modes**, **FullWindow e pesquisa** e **Lifecycle, ownership e handle**. Para ownership ou destruição, leia o documento de lifecycle antes de editar código.

## Pontos de entrada públicos

Existem dois pontos de entrada públicos para o mesmo runtime: `TRickUIBuilder.ComboBox`, que retorna `IRickUIBuilderComboBox`, e `TRickUIBuilderFactory.CreateComboBox`, que recebe `TRickUIBuilderComboBoxConfig` + `TRickUIBuilderComboBoxFactoryOptions`. Em ambos os casos, o runtime materializado pode ser acessado por `IRickUIBuilderComboBoxHandle`.

## Invariantes da implementação

- Os models/enums de domínio compartilhados permanecem em `Rick.UIBuilder.Types.pas`; `TRickUIBuilderComboBoxFactoryOptions` e `TRickUIBuilderComboBoxInitialSelectionMode` pertencem ao contrato de criação direta em `Rick.UIBuilder.Factory.pas`.
- As interfaces públicas do ComboBox permanecem em `Rick.UIBuilder.Interfaces.pas`.
- `Data` não possui nem manipula controles FMX.
- `Presentation` não filtra a coleção lógica de itens.
- `Virtualization` renderiza a view atual dos dados; não possui a coleção de origem.
- `FullWindow` reutiliza os mesmos dados e virtualizer usados pelos demais modos de apresentação.
- `ViewIndex` e `SourceIndex` são distintos quando existe filtro ativo.
- O `TPath` visual não é o alvo de interação de Back/Clear; a área externa de hit é.

## Evidência de testes

O ZIP atual declara **260** métodos `[Test]` nas units DUnitX. Para esta revisão foi fornecido resultado real de **260 executados / 260 aprovados / 0 failures / 0 errors / 0 ignored** em 2026-10-08. A evidência vale para a revisão/configuração executada; não substitui validação específica de outras plataformas ou alterações futuras.
