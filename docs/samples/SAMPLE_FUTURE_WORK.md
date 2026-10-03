# Trabalho futuro do RickUIBuilder.Samples

## Composition

A API pública possui Composition por meio de `TRickUIBuilder.On(AParent)`. A posição dessa abordagem nas páginas component-first ainda não foi implementada. Não adicionar a opção até existir decisão explícita de UX e mapeamento dos exemplos suportados.

## Component Page — layout aprovado e implementação pendente

A próxima evolução visual da página intermediária de componente já possui especificação aprovada em [`SAMPLE_COMPONENT_PAGE_SPEC.md`](SAMPLE_COMPONENT_PAGE_SPEC.md). O documento define o modelo comum das seis variações, os textos-alvo baseados na API atual, os assets oficiais e os critérios visuais.

Esse layout ainda não deve ser descrito como comportamento implementado até a `TComponentPage` ser alterada e validada.

## Exemplos Factory e Fluent

As páginas de componente atuais apresentam as abordagens suportadas, mas ainda não implementam as telas de exemplos específicos de Factory e Fluent Builder. Cada exemplo futuro deve ser derivado da API pública real no momento da implementação.

A especificação visual aprovada inclui a ação `Ver exemplos` como parte do layout-alvo final. Enquanto não existir uma página de destino real para cada abordagem, não criar callback vazio, navegação fictícia ou afirmar que essa ação já funciona.

## Factory.Edit

No estado analisado, `TRickUIBuilderFactory` não expõe `CreateEdit`. Não criar entrada Factory vazia, desabilitada ou fictícia para Edit. Se a API mudar, revisar novamente o contrato público antes de alterar o Samples.

## Navegação de retorno

A página de componente é aberta modalmente e o retorno ocorre ao fechá-la. Uma experiência explícita de Back pode ser avaliada quando as páginas de exemplos forem implementadas.

## Testes do Samples

Não foram adicionados testes automatizados nesta etapa. Quando a infraestrutura de navegação e as páginas de exemplos crescerem, avaliar testes de Presenter/Coordinator sem acoplamento a controles FMX.
