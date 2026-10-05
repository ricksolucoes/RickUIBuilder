# Especificação — listas no ComboBox Factory

**Projeto:** RickUIBuilder\
**Status:** definição funcional --- pré-implementação\
**Escopo:** evolução futura da abordagem Factory do `ComboBox`

> Este documento define uma capacidade futura. Ele não afirma que suporte a
> listas já exista em `TRickUIBuilderFactory.CreateComboBox`.

## 1. Objetivo

Evoluir a abordagem Factory do `ComboBox` para que seja possível fornecer os
dados da lista e materializar um ComboBox funcional sem obrigar o consumidor a
usar a API Fluent e sem expor classes internas do runtime.

A evolução deverá reutilizar, quando tecnicamente adequado, os contratos
públicos que já representam itens, colunas e runtime do ComboBox.

## 2. Estado atual comprovado

No baseline analisado, a Factory pública expõe:

```delphi
class function CreateComboBox(AOwner: TComponent; AParent: TFmxObject;
  const AConfig: TRickUIBuilderComboBoxConfig; out ATextLabel: TLabel;
  out AArrow: TPath): TRectangle; static;
```

A implementação atual:

1. cria o `TRectangle` principal;
2. aplica a configuração visual do controle fechado;
3. cria o `TLabel` interno;
4. cria o `TPath` da seta;
5. devolve `ATextLabel` e `AArrow` como referências non-owning.

A chamada não recebe coleção de itens, colunas ou seleção e não materializa
popup/superfície de seleção.

## 3. Modelos de dados já existentes na API pública

A API pública do ComboBox já possui os tipos necessários para representar os
modelos de dados usados pelo Fluent.

### 3.1. Item textual simples

`TRickUIBuilderComboBoxItem.Create(ADisplayText)` cria um item no qual
`DisplayText` e `Value` usam o mesmo texto.

O equivalente Fluent existente é disponibilizado por `Items([...])` e
`AddItem(ADisplayText)`.

### 3.2. DisplayText + Value

`TRickUIBuilderComboBoxItem.Create(ADisplayText, AValue)` mantém o texto exibido
separado do valor semântico.

O equivalente Fluent existente é `AddItem(ADisplayText, AValue)`.

### 3.3. Item estruturado

`TRickUIBuilderComboBoxItem.Structured(ADisplayText, AValue, AColumns)` permite
armazenar colunas visuais adicionais.

O equivalente Fluent existente é `AddStructuredItem(...)`.

### 3.4. Colunas

`TRickUIBuilderComboBoxColumn` representa colunas adicionais e possui os modos
de tamanho públicos:

- `TRickUIBuilderComboBoxColumnSizeMode.Auto`;
- `TRickUIBuilderComboBoxColumnSizeMode.Fixed`;
- `TRickUIBuilderComboBoxColumnSizeMode.Proportional`.

O Fluent já permite adicionar essas definições por `Column(...)`.

## 4. Lacuna funcional da Factory

A Factory atual não possui contrato público para:

- receber uma coleção de `TRickUIBuilderComboBoxItem`;
- receber definições de `TRickUIBuilderComboBoxColumn`;
- definir seleção inicial junto da criação Factory;
- materializar a superfície de seleção;
- manter o runtime de dados e seleção;
- devolver um contrato runtime equivalente ao que o Fluent expõe por
  `IRickUIBuilderComboBoxHandle`.

Consequentemente, a abordagem Factory atual não consegue demonstrar ou utilizar
de forma autônoma lista textual, `DisplayText/Value` ou lista estruturada.

## 5. Requisitos funcionais da evolução

A futura solução deverá permitir, pela abordagem Factory:

1. fornecer itens textuais simples;
2. fornecer itens com `DisplayText` e `Value` independentes;
3. fornecer itens estruturados com colunas adicionais;
4. fornecer definições de coluna quando itens estruturados forem utilizados;
5. materializar a superfície de seleção necessária ao funcionamento do
   ComboBox;
6. preservar os dados e a seleção enquanto a árvore visual estiver válida;
7. disponibilizar ao consumidor um contrato público para consultar e alterar o
   runtime quando isso fizer parte da solução aprovada.

## 6. Contratos públicos existentes a considerar

A análise técnica futura deverá considerar o reaproveitamento de:

```text
TRickUIBuilderComboBoxConfig
TRickUIBuilderComboBoxItem
TRickUIBuilderComboBoxColumn
IRickUIBuilderComboBoxHandle
```

Não criar tipos paralelos exclusivos para Factory sem necessidade arquitetural
comprovada.

As classes internas responsáveis por dados, handle concreto, presentation e
virtualização não devem ser expostas automaticamente como API pública apenas
para viabilizar esta evolução.

## 7. Compatibilidade

A assinatura pública atual de `CreateComboBox` já possui consumidores e testes.
A evolução deverá preservar seu comportamento ou definir explicitamente uma
estratégia compatível antes de qualquer alteração de contrato.

Não substituir silenciosamente a Factory visual atual por outra sem avaliar:

- código consumidor;
- testes existentes;
- ownership;
- lifetime;
- API pública;
- regressões no Builder, que hoje reutiliza a Factory para o controle fechado.

## 8. Separação entre dados e apresentação

Os modelos de dados da lista não devem ser confundidos com os modos de
apresentação do ComboBox.

Modelos de dados comprovados:

```text
texto simples
DisplayText + Value
item estruturado + colunas
```

Modos de apresentação públicos existentes:

```text
Auto
Anchored
Overlay
FullWindow
```

Perfis de estilo públicos existentes:

```text
Desktop
Mobile
Adaptive
Custom
```

A futura API Factory deverá definir explicitamente até onde vai sua
responsabilidade sobre apresentação e estilo. Essa decisão não está fechada por
esta especificação.

## 9. Decisões ainda abertas

A implementação não deve iniciar assumindo respostas para os pontos abaixo:

1. assinatura exata da nova operação Factory;
2. se a evolução será overload de `CreateComboBox` ou nova operação pública;
3. forma pública de fornecer coleção de itens;
4. forma pública de fornecer colunas;
5. suporte e precedência de seleção inicial por índice ou texto;
6. forma de devolver ou disponibilizar `IRickUIBuilderComboBoxHandle`;
7. alcance de `Placeholder` na abordagem Factory;
8. suporte a `OnChange`, `OnOpen`, `OnClose` e `OnCustomizeItem`;
9. responsabilidade da Factory sobre `PresentationMode` e `StyleType`;
10. ownership e lifetime dos dados/runtime quando o consumidor não mantiver um
    handle.

Esses pontos deverão ser fechados antes do plano técnico e do backlog de
implementação.

## 10. Fora de escopo desta especificação

Esta especificação não autoriza, por si só:

- alterar `TRickUIBuilderFactory`;
- alterar GUIDs de interfaces existentes;
- expor classes internas do runtime;
- duplicar o Builder Fluent dentro da Factory;
- criar lista manual apenas para fins de Sample;
- modificar os Samples para simular capacidade ainda inexistente.

## 11. Impacto futuro nos Samples

Enquanto esta capacidade não estiver implementada, `ComboBox - Factory` deve
demonstrar somente o controle fechado criado por `CreateComboBox` e as opções
que essa chamada realmente aplica.

Após implementação e validação da evolução, os Samples Factory poderão ser
reavaliados para incluir exemplos reais de:

- lista textual simples;
- `DisplayText + Value`;
- itens estruturados;
- colunas `Auto`, `Fixed` e `Proportional`;
- seleção e runtime somente quando fizerem parte do contrato implementado.

Nenhum desses exemplos deve antecipar a API futura.

## 12. Critérios de aceite para uma futura implementação

A capacidade somente poderá ser considerada implementada quando, no mínimo:

1. existir API pública Factory aprovada para fornecer os dados necessários;
2. os três modelos de dados previstos no escopo puderem ser materializados;
3. colunas estruturadas puderem ser utilizadas quando aplicável;
4. a lista/superfície de seleção for funcional sem depender da API Fluent pelo
   consumidor;
5. ownership e lifetime estiverem definidos e testados;
6. contratos públicos existentes permanecerem compatíveis ou a mudança tiver
   sido explicitamente aprovada;
7. testes cobrirem os novos contratos e regressões relevantes;
8. documentação do componente refletir somente a implementação final;
9. somente após isso os Samples Factory forem ampliados com listas reais.

## 13. Próxima etapa quando a implementação for autorizada

Com os requisitos e decisões abertas fechados, o fluxo documental do projeto
deve seguir para um plano técnico e, posteriormente, um backlog executável,
assim como ocorre com outras features definidas previamente em `specs/`.

Até essa autorização, este documento permanece como definição funcional da
capacidade futura.
