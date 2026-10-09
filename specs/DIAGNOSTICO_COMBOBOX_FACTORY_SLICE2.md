# Diagnóstico — ComboBox Factory Slice 2

## Contexto

Relatório analisado: execução DUnitX de 2026-10-08 21:29:58.

Resultado informado pelo relatório:

- total: 255;
- errors: 0;
- failures: 1;
- teste com falha: `Columns_DeveAplicarConfiguracaoEstruturada`.

## Tentativa 1 — implementação/teste original do Slice 2

**Hipótese testada:** `Columns` configuradas em `FactoryOptions` chegam ao runtime
e são materializadas nas rows da lista.

**Resultado:** falhou.

**Falha observada:** `Object is Nil when Not Nil expected.`

**Causa raiz confirmada por comparação com o código existente:** o helper de
teste `FindFirstRow` percorria `TVertScrollBox.Children`. A suíte de integração
preexistente do ComboBox percorre `TVertScrollBox.Content.Children`, que é a
estrutura correta para localizar os controles inseridos no conteúdo do scroll.

O runtime de produção já cria cada row com `LRow.Parent := FScrollBox`; não foi
encontrada evidência de falha em `ConfigureColumns`, `SetColumns` ou
`BuildColumnText`. A execução também aprovou os demais sete testes adicionados no
Slice 2, incluindo callbacks e lifetime.

## Tentativa 2 — correção da instrumentação de teste

**Alteração:** `FindFirstRow` passa a iterar
`AScrollBox.Content.Children`. Foram adicionadas mensagens explícitas às
assertions que validam scroll e row.

**Produção alterada:** não.

**Motivo:** corrigir a produção para satisfazer um helper que observa a árvore
FMX de forma incorreta mascararia a causa real e poderia introduzir regressão.

**Resultado:** confirmado em execução real posterior; o Slice 2 passou integralmente após a correção da instrumentação do teste.

## Validação concluída

A execução posterior confirmou que o teste avançou pela row correta e validou a implementação real de columns. A produção permaneceu inalterada nessa correção.
