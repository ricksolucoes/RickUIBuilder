# Skill — Test and Build Validation

## Classificação de evidência

### Compilação real
Compilador Delphi/MSBuild compatível foi executado e retornou resultado observável.

### Teste real
O executável/pipeline de testes foi executado e produziu resultado observável.

### Method Toxicity real
RAD Studio ou CSV exportado correspondente ao estado avaliado foi fornecido/executado.

### Análise estática
Código foi inspecionado sem a execução acima.

Nunca misture essas categorias.

## Baseline atual conhecida

- DUnitX: 197/197 aprovados; 0 failed, 0 errored e 0 leaked.
- Method Toxicity fornecida:
  - biblioteca: 404 métodos, máximo 0,554;
  - testes: 252 métodos, máximo 0,571;
  - Sample: 35 métodos, máximo 0,338;
  - zero violações dos gates configurados.

A baseline serve para comparação. Após alteração de código, ela deixa de provar o novo estado até que as validações sejam executadas novamente.

## Relatório

Sempre informe:

```text
Build real: executado / não executado
Testes reais: resultado ou não executados
Method Toxicity real: resultado ou não executada
Análise estática: escopo avaliado
```
