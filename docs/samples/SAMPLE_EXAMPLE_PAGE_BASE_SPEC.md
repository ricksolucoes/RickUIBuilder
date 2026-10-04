# Especificação da Sample Page Base

## Status

**Sample Page Base implementada e primeira página concreta disponível: Text / Label - Factory.**

Este documento fixa a intenção visual, a sequência estrutural, os limites de responsabilidade e o comportamento da base das páginas de exemplos do `RickUIBuilder.Samples`.

A implementação comum é coordenada por `RickUIBuilder.Samples.Example.Common`, com classe abstrata `TExampleCommon`. A família é dividida por responsabilidade em units próprias para header, navegação, painel de código, painel de resultado, ícones e estilo. A primeira derivada real é `TExampleTextLabelFactory`; os demais destinos permanecem futuros.

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

A Component Page continua sendo somente o divisor entre abordagens. A Sample Page concreta é onde os samples reais são apresentados e executados; Text / Label - Factory é o primeiro exemplo desse fluxo.

## Regra de tamanho

A Sample Page deve permanecer **sempre menor que a Home**.

No baseline atual, a Home possui referência de `644 × 534`. Portanto, toda Sample Page deve respeitar simultaneamente:

```text
SamplePage.ClientWidth  < 644
SamplePage.ClientHeight < 534
```

A implementação atual define `620 × 510`, mantendo simultaneamente `620 < 644` e `510 < 534`.

A navegação lateral utiliza `TVertScrollBox` e a superfície de código utiliza `TScrollBox`, mantendo excesso de conteúdo dentro das regiões apropriadas. Não aumentar a Sample Page acima da Home e não reduzir tipografia para esconder clipping.


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
├── RickUIBuilder.Samples.Example.Common.CodePanel.pas
│   └── TExampleCodePanel: faixa Código Delphi/Resultado e superfície de código
├── RickUIBuilder.Samples.Example.Common.ResultPanel.pas
│   └── TExampleResultPanel: título, superfície e ResultHost
├── RickUIBuilder.Samples.Example.Common.Icons.pas
│   └── geometria vetorial comum
└── RickUIBuilder.Samples.Example.Common.Style.pas
    └── geometria e paleta compartilhadas
```

Essa separação é estrutural e não cria regras específicas de componente. `TExampleCommon` coordena os controles acima; não reimplementa internamente header, navegação, painel de código ou painel de resultado.

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

Esses pontos de extensão não materializam componente ou abordagem. `AddNavigationItem` cria somente o item visual; a derivada associa sua ação. `SelectNavigationItem` controla apenas o estado visual selecionado. `ResultHost` é o container dos controles reais e `ClearResult` remove seus filhos visuais antes da substituição do exemplo.

A faixa `Código Delphi` / `Resultado` permanece com `HitTest` desabilitado e não implementa tabs.

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

## Textframe normativo da tela-base

O textframe abaixo fixa **ordem, agrupamento e hierarquia**. O Design System pode ajustar tokens visuais compatíveis, mas não deve mover, remover ou reordenar os blocos sem nova decisão explícita.

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
│                   │  │  superfície de código/conteúdo          │  │
│                   │  │  correspondente ao exemplo selecionado  │  │
│                   │  │                                          │  │
│                   │  └──────────────────────────────────────────┘  │
│                   │                                                │
│                   │  Resultado                                     │
│                   │  ┌──────────────────────────────────────────┐  │
│                   │  │                                          │  │
│                   │  │  host para execução/preview do sample    │  │
│                   │  │  criado pela página derivada             │  │
│                   │  │                                          │  │
│                   │  └──────────────────────────────────────────┘  │
│                   │                                                │
└───────────────────┴────────────────────────────────────────────────┘
```

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
7. Faixa visual Código Delphi / Resultado
        ↓
8. Superfície de código/conteúdo
        ↓
9. Título Resultado
        ↓
10. Host de execução/preview
```

Essa sequência é parte do contrato de UX da família e não pode ser reinterpretada automaticamente pelo Design System.

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
- fornecer estado visual distinto para o item selecionado;
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

## Faixa `Código Delphi` / `Resultado`

A referência visual contém a seguinte faixa:

```text
[ Código Delphi ] [ Resultado ]
```

Nesta etapa, somente sua **posição e presença visual** estão especificadas.

A semântica de clique/alternância entre `Código Delphi` e `Resultado` é **Não confirmada**. A primeira página concreta não adiciona tabs; a implementação da base continua sem troca de conteúdo ou duplicação de estado.

Até essa definição, o textframe deve preservar a região para que o Design System não elimine nem reposicione o elemento.

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

Regras planejadas:

- aparência de editor/bloco de código distinta do restante da página;
- fonte monoespaçada;
- conteúdo fornecido pela página derivada;
- o código apresentado deve representar a mesma operação executada no resultado;
- não inventar APIs para preencher exemplos;
- syntax highlighting pode ser considerado na implementação, mas sua técnica não está definida neste documento.

## Área `Resultado`

A região inferior da área principal é o host de execução/preview:

```text
Resultado
┌──────────────────────────────────────────────────┐
│                                                  │
│       controle(s) criado(s) pelo sample          │
│                                                  │
└──────────────────────────────────────────────────┘
```

A base fornece somente o host visual e o boundary de apresentação. A página derivada é responsável por:

- criar os controles reais do exemplo;
- usar a abordagem correta, Factory ou Fluent Builder;
- manter o resultado coerente com o código exibido;
- substituir/limpar o conteúdo anterior quando outro exemplo for selecionado;
- não deixar controles residuais de um exemplo anterior.

A estratégia Delphi concreta de ownership/limpeza deve ser confirmada na implementação contra o código FMX final; este documento fixa o resultado esperado, não inventa uma implementação de lifetime.

## Responsabilidade da Sample Page Base

A Sample Page Base pode conhecer:

- estrutura e dimensões comuns da família;
- header e retorno;
- regiões de identidade;
- layout navegação lateral + conteúdo;
- estado visual de seleção;
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
│                   │ └────────────────────────────────────────────┘ │
│                   │                                                │
│                   │ Resultado                                      │
│                   │ ┌────────────────────────────────────────────┐ │
│                   │ │          [ controle executado ]           │ │
│                   │ └────────────────────────────────────────────┘ │
└───────────────────┴────────────────────────────────────────────────┘
```

Os itens do menu são somente os fornecidos pela referência visual. Sua validade como cobertura da API de Button deverá ser verificada quando a página concreta for realmente implementada.

## Critérios de aderência da implementação da base

A primeira implementação deve ser considerada aderente a esta especificação somente se, no mínimo:

- conter apenas a infraestrutura comum da Sample Page Base;
- permanecer menor que a Home em largura e altura;
- preservar a sequência do textframe normativo;
- manter header com contexto do componente pai;
- permitir retorno à Component Page de origem;
- separar navegação lateral da área principal;
- reservar título/descrição do exemplo;
- preservar a faixa visual `Código Delphi` / `Resultado` sem inventar comportamento ainda não confirmado;
- possuir superfície de código e host de resultado distintos;
- não conter conteúdo específico de componente/abordagem;
- não conter páginas concretas ou samples reais nesta etapa;
- não centralizar catálogo global de exemplos;
- não alterar Home ou Component Pages além do necessário para uma integração explicitamente autorizada em etapa posterior.

## Fora do escopo após a implementação da base

Continuam fora do escopo até nova autorização:

- páginas concretas `Button - Factory`, `Button - Fluent Builder` e equivalentes;
- implementação dos menus definitivos de cada componente;
- snippets reais de API;
- criação/execução real dos controles de sample;
- interatividade de `Ver exemplos` nas Component Pages;
- definição funcional da faixa `Código Delphi` / `Resultado`;
- Composition nessa navegação.
