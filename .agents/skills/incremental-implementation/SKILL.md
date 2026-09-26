---
name: incremental-implementation
description: Entrega mudanças do RickUIBuilder em slices pequenos e verificáveis. Use em alterações multi-arquivo, features, refatorações autorizadas ou qualquer tarefa em que implementar tudo de uma vez aumente risco de regressão ou dificulte localizar a causa de falhas.
---

# Incremental Implementation

## Overview

Implemente o menor incremento coerente, verifique-o e só então expanda. O objetivo não é produzir commits artificiais; é manter causalidade, reduzir blast radius e evitar um grande lote de mudanças impossível de diagnosticar.

## When to Use

- feature em mais de um arquivo;
- novo componente;
- mudança que cruza API + runtime + docs;
- refatoração autorizada;
- mudança com risco de lifetime/visual state;
- tarefa que naturalmente possui contrato antes de implementação.

**When NOT to use:** correção realmente local e autocontida em que o overhead de slicing não reduz risco.

## Increment Cycle

```text
Implement smallest coherent slice
        ↓
Focused test / build / static gate
        ↓
Verify intended effect
        ↓
Review diff of the slice
        ↓
Proceed to next slice
```

Se o slice falha, não continue acumulando código sobre estado desconhecido.

## Slicing Strategies

### 1. Contract-first slicing

Use para API pública.

```text
Slice 1 — define public contract + tests
Slice 2 — minimal implementation
Slice 3 — runtime integration
Slice 4 — docs/Sample
```

### 2. Risk-first slicing

Use quando a maior incerteza é técnica.

Exemplo:

```text
Slice 1 — characterize destruction behavior
Slice 2 — prove corrected lifetime in focused test
Slice 3 — integrate with full component
```

Não construa toda feature antes de resolver a dúvida de lifetime que pode invalidar a arquitetura.

### 3. Vertical slicing

Use quando é possível entregar caminho observável completo sem construir toda a feature.

Exemplo hipotético de componente novo:

```text
Slice 1 — builder + basic Build + test
Slice 2 — first runtime property + Handle + test
Slice 3 — interaction/state + integration test
Slice 4 — advanced customization
```

### 4. Structural slicing

Use com cautela em refatoração. Um slice estrutural só é aceitável se o comportamento continuar verificável entre etapas.

## Implementation Rules

### Rule 0 — Simplicity first

Antes de criar abstração, tente a solução coesa mais simples. Não generalize a partir de um único caso.

### Rule 1 — One behavior at a time

Cada slice deve ter um efeito principal. Se muda API, ownership, visual tree e algoritmo ao mesmo tempo, está grande demais.

### Rule 2 — Keep the project in a knowable state

Quando build é executável, prefira slices compiláveis. Quando não é, mantenha diff estático coerente e não acumule símbolos quebrados deliberadamente sem necessidade.

### Rule 3 — Tests travel with behavior

O teste/prova do slice deve acompanhar o comportamento, não ser postergado para o fim da feature.

### Rule 4 — Safe defaults

Nova configuração pública deve ter default que preserve comportamento existente quando esse é o requisito.

### Rule 5 — Rollback-friendly

Um slice deve ser reversível conceitualmente. Evite entrelaçar mudanças independentes em um mesmo patch.

### Rule 6 — No drive-by cleanup

Se durante o slice encontrar dívida não necessária ao objetivo, registre e siga. Não expanda escopo silenciosamente.

## Working with Public API

Uma sequência comum:

1. definir type/interface/signature;
2. criar teste de contrato/chaining;
3. implementar armazenamento/config;
4. materializar runtime;
5. testar integração;
6. atualizar docs.

Não pule direto para visual internals e depois “descubra” a API.

## Working with FMX

Para mudança visual complexa:

1. caracterize visual tree atual;
2. altere um container/interaction path por vez;
3. execute integration test;
4. preserve lifetime/scroll/selection;
5. só depois refine visual details.

## Working with Legacy Code

Se um método grande precisa de correção, não refatore tudo primeiro. Preferência:

```text
characterize behavior
→ fix/regression
→ verify
→ refactor separately if authorized
```

Isso separa mudança funcional de simplificação.

## Slice Review Questions

Antes de avançar:

- O slice tem um propósito único?;
- O teste falha sem ele e passa com ele quando aplicável?;
- Ele deixou o componente em estado coerente?;
- Introduziu abstração que só o próximo slice justifica?;
- O próximo slice pode ser cancelado sem quebrar este?;
- O diff contém cleanup não relacionado?

## Common Rationalizations

| Racionalização | Realidade |
|---|---|
| “É mais rápido fazer tudo e testar no fim.” | Quando falha, causalidade é perdida e retrabalho cresce. |
| “Preciso criar todas as classes primeiro.” | Muitas classes podem ser arquitetura especulativa; deixe o comportamento justificar. |
| “O teste só faz sentido quando tudo estiver pronto.” | Normalmente existe contrato menor que pode ser provado antes. |
| “Já que toquei o arquivo, vou limpar.” | Cleanup ortogonal aumenta blast radius. |
| “Slice pequeno significa micro-commit.” | Slicing é sobre verificabilidade, não contagem de linhas. |

## Red Flags

- centenas de linhas antes da primeira verificação;
- vários behaviors novos em um único slice;
- tests todos deixados para última task;
- componente quebra temporariamente entre várias fases sem necessidade;
- nova abstração criada antes de qualquer consumidor;
- bugfix misturado com grande simplificação.

## Verification

Para cada slice:

- [ ] propósito único está claro;
- [ ] diff está dentro do escopo;
- [ ] teste/build/static gate adequado foi executado ou limitação declarada;
- [ ] comportamento anterior relevante continua protegido;
- [ ] nenhuma abstração especulativa foi introduzida;
- [ ] próximo slice pode começar sobre estado conhecido.

Antes de encerrar a feature:

- [ ] todos os slices atendem acceptance criteria;
- [ ] full verification aplicável foi executada;
- [ ] docs refletem implementação final;
- [ ] review final ocorreu.
