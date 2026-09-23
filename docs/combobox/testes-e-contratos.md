# Tests and Behavioral Contracts

> [English](testes-e-contratos.md) | [Português do Brasil](testes-e-contratos.pt-BR.md)

## Validated baseline

The current documented state was executed with DUnitX on 2026-09-22: **197 tests found, 197 passed, 0 ignored, 0 leaked, 0 failed, 0 errored**. This is real execution evidence for this version.

## Data contracts

The ComboBox data fixture validates no-selection defaults, duplicate text behavior, independent `Value`, invalid index handling, selection preservation during `AddRange`, filtered view/source mapping, filter clearing, and updates while a filter is active.

## Integration contracts

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

These test names document the current integration surface. They should be treated as behavior contracts when refactoring internals.

## Style contracts

The style fixture verifies `Desktop + Auto → Anchored`, `Mobile + Auto → FullWindow`, and explicit presentation override precedence.

## FullWindow contracts

The FullWindow tests verify root-form hosting, complete search structure, Clear visibility and behavior, source-index selection through a filtered view, custom empty state content, Back semantics, parent destruction, Custom + FullWindow reuse, and default provided path assets.

## Path normalization in tests

FireMonkey `TPathData.Data` parses the input path and may serialize it back in canonical form. Tests must not use the original SVG/path input string as a persistent textual identity. The current tests normalize expected path data through `TPathData` before comparison.

## What the test baseline does not mean

197/197 is evidence for the executed configuration and current test scope. It is not a guarantee of zero defects, all platforms, all themes, all DPI values, or future changes. Visual styling such as native edit appearance should still be inspected on target platforms when changed.

## Regression gate for future changes

At minimum, preserve all existing ComboBox tests. When behavior changes intentionally, update tests and documentation together. A final delivery should distinguish actual executed DUnitX results from static review.
