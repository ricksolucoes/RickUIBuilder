# Testes e Contratos Comportamentais

> [English](testes-e-contratos.md) | [Português do Brasil](testes-e-contratos.pt-BR.md)

## Cobertura atual no código e execução histórica

O ZIP atual declara **240** métodos `[Test]` nas units de teste. Esse valor foi obtido por inspeção estática do código-fonte e não comprova que a suíte passa. A governança do projeto preserva uma baseline DUnitX real histórica de **197 encontrados / 197 aprovados / 0 ignorados / 0 leaks / 0 failures / 0 errors** para uma revisão anterior efetivamente executada. Uma nova execução DUnitX é necessária antes de atribuir contagens de aprovação ou falha à revisão atual.

## Contratos de Data

A fixture de dados do ComboBox valida defaults sem seleção, comportamento com texto duplicado, `Value` independente, tratamento de índice inválido, preservação de seleção durante `AddRange`, mapeamento entre view filtrada e source, limpeza do filtro e atualização enquanto há filtro ativo.

## Contratos de integração

```text
Factory_DeveCriarControleFechadoNoScrollBox
Builder_DevePermanecerVisivelNoScrollBox
BuildSemHandle_DeveManterRuntimeAposBuilderSairDeEscopo
Facade_DeveCriarSelecaoInicial
Runtime_DeveSelecionarAdicionarEConsultar
RemoverOutroComponente_NaoDeveDesanexarHandle
Handle_DeveDesanexarQuandoParentForDestruido
PopupAberto_DeveDesanexarQuandoParentForDestruido
Seta_DeveTrocarPathAoAbrirEFechar
AddRangeComPopupAberto_DevePreservarSelecao
SetaDireita_DeveRespeitarMargensCustomizadas
SetaEsquerda_DeveReservarAreaDoTexto
PathsDefault_DeveUsarSetasIndependentes
FullWindow_DeveUsarFormComoHostVisual
FullWindow_DeveCriarEstruturaDeBuscaCompleta
Clear_InicialmenteEComEditVazioDeveEstarOculto
Clear_ComUmOuMaisCaracteresDeveFicarVisivel
Clear_AoClicarDeveRestaurarFiltroSemAlterarSelecao
Clear_AposEmptyStateDeveRestaurarLista
ResultadoFiltrado_DeveSelecionarSourceIndexEValueOriginal
EmptyState_DeveAceitarMensagemEPathCustomizados
Back_DeveFecharFullWindowSemAlterarSelecao
ParentDestruidoComFullWindowAberto_DeveDesanexarHandle
CustomFullWindow_DeveUsarMesmaPresentationFullWindow
FullWindowPathsDefault_DeveUsarAssetsFornecidos
```

Esses nomes de testes documentam a superfície de integração atual. Eles devem ser tratados como contratos comportamentais ao refatorar a implementação interna.

## Contratos de Style

A fixture de style verifica `Desktop + Auto → Anchored`, `Mobile + Auto → FullWindow` e precedência de override explícito de presentation.

## Contratos FullWindow

Os testes FullWindow validam hosting na Form raiz, estrutura completa de pesquisa, visibilidade e comportamento do Clear, seleção por source index através de view filtrada, conteúdo customizado de empty state, semântica de Back, destruição do parent, reutilização de Custom + FullWindow e assets default de path fornecidos.

## Normalização de path nos testes

`TPathData.Data` do FireMonkey interpreta o path de entrada e pode serializá-lo novamente em forma canônica. Os testes não devem usar a string SVG/path original como identidade textual persistente. Os testes atuais normalizam o path esperado via `TPathData` antes da comparação.

## O que a baseline histórica não significa

A execução histórica 197/197 é evidência apenas para a revisão e configuração que foram executadas. Ela não comprova que os 240 testes atualmente declarados passam, nem garante zero defeitos, todas as plataformas, todos os temas, todos os DPIs ou mudanças futuras. Estilo visual, como aparência nativa do edit, ainda deve ser inspecionado nas plataformas target quando alterado.

## Gate de regressão para mudanças futuras

No mínimo, preserve todos os testes existentes do ComboBox. Quando o comportamento mudar intencionalmente, atualize testes e documentação em conjunto. Uma entrega final deve distinguir resultado DUnitX realmente executado de revisão estática.
