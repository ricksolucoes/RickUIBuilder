# Orchestration Patterns — RickUIBuilder

Esta referência define como combinar personas e skills sem criar cadeias profundas de agentes ou duplicação de contexto.

## Regra central

**O usuário, AGENTS.md e a meta-skill fazem o roteamento. Personas não chamam personas.**

Skills podem ser usadas por qualquer persona apropriada.

## Pattern 1 — Direct specialist

```text
user/task
→ persona especializada
→ skill aplicável
→ output
```

Use quando existe uma perspectiva clara sobre um artefato.

Exemplos:

- review de diff → `code-reviewer`;
- estratégia de testes → `test-engineer`;
- documentação → `technical-writer`.

É o padrão mais barato e deve ser preferido quando suficiente.

## Pattern 2 — Main-agent workflow

```text
task
→ using-rickuibuilder-skills
→ sequência de skills
→ resultado
```

Use para implementação normal. Não é necessário criar persona separada para cada fase.

## Pattern 3 — Independent review fan-out

Para mudança de risco alto, perspectivas independentes podem analisar o mesmo diff:

```text
                 ┌→ code-reviewer ─┐
main change ─────┼→ test-engineer ─┼→ merge findings
                 └→ quality-auditor┘
```

Use somente quando as análises são realmente independentes e a fusão é simples.

O merge deve preservar divergências relevantes; não reduza três findings distintos a “parece ok”.

## Pattern 4 — Sequential lifecycle com checkpoint humano

```text
spec
→ plan
→ implementation
→ review
→ delivery
```

Use quando cada fase depende da anterior e uma decisão humana intermediária pode mudar direção/escopo.

Não automatize a cadeia inteira se isso elimina checkpoints importantes.

## Pattern 5 — Research isolation

Quando é necessário ler grande quantidade de fontes externas ou muitas units para produzir um digest pequeno, isole a pesquisa e retorne somente evidências necessárias ao workflow principal.

O pesquisador deve ser read-only quando sua função é descoberta.

## Anti-pattern A — Router persona

```text
task → router-persona → escolhe persona → persona
```

Problemas:

- hop extra sem valor de domínio;
- perda de contexto em resumo;
- regras duplicadas com AGENTS/meta-skill;
- custo e latência desnecessários.

Solução: roteamento direto via intent mapping.

## Anti-pattern B — Persona chama persona

`code-reviewer` não deve chamar `test-engineer` internamente. Ele pode recomendar uma revisão de testes, mas a composição deve ser feita pelo usuário/main workflow.

## Anti-pattern C — Deep agent tree

Evite:

```text
router
→ coordinator
  → reviewer
    → specialist
```

Cada camada perde contexto e torna auditoria mais difícil.

## Anti-pattern D — Todos os agents em toda tarefa

Um typo documental não precisa de code reviewer + test engineer + Delphi engineer + quality auditor.

Progressive disclosure também se aplica a personas.

## Decision guide

```text
Uma única perspectiva resolve?
├─ sim → direct specialist
└─ não → perspectivas independentes?
         ├─ sim → fan-out + merge
         └─ não → workflow sequencial com checkpoints
```

## Composition with skills

Uma persona deve declarar skills comuns, mas escolher somente as pertinentes ao artefato.

Exemplo `code-reviewer`:

```text
code-review-and-quality
+ delphi-change-safety se .pas
+ method-toxicity se método mudou
+ api-and-interface-design se API pública
```

## Evidence ownership

Cada persona deve declarar o que verificou. O merge não pode transformar “não verificado” em “aprovado”.
