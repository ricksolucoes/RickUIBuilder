# Lifecycle, Ownership e Handle

> [English](lifecycle-ownership-e-handle.md) | [Português do Brasil](lifecycle-ownership-e-handle.pt-BR.md)

## Fonte de verdade

Leia `Rick.UIBuilder.ComboBox.Handle.pas`, `Rick.UIBuilder.ComboBox.Presentation.pas` e `Rick.UIBuilder.ComboBox.Virtualization.pas` em conjunto antes de alterar ownership ou comportamento de destruição.

## Modelo de ownership

O builder cria o modelo lógico de dados e transfere a responsabilidade prática de lifetime para `TRickUIBuilderComboBoxHandle`, cujo destructor libera `FData` e `FState`. Os controles FMX fechados são criados com `AParent` fornecido pelo consumidor como owner e parent. As referências visuais dentro do handle são non-owning.

## Behavior component

`TRickUIBuilderComboBoxBehavior` é criado com `AParent` como owner. Ele armazena uma referência forte `IRickUIBuilderComboBoxHandle` (`FLifetime`) e um ponteiro raw para a implementação (`FHandle`). É isso que mantém o comportamento runtime vivo quando o consumidor usa `Build` e não preserva a interface local do handle retornada internamente por `BuildCore`.

## Fluxo de lifetime no Build

```text
BuildCore
↓
Create Data
↓
Create Handle interface + implementation pointer
↓
Create closed FMX controls
↓
Create Behavior owned by AParent
↓
Behavior retains IRickUIBuilderComboBoxHandle
↓
Visual tree remains interactive after builder scope ends
```

## Anexação do handle

`AttachVisual` armazena referências non-owning de parent/container/label/arrow, configura eventos do container, cria o behavior e então cria search timer e serviços de presentation usando o behavior como owner/contexto de lifetime. `IsAttached` é definido por `FContainer` ainda estar atribuído.

## Detach

`DetachVisual` remove eventos do controle fechado, desabilita/libera o search timer, libera virtualizer e presentation, fecha o estado interno quando necessário e limpa todas as referências visuais non-owning. Ele não libera os controles visuais fechados que pertencem ao caller.

## Notification da destruição do container

Behavior assina `FContainer.FreeNotification`. Quando o container é removido, behavior chama `FHandle.DetachVisual(False)` antes de limpar sua referência ao container. O `False` evita tocar eventos de um container que já está em processo de remoção.

## Notifications da Presentation

Presentation observa anchor, parent original e host FullWindow separado quando aplicável. Referências de popup/scrollbox também são acompanhadas. Durante notification, ela limpa referências raw afetadas para que o detach posterior não dereferencie controles já destruídos.

## Nuance de ownership no FullWindow

O popup FullWindow é criado com o owner do lado do behavior armazenado em `FOwner`, mas parented ao presentation host resolvido. Durante detach, `Presentation` libera os visuais somente quando o presentation host ainda é conhecido. Se o host já estiver sendo destruído, limpa referências e permite que o fluxo de destruição por ownership/parent do FMX termine sem uma segunda liberação.

## Lifetime do Virtualizer

O virtualizer é possuído manualmente pelo handle (`FreeAndNil(FVirtualizer)`). Rows/spacer pertencem ao scroll box. Ao receber notification de remoção do scroll box, o virtualizer limpa referências/metadados do pool em vez de liberar filhos visuais que pertencem à árvore FMX.

## Handle após destruição visual

Uma referência preservada a `IRickUIBuilderComboBoxHandle` pode sobreviver à árvore visual. Nesse estado `IsAttached = False`. Os dados lógicos continuam pertencendo ao handle até a interface ser liberada, mas operações de UI que dependem de attachment não podem presumir um container vivo.

## Checklist de alteração

Antes de mudar código de lifecycle, valide pelo menos: Build sem handle preservado; handle preservado após destruição do parent; popup aberto durante destruição do parent; FullWindow aberto durante destruição do parent; remoção de controles irmãos não relacionados; open/close/reopen normal; e ausência de double-free entre owner, parent, presentation e handle.
