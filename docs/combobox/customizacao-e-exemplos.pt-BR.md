# Customização e Exemplos

> [English](customizacao-e-exemplos.md) | [Português do Brasil](customizacao-e-exemplos.pt-BR.md)

## Fonte de verdade

Os exemplos deste documento utilizam a API fluente implementada e padrões já exercitados pelo Sample do projeto. Eles evitam intencionalmente APIs que não existem nos contratos atuais.

## ComboBox mínimo

```pascal
TRickUIBuilder.ComboBox
  .Position(24, 80)
  .Size(320, 42)
  .Items(['Small', 'Medium', 'Large'])
  .ItemIndex(0)
  .Build(AParent);
```

## DisplayText e Value

```pascal
FComboBoxHandle := TRickUIBuilder.ComboBox
  .Position(24, 80)
  .Size(320, 42)
  .AddItem('Rio de Janeiro', 'RJ')
  .AddItem('São Paulo', 'SP')
  .BuildHandle(AParent);
```

`SelectedText` retorna o texto exibido; `SelectedValue` retorna o valor semântico. São campos independentes.

## Seleção inicial

```pascal
TRickUIBuilder.ComboBox
  .Items(['Small', 'Medium', 'Large'])
  .SelectedText('Medium')
  .Build(AParent);
```

`ItemIndex(N)` e `SelectedText(Text)` são caminhos alternativos de seleção inicial. Uma chamada posterior no builder substitui a escolha anterior de seleção inicial.

## Desktop + Anchored

```pascal
TRickUIBuilder.ComboBox
  .StyleType(TRickUIBuilderComboBoxStyleType.Desktop)
  .PresentationMode(TRickUIBuilderComboBoxPresentationMode.Anchored)
  .Position(24, 80)
  .Size(320, 42)
  .Items(['Small', 'Medium', 'Large'])
  .ArrowPosition(TRickUIBuilderComboBoxArrowPosition.Right)
  .ArrowMargins(8, 4, 16, 4)
  .ArrowSize(14)
  .Build(AParent);
```

## Mobile + FullWindow

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

Com `Mobile + Auto`, a resolução de style seleciona `FullWindow`. O valor explícito `FullWindow` também pode ser usado diretamente.

## Custom + FullWindow

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

## Colunas estruturadas

```pascal
LCodeColumn := TRickUIBuilderComboBoxColumn.Create(
  TRickUIBuilderComboBoxColumnSizeMode.Fixed, 90);
LDescriptionColumn := TRickUIBuilderComboBoxColumn.Create(
  TRickUIBuilderComboBoxColumnSizeMode.Proportional, 1);

TRickUIBuilder.ComboBox
  .Column(LCodeColumn)
  .Column(LDescriptionColumn)
  .AddStructuredItem('Notebook Core i7', '001', ['001', 'Notebook Core i7'])
  .AddStructuredItem('Monitor 27', '002', ['002', 'Monitor 27'])
  .SelectedText('Monitor 27')
  .Build(AParent);
```

## Conteúdo customizado do item

```pascal
procedure TFormMain.CustomizeComboBoxItem(Sender: TObject; AIndex: Integer;
  const AItem: TRickUIBuilderComboBoxItem; AContainer: TControl);
var
  LBadge: TRectangle;
begin
  LBadge := TRectangle.Create(AContainer);
  LBadge.Parent := AContainer;
  LBadge.Align := TAlignLayout.Right;
  LBadge.Width := 72;
  LBadge.HitTest := False;
end;
```

O container recebido pelo callback é o custom slot criado dentro da row virtualizada. Crie o conteúdo do callback sob esse container e evite interceptar cliques da row, a menos que isso seja uma mudança futura intencional de contrato.

## Adições runtime e mutação da seta

```pascal
if FComboBoxHandle.IsAttached then
begin
  FComboBoxHandle.Add('Mouse sem fio', '004');
  FComboBoxHandle.AddRange(['Headset', 'Webcam']);
  FComboBoxHandle.SetArrowColor($FF7E22CE);
end;
```

## Paths customizados da seta

```pascal
TRickUIBuilder.ComboBox
  .ClosedArrowPath(MyClosedPath)
  .OpenedArrowPath(MyOpenedPath)
  .ArrowColor($FF2563EB)
  .Build(AParent);
```

## Conteúdo FullWindow customizado

```pascal
TRickUIBuilder.ComboBox
  .StyleType(TRickUIBuilderComboBoxStyleType.Mobile)
  .SearchPlaceholder('Search customer...')
  .NoResultsText('No customer found')
  .BackPath(MyBackPath)
  .ClearPath(MyClearPath)
  .NoResultsPath(MyEmptyPath)
  .Build(AParent);
```

Strings de path são interpretadas por `TPathData` do FireMonkey; consulte o documento de manutenção antes de escrever testes que comparem path data.

## CustomConfig

Use `TRickUIBuilderComboBoxConfig.Default` como ponto de partida, altere somente os tokens necessários e passe o record para `.CustomConfig(Config)`. Isso preserva todos os defaults atualmente definidos e evita deixar novos campos sem inicialização em versões futuras.
