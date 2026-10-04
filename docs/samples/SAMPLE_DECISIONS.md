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

Toda unit `.pas` criada ou modificada no Samples deve iniciar com um cabeçalho documental estrutural, produzido a partir da implementação final. O cabeçalho serve como mapa local para manutenção humana e para análise por IA, mas nunca substitui a leitura do código.

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

`Ver exemplos` representa a ação futura para abrir exemplos de Factory ou Fluent Builder. Enquanto essas páginas não existirem, o elemento permanece somente visual, sem callback vazio, `crHandPoint` ou navegação fictícia.

### DEC-029 — Tipografia é preservada na Component Page

A Component Page reutiliza a escala semântica de `App.Typography`: 24 para título, 14 para subtítulo, 16 para título de card, 14 para corpo, 14 para ação e 13 para navegação. Geometria e espaçamento devem acomodar esses tokens sem redução de fonte para mascarar clipping.

### DEC-030 — O painel “Sobre este componente” é obrigatório nas seis páginas

Cada página concreta possui painel informativo inferior com ícone oficial, título `Sobre este componente` e texto curto baseado no comportamento real do componente. O painel não deve antecipar APIs inexistentes nem simplificar detalhes de modo a produzir afirmação tecnicamente falsa.

### DEC-031 — Cada componente possui uma página concreta

`Text / Label`, `Button`, `Badge`, `Divider`, `ComboBox` e `Edit` possuem classes próprias herdando de `TComponentCommon`. A classe-base concentra somente layout e comportamento comum; cada derivada decide seu conteúdo e quais abordagens aparecem.

### DEC-032 — Component Page é somente a divisão para Factory e Fluent Builder

As páginas concretas atuais são intermediárias. Elas não contêm os samples finais de Factory/Fluent Builder e não criam as páginas posteriores. Esses destinos serão implementados em etapa futura.

### DEC-033 — Component Page é borderless e o retorno fecha a modal

A família de páginas utiliza `TFmxFormBorderStyle.None`, seguindo o padrão visual da Home. A seta superior esquerda possui hit area própria e fecha a janela modal atual; o Coordinator continua responsável por liberar a instância após `ShowModal`.

### DEC-034 — Components não depende de `Home.Style`

A família de Component Pages mantém geometria e paleta local em `RickUIBuilder.Samples.Component.Common.Style`, consumida por `TComponentCommon`, e reutiliza a tipografia global de `App.Typography`. A feature de Components não deve depender de `RickUIBuilder.Samples.Home.Style`.

### DEC-035 — A página de exemplos possui uma base visual própria

A próxima camada de navegação terá uma Sample Page Base própria, distinta da Home e da Component Page. Ela será reutilizada por herança pelas futuras páginas concretas de exemplos, sem centralizar regras específicas de componentes ou abordagens. Esta decisão está especificada, mas ainda não implementada.

### DEC-036 — Sample Page permanece menor que a Home

A família de páginas de exemplos deve permanecer estritamente menor que a Home. No baseline atual, a Home usa referência de `644 × 534`; a implementação futura deve escolher dimensões inferiores a esses limites e tratar excesso de conteúdo dentro das regiões apropriadas, sem aumentar a janela acima da Home e sem reduzir tipografia para mascarar clipping.

### DEC-037 — O textframe fixa a sequência estrutural da Sample Page

O Design System pode fornecer tokens e componentes visuais, mas não pode alterar a ordem estrutural definida em `SAMPLE_EXAMPLE_PAGE_BASE_SPEC.md`: header/back → identidade da página → corpo dividido em navegação lateral e conteúdo → identificação do exemplo → seletor visual local → superfície de código → área de resultado executável. Mudança nessa sequência exige decisão documental explícita.

### DEC-038 — Conteúdo e execução pertencem às páginas derivadas

A Sample Page Base fornece apenas infraestrutura comum. A página derivada de cada componente/abordagem define categorias, exemplos, código Delphi apresentado e execução do resultado. A base não contém `case/if` por componente, catálogo global de exemplos nem regras específicas de Factory ou Fluent Builder.

### DEC-039 — Back da Sample Page retorna à Component Page de origem

O header da futura página de exemplos preserva o contexto do componente pai. Exemplo: `Button - Factory` exibe `Button` no header e o retorno encerra somente essa página, devolvendo o usuário à Component Page de Button; a Component Page continua responsável por retornar à Home.

### DEC-040 — Cobertura de exemplos deriva da API pública real

Quando uma página concreta de exemplos for implementada, sua cobertura deve ser levantada a partir da API pública real daquele componente e daquela abordagem no código vigente. Todas as funcionalidades públicas relevantes devem estar representadas por exemplos individuais ou compostos. A Sample Page Base não fixa antecipadamente categorias como `Básico`, `Estilo`, `Ícones` ou `Estados`; esses nomes pertencem às páginas concretas quando sustentados pela API real.

### DEC-041 — Referência visual não autoriza comportamento não confirmado

Elementos presentes no mockup preservam posição, hierarquia e intenção visual, mas comportamentos não confirmados não são inventados. Em especial, a faixa visual `Código Delphi` / `Resultado` é reservada na estrutura; sua semântica de alternância só será implementada quando houver requisito explícito ou confirmação durante a implementação da primeira página concreta.

