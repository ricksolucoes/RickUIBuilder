# Edit runtime

O `Edit` é o builder single-line do RickUIBuilder para entrada de texto criada em runtime.

## Criação

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

`Build` retorna `IRickUIBuilderEditHandle`. O handle não substitui o ownership FMX: os controles criados pertencem ao `AParent` informado.

## Presets

`TRickUIBuilderEditPreset` disponibiliza CPF, CNPJ, CEP, e-mail, URL, telefone, celular, inteiro, Float, quatro variações de texto com/sem acentos e pontuação, e modo irrestrito.

CPF usa `000.000.000-00`; CEP usa `00000-000`. CNPJ usa `AA.AAA.AAA/AAAA-00`: as 12 primeiras posições aceitam `0-9`/`A-Z` e as duas finais são numéricas. Esses presets validam formato, não dígitos verificadores.

Telefone aceita `0000-0000` ou `(00) 0000-0000`. Celular aceita `0 0000-0000` ou `(00) 0 0000-0000`; o DDD passa a fazer parte da máscara quando a quantidade de dígitos o comporta.

## Números

`AllowNegative` controla sinal negativo. `FloatNumber` também aceita `DecimalPlaces`, `NumberFormatMode`, `DecimalSeparator`, `ThousandSeparator` e `UseThousandSeparator`. `Locale` usa `FormatSettings`; `Custom` usa os separadores informados.

## Caixa e URL

`CaseMode` permite preservar, converter para uppercase ou lowercase. E-mail é sempre convertido para lowercase.

Para URL, `SchemeAndHost` converte somente scheme + host; `EntireValue` converte todo o conteúdo.

## Limite e contador

`MaxLength` impede que o valor final ultrapasse o limite configurado. `CharacterCounter` exibe `atual/máximo` quando existe limite.

## Paste

Nos presets mascarados, paste só é aceito quando o texto colado já possui a estrutura da máscara. Um paste inválido preserva o último conteúdo válido. Os demais presets usam a mesma política de caracteres, transformação e limite aplicada à edição.

## Clear e senha

`ClearButton` habilita o botão de limpeza. `Password` inicia o `TEdit` em modo de senha e habilita a alternância runtime entre conteúdo oculto e visível.

## Estados e feedback

O componente possui estados normal, foco e inválido. `InvalidFeedback` seleciona mensagem, ícone ou ambos. O estado inválido pode ser controlado pelo handle:

```pascal
LEdit.SetInvalid(True, 'Valor inválido');
LEdit.SetInvalid(False);
```

## Indicador de requisito

`RequirementIndicator` habilita o indicador. O estado é explicitamente controlado pelo consumidor, sem inferir validação semântica:

```pascal
LEdit.SetRequirementMet(True);
```

Os paths padrão usam os SVGs fornecidos para requisito atendido e não atendido e podem ser substituídos pelos métodos `RequirementMetPath` e `RequirementNotMetPath`.

## TPath

Alert, clear, visibilidade de senha e requisito são renderizados com `TPath`. Os paths e `IconColor`/`IconSize` são configuráveis.

## Lifetime

O `Behavior` runtime é um `TComponent` pertencente ao `AParent`, portanto permanece vivo depois que o builder sai de escopo. O handle é non-owning em relação aos controles FMX e deve ser considerado inválido depois que o Parent for destruído, seguindo o mesmo princípio dos handles existentes do projeto.

## Sample operacional

O projeto em `sample/` possui uma seção dedicada ao `Edit` para validação visual e operacional em runtime. Ela cobre:

- CPF, CNPJ alfanumérico e CEP com máscara;
- e-mail, telefone e celular;
- inteiro negativo e `FloatNumber` nos modos `Locale` e `Custom`;
- todos os presets textuais;
- `Uppercase`, `Lowercase` e os dois modos de URL;
- `MaxLength` com contador, clear e password;
- os três modos de feedback inválido e estado controlado pelo handle;
- indicador de requisito controlado pelo consumidor;
- cópia e paste de CPF válido e inválido.

A bancada de clipboard usa `TEdit.SelectAll`, `CopyToClipboard` e `PasteFromClipboard`. Para o alvo CPF, o valor `123.456.789-01` representa um paste estruturalmente válido e `12345678901` permite verificar a rejeição do paste sem máscara.

O Sample é uma verificação manual complementar aos testes automatizados; ele não substitui DUnitX nem validação por Method Toxicity Metrics.
