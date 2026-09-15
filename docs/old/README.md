# RickUIBuilder

**A Delphi/FMX framework for building UI controls at runtime, with three complementary approaches: direct creation via a Factory, fluent per-attribute builders, and fluent composition of whole screens.**

[![Delphi](https://img.shields.io/badge/Delphi-FMX-red?logo=delphi&logoColor=white)](#requisitos)
[![Tests](https://img.shields.io/badge/tests-DUnitX-blue)](#-testes)
[![License](https://img.shields.io/badge/license-proprietary-lightgrey)](LICENSE)

🌐 [English](README.md) | [Português](README.pt-BR.md)

---

## About

`RickUIBuilder` creates FMX controls (`TLabel`, custom buttons, badges, dividers) entirely in code, without depending on `.fmx` design files for the controls it builds. It exposes three ways to create the same set of controls, so each screen can pick whichever fits best:

- **Factory** — direct, static creation from a configuration record (`TRickUIBuilderFactory`).
- **Fluent builders** — per-attribute chained configuration with a final `Build` call (`TRickUIBuilder.Label_ / Button / Badge / Divider`).
- **Composition** — a fluent chain that creates several controls in sequence on the same parent (`TRickUIBuilder.On(AParent)`).

All three are reachable through a single facade class, `TRickUIBuilder`.

## Requirements

- Delphi 10.2 or later, with FMX support.
- No third-party dependencies.

## Installation

There is no install package. Add the `src/` folder to your project's search path (Project Options → Delphi Compiler → Search path), or copy its contents into your project.

## Quick start

### Factory — direct creation

For a single control with few variations:

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

  TRickUIBuilder.Factory.CreateText(Self, FCard, 'Hello', LConfig);
end;
```

### Fluent builder

For controls with several optional states, or that need to react to events (hover, click):

```pascal
uses
  Rick.UIBuilder;

var
  LButton: TRectangle;
begin
  LButton := TRickUIBuilder.Button
    .Caption('Install')
    .Position(24, 290)
    .Size(188, 40)
    .FillColor(TAlphaColors.Dodgerblue)
    .HoverFillColor(TAlphaColors.Royalblue)
    .TextColor(TAlphaColors.White)
    .OnClick(InstallButtonClick)
    .Build(FCard);
end;
```

### Composition

For a short, fixed sequence of controls created together:

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
    .AddText('Title', LTextConfig)
    .AddDivider(LDividerConfig);
end;
```

### Choosing an approach

- Use the **Factory** for a single, static control.
- Use a **fluent builder** when you need hover behavior, click handlers, or many optional attributes — only the builders expose `HoverFillColor`/`OnHover` (on `Button`) and per-attribute chaining.
- Use **Composition** to create several controls on the same parent in one chain, when you don't need to configure hover on the button it creates.

## Repository structure

```
RickUIBuilder/
├── LICENSE
├── LICENSE-pt-BR
├── README.md
├── README.pt-BR.md
├── src/       # Framework units
├── tests/     # DUnitX test suite (unit + integration)
└── sample/    # Sample FMX application
```

## License

This project is distributed under a proprietary, revocable license held by RickSoluções. See [LICENSE](LICENSE) for the full terms.

---

<div align="center">

Made by **[RickSoluções](https://github.com/ricksolucoes)**

</div>


