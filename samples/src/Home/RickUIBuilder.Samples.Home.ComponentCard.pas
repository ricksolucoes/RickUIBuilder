(******************************************************************************
  Unit: RickUIBuilder.Samples.Home.ComponentCard

  FINALIDADE
  Construção visual dos cards da Home.

  FUNCIONALIDADE
  Cria superfície, ícone SVG, título, descrição e ação Ver exemplos de cada componente.

  DEPENDÊNCIAS DO PROJETO
  - RickUIBuilder.Samples.App.Typography — fornece os tamanhos tipográficos semânticos.
  - RickUIBuilder.Samples.Home.Icons — fornece o chevron SVG da ação.
  - RickUIBuilder.Samples.Home.Style — fornece cores e geometria dos cards.

  FLUXO / COLABORAÇÃO
  - TPageSamplesHome fornece parent, conteúdo e callback; esta unit apenas materializa a apresentação e conecta o callback à ação.

  RESTRIÇÕES E RESPONSABILIDADES
  - Não conhece Presenter, Coordinator ou destino de navegação.
  - A geometria deve comportar conteúdo sem reduzir a tipografia aprovada.

  Manutenção: este cabeçalho deve ser atualizado quando responsabilidade,
  dependências, fluxo, ownership/lifetime ou restrições desta unit mudarem.
******************************************************************************)
unit RickUIBuilder.Samples.Home.ComponentCard;

interface

uses
  System.Classes,
  FMX.Objects,
  FMX.Types;

type
  /// <summary>Constroi um card visual do catalogo da Home.</summary>
  TComponentCard = class
  strict private
    /// <summary>Configura a superfície externa do card.</summary>
    class procedure ConfigureSurface(const ACard: TRectangle); static;
    /// <summary>Cria a superfície azul que recebe o ícone.</summary>
    class function CreateIconSurface(const ACard: TRectangle): TRectangle; static;
    /// <summary>Renderiza o path SVG fornecido.</summary>
    class procedure AddIcon(const AIconSurface: TRectangle; const AIconData: string); static;
    /// <summary>Adiciona o título centralizado do componente.</summary>
    class procedure AddTitle(const ACard: TRectangle; const ATitle: string); static;
    /// <summary>Adiciona a descrição centralizada do componente.</summary>
    class procedure AddDescription(const ACard: TRectangle; const ADescription: string); static;
    /// <summary>Configura a ação clicável Ver exemplos.</summary>
    class procedure ConfigureAction(const AAction: TRectangle;
      const AOnClick: TNotifyEvent); static;
    /// <summary>Adiciona o caption centralizado da ação.</summary>
    class procedure AddActionText(const AAction: TRectangle); static;
    /// <summary>Adiciona o SVG de chevron da ação.</summary>
    class procedure AddActionChevron(const AAction: TRectangle); static;
    /// <summary>Cria a ação Ver exemplos na base do card.</summary>
    class procedure AddExamplesAction(const ACard: TRectangle;
      const AOnClick: TNotifyEvent); static;
  public
    /// <summary>Cria um card de componente com ação de navegação.</summary>
    class function New(const AParent: TFmxObject; const AIconData, ATitle,
      ADescription: string; const AOnClick: TNotifyEvent): TRectangle; static;
  end;

implementation

uses
  System.UITypes,
  FMX.Graphics,
  RickUIBuilder.Samples.App.Typography,
  RickUIBuilder.Samples.Home.Icons,
  RickUIBuilder.Samples.Home.Style;

class procedure TComponentCard.ConfigureSurface(const ACard: TRectangle);
begin
  ACard.SetBounds(0, 0, _HOME_CARD_WIDTH_, _HOME_CARD_HEIGHT_);
  ACard.Fill.Kind := TBrushKind.Solid;
  ACard.Fill.Color := _HOME_CARD_BACKGROUND_;
  ACard.Stroke.Kind := TBrushKind.Solid;
  ACard.Stroke.Color := _HOME_BORDER_;
  ACard.XRadius := _HOME_CARD_RADIUS_;
  ACard.YRadius := _HOME_CARD_RADIUS_;
  ACard.HitTest := False;
end;

class function TComponentCard.CreateIconSurface(const ACard: TRectangle): TRectangle;
begin
  Result := TRectangle.Create(ACard);
  Result.Parent := ACard;
  Result.SetBounds((_HOME_CARD_WIDTH_ - _HOME_ICON_SURFACE_SIZE_) / 2, 10,
    _HOME_ICON_SURFACE_SIZE_, _HOME_ICON_SURFACE_SIZE_);
  Result.Fill.Kind := TBrushKind.Solid;
  Result.Fill.Color := _HOME_PRIMARY_;
  Result.Stroke.Kind := TBrushKind.None;
  Result.XRadius := 7;
  Result.YRadius := 7;
  Result.HitTest := False;
end;

class procedure TComponentCard.AddIcon(const AIconSurface: TRectangle;
  const AIconData: string);
var
  LIcon: TPath;
begin
  LIcon := TPath.Create(AIconSurface);
  LIcon.Parent := AIconSurface;
  LIcon.SetBounds(8, 8, _HOME_ICON_SIZE_, _HOME_ICON_SIZE_);
  LIcon.Data.Data := AIconData;
  LIcon.WrapMode := TPathWrapMode.Fit;
  LIcon.Fill.Kind := TBrushKind.Solid;
  LIcon.Fill.Color := _HOME_ACTION_TEXT_;
  LIcon.Stroke.Kind := TBrushKind.None;
  LIcon.HitTest := False;
end;

class procedure TComponentCard.AddTitle(const ACard: TRectangle; const ATitle: string);
var
  LTitle: TText;
begin
  LTitle := TText.Create(ACard);
  LTitle.Parent := ACard;
  LTitle.SetBounds(10, 54, _HOME_CARD_WIDTH_ - 20, 22);
  LTitle.Text := ATitle;
  LTitle.TextSettings.Font.Size := _FONT_SIZE_CARD_TITLE_;
  LTitle.TextSettings.Font.Style := [TFontStyle.fsBold];
  LTitle.TextSettings.FontColor := _HOME_TEXT_PRIMARY_;
  LTitle.TextSettings.HorzAlign := TTextAlign.Center;
  LTitle.TextSettings.VertAlign := TTextAlign.Center;
  LTitle.HitTest := False;
end;

class procedure TComponentCard.AddDescription(const ACard: TRectangle;
  const ADescription: string);
var
  LDescription: TText;
begin
  LDescription := TText.Create(ACard);
  LDescription.Parent := ACard;
  LDescription.SetBounds(10, 78, _HOME_CARD_WIDTH_ - 20, 58);
  LDescription.Text := ADescription;
  LDescription.WordWrap := True;
  LDescription.TextSettings.Font.Size := _FONT_SIZE_BODY_;
  LDescription.TextSettings.FontColor := _HOME_TEXT_SECONDARY_;
  LDescription.TextSettings.HorzAlign := TTextAlign.Center;
  LDescription.TextSettings.VertAlign := TTextAlign.Center;
  LDescription.HitTest := False;
end;

class procedure TComponentCard.ConfigureAction(const AAction: TRectangle;
  const AOnClick: TNotifyEvent);
begin
  AAction.SetBounds(12, 144, _HOME_CARD_WIDTH_ - 24, 28);
  AAction.Fill.Kind := TBrushKind.Solid;
  AAction.Fill.Color := _HOME_PRIMARY_;
  AAction.Stroke.Kind := TBrushKind.None;
  AAction.XRadius := 6;
  AAction.YRadius := 6;
  AAction.Cursor := crHandPoint;
  AAction.OnClick := AOnClick;
end;

class procedure TComponentCard.AddActionText(const AAction: TRectangle);
var
  LText: TText;
begin
  LText := TText.Create(AAction);
  LText.Parent := AAction;
  LText.SetBounds(10, 0, AAction.Width - 20, AAction.Height);
  LText.Text := 'Ver exemplos';
  LText.TextSettings.Font.Size := _FONT_SIZE_ACTION_;
  LText.TextSettings.FontColor := _HOME_ACTION_TEXT_;
  LText.TextSettings.HorzAlign := TTextAlign.Center;
  LText.TextSettings.VertAlign := TTextAlign.Center;
  LText.HitTest := False;
end;

class procedure TComponentCard.AddActionChevron(const AAction: TRectangle);
var
  LChevron: TPath;
begin
  LChevron := TPath.Create(AAction);
  LChevron.Parent := AAction;
  LChevron.SetBounds(AAction.Width - 18, 9, 6, 10);
  LChevron.Data.Data := _HOME_ICON_ARROW_FORWARD_;
  LChevron.WrapMode := TPathWrapMode.Fit;
  LChevron.Fill.Kind := TBrushKind.Solid;
  LChevron.Fill.Color := _HOME_ACTION_TEXT_;
  LChevron.Stroke.Kind := TBrushKind.None;
  LChevron.HitTest := False;
end;

class procedure TComponentCard.AddExamplesAction(const ACard: TRectangle;
  const AOnClick: TNotifyEvent);
var
  LAction: TRectangle;
begin
  LAction := TRectangle.Create(ACard);
  LAction.Parent := ACard;
  ConfigureAction(LAction, AOnClick);
  AddActionText(LAction);
  AddActionChevron(LAction);
end;

class function TComponentCard.New(const AParent: TFmxObject;
  const AIconData, ATitle, ADescription: string;
  const AOnClick: TNotifyEvent): TRectangle;
var
  LIconSurface: TRectangle;
begin
  Result := TRectangle.Create(AParent);
  Result.Parent := AParent;
  ConfigureSurface(Result);
  LIconSurface := CreateIconSurface(Result);
  AddIcon(LIconSurface, AIconData);
  AddTitle(Result, ATitle);
  AddDescription(Result, ADescription);
  AddExamplesAction(Result, AOnClick);
end;

end.
