---
name: api-and-interface-design
description: Protege o contrato público do RickUIBuilder ao criar ou alterar facade, fluent builders, interfaces, handles, GUIDs, records, enums, overloads e defaults. Use sempre que consumidores externos puderem observar a mudança.
---

# API and Interface Design

## Overview

API pública é custo de compatibilidade. Uma vez observável por consumidores, até detalhes não intencionais podem se tornar dependências. O workflow é **contract-first**: defina semântica, compatibilidade e testes antes de encaixar implementação.

## When to Use

- `Rick.UIBuilder.pas`;
- `Rick.UIBuilder.Interfaces.pas`;
- `Rick.UIBuilder.Types.pas`;
- método fluent público;
- Handle público;
- overload/default novo;
- record/enum/config público;
- mudança em Build/BuildHandle semantics.

## Core Principles

### Hyrum's Law aplicado

Todo comportamento observável pode ter consumidor. Não mude silenciosamente:

- defaults;
- ordem de eventos;
- retorno/chaining;
- ownership observável;
- seleção inicial;
- tratamento de índice inválido;
- text/value semantics;
- exception behavior.

### Prefer addition over mutation

Quando o requisito permite e compatibilidade importa, prefira adicionar capacidade a redefinir semântica existente. Isso não significa manter APIs ruins indefinidamente; breaking change precisa ser explícito.

### One meaning per contract

Um método deve ter semântica previsível. Evite overloads cuja seleção depende de coerções/ambiguidade difíceis de ler.

## Process

### Step 1 — Inventory current contract

Localize:

- signature;
- GUID/interface;
- defaults;
- builder implementation;
- Handle implementation;
- tests;
- README/docs/Sample.

### Step 2 — Define consumer need

Escreva a necessidade do consumidor, não a implementação.

Exemplo:

> O consumidor precisa atualizar a cor da seta após Build.

Isso pode implicar Handle method; não implica automaticamente novo config record.

### Step 3 — Classify compatibility

#### Additive

Novo método/type sem alterar comportamento antigo.

#### Source-compatible behavior change

Código existente compila, mas comportamento muda. Ainda é risco alto.

#### Breaking

Consumer precisa mudar código ou contrato binário/semântico deixa de valer.

Não esconda categoria.

### Step 4 — Design signature

Avalie:

- naming consistente;
- parâmetro order;
- overload ambiguity;
- default values;
- fluent return type;
- nullable/empty semantics;
- invalid input semantics;
- exception behavior;
- runtime versus build-time configuration.

### Step 5 — Interfaces and GUIDs

Se adicionar membro a interface pública:

- identifique todos implementadores;
- identifique consumidores internos;
- preserve GUID salvo estratégia de versionamento explícita;
- analise impacto em compatibility do framework;
- adicione teste de contrato.

### Step 6 — Record/enum changes

Para config record:

- `Default` deve inicializar novo field;
- builder precisa aplicar novo field;
- Factory/runtime precisa consumir;
- docs precisam descrever;
- teste de default quando relevante.

Para enum:

- preserve member meanings;
- scoped use;
- `case` statements precisam tratar novo member;
- `Auto`/fallback semantics precisam ser explícitas quando existirem.

### Step 7 — Build vs runtime

Pergunte:

- é configuração antes de Build?;
- precisa mudar depois de Build?;
- Handle é o contrato correto?;
- modificar builder após Build deve afetar controle existente ou apenas próximo Build?

Não misture esses lifecycles silenciosamente.

### Step 8 — Contract tests first

Proteja:

- chaining;
- default;
- overload selecionado;
- value returned;
- runtime effect;
- invalid input;
- ownership/lifetime se observável.

### Step 9 — Implement internally

Somente depois do contrato estar claro, escolha implementação/cohesion adequada.

### Step 10 — Documentation and Sample

Atualize somente quando API final estabilizar. README mostra uso essencial; docs profundas explicam semantics/maintenance.

## Interface Design Questions

- Precisa interface pública ou method no builder já resolve?;
- O Handle já é o boundary runtime?;
- Nova interface tem mais de um consumidor/implementador provável?;
- Estamos expondo detalhe interno que impedirá refactor futuro?;
- O consumidor precisa do concrete FMX control ou só uma operação semântica?

## Overload Decision Guide

Use overload quando:

- mesma intenção;
- inputs alternativos claramente distinguíveis;
- semântica de retorno idêntica;
- resolução pelo compiler é clara.

Considere nome diferente quando overloads representam operações semanticamente diferentes.

## Additional Contract Principles

### Consistent failure semantics

Métodos semelhantes devem tratar input inválido de maneira consistente. Antes de introduzir exception, no-op ou fallback:

- veja como APIs irmãs tratam o mesmo tipo de erro;
- preserve comportamento existente quando não há requisito de mudança;
- documente comportamento público não óbvio;
- teste invalid input quando consumidor pode depender disso.

Não transforme erro de programação em silêncio apenas para deixar API “amigável”.

### Validate at boundaries

Valide no boundary que recebe informação externa/pública quando a validação faz parte do contrato. Não espalhe checks idênticos em múltiplas camadas.

Exemplos:

- índice recebido por Handle;
- config value público;
- path/string externo;
- callback opcional.

### Predictable naming

Use vocabulário já existente no framework:

- `Build` / `BuildHandle`;
- `ItemIndex` / `SelectedText` / `SelectedValue`;
- `FillColor`, `TextColor`, etc.

Não crie sinônimo novo para conceito existente (`CurrentIndex` versus `ItemIndex`) sem razão contratual.

### Input/output separation

Não exponha internal mutable state apenas para evitar método público. Prefira retorno/Handle que represente capacidade suportada.

### One-version mindset

Não adicione compat shims, aliases ou APIs duplicadas “por segurança” sem estratégia de depreciação solicitada. O framework deve ter um contrato atual claro.

## API Change Matrix

| Tipo de mudança | Risco | Ação mínima |
|---|---|---|
| Novo fluent setter aditivo | médio | chaining + config/default + docs |
| Novo Handle method | médio/alto | runtime semantics + lifetime + integration test |
| Novo enum member | médio | resolver/cases/defaults + tests |
| Alterar default | alto | behavioral compatibility + docs + tests |
| Alterar interface member | alto | implementers + GUID/compat strategy + tests |
| Renomear método público | breaking | autorização explícita + migration/docs |
| Mudar Build ownership | crítico | lifetime design + integration/destruction tests |

## Public Boundary Checklist

Antes de finalizar contract:

- nome é consistente?;
- tipo expressa semântica?;
- default preserva comportamento?;
- invalid input é previsível?;
- return/chaining é consistente?;
- runtime update ocorre imediatamente ou só no próximo Build?;
- consumidor precisa concrete FMX type?;
- API pode ser implementada sem vazar detail interno?;
- docs conseguem explicar o contrato sem conhecer implementação?

## Versioning and Deprecation

Não crie estratégia de depreciação sem demanda. Quando uma API precisa ser substituída:

1. identifique consumers;
2. defina janela/estratégia explicitamente;
3. prefira coexistência temporária somente se autorizada;
4. documente migration;
5. remova zombie API quando a migração for concluída, não indefinidamente.

## Common Rationalizations

| Racionalização | Realidade |
|---|---|
| “É só adicionar um método na interface.” | Interface pública afeta todos implementadores/consumidores e lifetime. |
| “Código antigo continua compilando, então é compatível.” | Behavioral compatibility também importa. |
| “Mudar o GUID resolve versionamento.” | GUID não é knob de build; é identidade contratual. |
| “Mais overloads são sempre mais ergonômicos.” | Ambiguidade e semantics sobrepostas pioram API. |
| “Depois atualizamos docs.” | API pública sem docs/testes vira contrato acidental. |

## Red Flags

- signature nasce da implementation convenience;
- default novo não aparece em `Default` record;
- enum novo não tratado por resolver/case;
- Handle ganha setter sem comportamento runtime testado;
- builder post-Build semantics mudam sem documentação;
- interface expõe concrete implementation desnecessariamente;
- GUID alterado sem breaking strategy.

## Verification

- [ ] Current contract foi inventariado.
- [ ] Need do consumidor está clara.
- [ ] Compatibilidade foi classificada.
- [ ] Signature/default/overload semantics são inequívocos.
- [ ] GUID/interface impact foi revisado.
- [ ] Build-time vs runtime semantics estão explícitas.
- [ ] Contract tests protegem a mudança.
- [ ] Implementação não vazou detalhe desnecessário.
- [ ] Docs/Sample foram revisados conforme impacto.
