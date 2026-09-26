# Method Toxicity — Baseline Conhecida

Esta referência registra resultados **reais** previamente fornecidos via CSV do RAD Studio para uma revisão do projeto. É baseline histórica, não aprovação automática de commits futuros.

## Gates permanentes

- `Length <= 20`
- `Parameters <= 6`
- `If Depth <= 5`
- `Cyclomatic Complexity <= 6`
- `Toxicity < 1`

## Resultados reais da revisão medida

| Projeto | Métodos medidos | Max Length | Max Parameters | Max If Depth | Max Cyclomatic | Max Toxicity |
|---|---:|---:|---:|---:|---:|---:|
| Library/BPL | 404 | 20 | 5 | 3 | 4 | 0.554 |
| Tests | 252 | 14 | 2 | 2 | 6 | 0.571 |
| Sample | 35 | 14 | 4 | 1 | 2 | 0.338 |

Os três relatórios estavam dentro dos gates no momento da medição.

## Proveniência

Relatórios fornecidos pelo usuário:

- `BUilfrBPL.csv` — library/package;
- `BuiderTeste.csv` — tests;
- `Samples.csv` — Sample.

Não inclua esses CSVs em entregas futuras salvo solicitação explícita.

## Como usar esta baseline

### Mudança sem novo CSV

Você pode dizer:

> Avaliação estática realizada; baseline real anterior registrada neste arquivo. Method Toxicity composta da revisão atual não foi medida.

Não pode dizer:

> Toxicity continua aprovada.

### Mudança com novo CSV

Compare:

- métodos alterados;
- máximos por projeto;
- qualquer regressão de método individual;
- gates permanentes.

Atualize esta referência somente quando o usuário desejar que o novo resultado se torne baseline do projeto.

## Regra para regressão

Mesmo abaixo dos gates, não aumente métricas sem necessidade. O objetivo é não introduzir nem agravar toxicidade, não apenas permanecer abaixo de `1`.
