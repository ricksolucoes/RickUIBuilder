# Trabalho futuro do RickUIBuilder.Samples

## Composition

A API pública possui Composition por meio de `TRickUIBuilder.On(AParent)`. A posição dessa abordagem nas páginas component-first ainda não foi implementada. Não adicionar a opção até existir decisão explícita de UX e mapeamento dos exemplos suportados.

## Sample Page Base e páginas de exemplos Factory/Fluent Builder

As páginas intermediárias de `Text / Label`, `Button`, `Badge`, `Divider`, `ComboBox` e `Edit` já existem como páginas concretas herdadas de `TComponentCommon`.

A Sample Page Base já está implementada e coordenada por `RickUIBuilder.Samples.Example.Common` (`TExampleCommon`). Header, navegação, seletor Código/Resultado, painel de código e painel de resultado ficam separados em `.Header`, `.Navigation`, `.View.Selector`, `.Code.Panel` e `.Result.Panel`; tokens permanecem em `.Style` e o vetor comum de retorno em `.Icons`. O seletor já alterna funcionalmente views mutuamente exclusivas, iniciando em `Código Delphi`. **Text / Label - Factory, Text / Label - Fluent Builder, Button - Factory, Button - Fluent Builder, Badge - Factory, Badge - Fluent Builder, Divider - Factory, Divider - Fluent Builder, ComboBox - Factory, ComboBox - Fluent Builder e Edit - Fluent Builder estão implementadas**. Essa é toda a matriz component-first suportada pela API pública atual; novos destinos dependem de mudança real da API ou de decisão específica para Composition.

Os enums atualmente compartilhados pela terceira camada ficam em `RickUIBuilder.Samples.App.Types`: `TExampleView` para a view ativa, `TTextLabelFactoryExample` para Text / Label - Factory, `TTextLabelFluentExample` para Text / Label - Fluent Builder, `TButtonFactoryExample` para Button - Factory, `TButtonFluentExample` para Button - Fluent Builder, `TBadgeFactoryExample` para Badge - Factory, `TBadgeFluentExample` para Badge - Fluent Builder, `TDividerFactoryExample` para Divider - Factory, `TDividerFluentExample` para Divider - Fluent Builder, `TComboBoxFactoryExample` para ComboBox - Factory, `TComboBoxFluentExample` para ComboBox - Fluent Builder e `TEditFluentExample` para Edit - Fluent Builder. Essa localização descreve o código vigente e deve ser revista somente se a arquitetura real mudar.

Para qualquer evolução futura, preservar esta sequência:

1. manter `TExampleCommon` sem conhecimento de componente ou abordagem específica;
2. criar nova página derivada somente quando existir uma abordagem pública real a demonstrar;
3. levantar a API pública vigente e cobrir suas funcionalidades com exemplos reais;
4. validar ownership/limpeza do `ResultHost` para os controles executados;
5. somente após existir o destino concreto, conectar `Ver exemplos` da Component Page.

A matriz atualmente esperada pela API conhecida é: Text / Label, Button, Badge, Divider e ComboBox com Factory + Fluent Builder; Edit apenas com Fluent Builder enquanto não existir `Factory.CreateEdit`. Essa matriz deve ser revalidada contra a API real no momento de cada implementação.

## `Ver exemplos`

Na implementação atual, `Text / Label → Factory`, `Text / Label → Fluent Builder`, `Button → Factory`, `Button → Fluent Builder`, `Badge → Factory`, `Badge → Fluent Builder`, `Divider → Factory`, `Divider → Fluent Builder`, `ComboBox → Factory`, `ComboBox → Fluent Builder` e `Edit → Fluent Builder` possuem destinos reais e ações clicáveis. Nenhuma abordagem sem destino é apresentada como opção funcional.

Em evoluções futuras, a interatividade só deve ser habilitada quando a página de destino correspondente existir.

## Factory.Edit

No estado analisado, `TRickUIBuilderFactory` não expõe `CreateEdit`. Por isso, `TComponentEdit` apresenta apenas Fluent Builder e centraliza o card.

Se a API mudar, revisar novamente o contrato público antes de alterar o Samples. Não criar entrada Factory vazia, desabilitada ou fictícia.

## Samples reais por componente

Os controles e demonstrações reais pertencem às páginas concretas Factory/Fluent Builder, e não às Component Pages intermediárias. `Text / Label - Factory`, `Text / Label - Fluent Builder`, `Button - Factory`, `Button - Fluent Builder`, `Badge - Factory`, `Badge - Fluent Builder`, `Divider - Factory`, `Divider - Fluent Builder`, `ComboBox - Factory`, `ComboBox - Fluent Builder` e `Edit - Fluent Builder` já materializam resultados reais. Novos destinos só pertencem a este documento quando houver capacidade pública correspondente ou uma decisão de navegação para Composition.

Nenhum sample real deve ser adicionado à `TComponentCommon` ou `TExampleCommon`: conteúdo e execução permanecem nas derivadas concretas.

## Testes do Samples

Não existem testes automatizados específicos do projeto `samples/` nesta etapa. Como a navegação Text / Label → Factory/Fluent Builder, Button → Factory/Fluent Builder, Badge → Factory/Fluent Builder, Divider → Factory/Fluent Builder, ComboBox → Factory/Fluent Builder e Edit → Fluent Builder já foi implementada, permanece como trabalho futuro avaliar testes do Coordinator, da seleção de exemplos e das regras de navegação sem acoplamento desnecessário a controles FMX.
