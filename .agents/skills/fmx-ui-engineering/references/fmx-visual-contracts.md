# FMX Visual Contracts — Checklist de Apoio

## Visual tree

- quem é parent de cada child?;
- algum child sai do subtree lógico para overlay/root?;
- z-order depende da ordem de criação?;
- container usa clipping?;
- align automático conflita com position manual?

## Interaction

- qual objeto recebe mouse/touch?;
- `HitTest` dos filhos interfere?;
- existe área mínima de interação distinta do ícone?;
- event interno e event público coexistem?;
- foco/teclado são necessários?

## State

- selected/hover/target têm estados distintos?;
- visual reset remove state antigo?;
- atualizar uma property preserva state runtime?;
- rebuild muda scroll/focus/selection?

## Hosting

- parent lógico é também host visual?;
- form/root precisa ser usado?;
- scroll content é local apropriado?;
- overlay/full-window acompanha resize?

## Lifecycle

- host pode morrer com popup aberto?;
- child possui owner diferente de parent?;
- handle referencia control após destruição?;
- events são desregistrados/detached?

## Platform

- hover é opcional;
- touch target suficiente;
- back action definida no mobile;
- edit/keyboard não quebra viewport;
- presentation mode resolve coerentemente.
