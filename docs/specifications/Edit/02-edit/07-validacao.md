# Owner EDIT-VALIDATION — Validação do Edit

**Origem:** `PEND-EDIT-004` — resolvida e migrada para este Owner normativo.

**Status documental:** `APROVADO`.

Este é o único Owner das regras de validação. Eventos/callbacks pertencem a `PEND-EDIT-005`; runtime pertence a `PEND-EDIT-006`.

## VAL-001 — Validator

O validator recebe o **texto efetivo depois da máscara/normalização**.

```pascal
TRickUIBuilderEditValidationResult = record
  IsValid: Boolean;
  ErrorText: string;
  class function Valid: TRickUIBuilderEditValidationResult; static;
  class function Invalid(
    const AErrorText: string
  ): TRickUIBuilderEditValidationResult; static;
end;

TRickUIBuilderEditValidator = reference to function(
  const AText: string
): TRickUIBuilderEditValidationResult;
```

O builder expõe `Validator(AValue: TRickUIBuilderEditValidator)`. Texto bruto anterior à política de input não é entregue ao validator.

## VAL-002 — Triggers

```pascal
TRickUIBuilderEditValidationTrigger = (OnChange, OnExit);
TRickUIBuilderEditValidationTriggers =
  set of TRickUIBuilderEditValidationTrigger;
```

São admitidos `[]`, `[OnChange]`, `[OnExit]` e `[OnChange, OnExit]`.

`[]` desabilita execução automática por mudança do usuário/saída de foco. `OnChange` observa o texto efetivo já consolidado; `OnExit` observa o texto efetivo consolidado na perda de foco. A ordem completa com callbacks é Owner de `PEND-EDIT-005`.

## VAL-003 — Origem automática

Resultado válido:

```text
ValidatorInvalid := False
ValidatorErrorText := ''
```

Resultado inválido:

```text
ValidatorInvalid := True
ValidatorErrorText := ValidationResult.ErrorText
```

O validator modifica somente a origem automática.

## VAL-004 — Origem manual

`ErrorText(...)` define `ManualErrorText`, mas sozinho não ativa `Invalid`.

`Invalid(True)` ativa `ManualInvalid`; `Invalid(False)` desativa somente essa origem.

Validator não modifica `ManualInvalid` nem apaga `ManualErrorText`.

## VAL-005 — Invalid efetivo

```text
InvalidEfetivo = ManualInvalid OR ValidatorInvalid
```

Validator válido não remove invalidade manual. `Invalid(False)` não remove invalidade automática.

## VAL-006 — Mensagem efetiva

Precedência:

```text
1. ManualInvalid=True e ManualErrorText não vazio -> ManualErrorText
2. ValidatorInvalid=True -> ValidatorErrorText
3. caso contrário -> nenhuma mensagem de erro ativa
```

Mensagem manual pode permanecer armazenada sem apresentação quando sua origem não estiver ativa. Se manual estiver ativo sem mensagem e automático também inválido, a mensagem automática pode ser apresentada. Nenhuma mensagem é fabricada.

## VAL-007 — Máscara não é validação

CPF, CNPJ, Phone, MobilePhone, Email e Website podem formatar/normalizar sem afirmar validade semântica. Estado intermediário incompleto permitido pela política de input não ativa `Invalid` por si só.

Invalidade decorre do validator ou da origem manual. Depende de `EDIT-INPUT`.

## VAL-008 — Requirement state

`RequirementSatisfied` é independente de `Invalid`. Validator não o altera e ele não participa de `InvalidEfetivo`.

## VAL-009 — Alteração programática

`Handle.SetText` passa pela política de input, mas não executa validator automaticamente. O contrato runtime completo permanece em `PEND-EDIT-006`.

## VAL-010 — Refresh visual

Após validação, `InvalidEfetivo` e mensagem efetiva são resolvidos antes do refresh visual. Presentation consome o estado; não redefine a precedência.

## Dependências

- `EDIT-INPUT`: texto efetivo.
- `EDIT-COMPOSITION`: apresentação de estado/mensagem.
- `PEND-EDIT-005`: eventos, callbacks e reentrada.
- `PEND-EDIT-006`: runtime.
- `PEND-EDIT-007`: defaults restantes.

## Critério de aceite

| Questão | Decisão |
|---|---|
| entrada | texto efetivo pós máscara/normalização |
| retorno | `IsValid` + `ErrorText` |
| triggers | `OnChange`, `OnExit`, ambos ou nenhum |
| manual/automático | origens independentes |
| `ErrorText(...)` | não ativa `Invalid` sozinho |
| invalidade efetiva | `ManualInvalid OR ValidatorInvalid` |
| mensagem manual | precede automática quando ativa e não vazia |
| validator válido | limpa somente origem automática |
| `RequirementSatisfied` | independente |
| `Handle.SetText` | não valida automaticamente |

Com estas regras, a validação está fechada sem absorver eventos, runtime ou defaults.
