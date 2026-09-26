# Delphi Failure Triage

## Compiler / build

```text
Unknown identifier?
├─ symbol existe? → não: typo/API mismatch
├─ uses presente? → não: dependency
├─ visibility correta? → interface/private
└─ versão/compiler suporta? → source-driven check
```

```text
Ambiguous overload?
├─ overload novo?
├─ implicit conversion?
├─ default parameter collision?
└─ qualified type necessário?
```

## DUnitX

### Failure

- leia assertion;
- capture expected/actual;
- valide se expected representa contrato atual;
- confira estado/setup.

### Error/AV

Priorize:

- Setup/TearDown;
- parent/owner destruction;
- helper com cast;
- callback tardio;
- dangling reference;
- child iteration durante mutation.

## FMX visual

Checklist:

- control existe?;
- parent correto?;
- visible/opacity?;
- align/size?;
- clipped?;
- behind sibling?;
- HitTest/focus?;
- host correto?;
- style/presentation mode correto?

## Runtime handle

- `IsAttached` esperado?;
- visual target ainda existe?;
- notification foi recebida?;
- handle é owner ou non-owning?;
- interface forte está prolongando objeto?

## Method Toxicity regression

Se CSV reporta regressão:

1. localize método alterado;
2. compare before/after se disponível;
3. identifique branch/length introduzido;
4. simplifique responsabilidade real;
5. não extraia wrappers cosméticos;
6. reexecute ferramenta para resultado real.
