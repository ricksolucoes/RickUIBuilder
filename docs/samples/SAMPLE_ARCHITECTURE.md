# Arquitetura do RickUIBuilder.Samples

## Objetivo

O Samples é um catálogo navegável da API pública atual do Rick.UIBuilder. A organização é **component-first**: a Home apresenta componentes e cada página de componente apresenta somente as formas de criação realmente suportadas.

## Fluxo atual

```text
Home
├── Text / Label
├── Button
├── Badge
├── Divider
├── ComboBox
└── Edit
       │
       └── Component Page
            ├── Factory        [quando suportado]
            └── Fluent Builder
```

`Edit` não apresenta Factory porque a API pública analisada não expõe `Factory.CreateEdit`. Essa ausência descreve somente o estado atual da API.

Composition continua sendo uma abordagem pública do Rick.UIBuilder, mas não foi adicionada às páginas de componente nesta implementação. Sua apresentação no Samples permanece trabalho futuro até existir uma decisão específica de UX/navegação.

## Boundary da Home

A Home é uma View FMX. Suas responsabilidades são apresentação, layout, estados visuais e captura de intenção. Ela não executa comandos de aplicação.

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
```

`IHomePresenter` contém apenas funções e representa as intenções `Close` e `OpenComponent`. `THomePresenter` não conhece controles FMX nem mantém referência à View.

O `TSampleApplicationCoordinator` executa o fluxo global: encerramento da aplicação e abertura da página correspondente ao componente. Não contém detalhes visuais da Home.

## Composition Root e lifetime

`TSampleApplication`, em `RickUIBuilder.Samples.App.Bootstrap`, é o Composition Root. Ele cria o Coordinator, o Presenter e a Home.

- `TSampleApplication` possui o Coordinator e a Home durante `Application.Run`.
- a Home mantém `IHomePresenter` por reference counting;
- `THomePresenter` mantém uma referência não-owning ao Coordinator;
- o Presenter não referencia a Home;
- a Home é destruída antes do Coordinator.

Esse desenho evita ciclo View ↔ Presenter e não introduz reference counting no Coordinator.

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
    └── Components/
        └── Common/
            └── RickUIBuilder.Samples.ComponentPage.pas
```

A estrutura física acompanha responsabilidades que já existem. Não são criadas pastas `Label`, `Button`, `Badge`, `Divider`, `ComboBox` ou `Edit` enquanto não existirem units específicas que as justifiquem.

Todas as units internas do Samples são incorporadas explicitamente ao `.dpr` e ao `.dproj`. O `DCC_UnitSearchPath` não contém o próprio `samples/src`; o caminho de busca fica reservado à dependência externa `..\src` da biblioteca Rick.UIBuilder e ao Search Path herdado.

## Design visual

A Home mantém geometria e cores específicas em `Home.Style`. A escala tipográfica semanticamente reutilizável permanece em `App.Typography`.

O header é filho direto do formulário, usa alinhamento superior e ocupa toda a largura do client, sem margem externa superior ou lateral. O respiro pertence ao conteúdo abaixo do header. O header possui superfície discretamente diferente do body.

Controles efetivamente clicáveis usam `crHandPoint`. O fechamento possui área de hit maior que o SVG e feedback de hover. Os botões `Ver exemplos` são clicáveis porque a navegação para a página de componente está implementada.

Os cards preservam a escala tipográfica aprovada e possuem geometria suficiente para título, descrição e ação sem recorte ou sobreposição.

Os SVGs oficiais fornecidos são usados como `TPath`; não há substituição por caracteres textuais.

## Encoding

As units Delphi modificadas que contêm texto em português são distribuídas em UTF-8 com BOM.

## Documentação estrutural das units

As units Delphi do Samples começam com um cabeçalho estrutural que descreve o papel real da unit no estado final do código. Ele identifica finalidade, funcionalidade, dependências internas relevantes, colaboração/fluxo e restrições; ownership e lifetime são registrados quando fizerem parte da responsabilidade da unit.

Esse cabeçalho é uma orientação local para desenvolvedores e IA. Ele não é fonte superior ao código: os auditores devem confrontá-lo com `interface`, `implementation`, `uses` e consumidores reais. Alterações que modifiquem responsabilidade, dependências, fluxo ou lifetime exigem atualização simultânea do cabeçalho.



## Governança de auditoria Delphi

A governança local do Samples separa revisão técnica geral de gates especializados. Toda unit `.pas` criada ou modificada passa por Naming; alterações que possam afetar corpos de métodos passam também por Toxicity; mudanças relacionadas a interfaces, GUIDs, reference counting, ownership ou lifetime passam por Contract & Lifetime. O Delphi Code Auditor não substitui esses gates.

O catálogo em `samples/.agents/README.md` deve corresponder aos arquivos existentes em `samples/.agents/agents/`. O Final Process Compliance Auditor recalcula a aplicabilidade e verifica a existência e a evidência dos gates obrigatórios.

## Artefatos locais e pacote de entrega

`__history/`, `__recovery/`, `.identcache` e `.dproj.local` são artefatos locais/temporários da IDE e não representam a arquitetura oficial do Samples. Eles não devem integrar pacotes de entrega sem necessidade explícita e comprovada. Recursos necessários ao build, como `.res`, são mantidos ou removidos somente após verificação de sua referência real no projeto.
