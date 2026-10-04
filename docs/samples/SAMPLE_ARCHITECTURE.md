# Arquitetura do RickUIBuilder.Samples

## Objetivo

O Samples é um catálogo navegável da API pública atual do Rick.UIBuilder. A organização é **component-first**: a Home apresenta componentes e cada componente possui uma página intermediária própria para apresentar as formas de criação realmente suportadas.

## Fluxo atual

```text
Home
├── Text / Label ──► TComponentTextLabel
├── Button ─────────► TComponentButton
├── Badge ──────────► TComponentBadge
├── Divider ────────► TComponentDivider
├── ComboBox ───────► TComponentComboBox
└── Edit ───────────► TComponentEdit
                         │
                         └── herda TComponentCommon
                              ├── Factory        [quando suportado]
                              └── Fluent Builder
```

`Edit` não apresenta Factory porque a API pública analisada não expõe `Factory.CreateEdit`. Essa ausência descreve somente o estado atual da API.

A primeira navegação concreta da terceira camada existe para **Text / Label → Factory**. O card Factory de `TComponentTextLabel` emite uma intenção ao Coordinator, que abre `TExampleTextLabelFactory`. O card Fluent Builder de Text / Label e todos os cards de abordagem dos demais componentes permanecem somente visuais enquanto seus destinos não existirem.

Composition continua sendo uma abordagem pública do Rick.UIBuilder, mas não foi adicionada às páginas de componente. Sua apresentação no Samples permanece trabalho futuro até existir decisão específica de UX/navegação.

## Base e páginas concretas de componente

`RickUIBuilder.Samples.Component.Common` expõe a classe-base abstrata `TComponentCommon`, responsável somente pela infraestrutura visual comum:

- formulário FMX borderless;
- dimensões e superfície da janela;
- header superior;
- ação de retorno;
- geometria compartilhada de título/subtítulo;
- cards Factory/Fluent Builder;
- ação visual `Ver exemplos`;
- painel `Sobre este componente`;
- cores e espaçamentos específicos desta família de páginas.

A base **não conhece `TSampleComponent`**, não contém arrays de configuração dos seis componentes e não decide se um componente suporta Factory. Ela apenas permite que uma page concreta forneça callback para `Ver exemplos` quando o destino correspondente já existir.

Cada componente possui uma página concreta que herda de `TComponentCommon` e define apenas seu conteúdo e as abordagens que aparecem:

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

As páginas de Text / Label, Button, Badge, Divider e ComboBox adicionam Factory e Fluent Builder. `TComponentEdit` adiciona somente Fluent Builder e usa a variante centralizada do card.

Os SVGs compartilhados da família de páginas ficam em `RickUIBuilder.Samples.Component.Common.Icons`. A geometria e a paleta local ficam em `RickUIBuilder.Samples.Component.Common.Style`; `TComponentCommon` consome esses tokens e concentra a construção visual/comportamental comum.

## Navegação e retorno

A Home continua capturando somente a intenção de abrir um `TSampleComponent`:

```text
TPageSamplesHome
      │ intenção
      ▼
IHomePresenter
      ▲
      │ implementado por
THomePresenter
      │
      ▼
TSampleApplicationCoordinator
      │
      ▼
página concreta do componente
```

O `TSampleApplicationCoordinator` resolve `TSampleComponent` para a classe concreta correspondente, cria a página sem Owner, executa `ShowModal` e libera a instância no `finally`.

A seta de retorno da `TComponentCommon` fecha a janela modal atual. O retorno não cria Router, Presenter adicional ou nova camada de navegação: ao fechar a modal, o fluxo retorna ao Coordinator e a Home volta a ficar ativa.

## Sample Page Base e primeiro destino concreto

A terceira camada do Samples possui uma base visual/comportamental coordenada por `RickUIBuilder.Samples.Example.Common`, com classe abstrata `TExampleCommon`. A construção visual comum permanece separada em units coesas de header, navegação, seletor de visualização, painel de código e painel de resultado, além de ícones e estilo.

O primeiro destino concreto implementado é **Text / Label - Factory**:

```text
Home
  ↓
TComponentTextLabel
  ├── Factory ─────────► TExampleTextLabelFactory
  │                           ▲
  │                           └── herda TExampleCommon
  └── Fluent Builder ──► ainda não implementado
```

A implementação específica fica separada por responsabilidade:

- `RickUIBuilder.Samples.Example.TextLabel.Factory`: page concreta e coordenação da seleção;
- `RickUIBuilder.Samples.Example.TextLabel.Factory.Content`: captions, títulos, descrições e snippets;
- `RickUIBuilder.Samples.Example.TextLabel.Factory.Runner`: execução real de `TRickUIBuilderFactory.CreateText` no `ResultHost`.

A página demonstra cinco exemplos: `Básico`, `Geometria`, `Tipografia`, `Alinhamento` e `Completo`. Em conjunto, eles cobrem a criação via `CreateText`, o texto informado e todos os campos públicos atuais de `TRickUIBuilderTextConfig`: `Left`, `Top`, `Width`, `Height`, `FontSize`, `FontColor`, `HorizontalAlign` e `Bold`.

A base continua responsável somente pela infraestrutura comum:

- `TExampleCommon`: formulário FMX borderless, composição das regiões e API protegida para derivadas;
- `TExampleHeader`: header/back com contexto do componente pai;
- `TExampleNavigation` / `TExampleNavigationItem`: navegação lateral rolável e estado visual selecionado com indicador lateral azul;
- `TExampleViewSelector`: seleção funcional e mutuamente exclusiva entre `Código Delphi` e `Resultado`;
- `TExampleCodePanel`: superfície de código com scroll, sem responsabilidade de tabs;
- `TExampleResultPanel`: superfície de resultado, `ResultHost` e limpeza do resultado anterior.

`TExampleCommon` não conhece `TSampleComponent`, componentes concretos, regras específicas de Factory/Fluent, categorias fixas ou catálogo global de exemplos. A page concreta define sua navegação e delega conteúdo e execução às units específicas.

Ao selecionar um exemplo em Text / Label - Factory, a page seleciona visualmente o item, atualiza título/descrição/snippet, chama `ClearResult` e executa o mesmo exemplo no `ResultHost`. O código exibido e o resultado executado representam a mesma configuração.

A geometria da Sample Page permanece `620 × 510`, estritamente menor que a Home de `644 × 534`. `Código Delphi` e `Resultado` agora funcionam como duas views mutuamente exclusivas: a página inicia em `Código Delphi`; ao selecionar `Resultado`, o painel de código é ocultado e somente o painel de resultado fica visível, e o inverso ocorre ao retornar para `Código Delphi`.

A especificação visual e os textframes normativos dessa camada estão em `docs/samples/SAMPLE_EXAMPLE_PAGE_BASE_SPEC.md`.

## Boundary da Home

A Home é uma View FMX. Suas responsabilidades são apresentação, layout, estados visuais e captura de intenção. Ela não executa comandos de aplicação.

`IHomePresenter` contém apenas funções e representa as intenções `Close` e `OpenComponent`. `THomePresenter` não conhece controles FMX nem mantém referência à View.

O `TSampleApplicationCoordinator` executa o fluxo global: encerramento da aplicação e abertura da página concreta correspondente ao componente. Ele não contém detalhes visuais da Home nem das Component Pages.

## Composition Root e lifetime

`TSampleApplication`, em `RickUIBuilder.Samples.App.Bootstrap`, é o Composition Root. Ele cria o Coordinator, o Presenter e a Home.

- `TSampleApplication` possui o Coordinator e a Home durante `Application.Run`;
- a Home mantém `IHomePresenter` por reference counting;
- `THomePresenter` mantém referência não-owning ao Coordinator;
- o Presenter não referencia a Home;
- a Home é destruída antes do Coordinator;
- o Coordinator cria e libera cada Component Page modal;
- para Text / Label - Factory, o Coordinator também cria e libera a Sample Page modal;
- uma Component Page não possui Presenter, Coordinator ou Home; o callback de navegação é non-owning.

## Contratos

Contratos do Samples não usam `procedure`. Operações contratuais são funções. O contrato da Home é fluente e retorna `IHomePresenter`.

As operações atuais do Presenter não alteram estado contratual. A implementação delega a intenção ao Coordinator e retorna a própria interface sem mutar sua configuração.

## Organização atual

```text
samples/
├── RickUIBuilder.Samples.dpr
├── RickUIBuilder.Samples.dproj
└── src/
    ├── App/
    │   ├── RickUIBuilder.Samples.App.Bootstrap.pas
    │   ├── RickUIBuilder.Samples.App.Coordinator.pas
    │   ├── RickUIBuilder.Samples.App.Typography.pas
    │   └── RickUIBuilder.Samples.App.Types.pas
    ├── Home/
    │   ├── RickUIBuilder.Samples.Home.pas
    │   ├── RickUIBuilder.Samples.Home.ComponentCard.pas
    │   ├── RickUIBuilder.Samples.Home.Icons.pas
    │   ├── RickUIBuilder.Samples.Home.Presenter.Intf.pas
    │   ├── RickUIBuilder.Samples.Home.Presenter.pas
    │   └── RickUIBuilder.Samples.Home.Style.pas
    ├── Components/
        ├── Common/
        │   ├── RickUIBuilder.Samples.Component.Common.pas
        │   ├── RickUIBuilder.Samples.Component.Common.Icons.pas
        │   └── RickUIBuilder.Samples.Component.Common.Style.pas
        ├── TextLabel/
        │   └── RickUIBuilder.Samples.Component.TextLabel.pas
        ├── Button/
        │   └── RickUIBuilder.Samples.Component.Button.pas
        ├── Badge/
        │   └── RickUIBuilder.Samples.Component.Badge.pas
        ├── Divider/
        │   └── RickUIBuilder.Samples.Component.Divider.pas
        ├── ComboBox/
        │   └── RickUIBuilder.Samples.Component.ComboBox.pas
        └── Edit/
            └── RickUIBuilder.Samples.Component.Edit.pas
    └── Examples/
        ├── Common/
        │   ├── RickUIBuilder.Samples.Example.Common.pas
        │   ├── RickUIBuilder.Samples.Example.Common.Header.pas
        │   ├── RickUIBuilder.Samples.Example.Common.Navigation.pas
        │   ├── RickUIBuilder.Samples.Example.Common.ViewSelector.pas
        │   ├── RickUIBuilder.Samples.Example.Common.CodePanel.pas
        │   ├── RickUIBuilder.Samples.Example.Common.ResultPanel.pas
        │   ├── RickUIBuilder.Samples.Example.Common.Icons.pas
        │   └── RickUIBuilder.Samples.Example.Common.Style.pas
        └── TextLabel/
            ├── RickUIBuilder.Samples.Example.TextLabel.Factory.pas
            ├── RickUIBuilder.Samples.Example.TextLabel.Factory.Content.pas
            └── RickUIBuilder.Samples.Example.TextLabel.Factory.Runner.pas
```

Diretórios específicos de componentes existem porque possuem units concretas. `src/Examples/Common` contém a base comum; `src/Examples/TextLabel` existe porque a primeira página concreta Factory foi implementada. Novos diretórios de exemplos só podem ser criados quando houver implementação real correspondente.

Todas as units internas do Samples são incorporadas explicitamente ao `.dpr` e ao `.dproj`. O `DCC_UnitSearchPath` não contém o próprio `samples/src`; o caminho de busca permanece reservado à dependência externa `..\src` da biblioteca Rick.UIBuilder e ao Search Path herdado.

## Design visual

A Home mantém geometria e cores específicas em `Home.Style`. A escala tipográfica semanticamente reutilizável permanece em `App.Typography`.

A família de Component Pages não depende de `Home.Style`. Sua geometria e sua paleta local são definidas em `RickUIBuilder.Samples.Component.Common.Style`, consumida pela base `TComponentCommon`, evitando acoplamento de Components com uma unit específica da Home.

A Component Page atual usa client de `500 × 500`, formulário `TFmxFormBorderStyle.None` e header de `40` unidades alinhado ao topo. O conteúdo possui área suficiente para os maiores subtítulos e textos informativos atuais sem reduzir a escala tipográfica aprovada.

O header possui área clicável de retorno maior que o SVG, `crHandPoint` e feedback de hover. O SVG interno não captura o evento.

Os cards preservam os SVGs oficiais fornecidos:

- Factory: `factory_24dp_E3E3E3_FILL0_wght400_GRAD0_opsz24.svg`;
- Fluent Builder: `link-03-svgrepo-com.svg`;
- informação: `info_48dp_E3E3E3_FILL0_wght400_GRAD0_opsz48.svg`.

A geometria de Factory e informação é renderizada por fill; Fluent Builder usa stroke, seguindo os assets originais.

`Ver exemplos` permanece sem `HitTest` e sem callback quando o destino não existe. No estado atual, somente `Text / Label → Factory` recebe callback e `crHandPoint`, porque `TExampleTextLabelFactory` é um destino real.

A Sample Page Base usa geometria e paleta próprias em `RickUIBuilder.Samples.Example.Common.Style`, vetor de retorno em `.Icons` e controles estruturais separados em `.Header`, `.Navigation`, `.ViewSelector`, `.CodePanel` e `.ResultPanel`. `TExampleCommon` apenas os coordena. A página possui client de `620 × 510`, é borderless e permanece menor que a Home. A sequência visual segue o textframe normativo: header → identidade → navegação/conteúdo → identificação do exemplo → seletor `Código Delphi`/`Resultado` → uma única view ativa. O estado selecionado da navegação usa fundo azul-claro e indicador vertical azul; o painel de resultado usa a superfície clara e borda suave definidas pela referência aprovada.

## Encoding

As units Delphi modificadas que contêm texto em português são distribuídas em UTF-8 com BOM.

## Documentação estrutural das units

As units Delphi do Samples começam com cabeçalho estrutural que descreve o papel real da unit no estado final do código. Ele identifica finalidade, funcionalidade, dependências internas relevantes, colaboração/fluxo e restrições; ownership e lifetime são registrados quando fizerem parte da responsabilidade da unit.

Esse cabeçalho é uma orientação local para desenvolvedores e IA. Ele não é fonte superior ao código: os auditores devem confrontá-lo com `interface`, `implementation`, `uses` e consumidores reais. Alterações que modifiquem responsabilidade, dependências, fluxo ou lifetime exigem atualização simultânea do cabeçalho.

## Governança de auditoria Delphi

A governança local do Samples separa revisão técnica geral de gates especializados. Toda unit `.pas` criada ou modificada passa por Naming; alterações que possam afetar corpos de métodos passam também por Toxicity; mudanças relacionadas a interfaces, GUIDs, reference counting, ownership ou lifetime passam por Contract & Lifetime. O Delphi Code Auditor não substitui esses gates.

O catálogo em `samples/.agents/README.md` deve corresponder aos arquivos existentes em `samples/.agents/agents/`. O Final Process Compliance Auditor recalcula a aplicabilidade e verifica a existência e a evidência dos gates obrigatórios.

## Artefatos locais e pacote de entrega

`__history/`, `__recovery/`, `.identcache` e `.dproj.local` são artefatos locais/temporários da IDE e não representam a arquitetura oficial do Samples. Eles não devem integrar pacotes de entrega sem necessidade explícita e comprovada. Recursos necessários ao build, como `.res`, são mantidos ou removidos somente após verificação de sua referência real no projeto.
