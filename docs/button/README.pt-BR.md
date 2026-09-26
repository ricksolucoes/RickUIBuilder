# Documentação Técnica do Button

> [English](README.md) | [Português do Brasil](README.pt-BR.md)

## Visão geral

O Button é um componente composto e possui comportamento runtime de hover separado do estado configurável.

```text
TRickUIBuilder.Button → Builder → Factory.CreateButton → TRectangle + TLabel
                           └→ HoverState → HoverBehavior
                           └→ BuildHandle → ButtonHandle
```

## Mapa

| Documento | Conteúdo |
|---|---|
| [API pública e configuração](api-publica-e-configuracao.pt-BR.md) | Fluent API, defaults e Factory × Builder. |
| [Hover e comportamento](hover-e-comportamento.pt-BR.md) | Estado vivo, eventos e mutabilidade pós-Build. |
| [Lifecycle, ownership e handle](lifecycle-ownership-e-handle.pt-BR.md) | `Build`, `BuildHandle`, ownership e lifetime. |
| [Customização e exemplos](customizacao-e-exemplos.pt-BR.md) | Exemplos progressivos. |

## Invariantes

- `Build` e `BuildHandle` usam o mesmo `BuildCore`.
- O Behavior consulta `FillColor`, `HoverFillColor`, `OnEnter` e `OnLeave` atuais a cada evento.
- Alterar `HoverState.Button` após o Build não retargeta o Behavior já criado.
- O Handle é non-owning em relação aos controles FMX.
- A Factory direta não adiciona o subsistema de hover do Fluent Builder.

## Mapa de manutenção

| Alteração | Leia primeiro |
|---|---|
| Fluent API/configuração | `src/Rick.UIBuilder.Button.pas`, `src/Rick.UIBuilder.Interfaces.pas` e `src/Rick.UIBuilder.Types.pas` quando config compartilhada for afetada |
| Estado/eventos de hover | `src/Rick.UIBuilder.Button.HoverState.pas`, `src/Rick.UIBuilder.Button.HoverBehavior.pas`, `src/Rick.UIBuilder.Button.pas` e [Hover e comportamento](hover-e-comportamento.pt-BR.md) |
| Handle/lifetime | `src/Rick.UIBuilder.Button.Handle.pas`, HoverState/Behavior e [Lifecycle, ownership e handle](lifecycle-ownership-e-handle.pt-BR.md) |
| Materialização pela Factory | `src/Rick.UIBuilder.Factory.pas` e [API pública e configuração](api-publica-e-configuracao.pt-BR.md) |
| Regressão de contrato | `tests/src/Rick.UIBuilder.Tests.Button.pas` |

## Contratos testados

A fixture DUnitX atual `tests/src/Rick.UIBuilder.Tests.Button.pas` cobre chaining da Fluent API, materialização visual, click/hover, opacity conforme `Enabled`, margin, `BuildHandle`, comportamento non-owning do Handle, alterações pós-Build de `FillColor`, `HoverFillColor`, `OnEnter` e `OnLeave`, não-retargeting após alterar `HoverState.Button` e permanência do hover após liberar referências externas ao Handle/estado. Esse é o baseline atual dos testes, não uma garantia isolada de comportamento futuro.
