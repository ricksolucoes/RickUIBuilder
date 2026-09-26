# Owner FRM-CONFIG — Configuração e defaults

## Padrão confirmado

O framework usa records públicos com método `Default` para configurações consumidas diretamente pela Factory.

`Rick.UIBuilder.Types.pas` contém, entre outros:

- `TRickUIBuilderTextConfig`;
- `TRickUIBuilderBadgeConfig`;
- `TRickUIBuilderButtonConfig`;
- `TRickUIBuilderDividerConfig`;
- `TRickUIBuilderComboBoxConfig`;
- `TRickUIBuilderSpacing`.

## Relação Builder → Config

Builders existentes podem partir dos defaults do record e aplicar overrides acumulados antes da materialização.

Exemplos: Label, Button, Badge, Divider e ComboBox.

## Regra para Edit

Se o Edit expuser record público de configuração:

- cada campo precisa de semântica única;
- cada campo precisa de default definido;
- o builder precisa ter regra explícita de precedência sobre o record quando ambos existirem;
- configuração de build-time e operação runtime não podem ser misturadas implicitamente.

Os campos e defaults específicos do Edit estão **Não confirmados** nas fontes permitidas.
