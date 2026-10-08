# Registro histórico de validação da implementação do Edit

> Este arquivo registra validações realizadas na entrega original do Edit e na correção de 2026-09-27. Ele **não** representa validação da revisão atual do repositório. Build, testes, validação FMX e Method Toxicity da revisão atual exigem nova execução no ambiente Delphi/RAD Studio.

## Executado na entrega registrada

- leitura do `AGENTS.md` e workflows aplicáveis;
- leitura da especificação, backlog e plano técnico na ordem definida;
- inspeção da arquitetura real dos builders, handles e behaviors existentes;
- verificação estrutural dos arquivos `.dproj` como XML;
- verificação de inclusão das novas units no package/projeto e suíte de testes;
- verificação de unicidade dos novos GUIDs;
- verificação byte a byte de BOM UTF-8 (`EF BB BF`) em todos os `.pas` criados ou modificados;
- avaliação estática de `Parameters`, complexidade condicional e tamanho dos métodos novos, com decomposição dos pontos identificados durante a auditoria;
- revisão estática separada de ownership/lifetime, contratos e escopo.

## Não executado

O ambiente desta entrega não disponibilizou compilador Delphi/MSBuild nem RAD Studio. Portanto:

- **Compilação real: Não confirmada.**
- **Resultado DUnitX real: Não confirmado.**
- **Validação runtime FMX real: Não confirmada.**
- **Toxicity composta real do RAD Studio: Não confirmada.**

Os testes DUnitX foram adicionados ao projeto, mas a existência desses testes não é apresentada como evidência de execução.

## Lifetime

O `TRickUIBuilderEditBehavior` é criado com o `AParent` como Owner e mantém os eventos runtime vivos depois que o builder sai de escopo. Os controles visuais pertencem à árvore FMX iniciada pelo mesmo Parent. O `IRickUIBuilderEditHandle` é non-owning em relação aos controles e ao behavior; não deve ser usado após a destruição do Parent.

## Escopo preservado

Nenhum componente existente foi redesenhado. As alterações compartilhadas ficaram limitadas a `Types`, `Interfaces`, Facade e arquivos de projeto necessários para expor e registrar o novo `Edit`.

## Correção visual e operacional — 2026-09-27

Esta correção adiciona fundo interno configurável (transparente por padrão), área útil do `TEdit` calculada conforme as ações habilitadas, alinhamento dos ícones à direita e cores individuais para alert, clear, password e requisito. `IconColor` permanece como configuração global retrocompatível.

Foram adicionados testes de regressão para máscara progressiva do CPF, rejeição de letras e limite estrutural de 11 dígitos. Os resultados de testes/toxicidade obtidos antes desta correção não são usados como aprovação desta revisão.

Neste ambiente não foi executado Delphi/MSBuild/RAD Studio após estas alterações. Portanto, para esta revisão: **compilação real, execução DUnitX, validação FMX e Toxicity composta real permanecem Não confirmadas** até nova execução no ambiente Delphi.
