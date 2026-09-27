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

The component supports max length, a single-line `current/max` counter, clear, password visibility toggle, normal/focus/invalid states, configurable invalid feedback, and optional requirement-state indication. Clear becomes visible when text exists and shares the right-side action area with the other enabled indicators.

The internal `TEdit` uses a transparent background by default. `EditBackgroundColor` configures its own background independently from the container background, borders, focus/invalid colors, and corner radius.

`SetInvalid` controls invalid state. `SetRequirementMet` controls the requirement indicator explicitly; the component does not invent semantic validation rules.

## TPath and lifetime

Alert, clear, password visibility, and requirement icons use configurable `TPath` data and are laid out in the right-side action area. `IconColor` sets all icon colors together; `AlertIconColor`, `ClearIconColor`, `PasswordIconColor`, and `RequirementIconColor` can override them individually. Runtime behavior is owned by `AParent`; the returned handle is non-owning with respect to FMX controls and must not be used after its Parent is destroyed.
