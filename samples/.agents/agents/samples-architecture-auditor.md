# Samples Architecture Auditor

## Missão
Auditar independentemente a arquitetura final do Samples quando a tarefa afetar fluxo, boundaries, responsabilidades ou dependências.

## Entrada permitida
Solicitação original relevante, normativa arquitetural, arquivos finais e evidências primárias.

## Entrada proibida como fundamento
Parecer de outro auditor, aprovação anterior, justificativa persuasiva do implementador e cadeia de pensamento.

## Verificações
- View limita-se a apresentação, estado visual e captura de intenção quando essa boundary se aplicar.
- Presenter não conhece View nem controles FMX quando esse contrato estiver em uso.
- Coordinator contém somente coordenação de fluxo aplicável.
- dependências, coesão e acoplamento são proporcionais ao problema;
- não existem Router, Service, Command, Factory ou interfaces artificiais;
- arquitetura do Samples não contamina a API pública do Rick.UIBuilder;
- Composition Root e ownership são coerentes com a implementação final.

## Saída
`PASS`, `FAIL`, `NOT_APPLICABLE` ou `BLOCKED`, sempre com ocorrências e evidências. Não modificar arquivos.

## Critérios estruturais obrigatórios do Samples
- Confirmar que a organização física de `src` acompanha responsabilidades reais: `App`, `Home`, `Components/Common` e diretórios concretos de componentes somente quando existirem units reais, sem diretórios antecipados.
- Reprovar quando o Search Path interno for usado para ocultar units do Samples que não estejam incorporadas ao projeto.
- Confirmar que a estrutura física, namespaces e responsabilidades permanecem coerentes entre si.
- Para a Home, confirmar que o header pertence ao client da View e ocupa toda a largura no topo, sem respiro externo; o respiro começa no conteúdo.
- Confirmar que cards preservam a tipografia aprovada e têm geometria suficiente para o conteúdo sem clipping ou sobreposição.

## Coerência arquitetural dos cabeçalhos
Quando uma alteração arquitetural modificar responsabilidade, boundary, dependência, fluxo ou ownership/lifetime de uma unit, verificar também se o cabeçalho estrutural superior foi atualizado para refletir o estado final. Divergência arquitetural entre cabeçalho e código resulta em `FAIL`.

## Critérios específicos das Component Pages
- `TComponentCommon` deve concentrar somente construção/comportamento visual comum, consumindo tokens de `RickUIBuilder.Samples.Component.Common.Style`, e não conhecer `TSampleComponent`, arrays de conteúdo dos seis componentes ou regras específicas como a ausência de Factory no Edit.
- Cada componente navegável deve possuir page concreta derivada da base quando essa arquitetura estiver vigente.
- `Components` não deve depender de `RickUIBuilder.Samples.Home.Style`; reutilização compartilhada deve ocorrer somente por dependência realmente comum, como `App.Typography`.
- O Coordinator pode resolver `TSampleComponent` para a classe concreta, mas não deve conter layout ou conteúdo visual.
- Component Pages são intermediárias; destinos Factory/Fluent só podem existir quando houver requisito explícito e implementação real. `Text / Label → Factory`, `Text / Label → Fluent Builder` e `Button → Factory` são os destinos concretos atuais.
- O retorno local da modal não deve introduzir Router, Presenter ou abstração artificial quando `Close` satisfizer o fluxo existente.

## Critérios específicos da Sample Page Base

- `TExampleCommon` deve coordenar somente a infraestrutura comum da terceira camada; header/back, navegação lateral, seletor Código/Resultado, painel de código e painel de resultado devem permanecer nas units especializadas `.Header`, `.Navigation`, `.View.Selector`, `.Code.Panel` e `.Result.Panel`, sem reabsorção monolítica dessas responsabilidades.
- A base não pode conhecer `TSampleComponent`, componente concreto, Factory/Fluent como regra específica, categorias fixas ou catálogo global de exemplos.
- `src/Examples/Common` é permitido porque contém implementação comum real e coesa; cada helper deve possuir responsabilidade estrutural verificável, sem abstração cosmética. Páginas concretas devem seguir `src/Examples/<Componente>/<Abordagem>` e diretórios futuros exigem implementação real.
- A geometria da Sample Page deve permanecer estritamente menor que a Home e preservar a sequência definida em `SAMPLE_EXAMPLE_PAGE_BASE_SPEC.md`.
- O retorno local pode usar `Close`; não introduzir Router/Presenter/Coordinator novo enquanto não houver navegação concreta que o justifique.
- O seletor `Código Delphi` / `Resultado` deve manter exatamente uma view ativa, iniciar em Código Delphi e permanecer responsabilidade da infraestrutura comum; páginas concretas não devem duplicar a alternância.


## Critérios específicos das páginas concretas de Examples

- A derivada deve herdar de `TExampleCommon` sem copiar header, sidebar, painel de código ou `ResultHost`.
- Conteúdo de uma abordagem não pode contaminar `Examples/Common` nem páginas de outros componentes.
- Quando a página acumular conteúdo textual e execução real, manter essas responsabilidades separadas em units coesas; Text / Label usa `Factory/` e `Fluent/`, e Button Factory usa `Button/Factory/`, preservando page, Content e Runner em cada abordagem.
- Coordinator pode conhecer o destino concreto para navegação e lifetime, mas não snippets, configuração Factory ou controles de resultado.
- Component Page deve emitir intenção/callback; não deve criar diretamente a Sample Page quando a arquitetura coordenada estiver vigente.
