---
name: debugging-and-error-recovery
description: Investiga falhas do RickUIBuilder de forma sistemática. Use para testes falhando, AVs, build/compiler errors, regressões visuais, comportamento runtime inesperado, lifetime defects ou quando uma tentativa de correção não resolveu a causa.
---

# Debugging and Error Recovery

## Overview

Debugging é redução de incerteza. O objetivo não é produzir rapidamente uma mudança que faz o sintoma sumir; é encontrar uma causa que explique a evidência e adicionar proteção contra recorrência.

## When to Use

- teste falhando/errored;
- AV;
- build/compiler/link error;
- comportamento visual divergente;
- handle detach/lifetime inesperado;
- regressão de state/selection;
- plataforma específica;
- tentativa anterior falhou;
- sintoma sem root cause claro.

## Stop-the-Line Rule

Quando aparece falha nova durante implementação:

1. pare de adicionar feature code;
2. determine se a falha foi introduzida pelo slice atual;
3. reproduza/localize;
4. só retome feature quando o estado estiver conhecido.

Não acumule novas mudanças sobre baseline quebrada sem decisão explícita.

## Workflow

```text
REPRODUCE
→ COLLECT EVIDENCE
→ LOCALIZE
→ REDUCE
→ HYPOTHESIZE
→ CHECK ATTEMPT LOG
→ TEST HYPOTHESIS
→ FIX ROOT CAUSE
→ GUARD
→ VERIFY BROADLY
```

## Step 1 — Reproduce

Defina o sintoma precisamente:

- qual teste?;
- qual exception/message?;
- qual ação visual?;
- qual plataforma/config?;
- sempre ou intermitente?;
- começou após qual mudança conhecida?

Se não reproduzível, registre condições conhecidas e evite alegar causa confirmada.

## Step 2 — Collect Evidence

Colete o mínimo que discrimina hipóteses:

- failing assertion/stack trace;
- actual vs expected;
- object/lifetime state;
- visual tree relevante;
- compiler error line;
- event count/order;
- changed files/diff.

Não faça mudanças ainda.

## Step 3 — Localize

Localize a menor boundary que ainda reproduz:

```text
whole suite
→ fixture
→ test
→ method/event path
→ state transition
```

Para compile error:

```text
project
→ unit
→ symbol/uses/signature
```

Para AV:

```text
operation
→ callback
→ reference
→ destruction order
```

## Step 4 — Reduce

Remova fatores não necessários:

- execute teste isolado;
- elimine dependência de outro component;
- use menor source data;
- feche popup/state extras;
- compare cenário que passa e falha.

Redução deve preservar o sintoma.

## Step 5 — Form a falsifiable hypothesis

Boa hipótese:

> `FControl` permanece non-nil após Parent destruction porque o holder não recebe Notification; acessar no callback causa AV.

Ruim:

> Lifetime está estranho.

Defina que evidência confirmaria/refutaria.

## Step 6 — Check Attempt Log

Se já houve múltiplas tentativas, abra `.agents/templates/attempt-log.md`.

Antes de experimentar:

- hipótese já foi testada?;
- resultado foi conclusivo?;
- arquivos alterados foram restaurados?;
- existe evidência nova que justifica repetir?

Não repita solução descartada apenas com nome diferente.

## Step 7 — Test the hypothesis with the smallest experiment

Prefira experimento que muda uma variável.

Exemplos:

- normalizar expected path sem tocar produção;
- adicionar focused lifetime test antes de mudar Handle;
- corrigir missing `uses` sem refatorar unit;
- observar `Parent` type antes de alterar hosting.

Se o experimento não muda previsão da hipótese, ele é ruim.

## Step 8 — Fix root cause

Uma causa adequada explica:

- sintoma principal;
- evidências correlatas;
- por que tentativas anteriores falharam quando relevante;
- por que a correção mínima resolve sem criar novo contrato.

Não aceite “funcionou” como root cause.

## Step 9 — Guard against recurrence

Adicione proteção:

- regression test;
- characterization;
- invariant doc quando manutenção pode repetir erro;
- Attempt Log concluído;
- source-driven note se a causa dependia de semântica da plataforma.

## Step 10 — Verify broadly

Depois do focused green:

- execute fixture relacionada;
- execute suite adequada;
- build;
- runtime/manual se visual;
- review lifetime/toxicity se `.pas` mudou.

Amplie conforme blast radius.

## Failure-Specific Triage

Leia `references/delphi-failure-triage.md` para árvore detalhada.

### Compiler error

Pergunte primeiro:

- symbol existe?;
- `uses` correto?;
- type mudou?;
- overload ambíguo?;
- scoped enum?;
- visibility/interface section?;
- compiler/version feature?

### DUnitX failure

Failure = assertion não satisfeita. Compare expected/actual e contrato.

### DUnitX error/AV

Error = teste não chegou à assertion normalmente. Priorize lifetime/setup/teardown/callback.

### Visual discrepancy

Compare visual tree, host, align, visibility, clipping, HitTest e style/presentation resolution antes de alterar dados.

### Lifetime issue

Mapeie ownership/destruction; não “resolver” mantendo referência forte sem entender contrato.

## Safe Fallbacks

Se root cause não puder ser confirmado:

- não faça redesign especulativo;
- preserve baseline estável;
- registre evidência e unknown;
- peça informação/execução necessária;
- proponha experimento pequeno e reversível.

## Common Rationalizations

| Racionalização | Realidade |
|---|---|
| “Essa mudança provavelmente resolve.” | Probabilidade não substitui hipótese falsificável. |
| “Já mexemos nessa área, então deve ser ali.” | Correlação histórica não localiza root cause atual. |
| “Vou refatorar para ficar mais fácil debugar.” | Refactor muda variáveis e pode apagar evidência. |
| “AV significa nil.” | Pode ser dangling pointer, double-free, callback tardio ou cast inválido. |
| “O Sample funciona, então teste está errado.” | Test pode revelar contrato/lifetime não exercitado pelo Sample. |
| “Já tentamos, mas vale tentar de novo.” | Só com nova evidência registrada. |

## Red Flags

- várias production changes antes de reproduzir;
- hipótese sem critério de refutação;
- mexer em Data/Style/lifetime quando failure aponta representação de teste;
- converter AV em `if Assigned` sem mapear dangling reference;
- alterar expected para actual sem requisito;
- repetir tentativa descartada;
- root cause não explica todas as evidências relevantes.

## Verification

- [ ] Sintoma foi reproduzido ou limites de reprodução estão explícitos.
- [ ] Evidência foi coletada antes de alterar produção.
- [ ] Falha foi localizada/reduzida.
- [ ] Hipótese era falsificável.
- [ ] Attempt Log foi consultado quando aplicável.
- [ ] Correção trata root cause, não apenas sintoma.
- [ ] Regression/guard foi adicionado quando aplicável.
- [ ] Focused verification passou quando executada.
- [ ] Blast radius maior foi verificado proporcionalmente.
- [ ] Resultados reais e limitações estão claramente separados.
