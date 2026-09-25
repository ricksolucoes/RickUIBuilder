# AGENTS.md — Regras de Engenharia e Manutenção

Este arquivo é o ponto de entrada para qualquer agente de IA, assistente de código ou mantenedor automatizado que analise este repositório.

## 1. Regra de início

Antes de editar qualquer arquivo:

1. leia a solicitação atual e classifique-a como análise, correção, implementação, refatoração, documentação, testes ou release;
2. identifique o domínio afetado e os arquivos que realmente precisam ser lidos;
3. consulte a documentação de domínio existente antes de inferir comportamento pelo nome das classes;
4. leia os testes relacionados quando eles existirem;
5. defina explicitamente o comportamento que precisa ser preservado;
6. selecione somente os agents, skills, templates e checklists necessários em `.ai/`.

Analisar não autoriza modificar. Documentar não autoriza refatorar. Corrigir um bug não autoriza redesenhar o módulo.

## 2. Fontes de verdade

Use esta prioridade:

1. requisito explícito da tarefa atual;
2. código-fonte final do repositório;
3. interfaces e types públicos;
4. testes existentes e resultados reais fornecidos;
5. documentação técnica específica do domínio;
6. Sample quando ele demonstra a API pública;
7. regras de engenharia deste arquivo e de `.ai/`.

Não invente APIs, requisitos, dependências, resultados de build, resultados de testes ou métricas.

Em diagnóstico iterativo, mantenha uma lista de **tentativas já realizadas**, seus resultados e evidências. Antes de propor nova correção, consulte essa lista e não repita uma solução já descartada sem evidência nova que justifique revisitá-la.

## 3. Roteamento obrigatório

| Tarefa | Ler antes de agir |
|---|---|
| Qualquer alteração | `.ai/skills/repository-analysis.md` e `.ai/checklists/pre-change.md` |
| Alterar `.pas` | `.ai/agents/delphi-engineer.md` e `.ai/skills/delphi-change-safety.md` |
| Alterar ComboBox | `.ai/skills/combobox-maintenance.md` e `docs/combobox/README.pt-BR.md` |
| Criar/alterar documentação | `.ai/agents/technical-writer.md`, `.ai/skills/documentation-consistency.md` e `.ai/checklists/documentation-gate.md` |
| Validar testes/build | `.ai/skills/test-validation.md` |
| Auditar mudança relevante | `.ai/agents/quality-auditor.md` |
| Entrega | `.ai/checklists/final-quality-gate.md` |

O agente coordenador é `.ai/agents/delphi-orchestrator.md`.

## 4. Código Delphi

Para todo `.pas` efetivamente modificado:

- salvar em UTF-8 com BOM (`EF BB BF`);
- preservar compatibilidade com a versão Delphi adotada pelo projeto;
- manter `uses` corretos;
- respeitar ownership, lifetime, `FreeNotification`, interfaces, GUIDs e reference counting;
- usar Scoped Enums como `Tipo.Membro`;
- aplicar alteração mínima necessária;
- não introduzir nem agravar Method Toxicity.

Gates de Method Toxicity do projeto:

- `Length <= 20`;
- `Parameters <= 6`;
- `If Depth <= 5`;
- `Cyclomatic Complexity <= 6`;
- `Toxicity < 1`.

`Toxicity` só pode ser reportada como valor real quando vier do RAD Studio/CSV correspondente ao código avaliado.

## 5. Documentação

A documentação deve descrever somente comportamento implementado.

- `README.md` e `README.pt-BR.md` apresentam visão geral do framework.
- documentação técnica aprofundada de um recurso deve ficar em `docs/<recurso>/`;
- para ComboBox, a fonte documental especializada é `docs/combobox/`;
- ao alterar comportamento, API, dependências, lifecycle ou configuração, verifique a documentação afetada na mesma tarefa;
- mantenha documentos EN e pt-BR semanticamente equivalentes quando existirem em pares.

Não espalhe documentação detalhada do ComboBox fora de `docs/combobox/`; no README principal mantenha apenas visão geral e links.

## 6. Testes, build e métricas

Diferencie sempre:

- compilação real;
- execução real de testes;
- Method Toxicity real;
- análise estática.

Nunca afirme que compilou, que todos os testes passaram, que não existem leaks ou que Toxicity foi aprovada sem evidência real.

Baseline conhecida desta revisão:

- DUnitX: 197 encontrados, 197 aprovados, 0 failures, 0 errors e 0 leaks;
- Method Toxicity: relatórios atuais dos três projetos sem violações dos gates. Consulte os READMEs para os máximos medidos.

Essa baseline não autoriza assumir que uma alteração futura continua verde sem nova execução.

## 7. Entrega

- execute ou solicite as validações aplicáveis;
- faça uma revisão separada quando houver risco relevante;
- compare o estado final com a baseline da tarefa;
- entregue somente arquivos efetivamente criados ou modificados;
- não inclua arquivos apenas consultados, temporários ou artefatos intermediários.
