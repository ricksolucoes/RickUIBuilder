# Adaptação do Agent Skills ao RickUIBuilder

## Objetivo

Registrar como o RickUIBuilder usa `ricksolucoes/agent-skills` como benchmark sem copiar mecanicamente tecnologia, estrutura física ou exemplos que não pertencem ao domínio Delphi.

Fonte de benchmark: https://github.com/ricksolucoes/agent-skills

Revisão consultada durante esta implementação: `bcab6a1b8503100e8618c3b4e32cc78de43de769` (`main`, 2026-09-25). Use a revisão registrada para entender o benchmark aplicado; atualizações upstream futuras exigem nova avaliação, não sincronização automática.

## Princípios preservados

| Princípio | Aplicação no RickUIBuilder |
|---|---|
| Skills são workflows | Cada skill possui gatilho, processo, decisões e Verification |
| Process over prose | Passos executáveis têm prioridade sobre explicação genérica |
| Evidence over assumption | Build, testes e Toxicity só são afirmados com execução/evidência |
| Anti-rationalization | Skills registram atalhos recorrentes e por que não são aceitáveis |
| Red Flags | Sinais concretos de violação do workflow |
| Progressive disclosure | Carregar somente skills e referências necessárias ao intent |
| Brownfield adoption | Entender e caracterizar antes de modificar comportamento existente |
| Definition of Done | Quality floor permanente, separado dos acceptance criteria |
| Personas != workflows | Agents fornecem perspectiva; skills fornecem processo |
| Orchestration rasa | Sem router-persona ou árvores profundas de agents |
| Model-neutral | Descrever capacidades e resultados, não tool names privados |

## Adaptações deliberadas

### Localização

Benchmark:

```text
skills/
agents/
references/
```

RickUIBuilder:

```text
.agents/skills/
.agents/agents/
.agents/references/
```

A divergência é de organização project-local, não de semântica das camadas.

### Stack

Práticas TypeScript/Web são substituídas por mecanismos do projeto:

| Benchmark | RickUIBuilder |
|---|---|
| package manager/build scripts | `.dproj`, `.dpk`, `.groupproj`, RAD Studio/MSBuild quando disponível |
| Jest/Vitest/etc. | DUnitX |
| browser component model | FireMonkey visual tree |
| web ownership via framework | `Owner`, `Parent`, `FreeNotification`, interfaces e reference counting |
| frontend rendering | FMX controls, layouts, paths, scroll containers e runtime composition |
| generic complexity/lint | Method Toxicity Metrics do RAD Studio + static review |

### TDD

O ciclo RED/GREEN/REFACTOR é preservado, mas testes FMX podem exigir `TForm` host e `Category('Integration')`. Characterization tests são preferidos para legado sem cobertura antes de refatorar.

### API design

Em vez de REST/TypeScript types, a skill trata fluent builders, interfaces Delphi, GUIDs, overloads, records, enums, handles, facade e compatibilidade source/API.

### UI engineering

A skill específica é `fmx-ui-engineering`, não uma cópia de práticas DOM/CSS. O foco é árvore visual, lifetime, layout e interação FMX.

### Release

A governança não inventa pipeline de deploy inexistente. `release-and-delivery` trata o que o repositório realmente possui: build/test evidence, Method Toxicity, documentação, encoding, diff e pacote de arquivos.

## Benchmark mapping

A implementação local não foi produzida por nomes semelhantes apenas. Cada workflow geral foi comparado com a skill correspondente da revisão upstream registrada:

| RickUIBuilder | Benchmark upstream | Adaptação principal |
|---|---|---|
| `using-rickuibuilder-skills` | `using-agent-skills` | intent routing, core behaviors, lifecycle e progressive disclosure |
| `context-engineering` | `context-engineering` | context hierarchy/budget adaptados a units, contracts, tests e docs Delphi |
| `spec-driven-development` | `spec-driven-development` | spec orientada a componentes, API, lifetime e compatibility |
| `planning-and-task-breakdown` | `planning-and-task-breakdown` | tasks/slices com acceptance criteria e gates Delphi |
| `incremental-implementation` | `incremental-implementation` | contract/risk/vertical slicing sem impor commit automático |
| `test-driven-development` | `test-driven-development` | RED/GREEN/REFACTOR, Prove-It e characterization em DUnitX/FMX |
| `debugging-and-error-recovery` | `debugging-and-error-recovery` | stop-the-line, reproduce/localize/reduce/root-cause + Attempt Log |
| `source-driven-development` | `source-driven-development` | documentação oficial Delphi/FMX/DUnitX/RAD Studio |
| `api-and-interface-design` | `api-and-interface-design` | Hyrum/contract-first aplicados a fluent builders, interfaces, GUIDs e handles |
| `code-review-and-quality` | `code-review-and-quality` | review multi-eixo especializado em lifetime, API, DUnitX e Toxicity |
| `code-simplification` | `code-simplification` | Chesterton's Fence, behavior preservation e anti-metric-gaming em Object Pascal |
| `documentation-and-adrs` | `documentation-and-adrs` | README/docs/ADR, bilingual parity e documentação orientada ao estado final |

Skills específicas do RickUIBuilder não têm equivalente 1:1 no benchmark e existem porque o domínio exige:

- `component-maintenance` — component discovery e arquitetura proporcional;
- `delphi-change-safety` — regras Object Pascal/Delphi, GUIDs, lifetime e BOM;
- `fmx-ui-engineering` — visual tree, interaction e hosting FireMonkey;
- `method-toxicity` — quality gate específico do RAD Studio;
- `release-and-delivery` — entrega incremental alinhada às regras do projeto.

Personas locais também usam o benchmark de comportamento: `code-reviewer` e `test-engineer` têm correspondência direta de papel; `delphi-engineer`, `technical-writer` e `quality-auditor` especializam necessidades permanentes do projeto e aplicam skills em vez de rotearem outras personas.

## Benchmark de profundidade

A profundidade é avaliada por cobertura comportamental, não contagem de linhas. Para workflows complexos, a skill deve responder:

1. quando usar e quando não usar;
2. que contexto carregar;
3. qual sequência seguir;
4. quais decisões surgem no meio;
5. quais atalhos são inválidos;
6. quais red flags exigem pausa;
7. como provar conclusão;
8. como se compõe com outras skills.

Se um `SKILL.md` possui headings corretos, mas não muda decisões do agente, ele falha o benchmark.

## O que não transportar

Não importar apenas porque existe no benchmark:

- browser testing quando não há browser;
- Core Web Vitals;
- padrões REST sem API REST;
- auth/SQL/secrets em skills que não tratam esses domínios;
- comandos de package managers;
- deploy/observability sem infraestrutura correspondente;
- modelos de thread/concurrency não presentes no componente.

Uma prática externa só entra quando existe correspondência real com o RickUIBuilder ou uma demanda concreta.

## Evolução

Ao atualizar o benchmark upstream, não sincronize automaticamente. Primeiro identifique se a mudança:

- corrige uma falha de workflow aplicável ao RickUIBuilder;
- acrescenta evidência/verification útil;
- melhora progressive disclosure;
- introduz um processo necessário neste repositório.

Somente então adapte de forma explícita.
