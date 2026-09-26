# Cinco alternativas — disciplina de decisão

A regra desta reconstrução é avaliar alternativas sem transformar opção plausível em requisito.

## Caso A — arquitetura do novo Edit

1. copiar Label;
2. copiar Button;
3. copiar ComboBox;
4. criar todas as camadas possíveis;
5. escolher arquitetura proporcional somente após contrato funcional.

**Selecionada:** 5.

## Caso B — Handle

1. sempre criar Handle;
2. nunca criar Handle;
3. retornar o controle FMX concreto;
4. criar Handle apenas por simetria com Button/ComboBox;
5. criar Handle somente se houver capacidade runtime pública confirmada.

**Selecionada:** 5.

## Caso C — Factory

1. obrigatória para todo novo componente;
2. proibida para componente stateful;
3. substituir Builder por Factory;
4. duplicar materialização no Builder e na Factory;
5. decidir após separar criação fundamental de comportamento adicional.

**Selecionada:** 5.

## Caso D — estado/presentation auxiliares

1. criar State;
2. criar Presentation;
3. criar Behavior;
4. copiar todas as units do ComboBox;
5. introduzir cada abstração somente se uma responsabilidade confirmada justificar.

**Selecionada:** 5.

## Caso E — lacuna funcional

1. inferir do FMX;
2. inferir do componente visualmente parecido;
3. escolher o comportamento mais comum;
4. reutilizar texto de documento antigo proibido;
5. registrar `Não confirmado` e impedir implementação daquela fronteira até decisão comprovada.

**Selecionada:** 5.
