# Trabalho futuro do RickUIBuilder.Samples

## Composition

A API pública possui Composition por meio de `TRickUIBuilder.On(AParent)`. A posição dessa abordagem nas páginas component-first ainda não foi implementada. Não adicionar a opção até existir decisão explícita de UX e mapeamento dos exemplos suportados.

## Sample Page Base e páginas de exemplos Factory/Fluent Builder

As páginas intermediárias de `Text / Label`, `Button`, `Badge`, `Divider`, `ComboBox` e `Edit` já existem como páginas concretas herdadas de `TComponentCommon`.

A próxima etapa possui agora uma especificação documental em `SAMPLE_EXAMPLE_PAGE_BASE_SPEC.md`, mas **nenhuma Sample Page Base ou página concreta de exemplos foi implementada ainda**.

A evolução prevista é deliberadamente faseada:

1. implementar e validar somente a Sample Page Base;
2. manter essa base sem conhecimento de componente ou abordagem específica;
3. depois criar páginas derivadas concretas por componente/abordagem;
4. em cada derivada, levantar a API pública vigente e cobrir suas funcionalidades com exemplos reais;
5. somente após existir um destino concreto, conectar `Ver exemplos` da Component Page.

A matriz atualmente esperada pela API conhecida é: Text / Label, Button, Badge, Divider e ComboBox com Factory + Fluent Builder; Edit apenas com Fluent Builder enquanto não existir `Factory.CreateEdit`. Essa matriz deve ser revalidada contra a API real no momento de cada implementação.

## `Ver exemplos`

Na implementação atual, `Ver exemplos` é somente visual e permanece com `HitTest := False`. Essa decisão evita comunicar uma navegação inexistente como funcionalidade pronta.

A interatividade deve ser habilitada somente quando a página de destino correspondente existir.

## Factory.Edit

No estado analisado, `TRickUIBuilderFactory` não expõe `CreateEdit`. Por isso, `TComponentEdit` apresenta apenas Fluent Builder e centraliza o card.

Se a API mudar, revisar novamente o contrato público antes de alterar o Samples. Não criar entrada Factory vazia, desabilitada ou fictícia.

## Samples reais por componente

Os controles e demonstrações reais de uso do Rick.UIBuilder pertencem às futuras páginas Factory/Fluent Builder, e não às páginas intermediárias implementadas nesta etapa.

Nenhum sample real deve ser adicionado à `TComponentCommon` base somente para antecipar esse trabalho futuro.

## Testes do Samples

Não existem testes automatizados específicos do projeto `samples/` nesta etapa. Quando a navegação para as páginas de exemplos e os comportamentos associados forem implementados, avaliar testes do Coordinator e das regras de navegação sem acoplamento desnecessário a controles FMX.
