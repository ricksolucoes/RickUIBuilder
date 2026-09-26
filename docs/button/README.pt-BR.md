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
