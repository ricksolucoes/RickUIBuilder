---
name: delphi-change-safety
description: Controla alterações seguras em Object Pascal/Delphi no RickUIBuilder. Use sempre que um arquivo .pas for criado ou modificado, especialmente quando houver interfaces, GUIDs, callbacks, FMX, ownership, lifetime, generics, exceptions ou API pública.
---

# Delphi Change Safety

## Overview

Esta skill transforma preocupações típicas de Delphi em gates operacionais. Compilar não é suficiente: código pode compilar e ainda conter dangling references, double-free, reference cycles, incompatibilidade de API ou regressão de lifetime.

Use esta skill para qualquer `.pas` tocado. A profundidade do workflow deve ser proporcional ao risco.

## When to Use

- criar/editar `.pas`;
- alterar interfaces, records, enums ou fluent builders;
- criar/alterar Handle/Behavior;
- mudar eventos/anonymous methods;
- mover types entre units;
- alterar ownership/lifetime;
- corrigir compile error;
- refatorar método Delphi.

## When NOT to Use

Não é necessária para alteração exclusivamente Markdown/config sem `.pas`. Não regrave `.pas` apenas para “aplicar” esta skill.

## Prerequisites

Antes de editar:

- Context Map suficiente;
- component domain identificado;
- comportamento a preservar;
- public surface conhecida;
- versão/compiler exato confirmado **ou** decisão de preservar apenas recursos já usados no projeto.

## Process

### Step 1 — Classifique a alteração Delphi

Marque os riscos aplicáveis:

- [ ] sintaxe/uses;
- [ ] API pública;
- [ ] interface/GUID;
- [ ] records/enums/defaults;
- [ ] FMX visual tree;
- [ ] lifetime/ownership;
- [ ] reference counting;
- [ ] callbacks/events;
- [ ] generics/RTTI;
- [ ] exceptions;
- [ ] plataforma/compiler;
- [ ] encoding;
- [ ] Method Toxicity.

Quanto mais caixas, maior a necessidade de review e testes de integração.

### Step 2 — Preserve compiler compatibility

Não introduza recurso de linguagem apenas porque é conhecido pelo agente.

1. procure o padrão já usado no repositório;
2. inspecione `.dproj/.dpk` se necessário;
3. confirme versão externa somente quando a decisão depende dela;
4. se versão exata não estiver confirmada, use o subset já comprovado no código.

`ProjectVersion`/`Delphi.Personality` isolados não são garantia da toolchain que o usuário está executando.

### Step 3 — Review `uses`

Pergunte:

- o type aparece em interface pública? → pode exigir `interface uses`;
- é dependência somente da implementação? → prefira `implementation uses` quando possível;
- uma unit foi adicionada apenas porque outro arquivo usa? → remova se não há símbolo consumido;
- mover `uses` altera circular dependency?;
- namespace correto está usado?

Não faça “cleanup” amplo de uses fora dos arquivos tocados.

### Step 4 — Public types and Scoped Enums

Para enum público:

- preserve type/member names;
- use `Type.Member` em código novo;
- não troque ordinal/meaning silenciosamente;
- reveja defaults e tests.

Para record público:

- preserve initialization semantics;
- novo field precisa default coerente;
- não crie record apenas para reduzir parâmetro count;
- revise impacto em consumers/constructors/default methods.

### Step 5 — Interfaces and GUIDs

Quando interface é alterada:

1. localize GUID;
2. localize implementadores;
3. localize consumers;
4. determine se mudança é aditiva/compatível/breaking;
5. não altere GUID por conveniência;
6. analise `IInterface` lifetime;
7. atualize testes/docs.

GUID é parte do contrato de identidade da interface.

### Step 6 — Map lifetime before coding

Para cada objeto/referência relevante, responda:

```text
Quem cria?
Quem destrói?
Existe Owner?
Existe Parent?
A referência é owning ou non-owning?
Pode o target morrer primeiro?
Precisa FreeNotification?
Uma interface mantém o objeto vivo?
Callback captura self/controle/handle?
```

Se alguma resposta material é desconhecida, não implemente o lifecycle por tentativa.

Leia `references/ownership-lifetime-guide.md` quando o risco for maior que trivial.

### Step 7 — Events and anonymous methods

Eventos podem substituir callbacks do consumidor e anonymous methods podem capturar referências.

Verifique:

- handler interno sobrescreve handler público?;
- ambos precisam coexistir?;
- callback permanece depois do controle morrer?;
- closure captura `Self` ou controle e prolonga lifetime?;
- cleanup remove handler/notificação corretamente?

### Step 8 — Exceptions and failure semantics

Não introduza `try/except` amplo para “estabilizar”.

Pergunte:

- exception atual faz parte do comportamento observável?;
- erro deve propagar, retornar estado ou ser ignorado?;
- fallback esconderia bug?;
- cleanup usa `try/finally` quando necessário?

### Step 9 — Implement minimal change

Escreva a menor alteração que satisfaz o contrato.

Evite:

- refactor ortogonal;
- nova interface sem necessidade;
- helper sem responsabilidade real;
- generic abstraction por uma ocorrência;
- reorganização de units para “ficar bonito”.

### Step 10 — Encoding Gate

Todo `.pas` efetivamente modificado deve ser salvo em UTF-8 com BOM.

Verificação de bytes:

```text
EF BB BF
```

Não converta `.pas` não tocados. O repositório pode conter arquivos legados em encodings diferentes; esta tarefa não autoriza normalização global.

### Step 11 — Method Toxicity

Aplique `method-toxicity` a métodos novos/alterados.

Não extraia micro-método que não melhora responsabilidade apenas para reduzir `Length`.

### Step 12 — Validation

Conforme risco:

- teste focado;
- integration test;
- build real;
- runtime/manual;
- static review;
- independent code review.

Relate exatamente o que executou.

## Decision Guides

### Raw object ou interface?

Pergunte qual lifetime é desejado. Interface pode prolongar objeto via reference counting; raw reference pode virar dangling. Não escolha apenas por conveniência sintática.

### `Owner` suficiente?

Não necessariamente. `Owner` participa de destruição de `TComponent`; `Parent` trata visual tree. Um holder externo ainda pode precisar observar destruição.

### `FreeNotification` necessário?

Use quando um `TComponent` mantém referência non-owning para outro `TComponent` que pode ser destruído antes. Não use mecanicamente em toda referência.

### Helper method ou nova classe?

Extraia método quando responsabilidade local é separável. Crie classe/interface somente quando existe estado/contrato/consumidor que justifique a abstração.

## Common Rationalizations

| Racionalização | Realidade |
|---|---|
| “Se compila, lifetime está certo.” | Compiler não prova ordem de destruição nem dangling references. |
| “Owner e Parent são equivalentes.” | São relações diferentes em FMX. |
| “Mudar GUID força todo mundo a atualizar.” | Também quebra identidade do contrato; só com breaking change explícito. |
| “BOM é detalhe editorial.” | É gate do projeto para `.pas` alterado. |
| “Vou usar record para cair de 7 para 1 parâmetro.” | Métrica não justifica abstração sem semântica real. |
| “A interface cuida do lifetime automaticamente.” | Só se a implementação/reference counting realmente tiver esse contrato. |
| “Esse callback dura só enquanto o controle existe.” | Closure pode capturar referências e alterar lifetime. |

## Red Flags

- cast de `Parent` sem prova estrutural;
- raw pointer/object reference armazenada após owner poder morrer;
- interface + raw object referindo mesmo instance sem análise;
- `FreeAndNil` em objeto owned externamente;
- handler interno substituindo evento público sem composição prevista;
- alteração de GUID não relacionada ao requisito;
- enum não qualificado em código novo;
- `.pas` alterado sem BOM;
- unit nova apenas para contornar Method Toxicity;
- claim de compatibilidade com versão Delphi não confirmada.

## Verification

- [ ] Compiler/feature assumptions estão confirmados ou preservam subset existente.
- [ ] `uses` está correto.
- [ ] Public types/Scoped Enums foram revisados.
- [ ] GUIDs/interfaces foram preservados ou mudança explícita documentada.
- [ ] Lifetime/ownership foi mapeado para referências relevantes.
- [ ] Events/callbacks foram analisados quando alterados.
- [ ] Exceptions/failure semantics não foram alteradas silenciosamente.
- [ ] Mudança é mínima e dentro do escopo.
- [ ] Todo `.pas` modificado possui BOM `EF BB BF`.
- [ ] Method Toxicity foi avaliada.
- [ ] Test/build/runtime evidence foi reportada sem falsas garantias.
