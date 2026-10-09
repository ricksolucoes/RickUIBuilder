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

`Ver exemplos` representa a ação para abrir uma Sample Page de Factory ou Fluent Builder. A ação só recebe callback, `crHandPoint` e hit testing quando o destino correspondente realmente existe. No estado atual, Text / Label, Button, Badge, Divider e ComboBox possuem destinos Factory + Fluent Builder; Edit possui somente Fluent Builder. Nenhuma abordagem sem destino é apresentada como opção funcional.

### DEC-029 — Tipografia é preservada na Component Page

A Component Page reutiliza a escala semântica de `App.Typography`: 24 para título, 14 para subtítulo, 16 para título de card, 14 para corpo, 14 para ação e 13 para navegação. Geometria e espaçamento devem acomodar esses tokens sem redução de fonte para mascarar clipping.

### DEC-030 — O painel “Sobre este componente” é obrigatório nas sete páginas

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

A família de páginas de exemplos deve permanecer estritamente menor que a Home. O layout padrão da base usa `620 × 510`, enquanto a Home usa `644 × 534`. **DEC-066 complementa esta decisão** permitindo especialização controlada por herança quando uma página concreta precisa de mais espaço, sempre abaixo da Home. Excesso de conteúdo continua sendo tratado pelas regiões roláveis apropriadas, sem reduzir tipografia para mascarar clipping.

### DEC-037 — O textframe fixa a sequência estrutural da Sample Page

O Design System pode fornecer tokens e componentes visuais, mas não pode alterar a ordem estrutural definida em `SAMPLE_EXAMPLE_PAGE_BASE_SPEC.md`. A sequência originalmente registrava código e resultado em série; **DEC-047 substitui essa parte** pela regra atual de uma única view ativa após o seletor. Mudança adicional nessa sequência exige decisão documental explícita.

### DEC-038 — Conteúdo e execução pertencem às páginas derivadas

A Sample Page Base fornece apenas infraestrutura comum. A página derivada de cada componente/abordagem define categorias, exemplos, código Delphi apresentado e execução do resultado. A base não contém `case/if` por componente, catálogo global de exemplos nem regras específicas de Factory ou Fluent Builder.

### DEC-039 — Back da Sample Page retorna à Component Page de origem

O header de cada página de exemplos preserva o contexto do componente pai. As páginas `Text / Label - Factory` e `Text / Label - Fluent Builder` exibem `Text / Label` no header e o retorno encerra somente a Sample Page atual, devolvendo o usuário à Component Page; a Component Page continua responsável por retornar à Home.

### DEC-040 — Cobertura de exemplos deriva da API pública real

Quando uma página concreta de exemplos for implementada, sua cobertura deve ser levantada a partir da API pública real daquele componente e daquela abordagem no código vigente. Todas as funcionalidades públicas relevantes devem estar representadas por exemplos individuais ou compostos. A Sample Page Base não fixa antecipadamente categorias como `Básico`, `Estilo`, `Ícones` ou `Estados`; esses nomes pertencem às páginas concretas quando sustentados pela API real.

### DEC-041 — Referência visual não autoriza comportamento não confirmado

Elementos presentes no mockup preservam posição, hierarquia e intenção visual, mas comportamentos não confirmados não são inventados. A ausência inicial de requisito manteve `Código Delphi` / `Resultado` apenas visual. **Essa parte da decisão foi superada por DEC-047**, após requisito explícito definir a alternância funcional.

### DEC-042 — Estrutura física e API protegida da Sample Page Base

A implementação comum fica em `samples/src/Examples/Common`. `TExampleCommon` expõe às derivadas apenas operações protegidas para configurar identidade, adicionar/selecionar itens de navegação, definir o exemplo, preencher o código e acessar/limpar `ResultHost`. Esta decisão trata somente da base; páginas concretas são decisões separadas, como DEC-044.

### DEC-043 — Controles estruturais da Sample Page Base são separados por responsabilidade

`TExampleCommon` não concentra toda a materialização visual. Header, navegação, seletor Código/Resultado, painel de código e painel de resultado são implementados respectivamente em `RickUIBuilder.Samples.Example.Common.Header`, `.Navigation`, `.View.Selector`, `.Code.Panel` e `.Result.Panel`; `.Icons` mantém vetores e `.Style` mantém os tokens visuais. A classe-base coordena esses elementos e preserva a API protegida destinada às páginas derivadas. Essa separação segue o padrão de responsabilidades já usado no Samples e evita transformar a base em um arquivo monolítico.

### DEC-044 — Text / Label - Factory é o primeiro sample concreto

`TExampleTextLabelFactory` é a primeira derivada real de `TExampleCommon`. A implementação fica em `src/Examples/TextLabel/Factory` e separa coordenação da page (`Factory`), conteúdo/snippets (`Factory.Content`) e execução real (`Factory.Runner`). Os exemplos Básico, Geometria, Tipografia, Alinhamento e Completo cobrem `CreateText` e todos os campos públicos atuais de `TRickUIBuilderTextConfig`.

### DEC-045 — Navegação só é habilitada para destino real e permanece coordenada fora da View

As Component Pages capturam somente as intenções correspondentes aos destinos reais. Nenhuma Component Page cria Sample Pages. `TSampleApplicationCoordinator` conecta os callbacks de Text / Label, Button, Badge, Divider e ComboBox para Factory + Fluent Builder e o callback Fluent de Edit; cria a Sample Page concreta sem Owner, executa `ShowModal` e libera a instância em `finally`. Se uma abordagem futura ainda não possuir destino real, ela não deve ser apresentada como ação funcional.

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

### DEC-052 — Tipos compartilhados da navegação de examples ficam em App.Types

O código vigente centraliza `TSampleComponent`, `TExampleView` e os enums de examples de Text / Label, Button, Badge, Divider, ComboBox e Edit em `RickUIBuilder.Samples.App.Types`. Os enums Factory/Fluent são compartilhados por suas respectivas pages, Contents e Runners; `TExampleView` é compartilhado por `TExampleCommon` e `TExampleViewSelector`. As units de conteúdo não declaram esses enums.

### DEC-053 — Units estruturais de examples usam namespaces físicos segmentados

As units comuns de seletor, código e resultado usam os nomes físicos e declarações `RickUIBuilder.Samples.Example.Common.View.Selector`, `RickUIBuilder.Samples.Example.Common.Code.Panel` e `RickUIBuilder.Samples.Example.Common.Result.Panel`. `.dpr`, `.dproj`, cabeçalhos, documentação e governança devem usar exatamente esses nomes.

### DEC-054 — O executável Samples aceita `-nodx` antes da inicialização FMX

`RickUIBuilder.Samples.dpr` aceita o parâmetro opcional `-nodx`. Quando detectado por `FindCmdLineSwitch`, o ponto de entrada define `FMX.Types.GlobalUseDX := False` antes de `Application.Initialize`; sem o parâmetro, o comportamento gráfico padrão do FireMonkey é preservado. Essa opção pertence ao bootstrap do executável e não altera os contratos de navegação ou as páginas do Samples.


### DEC-055 — Text / Label - Fluent Builder é o segundo destino concreto de examples

`TExampleTextLabelFluent` herda de `TExampleCommon` e separa coordenação (`Fluent`), conteúdo/snippets (`Fluent.Content`) e execução (`Fluent.Runner`). A página cobre a API pública configurável exposta por `TRickUIBuilder.Label_` / `IRickUIBuilderLabel`, enquanto a Component Page apenas emite a intenção e o Coordinator controla criação, `ShowModal` e liberação.

### DEC-056 — Exemplos `Completo` são exaustivos para a configuração pública

Em cada abordagem concreta, o item `Completo` funciona como referência exaustiva da configuração pública atual. Em Factory, todo campo público do record de configuração usado pelo método deve ser atribuído explicitamente; para Text / Label isso significa todos os campos de `TRickUIBuilderTextConfig`. Em Fluent Builder, todos os métodos públicos configuráveis da interface devem ser chamados; records auxiliares usados na cadeia devem ter todas as opções/campos relevantes explicitados. Para `TRickUIBuilderSpacing`, Left, Top, Right e Bottom são informados por `Create`. Expansão futura da API invalida a cobertura até que snippet, Runner e documentação sejam atualizados.

### DEC-057 — Button - Factory é o terceiro destino concreto da Sample Page

`TExampleButtonFactory` herda de `TExampleCommon` e fica em `src/Examples/Button/Factory`, separando coordenação (`Factory`), conteúdo/snippets (`Factory.Content`) e execução (`Factory.Runner`). A página possui oito exemplos: Básico, Geometria, Cores, Tipografia, Identificação, Caption interno, Clique e Completo. O exemplo Clique configura `OnClick` no `TRectangle` retornado por `CreateButton` e altera sua cor como feedback real; `OnClick` não é tratado como campo de `TRickUIBuilderButtonConfig`.

### DEC-058 — Examples concretos são organizados por componente e abordagem

Páginas reais da terceira camada seguem `samples/src/Examples/<Componente>/<Abordagem>`. Text / Label, Button, Badge, Divider e ComboBox mantêm `Factory/` e `Fluent/`; Edit mantém somente `Fluent/`. Diretórios de abordagem sem implementação não são criados. `Button - Factory` mantém o exemplo `Completo` exaustivo para os nove campos públicos de `TRickUIBuilderButtonConfig` e demonstra também as duas sobrecargas públicas de `CreateButton`. `Button - Fluent Builder` mantém dois exemplos completos: um direto e outro por interfaces; ambos cobrem os 23 métodos configuráveis de `IRickUIBuilderButton`.

### DEC-059 — Badge - Factory é o quinto destino concreto da Sample Page

`TExampleBadgeFactory` herda de `TExampleCommon` e fica em `src/Examples/Badge/Factory`, separando coordenação (`Factory`), conteúdo/snippets (`Factory.Content`) e execução (`Factory.Runner`). A página possui sete exemplos: Básico, Geometria, Cores, Tipografia, Texto interno, Construção em etapas e Completo. `CreateBadge` permanece a operação principal; as APIs públicas auxiliares `CreateBadgeContainer` e `BuildBadgeTextConfig` aparecem somente no exemplo de construção em etapas. O exemplo `Completo` atribui explicitamente os sete campos públicos de `TRickUIBuilderBadgeConfig`.

### DEC-060 — Badge - Fluent Builder é o sexto destino concreto da Sample Page

`TExampleBadgeFluent` herda de `TExampleCommon` e fica em `src/Examples/Badge/Fluent`, separando coordenação (`Fluent`), conteúdo/snippets (`Fluent.Content`) e execução (`Fluent.Runner`). A página possui onze exemplos: Básico, Interface, Geometria, Forma, Layout, Aparência, Tipografia, Estado, Resultado, Completo - Direto e Completo - Interfaces. `IRickUIBuilderBadge` é a API principal documentada e `IRickUIBuilderBadgeHandle` aparece somente como resultado de `Build`. Os dois exemplos completos cobrem os quinze métodos configuráveis; usam `Pill(False)` antes de `CornerRadius` para que ambos sejam exercitados com efeito real.

### DEC-061 — Divider - Factory é o sétimo destino concreto da Sample Page

`TExampleDividerFactory` herda de `TExampleCommon` e fica em `src/Examples/Divider/Factory`, separando coordenação (`Factory`), conteúdo/snippets (`Factory.Content`) e execução (`Factory.Runner`). A página possui quatro exemplos: Básico, Geometria, Cor e Completo. `CreateDivider` permanece a operação Factory documentada; o exemplo `Completo` atribui explicitamente `Left`, `Top`, `Width` e `Color` de `TRickUIBuilderDividerConfig`. A Component Page habilita Factory e Fluent Builder somente quando seus destinos concretos existem.


### DEC-062 — Divider - Fluent Builder é o oitavo destino concreto da Sample Page

`TExampleDividerFluent` herda de `TExampleCommon` e fica em `src/Examples/Divider/Fluent`, separando coordenação (`Fluent`), conteúdo/snippets (`Fluent.Content`) e execução (`Fluent.Runner`). A página possui nove exemplos: Básico, Interface, Geometria, Orientação, Layout, Aparência, Estado, Completo - Direto e Completo - Interfaces. `IRickUIBuilderDivider` é a API principal documentada; `TOrientation` e `TRickUIBuilderSpacing` aparecem apenas como tipos auxiliares dos métodos públicos. Os dois exemplos completos cobrem os oito métodos configuráveis, e a Component Page encaminha Factory e Fluent Builder por callbacks distintos ao Coordinator.


### DEC-063 — ComboBox - Factory demonstra o runtime funcional público

`TExampleComboBoxFactory` herda de `TExampleCommon` e fica em `src/Examples/ComboBox/Factory`, separando coordenação (`Factory`), conteúdo/snippets (`Factory.Content`) e execução (`Factory.Runner`). A página possui quinze exemplos: Básico, Texto + Value, Lista estruturada, Seleção inicial, Geometria e forma, Tipografia e texto, Cores, Seta, Estado, Desktop / Anchored, FullWindow e pesquisa, Eventos, Customização de item, Handle runtime e Completo. Todos usam a API Factory funcional real com `TRickUIBuilderComboBoxFactoryOptions` e `IRickUIBuilderComboBoxHandle`; o Runner é uma instância mantida pela página para callbacks `of object`. O exemplo `Completo` atribui 58/58 campos públicos de `TRickUIBuilderComboBoxConfig` e todos os campos públicos de `TRickUIBuilderComboBoxFactoryOptions`.

### DEC-064 — ComboBox - Fluent Builder demonstra dados, apresentação e runtime reais

`TExampleComboBoxFluent` herda de `TExampleCommon` e fica em `src/Examples/ComboBox/Fluent`, separando coordenação (`Fluent`), conteúdo/snippets (`Fluent.Content`) e execução (`Fluent.Runner`). A página possui quinze exemplos: Básico, Interface, Texto + Value, Lista estruturada, Seleção inicial, Geometria e popup, Desktop / Anchored, FullWindow e pesquisa, Configuração avançada, Seta, Estado, Eventos, Customização de item, Handle runtime e Completo. Todos os exemplos materializam dados reais; a matriz varia `Items`, os dois overloads de `AddItem`, `AddStructuredItem`, colunas `Auto`/`Fixed`/`Proportional`, seleção por índice/texto, presentation, pesquisa, callbacks e `IRickUIBuilderComboBoxHandle`. O Runner é uma instância mantida pela Sample Page para que callbacks `of object` permaneçam válidos sem `TComponent` auxiliar. O exemplo `Completo` atribui os 58 campos públicos de `TRickUIBuilderComboBoxConfig`, cobre os 32 métodos configuráveis de `IRickUIBuilderComboBox` e finaliza pela assinatura mais rica `BuildHandle`.


### DEC-065 — Edit - Fluent Builder cobre presets, validação e runtime

`TExampleEditFluent` herda de `TExampleCommon` e fica em `src/Examples/Edit/Fluent`, separando coordenação (`Fluent`), conteúdo/snippets (`Fluent.Content`) e execução (`Fluent.Runner`). A página possui vinte e nove exemplos: Básico, Interface, um exemplo individual para cada um dos 14 presets públicos, CaseMode, Obrigatoriedade, Limite/contador/limpar, Senha, Feedback inválido, Indicador de requisito, Copiar e colar mascarado, Aparência, Somente leitura, Customização visual, Handle runtime e Completo. O fluxo de clipboard preserva os cenários operacionais de CPF/CNPJ do Sample legado. O Runner é uma instância mantida pela Sample Page para que handlers de botões permaneçam válidos sem `TComponent` auxiliar; `Reset` libera referências a handles antes de `ClearResult`. O exemplo `Completo` cobre os 62 métodos configuráveis de `IRickUIBuilderEdit` e finaliza com `Build`. Edit continua sem Factory porque a API pública não expõe `Factory.CreateEdit`.

### DEC-066 — Sample Page usa layout padrão com especialização controlada por herança

`RickUIBuilder.Samples.Example.Common.Style` passa a definir `TExamplePageLayout`, record específico da infraestrutura de `Examples/Common`. Ele mantém apenas `PageWidth`, `PageHeight`, `NavigationWidth` e `NavigationItemHeight` como valores primários; larguras e alturas dependentes são calculadas pela própria infraestrutura. O tipo não é colocado em `RickUIBuilder.Samples.App.Types`, que permanece responsável pelos enums compartilhados de navegação/examples.

`TExampleCommon` inicializa `TExamplePageLayout.Default` (`620 × 510`, navegação `142`, item `28`) e chama o hook protegido virtual `ConfigureLayout(var ALayout)` antes de construir controles. A base não altera esses defaults. Derivadas podem sobrescrever o hook somente quando houver necessidade concreta de UI/UX, sem depender de campos próprios ainda não inicializados e mantendo a janela estritamente menor que a Home de `644 × 534`.

No estado atual, `TExampleButtonFluent` especializa a geometria para `640 × 530` com navegação de `170` px, enquanto `TExampleBadgeFactory`, `TExampleBadgeFluent`, `TExampleDividerFluent` e `TExampleEditFluent` usam `640 × 510` com navegação de `170` px; `TExampleComboBoxFactory` e `TExampleComboBoxFluent` usam `640 × 510` com navegação de `180` px; nas sete páginas o item permanece com `28` px. As demais Sample Pages não sobrescrevem o hook e preservam exatamente o layout padrão. A especialização não autoriza cada derivada a manipular diretamente controles internos ou métricas derivadas da base.

### DEC-067 — Snippets concretos devem ser reproduzíveis sem helpers privados

Os snippets exibidos em `Código Delphi` devem conter as inicializações necessárias para reproduzir o exemplo e respeitar a ordem real de uso da API. Helpers privados do Runner podem existir para manter a implementação interna dos Samples coesa, mas não podem ser pré-requisito invisível do código apresentado ao leitor. Para ComboBox - Factory, isso inclui inicializar `TRickUIBuilderComboBoxConfig`, `TRickUIBuilderComboBoxFactoryOptions` e o `IRickUIBuilderComboBoxHandle` quando usados, configurar diretamente dados/columns relevantes e somente operar o handle depois de `CreateComboBox`. Callbacks `of object` devem deixar explícito que pertencem a uma instância cujo lifetime cobre o controle.



### DEC-068 — Snippets preservam o contexto real da página e indentação Delphi legível

Os snippets de `Código Delphi` usam o mesmo contexto estrutural do Sample executado. Quando a implementação da página materializa o controle em `ResultHost`, o snippet também usa `ResultHost`; wrappers artificiais como `procedure ... (AHost: TLayout)` não são adicionados somente para tornar o trecho isolado. O objetivo é manter equivalência entre conteúdo exibido e Runner sem introduzir uma API/contexto que não existe na tela.

A formatação do snippet faz parte do contrato documental: indentação de 2 espaços por nível, uma instrução por linha, blocos `var`/`begin`/`end` alinhados e recuo consistente para arrays e chamadas multilinha. Não se usa compactação de múltiplas instruções, espaços artificiais ou escapes para corrigir visualmente a apresentação. O `Content.Code` já deve fornecer texto Delphi corretamente formatado.

No exemplo `ComboBox - Factory / Cores`, `TextColor` é compartilhado pelo controle fechado e pelas rows do popup. Por isso o sample usa `PopupColor`, `HoverColor` e `SelectedColor` com contraste suficiente para o mesmo `TextColor`, vários itens e seleção inicial; assim os estados normal, hover e selecionado podem ser observados de forma funcional sem alterar a biblioteca.
