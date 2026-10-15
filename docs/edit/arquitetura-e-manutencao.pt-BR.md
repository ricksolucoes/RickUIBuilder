# Arquitetura e manutenção do Edit

🇺🇸 [English](arquitetura-e-manutencao.md)

Este documento registra as decisões arquiteturais permanentes para o **novo Edit** em construção dentro de `src/Edit/`.

Ele não afirma que a migração já esteja concluída. O Edit legado permanece no repositório e continua sendo a implementação validada até que a nova arquitetura seja revisada e aceita pelo responsável pelo projeto.

Para o blueprint detalhado de montagem e dependências, consulte [Montagem e dependências do novo Edit](montagem-e-dependencias.pt-BR.md).

## Limite da migração

A nova implementação fica em:

```text
src/Edit/
```

A implementação legada permanece fora desse diretório e não deve ser removida nem reescrita sem autorização explícita.

O legado pode ser consultado como evidência de comportamento, mas não define a organização física da nova implementação. A nova implementação não deve depender das units legadas do Edit.

## Fonte de verdade do contrato

O contrato oficial é:

```text
src/Edit/Rick.UIBuilder.Edit.Interfaces.pas
```

A implementação deve se adaptar ao contrato atual. Conveniência interna não autoriza alterar retorno, parâmetro, overload, GUID, membro, spelling, navegação fluent nem adicionar getter/state/handle auxiliar.

A interface só muda mediante solicitação explícita do usuário na tarefa atual.

## Entrada e composition root

O ponto de entrada externo é `IRickUIBuilderEdit`.

A assinatura atual da raiz inclui:

```delphi
function Parent(AParentConstructor: TFmxObject): IRickUIBuilderEdit;
function Build: IRickUIBuilderEdit;
```

A implementação de `IRickUIBuilderEdit` é o composition root lógico. Toda a árvore especializada nasce a partir dela e deve permanecer acessível pela navegação já definida no contrato.

O consumidor não deve precisar conhecer classes concretas, helpers internos ou caminhos paralelos de estado.

## Organização 1 → 1 → 1

Para as 28 interfaces públicas do novo Edit:

```text
1 interface pública
        ↓
1 classe concreta correspondente
        ↓
1 unit exclusiva de implementação
```

Isto significa:

```text
28 interfaces públicas
=
28 classes concretas
=
28 units de implementação
```

A correspondência nominal permanece clara:

```text
I<Nome>
→ T<Nome>
→ unit exclusiva
```

Uma unit de implementação pública não deve conter segunda implementação pública, interface, record, enum, DTO ou configuração compartilhada de domínio.

## Types

Os types públicos/compartilhados do novo Edit pertencem a:

```text
src/Edit/Rick.UIBuilder.Edit.Types.pas
```

A presença desse boundary não autoriza criar records de settings por conveniência. Um type novo exige necessidade comprovada.

## Dependency Injection e contexto

Quando uma interface especializada depende do contexto de outra:

- receba o contrato pai por injeção;
- mantenha `FParent` somente quando a navegação de retorno exigir;
- use `[weak]` em linha própria;
- mantenha a referência descendente no pai por interface;
- não recrie Parent/origem;
- não use service locator;
- não crie `Context` central apenas para transportar estado;
- não duplique estado que pertence a outra implementação.

Formato obrigatório:

```delphi
[weak]
FParent: IRickUIBuilderEditDesigner;
```

Os métodos que implementam a interface ficam em `protected`; a superfície `public` da classe concreta deve permanecer mínima.

## Estado pertence ao contrato que o representa

Cada implementação guarda somente o contexto da sua própria responsabilidade.

Quando uma configuração pode ser aplicada diretamente ao objeto FMX que a interface configura, prefira o próprio objeto como estado efetivo.

Quando a interface representa múltiplos valores configurados simultaneamente, esses valores podem permanecer como campos da própria implementação correspondente.

Não concentrar o estado do componente inteiro em um record ou classe agregadora apenas para facilitar `Build`.

## Classes auxiliares não fazem parte da arquitetura do novo Edit

A implementação atual segue rigidamente a correspondência 1 → 1 → 1. Não existem classes próprias de produção fora das 28 implementações correspondentes às interfaces públicas.

`TRickUIBuilderEditVisualState` e `TRickUIBuilderEditInputRules`, usados em incrementos anteriores, foram removidos. As responsabilidades foram redistribuídas para os contratos que já as representam:

- estados e feedback de validação pertencem a `IRickUIBuilderEditDesignerValidation`;
- `ClearButton`, `Password` e `ReadOnly` pertencem a `IRickUIBuilderEditDesignerConfig`;
- máscaras, case, URL e `MaxLength` pertencem a `IRickUIBuilderEditDesignerInputConfig`;
- regras numéricas pertencem a `IRickUIBuilderEditDesignerInputNumber`;
- cada implementação visual mantém somente suas próprias cores e resolve seu estado usando `IRickUIBuilderEditDesignerValidation` e o `TEdit` compartilhado;
- `TEdit`, `TLabel`, `TPath` e `TRectangle` são controles FMX de infraestrutura e podem ser injetados diretamente quando são o alvo real da implementação.

Não criar `Context`, `State`, `Runtime`, `Interaction`, `Coordinator`, `Manager`, `Materializer`, service locator ou outra classe própria auxiliar para transportar estado entre ramos.

## Lifetime

O pai mantém seus filhos especializados por interface. O filho mantém o contrato pai por referência fraca quando precisa retornar na cadeia.

Assim, enquanto a raiz `IRickUIBuilderEdit` estiver referenciada, a árvore descendente de interfaces pode permanecer viva sem criar ciclo forte.

`Parent(AParentConstructor)` guarda a referência ao local de montagem para uso de `Build`; uma referência `TFmxObject` simples não transfere ownership nem prolonga automaticamente o lifetime do objeto informado.

O `TEdit` runtime é criado por `TRickUIBuilderEditDesigner` com o `TRectangle` raiz como owner. Implementações legítimas que precisam permanecer como receivers de eventos durante o lifetime do controle são componentes owned pelo próprio `TEdit`. Elas continuam sendo as classes concretas correspondentes às interfaces existentes; não existe helper adicional para lifetime.

Os handlers `OnEnter`, `OnExit` e `OnChangeTracking` são encadeados pelas implementações que realmente possuem aquele comportamento. O estado `Invalid` permanece em `IRickUIBuilderEditDesignerValidation`, `ReadOnly` permanece no `TEdit`, e o estado de foco usado pelos contratos visuais é mantido localmente somente pelos contratos que possuem a variação `Focus`.

As implementações visuais mantêm `IRickUIBuilderEditDesignerValidation` quando precisam consultar `Invalid` depois que a interface raiz foi liberada. As referências de navegação para o pai permanecem `[weak]`, evitando ciclo de reference counting.

## Estratégia de implementação

```text
contrato atual
    ↓
mapa de dependências
    ↓
prova das relações/lifetime
    ↓
implementações 1 → 1 → 1
    ↓
auditoria independente
    ↓
validação Delphi/DUnitX pelo responsável pelo projeto
```

Não introduzir helper/type para “destravar” uma implementação. Quando houver dificuldade, voltar ao mapa de contratos e demonstrar a dependência real.

## Repositório e entrega

- GitHub permanece read-only para o agente;
- o `main` deve ser reconfirmado antes de cada incremento;
- o legado permanece até validação explícita;
- ZIP incremental contém somente arquivos criados/modificados;
- build/test/toxicity só podem ser declarados quando realmente executados.

## Referências

- [Montagem e dependências do novo Edit](montagem-e-dependencias.pt-BR.md)
- [Interface Contract Preservation Policy](../../.agents/references/interface-contract-preservation-policy.md)
- [Interface Implementation Unit Policy](../../.agents/references/interface-implementation-unit-policy.md)
