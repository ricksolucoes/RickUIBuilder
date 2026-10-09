# Plano Técnico por Sprints — ComboBox Factory Runtime

**Projeto:** RickUIBuilder\
**Feature:** ComboBox Factory funcional\
**Status:** implementação incremental em andamento\
**Base funcional:** `specs/combobox-factory-listas.pt-BR.md`\
**Backlog:** `specs/BACKLOG_COMBOBOX_FACTORY_RUNTIME.md`

> Este plano transforma o contrato aprovado em incrementos verificáveis. O
> Slice 1 possui build/teste informados pelo usuário e DUnitX comprovado por XML;
> o Slice 2 permanece sem execução confirmada. Method Toxicity real ainda não
> foi fornecido.

## 1. Objetivo técnico

Evoluir `TRickUIBuilderFactory.CreateComboBox` para materializar o runtime
completo do ComboBox usando os contratos e componentes internos já existentes,
e migrar o Fluent para essa Factory como ponto comum de materialização.

Estratégia:

```text
contract-first
→ characterization
→ FactoryOptions/assinatura
→ runtime Factory
→ convergência Fluent
→ lifetime/integration
→ Samples
→ documentação
→ quality gates
```

## 2. Fonte de verdade

- contrato: `specs/combobox-factory-listas.pt-BR.md`;
- Factory atual: `src/Rick.UIBuilder.Factory.pas`;
- Fluent atual: `src/Rick.UIBuilder.ComboBox.pas`;
- contratos públicos: `src/Rick.UIBuilder.Types.pas` e
  `src/Rick.UIBuilder.Interfaces.pas`;
- runtime: `src/Rick.UIBuilder.ComboBox.*.pas`;
- testes: `tests/src/Rick.UIBuilder.Tests.Factory.pas` e
  `tests/src/Rick.UIBuilder.Tests.ComboBox.pas`;
- Samples: `samples/src/Examples/ComboBox/Factory/` e regras locais;
- docs: `docs/combobox/`, `README.md`, `README.pt-BR.md`.

## 3. Comportamento a preservar

- visual fechado atual (`TRectangle` + `TLabel` + `TPath`);
- geometria e configuração já aplicadas pela Factory;
- API Fluent existente;
- seleção e Data atuais;
- `IRickUIBuilderComboBoxHandle`;
- presentation/virtualização existentes;
- lifecycle/detach do Fluent;
- overrides explícitos de `Height`, `ItemHeight` e `ArrowSize`;
- comportamento de `Adaptive` e `Auto` já resolvido pelo runtime atual;
- GUIDs existentes.

## 4. Alterações autorizadas

- alterar a assinatura pública de `CreateComboBox` conforme a spec;
- adicionar `TRickUIBuilderComboBoxFactoryOptions` e
  `TRickUIBuilderComboBoxInitialSelectionMode`;
- fazer `Rick.UIBuilder.Factory` depender de `Rick.UIBuilder.Interfaces`;
- internalizar `ATextLabel`/`AArrow` como detalhes da Factory;
- reutilizar `Data`, Handle concreto, Behavior, Presentation, Virtualizer e
  Style Resolver existentes;
- migrar `BuildCore` para delegar materialização à Factory;
- adicionar/ajustar testes;
- ampliar Samples somente depois do runtime validado;
- atualizar documentação correspondente.

## 5. Alterações proibidas

- overload ou segunda operação pública para esta feature;
- nova interface runtime exclusiva da Factory;
- segunda implementação de popup/lista/virtualização;
- mudança de GUID;
- significado inventado para `EditBackgroundColor`;
- cleanup/refatoração de componentes não relacionados;
- Sample que simule lista manualmente;
- afirmação de build/testes/toxicity sem execução real.

## 6. Riscos principais

| Risco | Evidência | Mitigação |
|---|---|---|
| ciclo de dependência | callback/handle estão em `Interfaces`; `Types` é base | declarar `FactoryOptions` em `Factory`; Factory pode usar `Interfaces` |
| regressão Fluent | `BuildCore` hoje monta Data/Handle antes da Factory visual | characterization + migração incremental |
| resolução de estilo duplicada | Builder hoje reaplica overrides após resolver style | testes de regressão antes de mover responsabilidade |
| lifetime quebrado | Behavior mantém handle vivo sem referência externa | testes FMX de detach/destruction |
| API excessiva | ComboBox possui items, columns, seleção e callbacks | um agregador + `out AHandle`; 5 parâmetros |
| duplicação de runtime | Factory atual só cria visual | reutilizar classes internas existentes |
| Samples desatualizados | regras atuais proíbem lista Factory | alterar regras somente após capacidade existir |
| dívida `EditBackgroundColor` | campo público sem consumidor comprovado | preservar sem novo comportamento |

# Sprint 0 — Baseline e characterization

### Objetivo

Fixar contratos atuais que serão tocados antes da mudança pública.

### Arquivos previstos

```text
tests/src/Rick.UIBuilder.Tests.Factory.pas
tests/src/Rick.UIBuilder.Tests.ComboBox.pas
```

Somente adicionar testes quando uma lacuna real de cobertura for confirmada.

### Verificações

- visual fechado atual;
- config aplicado;
- Fluent `Build`/`BuildHandle`;
- overrides de estilo;
- seleção existente;
- lifetime existente relevante.

### Gate

Nenhuma lógica compartilhada é movida sem contrato anterior protegido por teste
ou por evidência explícita já existente.

# Sprint 1 — Contrato público Factory

### Objetivo

Materializar os tipos e a assinatura aprovados sem ainda duplicar runtime.

### Arquivos previstos

```text
src/Rick.UIBuilder.Factory.pas
tests/src/Rick.UIBuilder.Tests.Factory.pas
```

### Alterações

1. adicionar `TRickUIBuilderComboBoxInitialSelectionMode`;
2. adicionar `TRickUIBuilderComboBoxFactoryOptions`;
3. implementar `Default`;
4. adicionar `Rick.UIBuilder.Interfaces` à interface da Factory;
5. alterar assinatura de `CreateComboBox` para `AConfig`, `AOptions` e
   `out AHandle`;
6. preservar temporariamente a materialização visual como helper privado
   coerente, se necessário para manter o slice compilável.

### Testes

- defaults do record;
- enum/semântica inicial;
- assinatura consumível pelos testes;
- retorno principal/handle segundo o contrato do slice.

### Gate

- `Parameters <= 6`;
- nenhum GUID alterado;
- nenhuma nova interface criada;
- nenhum tipo de item/coluna duplicado.

# Sprint 2 — Dados e seleção na Factory

### Objetivo

A Factory criar `Data` e aplicar `Items`, `Columns`, `Placeholder` e seleção
inicial usando o runtime existente.

### Arquivos previstos

```text
src/Rick.UIBuilder.Factory.pas
src/Rick.UIBuilder.ComboBox.Data.pas        (somente se necessário)
src/Rick.UIBuilder.ComboBox.Handle.pas      (somente se necessário)
tests/src/Rick.UIBuilder.Tests.Factory.pas
tests/src/Rick.UIBuilder.Tests.ComboBox.pas
```

### Casos

- lista vazia;
- textual;
- DisplayText/Value;
- estruturado;
- columns;
- `None`;
- `Index` válido/inválido;
- `Text` encontrado/inexistente;
- placeholder.

### Gate

Sem regra paralela de seleção fora de `Data`/Handle quando o runtime atual já
fornecer a semântica necessária.

# Sprint 3 — Runtime, callbacks e lifetime

### Objetivo

Completar materialização com Handle, Behavior, callbacks, Presentation e
Virtualization existentes.

### Arquivos previstos

```text
src/Rick.UIBuilder.Factory.pas
src/Rick.UIBuilder.ComboBox.Handle.pas       (somente se necessário)
src/Rick.UIBuilder.ComboBox.Behavior.pas     (somente se necessário)
src/Rick.UIBuilder.ComboBox.Presentation.pas (somente se necessário)
src/Rick.UIBuilder.ComboBox.Virtualization.pas (somente se necessário)
tests/src/Rick.UIBuilder.Tests.Factory.pas
tests/src/Rick.UIBuilder.Tests.ComboBox.pas
```

### Casos

- `OnChange`;
- `OnOpen`;
- `OnClose`;
- `OnCustomizeItem`;
- criação sem manter handle externamente;
- destruição Parent antes de handle externo;
- liberação de handle externo antes dos controls;
- sibling irrelevante;
- `IsAttached` após detach;
- presentation aberta durante destruição, quando test harness permitir.

### Gate

Factory não contém segunda implementação de popup/virtualização e não inverte
ownership dos controls.

# Sprint 4 — Convergência do Fluent

### Objetivo

Migrar `TRickUIBuilderComboBoxBuilder.BuildCore` para usar a Factory funcional
como ponto comum de materialização.

### Arquivos previstos

```text
src/Rick.UIBuilder.ComboBox.pas
src/Rick.UIBuilder.Factory.pas
tests/src/Rick.UIBuilder.Tests.ComboBox.pas
```

### Pontos críticos

- converter `FItems`, `FColumns`, placeholder, seleção e callbacks em
  `FactoryOptions`;
- preservar `Build` e `BuildHandle`;
- preservar flags de override (`Height`, `ItemHeight`, `ArrowSize`);
- impedir resolução dupla ou divergente de style;
- não duplicar configuração de eventos.

### Gate

Testes de paridade/regressão do Fluent permanecem verdes quando executáveis.

# Sprint 5 — Style e Presentation parity

### Objetivo

Confirmar que Factory e Fluent usam a mesma resolução de `StyleType` e
`PresentationMode`.

### Casos

- Desktop;
- Mobile quando testável;
- Adaptive;
- Custom;
- Auto;
- Anchored;
- Overlay;
- FullWindow.

### Gate

Não existir `case` paralelo na Factory replicando regras que já pertencem ao
Style Resolver/Presentation.

# Sprint 6 — Samples Factory

### Dependência

Sprints 1–5 estabilizados.

### Objetivo

Demonstrar a API Factory real, sem simulação.

### Arquivos previstos

```text
samples/src/App/RickUIBuilder.Samples.App.Types.pas
samples/src/Examples/ComboBox/Factory/RickUIBuilder.Samples.Example.ComboBox.Factory.pas
samples/src/Examples/ComboBox/Factory/RickUIBuilder.Samples.Example.ComboBox.Factory.Content.pas
samples/src/Examples/ComboBox/Factory/RickUIBuilder.Samples.Example.ComboBox.Factory.Runner.pas
samples/AGENTS.md e/ou regras locais afetadas, somente onde a limitação antiga estiver codificada
```

### Cobertura

A quantidade de exemplos será derivada da API final. Deve cobrir os grupos
funcionais aprovados e manter um exemplo `Completo` exaustivo segundo as regras
dos Samples.

### Gate

- `Content.Code` e `Runner.Render` semanticamente equivalentes;
- `ClearResult` preservado;
- nenhum popup/lista manual;
- ownership do `ResultHost` preservado;
- callbacks com lifetime válido.

# Sprint 7 — Documentação

### Objetivo

Sincronizar docs somente com o código estabilizado.

### Arquivos candidatos

```text
README.md
README.pt-BR.md
docs/combobox/*.md
specs/combobox-factory-listas.pt-BR.md
```

### Regras

- documentar a nova assinatura real;
- explicar FactoryOptions e seleção;
- atualizar exemplos;
- retirar afirmações de visual-only quando deixarem de ser verdade;
- preservar distinções que ainda forem verdadeiras;
- `EditBackgroundColor` permanece não confirmado até evidência em contrário.

# Sprint 8 — Quality gates

### Auditorias

- API/arquitetura;
- Delphi Code Review;
- Contract & Lifetime;
- DelphiNamingGuard;
- Method Toxicity/static quality;
- Documentation Auditor;
- Samples auditors aplicáveis;
- Final Quality Gate.

### Validações

- DUnitX focado;
- suíte completa quando disponível;
- build package/Samples/tests quando disponível;
- BOM UTF-8 dos `.pas` modificados;
- Method Toxicity real somente com RAD Studio/CSV;
- diff final sem cleanup fora do escopo.

## 7. `-nodx` no README

A melhoria documental do switch é independente da implementação do ComboBox e
pode ser entregue antes do código da feature porque o comportamento já existe
no `samples/RickUIBuilder.Samples.dpr`.

Documentar em `README.md` e `README.pt-BR.md`:

- `-nodx` define `FMX.Types.GlobalUseDX := False` antes de
  `Application.Initialize`;
- uso indicado para cenários de acesso remoto com problema de captura/exibição
  de controles FMX runtime quando DirectX está ativo;
- detecção case-insensitive (`-nodx`, `-NODX` e equivalentes);
- sem o switch, o backend padrão do FMX é preservado;
- o switch pertence ao executável Samples, não à biblioteca.

## 8. Entrega esperada por execução

Seguir `AGENTS.md`: entregar somente arquivos efetivamente criados/modificados,
com caminhos relativos preservados. Não incluir fontes apenas consultadas.
