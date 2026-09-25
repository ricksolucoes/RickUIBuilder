# Governança de IA do RickUIBuilder

Esta pasta organiza instruções reutilizáveis para agentes de IA e manutenção assistida. O bootstrap fica em `../AGENTS.md`.

## Estrutura

```text
.ai/
├── README.md
├── agents/
├── skills/
├── templates/
└── checklists/
```

- `agents/`: papéis e responsabilidades.
- `skills/`: procedimentos por tipo de trabalho.
- `templates/`: estruturas para artefatos de engenharia.
- `checklists/`: gates objetivos antes, durante e depois de mudanças.

## Fluxo esperado

```text
Tarefa
  ↓
AGENTS.md
  ↓
delphi-orchestrator
  ↓
repository-analysis
  ↓
skill de domínio
  ↓
código + testes + documentação pertinente
  ↓
quality-auditor
  ↓
final-quality-gate
```

Nem todo agente precisa ser usado em toda tarefa. Se a tarefa for somente documental, não acione regras de implementação Delphi além das necessárias para compreender o código. Se for somente análise, não edite arquivos.

## Compatibilidade com ferramentas

`AGENTS.md` é o ponto de entrada explícito do repositório. Ferramentas que não carregam `.ai/` automaticamente devem seguir os links indicados por `AGENTS.md`. Os arquivos desta pasta são instruções versionadas; não são código executável nem substituem testes, compilação ou ferramentas do RAD Studio.
