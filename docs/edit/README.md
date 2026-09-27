# Runtime Edit

`Edit` is RickUIBuilder's single-line runtime text-input builder.

## Creation

```pascal
var
  LEdit: IRickUIBuilderEditHandle;
begin
  LEdit := TRickUIBuilder.Edit
    .LabelText('CPF')
    .Preset(TRickUIBuilderEditPreset.CPF)
    .ClearButton
    .MaxLength(14)
    .CharacterCounter
    .Build(Self);
end;
```

`Build` returns `IRickUIBuilderEditHandle`. FMX ownership remains attached to the supplied `AParent`.

## Input rules

The public presets cover CPF, alphanumeric CNPJ, CEP, email, URL, phone, mobile, integer, Float, text variants with/without accents and punctuation, and unrestricted input. Masked presets format typing and require pasted values to already match their mask structure.

CPF uses `000.000.000-00`; CEP uses `00000-000`; CNPJ uses `AA.AAA.AAA/AAAA-00`, with 12 alphanumeric `0-9`/`A-Z` positions and two final numeric positions. These rules validate format only, not check digits.

Phone supports `0000-0000` and `(00) 0000-0000`. Mobile supports `0 0000-0000` and `(00) 0 0000-0000`.

## Numbers and casing

Negative numbers are opt-in. Float input can use locale separators or custom decimal/thousand separators and a configured decimal-place limit. Email is always lowercased. URL casing can lowercase only scheme + host or the entire value.

## Runtime behavior

The component supports max length, a single-line `current/max` counter, clear, password visibility toggle, normal/focus/invalid states, configurable invalid feedback, and optional requirement-state indication.

`SetInvalid` controls invalid state. `SetRequirementMet` controls the requirement indicator explicitly; the component does not invent semantic validation rules.

## TPath and lifetime

Alert, clear, password visibility, and requirement icons use configurable `TPath` data. Runtime behavior is owned by `AParent`; the returned handle is non-owning with respect to FMX controls and must not be used after its Parent is destroyed.

## Operational sample

The project under `sample/` includes a dedicated runtime `Edit` section for visual and operational verification. It covers:

- masked CPF, alphanumeric CNPJ, and CEP;
- email, phone, and mobile phone;
- negative integer and `FloatNumber` in both `Locale` and `Custom` modes;
- every text preset;
- `Uppercase`, `Lowercase`, and both URL case modes;
- `MaxLength` with counter, clear, and password;
- all three invalid-feedback modes and invalid state controlled through the handle;
- requirement indicator controlled by the consumer;
- copy and paste scenarios with valid and invalid CPF input.

The clipboard bench uses `TEdit.SelectAll`, `CopyToClipboard`, and `PasteFromClipboard`. For the CPF target, `123.456.789-01` is the structurally valid paste example, while `12345678901` exercises rejection of unmasked paste.

The Sample complements automated tests with manual runtime verification; it does not replace DUnitX or Method Toxicity Metrics validation.
