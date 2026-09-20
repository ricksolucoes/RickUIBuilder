# RickUIBuilder

[![Delphi](https://img.shields.io/badge/Delphi-FireMonkey-E62431?style=flat-square)](#requisitos)
[![FMX](https://img.shields.io/badge/UI-FMX-0E7490?style=flat-square)](#visao-geral)
[![Tests](https://img.shields.io/badge/Tests-DUnitX-2EA44F?style=flat-square)](#testes)
[![License](https://img.shields.io/badge/License-Revocable%20Software%20License-8250DF?style=flat-square)](LICENSE-pt-BR)

[English](README.md) | **Português (Brasil)**

O RickUIBuilder é uma biblioteca para Delphi FireMonkey (FMX) voltada à criação e composição de controles de UI por código. A biblioteca oferece três formas complementares de uso: criação direta com a `Factory`, configuração por `Fluent Builders` e `Composition` para montar sequências de controles em um mesmo `Parent`.

A distribuição é feita em código-fonte. Para usar o RickUIBuilder, basta adicionar o diretório `src` ao **Search Path** do projeto Delphi.

## Conteúdo

- [Visão geral](#visao-geral)
- [Recursos](#recursos)
- [Requisitos](#requisitos)
- [Instalação](#instalacao)
- [Primeiros passos](#primeiros-passos)
- [Factory](#factory)
- [Label Builder](#label-builder)
- [Button Builder](#button-builder)
- [Badge Builder](#badge-builder)
- [Divider Builder](#divider-builder)
- [Composition](#composition)
- [Uso com Interfaces](#uso-com-interfaces)
- [Sample](#sample)
- [Testes](#testes)
- [Licença](#licenca)

<a name="visao-geral"></a>
## 📖 Visão geral

A unit `Rick.UIBuilder` expõe `TRickUIBuilder`, que funciona como principal ponto de entrada da biblioteca:

```text
TRickUIBuilder
├── Factory   -> criação direta de controles
├── Label_    -> Fluent Builder de Label
├── Button    -> Fluent Builder de Button
├── Badge     -> Fluent Builder de Badge
├── Divider   -> Fluent Builder de Divider
└── On(...)   -> Composition de UI
```

As três formas de criação atendem a níveis diferentes de configuração:

| Forma de uso | Ponto de entrada | Quando usar |
| --- | --- | --- |
| Factory | `TRickUIBuilder.Factory` ou `TRickUIBuilderFactory` | Quando você quer criar o controle diretamente a partir de um record de configuração |
| Fluent Builders | `Label_`, `Button`, `Badge`, `Divider` | Quando precisa configurar o componente de forma encadeada e legível antes de chamar `Build` |
| Composition | `TRickUIBuilder.On(AParent)` | Quando precisa criar uma sequência curta de controles no mesmo `Parent` |

Usar explicitamente uma interface `IRickUIBuilder*` **não representa uma quarta forma de criação**. É apenas outra maneira de manter e utilizar os mesmos `Fluent Builders` por meio de seus contratos públicos.

<a name="recursos"></a>
## ✨ Recursos

- Criação direta de textos, buttons, badges e dividers FMX por meio de `TRickUIBuilderFactory`.
- `Fluent Builders` para Label, Button, Badge e Divider.
- `Composition` de UI com `TRickUIBuilder.On(AParent)`.
- Records de configuração com valores `Default` reutilizáveis para criação direta pela `Factory`.
- Configuração compartilhada de espaçamento com `TRickUIBuilderSpacing`.
- Configuração de click e hover em Button.
- Handles de Button e Badge que expõem o container gerado e o `TLabel` interno.
- Interfaces públicas para os `Fluent Builders`, estado de hover do Button, Handles de controles gerados e `Composition`.

<a name="requisitos"></a>
## 🧰 Requisitos

- Delphi com suporte a FireMonkey (FMX).
- Diretório `src` do RickUIBuilder disponível para o projeto que irá consumir a biblioteca.

<a name="instalacao"></a>
## 📦 Instalação

Clone ou copie o RickUIBuilder e adicione o diretório `src` ao **Search Path** do projeto Delphi:

```text
<path-to-RickUIBuilder>\src
```

Para o uso normal da biblioteca, não é necessário instalar package.

<a name="primeiros-passos"></a>
## 🚀 Primeiros passos

Para trabalhar com os `Fluent Builders`, o ponto de entrada mais direto é `Rick.UIBuilder`:

```pascal
uses
  System.UITypes,
  Rick.UIBuilder;

procedure TMainForm.BuildUI;
begin
  TRickUIBuilder.Label_
    .Text('Olá, RickUIBuilder')
    .Position(24, 24)
    .Size(280, 28)
    .FontSize(16)
    .FontColor(TAlphaColors.Black)
    .Bold
    .Build(Self);
end;
```

`Label_` usa o `_` no final de forma intencional, pois `Label` entra em conflito com a sintaxe do Object Pascal.

Nas próximas seções, cada forma de uso é apresentada com mais detalhes.

---

<a name="factory"></a>
## 🏭 Factory

**Unit de implementação:** `Rick.UIBuilder.Factory`

`TRickUIBuilderFactory` cria os controles FMX imediatamente a partir de records de configuração. Cada método recebe um `AOwner`, um `AParent` e a configuração necessária para o controle que será criado.

A mesma `Factory` também pode ser acessada por:

```pascal
TRickUIBuilder.Factory
```

### Métodos disponíveis na Factory

| Método | Resultado |
| --- | --- |
| `CreateText` | `TLabel` |
| `CreateDivider` | `TRectangle` |
| `CreateBadge` | `TRectangle` do Badge e seu `TLabel` interno por meio de um parâmetro `out` |
| `CreateButton` | `TRectangle` do Button; uma sobrecarga aditiva também retorna o `TLabel` interno do caption por parâmetro `out` |

### Records de configuração

A criação com `Factory` utiliza os records definidos em `Rick.UIBuilder.Types`. A forma mais simples de usar é partir de `Default`, alterar apenas o que a tela precisa e passar o record resultante para a `Factory`.

| Record | Opções disponíveis |
| --- | --- |
| `TRickUIBuilderTextConfig` | `Left`, `Top`, `Width`, `Height`, `FontSize`, `FontColor`, `HorizontalAlign`, `Bold` |
| `TRickUIBuilderButtonConfig` | `Left`, `Top`, `Width`, `Height`, `FillColor`, `BorderColor`, `TextColor`, `Tag`, `FontSize` |
| `TRickUIBuilderBadgeConfig` | `Left`, `Top`, `Width`, `Height`, `BackgroundColor`, `TextColor`, `FontSize` |
| `TRickUIBuilderDividerConfig` | `Left`, `Top`, `Width`, `Color` |

Os exemplos abaixo alteram propositalmente apenas alguns campos. Os demais continuam disponíveis quando a tela exigir uma configuração mais específica.

```pascal
uses
  System.UITypes,
  FMX.StdCtrls,
  Rick.UIBuilder.Factory,
  Rick.UIBuilder.Types;

procedure TMainForm.BuildWithFactory;
var
  LTextConfig: TRickUIBuilderTextConfig;
  LButtonConfig: TRickUIBuilderButtonConfig;
  LBadgeConfig: TRickUIBuilderBadgeConfig;
  LDividerConfig: TRickUIBuilderDividerConfig;
  LBadgeText: TLabel;
begin
  LTextConfig := TRickUIBuilderTextConfig.Default;
  LTextConfig.Left := 24;
  LTextConfig.Top := 24;
  LTextConfig.FontSize := 16;
  TRickUIBuilderFactory.CreateText(
    Self,
    Self,
    'Criado com a Factory',
    LTextConfig
  );

  LDividerConfig := TRickUIBuilderDividerConfig.Default;
  LDividerConfig.Left := 24;
  LDividerConfig.Top := 64;
  LDividerConfig.Width := 280;
  TRickUIBuilderFactory.CreateDivider(Self, Self, LDividerConfig);

  LBadgeConfig := TRickUIBuilderBadgeConfig.Default;
  LBadgeConfig.Left := 24;
  LBadgeConfig.Top := 80;
  LBadgeConfig.BackgroundColor := TAlphaColors.Lightgray;
  TRickUIBuilderFactory.CreateBadge(
    Self,
    Self,
    'Ativo',
    LBadgeConfig,
    LBadgeText
  );

  LButtonConfig := TRickUIBuilderButtonConfig.Default;
  LButtonConfig.Left := 24;
  LButtonConfig.Top := 120;
  LButtonConfig.Width := 160;
  TRickUIBuilderFactory.CreateButton(
    Self,
    Self,
    'Continuar',
    LButtonConfig
  );
end;
```

`AOwner` controla o lifetime dos controles criados, enquanto `AParent` define onde eles serão inseridos na árvore visual do FMX.

No caso de Button, o método direto da `Factory` cria o controle visual, mas não adiciona o comportamento de hover disponível no `Fluent Builder`. Quando você precisar de `HoverFillColor`, `OnHover` ou outras opções específicas do Builder, use o `Button Builder`. A sobrecarga original `CreateButton(...): TRectangle` continua disponível; use a sobrecarga com `out ATextLabel: TLabel` somente quando o código que utiliza diretamente a Factory também precisar da referência exata ao label de caption criado para aquele Button. Os dois controles continuam pertencendo ao `AOwner` informado à Factory.

---

<a name="label-builder"></a>
## 🔤 Label Builder

**Unit de implementação:** `Rick.UIBuilder._Label`

Use `TRickUIBuilder.Label_` para configurar um `TLabel` com Fluent API. O controle só é criado quando `Build` é chamado.

### O que pode ser configurado

- Text, position, size e anchors.
- Margin e padding.
- Font family, font size, font color, bold e italic.
- Alinhamento horizontal e vertical do texto.
- Word wrapping e text trimming.
- Opacity, visibility, hit testing e tag.

`TRickUIBuilderSpacing` é usado por `Margin` e `Padding` e disponibiliza os helpers `Uniform`, `Create` e `None`. `Margin` é somado à posição definida em `Position`; `Padding` atua na área interna do texto sem alterar o `Width` e o `Height` configurados para o controle.

```pascal
uses
  System.UITypes,
  FMX.Types,
  Rick.UIBuilder,
  Rick.UIBuilder.Types;

procedure TMainForm.BuildLabel;
begin
  TRickUIBuilder.Label_
    .Text('Um Label com configuração mais completa')
    .Position(24, 24)
    .Size(320, 48)
    .FontSize(16)
    .FontColor(TAlphaColors.Black)
    .Bold
    .Align(TTextAlign.Center)
    .VerticalAlign(TTextAlign.Center)
    .WordWrap
    .Margin(TRickUIBuilderSpacing.Uniform(4))
    .Padding(TRickUIBuilderSpacing.Create(8, 4, 8, 4))
    .Opacity(1)
    .Visible
    .Build(Self);
end;
```

---

<a name="button-builder"></a>
## 🔘 Button Builder

**Unit de implementação:** `Rick.UIBuilder.Button`

Use `TRickUIBuilder.Button` quando o Button precisar de configuração visual ou de comportamento mais rica do que a criação direta pela `Factory`.

### O que pode ser configurado

- Caption, position, size e anchors.
- Corner radius, margin e padding.
- Fill color, border color e border thickness.
- Text color, font family, font size e bold.
- Hover fill color e handlers personalizados de enter/leave.
- Estado `Enabled` e `DisabledOpacity`.
- Cursor, opacity, visibility e tag.
- Click handler.

```pascal
uses
  System.Classes,
  System.UITypes,
  Rick.UIBuilder,
  Rick.UIBuilder.Types;

procedure TMainForm.SaveClick(Sender: TObject);
begin
  // Ação específica da aplicação.
end;

procedure TMainForm.BuildButton;
begin
  TRickUIBuilder.Button
    .Caption('Salvar')
    .Position(24, 24)
    .Size(160, 44)
    .CornerRadius(10)
    .FillColor(TAlphaColors.Dodgerblue)
    .BorderColor(TAlphaColors.Black)
    .BorderThickness(1)
    .TextColor(TAlphaColors.White)
    .FontSize(15)
    .Bold
    .HoverFillColor(TAlphaColors.Lightgray)
    .Padding(TRickUIBuilderSpacing.Create(12, 6, 12, 6))
    .OnClick(SaveClick)
    .Build(Self);
end;
```

Quando `Enabled(False)` é usado, o Builder aplica o valor configurado em `DisabledOpacity`. Quando está habilitado, utiliza o valor normal de `Opacity`.

### Estado de hover do Button

O Button Builder configura o hover pela própria API fluent pública (`HoverFillColor` e `OnHover`). O RickUIBuilder também expõe `IRickUIBuilderButtonHoverState` quando for necessário configurar explicitamente o próprio estado de hover.

`TRickUIBuilderButtonHoverState.New` não recebe parâmetros. A configuração é feita por overloads fluent de entrada, enquanto os overloads correspondentes sem parâmetro retornam os valores atualmente configurados:

| Configuração | Overload de entrada | Overload de saída |
| --- | --- | --- |
| Button | `Button(AValue: TRectangle)` | `Button: TRectangle` |
| Fill normal | `FillColor(AValue: TAlphaColor)` | `FillColor: TAlphaColor` |
| Fill de hover | `HoverFillColor(AValue: TAlphaColor)` | `HoverFillColor: TAlphaColor` |
| Handler de MouseEnter | `OnEnter(AValue: TNotifyEvent)` | `OnEnter: TNotifyEvent` |
| Handler de MouseLeave | `OnLeave(AValue: TNotifyEvent)` | `OnLeave: TNotifyEvent` |

Cada overload de entrada retorna `IRickUIBuilderButtonHoverState`, preservando o encadeamento fluent. `Build(AOwner)` materializa o comportamento persistente de hover e retorna o mesmo contrato de interface.

```pascal
uses
  System.UITypes,
  FMX.Objects,
  Rick.UIBuilder.Button.HoverState,
  Rick.UIBuilder.Interfaces;

procedure TMainForm.ConfigureButtonHover(const AButton: TRectangle);
var
  LHoverState: IRickUIBuilderButtonHoverState;
begin
  LHoverState := TRickUIBuilderButtonHoverState.New
    .Button(AButton)
    .FillColor(AButton.Fill.Color)
    .HoverFillColor(TAlphaColors.Lightgray);

  LHoverState.Build(Self);
end;
```

A interface de configuração pode ser liberada depois de `Build`. O comportamento materializado dos eventos pertence ao `AOwner` informado a `Build` e permanece vivo enquanto esse Owner permanecer vivo. `Build` não altera o ownership do Button; portanto, o Owner informado deve permanecer vivo enquanto o Button puder disparar os eventos de hover configurados.

### Acessando os controles gerados

A API existente `Build(AParent): TRectangle` foi preservada e continua sendo a opção mais simples quando o consumidor precisa apenas do container do Button. Quando também for necessária a referência exata ao label interno do caption, use `BuildHandle`. O retorno é um `IRickUIBuilderButtonHandle` com `Container` e `TextLabel` apontando para os mesmos controles criados pelo Builder.

```pascal
uses
  Rick.UIBuilder,
  Rick.UIBuilder.Interfaces;

procedure TMainForm.BuildButtonWithHandle;
var
  LHandle: IRickUIBuilderButtonHandle;
begin
  LHandle := TRickUIBuilder.Button
    .Caption('Salvar')
    .Size(160, 44)
    .BuildHandle(Self);

  LHandle.TextLabel.Text := 'Salvo';
end;
```

O Handle é **non-owning**. Liberar a interface não libera nenhum dos controles e manter a interface referenciada não mantém esses controles vivos. O ownership e o lifetime continuam pertencendo ao `Owner` usado na criação (o Fluent Builder utiliza o `AParent` informado a `Build`/`BuildHandle` como Owner e Parent do container e como Owner do label de caption). Portanto, `Container` e `TextLabel` não devem ser acessados pelo Handle depois que o respectivo Owner tiver sido destruído.

Use `Build` quando somente o `TRectangle` for necessário. Use `BuildHandle` quando o código precisar acessar explicitamente o `TLabel` criado, sem depender da organização interna de `Children` do Button.

As chamadas em código-fonte para `Build(AParent): TRectangle` permanecem inalteradas. Como `IRickUIBuilderButton` passa a possuir um novo método, units/packages Delphi dependentes devem ser recompilados contra esta versão; não é afirmada compatibilidade binária com DCUs/DCPs/BPLs compilados contra o layout anterior da interface.

---

<a name="badge-builder"></a>
## 🏷️ Badge Builder

**Unit de implementação:** `Rick.UIBuilder.Badge`

Use `TRickUIBuilder.Badge` para criar um Badge composto por um `TRectangle` como container e um `TLabel` interno.

### O que pode ser configurado

- Text, position e size.
- Pill mode ou corner radius explícito.
- Margin e padding.
- Background color, text color e border color.
- Font size e bold.
- Opacity, visibility e tag.

`Build` retorna um `IRickUIBuilderBadgeHandle`, que dá acesso ao `Container` e ao `TextLabel` gerados quando for necessário atualizá-los depois da criação.

```pascal
uses
  System.UITypes,
  Rick.UIBuilder,
  Rick.UIBuilder.Types;

procedure TMainForm.BuildBadge;
begin
  TRickUIBuilder.Badge
    .Text('Ativo')
    .Position(24, 24)
    .Size(100, 28)
    .Pill
    .BackgroundColor(TAlphaColors.Lightgray)
    .TextColor(TAlphaColors.Black)
    .BorderColor(TAlphaColors.Dodgerblue)
    .FontSize(12)
    .Bold
    .Padding(TRickUIBuilderSpacing.Create(8, 2, 8, 2))
    .Build(Self);
end;
```

Quando `Pill(True)` é usado, o formato pill definido pela `Factory` é preservado. Com `Pill(False)`, passa a valer o valor informado em `CornerRadius`.

---

<a name="divider-builder"></a>
## ➖ Divider Builder

**Unit de implementação:** `Rick.UIBuilder.Divider`

Use `TRickUIBuilder.Divider` para criar separadores horizontais ou verticais com length, thickness, color, opacity e visibility configuráveis.

### O que pode ser configurado

- Position e length.
- Thickness.
- Orientação horizontal ou vertical.
- Margin.
- Color, opacity e visibility.

Em um Divider vertical, o valor informado em `Width` passa a representar o length do Divider, enquanto `Thickness` define a largura visual.

```pascal
uses
  System.UITypes,
  FMX.Types,
  Rick.UIBuilder,
  Rick.UIBuilder.Types;

procedure TMainForm.BuildDivider;
begin
  TRickUIBuilder.Divider
    .Position(24, 24)
    .Width(240)
    .Thickness(2)
    .Orientation(TOrientation.Horizontal)
    .Margin(TRickUIBuilderSpacing.Uniform(4))
    .Color(TAlphaColors.Lightgray)
    .Opacity(1)
    .Build(Self);
end;
```

---

<a name="composition"></a>
## 🧩 Composition

**Unit de implementação:** `Rick.UIBuilder.Composition`

`TRickUIBuilder.On(AParent)` cria um composer associado a um único `Parent` FMX. Diferentemente dos `Fluent Builders` de componentes, o composer **não** espera um `Build` final: cada chamada `Add*` cria o controle imediatamente e devolve o mesmo composer para que o encadeamento continue.

### Operações disponíveis

| Método | Cria |
| --- | --- |
| `AddText` | `TLabel` |
| `AddDivider` | `TRectangle` do Divider |
| `AddBadge` | Badge e um `IRickUIBuilderBadgeHandle` |
| `AddButton` | `TRectangle` do Button com click handler opcional |

`Composition` utiliza os mesmos records de configuração da `Factory`.

```pascal
uses
  System.UITypes,
  Rick.UIBuilder,
  Rick.UIBuilder.Interfaces,
  Rick.UIBuilder.Types;

procedure TMainForm.BuildComposedUI;
var
  LText: TRickUIBuilderTextConfig;
  LDivider: TRickUIBuilderDividerConfig;
  LBadge: TRickUIBuilderBadgeConfig;
  LButton: TRickUIBuilderButtonConfig;
  LBadgeHandle: IRickUIBuilderBadgeHandle;
begin
  LText := TRickUIBuilderTextConfig.Default;
  LText.Left := 24;
  LText.Top := 24;
  LText.Width := 280;
  LText.FontSize := 16;

  LDivider := TRickUIBuilderDividerConfig.Default;
  LDivider.Left := 24;
  LDivider.Top := 60;
  LDivider.Width := 280;

  LBadge := TRickUIBuilderBadgeConfig.Default;
  LBadge.Left := 24;
  LBadge.Top := 76;
  LBadge.BackgroundColor := TAlphaColors.Lightgray;

  LButton := TRickUIBuilderButtonConfig.Default;
  LButton.Left := 24;
  LButton.Top := 116;
  LButton.Width := 160;

  TRickUIBuilder.On(Self)
    .AddText('UI composta', LText)
    .AddDivider(LDivider)
    .AddBadge('Pronto', LBadge, LBadgeHandle)
    .AddButton('Continuar', LButton, nil);
end;
```

Os records usados acima oferecem outros campos além dos alterados no exemplo. Parta de `Default` e sobrescreva somente o que fizer sentido para a tela atual.

---

<a name="uso-com-interfaces"></a>
## 🔌 Uso com Interfaces

**Unit:** `Rick.UIBuilder.Interfaces`

O RickUIBuilder expõe contratos públicos para os `Fluent Builders`, para o estado de hover do Button, para os Handles de Button e Badge e para o composer:

| Interface | Responsabilidade |
| --- | --- |
| `IRickUIBuilderLabel` | Contrato do Label Builder |
| `IRickUIBuilderButton` | Contrato do Button Builder |
| `IRickUIBuilderButtonHoverState` | Configuração fluent de hover com overloads de entrada/saída; `Build(AOwner)` materializa comportamento cujo lifetime segue o Owner informado |
| `IRickUIBuilderButtonHandle` | Acesso non-owning ao container e ao label de caption gerados para o Button |
| `IRickUIBuilderBadge` | Contrato do Badge Builder |
| `IRickUIBuilderBadgeHandle` | Acesso ao container e ao text label gerados para o Badge |
| `IRickUIBuilderDivider` | Contrato do Divider Builder |
| `IRickUIBuilderComposer` | Contrato de Composition |

Usar a interface explicitamente não cria outra implementação. Você continua trabalhando com o mesmo Builder retornado por `TRickUIBuilder`, apenas mantendo a referência pelo contrato público correspondente.

`IRickUIBuilderButtonHoverState` é diferente quanto à finalidade, mas segue o mesmo estilo orientado a interface: representa a configuração explícita do hover, e não um Builder visual. Seu `New` não recebe parâmetros, os pares setter/getter utilizam overloads e `Build(AOwner)` materializa o comportamento de eventos controlado pelo Owner. A interface de configuração não precisa permanecer referenciada depois de `Build`.

Exemplo simples:

```pascal
uses
  Rick.UIBuilder,
  Rick.UIBuilder.Interfaces;

procedure TMainForm.BuildThroughInterface;
var
  LButton: IRickUIBuilderButton;
begin
  LButton := TRickUIBuilder.Button;

  LButton
    .Caption('Salvar')
    .Size(120, 40)
    .Build(Self);
end;
```

Essa abordagem é útil quando o código deve depender explicitamente do contrato da interface sem abrir mão do mesmo comportamento do `Fluent Builder`.

---

<a name="sample"></a>
## 🎨 Sample

O projeto em `sample` é propositalmente simples e demonstra visualmente as três principais formas de uso:

- Factory.
- Fluent Builders.
- Composition.

Abra:

```text
sample\RickUIBuilder.Sample.dproj
```

O sample funciona como uma apresentação básica. Os exemplos deste README mostram opções adicionais que já estão disponíveis na API pública.

<a name="testes"></a>
## ✅ Testes

O projeto possui uma suíte DUnitX cobrindo as principais áreas do RickUIBuilder, incluindo:

- Types.
- Factory.
- Label.
- Button.
- Badge.
- Divider.
- Composition.
- Facade.

O projeto de testes está disponível no diretório `tests`.

### Resultado DUnitX verificado

Uma execução real de `RickUIBuilder.Test.exe` fornecida para esta versão apresentou:

| Resultado DUnitX | Valor |
| --- | ---: |
| Tests Found | **151** |
| Tests Passed | **151** |
| Tests Ignored | **0** |
| Tests Leaked | **0** |
| Tests Failed | **0** |
| Tests Errored | **0** |

Esses valores documentam essa execução verificada específica; não constituem garantia para revisões futuras.

### Method Toxicity Metrics

O Method Toxicity Metrics do RAD Studio também foi executado para os projetos da biblioteca e de testes. Nos relatórios fornecidos, ordenados por `Toxicity`, os maiores valores exibidos foram:

| Projeto | Maior `Toxicity` exibido | Threshold de qualidade do projeto |
| --- | ---: | ---: |
| `RickUIBuilder.dproj` | **0.487** | `< 1` |
| `RickUIBuilder.Test.dproj` | **0.367** | `< 1` |

Esses valores de `Toxicity` foram medidos pelo RAD Studio nos relatórios fornecidos; não são estimativas derivadas do código-fonte. A métrica é específica desta revisão e deve ser medida novamente após futuras alterações de código.

<a name="licenca"></a>
## 📄 Licença

Consulte [LICENSE-pt-BR](LICENSE-pt-BR).
