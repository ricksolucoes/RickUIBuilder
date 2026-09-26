---
name: component-maintenance
description: Guia análise e manutenção de qualquer componente ou domínio do RickUIBuilder sem impor arquitetura por simetria. Use ao alterar Label, Button, Badge, Divider, ComboBox, Factory, Composition, contratos compartilhados ou novos componentes.
---

# Component Maintenance

## Overview

Esta skill é o workflow genérico de domínio. Ela responde: **quais contratos, units, testes, docs e invariantes deste componente precisam ser compreendidos antes de mudar?**

Ela não prescreve Handle/State/Data/Presentation. Essas abstrações só existem quando a responsabilidade real justifica.

## When to Use

- qualquer alteração em componente existente;
- novo componente;
- mudança que cruza facade/factory/component;
- bug cujo root cause pode estar fora da unit inicialmente suspeita;
- documentação específica de componente;
- review de arquitetura por componente.

## Component Discovery Process

### Step 1 — Nomeie o domínio

Escolha entre:

- Facade/shared contracts;
- Factory;
- Label;
- Button;
- Badge;
- Divider;
- ComboBox;
- Composition;
- Sample/test infrastructure;
- novo domínio.

Se a tarefa atravessa dois domínios, identifique qual possui o comportamento e qual é consumidor.

### Step 2 — Consulte o Component Map

Abra `../../references/architecture-and-component-map.md` como índice, depois confirme os paths no repositório.

### Step 3 — Map public surface

Para o componente, localize:

- facade method;
- interface builder;
- interface handle;
- config record/enums/constants;
- overloads;
- events;
- Build/BuildHandle semantics.

Nem todo componente possui todos os itens.

### Step 4 — Map implementation responsibilities

Pergunte por cada unit:

- que responsabilidade possui?;
- que estado guarda?;
- quem chama?;
- quem ela chama?;
- possui FMX controls?;
- possui lifecycle responsibility?;
- é lógica pura?;
- existe razão real para estar separada?

### Step 5 — Map runtime lifecycle

Quando há Handle/Behavior/FMX:

```text
builder config
→ Build/BuildHandle
→ visual/materialization
→ runtime events/updates
→ parent/owner destruction
→ handle detach/destruction
```

Registre em que ponto cada referência deixa de ser válida.

### Step 6 — Map tests

Classifique testes existentes:

- chaining;
- config/defaults;
- pure logic;
- integration FMX;
- events;
- lifetime/detach;
- regressions;
- platform/presentation.

Identifique gaps relevantes para a mudança, não coverage genérica.

### Step 7 — Map docs/Sample

- existe `docs/<component>/`?;
- README principal possui exemplo?;
- Sample demonstra feature?;
- há known pitfalls documentados?

### Step 8 — Classify the change

#### Public surface

Ative `api-and-interface-design`.

#### Visual/runtime FMX

Ative `fmx-ui-engineering`.

#### `.pas`

Ative `delphi-change-safety` e `method-toxicity`.

#### New behavior/bug

Ative TDD/debugging conforme caso.

#### Structural simplification

Somente com autorização: `code-simplification`.

### Step 9 — Preserve component-specific invariants

Exemplos atuais:

#### Button

- hover callbacks e visual behavior coexistem conforme contrato;
- Handle não deve inadvertidamente assumir ownership dos controles;
- behavior criado em Build precisa sobreviver conforme ownership projetado.

#### Badge

- preservar handle/runtime semantics existentes;
- não copiar HoverState do Button sem requisito.

#### Divider

- manter simplicidade; não criar runtime abstraction sem comportamento runtime necessário.

#### ComboBox

Consulte docs específicas. Entre invariantes conhecidos:

- ViewIndex e SourceIndex têm semânticas diferentes;
- filtro não remove/reordena source items;
- FullWindow reutiliza Data/Virtualizer;
- StyleType e PresentationMode são conceitos distintos;
- target de navegação não é seleção confirmada;
- owner/parent/presentation host têm papéis específicos.

### Step 10 — Choose architecture proportional to responsibility

Use esta matriz como pergunta, não template obrigatório:

| Necessidade | Abstração candidata |
|---|---|
| configuração fluente | builder |
| API runtime persistente | handle |
| estado independente do visual | state |
| transformação/modelo lógico | data/model |
| várias materializações visuais | presentation |
| lista grande/viewport | virtualization |
| lifecycle ligado a componente | behavior/notification |
| contrato cross-module | interface/type público |

A ausência de necessidade é uma decisão válida.

## New Component Workflow

Para componente novo:

1. confirme necessidade/contrato com spec;
2. encontre o componente **mais parecido em responsabilidade**, não o mais complexo;
3. reaproveite conventions do framework;
4. comece com menor arquitetura capaz de atender;
5. adicione Handle/State/etc. somente quando comportamento exige;
6. inclua facade/interface/type somente se fazem parte da superfície pública desejada;
7. escreva testes no nível correspondente;
8. crie docs profundas apenas se complexidade justificar.

## Cross-Component Changes

Se uma mudança em shared Types/Interfaces afeta vários componentes:

- trate o shared contract como domínio principal;
- identifique todos os implementadores/consumidores;
- não atualize apenas o componente que motivou a feature;
- valide Sample/docs relevantes;
- use review independente.

## Common Rationalizations

| Racionalização | Realidade |
|---|---|
| “Todos os componentes deveriam ter Handle.” | Handle existe para comportamento runtime real, não simetria. |
| “ComboBox já resolve algo parecido.” | Pode fornecer conceito, mas sua arquitetura é mais complexa que a maioria. |
| “Só vou mudar a builder unit.” | Runtime behavior pode viver em Handle/Factory/Behavior e testes. |
| “Factory é sempre o lugar de criar tudo.” | Confirme o design real do componente. |
| “Docs do ComboBox mostram o padrão geral.” | Mostram padrão documental profundo para um domínio específico. |

## Red Flags

- nova unit sem responsabilidade clara;
- interface nova com um único uso privado sem necessidade pública;
- Handle criado sem runtime API;
- Data/State criados apenas para reduzir tamanho de builder;
- change path ignora tests/handle auxiliares;
- copiar lifecycle de outro componente sem mapear owner/parent atuais;
- componente simples ganhando arquitetura em camadas sem requisito.

## Verification

- [ ] Domínio foi identificado.
- [ ] Public surface relevante foi mapeada.
- [ ] Implementation responsibilities foram entendidas.
- [ ] Lifetime foi mapeado quando aplicável.
- [ ] Testes existentes foram classificados.
- [ ] Docs/Sample relevantes foram localizados.
- [ ] Invariantes específicos foram identificados.
- [ ] Skills adicionais foram ativadas pelo tipo de mudança.
- [ ] Arquitetura proposta é proporcional à responsabilidade real.
