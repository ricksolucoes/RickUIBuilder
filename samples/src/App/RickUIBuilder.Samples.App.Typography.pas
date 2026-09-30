(******************************************************************************
  Unit: RickUIBuilder.Samples.App.Typography

  FINALIDADE
  Escala tipográfica semântica compartilhada pelo Samples.

  FUNCIONALIDADE
  Centraliza tamanhos de fonte reutilizados por páginas e componentes visuais do Samples.

  DEPENDÊNCIAS DO PROJETO
  - Não possui dependências internas do projeto.

  FLUXO / COLABORAÇÃO
  - Units visuais consomem os tokens pelo papel semântico: título, subtítulo, card, body, ação e navegação.

  RESTRIÇÕES E RESPONSABILIDADES
  - Geometria específica de uma página não pertence a esta unit.
  - Não reduzir tokens para compensar falta de espaço em layouts.

  Manutenção: este cabeçalho deve ser atualizado quando responsabilidade,
  dependências, fluxo, ownership/lifetime ou restrições desta unit mudarem.
******************************************************************************)
unit RickUIBuilder.Samples.App.Typography;

interface

const
  _FONT_SIZE_PAGE_TITLE_ = 24;
  _FONT_SIZE_PAGE_SUBTITLE_ = 14;
  _FONT_SIZE_CARD_TITLE_ = 16;
  _FONT_SIZE_BODY_ = 14;
  _FONT_SIZE_ACTION_ = 14;
  _FONT_SIZE_NAVIGATION_ = 13;

implementation

end.
