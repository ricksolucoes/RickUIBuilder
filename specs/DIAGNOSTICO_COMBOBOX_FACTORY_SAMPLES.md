# Diagnóstico e tentativas — ComboBox Factory Samples

## Tentativa 1 — ampliação funcional dos Samples

Status: **IMPLEMENTADA — execução real pendente**.

Base: Slice 3 / Tentativa 3 validado com 260/260 testes DUnitX.

Alterações executadas:
- `TComboBoxFactoryExample` ampliado de 7 para 15 exemplos;
- Factory Samples passam a demonstrar dados textuais, `DisplayText/Value`, itens estruturados/colunas, seleção, Desktop/Anchored, Mobile/FullWindow, callbacks, `OnCustomizeItem` e runtime handle;
- `TComboBoxFactoryRunner` passou de class methods para instância mantida pela Sample Page, necessário para callbacks `of object`;
- `Reset` zera referências non-owning antes de `ClearResult`;
- o exemplo `Completo` cobre 58/58 campos do config e todos os campos públicos atuais de `TRickUIBuilderComboBoxFactoryOptions`;
- governança e documentação dos Samples foram atualizadas para remover a limitação antiga de Factory visual-only.

Resultado de build: **Não confirmado**.

Resultado de execução do Samples: **Não confirmado**.

DUnitX após esta alteração: **Não executado neste ambiente**.

Method Toxicity composta: **Não executada**; depende de RAD Studio/CSV real.


## Tentativa 2 — revisão didática e indentação dos 15 snippets

Status: **IMPLEMENTADA — execução real pendente**.

Evidência de entrada: a execução visual do Samples mostrou que os snippets da aba `Código Delphi` não continham as declarações/inicializações necessárias para reprodução independente. Também foi identificado um defeito semântico no exemplo `Handle runtime`: o snippet exibido operava `LHandle` antes de `TRickUIBuilderFactory.CreateComboBox`.

Ajuste executado:
- os 15 snippets agora mostram `var`, `TRickUIBuilderComboBoxConfig.Default`, `TRickUIBuilderComboBoxFactoryOptions.Default`, dados/opções relevantes, `IRickUIBuilderComboBoxHandle` e a chamada `CreateComboBox`;
- helpers internos do Runner (`BasicOptions`, `TextItems`, `FixedColumn`, `ProportionalColumn`, `AutoColumn`) não são pré-requisito do código exibido;
- arrays, blocos `var/begin/end`, chamadas quebradas e atribuições foram reindentados em formato Delphi legível;
- `Handle runtime` cria o ComboBox antes de executar `Add`, `Select*`, `SetArrow*`, `Open` e `Close`;
- `Eventos` mostra as assinaturas dos três handlers `of object`;
- `Customização de item` mostra a assinatura e a implementação de `OnCustomizeItem`, incluindo o requisito de lifetime da instância;
- `Completo` permanece exaustivo e foi tornado independente de callbacks invisíveis, atribuindo explicitamente `nil` aos quatro callbacks;
- Runner e snippet `Completo` foram sincronizados nesse ponto;
- a governança dos Samples passou a reprovar snippets dependentes de helpers privados/invisíveis ou com ordem de uso incorreta da API.

Validação estática:
- 15/15 snippets possuem comentários introdutórios, inicialização de `Config`, inicialização de `FactoryOptions` e chamada `CreateComboBox`;
- `Handle runtime`: `CreateComboBox` aparece antes da primeira operação em `LHandle`;
- `Completo`: 58/58 campos de `TRickUIBuilderComboBoxConfig` e 14/14 campos de `TRickUIBuilderComboBoxFactoryOptions`;
- arquivos `.pas` modificados permanecem UTF-8 com BOM.

Resultado de build: **Não confirmado**.

Resultado de execução do Samples após o ajuste: **Não confirmado**.

DUnitX após esta alteração: **Não executado neste ambiente**.

Method Toxicity composta: **Não executada**; depende de RAD Studio/CSV real.
