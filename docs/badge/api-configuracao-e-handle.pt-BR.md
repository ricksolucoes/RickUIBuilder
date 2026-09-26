# Badge — API, Configuração e Handle

> [English](api-configuracao-e-handle.md) | [Português do Brasil](api-configuracao-e-handle.pt-BR.md)

## API

| Método | Efeito |
|---|---|
| `Text`, `Position`, `Size` | Conteúdo e geometria. |
| `Pill` | Quando `True`, preserva o raio pill criado pela Factory. |
| `CornerRadius` | Raio usado quando `Pill=False`. |
| `Margin` | Soma `Left/Top` à posição-base. |
| `Padding` | Define padding do `TextLabel`. |
| `BackgroundColor`, `TextColor`, `BorderColor` | Cores do Badge. |
| `FontSize`, `Bold` | Tipografia do texto. |
| `Opacity`, `Visible`, `Tag` | Estado final do container. |
| `Build` | Retorna `IRickUIBuilderBadgeHandle`. |

## Defaults do Builder

`Text=''`, posição `0,0`, tamanho `80×25`, `Pill=False`, `CornerRadius=0`, margin/padding zero, background `Lightgray`, texto `Black`, borda `Null`, `FontSize=12`, `Bold=False`, `Opacity=1`, `Visible=True`, `Tag=0`.

## Pill versus CornerRadius

A Factory direta usa `XRadius=YRadius=Height/2`. O Builder preserva esse formato apenas quando `Pill=True`. Com `Pill=False`, sobrescreve ambos os raios com `CornerRadius`.

## Borda

`BorderColor=TAlphaColors.Null` mantém o stroke desativado. Quando uma cor é informada, o Builder ativa `Stroke.Kind=Solid` e aplica a cor. Não existe `BorderThickness` público no Badge atual.

## Handle

`IRickUIBuilderBadgeHandle` expõe `Container: TRectangle` e `TextLabel: TLabel`. O Handle é uma referência de acesso pós-Build; não assume ownership e não prolonga o lifetime dos controles.
