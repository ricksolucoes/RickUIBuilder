---
name: fmx-ui-engineering
description: Guia alterações de interface e comportamento visual FireMonkey no RickUIBuilder. Use ao criar ou modificar visual tree, layout, interação, mouse/touch, focus, paths, scroll, hosting, estilos ou runtime rendering de componentes FMX.
---

# FMX UI Engineering

## Overview

FireMonkey combina visual tree, component ownership, layout automático, hit testing, foco e eventos. Uma mudança visual aparentemente simples pode criar regressão de lifetime, interação ou plataforma.

Esta skill trata UI como contrato observável, não apenas aparência.

## When to Use

- materializar/mover controles FMX;
- alterar `Parent`, `Align`, margins/padding;
- adicionar hit area/path/edit/layout;
- alterar mouse/touch/focus;
- criar overlay/full-window/host visual;
- alterar scroll/virtualization/rendering;
- adaptar desktop/mobile;
- custom rendering;
- comportamento visual stateful.

## Inputs

Antes de editar:

- visual tree atual;
- owner/parent de cada elemento relevante;
- comportamento de interação atual;
- testes de integração;
- Sample/docs quando existem;
- plataforma/presentation mode quando aplicável.

## Process

### Step 1 — Desenhe a visual tree atual

Use árvore textual:

```text
Host
└── Container
    ├── Visual child
    └── Interactive child
```

Marque:

- Owner;
- Parent;
- `Align`;
- `HitTest`;
- event owner;
- clip boundaries.

Sem isso, não mova controles entre containers.

### Step 2 — Separe visual de interação

Pergunte para cada objeto:

- ele só desenha?;
- recebe clique/touch?;
- recebe teclado/foco?;
- captura evento ou deixa passar?;

Exemplo de princípio: um `TPath` visual pode ter `HitTest=False` enquanto um layout maior fornece hit target acessível.

### Step 3 — Review layout contract

Analise:

- `Align`;
- position/size explícitos;
- margins/padding;
- `ClipChildren`;
- child order/z-order;
- width/height dinâmicos;
- parent resize;
- scroll viewport.

Não conserte clipping aumentando números arbitrariamente sem entender o layout.

### Step 4 — Review hosting

Distinga:

- logical anchor/parent;
- presentation host;
- form/root visual;
- overlay/full-window host.

Uma apresentação full-window pode precisar de host diferente do controle fechado. Essa decisão não deve ser deduzida apenas do parent imediato.

### Step 5 — Review events

Mapeie:

```text
FMX event
→ internal handler
→ public callback
→ state update
→ visual refresh
```

Evite sobrescrever callback do usuário quando o contrato exige coexistência.

### Step 6 — Review focus/editing

Para edits/focusable controls:

- focus effect é intencional?;
- background/frame vem do control ou container?;
- teclado mobile muda layout?;
- `HitTest` permite interação?;
- clipping não corta focus/placeholder?

### Step 7 — Desktop vs Mobile

Não suponha identidade. Verifique:

- touch target;
- full-window vs anchored;
- back/close semantics;
- viewport disponível;
- hover inexistente em touch;
- keyboard/focus.

Se comportamento diverge por style/presentation, preserve a resolução existente.

### Step 8 — Scroll and virtualization

Quando a lista é virtualizada:

- não rebuildar todos os rows sem necessidade;
- preserve mapping lógico/visual;
- viewport controla pool;
- scroll offset deve continuar coerente;
- custom rendering deve respeitar reset/bind/state lifecycle.

Para ComboBox, leia docs específicas antes de modificar virtualizer.

### Step 9 — Paths and vector data

`TPathData.Data` pode normalizar representação. Não assuma round-trip textual.

Para testes/identidade semântica:

- parse expected;
- compare representação normalizada ou comportamento visual apropriado;
- não use raw input string como identidade quando API não garante isso.

### Step 10 — Build smallest visual change

Evite reconstruir toda árvore para alterar um detalhe quando um update localizado mantém estado/lifetime melhor.

Mas não force update incremental quando a arquitetura existente define reconstrução como contrato. Leia o componente.

### Step 11 — Verify structurally and at runtime

Automated integration pode verificar:

- type;
- Parent;
- visibility;
- HitTest;
- event invocation;
- dimensions/config;
- detach/lifetime.

Runtime/manual é necessário quando a propriedade visual relevante não é capturada adequadamente pelo teste estrutural.

Leia `references/fmx-visual-contracts.md` para checklist de alta complexidade.

## Interaction Decision Table

| Elemento | Visual | Hit target | Focus | Regra típica |
|---|---|---|---|---|
| `TPath` icon | sim | geralmente não | não | container recebe clique |
| `TEdit` | sim/input | sim | sim | não bloquear edição com overlay |
| `TRectangle` button-like | sim | sim | depende | preservar public OnClick |
| `TLayout` hit area | não/estrutura | sim | geralmente não | target maior que icon |
| `TVertScrollBox` | container | scroll | pode | children precisam respeitar viewport |

A tabela é heurística, não contrato universal.

## Common Rationalizations

| Racionalização | Realidade |
|---|---|
| “Visualmente parece certo no Sample.” | Ainda pode haver lifetime/HitTest/layout regression. |
| “Parent é o host natural.” | Overlay/full-window pode exigir outro visual root. |
| “O path recebe click.” | Ícone pequeno pode ser visual-only e ter hit area separada. |
| “Desktop funcionou, mobile também.” | Hover, touch, teclado e presentation podem divergir. |
| “Vou rebuildar tudo; é mais simples.” | Pode perder state, selection, scroll e eventos. |
| “String do SVG é igual à Data.” | FMX pode normalizar a representação. |

## Red Flags

- `HitTest=True` em ícone quando existe hit area prevista;
- control interativo coberto por layout overlay;
- parentagem alterada sem mapear ownership;
- full-window adicionado dentro de scroll content por conveniência;
- hover usado como único feedback mobile;
- rebuild de lista inteira em cada keystroke sem análise;
- comparação textual de path normalizado;
- event handler público substituído silenciosamente.

## Verification

- [ ] Visual tree antes/depois está compreendida.
- [ ] Owner e Parent estão corretos.
- [ ] Layout/clipping/z-order foram revisados.
- [ ] Hit testing/focus/event flow foram revisados.
- [ ] Desktop/mobile foram considerados quando aplicável.
- [ ] Scroll/virtualization state foi preservado quando aplicável.
- [ ] Tests verificam estrutura/comportamento relevante.
- [ ] Runtime/manual foi realizado ou explicitamente marcado não executado quando necessário.
