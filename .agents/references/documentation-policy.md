# Política de Documentação

## 1. Princípio

Documentação é uma representação do **estado final implementado**, não uma lista de intenções nem um changelog disfarçado.

Fonte de verdade para documentação:

1. código final;
2. API pública em `Interfaces`/`Types`/facade/builders;
3. testes e resultados reais;
4. documentação de domínio existente;
5. Sample como exemplo de uso público suportado;
6. fontes oficiais externas quando a explicação depende de Delphi/FMX/DUnitX.

## 2. Localização

### README principal

`README.md` e `README.pt-BR.md` devem conter:

- objetivo do framework;
- quick start;
- arquitetura em alto nível;
- catálogo de componentes;
- exemplos essenciais;
- build/test/quality conhecidos;
- links para documentação profunda;
- visão geral da governança de IA.

Não devem duplicar documentação interna extensa de um componente.

### `docs/<feature>/`

Use quando a complexidade exigir explicação aprofundada de:

- múltiplas units;
- API extensa;
- lifecycle/ownership;
- state/data/presentation separados;
- modos de comportamento;
- invariantes de manutenção;
- exemplos avançados;
- armadilhas relevantes.

### `.agents/`

Governança de engenharia. Não é documentação pública da API do framework.

### XMLDoc/comentários

Use para contratos locais e não óbvios que devem acompanhar o código. Não use comentário para repetir o que o nome já diz.

## 3. EN/PT-BR

Quando um documento possui par bilíngue:

- mesma estrutura lógica;
- mesmos exemplos;
- mesmas APIs;
- mesmas tabelas;
- mesmas limitações;
- adaptação natural da linguagem, não tradução literal artificial.

Uma mudança técnica em um idioma exige revisão do par.

## 4. Timeless language

Prefira:

> `BuildHandle` retorna um handle runtime não-owning sobre a árvore visual.

Evite:

> Agora `BuildHandle` foi corrigido para...

Histórico só deve aparecer quando o propósito do documento for histórico/migração.

## 5. Exemplos

Todo exemplo deve:

- usar API existente;
- refletir signatures reais;
- preservar nomes de tipos/enums;
- evitar features hipotéticas;
- ser pequeno o suficiente para evidenciar o contrato relevante;
- ser revisado após mudança pública.

## 6. ADR

Crie ADR somente quando existir decisão arquitetural duradoura que futuras mudanças precisam compreender.

Bons candidatos:

- nova fronteira de módulo;
- novo modelo de lifetime;
- mudança de estratégia de API pública;
- decisão cross-component;
- adoção de padrão fundamental.

Não crie ADR para bugfix localizado, rename ou detalhe de implementação reversível.

## 7. Maintenance knowledge

Quando uma investigação revela uma armadilha recorrente, registre-a no local mais apropriado:

- comportamento específico de um componente → `docs/<component>/`;
- regra de engenharia geral → `.agents/references/` ou skill;
- tentativa de debugging temporária → Attempt Log da tarefa, não documentação permanente;
- decisão arquitetural → ADR.

## 8. Review documental

Antes de concluir:

- compare afirmações com código final;
- verifique links;
- valide exemplos;
- cheque nomenclatura;
- cheque paridade EN/PT-BR;
- remova intenção não implementada;
- não copie baseline antiga como se fosse atual.
