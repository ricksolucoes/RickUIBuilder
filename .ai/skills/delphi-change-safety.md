# Skill — Delphi Change Safety

## Encoding

Todo `.pas` efetivamente modificado deve ser salvo em UTF-8 com BOM (`EF BB BF`). Não converta em massa units não alteradas.

## Contratos Delphi

Verifique conforme aplicável:

- versão do Delphi e compatibilidade de linguagem;
- cláusulas `uses`;
- Scoped Enums (`Tipo.Membro`);
- interfaces e GUIDs;
- reference counting;
- `Owner` e `Parent`;
- `FreeNotification` e destruição;
- referências non-owning;
- exceptions;
- API pública.

## Method Toxicity

Gates:

| Métrica | Limite |
|---|---:|
| Length | 20 |
| Parameters | 6 |
| If Depth | 5 |
| Cyclomatic Complexity | 6 |
| Toxicity | < 1 |

Para código alterado: não introduza nova toxicidade nem agrave toxicidade existente. Não crie micro-métodos ou abstrações artificiais apenas para reduzir números.

`Toxicity` composta é valor do RAD Studio. Sem RAD Studio/CSV correspondente, reporte apenas avaliação estática das demais métricas e declare `Toxicity real: Não confirmado.`

## Gate final do arquivo

- diff mínimo;
- BOM confirmado;
- sintaxe/dependências revisadas;
- testes pertinentes identificados;
- documentação afetada verificada.
