# FullWindow e Pesquisa

> [English](fullwindow-e-pesquisa.md) | [Português do Brasil](fullwindow-e-pesquisa.pt-BR.md)

## Fonte de verdade

`Rick.UIBuilder.ComboBox.Presentation.pas` materializa a árvore visual FullWindow. `Rick.UIBuilder.ComboBox.Handle.pas` possui o comportamento de search/clear/back. `Rick.UIBuilder.ComboBox.Data.pas` possui o estado real do filtro.

## Árvore visual

```text
FullWindow Popup
│
├── Header
│   └── SearchField
│       ├── BackHitArea
│       │   └── BackPath
│       ├── SearchEdit
│       └── ClearHitArea
│           └── ClearPath
│
├── TVertScrollBox
│
└── EmptyState
    ├── EmptyPath
    └── EmptyLabel
```

O popup FullWindow é criado de forma lazy na primeira abertura. Ele é alinhado ao presentation host resolvido, e não ao parent do anchor.

## Anchor parent e presentation host

O controle fechado permanece anexado ao parent fornecido pelo consumidor. FullWindow percorre essa cadeia de parents e usa o primeiro `TCommonCustomForm` como presentation host. Isso evita que uma superfície FullWindow fique limitada a uma hierarquia interna de `TVertScrollBox`/`TScrollContent`.

## Composição do campo de pesquisa

`SearchField` é o frame visual (`TRectangle`). `SearchEdit` é o controle de edição. O edit usa `ControlType = Styled`, `StyleLookup = transparentedit` e `DisableFocusEffect = True`. `SearchField.ClipChildren = True` impede que conteúdo do estilo do edit seja desenhado fora do campo arredondado.

## Hit areas de Back e Clear

`BackPath` e `ClearPath` são somente visuais (`HitTest = False`). Os `TLayout` que os contêm recebem os click handlers. A largura da hit area é `SearchFieldHeight`, enquanto o ícone usa `SearchIconSize`; assim, o alvo touch/click pode ser maior que o glyph.

## Fluxo da pesquisa

```text
SearchEdit
↓
OnChangeTracking
↓
Handle.SearchChanged
↓
Data.SetFilterText
↓
Filtered View
↓
UpdateTargetFromView
↓
Virtualizer.Refresh
↓
Presentation.UpdateResultState
```

`SearchChanged` primeiro sincroniza a visibilidade do Clear, depois atualiza `Data.FilterText`, recalcula o target transitório de acordo com a view filtrada e atualiza presentation/virtualização. A coleção de origem permanece inalterada.

## Contrato de visibilidade do Clear

```text
Length(SearchEdit.Text) = 0
→ ClearHitArea.Visible = False
→ ClearHitArea.HitTest = False

Length(SearchEdit.Text) > 0
→ ClearHitArea.Visible = True
→ ClearHitArea.HitTest = True
```

A implementação usa `Length(SearchEdit.Text) > 0`, e não `Trim`. Portanto um único espaço conta como conteúdo e mantém a hit area de Clear visível.

## Comportamento do clique em Clear

`Handle.ClearSearchClick` chama `Presentation.ResetSearch`, limpa `Data.FilterText`, recalcula o target e atualiza o popup. Ele não limpa a seleção confirmada, não dispara `OnChange` sem mudança real de seleção em outro fluxo, não fecha FullWindow e não refaz o Build.

## Comportamento de Back

A hit area de Back delega para `Handle.DismissClick`, que chama `Close`. O fechamento oculta a presentation e restaura o estado fechado da seta; não confirma um target transitório. `ItemIndex`, `SelectedText` e `SelectedValue` confirmados permanecem inalterados.

## Empty state

`Presentation.UpdateResultState(ViewCount)` mostra o `TVertScrollBox` de resultados quando `ViewCount > 0` e mostra `EmptyState` quando `ViewCount = 0`. O empty state contém `NoResultsPath` e `NoResultsText`, estilizados pelas cores e tamanho de ícone correspondentes do config.

## Comportamento de teclado dentro do SearchEdit

Enquanto FullWindow está aberto, o key handler específico do edit processa Up, Down, PageUp, PageDown, Enter, Escape e Tab. As demais teclas ficam para o edit. Enter confirma o target atual; Escape/Tab fecham. Home/End e Space são intencionalmente deixados fora do handler específico do edit.

## Comportamento ao reabrir

`Handle.Open` chama `ResetFullWindowFilter` antes de materializar/atualizar a presentation. Assim, FullWindow reabre com texto de busca vazio e a view completa dos dados, preservando a seleção confirmada.

## Exemplo

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
