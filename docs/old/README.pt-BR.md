# RickUIBuilder

**Framework Delphi/FMX para criação de controles de UI em runtime, com três abordagens complementares: criação direta via Factory, builders fluentes por atributo, e composição fluente de telas inteiras.**

[![Licença](https://img.shields.io/badge/licença-proprietária-lightgrey)](LICENSE-pt-BR)

🌐 [English](README.md) | [Português](README.pt-BR.md)

---

## Sobre

O `RickUIBuilder` cria controles FMX (`TLabel`, botões customizados, badges, divisores) inteiramente em código, sem depender de arquivos de design `.fmx` para os controles que constrói. Ele expõe três formas de criar o mesmo conjunto de controles, para que cada tela use a que fizer mais sentido:

- **Factory** — criação direta e estática a partir de um record de configuração (`TRickUIBuilderFactory`).
- **Builders fluentes** — configuração encadeada por atributo, finalizada com um `Build` (`TRickUIBuilder.Label_ / Button / Badge / Divider`).
- **Composição** — uma cadeia fluente que cria vários controles em sequência no mesmo parent (`TRickUIBuilder.On(AParent)`).

As três abordagens são acessadas por uma única classe de fachada, `TRickUIBuilder`.

## Requisitos

- Delphi 10.2 ou superior, com suporte a FMX.
- Nenhuma dependência de terceiros.

## Instalação

Não há pacote de instalação. Adicione a pasta `src/` ao search path do seu projeto (Project Options → Delphi Compiler → Search path), ou copie seu conteúdo para o seu projeto.

## Quick start

### Factory — criação direta

Para um controle único, com poucas variações:

```pascal
uses
  Rick.UIBuilder, Rick.UIBuilder.Types;

var
  LConfig: TRickUIBuilderTextConfig;
begin
  LConfig := TRickUIBuilderTextConfig.Default;
  LConfig.Left := 24;
  LConfig.Top := 16;
  LConfig.FontColor := TAlphaColors.Black;

  TRickUIBuilder.Factory.CreateText(Self, FCard, 'Olá', LConfig);
end;
```

### Builder fluente

Para controles com vários estados opcionais, ou que precisam reagir a eventos (hover, clique):

```pascal
uses
  Rick.UIBuilder;

var
  LButton: TRectangle;
begin
  LButton := TRickUIBuilder.Button
    .Caption('Instalar')
    .Position(24, 290)
    .Size(188, 40)
    .FillColor(TAlphaColors.Dodgerblue)
    .HoverFillColor(TAlphaColors.Royalblue)
    .TextColor(TAlphaColors.White)
    .OnClick(InstallButtonClick)
    .Build(FCard);
end;
```

### Composição

Para uma sequência curta e fixa de controles criados juntos:

```pascal
uses
  Rick.UIBuilder, Rick.UIBuilder.Types;

var
  LTextConfig: TRickUIBuilderTextConfig;
  LDividerConfig: TRickUIBuilderDividerConfig;
begin
  LTextConfig := TRickUIBuilderTextConfig.Default;
  LDividerConfig := TRickUIBuilderDividerConfig.Default;

  TRickUIBuilder.On(FCard)
    .AddText('Título', LTextConfig)
    .AddDivider(LDividerConfig);
end;
```

### Qual abordagem usar

- Use a **Factory** para um controle único e estático.
- Use um **builder fluente** quando precisar de comportamento de hover, manipuladores de clique, ou muitos atributos opcionais — só os builders expõem `HoverFillColor`/`OnHover` (no `Button`) e encadeamento por atributo.
- Use a **Composição** para criar vários controles no mesmo parent em uma única cadeia, quando não precisar configurar hover no botão que ela cria.

## Estrutura do repositório

```
RickUIBuilder/
├── LICENSE
├── LICENSE-pt-BR
├── README.md
├── README.pt-BR.md
├── src/       # Units do framework
├── tests/     # Suíte de testes DUnitX (unitária + integração)
└── sample/    # Aplicação FMX de exemplo
```

## Licença

Este projeto é distribuído sob uma licença proprietária e revogável, de titularidade da RickSoluções. Veja [LICENSE-pt-BR](LICENSE-pt-BR) para os termos completos.

---

<div align="center">

Feito por **[RickSoluções](https://github.com/ricksolucoes)**

</div>
