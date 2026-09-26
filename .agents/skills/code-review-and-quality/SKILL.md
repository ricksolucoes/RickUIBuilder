---
name: code-review-and-quality
description: Executa review independente e multi-eixo de mudanças no RickUIBuilder. Use antes de concluir mudanças relevantes, após bugfixes/features/refatorações e sempre que for necessário avaliar correctness, simplicidade, arquitetura, lifetime, API, testes, Method Toxicity, documentação e escopo.
---

# Code Review and Quality

## Overview

Review não é confirmação social da implementação. É uma tentativa deliberada de encontrar defeitos, regressões, assumptions e gaps de evidência antes da entrega.

O padrão de aprovação é: a mudança atende o requisito, preserva contratos, melhora ou mantém a saúde do código e possui evidência proporcional ao risco.

## When to Use

- feature concluída;
- bugfix;
- refatoração;
- API pública;
- lifetime/ownership;
- mudança multi-unit;
- mudança em Method Toxicity;
- entrega/release;
- código produzido por outro agente/humano.

Para typo ou docs trivial, aplique review proporcional.

## Review Preconditions

Antes de revisar:

- entenda a tarefa/acceptance criteria;
- veja diff completo;
- conheça comportamento a preservar;
- leia testes relevantes;
- saiba quais validações foram realmente executadas.

Não revise apenas arquivos isolados sem contexto do diff.

## Review Axes

### 1. Correctness

Pergunte:

- atende exatamente o requisito?;
- edge cases relevantes estão tratados?;
- error paths mantêm contrato?;
- state transitions são coerentes?;
- callbacks disparam quantidade/ordem esperadas?;
- invalid input altera estado indevidamente?;
- há off-by-one/mapping errado?;
- comportamento antigo foi alterado sem autorização?

### 2. Readability & Simplicity

- nomes revelam intenção?;
- fluxo é direto?;
- há nested condition evitável?;
- helper remove responsabilidade ou apenas divide linhas?;
- abstração tem consumidor real?;
- comentários explicam **por quê**, não o óbvio?;
- existe dead code/debug artifact?;
- solução simples resolveria com menos conceitos?

### 3. Architecture

- responsabilidade ficou na camada certa?;
- dependência flui na direção esperada?;
- componente simples ganhou arquitetura excessiva?;
- feature-specific logic vazou para shared layer?;
- novo type/interface é realmente compartilhado/público?;
- refatoração reduz complexidade ou só reloca?

### 4. Delphi Lifetime & Memory

- Owner/Parent estão corretos?;
- quem destrói cada objeto?;
- raw reference pode ficar dangling?;
- interface prolonga lifetime inesperadamente?;
- existe double-free?;
- `FreeNotification` observa o target correto?;
- callback/closure captura referência?;
- destructor/Notification deixa objeto em estado consistente?

### 5. API Compatibility

- signature/default mudou?;
- overload é ambíguo?;
- GUID mudou?;
- chaining continua?;
- Build/BuildHandle semantics foram preservadas?;
- mudança é aditiva ou behavioral breaking?;
- Sample/docs consumers foram revisados?

### 6. Tests

- teste prova o comportamento certo?;
- bugfix tem regression test?;
- RED foi realmente observado quando alegado?;
- integration test é necessário?;
- assertions estão fortes?;
- teste depende de representação incidental?;
- coverage gap relevante permanece?

### 7. Method Toxicity

- métodos alterados respeitam gates?;
- complexidade foi agravada sem necessidade?;
- nova abstração foi criada só para metric gaming?;
- `Toxicity` reportada é real ou estática?;

### 8. Documentation

- comportamento público alterado está documentado?;
- docs descrevem estado final?;
- exemplo compila conceitualmente com API real?;
- EN/PT-BR continuam equivalentes?;
- known pitfall novo deveria ser registrado?

### 9. Scope Discipline

- arquivo fora do plano foi tocado?;
- cleanup não relacionado entrou?;
- teste/docs foram modificados além do necessário?;
- autorização de refactor existia?;
- entrega inclui apenas arquivos relevantes?

## Review Process

### Step 1 — Read task and acceptance criteria

Sem isso, não existe referência para correctness.

### Step 2 — Review tests before implementation

Testes revelam intenção declarada da mudança e podem mostrar gaps/expectativas alteradas indevidamente.

### Step 3 — Review public contract

Se houver API, revise antes dos internals.

### Step 4 — Review implementation path

Siga dados/state/events/lifetime do entry point até o efeito observado.

### Step 5 — Review verification evidence

Confirme:

- teste real?;
- build real?;
- runtime?;
- Toxicity real?;
- static-only?

A revisão deve revisar também a **verificação**.

### Step 6 — Categorize findings

#### Critical

Bloqueia entrega. Exemplos:

- crash/AV;
- double-free;
- data corruption;
- quebra direta do requisito;
- API pública quebrada sem autorização;
- falsa afirmação de validação crítica.

#### Required

Precisa corrigir antes de entregar. Exemplos:

- missing regression test de bug reproduzível;
- lifetime risk real;
- new toxicity;
- docs/API inconsistentes;
- scope drift relevante;
- comportamento não coberto por requisito.

#### Optional

Melhoria válida não necessária para aprovação atual.

#### Nit

Preferência pequena/cosmética que não deve bloquear.

Não use “Required” para preferência pessoal.

## Finding Format

Todo finding acionável deve conter:

```text
Severity:
Local:
Evidence:
Impact:
Contract/rule affected:
Required/recommended correction:
```

Evite “isso poderia ser melhor” sem impacto/evidência.

## Review Output

```markdown
## Review Summary

**Status:** APPROVE | REQUEST CHANGES | INCOMPLETE EVIDENCE

**Scope reviewed:** ...
**Evidence reviewed:** ...

### Critical
- ...

### Required
- ...

### Optional
- ...

### Nits
- ...

### Verification Story
- Tests: ...
- Build: ...
- Method Toxicity: ...
- Runtime/manual: ...

### Remaining Risks
- ...
```

## Handling Disagreement

Se implementador discorda:

1. volte ao requisito/contrato;
2. compare evidência;
3. diferencie preferência de defect;
4. retire finding se não sustentar impacto;
5. escale decisão humana quando houver trade-off legítimo.

Review não é competição.

## Structural Remedies

Quando encontrar defeito arquitetural, recomende a menor remedy que remove o problema:

- move responsibility para owner correto;
- reutiliza helper canônico;
- elimina duplicate state;
- adiciona guard clause;
- separa contract de implementation;
- adiciona notification/detach coerente.

Não proponha “usar pattern X” sem conectar ao defect.

## Change Sizing

Review deve considerar tamanho como risco, não gate numérico rígido.

Sinais de change grande demais:

- vários behaviors independentes;
- API + refactor + visual redesign juntos;
- muitos arquivos sem dependency chain clara;
- impossível apontar teste por comportamento;
- description precisa de vários objetivos não relacionados.

Quando isso ocorrer, recomende splitting por contrato/risco/slice — não por número arbitrário de linhas.

## Change Description Quality

Uma mudança revisável deve explicar:

- problema;
- solução;
- comportamento preservado;
- evidência;
- riscos/limitações.

Se o diff faz algo diferente da descrição, isso é finding.

## Dead Code Hygiene

Procure artifacts introduzidos pela mudança:

- fields nunca lidos;
- methods wrappers sem uso;
- old branch mantido “por segurança”;
- commented-out code;
- debug output;
- compatibility shim sem estratégia.

Não use review para remover dead code legado fora do escopo, salvo risco direto.

## Dependency Discipline

Nova dependency precisa justificar:

- por que é necessária;
- por que pertence àquela unit/layer;
- se pode criar circular dependency;
- se expõe implementation detail na interface section;
- se uma dependency existente já oferece o comportamento.

## Independent Review Pattern

Para mudanças de risco alto, review pode ser combinado externamente com `test-engineer` e `quality-auditor`. Cada persona produz findings independentes; o main workflow faz merge.

O `code-reviewer` não deve invocar essas personas diretamente.

## Honesty in Review

Se falta evidência para decidir:

- use `INCOMPLETE EVIDENCE`;
- indique exatamente o que falta;
- não converta dúvida em `Critical` sem impacto demonstrável;
- não aprove por pressão de conclusão.

## Review Checklist

### Correctness
- [ ] task/acceptance criteria atendidos;
- [ ] edge/error paths relevantes;
- [ ] state/event semantics.

### Architecture
- [ ] boundaries e dependencies;
- [ ] nenhuma abstração sem valor;
- [ ] component complexity proporcional.

### Delphi/FMX
- [ ] lifetime/ownership;
- [ ] interfaces/GUIDs;
- [ ] callbacks;
- [ ] BOM.

### Verification
- [ ] tests reais;
- [ ] build real ou limitação;
- [ ] toxicity real versus estática;
- [ ] runtime quando necessário.

### Documentation/Scope
- [ ] docs correspondem ao final;
- [ ] diff sem scope drift.

## Common Rationalizations

| Racionalização | Realidade |
|---|---|
| “Tests green, então approve.” | Tests não cobrem automaticamente API/lifetime/docs/scope. |
| “É só style.” | Mudança FMX visual pode afetar interação/lifetime. |
| “Eu faria diferente.” | Preferência pessoal não é Required. |
| “Está abaixo dos thresholds.” | Métrica pode ter piorado mesmo abaixo do gate; revise necessidade. |
| “Implementador já revisou.” | Mudança de risco pede perspectiva separada. |
| “Build não está disponível, mas parece compilável.” | Marque evidence incompleta; não invente build. |

## Red Flags

- review sem ler task;
- findings sem localização/evidência;
- todo comentário marcado Required;
- ignore lifetime em Handle/FMX;
- approval baseado só em formatting;
- não verificar testes modificados;
- aceitar claims de execução sem output/evidência;
- sugerir refactor grande em bugfix fora do escopo.

## Verification

- [ ] Acceptance criteria foram usados como referência.
- [ ] Testes e public contract foram revisados.
- [ ] Nove eixos aplicáveis foram considerados.
- [ ] Findings têm severidade coerente.
- [ ] Findings Critical/Required têm evidência/impacto.
- [ ] Verification story foi auditada.
- [ ] Preferências foram separadas de defects.
- [ ] Scope drift foi verificado.
- [ ] Resultado final não contém garantia sem evidência.
