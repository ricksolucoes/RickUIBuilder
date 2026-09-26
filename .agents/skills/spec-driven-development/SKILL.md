---
name: spec-driven-development
description: Define mudanças significativas do RickUIBuilder antes da implementação. Use para novos componentes, novas capacidades públicas, mudanças arquiteturais ou alterações de comportamento com múltiplas decisões, quando requisitos e boundaries precisam ser estabilizados antes de escrever código.
---

# Spec-Driven Development

## Overview

Uma spec reduz retrabalho quando a decisão de **o que construir** ainda é maior que a decisão de **como codificar**. No RickUIBuilder, isso é especialmente importante para API pública, componentes novos e mudanças com lifetime/presentation/compatibilidade.

A spec não é burocracia para toda tarefa. É um contrato de decisão para mudanças que realmente possuem opções e boundaries.

## When to Use

Use para:

- novo componente público;
- nova família de métodos/handle;
- novo modo de apresentação;
- mudança cross-component;
- mudança de arquitetura/lifetime;
- mudança significativa com vários arquivos e trade-offs;
- requisito ainda amplo que precisa virar acceptance criteria.

## When NOT to Use

Não crie spec completa para:

- typo;
- documentação já claramente delimitada;
- missing `uses`;
- correção localizada com comportamento/contrato já explícitos;
- análise read-only;
- ajuste puramente mecânico sem decisão arquitetural.

Use `planning-and-task-breakdown` diretamente se o objetivo já está especificado.

## Process

### Step 1 — Descreva o problema, não a solução

Ruim:

> Criar uma interface nova para controlar X.

Melhor:

> O consumidor precisa alterar X em runtime sem reconstruir o componente.

Separar necessidade de solução evita abstração prematura.

### Step 2 — Capture comportamento atual

Documente somente o necessário:

- entry point atual;
- public contract;
- comportamento observável;
- limitações comprovadas;
- testes existentes;
- constraints de lifetime/plataforma.

### Step 3 — Declare objetivo e non-goals

A spec precisa responder:

- o que estará diferente?;
- o que explicitamente não muda?;
- que comportamento deve permanecer idêntico?;
- qual superfície é fora do escopo?

### Step 4 — Defina public contract antes da implementação

Se houver API pública, descreva:

- método/interface/type proposto;
- input/output;
- defaults;
- errors/exceptions observáveis;
- chaining/runtime semantics;
- compatibilidade.

Não esconda breaking change em detalhe interno.

### Step 5 — Defina architecture boundaries

Para cada responsabilidade nova:

- onde pertence?;
- por que não cabe na unidade existente?;
- precisa nova interface?;
- precisa estado independente?;
- precisa Handle?;
- precisa Factory?;
- precisa Presentation/Data/etc.?

A resposta pode ser “não”.

### Step 6 — Defina lifetime

Quando FMX/handles/interfaces estiverem envolvidos, a spec deve dizer:

- quem cria;
- quem possui;
- quem é parent;
- quem pode morrer primeiro;
- o que acontece após detach/destruction.

### Step 7 — Defina test strategy

Classifique:

- unit logic;
- integration FMX;
- characterization;
- regression;
- manual/runtime visual.

Não diga apenas “adicionar testes”.

### Step 8 — Defina documentation impact

Avalie:

- README;
- docs do componente;
- Sample;
- XMLDoc;
- ADR.

### Step 9 — Defina quality gates

Inclua quando aplicável:

- build;
- DUnitX;
- BOM;
- Method Toxicity;
- review independente;
- plataforma.

### Step 10 — Feche acceptance criteria

Cada critério deve ser observável/testável.

Ruim:

> Código deve ficar limpo.

Bom:

> `BuildHandle` deve permitir alterar `X` após build sem reconstruir o visual tree e sem alterar ownership do controle.

## Decision Record Inside the Spec

Quando houver mais de uma opção, registre de forma curta:

| Opção | Benefício | Custo/risco | Decisão |
|---|---|---|---|
| | | | |

Use ADR separado somente para decisão arquitetural duradoura além da feature.

## Brownfield Specifics

- não redefina comportamento que já existe sem requisito explícito;
- use testes como evidência de contratos atuais;
- declare migração quando consumidor existente é impactado;
- evite “limpar” inconsistências adjacentes como parte da spec;
- novo componente deve integrar padrões do framework sem copiar camadas desnecessárias.

## Common Rationalizations

| Racionalização | Realidade |
|---|---|
| “O código vai esclarecer a API depois.” | Em API pública, implementar antes do contrato aumenta retrabalho/compatibilidade. |
| “Novo componente é parecido com Button.” | Similaridade visual não prova lifecycle/API idênticos. |
| “Spec precisa descrever todas as classes.” | Spec define comportamento e boundaries, não implementação linha a linha. |
| “É só uma feature.” | Se há múltiplas decisões públicas/arquiteturais, spec é justamente o artefato para isso. |
| “Vamos decidir testes depois.” | Testability influencia boundaries e acceptance criteria. |

## Red Flags

- spec descreve classes antes de explicar problema;
- non-goals ausentes em mudança ampla;
- API pública indefinida;
- lifetime deixado para implementação;
- “adicionar testes” sem estratégia;
- acceptance criteria subjetivos;
- componente novo herdando todas as camadas do ComboBox por padrão.

## Verification

- [ ] Problema e objetivo estão separados da solução.
- [ ] Estado atual relevante está sustentado por evidência.
- [ ] In-scope e out-of-scope estão claros.
- [ ] Public contract está definido quando aplicável.
- [ ] Architecture/lifetime boundaries estão claros.
- [ ] Test strategy é específica.
- [ ] Documentation impact foi avaliado.
- [ ] Acceptance criteria são verificáveis.
- [ ] A spec não inventa comportamento futuro além do requisito.
