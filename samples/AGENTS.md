# AGENTS.md — Governança local do RickUIBuilder.Samples

Esta governança aplica-se exclusivamente ao diretório `samples/` e aos documentos de Samples em `docs/samples/`. Ela complementa, sem substituir, a normativa principal do RickUIBuilder.

## Princípios obrigatórios

1. Requisito explícito atual, comportamento existente e normativa superior prevalecem sobre preferências arquiteturais.
2. Não inventar requisito, API, resultado de teste, compilação, métrica ou evidência.
3. Aplicar alteração mínima necessária.
4. Selecionar somente os agentes/gates aplicáveis ao escopo e risco.
5. Auditor não implementa; implementador não aprova o próprio trabalho.
6. Evidência deve corresponder ao artefato final auditado.
7. Alteração posterior invalida os gates cujo domínio possa ter sido afetado.
8. `NOT_EXECUTED` nunca equivale a `PASS`.
9. A entrega relevante exige `PASS` do `Samples Final Quality Gate` e do `Samples Final Process Compliance Auditor` quando ambos forem aplicáveis.

## Estados oficiais

`PASS`, `FAIL`, `NOT_APPLICABLE`, `NOT_EXECUTED`, `BLOCKED`.

`NOT_APPLICABLE` exige evidência objetiva de não aplicabilidade. Gate obrigatório em `NOT_EXECUTED`, `FAIL` ou `BLOCKED` bloqueia a entrega.

## Fluxo

```text
Solicitação
  ↓
Samples Task Orchestrator
  ↓
Implementação pelo responsável técnico
  ↓
Auditorias aplicáveis e independentes
  ↓
Samples Final Quality Gate
  ↓
Samples Final Process Compliance Auditor
  ↓
Entrega
```

Em reprovação: auditor identifica → responsável corrige → gates afetados são repetidos → gates finais são repetidos.

## Isolamento de auditoria

Auditores especializados recebem requisito original relevante, sua normativa, artefato final e evidência primária necessária. Não recebem como fundamento conclusões, justificativas persuasivas ou cadeia de pensamento de outros agentes.

O `Samples Final Process Compliance Auditor` recebe o `Execution Manifest` porque precisa auditar o processo, mas recalcula independentemente quais gates eram obrigatórios.

## Catálogo

Consulte `.agents/README.md` para aplicabilidade, responsabilidades e formato do `Execution Manifest`.

## Regras estruturais obrigatórias do Samples

1. As units internas do Samples devem estar fisicamente organizadas por responsabilidade em `src/App`, `src/Home` e `src/Components/Common` enquanto essas responsabilidades existirem. Não criar diretórios de componentes sem units reais que os justifiquem.
2. Toda unit interna usada pelo executável deve estar explicitamente registrada no projeto (`.dpr` com `in` e `.dproj` com `DCCReference`). O Search Path não pode ser usado para mascarar unit interna ausente do projeto.
3. `DCC_UnitSearchPath` não deve conter `src` nem subpastas internas do próprio Samples. Ele pode conter somente dependências externas realmente necessárias, como `..\src` da biblioteca Rick.UIBuilder, além do Search Path herdado.
4. O header da Home deve ocupar toda a largura do client, alinhado ao topo, sem margem externa lateral ou superior. Respiro visual pertence ao conteúdo abaixo do header.
5. Cards devem preservar a tipografia aprovada e possuir largura/altura suficientes para título, descrição e ação sem recorte ou sobreposição. Não reduzir fonte para compensar geometria insuficiente.
6. Mudanças em estrutura, `.dpr`, `.dproj`, Search Path, header ou geometria dos cards invalidam os gates correspondentes e exigem nova auditoria sobre o artefato final.
7. Toda unit `.pas` criada ou modificada deve iniciar com cabeçalho documental estrutural fiel ao código final, cobrindo finalidade, funcionalidade, responsabilidades, dependências internas e sua função, fluxo/colaboração e, quando aplicável, ownership/lifetime e restrições. O cabeçalho orienta manutenção humana e IA, mas deve ser auditado contra o código e nunca substitui sua leitura.
8. Toda alteração de código Delphi exige `Samples Naming Auditor`; alterações que possam afetar corpos de métodos exigem também `Samples Toxicity Auditor`. Interfaces, GUIDs, reference counting, ownership ou lifetime exigem `Samples Contract & Lifetime Auditor`.
9. Os arquivos declarados no catálogo de agents devem existir fisicamente em `.agents/agents/`. Catálogo e arquivos de agentes divergentes constituem falha de governança.
10. Artefatos locais/temporários da IDE, como `__history/`, `__recovery/`, `.identcache` e `.dproj.local`, não são fonte arquitetural nem documental e não devem integrar pacote de entrega sem necessidade explícita e comprovada. Arquivos necessários ao build, como `.res`, não são classificados como temporários apenas pela extensão.
