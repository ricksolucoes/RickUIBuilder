---
name: documentation-and-adrs
description: Mantém documentação e decisões arquiteturais do RickUIBuilder sincronizadas com a implementação final. Use ao alterar API, configuração, arquitetura, lifecycle, comportamento documentado, exemplos, README ou quando uma decisão duradoura merece ADR.
---

# Documentation and ADRs

## Overview

Documentação é parte do contrato de manutenção. Ela deve explicar o que existe e por quê quando relevante, sem descrever intenção não implementada ou duplicar a mesma verdade em múltiplos lugares.

## When to Use

- API pública mudou;
- config/default mudou;
- comportamento documentado mudou;
- novo componente/feature foi entregue;
- arquitetura/lifetime mudou;
- Sample/README precisa refletir nova realidade;
- known pitfall foi descoberto;
- decisão arquitetural duradoura precisa de ADR;
- tarefa é documentação-only.

## Source of Truth Order

1. código final;
2. contracts públicos;
3. testes/resultados reais;
4. docs de domínio atuais;
5. Sample;
6. fonte oficial externa quando semântica da plataforma importa.

Não use plano/spec como prova de que feature foi implementada.

## Process

### Step 1 — Identify documentation impact

Pergunte:

- README precisa mudar?;
- docs do componente?;
- Sample?;
- XMLDoc/comentário?;
- architecture map?;
- ADR?;
- governança `.agents` mudou?

### Step 2 — Separate audience and depth

#### README

Para usuário do framework: visão geral, quick start, exemplos essenciais, qualidade/navegação.

#### `docs/<component>`

Para mantenedor/usuário avançado: arquitetura, dependências, API detalhada, lifecycle, tests, pitfalls.

#### `.agents`

Para processo de engenharia: workflows, gates e policies.

#### Inline/XMLDoc

Para contract local no ponto de código.

Não duplique detalhes profundos em todos os níveis.

### Step 3 — Write from final implementation

Valide cada afirmação:

- type/method existe?;
- default é real?;
- event semantics correspondem?;
- lifetime está correto?;
- example usa assinatura real?;
- baseline de testes/toxicity corresponde à revisão medida?

### Step 4 — Prefer timeless language

Descreva estado atual:

> `BuildHandle` retorna...

Evite changelog em docs de referência:

> Agora corrigimos `BuildHandle` para...

### Step 5 — Document the why selectively

Registre rationale quando um futuro mantenedor poderia “simplificar” e quebrar invariante.

Exemplos:

- por que FullWindow usa host diferente do anchor;
- por que `TPath` é visual-only e hit area recebe click;
- por que Data não remove source items ao filtrar.

Não encha docs com justificativa de decisões óbvias.

### Step 6 — Bilingual parity

Quando existem pares EN/PT-BR:

- mesma hierarquia lógica;
- mesmos exemplos;
- mesmas APIs;
- mesmas tabelas;
- mesma informação técnica;
- linguagem natural em cada idioma.

Código deve permanecer idêntico, exceto comentários traduzidos quando aplicável.

### Step 7 — Examples

Cada exemplo deve ser:

- mínimo;
- real;
- coerente com imports/types;
- adequado ao tópico;
- não dependente de API hipotética.

### Step 8 — ADR decision

Crie ADR se a decisão:

- é arquitetural;
- tem alternativas plausíveis;
- terá impacto futuro;
- não é evidente apenas pelo código;
- merece preservar rationale.

Não crie ADR para bugfix local, formatting ou implementação reversível pequena.

### Step 9 — Validate docs

- links relativos;
- headings/paridade;
- code fences;
- exemplos;
- paths/filenames;
- nenhuma referência obsoleta;
- nenhuma duplicação desnecessária.

## ADR Workflow

### Context

Descreva forces e problema, não solução.

### Decision

Escolha explícita.

### Alternatives

Inclua alternativas realmente consideradas, não strawmen.

### Consequences

Liste trade-offs positivos/negativos.

### Lifecycle

ADR pode ser Proposed, Accepted, Superseded ou Rejected. Não reescreva decisão antiga como se sempre tivesse sido diferente; crie/supersede quando necessário.

## Known Gotchas

Um gotcha merece documentação quando:

- causa regressão plausível;
- não é óbvio pelo código;
- já apareceu em debugging real;
- a regra é estável.

Attempt Log temporário não deve ser copiado integralmente para docs.

## Inline Documentation

### When to comment

Comente quando o código não consegue sozinho preservar o **porquê**:

- workaround de API/framework confirmado;
- lifetime invariant não óbvio;
- razão para ordem de operações;
- contrato de representação/canonicalization;
- comportamento que parece simplificável, mas é necessário.

### When NOT to comment

Evite:

```pascal
// Incrementa contador
Inc(FCount);
```

Prefira nomes/estrutura claros. Comentário redundante aumenta drift.

### Known gotchas

Gotcha estável e cross-method pode pertencer a docs do componente. Gotcha local ao algoritmo pode ficar perto do código.

## API Documentation

Para API pública, documente quando relevante:

- finalidade;
- parâmetros e defaults;
- retorno/chaining;
- ownership/lifetime;
- side effects;
- invalid input behavior;
- exceptions;
- diferença Build versus runtime.

Não documente implementação interna em XMLDoc público.

## README Structure Guidance

O README principal deve permanecer navegável. Ordem típica:

```text
Overview
Features
Installation / project use
Factory / builders
Component examples
Composition / interfaces
Sample
Tests / quality
AI-assisted maintenance
License
```

A estrutura real existente tem precedência; não reorganize sem necessidade.

## Documentation for Agents

Quando uma regra existe para impedir uma futura IA de quebrar invariantes:

- workflow geral → skill;
- política compartilhada → `.agents/references`;
- conhecimento do componente → `docs/<component>`;
- regra local → code comment/XMLDoc.

Não duplique a mesma regra nos quatro níveis.

## Changelog / Historical Documentation

O repositório só deve ganhar/manter changelog se houver arquivo/processo real ou solicitação explícita. Não crie `CHANGELOG.md` automaticamente.

Se existir changelog, registre mudança como evento histórico separado da documentação timeless de referência.

## Documentation Review Checklist

### Technical accuracy

- signatures/defaults conferem?;
- ownership/lifetime conferem?;
- exemplos usam API real?;
- test/toxicity baseline tem provenance?

### Information architecture

- conteúdo está no local correto?;
- há duplicação?;
- leitor sabe qual arquivo ler para a próxima decisão?

### Language

- termos técnicos consistentes?;
- pt-BR natural?;
- EN natural?;
- identifiers intactos?

### Maintainability

- link relativo válido?;
- filename correto?;
- regra depende de número que ficará obsoleto?;
- há source of truth único para baseline/policy?

## Common Rationalizations

| Racionalização | Realidade |
|---|---|
| “Código é autoexplicativo.” | API/lifetime/rationale podem não ser. |
| “Vou documentar o plano; depois implementamos.” | Docs de referência só descrevem estado implementado. |
| “README pode ter todos os detalhes.” | Duplica e dificulta manutenção. |
| “PT-BR pode ficar para depois.” | Se existe par, drift começa na primeira mudança unilateral. |
| “ADR para tudo melhora rastreabilidade.” | ADR demais vira ruído; use para decisão duradoura. |

## Red Flags

- example usa método inexistente;
- README e docs contradizem default;
- baseline histórica descrita como atual;
- um idioma possui feature ausente no outro;
- docs contam história de implementação em vez do contrato;
- regras de manutenção duplicadas em três locais;
- ADR criado sem alternativa/trade-off.

## Verification

- [ ] Docs impact foi mapeado.
- [ ] Cada claim técnico foi confrontado com código/teste.
- [ ] Localização/depth são apropriados ao público.
- [ ] Linguagem descreve estado final.
- [ ] Exemplos usam API real.
- [ ] EN/PT-BR permanecem equivalentes quando aplicável.
- [ ] Links e paths foram validados.
- [ ] ADR foi criado somente se decisão duradoura justificou.
