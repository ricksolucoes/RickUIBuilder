# Backlog de Implementação --- Edit Runtime

**Projeto:** RickUIBuilder\
**Feature:** `Edit` runtime\
**Status:** registro histórico do planejamento pré-implementação\
**Documento relacionado:**
`edit-runtime.pt-BR.md`

> Este backlog preserva o planejamento original da implementação. O componente `Edit` já existe no código atual; os estados iniciais e itens abaixo não representam o status corrente da implementação. Não inferir conclusão item a item sem evidência específica; para o comportamento atual, consultar o código e `docs/edit/`.

------------------------------------------------------------------------

## Convenções

### Estados

-   **Pendente** --- ainda não iniciado.
-   **Bloqueado** --- depende de decisão ou item anterior.
-   **Em andamento** --- implementação/análise iniciada.
-   **Em auditoria** --- aguardando ou executando revisão técnica.
-   **Concluído** --- critérios de aceite e Definition of Done
    atendidos.

### Regras gerais

-   Não implementar requisitos não definidos.
-   Quando uma informação necessária não puder ser confirmada: **Não
    confirmado.**
-   Aplicar alteração mínima necessária.
-   Preservar contratos e comportamento existentes fora do escopo.
-   Não afirmar build, testes ou métricas como aprovados sem execução
    real.
-   Todo código Delphi criado ou alterado deverá considerar Method
    Toxicity Metrics.
-   Itens que alterem API, arquitetura ou lifetime devem passar por
    auditoria técnica.

------------------------------------------------------------------------

# ÉPICO E00 --- Fechamento das decisões funcionais

**Objetivo:** eliminar ambiguidades funcionais que impedem implementação
determinística.

**Estado inicial:** Pendente\
**Gate:** obrigatório antes dos itens dependentes.

## BL-00.01 --- Ícone de requisito não atendido

**Objetivo:** confirmar se
`unpublished_62dp_E3E3E3_FILL0_wght400_GRAD0_opsz48.svg` representa
requisito não atendido.

**Critérios de aceite:**

-   associação confirmada ou rejeitada explicitamente;
-   especificação atualizada com a decisão;
-   nenhuma associação inferida pelo código.

## BL-00.02 --- Máscara CPF

Definir formalmente:

-   caracteres aceitos;
-   formato visual;
-   quantidade máxima de dígitos;
-   comportamento durante digitação;
-   comportamento durante remoção;
-   comportamento no paste.

**Critério de aceite:** regra suficientemente precisa para implementação
e testes determinísticos.

## BL-00.03 --- Máscara CNPJ

Aplicar os mesmos pontos de definição do CPF.

## BL-00.04 --- Máscara CEP

Aplicar os mesmos pontos de definição das máscaras anteriores.

## BL-00.05 --- Máscara Telefone

Definir formato e regras de entrada sem presumir formato regional não
especificado.

## BL-00.06 --- Máscara Celular

Definir formato e regras de entrada sem presumir formato regional não
especificado.

## BL-00.07 --- Número inteiro

Definir:

-   suporte ou não a sinal;
-   tratamento de zero;
-   caracteres permitidos;
-   comportamento de paste;
-   demais regras necessárias.

## BL-00.08 --- Número Float

Definir:

-   separador decimal;
-   quantidade configurável de casas;
-   suporte ou não a negativos;
-   separador de milhares, se existir;
-   comportamento regional;
-   estados intermediários válidos durante digitação.

## BL-00.09 --- Site/URL

Definir quais partes recebem lowercase:

-   scheme;
-   host;
-   port;
-   path;
-   query;
-   fragment.

A regra deve preservar a capitalização das partes que não forem
autorizadas para conversão.

## BL-00.10 --- Pontuação

Definir o conjunto de caracteres considerado pontuação nos presets
textuais.

## BL-00.11 --- Feedback de entrada inválida

Definir contrato para:

-   alerta;
-   ícone;
-   ambos;
-   configuração/default correspondente.

## Definition of Done do Épico

-   todas as decisões necessárias aos presets e feedback estão fechadas;
-   a especificação está sincronizada;
-   nenhuma decisão funcional bloqueante permanece implícita.

------------------------------------------------------------------------

# ÉPICO E01 --- Contrato público e arquitetura

**Objetivo:** definir como o `Edit` será exposto e mantido em runtime
sem copiar mecanicamente a arquitetura de outro componente.

**Dependência:** E00 para decisões que afetem contrato público.

## BL-01.01 --- Mapear pontos reais de integração

Analisar no código atual:

-   Facade;
-   Types;
-   Interfaces;
-   Factory;
-   builders existentes;
-   handles existentes;
-   behaviors existentes;
-   package/project;
-   testes;
-   convenções de documentação.

**Critérios de aceite:**

-   pontos que realmente precisam mudar identificados;
-   pontos que não precisam mudar explicitamente excluídos;
-   nenhuma unit nova criada por antecipação.

## BL-01.02 --- Definir API fluente

Definir somente os métodos necessários para os requisitos aprovados.

Considerar:

-   criação;
-   texto inicial;
-   label/hint;
-   presets;
-   limite;
-   contador;
-   senha;
-   clear;
-   ícones;
-   validação;
-   estados;
-   eventos aprovados.

**Critério de aceite:** API cobre os requisitos sem expor abstrações sem
responsabilidade real.

## BL-01.03 --- Definir Types

Avaliar e definir, quando justificados:

-   records;
-   enums;
-   aliases;
-   defaults;
-   configurações visuais;
-   configuração de input.

## BL-01.04 --- Definir retorno de Build

Decidir com base na necessidade real:

-   retorno do controle visual;
-   `BuildHandle`;
-   Handle;
-   outra estratégia compatível com a arquitetura existente.

Não criar Handle apenas por analogia com `ComboBox`, `Button` ou
`Badge`.

## BL-01.05 --- Definir ownership e lifetime

Documentar tecnicamente:

-   `Owner`;
-   `Parent`;
-   objetos auxiliares;
-   lifetime dos `TPath`;
-   callbacks;
-   referências de interfaces;
-   eventual Handle/Behavior;
-   destruição do Parent;
-   detach;
-   prevenção de referências dangling;
-   prevenção de ciclos de reference counting.

## BL-01.06 --- Revisão arquitetural

Executar uma passagem de auditoria separada da definição inicial.

Verificar:

-   coesão;
-   acoplamento;
-   compatibilidade com o projeto;
-   necessidade real de cada abstração;
-   superfície pública;
-   riscos de lifetime;
-   impacto nos contratos existentes.

## Definition of Done do Épico

-   contrato público definido;
-   arquitetura justificada pelo código real;
-   lifetime definido;
-   auditoria arquitetural sem pendência bloqueante.

------------------------------------------------------------------------

# ÉPICO E02 --- Núcleo de filtragem e transformação

**Objetivo:** implementar a lógica compartilhável de entrada somente se
a arquitetura aprovada confirmar responsabilidade própria.

**Dependência:** E01.

## BL-02.01 --- Modelo de política de entrada

Implementar a representação aprovada para determinar:

-   caracteres permitidos;
-   transformação;
-   limite;
-   preset;
-   regras específicas.

## BL-02.02 --- Filtragem de caracteres

Implementar a lógica necessária para validar entrada sem depender de
comportamento visual quando tecnicamente possível.

## BL-02.03 --- Uppercase

Implementar conversão automática conforme contrato.

## BL-02.04 --- Lowercase

Implementar conversão automática conforme contrato.

## BL-02.05 --- Limite

Implementar regra de limite reutilizável pela entrada e pelo paste.

## BL-02.06 --- Avaliação estática de toxicidade

Revisar:

-   `Length`;
-   `Parameters`;
-   `If Depth`;
-   `Cyclomatic Complexity`.

Não calcular nem inventar `Toxicity` composto.

## Definition of Done do Épico

-   núcleo implementado conforme arquitetura aprovada;
-   sem comportamento visual indevidamente acoplado;
-   regras cobertas por testes unitários quando aplicável;
-   nenhuma nova violação estática conhecida introduzida.

------------------------------------------------------------------------

# ÉPICO E03 --- Presets de entrada

**Objetivo:** implementar os presets definidos na especificação.

**Dependências:** E00 e E02.

## BL-03.01 --- CPF

Implementar exatamente a regra aprovada no BL-00.02.

## BL-03.02 --- CNPJ

Implementar exatamente a regra aprovada no BL-00.03.

## BL-03.03 --- CEP

Implementar exatamente a regra aprovada no BL-00.04.

## BL-03.04 --- E-mail

Implementar:

-   regras de caracteres aprovadas;
-   lowercase automático.

Não adicionar validação semântica não aprovada.

## BL-03.05 --- Site/URL

Implementar lowercase somente nas partes aprovadas no BL-00.09.

Preservar capitalização das demais partes.

## BL-03.06 --- Telefone

Implementar a máscara aprovada no BL-00.05.

## BL-03.07 --- Celular

Implementar a máscara aprovada no BL-00.06.

## BL-03.08 --- Número inteiro

Implementar o contrato aprovado no BL-00.07.

## BL-03.09 --- Número Float

Implementar:

-   regras aprovadas;
-   quantidade configurável de casas decimais.

## BL-03.10 --- Texto sem acentos e sem pontuação habilitada

Permitir espaço conforme requisito.

## BL-03.11 --- Texto sem acentos e com pontuação

Usar exclusivamente o conjunto aprovado no BL-00.10.

## BL-03.12 --- Texto com acentos e sem pontuação habilitada

Permitir espaço e caracteres acentuados conforme contrato aprovado.

## BL-03.13 --- Texto com acentos e pontuação

Usar o conjunto de pontuação aprovado.

## BL-03.14 --- Todos os caracteres

Não aplicar filtros dos presets textuais, preservando configurações
independentes como limite.

## Definition of Done do Épico

-   todos os presets aprovados implementados;
-   testes determinísticos para regras de entrada;
-   nenhum comportamento adicional inventado.

------------------------------------------------------------------------

# ÉPICO E04 --- Componente visual single-line

**Objetivo:** implementar a composição FMX runtime do `Edit`.

**Dependência:** E01.

## BL-04.01 --- Estrutura visual base

Criar somente os controles necessários à composição aprovada.

Definir corretamente:

-   `Owner`;
-   `Parent`;
-   alinhamento;
-   hit testing;
-   ordem visual;
-   criação e destruição.

## BL-04.02 --- Estado normal

Implementar aparência normal conforme configuração aprovada.

## BL-04.03 --- Estado de foco

Implementar transição visual de foco sem prejudicar edição nativa.

## BL-04.04 --- Estado inválido

Implementar estado visual de erro/invalidade e integração com
mensagem/ícone quando configurados.

## BL-04.05 --- Label/Hint

Implementar comportamento aprovado a partir das referências e do
contrato público.

## BL-04.06 --- Garantir single-line

Validar que:

-   não existe modo multiline;
-   não existe propriedade pública para multiline;
-   nenhuma dependência de `TMemo` foi introduzida para fornecer
    multiline.

## Definition of Done do Épico

-   controle criado em runtime;
-   single-line preservado;
-   estados visuais funcionais;
-   ownership/lifetime coerentes com E01.

------------------------------------------------------------------------

# ÉPICO E05 --- Ícones TPath

**Objetivo:** integrar os recursos SVG aprovados usando `TPath`.

**Dependências:** E01 e E04.

## BL-05.01 --- Infraestrutura de ícone

Implementar a estratégia aprovada para carregar/configurar `TPath` sem
criar framework paralelo de ícones.

## BL-05.02 --- Alerta

Integrar `check_alert...svg`.

## BL-05.03 --- Clear

Integrar `cancel...svg`.

## BL-05.04 --- Mostrar senha

Integrar `visibility...svg`.

## BL-05.05 --- Ocultar senha

Integrar `visibility_off...svg`.

## BL-05.06 --- Requisito atendido

Integrar `task_alt...svg`.

## BL-05.07 --- Requisito não atendido

Integrar o SVG somente após confirmação do BL-00.01.

## BL-05.08 --- Customização

Garantir o nível de customização aprovado sem tornar os ícones
obrigatórios.

## Definition of Done do Épico

-   ícones aprovados renderizados com `TPath`;
-   ações interativas possuem hit area adequada;
-   recursos opcionais permanecem opcionais;
-   lifetime dos elementos está definido.

------------------------------------------------------------------------

# ÉPICO E06 --- Clear e senha

**Objetivo:** implementar comportamentos interativos relacionados ao
conteúdo.

**Dependência:** E05.

## BL-06.01 --- Clear runtime

Implementar limpeza do conteúdo e atualização dos estados dependentes.

## BL-06.02 --- Senha oculta

Implementar estado protegido conforme capacidade FMX aprovada.

## BL-06.03 --- Alternância de visibilidade

Alternar visibilidade sem reconstruir o componente.

## BL-06.04 --- Sincronização dos ícones

Garantir que o ícone reflita corretamente o estado atual da senha.

## BL-06.05 --- Foco

Garantir que interação com clear/senha respeite o comportamento de foco
definido.

## Definition of Done do Épico

-   clear funcional;
-   senha funcional;
-   alternância runtime funcional;
-   estado visual sincronizado;
-   testes correspondentes adicionados.

------------------------------------------------------------------------

# ÉPICO E07 --- Limite e contador de caracteres

**Objetivo:** aplicar limite e informar consumo da capacidade do campo.

**Dependências:** E02 e E04.

## BL-07.01 --- Aplicação do limite

Impedir conteúdo acima do limite durante entrada.

## BL-07.02 --- Contador single-line

Exibir conceitualmente:

``` text
atual/máximo
```

Exemplos:

``` text
0/140
25/140
140/140
```

## BL-07.03 --- Sincronização

Atualizar o contador sempre que o conteúdo mudar por um caminho
permitido.

## BL-07.04 --- Integração visual

Posicionar o contador de forma compatível com o layout single-line
aprovado.

## Definition of Done do Épico

-   limite efetivamente impede excedente;
-   contador corresponde ao conteúdo real;
-   não existe suporte multiline.

------------------------------------------------------------------------

# ÉPICO E08 --- Input e Paste inválidos

**Objetivo:** impedir que caracteres proibidos entrem no campo por
qualquer meio contemplado.

**Dependências:** E02, E03, E04 e decisão BL-00.11.

## BL-08.01 --- Input inválido

Bloquear caracteres proibidos durante entrada.

## BL-08.02 --- Paste válido

Permitir paste quando todo o conteúdo respeitar a política do campo.

## BL-08.03 --- Paste inválido

Quando houver qualquer caractere proibido:

-   rejeitar a colagem;
-   não sanitizar silenciosamente;
-   preservar o conteúdo anterior.

## BL-08.04 --- Paste acima do limite

Aplicar o contrato de limite aprovado sem permitir estado final
excedente.

## BL-08.05 --- Feedback

Aplicar a estratégia aprovada:

-   alerta;
-   ícone;
-   ambos.

## BL-08.06 --- Estado visual

Sincronizar feedback inválido com o estado visual quando isso fizer
parte do contrato aprovado.

## Definition of Done do Épico

-   digitação inválida bloqueada;
-   paste inválido rejeitado integralmente;
-   conteúdo anterior preservado;
-   feedback coerente com configuração.

------------------------------------------------------------------------

# ÉPICO E09 --- Integração ao RickUIBuilder

**Objetivo:** disponibilizar o novo componente pela superfície pública
do framework.

**Dependências:** E01 e componentes funcionais necessários.

## BL-09.01 --- Types

Adicionar somente os tipos aprovados.

## BL-09.02 --- Interfaces

Adicionar somente os contratos aprovados.

Não modificar GUIDs existentes.

## BL-09.03 --- Factory

Integrar a criação visual conforme arquitetura aprovada.

## BL-09.04 --- Facade

Adicionar o entry point aprovado para o `Edit`.

## BL-09.05 --- Units novas

Adicionar ao package/project somente as units efetivamente criadas.

## BL-09.06 --- Uses

Atualizar dependências estritamente necessárias.

## BL-09.07 --- Verificação de impacto

Confirmar estaticamente que os componentes existentes não tiveram seus
contratos alterados fora do necessário.

## Definition of Done do Épico

-   `Edit` acessível pela API aprovada;
-   package/project coerentes;
-   contratos existentes preservados;
-   nenhuma dependência não autorizada adicionada.

------------------------------------------------------------------------

# ÉPICO E10 --- Testes

**Objetivo:** criar cobertura proporcional aos novos contratos e
proteger regressões.

**Dependências:** implementação dos respectivos itens.

## BL-10.01 --- Testes de Types/defaults

Validar defaults e tipos públicos novos.

## BL-10.02 --- Testes de presets

Cobrir cada preset aprovado.

## BL-10.03 --- Testes de transformação

Cobrir uppercase, lowercase e URL.

## BL-10.04 --- Testes de limite

Cobrir fronteiras:

-   vazio;
-   abaixo do limite;
-   exatamente no limite;
-   tentativa acima do limite.

## BL-10.05 --- Testes do contador

Validar correspondência entre conteúdo e limite.

## BL-10.06 --- Testes de criação FMX

Validar estrutura runtime, `Owner` e `Parent` conforme contrato.

## BL-10.07 --- Testes de estados

Cobrir normal, foco e inválido quando tecnicamente determinísticos no
ambiente.

## BL-10.08 --- Testes de clear

Cobrir conteúdo e atualização de estado.

## BL-10.09 --- Testes de senha

Cobrir visibilidade e sincronização dos ícones.

## BL-10.10 --- Testes de input/paste

Cobrir os caminhos testáveis de entrada válida e inválida.

## BL-10.11 --- Testes de lifetime

Cobrir destruição/detach e referências auxiliares conforme arquitetura
aprovada.

## BL-10.12 --- Regressão

Executar a suíte existente quando houver ambiente disponível.

## Definition of Done do Épico

-   testes correspondentes implementados;
-   execução real registrada quando realizada;
-   falhas investigadas;
-   nenhuma afirmação de sucesso sem execução.

------------------------------------------------------------------------

# ÉPICO E11 --- Method Toxicity e revisão técnica

**Objetivo:** impedir introdução ou agravamento de toxicidade.

**Dependência:** implementação Delphi estabilizada.

## BL-11.01 --- Length

Avaliar métodos novos/alterados contra o threshold aplicável.

## BL-11.02 --- Parameters

Avaliar quantidade de parâmetros.

## BL-11.03 --- If Depth

Avaliar profundidade condicional.

## BL-11.04 --- Cyclomatic Complexity

Avaliar complexidade ciclomática.

## BL-11.05 --- Toxicity real

Executar somente se RAD Studio/CSV estiver disponível.

Sem ferramenta real, registrar:

**Toxicity real: Não confirmado.**

## BL-11.06 --- Correções

Corrigir violações introduzidas sem criar fragmentação artificial ou
abstrações cosméticas.

## Definition of Done do Épico

-   avaliação estática registrada;
-   métricas reais registradas somente quando executadas;
-   nenhuma nova toxicidade conhecida introduzida.

------------------------------------------------------------------------

# ÉPICO E12 --- Auditoria independente

**Objetivo:** revisar a implementação completa por uma passagem separada
da implementação.

**Dependência:** E09, E10 e E11 em estado adequado para revisão.

## BL-12.01 --- Escopo

Verificar mudanças fora do escopo.

## BL-12.02 --- Contratos

Verificar API pública, GUIDs e compatibilidade.

## BL-12.03 --- FMX

Revisar:

-   ownership;
-   parentagem;
-   eventos;
-   callbacks;
-   foco;
-   destruição;
-   lifetime.

## BL-12.04 --- Arquitetura

Revisar responsabilidades, coesão e acoplamento.

## BL-12.05 --- Presets

Comparar implementação com a especificação aprovada.

## BL-12.06 --- Toxicidade

Revisar métricas e estrutura dos métodos.

## BL-12.07 --- Testes

Revisar se os contratos relevantes possuem testes proporcionais.

## BL-12.08 --- Ciclo de correção

Se houver reprovação:

``` text
AUDITORIA
   ↓
CORREÇÃO
   ↓
NOVA AUDITORIA
```

Repetir até atender aos critérios aplicáveis.

## Definition of Done do Épico

-   nenhuma pendência bloqueante de auditoria;
-   riscos restantes documentados;
-   correções reavaliadas no estado completo.

------------------------------------------------------------------------

# ÉPICO E13 --- Build e validação

**Objetivo:** executar as validações realmente disponíveis.

**Dependência:** E12 aprovado.

## BL-13.01 --- Build Delphi

Executar compilação real somente se houver toolchain compatível
disponível.

Caso contrário:

**Compilação real: Não confirmada.**

## BL-13.02 --- DUnitX

Executar testes reais quando o ambiente permitir.

## BL-13.03 --- Validação runtime

Executar validação manual/runtime quando houver ambiente FMX adequado.

## BL-13.04 --- Method Toxicity real

Executar RAD Studio/CSV quando disponível.

## BL-13.05 --- Registrar evidências

Separar claramente:

-   análise estática;
-   build real;
-   testes reais;
-   validação runtime;
-   métricas reais.

## Definition of Done do Épico

-   todas as validações possíveis executadas;
-   limitações explicitadas;
-   nenhum resultado inventado.

------------------------------------------------------------------------

# ÉPICO E14 --- Documentação final

**Objetivo:** documentar exclusivamente o comportamento final
implementado.

**Dependência:** implementação estabilizada e validada.

## BL-14.01 --- Documentação do Edit

Criar `docs/edit/` quando a profundidade final justificar.

Documentar:

-   finalidade;
-   API;
-   presets realmente existentes;
-   estados;
-   ícones;
-   senha;
-   clear;
-   limite;
-   contador;
-   validação;
-   exemplos de uso;
-   limitações reais.

## BL-14.02 --- XMLDoc

Atualizar interfaces, tipos e métodos públicos quando aplicável.

## BL-14.03 --- Sample

Atualizar somente se fizer parte da entrega aprovada e refletir API
real.

## BL-14.04 --- README

Atualizar somente quando necessário para representar a feature realmente
entregue.

## BL-14.05 --- Paridade documental

Quando houver versões EN/PT-BR, manter equivalência funcional sem
tradução mecânica inadequada.

## Definition of Done do Épico

-   documentação corresponde ao código final;
-   nenhum recurso planejado é apresentado como implementado;
-   exemplos correspondem à API real.

------------------------------------------------------------------------

# ÉPICO E15 --- Final Quality Gate e entrega

**Objetivo:** realizar a verificação final antes da entrega.

**Dependências:** E12, E13 e E14.

## BL-15.01 --- Requisitos

Verificar:

-   especificação atendida;
-   decisões aprovadas respeitadas;
-   multiline ausente;
-   contador single-line presente conforme contrato.

## BL-15.02 --- Código

Verificar:

-   escopo;
-   compatibilidade Delphi;
-   `uses`;
-   contratos;
-   GUIDs;
-   ownership;
-   lifetime;
-   ausência de alterações paralelas indevidas.

## BL-15.03 --- Arquitetura

Verificar:

-   responsabilidades;
-   coesão;
-   acoplamento;
-   necessidade das abstrações introduzidas.

## BL-15.04 --- Method Toxicity

Confirmar ausência de novas violações conhecidas e distinguir análise
estática de medição real.

## BL-15.05 --- Testes

Registrar somente resultados efetivamente executados.

## BL-15.06 --- Build

Registrar somente resultado efetivamente executado.

## BL-15.07 --- Documentação

Confirmar correspondência com a implementação final.

## BL-15.08 --- Riscos restantes

Listar limitações ou itens não confirmados que permanecerem.

## Definition of Done do Épico

A feature somente estará pronta para entrega quando todos os gates
aplicáveis estiverem aprovados ou quando uma limitação real estiver
explicitamente registrada e aceita.

------------------------------------------------------------------------

# Ordem de execução

``` text
E00 — Decisões funcionais
 ↓
E01 — Contrato e arquitetura
 ↓
├── E02 — Núcleo de filtragem
│    ↓
│   E03 — Presets
│
└── E04 — Visual single-line
     ↓
    E05 — TPath
     ↓
    E06 — Clear/Senha

E02 + E04
 ↓
E07 — Limite/Contador

E02 + E03 + E04
 ↓
E08 — Input/Paste

E01 + implementação funcional
 ↓
E09 — Integração
 ↓
E10 — Testes
 ↓
E11 — Method Toxicity
 ↓
E12 — Auditoria
 ↓
E13 — Build/Validação
 ↓
E14 — Documentação final
 ↓
E15 — Final Quality Gate
```

------------------------------------------------------------------------

# Regra de manutenção do backlog

Qualquer novo requisito deverá primeiro ser incorporado à especificação
funcional e então refletido neste backlog.

Não adicionar implementação ao backlog como forma de decidir requisito
ainda indefinido.

# Registro da execução do Edit

As decisões BL-00.01 a BL-00.11 foram fechadas conforme a seção 34 da especificação. D12 e D13 foram autorizadas como decisão técnica conforme a arquitetura existente.

A implementação deve manter como evidência separada: análise estática, testes realmente executados, build realmente executado e Method Toxicity real. A existência de código ou testes não implica aprovação de execução.
