# Owner EDIT-EVENTS — Eventos do Edit

**Origem:** `PEND-EDIT-005`.

**Status documental:** `APROVADO`.

Este documento é o único Owner da semântica dos eventos públicos do Edit, da ordem dos callbacks, da sessão de edição associada ao foco e da proteção contra reentrada.

Validação permanece em `EDIT-VALIDATION`; transformação do texto permanece em `EDIT-INPUT`; operações runtime completas permanecem dependentes de `PEND-EDIT-006`.

## EVT-001 — Eventos públicos

O Edit expõe exatamente:

```text
OnChange
OnEnter
OnExit
```

A superfície pública usa `TNotifyEvent`:

```pascal
function OnChange(AValue: TNotifyEvent): IRickUIBuilderEdit;
function OnEnter(AValue: TNotifyEvent): IRickUIBuilderEdit;
function OnExit(AValue: TNotifyEvent): IRickUIBuilderEdit;
```

Handlers internos não substituem nem eliminam silenciosamente callbacks registrados pelo consumidor.

## EVT-002 — OnChange

`OnChange` público representa uma alteração originada pelo usuário que resulte em mudança do texto efetivo.

```text
entrada do usuário
→ política de input
→ máscara/normalização
→ atualização do texto lógico efetivo
→ validator, se OnChange estiver em ValidationTriggers
→ atualização visual
→ callback público OnChange
```

O callback observa o texto efetivo já processado.

Se a tentativa for filtrada/rejeitada e o texto efetivo não mudar, não há `OnChange` público. Uma mudança efetiva do usuário produz no máximo um callback público `OnChange`, mesmo quando a implementação reatribuir internamente `TEdit.Text`.

## EVT-003 — OnEnter e início da sessão

Ao receber foco:

```text
consolidar texto efetivo atual
→ EntrySnapshot := Text
→ EntrySnapshotAvailable := True
→ atualizar foco/apresentação
→ callback público OnEnter
```

`EntrySnapshot` é a referência da action Revert durante a sessão e permanece imutável até `OnExit`, inclusive diante de `Handle.SetText`.

Novo snapshot somente é capturado em novo `OnEnter`.

## EVT-004 — OnExit e encerramento da sessão

Na perda de foco:

```text
consolidar estado lógico
→ validator, se OnExit estiver em ValidationTriggers
→ atualização visual
→ callback público OnExit
→ encerrar sessão
→ EntrySnapshotAvailable := False
```

Depois disso, Revert permanece indisponível até novo `OnEnter`.

## EVT-005 — Alterações programáticas

`Handle.SetText`:

- passa pela política de input;
- atualiza texto lógico/visual conforme o contrato runtime;
- não dispara `OnChange` público;
- não executa validator automaticamente;
- não substitui `EntrySnapshot` de uma sessão ativa.

O restante do contrato runtime pertence a `PEND-EDIT-006`.

## EVT-006 — Proteção contra reentrada

Alterações internas em `TEdit.Text` por máscara, normalização, sincronização visual ou Handle não podem retornar ao pipeline como nova edição do usuário.

Quando a API FMX utilizada puder reemitir a alteração, a implementação deve possuir proteção explícita contra reentrada.

Propriedades observáveis:

```text
mudança efetiva do usuário → no máximo um OnChange público
mudança interna/programática → nenhum OnChange público
```

A técnica interna da guarda não faz parte da API pública.

## EVT-007 — Relação com validação

Com trigger `OnChange`, o validator executa antes do refresh visual e do callback público `OnChange`.

Com trigger `OnExit`, o validator executa antes do refresh visual e do callback público `OnExit`.

As regras internas de invalidade/mensagem permanecem exclusivamente em `EDIT-VALIDATION`.

## EVT-008 — Callback público x evento FMX

Os callbacks públicos são contrato do RickUIBuilder, não exposição direta dos handlers internos do `TEdit`.

A implementação pode usar os eventos FMX necessários para detectar mudança/foco, desde que preserve a semântica e a cardinalidade deste Owner. `OnChangeTracking`, se usado internamente, não passa a integrar a API pública.

## Dependências

- `EDIT-INPUT`: transformação e texto efetivo.
- `EDIT-VALIDATION`: triggers e estado de validação.
- `EDIT-COMPOSITION`: controle editável e apresentação.
- `PEND-EDIT-006`: contrato runtime completo.
- `PEND-EDIT-007`: defaults restantes.

## Critério de aceite

| Questão | Decisão |
|---|---|
| eventos públicos | `OnChange`, `OnEnter`, `OnExit` |
| tipo | `TNotifyEvent` |
| `OnChange` | somente após mudança efetiva do usuário |
| texto observado | texto efetivo pós input/máscara/normalização |
| validator | antes do visual/callback quando trigger aplicável |
| `OnEnter` | inicia sessão e captura `EntrySnapshot` |
| snapshot | imutável até `OnExit` |
| `OnExit` | consolida, valida quando aplicável, atualiza visual, chama callback e encerra sessão |
| `Handle.SetText` | não dispara `OnChange` nem validator automaticamente |
| reentrada | alteração interna não retorna como edição do usuário |
| cardinalidade | no máximo um `OnChange` por mudança efetiva do usuário |

Com estas regras, `PEND-EDIT-005` está fechada sem absorver runtime completo ou defaults.
