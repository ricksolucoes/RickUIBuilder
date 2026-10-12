# Interface Implementation Unit Policy — Novo Edit

Política compartilhada para a organização física das implementações públicas da nova arquitetura do `Edit` em `src/Edit/`.

## Escopo

Esta política é obrigatória para as interfaces públicas declaradas em:

`src/Edit/Rick.UIBuilder.Edit.Interfaces.pas`

Ela não estabelece automaticamente a mesma organização para outros componentes do RickUIBuilder. A arquitetura de outros domínios deve ser determinada pelo contrato e pelas regras específicas correspondentes.

## Regra 1 → 1 → 1

Para cada interface pública do novo `Edit`:

```text
1 interface pública
        ↓
1 classe concreta correspondente
        ↓
1 unit exclusiva de implementação
```

No contrato atual do novo `Edit`, isso significa:

```text
28 interfaces públicas
=
28 classes concretas
=
28 units de implementação
```

A correspondência nominal deve permanecer clara:

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

## Conteúdo permitido na unit de implementação pública

Uma unit que implementa uma das interfaces públicas do novo `Edit` deve conter somente a classe concreta correspondente àquele contrato e o código necessário para implementá-la.

Ela não deve conter:

- implementação de uma segunda interface pública;
- segunda classe concreta correspondente a outro contrato público;
- interface de domínio;
- record de domínio;
- enum de domínio;
- DTO;
- configuração compartilhada;
- type auxiliar de domínio pertencente ao contrato compartilhado.

Records, enums e demais types compartilhados do novo `Edit` pertencem a:

`src/Edit/Rick.UIBuilder.Edit.Types.pas`

As interfaces públicas pertencem a:

`src/Edit/Rick.UIBuilder.Edit.Interfaces.pas`

## Helpers internos

Classes de infraestrutura interna que não correspondem às 28 interfaces públicas não entram na contagem 1 → 1 → 1.

Exemplos atualmente reconhecidos:

- `Rick.UIBuilder.Edit.Context.pas`;
- `Rick.UIBuilder.Edit.InputRules.pas`;
- `Rick.UIBuilder.Edit.Control.pas`;
- `Rick.UIBuilder.Edit.Interaction.pas`;
- `Rick.UIBuilder.Edit.Materializer.pas`.

A existência desses helpers não autoriza agrupamento das implementações públicas e não exige que cada helper ganhe uma interface. Novas abstrações só devem ser criadas quando houver responsabilidade arquitetural real e autorização de escopo.

## Proibições

Não:

- reagrupe interfaces irmãs em uma única unit concreta por conveniência;
- transforme helpers em interfaces apenas para simetria;
- mova records/enums/types para units concretas;
- altere o contrato público para tornar a separação física mais fácil;
- crie abstrações cosméticas apenas para satisfazer a forma 1 → 1 → 1.

## Verificação

Para mudanças no novo `Edit`, confirme:

- cada interface pública possui uma classe concreta correspondente;
- cada classe pública está em uma unit exclusiva;
- não existem duas implementações públicas na mesma unit;
- helpers internos não foram contados como implementações públicas;
- `Interfaces.pas` e `Types.pas` permanecem como boundaries do domínio;
- nenhuma alteração de organização violou [`interface-contract-preservation-policy.md`](interface-contract-preservation-policy.md).
