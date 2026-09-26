# Restrições Permanentes do RickUIBuilder

Este arquivo concentra restrições que valem para toda tarefa. Skills específicas podem adicionar passos, mas não podem enfraquecer estas regras.

## 1. Prioridade de decisão

Quando houver conflito, aplique a seguinte ordem:

1. requisito explícito da tarefa atual;
2. regra de negócio e comportamento existente comprovado;
3. integridade de dados e lifetime;
4. compatibilidade e API pública;
5. segurança;
6. testes e evidência runtime;
7. arquitetura;
8. legibilidade;
9. elegância.

Uma solução arquiteturalmente “melhor” não justifica quebrar comportamento ou contrato.

## 2. Não invenção

Nunca invente:

- requisitos;
- APIs;
- bibliotecas;
- unidades;
- campos/records;
- parâmetros;
- comportamento;
- dependências;
- versão de Delphi;
- resultado de build;
- resultado de teste;
- ausência de memory leak;
- thread safety;
- Method Toxicity;
- suporte de plataforma.

Quando não for possível confirmar um ponto material, declare **`Não confirmado.`**

## 3. Escopo

A autorização é da tarefa atual, não da sessão.

- analisar não autoriza modificar;
- documentar não autoriza refatorar;
- corrigir bug não autoriza redesign;
- adicionar uma feature não autoriza limpar código adjacente;
- reorganizar units não autoriza alterar algoritmo;
- refatorar não autoriza mudar API pública;
- modernizar não autoriza quebrar compatibilidade.

A política padrão é alteração mínima necessária.

## 4. Brownfield

O projeto possui comportamento e contratos existentes. Antes de mudar:

1. determine o que já existe;
2. encontre consumidores/testes;
3. caracterize comportamento importante;
4. identifique invariantes;
5. só então implemente.

Não trate comportamento estranho como defeito apenas por parecer incomum. Aplique Chesterton's Fence: entenda por que existe antes de removê-lo.

## 5. Delphi/Object Pascal

- preserve recursos já compatíveis com o repositório quando a versão exata não estiver confirmada;
- use Scoped Enums como `Tipo.Membro`;
- mantenha dependências em `uses` corretas e no bloco apropriado;
- preserve GUIDs públicos salvo mudança contratual explícita;
- analise reference counting quando interfaces são armazenadas/retornadas;
- analise callbacks e anonymous methods por captura de referências;
- trate exceptions como parte do contrato quando observáveis;
- não crie classes/interfaces/records apenas para satisfazer métricas.

## 6. FireMonkey

Em qualquer alteração visual:

- diferencie `Owner` de `Parent`;
- saiba quem destrói cada objeto;
- trate referências non-owning como potencialmente inválidas;
- use `FreeNotification` quando a relação de lifetime exigir;
- preserve visual tree e `HitTest` intencional;
- não suponha que comportamento desktop equivale a mobile;
- não suponha que uma árvore visual no Sample é a única forma válida de host.

## 7. Encoding

Todo `.pas` efetivamente modificado deve ser salvo em UTF-8 com BOM (`EF BB BF`).

Não converter em massa arquivos `.pas` que não foram modificados pela tarefa.

Arquivos Markdown devem permanecer UTF-8 válido.

## 8. API pública

Mudanças em facade, interfaces, records, enums, fluent builders e handles exigem análise de compatibilidade.

Perguntas obrigatórias:

- consumidor existente compila?
- semântica antiga foi preservada?
- overload novo cria ambiguidade?
- default mudou?
- ordem/meaning de parâmetro mudou?
- GUID mudou?
- documentação/Sample/testes precisam acompanhar?

## 9. Method Toxicity

Gates do projeto:

- `Length <= 20`;
- `Parameters <= 6`;
- `If Depth <= 5`;
- `Cyclomatic Complexity <= 6`;
- `Toxicity < 1` quando medido pelo RAD Studio.

Regras:

- não introduzir nova toxicidade;
- não agravar toxicidade existente;
- não calcular manualmente o valor composto;
- não afirmar aprovação da ferramenta sem relatório correspondente;
- diferenciar métrica real de avaliação estática.

## 10. Testes

- testes existentes são contratos úteis, mas não prova de cobertura completa;
- bugfix deve ganhar regressão quando tecnicamente justificável;
- refatoração de comportamento não caracterizado deve ganhar characterization test antes da mudança;
- Sample não substitui teste;
- não enfraqueça assertion para obter verde;
- não altere expectativa para acomodar bug sem requisito que mude o contrato.

## 11. Build

Nunca transforme ausência de compilador em “compilado por inspeção”.

Use termos precisos:

- `build executado com sucesso` — somente com build real;
- `análise estática sem build` — quando aplicável;
- `build não executado` — quando ambiente não permite.

## 12. Documentação

Documente somente comportamento implementado no estado final.

README é visão geral. Documentação de domínio deve conter detalhes de arquitetura/maintenance quando a complexidade justificar.

Pares EN/PT-BR devem permanecer semanticamente equivalentes quando existirem.

## 13. Auditoria independente

Exija revisão separada da implementação em mudanças de risco relevante, especialmente:

- API pública;
- lifetime/ownership;
- reference counting;
- refatoração estrutural;
- migração;
- mudança de contratos;
- Method Toxicity;
- reorganização extensa;
- release.

## 14. Entrega

Entregar somente arquivos efetivamente modificados/criados. Arquivos removidos devem ser listados explicitamente. Não incluir temporários, fontes consultadas, resultados intermediários ou artefatos não solicitados.
