# Mapa de Arquitetura e Componentes

Este mapa acelera descoberta. **O código é a fonte de verdade**; quando a estrutura mudar, atualize este arquivo na mesma tarefa.

## 1. Project topology

```text
Rick.UI.Builde.groupproj
RickUIBuilder.dpk
RickUIBuilder.dproj
src/
tests/
sample/
docs/
AGENTS.md
.agents/
```

Projetos conhecidos:

- package/library: `RickUIBuilder.dpk` + `RickUIBuilder.dproj`;
- tests: `tests/RickUIBuilder.Test.dpr` + `tests/RickUIBuilder.Test.dproj`;
- Sample: `sample/RickUIBuilder.Sample.dpr` + `sample/RickUIBuilder.Sample.dproj`.

O `.dproj` identifica Delphi personality, mas isso sozinho não deve ser usado para afirmar a versão exata do compiler sem confirmação adicional.

## 2. Public entry points e shared contracts

```text
src/Rick.UIBuilder.pas
src/Rick.UIBuilder.Types.pas
src/Rick.UIBuilder.Interfaces.pas
```

### `Rick.UIBuilder.pas`

Facade estática/entrada pública. Mudanças aqui são API-facing.

### `Rick.UIBuilder.Types.pas`

Enums, records, configurações e constants públicos compartilhados. Não deve acumular implementação concreta de controles.

### `Rick.UIBuilder.Interfaces.pas`

Contratos públicos de builders e handles. Mudanças exigem análise de GUID, implementadores, consumidores e documentação.

## 3. Factory

```text
src/Rick.UIBuilder.Factory.pas
tests/src/Rick.UIBuilder.Tests.Factory.pas
```

Factory materializa controles/configuração quando o design do componente delega essa responsabilidade. Não assuma que todo componente novo precisa de factory-specific method sem verificar padrão real.

## 4. Label

```text
src/Rick.UIBuilder._Label.pas
tests/src/Rick.UIBuilder.Tests._Label.pas
```

Componente relativamente simples. Use como evidência de que componentes não precisam compartilhar a mesma quantidade de camadas.

## 5. Button

```text
src/Rick.UIBuilder.Button.pas
src/Rick.UIBuilder.Button.Handle.pas
src/Rick.UIBuilder.Button.HoverState.pas
tests/src/Rick.UIBuilder.Tests.Button.pas
```

Características relevantes:

- fluent builder;
- runtime handle;
- hover behavior/state;
- testes puros de chaining e integração FMX com host visual.

Mudanças em hover/lifetime exigem ler builder + Handle + HoverState + testes, não apenas uma unit.

## 6. Badge

```text
src/Rick.UIBuilder.Badge.pas
src/Rick.UIBuilder.Badge.Handle.pas
tests/src/Rick.UIBuilder.Tests.Badge.pas
```

Possui Handle runtime sem a mesma complexidade interna do ComboBox.

## 7. Divider

```text
src/Rick.UIBuilder.Divider.pas
tests/src/Rick.UIBuilder.Tests.Divider.pas
```

Mantém superfície pequena. Não introduza Handle/State/etc. por simetria sem requisito real.

## 8. ComboBox

```text
src/Rick.UIBuilder.ComboBox.pas
src/Rick.UIBuilder.ComboBox.Data.pas
src/Rick.UIBuilder.ComboBox.State.pas
src/Rick.UIBuilder.ComboBox.Style.pas
src/Rick.UIBuilder.ComboBox.Presentation.pas
src/Rick.UIBuilder.ComboBox.Virtualization.pas
src/Rick.UIBuilder.ComboBox.Handle.pas
tests/src/Rick.UIBuilder.Tests.ComboBox.pas
docs/combobox/**
```

Responsabilidades especializadas existem porque o comportamento justifica:

- Data: modelo lógico/filtro/seleção;
- State: estado de navegação/open;
- Style: resolução de style/presentation;
- Presentation: materialização visual;
- Virtualization: pool/render de rows;
- Handle: runtime orchestration/lifecycle;
- Builder: configuração fluente/preparação;
- Factory: materialização do controle fechado.

Antes de alterar ComboBox, leia `docs/combobox/README*` e os documentos específicos do domínio afetado.

## 9. Composition

```text
src/Rick.UIBuilder.Composition.pas
tests/src/Rick.UIBuilder.Tests.Composition.pas
```

Trata operações de composição. Mudanças devem considerar compatibilidade entre componentes e não vazar detalhes internos de um builder específico.

## 10. Facade e Types tests

```text
tests/src/Rick.UIBuilder.Tests.Facade.pas
tests/src/Rick.UIBuilder.Tests.Types.pas
```

Use para validar contratos de entrada/defaults compartilhados.

## 11. Sample

```text
sample/RickUIBuilder.Sample.dpr
sample/RickUIBuilder.Sample.dproj
sample/src/RickUIBuilderSample.Main.pas
sample/src/RickUIBuilderSample.Main.fmx
sample/Readme.md
```

Sample demonstra uso público e integração visual. Não substitui testes automatizados.

## 12. Dependency discovery workflow

Para um componente-alvo:

1. localizar entry point público;
2. localizar interface/type/config associado;
3. localizar builder principal;
4. localizar units auxiliares;
5. ler `uses` interface e implementation;
6. localizar Factory/Facade calls;
7. localizar testes;
8. localizar Sample/docs;
9. identificar lifecycle/event callbacks;
10. confirmar antes de alterar.

## 13. Regra para novos componentes

Considere camadas por responsabilidade, não por template fixo:

| Necessidade real | Abstração possível |
|---|---|
| configuração fluente | Builder |
| API runtime após Build | Handle |
| estado independente | State |
| transformação lógica de dados | Data/model |
| múltiplas apresentações | Presentation/strategy apropriada |
| grande lista/viewport | Virtualization |
| comportamento atrelado a lifecycle | Behavior/notification |
| contrato compartilhado | Interface/Types |

“Outro componente tem essa unit” não é justificativa arquitetural.

## 14. Trigger de atualização deste mapa

Atualize quando:

- unit for criada/removida/renomeada;
- responsabilidade migrar entre units;
- novo componente público for adicionado;
- testes/Sample/docs ganharem nova localização relevante;
- entry point público mudar.
