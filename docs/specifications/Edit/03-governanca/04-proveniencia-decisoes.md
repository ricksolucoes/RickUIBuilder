# Proveniência das decisões recuperadas

Este documento registra somente origem, classificação, Owner e status. Não redefine regras normativas.

## PEND-EDIT-005

| ID | Assunto | Origem histórica autorizada | Compatibilidade verificada | Owner | Status |
|---|---|---|---|---|---|
| EVT-001 | eventos públicos | histórico `Eventos` | superfície pública reconstruída | `EDIT-EVENTS` | `APROVADO` |
| EVT-002 | pipeline de `OnChange` | histórico `OnChange` | `EDIT-INPUT` + `EDIT-VALIDATION` | `EDIT-EVENTS` | `APROVADO` |
| EVT-003 | sessão/snapshot | histórico `OnEnter` | composição + limite de runtime | `EDIT-EVENTS` | `APROVADO` |
| EVT-004 | saída da sessão | histórico `OnExit` | `EDIT-VALIDATION` | `EDIT-EVENTS` | `APROVADO` |
| EVT-005 | alteração programática | histórico Handle/eventos | regra de não validação automática | `EDIT-EVENTS` | `APROVADO` |
| EVT-006 | reentrada | histórico `Recursão` | sem nova API pública | `EDIT-EVENTS` | `APROVADO` |
| EVT-007 | evento + validação | histórico eventos/validator | referência a `EDIT-VALIDATION` | `EDIT-EVENTS` | `APROVADO` |
| EVT-008 | handler FMX x callback | histórico eventos/recursão | detalhe FMX encapsulado | `EDIT-EVENTS` | `APROVADO` |

Os documentos históricos foram usados porque o usuário autorizou explicitamente seu uso como material de recuperação. Eles não se tornam Owners normativos. Após a migração, o contrato deve ser consultado em `EDIT-EVENTS`.


## PEND-EDIT-006

| ID | Assunto | Origem histórica autorizada | Compatibilidade | Owner | Status |
|---|---|---|---|---|---|
| RUN-001 | contrato Handle | histórico `Contrato público definitivo do Handle` | `EDIT-PUBLIC` | `EDIT-RUNTIME` | `APROVADO` |
| RUN-002 | attached/BuildHandle | histórico `BuildHandle`/attached | builders | `EDIT-RUNTIME` | `APROVADO` |
| RUN-003 | leitura | histórico attached/detached | `EDIT-INPUT` | `EDIT-RUNTIME` | `APROVADO` |
| RUN-004 | SetText | histórico attached + eventos | `EDIT-INPUT/VALIDATION/EVENTS` | `EDIT-RUNTIME` | `APROVADO` |
| RUN-005 | invalid/error | histórico Handle | `EDIT-VALIDATION` | `EDIT-RUNTIME` | `APROVADO` |
| RUN-006 | enabled/read-only | histórico Handle | sem rebuild | `EDIT-RUNTIME` | `APROVADO` |
| RUN-007 | foco | histórico Handle | `EDIT-EVENTS` | `EDIT-RUNTIME` | `APROVADO` |
| RUN-008 | detach | histórico lifetime | refs non-owning | `EDIT-RUNTIME` | `APROVADO` |
| RUN-009 | detached | histórico detached | no-op seguro | `EDIT-RUNTIME` | `APROVADO` |
| RUN-010 | ownership | histórico lifetime | `EDIT-COMPOSITION` | `EDIT-RUNTIME` | `APROVADO` |
| RUN-011 | Build sem Handle externo | histórico lifetime | sem retenção obrigatória | `EDIT-RUNTIME` | `APROVADO` |
| RUN-012 | destruição/ciclos | histórico destruição | implementação livre | `EDIT-RUNTIME` | `APROVADO` |
| RUN-013 | limites | histórico + não invenção | sem garantias extras | `EDIT-RUNTIME` | `APROVADO` |


## PEND-EDIT-007

| ID | Assunto | Origem histórica autorizada | Compatibilidade | Owner | Status |
|---|---|---|---|---|---|
| DEF-001 | snapshot default | histórico configuração/default | `EDIT-PUBLIC` | `EDIT-DEFAULTS` | `APROVADO` |
| DEF-002 | geometria | histórico defaults funcionais | composição | `EDIT-DEFAULTS` | `APROVADO` |
| DEF-003 | tipografia | histórico defaults visuais | FMX | `EDIT-DEFAULTS` | `APROVADO` |
| DEF-004 | input | histórico defaults funcionais | `EDIT-INPUT` | `EDIT-DEFAULTS` | `APROVADO` |
| DEF-005 | comportamento | histórico defaults funcionais | validation/events | `EDIT-DEFAULTS` | `APROVADO` |
| DEF-006 | conteúdo | histórico defaults funcionais | validation/composition | `EDIT-DEFAULTS` | `APROVADO` |
| DEF-007 | ícones/cores | histórico defaults visuais | configuração pública | `EDIT-DEFAULTS` | `APROVADO` |
| DEF-008 | assets | histórico ações/ícones | paths substituíveis | `EDIT-DEFAULTS` | `APROVADO` |
| DEF-009 | estados visuais | histórico paleta default | VisualStates | `EDIT-DEFAULTS` | `APROVADO` |
| DEF-010 | precedência visual | histórico estados/transições | sem alterar semântica | `EDIT-DEFAULTS` | `APROVADO` |
| DEF-011 | config por record | histórico configuração | `EDIT-PUBLIC` | `EDIT-DEFAULTS` | `APROVADO` |
