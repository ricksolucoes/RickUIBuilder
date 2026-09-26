---
name: context-engineering
description: Constrói o contexto técnico mínimo e suficiente para trabalhar com segurança no RickUIBuilder. Use antes de alterar código desconhecido, ao trocar de domínio, ao investigar comportamento sistêmico ou quando arquivos, contratos, testes e documentação relevantes ainda não foram mapeados.
---

# Context Engineering

## Overview

A qualidade da implementação depende do contexto carregado. Esta skill impede que o agente inferira a arquitetura a partir do primeiro arquivo encontrado ou leia o repositório inteiro sem objetivo.

O resultado esperado é um **Context Map** pequeno, rastreável e suficiente para a decisão atual.

## When to Use

Use quando:

- começar tarefa em domínio ainda não analisado;
- trocar de componente durante a mesma sessão;
- comportamento atravessar múltiplas units;
- houver API pública/shared Types/Interfaces;
- houver divergência entre código, testes e docs;
- uma investigação anterior mostrou que a causa não está no arquivo inicialmente suspeito.

**Não use para repetir leitura já completa e ainda válida apenas por ritual.**

## Context Map

Construa conceitualmente:

```text
Task
├── Requirement
├── Target domain/component
├── Public entry points
├── Internal implementation
├── Shared contracts
├── Consumers
├── Tests
├── Sample
├── Documentation
├── Build/project files
├── Platform/compiler constraints
├── Known invariants
└── Unknowns
```

## Process

### Step 1 — Fixe o objetivo

Reescreva a tarefa em uma frase operacional:

> Alterar X para produzir Y, preservando Z.

Se não for possível preencher `X/Y/Z` sem inventar, marque a lacuna antes de seguir.

### Step 2 — Identifique domínio e boundaries

Use `architecture-and-component-map.md` como índice, depois confirme no código.

Pergunte:

- qual componente é alvo?;
- existe entry point na facade?;
- há interface/type público?;
- há unit auxiliar?;
- há Factory/Composition envolvida?;
- há docs específicas?;
- há Sample que demonstra o fluxo?

### Step 3 — Localize contratos públicos

Antes de implementation details, leia o que consumidores enxergam:

- `Rick.UIBuilder.pas`;
- `Rick.UIBuilder.Interfaces.pas`;
- `Rick.UIBuilder.Types.pas`;
- builder/handle público relevante.

Não assuma que a implementation unit define sozinha o contrato.

### Step 4 — Localize implementation path

Siga chamadas e `uses` necessários para o comportamento, não todo o grafo do projeto.

Mapeie:

```text
entry point
→ builder/factory
→ helper/state/data/presentation/behavior
→ runtime event/handle
```

quando essas camadas existirem.

### Step 5 — Leia testes antes de decidir comportamento

Testes revelam:

- contratos já protegidos;
- edge cases;
- conventions de DUnitX;
- integração/lifetime;
- regressões históricas preservadas.

Não conclua que algo é irrelevante só porque não está documentado.

### Step 6 — Leia docs de domínio seletivamente

Se existir `docs/<component>/`, use README do domínio para escolher documentos necessários.

Para ComboBox, não leia 22 docs indiscriminadamente: selecione conforme a mudança.

### Step 7 — Verifique Sample quando apropriado

Use Sample para:

- compreender uso público;
- confirmar combinação de API;
- observar composição visual.

Não use Sample como prova única de correção.

### Step 8 — Identifique build/project constraints

Localize `.dproj`, `.dpk`, `.dpr`, search paths e platform configs quando a tarefa envolver compile/link/package.

Não infira versão exata de Delphi apenas por `Delphi.Personality`/ProjectVersion sem confirmação adicional.

### Step 9 — Registre invariantes

Exemplos de invariantes:

- handle não é owner;
- seleção confirmada é diferente de target de navegação;
- `Owner` deve permanecer o Parent informado;
- evento existente precisa coexistir com comportamento interno;
- fonte de dados não pode ser reordenada.

Invariante deve ser sustentada por código/teste/docs, não por preferência arquitetural.

### Step 10 — Liste unknowns

Classifique unknown:

- bloqueante para implementação;
- pode ser verificado por fonte oficial;
- pode ser resolvido por teste;
- não afeta decisão atual.

Só peça ao usuário o que realmente bloqueia.

## Context Budget

Pare de carregar arquivos quando já puder responder com evidência:

1. qual contrato muda?;
2. onde está implementado?;
3. quem consome?;
4. quais testes protegem?;
5. que docs precisam acompanhar?;
6. que risco de lifetime/API existe?

Ler mais depois disso precisa de hipótese específica.

## Conflict Resolution

### Código vs documentação

Código final é fonte primária de comportamento. Se docs divergem, não use docs para sobrescrever código silenciosamente; registre o drift.

### Código vs testes

Teste pode revelar contrato esperado. Se código e teste divergem, determine se é regressão, teste obsoleto ou ambiente incompleto antes de mudar qualquer um.

### Sample vs API

Se Sample usa API não encontrada no contrato, trate como inconsistência a investigar.

### Project files vs ambiente

Um `.dproj` pode conter packages/search paths específicos de outra máquina. Não declare dependência necessária apenas por presença em configuração herdada sem confirmar relevância.

## Context Hierarchy

Carregue contexto em camadas. Suba de nível somente quando a pergunta atual exigir.

### Level 1 — Project rules

- `AGENTS.md`;
- skill routing;
- project constraints;
- Definition of Done.

Essas regras moldam **como** trabalhar, não explicam o componente inteiro.

### Level 2 — Domain map and documentation

- architecture/component map;
- `docs/<component>/README` quando existe;
- ADRs relevantes.

Use para saber **onde** procurar e quais invariantes já estão documentadas.

### Level 3 — Public contracts

- facade;
- interfaces;
- types/configs;
- public builder/handle methods.

Esses arquivos definem a superfície que consumidores observam.

### Level 4 — Relevant implementation

Carregue somente units no path do comportamento atual. Siga calls/uses a partir do entry point.

### Level 5 — Tests and failure evidence

Para manutenção/debugging, failure output e testes frequentemente têm maior valor que mais código não relacionado.

## Context Packing Strategies

### Selective include

Prefira conjunto pequeno e explícito de arquivos que cobrem contrato → implementação → teste.

### Hierarchical summary

Quando domínio é grande, produza um mapa curto:

```text
Public entry → internal responsibility → test contract → docs
```

Use o resumo para decidir o próximo arquivo, não para substituir a fonte.

### Compare-passing-to-failing

Em debugging, carregue diferença entre cenário que passa e cenário que falha antes de adicionar mais arquivos ao contexto.

### Protect critical facts

Não descarte do contexto:

- requisito atual;
- non-goals;
- lifetime model;
- public contract;
- evidência de tentativa anterior;
- acceptance criteria.

Detalhes de implementação já resolvidos podem ser comprimidos primeiro.

## Context Budget Management

Quando o contexto cresce demais, corte nesta ordem:

1. exemplos irrelevantes;
2. código fora do call path;
3. docs genéricas já resumidas;
4. histórico de tentativa já consolidado no Attempt Log;
5. outputs longos já reduzidos a evidência específica.

Proteja até o final:

- task contract;
- current hypothesis;
- evidence que diferencia hipóteses;
- contracts/lifetime;
- verification status.

## Restartable Session Boundaries

Uma tarefa longa deve ser retomável em outra sessão sem reconstruir tudo por memória.

Antes de encerrar uma fase, preserve artefatos quando realmente necessários:

- spec/plano aprovado;
- Attempt Log;
- arquivos modificados;
- testes executados;
- findings pendentes;
- unknowns bloqueantes.

Não crie handoff artificial para tarefas curtas. Em tarefas longas, o objetivo é que a próxima sessão possa responder: **onde estamos, o que já foi provado e o que não deve ser repetido?**

## Inline Planning Pattern

Para uma tarefa pequena sem plano formal, ainda faça um micro-plano mental explícito:

```text
1. Ler contrato/teste relevante
2. Alterar X
3. Executar Y
4. Revisar Z
```

Isso é preferível a começar edição sem uma noção de causalidade.

## Anti-Patterns

- **Brain dump indiscriminado:** carregar todo `src/` e esperar que o modelo encontre o sinal.
- **First-file bias:** inferir arquitetura do primeiro arquivo encontrado.
- **Doc-only reasoning:** confiar em documentação sem conferir implementação.
- **Conversation-only context:** depender de memória da sessão quando artefatos existem no repositório.
- **Stale context:** continuar usando informação anterior depois que código relevante mudou.
- **Context churn:** reler os mesmos arquivos sem nova pergunta.

## Common Rationalizations

| Racionalização | Realidade |
|---|---|
| “É só uma unit.” | A unit pode depender de contratos públicos e lifecycle em outras units. |
| “Os testes dizem tudo.” | Testes são evidência, não prova de cobertura completa. |
| “Vou ler o projeto inteiro.” | Context excessivo dilui sinais; leia por hipótese/boundary. |
| “A documentação já explica.” | Documentação precisa ser confrontada com o código final. |
| “A versão de Delphi está óbvia no dproj.” | Metadados do projeto não são necessariamente confirmação suficiente da toolchain atual. |

## Red Flags

- implementação proposta após ler somente um arquivo;
- consumer/public interface não localizado em mudança pública;
- teste existente ignorado;
- docs especializadas não consultadas em domínio complexo;
- leitura de dezenas de arquivos sem pergunta clara;
- unknown material tratado como fato;
- comportamento inferido de um componente para outro.

## Verification

- [ ] Objetivo está definido sem requisito inventado.
- [ ] Domínio e boundaries foram identificados.
- [ ] Contratos públicos relevantes foram lidos.
- [ ] Implementation path relevante foi mapeado.
- [ ] Testes existentes foram localizados.
- [ ] Docs/Sample foram consultados quando úteis.
- [ ] Invariantes a preservar estão sustentadas por evidência.
- [ ] Unknowns materiais estão explícitos.
- [ ] Contexto é suficiente para escolher a próxima skill sem carregar o repositório inteiro.
