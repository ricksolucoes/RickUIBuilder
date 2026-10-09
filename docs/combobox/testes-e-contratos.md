# Tests and Behavioral Contracts

> [English](testes-e-contratos.md) | [Português do Brasil](testes-e-contratos.pt-BR.md)

## Current source coverage and real execution

The current ZIP declares **260** `[Test]` methods across the test units. A real DUnitX report was supplied for this revision with **260 executed / 260 passed / 0 ignored / 0 failures / 0 errors** on 2026-10-08. `TRickUIBuilderFactoryCreateComboBoxTests` covers direct creation, items, DisplayText/Value, selection, placeholder, columns, callbacks, lifetime, Factory × Fluent parity, style/presentation, and override preservation.

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

## Evidence limits

The 260/260 run proves the revision and configuration that were actually executed. It does not guarantee the absence of defects outside test coverage, every platform, theme, DPI value, or future change. Visual changes still require target-platform inspection when applicable.

## Regression gate for future changes

At minimum, preserve all existing ComboBox tests. When behavior changes intentionally, update tests and documentation together. A final delivery should distinguish actual executed DUnitX results from static review.
