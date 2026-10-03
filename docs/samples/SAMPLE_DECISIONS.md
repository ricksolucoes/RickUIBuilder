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

A próxima evolução da `TComponentPage` deve seguir a referência visual fornecida para `Button` como modelo de hierarquia, proporção, alinhamento e densidade. O detalhamento implementável fica em `SAMPLE_COMPONENT_PAGE_SPEC.md`, explicitamente marcado como especificação futura até a alteração correspondente chegar ao código.

### DEC-025 — Uma página comum possui seis variações de conteúdo

`TComponentPage` permanece uma única página reutilizável. `Text / Label`, `Button`, `Badge`, `Divider` e `ComboBox` apresentam Factory e Fluent Builder; `Edit` apresenta somente Fluent Builder enquanto `Factory.CreateEdit` não existir. O card único do Edit é centralizado, sem placeholder de Factory.

### DEC-026 — Assets oficiais da Component Page são os SVGs fornecidos

A página usa `factory_24dp_E3E3E3_FILL0_wght400_GRAD0_opsz24.svg` para Factory, `link-03-svgrepo-com.svg` para Fluent Builder e `info_48dp_E3E3E3_FILL0_wght400_GRAD0_opsz48.svg` para o painel informativo. A geometria vetorial é preservada; emoji, caractere Unicode e aproximações desenhadas não substituem esses assets.

### DEC-027 — Referência visual não substitui a verdade técnica do código

Textos técnicos da imagem não são copiados quando divergirem da implementação. Em particular, o Button atual não é documentado como `TButton`: sua implementação é composta por `TRectangle + TLabel`. Títulos, subtítulos e texto de `Sobre este componente` são derivados da API/documentação real do componente.

### DEC-028 — Ação visual exige destino real

`Ver exemplos` representa a ação futura para abrir exemplos de Factory ou Fluent Builder. A aparência de ação não autoriza callback vazio, navegação fictícia ou tela inexistente. A interatividade deve ser habilitada quando houver destino real; qualquer etapa intermediária exclusivamente visual precisa decidir explicitamente o comportamento antes da entrega.

### DEC-029 — Tipografia é preservada na Component Page

A Component Page reutiliza a escala semântica de `App.Typography`: 24 para título, 14 para subtítulo, 16 para título de card, 14 para corpo, 14 para ação e 13 para navegação. Geometria e espaçamento devem acomodar esses tokens sem redução de fonte para mascarar clipping.

### DEC-030 — O painel “Sobre este componente” é obrigatório nas seis variações

Cada estado da `TComponentPage` possui painel informativo inferior com ícone oficial, título `Sobre este componente` e texto curto baseado no comportamento real do componente. O painel não deve antecipar APIs inexistentes nem simplificar detalhes de modo a produzir afirmação tecnicamente falsa.
