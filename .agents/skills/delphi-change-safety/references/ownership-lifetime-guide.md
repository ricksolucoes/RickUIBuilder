# Ownership and Lifetime Guide — Delphi/FMX

Supporting reference para `delphi-change-safety`. Carregue quando houver Handle, Behavior, referências non-owning, interfaces, callbacks ou destruição assimétrica.

## Mapa mínimo

Para cada objeto relevante crie mentalmente uma linha:

| Objeto | Criado por | Owner | Parent | Quem destrói | Referências externas |
|---|---|---|---|---|---|
| | | | | | |

## `Owner`

`TComponent.Owner` participa de ownership/destruição de componentes. Não conclua que `Owner=nil` significa leak nem que `Owner<>nil` torna toda referência externa segura.

## `Parent`

Em FMX, `Parent` define a relação visual/object tree. Pode coincidir ou não com Owner.

Perguntas:

- parent pode ser destruído antes do builder/handle?;
- child é automaticamente removido?;
- holder externo recebe notificação?;
- FullWindow/overlay pode ter host diferente do anchor parent?

## Non-owning references

Uma referência non-owning é válida somente enquanto o target existe. Estratégias:

- `FreeNotification`/`Notification` para `TComponent` quando apropriado;
- detach explícito;
- checagem de attached state;
- controle do lifetime por objeto owner compartilhado.

Não use `Assigned` como prova de que um dangling pointer continua válido.

## Interfaces e reference counting

Analise:

- implementação herda `TInterfacedObject`?;
- `_AddRef/_Release` são padrão ou customizados?;
- existe `TComponent` com reference counting neutralizado?;
- interface é mantida por behavior/field?;
- ciclo de interfaces pode ocorrer?;
- builder sai de escopo após Build e runtime continua por qual referência?

## Anonymous methods

Closures podem capturar:

- `Self`;
- interface;
- control;
- owner;
- local object.

Isso pode prolongar lifetime ou deixar callback acessando objeto morto, dependendo de tipos capturados.

## FreeNotification

Use quando:

- holder é `TComponent`;
- target é `TComponent`;
- holder não possui target;
- target pode ser destruído independentemente;
- holder precisa invalidar referência.

Evite quando a relação já possui lifetime estritamente contido ou quando não há `TComponent` apropriado.

## Destruction scenarios a testar

Quando relevantes:

1. destruir handle antes do visual;
2. destruir visual/parent antes do handle;
3. destruir outro sibling e confirmar que handle continua attached;
4. popup/overlay aberto durante parent destruction;
5. liberar interface builder após Build;
6. callbacks após mudança runtime;
7. dupla chamada Close/Free/detach.

## Red flags

- destructor libera objeto que possui Owner externo;
- callback chama visual após detach;
- notification observa objeto errado;
- `Parent` cast assumido;
- interface forte usada apenas para “evitar AV” sem modelar ownership;
- lifecycle fix altera quem é dono do controle público.
