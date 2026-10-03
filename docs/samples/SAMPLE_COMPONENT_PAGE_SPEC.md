# Especificação visual da Component Page

## Status

**Especificação aprovada para a próxima etapa de implementação.**

Este documento descreve o layout-alvo das páginas de componente do `RickUIBuilder.Samples`. Ele **não declara que o layout abaixo já está implementado**. O estado atual do código continua sendo a autoridade para comportamento existente; esta especificação orienta a próxima alteração da `TComponentPage`.

A referência visual aprovada é a imagem fornecida para a página `Button`. A imagem orienta hierarquia, proporção, alinhamento, densidade e aparência. Textos técnicos e capacidades vêm da API pública e da documentação real do Rick.UIBuilder, não de afirmações funcionais presentes na imagem.

## Escopo desta etapa

A próxima implementação deve ajustar somente a página intermediária de componente, mantendo a Home já concluída.

O Samples continuará com estas telas/estados navegáveis:

```text
Home
├── Text / Label ──┐
├── Button ────────┤
├── Badge ─────────┤
├── Divider ───────┼──► TComponentPage
├── ComboBox ──────┤
└── Edit ──────────┘
```

`TComponentPage` continua sendo uma única página reutilizável. O componente selecionado define título, subtítulo, texto informativo e disponibilidade das abordagens.

As telas específicas de exemplos de `Factory` e `Fluent Builder` **não fazem parte desta etapa** e continuam registradas como trabalho futuro.

## Hierarquia visual comum

A página segue quatro zonas, de cima para baixo:

```text
┌──────────────────────────────────────────────────────────┐
│  ←   Componentes                                         │  Navegação
├──────────────────────────────────────────────────────────┤
│                                                          │
│   Título do componente                                   │  Identidade
│   Subtítulo contextual                                   │
│                                                          │
│   ┌───────────────────────┐  ┌───────────────────────┐   │
│   │       abordagem       │  │       abordagem       │   │  Abordagens
│   └───────────────────────┘  └───────────────────────┘   │
│                                                          │
│   ┌──────────────────────────────────────────────────┐   │
│   │  ⓘ   Sobre este componente                      │   │  Contexto
│   │      Texto técnico curto e específico.           │   │
│   └──────────────────────────────────────────────────┘   │
│                                                          │
└──────────────────────────────────────────────────────────┘
```

A imagem de referência possui aproximadamente `430 × 395 px`. Essa dimensão é uma referência visual do screenshot e **não deve ser tratada automaticamente como `ClientWidth`/`ClientHeight` do `TForm`**. A implementação deve reproduzir as proporções e o espaçamento observados sem depender de borda de janela ou escala externa do screenshot.

## Navegação superior

O header/breadcrumb possui:

- seta de retorno à esquerda;
- texto `Componentes`;
- separador inferior sutil;
- superfície visual coerente com a Home;
- área de hit adequada quando a ação de retorno estiver implementada;
- `crHandPoint` somente quando existir ação real.

O retorno atual da página continua ocorrendo pelo fechamento modal. A adoção de uma ação explícita de Back deve respeitar a decisão de navegação vigente no momento da implementação.

## Identidade do componente

Abaixo do header:

- título com o nome público do componente;
- subtítulo curto, em uma linha quando houver espaço;
- título usa `_FONT_SIZE_PAGE_TITLE_`;
- subtítulo usa `_FONT_SIZE_PAGE_SUBTITLE_`;
- o conteúdo é alinhado à esquerda, como na referência visual.

## Cards de abordagem

Quando `Factory` e `Fluent Builder` estiverem disponíveis, os dois cards aparecem lado a lado com mesma largura e altura.

Cada card possui:

1. ícone vetorial centralizado;
2. título da abordagem;
3. descrição curta;
4. ação `Ver exemplos` na parte inferior;
5. chevron vetorial à direita da ação.

Textos fixos:

```text
Factory
Criação direta
do componente.
Ver exemplos
```

```text
Fluent Builder
API encadeada
para configuração.
Ver exemplos
```

A legenda `Ver exemplos` deve permanecer visualmente centralizada independentemente do chevron.

### Assets obrigatórios

A geometria dos assets fornecidos deve ser preservada; não substituir por emoji, caractere Unicode ou desenho aproximado.

| Uso | Asset fornecido |
|---|---|
| Factory | `factory_24dp_E3E3E3_FILL0_wght400_GRAD0_opsz24.svg` |
| Fluent Builder | `link-03-svgrepo-com.svg` |
| Informação | `info_48dp_E3E3E3_FILL0_wght400_GRAD0_opsz48.svg` |

Os três arquivos foram fornecidos junto à solicitação desta etapa. O caminho definitivo deles dentro do repositório **não está confirmado nesta documentação** e deve ser validado quando forem incorporados à implementação; não presumir uma pasta de assets inexistente.

O asset de Factory é baseado em `fill`; o asset de Fluent Builder é baseado em `stroke`; o asset de informação é baseado em `fill`. A implementação FMX deve preservar essa diferença ao converter/renderizar a geometria em `TPath`.

As cores finais dos três ícones devem seguir a referência visual: Factory em destaque violeta, Fluent Builder em destaque verde e informação em azul. Os valores ARGB exatos ainda **não estão definidos como contrato** nesta especificação; não inventar valores sem derivação/decisão na implementação.

O chevron da ação deve continuar vetorial. A geometria já aprovada para `arrow_forward_ios` pode ser reutilizada, desde que isso não crie dependência arquitetural indevida entre a página de componente e a Home.

## Painel “Sobre este componente”

O painel inferior possui:

- superfície azul muito clara;
- borda sutil e cantos arredondados;
- ícone de informação à esquerda;
- título `Sobre este componente` em destaque;
- texto técnico curto abaixo do título;
- conteúdo suficiente para duas ou três linhas sem clipping.

O texto do painel deve descrever a implementação real do componente. Não copiar afirmações técnicas da imagem quando divergirem do código.

**Exemplo importante:** a referência visual do Button menciona `TButton`, mas a implementação atual do Rick.UIBuilder materializa o Button como composição de `TRectangle + TLabel`. Portanto, `TButton` não deve aparecer no texto final dessa página enquanto o código continuar assim.

## Tipografia

Manter a escala já aprovada no Samples:

| Papel | Token | Tamanho |
|---|---|---:|
| Título da página | `_FONT_SIZE_PAGE_TITLE_` | 24 |
| Subtítulo | `_FONT_SIZE_PAGE_SUBTITLE_` | 14 |
| Título do card | `_FONT_SIZE_CARD_TITLE_` | 16 |
| Corpo/descrições | `_FONT_SIZE_BODY_` | 14 |
| Ação | `_FONT_SIZE_ACTION_` | 14 |
| Navegação | `_FONT_SIZE_NAVIGATION_` | 13 |

A geometria deve acomodar a tipografia. Não reduzir fonte para compensar falta de espaço.

## Conteúdo por tela

Os textos abaixo são derivados da API/documentação atual do projeto e constituem o conteúdo-alvo da próxima implementação.

### Text / Label

**Título**

`Text / Label`

**Subtítulo**

`Crie e configure textos FireMonkey com Rick.UIBuilder.`

**Abordagens**

- Factory
- Fluent Builder

**Sobre este componente**

`Text / Label cria TLabel em runtime. A Factory cobre a configuração textual básica e o Fluent Builder complementa a configuração visual e de layout.`

**Textframe**

```text
┌──────────────────────────────────────────────────────────┐
│  ←   Componentes                                         │
├──────────────────────────────────────────────────────────┤
│                                                          │
│   Text / Label                                           │
│   Crie e configure textos FireMonkey com Rick.UIBuilder. │
│                                                          │
│   ┌───────────────────────┐  ┌───────────────────────┐   │
│   │       [Factory]       │  │        [Link]         │   │
│   │        Factory        │  │    Fluent Builder     │   │
│   │     Criação direta    │  │     API encadeada     │   │
│   │     do componente.    │  │    para configuração. │   │
│   │   [ Ver exemplos  › ] │  │   [ Ver exemplos  › ] │   │
│   └───────────────────────┘  └───────────────────────┘   │
│                                                          │
│   ┌──────────────────────────────────────────────────┐   │
│   │  [Info]  Sobre este componente                  │   │
│   │  Text / Label cria TLabel em runtime...          │   │
│   └──────────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────────┘
```

### Button

**Título**

`Button`

**Subtítulo**

`Crie e configure botões FireMonkey com Rick.UIBuilder.`

**Abordagens**

- Factory
- Fluent Builder

**Sobre este componente**

`Button é composto por TRectangle + TLabel. A Factory materializa a estrutura visual e o Fluent Builder acrescenta configuração e comportamento de hover.`

**Textframe**

```text
┌──────────────────────────────────────────────────────────┐
│  ←   Componentes                                         │
├──────────────────────────────────────────────────────────┤
│                                                          │
│   Button                                                 │
│   Crie e configure botões FireMonkey com Rick.UIBuilder. │
│                                                          │
│   ┌───────────────────────┐  ┌───────────────────────┐   │
│   │       [Factory]       │  │        [Link]         │   │
│   │        Factory        │  │    Fluent Builder     │   │
│   │     Criação direta    │  │     API encadeada     │   │
│   │     do componente.    │  │    para configuração. │   │
│   │   [ Ver exemplos  › ] │  │   [ Ver exemplos  › ] │   │
│   └───────────────────────┘  └───────────────────────┘   │
│                                                          │
│   ┌──────────────────────────────────────────────────┐   │
│   │  [Info]  Sobre este componente                  │   │
│   │  Button é composto por TRectangle + TLabel...    │   │
│   └──────────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────────┘
```

### Badge

**Título**

`Badge`

**Subtítulo**

`Crie badges compostos e configure sua apresentação com Rick.UIBuilder.`

**Abordagens**

- Factory
- Fluent Builder

**Sobre este componente**

`Badge combina TRectangle + TLabel e pode ser criado pela Factory ou configurado pelo Fluent Builder, incluindo as opções visuais próprias do componente.`

**Textframe**

```text
┌──────────────────────────────────────────────────────────┐
│  ←   Componentes                                         │
├──────────────────────────────────────────────────────────┤
│                                                          │
│   Badge                                                  │
│   Crie badges compostos e configure sua apresentação     │
│   com Rick.UIBuilder.                                    │
│                                                          │
│   ┌───────────────────────┐  ┌───────────────────────┐   │
│   │       [Factory]       │  │        [Link]         │   │
│   │        Factory        │  │    Fluent Builder     │   │
│   │     Criação direta    │  │     API encadeada     │   │
│   │     do componente.    │  │    para configuração. │   │
│   │   [ Ver exemplos  › ] │  │   [ Ver exemplos  › ] │   │
│   └───────────────────────┘  └───────────────────────┘   │
│                                                          │
│   ┌──────────────────────────────────────────────────┐   │
│   │  [Info]  Sobre este componente                  │   │
│   │  Badge é materializado como TRectangle + TLabel. │   │
│   └──────────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────────┘
```

### Divider

**Título**

`Divider`

**Subtítulo**

`Crie separadores horizontais ou verticais com Rick.UIBuilder.`

**Abordagens**

- Factory
- Fluent Builder

**Sobre este componente**

`Divider usa TRectangle como separador horizontal ou vertical e pode ser criado pela Factory ou configurado pelo Fluent Builder.`

**Textframe**

```text
┌──────────────────────────────────────────────────────────┐
│  ←   Componentes                                         │
├──────────────────────────────────────────────────────────┤
│                                                          │
│   Divider                                                │
│   Crie separadores horizontais ou verticais com          │
│   Rick.UIBuilder.                                        │
│                                                          │
│   ┌───────────────────────┐  ┌───────────────────────┐   │
│   │       [Factory]       │  │        [Link]         │   │
│   │        Factory        │  │    Fluent Builder     │   │
│   │     Criação direta    │  │     API encadeada     │   │
│   │     do componente.    │  │    para configuração. │   │
│   │   [ Ver exemplos  › ] │  │   [ Ver exemplos  › ] │   │
│   └───────────────────────┘  └───────────────────────┘   │
│                                                          │
│   ┌──────────────────────────────────────────────────┐   │
│   │  [Info]  Sobre este componente                  │   │
│   │  Divider usa TRectangle como separador...        │   │
│   └──────────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────────┘
```

### ComboBox

**Título**

`ComboBox`

**Subtítulo**

`Crie seleções FireMonkey configuráveis com Rick.UIBuilder.`

**Abordagens**

- Factory
- Fluent Builder

**Sobre este componente**

`ComboBox possui suporte à Factory e ao Fluent Builder. O Builder concentra configuração, itens e modos de apresentação, com superfícies de seleção materializadas quando necessárias.`

**Textframe**

```text
┌──────────────────────────────────────────────────────────┐
│  ←   Componentes                                         │
├──────────────────────────────────────────────────────────┤
│                                                          │
│   ComboBox                                               │
│   Crie seleções FireMonkey configuráveis com             │
│   Rick.UIBuilder.                                        │
│                                                          │
│   ┌───────────────────────┐  ┌───────────────────────┐   │
│   │       [Factory]       │  │        [Link]         │   │
│   │        Factory        │  │    Fluent Builder     │   │
│   │     Criação direta    │  │     API encadeada     │   │
│   │     do componente.    │  │    para configuração. │   │
│   │   [ Ver exemplos  › ] │  │   [ Ver exemplos  › ] │   │
│   └───────────────────────┘  └───────────────────────┘   │
│                                                          │
│   ┌──────────────────────────────────────────────────┐   │
│   │  [Info]  Sobre este componente                  │   │
│   │  ComboBox possui Factory e Fluent Builder...     │   │
│   └──────────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────────┘
```

### Edit

**Título**

`Edit`

**Subtítulo**

`Crie campos de texto de uma linha em runtime com Rick.UIBuilder.`

**Abordagens**

- Fluent Builder

`Factory` não deve ser exibida enquanto `TRickUIBuilderFactory` não expuser `CreateEdit`.

**Sobre este componente**

`Edit é o builder de entrada de texto de uma linha do Rick.UIBuilder. No estado atual da API, ele está disponível pelo Fluent Builder e não possui Factory.CreateEdit.`

**Textframe**

```text
┌──────────────────────────────────────────────────────────┐
│  ←   Componentes                                         │
├──────────────────────────────────────────────────────────┤
│                                                          │
│   Edit                                                   │
│   Crie campos de texto de uma linha em runtime com       │
│   Rick.UIBuilder.                                        │
│                                                          │
│                ┌───────────────────────┐                 │
│                │        [Link]         │                 │
│                │    Fluent Builder     │                 │
│                │     API encadeada     │                 │
│                │    para configuração. │                 │
│                │   [ Ver exemplos  › ] │                 │
│                └───────────────────────┘                 │
│                                                          │
│   ┌──────────────────────────────────────────────────┐   │
│   │  [Info]  Sobre este componente                  │   │
│   │  Edit é o builder de entrada de texto de uma linha...│   │
│   └──────────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────────┘
```

O único card do Edit deve ser centralizado. Não deixar espaço vazio equivalente ao card Factory e não criar Factory desabilitada ou fictícia.

## Interatividade e estado de implementação

A referência visual mostra `Ver exemplos` como botão de ação. A governança do Samples exige que aparência interativa corresponda a uma ação real.

Consequentemente:

- esta especificação define a **aparência-alvo final** dos cards;
- enquanto as telas de exemplos Factory/Fluent não existirem, não declarar na documentação de estado atual que esses botões já navegam;
- uma implementação intermediária não deve criar navegação falsa, callback vazio ou destino fictício apenas para satisfazer a aparência;
- quando as páginas de exemplos forem implementadas, `Ver exemplos` deve se tornar a ação real de navegação correspondente.

Se a próxima tarefa limitar-se estritamente à reprodução visual antes das páginas de exemplo, o comportamento da ação deve ser decidido explicitamente antes de concluir a implementação para não violar a regra de interatividade real.

## Responsabilidades da `TComponentPage`

A página continua responsável por:

- receber `TSampleComponent`;
- selecionar conteúdo correspondente ao componente;
- exibir somente abordagens realmente suportadas;
- construir o layout da página;
- não alterar nem simular a API pública do Rick.UIBuilder.

A decisão de navegação para futuras páginas Factory/Fluent deve continuar fora da View quando for implementada, preservando a separação já adotada no Samples.

## Critérios de aceitação visual da próxima implementação

A implementação desta especificação estará visualmente aderente quando, no mínimo:

- o header/breadcrumb seguir a hierarquia da referência;
- título e subtítulo estiverem alinhados à esquerda;
- Factory e Fluent aparecerem lado a lado para `Text / Label`, `Button`, `Badge`, `Divider` e `ComboBox`;
- `Edit` apresentar somente Fluent Builder, centralizado;
- os três SVGs fornecidos forem utilizados nas funções corretas;
- cards mantiverem título, descrição e área de ação sem clipping;
- `Ver exemplos` mantiver legenda centralizada e chevron vetorial;
- o painel `Sobre este componente` estiver presente em todas as seis variações;
- o texto técnico do painel corresponder à implementação real de cada componente;
- a escala tipográfica compartilhada for preservada;
- nenhum elemento visual indicar comportamento inexistente como se estivesse implementado.

## Fora do escopo desta especificação

Não estão definidos aqui:

- layout das telas de exemplos Factory;
- layout das telas de exemplos Fluent Builder;
- conteúdo de exemplos de código;
- posição futura de Composition na navegação;
- mudanças na API pública do Rick.UIBuilder;
- criação de `Factory.CreateEdit`;
- valores ARGB exatos dos novos acentos violeta/verde quando não existirem tokens aprovados.
