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

  Os builders fluentes (Rick.UIBuilder.Label, .Button, .Badge, .Divider
  e .ComboBox) delegam sua criacao fundamental para esta Factory, evitando
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
  private
    class procedure ApplyButtonConfig(AButton: TRectangle;
      const AConfig: TRickUIBuilderButtonConfig); static;
    class function ButtonTextConfig(
      const AConfig: TRickUIBuilderButtonConfig): TRickUIBuilderTextConfig; static;
    class procedure ApplyComboBoxConfig(AContainer: TRectangle;
      const AConfig: TRickUIBuilderComboBoxConfig); static;
    class function ComboBoxArrowLeft(
      const AConfig: TRickUIBuilderComboBoxConfig): Single; static;
    class function ComboBoxArrowTop(
      const AConfig: TRickUIBuilderComboBoxConfig): Single; static;
    class procedure ConfigureComboBoxText(ATextLabel: TLabel;
      const AConfig: TRickUIBuilderComboBoxConfig); static;
    class procedure ConfigureComboBoxArrow(AArrow: TPath;
      const AConfig: TRickUIBuilderComboBoxConfig); static;
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
    ///    Cria o controle principal fechado do ComboBox usando somente
    ///    TRectangle, TLabel e TPath. A lista/popup e criada posteriormente
    ///    pelo runtime quando realmente utilizada.
    /// </summary>
    /// <param name="AOwner">Owner dos controles materializados.</param>
    /// <param name="AParent">Parent visual do container principal.</param>
    /// <param name="AConfig">Configuracao efetiva do ComboBox.</param>
    /// <param name="ATextLabel">TLabel interno non-owning devolvido ao runtime.</param>
    /// <param name="AArrow">TPath interno non-owning devolvido ao runtime.</param>
    /// <returns>TRectangle principal ja anexado ao Parent.</returns>
    class function CreateComboBox(AOwner: TComponent; AParent: TFmxObject;
      const AConfig: TRickUIBuilderComboBoxConfig; out ATextLabel: TLabel;
      out AArrow: TPath): TRectangle; static;

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
    ///    Cria o TRectangle (container visual) de um Badge, posicionado
    ///    e configurado a partir de um TRickUIBuilderBadgeConfig, no
    ///    formato de pilula (cantos totalmente arredondados).
    /// </summary>
    /// <param name="AOwner">
    ///    Componente responsavel pelo ciclo de vida do TRectangle
    ///    criado.
    /// </param>
    /// <param name="AParent">
    ///    Controle ou formulario que sera o Parent do Container
    ///    criado.
    /// </param>
    /// <param name="AConfig">
    ///    Configuracao de geometria e cor de fundo a ser aplicada.
    /// </param>
    /// <returns>
    ///    O TRectangle criado e ja anexado a AParent, sem HitTest e
    ///    sem Stroke.
    /// </returns>
    class function CreateBadgeContainer(AOwner: TComponent; AParent: TFmxObject;
      const AConfig: TRickUIBuilderBadgeConfig): TRectangle;

    /// <summary>
    ///    Monta a configuracao de texto (TRickUIBuilderTextConfig) usada
    ///    para criar o TLabel interno de um Badge, a partir de um
    ///    TRickUIBuilderBadgeConfig.
    /// </summary>
    /// <param name="AConfig">
    ///    Configuracao do Badge da qual sao derivados tamanho, fonte e
    ///    cor do texto.
    /// </param>
    /// <returns>
    ///    Um TRickUIBuilderTextConfig com Left/Top zerados (o texto e
    ///    posicionado em relacao ao Container, nao ao Parent do Badge) e
    ///    alinhamento horizontal centralizado.
    /// </returns>
    class function BuildBadgeTextConfig(
      const AConfig: TRickUIBuilderBadgeConfig): TRickUIBuilderTextConfig;

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
      const ACaption: string; const AConfig: TRickUIBuilderButtonConfig): TRectangle; overload; static;

    /// <summary>
    ///    Cria o mesmo Button da sobrecarga tradicional e devolve, em
    ///    ATextLabel, a referencia exata ao TLabel de Caption criado.
    /// </summary>
    /// <param name="ATextLabel">
    ///    Parametro de saida com o TLabel interno criado. A referencia
    ///    nao transfere ownership ao chamador.
    /// </param>
    /// <returns>
    ///    O mesmo TRectangle retornado pela sobrecarga tradicional.
    /// </returns>
    class function CreateButton(AOwner: TComponent; AParent: TFmxObject;
      const ACaption: string; const AConfig: TRickUIBuilderButtonConfig;
      out ATextLabel: TLabel): TRectangle; overload; static;
  end;

implementation

uses
  System.Math,
  FMX.Graphics;

{ TRickUIBuilderFactory }

class procedure TRickUIBuilderFactory.ApplyComboBoxConfig(
  AContainer: TRectangle; const AConfig: TRickUIBuilderComboBoxConfig);
begin
  AContainer.Position.X := AConfig.Left;
  AContainer.Position.Y := AConfig.Top;
  AContainer.Width := AConfig.Width;
  AContainer.Height := AConfig.Height;
  AContainer.Cursor := crHandPoint;
  AContainer.HitTest := True;
  AContainer.CanFocus := AConfig.Enabled;
  AContainer.Enabled := AConfig.Enabled;
  AContainer.Fill.Kind := TBrushKind.Solid;
  AContainer.Fill.Color := AConfig.BackgroundColor;
  AContainer.Stroke.Kind := TBrushKind.Solid;
  AContainer.Stroke.Color := AConfig.BorderColor;
  AContainer.XRadius := AConfig.CornerRadius;
  AContainer.YRadius := AConfig.CornerRadius;
  if not AConfig.Enabled then
    AContainer.Opacity := AConfig.DisabledOpacity;
end;

class function TRickUIBuilderFactory.ComboBoxArrowLeft(
  const AConfig: TRickUIBuilderComboBoxConfig): Single;
begin
  if AConfig.ArrowPosition = TRickUIBuilderComboBoxArrowPosition.Right then
    Result := AConfig.Width - Max(0, AConfig.ArrowMarginRight) - AConfig.ArrowSize
  else
    Result := Max(0, AConfig.ArrowMarginLeft);
  Result := Max(0, Min(Result, Max(0, AConfig.Width - AConfig.ArrowSize)));
end;

class function TRickUIBuilderFactory.ComboBoxArrowTop(
  const AConfig: TRickUIBuilderComboBoxConfig): Single;
var
  LAvailable: Single;
begin
  LAvailable := Max(0, AConfig.Height - Max(0, AConfig.ArrowMarginTop) -
    Max(0, AConfig.ArrowMarginBottom));
  Result := Max(0, AConfig.ArrowMarginTop) + Max(0,
    (LAvailable - AConfig.ArrowSize) / 2);
  Result := Max(0, Min(Result, Max(0, AConfig.Height - AConfig.ArrowSize)));
end;

class procedure TRickUIBuilderFactory.ConfigureComboBoxText(
  ATextLabel: TLabel; const AConfig: TRickUIBuilderComboBoxConfig);
var
  LArrowLeft: Single;
  LTextLeft: Single;
  LTextRight: Single;
begin
  LArrowLeft := ComboBoxArrowLeft(AConfig);
  LTextLeft := AConfig.HorizontalPadding;
  LTextRight := AConfig.Width - AConfig.HorizontalPadding;
  if AConfig.ArrowPosition = TRickUIBuilderComboBoxArrowPosition.Right then
    LTextRight := LArrowLeft - Max(0, AConfig.ArrowMarginLeft)
  else
    LTextLeft := LArrowLeft + AConfig.ArrowSize +
      Max(0, AConfig.ArrowMarginRight);
  ATextLabel.SetBounds(LTextLeft, 0, Max(1, LTextRight - LTextLeft),
    AConfig.Height);
  ATextLabel.TextSettings.Font.Size := AConfig.FontSize;
  ATextLabel.TextSettings.Font.Style := AConfig.FontStyle;
  ATextLabel.TextSettings.FontColor := AConfig.TextColor;
  ATextLabel.TextSettings.HorzAlign := AConfig.TextAlign;
  ATextLabel.TextSettings.VertAlign := TTextAlign.Center;
  ATextLabel.TextSettings.Trimming := AConfig.Trimming;
  ATextLabel.StyledSettings := ATextLabel.StyledSettings -
    [TStyledSetting.Size, TStyledSetting.Style, TStyledSetting.FontColor];
  if AConfig.FontFamily <> '' then
  begin
    ATextLabel.TextSettings.Font.Family := AConfig.FontFamily;
    ATextLabel.StyledSettings := ATextLabel.StyledSettings -
      [TStyledSetting.Family];
  end;
  ATextLabel.HitTest := False;
end;

class procedure TRickUIBuilderFactory.ConfigureComboBoxArrow(AArrow: TPath;
  const AConfig: TRickUIBuilderComboBoxConfig);
begin
  AArrow.SetBounds(ComboBoxArrowLeft(AConfig), ComboBoxArrowTop(AConfig),
    AConfig.ArrowSize, AConfig.ArrowSize);
  AArrow.Data.Data := AConfig.ClosedArrowPath;
  AArrow.Fill.Kind := TBrushKind.Solid;
  AArrow.Fill.Color := AConfig.ArrowColor;
  AArrow.Stroke.Kind := TBrushKind.None;
  AArrow.HitTest := False;
end;

class function TRickUIBuilderFactory.CreateComboBox(AOwner: TComponent;
  AParent: TFmxObject; const AConfig: TRickUIBuilderComboBoxConfig;
  out ATextLabel: TLabel; out AArrow: TPath): TRectangle;
begin
  Result := TRectangle.Create(AOwner);
  Result.Parent := AParent;
  ApplyComboBoxConfig(Result, AConfig);

  ATextLabel := TLabel.Create(AOwner);
  ATextLabel.Parent := Result;
  ConfigureComboBoxText(ATextLabel, AConfig);

  AArrow := TPath.Create(AOwner);
  AArrow.Parent := Result;
  ConfigureComboBoxArrow(AArrow, AConfig);
end;

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

class function TRickUIBuilderFactory.CreateBadgeContainer(AOwner: TComponent;
  AParent: TFmxObject; const AConfig: TRickUIBuilderBadgeConfig): TRectangle;
begin
  Result             := TRectangle.Create(AOwner);
  Result.Parent      := AParent;
  Result.Position.X  := AConfig.Left;
  Result.Position.Y  := AConfig.Top;
  Result.Width       := AConfig.Width;
  Result.Height      := AConfig.Height;
  Result.XRadius     := AConfig.Height / 2;
  Result.YRadius     := AConfig.Height / 2;
  Result.HitTest     := False;
  Result.Fill.Kind   := TBrushKind.Solid;
  Result.Fill.Color  := AConfig.BackgroundColor;
  Result.Stroke.Kind := TBrushKind.None;
end;

class function TRickUIBuilderFactory.BuildBadgeTextConfig(
  const AConfig: TRickUIBuilderBadgeConfig): TRickUIBuilderTextConfig;
begin
  Result                 := TRickUIBuilderTextConfig.Default;
  Result.Left            := 0;
  Result.Top             := 0;
  Result.Width           := AConfig.Width;
  Result.Height          := AConfig.Height;
  Result.FontSize        := AConfig.FontSize;
  Result.FontColor       := AConfig.TextColor;
  Result.HorizontalAlign := TTextAlign.Center;
end;

class function TRickUIBuilderFactory.CreateBadge(AOwner: TComponent;
  AParent: TFmxObject; const AText: string;
  const AConfig: TRickUIBuilderBadgeConfig; out ATextLabel: TLabel): TRectangle;
var
  LTextConfig: TRickUIBuilderTextConfig;
begin
  Result      := CreateBadgeContainer(AOwner, AParent, AConfig);
  LTextConfig := BuildBadgeTextConfig(AConfig);
  ATextLabel  := CreateText(AOwner, Result, AText, LTextConfig);
end;

class procedure TRickUIBuilderFactory.ApplyButtonConfig(AButton: TRectangle;
  const AConfig: TRickUIBuilderButtonConfig);
begin
  AButton.Position.X         := AConfig.Left;
  AButton.Position.Y         := AConfig.Top;
  AButton.Width              := AConfig.Width;
  AButton.Height             := AConfig.Height;
  AButton.Cursor             := crHandPoint;
  AButton.XRadius            := 16;
  AButton.YRadius            := 16;
  AButton.Tag                := AConfig.Tag;
  AButton.HitTest            := True;
  AButton.Fill.Kind          := TBrushKind.Solid;
  AButton.Fill.Color         := AConfig.FillColor;
  AButton.Stroke.Kind        := TBrushKind.None;

  if not (AConfig.BorderColor = TAlphaColors.Null) then
  begin
    AButton.Stroke.Kind      := TBrushKind.Solid;
    AButton.Stroke.Color     := AConfig.BorderColor;
    AButton.Stroke.Thickness := 2;
  end;
end;

class function TRickUIBuilderFactory.ButtonTextConfig(
  const AConfig: TRickUIBuilderButtonConfig): TRickUIBuilderTextConfig;
begin
  Result                 := TRickUIBuilderTextConfig.Default;
  Result.Left            := 0;
  Result.Top             := 0;
  Result.Width           := AConfig.Width;
  Result.Height          := AConfig.Height;
  Result.FontSize        := AConfig.FontSize;
  Result.FontColor       := AConfig.TextColor;
  Result.HorizontalAlign := TTextAlign.Center;
end;

class function TRickUIBuilderFactory.CreateButton(AOwner: TComponent;
  AParent: TFmxObject; const ACaption: string;
  const AConfig: TRickUIBuilderButtonConfig): TRectangle;
var
  LTextLabel: TLabel;
begin
  Result := CreateButton(AOwner, AParent, ACaption, AConfig, LTextLabel);
end;

class function TRickUIBuilderFactory.CreateButton(AOwner: TComponent;
  AParent: TFmxObject; const ACaption: string;
  const AConfig: TRickUIBuilderButtonConfig; out ATextLabel: TLabel): TRectangle;
begin
  Result := TRectangle.Create(AOwner);
  Result.Parent := AParent;
  ApplyButtonConfig(Result, AConfig);
  ATextLabel := CreateText(AOwner, Result, ACaption, ButtonTextConfig(AConfig));
end;

end.
