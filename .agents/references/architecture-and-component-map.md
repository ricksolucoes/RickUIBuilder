# Mapa de Arquitetura e Componentes

Este mapa acelera descoberta. **O código é a fonte de verdade**; quando a estrutura mudar, atualize este arquivo na mesma tarefa.

## 1. Project topology

```text
Rick.UI.Builde.groupproj
RickUIBuilder.dpk
RickUIBuilder.dproj
src/
tests/
samples/
docs/
AGENTS.md
.agents/
```

Projetos conhecidos:

- package/library: `RickUIBuilder.dpk` + `RickUIBuilder.dproj`;
- tests: `tests/RickUIBuilder.Test.dpr` + `tests/RickUIBuilder.Test.dproj`;
- Samples: `samples/RickUIBuilder.Samples.dpr` + `samples/RickUIBuilder.Samples.dproj`.

O `.dproj` identifica Delphi personality, mas isso sozinho não deve ser usado para afirmar a versão exata do compiler sem confirmação adicional.

## 2. Public entry points e shared contracts

```text
src/Rick.UIBuilder.pas
src/Rick.UIBuilder.Types.pas
src/Rick.UIBuilder.Interfaces.pas
src/Edit/Rick.UIBuilder.Edit.Interfaces.pas
src/Edit/Rick.UIBuilder.Edit.Types.pas
```

### `Rick.UIBuilder.pas`

Facade estática/entrada pública. Mudanças aqui são API-facing.

### `Rick.UIBuilder.Types.pas`

Enums, records, configurações e constants públicos compartilhados. Não deve acumular implementação concreta de controles.

### `Rick.UIBuilder.Interfaces.pas`

Boundary compartilhado de contratos públicos do framework. Mudanças exigem análise de GUID, implementadores, consumidores e documentação.

Não use essa regra genérica para mover as interfaces da nova arquitetura do `Edit`: esse domínio já possui boundary contratual específico.

### `src/Edit/Rick.UIBuilder.Edit.Interfaces.pas`

Contrato oficial da nova arquitetura do `Edit`. As interfaces existentes nessa unit são imutáveis por padrão durante implementação; a implementação deve se adaptar a elas. Mudança contratual exige solicitação explícita do usuário na tarefa atual.

### `src/Edit/Rick.UIBuilder.Edit.Types.pas`

Boundary de records, enums e demais types compartilhados da nova arquitetura do `Edit`. Types de domínio do novo `Edit` não devem ser declarados dentro das units concretas de implementação.

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
docs/label/**
```

Componente relativamente simples. Use como evidência de que componentes não precisam compartilhar a mesma quantidade de camadas. Antes de alterar Label, leia `docs/label/README*` e o documento específico do aspecto afetado.

## 5. Button

```text
src/Rick.UIBuilder.Button.pas
src/Rick.UIBuilder.Button.Handle.pas
src/Rick.UIBuilder.Button.HoverState.pas
src/Rick.UIBuilder.Button.HoverBehavior.pas
tests/src/Rick.UIBuilder.Tests.Button.pas
docs/button/**
```

Características relevantes:

- fluent builder;
- runtime handle;
- hover behavior/state;
- testes puros de chaining e integração FMX com host visual.

Mudanças em hover/lifetime exigem ler builder + Handle + HoverState + HoverBehavior + testes, não apenas uma unit. Antes de alterar Button, leia `docs/button/README*` e o documento específico do domínio afetado.

## 6. Badge

```text
src/Rick.UIBuilder.Badge.pas
src/Rick.UIBuilder.Badge.Handle.pas
tests/src/Rick.UIBuilder.Tests.Badge.pas
docs/badge/**
```

Possui Handle runtime sem a mesma complexidade interna do ComboBox. A Factory materializa inicialmente o formato pill; o Fluent Builder tem `Pill=False` por padrão e pode substituir esse raio por `CornerRadius`. Antes de alterar Badge, leia `docs/badge/README*` e o documento específico do aspecto afetado.

## 7. Divider

```text
src/Rick.UIBuilder.Divider.pas
tests/src/Rick.UIBuilder.Tests.Divider.pas
docs/divider/**
```

Mantém superfície pequena. `Width` representa o comprimento lógico: Horizontal usa `Width × Thickness`; Vertical usa `Thickness × Width`. Não introduza Handle/State/etc. por simetria sem requisito real. Antes de alterar Divider, leia `docs/divider/README*` e o documento específico do aspecto afetado.

## 8. ComboBox

```text
src/Rick.UIBuilder.ComboBox.pas
src/Rick.UIBuilder.ComboBox.Data.pas
src/Rick.UIBuilder.ComboBox.State.pas
src/Rick.UIBuilder.ComboBox.Style.pas
src/Rick.UIBuilder.ComboBox.Behavior.pas
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
- Behavior: lifetime do runtime, observação do container e solicitação de detach sem depender da classe concreta do Handle;
- Presentation: materialização visual;
- Virtualization: pool/render de rows;
- Handle: runtime orchestration e coordenação do detach visual;
- Builder: configuração fluente/preparação;
- Factory: materialização do controle fechado.

Antes de alterar ComboBox, leia `docs/combobox/README*` e os documentos específicos do domínio afetado.

## 9. Edit

O `Edit` está em migração arquitetural. O legado permanece no repositório enquanto a nova implementação não for validada pelo usuário.

### 9.1 Edit legado

```text
src/Rick.UIBuilder.Edit.pas
src/Rick.UIBuilder.Edit.Input.pas
src/Rick.UIBuilder.Edit.Handle.pas
src/Rick.UIBuilder.Edit.Behavior.pas
tests/src/Rick.UIBuilder.Tests.Edit.pas
docs/edit/**
```

O Edit legado é exposto pelo Fluent Builder no estado atualmente documentado: `TRickUIBuilder.Edit` retorna `IRickUIBuilderEdit`, e `Build` retorna `IRickUIBuilderEditHandle`. A Factory pública não expõe `CreateEdit`. Mudanças no legado permanecem fora do escopo da nova arquitetura salvo solicitação explícita.

### 9.2 Nova arquitetura do Edit

Já pertencem ao `main`:

```text
src/Edit/Rick.UIBuilder.Edit.Interfaces.pas
src/Edit/Rick.UIBuilder.Edit.Types.pas
```

Decisões de arquitetura já estabelecidas:

- `Rick.UIBuilder.Edit.Interfaces.pas` é o contrato oficial e não deve ser alterado para acomodar implementação;
- `Rick.UIBuilder.Edit.Types.pas` concentra records, enums e demais types compartilhados do novo domínio;
- as 28 interfaces públicas devem possuir 28 classes concretas correspondentes em 28 units exclusivas de implementação;
- helpers internos não entram na contagem das 28 implementações públicas e não devem virar interfaces por simetria;
- quando uma implementação especializada precisar do contexto de outra interface, use o contrato/origem existente por Dependency Injection quando aplicável; não crie getter, interface ou caminho alternativo apenas por conveniência;
- a nova implementação não deve depender das units legadas do `Edit`;
- a migração só substitui o legado depois da validação final do usuário.

A organização física detalhada é governada por [`interface-implementation-unit-policy.md`](interface-implementation-unit-policy.md); preservação contratual por [`interface-contract-preservation-policy.md`](interface-contract-preservation-policy.md). Consulte também `docs/edit/arquitetura-e-manutencao*`.

Não trate units de implementação encontradas em pacotes locais/temporários como integrantes do `main` sem confirmar sua presença no repositório.

## 10. Composition

```text
src/Rick.UIBuilder.Composition.pas
tests/src/Rick.UIBuilder.Tests.Composition.pas
```

Trata operações de composição. Mudanças devem considerar compatibilidade entre componentes e não vazar detalhes internos de um builder específico.

## 11. Facade e Types tests

```text
tests/src/Rick.UIBuilder.Tests.Facade.pas
tests/src/Rick.UIBuilder.Tests.Types.pas
```

Use para validar contratos de entrada/defaults compartilhados.

## 12. Samples

```text
samples/RickUIBuilder.Samples.dpr
samples/RickUIBuilder.Samples.dproj
samples/src/App/**
samples/src/Home/**
samples/src/Components/**
samples/src/Examples/**
docs/samples/**
```

O Samples atual é um catálogo component-first. Text / Label, Button, Badge, Divider e ComboBox possuem páginas Factory + Fluent Builder; Edit possui somente Fluent Builder porque `Factory.CreateEdit` não existe. As Sample Pages concretas seguem a divisão Page / Content / Runner e herdam de `TExampleCommon`. Composition é API pública, mas ainda não integra essa navegação. Sample demonstra uso público e integração visual; não substitui testes automatizados.

## 13. Dependency discovery workflow

Para um componente-alvo:

1. localizar entry point público;
2. localizar interface/type/config associado e confirmar o boundary oficial do domínio;
3. localizar builder principal;
4. localizar units auxiliares;
5. ler `uses` interface e implementation;
6. localizar Factory/Facade calls;
7. localizar testes;
8. localizar Sample/docs;
9. identificar lifecycle/event callbacks;
10. confirmar antes de alterar.

## 14. Regra para novos componentes

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

A regra 1 interface → 1 implementação → 1 unit é uma decisão específica do novo `Edit`; não a replique automaticamente em outros domínios.

## 15. Trigger de atualização deste mapa

Atualize quando:

- unit for criada/removida/renomeada;
- responsabilidade migrar entre units;
- novo componente público for adicionado;
- testes/Sample/docs ganharem nova localização relevante;
- entry point público mudar;
- um domínio ganhar boundary contratual específico.
