# Owner FRM-PACKAGE — Package e integração de units

## Fato confirmado

`RickUIBuilder.dpk` declara explicitamente cada unit distribuída no package.

O snapshot contém as units de Types, Interfaces, Factory, componentes, auxiliares e facade.

## Consequência para Edit

Toda nova unit efetivamente criada para o Edit terá de ser considerada na integração do package.

Também deve ser avaliado se a facade `Rick.UIBuilder` precisa importar a unit do builder para expor um novo entry point.

Nenhuma lista de novas units do Edit é definida neste documento porque a arquitetura interna específica ainda não está confirmada.
