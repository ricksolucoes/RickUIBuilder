# Backlog de Implementação — ComboBox Factory Runtime

**Projeto:** RickUIBuilder\
**Feature:** ComboBox Factory funcional\
**Status:** implementação concluída — fechamento documental e quality gate consolidados\
**Spec:** `specs/combobox-factory-listas.pt-BR.md`\
**Plano:** `specs/PLANO_TECNICO_COMBOBOX_FACTORY_RUNTIME.md`

> Os itens abaixo não representam implementação concluída. Estados de build,
> testes e métricas só podem mudar com evidência real.

## Estados

- **Pendente** — não iniciado.
- **Bloqueado** — depende de item anterior.
- **Em andamento** — trabalho iniciado.
- **Em auditoria** — aguardando/repetindo revisão.
- **Concluído** — critérios e verificações aplicáveis atendidos.

## Evidência de execução disponível

- Slice 1 compilado pelo usuário.
- DUnitX em 2026-10-08: **247 total / 247 aprovados / 0 failures / 0 errors**.
- Os 7 testes novos de `TRickUIBuilderFactoryCreateComboBoxTests` do Slice 1
  foram executados com sucesso.
- Sample executado com sucesso pelo usuário.
- Slice 2 validado pelo usuário: **255/255 aprovados / 0 failures / 0 errors** após correção da instrumentação do teste de Columns.
- Slice 3 / Tentativa 2: **259 testes / 2 failures / 0 errors**; regressão de precedência de style identificada.
- Slice 3 / Tentativa 3 validada pelo usuário: **260/260 aprovados / 0 failures / 0 errors**.
- Revisão final recebida em 2026-10-08: **260 executados / 260 aprovados / 0 failures / 0 errors / 0 ignored**.
- Samples Factory revisados e confirmados visualmente pelo usuário após os ajustes de snippets/indentação e do exemplo de cores.

# E00 — Baseline e characterization

## CBF-00.01 — Auditar cobertura atual da Factory

**Estado:** Concluído

- localizar testes do visual fechado e config;
- identificar lacunas antes de alterar assinatura.

**Aceite:** comportamento atual que será movido possui proteção por teste ou
registro explícito de cobertura já existente.

## CBF-00.02 — Auditar cobertura atual do Fluent

**Estado:** Concluído

- `Build`;
- `BuildHandle`;
- style overrides;
- seleção;
- callbacks;
- lifetime/detach.

**Aceite:** riscos de migração de `BuildCore` mapeados.

# E01 — Contrato público Factory

## CBF-01.01 — Criar `TRickUIBuilderComboBoxInitialSelectionMode`

**Estado:** Concluído

**Aceite:** `None`, `Index`, `Text` conforme spec; sem enum paralelo em outra
unit.

## CBF-01.02 — Criar `TRickUIBuilderComboBoxFactoryOptions`

**Estado:** Concluído

**Local aprovado:** `Rick.UIBuilder.Factory`.

**Aceite:** fields e `Default` exatamente conforme spec; nenhuma dependência
cíclica introduzida.

## CBF-01.03 — Evoluir assinatura de `CreateComboBox`

**Estado:** Concluído

**Aceite:** cinco parâmetros; `ATextLabel/AArrow` deixam contrato público;
`out AHandle` usa interface existente; consumidores internos identificados.

## CBF-01.04 — Preservar primitive visual internamente

**Estado:** Concluído

**Aceite:** visual atual continua sendo criado sem duplicação e com helper
privado somente se tecnicamente necessário.

# E02 — Dados, columns e seleção

## CBF-02.01 — Materializar Data com `Items`

**Estado:** Concluído

**Aceite:** vazio, textual, Display/Value e estruturado cobertos.

## CBF-02.02 — Configurar Columns

**Estado:** Concluído

**Aceite:** Auto/Fixed/Proportional e fields relevantes chegam ao handle/runtime
existente.

## CBF-02.03 — Aplicar `SelectionMode.None`

**Estado:** Concluído

**Aceite:** índice `-1`, sem exception.

## CBF-02.04 — Aplicar seleção por Index

**Estado:** Concluído

**Aceite:** válido seleciona; `-1`/fora do intervalo preservam ausência conforme
spec; sem regra paralela inventada.

## CBF-02.05 — Aplicar seleção por Text

**Estado:** Concluído

**Aceite:** comparação case-insensitive existente; primeira ocorrência; ausente
mantém sem seleção.

## CBF-02.06 — Aplicar Placeholder

**Estado:** Concluído

**Aceite:** não confundir com `SearchPlaceholder`.

# E03 — Runtime, eventos e lifetime

## CBF-03.01 — Criar/reutilizar Handle existente na Factory

**Estado:** Concluído

**Aceite:** `out AHandle` recebe `IRickUIBuilderComboBoxHandle`; nenhuma interface
nova.

## CBF-03.02 — Configurar callbacks

**Estado:** Concluído

**Aceite:** `OnChange`, `OnOpen`, `OnClose`, `OnCustomizeItem` encaminhados ao
runtime existente.

## CBF-03.03 — Attach visual e Behavior

**Estado:** Concluído

**Aceite:** runtime permanece vivo sem referência externa ao handle enquanto
visual estiver vivo.

## CBF-03.04 — Testar detach/destruction

**Estado:** Concluído

**Aceite:** Parent antes do handle, handle antes dos controls, sibling
irrelevante e `IsAttached` cobertos conforme harness disponível.

## CBF-03.05 — Testar presentation aberta durante destruição

**Estado:** Concluído

**Aceite:** cenário coberto quando harness permitir; caso contrário registrar
limitação sem inventar resultado.

# E04 — Convergência Fluent → Factory

## CBF-04.01 — Converter estado do Builder em `FactoryOptions`

**Estado:** Concluído

**Aceite:** Items, Columns, Placeholder, seleção e callbacks preservados.

## CBF-04.02 — Delegar `BuildCore` à Factory

**Estado:** Concluído

**Aceite:** sem pipeline runtime duplicado; `Build`/`BuildHandle` preservados.

## CBF-04.03 — Preservar overrides de style

**Estado:** Concluído

**Aceite:** `Height`, `ItemHeight`, `ArrowSize` e demais regras existentes não
regredirem; resolução não ocorre duas vezes com efeitos divergentes.

## CBF-04.04 — Paridade Factory × Fluent

**Estado:** Concluído

**Aceite:** contratos observáveis compartilhados equivalentes para entradas
equivalentes.

# E05 — Style e Presentation

## CBF-05.01 — Adaptive/Desktop/Mobile/Custom

**Estado:** Concluído

**Aceite:** Factory usa resolver existente; nenhuma segunda regra de style.

## CBF-05.02 — Auto/Anchored/Overlay/FullWindow

**Estado:** Concluído

**Aceite:** Factory usa Presentation existente; nenhum popup alternativo.

# E06 — Samples Factory

## CBF-06.01 — Reavaliar regras locais dos Samples

**Estado:** Concluído

**Aceite:** remover somente restrições que descrevem a limitação antiga da
Factory; manter/fortalecer quality gates.

## CBF-06.02 — Definir matriz final de exemplos

**Estado:** Concluído

**Aceite:** quantidade decorre da API implementada; sem contagem arbitrária.

## CBF-06.03 — Atualizar Types/Page

**Estado:** Concluído

**Aceite:** navegação representa a matriz final.

## CBF-06.04 — Atualizar `Factory.Content`

**Estado:** Concluído

**Aceite:** snippets usam somente API pública real.

## CBF-06.05 — Atualizar `Factory.Runner`

**Estado:** Concluído

**Aceite:** código executado é semanticamente equivalente ao snippet; lifetime
dos callbacks válido.

## CBF-06.06 — Atualizar página Factory

**Estado:** Concluído

**Aceite:** `ClearResult`, ResultHost, títulos/descrições e exemplo Completo
seguem governança local.

# E07 — Documentação

## CBF-07.01 — Atualizar docs do ComboBox

**Estado:** Concluído

**Aceite:** API, runtime, lifecycle, testes e exemplos correspondem ao código
final.

## CBF-07.02 — Atualizar README sobre Factory

**Estado:** Concluído

**Aceite:** README não descreve capacidade inexistente nem mantém limitação
obsoleta.

## CBF-07.03 — Documentar `-nodx`

**Estado:** Concluído nesta etapa documental

**Aceite:** README EN/PT-BR explica finalidade em acesso remoto,
case-insensitive, default sem switch e escopo do Samples executable.

# E08 — Quality gates

## CBF-08.01 — DelphiNamingGuard

**Estado:** Concluído por auditoria estática do código final

## CBF-08.02 — Method Toxicity/static quality

**Estado:** Concluído por auditoria estática do código final

**Aceite:** nenhuma nova violação conhecida; Toxicity real somente com ferramenta.

## CBF-08.03 — Contract & Lifetime audit

**Estado:** Concluído

## CBF-08.04 — Documentation audit

**Estado:** Concluído

## CBF-08.05 — DUnitX/build

**Estado:** Concluído — revisão final: 260/260 DUnitX, 0 failures, 0 errors, 0 ignored

**Aceite:** reportar execução real ou **Não confirmado**.

## CBF-08.06 — Final Quality Gate

**Estado:** Concluído com limitação declarada: Toxicity composta atual não medida no RAD Studio

**Aceite:** requisito, spec, código, testes, Samples e docs coerentes; sem
pendência bloqueante.

# Débito técnico separado

## CBF-DT-01 — `TRickUIBuilderComboBoxConfig.EditBackgroundColor`

**Estado:** Não confirmado

Não faz parte da implementação desta feature. Investigar somente com evidência
adicional de intenção/consumer. Não atribuir comportamento pelo nome.

# Registro de tentativas — Slice 2

## Tentativa 1 — Teste inicial de Columns

**Data:** 2026-10-08 21:29

**Resultado:** Falhou.

**Evidência:** DUnitX executou 255 testes, com 1 failure em
`Columns_DeveAplicarConfiguracaoEstruturada`. A mensagem foi `Object is Nil when Not Nil expected.`

**Diagnóstico:** o helper novo `FindFirstRow` procurava rows em
`TVertScrollBox.Children`. Os testes de integração já existentes do ComboBox
tratam corretamente a estrutura FMX via `TVertScrollBox.Content.Children`. O
runtime cria as rows com `Parent := FScrollBox`, e o `TScrollBox` as mantém em
seu conteúdo interno. A falha ocorreu, portanto, antes das assertions de largura
e alinhamento de colunas.

**Ação:** corrigir somente o helper de observação do teste para usar
`AScrollBox.Content.Children`, mantendo produção inalterada. Adicionar mensagens
às assertions de presença do scroll e da row para melhorar diagnóstico futuro.

**Status após correção:** confirmado em execução posterior; Slice 2 passou integralmente.


## Registro de execução — Slice 3 (Style / Presentation / overrides)

### Tentativa 1 — resolver `AConfig` diretamente na Factory

**Status:** rejeitada antes de consolidar implementação.

**Motivo:** `TRickUIBuilderComboBoxStyleResolver.Resolve` aplica defaults de
Desktop/Mobile sobre `Height`, `ItemHeight` e `ArrowSize`. O `AConfig` isolado
não informa se esses três valores foram explicitamente sobrescritos pelo
consumidor Fluent. Mover apenas a chamada ao resolver causaria perda de
comportamento existente.

### Tentativa 2 — Factory resolve e recebe metadados explícitos de override

**Status:** falhou na primeira execução real do Slice 3.

**Resultado real:** 259 testes executados, 2 failures, 0 errors. Os novos testes
específicos do Slice 3 passaram, porém dois testes de regressão anteriores
falharam porque a Factory direta perdeu customizações de `AConfig` (`Height` e
`ArrowSize`).

### Tentativa 3 — merge correto entre style defaults e `AConfig`

**Status:** concluída e validada em execução real.

Alterações:

- valores não-default de `Height`, `ItemHeight`, `HorizontalPadding` e
  `ArrowSize` passam a prevalecer automaticamente após resolução de style;
- foi adicionado `PreserveHorizontalPadding` para completar todos os campos que
  o resolver realmente sobrescreve;
- flags `Preserve...` ficam reservados ao caso em que um override explícito tem
  o mesmo valor do config Default e, portanto, não pode ser inferido;
- os dois testes antigos que detectaram a regressão permanecem inalterados;
- teste Factory de override foi reforçado para provar preservação automática,
  inclusive de `HorizontalPadding`;
- foi adicionado teste para o caso Mobile em que `Preserve...` mantém valores
  explicitamente iguais ao default-base.

Alterações:

- `FactoryOptions` ganhou `PreserveHeight`, `PreserveItemHeight` e
  `PreserveArrowSize`;
- `TRickUIBuilderFactory.ResolveComboBoxConfig` centraliza resolução de style e
  reaplica somente overrides marcados;
- `TRickUIBuilderComboBoxBuilder.ResolvedConfig` foi removido;
- o Fluent envia `FConfig` solicitado + as três flags já rastreadas;
- Factory e Fluent passam a compartilhar um único ponto de resolução;
- foram adicionados testes de Desktop defaults, Mobile+Auto/FullWindow,
  overrides diretos da Factory e preservação dos overrides Fluent.

**Resultado real:** 260/260 testes aprovados, 0 failures, 0 errors, 0 ignored na revisão final de 2026-10-08.
