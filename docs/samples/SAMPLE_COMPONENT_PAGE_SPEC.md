# Especificação da Component Page

## Status

**Estrutura implementada no código-fonte atual do Samples.**

Este documento descreve a página intermediária de componente e suas seis implementações concretas. Ele documenta a estrutura e a geometria presentes no código. Compilação Delphi e validação visual em runtime dependem de execução real do ambiente e não são inferidas por esta documentação.

## Papel da página

A Component Page é o ponto intermediário entre a Home e as páginas de samples de cada abordagem. No estado atual, Text / Label, Button, Badge, Divider e ComboBox possuem destinos concretos para Factory e Fluent Builder; Edit possui destino concreto somente para Fluent Builder.

```text
Home
  │
  ▼
Component Page do componente
  │
  ├── Factory
  │      ├── Text / Label → TExampleTextLabelFactory
  │      ├── Button → TExampleButtonFactory
  │      ├── Badge → TExampleBadgeFactory
  │      ├── Divider → TExampleDividerFactory
  │      └── ComboBox → TExampleComboBoxFactory
  │
  └── Fluent Builder
         ├── Text / Label → TExampleTextLabelFluent
         ├── Button → TExampleButtonFluent
         ├── Badge → TExampleBadgeFluent
         ├── Divider → TExampleDividerFluent
         ├── ComboBox → TExampleComboBoxFluent
         └── Edit → TExampleEditFluent
```

Callbacks só existem quando há destino real. No estado atual, Text / Label, Button, Badge, Divider e ComboBox possuem destinos Factory + Fluent Builder; Edit possui somente Fluent Builder. Nenhuma abordagem sem destino é apresentada como opção funcional.

## Arquitetura da família de páginas

A infraestrutura comum reside em `RickUIBuilder.Samples.Component.Common.pas`, com tokens visuais em `RickUIBuilder.Samples.Component.Common.Style` e SVGs compartilhados em `RickUIBuilder.Samples.Component.Common.Icons`.

```text
TComponentCommon
      ▲
      ├── TComponentTextLabel
      ├── TComponentButton
      ├── TComponentBadge
      ├── TComponentDivider
      ├── TComponentComboBox
      └── TComponentEdit
```

A classe-base é abstrata e não conhece `TSampleComponent`. Ela define somente formulário, header, retorno, geometria, cards e painel informativo compartilhados.

Cada página derivada decide explicitamente:

- título;
- subtítulo;
- texto de `Sobre este componente`;
- presença de Factory;
- presença/posição de Fluent Builder.

Não existe array central de títulos/subtítulos/descrições dos seis componentes e não existe `SupportsFactory` na classe-base.

## Geometria comum

A implementação atual usa:

| Elemento | Valor |
|---|---:|
| ClientWidth | `500` |
| ClientHeight | `500` |
| Header | `40` |
| Margem horizontal de conteúdo | `24` |
| Largura útil | `452` |
| Card | `220 × 188` |
| Gap entre cards | `12` |
| Top dos cards | `152` |
| Top do painel de informação | `356` |
| Altura do painel de informação | `126` |

O formulário usa `TFmxFormBorderStyle.None`, seguindo o mesmo princípio visual da Home: não existe title bar nativa acima do header do Samples.

A geometria foi ampliada em relação à primeira tentativa para acomodar os maiores subtítulos e textos informativos atuais sem reduzir a tipografia.

## Header e retorno

```text
┌────────────────────────────────────────────────────────────┐
│  ←   Componentes                                           │
├────────────────────────────────────────────────────────────┤
```

A seta possui uma área clicável maior que o SVG, cursor `crHandPoint` e feedback de hover. O clique executa `Close` na modal atual. O SVG interno usa `HitTest := False`.

O retorno mantém o fluxo existente:

```text
TComponentCommon.Close
        ↓
ShowModal retorna
        ↓
TSampleApplicationCoordinator libera a página
        ↓
Home volta a ficar ativa
```

## Identidade do componente

Abaixo do header, a página derivada adiciona:

- título com `_FONT_SIZE_PAGE_TITLE_ = 24`;
- subtítulo com `_FONT_SIZE_PAGE_SUBTITLE_ = 14`;
- alinhamento à esquerda;
- quebra de linha habilitada no subtítulo;
- área vertical suficiente para duas linhas sem invadir os cards.

## Cards de abordagem

Quando Factory e Fluent Builder estão disponíveis:

```text
┌──────────────────────┐  ┌──────────────────────┐
│      [Factory]       │  │       [Link]         │
│       Factory        │  │   Fluent Builder     │
│   Criação direta     │  │    API encadeada     │
│   do componente.     │  │  para configuração.  │
│  [ Ver exemplos  › ] │  │  [ Ver exemplos  › ] │
└──────────────────────┘  └──────────────────────┘
```

Quando somente Fluent Builder existe, como no Edit, o card permanece centralizado e recebe callback somente quando a Sample Page concreta existe:

```text
              ┌──────────────────────┐
              │       [Link]         │
              │   Fluent Builder     │
              │    API encadeada     │
              │  para configuração.  │
              │  [ Ver exemplos  › ] │
              └──────────────────────┘
```

O card único é centralizado. Não existe placeholder de Factory.

`Ver exemplos` recebe `HitTest := True`, `crHandPoint` e callback somente quando existe destino real. A implementação atual expõe exatamente os onze destinos listados nesta especificação; não há card funcional apontando para página inexistente.

## Assets vetoriais

Os paths da família de páginas ficam em `RickUIBuilder.Samples.Component.Common.Icons`; dimensões, cores e espaçamentos específicos ficam em `RickUIBuilder.Samples.Component.Common.Style`.

| Uso | Asset fornecido |
|---|---|
| Factory | `factory_24dp_E3E3E3_FILL0_wght400_GRAD0_opsz24.svg` |
| Fluent Builder | `link-03-svgrepo-com.svg` |
| Informação | `info_48dp_E3E3E3_FILL0_wght400_GRAD0_opsz48.svg` |

A geometria do Factory e do ícone de informação é renderizada por fill. O Fluent Builder preserva o desenho baseado em stroke.

## Painel “Sobre este componente”

```text
┌────────────────────────────────────────────────────────────┐
│  ⓘ  Sobre este componente                                  │
│                                                            │
│     Texto técnico da página concreta, com quebra de linha  │
│     e altura reservada para o maior conteúdo atual.        │
└────────────────────────────────────────────────────────────┘
```

O painel possui área de texto de `74` unidades de altura dentro de um container de `126`, evitando o corte observado na primeira versão.

## Tipografia

A família reutiliza `RickUIBuilder.Samples.App.Typography`:

| Papel | Token | Tamanho |
|---|---|---:|
| Título da página | `_FONT_SIZE_PAGE_TITLE_` | 24 |
| Subtítulo | `_FONT_SIZE_PAGE_SUBTITLE_` | 14 |
| Título do card | `_FONT_SIZE_CARD_TITLE_` | 16 |
| Corpo/descrições | `_FONT_SIZE_BODY_` | 14 |
| Ação | `_FONT_SIZE_ACTION_` | 14 |
| Navegação | `_FONT_SIZE_NAVIGATION_` | 13 |

A geometria deve acomodar essa escala. Não reduzir fonte para mascarar clipping.

## Conteúdo das seis páginas

### Text / Label

**Classe:** `TComponentTextLabel`

**Subtítulo:** `Crie e configure textos FireMonkey com Rick.UIBuilder.`

**Abordagens:** Factory + Fluent Builder.

**Sobre:** `Text / Label cria TLabel em runtime. A Factory cobre a configuração textual básica e o Fluent Builder complementa a configuração visual e de layout.`

```text
┌────────────────────────────────────────────────────────────┐
│  ←   Componentes                                           │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  Text / Label                                              │
│  Crie e configure textos FireMonkey com Rick.UIBuilder.    │
│                                                            │
│  ┌────────────────────┐  ┌────────────────────┐            │
│  │      Factory       │  │   Fluent Builder   │            │
│  │  Ver exemplos  ›   │  │  Ver exemplos  ›   │            │
│  └────────────────────┘  └────────────────────┘            │
│                                                            │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ ⓘ Sobre este componente                             │  │
│  │ Text / Label cria TLabel em runtime...               │  │
│  └──────────────────────────────────────────────────────┘  │
└────────────────────────────────────────────────────────────┘
```

### Button

**Classe:** `TComponentButton`

**Subtítulo:** `Crie e configure botões FireMonkey com Rick.UIBuilder.`

**Abordagens:** Factory + Fluent Builder.

**Sobre:** `Button é composto por TRectangle + TLabel. A Factory materializa a estrutura visual e o Fluent Builder acrescenta configuração e comportamento de hover.`

A referência visual original mencionava `TButton`, mas a implementação real do Rick.UIBuilder materializa o Button como `TRectangle + TLabel`; a página preserva a verdade técnica do código. Factory possui callback real para `TExampleButtonFactory` e Fluent Builder possui callback real para `TExampleButtonFluent`.

### Badge

**Classe:** `TComponentBadge`

**Subtítulo:** `Crie badges compostos e configure sua apresentação com Rick.UIBuilder.`

**Abordagens:** Factory + Fluent Builder.

**Sobre:** `Badge combina TRectangle + TLabel e pode ser criado pela Factory ou configurado pelo Fluent Builder, incluindo as opções visuais próprias do componente.`

Factory possui callback real para `TExampleBadgeFactory`; Fluent Builder possui callback real para `TExampleBadgeFluent`.

### Divider

**Classe:** `TComponentDivider`

**Subtítulo:** `Crie separadores horizontais ou verticais com Rick.UIBuilder.`

**Abordagens:** Factory + Fluent Builder.

**Sobre:** `Divider usa TRectangle como separador horizontal ou vertical e pode ser criado pela Factory ou configurado pelo Fluent Builder.`

Factory possui callback real para `TExampleDividerFactory` e Fluent Builder para `TExampleDividerFluent`; a Component Page apenas emite as intenções.

### ComboBox

**Classe:** `TComponentComboBox`

**Subtítulo:** `Crie seleções FireMonkey configuráveis com Rick.UIBuilder.`

**Abordagens:** Factory + Fluent Builder.

**Sobre:** `Factory e Fluent Builder demonstram listas, seleção, apresentação, eventos e runtime do ComboBox por suas APIs públicas.`

Factory possui callback real para `TExampleComboBoxFactory` e Fluent Builder para `TExampleComboBoxFluent`; a Component Page apenas emite as duas intenções.

### Edit

**Classe:** `TComponentEdit`

**Subtítulo:** `Crie campos de texto de uma linha em runtime com Rick.UIBuilder.`

**Abordagens:** somente Fluent Builder.

**Sobre:** `Edit é o builder de entrada de texto de uma linha do Rick.UIBuilder. No estado atual da API, ele está disponível pelo Fluent Builder e não possui Factory.CreateEdit.`

Fluent Builder possui callback real para `TExampleEditFluent`; a Component Page mantém o card centralizado e apenas emite a intenção ao Coordinator.

```text
┌────────────────────────────────────────────────────────────┐
│  ←   Componentes                                           │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  Edit                                                      │
│  Crie campos de texto de uma linha em runtime com          │
│  Rick.UIBuilder.                                           │
│                                                            │
│                 ┌────────────────────┐                     │
│                 │   Fluent Builder   │                     │
│                 │  Ver exemplos  ›   │                     │
│                 └────────────────────┘                     │
│                                                            │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ ⓘ Sobre este componente                             │  │
│  │ Edit é o builder de entrada de texto...              │  │
│  └──────────────────────────────────────────────────────┘  │
└────────────────────────────────────────────────────────────┘
```

## Integração com a terceira camada

A ação `Ver exemplos` é conectada individualmente aos destinos reais. Text / Label, Button, Badge, Divider e ComboBox abrem Factory e Fluent Builder; Edit abre somente Fluent Builder, porque a API pública atual não expõe `Factory.CreateEdit`. A terceira camada implementada é especificada em `SAMPLE_EXAMPLE_PAGE_BASE_SPEC.md`.

A Component Page continua tendo somente a responsabilidade de escolher a abordagem. Ela não deve absorver menu lateral, código Delphi, resultado executável ou qualquer sample real.

## Limites de responsabilidade

`TComponentCommon` pode conhecer:

- regras visuais comuns da família;
- geometria;
- cores locais;
- header e retorno;
- construção comum de cards e painel informativo.

`TComponentCommon` não pode conhecer:

- `TSampleComponent`;
- arrays com conteúdo dos seis componentes;
- regra específica `Edit não possui Factory`;
- catálogo global das páginas Factory/Fluent da terceira camada;
- samples concretos pertencentes à terceira camada; no estado atual, Text / Label, Button, Badge, Divider e ComboBox possuem Factory + Fluent e Edit possui apenas Fluent.

Cada página concreta pode conhecer somente o conteúdo e as abordagens do seu próprio componente.

## Critérios de aceitação

A implementação deve manter simultaneamente:

- ausência de barra nativa do sistema;
- header no topo e em toda a largura do client;
- retorno clicável fechando a modal;
- subtítulos completos sem sobreposição;
- cards sem clipping;
- painel informativo sem cortar linhas;
- tipografia aprovada preservada;
- Factory ausente no Edit sem espaço vazio;
- nenhuma dependência de Components para `Home.Style`;
- uma unit concreta por componente herdando de `TComponentCommon`;
- `.dpr` e `.dproj` contendo explicitamente todas as units;
- nenhum `samples/src` no Search Path;
- nenhum callback habilitado para destino inexistente; Text / Label, Button, Badge, Divider e ComboBox possuem Factory/Fluent concretos, e Edit possui Fluent concreto nesta etapa.
