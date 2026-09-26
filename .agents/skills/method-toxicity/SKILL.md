---
name: method-toxicity
description: Avalia e protege Method Toxicity Metrics de código Delphi do RickUIBuilder. Use sempre que métodos .pas forem criados, alterados ou refatorados, distinguindo avaliação estática de métricas reais exportadas pelo RAD Studio.
---

# Method Toxicity

## Overview

Method Toxicity é um quality gate permanente. Métricas são sinais de responsabilidade e testabilidade, não metas para gaming.

A regra central:

> Não introduzir nova toxicidade e não agravar toxicidade existente.

## When to Use

- qualquer método Delphi criado/alterado;
- refatoração;
- review de complexidade;
- CSV novo do RAD Studio;
- método legado já acima de limite;
- mudança que adiciona branches/parâmetros.

## Gates

| Métrica | Gate do projeto |
|---|---:|
| Length | <= 20 |
| Parameters | <= 6 |
| If Depth | <= 5 |
| Cyclomatic Complexity | <= 6 |
| Toxicity | < 1 |

`Toxicity` é valor composto do RAD Studio. Não reproduza/invente a fórmula.

## Evidence Levels

### Static assessment

Inspeção do código para Length/Parameters/If Depth/Cyclomatic qualitativamente ou por contagem verificável. Não é “RAD Studio approved”.

### Real metric

CSV/RAD Studio da revisão avaliada. Pode reportar `Toxicity` real.

### Historical baseline

Métrica real de revisão anterior. Útil para comparação, não prova do código atual.

Consulte `../../references/method-toxicity-baseline.md`.

## Process

### Step 1 — Identify affected methods

Liste somente métodos cujo body/signature mudou ou foram criados.

### Step 2 — Capture before state when possible

Para método existente:

- metric/baseline anterior se disponível;
- estrutura anterior;
- número de branches/params.

Sem before state, ainda aplique gates, mas não alegue melhoria/regressão exata sem evidência.

### Step 3 — Evaluate Length

Pergunte:

- método mistura responsabilidades?;
- setup repetitivo pode ir para helper coeso?;
- extração reduziria carga cognitiva ou apenas moveria linhas?

`Length > 20` em código novo requer redesign ou justificativa explícita autorizada.

### Step 4 — Evaluate Parameters

`Parameters > 6`:

- existe objeto/record de domínio real que representa esses valores juntos?;
- parâmetros pertencem a uma config existente?;
- overload está tentando fazer coisas diferentes?

Não invente DTO/record apenas para a métrica.

### Step 5 — Evaluate If Depth

Reduza nesting com:

- guard clause;
- early exit;
- separar validação de ação;
- state/policy real quando domínio possui variações.

Não troque nested `if` por métodos que continuam aninhando semanticamente sem benefício.

### Step 6 — Evaluate Cyclomatic Complexity

Branches demais podem sinalizar:

- responsabilidades misturadas;
- state machine implícita;
- switch/case que pertence a resolver/policy;
- múltiplos modos em um único método.

Escolha mudança que simplifique modelo, não apenas distribuição de branches.

### Step 7 — Classify code

#### New method

Deve nascer dentro dos gates salvo exceção autorizada.

#### Existing acceptable method

Mudança não deve empurrá-lo para fora do gate nem piorar sem necessidade.

#### Legacy toxic method, refactor authorized

Reduza métricas preservando comportamento/tests.

#### Legacy toxic method, refactor not authorized

Não expanda escopo só para corrigir dívida. Preserve ou melhore sem piorar e registre risco.

### Step 8 — Run RAD Studio/CSV when available

Se relatório fornecido:

- confirme arquivo corresponde ao projeto/revisão;
- localize métodos alterados;
- compare gates;
- registre máximos se baseline for atualizada;
- não misture CSV de Tests com Library/Sample.

### Step 9 — Review for metric gaming

Pergunte:

- criei wrapper de uma linha?;
- movi branches sem reduzir responsabilidade?;
- criei interface/helper só para cair Length?;
- aumentei número de conceitos para melhorar score?

Se sim, reverta o gaming.

## Refactoring Patterns That May Help

Use somente quando semanticamente apropriados:

- guard clauses;
- named helper com responsabilidade real;
- resolver para policy existente;
- state object quando estado é domínio real;
- reutilização de helper canônico;
- config record existente.

## Common Rationalizations

| Racionalização | Realidade |
|---|---|
| “Está abaixo de 1, então está ótimo.” | Outras métricas podem ter piorado e 1 é limite, não alvo. |
| “Vou extrair tudo para helpers.” | Micro-métodos podem mascarar complexidade. |
| “Toxicity dá para calcular pela fórmula.” | Use apenas valor da ferramenta; não invente. |
| “Método já era tóxico, posso adicionar mais.” | Regra é não agravar. |
| “CSV antigo prova a revisão atual.” | Baseline histórica não mede código novo. |

## Red Flags

- novo método acima dos gates sem justificativa;
- refactor aumenta conceitos/units apenas para score;
- `Toxicity` reportada sem CSV/RAD Studio;
- CSV de projeto errado usado como evidência;
- método legado piorado porque “já estava ruim”;
- parameters reduzidos via bag de dados sem semântica.

## Verification

- [ ] Métodos afetados foram identificados.
- [ ] Código novo respeita gates ou exceção explícita.
- [ ] Código existente não foi agravado injustificadamente.
- [ ] Legacy toxic code seguiu regra de escopo.
- [ ] Não houve metric gaming.
- [ ] `Toxicity` real só foi reportada com RAD Studio/CSV da revisão.
- [ ] Resultado foi classificado corretamente como real, histórico ou estático.
