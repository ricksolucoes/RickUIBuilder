---
name: release-and-delivery
description: Executa o gate final e prepara entregas do RickUIBuilder com evidência rastreável. Use ao concluir qualquer mudança que gere arquivos para o usuário, especialmente releases, pacotes incrementais ou tarefas que alteram código, testes, documentação ou governança.
---

# Release and Delivery

## Overview

Entrega é a última oportunidade de impedir scope pollution, claims falsas e artefatos incompletos. Esta skill não substitui testes/review; ela verifica que as evidências e arquivos corretos chegam ao usuário.

## When to Use

- antes de enviar ZIP/arquivos;
- final de feature/bugfix/refatoração;
- mudança documental relevante;
- release;
- migração estrutural com arquivos removidos.

## Inputs

- acceptance criteria;
- diff final;
- Definition of Done;
- resultados reais de testes/build/toxicity;
- lista de arquivos criados/modificados/removidos;
- riscos/limitações.

## Process

### Step 1 — Freeze scope

Pare de adicionar melhorias. A partir daqui, só corrija findings necessários ao gate.

### Step 2 — Review final diff

Classifique cada path:

- necessário;
- temporário;
- consultado apenas;
- gerado acidentalmente;
- removido.

Qualquer path sem relação clara com a tarefa sai da entrega ou volta para investigação.

### Step 3 — Apply Definition of Done

Use `../../references/definition-of-done.md`.

Não marque check por inferência. Se não foi executado, registre como não executado.

### Step 4 — Verify encoding

Para todo `.pas` efetivamente modificado:

- bytes iniciais `EF BB BF`;
- não converter `.pas` untouched.

### Step 5 — Verify tests

Relate exatamente:

- teste focado;
- fixture;
- suíte inteira;
- contagens.

Não transforme `1 test passed` em “tests passed” genericamente se isso sugere suíte total.

### Step 6 — Verify build

Se executado, registre ambiente/comando/resultado. Se não, diga `build não executado`.

### Step 7 — Verify Method Toxicity

- static assessment?;
- CSV real?;
- qual projeto?;
- qual revisão?;

Não atualizar baseline automaticamente sem intenção do projeto.

### Step 8 — Verify documentation

- docs afetadas atualizadas?;
- links válidos?;
- EN/PT-BR parity?;
- README não duplicou detalhes profundos?;

### Step 9 — Handle removals explicitly

ZIP incremental não apaga arquivo antigo.

Se houver remoção:

- liste path exato;
- explique que deve ser removido ao aplicar;
- não inclua placeholder vazio apenas para simular delete.

### Step 10 — Package only changed/created files

Preserve paths relativos do repositório.

Não incluir:

- CSV/XML consultado;
- worktree completo;
- source files untouched;
- cache/temp;
- scripts de análise que não fazem parte do projeto.

### Step 11 — Integrity

Quando produzir ZIP:

- liste contents;
- confirme quantidade;
- calcule checksum quando útil;
- compare pacote com lista de diff.

### Step 12 — Report limitations and risks

Exemplos:

- Delphi compiler indisponível;
- runtime mobile não verificado;
- Toxicity atual sem CSV;
- visual behavior revisado estaticamente apenas.

Limitação explícita é melhor que falsa garantia.

## Delivery Report Structure

Use `.agents/templates/delivery-report.md` quando a tarefa é grande. Para tarefa pequena, resposta curta é suficiente, desde que preserve precisão.

## Common Rationalizations

| Racionalização | Realidade |
|---|---|
| “Pode mandar o projeto inteiro; é mais fácil.” | Usuário pediu somente arquivos modificados e pacotes grandes escondem scope drift. |
| “Não precisa mencionar que build não rodou.” | Omissão pode ser interpretada como validação. |
| “Arquivo removido não vai no ZIP, então não importa.” | Usuário precisa saber que deve removê-lo. |
| “Baseline anterior vale.” | Não prova revisão atual. |
| “Checksum é detalhe.” | Não é sempre obrigatório, mas é útil em artefato final quando produzido. |

## Red Flags

- pacote contém `src/` inteiro após docs-only;
- arquivo consultado incluído;
- remoção não mencionada;
- `.pas` alterado sem BOM;
- claims de 197/197 após mudança sem reexecução;
- `Toxicity approved` sem CSV atual;
- README/docs divergentes;
- temp/worktree no ZIP.

## Verification

- [ ] Scope congelado e diff revisado.
- [ ] DoD aplicada.
- [ ] BOM validado para `.pas` alterados.
- [ ] Test/build/toxicity reportados com evidência correta.
- [ ] Docs/links/paridade revisados.
- [ ] Remoções listadas explicitamente.
- [ ] Pacote contém somente criados/modificados.
- [ ] Conteúdo do pacote corresponde ao diff.
- [ ] Limitações/riscos estão explícitos.
