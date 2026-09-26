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


## PEND-EDIT-005 — alternativas avaliadas

As alternativas registram a disciplina de decisão; a regra final permanece exclusivamente em `EDIT-EVENTS`.

### Superfície pública
1. nenhum callback;
2. somente `OnChange`;
3. `OnChange` + `OnExit`;
4. `OnChange` + `OnEnter` + `OnExit`;
5. exposição dos eventos internos do `TEdit`.

**Selecionada:** 4, por corresponder ao histórico autorizado sem expor detalhe FMX.

### Ordem de OnChange
1. callback antes do processamento;
2. depois do input e antes da normalização;
3. depois da normalização e antes da validação;
4. depois de input, normalização, estado, validação aplicável e refresh visual;
5. múltiplos callbacks no mesmo ciclo.

**Selecionada:** 4, por corresponder ao histórico e às dependências `EDIT-INPUT`/`EDIT-VALIDATION`.

### Sessão de foco/Revert
1. sem snapshot;
2. snapshot no Build;
3. snapshot a cada mudança;
4. snapshot no `OnEnter`, imutável até `OnExit`;
5. snapshot substituído por `Handle.SetText`.

**Selecionada:** 4, conforme histórico autorizado.

### Reentrada
1. aceitar reentrada;
2. callback para toda reatribuição de `TEdit.Text`;
3. suprimir somente Handle;
4. suprimir somente máscara;
5. impedir que alteração interna/programática retorne como edição do usuário.

**Selecionada:** 5, conforme histórico e cardinalidade pública.

### Alteração programática
1. dispara `OnChange` e validator;
2. dispara somente `OnChange`;
3. dispara somente validator;
4. não dispara ambos, mas substitui snapshot;
5. não dispara ambos e preserva snapshot da sessão.

**Selecionada:** 5, conforme histórico autorizado e `EDIT-VALIDATION`.

Nenhuma alternativa descartada cria requisito normativo.


## PEND-EDIT-006 — alternativas avaliadas

### Superfície runtime
1. expor `TEdit`; 2. somente root; 3. Handle só leitura; 4. Handle genérico FMX; 5. Handle específico lógico sem expor controles.

**Selecionada:** 5, conforme histórico autorizado.

### Pós-destruição
1. continuar attached; 2. gerar erro; 3. recriar árvore; 4. destruir Handle; 5. detached com último texto e setters no-op.

**Selecionada:** 5, conforme histórico.

### Ownership
1. Handle possui root; 2. possui filhos; 3. controles possuem Handle; 4. ciclo forte; 5. Owner/Parent FMX + refs non-owning.

**Selecionada:** 5.

### Build sem Handle externo
1. exigir retenção; 2. perder comportamento; 3. mudar retorno de Build; 4. ciclo permanente; 5. manter somente vida interna necessária sem ciclo.

**Selecionada:** 5.

### SetText
1. rebuild; 2. texto bruto; 3. normaliza + callback/validator; 4. normaliza e troca snapshot de entrada; 5. aplica input e sincroniza sem callback/validator, preservando snapshot da sessão.

**Selecionada:** 5.

Nenhuma alternativa descartada cria requisito normativo.


## PEND-EDIT-007 — alternativas avaliadas

### Estratégia de defaults
1. exigir toda configuração; 2. defaults do `TEdit`; 3. constantes globais dispersas; 4. defaults parciais; 5. `TRickUIBuilderEditConfig.Default` completo/determinístico.

**Selecionada:** 5.

### Paleta
1. sem paleta; 2. StyleLookup obrigatório; 3. cores fixas não configuráveis; 4. um único conjunto sem estados; 5. estados configuráveis com paleta default para fundo claro.

**Selecionada:** 5.

### Ações opcionais
1. ocultar todas por default; 2. sempre mostrar; 3. somente password; 4. somente revert; 5. flags default combinadas com condições de aplicabilidade.

**Selecionada:** 5.

### Assets
1. nenhum asset; 2. controles nativos sem paths; 3. paths imutáveis; 4. paths fornecidos obrigatoriamente pelo consumidor; 5. seis assets default substituíveis pela configuração.

**Selecionada:** 5.

### Configuração sem setter fluente
1. não suportar; 2. criar setter para tudo; 3. globals; 4. RTTI dinâmica; 5. manter no record público e usar setter apenas onde o contrato o declara.

**Selecionada:** 5.

Nenhuma alternativa descartada cria requisito normativo.
