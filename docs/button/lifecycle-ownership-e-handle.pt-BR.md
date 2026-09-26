# Button — Lifecycle, Ownership e Handle

> [English](lifecycle-ownership-e-handle.md) | [Português do Brasil](lifecycle-ownership-e-handle.pt-BR.md)

## Build e BuildHandle

Ambos chamam `BuildCore`. O fluxo cria `TRectangle` + `TLabel` pela Factory, aplica o estado adicional e materializa o Hover Behavior.

`Build(AParent)` retorna somente o `TRectangle`. `BuildHandle(AParent)` retorna `IRickUIBuilderButtonHandle` com `Container`, `TextLabel` e o mesmo `HoverState` usado pelo Behavior.

## Ownership dos controles

O Fluent Builder chama a Factory usando `AParent` como Owner e Parent do container e como Owner do label. O Handle é non-owning: liberar a interface não libera controles; manter a interface viva não mantém os controles vivos.

## Lifetime do hover

`HoverState.Build(AOwner)` cria `TRickUIBuilderButtonHoverBehavior` owned por `AOwner`. O Behavior mantém `FState` como interface forte, então o estado continua vivo mesmo que o chamador libere sua própria referência.

O estado não é proprietário do Button. O Behavior também não altera o ownership do `TRectangle`.

## Handle de compatibilidade

`TRickUIBuilderButtonHandle.New(Container, TextLabel)` continua disponível e produz um Handle com `HoverState=nil`. A sobrecarga usada por `BuildHandle` recebe também o estado de hover.

## Regra de uso

Não use `Container` ou `TextLabel` do Handle depois que o Owner dos controles tiver sido destruído. O Handle não implementa detecção automática de destruição desses controles.

## Destruição independente do Button

`TRickUIBuilderButtonHoverBehavior` armazena `FButton: TRectangle` e uma referência forte à interface `FState`. Na implementação atual ele **não** chama `FButton.FreeNotification(Self)` e não sobrescreve `Notification` para observar a destruição independente desse Button. Isso difere de componentes runtime que monitoram explicitamente um container visual.

No caminho normal do Fluent Builder, Button e Hover Behavior são criados no mesmo contexto de ownership de `AParent`; ainda assim, uma montagem direta/manual deve respeitar essa relação de lifetime: não destrua o Button configurado de forma independente enquanto um Behavior que o referencia ainda puder receber eventos. Isso descreve o contrato atual de lifetime e não representa transferência de ownership para o Behavior.
