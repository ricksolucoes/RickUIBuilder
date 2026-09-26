# Owner EDIT-RUNTIME — Runtime, Handle e lifetime do Edit

**Origem:** `PEND-EDIT-006`.

**Status documental:** `APROVADO`.

Este é o único Owner do contrato runtime pós-materialização, da semântica attached/detached do Handle e das garantias de lifetime associadas.

## RUN-001 — Contrato público

O Handle não expõe controles FMX internos.

```pascal
IRickUIBuilderEditHandle = interface
  function IsAttached: Boolean;
  function Text: string;
  procedure SetText(const AValue: string);
  procedure SetInvalid(AValue: Boolean);
  procedure SetErrorText(const AValue: string);
  procedure SetEnabled(AValue: Boolean);
  procedure SetReadOnly(AValue: Boolean);
  procedure SetFocus;
end;
```

O GUID público real será gerado uma vez na implementação e preservado após publicação; nenhum GUID é inventado nesta especificação.

## RUN-002 — BuildHandle e attached

`BuildHandle(AParent)` materializa o Edit e retorna seu Handle. Enquanto a árvore estiver viva e vinculada, `IsAttached=True`.

Configuração fluente anterior à materialização pertence ao snapshot do builder; mutações posteriores previstas no contrato pertencem ao Handle.

## RUN-003 — Text

Attached: `Text` retorna o texto efetivo atual.

Detached: `Text` retorna o último texto lógico conhecido pelo Handle.

## RUN-004 — SetText attached

`SetText` aplica a política de input/normalização/máscara, atualiza texto lógico, snapshot lógico do Handle e visual.

Não dispara `OnChange`, não executa validator automaticamente, não substitui `EntrySnapshot` de sessão ativa e não reconstrói a árvore.

## RUN-005 — SetInvalid / SetErrorText

Attached, `SetInvalid` altera a origem manual de invalidade e `SetErrorText` altera `ManualErrorText`; ambos sincronizam o visual.

`SetErrorText` sozinho não ativa `Invalid`. A precedência de validação permanece em `EDIT-VALIDATION`.

## RUN-006 — SetEnabled / SetReadOnly

Attached, atualizam estado lógico e controle editável correspondente, sem rebuild. Não recebem efeitos colaterais adicionais de eventos/validação.

## RUN-007 — SetFocus

Attached, solicita foco ao `TEdit` interno. Quando o foco for efetivamente recebido, `OnEnter` e `EntrySnapshot` seguem `EDIT-EVENTS`.

## RUN-008 — Detach

Quando a árvore visual for destruída, `IsAttached=False`.

Referências visuais do Handle são non-owning e devem ser invalidadas antes de reutilização. O Handle preserva o último snapshot lógico necessário ao contrato detached.

## RUN-009 — Operações detached

```text
Text         -> último texto lógico conhecido
SetText      -> no-op seguro
SetInvalid   -> no-op seguro
SetErrorText -> no-op seguro
SetEnabled   -> no-op seguro
SetReadOnly  -> no-op seguro
SetFocus     -> no-op seguro
```

Nenhuma operação detached acessa controle destruído, recria implicitamente o Edit ou volta `IsAttached` para `True`.

## RUN-010 — Ownership

O Handle não possui a árvore visual. Owner/Parent FMX governam os controles; referências visuais do Handle são non-owning. Destruição do root deve resultar em detach seguro.

## RUN-011 — Build sem Handle externo

`Build(AParent)` continua funcional mesmo sem o consumidor reter um Handle.

Se comportamento interno depender de objeto com reference counting, sua vida necessária deve ser mantida sem ciclo permanente. A solução concreta deve ser mínima e não precisa copiar outro componente.

## RUN-012 — Destruição e ciclos

A implementação deve considerar root, Parent, callbacks, anonymous methods, referências fortes e mecanismo de notificação/detach quando necessário.

A estratégia concreta é detalhe interno, desde que preserve detach seguro e não mantenha a árvore artificialmente viva por ciclo de referências.

## RUN-013 — Limites de garantia

O contrato não afirma ausência de leak sem teste real, thread safety, reattach/rebuild pelo Handle, acesso aos controles FMX, validação automática em `SetText` ou `OnChange` programático.

## Dependências

- `EDIT-PUBLIC`: `BuildHandle` e superfície pública.
- `EDIT-COMPOSITION`: árvore visual.
- `EDIT-INPUT`: política de `SetText`.
- `EDIT-VALIDATION`: invalidade/mensagem manual.
- `EDIT-EVENTS`: efeitos de `SetText`/`SetFocus`.
- `PEND-EDIT-007`: defaults restantes.

## Critério de aceite

| Questão | Decisão |
|---|---|
| controles FMX no Handle | não expostos |
| attached | árvore viva/vinculada |
| `Text` attached | texto efetivo atual |
| `SetText` | normaliza/mascara e sincroniza, sem callback/validator automático |
| setters de estado | atualizam lógico/visual sem rebuild |
| detach | destruição da árvore torna `IsAttached=False` |
| `Text` detached | último texto lógico |
| setters detached | no-op seguro |
| rebuild implícito | proibido |
| refs visuais | non-owning |
| `Build` sem Handle retido | funcional |

Com estas regras, `PEND-EDIT-006` está fechada sem absorver defaults.
