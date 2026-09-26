# Customization and Examples

> [English](customizacao-e-exemplos.md) | [Português do Brasil](customizacao-e-exemplos.pt-BR.md)

## Source of truth

Examples in this document use the implemented fluent API and patterns already exercised by the project Sample. They intentionally avoid APIs that do not exist in the current contracts.

## Minimal ComboBox

```pascal
TRickUIBuilder.ComboBox
  .Position(24, 80)
  .Size(320, 42)
  .Items(['Small', 'Medium', 'Large'])
  .ItemIndex(0)
  .Build(AParent);
```

## DisplayText and Value

```pascal
FComboBoxHandle := TRickUIBuilder.ComboBox
  .Position(24, 80)
  .Size(320, 42)
  .AddItem('Rio de Janeiro', 'RJ')
  .AddItem('São Paulo', 'SP')
  .BuildHandle(AParent);
```

`SelectedText` returns the display label; `SelectedValue` returns the semantic value. They are independent fields.

## Initial selection

```pascal
TRickUIBuilder.ComboBox
  .Items(['Small', 'Medium', 'Large'])
  .SelectedText('Medium')
  .Build(AParent);
```

`ItemIndex(N)` and `SelectedText(Text)` are alternative initial-selection paths. A later builder call replaces the earlier initial-selection choice.

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

With `Mobile + Auto`, style resolution selects `FullWindow`. The explicit `FullWindow` value may also be used directly.

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

## Structured columns

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

## Custom item content

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

The callback container is the custom slot created inside the virtualized row. Create callback-owned content under that container and avoid intercepting row clicks unless that is an intentional future contract change.

## Runtime additions and arrow mutation

```pascal
if FComboBoxHandle.IsAttached then
begin
  FComboBoxHandle.Add('Mouse sem fio', '004');
  FComboBoxHandle.AddRange(['Headset', 'Webcam']);
  FComboBoxHandle.SetArrowColor($FF7E22CE);
end;
```

## Custom arrow paths

```pascal
TRickUIBuilder.ComboBox
  .ClosedArrowPath(MyClosedPath)
  .OpenedArrowPath(MyOpenedPath)
  .ArrowColor($FF2563EB)
  .Build(AParent);
```

## Custom FullWindow content

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

Path strings are parsed by FireMonkey `TPathData`; see the maintenance document before writing tests that compare path data.

## CustomConfig

Use `TRickUIBuilderComboBoxConfig.Default` as the starting point, change only required tokens, then pass the record to `.CustomConfig(Config)`. This preserves all currently defined defaults and avoids leaving newly introduced fields uninitialized in future versions.

### Advanced typography and colors

```pascal
LConfig := TRickUIBuilderComboBoxConfig.Default;
LConfig.FontFamily := 'Segoe UI';
LConfig.FontStyle := [TFontStyle.fsBold];
LConfig.TextAlign := TTextAlign.Center;
LConfig.Trimming := TTextTrimming.Character;
LConfig.PlaceholderColor := $FF98A2B3;
LConfig.FocusColor := $FF7E22CE;

TRickUIBuilder.ComboBox
  .CustomConfig(LConfig)
  .Items(['Small', 'Medium', 'Large'])
  .Build(AParent);
```

`CustomConfig` copies the entire record. Prefer starting from `Default` instead of declaring a partially initialized record.

### Advanced FullWindow configuration

```pascal
LConfig := TRickUIBuilderComboBoxConfig.Default;
LConfig.PresentationMode :=
  TRickUIBuilderComboBoxPresentationMode.FullWindow;
LConfig.FullWindowCornerRadius := 20;
LConfig.FullWindowPadding := 20;
LConfig.SearchFieldHeight := 52;
LConfig.SearchFieldCornerRadius := 12;
LConfig.FullWindowBackgroundColor := $FFF8FAFC;
LConfig.SearchFieldBackgroundColor := TAlphaColors.White;
LConfig.SearchFieldBorderColor := $FFCBD5E1;
LConfig.SearchTextColor := $FF0F172A;
LConfig.SearchIconColor := $FF475569;
LConfig.NoResultsTextColor := $FF64748B;
LConfig.NoResultsIconColor := $FF94A3B8;

TRickUIBuilder.ComboBox
  .CustomConfig(LConfig)
  .SearchPlaceholder('Search product...')
  .NoResultsText('No product found')
  .Build(AParent);
```

The geometry and color fields above belong to the same `TRickUIBuilderComboBoxConfig`; there is no separate FullWindow configuration record.

### Popup width

With `PopupWidth <= 0`, the popup uses the anchor width plus `PopupWidthOffset`:

```pascal
LConfig := TRickUIBuilderComboBoxConfig.Default;
LConfig.PopupWidth := 0;
LConfig.PopupWidthOffset := 80;

TRickUIBuilder.ComboBox
  .CustomConfig(LConfig)
  .Size(240, 40)
  .Items(['Small', 'Medium', 'Large'])
  .Build(AParent);
```

In this example, the runtime rule calculates width from the anchor width (`240`) plus the offset (`80`). If `PopupWidth` is greater than zero, `PopupWidthOffset` no longer participates in the calculation.

### Left-side arrow

```pascal
TRickUIBuilder.ComboBox
  .ArrowPosition(TRickUIBuilderComboBoxArrowPosition.Left)
  .ArrowMargins(12, 4, 8, 4)
  .ArrowSize(16)
  .Items(['Small', 'Medium', 'Large'])
  .Build(AParent);
```

When the arrow is on the left, runtime reserves text space after the arrow using `ArrowMarginRight`. When it is on the right, the text area ends before the arrow using `ArrowMarginLeft`. `ArrowMarginTop` and `ArrowMarginBottom` participate in the arrow's vertical placement.
