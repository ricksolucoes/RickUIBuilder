# Montagem e dependências do novo Edit

Este documento registra o **blueprint de implementação** do novo `Edit` a partir do contrato atual em `src/Edit/Rick.UIBuilder.Edit.Interfaces.pas` e das regras vigentes de governança.

Ele não descreve uma implementação já concluída. Seu objetivo é impedir que a implementação seja decidida por conveniência durante a codificação.

## Fonte de decisão

A implementação deve ser derivada somente de:

1. contrato atual de `Rick.UIBuilder.Edit.Interfaces.pas`;
2. `api-and-interface-design`;
3. `interface-contract-preservation-policy.md`;
4. `interface-implementation-unit-policy.md`;
5. comportamento comprovado por código/testes/documentação quando necessário.

Implementações experimentais ou ZIPs anteriores não são fonte arquitetural.

## Princípios de montagem

### 1. Uma única entrada externa

O ponto de entrada externo é `IRickUIBuilderEdit`.

O consumidor pode navegar pelas interfaces especializadas por meio da fluent API, mas não deve precisar conhecer classes concretas, helpers internos ou mecanismos paralelos de estado.

`IRickUIBuilderEdit` é o **composition root lógico** do novo componente.

### 2. A árvore de interfaces é também a árvore principal de dependências

A relação definida pelo contrato deve ser preservada:

```text
IRickUIBuilderEdit
├── Rectangle
│   ├── Position
│   ├── Size
│   ├── Background
│   └── Border
├── Labels
│   ├── Main
│   │   └── Text
│   │       └── Color
│   ├── Counter
│   └── Error
│       └── Text
│           └── Font
├── Edit
│   ├── Input
│   │   ├── Text
│   │   │   └── Color
│   │   ├── Number
│   │   └── Config
│   ├── Validation
│   └── Config
├── Line
│   └── Color
└── Config
    └── Icons
        ├── Colors
        └── Paths
```

A implementação raiz origina a montagem. Cada implementação pai cria e mantém somente os contratos filhos que pertencem à sua própria ramificação.

### 3. Referências para baixo são fortes; retorno ao pai é fraco

O pai mantém os filhos por interface para preservar o lifetime da árvore.

A implementação filha recebe o contrato pai por injeção quando precisa de navegação de retorno.

Formato obrigatório:

```delphi
[weak]
FParent: IRickUIBuilderEditDesigner;
```

Não usar:

```delphi
[weak] FParent: IRickUIBuilderEditDesigner;
```

A referência fraca evita ciclo de reference counting quando o pai também mantém a interface filha.

### 4. Métodos de interface ficam em `protected`

A classe concreta deve manter a superfície pública mínima.

Padrão estrutural:

```delphi
type
  TRickUIBuilderEditExample = class(TInterfacedObject, IRickUIBuilderEditExample)
  private
    [weak]
    FParent: IRickUIBuilderEditParent;
  protected
    constructor Create(const AParent: IRickUIBuilderEditParent);

    function Configure(AValue: Boolean): IRickUIBuilderEditExample;
    function ToBack: IRickUIBuilderEditParent;
  public
    class function New(const AParent: IRickUIBuilderEditParent): IRickUIBuilderEditExample;
  end;
```

Não promover os métodos da interface para `public` sem necessidade comprovada.

### 5. Cada implementação guarda somente o contexto do próprio contrato

Não existe autorização para um `Context` central que reúna o estado de todo o Edit.

Quando uma propriedade já pode ser aplicada diretamente ao objeto FMX que aquela interface configura, prefira o próprio objeto como estado efetivo.

Quando o contrato representa múltiplos valores simultâneos que não cabem em uma única propriedade runtime — por exemplo cores Normal/Invalid/ReadOnly — a implementação correspondente pode manter esses valores em campos próprios.

Não duplicar o mesmo estado em interfaces diferentes.

### 6. Dependency Injection deve transportar a dependência real

Existem duas dependências diferentes que podem ser injetadas:

- **contrato pai**, para navegação fluent e retorno por `ToBack`;
- **objeto alvo específico**, somente quando uma interface especializada configura um objeto interno criado pelo pai e esse objeto não é exposto pelo contrato público.

O segundo caso não autoriza `Context`, service locator ou record agregador. É injeção direta da dependência concreta que aquela implementação realmente configura.

### 7. Nenhum helper existe por padrão

Nesta arquitetura não estão previamente aprovados:

- `TRickUIBuilderEditContext`;
- subclasse customizada de `TEdit`;
- `TRickUIBuilderEditInputRules`;
- `TRickUIBuilderEditInteraction`;
- `TRickUIBuilderEditMaterializer`;
- records agregadores de configuração.

Qualquer helper futuro precisa de necessidade comprovada pelo contrato/comportamento e não pode existir apenas porque simplifica a implementação.

### 8. `Parent` preserva a referência do local de montagem, não ownership

O contrato atual da raiz é:

```delphi
function Parent(AParentConstructor: TFmxObject): IRickUIBuilderEdit;
function Build: IRickUIBuilderEdit;
```

A implementação raiz deve guardar a referência recebida para que `Build` saiba onde montar o componente.

Uma referência `TFmxObject` simples **não prolonga o lifetime** do objeto informado. O ownership do `AParentConstructor` permanece externo. A estratégia exata de retenção/limpeza dessa referência deve respeitar o lifecycle FMX e ser validada antes da implementação final.

`Build` retornar `IRickUIBuilderEdit` permite que o consumidor mantenha a raiz viva depois da montagem; isso também mantém a árvore de interfaces filhas viva enquanto a raiz permanecer referenciada.

## Mapa de classes e dependências

| Contrato / classe nominal | Criada por | Dependência pai injetada | Contexto que pertence à implementação | Filhos que mantém | Observação arquitetural |
|---|---|---|---|---|---|
| `IRickUIBuilderEdit` / `TRickUIBuilderEdit` | entrada da composição | nenhuma | referência de `Parent` e referências dos cinco ramos principais | Rectangle, Labels, Edit, Line, Config | único composition root externo |
| `IRickUIBuilderEditRetangle` / `TRickUIBuilderEditRetangle` | root | `IRickUIBuilderEdit` | `TRectangle` exposto por `Control` e `CornerRadius` | Position, Size, Background, Border | o próprio `TRectangle` é o alvo natural do ramo |
| `IRickUIBuilderEditRetanglePosition` | Rectangle | `IRickUIBuilderEditRetangle` | nenhum estado duplicado quando puder escrever em `FParent.Control.Position` | nenhum | depende do `Control` já exposto pelo contrato pai |
| `IRickUIBuilderEditRetangleSize` | Rectangle | `IRickUIBuilderEditRetangle` | nenhum estado duplicado quando puder escrever em `FParent.Control` | nenhum | depende do `Control` já exposto pelo contrato pai |
| `IRickUIBuilderEditRetangleBackground` | Rectangle | `IRickUIBuilderEditRetangle` | valores Normal/Invalid/ReadOnly que pertencem a Background | nenhum | mecanismo de troca de estado precisa ser comprovado antes do código |
| `IRickUIBuilderEditRetangleBorder` | Rectangle | `IRickUIBuilderEditRetangle` | Thickness e cores Normal/Focus/Invalid/ReadOnly | nenhum | mecanismo de troca de estado precisa ser comprovado antes do código |
| `IRickUIBuilderEditLabel` | root | `IRickUIBuilderEdit` | somente referências dos subcontratos de labels | Main, Counter, Error | agrupador do ramo de labels |
| `IRickUIBuilderEditLabelMain` | Labels | `IRickUIBuilderEditLabel` | referência de Text | Text | não deve acumular estado que pertence a Text |
| `IRickUIBuilderEditLabelMainText` | Main | `IRickUIBuilderEditLabelMain` | Value, Size e o alvo visual interno do texto principal | Color | a classe FMX concreta do alvo deve ser confirmada antes da codificação |
| `IRickUIBuilderEditLabelMainTextColor` | MainText | `IRickUIBuilderEditLabelMainText` | Text/Invalid/ReadOnly colors | nenhum | `Invalid` e `ReadOnly` retornam o próprio `FParent` por contrato |
| `IRickUIBuilderEditLabelCounter` | Labels | `IRickUIBuilderEditLabel` | Enabled e alvo visual do contador | nenhum | sincronização com texto do Designer exige mecanismo comprovado |
| `IRickUIBuilderEditLabelError` | Labels | `IRickUIBuilderEditLabel` | referência de Text | Text | agrupador do erro |
| `IRickUIBuilderEditLabelErrorText` | Error | `IRickUIBuilderEditLabelError` | Value, Color, Spacing e alvo visual da mensagem | Font | Font deve receber apenas o alvo que realmente configura |
| `IRickUIBuilderEditLabelErrorTextFont` | ErrorText | `IRickUIBuilderEditLabelErrorText` | Family, Size, Styles ou aplicação direta no alvo injetado | nenhum | não precisa de record para três valores locais |
| `IRickUIBuilderEditDesigner` | root | `IRickUIBuilderEdit` | `TEdit` exposto por `Control` e referências dos subcontratos | Input, Validation, Config | dono lógico do controle de entrada |
| `IRickUIBuilderEditDesignerInput` | Designer | `IRickUIBuilderEditDesigner` | referências dos subcontratos de input | Text, Number, Config | agrupador do domínio de entrada |
| `IRickUIBuilderEditDesignerInputText` | Input | `IRickUIBuilderEditDesignerInput` | Value/Size aplicados ao `TEdit` quando possível | Color | `Size` e `ToBack` retornam `FParent.ToBack`, isto é, Designer |
| `IRickUIBuilderEditDesignerInputTextColor` | Input.Text | `IRickUIBuilderEditDesignerInputText` | Background/Text/ReadOnly colors | nenhum | alcança `TEdit` pela cadeia existente; não precisa alterar contrato |
| `IRickUIBuilderEditDesignerInputNumber` | Input | `IRickUIBuilderEditDesignerInput` | AllowNegative, DecimalPlaces, FormatMode, separators e UseThousandSeparator | nenhum | regras de digitação/formatação exigem prova do mecanismo de coordenação |
| `IRickUIBuilderEditDesignerInputConfig` | Input | `IRickUIBuilderEditDesignerInput` | Preset, CaseMode, UrlCaseMode, MaxLength | nenhum | regras de digitação/formatação exigem prova do mecanismo de coordenação |
| `IRickUIBuilderEditDesignerValidation` | Designer | `IRickUIBuilderEditDesigner` | Required, RequirementIndicator, Feedback, DefaultMessage e estado Invalid/RequirementMet | nenhum | o próprio contrato já possui getters de estado; não criar state paralelo |
| `IRickUIBuilderEditDesignerConfig` | Designer | `IRickUIBuilderEditDesigner` | ClearButton, Password e ReadOnly | nenhum | aplicar diretamente ao Designer/control quando houver propriedade real; controles auxiliares precisam de prova |
| `IRickUIBuilderEditLine` | root | `IRickUIBuilderEdit` | Thickness e alvo visual interno da linha | Color | tipo FMX concreto da linha ainda não é assumido |
| `IRickUIBuilderEditLineColor` | Line | `IRickUIBuilderEditLine` | Normal/Focus/Invalid/ReadOnly colors | nenhum | recebe o alvo real criado por Line quando necessário |
| `IRickUIBuilderEditConfig` | root | `IRickUIBuilderEdit` | Appearance e referência de Icons | Icons | não criar `ConfigSettings` só para espelhar a árvore |
| `IRickUIBuilderEditConfigIcons` | Config | `IRickUIBuilderEditConfig` | Size e os alvos internos dos ícones | Colors, Paths | Colors/Paths recebem somente os alvos que configuram |
| `IRickUIBuilderEditConfigIconColors` | Icons | `IRickUIBuilderEditConfigIcons` | Default/Alert/Clear/Password/Requirement colors | nenhum | não precisa de record agregado se os alvos forem injetáveis diretamente |
| `IRickUIBuilderEditConfigIconPaths` | Icons | `IRickUIBuilderEditConfigIcons` | paths Alert/Clear/Visibility/VisibilityOff/RequirementMet/RequirementNotMet | nenhum | pares de estado podem permanecer como campos desta implementação |

## Fluxos especiais já determinados pelo contrato

### MainText.Color

```text
MainText
  ↓ Color
MainTextColor
  ├─ Text(...)     → MainTextColor
  ├─ Invalid(...)  → MainText
  ├─ ReadOnly(...) → MainText
  └─ ToBack        → MainText
```

Logo, `TRickUIBuilderEditLabelMainTextColor` recebe `IRickUIBuilderEditLabelMainText` como `FParent` e retorna esse contrato onde a interface exige.

### Designer.Input.Text

```text
Designer
  ↓ Input
Input
  ↓ Text
InputText
  ├─ Value(...) → InputText
  ├─ Color      → InputTextColor
  ├─ Size(...)  → Designer
  └─ ToBack     → Designer
```

`TRickUIBuilderEditDesignerInputText` recebe `IRickUIBuilderEditDesignerInput` como `FParent`.

Quando precisar retornar `Designer`, usa a navegação contratual existente:

```delphi
Result := FParent.ToBack;
```

Não criar segundo Parent, getter, Context ou retorno alternativo.

## Pontos que exigem prova antes da implementação

Os itens abaixo ainda não possuem mecanismo aprovado. A ausência de decisão é intencional: nenhum deles deve ser resolvido por conveniência durante a codificação.

### 1. Transição de estados visuais

Background, Border, MainTextColor e LineColor possuem valores para estados diferentes, enquanto Validation/Config/focus alteram o estado ativo.

É necessário provar como essas implementações serão notificadas/aplicadas sem:

- `Context` central;
- duplicação de estado;
- cast frágil para classes concretas;
- service locator;
- interface nova não autorizada.

### 2. Regras de input

`Input.Number` e `Input.Config` possuem dados que precisam cooperar durante digitação/formatação.

Antes de criar helper como `InputRules`, deve ser demonstrado por que a própria árvore `Designer → Input → Text/Number/Config` não consegue assumir essa responsabilidade com DI e o `TEdit` existente.

### 3. Eventos runtime

Não criar `Interaction = class(TComponent)` por padrão.

Como `Build` retorna `IRickUIBuilderEdit` e a raiz mantém os filhos por interface, existe uma base natural para manter objetos que possuem event handlers vivos. O desenho de eventos deve primeiro explorar esse lifetime antes de introduzir outro componente runtime.

### 4. Materialização

Não criar `Materializer` por padrão.

Primeiro deve ser verificado se a própria raiz e os owners naturais de cada ramo conseguem criar/configurar seus objetos sem concentrar todas as responsabilidades em uma classe extra.

### 5. Records adicionais

`Rick.UIBuilder.Edit.Types.pas` atualmente contém os enums do contrato.

Nenhum record de settings está previamente autorizado. Um record novo só deve existir quando houver necessidade de domínio real que não possa ser representada pelo estado da própria implementação ou por DI direta.

## Critérios antes de começar a codificar

Antes da primeira unit concreta, o desenho deve responder com evidência:

- quem cria a classe;
- qual contrato pai ela recebe;
- quais filhos mantém;
- qual estado pertence exclusivamente a ela;
- qual objeto FMX ela configura;
- quem possui/destrói esse objeto;
- se existe evento runtime, quem mantém o receptor vivo;
- como estados transversais são propagados sem duplicação;
- por que qualquer helper/type adicional é necessário.

Se uma dessas respostas depender de suposição, o ponto permanece **Não confirmado** e não deve gerar código ainda.
