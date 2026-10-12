---
name: api-and-interface-design
description: Protege o contrato público do RickUIBuilder ao criar ou alterar facade, fluent builders, interfaces, handles, GUIDs, records, enums, overloads e defaults. Use sempre que consumidores externos puderem observar a mudança.
---

# API and Interface Design

## Overview

API pública é custo de compatibilidade. Uma vez observável por consumidores, até detalhes não intencionais podem se tornar dependências. O workflow é **contract-first**: defina semântica, compatibilidade e testes antes de encaixar implementação.

Interfaces existentes seguem [`../../references/interface-contract-preservation-policy.md`](../../references/interface-contract-preservation-policy.md): a implementação se adapta ao contrato e não o contrário. A organização física das implementações públicas do novo `Edit` segue separadamente [`../../references/interface-implementation-unit-policy.md`](../../references/interface-implementation-unit-policy.md).

## When to Use

- `Rick.UIBuilder.pas`;
- `Rick.UIBuilder.Interfaces.pas`;
- `src/Edit/Rick.UIBuilder.Edit.Interfaces.pas`;
- `Rick.UIBuilder.Types.pas`;
- método fluent público;
- Handle público;
- overload/default novo;
- record/enum/config público;
- mudança em Build/BuildHandle semantics.

## Core Principles

### Hyrum's Law aplicado

Todo comportamento observável pode ter consumidor. Não mude silenciosamente:

- defaults;
- ordem de eventos;
- retorno/chaining;
- ownership observável;
- seleção inicial;
- tratamento de índice inválido;
- text/value semantics;
- exception behavior.

### Existing contract wins

Quando a interface já existe, ela é a fonte de verdade da implementação. Não altere assinatura, retorno, parâmetro, overload, GUID, membro, spelling público ou navegação fluent para resolver conveniência interna.

Mudança de contrato só entra no workflow quando o usuário a solicita explicitamente na tarefa atual. Dificuldade de obter estado/contexto não é autorização para mudar a interface.

### Prefer addition over mutation

Quando o requisito permite e compatibilidade importa, prefira adicionar capacidade a redefinir semântica existente. Isso não significa manter APIs ruins indefinidamente; breaking change precisa ser explícito.

Para interfaces existentes, até uma mudança aditiva continua sendo alteração de contrato e exige autorização explícita quando a tarefa atual não pediu mudança de API.

### One meaning per contract

Um método deve ter semântica previsível. Evite overloads cuja seleção depende de coerções/ambiguidade difíceis de ler.

### Fluent operations return contracts

Em uma interface fluent, uma operação mutável/configuradora que participa da cadeia deve retornar o contrato apropriado. Não use `procedure` quando a operação precisa permitir continuidade do fluent. `procedure` continua válida fora desse contexto quando esse for o significado correto do contrato.

### Interface dependencies use injected contracts

Quando uma interface especializada depende do contexto de uma interface pai, modele essa relação por contrato e injeção. A implementação especializada recebe a interface pai; não deve reconstruí-la, procurá-la globalmente nem depender da classe concreta apenas para retornar ao fluxo de origem.

Se o contrato existente determina retorno a outro nível da cadeia, a implementação deve conseguir chegar a esse contrato pela relação já existente. Não altere o retorno público para permanecer na implementação especializada.

### Templates describe structure, not names or unit placement

Nomes apresentados nesta skill são placeholders didáticos. Adapte-os ao domínio real. Por padrão, interfaces compartilhadas do framework permanecem em `Rick.UIBuilder.Interfaces.pas`; boundaries específicos já estabelecidos prevalecem. No novo `Edit`, todas as interfaces oficiais permanecem em `src/Edit/Rick.UIBuilder.Edit.Interfaces.pas`. Units concretas de implementação não declaram tipos `interface`; nelas ficam as classes concretas correspondentes. Quando existir implementação direta, preserve o par nominal `I<Nome>` / `T<Nome>` e não crie uma interface auxiliar redundante para o mesmo papel.

Para as 28 interfaces públicas do novo `Edit`, a separação física é obrigatória: uma interface → uma classe concreta → uma unit exclusiva de implementação. Não generalize essa regra automaticamente para outros componentes.

### Natural Delphi signature and class declaration formatting

Mantenha a assinatura em uma única linha enquanto couber de forma legível. Não quebre parâmetro ou retorno mecanicamente. Declarações de classe são sempre escritas integralmente em uma única linha, incluindo ancestral e lista de interfaces, por exemplo `TImplementation = class(TInterfacedObject, IImplementation)`. Para assinaturas de métodos, quebre somente quando o comprimento realmente exigir.

## Process

### Step 1 — Inventory current contract

Localize:

- unit oficial do contrato;
- signature;
- GUID/interface;
- defaults;
- builder implementation;
- Handle implementation;
- tests;
- README/docs/Sample.

Se a interface já existe, compare contra a fonte de verdade/baseline antes de implementar e trate-a como imutável salvo autorização explícita para mudança contratual.

### Step 2 — Define consumer need

Escreva a necessidade do consumidor, não a implementação.

Exemplo:

> O consumidor precisa atualizar a cor da seta após Build.

Isso pode implicar Handle method; não implica automaticamente novo config record.

### Step 3 — Classify compatibility

#### Additive

Novo método/type sem alterar comportamento antigo.

#### Source-compatible behavior change

Código existente compila, mas comportamento muda. Ainda é risco alto.

#### Breaking

Consumer precisa mudar código ou contrato binário/semântico deixa de valer.

Não esconda categoria.

Se a tarefa atual não autoriza mudança de contrato, pare antes de escolher uma dessas categorias como solução para conveniência de implementação.

### Step 4 — Design signature

Esta etapa só redesenha assinatura quando a tarefa autoriza criar/alterar contrato. Para implementar interface existente, a assinatura já está definida e deve ser preservada.

Quando aplicável, avalie:

- naming consistente;
- parâmetro order;
- overload ambiguity;
- default values;
- fluent return type;
- nullable/empty semantics;
- invalid input semantics;
- exception behavior;
- runtime versus build-time configuration.

### Step 5 — Interfaces, GUIDs e dependency direction

Antes de adicionar ou alterar membro de interface pública, confirme que a tarefa atual autorizou explicitamente a mudança contratual.

Quando a mudança estiver autorizada:

- identifique todos implementadores;
- identifique consumidores internos;
- preserve GUID salvo estratégia de versionamento explícita;
- analise impacto em compatibility do framework;
- adicione teste de contrato quando aplicável.

Independentemente de haver mudança contratual, quando a implementação depender de outro nível da cadeia:

- identifique se existe dependência entre contratos;
- determine qual contrato é o pai/origem e qual é a interface especializada dependente;
- determine se a especializada precisa navegar de volta ao contrato de origem;
- reutilize o contrato existente em vez de criar getter/interface/estado paralelo por conveniência;
- modele lifetime/reference counting antes de escolher referência forte ou não proprietária.

Quando houver relação pai → interface especializada → retorno ao pai, use o padrão estrutural descrito em **Parent-aware interface pattern** abaixo.

### Step 6 — Fluent operations, overloads e defaults

Para cada operação pública, classifique-a como:

- consulta/getter;
- configuração fluent no contrato atual;
- entrada em interface especializada;
- retorno ao contrato pai;
- operação terminal;
- operação não fluent.

Regras:

- em interface existente, preserve exatamente o retorno já definido mesmo quando outra forma seria mais conveniente à implementação;
- configuração fluent retorna o contrato atual quando esse for o contrato estabelecido;
- não use `procedure` para configuração que precisa continuar a cadeia;
- se a mesma operação possuir formas semanticamente distintas de chamada e a mudança de API estiver autorizada, avalie `overload` explícito;
- não use parâmetro default apenas para esconder essas variantes;
- overloads simplificados devem delegar à forma completa quando compartilham a mesma regra;
- não crie overloads por simetria quando não houver forma de uso real.

### Step 7 — Record/enum changes

Para config record:

- `Default` deve inicializar novo field;
- builder precisa aplicar novo field;
- Factory/runtime precisa consumir;
- docs precisam descrever;
- teste de default quando relevante.

Para enum:

- preserve member meanings;
- scoped use;
- `case` statements precisam tratar novo member;
- `Auto`/fallback semantics precisam ser explícitas quando existirem.

### Step 8 — Build vs runtime

Pergunte:

- é configuração antes de Build?;
- precisa mudar depois de Build?;
- Handle é o contrato correto?;
- modificar builder após Build deve afetar controle existente ou apenas próximo Build?

Não misture esses lifecycles silenciosamente nem exponha nova API apenas para contornar uma necessidade interna.

### Step 9 — Contract tests first

Proteja:

- chaining;
- default;
- overload selecionado;
- value returned;
- runtime effect;
- invalid input;
- ownership/lifetime se observável.

### Step 10 — Implement internally

Somente depois do contrato estar claro, escolha implementação/cohesion adequada.

Para interface existente, a direção é sempre:

```text
contrato oficial
→ implementação se adapta
→ usa contratos já existentes para contexto/navegação
```

Nunca:

```text
implementação precisa de conveniência
→ contrato público é alterado
```

### Step 11 — Documentation and Sample

Atualize somente quando API final estabilizar. README mostra uso essencial; docs profundas explicam semantics/maintenance.

## Parent-aware interface pattern

Use este padrão quando uma interface especializada precisa do contexto da interface que a originou. Ele é um **template estrutural do projeto**: os nomes são placeholders e devem ser substituídos pelo vocabulário real do domínio.

### 1. Contratos ficam fora da implementação concreta

Os contratos devem permanecer na unit oficial do boundary correspondente. Por padrão, contratos compartilhados do framework ficam em `Rick.UIBuilder.Interfaces.pas`. No novo `Edit`, o boundary oficial é `src/Edit/Rick.UIBuilder.Edit.Interfaces.pas`. Uma unit concreta de implementação não declara tipo `interface`. O exemplo abaixo mostra somente a forma dos contratos:

```delphi
type
  iInjected = interface;

  iParent = interface
    function Injected: iInjected;
  end;

  iInjected = interface
    function ToBack: iParent;
  end;
```

`iParent`, `iInjected`, `Injected` e `ToBack` são nomes didáticos. Não os copie para código real sem validar a nomenclatura do domínio.

### 2. Implementação simples, sem Parent

Quando a implementação não depende de um contrato pai, use a estrutura simples equivalente ao template base:

```delphi
type
  TControllerPadrao = class(TInterfacedObject, iPadrao)
  protected
    constructor Create;
  public
    destructor Destroy; override;
    class function New: iPadrao;
  end;
```

```delphi
constructor TControllerPadrao.Create;
begin
end;

class function TControllerPadrao.New: iPadrao;
begin
  Result := Self.Create;
end;
```

Não adicione Parent, overloads ou navegação se a dependência não existe.

### 3. Implementação especializada com Parent injetado

Quando a implementação depende do contrato que a originou, a referência de retorno fica na classe especializada:

```delphi
type
  TControllerPadrao = class(TInterfacedObject, iPadrao)
  private
    [weak]
    FParent: iPadraoParent;
    procedure SetupStart;
  protected
    function ToBack: iPadraoParent;
    constructor Create; overload;
    constructor Create(const AValue: iPadraoParent); overload;
  public
    destructor Destroy; override;
    class function New: iPadrao; overload;
    class function New(const AValue: iPadraoParent): iPadrao; overload;
  end;
```

Os overloads com e sem Parent só devem coexistir quando os dois modos de construção forem válidos para aquele contrato. `SetupStart` é um detalhe privado de implementação; `procedure` é válida nesse papel porque não pertence ao contrato fluent público.

A inicialização compartilhada deve permanecer em um único ponto quando houver lógica comum:

```delphi
constructor TControllerPadrao.Create;
begin
  SetupStart;
end;

constructor TControllerPadrao.Create(const AValue: iPadraoParent);
begin
  FParent := AValue;
  SetupStart;
end;
```

Factories correspondentes:

```delphi
class function TControllerPadrao.New: iPadrao;
begin
  Result := Self.Create;
end;

class function TControllerPadrao.New(const AValue: iPadraoParent): iPadrao;
begin
  Result := Self.Create(AValue);
end;
```

### 4. Retorno ao contrato de origem

Quando a cadeia precisa voltar ao contrato pai, retorne o `FParent` injetado. Não recrie o pai e não procure uma instância global:

```delphi
function TControllerPadrao.ToBack: iPadraoParent;
begin
  if (not Assigned(FParent)) or (FParent = nil) then
    raise Exception.Create('O Parent da interface não foi informado para retornar.');

  Result := FParent;
end;
```

O nome da função de retorno deve seguir o vocabulário aprovado para o domínio. O template demonstra o papel arquitetural, não impõe um identificador global.

Se a interface existente já determina retorno a um contrato específico, preserve esse retorno e injete/obtenha o contrato de origem necessário; não mude a assinatura para retornar a interface mais conveniente.

### 5. Criação da interface especializada pelo Parent

Quando o contrato pai expõe e mantém a interface especializada, a implementação pai pode criá-la de forma lazy e injetar `Self`:

```delphi
function TControllerParent.Injected: iInjected;
begin
  if not Assigned(FInjected) then
    FInjected := TControllerInjected.New(Self);

  Result := FInjected;
end;
```

Os papéis são distintos:

```text
Parent implementation
  mantém FInjected: iInjected
        ↓ New(Self)
Injected implementation
  mantém FParent: iParent [non-owning quando necessário]
        ↓ retorno
Parent contract
```

Não confunda o campo que mantém a interface especializada no pai com `FParent`, que pertence à implementação especializada e representa o contrato de origem.

### 6. Lifetime obrigatório

Se o pai mantém a interface especializada e a especializada mantém uma referência ao pai, existe potencial de ciclo:

```text
iParent -> iInjected
   ^          |
   |----------|
```

Antes de implementar:

1. confirme a estratégia de reference counting do projeto/versão Delphi;
2. identifique qual referência é proprietária;
3. mantenha a referência de retorno ao Parent como não proprietária quando necessário para quebrar o ciclo;
4. não copie `[weak]` mecanicamente se a compatibilidade não estiver confirmada;
5. teste/descreva o lifetime conforme o risco da mudança.

### 7. Fluent sobre a interface especializada

Operações configuradoras dentro da interface especializada retornam a própria interface quando esse for o contrato definido:

```delphi
function Configure(const AValue: string): iInjected;
```

Não use:

```delphi
procedure Configure(const AValue: string);
```

quando a operação pertence ao encadeamento fluent.

O fluxo conceitual esperado deve ser lido da interface real. Em um desenho típico:

```text
interface principal
  -> interface especializada
       -> configurações especializadas
       -> retorno ao Parent
  -> demais configurações da interface principal
  -> operação terminal
```

Não ajuste o contrato existente para forçar esse exemplo quando a API real define outro retorno.

### 8. Overloads como contrato explícito

Quando houver variantes reais da mesma operação e a mudança contratual estiver autorizada, prefira overloads explícitos:

```delphi
function Configure(AValue: Boolean): iPadrao; overload;
function Configure(const AMessage: string): iPadrao; overload;
function Configure(AValue: Boolean; const AMessage: string): iPadrao; overload;
```

Quando compartilham a mesma regra, delegue os overloads simples ao completo:

```delphi
function TControllerPadrao.Configure(AValue: Boolean): iPadrao;
begin
  Result := Configure(AValue, EmptyStr);
end;

function TControllerPadrao.Configure(const AMessage: string): iPadrao;
begin
  Result := Configure(True, AMessage);
end;
```

Não substitua esse contrato por parâmetro default apenas para reduzir a quantidade de assinaturas.

### 9. Formatação das assinaturas e declarações de classe

Correto quando couber de forma legível:

```delphi
function Configure(AValue: Boolean; const AMessage: string): iPadrao;
constructor Create(const AValue: iPadraoParent); overload;
class function New(const AValue: iPadraoParent): iPadrao; overload;
```

Evite quebra mecânica como:

```delphi
function Configure(
  AValue: Boolean;
  const AMessage: string
): iPadrao;
```

A quebra de assinatura só é válida quando o comprimento real prejudicar a leitura. Declaração de classe não segue essa exceção: `TControllerPadrao = class(TInterfacedObject, iPadrao)` deve permanecer integralmente em uma linha; não coloque ancestral e interfaces em linhas separadas.

## Interface Design Questions

- A tarefa autoriza criar/alterar contrato ou apenas implementar o existente?;
- Precisa interface pública ou method no builder já resolve?;
- O Handle já é o boundary runtime?;
- Nova interface tem mais de um consumidor/implementador provável?;
- Estamos expondo detalhe interno que impedirá refactor futuro?;
- O consumidor precisa do concrete FMX control ou só uma operação semântica?;
- O contexto necessário já pertence a um contrato existente que pode ser injetado?;

## Overload Decision Guide

Use overload quando a alteração contratual estiver autorizada e houver:

- mesma intenção;
- inputs alternativos claramente distinguíveis;
- semântica de retorno idêntica;
- resolução pelo compiler é clara;
- variantes precisam aparecer explicitamente no contrato em vez de ficarem escondidas por default.

Quando overloads compartilham a mesma regra, faça as formas simplificadas delegarem à forma completa. Considere nome diferente quando overloads representam operações semanticamente diferentes.

## Additional Contract Principles

### Consistent failure semantics

Métodos semelhantes devem tratar input inválido de maneira consistente. Antes de introduzir exception, no-op ou fallback:

- veja como APIs irmãs tratam o mesmo tipo de erro;
- preserve comportamento existente quando não há requisito de mudança;
- documente comportamento público não óbvio;
- teste invalid input quando consumidor pode depender disso.

Não transforme erro de programação em silêncio apenas para deixar API “amigável”.

### Validate at boundaries

Valide no boundary que recebe informação externa/pública quando a validação faz parte do contrato. Não espalhe checks idênticos em múltiplas camadas.

Exemplos:

- índice recebido por Handle;
- config value público;
- path/string externo;
- callback opcional.

### Predictable naming

Use vocabulário já existente no framework:

- `Build` / `BuildHandle`;
- `ItemIndex` / `SelectedText` / `SelectedValue`;
- `FillColor`, `TextColor`, etc.

Não crie sinônimo novo para conceito existente (`CurrentIndex` versus `ItemIndex`) sem razão contratual. Não “corrija” spelling de identificador público existente sem autorização de mudança contratual.

### Input/output separation

Não exponha internal mutable state apenas para evitar método público. Prefira usar o contrato já existente que representa a responsabilidade. Nova capacidade pública só deve ser criada quando a necessidade do consumidor e o escopo autorizarem.

### One-version mindset

Não adicione compat shims, aliases ou APIs duplicadas “por segurança” sem estratégia de depreciação solicitada. O framework deve ter um contrato atual claro.

## API Change Matrix

| Tipo de mudança | Risco | Ação mínima |
|---|---|---|
| Novo fluent setter aditivo | médio | autorização de API + chaining + config/default + docs |
| Novo Handle method | médio/alto | autorização de API + runtime semantics + lifetime + integration test |
| Novo enum member | médio | resolver/cases/defaults + tests |
| Alterar default | alto | behavioral compatibility + docs + tests |
| Alterar interface member | alto | autorização explícita + implementers + GUID/compat strategy + tests |
| Renomear método público | breaking | autorização explícita + migration/docs |
| Mudar Build ownership | crítico | lifetime design + integration/destruction tests |

## Public Boundary Checklist

Antes de finalizar contract:

- a tarefa autoriza a mudança pública?;
- nome é consistente?;
- tipo expressa semântica?;
- default preserva comportamento?;
- invalid input é previsível?;
- return/chaining é consistente?;
- runtime update ocorre imediatamente ou só no próximo Build?;
- consumidor precisa concrete FMX type?;
- API pode ser implementada sem vazar detail interno?;
- docs conseguem explicar o contrato sem conhecer implementação?

## Versioning and Deprecation

Não crie estratégia de depreciação sem demanda. Quando uma API precisa ser substituída e a tarefa autoriza essa mudança:

1. identifique consumers;
2. defina janela/estratégia explicitamente;
3. prefira coexistência temporária somente se autorizada;
4. documente migration;
5. remova zombie API quando a migração for concluída, não indefinidamente.

## Common Rationalizations

| Racionalização | Realidade |
|---|---|
| “É só adicionar um método na interface.” | Interface pública afeta todos implementadores/consumidores e lifetime; exige escopo autorizado. |
| “A implementação precisa desse retorno.” | Necessidade interna não autoriza mudar o contrato; obtenha o contexto pelo contrato/origem existente. |
| “É mais fácil devolver a interface atual.” | Se a interface oficial retorna outro contrato, a implementação precisa se adaptar. |
| “Código antigo continua compilando, então é compatível.” | Behavioral compatibility também importa. |
| “Mudar o GUID resolve versionamento.” | GUID não é knob de build; é identidade contratual. |
| “Mais overloads são sempre mais ergonômicos.” | Ambiguidade e semantics sobrepostas pioram API. |
| “Depois atualizamos docs.” | API pública sem docs/testes vira contrato acidental. |

## Red Flags

- interface existente alterada sem solicitação explícita de mudança contratual;
- signature nasce da implementation convenience;
- retorno é alterado porque a classe não consegue chegar ao contrato exigido;
- getter/interface/state é criado apenas para transportar contexto interno;
- default novo não aparece em `Default` record;
- enum novo não tratado por resolver/case;
- Handle ganha setter sem comportamento runtime testado;
- builder post-Build semantics mudam sem documentação;
- interface expõe concrete implementation desnecessariamente;
- interface especializada depende da classe concreta do Parent sem necessidade;
- implementação especializada procura/recria Parent em vez de receber o contrato por injeção;
- pai e especializada mantêm referências fortes circulares;
- `procedure` é usada para configuração que deveria continuar o fluent;
- parâmetro default esconde variantes que deveriam ser overloads explícitos;
- assinatura é quebrada mecanicamente apesar de caber em uma linha legível;
- GUID alterado sem breaking strategy;
- interface do novo `Edit` movida para fora de `src/Edit/Rick.UIBuilder.Edit.Interfaces.pas`;
- duas implementações públicas do novo `Edit` agrupadas na mesma unit.

## Verification

- [ ] Current contract foi inventariado a partir da unit oficial.
- [ ] Se o contrato existente mudou, existe solicitação explícita do usuário na tarefa atual.
- [ ] Implementação não alterou interface apenas para obter contexto/chaining mais conveniente.
- [ ] Need do consumidor está clara quando há mudança de API autorizada.
- [ ] Compatibilidade foi classificada quando há mudança de API autorizada.
- [ ] Signature/default/overload semantics são inequívocos.
- [ ] Variantes públicas foram avaliadas quanto a overload explícito versus default.
- [ ] Operações configuradoras fluent preservam o retorno definido pelo contrato.
- [ ] Dependências entre interfaces usam contratos/injeção quando o padrão é aplicável.
- [ ] Relação Parent/especializada foi revisada quanto a `FParent`, ownership e ciclos fortes.
- [ ] Contratos permanecem separados das implementações concretas conforme os boundaries do projeto.
- [ ] Novo `Edit` preserva `Rick.UIBuilder.Edit.Interfaces.pas` como contrato e a organização 1 → 1 → 1 das implementações públicas.
- [ ] Assinaturas permanecem em uma linha quando legíveis.
- [ ] GUID/interface impact foi revisado.
- [ ] Build-time vs runtime semantics estão explícitas.
- [ ] Contract tests protegem a mudança quando aplicável.
- [ ] Implementação não vazou detalhe desnecessário.
- [ ] Docs/Sample foram revisados conforme impacto.
