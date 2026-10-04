# Especificação da Sample Page Base

## Status

**Sample Page Base implementada e sete páginas concretas disponíveis: Text / Label - Factory, Text / Label - Fluent Builder, Button - Factory, Button - Fluent Builder, Badge - Factory, Badge - Fluent Builder e Divider - Factory.**

Este documento fixa a intenção visual, a sequência estrutural, os limites de responsabilidade e o comportamento da base das páginas de exemplos do `RickUIBuilder.Samples`.

A implementação comum é coordenada por `RickUIBuilder.Samples.Example.Common`, com classe abstrata `TExampleCommon`. A família é dividida por responsabilidade em units próprias para header, navegação, seletor de visualização, painel de código, painel de resultado, ícones e estilo. As derivadas reais atuais são `TExampleTextLabelFactory`, `TExampleTextLabelFluent`, `TExampleButtonFactory`, `TExampleButtonFluent`, `TExampleBadgeFactory`, `TExampleBadgeFluent` e `TExampleDividerFactory`; os demais destinos permanecem futuros.

## Papel na navegação

A Sample Page Base pertence à terceira camada do fluxo do Samples:

```text
HOME
  │
  │ escolhe um componente
  ▼
COMPONENT PAGE
  │
  │ escolhe uma abordagem suportada
  ├─────────────────────┐
  ▼                     ▼
Factory             Fluent Builder
  │                     │
  └──────────┬──────────┘
             ▼
      SAMPLE PAGE CONCRETA
             ▲
             │ herda
             │
       SAMPLE PAGE BASE
```

A Component Page continua sendo somente o divisor entre abordagens. A Sample Page concreta é onde os samples reais são apresentados e executados; Text / Label, Button e Badge possuem Factory e Fluent Builder concretos, enquanto Divider possui Factory concreto nesta etapa.

## Regra de tamanho

A Sample Page deve permanecer **sempre menor que a Home**.

No baseline atual, a Home possui referência de `644 × 534`. Portanto, toda Sample Page deve respeitar simultaneamente:

```text
SamplePage.ClientWidth  < 644
SamplePage.ClientHeight < 534
```

A implementação atual define `620 × 510`, mantendo simultaneamente `620 < 644` e `510 < 534`.

A navegação lateral utiliza `TVertScrollBox`. A superfície de código utiliza `TMemo` read-only e selecionável, com `WordWrap = False` e scrollbars em comportamento AutoHide: a rolagem pertence ao overflow real do conteúdo, sem canvas artificialmente maior que o viewport. Não aumentar a Sample Page acima da Home e não reduzir tipografia para esconder clipping.


## Implementação atual da base

A infraestrutura comum é separada fisicamente para evitar que a classe-base concentre toda a construção visual:

```text
src/Examples/Common/
├── RickUIBuilder.Samples.Example.Common.pas
│   └── TExampleCommon: orquestra a página e expõe a API protegida
├── RickUIBuilder.Samples.Example.Common.Header.pas
│   └── TExampleHeader: header, contexto do pai e ação visual de retorno
├── RickUIBuilder.Samples.Example.Common.Navigation.pas
│   ├── TExampleNavigation: sidebar rolável e seleção visual
│   └── TExampleNavigationItem: item visual reutilizável
├── RickUIBuilder.Samples.Example.Common.View.Selector.pas
│   └── TExampleViewSelector: alternância funcional Código Delphi/Resultado
├── RickUIBuilder.Samples.Example.Common.Code.Panel.pas
│   └── TExampleCodePanel: código read-only/selecionável, scroll sob demanda e cópia integral
├── RickUIBuilder.Samples.Example.Common.Result.Panel.pas
│   └── TExampleResultPanel: título, superfície e ResultHost
├── RickUIBuilder.Samples.Example.Common.Icons.pas
│   └── geometria vetorial comum
└── RickUIBuilder.Samples.Example.Common.Style.pas
    └── geometria e paleta compartilhadas
```

Essa separação é estrutural e não cria regras específicas de componente. `TExampleCommon` coordena os controles acima; não reimplementa internamente header, navegação, seletor, painel de código ou painel de resultado.

`RickUIBuilder.Samples.App.Types` fornece atualmente os enums compartilhados usados por esta camada: `TExampleView` representa a seleção `Código Delphi`/`Resultado`, `TTextLabelFactoryExample` identifica Text / Label - Factory, `TTextLabelFluentExample` identifica Text / Label - Fluent Builder, `TButtonFactoryExample` identifica Button - Factory, `TButtonFluentExample` identifica Button - Fluent Builder, `TBadgeFactoryExample` identifica Badge - Factory, `TBadgeFluentExample` identifica Badge - Fluent Builder e `TDividerFactoryExample` identifica Divider - Factory. O seletor, as pages concretas, Contents e Runners consomem esses tipos sem redeclará-los.

A base implementada expõe pontos de extensão protegidos para as derivadas:

```text
ConfigurePage(parent, title, subtitle)
AddNavigationItem(caption)
SelectNavigationItem(item)
SetExampleIdentity(title, description)
SetCodeText(code)
ClearResult
ResultHost
```

Esses pontos de extensão não materializam componente ou abordagem. `AddNavigationItem` cria somente o item visual; a derivada associa sua ação. `SelectNavigationItem` controla apenas o estado visual selecionado. `ResultHost` é o container estável, owned por `TExampleResultPanel`, onde a derivada anexa os controles reais do resultado; a derivada não deve liberar nem substituir esse host. `ClearResult` remove somente os filhos visuais antes da substituição do exemplo, preservando a infraestrutura para a próxima materialização.

`Código Delphi` e `Resultado` são opções clicáveis coordenadas por `TExampleViewSelector`. Exatamente uma view fica ativa: `Código Delphi` é o estado inicial; selecionar `Resultado` oculta o código e exibe somente o painel de resultado, e selecionar `Código Delphi` executa a alternância inversa.

## Primeira página concreta — Text / Label - Factory

A primeira implementação derivada valida a base sem transformá-la em catálogo global:

```text
src/Examples/TextLabel/Factory/
├── RickUIBuilder.Samples.Example.TextLabel.Factory.pas
├── RickUIBuilder.Samples.Example.TextLabel.Factory.Content.pas
└── RickUIBuilder.Samples.Example.TextLabel.Factory.Runner.pas
```

Responsabilidades:

- `Factory.pas`: coordena a page, itens de navegação e seleção;
- `Factory.Content.pas`: contém somente textos/snippets dos exemplos Factory de Text / Label;
- `Factory.Runner.pas`: materializa o resultado real com `TRickUIBuilderFactory.CreateText`.

Cobertura atual da API pública Factory de Text / Label:

| Exemplo | Cobertura |
|---|---|
| `Básico` | `CreateText`, `AOwner`, `AParent`, `AText` e `TRickUIBuilderTextConfig.Default` |
| `Geometria` | `Left`, `Top`, `Width`, `Height` |
| `Tipografia` | `FontSize`, `FontColor`, `Bold` |
| `Alinhamento` | `HorizontalAlign` |
| `Completo` | composição de todos os campos públicos atuais do record |

Ao trocar a seleção, a page executa a sequência `SelectNavigationItem → SetExampleIdentity → SetCodeText → ClearResult → Runner.Render`. O Runner usa `ResultHost` como Owner e Parent do `TLabel`, mantendo o resultado dentro da árvore visual que será limpa antes da próxima execução.

`TTextAlign` utilizado pelos exemplos de alinhamento exige `FMX.Types` explicitamente no `uses`; `TAlphaColors` exige `System.UITypes`. Essa dependência é parte do gate Delphi do Samples.

## Página concreta — Text / Label - Fluent Builder

A implementação Fluent reutiliza a mesma base e preserva a separação entre coordenação, conteúdo e execução:

```text
src/Examples/TextLabel/Fluent/
├── RickUIBuilder.Samples.Example.TextLabel.Fluent.pas
├── RickUIBuilder.Samples.Example.TextLabel.Fluent.Content.pas
└── RickUIBuilder.Samples.Example.TextLabel.Fluent.Runner.pas
```

Cobertura da API pública `TRickUIBuilder.Label_` / `IRickUIBuilderLabel`:

| Exemplo | Cobertura |
|---|---|
| `Básico` | `Label_`, `Text`, `Build` |
| `Geometria` | `Position`, `Size` |
| `Layout` | `Anchors`, `Margin`, `Padding`; spacings com Left/Top/Right/Bottom explícitos |
| `Tipografia` | `FontFamily`, `FontSize`, `FontColor`, `Bold`, `Italic` |
| `Alinhamento` | `Align`, `VerticalAlign` |
| `Fluxo de texto` | `WordWrap`, `Trimming` |
| `Estado` | `Opacity`, `Visible`, `HitTest`, `Tag` |
| `Completo` | todos os métodos públicos configuráveis de `IRickUIBuilderLabel`, incluindo `Build`; `Margin` e `Padding` usam `TRickUIBuilderSpacing.Create` com os quatro lados explícitos |

O exemplo `Completo` é deliberadamente exaustivo. Para Text / Label Factory, atribui todos os campos de `TRickUIBuilderTextConfig`; para Text / Label Fluent, chama todos os métodos configuráveis de `IRickUIBuilderLabel`; para Button Factory, atribui todos os nove campos de `TRickUIBuilderButtonConfig`; para Button Fluent, os dois exemplos completos chamam os 23 métodos configuráveis de `IRickUIBuilderButton`, usando `Build` no direto e `BuildHandle` na variante por interfaces; para Badge Factory, atribui os sete campos públicos de `TRickUIBuilderBadgeConfig`; para Badge Fluent, os dois exemplos completos chamam os quinze métodos configuráveis de `IRickUIBuilderBadge`, usando `IRickUIBuilderBadgeHandle` na variante por interfaces; para Divider Factory, atribui os quatro campos públicos de `TRickUIBuilderDividerConfig`. Se a API ou um record público usado por esses exemplos ganhar nova opção configurável, snippet, Runner e matriz devem ser atualizados em conjunto.

## Página concreta — Button - Factory

Button Factory segue a estrutura física por componente e abordagem:

```text
src/Examples/Button/Factory/
├── RickUIBuilder.Samples.Example.Button.Factory.pas
├── RickUIBuilder.Samples.Example.Button.Factory.Content.pas
└── RickUIBuilder.Samples.Example.Button.Factory.Runner.pas
```

Cobertura da API pública `TRickUIBuilderFactory.CreateButton`:

| Exemplo | Cobertura |
|---|---|
| `Básico` | overload simples, `ACaption` e `TRickUIBuilderButtonConfig.Default` |
| `Geometria` | `Left`, `Top`, `Width`, `Height` |
| `Cores` | `FillColor`, `BorderColor`, `TextColor` |
| `Tipografia` | `FontSize` |
| `Identificação` | `Tag` e leitura pelo `TRectangle` retornado |
| `Caption interno` | overload com `out ATextLabel` e alteração pela referência non-owning |
| `Clique` | `OnClick` configurado no `TRectangle` retornado; o clique muda a cor do próprio Button |
| `Completo` | todos os nove campos públicos de `TRickUIBuilderButtonConfig` e overload com `out ATextLabel` |

`OnClick` não é campo de `TRickUIBuilderButtonConfig`: o exemplo interativo demonstra a propriedade pública do `TRectangle` retornado pela Factory. O helper que recebe o evento é owned pelo próprio Button e é liberado com o resultado quando `ClearResult` substitui o sample.

## Página concreta — Button - Fluent Builder

Button Fluent segue `src/Examples/Button/Fluent/` com Page, Content e Runner separados. A página possui doze exemplos: `Básico`, `Interface`, `Geometria`, `Layout`, `Aparência`, `Tipografia`, `Estado`, `Hover`, `Clique`, `Resultado`, `Completo - Direto` e `Completo - Interfaces`. O foco principal é `TRickUIBuilder.Button`/`IRickUIBuilderButton`; `IRickUIBuilderButtonHandle`, `IRickUIBuilderButtonHoverState` e `TRickUIBuilderSpacing` aparecem somente quando necessários à API principal. `Clique` e `Hover` são executáveis. `Completo - Direto` cobre os 23 métodos configuráveis e usa `Build`; `Completo - Interfaces` cobre a mesma configuração mantendo `IRickUIBuilderButton`, usa `BuildHandle` e demonstra também as duas interfaces secundárias do Button.

## Página concreta — Badge - Factory

Badge Factory segue `src/Examples/Badge/Factory/` com Page, Content e Runner separados. A página possui sete exemplos: `Básico`, `Geometria`, `Cores`, `Tipografia`, `Texto interno`, `Construção em etapas` e `Completo`. `CreateBadge` é a operação principal; o exemplo `Texto interno` demonstra o `TRectangle` retornado e `out ATextLabel`, enquanto `Construção em etapas` mostra as APIs públicas auxiliares `CreateBadgeContainer` e `BuildBadgeTextConfig`. `Completo` atribui explicitamente `Left`, `Top`, `Width`, `Height`, `BackgroundColor`, `TextColor` e `FontSize`.

## Página concreta — Badge - Fluent Builder

Badge Fluent segue `src/Examples/Badge/Fluent/` com Page, Content e Runner separados. A página possui onze exemplos: `Básico`, `Interface`, `Geometria`, `Forma`, `Layout`, `Aparência`, `Tipografia`, `Estado`, `Resultado`, `Completo - Direto` e `Completo - Interfaces`. O foco principal é `TRickUIBuilder.Badge`/`IRickUIBuilderBadge`; `IRickUIBuilderBadgeHandle` e `TRickUIBuilderSpacing` aparecem somente quando exigidos pela API principal. `Forma` demonstra separadamente `Pill(True)` e `Pill(False) + CornerRadius`; os dois completos usam `Pill(False)` para que `CornerRadius` permaneça efetivo e cobrem os quinze métodos configuráveis. A variante por interfaces mantém `IRickUIBuilderBadge` e recebe `IRickUIBuilderBadgeHandle` de `Build`.

## Página concreta — Divider - Factory

Divider Factory segue `src/Examples/Divider/Factory/` com Page, Content e Runner separados. A página possui quatro exemplos: `Básico`, `Geometria`, `Cor` e `Completo`. `CreateDivider` é a operação principal; `Geometria` demonstra `Left`, `Top` e `Width`, `Cor` demonstra `Color`, e `Completo` atribui explicitamente os quatro campos públicos de `TRickUIBuilderDividerConfig`. A altura fixa de 1 px, `HitTest = False` e ausência de Stroke pertencem ao comportamento da Factory e não são apresentados como opções configuráveis do record.

## Textframe normativo da tela-base

O textframe abaixo fixa **ordem, agrupamento e hierarquia**. O Design System pode ajustar tokens visuais compatíveis, mas não deve mover, remover ou reordenar os blocos sem nova decisão explícita. Código e resultado nunca aparecem simultaneamente na mesma view.

```text
┌────────────────────────────────────────────────────────────────────┐
│  ←   {Componente pai}                                              │
├────────────────────────────────────────────────────────────────────┤
│                                                                    │
│  {Componente} - {Abordagem}                                        │
│  {Descrição curta da página/abordagem}                             │
│                                                                    │
├───────────────────┬────────────────────────────────────────────────┤
│                   │                                                │
│  {Categoria A}    │  {Título do exemplo selecionado}              │
│  {Categoria B}    │  {Descrição curta do exemplo}                 │
│  {Categoria C}    │                                                │
│  {Categoria D}    │  [ Código Delphi ] [ Resultado ]              │
│  ...              │                                                │
│                   │  ┌──────────────────────────────────────────┐  │
│                   │  │                                          │  │
│                   │  │  VIEW ATIVA                              │  │
│                   │  │  Código OU Resultado                     │  │
│                   │  │                                          │  │
│                   │  └──────────────────────────────────────────┘  │
│                   │                                                │
└───────────────────┴────────────────────────────────────────────────┘
```

### Estado `Código Delphi`

```text
[ Código Delphi ] [ Resultado ]

┌──────────────────────────────────────────────────┐
│                               [ Copiar código ]  │
│ código Delphi do exemplo selecionado             │
│ ...                                              │
└──────────────────────────────────────────────────┘
```

Nesta view, o painel `Resultado` fica oculto. O snippet é read-only, permite seleção parcial ou total e cópia pelo mecanismo normal da plataforma; a ação `Copiar código` copia o conteúdo completo e, após sucesso, apresenta feedback visual temporário `Copiado` antes de retornar ao estado normal. O `TMemo` deve permanecer visualmente integrado à superfície escura, com fonte monoespaçada clara e seleção legível; fundo branco proveniente do estilo padrão não faz parte do layout aprovado. As barras de rolagem aparecem somente quando o conteúdo ultrapassa o viewport do `TMemo`.

### Estado `Resultado`

```text
[ Código Delphi ] [ Resultado ]

Resultado
┌──────────────────────────────────────────────────┐
│                                                  │
│                                                  │
│       controle(s) criado(s) pelo sample          │
│             dentro do ResultHost                 │
│                                                  │
│                                                  │
│                                                  │
└──────────────────────────────────────────────────┘
```

Nesta view, o painel de código fica oculto. A superfície de resultado ocupa toda a área útil restante abaixo do seletor; o controle do sample preserva sua própria geometria e não é esticado apenas porque o host cresceu.

## Sequência visual obrigatória

A ordem vertical/hierárquica é:

```text
1. Header / Back / nome do componente pai
        ↓
2. Título da página concreta
        ↓
3. Descrição da abordagem
        ↓
4. Corpo principal dividido em duas regiões
        ├── navegação lateral
        └── conteúdo do exemplo
                ↓
5. Título do exemplo
        ↓
6. Descrição do exemplo
        ↓
7. Seletor Código Delphi / Resultado
        ↓
8. Uma única view ativa
        ├── Código Delphi → superfície de código
        └── Resultado → título Resultado + host de execução/preview
```

Essa sequência é parte do contrato de UX da família. O Design System não pode voltar a exibir código e resultado simultaneamente sem nova decisão explícita.

## Header e retorno

Textframe:

```text
┌────────────────────────────────────────────────────────────────────┐
│  ←   Button                                                        │
├────────────────────────────────────────────────────────────────────┤
```

Regras:

- o texto do header representa o **componente pai**, não `Componentes`;
- em `Button - Factory`, o header mostra `Button`;
- o retorno fecha somente a página de exemplos atual;
- após o fechamento, a Component Page daquele componente volta a ser a tela ativa;
- retornar da Component Page para a Home continua sendo responsabilidade da própria Component Page;
- a base não deve criar Router ou outra camada apenas para esse retorno se o fluxo modal existente continuar suficiente.

Fluxo esperado:

```text
Home
  ↓
Button Component Page
  ↓
Button - Factory Sample Page
  ↑
  └── Back
      retorna para Button Component Page
          ↑
          └── Back
              retorna para Home
```

## Identidade da página concreta

A base reserva as regiões de título e descrição, mas não define o conteúdo específico.

Formato visual esperado:

```text
Button - Factory
Exemplos de criação de botões usando a abordagem Factory.
```

A página derivada fornece:

- nome do componente;
- abordagem atual;
- título final;
- descrição da página.

A base não mantém tabela global de componentes ou abordagens.

## Navegação lateral

A coluna esquerda representa as categorias/exemplos disponíveis na página concreta.

Textframe:

```text
┌───────────────────┐
│ Básico            │  ← selecionado
│ Estilo            │
│ Ícones            │
│ Estados           │
│ Exemplos completos│
└───────────────────┘
```

`Básico`, `Estilo`, `Ícones`, `Estados` e `Exemplos completos` pertencem apenas ao mockup de Button e **não são categorias obrigatórias da base**.

Comportamento comum esperado:

- possuir exatamente um item selecionado quando houver exemplos;
- fornecer estado visual distinto para o item selecionado: fundo azul-claro, texto azul e indicador vertical azul à esquerda;
- o estado selecionado não depende de bold para comunicar seleção;
- ao trocar a seleção, atualizar a área principal para o exemplo correspondente;
- permitir quantidade variável de itens;
- quando a quantidade exceder a área disponível, a solução deve preservar a largura/posição da coluna e tratar o overflow sem aumentar a janela acima da Home.

Cada página derivada é responsável por declarar quais categorias/exemplos existem. Text / Label - Factory usa Básico, Geometria, Tipografia, Alinhamento e Completo; Button - Factory usa Básico, Geometria, Cores, Tipografia, Identificação, Caption interno, Clique e Completo; Button - Fluent Builder usa Básico, Interface, Geometria, Layout, Aparência, Tipografia, Estado, Hover, Clique, Resultado, Completo - Direto e Completo - Interfaces; Badge - Factory usa Básico, Geometria, Cores, Tipografia, Texto interno, Construção em etapas e Completo; Badge - Fluent Builder usa Básico, Interface, Geometria, Forma, Layout, Aparência, Tipografia, Estado, Resultado, Completo - Direto e Completo - Interfaces; Divider - Factory usa Básico, Geometria, Cor e Completo.

## Conteúdo do exemplo

A região principal apresenta inicialmente:

```text
{Título do exemplo}
{Descrição curta do exemplo}
```

A página derivada fornece esses textos. A base apenas garante posicionamento, tipografia e espaço coerentes.

O título e a descrição devem corresponder ao mesmo exemplo selecionado na navegação lateral.

## Seletor `Código Delphi` / `Resultado`

A referência visual define duas opções adjacentes:

```text
[ Código Delphi ] [ Resultado ]
```

O seletor é funcional e obedece às seguintes regras:

- exatamente uma opção fica selecionada;
- `Código Delphi` é a seleção inicial ao abrir a página;
- a opção selecionada usa fundo azul-claro e texto azul, preservando a referência visual;
- selecionar `Código Delphi` exibe somente `TExampleCodePanel` e oculta `TExampleResultPanel`;
- selecionar `Resultado` exibe somente `TExampleResultPanel` e oculta `TExampleCodePanel`;
- a alternância de view não troca o exemplo selecionado e não cria um segundo estado do sample;
- o resultado pode ser preparado quando o exemplo muda, mesmo enquanto a view de código estiver ativa; ao abrir `Resultado`, deve ser exibido o resultado correspondente ao mesmo exemplo;
- a responsabilidade de alternância pertence à infraestrutura comum, não às páginas concretas.

`TExampleViewSelector` materializa e mantém a seleção. `TExampleCommon` responde à mudança tornando os painéis mutuamente exclusivos.

## Superfície de código

A base reserva uma superfície visual para código Delphi:

```text
┌──────────────────────────────────────────────────┐
│ var                                              │
│   ...                                            │
│ begin                                            │
│   ...                                            │
│ end;                                             │
└──────────────────────────────────────────────────┘
```

Regras implementadas:

- aparência de editor/bloco de código distinta do restante da página;
- `TMemo` read-only com fonte monoespaçada e `WordWrap = False`;
- seleção parcial, seleção total e cópia normal da seleção permanecem disponíveis;
- a ação `Copiar código` envia o snippet completo ao clipboard da plataforma e informa `Copiado` temporariamente após sucesso;
- o memo utiliza fundo escuro integrado à superfície, texto monoespaçado claro e seleção visível;
- scrollbars ficam em AutoHide e dependem do overflow real, sem canvas fixa maior que o viewport;
- conteúdo fornecido pela página derivada;
- o código apresentado deve representar a mesma operação executada no resultado;
- não inventar APIs para preencher exemplos;
- syntax highlighting continua fora do escopo atual.

## Área `Resultado`

Quando a opção `Resultado` está selecionada, a área principal apresenta o título e o host de execução/preview:

```text
Resultado
┌──────────────────────────────────────────────────┐
│                                                  │
│       controle(s) criado(s) pelo sample          │
│                                                  │
└──────────────────────────────────────────────────┘
```

A superfície de resultado usa fundo claro próprio, borda suave e cantos arredondados conforme a referência aprovada e preenche toda a altura útil restante da view ativa. `ResultHost` fica dentro dessa superfície e também ocupa sua área interna descontado o padding. A base fornece o host visual e o boundary de apresentação; crescer o host não altera automaticamente o tamanho do controle criado pelo sample. A página derivada é responsável por:

- criar os controles reais do exemplo;
- usar a abordagem correta, Factory ou Fluent Builder;
- manter o resultado coerente com o código exibido;
- substituir/limpar o conteúdo anterior quando outro exemplo for selecionado;
- não deixar controles residuais de um exemplo anterior.

O contrato de ownership vigente é explícito: `TExampleResultPanel` owns a superfície, a superfície owns `ResultHost` e `ResultHost` owns os controles visuais materializados. A derivada usa o host como Parent, não o libera nem substitui, e chama `ClearResult` antes da próxima materialização; `ClearResult` libera somente os filhos do host.

## Responsabilidade da Sample Page Base

A Sample Page Base pode conhecer:

- estrutura e dimensões comuns da família;
- header e retorno;
- regiões de identidade;
- layout navegação lateral + conteúdo;
- estado visual de seleção;
- seletor funcional entre código e resultado;
- hosts de código e resultado;
- cores, espaçamentos e tipografia comuns;
- comportamento estrutural necessário para trocar o exemplo visível.

A Sample Page Base não pode conhecer:

- `Button`, `Badge`, `Divider`, `ComboBox`, `Edit` ou `Text / Label` como regras específicas;
- lista global de APIs;
- categorias fixas para todos os componentes;
- código Delphi específico de um componente;
- execução de Factory ou Fluent Builder específica;
- `case/if` por componente ou abordagem para materializar samples.

## Responsabilidade das páginas derivadas

Cada página concreta componente/abordagem é responsável por:

- identidade da página;
- categorias/exemplos próprios;
- título e descrição de cada exemplo;
- código Delphi demonstrado;
- execução real correspondente;
- controles específicos necessários ao resultado;
- atualização do resultado quando o exemplo muda;
- documentação da cobertura da API pública daquele componente/abordagem.

Não haverá um arquivo único de configuração contendo os exemplos de todos os componentes.

## Cobertura por componente e abordagem

A matriz conhecida no baseline atual é:

| Componente | Factory | Fluent Builder |
|---|:---:|:---:|
| Text / Label | implementado | implementado |
| Button | implementado | implementado |
| Badge | implementado | previsto |
| Divider | implementado | previsto |
| ComboBox | previsto | previsto |
| Edit | não disponível na API atual | previsto |

A tabela diferencia o destino já implementado dos destinos ainda previstos; ela não declara como existente nenhuma página marcada como `previsto`.

Ao implementar cada página concreta, a API pública deve ser reanalisada naquele momento. A cobertura esperada é:

```text
API pública real do componente + abordagem
                ↓
levantamento das funcionalidades públicas relevantes
                ↓
organização em categorias de exemplos da página concreta
                ↓
exemplo(s) que demonstrem cada funcionalidade
                ↓
código mostrado = execução apresentada no Resultado
```

Uma funcionalidade pode ser demonstrada isoladamente ou em exemplo composto quando isso tornar o uso mais claro, sem criar categorias artificiais apenas para aumentar a quantidade de exemplos.

## Exemplo visual — Button / Factory

A derivada concreta Button - Factory utiliza as categorias levantadas da API pública real, não as categorias genéricas do mockup inicial:

```text
┌────────────────────────────────────────────────────────────────────┐
│  ←   Button                                                        │
├────────────────────────────────────────────────────────────────────┤
│                                                                    │
│  Button - Factory                                                  │
│  Criação direta de TRectangle + TLabel com CreateButton.           │
│                                                                    │
├───────────────────┬────────────────────────────────────────────────┤
│ Básico            │ {título/descrição do exemplo selecionado}      │
│ Geometria         │                                                │
│ Cores             │ [ Código Delphi ] [ Resultado ]                │
│ Tipografia        │                                                │
│ Identificação     │ ┌────────────────────────────────────────────┐ │
│ Caption interno   │ │ view ativa: código OU resultado           │ │
│ Clique            │ └────────────────────────────────────────────┘ │
│ Completo          │                                                │
└───────────────────┴────────────────────────────────────────────────┘
```

O exemplo `Clique` é interativo: o Runner associa `OnClick` ao `TRectangle` retornado por `CreateButton`; ao clicar no Button da aba Resultado, sua cor muda para verde, tornando a execução observável sem atribuir `OnClick` ao record de configuração.

## Critérios de aderência da implementação da base

A implementação atual da base deve ser considerada aderente a esta especificação somente se, no mínimo:

- conter apenas a infraestrutura comum da Sample Page Base;
- permanecer menor que a Home em largura e altura;
- preservar a sequência do textframe normativo;
- manter header com contexto do componente pai;
- permitir retorno à Component Page de origem;
- separar navegação lateral da área principal;
- reservar título/descrição do exemplo;
- implementar `Código Delphi` / `Resultado` como seletor funcional com views mutuamente exclusivas;
- iniciar em `Código Delphi`;
- possuir superfície de código e host de resultado distintos;
- não conter conteúdo específico de componente/abordagem;
- não centralizar catálogo global de exemplos;
- não alterar Home ou Component Pages além do necessário para uma integração explicitamente autorizada em etapa posterior.

## Fora do escopo após a implementação da base

Continuam fora do escopo até nova autorização:

- implementação dos menus definitivos dos destinos ainda não implementados;
- snippets reais de API para destinos ainda não implementados;
- criação/execução real dos controles dos samples ainda não implementados;
- interatividade de `Ver exemplos` nas Component Pages que ainda não possuem destino real;
- Composition nessa navegação.
