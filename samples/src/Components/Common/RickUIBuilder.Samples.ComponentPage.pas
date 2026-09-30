(******************************************************************************
  Unit: RickUIBuilder.Samples.ComponentPage

  FINALIDADE
  Página visual comum para as abordagens de um componente.

  FUNCIONALIDADE
  Apresenta o componente selecionado e somente as abordagens atualmente suportadas pela API pública confirmada.

  DEPENDÊNCIAS DO PROJETO
  - RickUIBuilder.Samples.App.Types — identifica o componente apresentado.
  - RickUIBuilder.Samples.App.Typography — fornece tipografia compartilhada.
  - RickUIBuilder.Samples.Home.Style — fornece os tokens visuais atualmente reutilizados pela página.

  FLUXO / COLABORAÇÃO
  - TSampleApplicationCoordinator cria esta página com um TSampleComponent; a página deriva título e opções visuais desse valor.

  RESTRIÇÕES E RESPONSABILIDADES
  - Não inventar Factory para Edit enquanto Factory.CreateEdit não existir na API confirmada.
  - Esta página apresenta opções; não altera a API pública do Rick.UIBuilder.

  Manutenção: este cabeçalho deve ser atualizado quando responsabilidade,
  dependências, fluxo, ownership/lifetime ou restrições desta unit mudarem.
******************************************************************************)
unit RickUIBuilder.Samples.ComponentPage;

interface

uses
  System.Classes,
  FMX.Forms,
  FMX.Objects,
  RickUIBuilder.Samples.App.Types;

type
  /// <summary>Pagina base visual que apresenta as abordagens suportadas por um componente.</summary>
  TComponentPage = class(TForm)
  strict private
    FComponent: TSampleComponent;
    /// <summary>Configura a janela da página de componente.</summary>
    procedure ConfigureForm;
    /// <summary>Monta os elementos visuais da página.</summary>
    procedure BuildInterface;
    /// <summary>Adiciona o título do componente atual.</summary>
    procedure AddTitle;
    /// <summary>Adiciona somente as abordagens suportadas pelo componente.</summary>
    procedure AddApproaches;
    /// <summary>Adiciona uma opção visual de abordagem.</summary>
    procedure AddApproach(const ACaption: string; const ATop: Single);
    /// <summary>Configura a superfície visual de uma abordagem.</summary>
    procedure ConfigureApproachSurface(const ASurface: TRectangle; const ATop: Single);
    /// <summary>Adiciona o texto centralizado da abordagem.</summary>
    procedure AddApproachText(const ASurface: TRectangle; const ACaption: string);
    /// <summary>Obtém o título público do componente atual.</summary>
    function ComponentTitle: string;
    /// <summary>Indica se a API pública atual oferece Factory ao componente.</summary>
    function SupportsFactory: Boolean;
  public
    /// <summary>Cria a página para o componente informado.</summary>
    constructor Create(AOwner: TComponent; const AComponent: TSampleComponent); reintroduce;
  end;

implementation

uses
  System.UITypes,

  FMX.Types,
  FMX.Graphics,

  RickUIBuilder.Samples.Home.Style,
  RickUIBuilder.Samples.App.Typography;

constructor TComponentPage.Create(AOwner: TComponent;
  const AComponent: TSampleComponent);
begin
  inherited CreateNew(AOwner);
  FComponent := AComponent;
  ConfigureForm;
  BuildInterface;
end;

procedure TComponentPage.ConfigureForm;
begin
  Caption := ComponentTitle;
  ClientWidth := 420;
  ClientHeight := 300;
  Position := TFormPosition.ScreenCenter;
  Fill.Kind := TBrushKind.Solid;
  Fill.Color := _HOME_BACKGROUND_;
end;

procedure TComponentPage.BuildInterface;
begin
  AddTitle;
  AddApproaches;
end;

procedure TComponentPage.AddTitle;
var
  LTitle: TText;
begin
  LTitle := TText.Create(Self);
  LTitle.Parent := Self;
  LTitle.SetBounds(24, 32, 372, 40);
  LTitle.Text := ComponentTitle;
  LTitle.TextSettings.Font.Size := _FONT_SIZE_PAGE_TITLE_;
  LTitle.TextSettings.Font.Style := [TFontStyle.fsBold];
  LTitle.TextSettings.FontColor := _HOME_TEXT_PRIMARY_;
  LTitle.TextSettings.HorzAlign := TTextAlign.Center;
  LTitle.HitTest := False;
end;

procedure TComponentPage.AddApproaches;
begin
  if SupportsFactory then
  begin
    AddApproach('Factory', 104);
    AddApproach('Fluent Builder', 166);
    Exit;
  end;
  AddApproach('Fluent Builder', 135);
end;

procedure TComponentPage.AddApproach(const ACaption: string;
  const ATop: Single);
var
  LSurface: TRectangle;
begin
  LSurface := TRectangle.Create(Self);
  LSurface.Parent := Self;
  ConfigureApproachSurface(LSurface, ATop);
  AddApproachText(LSurface, ACaption);
end;

procedure TComponentPage.ConfigureApproachSurface(const ASurface: TRectangle;
  const ATop: Single);
begin
  ASurface.SetBounds(80, ATop, 260, 46);
  ASurface.Fill.Kind := TBrushKind.Solid;
  ASurface.Fill.Color := _HOME_CARD_BACKGROUND_;
  ASurface.Stroke.Kind := TBrushKind.Solid;
  ASurface.Stroke.Color := _HOME_BORDER_;
  ASurface.XRadius := 8;
  ASurface.YRadius := 8;
  ASurface.HitTest := False;
end;

procedure TComponentPage.AddApproachText(const ASurface: TRectangle;
  const ACaption: string);
var
  LText: TText;
begin
  LText := TText.Create(ASurface);
  LText.Parent := ASurface;
  LText.Align := TAlignLayout.Client;
  LText.Text := ACaption;
  LText.TextSettings.Font.Size := _FONT_SIZE_CARD_TITLE_;
  LText.TextSettings.FontColor := _HOME_TEXT_PRIMARY_;
  LText.TextSettings.HorzAlign := TTextAlign.Center;
  LText.TextSettings.VertAlign := TTextAlign.Center;
  LText.HitTest := False;
end;

function TComponentPage.ComponentTitle: string;
const
  _COMPONENT_TITLES_: array[TSampleComponent] of string = (
    'Text / Label', 'Button', 'Badge', 'Divider', 'ComboBox', 'Edit');
begin
  Result := _COMPONENT_TITLES_[FComponent];
end;

function TComponentPage.SupportsFactory: Boolean;
begin
  Result := FComponent <> TSampleComponent.Edit;
end;

end.
