# Presentation Modes

> [English](presentation-modes.md) | [Português do Brasil](presentation-modes.pt-BR.md)

## Fonte de verdade

A seleção do modo de apresentação é resolvida em `Rick.UIBuilder.ComboBox.Style.pas`; a materialização visual é implementada em `Rick.UIBuilder.ComboBox.Presentation.pas`.

## StyleType e PresentationMode são independentes

`TRickUIBuilderComboBoxStyleType` seleciona um perfil visual/de interação. `TRickUIBuilderComboBoxPresentationMode` seleciona como a superfície de seleção é apresentada. Eles são separados intencionalmente para que `Custom` possa usar Anchored ou FullWindow e para que uma presentation explícita substitua o default do style.

## Resolução de Auto

```text
Desktop + Auto  → Anchored
Mobile  + Auto  → FullWindow
Adaptive         → Mobile on ANDROID/IOS, otherwise Desktop
Explicit PresentationMode → preserved
```

`Adaptive` é resolvido no target de compilação por conditional defines. Depois de definido o effective style, `Auto` é convertido para `FullWindow` em Mobile e `Anchored` nos demais estilos efetivos.

## Defaults Desktop e Mobile

Defaults Desktop: `Height = 40`, `ItemHeight = 36`, `HorizontalPadding = 12`, `ArrowSize = 20`. Defaults Mobile: `Height = 48`, `ItemHeight = 48`, `HorizontalPadding = 16`, `ArrowSize = 22`. Overrides explícitos do builder para height, item height e arrow size são restaurados após a resolução de style.

## Anchored

Anchored usa o parent original como parent do popup. A largura é `PopupWidth` quando maior que zero; caso contrário usa a largura do anchor mais `PopupWidthOffset`. O posicionamento prefere abaixo do anchor quando há espaço, depois acima, e por fim o lado com mais espaço disponível. A altura é limitada por `PopupMaxHeight`.

## Overlay

Overlay também utiliza o parent original. Sua origem é a origem atual do viewport e sua largura expande para a largura do parent quando ele é um `TControl`. A altura é limitada pela altura disponível do parent. Overlay é um comportamento distinto e não deve ser tratado como alias de FullWindow.

## FullWindow

FullWindow resolve um presentation host separado percorrendo a cadeia de parents até encontrar um `TCommonCustomForm`. O popup é parented nesse host, alinhado como client, e somente os cantos top-left/top-right são arredondados. Ele contém o header de pesquisa, a lista virtualizada de resultados e o empty state.

## Overrides explícitos

Quando `PresentationMode` não é `Auto`, o resolver preserva o valor. Isso permite `Custom + Anchored`, `Custom + FullWindow` ou um modo explicitamente solicitado em Desktop/Mobile. A decisão explícita de presentation prevalece sobre o default do style.

## Exemplos

```pascal
TRickUIBuilder.ComboBox
  .StyleType(TRickUIBuilderComboBoxStyleType.Mobile)
  .PresentationMode(TRickUIBuilderComboBoxPresentationMode.Auto)
  .Position(24, 80)
  .AddItem('Rio de Janeiro', 'RJ')
  .AddItem('Riviera de São Lourenço, SP', 'RIVIERA')
  .AddItem('Ribeirão Preto, SP', 'RAO')
  .SearchPlaceholder('Pesquisar cidade...')
  .NoResultsText('Nenhuma cidade encontrada')
  .Build(AParent);
```

```pascal
TRickUIBuilder.ComboBox
  .StyleType(TRickUIBuilderComboBoxStyleType.Custom)
  .PresentationMode(TRickUIBuilderComboBoxPresentationMode.FullWindow)
  .Column(TRickUIBuilderComboBoxColumn.Create(
    TRickUIBuilderComboBoxColumnSizeMode.Fixed, 86))
  .Column(TRickUIBuilderComboBoxColumn.Create(
    TRickUIBuilderComboBoxColumnSizeMode.Proportional, 1))
  .AddStructuredItem('Cliente ativo', 'ATV', ['ATV', 'Cliente ativo'])
  .AddStructuredItem('Cliente bloqueado', 'BLQ', ['BLQ', 'Cliente bloqueado'])
  .SearchPlaceholder('Pesquisar status...')
  .NoResultsText('Nenhum status encontrado')
  .Build(AParent);
```

## Restrições de manutenção

Não colapsar Overlay e FullWindow em um único modo. Não inferir presentation a partir do parent atual depois da resolução de style. Manter `RequestedStyleType` e `EffectiveStyleType` distintos. Qualquer mudança na resolução de Auto exige atualização dos testes de style e da documentação correspondente.
