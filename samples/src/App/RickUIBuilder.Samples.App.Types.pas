(******************************************************************************
  Unit: RickUIBuilder.Samples.App.Types

  FINALIDADE
  Tipos compartilhados pela aplicação Samples.

  FUNCIONALIDADE
  Declara TSampleComponent, enum que identifica os seis destinos de componente atualmente navegáveis.

  DEPENDÊNCIAS DO PROJETO
  - Não possui dependências internas do projeto.

  FLUXO / COLABORAÇÃO
  - TPageSamplesHome associa cada card a um TSampleComponent; Presenter e Coordinator transportam esse valor até a navegação.

  RESTRIÇÕES E RESPONSABILIDADES
  - Adicionar valores somente quando existir destino real correspondente no Samples.

  Manutenção: este cabeçalho deve ser atualizado quando responsabilidade,
  dependências, fluxo, ownership/lifetime ou restrições desta unit mudarem.
******************************************************************************)
unit RickUIBuilder.Samples.App.Types;

interface

{$SCOPEDENUMS ON}

type

  /// <summary>Identifica os componentes navegaveis apresentados pelo Samples.</summary>
  TSampleComponent = (TextLabel, Button, Badge, Divider, ComboBox, Edit);

implementation

end.
