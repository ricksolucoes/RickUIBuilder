{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Example.ComboBox.Factory.Runner                       }
{                                                                              }
{ Esta unit executa os sete exemplos ComboBox - Factory diretamente no         }
{ ResultHost. A Factory atual materializa somente o controle fechado; por isso }
{ nenhum exemplo simula lista, popup, seleção ou runtime inexistente na API.   }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Executar exemplos comprováveis de TRickUIBuilderFactory.CreateComboBox.     }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Materializa TRectangle + TLabel + TPath, demonstra os 24 campos consumidos  }
{  pelo controle fechado e mantém o Completo exaustivo nos 58 campos públicos  }
{  de TRickUIBuilderComboBoxConfig, distinguindo os campos de runtime.         }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - RickUIBuilder.Samples.App.Types                                           }
{      Fornece TComboBoxFactoryExample usado para selecionar a execução.       }
{  - Rick.UIBuilder.Factory                                                    }
{      Fornece TRickUIBuilderFactory.CreateComboBox.                           }
{  - Rick.UIBuilder.Types                                                      }
{      Fornece config, enums e paths públicos utilizados pelos exemplos.       }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - TExampleComboBoxFactory limpa ResultHost e solicita Render.               }
{  - Cada método materializa somente o resultado do exemplo selecionado.       }
{  - Factory.Content fornece o snippet equivalente sem ser dependência direta. }
{                                                                              }
{  Ownership / lifetime                                                        }
{  --------------------                                                        }
{  - ResultHost é usado como Owner e Parent do TRectangle principal.           }
{  - TLabel e TPath usam ResultHost como Owner e o TRectangle como Parent.     }
{  - LTextLabel e LArrow são referências non-owning aos filhos materializados. }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - Não cria lista, popup, seleção nem runtime por fora da Factory.           }
{  - Não depende de classes internas do runtime nem do Fluent Builder.          }
{  - Os helpers do Completo apenas agrupam os 58 campos para preservar métodos }
{    pequenos; não introduzem nova abstração de domínio.                       }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Valores e ordem dos campos devem permanecer sincronizados com Content.      }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.Example.ComboBox.Factory.Runner;

interface

uses
  FMX.Layouts,
  RickUIBuilder.Samples.App.Types,
  Rick.UIBuilder.Types;

type
  /// <summary>Executa o resultado visual dos exemplos Factory de ComboBox.</summary>
  TComboBoxFactoryRunner = class sealed
  strict private
    class procedure RenderPrimary(const AExample: TComboBoxFactoryExample;
      const AHost: TLayout); static;
    class procedure RenderAdvanced(const AExample: TComboBoxFactoryExample;
      const AHost: TLayout); static;
    class procedure RenderBasic(const AHost: TLayout); static;
    class procedure RenderGeometryShape(const AHost: TLayout); static;
    class procedure RenderTypographyText(const AHost: TLayout); static;
    class procedure RenderColors(const AHost: TLayout); static;
    class procedure RenderArrow(const AHost: TLayout); static;
    class procedure RenderState(const AHost: TLayout); static;
    class procedure RenderComplete(const AHost: TLayout); static;
    class procedure ConfigureCompleteGeometry(var AConfig: TRickUIBuilderComboBoxConfig); static;
    class procedure ConfigureCompleteArrowTypography(var AConfig: TRickUIBuilderComboBoxConfig); static;
    class procedure ConfigureCompleteColors(var AConfig: TRickUIBuilderComboBoxConfig); static;
    class procedure ConfigureCompleteFullWindowGeometry(var AConfig: TRickUIBuilderComboBoxConfig); static;
    class procedure ConfigureCompleteFullWindowColors(var AConfig: TRickUIBuilderComboBoxConfig); static;
    class procedure ConfigureCompleteContentBehavior(var AConfig: TRickUIBuilderComboBoxConfig); static;
  public
    class procedure Render(const AExample: TComboBoxFactoryExample;
      const AHost: TLayout); static;
  end;

implementation

uses
  System.UITypes,

  FMX.Objects,
  FMX.StdCtrls,
  FMX.Types,

  Rick.UIBuilder.Factory;

class procedure TComboBoxFactoryRunner.Render(
  const AExample: TComboBoxFactoryExample; const AHost: TLayout);
begin
  if AExample <= TComboBoxFactoryExample.Colors then
    RenderPrimary(AExample, AHost)
  else
    RenderAdvanced(AExample, AHost);
end;

class procedure TComboBoxFactoryRunner.RenderPrimary(
  const AExample: TComboBoxFactoryExample; const AHost: TLayout);
begin
  case AExample of
    TComboBoxFactoryExample.Basic: RenderBasic(AHost);
    TComboBoxFactoryExample.GeometryShape: RenderGeometryShape(AHost);
    TComboBoxFactoryExample.TypographyText: RenderTypographyText(AHost);
    TComboBoxFactoryExample.Colors: RenderColors(AHost);
  end;
end;

class procedure TComboBoxFactoryRunner.RenderAdvanced(
  const AExample: TComboBoxFactoryExample; const AHost: TLayout);
begin
  case AExample of
    TComboBoxFactoryExample.Arrow: RenderArrow(AHost);
    TComboBoxFactoryExample.State: RenderState(AHost);
    TComboBoxFactoryExample.Complete: RenderComplete(AHost);
  end;
end;

class procedure TComboBoxFactoryRunner.RenderBasic(const AHost: TLayout);
var
  LTextLabel: TLabel;
  LArrow: TPath;
  LConfig: TRickUIBuilderComboBoxConfig;
begin
  LConfig := TRickUIBuilderComboBoxConfig.Default;
  TRickUIBuilderFactory.CreateComboBox(AHost, AHost, LConfig,
    LTextLabel, LArrow);
  LTextLabel.Text := 'Selecione...';
end;

class procedure TComboBoxFactoryRunner.RenderGeometryShape(
  const AHost: TLayout);
var
  LTextLabel: TLabel;
  LArrow: TPath;
  LConfig: TRickUIBuilderComboBoxConfig;
begin
  LConfig := TRickUIBuilderComboBoxConfig.Default;
  LConfig.Left := 20;
  LConfig.Top := 20;
  LConfig.Width := 280;
  LConfig.Height := 44;
  LConfig.CornerRadius := 10;
  LConfig.HorizontalPadding := 16;
  TRickUIBuilderFactory.CreateComboBox(AHost, AHost, LConfig,
    LTextLabel, LArrow);
  LTextLabel.Text := 'Geometria e forma';
end;

class procedure TComboBoxFactoryRunner.RenderTypographyText(
  const AHost: TLayout);
var
  LTextLabel: TLabel;
  LArrow: TPath;
  LConfig: TRickUIBuilderComboBoxConfig;
begin
  LConfig := TRickUIBuilderComboBoxConfig.Default;
  LConfig.Width := 250;
  LConfig.FontSize := 16;
  LConfig.FontFamily := 'Arial';
  LConfig.FontStyle := [TFontStyle.fsBold];
  LConfig.TextAlign := TTextAlign.Center;
  LConfig.Trimming := TTextTrimming.Character;
  TRickUIBuilderFactory.CreateComboBox(AHost, AHost, LConfig,
    LTextLabel, LArrow);
  LTextLabel.Text := 'Texto longo para demonstrar alinhamento e trimming';
end;

class procedure TComboBoxFactoryRunner.RenderColors(const AHost: TLayout);
var
  LTextLabel: TLabel;
  LArrow: TPath;
  LConfig: TRickUIBuilderComboBoxConfig;
begin
  LConfig := TRickUIBuilderComboBoxConfig.Default;
  LConfig.BackgroundColor := TAlphaColors.Dodgerblue;
  LConfig.BorderColor := TAlphaColors.Gray;
  LConfig.TextColor := TAlphaColors.White;
  LConfig.ArrowColor := TAlphaColors.White;
  TRickUIBuilderFactory.CreateComboBox(AHost, AHost, LConfig,
    LTextLabel, LArrow);
  LTextLabel.Text := 'Cores';
end;

class procedure TComboBoxFactoryRunner.RenderArrow(const AHost: TLayout);
var
  LTextLabel: TLabel;
  LArrow: TPath;
  LConfig: TRickUIBuilderComboBoxConfig;
begin
  LConfig := TRickUIBuilderComboBoxConfig.Default;
  LConfig.Width := 280;
  LConfig.ArrowSize := 18;
  LConfig.ArrowMarginLeft := 14;
  LConfig.ArrowMarginTop := 4;
  LConfig.ArrowMarginRight := 10;
  LConfig.ArrowMarginBottom := 4;
  LConfig.ArrowPosition := TRickUIBuilderComboBoxArrowPosition.Left;
  LConfig.ClosedArrowPath := RICK_COMBOBOX_ARROW_UP_PATH;
  TRickUIBuilderFactory.CreateComboBox(AHost, AHost, LConfig,
    LTextLabel, LArrow);
  LTextLabel.Text := 'Seta à esquerda';
end;

class procedure TComboBoxFactoryRunner.RenderState(const AHost: TLayout);
var
  LTextLabel: TLabel;
  LArrow: TPath;
  LConfig: TRickUIBuilderComboBoxConfig;
begin
  LConfig := TRickUIBuilderComboBoxConfig.Default;
  LConfig.Enabled := False;
  LConfig.DisabledOpacity := 0.45;
  TRickUIBuilderFactory.CreateComboBox(AHost, AHost, LConfig,
    LTextLabel, LArrow);
  LTextLabel.Text := 'Desabilitado';
end;

class procedure TComboBoxFactoryRunner.RenderComplete(const AHost: TLayout);
var
  LTextLabel: TLabel;
  LArrow: TPath;
  LConfig: TRickUIBuilderComboBoxConfig;
begin
  LConfig := TRickUIBuilderComboBoxConfig.Default;
  ConfigureCompleteGeometry(LConfig);
  ConfigureCompleteArrowTypography(LConfig);
  ConfigureCompleteColors(LConfig);
  ConfigureCompleteFullWindowGeometry(LConfig);
  ConfigureCompleteFullWindowColors(LConfig);
  ConfigureCompleteContentBehavior(LConfig);
  TRickUIBuilderFactory.CreateComboBox(AHost, AHost, LConfig,
    LTextLabel, LArrow);
  LTextLabel.Text := 'Configuração completa';
end;

class procedure TComboBoxFactoryRunner.ConfigureCompleteGeometry(
  var AConfig: TRickUIBuilderComboBoxConfig);
begin
  AConfig.Left := 18;
  AConfig.Top := 20;
  AConfig.Width := 320;
  AConfig.Height := 44;
  AConfig.ItemHeight := 40;
  AConfig.PopupWidth := 340;
  AConfig.PopupWidthOffset := 12;
  AConfig.PopupMaxHeight := 280;
  AConfig.CornerRadius := 10;
  AConfig.HorizontalPadding := 16;
end;

class procedure TComboBoxFactoryRunner.ConfigureCompleteArrowTypography(
  var AConfig: TRickUIBuilderComboBoxConfig);
begin
  AConfig.ArrowSize := 18;
  AConfig.ArrowMarginLeft := 10;
  AConfig.ArrowMarginTop := 4;
  AConfig.ArrowMarginRight := 14;
  AConfig.ArrowMarginBottom := 4;
  AConfig.ArrowPosition := TRickUIBuilderComboBoxArrowPosition.Right;
  AConfig.FontSize := 15;
  AConfig.FontFamily := 'Arial';
  AConfig.FontStyle := [TFontStyle.fsBold];
  AConfig.TextAlign := TTextAlign.Center;
  AConfig.Trimming := TTextTrimming.Character;
end;

class procedure TComboBoxFactoryRunner.ConfigureCompleteColors(
  var AConfig: TRickUIBuilderComboBoxConfig);
begin
  AConfig.BackgroundColor := TAlphaColors.Dodgerblue;
  AConfig.EditBackgroundColor := $FFF7F7F7;
  AConfig.BorderColor := TAlphaColors.Gray;
  AConfig.TextColor := TAlphaColors.White;
  AConfig.PlaceholderColor := $FFD0D5DD;
  AConfig.ArrowColor := TAlphaColors.White;
  AConfig.PopupColor := TAlphaColors.White;
  AConfig.HoverColor := $FFF2F4F7;
  AConfig.SelectedColor := $FFEFF8FF;
  AConfig.FocusColor := $FF2E90FA;
  AConfig.DisabledOpacity := 0.50;
  AConfig.SearchTimeout := 750;
end;

class procedure TComboBoxFactoryRunner.ConfigureCompleteFullWindowGeometry(
  var AConfig: TRickUIBuilderComboBoxConfig);
begin
  AConfig.FullWindowCornerRadius := 24;
  AConfig.FullWindowPadding := 16;
  AConfig.SearchHeaderHeight := 84;
  AConfig.SearchFieldHeight := 52;
  AConfig.SearchFieldCornerRadius := 14;
  AConfig.SearchIconSize := 22;
  AConfig.NoResultsIconSize := 60;
end;

class procedure TComboBoxFactoryRunner.ConfigureCompleteFullWindowColors(
  var AConfig: TRickUIBuilderComboBoxConfig);
begin
  AConfig.FullWindowBackgroundColor := TAlphaColors.White;
  AConfig.SearchFieldBackgroundColor := TAlphaColors.White;
  AConfig.SearchFieldBorderColor := $FF98A2B3;
  AConfig.SearchTextColor := $FF1D2939;
  AConfig.SearchIconColor := $FF1D2939;
  AConfig.NoResultsTextColor := $FF667085;
  AConfig.NoResultsIconColor := $FF98A2B3;
end;

class procedure TComboBoxFactoryRunner.ConfigureCompleteContentBehavior(
  var AConfig: TRickUIBuilderComboBoxConfig);
begin
  AConfig.SearchPlaceholder := 'Pesquisar item...';
  AConfig.NoResultsText := 'Nenhum item encontrado';
  AConfig.BackPath := RICK_COMBOBOX_BACK_PATH;
  AConfig.ClearPath := RICK_COMBOBOX_CLEAR_PATH;
  AConfig.NoResultsPath := RICK_COMBOBOX_NO_RESULTS_PATH;
  AConfig.Enabled := True;
  AConfig.RequestedStyleType := TRickUIBuilderComboBoxStyleType.Adaptive;
  AConfig.EffectiveStyleType := TRickUIBuilderComboBoxStyleType.Desktop;
  AConfig.PresentationMode := TRickUIBuilderComboBoxPresentationMode.Auto;
  AConfig.ClosedArrowPath := RICK_COMBOBOX_ARROW_DOWN_PATH;
  AConfig.OpenedArrowPath := RICK_COMBOBOX_ARROW_UP_PATH;
end;

end.
