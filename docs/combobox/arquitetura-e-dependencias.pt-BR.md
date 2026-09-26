# Arquitetura e Dependências

> [English](arquitetura-e-dependencias.md) | [Português do Brasil](arquitetura-e-dependencias.pt-BR.md)

## Escopo e fonte de verdade

Este documento descreve os limites entre as units implementadas pelo ComboBox. Fonte de verdade: `Rick.UIBuilder.pas`, `Rick.UIBuilder.Types.pas`, `Rick.UIBuilder.Interfaces.pas`, `Rick.UIBuilder.Factory.pas` e todas as units `Rick.UIBuilder.ComboBox*.pas`.

## Visão geral das dependências

```text
TRickUIBuilder.ComboBox
        ↓
TRickUIBuilderComboBoxBuilder
        ↓
TRickUIBuilderComboBoxConfig + TRickUIBuilderComboBoxData
        ↓
TRickUIBuilderFactory + TRickUIBuilderComboBoxHandle
        ↓
TRickUIBuilderComboBoxState
TRickUIBuilderComboBoxBehavior
TRickUIBuilderComboBoxPresentation
TRickUIBuilderComboBoxVirtualizer
```

A direção das dependências é intencionalmente assimétrica. O modelo de dados é independente da renderização FMX. O handle coordena estado, presentation, dados e virtualização. Presentation materializa controles, mas delega filtro e seleção para as camadas de handle/data.

## Responsabilidades das units

| Unit | Responsabilidade | Não deve se tornar |
|---|---|---|
| `Rick.UIBuilder.pas` | Facade do framework; expõe `TRickUIBuilder.ComboBox`. | Unit de implementação do ComboBox. |
| `Rick.UIBuilder.Types.pas` | Enums públicos, records de item/coluna/config e constantes de paths default. | Armazenamento de estado runtime. |
| `Rick.UIBuilder.Interfaces.pas` | Contratos públicos do builder e handle, tipo do callback de custom item. | Camada de implementação. |
| `Rick.UIBuilder.Factory.pas` | Cria o `TRectangle` fechado, label de texto e path da seta. | Serviço de popup ou filtro. |
| `Rick.UIBuilder.ComboBox.pas` | Builder fluente; resolve configuração e materializa o grafo runtime. | Controlador runtime de longa duração. |
| `Rick.UIBuilder.ComboBox.Data.pas` | Itens de origem, seleção confirmada, texto do filtro e view de índices filtrados. | Camada de renderização FMX. |
| `Rick.UIBuilder.ComboBox.State.pas` | Fase de abertura/fechamento e target index transitório. | Armazenamento da seleção confirmada. |
| `Rick.UIBuilder.ComboBox.Style.pas` | Resolve style solicitado/efetivo e presentation `Auto`. | Serviço runtime com estado. |
| `Rick.UIBuilder.ComboBox.Handle.pas` | Orquestrador runtime de eventos, navegação, seleção, pesquisa e dos serviços usados pelo controle materializado. | Owner da árvore visual ou observador de lifetime. |
| `Rick.UIBuilder.ComboBox.Behavior.pas` | Ponte de lifetime gerenciada pelo Owner; mantém a interface do handle viva, observa o container visual e solicita detach por callback sem depender da classe concreta do handle. | Orquestrador runtime ou owner da árvore visual. |
| `Rick.UIBuilder.ComboBox.Presentation.pas` | Materialização lazy e layout das superfícies Anchored, Overlay e FullWindow. | Implementação do filtro de dados. |
| `Rick.UIBuilder.ComboBox.Virtualization.pas` | Pool de rows, mapeamento do viewport, colunas, estados visuais e custom slot. | Owner da coleção de origem. |

## Fluxo de dependências no Build

```text
Consumer
↓
TRickUIBuilder.ComboBox
↓
Builder
↓
Style Resolver
↓
Data + Factory
↓
Handle + Behavior
↓
Presentation + Virtualizer (lazy when opened)
```

`TRickUIBuilderComboBoxBuilder.BuildCore` cria `TRickUIBuilderComboBoxData`, copia os itens do builder, aplica a seleção inicial, cria o handle, cria o controle visual fechado via `TRickUIBuilderFactory.CreateComboBox` e então anexa o comportamento runtime.

## Fluxo de dependências em runtime

Quando o controle abre, o handle solicita a `Presentation` que crie/exiba a superfície de seleção. Depois que a presentation expõe seu `TVertScrollBox`, o handle cria um único `TRickUIBuilderComboBoxVirtualizer` para essa superfície. O virtualizer lê `Data.ViewCount` e `SourceIndexFromView` para vincular as rows.

## Limites públicos e internos

Somente types/interfaces nas units públicas centralizadas fazem parte do contrato público. `Data`, `State`, `Style`, `Handle`, `Behavior`, `Presentation` e `Virtualization` são units de implementação. Novas capacidades públicas devem entrar nos contratos centralizados somente quando houver consumidor externo real.

## Invariantes arquiteturais

1. Não criar `Rick.UIBuilder.ComboBox.Types.pas` nem `Rick.UIBuilder.ComboBox.Interfaces.pas`.
2. Não implementar uma engine de itens separada para Mobile; FullWindow reutiliza o mesmo modelo de dados e virtualizer.
3. Não mover filtro para `Presentation`.
4. Não armazenar seleção confirmada em `State`; a seleção confirmada pertence a `Data`.
5. Não fazer `Virtualization` possuir `Data`.
6. Manter resolução de style separada do comportamento de presentation.

## Guia de impacto

- Alterar identidade do item ou filtro impacta `Data`, `Handle`, `Virtualization` e testes.
- Alterar geometria do controle fechado impacta `Types`, overrides do builder, `Factory`, dimensionamento runtime da seta no `Handle` e testes.
- Alterar layout FullWindow impacta `Presentation`, testes de interação e validação manual no Sample.
- Alterar ownership/lifetime impacta `Handle`, `Behavior`, `Presentation`, `Virtualization` e testes de destruição.
