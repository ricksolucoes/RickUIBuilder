# Padrão de Documentação Profunda por Componente

Este padrão decide **quando** criar `docs/<component>/` e que tipo de informação deve existir. Ele não obriga simetria documental entre componentes de complexidades diferentes.

## 1. Quando documentação profunda é justificada

Considere criar `docs/<component>/` quando dois ou mais sinais forem relevantes:

- mais de uma unit interna com responsabilidades distintas;
- API pública extensa;
- runtime Handle ou behavior stateful;
- lifetime/ownership não trivial;
- transformação de dados separada da UI;
- múltiplos modos de apresentação;
- virtualização/scroll complexo;
- custom rendering;
- plataforma desktop/mobile com comportamento diferente;
- configuração extensa;
- invariantes que um mantenedor pode quebrar sem perceber;
- histórico de regressões difíceis de diagnosticar.

Um Divider simples não precisa receber a mesma documentação do ComboBox por simetria.

## 2. Estrutura recomendada

A estrutura deve seguir a complexidade real. Possíveis tópicos:

```text
README
architecture-and-dependencies
public-api-and-configuration
data-state-and-selection
presentation
rendering
lifecycle-and-ownership
customization-and-examples
tests-and-contracts
maintenance-and-pitfalls
```

Não crie arquivos vazios para preencher essa lista.

## 3. README do componente

Deve permitir que um engenheiro responda rapidamente:

- o que o componente faz;
- quais são os entry points públicos;
- quais units precisam ser lidas para uma mudança específica;
- quais invariantes são críticos;
- onde ficam exemplos/testes;
- qual documento ler para cada classe de alteração.

## 4. Arquitetura e dependências

Documente:

- responsabilidade de cada unit;
- dependências relevantes;
- direção desejada das dependências;
- o que cada unit deliberadamente não faz;
- impacto típico de alteração.

Não invente diagramas que não correspondem aos `uses`/calls reais.

## 5. API pública

Documente contracts reais:

- builder methods;
- handles;
- records/enums;
- defaults;
- overloads;
- eventos;
- build semantics;
- lifetime observável.

## 6. Lifecycle

Quando aplicável, explique:

```text
create
→ configure
→ build
→ runtime interaction
→ detach/destruction
```

E responda:

- quem é owner;
- quem é parent;
- o handle possui o controle?;
- o controle pode morrer antes do handle?;
- que notification existe?;
- callbacks preservam referências?

## 7. Tests and contracts

Registre o que testes protegem, sem tratar cobertura atual como garantia de futuro. Baselines reais devem incluir data/revisão/contexto quando relevante.

## 8. Maintenance pitfalls

Inclua somente armadilhas reais sustentadas por código/testes/diagnóstico. Prefira formular como invariante generalizável, não diário de tentativa.

## 9. Bilinguismo

Quando a feature adota EN/PT-BR, os pares devem permanecer semanticamente equivalentes. Código deve ser idêntico, salvo comentários traduzidos quando necessário.

## 10. Trigger de atualização

Revisar docs quando mudar:

- API;
- config/default;
- arquitetura;
- dependência;
- state/data mapping;
- lifecycle;
- presentation;
- custom rendering;
- teste que documentava um contrato;
- known pitfall.
