# Label — API e Configuração

> [English](api-e-configuracao.md) | [Português do Brasil](api-e-configuracao.pt-BR.md)

## API fluente

| Método | Efeito |
|---|---|
| `Text` | Define `TLabel.Text`. |
| `Position` | Define a posição-base. |
| `Size` | Define `Width` e `Height`. |
| `Anchors` | Define `TLabel.Anchors`. |
| `Margin` | Soma `Left/Top` à posição-base. |
| `Padding` | Define o padding interno do `TLabel`. |
| `FontFamily`, `FontSize`, `FontColor` | Configuram a fonte. |
| `Bold`, `Italic` | Acrescentam os estilos correspondentes. |
| `Align`, `VerticalAlign` | Configuram alinhamento horizontal e vertical. |
| `WordWrap`, `Trimming` | Configuram tratamento do texto. |
| `Opacity`, `Visible`, `HitTest`, `Tag` | Configuram o estado final do controle. |
| `Build` | Materializa e retorna o `TLabel`. |

## Defaults do Builder

| Opção | Default |
|---|---|
| `Text` | `''` |
| `Position` | `0, 0` |
| `Size` | `100, 25` |
| `Anchors` | `[]` |
| `Margin`, `Padding` | `TRickUIBuilderSpacing.None` |
| `FontFamily` | `''` |
| `FontSize` | `12` |
| `FontColor` | `TAlphaColors.Black` |
| `Bold`, `Italic` | `False` |
| `Align` | `TTextAlign.Leading` |
| `VerticalAlign` | `TTextAlign.Leading` |
| `WordWrap` | `False` |
| `Trimming` | `TTextTrimming.None` |
| `Opacity` | `1` |
| `Visible` | `True` |
| `HitTest` | `False` |
| `Tag` | `0` |

`TRickUIBuilderTextConfig.Default` fornece apenas o baseline usado pela Factory: posição, tamanho, tamanho/cor da fonte, alinhamento horizontal e bold. Os demais defaults pertencem ao Builder.

## Margin e Padding

A posição materializada é `Position + Margin.Left/Top`. `Margin.Right` e `Margin.Bottom` são preservados no record recebido pelo Builder, mas não participam do cálculo de posição ou tamanho nesta implementação. `Padding` é copiado para `TLabel.Padding` sem modificar as dimensões externas.

## Factory

`TRickUIBuilderFactory.CreateText` é a alternativa direta baseada em `TRickUIBuilderTextConfig`. Ela não oferece automaticamente as opções adicionais mantidas pelo Fluent Builder.
