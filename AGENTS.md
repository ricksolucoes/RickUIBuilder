# AGENTS.md — Governança de Engenharia do RickUIBuilder

Este arquivo é o bootstrap obrigatório para qualquer agente de IA, assistente de código ou automação que trabalhe no RickUIBuilder.

A governança detalhada fica em [`.agents/`](.agents/README.md). O projeto usa [`ricksolucoes/agent-skills`](https://github.com/ricksolucoes/agent-skills) como **benchmark de comportamento e profundidade**, especializado para Delphi/Object Pascal, FireMonkey, DUnitX, RAD Studio e a arquitetura real do RickUIBuilder.

> **Regra central:** skills são workflows executáveis. Se uma skill corresponde à tarefa, siga o workflow e sua Verification; não implemente diretamente ignorando-a.

## Repository scope

Estas regras valem para todo o framework: Facade, `Types`, `Interfaces`, Factory, Label, Button, Badge, Divider, ComboBox, Composition, Sample, testes, projetos Delphi, documentação e componentes futuros.

O ComboBox possui documentação profunda em `docs/combobox/`, mas não define a arquitetura obrigatória dos demais componentes.

## Engineering layers

- **Skills** — `.agents/skills/<name>/SKILL.md`: o **como**, com gatilhos, passos, decisões, anti-rationalization, red flags e evidência de saída.
- **Agents** — `.agents/agents/`: o **quem**, com perspectiva especializada e formato de saída. Personas não roteiam ou invocam outras personas.
- **References** — `.agents/references/`: políticas compartilhadas, component map, quality gates e Definition of Done.
- **Templates** — `.agents/templates/`: artefatos persistentes somente quando agregam valor.

## Start-of-task protocol

Antes de editar qualquer arquivo:

1. compreenda a solicitação atual sem reutilizar permissões de tarefas anteriores;
2. abra `.agents/skills/using-rickuibuilder-skills/SKILL.md`;
3. classifique intenção, domínio e risco;
4. selecione somente as skills aplicáveis;
5. identifique código, contratos públicos, testes, docs e comportamento a preservar;
6. delimite alterações autorizadas e proibidas;
7. determine como a conclusão poderá ser provada;
8. resolva ambiguidades materiais antes de implementar.

**Analisar ≠ modificar. Documentar ≠ refatorar. Corrigir bug ≠ redesenhar.**

## Intent → Skill Routing

| Intenção | Skills principais |
|---|---|
| Contexto/repositório desconhecido | `context-engineering` |
| Nova feature significativa | `spec-driven-development` → `planning-and-task-breakdown` |
| Plano solicitado | `planning-and-task-breakdown` |
| Componente existente/novo | `component-maintenance` |
| Alterar `.pas` | `delphi-change-safety` + `method-toxicity` |
| UI/interação FMX | `fmx-ui-engineering` |
| API/interface pública | `api-and-interface-design` |
| Mudança multi-arquivo | `incremental-implementation` |
| Novo comportamento/bug | `test-driven-development` |
| Test failure/AV/build quebrado | `debugging-and-error-recovery` |
| Semântica externa não confirmada | `source-driven-development` |
| Review | `code-review-and-quality` |
| Refatoração autorizada | `code-simplification` |
| Documentação/ADR | `documentation-and-adrs` |
| Entrega | `release-and-delivery` |

Múltiplas skills podem compor a tarefa. Não carregue todas por precaução.

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

Nem toda tarefa usa todas as fases. Uma correção pequena pode seguir apenas `context → debugging/delphi safety → verification`. Uma feature significativa normalmente exige spec, plano, testes, review e docs.

## Brownfield strategy

O RickUIBuilder já possui API, comportamento, testes, Sample e decisões arquiteturais. O padrão é **verification-first**:

```text
Entender
→ caracterizar
→ preservar contratos
→ alterar minimamente
→ verificar
→ revisar
```

Não copie a arquitetura do componente mais complexo. Use `component-maintenance` para descobrir a complexidade real do alvo.

## Core operating behaviors

### Surface assumptions

Não preencha lacunas silenciosamente. Se uma suposição puder mudar contrato, arquitetura ou escopo, procure evidência. Se não houver, declare **`Não confirmado.`** e peça decisão quando bloqueante.

### Manage confusion actively

Se requisito, código, testes e docs discordarem:

1. pare;
2. nomeie o conflito;
3. reúna evidência;
4. aplique a precedência correta;
5. prossiga somente depois de resolver.

### Scope discipline

Não faça cleanup, rename, refactor, nova abstração ou migração fora do requisito atual. A política padrão é **alteração mínima necessária**.

### Evidence over confidence

Distinga explicitamente:

- análise estática;
- build real;
- teste DUnitX real;
- runtime/manual real;
- Method Toxicity real via RAD Studio/CSV.

Nunca transforme “parece correto” em aprovação.

## Source-of-truth order

Use, conforme o assunto:

1. requisito explícito da tarefa atual;
2. comportamento/regra existente comprovado;
3. integridade de dados e lifetime;
4. compatibilidade/API pública;
5. código final;
6. testes/resultados reais;
7. documentação técnica de domínio;
8. Sample como demonstração de uso;
9. `.agents/` como governança do processo.

Fontes externas explicam a plataforma; não substituem o contrato específico do RickUIBuilder.

## Delphi gates

Para qualquer `.pas` efetivamente modificado:

- preserve compatibilidade com recursos confirmados do projeto;
- mantenha `uses` corretos;
- use Scoped Enums como `Tipo.Membro`;
- preserve GUIDs públicos salvo mudança explícita de contrato;
- analise interfaces/reference counting;
- analise `Owner`, `Parent`, `FreeNotification`, callbacks e lifetime quando aplicável;
- salve em **UTF-8 com BOM (`EF BB BF`)**;
- não converta `.pas` não modificados;
- execute o workflow `method-toxicity`.

Detalhes: `delphi-change-safety`, `fmx-ui-engineering`, `api-and-interface-design` e referências compartilhadas.

## Method Toxicity

Gates permanentes:

- `Length <= 20`;
- `Parameters <= 6`;
- `If Depth <= 5`;
- `Cyclomatic Complexity <= 6`;
- `Toxicity < 1` quando medida pelo RAD Studio.

Não introduza nem agrave toxicidade. Não invente fórmula de `Toxicity` e não chame avaliação estática de métrica real.

## Tests and build

- bugfix: use Prove-It/regression quando tecnicamente aplicável;
- refactor sem cobertura: characterize antes de mudar;
- FMX/lifetime normalmente pede integration test;
- Sample não substitui teste;
- não enfraqueça assertion para obter verde;
- não afirme build/test/leak sem execução real.

Baseline histórica conhecida: `197 found / 197 passed / 0 failed / 0 errored / 0 leaked`. Ela não comprova alterações futuras.

## Debugging

Para falha não localizada, use:

```text
REPRODUCE
→ EVIDENCE
→ LOCALIZE
→ REDUCE
→ HYPOTHESIS
→ CHECK ATTEMPT LOG
→ FIX ROOT CAUSE
→ GUARD
→ VERIFY
```

Quando houver múltiplas tentativas, mantenha `.agents/templates/attempt-log.md`. Não repita abordagem descartada sem evidência nova.

## Documentation

Documente somente comportamento implementado no estado final.

- `README.md` / `README.pt-BR.md`: visão geral e navegação;
- `docs/<feature>/`: profundidade quando complexidade justificar;
- `.agents/`: processo de engenharia, não API pública;
- pares EN/PT-BR devem permanecer equivalentes quando existirem.

Mudanças em API, arquitetura, lifecycle, configuração ou comportamento documentado exigem revisão documental.

## Review and Definition of Done

Mudanças de risco relevante — API, lifetime/ownership, refatoração, mudança estrutural, Method Toxicity ou release — exigem revisão separada da implementação.

Antes de concluir, aplique `.agents/references/definition-of-done.md`. Acceptance Criteria são específicos da tarefa; Definition of Done é a barra permanente do projeto.

## Skill evolution

Antes de criar skill nova:

1. procure workflow existente;
2. diferencie processo de conhecimento;
3. prefira ampliar skill coesa a duplicar;
4. nova skill precisa de gatilho, workflow e Verification próprios;
5. detalhes compartilhados ficam em `references/`;
6. detalhes exclusivos e extensos ficam em supporting references da skill;
7. escreva procedimentos model-neutral.

## Global anti-rationalization

| Racionalização | Regra |
|---|---|
| “É pequeno demais para skill.” | Use o workflow aplicável de forma proporcional. |
| “Vou testar depois.” | Verificação faz parte do incremento. |
| “Outro componente faz assim.” | Similaridade não prova mesma arquitetura. |
| “Já era complexo.” | Dívida existente não autoriza agravamento. |
| “O Sample funciona.” | Sample não substitui testes/build. |
| “O compilador pegaria.” | Lifetime e semântica runtime podem compilar normalmente. |

## Delivery

Antes de enviar arquivos:

1. revise o diff final;
2. confirme escopo;
3. valide BOM de `.pas` alterados;
4. reporte somente validações realmente executadas;
5. declare limitações e riscos restantes;
6. entregue somente arquivos criados/modificados;
7. liste remoções separadamente — ZIP incremental não remove arquivo existente;
8. não inclua temporários, fontes apenas consultadas ou relatórios não solicitados.
