# Montagem e dependências do novo Edit

Este documento registra o **blueprint de implementação atual** do novo `Edit`, derivado do contrato em `src/Edit/Rick.UIBuilder.Edit.Interfaces.pas` e da implementação existente em `src/Edit/`.

A arquitetura é rígida: as 28 interfaces públicas possuem exatamente 28 classes concretas correspondentes, cada uma em sua unit exclusiva. Não existem classes próprias auxiliares de produção fora desse conjunto.

## Fonte de decisão

A implementação é derivada de:

1. contrato atual de `Rick.UIBuilder.Edit.Interfaces.pas`;
2. comportamento comprovado pelos testes do novo Edit;
3. regras vigentes de governança do projeto;
4. objetos e eventos FMX realmente utilizados pela implementação.

Implementações experimentais ou ZIPs anteriores não são fonte arquitetural.

## Princípios de montagem

### 1. Uma única entrada externa

O ponto de entrada externo é `IRickUIBuilderEdit`.

`IRickUIBuilderEdit` é o **composition root lógico**. A implementação correspondente cria a árvore visual compartilhada e conecta os cinco ramos públicos definidos pelo contrato.

O consumidor não precisa conhecer classes concretas, helpers internos ou caminhos paralelos de estado.

### 2. A árvore de interfaces é a árvore principal de responsabilidades

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
├── Designer
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

Cada estado é mantido pela implementação correspondente ao contrato que o representa. Controles FMX compartilhados são infraestrutura de composição, não classes de domínio do RickUIBuilder.

### 3. Correspondência 1 → 1 → 1

```text
1 interface pública
        ↓
1 classe concreta correspondente
        ↓
1 unit exclusiva
```

O estado estrutural esperado é:

```text
28 interfaces públicas
28 classes próprias de produção
28 units de implementação
+ Rick.UIBuilder.Edit.Interfaces.pas
+ Rick.UIBuilder.Edit.Types.pas
=
30 arquivos .pas em src/Edit/
```

`Rick.UIBuilder.Edit.InputRules.pas` e `Rick.UIBuilder.Edit.VisualState.pas` não fazem parte da arquitetura final.

### 4. Referências de navegação

Quando um filho precisa retornar ao contrato pai, mantém `FParent` como referência fraca:

```delphi
[weak]
FParent: IRickUIBuilderEditDesigner;
```

O pai armazena o filho pela interface correspondente. Implementações baseadas em `TInterfacedObject` seguem reference counting; receivers baseados em `TComponent` seguem o ownership do `TEdit`. A referência ascendente `[weak]` evita ciclo forte e preserva a navegação fluent.

### 5. Dependency Injection transporta a dependência real

As implementações podem receber:

- o contrato pai, para `ToBack`;
- interfaces existentes quando a responsabilidade depende de outro contrato;
- controles FMX (`TEdit`, `TRectangle`, `TLabel`, `TPath`) quando esses controles são o alvo real da implementação.

Não existe `Context`, service locator, record de settings agregado ou classe concreta auxiliar usada como barramento entre ramos.

### 6. Eventos permanecem nas implementações legítimas

Eventos FMX não justificam classe auxiliar.

As implementações que precisam sobreviver como receivers de eventos são as próprias classes correspondentes às interfaces existentes. Quando necessário, essas implementações derivam de `TComponent` e são owned pelo `TEdit` runtime.

Os eventos usados são encadeados preservando o handler anterior:

- `OnChangeTracking`: input configurável, counter e clear button;
- `OnEnter` / `OnExit`: contratos visuais que precisam reagir a Focus/ReadOnly/Invalid;
- `OnClick`: clear e password visibility;
- `OnValidate` / `OnValidating`: cooperação entre `Input.Config` e `Input.Number` para regras numéricas sobre o mesmo `TEdit`.

Não existe dispatcher próprio de eventos.

### 7. Controles FMX compartilhados

A implementação reutiliza somente controles do framework quando um comportamento atravessa ramos do contrato:

- `TRectangle` raiz, materializado pelo ramo Rectangle;
- `TEdit` runtime, materializado pelo Designer;
- seis `TPath` criados pelo composition root e compartilhados por Config/Validation/Designer.Config;
- um `TLabel` de erro lazy, materializado exclusivamente por `Labels.Error.Text`, owned pelo `TEdit` runtime e com parent visual no retângulo raiz; Validation apenas localiza e atualiza esse controle quando ele já existe.

Esses objetos usam ownership FMX e não transportam estado de domínio fora das responsabilidades definidas pelos contratos. O label de erro é reutilizado via `TEdit.Components`; não existe Context, tag, service locator ou helper próprio do projeto para essa ligação.

## Mapa de classes e dependências

| Contrato / classe | Responsabilidade principal | Dependências legítimas relevantes |
|---|---|---|
| `IRickUIBuilderEdit` / `TRickUIBuilderEdit` | composition root, `Parent`, `Build`, shared controls | interfaces dos cinco ramos + controles FMX |
| `IRickUIBuilderEditRetangle` / `TRickUIBuilderEditRetangle` | `TRectangle`, CornerRadius e filhos | `IRickUIBuilderEdit` |
| `IRickUIBuilderEditRetanglePosition` | Position | `IRickUIBuilderEditRetangle`, `TRectangle` |
| `IRickUIBuilderEditRetangleSize` | Size | `IRickUIBuilderEditRetangle`, `TRectangle` |
| `IRickUIBuilderEditRetangleBackground` | cores Normal/Invalid/ReadOnly | `TEdit`, `TRectangle`, `IRickUIBuilderEditDesignerValidation` |
| `IRickUIBuilderEditRetangleBorder` | Thickness e cores Normal/Focus/Invalid/ReadOnly | `TEdit`, `TRectangle`, `IRickUIBuilderEditDesignerValidation` |
| `IRickUIBuilderEditLabel` | agrupa Main/Counter/Error | `TEdit`, Validation |
| `IRickUIBuilderEditLabelMain` | agrupa Main.Text | `TEdit`, Validation |
| `IRickUIBuilderEditLabelMainText` | texto/tamanho do label principal | `TLabel`, `TEdit`, Validation |
| `IRickUIBuilderEditLabelMainTextColor` | cores Text/Invalid/ReadOnly | `TLabel`, `TEdit`, Validation |
| `IRickUIBuilderEditLabelCounter` | Enabled e sincronização do contador | `TEdit`, `TLabel`, `OnChangeTracking` |
| `IRickUIBuilderEditLabelError` | agrupa Error.Text | `TEdit`, `TRectangle` raiz |
| `IRickUIBuilderEditLabelErrorText` | Value/Color/Spacing da mensagem | `TLabel` lazy owned pelo `TEdit` |
| `IRickUIBuilderEditLabelErrorTextFont` | Family/Size/Styles | `TLabel` |
| `IRickUIBuilderEditDesigner` | cria `TEdit`; agrupa Input/Validation/Config | shared paths |
| `IRickUIBuilderEditDesignerInput` | agrupa Text/Number/Config | `TEdit`, background |
| `IRickUIBuilderEditDesignerInputText` | Value/Size | `TEdit` |
| `IRickUIBuilderEditDesignerInputTextColor` | Background/Text/ReadOnly | `TEdit`, background |
| `IRickUIBuilderEditDesignerInputNumber` | regras numéricas | `TEdit`, `OnValidate`, `OnValidating` |
| `IRickUIBuilderEditDesignerInputConfig` | Preset, máscaras, CaseMode, UrlCaseMode, MaxLength e caret | `TEdit`, `IRickUIBuilderEditDesignerInput` |
| `IRickUIBuilderEditDesignerValidation` | Required, RequirementIndicator, Feedback, Invalid e RequirementMet | `TEdit`, alert/requirement paths, error label lazy |
| `IRickUIBuilderEditDesignerConfig` | ClearButton, Password, ReadOnly | `TEdit`, clear/visibility paths |
| `IRickUIBuilderEditLine` | Thickness e alvo visual da linha | `TEdit`, Validation |
| `IRickUIBuilderEditLineColor` | Normal/Focus/Invalid/ReadOnly | `TEdit`, Validation |
| `IRickUIBuilderEditConfig` | Appearance e Icons | shared paths |
| `IRickUIBuilderEditConfigIcons` | Size e agrupamento Colors/Paths | shared paths |
| `IRickUIBuilderEditConfigIconColors` | cores dos paths | `TPath` |
| `IRickUIBuilderEditConfigIconPaths` | dados dos paths | `TPath` |

## Fluxo de estado visual

Não existe mais `TRickUIBuilderEditVisualState`.

A fonte de estado é a própria implementação legítima:

```text
Invalid
→ IRickUIBuilderEditDesignerValidation.InvalidValue

ReadOnly
→ TEdit.ReadOnly

Focus
→ handler local somente nos contratos que possuem variação Focus
```

A precedência preservada é:

```text
Background:
Invalid > ReadOnly > Normal

Border:
Invalid > ReadOnly > Focus > Normal

Line:
Invalid > ReadOnly > Focus > Normal

Main label:
Invalid > ReadOnly > Normal

Input text:
ReadOnly > Normal
```

`Designer.Validation.Invalid(...)` e `Designer.Config.ReadOnly(...)` solicitam refresh dos subscribers visuais pelo próprio chain de `OnEnter`, usando `Sender = nil` apenas como refresh interno. Os contratos de Focus não alteram sua flag local quando o `Sender` é `nil`.

## Fluxo de input

Não existe mais `TRickUIBuilderEditInputRules`.

O runtime é um `TEdit` comum criado por `TRickUIBuilderEditDesigner`.

`IRickUIBuilderEditDesignerInputConfig` possui as regras textuais que o contrato representa:

- CPF;
- CNPJ alfanumérico;
- CEP;
- Phone;
- Mobile;
- Email;
- URL;
- `CaseMode`;
- `UrlCaseMode`;
- `MaxLength`;
- transformação e preservação de caret.

`IRickUIBuilderEditDesignerInputNumber` possui:

- `AllowNegative`;
- `DecimalPlaces`;
- `FormatMode`;
- `DecimalSeparator`;
- `ThousandSeparator`;
- `UseThousandSeparator`;
- validação de IntegerNumber e FloatNumber.

Quando o preset é numérico, `Input.Config` materializa `Input.Number` pela interface pai existente. Os dois contratos operam sobre o mesmo `TEdit`; a validação numérica é exposta no próprio ciclo de validação do controle, sem cast para classe concreta e sem classe intermediária.

## Counter, clear, password e requirement

Essas responsabilidades não ficam mais concentradas em um runtime genérico:

```text
Counter
→ IRickUIBuilderEditLabelCounter

ClearButton / Password / ReadOnly
→ IRickUIBuilderEditDesignerConfig

RequirementIndicator / RequirementMet
→ IRickUIBuilderEditDesignerValidation
```

Os `TPath` são os mesmos objetos configurados por `IRickUIBuilderEditConfigIcons`, portanto configuração visual e comportamento operam sobre o mesmo controle FMX sem duplicação de estado.

## Validation feedback

`IRickUIBuilderEditDesignerValidation` é a fonte de verdade para:

- `Feedback`;
- `DefaultMessage`;
- `Invalid`;
- `InvalidMessage`;
- `RequirementIndicator`;
- `RequirementMet`.

`Labels.Error.Text` é o único responsável por materializar o `TLabel` lazy owned pelo `TEdit`. Se `Invalid` tiver sido configurado antes, `Error.Text` reaplica o estado existente por `IRickUIBuilderEditDesignerValidation`, usando somente o contrato público já disponível; depois disso Validation localiza e atualiza o mesmo controle. A aplicação de estilo não reinicializa mensagem nem visibilidade já ativas. O mesmo `TPath` de alert é configurado por `Config.Icons` e tem a visibilidade determinada por Validation. Isso preserva ambas as ordens de configuração/materialização sem classe de contexto.

## Lifetime dos receivers

A implementação precisa continuar reagindo a eventos depois que a interface raiz for liberada, enquanto a árvore FMX permanecer viva.

Para isso, implementações correspondentes a interfaces que recebem eventos podem ser componentes owned pelo `TEdit`. Elas não criam uma classe extra e não mantêm a raiz viva por referência forte.

Os contratos visuais que precisam consultar `Invalid` mantêm `IRickUIBuilderEditDesignerValidation`; a navegação ascendente permanece `[weak]`.

Durante a destruição do `TEdit`, os receivers não tentam restaurar handlers no owner quando `csDestroying` está ativo.

## Regras que permanecem proibidas

Não introduzir:

- `TRickUIBuilderEditContext`;
- `TRickUIBuilderEditVisualState`;
- `TRickUIBuilderEditInputRules`;
- `Interaction` genérico;
- `Runtime` genérico;
- `Coordinator`;
- `Manager`;
- `Materializer`;
- service locator;
- settings record agregado;
- interface nova apenas para justificar classe auxiliar.

Qualquer evolução deve continuar resolvendo responsabilidade dentro da implementação correspondente a uma interface existente, salvo alteração explícita do contrato pelo usuário.
