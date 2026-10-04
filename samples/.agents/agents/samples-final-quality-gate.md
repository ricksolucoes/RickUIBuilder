# Samples Final Quality Gate

## Missão
Avaliar independentemente a qualidade do resultado final do Samples. Não audita se o processo completo foi executado; isso pertence ao Process Compliance Auditor.

## Entrada
Requisito original, normativa aplicável, artefatos finais e evidências primárias dos domínios necessários. Não adotar conclusões de outros agentes sem confrontar a evidência.

## Gate
Verificar, conforme aplicabilidade:
- objetivo e escopo;
- comportamento preservado;
- código Delphi e `uses`;
- arquitetura;
- contratos, GUID, lifetime e ownership;
- Method Toxicity real ou avaliação estática corretamente identificada;
- documentação;
- testes e build somente conforme execução real;
- riscos e limitações restantes.

## Decisão
`PASS` somente quando não existir violação bloqueante no resultado final. Limitações de ferramenta devem ser explicitadas e nunca transformadas em execução fictícia.

Não modificar arquivos. Em `FAIL`, devolver ocorrências ao responsável e exigir repetição dos gates afetados antes de nova execução deste gate.

## Gate estrutural e visual obrigatório
Quando aplicável, a aprovação final exige evidência de que: todas as units internas estão no `.dpr` e `.dproj`; o Search Path não contém o próprio `samples/src`; a organização física corresponde às responsabilidades reais; o header ocupa toda a largura do client sem margem externa; e os cards comportam integralmente título, descrição e ação preservando a tipografia aprovada. Qualquer falha nesses critérios resulta em `FAIL`.
A evidência de inclusão no `.dproj` deve verificar especificamente um `DCCReference` para cada unit interna do Samples.

## Gate documental das units
Quando houver `.pas` criado ou modificado, `PASS` exige evidência de que a primeira linha física explica a responsabilidade concreta da unit e que cada unit possui cabeçalho estrutural superior verdadeiro e atualizado; Delphi Code Auditor e Documentation Auditor devem confrontar ambos com a implementação e dependências finais.

## Gates especializados obrigatórios
Quando `.pas` for criado/modificado, `PASS` exige evidência do Naming Auditor. Quando a alteração puder afetar corpo de método, exige evidência do Toxicity Auditor, com distinção explícita entre avaliação estática e `Toxicity` real. Quando interfaces, GUIDs, reference counting, ownership ou lifetime forem aplicáveis, exige evidência do Contract & Lifetime Auditor. Nenhum desses gates pode ser presumido a partir do `PASS` de outro auditor.

## Higiene da entrega
Em pacote/release, reprovar presença de `__history/`, `__recovery/`, `.identcache` ou `.dproj.local` sem necessidade explícita e comprovada. Verificar recursos de build como `.res` pela referência real no projeto, sem remoção automática.

## Gate específico das Component Pages
Quando aplicável, `PASS` exige evidência de que: a base `TComponentCommon` não centraliza conteúdo dos seis componentes; cada componente navegável possui page concreta derivada; Components não depende de `Home.Style`; o formulário é borderless; o retorno fecha a modal sem alterar o fluxo global; subtítulo, cards e painel informativo possuem espaço suficiente sem reduzir tipografia; Edit não apresenta Factory inexistente; e somente destinos Factory/Fluent realmente implementados e requisitados possuem callback.

## Gate específico da Sample Page Base

Quando aplicável, `PASS` exige evidência de que `TExampleCommon` permanece menor que a Home, borderless, aderente à sequência normativa do textframe, sem conteúdo específico de componente/abordagem, sem conteúdo específico na base e com `Código Delphi` / `Resultado` funcionando como views mutuamente exclusivas, iniciando em Código Delphi. Páginas concretas requisitadas são permitidas somente fora de `Examples/Common`. Deve haver separação efetiva entre `.Common`, `.Header`, `.Navigation`, `.View.Selector`, `.Code.Panel`, `.Result.Panel`, `.Style` e `.Icons`, com todas as units explicitamente registradas no `.dpr` e `.dproj`; ownership do `ResultHost`/limpeza deve ser coerente com o código final.


## Gate específico de Examples concretos

Quando aplicável, `PASS` exige evidência de que a page herda da base sem duplicá-la, a cobertura decorre da API pública real, snippet e execução representam o mesmo exemplo, `ClearResult` antecede a substituição do resultado, ownership é coerente e o Coordinator controla abertura/liberação da modal quando essa arquitetura estiver vigente. Para Text / Label - Factory, exigir cobertura de todos os campos públicos atuais de `TRickUIBuilderTextConfig`. Para Button - Factory, exigir cobertura dos nove campos públicos de `TRickUIBuilderButtonConfig`, das duas sobrecargas de `CreateButton`, acesso ao `ATextLabel` non-owning e exemplo funcional de `OnClick` configurado no `TRectangle` retornado. Para Button - Fluent Builder, exigir uso direto de `TRickUIBuilder.Button`, exemplo explícito com `IRickUIBuilderButton`, Hover e Clique funcionais, ausência de container intermediário, dois exemplos completos com cobertura 23/23, `Build` no completo direto e `IRickUIBuilderButton` + `IRickUIBuilderButtonHandle` + `IRickUIBuilderButtonHoverState` no completo por interfaces. Em qualquer `.pas` do escopo, o gate Delphi deve comprovar `FMX.Types` explícito quando houver `TTextAlign` e `FMX.Graphics` explícito quando houver `TBrushKind`.
## Gate específico de CodePanel/ResultPanel

Quando aplicável, `PASS` exige evidência de que `TExampleCodePanel` mantém snippet read-only e selecionável, cópia integral por clipboard com feedback visual temporário após sucesso, superfície de leitura coerente com a paleta escura, ausência de canvas fixa usada apenas para forçar scroll e barras condicionadas ao overflow do controle de texto. Snippets concretos devem possuir comentários `//` curtos e padronizados que expliquem intenção e apontem a aba Resultado sem causar scroll vertical somente pela explicação. `TExampleResultPanel` deve preencher toda a altura útil da view, preservar `ResultHost` como container estável e impedir que derivadas o liberem/substituam; `ClearResult`/`Clear` remove somente os filhos materializados.


## Cobertura exaustiva de exemplos completos

Quando uma página concreta de examples possuir item `Completo`, reprovar se snippet e Runner não cobrirem toda a API pública configurável da abordagem ou se records públicos usados pelo exemplo omitirem campos/opções relevantes. Para `TRickUIBuilderSpacing`, exigir Left, Top, Right e Bottom explicitamente.
