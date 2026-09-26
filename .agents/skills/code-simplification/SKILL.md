---
name: code-simplification
description: Simplifica código existente do RickUIBuilder preservando comportamento e contratos. Use somente quando refatoração/simplificação estiver autorizada ou quando uma mudança precisa remover complexidade real sem alterar semântica pública.
---

# Code Simplification

## Overview

Simplificar significa reduzir conceitos, branches, duplicação ou acoplamento **sem mudar comportamento**. Mover o mesmo número de decisões para helpers/classes adicionais não é simplificação.

Aplique Chesterton's Fence: antes de remover algo estranho, entenda a função que ele exerce.

## When to Use

- refatoração explicitamente autorizada;
- método com complexidade difícil de manter;
- duplicação real;
- abstração que deixou de ter consumidor;
- Method Toxicity que exige redesign de responsabilidade;
- código legado coberto por characterization tests.

## When NOT to Use

- bugfix sem autorização de refactor;
- documentação;
- cleanup “já que estamos aqui”;
- tentativa de reduzir métricas artificialmente.

## Preconditions

- comportamento atual caracterizado;
- testes relevantes verdes antes da refatoração quando possível;
- public contract identificado;
- escopo de refactor autorizado;
- baseline de métricas disponível ou avaliação estática inicial.

## Process

### Step 1 — State the complexity problem

Exemplos válidos:

- mesma regra duplicada em três lugares;
- método mistura configuração, state transition e rendering;
- nested condition produz caminhos difíceis de testar;
- abstraction wrapper não adiciona policy/contract;
- lifecycle logic espalhada.

Evite “não gosto desse estilo”.

### Step 2 — Protect behavior

Se cobertura não é suficiente, adicione characterization tests antes de mexer.

### Step 3 — Find responsibility boundary

Pergunte:

- existe conceito que pode desaparecer?;
- branch pode virar early exit sem alterar contract?;
- duplicação pode usar helper já canônico?;
- state pode ser representado mais diretamente?;
- uma abstração pode ser removida em vez de renomeada?

### Step 4 — Prefer deletion over relocation

Melhor simplificação frequentemente:

- remove branch;
- remove duplicate state;
- remove wrapper;
- reutiliza helper existente;
- elimina uma camada.

Pior “simplificação”:

- cria três helpers com uma linha para diminuir Length;
- move `if` para strategy sem reduzir decisões;
- cria interface com único implementador sem boundary real.

### Step 5 — Refactor in small slices

Faça uma mudança estrutural por vez e mantenha testes verdes.

### Step 6 — Compare before/after

Avalie:

- conceitos necessários para entender;
- methods/branches;
- dependencies;
- Method Toxicity;
- test readability;
- public behavior.

### Step 7 — Stop when objective reached

Não transforme uma simplificação local em modernização geral.

## Method Toxicity Interaction

Use metrics como sinal, não design engine.

Se `Length > 20`:

- primeiro procure múltiplas responsabilidades;
- não extraia wrappers cosméticos.

Se cyclomatic > 6:

- procure state/decision model;
- guard clauses podem ajudar;
- dispatch/policy só quando existe variação real.

## Chesterton's Fence Questions

Antes de remover:

- quando foi introduzido?;
- que teste depende?;
- que bug histórico pode explicar?;
- existe plataforma/presentation específica?;
- o código parece redundante porque uma invariável não foi lida?

## Five Simplification Principles

### 1. Preserve behavior exactly

A refatoração não ganha licença para “corrigir” semantics não solicitadas. Se comportamento precisa mudar, trate como mudança funcional separada.

### 2. Follow project conventions

Uma solução localmente elegante que introduz paradigma novo pode piorar manutenção. Prefira patterns já entendidos no projeto quando adequados.

### 3. Prefer clarity over cleverness

Reduza necessidade de inferência. Guard clauses, names e boundaries claras valem mais que expressões compactas difíceis de ler.

### 4. Maintain balance

Não troque método grande por dezenas de micro-métodos. Não troque duplicação pequena por framework genérico.

### 5. Scope to what changed

Simplifique a área autorizada. Dívida adjacente pode ser registrada, não absorvida.

## Simplification Opportunities

### Nested conditionals

Antes:

```pascal
if AEnabled then
begin
  if Assigned(FTarget) then
  begin
    if FTarget.Visible then
      ApplyState;
  end;
end;
```

Possível simplificação quando semantics permitem:

```pascal
if not AEnabled then
  Exit;
if not Assigned(FTarget) then
  Exit;
if not FTarget.Visible then
  Exit;
ApplyState;
```

A melhoria é reduzir nesting sem mudar comportamento, não apenas mudar estilo.

### Duplicate state

Se o mesmo estado é mantido em Data e Presentation, determine qual é source of truth. Remover estado duplicado costuma simplificar mais que criar sincronização adicional.

### Wrapper without policy

Uma classe que apenas repassa todas chamadas sem ownership, policy ou abstraction boundary pode ser removível. Verifique consumidores antes.

### Repeated conditionals

Branches repetidos sobre o mesmo mode/state podem indicar um resolver/state abstraction real — ou apenas duas ocorrências que ainda não justificam pattern. Conte responsabilidade, não ocorrências mecanicamente.

### Long parameter lists

Antes de criar record, verifique se os parâmetros realmente formam um conceito de domínio/config. Caso contrário, reorganize responsabilidade ou aceite o design se dentro do gate.

## Before/After Evaluation

Compare:

| Critério | Antes | Depois |
|---|---|---|
| conceitos necessários para entender | | |
| branches/nesting | | |
| dependencies | | |
| public API | | |
| Method Toxicity | | |
| testes | | |

Se “depois” só desloca números, não há ganho real.

## Language-Specific Guidance — Delphi

- `with` não deve ser introduzido para reduzir linhas se obscurece owner do membro;
- nested `if` pode usar guard clauses;
- `case` é útil quando enum/state é explícito, mas não esconda missing member;
- local function/helper é válido quando responsabilidade permanece local;
- nova unit é justificada por responsibility boundary, não por line count;
- interface só se houver contract/boundary real;
- `record` deve representar conceito, não metric workaround;
- `try/finally` deve preservar cleanup explícito mesmo que adicione linhas.

## Common Rationalizations

| Racionalização | Realidade |
|---|---|
| “Menos linhas = mais simples.” | Número de conceitos/decisões importa mais. |
| “Interface desacopla.” | Sem boundary/consumer real pode só adicionar abstração. |
| “Extrair métodos melhora Toxicity.” | Só se melhora responsabilidade; wrappers cosméticos mascaram. |
| “Teste verde permite qualquer refactor.” | Tests podem não cobrir lifetime/API/visual behavior. |
| “Código estranho deve ser removido.” | Entenda primeiro por que existe. |

## Red Flags

- mais arquivos/classes após “simplificação” sem redução de conceitos;
- abstração genérica por uma única ocorrência;
- branches apenas deslocados;
- public API alterada sem requisito;
- tests atualizados para aceitar refactor que mudou comportamento;
- métricas melhoram porque método foi fragmentado artificialmente.

## Verification

- [ ] Problema de complexidade estava concreto.
- [ ] Comportamento foi protegido antes da mudança.
- [ ] Simplificação remove/organiza responsabilidade real.
- [ ] Public contract permanece.
- [ ] Tests permanecem verdes quando executados.
- [ ] Method Toxicity não piorou; idealmente melhorou por razão estrutural.
- [ ] Scope não expandiu além da autorização.
