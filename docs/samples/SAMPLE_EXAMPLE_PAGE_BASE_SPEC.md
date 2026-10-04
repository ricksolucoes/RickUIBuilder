# Especificação da Sample Page Base

## Status

**Sample Page Base implementada e duas páginas concretas disponíveis: Text / Label - Factory e Text / Label - Fluent Builder.**

Este documento fixa a intenção visual, a sequência estrutural, os limites de responsabilidade e o comportamento da base das páginas de exemplos do `RickUIBuilder.Samples`.

A implementação comum é coordenada por `RickUIBuilder.Samples.Example.Common`, com classe abstrata `TExampleCommon`. A família é dividida por responsabilidade em units próprias para header, navegação, seletor de visualização, painel de código, painel de resultado, ícones e estilo. As derivadas reais atuais são `TExampleTextLabelFactory` e `TExampleTextLabelFluent`; os demais destinos permanecem futuros.

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

A Component Page continua sendo somente o divisor entre abordagens. A Sample Page concreta é onde os samples reais são apresentados e executados; Text / Label possui hoje destinos concretos para Factory e Fluent Builder.

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

`RickUIBuilder.Samples.App.Types` fornece atualmente os enums compartilhados usados por esta camada: `TExampleView` representa a seleção `Código Delphi`/`Resultado`, `TTextLabelFactoryExample` identifica os exemplos de Text / Label - Factory e `TTextLabelFluentExample` identifica os exemplos de Text / Label - Fluent Builder. O seletor, a page concreta, o conteúdo e o Runner consomem esses tipos; `Factory.Content` mantém apenas textos/snippets e não declara o enum dos exemplos.

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
src/Examples/TextLabel/
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
src/Examples/TextLabel/
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

O exemplo `Completo` é deliberadamente exaustivo. Para Factory, `Completo` continua atribuindo todos os campos públicos de `TRickUIBuilderTextConfig`; para Fluent Builder, chama todos os métodos públicos configuráveis de `IRickUIBuilderLabel`. Se a API ou um record público usado por esses exemplos ganhar nova opção configurável, o snippet, o Runner e esta matriz devem ser atualizados em conjunto.

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

Cada página derivada é responsável por declarar quais categorias/exemplos existem. Text / Label - Factory usa atualmente Básico, Geometria, Tipografia, Alinhamento e Completo.

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
| Text / Label | implementado | previsto |
| Button | previsto | previsto |
| Badge | previsto | previsto |
| Divider | previsto | previsto |
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

## Exemplo visual futuro — Button / Factory

Este textframe ilustra uma futura derivada sem declarar implementação atual:

```text
┌────────────────────────────────────────────────────────────────────┐
│  ←   Button                                                        │
├────────────────────────────────────────────────────────────────────┤
│                                                                    │
│  Button - Factory                                                  │
│  Exemplos de criação de botões usando a abordagem Factory.         │
│                                                                    │
├───────────────────┬────────────────────────────────────────────────┤
│ Básico            │ Exemplo básico                                 │
│ Estilo            │ Criação de um botão simples usando a Factory.  │
│ Ícones            │                                                │
│ Estados           │ [ Código Delphi ] [ Resultado ]                │
│ Exemplos completos│                                                │
│                   │ ┌────────────────────────────────────────────┐ │
│                   │ │ código Delphi do exemplo                  │ │
│                   │ │ (view Código Delphi ativa)                │ │
│                   │ └────────────────────────────────────────────┘ │
└───────────────────┴────────────────────────────────────────────────┘
```

Os itens do menu são somente os fornecidos pela referência visual. Sua validade como cobertura da API de Button deverá ser verificada quando a página concreta for realmente implementada. Na view `Resultado`, esse mesmo espaço passa a exibir somente o título `Resultado` e a superfície executável, nunca simultaneamente ao código.

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

- páginas concretas `Button - Factory`, `Button - Fluent Builder` e equivalentes;
- implementação dos menus definitivos dos destinos ainda não implementados;
- snippets reais de API para destinos ainda não implementados;
- criação/execução real dos controles dos samples ainda não implementados;
- interatividade de `Ver exemplos` nas Component Pages que ainda não possuem destino real;
- Composition nessa navegação.
