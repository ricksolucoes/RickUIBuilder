# RickUIBuilder Samples — Decisões e Aprendizados

## 1. Finalidade

Este documento registra decisões consolidadas, abordagens descartadas, regras técnicas descobertas durante a implementação, pendências e decisões deliberadamente adiadas do projeto `RickUIBuilder.Samples`.

Ele complementa `docs/samples/SAMPLE_ARCHITECTURE.md`.

A arquitetura descreve **como o projeto deve ser organizado**. Este documento registra **por que determinadas decisões foram adotadas, quais alternativas não devem ser repetidas e quais pontos ainda não estão fechados**.

O objetivo é evitar retrabalho e impedir que implementações futuras — humanas ou assistidas por IA — repitam abordagens que já foram analisadas e descartadas.

## 2. Regra de manutenção

Este arquivo deve ser atualizado a cada iteração em que surgir pelo menos um dos seguintes itens:

- nova decisão arquitetural ou estrutural consolidada;
- abordagem analisada e descartada;
- regra técnica confirmada durante a implementação;
- nova pendência relevante;
- resolução de uma pendência existente;
- decisão explicitamente adiada para uma etapa futura.

Não registrar hipótese como decisão.

Uma alternativa discutida, mas ainda não aprovada ou rejeitada, deve permanecer como pendência.

Quando uma pendência for resolvida, sua situação deve ser atualizada neste documento em vez de criar registros contraditórios.

## 3. Decisões consolidadas

### DEC-001 — Arquitetura preparada para crescimento

O projeto `RickUIBuilder.Samples` deve ser estruturado considerando o crescimento futuro do catálogo de componentes, abordagens e cenários.

Adicionar um novo componente ou cenário deve ampliar principalmente a área correspondente, evitando crescimento contínuo de units centrais como a Home.

### DEC-002 — Implementação gradual

A definição da arquitetura não autoriza a criação antecipada de toda a infraestrutura ou de todas as telas previstas.

A implementação será gradual, conforme cada etapa for explicitamente autorizada.

### DEC-003 — Documentação centralizada

Toda documentação do projeto deve permanecer sob a raiz `/docs`.

A documentação específica do aplicativo de samples deve ficar em:

```text
docs/samples/
```

Não criar documentação em `sample/docs`, `samples/docs` ou outras árvores paralelas.

### DEC-004 — Factory e Fluent não são artificialmente simétricos

As áreas Factory e Fluent devem refletir somente as APIs efetivamente disponíveis.

No estado atualmente confirmado:

**Factory**

- Text
- Button
- Badge
- Divider
- ComboBox

**Fluent**

- Label
- Button
- Badge
- Divider
- ComboBox
- Edit

A ausência atual de `Edit` na Factory não deve ser interpretada como proibição arquitetural permanente.

### DEC-005 — Composition é uma abordagem pública própria

Composition deve ser apresentada como uma abordagem própria do sample, baseada na API pública:

```delphi
TRickUIBuilder.On(AParent)
```

Ela não deve ser escondida dentro de Factory ou Fluent.

### DEC-006 — Cenário não implica nova unit

A existência de vários cenários de um componente não justifica automaticamente uma unit para cada cenário.

A separação deve ocorrer somente quando existir responsabilidade suficiente para justificar um novo arquivo.

### DEC-007 — Baixo acoplamento entre features

Features não devem depender lateralmente umas das outras sem necessidade comprovada.

Exemplos de dependências que devem ser evitadas:

```text
Fluent.Edit      -> Home
Factory.Button   -> Fluent.Button
ComboBox         -> Edit
```

Infraestrutura compartilhada pode ser consumida quando fizer parte do boundary arquitetural definido.

### DEC-008 — Primeira Home sem navegação funcional

A primeira implementação da página principal deve apresentar Factory, Fluent Builder e Composition, mas inicialmente sem implementar os links ou a navegação para as telas de destino.

A navegação será introduzida em etapa posterior.

### DEC-009 — Entregas incrementais de arquivos

Cada entrega deve conter somente os arquivos criados ou modificados naquela iteração.

Não reenviar arquivos inalterados apenas para completar a árvore do projeto.

Quando um ZIP for utilizado, seus caminhos devem ser relativos à raiz do repositório para permitir extração diretamente sobre o projeto.

### DEC-010 — Registro contínuo de decisões

Este arquivo, `docs/samples/SAMPLE_DECISIONS.md`, passa a ser o registro persistente das decisões e aprendizados do desenvolvimento do Samples.

Sempre que uma iteração alterar decisões, aprendizados, pendências ou abordagens descartadas, este arquivo deverá acompanhar os demais arquivos modificados da entrega.


### DEC-011 — Boundary interno da primeira Home

A primeira Home passa a possuir tres responsabilidades fisicas separadas, sem antecipar infraestrutura global:

- `RickUIBuilder.Samples.Home.pas`: orquestracao, composicao e layout da pagina;
- `RickUIBuilder.Samples.Home.ApproachCard.pas`: representacao visual das tres abordagens apresentadas exclusivamente na Home;
- `RickUIBuilder.Samples.Home.Style.pas`: tokens e medidas compartilhados somente entre as units da Home.

`Home.ApproachCard` e um boundary especifico da Home. Ele nao deve se transformar em catalogo de componentes nem receber responsabilidades de Factory, Fluent ou Composition.

### DEC-012 — Design System global somente com reutilizacao comprovada

A primeira Home nao cria `App/DesignSystem`. Enquanto os tokens forem consumidos somente pela Home, permanecem em `RickUIBuilder.Samples.Home.Style`.

Quando outras paginas comprovarem reutilizacao transversal, os tokens realmente compartilhados poderao migrar para o Design System do aplicativo. A migracao deve ocorrer por uso real, nao por antecipacao arquitetural.

### DEC-013 — `ApproachCard` usa composicao, contrato fluent e nao conhece as abordagens

`RickUIBuilder.Samples.Home.ApproachCard` e responsavel exclusivamente por configurar e construir a representacao visual comum de um card de abordagem.

A unit nao conhece quais abordagens existem e nao possui metodos especificos para Factory, Fluent Builder ou Composition. O conteudo pertence a `RickUIBuilder.Samples.Home`, que o fornece por meio do contrato fluent `IApproachCard`.

`TApproachCard` mantem somente o estado temporario necessario a configuracao do card e materializa a composicao visual por meio de `Build`. `TRectangle` permanece como detalhe da composicao visual atual e como retorno concreto porque a Home precisa posicionar os cards. Nao existe heranca entre `TApproachCard` e controles FMX.

A interface possui consumidor e responsabilidade concretos nesta feature; sua adocao nao estabelece que toda classe do Samples deva possuir interface.

### DEC-014 — Heranca somente com necessidade comprovada

Heranca no `RickUIBuilder.Samples` somente deve ser introduzida quando existir necessidade comprovada e uma relacao semantica valida de especializacao (`is-a`).

Nao utilizar heranca apenas para reutilizar implementacao, acessar propriedades de controles FMX, simplificar construcao visual, evitar composicao ou reduzir quantidade de codigo.

Na ausencia dessa comprovacao, preferir composicao ou uma solucao mais simples que preserve a responsabilidade real.

### DEC-015 — Documentacao estrutural no cabecalho e declaracao

A documentacao que permite compreender a responsabilidade de uma unit deve estar disponivel antes da `implementation`.

O cabecalho da unit deve apresentar, quando aplicavel, objetivo, responsabilidade, limites e decisoes estruturais relevantes. Tipos e operacoes publicas devem receber XMLDoc junto de suas declaracoes quando a documentacao agregar informacao real.

Comentarios na `implementation` ficam reservados a decisoes locais de implementacao que realmente precisem de explicacao. A `implementation` nao deve ser o local principal para descobrir a finalidade arquitetural da unit ou de sua API.

### DEC-016 — Estrutura obrigatoria para classes que implementam interfaces

Quando uma classe do projeto implementar uma interface seguindo este padrao, sua organizacao deve obedecer a convencao estrutural definida para o projeto:

- os metodos que implementam a interface ficam em `protected`;
- o `constructor Create` fica em `protected`;
- a secao `public` da classe concreta expoe somente `Destroy` e `New`;
- `New` retorna a interface correspondente;
- `Destroy` permanece declarado como parte da convencao, mesmo quando apenas chama `inherited`.

Essa convencao define **como** uma implementacao orientada a interface deve ser estruturada quando a interface tiver necessidade comprovada. Ela nao obriga a criacao de interfaces onde nao exista justificativa arquitetural real.

### DEC-017 — Lifetime do builder e ownership do controle FMX

`TApproachCard` deriva de `TInterfacedObject`; portanto, o lifetime da instancia concreta e controlado por reference counting durante o encadeamento fluent.

O `TRectangle` materializado por `Build` utiliza o `Parent` configurado tambem como Owner. O controle visual pertence ao ownership FMX e nao ao lifetime da interface `IApproachCard`.

A separacao entre lifetime do builder e ownership do controle criado deve permanecer explicita nas futuras implementacoes que adotarem o mesmo modelo.

### DEC-018 — Checklist operacional obrigatoria antes de cada entrega

Toda entrega de codigo deve passar por uma checklist operacional completa antes da geracao do artefato final.

A conferencia nao pode se limitar aos trechos alterados. Todos os arquivos de codigo que serao enviados devem ser revisados integralmente contra as regras aplicaveis do projeto, incluindo documentacao, nomenclatura, dependencias, estrutura, escopo, arquitetura e avaliacao estatica de Method Toxicity Metrics.

Um item somente pode ser considerado atendido depois de ser conferido na versao final que entrara na entrega. Se uma correcao alterar o codigo depois da conferencia, os itens afetados devem ser verificados novamente.

A checklist operacional e parte do Quality Gate da entrega e nao deve ser substituida por uma avaliacao informal.

### DEC-019 — Documentacao de contratos de interface e metodos privados

Quando uma interface fizer parte da implementacao:

- a interface e seus metodos devem possuir XMLDoc junto das declaracoes do contrato;
- os metodos da classe que apenas implementam os mesmos metodos da interface nao precisam repetir a documentacao do contrato;
- metodos privados proprios da classe devem possuir XMLDoc junto de suas declaracoes;
- metodos privados de outras classes do Samples tambem devem ser documentados junto de suas declaracoes;
- documentacao estrutural e de API deve permanecer antes da `implementation`;
- comentarios dentro da `implementation` ficam reservados a decisoes locais que nao sejam adequadamente expressas pelo contrato ou pela declaracao.

Essa regra evita documentacao duplicada nos implementadores de interfaces sem deixar responsabilidades privadas sem explicacao.

## 4. Abordagens descartadas

### DSC-001 — Home monolítica

Não concentrar continuamente na unit da Home:

- composição da tela;
- Design System;
- criação visual detalhada dos cards;
- conteúdo de todas as abordagens;
- navegação futura;
- catálogo futuro de componentes.

Essa direção reproduziria o problema de crescimento monolítico que a reorganização pretende evitar.

### DSC-002 — Apenas deslocar o problema para `Home.Cards`

Criar uma unit `Home.Cards` não é, isoladamente, uma solução arquitetural.

Se ela concentrar indiscriminadamente todos os cards e continuar crescendo com o projeto, apenas transfere a responsabilidade excessiva da Home para outro arquivo.

Uma extração futura deve representar um boundary real e estável.

### DSC-003 — `record` de configuração + classe apenas para três cards

Foi descartada a criação de um `record` usado somente para transportar dados para uma classe construtora dos três cards da Home.

Essa combinação introduziria duas representações para uma responsabilidade pequena sem benefício arquitetural comprovado.

Records continuam permitidos quando houver uma necessidade real de modelagem; esta decisão não proíbe records no projeto.

### DSC-004 — Units excessivamente granulares por cenário

Não criar automaticamente estruturas como:

```text
Edit.CPF.pas
Edit.CNPJ.pas
Edit.Email.pas
Edit.Phone.pas
```

quando os cenários puderem permanecer coesos dentro da responsabilidade do componente.

A divisão deve ser orientada por responsabilidade e crescimento real, não pela quantidade de exemplos.

### DSC-005 — Abstrações antecipadas

Não criar interfaces, factories, services, routers, registros de configuração ou outras abstrações apenas porque poderão ser úteis futuramente.

A arquitetura pode prever boundaries futuros, mas a implementação deve ocorrer somente quando houver responsabilidade e consumidor concretos.

### DSC-006 — `ApproachCard` herdando de `TRectangle` por conveniencia visual

Foi descartada a implementacao de `TSampleHomeApproachCard = class(TRectangle)`.

O card de abordagem nao possui relacao conceitual que exija especializacao de `TRectangle`; o retangulo e apenas sua superficie visual atual. A heranca criava uma hierarquia por conveniencia de implementacao, sem necessidade comprovada.

### DSC-007 — Classe estatica apenas para agrupar a construcao do card

Depois de remover a heranca, tambem foi descartada a criacao de uma classe `sealed` composta somente por `class function`/`class procedure` para construir cards.

Sem estado, identidade, lifetime proprio ou comportamento polimorfico, a classe adicionaria cerimonia sem responsabilidade que a justificasse. A unit `Home.ApproachCard` ja fornece o boundary necessario.

### DSC-008 — `ApproachCard` conhecendo Factory, Fluent e Composition

Foi descartado manter metodos como `CreateFactory`, `CreateFluent` e `CreateComposition` dentro de `Home.ApproachCard`.

Esses metodos fariam o renderer conhecer o catalogo da Home. O conteudo e a existencia das abordagens pertencem a Home; `ApproachCard` conhece somente como representar visualmente os dados recebidos.

## 5. Regras técnicas confirmadas

### TEC-001 — `TBrushKind` requer `FMX.Graphics`

Sempre que uma unit utilizar `TBrushKind`, incluir explicitamente:

```delphi
FMX.Graphics
```

na cláusula `uses` apropriada.

Essa verificação deve fazer parte da revisão das próximas units FMX.

### TEC-002 — Convenção de parâmetros

Parâmetros de métodos Delphi devem iniciar com `A`.

Exemplo:

```delphi
procedure ConfigureCard(ACard: TRectangle);
```

### TEC-003 — Convenção de variáveis locais

Variáveis locais devem iniciar com `L`.

Exemplo:

```delphi
var
  LCard: TRectangle;
```

### TEC-004 — Convenção de campos privados

Campos privados devem iniciar com `F`.

Exemplo:

```delphi
FContent: TLayout;
```

### TEC-005 — Convenção de constantes

Constantes devem utilizar caixa alta e possuir `_` no início e no fim.

Exemplo:

```delphi
_CARD_WIDTH_ = 320;
```

### TEC-006 — Validação real versus análise estática

Não afirmar que:

- o projeto compilou;
- testes passaram;
- não existem regressões;
- não existem memory leaks;
- o código está thread-safe;
- Method Toxicity Metrics foi aprovado;

sem execução real correspondente.

Quando RAD Studio/CSV de Method Toxicity não for executado, qualquer avaliação de `Length`, `Parameters`, `If Depth` e `Cyclomatic Complexity` deve ser identificada como avaliação estática.

O valor composto de `Toxicity` não deve ser inventado.

## 6. Pendências atuais

### PEN-001 — Comportamento responsivo da Home

A primeira Home preserva os tres cards em uma unica linha. O comportamento para larguras menores — wrap, scroll ou outra estrategia — ainda nao foi definido.

Nao tratar o layout atual para janelas estreitas como decisao definitiva de UX.

### PEN-002 — Boundary dos elementos visuais reutilizáveis

Ainda deve ser confirmado, a partir da implementação real das primeiras telas, quais elementos visuais justificam reutilização compartilhada e quais pertencem exclusivamente a uma página.

Não antecipar componentes compartilhados sem evidência de reutilização.

### PEN-003 — Implementação da navegação

A arquitetura prevê navegação entre Home, Factory, Fluent e Composition, mas sua implementação concreta ainda não foi autorizada.

A primeira Home permanecerá sem links funcionais.

### PEN-004 — Estrutura concreta das páginas de abordagem

As estruturas internas das páginas Factory, Fluent e Composition serão definidas gradualmente quando cada área entrar em implementação.

A arquitetura geral não deve ser usada para inventar antecipadamente suas classes ou APIs.

## 7. Decisões futuras

### FUT-001 — `Factory.Edit`

A Factory atualmente confirmada não expõe `CreateEdit`.

O componente Edit está em evolução e sua eventual disponibilidade na Factory permanece:

**Não confirmado.**

Se a API pública mudar futuramente, a estrutura e a documentação do Samples deverão ser revisadas com base no código real existente naquele momento.

## 8. Checklist operacional obrigatoria para proximas iteracoes

Antes de concluir e empacotar qualquer entrega do Samples, conferir **todos os arquivos de codigo que serao enviados**, utilizando a versao final de cada arquivo.

### Escopo e entrega

- o escopo autorizado foi respeitado;
- somente arquivos necessarios foram alterados;
- o ZIP contem somente arquivos criados ou modificados na iteracao;
- os caminhos do ZIP sao relativos a raiz do repositorio;
- nenhuma funcionalidade, abstracao ou infraestrutura futura foi implementada sem autorizacao.

### Documentacao

- toda unit enviada possui cabecalho que explica objetivo, responsabilidade e limites quando aplicavel;
- a documentacao estrutural esta antes da `implementation`;
- classes e contratos relevantes possuem XMLDoc junto de suas declaracoes;
- todos os metodos privados possuem XMLDoc junto de suas declaracoes;
- cada metodo declarado em uma interface possui XMLDoc no contrato;
- metodos da classe que apenas implementam a interface nao duplicam obrigatoriamente o XMLDoc ja existente no contrato;
- documentacao existente corresponde ao comportamento realmente implementado;
- nao existem blocos XMLDoc malformados ou parcialmente comentados.

### Estrutura e arquitetura

- responsabilidades das units continuam claras;
- dependencias entre features permanecem controladas;
- heranca existe somente quando houver necessidade comprovada e relacao `is-a`;
- interfaces e outras abstracoes possuem responsabilidade e consumidor concretos;
- classes que implementam interfaces seguem a convencao do projeto: metodos da interface e `Create` em `protected`, `public` somente com `Destroy` e `New`;
- lifetime, ownership e reference counting permanecem coerentes com os contratos utilizados.

### Delphi e nomenclatura

- `uses` contem as dependencias realmente necessarias;
- `FMX.Graphics` esta presente quando `TBrushKind` for utilizado;
- parametros seguem `A...`;
- variaveis locais seguem `L...`;
- campos privados seguem `F...`;
- constantes seguem `_NOME_`;
- identificadores continuam semanticamente coerentes com sua responsabilidade.

### Method Toxicity Metrics e validacao

- todo codigo Delphi enviado foi avaliado estaticamente quanto a `Length`, `Parameters`, `If Depth` e `Cyclomatic Complexity`;
- nao foi introduzida nova toxicidade evidente nem agravada toxicidade existente;
- nenhuma abstracao cosmetica foi criada apenas para reduzir metricas;
- build, testes e Method Toxicity Metrics real somente sao declarados quando efetivamente executados;
- o valor composto de `Toxicity` nao e inventado quando o RAD Studio/CSV nao foi executado.

### Registro e revalidacao

- este documento foi atualizado quando a iteracao produziu nova decisao, descarte, regra tecnica ou pendencia;
- depois da ultima alteracao de codigo, os itens afetados da checklist foram conferidos novamente;
- somente depois dessa conferencia a entrega pode ser considerada pronta para empacotamento.

---

Este documento deve permanecer factual e acompanhar o estado real do projeto. Decisões futuras não devem ser registradas como implementadas antes de existirem no código ou de serem explicitamente aprovadas.
