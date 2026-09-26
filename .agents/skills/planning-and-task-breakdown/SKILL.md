---
name: planning-and-task-breakdown
description: Decompõe uma especificação ou objetivo confirmado em tarefas pequenas, ordenadas e verificáveis para o RickUIBuilder. Use quando uma mudança possui múltiplos arquivos, dependências, riscos ou fases e precisa de um plano implementável sem perder escopo.
---

# Planning and Task Breakdown

## Overview

Um bom plano reduz blast radius. Cada tarefa deve terminar em um estado verificável e preparar a próxima, sem “implementar tudo” em um único salto.

## When to Use

- feature multi-arquivo;
- novo componente;
- refatoração autorizada;
- migração/reorganização;
- mudança pública com testes/docs;
- quando o usuário pede plano antes da execução.

**Não use para inflar tarefas triviais.** Uma alteração local bem especificada pode seguir direto para skill técnica.

## Inputs

Antes de planejar, tenha:

- objetivo confirmado;
- Context Map mínimo;
- in/out of scope;
- comportamento a preservar;
- riscos principais;
- acceptance criteria ou requisitos suficientemente claros.

Se isso não existir, volte para `context-engineering` ou `spec-driven-development`.

## Process

### Step 1 — Liste deliverables, não atividades vagas

Ruim:

> Trabalhar na API.

Bom:

> Adicionar overload público X preservando Y, com teste de chaining e integração.

### Step 2 — Identifique dependências

Pergunte para cada deliverable:

- precisa contrato antes da implementação?;
- precisa characterization test antes de refatorar?;
- uma unit depende de type/interface ainda inexistente?;
- docs dependem do código final?;
- toxicity depende do método final?;

### Step 3 — Escolha slicing strategy

#### Contract-first

Use quando API compartilhada precisa estabilizar consumidores/implementação.

```text
contract
→ tests
→ implementation
→ docs
```

#### Risk-first

Use quando existe incerteza crítica de lifetime/framework.

```text
small proof/characterization
→ decision
→ implementation
```

#### Vertical slice

Use quando cada incremento consegue entregar caminho completo observável.

### Step 4 — Faça tasks pequenas, mas completas

Cada task deve conter:

- objetivo;
- arquivos previstos;
- pré-condições;
- alteração;
- acceptance criteria;
- verificação;
- docs impact se aplicável.

Não fragmente um método em cinco tasks artificiais só para parecer incremental.

### Step 5 — Defina gate entre tasks

Antes de avançar:

- teste focado está verde?;
- build ainda está íntegro quando disponível?;
- contrato anterior não foi quebrado?;
- hipótese de risco foi resolvida?

### Step 6 — Reserve review/doc no ponto certo

Documentação profunda deve refletir implementação final. Pode ser preparada antes, mas só concluída depois do código estabilizar.

Review arquitetural pode acontecer antes de implementar se o plano muda boundaries.

### Step 7 — Defina rollback mental

Para mudanças arriscadas, mantenha claro:

- qual task introduziu qual comportamento;
- como isolar regressão;
- quais mudanças podem ser revertidas sem desmontar o resto.

Não é obrigatório criar commits automaticamente; o princípio é isolabilidade.

## Task Size Heuristics

Task está grande demais quando:

- toca várias responsabilidades sem um único acceptance criterion;
- não pode ser verificada antes da próxima;
- mistura API + refactor + docs + unrelated cleanup;
- tem descrição “implementar módulo inteiro”.

Task está pequena demais quando:

- só renomeia variável privada como fase isolada;
- separa operações que não possuem valor verificável sozinhas;
- cria overhead maior que o risco reduzido.

## Example — Public runtime option

```text
Task 1 — Caracterizar contrato atual
  files: interface/builder/tests
  verify: testes atuais

Task 2 — Definir API aditiva
  files: Interfaces/Types/builder
  verify: compile/static + chaining test

Task 3 — Aplicar runtime behavior
  files: Handle/implementation
  verify: integration test

Task 4 — Atualizar Sample/docs
  verify: exemplos e links

Task 5 — Quality gate
  verify: suite/build/toxicity/review
```

## Common Rationalizations

| Racionalização | Realidade |
|---|---|
| “Um plano detalhado precisa prever cada linha.” | Planeje contratos, riscos e verificações; implementação local pode emergir. |
| “Se eu separar, vai demorar mais.” | Slices verificáveis reduzem retrabalho e diagnóstico. |
| “Docs podem entrar na primeira task.” | Documentação final precisa refletir implementação estabilizada. |
| “Vou aproveitar e limpar o arquivo.” | Cleanup ortogonal precisa de escopo próprio. |
| “Tudo depende de tudo.” | Normalmente há um contrato ou risco que pode ser estabilizado primeiro. |

## Red Flags

- task sem acceptance criterion;
- task sem verificação;
- muitos arquivos sem justificativa;
- docs antes de comportamento definido;
- refactor misturado a bugfix sem autorização;
- nenhuma ordem de dependência;
- plano que não menciona API/lifetime apesar de afetá-los.

## Verification

- [ ] Cada task entrega algo verificável.
- [ ] Dependências estão ordenadas.
- [ ] Slicing strategy é adequada ao risco.
- [ ] Não existe cleanup fora do escopo embutido.
- [ ] Tests/build/toxicity/docs têm ponto definido no plano.
- [ ] O plano permite identificar qual task introduziu regressão.
- [ ] Arquivos previstos são coerentes com o Context Map.
