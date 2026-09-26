# CHECKLIST MESTRE — execução comprovável

Regra: `[x]` somente quando a evidência está materializada neste pacote ou no snapshot do repositório analisado. `[ ]` significa que a condição ainda não pode ser comprovada.

## Fase 0 — Congelamento das fontes

- [x] Registrar o snapshot atual do RickUIBuilder como fonte de arquitetura.
  - Evidência: `03-governanca/02-fontes-e-evidencias.md`.
- [x] Não consultar documentos do Edit produzidos anteriormente.
  - Evidência: `03-governanca/02-fontes-e-evidencias.md`, “Fontes explicitamente não utilizadas”.
- [x] Não utilizar memória do modelo como evidência.
  - Evidência: nenhum Owner usa memória como fonte; fontes permitidas estão enumeradas.
- [x] Não aproveitar auditorias anteriores como requisitos.
  - Evidência: exclusão explícita em `03-governanca/02-fontes-e-evidencias.md`.
- [x] Usar governança do projeto somente para processo/arquitetura comprovada.
  - Evidência: `README.md` e `03-governanca/02-fontes-e-evidencias.md`.
- [x] Não corrigir silenciosamente regra funcional ausente.
  - Evidência: `02-edit/03-decisoes-nao-confirmadas.md`.
- [x] Informação ausente permanece `Não confirmado`.
  - Evidência: `README.md` e `02-edit/03-decisoes-nao-confirmadas.md`.

## Fase 1 — Inventário antes de documentação funcional

- [x] Ler a arquitetura central do snapshot.
  - Evidência: relação de arquivos em `03-governanca/02-fontes-e-evidencias.md`.
- [x] Identificar entry points públicos atuais.
  - Evidência: `01-framework/01-visao-geral.md` e `01-framework/02-superficie-publica.md`.
- [x] Identificar Factory, Builders e Composition separadamente.
  - Evidência: `01-framework/03-factory-builders-composition.md`.
- [x] Identificar contratos públicos separadamente da implementação.
  - Evidência: `01-framework/02-superficie-publica.md`.
- [x] Identificar defaults/configuração separadamente de comportamento.
  - Evidência: `01-framework/06-config-defaults.md`.
- [x] Identificar lifetime/Handle separadamente.
  - Evidência: `01-framework/04-build-handle-lifetime.md`.
- [x] Identificar package/integração separadamente.
  - Evidência: `01-framework/07-package-integracao.md`.
- [x] Detectar ausência de Edit no snapshot.
  - Evidência: `01-framework/01-visao-geral.md`.
- [x] Separar fatos confirmados de requisitos Edit não confirmados.
  - Evidência: `02-edit/02-contrato-funcional-confirmado.md` e `02-edit/03-decisoes-nao-confirmadas.md`.

## Fase 2 — Mapa de ownership documental

- [x] Cada assunto documentado possui Owner.
  - Evidência: `03-governanca/01-mapa-de-owners.md`.
- [x] Cada Owner possui um único documento.
  - Evidência: tabela de `03-governanca/01-mapa-de-owners.md`.
- [x] Regra de não redefinição está explícita.
  - Evidência: `README.md` e `03-governanca/01-mapa-de-owners.md`.
- [x] Lacunas funcionais abertas possuem Owner único; decisões fechadas possuem Owners normativos próprios.
  - Evidência: `EDIT-PENDING`, `EDIT-PUBLIC`, `EDIT-COMPOSITION`, `EDIT-INPUT` e `EDIT-VALIDATION`.
- [x] O índice não contém cópia integral das regras.
  - Evidência: `03-governanca/01-mapa-de-owners.md`.

## Fase 3 — Dependências

- [x] Dependências do Edit em relação ao framework foram identificadas.
  - Evidência: `02-edit/01-integracao-no-framework.md`.
- [x] Public API é tratada antes de decidir implementação interna.
  - Evidência: `FRM-PUBLIC` + `EDIT-INTEGRATION`.
- [x] Lifetime é tratado como fronteira própria.
  - Evidência: `FRM-LIFETIME`.
- [x] FMX/árvore visual é tratado como fronteira própria.
  - Evidência: `FRM-FMX`.
- [x] Config/defaults é tratado como fronteira própria.
  - Evidência: `FRM-CONFIG`.
- [x] Package/units é tratado como fronteira própria.
  - Evidência: `FRM-PACKAGE`.
- [ ] Grafo completo das dependências internas do Edit.
  - Evidência faltante: arquitetura interna do Edit depende de contrato funcional ainda `Não confirmado`.

## Fase 4 — Especialização por domínio

- [x] Contexto/repositório foi tratado como domínio próprio.
  - Evidência: `FRM-OVERVIEW`.
- [x] API pública foi tratada separadamente.
  - Evidência: `FRM-PUBLIC`.
- [x] FMX/lifetime foram tratados separadamente.
  - Evidência: `FRM-FMX` e `FRM-LIFETIME`.
- [x] Config/defaults foram tratados separadamente.
  - Evidência: `FRM-CONFIG`.
- [x] Integração do Edit foi tratada sem copiar arquitetura de outro componente.
  - Evidência: `EDIT-INTEGRATION`.
- [x] Cinco alternativas arquiteturais foram avaliadas antes de escolher o processo.
  - Evidência: `03-governanca/03-cinco-alternativas-por-decisao.md`.
- [ ] Especialização funcional de máscaras/validação/eventos do Edit.
  - Evidência faltante: requisitos funcionais específicos não confirmados.

## Fase 5 — Ciclo por arquivo

- [x] Documentos foram mantidos pequenos e direcionados por responsabilidade.
  - Evidência: estrutura de arquivos e mapa de Owners.
- [x] Cada documento separa fato confirmado de consequência/limitação.
  - Evidência: documentos `01-framework/*` e `02-edit/*`.
- [x] Nenhum documento implementa código Delphi.
  - Evidência: conteúdo do pacote; não há `.pas`.
- [x] Problema encontrado não foi “resolvido” por invenção.
  - Evidência: `EDIT-PENDING`.
- [ ] Revisão funcional final do Edit.
  - Evidência faltante: contrato funcional completo ainda não confirmado.

## Fase 6 — Regra de retorno

- [x] Lacunas impedem aprovação da fronteira correspondente.
  - Evidência: regra de `EDIT-PENDING`.
- [x] Lacunas foram devolvidas ao Owner de pendências, não espalhadas.
  - Evidência: `02-edit/03-decisoes-nao-confirmadas.md`.
- [x] Nenhum documento dependente declara como fato uma lacuna de `EDIT-PENDING`.
  - Evidência: Owners de framework e integração.
- [ ] Retorno/correção de decisões funcionais do Edit.
  - Evidência faltante: decisões passadas verificáveis ou nova confirmação do usuário.

## Fase 7 — Controle contra duplicação

- [x] Regra de Owner único documentada.
  - Evidência: `README.md`.
- [x] Mapa de Owners criado.
  - Evidência: `03-governanca/01-mapa-de-owners.md`.
- [x] Requisitos ainda não confirmados permanecem concentrados em `EDIT-PENDING`; regras resolvidas 001–003 foram migradas para Owners próprios.
  - Evidência: `EDIT-PENDING`, `EDIT-PUBLIC`, `EDIT-COMPOSITION`, `EDIT-INPUT` e `EDIT-VALIDATION`.
- [x] Exemplos não foram usados para criar requisito funcional do Edit.
  - Evidência: não existem exemplos funcionais inventados.
- [x] Defaults específicos do Edit não foram inventados.
  - Evidência: `EDIT-FUNCTION` e `EDIT-PENDING`.
- [x] Enums específicos do Edit não foram inventados.
  - Evidência: `EDIT-PENDING`.
- [x] Pipeline específico do Edit não foi inventado.
  - Evidência: `EDIT-PENDING`.

## Fase 8 — Documentos pequenos

- [x] Visão geral do framework isolada.
- [x] Superfície pública isolada.
- [x] Estratégias de criação isoladas.
- [x] Lifetime isolado.
- [x] FMX isolado.
- [x] Config/defaults isolados.
- [x] Package isolado.
- [x] Integração do Edit isolada.
- [x] Contrato funcional confirmado isolado.
- [x] Pendências abertas isoladas; superfície pública, composição visual, entrada/transformação e validação isoladas em Owners próprios.
  - Evidência para todos: estrutura do pacote e `03-governanca/01-mapa-de-owners.md`.

## Fase 9 — Testes

A instrução atual do usuário define que este conjunto é para **orientar implementação, não para documentar testes**.

- [x] Nenhum documento de testes do Edit foi criado.
  - Evidência: estrutura do pacote.
- [x] Regras funcionais não foram duplicadas em “casos de teste”.
  - Evidência: inexistência dessa camada documental.
- [x] A governança do repositório sobre testes não foi convertida em contrato funcional do Edit.
  - Evidência: Owners não contêm requisitos de teste do Edit.

## Fase 10 — Índice central

- [x] Índice de Owners contém Owner e documento.
  - Evidência: `03-governanca/01-mapa-de-owners.md`.
- [x] Índice não redefine as regras.
  - Evidência: conteúdo do índice.
- [x] Pendências abertas e decisões resolvidas possuem Owner identificável.
  - Evidência: `EDIT-PENDING`, `EDIT-PUBLIC`, `EDIT-COMPOSITION`, `EDIT-INPUT` e `EDIT-VALIDATION`.

## Fase 11 — Status

- [x] Fatos confirmados estão separados de `Não confirmado`, e decisões resolvidas 001–003 não permanecem no Owner de pendências.
  - Evidência: `EDIT-FUNCTION`, `EDIT-PUBLIC`, `EDIT-COMPOSITION`, `EDIT-INPUT`, `EDIT-VALIDATION` versus `EDIT-PENDING`.
- [x] Não existe “APROVADO” funcional falso para o Edit.
  - Evidência: este checklist mantém itens funcionais pendentes.
- [ ] Contrato funcional do Edit aprovado.
  - Evidência faltante: requisitos específicos não estão disponíveis nas fontes permitidas.

## Fase 12 — Auditoria de integração documental

- [x] Entry point atual do framework foi verificado.
- [x] Shared contracts foram verificados.
- [x] Factory foi verificada.
- [x] Builder patterns foram verificados.
- [x] Handle/lifetime foram verificados.
- [x] Package foi verificado.
- [x] Ausência atual do Edit foi verificada.
- [x] Cinco alternativas por decisão estrutural foram registradas.
- [ ] Dependências internas finais do Edit verificadas.
  - Evidência faltante: contrato funcional não fechado.
- [ ] Ausência de contradição funcional do Edit comprovada.
  - Evidência faltante: contrato funcional não fechado.

## Fase 13 — Dubiedade

- [x] Dubiedade não é preenchida por conhecimento genérico.
  - Evidência: `EDIT-PENDING`.
- [x] Dubiedade não é resolvida copiando ComboBox/Button.
  - Evidência: `EDIT-INTEGRATION`.
- [x] Opções plausíveis são avaliadas sem promovê-las automaticamente a requisito.
  - Evidência: `03-governanca/03-cinco-alternativas-por-decisao.md`.
- [ ] Histórico funcional anterior do Edit reconciliado.
  - Evidência faltante: histórico completo não está disponível como fonte verificável nesta execução e documentos antigos estão proibidos.

## Fase 14 — Encerramento

- [x] Nova documentação foi criada do zero.
  - Evidência: diretório `RickUIBuilder_Edit_Documentacao_Zero`.
- [x] Nenhum código do projeto foi modificado.
  - Evidência: artefato entregue contém apenas Markdown/JSON.
- [x] O framework foi analisado como projeto, não apenas como um componente.
  - Evidência: Owners `FRM-*`.
- [x] O papel desta etapa ficou limitado à documentação.
  - Evidência: `README.md`.
- [ ] Documentação funcional do Edit pronta para implementação sem decisões adicionais.
  - Evidência faltante: `EDIT-PENDING` contém lacunas materiais.
- [ ] Checklist integral concluído.
  - Condição: todos os itens anteriores precisam estar comprovados.

## Resultado comprovável

**Estado:** documentação arquitetural e de integração concluída; contrato funcional específico do Edit ainda não pode ser declarado completo sem violar a regra de não usar documentos antigos gerados nem memória como evidência.

Nenhum item pendente foi marcado como concluído.
