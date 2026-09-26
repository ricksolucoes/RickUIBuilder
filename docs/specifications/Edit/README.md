# RickUIBuilder — documentação de preparação do recurso Edit

## Finalidade

Este conjunto foi reconstruído do zero para orientar uma futura IA implementadora do recurso **Edit** dentro do RickUIBuilder.

O escopo deste conjunto é **documentar fatos, contratos do framework, dependências e decisões necessárias à implementação**. Nenhum código Delphi do recurso Edit é implementado aqui.

## Fontes permitidas nesta reconstrução

1. código-fonte do `RickUIBuilder-0.2.2.zip`;
2. governança existente no próprio repositório (`AGENTS.md` e `.agents/`);
3. instruções explícitas atuais do usuário.

Documentos anteriormente gerados para o Edit e análises anteriores não foram usados como fonte.

## Regra de autoridade documental

Cada fato ou decisão normativa deve possuir um único documento proprietário (**Owner documental**). Outros documentos somente referenciam o Owner.

Se uma informação necessária ao Edit não puder ser comprovada nas fontes permitidas, ela deve aparecer como **Não confirmado**. A futura IA implementadora não está autorizada a preencher a lacuna por conveniência.

## Ordem de leitura para a futura IA implementadora

1. `01-framework/01-visao-geral.md`
2. `01-framework/02-superficie-publica.md`
3. `01-framework/03-factory-builders-composition.md`
4. `01-framework/04-build-handle-lifetime.md`
5. `01-framework/05-fmx-e-arvore-visual.md`
6. `02-edit/01-integracao-no-framework.md`
7. `02-edit/02-contrato-funcional-confirmado.md`
8. `02-edit/03-decisoes-nao-confirmadas.md`
9. `02-edit/04-superficie-publica.md`
10. `02-edit/05-composicao-visual.md`
11. `02-edit/06-entrada-transformacao.md`
12. `02-edit/07-validacao.md`
13. `02-edit/08-eventos.md`
14. `02-edit/09-runtime-handle-lifetime.md`
15. `02-edit/10-defaults.md`
16. `03-governanca/01-mapa-de-owners.md`
10. `CHECKLIST_MESTRE.md`

## Regra para implementação futura

A implementação só deve transformar em código o que estiver confirmado no Owner correspondente. Itens `Não confirmado` não são autorização para inventar API, defaults, eventos, máscaras, estados, lifetime ou comportamento.
