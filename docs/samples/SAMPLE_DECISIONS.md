# Decisões do RickUIBuilder.Samples

## Decisões consolidadas

### DEC-001 — Arquitetura component-first

A Home é um catálogo de `Text / Label`, `Button`, `Badge`, `Divider`, `ComboBox` e `Edit`. Factory e Fluent Builder são opções internas da página do componente, e não categorias de primeiro nível da Home.

### DEC-002 — Factory e Fluent não são artificialmente simétricos

Somente APIs públicas confirmadas podem ser apresentadas. `Edit` não apresenta Factory no estado atual porque `Factory.CreateEdit` não está disponível.

### DEC-003 — Composition permanece abordagem pública própria

Composition não é tratada como sinônimo de Factory ou Fluent. Sua apresentação na navegação do Samples permanece pendente de decisão específica.

### DEC-004 — View apresenta e captura intenção

Views não executam comandos da aplicação. Não existe exceção baseada no tamanho ou simplicidade aparente do comando.

### DEC-005 — Home usa `IHomePresenter`

A Home depende de `IHomePresenter`. O contrato possui somente funções e representa as intenções `Close` e `OpenComponent`.

### DEC-006 — Contratos sem `procedure`

Contratos do projeto não declaram `procedure`. Operações contratuais são expressas por `function` e retornam o contrato apropriado quando a API for fluente.

### DEC-007 — Implementação contratual imutável

Uma operação fluente não deve alterar silenciosamente a configuração contratual da instância. No Presenter atual não existe estado configurável: as funções apenas delegam intenções e retornam a interface, sem mutação de configuração.

### DEC-008 — Coordinator controla o fluxo global

`TSampleApplicationCoordinator` executa fechamento e abertura de páginas. A Home e o Presenter não criam páginas de destino.

### DEC-009 — Composition Root explícito

`TSampleApplication` cria e conecta Coordinator, Presenter e Home. O Presenter não possui o Coordinator e não referencia a View.

### DEC-010 — Interatividade visual deve corresponder a ação real

Controles realmente clicáveis usam `crHandPoint`. Elementos sem ação não devem comunicar interatividade inexistente.

### DEC-011 — Imagem é referência visual

Screenshots fornecidos orientam proporção, alinhamento, densidade e hierarquia visual. Os textos e contratos vêm dos requisitos e da API real, não do conteúdo textual da imagem.

### DEC-012 — SVGs fornecidos são os assets oficiais da Home

Os ícones Material Symbols fornecidos são preservados como geometria vetorial `TPath`, inclusive `cottage`, `close_small` e `arrow_forward_ios`.

### DEC-013 — Typography compartilhada, Style específico

Tokens tipográficos semanticamente reutilizáveis ficam em `RickUIBuilder.Samples.App.Typography`. Geometria e aparência exclusivas da Home ficam em `RickUIBuilder.Samples.Home.Style`.

### DEC-014 — UTF-8 com BOM para fontes Delphi modificados com português

Units `.pas` modificadas com textos em português devem ser salvas em UTF-8 com BOM para evitar mojibake.

### DEC-015 — Entrega incremental

Pacotes de entrega contêm somente arquivos criados ou modificados na execução, mantendo caminhos relativos à raiz do repositório.


### DEC-016 — Units internas pertencem explicitamente ao projeto

As units do Samples são registradas no `.dpr` com seus caminhos físicos e no `.dproj` como `DCCReference`. O Search Path não é usado para incorporar units internas do próprio Samples.

### DEC-017 — Estrutura física acompanha responsabilidades existentes

`src/App`, `src/Home` e `src/Components/Common` refletem responsabilidades já implementadas. Diretórios por componente somente serão criados quando houver units reais que os justifiquem.

### DEC-018 — Header ocupa o client sem respiro externo

O header da Home é alinhado diretamente ao topo do formulário e ocupa sua largura. Margens e respiros pertencem ao conteúdo abaixo dele, não ao retângulo do header.

### DEC-019 — Geometria não reduz tipografia

Quando o conteúdo dos cards exigir mais espaço, largura e altura devem ser ajustadas moderadamente. A tipografia aprovada não deve ser reduzida para esconder clipping ou sobreposição.

### DEC-020 — Cabeçalho estrutural obrigatório nas units do Samples

Toda unit `.pas` criada ou modificada no Samples deve iniciar, já na primeira linha física, com uma explicação objetiva e suficientemente detalhada da responsabilidade concreta daquela unit; em seguida mantém o cabeçalho documental estrutural produzido a partir da implementação final. O cabeçalho serve como mapa local para manutenção humana e para análise por IA, mas nunca substitui a leitura do código.

O cabeçalho deve registrar, quando aplicável: finalidade, funcionalidade existente, responsabilidades, dependências internas do projeto e o motivo de cada dependência, fluxo/colaboração com outras units, ownership/lifetime e restrições arquiteturais. Se uma alteração mudar qualquer uma dessas informações, o cabeçalho deve ser atualizado na mesma execução. Comentário genérico, copiado mecanicamente ou divergente do código reprova a documentação.



### DEC-021 — Gates Delphi especializados são independentes

Código Delphi criado ou modificado é auditado por Naming; alterações capazes de afetar corpos de métodos são auditadas também por Toxicity; interfaces, GUIDs, reference counting, ownership e lifetime acionam Contract & Lifetime. Delphi Code Auditor continua responsável pela revisão técnica geral, mas não substitui esses gates especializados.

### DEC-022 — Catálogo de agents deve corresponder aos arquivos reais

Todo agent declarado em `samples/.agents/README.md` deve possuir arquivo correspondente em `samples/.agents/agents/`. O Final Process Compliance Auditor verifica essa correspondência antes de permitir uma entrega relevante.

### DEC-023 — Artefatos locais da IDE não integram a entrega

`__history/`, `__recovery/`, `.identcache` e `.dproj.local` são tratados como artefatos locais/temporários e não integram pacotes de entrega sem necessidade explícita e comprovada. Eles também não são fonte arquitetural ou documental. Arquivos necessários ao build, como `.res`, são avaliados pela referência real no projeto e não são removidos mecanicamente.

### DEC-024 — Component Page adota a referência visual aprovada

A família de páginas de componente segue a referência visual fornecida para `Button` como modelo de hierarquia, proporção, alinhamento e densidade, sem copiar afirmações técnicas que contradigam o código real.

### DEC-025 — Modelo parametrizado único foi substituído por herança explícita

A decisão anterior de representar os seis componentes como estados parametrizados dentro de uma única página genérica foi substituída. `TComponentCommon` é a base abstrata comum atual, e cada componente possui uma página concreta derivada. Conteúdo específico não fica centralizado em arrays ou `case/if` na classe-base.

### DEC-026 — Assets oficiais da Component Page são os SVGs fornecidos

A página usa `factory_24dp_E3E3E3_FILL0_wght400_GRAD0_opsz24.svg` para Factory, `link-03-svgrepo-com.svg` para Fluent Builder e `info_48dp_E3E3E3_FILL0_wght400_GRAD0_opsz48.svg` para o painel informativo. A geometria vetorial é preservada; emoji, caractere Unicode e aproximações desenhadas não substituem esses assets.

### DEC-027 — Referência visual não substitui a verdade técnica do código

Textos técnicos da imagem não são copiados quando divergirem da implementação. Em particular, o Button atual não é documentado como `TButton`: sua implementação é composta por `TRectangle + TLabel`. Títulos, subtítulos e texto de `Sobre este componente` são derivados da API/documentação real do componente.

### DEC-028 — `Ver exemplos` não possui destino fictício

`Ver exemplos` representa a ação para abrir uma Sample Page de Factory ou Fluent Builder. A ação só recebe callback, `crHandPoint` e hit testing quando o destino correspondente realmente existe. No estado atual, `Text / Label → Factory` é o primeiro destino concreto; os demais permanecem somente visuais até sua implementação.

### DEC-029 — Tipografia é preservada na Component Page

A Component Page reutiliza a escala semântica de `App.Typography`: 24 para título, 14 para subtítulo, 16 para título de card, 14 para corpo, 14 para ação e 13 para navegação. Geometria e espaçamento devem acomodar esses tokens sem redução de fonte para mascarar clipping.

### DEC-030 — O painel “Sobre este componente” é obrigatório nas seis páginas

Cada página concreta possui painel informativo inferior com ícone oficial, título `Sobre este componente` e texto curto baseado no comportamento real do componente. O painel não deve antecipar APIs inexistentes nem simplificar detalhes de modo a produzir afirmação tecnicamente falsa.

### DEC-031 — Cada componente possui uma página concreta

`Text / Label`, `Button`, `Badge`, `Divider`, `ComboBox` e `Edit` possuem classes próprias herdando de `TComponentCommon`. A classe-base concentra somente layout e comportamento comum; cada derivada decide seu conteúdo e quais abordagens aparecem.

### DEC-032 — Component Page é somente a divisão para Factory e Fluent Builder

As Component Pages permanecem intermediárias e não contêm os samples finais. A decisão de não criar destinos sem requisito continua válida; a implementação posterior de Text / Label - Factory é registrada em DEC-044 e não move o sample para a Component Page.

### DEC-033 — Component Page é borderless e o retorno fecha a modal

A família de páginas utiliza `TFmxFormBorderStyle.None`, seguindo o padrão visual da Home. A seta superior esquerda possui hit area própria e fecha a janela modal atual; o Coordinator continua responsável por liberar a instância após `ShowModal`.

### DEC-034 — Components não depende de `Home.Style`

A família de Component Pages mantém geometria e paleta local em `RickUIBuilder.Samples.Component.Common.Style`, consumida por `TComponentCommon`, e reutiliza a tipografia global de `App.Typography`. A feature de Components não deve depender de `RickUIBuilder.Samples.Home.Style`.

### DEC-035 — A página de exemplos possui uma base visual própria

A terceira camada de navegação possui uma Sample Page Base própria, distinta da Home e da Component Page. Ela está implementada como `TExampleCommon` em `RickUIBuilder.Samples.Example.Common` e é reutilizada por herança pelas páginas concretas, começando por Text / Label - Factory, sem centralizar regras específicas de componentes ou abordagens.

### DEC-036 — Sample Page permanece menor que a Home

A família de páginas de exemplos deve permanecer estritamente menor que a Home. A base implementada usa `620 × 510`, enquanto a Home usa `644 × 534`. Excesso de navegação e código é tratado dentro das regiões roláveis da própria página, sem aumentar a janela acima da Home nem reduzir tipografia para mascarar clipping.

### DEC-037 — O textframe fixa a sequência estrutural da Sample Page

O Design System pode fornecer tokens e componentes visuais, mas não pode alterar a ordem estrutural definida em `SAMPLE_EXAMPLE_PAGE_BASE_SPEC.md`. A sequência originalmente registrava código e resultado em série; **DEC-047 substitui essa parte** pela regra atual de uma única view ativa após o seletor. Mudança adicional nessa sequência exige decisão documental explícita.

### DEC-038 — Conteúdo e execução pertencem às páginas derivadas

A Sample Page Base fornece apenas infraestrutura comum. A página derivada de cada componente/abordagem define categorias, exemplos, código Delphi apresentado e execução do resultado. A base não contém `case/if` por componente, catálogo global de exemplos nem regras específicas de Factory ou Fluent Builder.

### DEC-039 — Back da Sample Page retorna à Component Page de origem

O header de cada página de exemplos preserva o contexto do componente pai. No primeiro destino concreto, `Text / Label - Factory` exibe `Text / Label` no header e o retorno encerra somente essa página, devolvendo o usuário à Component Page; a Component Page continua responsável por retornar à Home.

### DEC-040 — Cobertura de exemplos deriva da API pública real

Quando uma página concreta de exemplos for implementada, sua cobertura deve ser levantada a partir da API pública real daquele componente e daquela abordagem no código vigente. Todas as funcionalidades públicas relevantes devem estar representadas por exemplos individuais ou compostos. A Sample Page Base não fixa antecipadamente categorias como `Básico`, `Estilo`, `Ícones` ou `Estados`; esses nomes pertencem às páginas concretas quando sustentados pela API real.

### DEC-041 — Referência visual não autoriza comportamento não confirmado

Elementos presentes no mockup preservam posição, hierarquia e intenção visual, mas comportamentos não confirmados não são inventados. A ausência inicial de requisito manteve `Código Delphi` / `Resultado` apenas visual. **Essa parte da decisão foi superada por DEC-047**, após requisito explícito definir a alternância funcional.

### DEC-042 — Estrutura física e API protegida da Sample Page Base

A implementação comum fica em `samples/src/Examples/Common`. `TExampleCommon` expõe às derivadas apenas operações protegidas para configurar identidade, adicionar/selecionar itens de navegação, definir o exemplo, preencher o código e acessar/limpar `ResultHost`. Esta decisão trata somente da base; páginas concretas são decisões separadas, como DEC-044.

### DEC-043 — Controles estruturais da Sample Page Base são separados por responsabilidade

`TExampleCommon` não concentra toda a materialização visual. Header, navegação, seletor Código/Resultado, painel de código e painel de resultado são implementados respectivamente em `RickUIBuilder.Samples.Example.Common.Header`, `.Navigation`, `.ViewSelector`, `.CodePanel` e `.ResultPanel`; `.Icons` mantém vetores e `.Style` mantém os tokens visuais. A classe-base coordena esses elementos e preserva a API protegida destinada às páginas derivadas. Essa separação segue o padrão de responsabilidades já usado no Samples e evita transformar a base em um arquivo monolítico.

### DEC-044 — Text / Label - Factory é o primeiro sample concreto

`TExampleTextLabelFactory` é a primeira derivada real de `TExampleCommon`. A implementação fica em `src/Examples/TextLabel` e separa coordenação da page (`Factory`), conteúdo/snippets (`Factory.Content`) e execução real (`Factory.Runner`). Os exemplos Básico, Geometria, Tipografia, Alinhamento e Completo cobrem `CreateText` e todos os campos públicos atuais de `TRickUIBuilderTextConfig`.

### DEC-045 — Navegação só é habilitada para destino real e permanece coordenada fora da View

`TComponentTextLabel` captura o clique de Factory e emite `OnFactoryExamples`; não cria a Sample Page. `TSampleApplicationCoordinator` conecta esse callback, cria `TExampleTextLabelFactory` sem Owner, executa `ShowModal` e libera a instância em `finally`. Os demais cards sem destino continuam sem callback e sem `HitTest`.

### DEC-046 — Dependências FMX de símbolos visuais devem ser explícitas

Toda unit do Samples que utilizar `TTextAlign` deve declarar `FMX.Types` explicitamente no `uses`. Toda unit que utilizar `TBrushKind` deve declarar `FMX.Graphics` explicitamente. A regra evita dependência acidental de símbolos trazidos transitivamente por outras units e faz parte da auditoria Delphi local.



### DEC-047 — Código Delphi e Resultado são views mutuamente exclusivas

O requisito atual confirma a semântica do seletor `Código Delphi` / `Resultado`. A Sample Page inicia em `Código Delphi`; selecionar `Resultado` oculta o painel de código e exibe somente o painel de resultado, e selecionar `Código Delphi` executa a alternância inversa. A responsabilidade fica em `TExampleViewSelector` + `TExampleCommon`; páginas concretas não duplicam essa lógica.

### DEC-048 — Estado selecionado e superfície de resultado seguem a referência aprovada

O item ativo da navegação lateral usa fundo azul-claro, texto azul e indicador vertical azul à esquerda, sem depender de bold para comunicar seleção. A superfície de resultado usa fundo claro próprio, borda suave e cantos arredondados conforme a referência visual. Esses tokens pertencem a `RickUIBuilder.Samples.Example.Common.Style`; a navegação e o painel de resultado apenas os materializam.

### DEC-049 — Superfície de código é selecionável, copiável e rola somente por overflow

`TExampleCodePanel` utiliza `TMemo` read-only com `WordWrap = False`, permite seleção parcial/total e cópia normal da seleção, além da ação explícita `Copiar código` para o snippet completo. A rolagem depende do overflow real do memo em modo AutoHide; não se usa canvas fixa maior que o viewport apenas para forçar barras.

### DEC-050 — Resultado ocupa toda a área útil e `ResultHost` permanece estável

`TExampleResultPanel` ocupa toda a altura útil da view abaixo do seletor. Sua superfície owns `ResultHost`, que permanece estável durante a vida da página; derivadas usam o host como Parent dos controles do sample, não o liberam nem o substituem. `ClearResult` libera somente os filhos antes da próxima materialização. A expansão do host não estica automaticamente o controle produzido pelo sample.


### DEC-051 — CodePanel fornece feedback de cópia, leitura escura e snippets didáticos compactos

`TExampleCodePanel` mantém o `TMemo` read-only/selecionável integrado à paleta escura da superfície de código, em vez de aceitar o fundo branco do estilo padrão. A ação `Copiar código` altera temporariamente seu estado visual para `Copiado` somente após a escrita bem-sucedida no clipboard e retorna automaticamente ao estado normal. Snippets concretos começam com comentários `//` curtos e padronizados que explicam a intenção do exemplo e orientam a conferência na aba `Resultado`; comentários não devem ser verbosos a ponto de criar scroll vertical apenas pela documentação.
