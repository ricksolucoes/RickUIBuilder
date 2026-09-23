# Dados, Seleção e Filtro

> [English](dados-selecao-e-filtro.md) | [Português do Brasil](dados-selecao-e-filtro.pt-BR.md)

## Fonte de verdade

`Rick.UIBuilder.ComboBox.Data.pas` possui os itens lógicos, a seleção confirmada, o texto do filtro e o mapeamento entre índices da view filtrada e índices da coleção de origem. Ele não contém controles visuais FMX.

## Identidade do item

Um item lógico é `TRickUIBuilderComboBoxItem` com `DisplayText`, `Value` e `Columns` opcionais. `Value` não precisa ser único. `DisplayText` também pode repetir. A identidade estável usada pela implementação é o source index na lista/array atual de itens.

## Seleção confirmada

`FItemIndex` armazena o source index confirmado. `-1` significa sem seleção. `SelectedText` e `SelectedValue` retornam strings vazias quando não existe source index válido selecionado. `SelectIndex` aceita `-1` ou um source index válido; índices inválidos não alteram a seleção atual.

## Comportamento de SelectText

`TrySelectText` realiza comparação exata case-insensitive com `DisplayText` e seleciona a primeira ocorrência. Se não houver correspondência, retorna `False` e preserva a seleção confirmada atual.

## Pesquisa incremental por prefixo

`FindPrefix` é separado do filtro FullWindow. Ele é usado pela pesquisa incremental via teclado no handle runtime. O handle acumula caracteres digitados em um search buffer e limpa esse buffer após `SearchTimeout` (900 ms por default).

## View filtrada

```text
Source Items
    ↓
FilterText
    ↓
FilteredIndexes
    ↓
ViewIndex
    ↓
SourceIndex
```

Quando `FilterText` está vazio, `ViewCount = Count` e `SourceIndexFromView(N) = N`. Com filtro ativo, `FFilteredIndexes` contém source indexes cujo `DisplayText` atende `ContainsText(DisplayText, FilterText)`. É uma busca case-insensitive por substring via `System.StrUtils.ContainsText`.

## Exemplo de mapeamento de índices

```text
SourceIndex  DisplayText
0            Rio de Janeiro
1            São Paulo
2            Riviera
3            Salvador

FilterText = "ri"

ViewIndex    SourceIndex
0            0
1            2
```

A seleção continua baseada em source index. Uma row representando `ViewIndex = 1` neste exemplo filtrado armazena `Tag = 2`, e a confirmação dessa row seleciona o item de origem 2.

## Regras de mutação do filtro

`SetFilterText` armazena o novo texto e reconstrói os índices filtrados. `ClearFilter` limpa somente o estado do filtro. `Add` e ambas as sobrecargas de `AddRange` reconstróem a lista filtrada quando há filtro ativo. A filtragem nunca remove, copia ou reordena `FItems`.

## Interação entre seleção e filtro

Uma seleção de origem confirmada pode não estar presente na view filtrada atual. `Handle.UpdateTargetFromView` mantém a seleção confirmada como target quando ela está visível; caso contrário usa o primeiro item de origem visível, ou `-1` quando a view está vazia. Isso altera somente o target transitório, não o `ItemIndex` confirmado.

## Restrições de manutenção

Não substituir seleção por source index por seleção baseada em view index. Não modificar `FItems` para implementar filtro. Não utilizar `Value` como chave de unicidade. Qualquer mudança na semântica de busca exige atualização coordenada dos testes de Data, testes de pesquisa FullWindow e comportamento de seleção/virtualização.
