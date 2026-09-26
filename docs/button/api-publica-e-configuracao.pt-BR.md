# Button — API Pública e Configuração

> [English](api-publica-e-configuracao.md) | [Português do Brasil](api-publica-e-configuracao.pt-BR.md)

## API fluente

| Grupo | Métodos |
|---|---|
| Conteúdo/geometria | `Caption`, `Position`, `Size`, `Anchors`, `CornerRadius`, `Margin`, `Padding` |
| Aparência | `FillColor`, `BorderColor`, `BorderThickness`, `TextColor`, `FontFamily`, `FontSize`, `Bold`, `HoverFillColor` |
| Estado | `DisabledOpacity`, `Enabled`, `Cursor`, `Opacity`, `Visible`, `Tag` |
| Eventos | `OnClick`, `OnHover` |
| Materialização | `Build`, `BuildHandle` |

## Defaults do Builder

Posição `0,0`, tamanho `120×40`, `CornerRadius=16`, margin/padding zero, fill `Dodgerblue`, borda `Null`, `BorderThickness=0`, texto `White`, `FontFamily=''`, `FontSize=16`, `Bold=False`, sem hover color explícita, `DisabledOpacity=0.45`, `Enabled=True`, `Cursor=crHandPoint`, `Opacity=1`, `Visible=True`, `Tag=0` e eventos `nil`.

`TRickUIBuilderButtonConfig.Default` é menor: contém posição, tamanho, fill, border color, text color, tag e font size. Os demais defaults pertencem ao Builder.

## Borda

A Factory ativa uma borda sólida de espessura `2` quando `BorderColor <> TAlphaColors.Null`. Depois, o Builder só substitui a espessura se `BorderThickness > 0`. Assim, definir apenas `BorderColor` mantém a espessura `2` da Factory.

## Enabled e opacidade

Quando `Enabled=True`, o container recebe `Opacity`. Quando `Enabled=False`, recebe `DisabledOpacity`. O Builder também define `TRectangle.Enabled` com o valor configurado.

## Margin e Padding

`Margin.Left/Top` são somados a `Position`. `Padding` é aplicado ao `TLabel` interno do caption e não redimensiona o container.

## Factory × Builder

`TRickUIBuilderFactory.CreateButton` materializa `TRectangle` + `TLabel` a partir de `TRickUIBuilderButtonConfig`. O Fluent Builder adiciona anchors, radius, margin/padding, font family/bold, border thickness, enabled/opacity/cursor/visible, eventos e todo o subsistema de hover.
