unit Rick.UIBuilder.Factory;
(*
  ==============================================================================
  Unit: Rick.UIBuilder.Factory
  ==============================================================================

  RESPONSABILIDADE

  Implementa a abordagem de criacao direta (Opcao A) do framework
  Rick.UIBuilder: TRickUIBuilderFactory, com metodos estaticos que
  recebem um record de configuracao (Rick.UIBuilder.Types) e devolvem
  o controle FMX ja criado e anexado ao Parent informado.

  Esta unit e a extracao direta da logica que antes vivia em
  EFCompras.View.Main (CreateText, CreateDivider, CreateBadge,
  CreateButton), agora desacoplada de qualquer TForm especifico: o
  Owner dos componentes passa a ser recebido explicitamente via
  AOwner, em vez de assumir Self implicitamente.

  Esta unit NAO conhece paleta de cores de nenhum projeto consumidor -
  toda cor chega via TAlphaColor nos records de configuracao.

  Os builders fluentes (Rick.UIBuilder.Label, .Button, .Badge,
  .Divider) delegam sua criacao real para esta Factory, evitando
  duplicar a logica de instanciacao de controles.

  ==============================================================================
*)

interface

uses
  System.Classes,
  System.UITypes,
  FMX.Types,
  FMX.Controls,
  FMX.Objects,
  FMX.StdCtrls,
  Rick.UIBuilder.Types;

type
  /// <summary>
  ///    Fabrica estatica responsavel por criar controles FMX a partir
  ///    dos records de configuracao definidos em Rick.UIBuilder.Types.
  ///    Representa a abordagem de criacao direta (Opcao A) do
  ///    framework Rick.UIBuilder.
  /// </summary>
  TRickUIBuilderFactory = class sealed
  public
    /// <summary>
    ///    Cria um TLabel a partir de um TRickUIBuilderTextConfig.
    /// </summary>
    /// <param name="AOwner">
    ///    Componente responsavel pelo ciclo de vida do TLabel criado.
    /// </param>
    /// <param name="AParent">
    ///    Controle ou formulario que sera o Parent do TLabel criado.
    /// </param>
    /// <param name="AText">
    ///    Texto a ser exibido no controle.
    /// </param>
    /// <param name="AConfig">
    ///    Configuracao de geometria e tipografia a ser aplicada.
    /// </param>
    /// <returns>
    ///    A instancia de TLabel criada e ja anexada a AParent.
    /// </returns>
    class function CreateText(AOwner: TComponent; AParent: TFmxObject;
      const AText: string; const AConfig: TRickUIBuilderTextConfig): TLabel; static;

    /// <summary>
    ///    Cria um divisor (TRectangle de 1px de altura) a partir de
    ///    um TRickUIBuilderDividerConfig.
    /// </summary>
    /// <param name="AOwner">
    ///    Componente responsavel pelo ciclo de vida do TRectangle
    ///    criado.
    /// </param>
    /// <param name="AParent">
    ///    Controle ou formulario que sera o Parent do divisor criado.
    /// </param>
    /// <param name="AConfig">
    ///    Configuracao de geometria e cor a ser aplicada.
    /// </param>
    /// <returns>
    ///    O TRectangle criado e ja anexado a AParent, sem HitTest e
    ///    sem borda.
    /// </returns>
    class function CreateDivider(AOwner: TComponent; AParent: TFmxObject;
      const AConfig: TRickUIBuilderDividerConfig): TRectangle; static;

    /// <summary>
    ///    Cria um Badge (TRectangle com TLabel interno) a partir de
    ///    um TRickUIBuilderBadgeConfig.
    /// </summary>
    /// <param name="AOwner">
    ///    Componente responsavel pelo ciclo de vida dos controles
    ///    criados.
    /// </param>
    /// <param name="AParent">
    ///    Controle ou formulario que sera o Parent do Container
    ///    criado.
    /// </param>
    /// <param name="AText">
    ///    Texto a ser exibido dentro do Badge.
    /// </param>
    /// <param name="AConfig">
    ///    Configuracao de geometria e cor a ser aplicada.
    /// </param>
    /// <param name="ATextLabel">
    ///    Parametro de saida com o TLabel interno criado, para que o
    ///    chamador possa manipula-lo posteriormente (ex.: alterar
    ///    texto/cor em runtime).
    /// </param>
    /// <returns>
    ///    O TRectangle criado, ja anexado a AParent, com formato de
    ///    pilula (cantos totalmente arredondados) e sem HitTest.
    /// </returns>
    class function CreateBadge(AOwner: TComponent; AParent: TFmxObject;
      const AText: string; const AConfig: TRickUIBuilderBadgeConfig;
      out ATextLabel: TLabel): TRectangle; static;

    /// <summary>
    ///    Cria um botao customizado (TRectangle com TLabel interno)
    ///    a partir de um TRickUIBuilderButtonConfig.
    /// </summary>
    /// <param name="AOwner">
    ///    Componente responsavel pelo ciclo de vida dos controles
    ///    criados.
    /// </param>
    /// <param name="AParent">
    ///    Controle ou formulario que sera o Parent do botao criado.
    /// </param>
    /// <param name="ACaption">
    ///    Texto a ser exibido no botao.
    /// </param>
    /// <param name="AConfig">
    ///    Configuracao de geometria, cor e Tag a ser aplicada.
    /// </param>
    /// <returns>
    ///    O TRectangle criado, ja anexado a AParent, com cursor de
    ///    mao (crHandPoint), HitTest habilitado e o TLabel de
    ///    ACaption criado como seu filho.
    /// </returns>
    /// <remarks>
    ///    Esta sobrecarga nao anexa manipuladores de hover - a
    ///    alternancia de cor em MouseEnter/MouseLeave e
    ///    responsabilidade do builder fluente (IRickUIBuilderButton),
    ///    nao da Factory. Consumidores que utilizam a Factory
    ///    diretamente devem atribuir OnMouseEnter/OnMouseLeave por
    ///    conta propria, se necessario.
    /// </remarks>
    class function CreateButton(AOwner: TComponent; AParent: TFmxObject;
      const ACaption: string; const AConfig: TRickUIBuilderButtonConfig): TRectangle; static;
  end;

implementation

uses
  FMX.Graphics;

{ TRickUIBuilderFactory }

class function TRickUIBuilderFactory.CreateText(AOwner: TComponent;
  AParent: TFmxObject; const AText: string;
  const AConfig: TRickUIBuilderTextConfig): TLabel;
begin
  Result                            := TLabel.Create(AOwner);
  Result.Parent                     := AParent;
  Result.Text                       := AText;
  Result.Position.X                 := AConfig.Left;
  Result.Position.Y                 := AConfig.Top;
  Result.Width                      := AConfig.Width;
  Result.Height                     := AConfig.Height;
  Result.HitTest                    := False;
  Result.TextSettings.Font.Size     := AConfig.FontSize;
  Result.TextSettings.FontColor     := AConfig.FontColor;
  Result.TextSettings.HorzAlign     := AConfig.HorizontalAlign;
  Result.TextSettings.Font.Style    := Result.TextSettings.Font.Style
                                        - [TFontStyle.fsBold];

  if AConfig.Bold then
    Result.TextSettings.Font.Style  := Result.TextSettings.Font.Style
                                        + [TFontStyle.fsBold];

  Result.StyledSettings             := Result.StyledSettings
                                        - [TStyledSetting.Size,
                                           TStyledSetting.FontColor,
                                           TStyledSetting.Style];
end;

class function TRickUIBuilderFactory.CreateDivider(AOwner: TComponent;
  AParent: TFmxObject; const AConfig: TRickUIBuilderDividerConfig): TRectangle;
begin
  Result              := TRectangle.Create(AOwner);
  Result.Parent       := AParent;
  Result.Position.X   := AConfig.Left;
  Result.Position.Y   := AConfig.Top;
  Result.Width        := AConfig.Width;
  Result.Height       := 1;
  Result.HitTest      := False;
  Result.Fill.Kind    := TBrushKind.Solid;
  Result.Fill.Color   := AConfig.Color;
  Result.Stroke.Kind  := TBrushKind.None;
end;

class function TRickUIBuilderFactory.CreateBadge(AOwner: TComponent;
  AParent: TFmxObject; const AText: string;
  const AConfig: TRickUIBuilderBadgeConfig; out ATextLabel: TLabel): TRectangle;
var
  LTextConfig: TRickUIBuilderTextConfig;
begin
  Result                  := TRectangle.Create(AOwner);
  Result.Parent           := AParent;
  Result.Position.X       := AConfig.Left;
  Result.Position.Y       := AConfig.Top;
  Result.Width            := AConfig.Width;
  Result.Height           := AConfig.Height;
  Result.XRadius          := AConfig.Height / 2;
  Result.YRadius          := AConfig.Height / 2;
  Result.HitTest          := False;
  Result.Fill.Kind        := TBrushKind.Solid;
  Result.Fill.Color       := AConfig.BackgroundColor;
  Result.Stroke.Kind      := TBrushKind.None;

  LTextConfig                 := TRickUIBuilderTextConfig.Default;
  LTextConfig.Left            := 0;
  LTextConfig.Top             := 0;
  LTextConfig.Width           := AConfig.Width;
  LTextConfig.Height          := AConfig.Height;
  LTextConfig.FontSize        := AConfig.FontSize;
  LTextConfig.FontColor       := AConfig.TextColor;
  LTextConfig.HorizontalAlign := TTextAlign.Center;

  ATextLabel := CreateText(AOwner, Result, AText, LTextConfig);
end;

class function TRickUIBuilderFactory.CreateButton(AOwner: TComponent;
  AParent: TFmxObject; const ACaption: string;
  const AConfig: TRickUIBuilderButtonConfig): TRectangle;
var
  LTextConfig: TRickUIBuilderTextConfig;
begin
  Result                      := TRectangle.Create(AOwner);
  Result.Parent               := AParent;
  Result.Position.X           := AConfig.Left;
  Result.Position.Y           := AConfig.Top;
  Result.Width                := AConfig.Width;
  Result.Height               := AConfig.Height;
  Result.Cursor                := crHandPoint;
  Result.XRadius               := 16;
  Result.YRadius               := 16;
  Result.Tag                   := AConfig.Tag;
  Result.HitTest               := True;
  Result.Fill.Kind             := TBrushKind.Solid;
  Result.Fill.Color            := AConfig.FillColor;
  Result.Stroke.Kind           := TBrushKind.None;

  if not (AConfig.BorderColor = TAlphaColors.Null) then
  begin
    Result.Stroke.Kind        := TBrushKind.Solid;
    Result.Stroke.Color       := AConfig.BorderColor;
    Result.Stroke.Thickness   := 2;
  end;

  LTextConfig                 := TRickUIBuilderTextConfig.Default;
  LTextConfig.Left            := 0;
  LTextConfig.Top             := 0;
  LTextConfig.Width           := AConfig.Width;
  LTextConfig.Height          := AConfig.Height;
  LTextConfig.FontSize        := AConfig.FontSize;
  LTextConfig.FontColor       := AConfig.TextColor;
  LTextConfig.HorizontalAlign := TTextAlign.Center;

  CreateText(AOwner, Result, ACaption, LTextConfig);
end;

end.
