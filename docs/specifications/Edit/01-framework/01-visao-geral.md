# Owner FRM-OVERVIEW — Visão geral do RickUIBuilder

## Fato confirmado

O RickUIBuilder é uma biblioteca FireMonkey cujo ponto público principal é `TRickUIBuilder`.

A facade atual expõe três formas de criação:

- Factory;
- Fluent Builders;
- Composition.

**Evidência:** `src/Rick.UIBuilder.pas`, linhas 9–22 e 51–132.

## Componentes públicos atuais

A facade expõe builders para:

- Label;
- Button;
- Badge;
- Divider;
- ComboBox.

**Evidência:** `src/Rick.UIBuilder.pas`, linhas 55–105.

Não existe entry point `Edit` no snapshot analisado.

**Evidência:** `src/Rick.UIBuilder.pas`, linhas 55–132; package `RickUIBuilder.dpk`, bloco `contains`.

## Consequência documental para o Edit

O Edit é um **novo domínio** no snapshot analisado. A futura implementação não deve ser tratada como simples alteração de um componente já existente.

Isso não determina, por si só, quantas units o Edit terá.
