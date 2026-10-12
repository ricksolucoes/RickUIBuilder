# Arquitetura e manutenção do Edit

🇺🇸 [English](arquitetura-e-manutencao.md)

Este documento registra as decisões arquiteturais já estabelecidas para o **novo Edit** em construção dentro de `src/Edit/`. Ele é documentação de arquitetura e manutenção; não significa que a migração já esteja concluída.

O Edit legado permanece no repositório e continua sendo a implementação validada até que a nova arquitetura seja completamente revisada e aceita pelo responsável pelo projeto.

## Limite da migração

A nova implementação fica em:

```text
src/Edit/
```

A implementação legada permanece fora desse diretório e não deve ser removida nem reescrita como parte da nova arquitetura, a menos que uma tarefa autorize isso explicitamente.

O legado pode ser consultado como evidência de comportamento, mas não define a organização física da nova implementação. A nova implementação não deve depender das units legadas do Edit.

## Fonte de verdade do contrato

O contrato oficial de interfaces do novo Edit é:

```text
src/Edit/Rick.UIBuilder.Edit.Interfaces.pas
```

Todas as interfaces públicas do novo Edit permanecem nessa unit.

Durante a implementação, esse arquivo é **read-only por padrão**. A implementação deve se adaptar ao contrato existente. A interface só pode ser alterada quando o usuário solicitar explicitamente uma mudança de contrato na tarefa atual.

Conveniência da implementação não autoriza alterar:

- retorno de método;
- parâmetro;
- overload;
- GUID;
- nome de membro;
- spelling público;
- navegação fluent;
- nem adicionar getter, state, runtime, handle ou outro membro público.

Se o contrato parecer incomum, ele deve ser preservado até existir uma tarefa explícita de alteração contratual.

## Boundary de Types

Records, enums e demais types compartilhados do domínio do novo Edit permanecem em:

```text
src/Edit/Rick.UIBuilder.Edit.Types.pas
```

Não declare records, enums, DTOs ou configurações compartilhadas de domínio dentro das units concretas de implementação.

## Uma interface pública, uma implementação, uma unit

O novo Edit possui uma regra específica de organização física:

```text
1 interface pública
        ↓
1 classe concreta correspondente
        ↓
1 unit exclusiva de implementação
```

Para o contrato atual, isso significa:

```text
28 interfaces públicas
=
28 classes concretas
=
28 units de implementação
```

A correspondência nominal deve ser preservada:

```text
I<Nome>
→ T<Nome>
→ unit exclusiva de implementação
```

Exemplo:

```text
IRickUIBuilderEditRetangle
→ TRickUIBuilderEditRetangle
→ Rick.UIBuilder.Edit.Rectangle.pas
```

Não reagrupe implementações irmãs como Rectangle.Position, Rectangle.Size, Rectangle.Background e Rectangle.Border dentro de uma única unit de implementação.

Essa regra 1 → 1 → 1 é uma decisão específica do novo Edit. Ela não deve ser generalizada automaticamente para outros componentes do RickUIBuilder.

## Infraestrutura interna não faz parte das 28 implementações

O novo Edit também utiliza classes internas que não correspondem às interfaces públicas. Entre as units já identificadas no trabalho de implementação estão:

```text
Rick.UIBuilder.Edit.Context.pas
Rick.UIBuilder.Edit.InputRules.pas
Rick.UIBuilder.Edit.Control.pas
Rick.UIBuilder.Edit.Interaction.pas
Rick.UIBuilder.Edit.Materializer.pas
```

Essas units são helpers/infraestrutura. Elas não entram na contagem das 28 implementações públicas.

Não transforme helpers em interfaces apenas para deixar a arquitetura simétrica. Uma nova abstração só deve existir quando houver responsabilidade arquitetural real e o escopo da tarefa autorizar.

## A implementação se adapta ao contrato

Quando uma implementação precisar de contexto, estado ou acesso a outro nível da cadeia fluent, não altere a interface para facilitar a navegação.

A direção esperada é:

```text
contrato oficial
        ↓
implementação concreta
        ↓
usa contratos/origem existentes
para obter o contexto necessário
```

E não:

```text
implementação precisa de algo
        ↓
altera interface pública
        ↓
adiciona retorno/getter/caminho conveniente
```

Se a informação necessária já pertence a outra interface, dependa desse contrato existente. Quando existir uma origem/pai clara, forneça o contrato necessário à implementação especializada por Dependency Injection quando aplicável.

Não substitua essa relação por:

- getter público novo;
- interface nova apenas para transportar estado;
- estado duplicado;
- global ou service locator;
- recriação do Parent;
- segundo caminho para o mesmo contexto.

Dependency Inversion aqui significa depender do contrato correto que já existe. Não significa criar outra interface por simetria.

## Exemplo de retorno fluent

Quando uma interface especializada existente deve retornar ao contrato de origem, a implementação precisa ter acesso a esse contrato de origem.

Conceitualmente:

```text
MainText
   ↓ Color
MainTextColor
   ↓ Invalid(...)
MainText
```

Se `Invalid(...)` está declarado para retornar `IRickUIBuilderEditLabelMainText`, a implementação concreta de Color precisa conseguir retornar esse contrato existente. Ela não deve alterar o método para retornar `IRickUIBuilderEditLabelMainTextColor` apenas porque isso seria mais simples internamente.

O mesmo princípio vale para todo o novo Edit: a interface pública define a navegação; a implementação segue o contrato.

## Estratégia de migração

A migração é deliberadamente incremental:

```text
legado permanece disponível
        ↓
novo contrato/types são estabelecidos em src/Edit/
        ↓
novas implementações são construídas e auditadas
        ↓
validação Delphi/DUnitX pelo responsável pelo projeto
        ↓
somente depois pode ser considerada a substituição/remoção do legado
```

Não remova o legado antecipadamente. Não altere Samples, testes, facade, package/project ou comportamento legado em um incremento de implementação, salvo quando a tarefa atual incluir isso explicitamente.

## Repositório e entrega

No trabalho assistido por IA deste projeto:

- o GitHub é somente leitura para o agente;
- o `main` atual deve ser confirmado novamente antes de cada novo incremento de implementação;
- o agente não executa mutações no repositório;
- o responsável pelo projeto recebe os arquivos/ZIP primeiro e realiza a validação final no Delphi/DUnitX;
- ZIPs incrementais contêm somente arquivos criados ou efetivamente modificados pela tarefa, preservando os caminhos relativos do repositório;
- arquivos usados apenas como Fontes do Projeto ChatGPT não são arquivos do repositório, salvo quando também existirem no próprio repositório.

Antes de empacotar um incremento de implementação do Edit, audite dependências, types referenciados, helpers, `Types`, units de implementação e somente os package/project files efetivamente modificados naquele incremento.

## Referências de governança

As regras de processo ficam em `.agents/`, não neste documento. As políticas detalhadas são:

- [`.agents/references/interface-contract-preservation-policy.md`](../../.agents/references/interface-contract-preservation-policy.md) — protege os contratos existentes;
- [`.agents/references/interface-implementation-unit-policy.md`](../../.agents/references/interface-implementation-unit-policy.md) — protege a organização física 1 → 1 → 1 do novo Edit.

Este documento registra a arquitetura e os limites de manutenção do componente para que essas decisões possam ser recuperadas independentemente do histórico da conversa.
