# Governança de Agents do RickUIBuilder.Samples

Esta pasta contém agentes locais do `samples/`. Eles não alteram a governança global do RickUIBuilder.

## Agentes

| Agente | Aplicabilidade | Responsabilidade |
|---|---|---|
| `samples-task-orchestrator` | toda tarefa relevante do Samples | define escopo, riscos, gates e evidências |
| `samples-architecture-auditor` | mudanças arquiteturais/fluxo/dependências | audita boundaries, responsabilidades, acoplamento e abstrações |
| `samples-delphi-code-auditor` | código Delphi criado/modificado | audita código, `uses`, dependências e compatibilidade observável |
| `samples-contract-lifetime-auditor` | interfaces/GUID/lifetime/ownership | audita contratos, imutabilidade, reference counting e ciclos |
| `samples-naming-auditor` | código Delphi criado/modificado | audita parâmetros, locais, fields e constantes |
| `samples-toxicity-auditor` | código Delphi criado/modificado | audita Length, Parameters, If Depth e Cyclomatic Complexity; distingue métrica real de estática |
| `samples-documentation-auditor` | documentação criada/modificada ou entrega documentada | compara documentação com implementação final |
| `samples-build-validation-auditor` | entrega Delphi | valida estrutura de build e executa compilação somente se ferramenta existir |
| `samples-final-quality-gate` | entrega relevante | avalia qualidade do resultado final |
| `samples-final-process-compliance-auditor` | último gate de entrega relevante | prova que o processo e gates obrigatórios foram cumpridos |

Não existe `Samples Test Auditor` nesta versão porque sua criação depende da existência de testes do Samples ou de requisito concreto de testes. A ausência do agente não autoriza ignorar testes existentes: se forem encontrados, o Orchestrator deve registrar a necessidade e bloquear até existir o gate adequado ou utilizar o Test Engineer normativo aplicável.

## Estados

- `PASS`: gate executado e sustentado por evidência.
- `FAIL`: gate executado e encontrou violação.
- `NOT_APPLICABLE`: domínio não pertence à tarefa, com evidência.
- `NOT_EXECUTED`: gate aplicável não executado.
- `BLOCKED`: dependência impede conclusão.

## Execution Manifest

O Orchestrator inicia um manifesto por tarefa. Ele pode ser mantido como artefato de execução e não precisa integrar o pacote de release.

```text
Gate:
Applicability:
Status:
Artifact/version audited:
Evidence:
Execution mode:
Invalidated by later change?:
```

O manifesto registra fatos e evidências, nunca cadeia de pensamento.

## Invalidação

Após qualquer alteração, determinar quais gates podem ter sido afetados. Um `PASS` sobre versão anterior não aprova automaticamente o estado novo. Os gates afetados devem ser repetidos sobre o artefato completo.

## Isolamento

Auditores especializados não devem receber conclusões de outros auditores nem justificativas persuasivas do implementador. Recebem requisitos, regras, artefatos e evidências primárias.

O auditor final de processo recebe o manifesto, mas não confia na seleção do Orchestrator: recalcula os gates obrigatórios a partir da solicitação e do artefato final.

## Regras obrigatórias para estrutura e UI do Samples

Os agentes aplicáveis devem tratar como critérios objetivos: units internas explicitamente incluídas no `.dpr` e `.dproj`; ausência do próprio `samples/src` no Search Path; organização física por responsabilidade (`App`, `Home`, `Components/Common` e diretórios concretos por componente quando houver unit real); header da Home alinhado ao client sem margem externa; e cards dimensionados para o conteúdo sem reduzir a tipografia aprovada.

Para Component Pages, `RickUIBuilder.Samples.Component.Common` (`TComponentCommon`) deve permanecer base comum de layout/comportamento, com tokens visuais locais em `RickUIBuilder.Samples.Component.Common.Style`, sem conteúdo centralizado dos seis componentes e sem dependência de `Home.Style`. Cada componente navegável possui page concreta derivada. A página é intermediária: Factory/Fluent são divisões de navegação e somente destinos realmente implementados podem ser clicáveis. Atualmente `Text / Label → Factory` e `Text / Label → Fluent Builder` são destinos concretos. O formulário deve ser borderless, o retorno deve fechar a modal e nenhum texto/card/painel pode sofrer clipping.

## Cabeçalho estrutural das units Delphi

Sempre que uma unit `.pas` do Samples for criada ou modificada, o Orchestrator deve exigir auditoria do cabeçalho documental superior. O Delphi Code Auditor valida a coerência técnica com o código e as dependências; o Documentation Auditor valida finalidade, funcionalidade, responsabilidades, fluxo, ownership/lifetime quando aplicável e restrições. O Final Quality Gate exige essas evidências, e o Final Process Compliance Auditor recalcula esses gates como obrigatórios. O cabeçalho é orientação para humanos e IA, mas não substitui a inspeção do código final.

## Gates obrigatórios para Delphi

Sempre que `.pas` for criado ou modificado, o Orchestrator exige `samples-naming-auditor`. Se a alteração puder afetar corpo de método, exige também `samples-toxicity-auditor`. Quando houver interface, GUID, reference counting, ownership ou lifetime no escopo ou afetados pela mudança, exige `samples-contract-lifetime-auditor`. Esses gates especializados não são substituídos pelo Delphi Code Auditor.

O catálogo desta página deve corresponder aos arquivos físicos em `.agents/agents/`. Agente declarado e ausente, ou arquivo de agente obrigatório não catalogado, reprova a conformidade do processo.

## Higiene de artefatos de entrega

`__history/`, `__recovery/`, `.identcache` e `.dproj.local` são artefatos locais/temporários da IDE para fins desta governança: não servem como evidência arquitetural ou documental e não devem integrar o pacote de entrega sem necessidade explícita e comprovada. Recursos necessários ao build, como `.res`, devem ser avaliados pelo Build Validation Auditor e não removidos mecanicamente.

## Regras obrigatórias para Sample Page Base

`RickUIBuilder.Samples.Example.Common` (`TExampleCommon`) coordena a base visual da terceira camada de navegação do Samples. A estrutura física comum fica em `src/Examples/Common` e separa header, navegação, seletor Código/Resultado, painel de código e painel de resultado em units próprias, além de `.Style` e `.Icons`; não concentrar novamente essas responsabilidades em `TExampleCommon`. Diretórios concretos de exemplos não devem ser criados antes de existirem páginas reais. A base deve permanecer menor que a Home, borderless, sem conhecimento de componentes/abordagens e sem catálogo global de exemplos. `Código Delphi` / `Resultado` possui semântica confirmada de views mutuamente exclusivas, coordenada por `.View.Selector` e `TExampleCommon`, com `Código Delphi` como estado inicial. `Text / Label - Factory` e `Text / Label - Fluent Builder` são derivadas reais e separam page, conteúdo/snippets e Runner; futuras derivadas devem manter responsabilidades equivalentes separadas quando aplicável.


## Dependências FMX explícitas

Toda unit Delphi do Samples que utilize `TTextAlign` deve declarar `FMX.Types` explicitamente no `uses`. Toda unit que utilize `TBrushKind` deve declarar `FMX.Graphics` explicitamente. O Delphi Code Auditor deve reprovar dependência transitiva desses símbolos.

## Cobertura exaustiva dos exemplos `Completo`

Quando uma página concreta possuir item `Completo`, os auditores devem compará-lo diretamente com a API pública vigente da abordagem. Factory deve explicitar todos os campos públicos do record de configuração utilizado; Fluent Builder deve chamar todos os métodos públicos configuráveis da interface. Records auxiliares usados pelo exemplo também devem ter todas as opções/campos relevantes explícitos; para `TRickUIBuilderSpacing`, Left, Top, Right e Bottom devem ser informados.
