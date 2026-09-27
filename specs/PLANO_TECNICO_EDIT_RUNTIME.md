# Plano Técnico por Sprints --- Edit Runtime

**Projeto:** RickUIBuilder\
**Feature:** `Edit` runtime\
**Status:** Implementação executada --- validação estática concluída; build/testes reais não confirmados\
**Base funcional:** `specs/edit-runtime.pt-BR.md`\
**Backlog:** `specs/BACKLOG_EDIT_RUNTIME.md`

> Este documento organiza a execução técnica. As decisões funcionais usadas na implementação estão registradas na seção 34 da especificação. Resultados de build, DUnitX e Toxicity real continuam dependentes de execução efetiva das respectivas ferramentas.

## 1. Objetivo técnico

Implementar um novo componente `Edit` single-line em runtime, integrado
ao RickUIBuilder, preservando os contratos existentes e adicionando
somente a arquitetura necessária para estados visuais, label/hint,
ícones opcionais com `TPath`, clear, senha, indicadores de requisito,
presets, transformação de caixa, limite e contador, bloqueio de input
inválido, rejeição integral de paste inválido e feedback configurável.

Estratégia: **contract-first + risk-first + vertical slices**.

``` text
Fechar comportamento
→ fechar contrato/lifetime
→ caracterizar contratos com testes
→ implementar incrementos verificáveis
→ integrar
→ auditar
→ validar
→ documentar o estado final
```

## Regra permanente de entrega

Ao final de qualquer execução relacionada ao componente `Edit`:

-   a resposta ao usuário deverá disponibilizar **somente um arquivo
    ZIP**;
-   o ZIP deverá conter **exclusivamente arquivos efetivamente criados
    ou modificados** pela execução;
-   os caminhos relativos ao repositório deverão ser preservados dentro
    do ZIP;
-   arquivos apenas consultados, arquivos temporários e arquivos sem
    alteração não deverão ser incluídos;
-   arquivos removidos não poderão ser simulados no ZIP por
    placeholders;
-   nenhuma etapa poderá substituir essa regra por uma entrega do
    repositório completo.

Esta regra também se aplica a execuções parciais ou bloqueadas: somente
artefatos realmente criados ou modificados poderão compor o ZIP.

## Regra permanente de encoding Delphi

Todo arquivo Delphi `.pas` criado ou modificado durante a implementação
do componente `Edit` deverá ser salvo em **UTF-8 com BOM**.

Esta regra é obrigatória para preservar corretamente caracteres
acentuados e evitar problemas de encoding no código-fonte.

Antes de incluir qualquer `.pas` no ZIP de entrega, verificar
efetivamente a presença do BOM UTF-8 (`EF BB BF`). Arquivo `.pas` novo
ou modificado sem esse encoding não atende ao Quality Gate.

## 2. Restrições permanentes

-   `Edit` exclusivamente single-line.
-   Multiline fora do escopo.
-   Alteração mínima necessária.
-   Sem refatoração paralela.
-   Sem dependência externa nova sem autorização.
-   Sem alteração de GUID existente.
-   Sem arquitetura copiada mecanicamente do `ComboBox`.
-   Handle/Behavior/State somente se necessidade runtime justificar.
-   `.pas` modificado em UTF-8 com BOM.
-   Ownership, Parent, callbacks e reference counting analisados
    explicitamente.
-   Todo `.pas` modificado passa por Method Toxicity.
-   Build, DUnitX, runtime e Toxicity real só são declarados executados
    com evidência real.

## 3. Superfícies de integração previstas

Revisar conforme necessidade real:

``` text
src/Rick.UIBuilder.pas
src/Rick.UIBuilder.Types.pas
src/Rick.UIBuilder.Interfaces.pas
src/Rick.UIBuilder.Factory.pas
RickUIBuilder.dpk
RickUIBuilder.dproj
tests/RickUIBuilder.Test.dpr
tests/RickUIBuilder.Test.dproj
```

Units específicas candidatas, a confirmar no Sprint 1:

``` text
src/Rick.UIBuilder.Edit.pas
src/Rick.UIBuilder.Edit.Input.pas
src/Rick.UIBuilder.Edit.Handle.pas
```

`Edit.Input` só será criada se filtragem/máscaras constituírem
responsabilidade independente. `Edit.Handle` só será criado se operações
runtime públicas justificarem boundary próprio.
Behavior/State/Presentation não serão criados sem necessidade
comprovada.

# Sprint 0 --- Fechamento funcional

**Backlog:** E00 / BL-00.01 a BL-00.11\
**Código Delphi:** proibido.

### Objetivo

Eliminar ambiguidades que alteram comportamento antes do desenho final
da API.

### Decisões obrigatórias

1.  confirmar/rejeitar `unpublished...svg` para requisito não atendido;
2.  formalizar CPF;
3.  formalizar CNPJ;
4.  formalizar CEP;
5.  formalizar telefone;
6.  formalizar celular;
7.  fechar semântica de inteiro;
8.  fechar semântica de `Float`;
9.  fechar canonicalização de Site/URL;
10. definir conjunto de pontuação;
11. definir contrato de feedback inválido.

### Arquivos permitidos

``` text
specs/edit-runtime.pt-BR.md
specs/BACKLOG_EDIT_RUNTIME.md
specs/PLANO_TECNICO_EDIT_RUNTIME.md
```

Somente quando a decisão exigir sincronização documental.

### Gate

Não iniciar implementação dependente enquanto decisão funcional
bloqueante permanecer implícita.

------------------------------------------------------------------------

# Sprint 1 --- Contrato público, arquitetura e lifetime

**Backlog:** E01 / BL-01.01 a BL-01.06

### Objetivo

Definir a menor arquitetura pública e interna necessária.

### Context Map focado

Reabrir no código real:

-   Facade;
-   Types;
-   Interfaces;
-   Factory;
-   componente simples mais próximo em responsabilidade;
-   componente com Handle apenas para compreender runtime/lifetime;
-   package/project;
-   testes.

### Contrato do consumidor

Fechar:

-   entry point;
-   interface fluent;
-   configuração e defaults;
-   semântica de `Build`;
-   operações pós-`Build`;
-   eventos necessários;
-   invalid input semantics;
-   runtime versus build-time.

### Decisão de Handle

Criar Handle somente se houver operação runtime semântica que justifique
boundary próprio e lifetime independente do builder. Caso contrário, não
criar.

### Visual tree e lifetime

Para cada elemento definir:

-   tipo;
-   `Owner`;
-   `Parent`;
-   `Align`;
-   `HitTest`;
-   responsabilidade;
-   evento/interação;
-   destruição.

Definir também destruição do Parent, detach, callbacks e prevenção de
ciclos de interface.

### Gate

API, ownership/lifetime e arquitetura revisados separadamente antes da
implementação.

------------------------------------------------------------------------

# Sprint 2 --- Contract tests e núcleo de input

**Backlog:** E02 + E10 parcial\
**Dependência:** Sprint 1.

### Objetivo

Fixar contratos testáveis e implementar o menor núcleo de filtragem,
transformação e limite.

### Sequência

``` text
Contrato aprovado
→ teste focado
→ falha esperada
→ implementação mínima
→ teste focado
→ avaliação estática de toxicidade
```

### Escopo

-   caracteres permitidos;
-   uppercase;
-   lowercase;
-   limite;
-   decisão de aceitação da entrada;
-   reutilização por digitação e paste.

Criar `Rick.UIBuilder.Edit.Input.pas` somente se houver responsabilidade
coesa independente da UI.

### Testes mínimos

-   vazio;
-   permitido;
-   proibido;
-   uppercase;
-   lowercase;
-   abaixo do limite;
-   exatamente no limite;
-   tentativa acima.

### Gate

`Length <= 20`, `Parameters <= 6`, `If Depth <= 5` e
`Cyclomatic Complexity <= 6` avaliados estaticamente. `Toxicity` real
permanece **Não confirmado** sem RAD Studio/CSV.

------------------------------------------------------------------------

# Sprint 3 --- Presets e canonicalização

**Backlog:** E03 + E10 parcial\
**Dependências:** Sprints 0 e 2.

### Ordem

1.  todos os caracteres;
2.  quatro presets textuais;
3.  inteiro;
4.  `Float`;
5.  e-mail;
6.  Site/URL;
7.  CEP;
8.  CPF;
9.  CNPJ;
10. telefone;
11. celular.

Para cada preset:

``` text
Regra aprovada
→ casos válidos
→ casos inválidos
→ boundaries
→ implementação mínima
→ teste focado
```

### Regras especiais

E-mail: somente política aprovada + lowercase; sem validação semântica
inventada.

Site/URL: testar separadamente cada parte cuja capitalização deva ser
convertida ou preservada.

`Float`: cobrir estados intermediários de digitação definidos no Sprint
0.

### Gate

Todos os presets implementados correspondem exatamente à especificação
fechada.

------------------------------------------------------------------------

# Sprint 4 --- Primeira fatia visual single-line

**Backlog:** E04 + E09 parcial\
**Dependência:** Sprint 1.

### Objetivo

Entregar o primeiro `Edit` runtime utilizável, sem antecipar adornos
posteriores.

### Escopo

-   entry point mínimo;
-   `TEdit` single-line;
-   composição mínima;
-   label/hint;
-   normal;
-   foco;
-   inválido;
-   Factory somente se a arquitetura atribuir essa responsabilidade.

### Verificação FMX

-   `Owner`;
-   `Parent`;
-   `Align`;
-   margins/padding;
-   z-order;
-   `HitTest`;
-   clipping;
-   focus;
-   teclado virtual.

### Gate single-line

Reprovar se houver API multiline ou `TMemo` usado para fornecer
multiline.

------------------------------------------------------------------------

# Sprint 5 --- TPath, Clear e Senha

**Backlog:** E05 + E06\
**Dependência:** Sprint 4.

### Objetivo

Adicionar ações e estados iconográficos preservando foco e edição.

### TPath

-   alerta;
-   clear;
-   mostrar senha;
-   ocultar senha;
-   requisito atendido;
-   requisito não atendido somente se confirmado.

Separar elemento visual da hit area quando necessário.

### Clear

Validar limpeza, contador, estado e foco conforme contrato.

### Senha

Validar estado inicial, ocultação, exibição, alternância sem
reconstrução, sincronização de ícone e preservação de texto.

### Gate

Recursos opcionais continuam opcionais; lifetime dos elementos
auxiliares está definido.

------------------------------------------------------------------------

# Sprint 6 --- Limite e contador single-line

**Backlog:** E07\
**Dependências:** Sprints 2 e 4.

### Objetivo

Integrar limite real ao contador visual.

### Casos

-   `0/N`;
-   `1/N`;
-   `N-1/N`;
-   `N/N`;
-   tentativa `N+1`;
-   clear retorna `0/N`;
-   conteúdo inicial conforme contrato.

### Gate

Campo não termina acima do limite e contador representa o texto real sem
suporte multiline.

------------------------------------------------------------------------

# Sprint 7 --- Input real, Paste e feedback

**Backlog:** E08\
**Dependências:** Sprints 3, 4, 5 e 6.

### Digitação inválida

-   caractere não entra;
-   seleção/cursor não é corrompido;
-   feedback conforme configuração.

### Paste válido

Respeita preset, transformação, limite e contador.

### Paste inválido

-   rejeição integral;
-   sem sanitização silenciosa;
-   conteúdo anterior preservado;
-   feedback configurado.

Quando paste nativo não puder ser automatizado confiavelmente, testar a
boundary lógica e registrar a limitação.

### Gate

Não existe caminho contemplado que introduza caractere proibido.

------------------------------------------------------------------------

# Sprint 8 --- Integração pública completa

**Backlog:** E09

### Objetivo

Concluir integração às superfícies públicas e projetos Delphi.

### Revisar conforme necessidade

``` text
src/Rick.UIBuilder.pas
src/Rick.UIBuilder.Types.pas
src/Rick.UIBuilder.Interfaces.pas
src/Rick.UIBuilder.Factory.pas
RickUIBuilder.dpk
RickUIBuilder.dproj
tests/RickUIBuilder.Test.dpr
tests/RickUIBuilder.Test.dproj
```

Mais as units específicas realmente criadas.

### Gate

-   Facade expõe somente contrato aprovado;
-   defaults correspondem aos testes;
-   GUIDs existentes intactos;
-   Factory sem responsabilidade indevida;
-   package/project sincronizados;
-   `uses` mínimos;
-   `.pas` modificados com UTF-8 BOM.

------------------------------------------------------------------------

# Sprint 9 --- Consolidação de testes e lifetime

**Backlog:** E10\
**Dependência:** Sprint 8.

### Matriz

**Types/API:** defaults, chaining, Build, Handle se existir, invalid
input.

**Presets:** válidos, inválidos, boundaries e transformações.

**FMX:** criação, Parent/Owner, foco, estados, clear, senha, TPath e
contador.

**Lifetime:** destruição do Parent, detach, callbacks, referências e
acesso a controles destruídos.

**Regressão:** executar suíte existente quando houver ambiente. Baseline
histórica não prova a alteração atual.

### Gate

Resultados reais separados de análise estática; assertions existentes
não são enfraquecidas.

------------------------------------------------------------------------

# Sprint 10 --- Method Toxicity e auditoria

**Backlog:** E11 + E12\
**Dependência:** Sprint 9.

### Passagem de métricas

Para cada `.pas` novo/alterado:

-   `Length`;
-   `Parameters`;
-   `If Depth`;
-   `Cyclomatic Complexity`;
-   `Toxicity` somente com RAD Studio/CSV real.

### Auditoria separada

Revisar:

-   escopo;
-   contratos;
-   GUIDs;
-   ownership/lifetime;
-   callbacks/reference counting;
-   foco/hit testing;
-   API;
-   presets;
-   segurança de input;
-   complexidade;
-   testes;
-   arquivos de projeto.

### Ciclo

``` text
AUDITORIA
→ CORREÇÃO
→ TESTES AFETADOS
→ TOXICITY AFETADA
→ NOVA AUDITORIA
```

### Gate

Nenhuma pendência bloqueante e nenhuma nova toxicidade conhecida.

------------------------------------------------------------------------

# Sprint 11 --- Build e validação runtime

**Backlog:** E13\
**Dependência:** Sprint 10.

### Build

Se houver toolchain Delphi compatível, compilar e registrar resultado
real. Caso contrário:

**Compilação real: Não confirmada.**

### DUnitX

Executar quando possível e registrar números reais. Sem execução:

**Resultado DUnitX real: Não confirmado.**

### Runtime FMX

Quando disponível, validar criação, foco, teclado, clear, senha,
contador, estados, paste e destruição.

### Toxicity real

Somente quando RAD Studio/CSV for efetivamente executado.

Falha real retorna ao sprint responsável pela causa.

------------------------------------------------------------------------

# Sprint 12 --- Documentação final

**Backlog:** E14\
**Dependência:** implementação estabilizada.

### Possíveis entregáveis

``` text
docs/edit/
README.md
README.pt-BR.md
sample/
XMLDoc
```

Não criar todos automaticamente.

`docs/edit/` deve documentar somente o que realmente existir: criação,
API, presets, estados, TPath, clear, senha, limite, contador,
input/paste, runtime, lifetime relevante, limitações e exemplos reais.

### Gate

Nenhuma assinatura hipotética ou funcionalidade apenas planejada é
apresentada como implementada.

------------------------------------------------------------------------

# Sprint 13 --- Final Quality Gate e pacote de entrega

**Backlog:** E15\
**Dependências:** Sprints 10, 11 e 12.

### Requisitos

-   spec final atendida;
-   single-line;
-   multiline ausente;
-   contador conforme contrato;
-   presets conforme decisões.

### Delphi

-   `uses`;
-   BOM;
-   GUIDs;
-   ownership;
-   lifetime;
-   compatibilidade no nível realmente validado.

### Arquitetura

-   responsabilidades coesas;
-   sem camada sem necessidade;
-   sem acoplamento injustificado.

### Evidências

-   testes/build/runtime somente com resultados reais;
-   Method Toxicity real somente se medida;
-   limitações explicitadas.

### Pacote final

O ZIP final deverá conter **somente arquivos efetivamente criados ou
modificados**, preservando os caminhos relativos do repositório.

Exemplo:

``` text
src/
  ... somente .pas criados/modificados
tests/
  ... somente arquivos alterados
docs/
  ... somente arquivos criados/modificados
sample/
  ... somente se alterado
specs/
  ... somente se alterado
RickUIBuilder.dpk       # somente se alterado
RickUIBuilder.dproj     # somente se alterado
```

Arquivos intocados não entram no ZIP.

## 4. Mapa Sprint → Backlog

  Sprint   Backlog             Resultado verificável
  -------- ------------------- ---------------------------------------
  0        E00                 decisões funcionais fechadas
  1        E01                 API, arquitetura e lifetime aprovados
  2        E02 + E10 parcial   núcleo de input testável
  3        E03 + E10 parcial   presets testados
  4        E04 + E09 parcial   primeiro Edit runtime
  5        E05 + E06           TPath, clear e senha
  6        E07                 limite e contador
  7        E08                 input/paste e feedback
  8        E09                 integração pública
  9        E10                 matriz de testes/lifetime
  10       E11 + E12           toxicity + auditoria
  11       E13                 build/test/runtime quando disponíveis
  12       E14                 documentação final
  13       E15                 quality gate e entrega

## 5. Dependências críticas

``` text
SPRINT 0 — DECISÕES
        ↓
SPRINT 1 — CONTRATO / LIFETIME
        ↓
   ┌────┴────┐
   ↓         ↓
SPRINT 2   SPRINT 4
INPUT      VISUAL
   ↓         ↓
SPRINT 3   SPRINT 5
PRESETS    ÍCONES/AÇÕES
   └────┬────┘
        ↓
SPRINT 6 — LIMITE/CONTADOR
        ↓
SPRINT 7 — INPUT/PASTE FMX
        ↓
SPRINT 8 — INTEGRAÇÃO
        ↓
SPRINT 9 — TESTES/LIFETIME
        ↓
SPRINT 10 — AUDITORIA/TOXICITY
        ↓
SPRINT 11 — BUILD/RUNTIME
        ↓
SPRINT 12 — DOCS
        ↓
SPRINT 13 — QUALITY GATE/ENTREGA
```

Sprints 2 e 4 podem ser preparados em paralelo somente depois do
contrato do Sprint 1 estar fechado, mantendo alterações logicamente
isoláveis.

## 6. Política de regressão

Quando surgir regressão:

1.  localizar o primeiro sprint onde o comportamento divergiu;
2.  isolar o menor conjunto relacionado;
3.  não fazer refatoração adjacente não autorizada;
4.  adicionar/ajustar teste de caracterização;
5.  corrigir causa raiz;
6.  repetir gates afetados.

Mudanças compartilhadas em Types, Interfaces, Factory e Facade entram
somente quando o contrato correspondente realmente precisar delas.

## 7. Critério para iniciar implementação

Implementação Delphi somente quando:

-   decisões necessárias do Sprint 0 estiverem fechadas;
-   Sprint 1 tiver contrato/lifetime aprovados;
-   arquivos previstos do incremento estiverem identificados;
-   acceptance criteria forem testáveis;
-   fora de escopo estiver explícito.

## 8. Critério para concluir

A feature estará pronta somente quando:

-   implementação corresponder à spec final;
-   nenhuma decisão bloqueante permanecer implícita;
-   contratos existentes estiverem preservados;
-   ownership/lifetime estiverem auditados;
-   Method Toxicity estiver avaliada no nível disponível;
-   testes/build/runtime forem reportados pelo nível real de evidência;
-   documentação refletir exclusivamente o código final;
-   Final Quality Gate estiver aprovado;
-   ZIP final contiver somente arquivos realmente criados ou
    modificados.
