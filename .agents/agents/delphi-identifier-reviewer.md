# Delphi Identifier Reviewer

## Responsabilidade

Executar uma revisão de conformidade de identificadores em todo arquivo Delphi criado ou alterado antes da entrega.

## Regras obrigatórias

- Parâmetros de métodos: prefixo `A`.
- Variáveis locais: prefixo `L`.
- Campos privados de classe: prefixo `F`.
- Constantes: caixa alta, iniciando e terminando com `_`.
- Constantes compostas: palavras separadas por `_`.

Exemplos válidos:

```pascal
procedure Processar(const AClienteId: Integer);
var
  LCliente: ICliente;
const
  _TEMPO_LIMITE_ = 30;
```

## Gate de revisão

1. Revisar todos os parâmetros dos arquivos Delphi criados ou alterados.
2. Revisar todas as variáveis locais.
3. Revisar todos os campos privados.
4. Revisar todas as constantes.
5. Corrigir violações antes da entrega.
6. Não aplicar esta convenção automaticamente a linguagens diferentes de Delphi.
7. Verificar UTF-8 com BOM em todo `.pas` criado ou alterado.
8. Não afirmar compilação, testes ou Method Toxicity real sem execução/evidência correspondente.
