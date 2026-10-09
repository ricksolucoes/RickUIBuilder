# Especificação — listas no ComboBox Factory

**Projeto:** RickUIBuilder\
**Status:** contrato aprovado — implementação incremental em andamento\
**Escopo:** evolução da abordagem Factory do `ComboBox`\
**Plano técnico:** `specs/PLANO_TECNICO_COMBOBOX_FACTORY_RUNTIME.md`\
**Backlog:** `specs/BACKLOG_COMBOBOX_FACTORY_RUNTIME.md`

> Este documento define o contrato aprovado para a evolução do ComboBox Factory.
> O primeiro slice de implementação já introduz o contrato público, Items, seleção
> inicial e convergência básica do Fluent para a Factory. Style/Presentation,
> ampliação funcional dos Samples e quality gates completos permanecem pendentes.

## 1. Objetivo

Evoluir `TRickUIBuilderFactory.CreateComboBox` para materializar um ComboBox
funcional, com dados, seleção e runtime, sem obrigar o consumidor a utilizar a
API Fluent e sem expor classes internas de `Data`, `Handle`, `Presentation` ou
virtualização.

A solução deve reutilizar os contratos e o runtime já existentes sempre que
isso preservar as responsabilidades atuais e evitar uma segunda implementação
do ComboBox.

## 2. Baseline comprovado antes da implementação

Antes desta feature, no baseline analisado, a Factory pública expunha:

```delphi
class function CreateComboBox(AOwner: TComponent; AParent: TFmxObject;
  const AConfig: TRickUIBuilderComboBoxConfig; out ATextLabel: TLabel;
  out AArrow: TPath): TRectangle; static;
```

A implementação do baseline:

1. cria o `TRectangle` principal;
2. aplica a configuração visual do controle fechado;
3. cria o `TLabel` interno;
4. cria o `TPath` da seta;
5. devolve `ATextLabel` e `AArrow` como referências non-owning.

A chamada não recebe coleção de itens, colunas ou seleção e não materializa
popup/superfície de seleção.

No baseline, o Fluent complementava essa criação visual com `Data`,
`IRickUIBuilderComboBoxHandle`, `Behavior`, `Presentation`, virtualização,
seleção inicial, placeholder e callbacks.

## 3. Modelos de dados públicos preservados

A evolução não cria modelos paralelos exclusivos para Factory.

### 3.1. Item textual simples

`TRickUIBuilderComboBoxItem.Create(ADisplayText)` permanece como representação
pública para item em que `DisplayText` e `Value` usam o mesmo texto.

### 3.2. DisplayText + Value

`TRickUIBuilderComboBoxItem.Create(ADisplayText, AValue)` permanece como
representação pública para texto exibido e valor semântico independentes.

### 3.3. Item estruturado

`TRickUIBuilderComboBoxItem.Structured(ADisplayText, AValue, AColumns)` permanece
como representação pública para item com dados adicionais de coluna.

### 3.4. Colunas

`TRickUIBuilderComboBoxColumn` permanece como definição pública de coluna, com
os modos:

- `TRickUIBuilderComboBoxColumnSizeMode.Auto`;
- `TRickUIBuilderComboBoxColumnSizeMode.Fixed`;
- `TRickUIBuilderComboBoxColumnSizeMode.Proportional`.

## 4. Decisão de API pública

A operação pública existente será **evoluída**. Não será criado overload e não
será criada uma segunda operação pública para representar o ComboBox funcional.

A assinatura-alvo aprovada é:

```delphi
class function CreateComboBox(
  AOwner: TComponent;
  AParent: TFmxObject;
  const AConfig: TRickUIBuilderComboBoxConfig;
  const AOptions: TRickUIBuilderComboBoxFactoryOptions;
  out AHandle: IRickUIBuilderComboBoxHandle
): TRectangle; static;
```

A assinatura possui cinco parâmetros, permanecendo abaixo do baseline de
`Parameters = 6` adotado pelo projeto.

### 4.1. Mudança de compatibilidade aprovada

A alteração substitui os atuais parâmetros públicos:

```text
out ATextLabel
out AArrow
```

por:

```text
AOptions
out AHandle
```

`ATextLabel` e `AArrow` passam a ser detalhes de materialização interna do
ComboBox e não fazem mais parte do contrato público da operação funcional.

Essa mudança é deliberadamente aprovada para esta feature. Consumidores atuais
de `CreateComboBox` deverão ser migrados para a nova assinatura. O Fluent,
testes, Samples e documentação do próprio repositório fazem parte dessa
migração.

Não alterar GUIDs de interfaces existentes por causa dessa mudança.

## 5. `TRickUIBuilderComboBoxFactoryOptions`

Será criado um record público com responsabilidade exclusiva de transportar os
dados e o comportamento runtime necessários à criação Factory.

Contrato aprovado:

```delphi
TRickUIBuilderComboBoxFactoryOptions = record
  Items: TArray<TRickUIBuilderComboBoxItem>;
  Columns: TArray<TRickUIBuilderComboBoxColumn>;
  Placeholder: string;
  SelectionMode: TRickUIBuilderComboBoxInitialSelectionMode;
  ItemIndex: Integer;
  SelectedText: string;
  OnChange: TNotifyEvent;
  OnOpen: TNotifyEvent;
  OnClose: TNotifyEvent;
  OnCustomizeItem: TRickUIBuilderComboBoxCustomizeItemEvent;
  PreserveHeight: Boolean;
  PreserveItemHeight: Boolean;
  PreserveHorizontalPadding: Boolean;
  PreserveArrowSize: Boolean;
  class function Default: TRickUIBuilderComboBoxFactoryOptions; static;
end;
```

### 5.1. Unidade pública do record

O record deverá ser declarado em `Rick.UIBuilder.Factory`.

Motivo comprovado pelo grafo atual:

- `TRickUIBuilderComboBoxCustomizeItemEvent` e
  `IRickUIBuilderComboBoxHandle` pertencem a `Rick.UIBuilder.Interfaces`;
- `Rick.UIBuilder.Interfaces` já depende de `Rick.UIBuilder.Types`;
- fazer `Rick.UIBuilder.Types` depender de `Rick.UIBuilder.Interfaces`
  introduziria dependência inversa inadequada e risco de ciclo;
- `Rick.UIBuilder.Factory` pode depender de `Rick.UIBuilder.Interfaces` sem
  ciclo no grafo atual.

Não mover callbacks ou controles concretos para `Rick.UIBuilder.Types` apenas
para acomodar este record.

### 5.1.1. Metadados de override de estilo

A Factory passa a ser o ponto único de resolução de `RequestedStyleType` e
`PresentationMode.Auto`. O `StyleResolver` fornece defaults de estilo, mas não
pode apagar customizações já presentes no `AConfig` passado diretamente à
Factory.

Os quatro campos redefinidos atualmente pelo resolver são:

- `Height`;
- `ItemHeight`;
- `HorizontalPadding`;
- `ArrowSize`.

Para preservar o contrato histórico da Factory, qualquer valor desses campos
que seja diferente de `TRickUIBuilderComboBoxConfig.Default` deve prevalecer
sobre o default Desktop/Mobile automaticamente.

O record também transporta metadados para o caso que não pode ser inferido pela
comparação com o default-base:

- `PreserveHeight`;
- `PreserveItemHeight`;
- `PreserveHorizontalPadding`;
- `PreserveArrowSize`.

Esses flags são necessários quando o consumidor definiu explicitamente um valor
igual ao default-base e ainda assim quer preservá-lo contra um style que o
alteraria. Eles não representam uma segunda configuração visual.

A Factory deve executar a sequência:

```text
config solicitado
→ StyleResolver.Resolve
→ preservar automaticamente valores diferentes do config Default
→ reaplicar flags Preserve... para overrides explícitos iguais ao Default
→ criar Handle e visual com config efetivo
```

O Builder Fluent não deve continuar resolvendo style por conta própria.

### 5.2. Defaults aprovados

`TRickUIBuilderComboBoxFactoryOptions.Default` deverá produzir:

```text
Items           = vazio
Columns         = vazio
Placeholder     = ''
SelectionMode   = None
ItemIndex        = -1
SelectedText     = ''
OnChange         = nil
OnOpen           = nil
OnClose          = nil
OnCustomizeItem  = nil
PreserveHeight   = False
PreserveItemHeight = False
PreserveHorizontalPadding = False
PreserveArrowSize  = False
```

Nenhum callback deve ser obrigatório.

## 6. Seleção inicial

Será criado o enum público:

```delphi
TRickUIBuilderComboBoxInitialSelectionMode = (
  None,
  Index,
  Text
);
```

A seleção inicial não utilizará precedência implícita entre índice e texto.
`SelectionMode` determina qual campo é considerado.

### 6.1. `None`

- nenhuma seleção inicial é aplicada;
- o índice lógico permanece `-1`.

### 6.2. `Index`

- `ItemIndex = -1` representa ausência de seleção;
- índice válido seleciona o item correspondente;
- índice fora do intervalo não lança exception e mantém ausência de seleção.

### 6.3. `Text`

- `SelectedText` é procurado usando a mesma semântica case-insensitive já
  implementada no runtime atual;
- quando houver correspondência, a primeira ocorrência encontrada é
  selecionada;
- texto inexistente não lança exception e mantém ausência de seleção.

A implementação deverá reutilizar a semântica existente de seleção do
`TRickUIBuilderComboBoxData`/handle em vez de criar regras paralelas.

## 7. Placeholder

`TRickUIBuilderComboBoxFactoryOptions.Placeholder` representa o texto do
controle fechado quando não há seleção.

Ele permanece distinto de:

```delphi
TRickUIBuilderComboBoxConfig.SearchPlaceholder
```

que pertence ao campo de pesquisa da apresentação FullWindow.

## 8. Callbacks

A Factory funcional suportará os mesmos callbacks públicos já utilizados pelo
Fluent:

```text
OnChange
OnOpen
OnClose
OnCustomizeItem
```

A implementação deve configurar esses callbacks no runtime existente; não deve
criar uma segunda infraestrutura de eventos para a Factory.

`OnCustomizeItem` continua sujeito ao contrato atual de reciclagem do container
visual e ao índice lógico/source index fornecido pelo runtime.

## 9. Handle runtime

`CreateComboBox` continuará retornando o `TRectangle` principal e disponibiliza
por `out`:

```delphi
IRickUIBuilderComboBoxHandle
```

O handle existente permanece como boundary público de runtime. Não criar
interface paralela exclusiva para Factory.

Pelo handle, o consumidor poderá utilizar as operações runtime já existentes,
como consulta de seleção, seleção por índice/texto, adição de itens, abertura e
fechamento, conforme o contrato atual da interface.

## 10. Configuração visual, estilo e apresentação

`TRickUIBuilderComboBoxConfig` continua responsável por geometria, tipografia,
cores, paths, `RequestedStyleType`, `EffectiveStyleType` e
`PresentationMode`.

Esses conceitos não serão duplicados em `FactoryOptions`.

A Factory funcional deverá aplicar a mesma resolução de estilo utilizada pelo
Fluent, incluindo `Adaptive`, e preservar os overrides explícitos atualmente
mantidos pelo Builder.

`PresentationMode` continuará aceitando os modos públicos existentes:

```text
Auto
Anchored
Overlay
FullWindow
```

A Factory deverá utilizar o runtime/presentation existente para esses modos,
sem criar uma implementação de popup separada.

## 11. Boundary de materialização

A Factory passa a ser o ponto comum de materialização do ComboBox funcional,
assim como os builders dos componentes simples já delegam sua criação à
Factory.

Direção aprovada:

```text
Fluent Builder
    ↓
converte estado acumulado em Config + FactoryOptions
    ↓
TRickUIBuilderFactory.CreateComboBox
    ↓
Data + Handle + visual fechado + Behavior
    ↓
Presentation/Virtualization existentes quando necessárias
```

A implementação visual atual (`TRectangle` + `TLabel` + `TPath`) deve ser
preservada como detalhe interno reutilizável. A forma exata dessa extração é
decisão de implementação e deve respeitar alteração mínima e Method Toxicity.

Não duplicar `BuildCore` dentro da Factory e não manter dois pipelines runtime
independentes.

## 12. Lifetime e ownership

A Factory funcional deverá preservar o contrato de lifetime já comprovado no
Fluent atual.

### 12.1. Enquanto a árvore visual estiver viva

- o runtime permanece funcional mesmo que o consumidor não mantenha uma
  referência externa ao handle;
- o `Behavior` associado à árvore visual mantém a referência necessária ao
  handle;
- controles FMX continuam pertencendo ao `Owner`/`Parent` definidos pela
  materialização existente.

### 12.2. Quando o Parent/visual for destruído

- o handle deve ser destacado da árvore visual;
- `IsAttached` deve retornar `False`;
- o handle não deve tentar liberar controles owned externamente.

### 12.3. Handle externo sobrevivente

Quando uma referência externa ao handle sobreviver ao visual, o modelo lógico
que já é mantido pelo handle poderá continuar consultável conforme o contrato
atual, sem reanexar visual destruído e sem manter ponteiros dangling.

Não introduzir ciclos de reference counting.

## 13. Compatibilidade do Fluent

O Fluent continua sendo API pública e seu comportamento existente deve ser
preservado.

A implementação deverá migrar o `BuildCore` para usar a Factory funcional como
ponto de materialização, mas deve preservar:

- `Items`/`AddItem`/`AddStructuredItem`;
- `Column`;
- `ItemIndex`;
- `SelectedText`;
- `Placeholder`;
- callbacks;
- overrides explícitos de altura, item height e arrow size;
- resolução de estilo;
- `Build` e `BuildHandle`;
- lifetime e detach.

Antes de mover lógica compartilhada, testes de caracterização devem proteger
qualquer comportamento relevante ainda não coberto.

## 14. `EditBackgroundColor`

`TRickUIBuilderComboBoxConfig.EditBackgroundColor` existe na API pública, mas a
análise do baseline não confirmou consumidor runtime nem finalidade funcional
inequívoca para esse campo.

Decisão para esta feature:

- preservar o campo por compatibilidade;
- não atribuir comportamento novo por inferência;
- não utilizar o nome do campo como evidência de que ele pertence ao search
  field, porque `SearchFieldBackgroundColor` já existe com finalidade própria;
- registrar a questão como débito técnico separado.

**Finalidade funcional de `EditBackgroundColor`: Não confirmado.**

## 15. Estratégia de testes

A implementação deverá seguir contract-first e TDD quando executável.

### 15.1. Characterization/regressão

Preservar ou adicionar cobertura para:

- visual fechado atual;
- geometry/config aplicado;
- Fluent atual;
- overrides de estilo;
- lifetime já coberto.

### 15.2. Contrato Factory

Cobrir:

- defaults de `FactoryOptions`;
- criação com lista vazia;
- itens textuais;
- `DisplayText/Value`;
- itens estruturados;
- colunas `Auto`, `Fixed`, `Proportional`;
- `Visible` e `Alignment` de coluna;
- seleção `None`, `Index` e `Text`;
- índice inválido;
- texto inexistente;
- placeholder;
- callbacks configurados e ausentes;
- handle devolvido.

### 15.3. Integração FMX/lifetime

Cobrir:

- `Owner`/`Parent`;
- criação sem manter handle externamente;
- liberação da referência externa ao handle antes dos controls;
- destruição do Parent antes de uma referência externa ao handle;
- destruição de sibling irrelevante;
- destruição com presentation aberta quando o harness permitir;
- `IsAttached` após detach;
- ausência de double free/ownership invertido observável.

### 15.4. Paridade Factory × Fluent

Para entradas equivalentes, validar os contratos observáveis compartilhados,
como:

```text
Count
ItemIndex
SelectedText
SelectedValue
EffectiveStyleType quando observável no contrato testado
```

Não testar identidade de implementação interna.

## 16. Impacto nos Samples

Os Samples Factory só serão ampliados depois da implementação e dos testes do
runtime.

A quantidade final de exemplos não é fixada por esta spec; deve decorrer da
API final e das regras dos Concrete Example Pages.

A cobertura deverá demonstrar, quando implementado:

- lista textual;
- `DisplayText/Value`;
- item estruturado;
- colunas;
- seleção inicial;
- placeholder;
- style/presentation relevantes;
- callbacks;
- handle/runtime;
- exemplo completo cobrindo a superfície Factory aprovada.

`Content.Code` e `Runner.Render` devem continuar semanticamente equivalentes.
Não criar lista/popup manual para simular funcionalidade.

As regras locais dos Samples que atualmente limitam `ComboBox - Factory` ao
controle fechado deverão ser atualizadas somente depois que a capacidade real
existir, sem enfraquecer os quality gates.

## 17. Impacto documental

Após estabilização do código, revisar somente os documentos que divergirem do
runtime final, especialmente:

```text
README.md
README.pt-BR.md
docs/combobox/README.md
docs/combobox/README.pt-BR.md
docs/combobox/api-publica-e-configuracao.*
docs/combobox/arquitetura-e-dependencias.*
docs/combobox/customizacao-e-exemplos.*
docs/combobox/dados-selecao-e-filtro.*
docs/combobox/lifecycle-ownership-e-handle.*
docs/combobox/testes-e-contratos.*
```

A documentação deverá distinguir, quando necessário, o comportamento histórico
da antiga assinatura do contrato funcional final, sem afirmar capacidade antes
de ela existir no código.

## 18. Decisões registradas

| Tema | Opções consideradas | Decisão aprovada |
|---|---|---|
| Operação pública | overload / nova operação / alterar existente | alterar `CreateComboBox` existente |
| Parâmetros complexos | vários parâmetros soltos / agregador | `TRickUIBuilderComboBoxFactoryOptions` |
| Local do agregador | `Types` / `Interfaces` / `Factory` | `Rick.UIBuilder.Factory` |
| Itens | strings / tipo paralelo / item existente | `TArray<TRickUIBuilderComboBoxItem>` |
| Colunas | tipo paralelo / coluna existente | `TArray<TRickUIBuilderComboBoxColumn>` |
| Seleção | precedência implícita / modo explícito | `None`, `Index`, `Text` |
| Handle | novo handle / interface existente | `out IRickUIBuilderComboBoxHandle` |
| Placeholder | `Config` / options | `FactoryOptions.Placeholder` |
| Eventos | subset novo / eventos existentes | quatro callbacks existentes |
| Style/Presentation | duplicar em options / manter Config | manter em `TRickUIBuilderComboBoxConfig` |
| Runtime | segunda implementação / reutilização | reutilizar Data/Handle/Behavior/Presentation/Virtualizer |
| Lifetime | caller mantém handle / behavior existente | preservar lifetime do Fluent |
| `EditBackgroundColor` | inventar uso / remover / preservar | preservar sem novo comportamento; finalidade não confirmada |

## 19. Fora de escopo

Esta feature não autoriza:

- alterar GUIDs existentes;
- criar outra implementação de popup/lista;
- expor classes internas concretas do runtime;
- criar tipos Factory paralelos para item/coluna;
- refatorar componentes não relacionados;
- corrigir `EditBackgroundColor` sem evidência adicional;
- alterar o comportamento `-nodx` do executável Samples;
- simular a capacidade Factory nos Samples antes de implementá-la.

## 20. Quality gates

Antes de considerar a feature concluída:

1. contrato público final corresponde a esta spec ou a uma revisão explícita
   dela;
2. testes novos e regressões relevantes foram executados quando houver
   toolchain;
3. build real foi executado quando houver compilador compatível;
4. lifetime/ownership foi auditado separadamente;
5. Naming foi auditado nos `.pas` alterados;
6. `Length`, `Parameters`, `If Depth` e `Cyclomatic Complexity` foram avaliados
   conforme a normativa;
7. `Toxicity` composto somente é informado quando houver RAD Studio/CSV real;
8. Samples usam somente a capacidade realmente implementada;
9. documentação corresponde ao código final;
10. review final independente não possui pendência bloqueante.

Quando build, DUnitX ou Method Toxicity real não puderem ser executados, o
resultado deve ser registrado como **Não confirmado**, sem substituir execução
por afirmação estática.

## 21. Critérios de aceite

A capacidade somente será considerada implementada quando:

1. `CreateComboBox` aceitar `AConfig`, `AOptions` e devolver `AHandle` conforme o
   contrato aprovado;
2. itens textuais, `DisplayText/Value` e itens estruturados funcionarem pela
   Factory;
3. colunas funcionarem pela Factory;
4. seleção inicial `None`, `Index` e `Text` respeitar a semântica definida;
5. placeholder e callbacks aprovados estiverem integrados ao runtime existente;
6. `StyleType`/`PresentationMode` utilizarem a mesma infraestrutura do Fluent;
7. a lista/superfície de seleção funcionar sem exigir API Fluent do consumidor;
8. o handle público existente controlar o runtime Factory;
9. lifetime e detach estiverem protegidos por testes adequados;
10. o Fluent continuar funcional sobre o novo ponto comum de materialização;
11. não existir segunda implementação independente de Data/Presentation/
    Virtualization;
12. Samples e documentação refletirem somente a implementação final.

## 22. Próxima etapa

Com o contrato aprovado neste documento, a execução deve seguir
`specs/PLANO_TECNICO_COMBOBOX_FACTORY_RUNTIME.md` e
`specs/BACKLOG_COMBOBOX_FACTORY_RUNTIME.md`.

Nenhum código Delphi foi autorizado ou alterado por esta revisão documental.
