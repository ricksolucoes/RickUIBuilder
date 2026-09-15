unit Rick.UIBuilder.Tests.Types;
(*
  ==============================================================================
  Unit: Rick.UIBuilder.Tests.Types
  ==============================================================================

  RESPONSABILIDADE

  Testes unitarios puros (sem dependencia de TForm/Application) para os
  records definidos em Rick.UIBuilder.Types: valores de "Default" de cada
  Config e o comportamento de TRickUIBuilderSpacing.Create/Uniform/None.

  Nao pertence a categoria "Integration": nenhum destes testes cria
  controle FMX algum, apenas valida os records em memoria.

  ==============================================================================
*)

interface

uses
  DUnitX.TestFramework,
  System.UITypes,
  FMX.Types,
  Rick.UIBuilder.Types;

type
  [TestFixture]
  TRickUIBuilderTextConfigTests = class
  public
    [Test]
    procedure Default_DeveRetornarWidthCemEHeightVinteECinco;
    [Test]
    procedure Default_DeveRetornarFontSizeDoze;
    [Test]
    procedure Default_DeveRetornarFontColorPreto;
    [Test]
    procedure Default_DeveRetornarHorizontalAlignLeading;
    [Test]
    procedure Default_DeveRetornarBoldFalso;
  end;

  [TestFixture]
  TRickUIBuilderBadgeConfigTests = class
  public
    [Test]
    procedure Default_DeveRetornarWidthOitentaEHeightVinteECinco;
    [Test]
    procedure Default_DeveRetornarBackgroundColorCinzaClaro;
    [Test]
    procedure Default_DeveRetornarTextColorPreto;
  end;

  [TestFixture]
  TRickUIBuilderButtonConfigTests = class
  public
    [Test]
    procedure Default_DeveRetornarWidthCentoEVinteEHeightQuarenta;
    [Test]
    procedure Default_DeveRetornarFillColorDodgerblue;
    [Test]
    procedure Default_DeveRetornarBorderColorTransparente;
    [Test]
    procedure Default_DeveRetornarTextColorBranco;
    [Test]
    procedure Default_DeveRetornarTagZero;
  end;

  [TestFixture]
  TRickUIBuilderDividerConfigTests = class
  public
    [Test]
    procedure Default_DeveRetornarWidthCem;
    [Test]
    procedure Default_DeveRetornarColorCinzaClaro;
  end;

  [TestFixture]
  TRickUIBuilderSpacingTests = class
  public
    [Test]
    procedure Create_DeveArmazenarCadaLadoIndependentemente;
    [Test]
    procedure Uniform_DeveAplicarMesmoValorNosQuatroLados;
    [Test]
    procedure None_DeveRetornarTodosOsLadosComoZero;
  end;

implementation

{ TRickUIBuilderTextConfigTests }

procedure TRickUIBuilderTextConfigTests.Default_DeveRetornarWidthCemEHeightVinteECinco;
var
  LConfig: TRickUIBuilderTextConfig;
begin
  LConfig := TRickUIBuilderTextConfig.Default;

  Assert.AreEqual<Single>(100, LConfig.Width, 'Width padrao deveria ser 100.');
  Assert.AreEqual<Single>(25, LConfig.Height, 'Height padrao deveria ser 25.');
end;

procedure TRickUIBuilderTextConfigTests.Default_DeveRetornarFontSizeDoze;
var
  LConfig: TRickUIBuilderTextConfig;
begin
  LConfig := TRickUIBuilderTextConfig.Default;

  Assert.AreEqual<Single>(12, LConfig.FontSize, 'FontSize padrao deveria ser 12.');
end;

procedure TRickUIBuilderTextConfigTests.Default_DeveRetornarFontColorPreto;
var
  LConfig: TRickUIBuilderTextConfig;
begin
  LConfig := TRickUIBuilderTextConfig.Default;

  Assert.AreEqual<TAlphaColor>(TAlphaColors.Black, LConfig.FontColor,
    'FontColor padrao deveria ser preto.');
end;

procedure TRickUIBuilderTextConfigTests.Default_DeveRetornarHorizontalAlignLeading;
var
  LConfig: TRickUIBuilderTextConfig;
begin
  LConfig := TRickUIBuilderTextConfig.Default;

  Assert.AreEqual<TTextAlign>(TTextAlign.Leading, LConfig.HorizontalAlign,
    'HorizontalAlign padrao deveria ser Leading.');
end;

procedure TRickUIBuilderTextConfigTests.Default_DeveRetornarBoldFalso;
var
  LConfig: TRickUIBuilderTextConfig;
begin
  LConfig := TRickUIBuilderTextConfig.Default;

  Assert.IsFalse(LConfig.Bold, 'Bold padrao deveria ser False.');
end;

{ TRickUIBuilderBadgeConfigTests }

procedure TRickUIBuilderBadgeConfigTests.Default_DeveRetornarWidthOitentaEHeightVinteECinco;
var
  LConfig: TRickUIBuilderBadgeConfig;
begin
  LConfig := TRickUIBuilderBadgeConfig.Default;

  Assert.AreEqual<Single>(80, LConfig.Width, 'Width padrao deveria ser 80.');
  Assert.AreEqual<Single>(25, LConfig.Height, 'Height padrao deveria ser 25.');
end;

procedure TRickUIBuilderBadgeConfigTests.Default_DeveRetornarBackgroundColorCinzaClaro;
var
  LConfig: TRickUIBuilderBadgeConfig;
begin
  LConfig := TRickUIBuilderBadgeConfig.Default;

  Assert.AreEqual<TAlphaColor>(TAlphaColors.Lightgray, LConfig.BackgroundColor,
    'BackgroundColor padrao deveria ser cinza claro.');
end;

procedure TRickUIBuilderBadgeConfigTests.Default_DeveRetornarTextColorPreto;
var
  LConfig: TRickUIBuilderBadgeConfig;
begin
  LConfig := TRickUIBuilderBadgeConfig.Default;

  Assert.AreEqual<TAlphaColor>(TAlphaColors.Black, LConfig.TextColor,
    'TextColor padrao deveria ser preto.');
end;

{ TRickUIBuilderButtonConfigTests }

procedure TRickUIBuilderButtonConfigTests.Default_DeveRetornarWidthCentoEVinteEHeightQuarenta;
var
  LConfig: TRickUIBuilderButtonConfig;
begin
  LConfig := TRickUIBuilderButtonConfig.Default;

  Assert.AreEqual<Single>(120, LConfig.Width, 'Width padrao deveria ser 120.');
  Assert.AreEqual<Single>(40, LConfig.Height, 'Height padrao deveria ser 40.');
end;

procedure TRickUIBuilderButtonConfigTests.Default_DeveRetornarFillColorDodgerblue;
var
  LConfig: TRickUIBuilderButtonConfig;
begin
  LConfig := TRickUIBuilderButtonConfig.Default;

  Assert.AreEqual<TAlphaColor>(TAlphaColors.Dodgerblue, LConfig.FillColor,
    'FillColor padrao deveria ser Dodgerblue.');
end;

procedure TRickUIBuilderButtonConfigTests.Default_DeveRetornarBorderColorTransparente;
var
  LConfig: TRickUIBuilderButtonConfig;
begin
  LConfig := TRickUIBuilderButtonConfig.Default;

  Assert.AreEqual<TAlphaColor>(TAlphaColors.Null, LConfig.BorderColor,
    'BorderColor padrao deveria ser transparente (Null).');
end;

procedure TRickUIBuilderButtonConfigTests.Default_DeveRetornarTextColorBranco;
var
  LConfig: TRickUIBuilderButtonConfig;
begin
  LConfig := TRickUIBuilderButtonConfig.Default;

  Assert.AreEqual<TAlphaColor>(TAlphaColors.White, LConfig.TextColor,
    'TextColor padrao deveria ser branco.');
end;

procedure TRickUIBuilderButtonConfigTests.Default_DeveRetornarTagZero;
var
  LConfig: TRickUIBuilderButtonConfig;
begin
  LConfig := TRickUIBuilderButtonConfig.Default;

  Assert.AreEqual<NativeInt>(0, LConfig.Tag, 'Tag padrao deveria ser 0.');
end;

{ TRickUIBuilderDividerConfigTests }

procedure TRickUIBuilderDividerConfigTests.Default_DeveRetornarWidthCem;
var
  LConfig: TRickUIBuilderDividerConfig;
begin
  LConfig := TRickUIBuilderDividerConfig.Default;

  Assert.AreEqual<Single>(100, LConfig.Width, 'Width padrao deveria ser 100.');
end;

procedure TRickUIBuilderDividerConfigTests.Default_DeveRetornarColorCinzaClaro;
var
  LConfig: TRickUIBuilderDividerConfig;
begin
  LConfig := TRickUIBuilderDividerConfig.Default;

  Assert.AreEqual<TAlphaColor>(TAlphaColors.Lightgray, LConfig.Color,
    'Color padrao deveria ser cinza claro.');
end;

{ TRickUIBuilderSpacingTests }

procedure TRickUIBuilderSpacingTests.Create_DeveArmazenarCadaLadoIndependentemente;
var
  LSpacing: TRickUIBuilderSpacing;
begin
  LSpacing := TRickUIBuilderSpacing.Create(1, 2, 3, 4);

  Assert.AreEqual<Single>(1, LSpacing.Left, 'Left incorreto.');
  Assert.AreEqual<Single>(2, LSpacing.Top, 'Top incorreto.');
  Assert.AreEqual<Single>(3, LSpacing.Right, 'Right incorreto.');
  Assert.AreEqual<Single>(4, LSpacing.Bottom, 'Bottom incorreto.');
end;

procedure TRickUIBuilderSpacingTests.Uniform_DeveAplicarMesmoValorNosQuatroLados;
var
  LSpacing: TRickUIBuilderSpacing;
begin
  LSpacing := TRickUIBuilderSpacing.Uniform(8);

  Assert.AreEqual<Single>(8, LSpacing.Left, 'Left deveria ser 8.');
  Assert.AreEqual<Single>(8, LSpacing.Top, 'Top deveria ser 8.');
  Assert.AreEqual<Single>(8, LSpacing.Right, 'Right deveria ser 8.');
  Assert.AreEqual<Single>(8, LSpacing.Bottom, 'Bottom deveria ser 8.');
end;

procedure TRickUIBuilderSpacingTests.None_DeveRetornarTodosOsLadosComoZero;
var
  LSpacing: TRickUIBuilderSpacing;
begin
  LSpacing := TRickUIBuilderSpacing.None;

  Assert.AreEqual<Single>(0, LSpacing.Left, 'Left deveria ser 0.');
  Assert.AreEqual<Single>(0, LSpacing.Top, 'Top deveria ser 0.');
  Assert.AreEqual<Single>(0, LSpacing.Right, 'Right deveria ser 0.');
  Assert.AreEqual<Single>(0, LSpacing.Bottom, 'Bottom deveria ser 0.');
end;

initialization
  TDUnitX.RegisterTestFixture(TRickUIBuilderTextConfigTests);
  TDUnitX.RegisterTestFixture(TRickUIBuilderBadgeConfigTests);
  TDUnitX.RegisterTestFixture(TRickUIBuilderButtonConfigTests);
  TDUnitX.RegisterTestFixture(TRickUIBuilderDividerConfigTests);
  TDUnitX.RegisterTestFixture(TRickUIBuilderSpacingTests);

end.
