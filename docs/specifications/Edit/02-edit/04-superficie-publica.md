# Owner EDIT-PUBLIC — Superfície pública do Edit

**Origem:** `PEND-EDIT-001` — resolvida e migrada para este Owner normativo.

**Status documental:** `APROVADO` para a decisão já fechada; dependências explicitamente indicadas no próprio contrato continuam nos respectivos Owners.

Esta pendência trata exclusivamente da **existência e da responsabilidade das fronteiras públicas do Edit**. Ela não é proprietária dos métodos funcionais do builder, da composição visual concreta, dos campos/defaults da configuração nem das operações runtime específicas do Handle; esses contratos pertencem às respectivas pendências funcionais.

### Decisão normativa

A superfície pública do Edit deve possuir:

- `TRickUIBuilder.Edit`, como ponto de entrada do builder fluente na facade do RickUIBuilder;
- `IRickUIBuilderEdit`, como contrato público e autocontido do builder;
- `TRickUIBuilderEditConfig`, como record público de configuração do Edit;
- suporte da `TRickUIBuilderFactory` à materialização fundamental do Edit;
- `Build`, como operação de materialização pelo builder;
- `BuildHandle`, como operação de materialização que retorna acesso runtime;
- `IRickUIBuilderEditHandle`, como contrato público para as operações pós-Build que forem definidas para o componente.

### Encaixe no RickUIBuilder

A decisão preserva as fronteiras já existentes no framework:

- a facade continua sendo o ponto único de entrada para builders;
- interfaces públicas permanecem concentradas no contrato público do framework;
- configuração pública permanece representada por record;
- a Factory continua responsável pela criação fundamental dos controles;
- o builder concentra configuração fluente antes da materialização;
- o Handle, quando usado, é a fronteira pública para comportamento runtime sem obrigar o consumidor a conhecer a composição visual interna.

A existência dessas fronteiras está decidida nesta pendência. A implementação não deve copiar automaticamente a arquitetura interna de Button, Badge ou ComboBox; cada abstração interna do Edit continua condicionada à responsabilidade funcional efetivamente documentada.

### Limites desta decisão

Esta pendência **não autoriza inferir**:

- a lista completa de métodos fluent de `IRickUIBuilderEdit`;
- os campos ou valores de `TRickUIBuilderEditConfig`;
- o tipo concreto da raiz visual retornada por `Build`;
- a assinatura concreta da criação na Factory quando ela depender da composição visual;
- os métodos de `IRickUIBuilderEditHandle`;
- as regras de attached/detached, ownership ou lifetime do Handle;
- máscaras, validação, eventos, estados visuais, ações ou defaults.

Esses pontos continuam pertencendo às pendências específicas e só podem ser implementados depois que seus respectivos contratos estiverem fechados.

### Dependências remanescentes

- `PEND-EDIT-002` deve fechar a composição visual e, com isso, o tipo/estrutura materializada por Factory e `Build`;
- `PEND-EDIT-006` deve fechar as operações runtime e a semântica de lifetime de `IRickUIBuilderEditHandle`;
- `PEND-EDIT-007` deve fechar os campos e defaults de `TRickUIBuilderEditConfig`;
- as demais pendências funcionais devem definir somente os métodos públicos que correspondam aos seus próprios comportamentos.

### Critério de aceite da PEND-EDIT-001

| Questão | Decisão |
|---|---|
| `TRickUIBuilder.Edit` | Obrigatório |
| `IRickUIBuilderEdit` | Obrigatório |
| `TRickUIBuilderEditConfig` | Obrigatório |
| Factory pública para Edit | Obrigatório |
| `Build` | Obrigatório |
| `BuildHandle` | Obrigatório |
| `IRickUIBuilderEditHandle` | Obrigatório |

Com essas decisões, não resta escolha arquitetural sobre **se** essas fronteiras públicas existem. Os detalhes ainda não definidos foram explicitamente encaminhados aos Owners funcionais correspondentes, sem serem inventados aqui.
