# Política de Testes e Validação

Esta referência define o vocabulário e a barra de evidência. O workflow operacional está em `../skills/test-driven-development/SKILL.md` e `../skills/debugging-and-error-recovery/SKILL.md`.

## 1. Tipos de evidência

### Análise estática

Código/teste/configuração foi inspecionado sem executar compilador ou teste. Pode identificar riscos; não prova runtime.

### Build real

Um compilador Delphi/MSBuild compatível com o projeto foi executado e produziu resultado observável.

### Teste real

O executável/pipeline DUnitX foi executado e forneceu contagem/resultados observáveis.

### Verificação runtime/manual

Comportamento visual/interativo foi observado em execução. Deve indicar plataforma/cenário relevante quando isso importa.

### Method Toxicity real

RAD Studio ou CSV exportado da revisão avaliada forneceu as métricas.

Nunca use uma categoria como substituto de outra.

## 2. Baseline conhecida

Última baseline DUnitX fornecida para a revisão documentada:

```text
Tests Found   : 197
Tests Passed  : 197
Tests Ignored : 0
Tests Failed  : 0
Tests Errored : 0
Tests Leaked  : 0
```

Esta baseline é histórica. Depois de qualquer alteração, só declare que continua válida se a suíte correspondente for executada novamente.

## 3. Níveis de teste no RickUIBuilder

### Unitário puro

Adequado quando o comportamento não exige FMX host ou visual tree.

Exemplos atuais:

- resolução de estilo;
- data/state logic;
- chaining de builders quando Build não é chamado;
- defaults/configuração pura.

### Integração FMX

Adequado quando o teste precisa materializar controles, eventos, owner/parent ou lifetime.

O repositório usa `Category('Integration')` em fixtures apropriadas e `TForm` como host em testes de componentes.

### Sample/manual

Útil para UX/visual behavior, mas complementar. Não substitui contrato automatizado quando o comportamento pode ser testado.

## 4. Prove-It para bugfix

Sempre que tecnicamente possível:

1. reproduza o bug;
2. escreva/ajuste teste que falhe pelo motivo correto;
3. confirme a falha;
4. implemente a menor correção;
5. confirme teste focado verde;
6. execute escopo mais amplo adequado;
7. mantenha o teste como regressão.

Se não for possível automatizar a reprodução, registre por que e qual evidência alternativa foi usada.

## 5. Characterization tests

Antes de refatorar comportamento legado sem proteção:

- capture comportamento atual observável;
- não “corrija” o comportamento dentro do characterization test;
- somente depois altere estrutura;
- se a tarefa também muda comportamento, separe caracterização da nova expectativa.

## 6. Teste correto, não teste conveniente

Evite:

- assertar detalhes internos quando existe contrato público equivalente;
- mockar FMX quando o risco real é integração do visual tree;
- comparar strings de representação quando a API normaliza/serializa semanticamente;
- contar controles sem filtrar estado/visibilidade relevante;
- depender de ordem incidental da coleção de filhos quando não faz parte do contrato;
- inserir sleeps para mascarar sincronização não compreendida.

## 7. Lição generalizável de `TPathData.Data`

FireMonkey pode parsear e reserializar path data. Portanto a string recebida não é necessariamente uma identidade textual persistente.

Regra geral:

> Teste a garantia semântica da API, não uma representação incidental.

Quando a API normaliza, normalize expected e actual de forma equivalente antes de comparar.

## 8. Naming e legibilidade

O repositório usa nomes de teste descritivos em pt-BR, normalmente no padrão:

```text
Metodo_Condicao_DeveResultado
```

Preserve a convenção local do fixture. Nomes devem permitir entender o contrato sem abrir a implementação.

## 9. Setup/TearDown

Em testes FMX:

- crie host explicitamente;
- destrua no `TearDown` conforme ownership real;
- evite estado compartilhado entre testes;
- não deixe handler ou interface reter host após destruição sem intenção;
- valide cenários de detach quando lifetime faz parte do contrato.

## 10. Cobertura por mudança

Para uma mudança, classifique cenários:

- happy path;
- empty/default;
- boundary;
- invalid input;
- state transition;
- event callback;
- ownership/lifetime;
- repeated operation;
- component destruction;
- desktop/mobile quando o comportamento difere.

Nem toda mudança precisa de todos; selecione os que podem falhar realisticamente.

## 11. Anti-patterns

- alterar teste antes de provar que o requisito mudou;
- remover assertion que detecta regressão;
- afirmar “testado pelo Sample” quando não houve suíte;
- adicionar teste que passa antes da correção e chamá-lo de regressão;
- testar implementação privada em vez do contrato sem motivo;
- fazer full suite verde ignorando teste filtrado que ainda falha.

## 12. Reporting

Relate resultados com contagem real e contexto suficiente. Exemplo:

```text
DUnitX executado: 197 found / 197 passed / 0 failed / 0 errored / 0 leaked.
```

Se apenas teste focado foi executado, não generalize para a suíte inteira.
