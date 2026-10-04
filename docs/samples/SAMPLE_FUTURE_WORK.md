# Trabalho futuro do RickUIBuilder.Samples

## Composition

A API pública possui Composition por meio de `TRickUIBuilder.On(AParent)`. A posição dessa abordagem nas páginas component-first ainda não foi implementada. Não adicionar a opção até existir decisão explícita de UX e mapeamento dos exemplos suportados.

## Páginas de samples Factory e Fluent Builder

As páginas intermediárias de `Text / Label`, `Button`, `Badge`, `Divider`, `ComboBox` e `Edit` já existem como páginas concretas herdadas de `TComponentCommon`.

Elas apresentam somente a divisão entre as abordagens suportadas. As páginas posteriores que realmente conterão os samples de Factory e Fluent Builder **ainda não existem**.

Quando essas páginas forem implementadas:

- derivar os exemplos da API pública real naquele momento;
- definir a navegação concreta a partir de `Ver exemplos`;
- não reaproveitar callback vazio ou destino provisório;
- manter cada componente responsável por seus próprios exemplos e controles;
- revisar a documentação após a implementação final.

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
