# Delphi Quality Gates

Referência compartilhada para critérios técnicos de alterações Delphi/Object Pascal.

## 1. Sintaxe e compatibilidade

- use sintaxe já compatível com o projeto;
- não introduza recurso de versão de compiler não confirmada;
- preserve namespaces e unit resolution;
- mantenha `interface uses` apenas para dependências necessárias ao contrato público;
- mova dependências privadas para `implementation uses` quando isso reduz acoplamento sem alterar API;
- não use conditional compilation sem necessidade comprovada.

## 2. Public contracts

### Interfaces

- GUID é identidade pública; não alterar por conveniência;
- entender ownership implícito via `IInterface`/reference counting;
- não armazenar interface temporária em campo object sem modelar lifetime;
- mudanças em interface exigem busca por implementadores e consumidores;
- quando uma interface especializada depende do contexto de uma interface pai, a implementação deve receber o contrato necessário por injeção em vez de depender da classe concreta;
- quando a interface especializada precisa retornar ao contrato de origem, a implementação deve manter `FParent` com o contrato pai e o lifetime dessa referência deve ser explicitamente modelado;
- pai mantendo a especializada e especializada mantendo o pai exige análise de ciclo forte; referência de retorno proprietária que produz ciclo é finding bloqueante;
- service locator, lookup global ou reconstrução do pai no lugar de uma dependência diretamente injetável é não conforme, salvo justificativa técnica comprovada;
- contratos públicos e implementações concretas devem respeitar as units/boundaries definidos pelo projeto.

### Records e enums

- preserve significado e defaults;
- use Scoped Enums qualificados;
- avalie impacto de novo field em inicialização/defaults/serialização se existir;
- não use record como Parameter Object apenas para reduzir `Parameters`.

### Fluent builders

- preserve chaining;
- operações mutáveis/configuradoras pertencentes ao fluent devem retornar o contrato apropriado; `procedure` nesse papel é não conforme;
- operações dentro de uma interface especializada devem retornar o próprio contrato enquanto a cadeia permanecer nela;
- retorno ao contrato pai deve ser explícito quando fizer parte do fluxo;
- Build/BuildHandle devem preservar ownership/lifetime documentado;
- overloads devem ser inequívocos;
- variantes semanticamente distintas não devem ser escondidas por parâmetro default quando o contrato deve expô-las como overloads;
- overload simplificado deve delegar à forma completa quando compartilham a mesma regra, evitando duplicação.

## 3. Lifetime e ownership

Perguntas mínimas:

1. Quem cria o objeto?
2. Quem possui (`Owner`)?
3. Existe `Parent` visual?
4. Quem destrói primeiro?
5. Alguma referência é non-owning?
6. É necessário `FreeNotification`?
7. Alguma interface prolonga lifetime?
8. Algum callback captura owner/handle/control?
9. Há risco de double-free?
10. Há risco de dangling reference?

Sem respostas para relações relevantes, o gate de lifetime não passa.

## 4. FMX

- `Owner` e `Parent` têm papéis diferentes;
- `Parent` define inserção visual; `Owner` participa de lifetime de `TComponent`;
- `TObject` sem owner precisa de estratégia explícita de destruição;
- visual child não implica que toda referência externa permanece válida;
- alteração de eventos deve considerar substituição de handlers existentes;
- `HitTest=False` em elemento visual significa que outro objeto deve receber interação, se necessário;
- cuidado com visual roots/forms versus parent lógico.

## 5. Error handling

- não engolir exception apenas para deixar teste verde;
- não usar `try/except` amplo sem comportamento definido;
- não converter erro de programação em fallback silencioso;
- preserve exception behavior público se consumidor puder depender dele.

## 6. Performance e alocação

Não otimize sem evidência, mas revise:

- criação repetida de controles em scroll/loops;
- rebuilding integral quando atualização incremental é suficiente;
- coleções copiadas desnecessariamente;
- event handlers acumulados;
- objetos temporários em hot paths.

Para ComboBox, consulte documentação específica antes de tocar virtualização.

## 7. Method Toxicity

Limites:

| Métrica | Gate |
|---|---:|
| Length | <= 20 |
| Parameters | <= 6 |
| If Depth | <= 5 |
| Cyclomatic Complexity | <= 6 |
| Toxicity | < 1 |

Consulte `method-toxicity-baseline.md` e a skill `method-toxicity` para workflow completo.

## 8. Formatação de assinaturas Delphi

- mantenha declarações e implementações de métodos em uma única linha enquanto forem legíveis;
- não quebre parâmetros/retorno mecanicamente;
- quebre somente quando o comprimento realmente justificar;
- não compacte múltiplas instruções em uma linha para manipular `Length`;
- quebra desnecessária de assinatura em código criado/alterado é finding de conformidade.

## 9. Encoding

Qualquer `.pas` modificado precisa iniciar com bytes:

```text
EF BB BF
```

Isso é gate de entrega. Não converter unidades não alteradas.

## 10. Red flags

- `FreeAndNil` usado sem saber quem é owner;
- interface armazenada junto com raw object para o mesmo instance sem análise;
- evento substituído e callback anterior perdido sem requisito;
- cast de `Parent` sem prova do tipo;
- alteração de GUID sem breaking-change explícito;
- unit nova somente para contornar limite de tamanho;
- método extraído que apenas desloca branches sem melhorar responsabilidade;
- `.pas` alterado sem BOM;
- `procedure` configuradora quebrando uma cadeia fluent;
- parâmetro default ocultando variantes públicas que deveriam ser overloads explícitos;
- interface especializada dependendo da classe concreta do pai sem justificativa;
- relação pai/especializada com ciclo forte de interfaces;
- assinatura quebrada em várias linhas sem necessidade real.
