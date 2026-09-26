# Governança de Engenharia Assistida por IA

`.agents/` contém a camada de processos de engenharia do RickUIBuilder. Ela existe para fazer diferentes agentes de IA seguirem a mesma disciplina em análise, implementação, testes, revisão, documentação e entrega.

O bootstrap obrigatório é [`../AGENTS.md`](../AGENTS.md). Este README explica a arquitetura da governança; as decisões executáveis ficam nas skills e referências.

## Benchmark e política de adaptação

A governança usa [`ricksolucoes/agent-skills`](https://github.com/ricksolucoes/agent-skills) como **benchmark de profundidade e comportamento**. Isso significa preservar o que torna aquelas skills eficazes:

- process over prose;
- intent-driven skill discovery;
- passos executáveis e pontos de decisão;
- anti-rationalization explícita;
- red flags observáveis;
- verification baseada em evidência;
- progressive disclosure;
- Definition of Done reutilizável;
- personas separadas de workflows;
- orquestração rasa e rastreável;
- adoção brownfield verification-first.

Não significa copiar práticas Web/TypeScript que não pertencem ao domínio. O conteúdo concreto aqui é especializado para Delphi/Object Pascal, FMX, DUnitX, RAD Studio e o RickUIBuilder.

Veja [`references/agent-skills-adaptation.md`](references/agent-skills-adaptation.md) para a matriz de adaptação e divergências deliberadas.

## Por que `.agents/`

O repositório de benchmark mantém o núcleo em `skills/`, `agents/` e `references/`. O RickUIBuilder agrupa esses elementos sob `.agents/` como convenção project-local. A anatomia dos workflows continua a mesma: cada skill vive em sua pasta e entra por `SKILL.md`.

## Estrutura

```text
.agents/
├── README.md
├── skills/
│   └── <skill>/
│       ├── SKILL.md
│       └── references/        # somente quando o workflow precisa de apoio próprio
├── agents/
│   └── <persona>.md
├── references/
│   └── <politica-compartilhada>.md
└── templates/
    └── <artefato>.md
```

### `skills/`

Definem **como executar trabalho**. Uma skill deve mudar o comportamento do agente: gatilhos, sequência, decisões, evidências e exit criteria. Se remover uma seção não altera o comportamento, considere removê-la ou movê-la para referência.

### `agents/`

Definem **perspectiva, responsabilidade e formato de saída**. Não são routers. Uma persona pode aplicar skills, mas não deve invocar outra persona.

### `references/`

Concentram políticas compartilhadas por múltiplas skills. Ex.: Definition of Done, component map, testing policy, Method Toxicity baseline e orchestration patterns.

### `templates/`

Padronizam artefatos persistentes. Template não é etapa obrigatória por si só; use quando a tarefa realmente precisa daquele artefato.

## Lifecycle

```text
DEFINE
  ↓
PLAN
  ↓
CONTEXT
  ↓
BUILD
  ↓
VERIFY
  ↓
REVIEW
  ↓
DOCUMENT
  ↓
DELIVER
```

O lifecycle é composicional. Nem toda tarefa percorre todas as fases.

### Exemplo — análise read-only

```text
using-rickuibuilder-skills
→ context-engineering
→ component-maintenance se houver componente-alvo
→ análise
```

### Exemplo — bug comportamental

```text
using-rickuibuilder-skills
→ debugging-and-error-recovery
→ component-maintenance
→ test-driven-development
→ delphi-change-safety / fmx-ui-engineering conforme necessário
→ method-toxicity se .pas mudou
→ code-review-and-quality
→ release-and-delivery
```

### Exemplo — novo componente

```text
spec-driven-development
→ planning-and-task-breakdown
→ context-engineering
→ component-maintenance
→ api-and-interface-design
→ fmx-ui-engineering
→ incremental-implementation
→ test-driven-development
→ method-toxicity
→ documentation-and-adrs
→ code-review-and-quality
→ release-and-delivery
```

A presença de uma etapa no exemplo não dispensa verificar se ela é realmente aplicável ao caso concreto.

## Catálogo de skills

### Discovery e definição

- `using-rickuibuilder-skills` — meta-skill e intent routing.
- `context-engineering` — monta o contexto técnico mínimo correto.
- `spec-driven-development` — define mudanças significativas antes do código.
- `planning-and-task-breakdown` — decompõe specs/objetivos em unidades verificáveis.

### Construção e manutenção

- `component-maintenance` — descobre contratos e dependências de qualquer componente.
- `delphi-change-safety` — segurança de alterações Object Pascal/Delphi.
- `fmx-ui-engineering` — visual tree, interaction, lifetime e layout FireMonkey.
- `api-and-interface-design` — API pública, interfaces, GUIDs, records/enums e compatibilidade.
- `incremental-implementation` — implementação em slices pequenos e verificáveis.

### Verificação e diagnóstico

- `test-driven-development` — RED/GREEN/REFACTOR, regressão e characterization tests em DUnitX.
- `debugging-and-error-recovery` — reproduce/localize/reduce/hypothesis/fix/guard.
- `source-driven-development` — decisões apoiadas em documentação/fonte oficial.
- `method-toxicity` — gates RAD Studio e prevenção de regressão de métricas.

### Review, documentação e entrega

- `code-review-and-quality` — review multi-eixo com severidades e evidência.
- `code-simplification` — simplificação preservando comportamento e contratos.
- `documentation-and-adrs` — documentação do estado final e decisões arquiteturais.
- `release-and-delivery` — gate de escopo, evidência, artefatos e entrega.

## Catálogo de personas

- `delphi-engineer` — implementação/análise Delphi e FMX.
- `code-reviewer` — revisão independente de mudanças.
- `test-engineer` — estratégia e qualidade DUnitX.
- `technical-writer` — documentação baseada na implementação final.
- `quality-auditor` — auditoria final de evidência, escopo e gates.

## Como escolher entre skill e reference

Pergunte: **isso é um processo recorrente ou conhecimento compartilhado?**

- processo com gatilho, sequência e verificação → skill;
- regra estável usada por várias skills → reference;
- conhecimento de uma única skill e extenso → supporting reference dentro da skill;
- documentação de produto/componente → `docs/`, não `.agents/`.

## Como evoluir a governança

Antes de adicionar uma skill:

1. pesquise o catálogo existente;
2. confirme que não é apenas um caso de uma skill genérica;
3. descreva gatilho e exclusão;
4. descreva o workflow completo;
5. defina evidência de saída;
6. adicione rationalizations e red flags reais;
7. mantenha o conteúdo model-neutral;
8. valide links/frontmatter.

Não crie `button-maintenance`, `badge-maintenance` e similares se `component-maintenance` cobre o processo. Conhecimento específico deve ser carregado por documentação/refs do componente.

## Qualidade da própria governança

Uma skill está incompleta quando:

- só lista boas práticas;
- não diz quando parar ou pedir decisão;
- não define evidência;
- não diferencia análise estática de execução real;
- repete outra skill;
- contém procedimentos irrelevantes para Delphi/RickUIBuilder;
- é curta apenas por estética ou longa apenas para imitar o benchmark.

A meta é **profundidade operacional com progressive disclosure**.
