# Virtualização e Renderização

> [English](virtualizacao-e-renderizacao.md) | [Português do Brasil](virtualizacao-e-renderizacao.pt-BR.md)

## Fonte de verdade

`Rick.UIBuilder.ComboBox.Virtualization.pas` implementa o pool de rows e o pipeline de renderização. Ele recebe um `TVertScrollBox`, uma referência non-owning para `TRickUIBuilderComboBoxData` e uma cópia de `TRickUIBuilderComboBoxConfig`.

## Por que existe virtualização

A quantidade de itens lógicos pode exceder a quantidade de rows visíveis. O virtualizer cria somente rows suficientes para o viewport mais um pequeno buffer: `Ceil(ScrollBox.Height / ItemHeight) + 2`, limitado por `Data.ViewCount`. As rows são rebinderizadas conforme o viewport muda.

## Ownership do pool visual

Rows e spacer são criados com o `TVertScrollBox` como owner/parent. O virtualizer armazena referências non-owning para eles e limpa eventos/referências durante detach/destruição. Ele não libera manualmente rows quando o scroll box possui a árvore visual.

## Pipeline de renderização

```text
ResetRow
→ BindRow
→ BuildTextCells
→ CreateCustomSlot (when configured)
→ ApplyRowState
→ Display
```

`ResetRow` oculta a row, redefine `Tag`, restaura a cor do popup e libera conteúdo filho existente. `BindRow` resolve `SourceIndexFromView`, armazena o source index em `Row.Tag`, posiciona a row pelo view index, constrói texto/colunas, cria opcionalmente o custom slot e torna a row visível. `Refresh` então aplica as cores de selected/target.

## View index versus source index

A posição Y da row é baseada no view index porque a view filtrada controla ordem/visibilidade. `Row.Tag` guarda o source index porque seleção, hover e callbacks operam sobre a identidade de origem. Essa distinção é obrigatória com filtros ativos.

## Altura do conteúdo

Um spacer transparente é posicionado em `ViewCount * ItemHeight - 1` para que o scroll box exponha a extensão virtual correta sem materializar um controle por item.

## Renderização de texto simples

Quando não existem colunas estruturadas utilizáveis, é criado um único `TLabel` client-aligned usando fonte, cor, alinhamento, trimming e padding horizontal do config. Para effective style Mobile, o renderer usa intencionalmente `DisplayText` simples mesmo quando existem colunas estruturadas.

## Colunas estruturadas

Colunas visíveis são processadas em ordem. `Fixed` consome a largura configurada. `Proportional` recebe uma fração ponderada do espaço restante. `Auto` recebe uma unidade de peso flexível. Valores ausentes em `Item.Columns[N]` são renderizados como string vazia. Visibilidade e alinhamento vêm de `TRickUIBuilderComboBoxColumn`.

## Custom slot

Quando `OnCustomizeItem` está atribuído, o virtualizer cria um `TLayout` client-aligned sob a row e chama o callback com o **source index**, record do item e container custom. Controles criados pelo callback devem usar esse container como owner/parent. O slot possui `HitTest = False` para manter a row como alvo do clique.

## Estados visuais

O source index selecionado usa `SelectedColor`. O target source index usa `HoverColor`. As demais rows usam `PopupColor`. Mouse enter usa hover color exceto na row selecionada; mouse leave reaplica o estado selected/target/default.

## EnsureIndexVisible

O método primeiro converte o source index para o view index atual. Se o item de origem estiver filtrado, não ocorre scroll. Caso contrário o viewport é ajustado somente quando a row está acima ou abaixo da área visível.

## Exemplo

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
