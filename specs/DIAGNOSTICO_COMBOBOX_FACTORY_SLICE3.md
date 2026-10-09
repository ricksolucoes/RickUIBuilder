# Diagnóstico — ComboBox Factory Slice 3

## Objetivo

Centralizar em `TRickUIBuilderFactory.CreateComboBox` a resolução de
`StyleType` e `PresentationMode`, preservando o comportamento atual do Fluent.

## Tentativa 1 — resolução direta do `AConfig`

**Hipótese:** bastaria executar `TRickUIBuilderComboBoxStyleResolver.Resolve`
dentro da Factory e remover `ResolvedConfig` do Builder.

**Resultado da análise:** não aplicada como solução final.

**Causa:** o resolver redefine `Height`, `ItemHeight`, `HorizontalPadding` e
`ArrowSize` para os defaults Desktop/Mobile. O Builder atual possui `FHeightOverridden`,
`FItemHeightOverridden` e `FArrowSizeOverridden` justamente para reaplicar os
valores explicitamente definidos pelo consumidor. Essa informação não existe
no `AConfig` isolado.

Aplicar essa tentativa causaria regressão funcional mesmo que testes mais
simples permanecessem verdes.

## Tentativa 2 — resolução centralizada com metadados de override

**Alteração:**

1. `FactoryOptions` transportava `PreserveHeight`, `PreserveItemHeight` e
   `PreserveArrowSize`; `HorizontalPadding` ainda não havia sido coberto;
2. a Factory salva os três valores solicitados;
3. executa o resolver existente;
4. reaplica somente os valores marcados como explicitamente sobrescritos;
5. cria Handle, Presentation e visual usando o config efetivo;
6. o Builder deixa de depender de `Rick.UIBuilder.ComboBox.Style` e envia o
   config solicitado diretamente à Factory.

**Status:** implementada.

**Validação estática:** coerente com o contrato existente e elimina a resolução
duplicada entre Fluent e Factory.

**Resultado real:** falhou na execução DUnitX de 2026-10-08.

A suíte executou 259 testes, com 2 failures e 0 errors. As falhas foram:

- `Factory_DeveCriarControleFechadoNoScrollBox`: esperado `Height = 42`, obtido `40`;
- `SetaDireita_DeveRespeitarMargensCustomizadas`: esperado `Arrow.Position.X = 270`, obtido `264`.

**Diagnóstico:** a solução preservava apenas valores marcados por flags. Isso
funciona para o Fluent, que possui flags internas de override, mas quebra o
contrato histórico da Factory direta, cujo `AConfig` sempre foi autoritativo.
Assim, `Height := 42` e `ArrowSize := 14` foram indevidamente substituídos pelos
defaults Desktop (`40` e `20`).

## Tentativa 3 — merge entre defaults de style e customizações do `AConfig`

**Hipótese:** style deve fornecer defaults; customizações diretas do `AConfig`
devem prevalecer.

**Alteração:**

1. a Factory resolve style/presentation normalmente;
2. compara os quatro campos que o resolver redefine (`Height`, `ItemHeight`,
   `HorizontalPadding`, `ArrowSize`) com `TRickUIBuilderComboBoxConfig.Default`;
3. valores diferentes do default-base são tratados como customizações e
   reaplicados automaticamente;
4. `PreserveHeight`, `PreserveItemHeight`, `PreserveHorizontalPadding` e
   `PreserveArrowSize` cobrem o caso explícito em que o valor desejado é igual
   ao default-base;
5. nenhum teste antigo foi relaxado e nenhuma geometria foi hardcoded para os
   valores esperados pelos testes.

**Status:** concluída e validada em execução real.

**Validação estática:** a regra cobre integralmente os campos atualmente
sobrescritos por `ApplyDesktopDefaults`/`ApplyMobileDefaults` e preserva o
contrato direto da Factory sem devolver a resolução ao Builder.

**Resultado real final:** 260/260 testes aprovados, 0 failures, 0 errors e 0 ignored na revisão final de 2026-10-08.
