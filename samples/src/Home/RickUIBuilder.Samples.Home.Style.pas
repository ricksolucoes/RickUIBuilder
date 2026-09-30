(******************************************************************************
  Unit: RickUIBuilder.Samples.Home.Style

  FINALIDADE
  Tokens visuais e geometria específicos da Home.

  FUNCIONALIDADE
  Centraliza cores, dimensões do formulário, header, cards, ícones e grid da Home.

  DEPENDÊNCIAS DO PROJETO
  - Não possui dependências internas do projeto.

  FLUXO / COLABORAÇÃO
  - Home e ComponentCard consomem estas constantes para manter a geometria visual consistente.

  RESTRIÇÕES E RESPONSABILIDADES
  - Tipografia compartilhada pertence a RickUIBuilder.Samples.App.Typography.
  - Alterações de tamanho devem preservar header sem margem externa e cards sem clipping.

  Manutenção: este cabeçalho deve ser atualizado quando responsabilidade,
  dependências, fluxo, ownership/lifetime ou restrições desta unit mudarem.
******************************************************************************)
unit RickUIBuilder.Samples.Home.Style;

interface

const
  _HOME_BACKGROUND_ = $FFFAFCFE;
  _HOME_TOP_BAR_BACKGROUND_ = $FFF5F8FB;
  _HOME_CARD_BACKGROUND_ = $FFF5F8FB;
  _HOME_BORDER_ = $FFD7E2EC;
  _HOME_TEXT_PRIMARY_ = $FF0D1B35;
  _HOME_TEXT_SECONDARY_ = $FF304A68;
  _HOME_PRIMARY_ = $FF1677F2;
  _HOME_ACTION_TEXT_ = $FFFFFFFF;
  _HOME_CLOSE_HOVER_ = $FFEAF1F7;

  _HOME_REFERENCE_WIDTH_ = 644;
  _HOME_REFERENCE_HEIGHT_ = 534;
  _HOME_TOP_BAR_HEIGHT_ = 40;
  _HOME_CARD_WIDTH_ = 192;
  _HOME_CARD_HEIGHT_ = 180;
  _HOME_CARD_GAP_ = 12;
  _HOME_CARD_ROW_GAP_ = 12;
  _HOME_CARD_RADIUS_ = 9;
  _HOME_ICON_SURFACE_SIZE_ = 40;
  _HOME_ICON_SIZE_ = 24;
  _HOME_GRID_WIDTH_ = 600;
  _HOME_GRID_HEIGHT_ = 372;

implementation

end.
