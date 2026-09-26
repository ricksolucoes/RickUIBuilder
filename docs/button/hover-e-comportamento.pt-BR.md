# Button — Hover e Comportamento

> [English](hover-e-comportamento.md) | [Português do Brasil](hover-e-comportamento.pt-BR.md)

## Separação de responsabilidades

`TRickUIBuilderButtonHoverState` armazena a configuração viva. `TRickUIBuilderButtonHoverBehavior`, um `TComponent`, executa `MouseEnter/MouseLeave` e mantém uma referência forte à interface de estado.

## Estado público

`IRickUIBuilderButtonHoverState` expõe setters/getters para `Button`, `FillColor`, `HoverFillColor`, `OnEnter` e `OnLeave`, além de `HasHoverFillColor` e `Build(AOwner)`.

## MouseEnter

Se `HasHoverFillColor=True`, o Behavior aplica o `HoverFillColor` atual ao `FButton`; depois consulta e executa o `OnEnter` atual.

## MouseLeave

Se há hover color, restaura o `FillColor` atual; depois consulta e executa o `OnLeave` atual.

## Mutabilidade pós-Build

O Behavior consulta o estado a cada evento. Portanto, alterações posteriores em `FillColor`, `HoverFillColor`, `OnEnter` e `OnLeave` afetam eventos seguintes sem reconstrução. Os setters não repintam imediatamente: as cores são consumidas no próximo evento correspondente.

`Button(AValue)` é diferente: o Behavior guarda o `TRectangle` recebido em `Configure`. Alterar `HoverState.Button` depois de `Build` não retargeta esse Behavior.

## Builder

`HoverFillColor` e `OnHover` configuram o mesmo estado usado pelo Behavior. Mesmo sem hover color explícita, o estado é criado e callbacks `OnHover` podem ser executados; a troca de cor só ocorre quando `HasHoverFillColor=True`.

## Pré-condição no uso direto de HoverState

Ao usar `TRickUIBuilderButtonHoverState` diretamente, chame `Button(AValue)` com um `TRectangle` válido antes de `Build(AOwner)`. A implementação atual de `Build` atribui `OnMouseEnter` e `OnMouseLeave` por meio do `FButton` armazenado, sem guarda para `nil`. O Fluent Button Builder satisfaz essa pré-condição antes de construir o estado de hover.
