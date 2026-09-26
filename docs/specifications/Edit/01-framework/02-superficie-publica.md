# Owner FRM-PUBLIC — Superfície pública e contratos compartilhados

## Units públicas centrais

O framework concentra contratos compartilhados em:

- `Rick.UIBuilder.pas`: facade;
- `Rick.UIBuilder.Interfaces.pas`: interfaces públicas dos builders/handles;
- `Rick.UIBuilder.Types.pas`: records, enums, callbacks e constantes públicas;
- `Rick.UIBuilder.Factory.pas`: criação direta de controles.

**Evidência:** `src/Rick.UIBuilder.pas`, linhas 30–41; `src/Rick.UIBuilder.Interfaces.pas`, linhas 7–23; `src/Rick.UIBuilder.Factory.pas`, cabeçalho e interface.

## Interfaces

As interfaces de builders atuais são autocontidas e não usam herança entre interfaces.

**Evidência:** `src/Rick.UIBuilder.Interfaces.pas`, linhas 15–18.

## Regra para o futuro Edit

Se o Edit tiver API pública, a IA implementadora deve avaliar impacto em facade, interfaces, types e factory. A existência dessas quatro superfícies no framework não autoriza adicionar elementos em todas elas automaticamente.

A necessidade de cada contrato deve ser comprovada pelo contrato funcional do Edit.
