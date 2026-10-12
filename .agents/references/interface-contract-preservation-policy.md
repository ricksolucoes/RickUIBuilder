# Interface Contract Preservation Policy

Política compartilhada para preservar contratos de interfaces existentes do RickUIBuilder.

## Princípio

Uma interface existente é contrato. Durante implementação, correção, reorganização ou refatoração, a implementação deve se adaptar ao contrato existente; o contrato não deve ser alterado para acomodar conveniência interna.

Alteração de contrato só é autorizada quando o usuário solicitar **explicitamente**, na tarefa atual, uma mudança da interface/API correspondente.

## Alterações protegidas

Sem autorização explícita de mudança contratual, não:

- adicione ou remova métodos;
- altere retorno;
- altere parâmetros;
- altere overloads;
- adicione, remova ou substitua GUID;
- renomeie membro;
- corrija spelling de identificador público;
- altere navegação fluent;
- exponha getter, state, runtime, handle ou outro membro público apenas para facilitar a implementação.

Dificuldade de implementação, obtenção de contexto, chaining ou acesso a estado não constitui autorização para alterar a interface.

## Dependências e obtenção de contexto

Quando uma implementação precisar de contexto ou estado que já pertença a outro contrato:

1. identifique a interface que já representa a responsabilidade;
2. use esse contrato como dependência quando a relação exigir;
3. quando existir origem/pai clara, receba o contrato necessário por injeção;
4. retorne ou acesse o contexto pela relação já definida na arquitetura;
5. modele lifetime e reference counting quando interfaces mantiverem referências entre si.

Não substitua essa relação por:

- nova interface criada apenas para transportar estado;
- getter público artificial;
- estado duplicado;
- service locator ou global;
- reconstrução do Parent/origem;
- segundo caminho para o mesmo contexto;
- alteração de retorno para tornar a implementação mais conveniente.

Dependency Inversion aqui significa depender do contrato correto já existente quando ele já representa a responsabilidade. Não significa criar outra interface por simetria.

## Novo Edit

Para a nova arquitetura em `src/Edit/`, a fonte oficial do contrato é:

`src/Edit/Rick.UIBuilder.Edit.Interfaces.pas`

Todas as interfaces públicas do novo `Edit` permanecem nessa unit. Essa decisão específica prevalece sobre regras genéricas antigas que centralizem interfaces em `Rick.UIBuilder.Interfaces.pas`.

Durante implementação do novo `Edit`, trate `Rick.UIBuilder.Edit.Interfaces.pas` como read-only por padrão. Somente uma solicitação explícita do usuário para alterar o contrato autoriza modificação dessa unit.

A implementação deve preservar inclusive nomes existentes que pareçam incorretos ou incomuns. Correção de spelling público é mudança contratual.

## Evidência e review

Antes de aprovar uma alteração que envolva interfaces existentes:

- compare a interface final com a baseline/fonte de verdade da tarefa;
- confirme que qualquer diferença pública foi explicitamente autorizada;
- verifique implementadores e consumidores quando houver mudança contratual autorizada;
- trate alteração por conveniência da implementação como finding bloqueante;
- não use build bem-sucedido como substituto da revisão de contrato.

## Relação com outras políticas

Esta política protege **o contrato**.

A organização física das implementações públicas do novo `Edit` é protegida separadamente por [`interface-implementation-unit-policy.md`](interface-implementation-unit-policy.md).

Não misture as duas responsabilidades: uma alteração pode preservar o contrato e ainda violar a organização física, ou preservar a organização física e ainda quebrar o contrato.
