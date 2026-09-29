# Arquitetura do projeto RickUIBuilder.Samples

## 1. Finalidade

Este documento define a arquitetura estrutural do projeto `samples/RickUIBuilder.Samples` antes da expansão gradual do código Delphi.

O projeto de samples deve funcionar simultaneamente como aplicação demonstrativa, catálogo navegável da API pública e documentação executável. A arquitetura deve permitir crescimento por abordagem, componente e cenário sem transformar a Home, a navegação ou qualquer outra unit central em um arquivo monolítico.

Esta especificação autoriza somente a organização estrutural e documental do projeto de samples. A criação, movimentação, refatoração ou implementação de código Delphi continua sendo gradual e depende de autorização específica.

## 2. Princípio de crescimento

A pergunta arquitetural obrigatória para qualquer nova funcionalidade é:

> Se este catálogo crescer para dezenas de componentes e centenas de cenários, esta alteração continuará localizada na feature correspondente ou obrigará units centrais e features não relacionadas a crescerem junto?

A unidade primária de crescimento é o **componente dentro de uma abordagem**. Cenários crescem dentro do componente. Infraestrutura compartilhada deve permanecer estável.

Adicionar um novo componente não deve exigir alterações em componentes não relacionados. Adicionar um novo cenário não deve exigir alterações na Home.

## 3. Estado público confirmado da biblioteca

A organização do sample deve refletir somente a API pública efetivamente existente no código analisado.

### Factory

Atualmente confirmados:

- Text (`CreateText`)
- Button (`CreateButton`)
- Badge (`CreateBadge`)
- Divider (`CreateDivider`)
- ComboBox (`CreateComboBox`)

`Factory.CreateEdit` não está confirmado no estado analisado e, portanto, não deve ser representado como funcionalidade atual.

### Fluent Builder

Atualmente confirmados:

- Label
- Button
- Badge
- Divider
- ComboBox
- Edit

### Composition

Existe entrada pública através de `TRickUIBuilder.On(AParent)`.

Factory, Fluent Builder e Composition não devem ser forçados a possuir paridade artificial. Cada área representa somente o contrato público que realmente existe.

## 4. Estrutura física planejada

A estrutura alvo é:

```text
samples/
├── RickUIBuilder.Samples.dpr
├── RickUIBuilder.Samples.dproj
└── src/
    ├── App/
    │   ├── Shell/
    │   ├── Navigation/
    │   └── DesignSystem/
    │
    ├── Home/
    │
    ├── Factory/
    │   ├── Text/
    │   ├── Button/
    │   ├── Badge/
    │   ├── Divider/
    │   └── ComboBox/
    │
    ├── Fluent/
    │   ├── Label/
    │   ├── Button/
    │   ├── Badge/
    │   ├── Divider/
    │   ├── ComboBox/
    │   └── Edit/
    │
    └── Composition/
```

Os diretórios representam boundaries arquiteturais. Eles não significam que todas as possíveis units devem ser criadas imediatamente. Uma unit só deve existir quando houver responsabilidade concreta suficiente.

## 5. Responsabilidades dos boundaries

### 5.1 App

`App` contém exclusivamente infraestrutura transversal do aplicativo de samples.

#### Shell

Responsável pela estrutura visual compartilhada entre páginas quando essa necessidade estiver comprovada: área de conteúdo, estrutura comum de página, regiões persistentes e composição visual de alto nível.

O Shell não deve conhecer detalhes de Button, Edit, ComboBox ou qualquer outro componente demonstrado.

#### Navigation

Responsável pelo mecanismo de transição entre páginas/áreas quando a navegação for implementada.

A Home não deve se transformar em registry global de todas as páginas do catálogo. A solução concreta de navegação será implementada somente quando autorizada; este documento define apenas o boundary e a responsabilidade.

#### DesignSystem

Responsável apenas por tokens visuais realmente compartilhados pelo aplicativo de samples, como cores, tipografia, spacing e radius que tenham uso transversal comprovado.

Não pertence ao DesignSystem:

- coordenada específica de um controle;
- altura exclusiva de um card da Home;
- largura exclusiva de um exemplo de Edit;
- texto de uma página;
- configuração funcional de um componente demonstrado.

O DesignSystem pertence ao consumidor `RickUIBuilder.Samples`; não altera nem impõe um Design System ao framework `Rick.UIBuilder`.

### 5.2 Home

A Home possui somente estas responsabilidades:

- explicar o propósito do catálogo;
- apresentar as abordagens públicas disponíveis;
- encaminhar o usuário para Factory, Fluent Builder ou Composition quando a navegação correspondente existir.

A Home não demonstra componentes e não conhece cenários internos de componentes.

A Home não deve possuir métodos específicos para navegar diretamente para cada componente futuro.

### 5.3 Factory

Boundary de exemplos construídos através de `TRickUIBuilder.Factory`.

Somente componentes confirmados na Factory podem existir como opções funcionais nessa área.

Um componente Factory deve conter seus próprios exemplos e não depender do componente equivalente em Fluent.

### 5.4 Fluent

Boundary de exemplos construídos através dos builders fluentes da fachada `TRickUIBuilder`.

Um componente Fluent deve conter seus próprios exemplos e não depender do componente equivalente em Factory.

### 5.5 Composition

Boundary dos exemplos baseados em `TRickUIBuilder.On(AParent)`.

A implementação futura deve ser derivada da API pública efetivamente existente no momento da implementação, sem pressupor paridade com Factory ou Fluent.

## 6. Hierarquia de navegação conceitual

```text
Home
 │
 ├── Factory
 │     └── Componente
 │           └── Cenários
 │
 ├── Fluent Builder
 │     └── Componente
 │           └── Cenários
 │
 └── Composition
       └── Cenários suportados
```

A navegação deve preservar essa hierarquia. Um cenário não deve virar destino global da Home.

## 7. Regra de granularidade

### Abordagem

Factory, Fluent e Composition são boundaries de primeiro nível porque representam formas públicas distintas de utilizar a biblioteca.

### Componente

Componente é a unidade padrão de expansão funcional do catálogo.

Exemplos:

```text
Factory/ComboBox
Fluent/ComboBox
Fluent/Edit
```

### Cenário

Cenário é uma demonstração significativa dentro de um componente.

Cenário não implica automaticamente uma nova unit, classe ou Form. A separação física deve ocorrer somente quando tamanho, responsabilidade, dependências ou manutenção justificarem o boundary.

É proibido fragmentar artificialmente um componente em dezenas de units apenas para diminuir métodos ou arquivos.

## 8. Componentes complexos

Componentes simples podem permanecer com poucos métodos em sua página.

Componentes complexos devem crescer internamente sem aumentar a responsabilidade das áreas superiores.

### ComboBox

Os cenários atualmente conhecidos no sample existente são:

- Desktop
- Mobile
- Adaptive
- Custom
- Custom Full Window

A futura área de ComboBox deve manter esses cenários enquanto continuarem válidos para a API final.

### Edit

Os grupos atualmente conhecidos são:

- Document Presets
- Contact Presets
- Numeric Presets
- Text Presets
- Case and URL
- Required
- Counter / Clear / Password
- Feedback
- Requirement
- Clipboard
- Custom Appearance

Esses grupos são cenários, não uma determinação de que cada um deva possuir uma unit própria.

O Edit continua em desenvolvimento. Revisões futuras relacionadas à Factory estão registradas em `SAMPLE_FUTURE_WORK.md`.

## 9. Direção das dependências

A infraestrutura compartilhada pode ser consumida pelas features. Features não devem depender lateralmente umas das outras sem necessidade arquitetural comprovada.

```text
Home -----------┐
Factory --------┼──> App / infraestrutura compartilhada
Fluent ---------┤
Composition ----┘

Factory/* ------> Rick.UIBuilder
Fluent/* -------> Rick.UIBuilder
Composition/* --> Rick.UIBuilder
```

Dependências a evitar:

```text
Fluent.Edit      -X-> Home
Factory.Button   -X-> Fluent.Button
Fluent.ComboBox  -X-> Fluent.Edit
Factory.ComboBox -X-> Fluent.ComboBox
```

Código visual realmente genérico e compartilhado deve subir para um boundary de infraestrutura somente depois que o compartilhamento estiver comprovado. Não antecipar abstrações.

## 10. Convenção de namespaces e units

A raiz das units do aplicativo permanece:

```text
RickUIBuilder.Samples.*
```

Famílias previstas:

```text
RickUIBuilder.Samples.App.*
RickUIBuilder.Samples.Home.*
RickUIBuilder.Samples.Factory.*
RickUIBuilder.Samples.Fluent.*
RickUIBuilder.Samples.Composition.*
```

Sufixos como `.Main`, `.View`, `.Navigation`, `.Layout`, `.Style` ou equivalentes não devem ser criados por padrão. Devem representar uma responsabilidade real e estável.

Não criar interface, factory, service, DTO, record de configuração, registry ou classe auxiliar apenas para satisfazer aparência arquitetural.

## 11. Regra para records e classes

Records e classes não devem ser combinados mecanicamente para representar uma pequena estrutura visual.

Use record quando existir valor/dado coeso com semântica própria e benefício concreto de value type.

Use classe quando existir identidade, comportamento, lifetime ou responsabilidade que justifique object type.

Não introduzir `Config record + Builder class` apenas para transportar parâmetros entre dois métodos de uma tela. Se o crescimento futuro comprovar um componente visual reutilizável, a abstração deve ser desenhada a partir desse uso real.

## 12. Regras para Design System

Tokens compartilhados devem ter semântica, não apenas valor.

Exemplos aceitáveis quando comprovadamente globais:

```text
Background
Surface
Border
TextPrimary
TextSecondary
Primary
PrimarySoft
Success
SpacingSmall / Medium / Large
RadiusSmall / Medium / Large
```

Evitar tokens globais como:

```text
HomeCardWidth
EditExampleTop
ComboBoxDemoHeight
```

Esses valores pertencem ao layout da feature correspondente.

## 13. Regras Delphi/FMX do projeto de samples

Todo código futuro deve seguir as normas Delphi do projeto principal.

Convenções obrigatórias já definidas:

```text
Parâmetro de método  -> A...
Variável local       -> L...
Campo privado        -> F...
Constante            -> _NOME_
```

Os nomes devem ser semanticamente claros além de respeitar o prefixo.

### Uses e TBrushKind

Sempre que uma unit utilizar `TBrushKind`, deve declarar a unit que fornece o símbolo:

```delphi
uses
  FMX.Graphics;
```

A cláusula `uses` deve refletir as dependências reais da unit. Não depender de disponibilidade transitiva de símbolos.

### Ownership

Controles FMX criados em runtime devem ter owner e parent definidos de forma consciente. O padrão concreto de cada infraestrutura será documentado a partir da implementação autorizada, sem presumir lifetime ainda não implementado.

## 14. Regra para documentação de units futuras

Cada unit relevante do sample deve possuir cabeçalho técnico suficiente para que uma pessoa ou IA consiga identificar:

- objetivo;
- boundary ao qual pertence;
- responsabilidade;
- o que não pertence à unit;
- dependências relevantes;
- regras de extensão;
- comportamento que deve ser preservado.

XMLDoc deve documentar métodos públicos/protegidos e métodos privados cuja responsabilidade não seja evidente pelo nome. Não adicionar comentários redundantes apenas para aumentar documentação.

## 15. Regras para implementação assistida por IA

Antes de criar ou alterar uma tela do sample:

1. consultar a API pública real do componente;
2. identificar a abordagem correta;
3. verificar se o cenário já pertence a uma feature existente;
4. não assumir paridade entre Factory e Fluent;
5. não criar API na biblioteca porque o sample deseja demonstrá-la;
6. não transformar backlog em requisito implementado;
7. preservar a direção das dependências;
8. evitar crescimento de Home e infraestrutura por causa de detalhes de features;
9. manter `uses` completos, incluindo `FMX.Graphics` quando `TBrushKind` for utilizado;
10. considerar Method Toxicity Metrics em todo código Delphi novo ou alterado;
11. distinguir avaliação estática de métricas reais do RAD Studio;
12. documentar somente comportamento existente na implementação final.

## 16. Teste arquitetural para novos componentes

Antes de adicionar um componente, responder:

1. Em quais abordagens a API pública realmente oferece o componente?
2. Quais diretórios/features precisam ser adicionados?
3. Quais arquivos existentes precisam mudar e por quê?
4. Alguma feature não relacionada está sendo alterada?
5. A Home está ganhando conhecimento de cenários internos?
6. A infraestrutura está recebendo algo que só uma feature utiliza?
7. Existe nova abstração sem segundo consumidor ou responsabilidade comprovada?
8. A navegação continua independente dos detalhes internos do componente?

Exemplo de crescimento esperado para um hipotético `CheckBox`, caso a API futura realmente o ofereça em Factory e Fluent:

```text
Factory/CheckBox/
Fluent/CheckBox/
```

A inclusão não deveria exigir alterações em Edit, ComboBox, Button, Badge ou Divider.

## 17. Teste arquitetural para novos cenários

Antes de adicionar um cenário:

1. pertence a qual componente?
2. é apenas um método de demonstração ou possui responsabilidade suficiente para unit própria?
3. reutiliza infraestrutura realmente compartilhada ou apenas código da própria feature?
4. introduz dependência lateral desnecessária?
5. o cenário pode ser localizado facilmente pelo nome e pela estrutura?
6. o exemplo continua ensinando a API pública sem esconder o uso relevante atrás de abstrações do sample?

O último item é importante: a arquitetura do aplicativo de samples não pode tornar os exemplos mais difíceis de compreender que a própria biblioteca.

## 18. Anti-patterns a evitar

Não permitir que o projeto evolua para:

- uma Home com todos os componentes e todos os eventos de navegação;
- uma única unit por abordagem contendo todos os exemplos;
- uma unit auxiliar global com funções sem relação entre si;
- um DesignSystem usado como depósito de constantes locais;
- `Config record + class` para cada pequeno elemento visual;
- uma Form por variação mínima de configuração;
- dependência entre exemplos Factory e Fluent apenas para eliminar algumas linhas duplicadas;
- abstrações do sample que escondam como utilizar `Rick.UIBuilder`;
- documentação fora da árvore `docs/`.

## 19. Documentação do projeto de samples

Toda documentação pertence à raiz documental do repositório:

```text
docs/
└── samples/
    ├── SAMPLE_ARCHITECTURE.md
    └── SAMPLE_FUTURE_WORK.md
```

Não criar `sample/docs`, `samples/docs` ou documentos Markdown espalhados pelo projeto executável.

`SAMPLE_ARCHITECTURE.md` é a referência estrutural.

`SAMPLE_FUTURE_WORK.md` registra decisões que dependem de implementação futura e não podem ser tratadas como funcionalidade atual.

## 20. Processo gradual de implementação

A implementação deve ocorrer em etapas autorizadas separadamente.

Ordem conceitual recomendada:

```text
1. Estrutura e documentação
2. Home
3. Infraestrutura mínima comprovadamente necessária pela Home
4. Navegação de primeiro nível
5. Factory
6. Fluent
7. Composition
8. Componentes e cenários, gradualmente
```

Essa ordem não autoriza automaticamente nenhuma etapa seguinte.

Quando a implementação revelar uma necessidade arquitetural não prevista, atualizar esta documentação somente depois de confirmar a necessidade no código real.

## 21. Critérios de qualidade para cada etapa de código

Quando houver autorização para código Delphi:

- alteração mínima necessária;
- responsabilidade clara;
- `uses` corretos;
- compatibilidade Delphi confirmada conforme o projeto;
- ownership/lifetime analisados quando aplicável;
- nomenclatura conforme as regras do projeto;
- avaliação de `Length`, `Parameters`, `If Depth` e `Cyclomatic Complexity`;
- nenhuma toxicidade nova ou agravada;
- resultado real de `Toxicity` somente quando RAD Studio/CSV for realmente executado;
- build/testes declarados somente quando realmente executados;
- documentação sincronizada com a implementação final.

## 22. Limites desta especificação

Este documento não define nem autoriza:

- implementação concreta do router/navigator;
- implementação concreta do Shell;
- classes, interfaces ou records ainda inexistentes;
- layout final de todas as páginas;
- API futura da biblioteca;
- `Factory.CreateEdit`;
- refatoração do framework;
- alteração funcional do `Rick.UIBuilder`.

Qualquer item não confirmado deve permanecer como **Não confirmado.** até existir evidência no código, requisito explícito ou validação real.
