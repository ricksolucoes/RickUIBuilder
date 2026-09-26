---
name: test-driven-development
description: Conduz desenvolvimento e correções do RickUIBuilder com DUnitX usando RED-GREEN-REFACTOR, Prove-It para bugs e characterization tests para legado. Use ao adicionar lógica, alterar comportamento, corrigir regressões ou refatorar código cuja segurança depende de testes.
---

# Test-Driven Development

## Overview

Testes são evidência executável de comportamento. Para bugfix, o teste deve provar o defeito antes de a correção ser aceita quando tecnicamente possível. Para refatoração, characterization tests protegem o comportamento atual antes de alterar estrutura.

No RickUIBuilder, “testar” pode signific unit test puro ou integração FMX com `TForm` host. Escolha o nível que captura o risco real.

## When to Use

- nova lógica;
- novo comportamento público;
- bugfix;
- alteração de state/selection/event;
- mudança de lifetime observável;
- refatoração de comportamento já existente;
- mudança em Handle/builder que pode regressar contrato.

## When NOT to Use

Não force TDD para:

- documentação pura;
- alteração estática de texto;
- correção sintática sem comportamento observável novo;
- mudança de configuração externa sem test harness apropriado.

Mesmo nesses casos, alguma verificação ainda é necessária.

## Discover the Test Structure First

Antes de escrever teste:

1. localize `tests/RickUIBuilder.Test.dpr/.dproj`;
2. localize fixture do componente;
3. veja naming local;
4. identifique `Category('Integration')` quando existe host FMX;
5. veja Setup/TearDown e helpers existentes;
6. determine como executar teste focado e suíte no ambiente disponível;
7. não invente comando se toolchain não está acessível.

O repositório usa DUnitX e fixtures como `TRickUIBuilderButtonBuildTests`/`TRickUIBuilderComboBoxIntegrationTests` para integração visual.

## The TDD Cycle

```text
RED
write a test that fails for the intended reason
    ↓
GREEN
write the minimum production change that makes it pass
    ↓
REFACTOR
simplify only if authorized/necessary, keeping tests green
    ↓
repeat
```

## Step 1 — RED

Um RED válido precisa:

- representar requisito real;
- falhar antes da correção;
- falhar pelo motivo correto;
- não depender de detalhe incidental;
- ser determinístico.

Se o teste passa imediatamente:

- comportamento já existe?;
- teste não reproduz bug?;
- assertion está fraca?;
- cenário está errado?

Não siga para GREEN sem entender.

## Step 2 — GREEN

Faça a menor mudança capaz de satisfazer o teste e contrato.

Evite durante GREEN:

- refatorar adjacências;
- redesenhar API;
- adicionar abstração futura;
- otimizar sem evidência.

## Step 3 — REFACTOR

Refactor só quando:

- escopo permite;
- comportamento está protegido;
- simplificação remove complexidade real;
- Method Toxicity/legibilidade melhoram sem API regression.

Se a tarefa é apenas bugfix e não autoriza refactor, pare em GREEN + cleanup mínimo necessário.

## Prove-It Pattern for Bugs

### 1. Reproduce

Obtenha sintoma observável.

### 2. Encode regression

Crie teste que representa exatamente o contrato quebrado.

### 3. Prove failure

Confirme que falha com implementação anterior. Se não puder executar, registre que é test design estático, não prova real.

### 4. Fix root cause

Use `debugging-and-error-recovery` quando root cause ainda não está localizado.

### 5. Prove green

Teste focado precisa passar.

### 6. Broaden verification

Execute fixture/suite adequadas para detectar regressões.

## Characterization Tests

Use antes de alterar legado sem cobertura.

Objetivo:

> fixar comportamento atual, mesmo que ele pareça estranho, para separar refatoração de mudança funcional.

Processo:

1. observe comportamento real/código;
2. escreva teste que captura o contrato atual;
3. confirme;
4. refatore mantendo verde;
5. se comportamento também precisa mudar, escreva novo teste separado para novo requisito.

## Choosing the Test Level

### Pure unit

Use para:

- Data/State/Style logic;
- calculations/defaults;
- builder chaining sem Build;
- mapping independente de FMX host.

### FMX integration

Use para:

- Build/BuildHandle;
- Parent/Owner;
- event dispatch;
- visual tree;
- detach/destruction;
- interaction state;
- presentation host;
- scroll/virtualization integration.

### Manual/runtime complement

Use para percepção visual/UX que testes estruturais não capturam, mas não substitua automated contract test se ele for possível.

## DUnitX Patterns

Leia `references/dunitx-test-patterns.md` para exemplos de estrutura e lifetime.

Princípios:

- Arrange → Act → Assert;
- nome descritivo;
- uma ideia comportamental por teste;
- fixtures isoladas;
- cleanup determinístico;
- helpers devem melhorar legibilidade, não esconder assertions.

## Test the Contract, Not Incidental Representation

Exemplo real de princípio: `TPathData.Data` pode parsear e reserializar path data. A string de entrada não é garantia de identidade textual.

Logo:

- teste semântica/canonical representation;
- normalize expected/actual quando apropriado;
- não force production code a preservar formato textual que a API não promete.

A mesma regra vale para ordem interna de children, floating-point rendering ou outras representações incidentais.

## State and Event Tests

Quando componente possui estado:

- inicial;
- transition válida;
- invalid transition;
- repeated action;
- callback count;
- callback payload;
- state after close/reopen;
- state after source mutation.

## Lifetime Tests

Quando handle/behavior/parent estão envolvidos, considere:

- Build sem manter builder interface;
- liberar Handle antes dos controls;
- destruir Parent antes do Handle;
- destruir sibling irrelevante;
- destruir com popup/state ativo;
- confirmar `IsAttached`/detach behavior;
- confirmar que handle não libera control owned externamente.

## Edge Cases

Selecione conforme contrato:

- empty;
- `-1`/invalid index;
- duplicate display text/value;
- single-space versus empty quando semântica difere;
- zero/negative geometry se permitido;
- repeated Add/Close/Open;
- no callback configured;
- missing optional path/config.

Não crie matriz combinatória sem risco real.

## Test Helpers

Um helper é adequado quando:

- reduz repetição de setup;
- nomeia um conceito (`RequireEdit`, `FindScrollBox`);
- centraliza normalização sem esconder expectativa.

Red flag: helper faz várias assertions implícitas e torna impossível saber por que teste falhou.

## Common Rationalizations

| Racionalização | Realidade |
|---|---|
| “Bug é óbvio, não precisa teste.” | Sem regressão, a mesma causa pode retornar e não há prova automatizada. |
| “Vou escrever teste depois do fix.” | Você perde prova de que o teste realmente detectava o bug. |
| “Integration test é pesado; vou mockar FMX.” | Se o risco é visual tree/lifetime, mock não cobre o contrato. |
| “String é igual visualmente, então posso comparar literal.” | APIs podem normalizar representação sem alterar semântica. |
| “Full suite verde prova tudo.” | Só prova o que a suíte cobre. |
| “Characterization congela bug.” | Ela separa comportamento existente de refactor; mudança funcional pode vir em teste posterior. |

## Red Flags

- novo teste passa antes da implementação sem explicação;
- assertion alterada para aceitar produção quebrada;
- integração FMX substituída por unit test que não materializa lifecycle;
- shared mutable fixture entre testes;
- leak/AV mascarado em TearDown;
- helper que captura exception e retorna sucesso;
- test name genérico (`Test1`, `Works`);
- baseline antiga usada como resultado da revisão atual.

## Verification

### Per behavior

- [ ] Teste representa requisito real.
- [ ] RED foi observado quando aplicável e ambiente disponível.
- [ ] GREEN foi observado.
- [ ] Teste falha pelo motivo correto sem a mudança.
- [ ] Nível de teste captura o risco real.

### Before completion

- [ ] Testes focados passaram quando executados.
- [ ] Escopo mais amplo adequado foi executado quando disponível.
- [ ] Nenhuma assertion foi enfraquecida sem requisito.
- [ ] Characterization precedeu refactor de legado quando necessário.
- [ ] Resultado reportado corresponde exatamente ao que foi executado.
