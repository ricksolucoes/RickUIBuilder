# Owner EDIT-INPUT — Entrada e transformação do Edit

**Origem:** `PEND-EDIT-003` — resolvida e migrada para este Owner normativo.

**Status documental:** `APROVADO` para a decisão já fechada; dependências explicitamente indicadas no próprio contrato continuam nos respectivos Owners.

Esta pendência é o Owner de máscaras, admissão/rejeição de caracteres, transformação, `MaxLength`, paste/substituição, normalização, formatação e preservação lógica do caret. A política de input é independente da Presentation e o Edit é single-line.

### Pipeline geral

O contrato deve funcionar de forma consistente em digitação, paste, substituição de seleção, inserção no meio, backspace/delete, texto inicial e alteração programática. A implementação não pode assumir edição apenas no final.

Caracteres incompatíveis não podem permanecer no texto efetivo. Máscaras que reformatarem o conteúdo devem preservar a posição **lógica** do caret.

`None` significa ausência de máscara adicional; `MaxLength` e os demais contratos do Edit continuam aplicáveis.

### `MaxLength`

`MaxLength` limita o **conteúdo lógico não formatado**. Caracteres de apresentação inseridos por CPF, CNPJ ou telefone não contam.

`MaxLength <= 0` significa ausência de limite adicional. Havendo limite estrutural:

```text
LimiteEfetivo = Min(MaxLength, LimiteEstrutural)
```

Limites conhecidos:

```text
CPF         = 11 dígitos lógicos
CNPJ        = 14 dígitos lógicos
Phone BR    = 10 dígitos nacionais
Mobile BR   = 11 dígitos nacionais
```

No formato internacional brasileiro, `55` não consome o comprimento lógico nacional.

O limite é verificado depois das conversões/filtragens e antes do commit. Se o resultado exceder o limite, **a operação inteira é rejeitada**, preservando o texto anterior. Não há truncamento silencioso. Em substituição de seleção, calcula-se o texto final depois de remover a seleção e inserir integralmente o novo conteúdo.

### Caracteres incompatíveis

Na digitação unitária, caractere incompatível é rejeitado e não aparece.

Para inserção múltipla:

```text
A = filtrar incompatíveis e aceitar a parte válida
B = rejeitar a operação inteira se houver incompatível
```

Política fixa:

```text
TextAlphanumericPure       = B
TextAlphanumericWithSpaces = A
TextOnlyPure               = B
TextOnlyWithSpaces         = B
TextWithAccents            = A
TextWithPunctuation        = A
TextWithSpecialChars       = A
Email                      = A
Website                    = A
```

### `Numeric`

Aceita somente `0-9`. Em paste/substituição múltipla, incompatíveis são filtrados e os dígitos válidos permanecem, respeitando `MaxLength`.

### `Float`

Aceita dígitos e no máximo um separador decimal efetivo:

```text
Locale | Dot | Comma | Custom
```

`AllowNegative=False` não admite `-`. Com `True`, admite no máximo um `-`, exclusivamente na primeira posição lógica.

Um `CustomDecimalSeparator` utilizável não pode ser letra, dígito, sinal, whitespace ou controle. Se `Custom` não tiver separador utilizável, o campo aceita somente a parte inteira, sem fallback para locale e sem exception apenas por essa condição.

Não há parsing financeiro implícito.

### Classificação textual

O contrato público usa categorias observáveis:

- letras sem acento;
- letras com acento;
- números;
- espaço;
- pontuação;
- caracteres especiais.

Pontuação e caracteres especiais são capacidades distintas. A implementação interna pode usar Delphi/RTL, mas não pode ampliar silenciosamente o comportamento observável.

### `TextConversion`

`None` não converte.

`RemoveAccents` aplica, **antes da admissão da máscara**, somente este dicionário:

```text
À Á Â Ã Ä Å -> A       à á â ã ä å -> a
È É Ê Ë     -> E       è é ê ë     -> e
Ì Í Î Ï     -> I       ì í î ï     -> i
Ò Ó Ô Õ Ö   -> O       ò ó ô õ ö   -> o
Ù Ú Û Ü     -> U       ù ú û ü     -> u
Ý Ÿ         -> Y       ý ÿ         -> y
Ç -> C                  ç -> c
ñ -> N                  Ñ -> N
ø -> 0
æ -> ''
ß -> ''
```

`''` remove o caractere. As conversões especiais são literais: `ñ` não vira `n`, `ø` não vira `o`, e `æ`/`ß` não geram saída.

Caracteres fora do dicionário não recebem conversão automática. É proibido ampliar o catálogo por normalização de diacríticos, transliteração, aproximação fonética, locale, tabela do SO ou biblioteca externa.

### `PunctuationPolicy`

É independente de `TextConversion`:

```text
Keep   = preserva pontuação admitida
Remove = remove pontuação admitida
```

`Remove` não remove caracteres especiais por consequência.

Pipeline textual geral:

```text
entrada bruta
 -> TextConversion
 -> admissão pela InputMask + política A/B
 -> PunctuationPolicy
 -> MaxLength
 -> texto efetivo
```

### `Email`

Aceita somente:

```text
A-Z a-z 0-9 @ . _ - +
```

Filtra incompatíveis em inserção múltipla e normaliza todo conteúdo efetivo para lowercase.

A máscara não valida estrutura de e-mail. Essa responsabilidade pertence ao Validator. `TextConversion` e `PunctuationPolicy` genéricos não alteram a política especializada de Email.

### `Website`

Aceita somente:

```text
A-Z a-z 0-9 . - _ / : ? & = # % + ~ @
```

Filtra incompatíveis em inserção múltipla.

`WebsiteCaseMode`:

```text
LowercaseHost
LowercaseAll
```

`LowercaseHost` é o default funcional. Com `://`, normaliza para lowercase o prefixo desde o início até antes do primeiro `/`, `?` ou `#` posterior a `://`. Sem `://`, usa o primeiro `/`, `?` ou `#` como limite. Path, query e fragment preservam casing.

`LowercaseAll` converte todo conteúdo aceito para lowercase.

Website admite estados intermediários e não valida existência, DNS ou HTTP/HTTPS. `TextConversion` e `PunctuationPolicy` genéricos não alteram sua política especializada.

### CPF e CNPJ

CPF aceita até 11 dígitos lógicos e apresenta:

```text
000.000.000-00
```

CNPJ aceita até 14 dígitos lógicos e apresenta:

```text
00.000.000/0000-00
```

Não numéricos são rejeitados na digitação e filtrados em inserções múltiplas. As duas máscaras **formatam**, mas não afirmam validade matemática.

### `Phone` e `MobilePhone`

Suportam `National` e `International`. Brasil é a primeira política específica.

```text
Phone nacional       -> (21) 2345-6789
Mobile nacional      -> (21) 98765-4321
Phone internacional  -> +55 21 2345-6789
Mobile internacional -> +55 21 98765-4321
```

O país público usa ISO 3166-1 alpha-2 e o default funcional é `BR`.

No modo internacional são aceitos `+`, calling code e dígitos. País/calling code conhecido usa sua política específica. Quando ainda não houver formatter específico, preservar `+`, calling code e dígitos sem inventar formatação nacional.

Phone/MobilePhone normalizam e formatam; não validam automaticamente existência do número, DDD ou calling code. Validação pertence a `PEND-EDIT-004`.

### Texto inicial, edição intermediária e caret

O texto inicial passa pela normalização/máscara antes de se tornar texto efetivo.

Alteração programática por `Handle.SetText` também não pode contornar a política de input; sua semântica de eventos pertence às pendências de runtime/eventos.

Devem ser suportados inserção no início/meio/fim, seleção/substituição, backspace/delete, paste e estados intermediários incompletos.

Após reformatação, o caret permanece associado à posição lógica editada; não deve ser movido sempre para o final como efeito colateral da máscara.

### Fronteiras

- `PEND-EDIT-004`: validação semântica e estado `Invalid`;
- `PEND-EDIT-005`: disparo e cardinalidade de callbacks;
- `PEND-EDIT-006`: contrato runtime de `Handle.SetText`;
- `PEND-EDIT-007`: defaults de configuração não fixados funcionalmente aqui.

Máscara/formatação não ativa `Invalid` somente porque um documento ou número está incompleto.

### Critério de aceite

| Área | Contrato fechado |
|---|---|
| `None` | sem máscara adicional |
| `MaxLength` | conteúdo lógico; excesso rejeita operação inteira |
| inserção múltipla | política A/B por máscara |
| `Numeric` | somente dígitos |
| `Float` | separador controlado e negativo opcional |
| conversão | dicionário explícito antes da admissão |
| pontuação | independente de caracteres especiais |
| `Email` | catálogo fechado + lowercase; sem validação estrutural |
| `Website` | catálogo fechado + casing especializado |
| CPF/CNPJ | formatação sem validação matemática |
| Phone/MobilePhone | nacional/internacional; BR específico + fallback conservador |
| texto inicial/programático | passa pela política de input |
| edição intermediária | suportada |
| caret | posição lógica preservada |

Com estas regras, PEND-EDIT-003 fica fechada sem absorver validação, eventos ou lifetime.
