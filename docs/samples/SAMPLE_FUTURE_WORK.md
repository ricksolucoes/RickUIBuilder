# Pendências Futuras do Sample do Rick.UIBuilder

## 1. Objetivo

Este arquivo registra atividades futuras do sample que dependem da evolução real da biblioteca `Rick.UIBuilder`.

Ele existe para impedir que funcionalidades planejadas ou possíveis sejam confundidas com APIs já disponíveis.

As entradas deste arquivo são **pendências de revisão**, não requisitos de implementação automática da biblioteca.

## 2. Regra fundamental

Uma pendência registrada aqui não autoriza:

- criar uma nova API pública;
- alterar contratos existentes;
- adicionar métodos à Factory;
- modificar builders;
- apresentar uma funcionalidade como disponível antes de sua implementação real;
- criar exemplos que dependam de uma API inexistente.

Antes de executar qualquer item, o código vigente deve ser analisado novamente.

## 3. Edit — revisão de integração com Factory

**Status:** PENDENTE  
**Motivo:** o componente Edit ainda está em desenvolvimento.

### 3.1 Estado atual confirmado

No estado analisado:

- `TRickUIBuilder.Edit` expõe o Edit através do Fluent Builder;
- o sample possui demonstrações do Edit em `RickUIBuilderSample.Edit.pas`;
- `TRickUIBuilderFactory` não possui `CreateEdit`;
- portanto, o Edit não deve aparecer atualmente como opção Factory no sample.

### 3.2 Interpretação obrigatória

A ausência atual de `Factory.CreateEdit` **não deve ser tratada automaticamente como decisão arquitetural definitiva**.

Também não deve ser interpretada como autorização para implementar `Factory.CreateEdit` durante a reorganização do sample.

A decisão deve ser tomada somente depois que a implementação do Edit estiver concluída e a API pública final puder ser analisada.

### 3.3 Gatilho para revisão

Revisar esta pendência quando o desenvolvimento do Edit for declarado concluído para a etapa correspondente do projeto.

### 3.4 Processo obrigatório de revisão

Quando o gatilho ocorrer:

1. analisar novamente `Rick.UIBuilder.pas`;
2. analisar `Rick.UIBuilder.Factory.pas`;
3. analisar `Rick.UIBuilder.Edit.pas` e suas units relacionadas;
4. analisar `Rick.UIBuilder.Interfaces.pas` e `Rick.UIBuilder.Types.pas` quando necessário para confirmar contratos e configurações;
5. verificar testes existentes relacionados ao Edit;
6. verificar documentação vigente do Edit;
7. determinar, com base no código real, se existe suporte Factory para o Edit;
8. atualizar o sample somente depois dessa confirmação.

### 3.5 Fluxo de decisão

```text
Edit concluído
      ↓
Revisar API pública final
      ↓
Existe suporte Factory para Edit?
   ┌───────────────┴───────────────┐
   │                               │
  NÃO                             SIM
   │                               │
   ▼                               ▼
Manter Edit somente          Verificar contrato e
nas abordagens realmente     possibilidades reais da
suportadas                    Factory para o Edit
                                   │
                                   ▼
                              Criar demonstração
                              Factory no sample
                                   │
                                   ▼
                              Atualizar documentação
                              e navegação
```

### 3.6 Se Factory.Edit NÃO existir após a conclusão do Edit

Se a API final continuar sem suporte Factory:

- manter o Edit somente nas abordagens realmente suportadas;
- não criar entrada vazia ou desabilitada na tela Factory apenas para obter simetria visual;
- documentar a estrutura real sem tratar a diferença como erro;
- encerrar esta pendência registrando que a revisão foi realizada e que não existe suporte Factory no estado final analisado.

### 3.7 Se Factory.Edit existir após a conclusão do Edit

Se o código final disponibilizar suporte Factory para Edit:

1. identificar a assinatura pública real;
2. identificar os records, interfaces e configurações realmente aplicáveis;
3. mapear quais cenários fazem sentido na abordagem Factory;
4. adicionar Edit à navegação Factory do sample;
5. criar a unit de demonstração correspondente somente se houver responsabilidade suficiente para justificar uma unit própria;
6. utilizar a API pública existente, sem reproduzir lógica interna do componente;
7. adicionar XMLDoc aos métodos de demonstração relevantes;
8. atualizar o cabeçalho técnico da unit;
9. atualizar `SAMPLE_ARCHITECTURE.md` para refletir o novo estado;
10. atualizar demais documentos do sample afetados pela mudança;
11. executar as validações de código aplicáveis.

### 3.8 Não presumir equivalência entre Factory e Fluent Builder

Mesmo que Factory.Edit venha a existir, não assumir que ela oferece exatamente os mesmos recursos ou a mesma forma de configuração do Fluent Builder.

A futura demonstração deve ser construída a partir do contrato Factory real.

Não duplicar exemplos apenas para tornar as duas áreas visualmente simétricas.

## 4. Revisão documental da fachada após conclusão do Edit

**Status:** PENDENTE  
**Motivo:** o Edit ainda está em desenvolvimento e a documentação da fachada deve refletir o estado final.

No estado analisado, `TRickUIBuilder.Edit` existe como método público. Entretanto, o cabeçalho descritivo de `Rick.UIBuilder.pas` enumera os builders fluentes sem mencionar o Edit.

Quando o desenvolvimento do Edit for concluído:

1. revisar o cabeçalho de `Rick.UIBuilder.pas`;
2. revisar XMLDoc relacionado à fachada;
3. revisar README e documentação do sample;
4. garantir que a lista de builders e abordagens represente exatamente a API final;
5. não documentar Factory.Edit caso ela não exista.

Esta entrada registra somente uma necessidade de revisão documental futura. Ela não autoriza alterações antecipadas na API.

## 5. Critério para encerrar uma pendência

Uma pendência deste arquivo somente deve ser marcada como concluída quando:

- o gatilho correspondente tiver ocorrido;
- o código vigente tiver sido analisado;
- a decisão estiver sustentada pela implementação real;
- as alterações necessárias tiverem sido executadas, quando aplicável;
- documentação e sample estiverem sincronizados com o código final;
- validações aplicáveis tiverem sido registradas sem inventar resultados.

Se alguma informação necessária não puder ser confirmada, registrar explicitamente: **Não confirmado.**

## 6. Relação com a especificação principal

`SAMPLE_ARCHITECTURE.md` descreve a arquitetura planejada do sample com base nas APIs disponíveis no estado analisado.

Este arquivo registra dependências futuras que ainda não podem ser incorporadas como funcionalidades atuais.

A regra de separação é:

```text
Existe e foi confirmado
        ↓
SAMPLE_ARCHITECTURE.md

Ainda depende de implementação ou decisão futura
        ↓
SAMPLE_FUTURE_WORK.md
```

Essa separação deve ser preservada para evitar que uma pessoa ou uma IA transforme backlog em comportamento existente.
