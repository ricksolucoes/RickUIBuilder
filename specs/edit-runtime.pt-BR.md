# Especificação do componente Edit runtime

**Projeto:** RickUIBuilder\
**Status:** especificação funcional original --- registro histórico de pré-implementação\
**Escopo:** contrato funcional que orientou a implementação do componente `Edit` runtime

> Este documento preserva os requisitos definidos antes da implementação. No código atual do repositório o componente `Edit` já existe; para o comportamento efetivamente implementado, o código e `docs/edit/` são as fontes atuais. A redação futura mantida nas seções abaixo registra a especificação original e não deve ser interpretada como backlog pendente.

## 1. Objetivo

Adicionar ao RickUIBuilder um novo componente `Edit`, criado
programaticamente em runtime, integrado à API e à arquitetura
existentes, sem quebrar contratos ou comportamentos atuais.

O componente será exclusivamente **single-line** e deverá contemplar
estados visuais, ícones com `TPath`, presets de entrada, filtragem
durante o input, paste inválido, transformação de caixa, limite e
contador de caracteres, senha e indicadores de validação.

## 2. Regras de engenharia

1.  O código existente é a fonte primária para decisões arquiteturais.
2.  Não presumir comportamento por README, documentação, nomes ou
    semelhança com outros componentes.
3.  Aplicar alteração mínima necessária.
4.  Não refatorar componentes existentes fora do escopo.
5.  Não copiar automaticamente a arquitetura do `ComboBox`, `Button`,
    `Badge` ou outro componente.
6.  Preservar GUIDs e contratos públicos existentes.
7.  Não adicionar dependências de terceiros sem requisito explícito.
8.  Analisar `Owner`, `Parent`, reference counting, eventos, callbacks e
    lifetime.
9.  Respeitar o `AGENTS.md` e os workflows aplicáveis do projeto.
10. Quando algo não estiver comprovado ou definido, registrar **Não
    confirmado.**

## 3. Referências visuais

As sete imagens fornecidas são referências visuais e comportamentais
para composição, foco, erro, label/hint, borda, mensagens, ícones,
senha, clear e contador.

Detalhes ambíguos das imagens não deverão virar requisitos por
inferência.

### Single-line

Apesar da existência de uma imagem multiline:

-   o `Edit` será exclusivamente **single-line**;
-   não haverá API, propriedade ou modo multiline;
-   o contador de caracteres observado na referência permanece como
    requisito para o `Edit` single-line.

## 4. Estados visuais

O componente deverá contemplar:

-   estado normal;
-   estado com foco/edição;
-   estado inválido/erro.

Os estados poderão afetar borda, label/hint, cores, ícones e mensagem de
validação. Características visuais destinadas à customização não deverão
ficar rigidamente vinculadas às screenshots.

## 5. Ícones com TPath

Os ícones fornecidos deverão ser utilizados por meio de `TPath` quando
habilitados.

  -------------------------------------------------------------------------------------------------
  Finalidade                          Arquivo
  ----------------------------------- -------------------------------------------------------------
  Alerta/entrada inválida             `check_alert_62dp_E3E3E3_FILL0_wght400_GRAD0_opsz48.svg`

  Clear                               `cancel_62dp_E3E3E3_FILL0_wght400_GRAD0_opsz48.svg`

  Mostrar senha                       `visibility_62dp_E3E3E3_FILL0_wght400_GRAD0_opsz48.svg`

  Ocultar senha                       `visibility_off_62dp_E3E3E3_FILL0_wght400_GRAD0_opsz48.svg`

  Requisito atendido                  `task_alt_62dp_E3E3E3_FILL0_wght400_GRAD0_opsz48.svg`

  Possível requisito não atendido     `unpublished_62dp_E3E3E3_FILL0_wght400_GRAD0_opsz48.svg`
  -------------------------------------------------------------------------------------------------

A associação de `unpublished...svg` ao estado de requisito não atendido
permanece **Não confirmado** até confirmação explícita.

## 6. Clear

O recurso de clear será opcional e deverá:

-   utilizar o `TPath` correspondente;
-   limpar o conteúdo do campo;
-   preservar foco/edição conforme o contrato que for definido;
-   possuir área de interação adequada.

## 7. Senha

O `Edit` poderá ser configurado para senha e deverá permitir alternância
runtime entre conteúdo oculto e visível.

-   `visibility...` representa senha visível;
-   `visibility_off...` representa senha oculta.

A alternância não deverá exigir reconstrução do componente.

## 8. Indicadores de requisito

O componente deverá poder representar visualmente requisito/validação
atendido ou não atendido.

`task_alt...` está confirmado para requisito atendido. A associação do
ícone de requisito não atendido ainda precisa ser confirmada.

## 9. Presets de entrada

Deverão existir presets para:

1.  CPF;
2.  CNPJ;
3.  CEP;
4.  E-mail;
5.  Site/URL;
6.  Telefone;
7.  Celular;
8.  somente número inteiro;
9.  somente número `Float`, com casas decimais configuráveis;
10. somente texto com espaço, sem caracteres acentuados;
11. somente texto com espaço e pontuação, sem caracteres acentuados;
12. somente texto com espaço, com caracteres acentuados;
13. somente texto com espaço e pontuação, com caracteres acentuados;
14. aceitar todos os caracteres.

As máscaras exatas de CPF, CNPJ, CEP, telefone e celular ainda deverão
ser formalizadas. Não inventar formatação.

## 10. Número inteiro

O preset inteiro deverá restringir a entrada durante o input e aplicar a
mesma regra a paste.

Ainda **Não confirmado**: sinal negativo, separadores e regras numéricas
adicionais.

## 11. Número Float

O preset `Float` deverá permitir configurar a quantidade de casas
decimais e restringir a entrada durante o input.

Ainda **Não confirmado**: separador decimal, negativos, agrupamento de
milhares e regras regionais.

## 12. E-mail

O preset de e-mail deverá converter automaticamente o conteúdo para
**lowercase**.

Validação semântica completa de endereço de e-mail não foi especificada
e não deverá ser inventada.

## 13. Site/URL

No preset de Site/URL:

-   somente a parte definida como endereço deverá receber lowercase;
-   parâmetros e query parameters deverão preservar a capitalização
    fornecida pelo usuário;
-   a URL inteira não poderá ser convertida indiscriminadamente para
    lowercase.

Antes da implementação deverão ser formalizadas as regras para `scheme`,
`host`, `port`, `path`, `query` e `fragment`.

## 14. Conversão automática de caixa

Deverá existir transformação configurável para:

-   uppercase;
-   lowercase.

Presets com regra própria, como Site/URL, não deverão sofrer
transformação global incompatível com seu contrato.

## 15. Limite máximo de caracteres

Deverá ser possível configurar quantidade máxima de caracteres.

O limite deverá:

-   atuar durante o input;
-   valer para digitação;
-   valer para paste;
-   valer para outras formas de entrada;
-   impedir que o campo termine com conteúdo acima do limite.

## 16. Contador de caracteres

O contador permanece obrigatório como capacidade do `Edit`
**single-line** quando houver limite configurado.

Formato conceitual:

``` text
0/140
25/140
139/140
140/140
```

O numerador deverá refletir o conteúdo real e o denominador o limite
configurado. O posicionamento deverá ser adequado ao layout single-line
e não precisa reproduzir literalmente a referência multiline.

## 17. Restrição durante input

Quando houver restrição:

-   somente caracteres permitidos poderão entrar;
-   a restrição deverá ocorrer durante o input;
-   não aceitar primeiro para rejeitar depois;
-   aplicar a mesma regra independentemente do meio de entrada.

## 18. Paste inválido

Se o conteúdo colado contiver caracteres proibidos:

-   rejeitar a colagem;
-   não remover silenciosamente caracteres inválidos para aceitar o
    restante;
-   preservar o conteúdo válido que já estava no campo;
-   fornecer feedback de conteúdo inválido.

## 19. Feedback de entrada inválida

O feedback poderá ser:

-   alerta;
-   ícone de alerta;
-   ambos.

O ícone associado é `check_alert...svg`.

A configuração definitiva entre alerta, ícone ou ambos permanece
pendente e não deverá ser escolhida arbitrariamente.

## 20. Texto, acentuação e pontuação

Devem existir quatro variações:

  Espaço      Pontuação                    Acentos
  ----------- ---------------------------- ---------
  permitido   não habilitada pelo preset   não
  permitido   permitida                    não
  permitido   não habilitada pelo preset   sim
  permitido   permitida                    sim

O conjunto exato considerado **pontuação** ainda precisa ser definido.

## 21. Modo irrestrito

O modo de aceitar todos os caracteres não deverá aplicar os filtros dos
presets textuais. Configurações independentes, como limite máximo,
continuarão válidas quando habilitadas.

## 22. Interação FMX

Os recursos adicionais deverão preservar, conforme aplicável:

-   foco;
-   cursor;
-   seleção de texto;
-   teclado;
-   teclado virtual;
-   edição.

Ícones interativos deverão possuir área de interação adequada. Eventos,
callbacks, ownership e lifetime deverão ser tratados explicitamente.

## 23. API pública

A API final ainda não está aprovada.

O plano técnico deverá definir, a partir da arquitetura real:

-   entry point na Facade;
-   interface fluente, se necessária;
-   records/enums;
-   defaults;
-   retorno de `Build`;
-   necessidade ou não de `BuildHandle`;
-   necessidade ou não de Handle/Behavior;
-   eventos públicos;
-   configuração de ícones;
-   configuração de presets;
-   validação;
-   semântica runtime;
-   ownership/lifetime observável pelo consumidor.

Não criar Handle, Behavior, State, Presentation ou outras camadas apenas
porque outro componente as utiliza.

## 24. Lifetime e ownership

Antes de implementar deverão estar definidos:

-   quem cria o controle;
-   quem é `Owner`;
-   quem é `Parent`;
-   quais objetos auxiliares existem;
-   quem possui cada objeto;
-   comportamento na destruição do Parent;
-   comportamento no detach;
-   remoção de eventos/callbacks;
-   prevenção de referências dangling;
-   prevenção de ciclos de interfaces.

## 25. Testes

A estratégia deverá contemplar proporcionalmente:

### Lógica

-   presets;
-   caracteres permitidos/proibidos;
-   uppercase/lowercase;
-   URL;
-   limite;
-   contador;
-   casas decimais.

### Integração FMX

-   criação runtime;
-   ownership/parentagem;
-   foco;
-   clear;
-   senha;
-   ícones;
-   estados;
-   paste inválido quando testável;
-   destruição/detach;
-   lifetime de Handle/Behavior, caso existam.

A suíte existente deverá permanecer válida. Não enfraquecer assertions
para obter resultado verde.

## 26. Method Toxicity

Todo `.pas` criado ou alterado deverá considerar os gates do projeto:

-   `Length <= 20`;
-   `Parameters <= 6`;
-   `If Depth <= 5`;
-   `Cyclomatic Complexity <= 6`;
-   `Toxicity < 1` quando medida realmente pelo RAD Studio.

Não introduzir ou agravar toxicidade. Não inventar valor composto de
`Toxicity`.

## 27. Build e validação

Não afirmar sem execução real:

-   que compila;
-   que testes passaram;
-   que não existem regressões;
-   que não existem leaks;
-   que Method Toxicity foi aprovado.

Distinguir análise estática, build real, DUnitX real, runtime/manual e
Method Toxicity real.

## 28. Documentação final

Este arquivo é uma **spec de planejamento**, não documentação de API
implementada.

Após a implementação estabilizar:

-   criar `docs/edit/` quando a profundidade justificar;
-   documentar somente comportamento existente;
-   atualizar README/Sample somente quando houver impacto confirmado;
-   manter paridade EN/PT-BR quando houver pares bilíngues.

## 29. Fluxo da feature

``` text
DEFINIR
  ↓
FECHAR DECISÕES BLOQUEANTES
  ↓
PLANEJAR
  ↓
CARACTERIZAR CONTRATOS
  ↓
IMPLEMENTAR EM INCREMENTOS
  ↓
VERIFICAR
  ↓
REVISAR
  ↓
DOCUMENTAR O ESTADO FINAL
  ↓
ENTREGAR
```

## 30. Fora do escopo

-   multiline;
-   refatoração geral do RickUIBuilder;
-   redesenho dos componentes existentes;
-   dependências externas não solicitadas;
-   funcionalidades inferidas apenas pelas screenshots;
-   validações de e-mail não especificadas;
-   regras numéricas não especificadas;
-   máscaras não formalizadas;
-   conjunto de pontuação não formalizado;
-   funcionalidades não aprovadas.

## 31. Decisões pendentes

  ----------------------------------------------------------------------------
  ID                      Decisão                      Estado
  ----------------------- ---------------------------- -----------------------
  D01                     Confirmar                    Não confirmado
                          `unpublished...svg` como     
                          requisito não atendido       

  D02                     Formalizar máscara de CPF    Pendente

  D03                     Formalizar máscara de CNPJ   Pendente

  D04                     Formalizar máscara de CEP    Pendente

  D05                     Formalizar máscara de        Pendente
                          telefone                     

  D06                     Formalizar máscara de        Pendente
                          celular                      

  D07                     Definir sinal e semântica do Pendente
                          inteiro                      

  D08                     Definir                      Pendente
                          separador/negativos/regras   
                          do `Float`                   

  D09                     Definir partes da URL que    Pendente
                          recebem lowercase            

  D10                     Definir conjunto de          Pendente
                          pontuação                    

  D11                     Definir feedback: alerta,    Pendente
                          ícone ou ambos               

  D12                     Definir contrato público     Pendente
                          final                        

  D13                     Definir necessidade de       Pendente
                          Handle/Behavior e lifetime   
  ----------------------------------------------------------------------------

## 32. Acceptance criteria de alto nível

A feature somente poderá ser considerada concluída quando, conforme o
contrato final aprovado:

1.  o `Edit` puder ser criado em runtime pela API do RickUIBuilder;
2.  permanecer exclusivamente single-line;
3.  estados visuais aprovados estiverem implementados;
4.  ícones aprovados utilizarem `TPath`;
5.  clear funcionar quando habilitado;
6.  senha puder alternar visibilidade quando habilitada;
7.  presets aprovados restringirem entrada conforme seus contratos;
8.  e-mail aplicar lowercase conforme definido;
9.  URL aplicar lowercase somente às partes aprovadas;
10. uppercase/lowercase configurável funcionar;
11. limite impedir entrada excedente;
12. contador refletir conteúdo atual e limite;
13. paste proibido for rejeitado conforme requisito;
14. feedback inválido seguir configuração aprovada;
15. ownership/lifetime estiverem definidos e testados proporcionalmente;
16. contratos existentes não forem alterados fora do necessário;
17. documentação final refletir somente a implementação;
18. validações executadas forem reportadas com evidência real.

## 33. Controle de mudanças

Requisito novo, remoção ou alteração deverá ser incorporado
explicitamente a esta especificação ou a uma decisão relacionada antes
de ser tratado como requisito.

Uma interpretação visual, conveniência de implementação ou comportamento
de outro componente não altera esta especificação por inferência.

## 34. Decisões fechadas para implementação

As decisões abaixo substituem os estados pendentes da seção 31 para esta implementação:

- **D01:** `unpublished...svg` confirmado como requisito não atendido.
- **D02:** CPF por formato `000.000.000-00`, somente numérico, sem cálculo de DV; máscara automática na digitação e paste somente com a estrutura mascarada.
- **D03:** CNPJ por formato `AA.AAA.AAA/AAAA-00`; 12 posições alfanuméricas `0-9`/`A-Z` e dois caracteres finais numéricos, sem cálculo de DV; máscara automática na digitação e paste somente mascarado.
- **D04:** CEP por formato `00000-000`, mesma política de digitação/paste do CPF.
- **D05:** telefone `0000-0000` ou `(00) 0000-0000`; DDD opcional e incorporado quando a quantidade de dígitos o comporta.
- **D06:** celular `0 0000-0000` ou `(00) 0 0000-0000`; DDD opcional e incorporado quando a quantidade de dígitos o comporta.
- **D07:** inteiro possui configuração explícita para permitir/proibir negativo.
- **D08:** Float pode usar locale ou separadores customizados; negativo, separador de milhar e casas decimais são configuráveis.
- **D09:** URL oferece `scheme + host` em lowercase ou conteúdo inteiro em lowercase.
- **D10:** pontuação permitida: `. , ; : ! ? ... - — ( ) [ ] { } " ' « » ’ ` / \ | _ + = < > * @ # $ % & § ~ ^ ° º ª`.
- **D11:** mensagem de alerta e ícone são suportados e configuráveis.
- **D12:** contrato público definido tecnicamente conforme a arquitetura real existente.
- **D13:** Handle/Behavior e lifetime definidos tecnicamente conforme a arquitetura real existente, somente quando necessários ao comportamento runtime.

O indicador de requisito é stateful e seu estado é informado explicitamente pelo consumidor. Nenhuma regra semântica de validação é inferida pelo componente.
