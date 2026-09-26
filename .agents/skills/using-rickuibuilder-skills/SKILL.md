---
name: using-rickuibuilder-skills
description: Descobre e combina workflows de engenharia do RickUIBuilder. Use no início de qualquer tarefa técnica para classificar intenção, risco, domínio e skills necessárias antes de analisar, implementar, testar, revisar, documentar ou entregar mudanças.
---

# Using RickUIBuilder Skills

## Overview

Esta é a meta-skill que governa descoberta e composição das demais skills. Seu objetivo é impedir duas falhas recorrentes: começar a editar antes de entender o problema e carregar workflows irrelevantes que diluem o contexto.

O RickUIBuilder é brownfield. Portanto, a estratégia padrão não é “construir do zero”; é compreender contratos existentes, proteger comportamento e só então alterar.

## When to Use

Use:

- no início de qualquer sessão/tarefa de engenharia;
- quando a solicitação mistura implementação, teste, documentação ou review;
- quando não estiver claro qual workflow aplicar;
- quando o trabalho muda de fase durante a mesma tarefa;
- quando uma falha exige sair de implementação e entrar em debugging.

**Não use como substituto das skills específicas.** Esta skill roteia; não implementa por elas.

## Core Operating Behaviors

### 1. Classifique a tarefa antes de agir

Determine primeiro:

- análise read-only;
- documentação;
- bugfix;
- feature;
- novo componente;
- mudança de API;
- refatoração;
- UI/FMX;
- teste;
- build/debugging;
- release/entrega.

Uma mesma tarefa pode ter mais de uma classe, mas precisa de uma principal.

### 2. Surface assumptions

Se houver uma suposição que possa alterar escopo, API, arquitetura ou comportamento, não a esconda. Procure evidência no repositório. Se não existir, marque `Não confirmado.` e peça decisão quando material.

### 3. Manage confusion actively

Quando encontrar conflito entre requisito, código, teste e documentação:

```text
STOP
↓
identifique o conflito
↓
reúna evidência
↓
defina a fonte com precedência
↓
prossiga somente após resolver
```

Não selecione silenciosamente a interpretação que facilita a implementação.

### 4. Scope discipline

Carregue a skill mínima que protege o risco real. Não use feature work para justificar cleanup adjacente.

### 5. Verify, don't assume

Toda skill termina em evidência. Se a evidência não puder ser produzida, a saída correta é registrar a limitação — nunca promover análise estática a execução real.

## Workflow — Skill Discovery

```text
Tarefa chega
  │
  ├─ contexto/repositório desconhecido? ───────→ context-engineering
  ├─ nova feature significativa? ──────────────→ spec-driven-development
  ├─ precisa plano? ───────────────────────────→ planning-and-task-breakdown
  ├─ componente existente/novo? ───────────────→ component-maintenance
  ├─ editar .pas? ─────────────────────────────→ delphi-change-safety
  ├─ UI/interação FMX? ────────────────────────→ fmx-ui-engineering
  ├─ API/interface pública? ───────────────────→ api-and-interface-design
  ├─ mudança multi-arquivo? ───────────────────→ incremental-implementation
  ├─ novo comportamento/bug? ──────────────────→ test-driven-development
  ├─ falha/AV/build/test inesperado? ──────────→ debugging-and-error-recovery
  ├─ semântica externa não confirmada? ────────→ source-driven-development
  ├─ review? ──────────────────────────────────→ code-review-and-quality
  ├─ refatoração autorizada? ──────────────────→ code-simplification
  ├─ docs/ADR? ────────────────────────────────→ documentation-and-adrs
  ├─ .pas alterado? ───────────────────────────→ method-toxicity
  └─ entrega? ─────────────────────────────────→ release-and-delivery
```

## Lifecycle Sequence

Um ciclo completo de feature pode seguir:

```text
DEFINE
  spec-driven-development
    ↓
PLAN
  planning-and-task-breakdown
    ↓
CONTEXT
  context-engineering + component-maintenance
    ↓
BUILD
  delphi-change-safety / fmx-ui / api design / incremental implementation
    ↓
VERIFY
  TDD + debugging quando necessário + toxicity
    ↓
REVIEW
  code-review-and-quality
    ↓
DOCUMENT
  documentation-and-adrs
    ↓
DELIVER
  release-and-delivery
```

Nem toda tarefa percorre todas as fases.

## Routing by Intent

### Read-only analysis

Aplique:

1. `context-engineering`;
2. `component-maintenance` se houver componente alvo;
3. `source-driven-development` somente se a análise depender de semântica externa.

**Proibido:** editar arquivo apenas porque uma melhoria foi observada.

### Documentation-only

Aplique:

1. `context-engineering`;
2. `documentation-and-adrs`;
3. source code/testes como fonte;
4. `source-driven-development` se documentação depende de API externa;
5. review documental.

Não aplique TDD/toxicity sem código alterado.

### Bugfix

Aplique normalmente:

1. `debugging-and-error-recovery`;
2. `component-maintenance`;
3. `test-driven-development`;
4. `delphi-change-safety` se `.pas` mudar;
5. `fmx-ui-engineering` se UI/lifetime visual mudar;
6. `method-toxicity` se `.pas` mudar;
7. `code-review-and-quality`.

### Build/compile failure

Priorize:

1. `debugging-and-error-recovery`;
2. `delphi-change-safety`;
3. `source-driven-development` apenas quando a semântica do compiler/framework exigir confirmação.

Não crie teste comportamental só porque houve erro sintático.

### New component

Aplique:

1. `spec-driven-development`;
2. `planning-and-task-breakdown`;
3. `context-engineering`;
4. `component-maintenance`;
5. `api-and-interface-design` se público;
6. `fmx-ui-engineering` se visual;
7. `incremental-implementation`;
8. `test-driven-development`;
9. `method-toxicity`;
10. `documentation-and-adrs`;
11. `code-review-and-quality`;
12. `release-and-delivery`.

A sequência não autoriza criar todas as camadas arquiteturais existentes no ComboBox.

### Public API change

Aplique:

1. `context-engineering`;
2. `api-and-interface-design`;
3. `component-maintenance`;
4. `test-driven-development`;
5. `documentation-and-adrs`;
6. `code-review-and-quality`.

### Refactoring

Somente se explicitamente autorizada:

1. `context-engineering`;
2. characterization/TDD quando necessário;
3. `code-simplification`;
4. `delphi-change-safety`;
5. `method-toxicity`;
6. review independente.

## Risk Multipliers

Aumente rigor quando houver:

- API pública;
- GUID/interface;
- ownership/lifetime;
- reference counting;
- eventos/anonymous methods;
- visual root/parentagem;
- múltiplas plataformas;
- virtualização;
- mudança estrutural multi-unit;
- regressão sem reprodução clara;
- método já próximo/acima de gates de Toxicity.

Risco maior pode justificar `source-driven-development`, review separado e testes de integração adicionais.

## Progressive Disclosure Rules

1. Não carregue todas as skills “por segurança”.
2. Carregue referências somente quando o workflow chega ao ponto que precisa delas.
3. Para componente complexo, leia documentação de domínio antes de abrir todas as units.
4. Se o contexto já possui evidência completa, não repita descoberta sem motivo.
5. Quando a tarefa muda de natureza — por exemplo, implementação encontra um AV — mude de skill em vez de improvisar.

## Brownfield Rules

- comportamento existente comprovado é restrição;
- refatoração sem cobertura exige characterization quando aplicável;
- teste atual pode estar incompleto; não trate “verde” como prova universal;
- arquitetura existente deve ser entendida antes de ser simplificada;
- não copie o componente mais complexo como template universal;
- mudanças novas devem melhorar ou pelo menos não degradar o quality floor.

## Skill Composition Examples

### `Button` hover regression

```text
debugging-and-error-recovery
→ component-maintenance
→ fmx-ui-engineering
→ test-driven-development
→ delphi-change-safety
→ method-toxicity
→ code-review-and-quality
```

### `Divider` documentação

```text
context-engineering
→ component-maintenance
→ documentation-and-adrs
```

### Novo overload público de Badge

```text
api-and-interface-design
→ component-maintenance
→ test-driven-development
→ delphi-change-safety
→ method-toxicity
→ documentation-and-adrs
→ code-review-and-quality
```

### FullWindow ComboBox

```text
component-maintenance
→ docs/combobox específicos
→ fmx-ui-engineering
→ delphi-change-safety
→ TDD
→ toxicity
→ review
```

## Common Rationalizations

| Racionalização | Realidade |
|---|---|
| “Já sei qual arquivo mudar.” | Saber um arquivo não significa conhecer contratos/consumidores. |
| “Vou só olhar o código primeiro e depois escolho skill.” | Context discovery também é workflow; use a meta-skill para escolher o caminho. |
| “É pequeno demais para processo.” | Use processo proporcional; não pule o gate essencial. |
| “Carregar todas as skills é mais seguro.” | Dilui contexto e introduz regras irrelevantes. |
| “O usuário pediu código, então spec/plano são dispensáveis.” | Para mudança significativa, definir contrato reduz retrabalho; escolha proporcionalmente. |
| “O ComboBox já mostra o padrão.” | Ele mostra um caso complexo, não arquitetura universal. |

## Red Flags

- começar edição antes de classificar intent;
- usar uma única skill para toda tarefa apesar de mudança de fase;
- carregar skills sem relação com risco real;
- criar nova skill para um componente específico quando o workflow é genérico;
- usar agent persona como roteador;
- afirmar conclusão sem passar pela Verification da skill ativa;
- ignorar conflito entre teste e documentação.

## Verification

Antes de sair desta meta-skill:

- [ ] Intenção principal foi classificada.
- [ ] Risco e domínio foram identificados.
- [ ] Skills escolhidas cobrem os riscos reais sem excesso.
- [ ] Tarefas read-only permanecem read-only.
- [ ] Mudança significativa recebeu spec/plano quando necessário.
- [ ] Nenhuma persona foi usada como router.
- [ ] A próxima skill possui contexto suficiente para iniciar.
