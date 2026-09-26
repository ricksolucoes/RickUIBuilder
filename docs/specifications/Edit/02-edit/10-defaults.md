# Owner EDIT-DEFAULTS — Defaults visuais e funcionais do Edit

**Origem:** `PEND-EDIT-007`.

**Status documental:** `APROVADO`.

Este é o único Owner dos valores default do `TRickUIBuilderEditConfig.Default`. Os demais Owners continuam responsáveis pela semântica dos recursos aos quais estes valores se aplicam.

## DEF-001 — Snapshot default

`TRickUIBuilderEditConfig.Default` constrói todos os subrecords por seus respectivos `Default`, produzindo configuração completa e determinística por valor.

Quando existir setter fluente equivalente, o setter chamado depois de `Edit(AConfig)` prevalece sobre o snapshot inicial.

`Text` e `LabelText` permanecem estado/conteúdo do builder e não são duplicados na configuração.

## DEF-002 — Geometria

| Configuração | Default |
|---|---|
| `Left` / `Top` | `0` |
| `Width` | `240` |
| `Height` | `56` |
| `CornerRadius` | `8` |
| `BorderThickness` | `1` |
| `Padding` | `TRickUIBuilderSpacing.Create(12, 8, 12, 8)` |
| `AssistiveSpacing` | `6` |

A ordem do `TRickUIBuilderSpacing.Create` é esquerda, topo, direita e base.

## DEF-003 — Tipografia

| Configuração | Default |
|---|---|
| `FontFamily` | `''` |
| `TextFontSize` | `16` |
| `LabelFontSize` | `12` |
| `PlaceholderFontSize` | `16` |
| `AssistiveFontSize` | `12` |
| `FontStyle` | `[]` |

`FontFamily=''` não força família nominal; a fonte efetiva é resolvida pelo FMX/plataforma.

## DEF-004 — Input

| Configuração | Default |
|---|---|
| `MaxLength` | `0` |
| `KeyboardType` | `TVirtualKeyboardType.Default` |
| `ReturnKeyType` | `TReturnKeyType.Default` |
| `Password` | `False` |
| `InputMask` | `None` |
| `AllowNegative` | `False` |
| `DecimalSeparatorMode` | `Locale` |
| `CustomDecimalSeparator` | `#0` |
| `TextConversion` | `None` |
| `PunctuationPolicy` | `Keep` |
| `NumberFormat` | `National` |
| `WebsiteCaseMode` | `LowercaseHost` |
| `Country` | `'BR'` |

`MaxLength=0` significa ausência de limite adicional do RickUIBuilder; limites inerentes à máscara continuam aplicáveis.

## DEF-005 — Comportamento

| Configuração | Default |
|---|---|
| `Enabled` | `True` |
| `ReadOnly` | `False` |
| `ValidationTriggers` | `[]` |
| `ShowRevertAction` | `True` |
| `ShowPasswordAction` | `True` |
| `ShowErrorIcon` | `True` |
| `ShowRequirementState` | `False` |
| `RequirementSatisfied` | `False` |

`ShowPasswordAction=True` só torna a action aplicável quando `Password=True`.

`ShowRevertAction=True` só torna a action aplicável durante sessão de edição válida, com snapshot disponível, texto diferente do snapshot, campo enabled e não read-only.

## DEF-006 — Conteúdo

| Configuração | Default |
|---|---|
| `Placeholder` | vazio |
| `HelperText` | vazio |
| `ErrorText` | vazio |

Mensagem default vazia não cria erro por si só.

## DEF-007 — Tamanho e cores de ícones/actions

| Configuração | Default |
|---|---|
| `IconSize` | `20` |
| `ActionColor` | `#57606A` |
| `ErrorColor` | `#CF222E` |
| `RequirementValidColor` | `#1A7F37` |
| `RequirementInvalidColor` | `#CF222E` |

`IconSize=20` define o desenho visual, não obriga a hit area a ter 20.

## DEF-008 — Assets default

| Finalidade | Asset |
|---|---|
| Revert | `cancel_62dp_E3E3E3_FILL0_wght400_GRAD0_opsz48.svg` |
| Error | `check_alert_62dp_E3E3E3_FILL0_wght400_GRAD0_opsz48.svg` |
| Show password | `visibility_62dp_E3E3E3_FILL0_wght400_GRAD0_opsz48.svg` |
| Hide password | `visibility_off_62dp_E3E3E3_FILL0_wght400_GRAD0_opsz48.svg` |
| Requirement valid | `task_alt_62dp_E3E3E3_FILL0_wght400_GRAD0_opsz48.svg` |
| Requirement invalid | `unpublished_62dp_E3E3E3_FILL0_wght400_GRAD0_opsz48.svg` |

Os paths são substituíveis pela configuração pública correspondente.

## DEF-009 — Estados visuais

| Estado | BackgroundColor | BorderColor | TextColor | LabelColor | PlaceholderColor | AssistiveTextColor |
|---|---|---|---|---|---|---|
| `Normal` | `#FFFFFF` | `#8C959F` | `#1F2328` | `#57606A` | `#6E7781` | `#57606A` |
| `Focused` | `#FFFFFF` | `#0969DA` | `#1F2328` | `#0969DA` | `#6E7781` | `#57606A` |
| `Invalid` | `#FFF8F7` | `#CF222E` | `#1F2328` | `#CF222E` | `#6E7781` | `#CF222E` |
| `Disabled` | `#F6F8FA` | `#D0D7DE` | `#8C959F` | `#8C959F` | `#8C959F` | `#8C959F` |
| `ReadOnly` | `#FFFFFF` | `#8C959F` | `#1F2328` | `#57606A` | `#6E7781` | `#57606A` |

A paleta default é destinada a fundo claro. O consumidor não precisa fornecer `StyleLookup` para obter o design default.

Todas as cores normativas possuem representação configurável em `VisualStates` ou `Icons`.

## DEF-010 — Precedência visual

A seleção do estado visual segue:

```text
Disabled > Invalid > ReadOnly > Focused > Normal
```

Essa precedência é visual e não redefine a semântica comportamental dos estados.

## DEF-011 — Configuração por record

Neste release, opções sem setter declarado em `IRickUIBuilderEdit` são configuradas por `TRickUIBuilderEditConfig`, incluindo políticas de input e configurações visuais, tipográficas, geométricas e de ícones.

A ausência de setter fluente não remove a capacidade de configuração.

## Dependências

- `EDIT-PUBLIC`: configuração e setters públicos.
- `EDIT-INPUT`: significado dos defaults de input.
- `EDIT-VALIDATION`: triggers/invalidade.
- `EDIT-EVENTS`: sessão usada por Revert.
- `EDIT-RUNTIME`: mutações pós-Build.
- `EDIT-COMPOSITION`: consumo dos defaults visuais.

## Critério de aceite

`TRickUIBuilderEditConfig.Default` deve produzir exatamente os valores documentados neste Owner, e customizações públicas devem poder substituir os tokens configuráveis correspondentes.

Com estas regras, `PEND-EDIT-007` está fechada.
