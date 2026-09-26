# Owner FRM-FMX — FireMonkey e árvore visual

## Fatos do framework

O framework diferencia materialização visual, estado e comportamento conforme a complexidade real do componente.

Exemplos:

- Label e Divider são implementações simples;
- Button separa Handle e hover behavior/state;
- ComboBox separa Data, State, Style, Presentation, Virtualization, Handle e Behavior.

**Evidência:** package `RickUIBuilder.dpk`, bloco `contains`.

## Owner versus Parent

Factory recebe Owner e Parent separadamente. Builders existentes normalmente passam `AParent` para ambos.

**Evidência:** signatures públicas de `TRickUIBuilderFactory` e implementações de `Build`.

## Regra para Edit

A futura IA deve desenhar a árvore visual do Edit antes de materializá-la em código e registrar:

- root visual;
- elemento editável;
- elementos apenas visuais;
- hit targets;
- foco;
- Owner;
- Parent;
- handlers;
- elementos opcionais.

A composição concreta do Edit está **Não confirmada** nas fontes permitidas.
