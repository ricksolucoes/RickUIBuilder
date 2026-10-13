unit Rick.UIBuilder.Tests.Edit.Fluent;

{$SCOPEDENUMS ON}

interface

uses
  DUnitX.TestFramework,

  Rick.UIBuilder.Edit.Interfaces;

type
  [TestFixture]
  [Category('Integration')]
  TRickUIBuilderEditFluentTests = class
  private
    FEdit: IRickUIBuilderEdit;
  public
    [Setup] procedure Setup;
    [TearDown] procedure TearDown;
    [Test] procedure FilhosEspecializados_DevemSerCacheados;
    [Test] procedure Rectangle_DeveNavegarParaOrigem;
    [Test] procedure LabelsMainColor_DeveNavegarParaOrigem;
    [Test] procedure LabelsErrorFont_DeveNavegarParaOrigem;
    [Test] procedure DesignerInputText_DeveRetornarDesignerConformeContrato;
    [Test] procedure DesignerFilhos_DeveNavegarParaOrigem;
    [Test] procedure LineEConfig_DeveNavegarParaOrigem;
    [Test] procedure Validation_DeveExporEstadoContratual;
    [Test] procedure Number_MutadoresDevemPreservarFluent;
  end;

implementation

uses
  System.UITypes,

  Rick.UIBuilder.Edit.Builder,
  Rick.UIBuilder.Edit.Types;

procedure TRickUIBuilderEditFluentTests.Setup;
begin
  FEdit := TRickUIBuilderEdit.New;
end;

procedure TRickUIBuilderEditFluentTests.TearDown;
begin
  FEdit := nil;
end;

procedure TRickUIBuilderEditFluentTests.FilhosEspecializados_DevemSerCacheados;
begin
  Assert.IsTrue(FEdit.Rectangle.Position = FEdit.Rectangle.Position);
  Assert.IsTrue(FEdit.Rectangle.Border = FEdit.Rectangle.Border);
  Assert.IsTrue(FEdit.Labels.Main = FEdit.Labels.Main);
  Assert.IsTrue(FEdit.Labels.Counter = FEdit.Labels.Counter);
  Assert.IsTrue(FEdit.Labels.Error.Text.Font = FEdit.Labels.Error.Text.Font);
  Assert.IsTrue(FEdit.Designer.Input = FEdit.Designer.Input);
  Assert.IsTrue(FEdit.Designer.Input.Text.Color = FEdit.Designer.Input.Text.Color);
  Assert.IsTrue(FEdit.Designer.Input.Number = FEdit.Designer.Input.Number);
  Assert.IsTrue(FEdit.Designer.Input.Config = FEdit.Designer.Input.Config);
  Assert.IsTrue(FEdit.Designer.Validation = FEdit.Designer.Validation);
  Assert.IsTrue(FEdit.Designer.Config = FEdit.Designer.Config);
  Assert.IsTrue(FEdit.Line.Color = FEdit.Line.Color);
  Assert.IsTrue(FEdit.Config.Icons = FEdit.Config.Icons);
  Assert.IsTrue(FEdit.Config.Icons.Colors = FEdit.Config.Icons.Colors);
  Assert.IsTrue(FEdit.Config.Icons.Paths = FEdit.Config.Icons.Paths);
end;

procedure TRickUIBuilderEditFluentTests.Rectangle_DeveNavegarParaOrigem;
var
  LRectangle: IRickUIBuilderEditRetangle;
begin
  LRectangle := FEdit.Rectangle;
  Assert.IsTrue(LRectangle.Position.ToBack = LRectangle);
  Assert.IsTrue(LRectangle.Size.ToBack = LRectangle);
  Assert.IsTrue(LRectangle.Background.ToBack = LRectangle);
  Assert.IsTrue(LRectangle.Border.ToBack = LRectangle);
  Assert.IsTrue(LRectangle.ToBack = FEdit);
end;

procedure TRickUIBuilderEditFluentTests.LabelsMainColor_DeveNavegarParaOrigem;
var
  LLabels: IRickUIBuilderEditLabel;
  LMain: IRickUIBuilderEditLabelMain;
  LText: IRickUIBuilderEditLabelMainText;
  LColor: IRickUIBuilderEditLabelMainTextColor;
begin
  LLabels := FEdit.Labels;
  LMain := LLabels.Main;
  LText := LMain.Text;
  LColor := LText.Color;
  Assert.IsTrue(LColor.ToBack = LText);
  Assert.IsTrue(LColor.Invalid(TAlphaColors.Red) = LText);
  Assert.IsTrue(LColor.ReadOnly(TAlphaColors.Gray) = LText);
  Assert.IsTrue(LText.ToBack = LMain);
  Assert.IsTrue(LMain.ToBack = LLabels);
end;

procedure TRickUIBuilderEditFluentTests.LabelsErrorFont_DeveNavegarParaOrigem;
var
  LError: IRickUIBuilderEditLabelError;
  LText: IRickUIBuilderEditLabelErrorText;
begin
  LError := FEdit.Labels.Error;
  LText := LError.Text;
  Assert.IsTrue(LText.Font.ToBack = LText);
  Assert.IsTrue(LText.ToBack = LError);
  Assert.IsTrue(LError.ToBack = FEdit.Labels);
end;

procedure TRickUIBuilderEditFluentTests.DesignerInputText_DeveRetornarDesignerConformeContrato;
var
  LDesigner: IRickUIBuilderEditDesigner;
  LInput: IRickUIBuilderEditDesignerInput;
  LText: IRickUIBuilderEditDesignerInputText;
begin
  LDesigner := FEdit.Designer;
  LInput := LDesigner.Input;
  LText := LInput.Text;
  Assert.IsTrue(LText.Color.ToBack = LText);
  Assert.IsTrue(LText.ToBack = LDesigner);
  Assert.IsTrue(LText.Size(16) = LDesigner);
  Assert.IsTrue(LInput.ToBack = LDesigner);
end;

procedure TRickUIBuilderEditFluentTests.DesignerFilhos_DeveNavegarParaOrigem;
var
  LDesigner: IRickUIBuilderEditDesigner;
  LInput: IRickUIBuilderEditDesignerInput;
begin
  LDesigner := FEdit.Designer;
  LInput := LDesigner.Input;
  Assert.IsTrue(LInput.Number.ToBack = LInput);
  Assert.IsTrue(LInput.Config.ToBack = LInput);
  Assert.IsTrue(LDesigner.Validation.ToBack = LDesigner);
  Assert.IsTrue(LDesigner.Config.ToBack = LDesigner);
  Assert.IsTrue(LDesigner.ToBack = FEdit);
end;

procedure TRickUIBuilderEditFluentTests.LineEConfig_DeveNavegarParaOrigem;
var
  LConfig: IRickUIBuilderEditConfig;
  LIcons: IRickUIBuilderEditConfigIcons;
  LLine: IRickUIBuilderEditLine;
begin
  LLine := FEdit.Line;
  Assert.IsTrue(LLine.Color.ToBack = LLine);
  Assert.IsTrue(LLine.ToBack = FEdit);
  LConfig := FEdit.Config;
  LIcons := LConfig.Icons;
  Assert.IsTrue(LIcons.Colors.ToBack = LIcons);
  Assert.IsTrue(LIcons.Paths.ToBack = LIcons);
  Assert.IsTrue(LIcons.ToBack = LConfig);
  Assert.IsTrue(LConfig.ToBack = FEdit);
end;

procedure TRickUIBuilderEditFluentTests.Validation_DeveExporEstadoContratual;
var
  LValidation: IRickUIBuilderEditDesignerValidation;
begin
  LValidation := FEdit.Designer.Validation;
  LValidation.Invalid(True, 'Valor inválido').RequirementMet(True);
  Assert.IsTrue(LValidation.HasInvalid);
  Assert.IsTrue(LValidation.InvalidValue);
  Assert.AreEqual('Valor inválido', LValidation.InvalidMessage);
  Assert.IsTrue(LValidation.HasRequirementMet);
  Assert.IsTrue(LValidation.RequirementMetValue);
end;

procedure TRickUIBuilderEditFluentTests.Number_MutadoresDevemPreservarFluent;
var
  LNumber: IRickUIBuilderEditDesignerInputNumber;
begin
  LNumber := FEdit.Designer.Input.Number;
  Assert.IsTrue(LNumber.AllowNegative = LNumber);
  Assert.IsTrue(LNumber.DecimalPlaces(3) = LNumber);
  Assert.IsTrue(LNumber.FormatMode(TRickUIBuilderEditNumberFormatMode.Custom) = LNumber);
  Assert.IsTrue(LNumber.DecimalSeparator(',') = LNumber);
  Assert.IsTrue(LNumber.ThousandSeparator('.') = LNumber);
  Assert.IsTrue(LNumber.UseThousandSeparator = LNumber);
end;

initialization
  TDUnitX.RegisterTestFixture(TRickUIBuilderEditFluentTests);

end.
