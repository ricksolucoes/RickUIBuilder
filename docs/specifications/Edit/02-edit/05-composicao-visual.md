# Owner EDIT-COMPOSITION — Composição visual do Edit

**Origem:** `PEND-EDIT-002` — resolvida e migrada para este Owner normativo.

**Status documental:** `APROVADO` para a decisão já fechada; dependências explicitamente indicadas no próprio contrato continuam nos respectivos Owners.

Esta pendência é o Owner da **estrutura visual estática** do Edit: quais elementos FMX compõem o controle, qual é a relação Parent/child entre eles, qual elemento recebe foco/entrada e quais elementos podem existir como adornos visuais ou áreas de interação.

Ela não define tamanhos, cores, espessuras, margens, paths concretos, textos default ou qualquer outro valor visual; esses valores pertencem a `PEND-EDIT-007`. Também não define regras de máscara, validação, eventos ou operações runtime.

### Alternativas avaliadas

A composição foi analisada sem copiar integralmente Label, Button ou ComboBox.

1. **Usar somente `TEdit` como root e controle editável.**  
   Rejeitada porque não fornece uma superfície estrutural estável para label, support text, adornos laterais e hit areas sem acoplar esses elementos ao Parent externo.

2. **Usar `TLayout` como root e deixar toda apresentação no `TEdit`.**  
   Rejeitada porque o root não fornece uma superfície visual própria para representar estados de contorno/fundo do componente composto.

3. **Usar `TRectangle` como root e um `TEdit` interno, criando elementos adicionais fora do root.**  
   Rejeitada porque fragmenta ownership visual e permite que label/helper/adornos escapem da árvore do componente.

4. **Criar uma árvore profunda com containers independentes para label, input, helper, ícones e estados.**  
   Rejeitada porque introduz containers sem responsabilidade comprovada e aumenta complexidade de layout, hit testing e lifetime.

5. **Usar um `TRectangle` como root visual único, contendo diretamente o `TEdit` e somente os elementos auxiliares necessários.**  
   **Selecionada.** Fornece uma raiz visual única, mantém a árvore coesa e permite representar visualmente o campo sem criar camadas estruturais sem necessidade.

### Árvore visual normativa

A materialização do Edit deve seguir esta árvore conceitual:

```text
TRectangle  Root
├── TLabel      Label            [opcional]
├── TEdit       Input            [obrigatório]
├── TRectangle  LeftHitArea      [opcional]
│   └── TPath   LeftPath         [opcional]
├── TRectangle  RightHitArea     [opcional]
│   └── TPath   RightPath        [opcional]
└── TLabel      SupportText      [opcional]
```

Não devem ser criados containers adicionais apenas para reproduzir a arquitetura de outro componente.

### Root visual

O root do componente deve ser um `TRectangle`.

Responsabilidades estruturais:

- ser o único elemento retornável como raiz visual do Edit;
- ser anexado ao `AParent` recebido na materialização;
- conter todos os elementos visuais pertencentes ao Edit;
- delimitar a área visual total do componente;
- fornecer a superfície na qual estados visuais de container poderão ser aplicados;
- impedir que elementos auxiliares precisem ser irmãos externos do Edit.

O root não recebe entrada textual. Foco de edição pertence exclusivamente ao `TEdit` interno.

### Controle editável

Deve existir exatamente um `TEdit` obrigatório, denominado conceitualmente `Input`.

Responsabilidades:

- receber foco de teclado;
- receber e apresentar o texto editável;
- fornecer caret e seleção nativos do FMX;
- ser a única fonte visual de entrada textual dentro da composição.

Máscara, transformação, normalização, `MaxLength`, paste e demais políticas de entrada não pertencem a esta pendência e permanecem em `PEND-EDIT-003`.

A composição não deve criar um segundo `TEdit` para apresentação, máscara ou estado.

### Label

A composição suporta um `TLabel` opcional denominado conceitualmente `Label`.

Ele pertence ao root e identifica o campo quando a configuração funcional solicitar label.

Esta decisão define somente a existência e posição estrutural do elemento na árvore. Não define:

- texto default;
- floating label;
- animação;
- regra de visibilidade;
- tipografia;
- cor;
- margens;
- comportamento condicionado a foco ou conteúdo.

Qualquer comportamento de floating label ou transição exige contrato funcional próprio e não pode ser inferido desta composição.

### SupportText: helper e error

Helper e error **não devem criar dois labels simultâneos**.

A composição deve possuir no máximo um `TLabel` auxiliar opcional, denominado conceitualmente `SupportText`, responsável pela região textual de apoio abaixo/ao redor do campo conforme layout definido posteriormente.

O mesmo elemento visual é reutilizado para apresentar helper **ou** mensagem de erro. A decisão sobre qual conteúdo tem precedência e quando ele aparece pertence a `PEND-EDIT-004`.

Consequências:

- não há sobreposição entre `HelperLabel` e `ErrorLabel`;
- a troca de estado não exige criar/destruir labels;
- a árvore permanece estável durante validação.

### Adornos laterais (`TPath`)

A composição suporta até dois adornos visuais opcionais:

- `LeftPath`;
- `RightPath`.

Cada adorno é um `TPath` e deve permanecer filho de sua respectiva hit area quando esta existir.

Os paths são **visuais**. Não devem receber diretamente a responsabilidade de ação, foco textual ou regra de negócio.

O conteúdo SVG/path, tamanho, cor e visibilidade default pertencem a `PEND-EDIT-007` ou ao Owner funcional que introduzir determinada ação.

### Hit areas

Quando um adorno lateral possuir comportamento interativo confirmado, sua interação deve ser recebida por uma área dedicada:

- `LeftHitArea: TRectangle`;
- `RightHitArea: TRectangle`.

A hit area:

- é filha do root;
- contém o `TPath` correspondente;
- representa o alvo de ponteiro/toque;
- não recebe foco textual;
- não altera diretamente o texto por regra própria;
- encaminha a ação ao comportamento que for definido pelo Owner funcional correspondente.

Um `TPath` não deve ser usado como único hit target de uma ação.

Se não houver adorno/ação correspondente, a hit area não precisa ser materializada. A composição não reserva elementos invisíveis obrigatórios apenas por simetria.

### Estados visuais

Os estados visuais não devem ser representados por árvores alternativas nem pela criação/destruição do `Input`.

A árvore estrutural permanece a mesma. Mudanças de estado devem alterar propriedades dos elementos existentes.

A composição reconhece três alvos estruturais de estado:

- `Root`: container, contorno e fundo;
- `Input`: apresentação diretamente ligada ao texto editável;
- adornos/support text: apresentação contextual quando o respectivo Owner funcional determinar.

Esta pendência **não define o conjunto de estados nem sua precedência**. Estados como focused, invalid, disabled ou required somente podem receber semântica quando documentados pelos Owners funcionais correspondentes.

### Ordem visual e sobreposição

A árvore deve preservar estas invariantes:

- `Input` permanece utilizável mesmo quando label/support text existirem;
- hit areas laterais não podem ficar atrás do `Input` a ponto de perderem hit testing;
- paths permanecem dentro das respectivas hit areas;
- `Label` e `SupportText` não devem interceptar interação destinada ao `Input`;
- elementos auxiliares não podem ultrapassar a responsabilidade visual do root.

Coordenadas, paddings e dimensões concretas permanecem em `PEND-EDIT-007`.

### Foco

Somente `Input: TEdit` é o alvo de foco textual.

Clique/toque em área não interativa do campo pode futuramente encaminhar foco ao `Input`, mas essa política de interação não é definida aqui.

Hit areas de adornos não substituem o foco do `Input` e não constituem campos editáveis independentes.

### Owner e Parent

Na materialização:

- `Root.Parent` deve ser o `AParent` informado;
- todos os elementos internos devem possuir `Root` como `Parent`;
- nenhuma parte visual do Edit deve ser anexada diretamente ao Parent externo fora do root;
- referências internas a `Input`, `Label`, `SupportText`, paths e hit areas são non-owning do ponto de vista de qualquer futuro Handle.

O `Owner` Delphi concreto utilizado na criação deve respeitar a política de lifetime do framework e será fechado junto da semântica runtime/lifetime em `PEND-EDIT-006`; esta pendência não redefine ownership de `TComponent`.

### Elementos opcionais

A árvore possui somente um elemento estrutural obrigatório além do root: `Input`.

São opcionais:

- `Label`;
- `SupportText`;
- `LeftHitArea` / `LeftPath`;
- `RightHitArea` / `RightPath`.

Um elemento opcional só deve ser materializado quando alguma configuração ou comportamento funcional confirmado exigir sua presença. Não criar elementos ocultos preventivamente.

### Dependências remanescentes

- `PEND-EDIT-003`: comportamento do `Input` durante entrada, transformação, `MaxLength` e paste;
- `PEND-EDIT-004`: conteúdo/visibilidade de erro e precedência sobre helper em `SupportText`;
- `PEND-EDIT-005`: eventos produzidos pelas interações;
- `PEND-EDIT-006`: lifetime, referências runtime e operações pós-Build;
- `PEND-EDIT-007`: geometria, cores, tipografia, paths, margens e demais defaults.

### Critério de aceite da PEND-EDIT-002

| Questão | Decisão |
|---|---|
| Root | `TRectangle` único |
| Controle de edição | exatamente um `TEdit` interno |
| Label | `TLabel` opcional |
| Helper/error | um único `TLabel` opcional `SupportText` |
| Adorno esquerdo | `TPath` opcional |
| Adorno direito | `TPath` opcional |
| Hit target de adorno interativo | `TRectangle` dedicado |
| Foco textual | exclusivamente no `TEdit` |
| Estados | propriedades da árvore estável; sem árvores alternativas |
| Parent dos elementos internos | sempre o root |
| Elementos opcionais preventivos | proibidos |

Com estas decisões, a composição visual está estruturalmente definida sem antecipar comportamento, valores default ou lifetime pertencentes às demais pendências.
