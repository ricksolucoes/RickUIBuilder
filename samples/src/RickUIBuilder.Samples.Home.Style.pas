unit RickUIBuilder.Samples.Home.Style;
(*
  ==============================================================================
  Unit: RickUIBuilder.Samples.Home.Style
  ==============================================================================

  OBJETIVO

  Centraliza somente os tokens visuais e medidas pertencentes a Home do
  RickUIBuilder.Samples.

  REGRAS DE MANUTENCAO

  1. Esta unit nao e o Design System global do aplicativo de samples.
  2. Manter aqui apenas valores compartilhados entre as units da Home.
  3. Nao adicionar tokens de Factory, Fluent, Composition ou componentes.
  4. Um token so deve migrar para App/DesignSystem quando houver reutilizacao
     transversal comprovada em outras paginas.

  ==============================================================================
*)

interface

const
  _HOME_BACKGROUND_ = $FFF4F5F7;
  _HOME_CARD_BACKGROUND_ = $FFFFFFFF;
  _HOME_BORDER_ = $FFE0E3E8;
  _HOME_TEXT_PRIMARY_ = $FF1A1D21;
  _HOME_TEXT_SECONDARY_ = $FF6B7280;
  _HOME_PRIMARY_ = $FF2563EB;
  _HOME_PRIMARY_SOFT_ = $FFEFF6FF;
  _HOME_SUCCESS_TEXT_ = $FF166534;

  _HOME_CONTENT_MAX_WIDTH_ = 1040;
  _HOME_CONTENT_MARGIN_ = 32;
  _HOME_CARD_WIDTH_ = 320;
  _HOME_CARD_HEIGHT_ = 330;
  _HOME_CARD_GAP_ = 24;
  _HOME_CARD_RADIUS_ = 12;

implementation

end.
