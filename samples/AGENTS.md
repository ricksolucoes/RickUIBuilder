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

1. As units internas do Samples devem estar fisicamente organizadas por responsabilidade. `src/App`, `src/Home`, `src/Components/Common` e `src/Examples/Common` concentram responsabilidades compartilhadas; diretórios `src/Components/<Componente>` e futuros `src/Examples/<Componente>` são permitidos somente quando possuírem units concretas daquele componente. Não criar diretórios antecipados sem implementação real.
2. Toda unit interna usada pelo executável deve estar explicitamente registrada no projeto (`.dpr` com `in` e `.dproj` com `DCCReference`). O Search Path não pode ser usado para mascarar unit interna ausente do projeto.
3. `DCC_UnitSearchPath` não deve conter `src` nem subpastas internas do próprio Samples. Ele pode conter somente dependências externas realmente necessárias, como `..\src` da biblioteca Rick.UIBuilder, além do Search Path herdado.
4. O header da Home deve ocupar toda a largura do client, alinhado ao topo, sem margem externa lateral ou superior. Respiro visual pertence ao conteúdo abaixo do header.
5. Cards devem preservar a tipografia aprovada e possuir largura/altura suficientes para título, descrição e ação sem recorte ou sobreposição. Não reduzir fonte para compensar geometria insuficiente.
6. Mudanças em estrutura, `.dpr`, `.dproj`, Search Path, header ou geometria dos cards invalidam os gates correspondentes e exigem nova auditoria sobre o artefato final.
7. Toda unit `.pas` criada ou modificada deve iniciar, já na primeira linha física, com uma explicação objetiva e suficientemente detalhada da responsabilidade concreta daquela unit; em seguida deve manter o cabeçalho documental estrutural fiel ao código final, cobrindo finalidade, funcionalidade, responsabilidades, dependências internas e sua função, fluxo/colaboração e, quando aplicável, ownership/lifetime e restrições. O cabeçalho orienta manutenção humana e IA, mas deve ser auditado contra o código e nunca substitui sua leitura.
8. Toda alteração de código Delphi exige `Samples Naming Auditor`; alterações que possam afetar corpos de métodos exigem também `Samples Toxicity Auditor`. Interfaces, GUIDs, reference counting, ownership ou lifetime exigem `Samples Contract & Lifetime Auditor`.
9. Os arquivos declarados no catálogo de agents devem existir fisicamente em `.agents/agents/`. Catálogo e arquivos de agentes divergentes constituem falha de governança.
10. Artefatos locais/temporários da IDE, como `__history/`, `__recovery/`, `.identcache` e `.dproj.local`, não são fonte arquitetural nem documental e não devem integrar pacote de entrega sem necessidade explícita e comprovada. Arquivos necessários ao build, como `.res`, não são classificados como temporários apenas pela extensão.

11. `RickUIBuilder.Samples.Component.Common` (`TComponentCommon`) é a base comum das páginas intermediárias de componente; `RickUIBuilder.Samples.Component.Common.Style` mantém os tokens visuais compartilhados. Conteúdo específico de Text/Label, Button, Badge, Divider, ComboBox e Edit deve permanecer nas respectivas pages derivadas; a base não deve centralizar arrays/configurações desses seis componentes nem depender de `Home.Style`.
12. Component Pages são o divisor entre Factory e Fluent Builder. Ações só podem ser habilitadas quando existir destino real implementado. No estado atual, somente `Text / Label → Factory` possui Sample Page concreta; não criar callbacks vazios ou destinos fictícios para as demais abordagens.
13. Component Pages devem permanecer borderless, com header no topo, retorno funcional fechando a modal e geometria suficiente para subtítulo, cards e painel informativo sem clipping e sem redução da tipografia aprovada.
14. `RickUIBuilder.Samples.Example.Common` (`TExampleCommon`) coordena a base comum da terceira camada de páginas de exemplos. Header, navegação, seletor Código/Resultado, painel de código e painel de resultado devem permanecer separados em `.Header`, `.Navigation`, `.View.Selector`, `.Code.Panel` e `.Result.Panel`; `.Style` mantém tokens visuais e `.Icons` os vetores comuns. Nenhuma dessas units pode conhecer conteúdo específico de componente ou abordagem, e a classe-base não deve reabsorver responsabilidades já separadas. Conteúdo específico pertence às derivadas, como `Text / Label - Factory`.
15. A Sample Page Base deve permanecer borderless e estritamente menor que a Home. Na geometria vigente usa `620 × 510`, enquanto a Home usa `644 × 534`. A sequência `header → identidade → navegação/conteúdo → exemplo → seletor Código Delphi/Resultado → uma única view ativa` não pode ser reordenada sem decisão documental explícita. A page concreta deve manter snippet exibido e resultado executado semanticamente sincronizados.
16. `Código Delphi` / `Resultado` é um seletor funcional da base. `Código Delphi` é a view inicial; código e resultado são mutuamente exclusivos e a alternância pertence a `.View.Selector` + `TExampleCommon`, sem ser duplicada pelas páginas concretas. A base continua fornecendo superfície de código e `ResultHost`; páginas concretas fornecem snippets e execução próprios sem mover conteúdo específico para `TExampleCommon`.
17. Páginas concretas de examples devem ficar em `src/Examples/<Componente>` somente quando houver implementação real. Para Text / Label - Factory, coordenação da page, conteúdo/snippets e execução permanecem separados em `.Factory`, `.Factory.Content` e `.Factory.Runner`; novas páginas devem preservar a mesma separação quando essas responsabilidades existirem.
18. Toda unit que utilizar `TTextAlign` deve declarar `FMX.Types` explicitamente no `uses`. Toda unit que utilizar `TBrushKind` deve declarar `FMX.Graphics` explicitamente. Dependência transitiva não satisfaz esse critério.
19. `TExampleCodePanel` deve usar uma superfície de texto somente leitura que permita seleção parcial/total e cópia, sem canvas fixa usada apenas para forçar scroll. As barras de rolagem devem depender do overflow real do conteúdo; a ação `Copiar código` copia o snippet completo por serviço de clipboard da plataforma e deve fornecer feedback visual temporário após cópia bem-sucedida. A superfície do `TMemo` deve permanecer integrada à paleta escura do painel, sem fundo branco proveniente do estilo padrão.
20. `TExampleResultPanel` deve ocupar toda a altura útil da view `Resultado` abaixo do seletor. `ResultHost` é um container estável owned pela superfície de resultado; páginas derivadas podem anexar controles a ele, mas não podem liberá-lo ou substituí-lo. `ClearResult` remove somente seus filhos antes da próxima materialização.


21. Snippets exibidos nas páginas concretas devem iniciar com comentários `//` curtos e padronizados que expliquem a intenção do exemplo e indiquem que o controle materializado pode ser conferido na aba `Resultado`. Esses comentários não devem ser verbosos a ponto de introduzir scroll vertical apenas pela explicação; snippet e Runner continuam semanticamente sincronizados.
