# Definition of Done — RickUIBuilder

A Definition of Done (DoD) é a barra permanente de qualidade para qualquer alteração. Acceptance Criteria variam por tarefa; a DoD permanece estável.

Uma tarefa está concluída somente quando **os critérios específicos** e **os gates permanentes aplicáveis** foram satisfeitos ou uma limitação foi declarada explicitamente.

## 1. Requirement e scope

- [ ] O requisito explícito da tarefa foi atendido.
- [ ] Nenhuma permissão de tarefa anterior foi reutilizada implicitamente.
- [ ] Alterações autorizadas e proibidas foram respeitadas.
- [ ] O diff não contém cleanup/refactor/rename fora do objetivo.
- [ ] Requisitos não confirmados não foram inventados.

## 2. Correctness

- [ ] O comportamento implementado corresponde ao contrato solicitado.
- [ ] Comportamento existente a preservar continua representado por código/testes/evidência.
- [ ] Edge cases relevantes foram considerados.
- [ ] Error paths relevantes foram considerados.
- [ ] Não há fallback silencioso que esconda erro de programação sem requisito.

## 3. Architecture

- [ ] Responsabilidades permanecem coesas.
- [ ] Dependências novas são justificadas.
- [ ] Não há abstração criada apenas por simetria ou estética.
- [ ] Um componente simples não recebeu camadas de componente complexo sem necessidade.
- [ ] Se uma decisão arquitetural duradoura foi introduzida, ADR/docs foram avaliados.

## 4. Delphi/Object Pascal

- [ ] Sintaxe/recursos são compatíveis com o projeto ou a versão foi confirmada.
- [ ] `uses` está correto e no bloco apropriado.
- [ ] Scoped Enums estão qualificados.
- [ ] GUIDs públicos foram preservados salvo mudança explícita.
- [ ] Interfaces/reference counting foram revisados quando aplicável.
- [ ] Exceptions observáveis foram preservadas ou documentadas quando alteradas.
- [ ] Todo `.pas` efetivamente modificado está UTF-8 com BOM (`EF BB BF`).

## 5. Lifetime e FMX

- [ ] `Owner` e `Parent` foram identificados quando aplicável.
- [ ] A ordem possível de destruição foi considerada.
- [ ] Referências non-owning são invalidadas/observadas adequadamente.
- [ ] `FreeNotification` foi usado somente quando necessário e corretamente.
- [ ] Eventos/callbacks não criam retenção ou dangling reference não intencional.
- [ ] `HitTest`, focus, visibility e parentagem preservam o contrato de interação.
- [ ] Desktop/mobile foram considerados quando o comportamento depende da plataforma.

## 6. Public API

- [ ] Mudanças públicas foram identificadas como aditivas, compatíveis ou breaking.
- [ ] Overloads/defaults não criam ambiguidade não intencional.
- [ ] Builders preservam chaining quando aplicável.
- [ ] Handles preservam lifecycle e ownership documentados.
- [ ] Facade/Types/Interfaces foram atualizados somente quando necessário.
- [ ] Consumidores, Sample e docs foram revisados quando a API mudou.

## 7. Tests

- [ ] Testes relacionados foram identificados.
- [ ] Bugfix possui Prove-It/regressão quando tecnicamente aplicável.
- [ ] Novo comportamento possui proteção no nível apropriado.
- [ ] Refatoração de legado sem cobertura foi caracterizada antes da mudança quando necessário.
- [ ] Testes não foram enfraquecidos apenas para obter verde.
- [ ] Resultado real é reportado somente se executado.
- [ ] Se somente teste focado foi executado, isso está claro.
- [ ] Baseline histórica não foi apresentada como resultado da revisão atual.

## 8. Build/runtime

- [ ] Build real foi executado quando ambiente disponível/requerido.
- [ ] Se build não foi executado, a limitação está declarada.
- [ ] Verificação runtime/manual foi realizada quando o contrato visual não pode ser provado apenas por estrutura/teste.
- [ ] Ausência de leak só foi afirmada quando a execução correspondente forneceu essa evidência.

## 9. Method Toxicity

- [ ] Métodos Delphi novos/alterados foram avaliados estaticamente.
- [ ] `Length`, `Parameters`, `If Depth` e `Cyclomatic Complexity` não foram agravados injustificadamente.
- [ ] Código novo respeita gates ou possui exceção autorizada e justificada.
- [ ] `Toxicity` composta só é chamada de métrica real quando existe RAD Studio/CSV da revisão.
- [ ] Nenhuma fórmula de Toxicity foi inventada.
- [ ] Nenhuma abstração cosmética foi criada apenas para manipular métricas.

## 10. Documentation

- [ ] Documentação afetada foi identificada.
- [ ] Docs correspondem ao código final.
- [ ] Nenhuma intenção futura está descrita como comportamento existente.
- [ ] README permanece visão geral; detalhes profundos permanecem no domínio.
- [ ] Exemplos usam API existente.
- [ ] Pares EN/PT-BR permanecem equivalentes quando existirem.
- [ ] Links relativos foram validados quando arquivos foram movidos/criados.

## 11. Review

- [ ] Mudanças de risco relevante receberam review independente.
- [ ] Findings Critical/Required foram resolvidos ou explicitamente aceitos pelo usuário quando apropriado.
- [ ] A revisão considerou correctness, arquitetura, lifetime, API, testes, toxicity, docs e escopo.
- [ ] O review verificou a verificação: não aceitou afirmações sem evidência.

## 12. Repository hygiene

- [ ] Nenhum arquivo temporário/debug foi deixado no diff.
- [ ] Não existem referências quebradas para estrutura obsoleta.
- [ ] Arquivos removidos não continuam documentados como presentes.
- [ ] Não há duas fontes normativas concorrentes para a mesma regra.

## 13. Delivery

- [ ] Lista de arquivos efetivamente modificados/criados está correta.
- [ ] Arquivos removidos estão listados separadamente.
- [ ] Pacote incremental contém somente arquivos modificados/criados.
- [ ] Validações executadas estão separadas de validações não executadas.
- [ ] Limitações e riscos restantes estão explícitos.

## Regra final

`Done` não significa “o código parece bom”. Significa que o requisito foi atendido e cada gate aplicável possui evidência suficiente ou limitação explicitamente declarada.
