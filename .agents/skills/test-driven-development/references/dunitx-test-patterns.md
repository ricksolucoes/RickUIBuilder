# DUnitX Test Patterns — RickUIBuilder

## Fixture puro

Use quando não há FMX host.

```pascal
[TestFixture]
TExampleTests = class
public
  [Test]
  procedure Metodo_Condicao_DeveResultado;
end;
```

## Fixture de integração FMX

Padrão observado no projeto:

```pascal
[TestFixture]
[Category('Integration')]
TExampleIntegrationTests = class
private
  FHostForm: TForm;
public
  [Setup]
  procedure Setup;
  [TearDown]
  procedure TearDown;
end;
```

Use Setup/TearDown para isolar visual tree e lifetime entre testes.

## Naming

Prefira nome comportamental:

```text
Build_DeveDefinirParentCorretamente
SelectText_TextoDuplicado_DeveSelecionarPrimeiraOcorrencia
Handle_DeveDesanexarQuandoParentForDestruido
```

## Arrange / Act / Assert

Mantenha blocos conceituais simples. Não precisa comentar as palavras se o código já é claro.

## Events

Para callbacks:

- contador simples quando só quantidade importa;
- capture payload quando semântica importa;
- dispare o evento pelo caminho mais próximo do runtime real;
- não chame método privado apenas para contornar interação.

## Lifetime

Ao testar ownership:

- saiba quem deve liberar o host;
- evite double-free no TearDown;
- quando parent destruction é o cenário, não mantenha referência e depois use sem check;
- valide detach state antes de acessar controls.

## Semantic normalization

Se uma API normaliza dados, normalize expected com a própria API antes de comparar quando isso representa o contrato. Não duplique parser/normalizer em teste se a plataforma já define a transformação.

## Helper discipline

`FindX` pode retornar nil; `RequireX` pode assertar presence e retornar valor. Mantenha diferença clara.
