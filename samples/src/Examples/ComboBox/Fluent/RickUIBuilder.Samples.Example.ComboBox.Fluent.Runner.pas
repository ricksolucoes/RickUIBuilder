{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Example.ComboBox.Fluent.Runner                        }
{                                                                              }
{ Esta unit executa os quinze exemplos ComboBox - Fluent Builder com listas    }
{ reais, seleção, presentation, eventos, customização e handle runtime.        }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Executar exemplos reais da API pública TRickUIBuilder.ComboBox.             }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Demonstra listas simples, DisplayText/Value, itens estruturados, colunas,   }
{  seleção inicial, estilos, pesquisa FullWindow, callbacks e BuildHandle.     }
{  O exemplo Completo configura os 58 campos públicos do config e todos os     }
{  32 métodos configuráveis de IRickUIBuilderComboBox antes de BuildHandle.    }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - RickUIBuilder.Samples.App.Types                                           }
{      Fornece TComboBoxFluentExample para o dispatch.                         }
{  - Rick.UIBuilder                                                            }
{      Fornece TRickUIBuilder.ComboBox, entrada pública do Fluent Builder.     }
{  - Rick.UIBuilder.Interfaces                                                 }
{      Fornece IRickUIBuilderComboBox, Handle e callback de customização.      }
{  - Rick.UIBuilder.Types                                                      }
{      Fornece config, itens, colunas, enums e paths públicos do ComboBox.     }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - TExampleComboBoxFluent chama Reset antes de destruir o resultado antigo.  }
{  - Render executa somente o exemplo selecionado.                             }
{  - Eventos atualizam somente feedback owned pelo ResultHost atual.           }
{                                                                              }
{  Ownership / lifetime                                                        }
{  --------------------                                                        }
{  - Build/BuildHandle recebem diretamente AHost como Parent.                  }
{  - FStatusLabel é referência non-owning e é zerada por Reset.                }
{  - Controles criados em OnCustomizeItem usam AContainer como Owner/Parent.   }
{  - O Runner vive durante toda a página, mantendo callbacks of object válidos.}
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - Não usa classes concretas internas de Data/Handle/Presentation.           }
{  - Não usa TComponent/InsertComponent para prolongar lifetime de callbacks.  }
{  - Não cria container intermediário para materializar o ComboBox.            }
{  - Não contém textos de navegação ou documentação da Sample Page.            }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Manter valores, callbacks e sequência Fluent sincronizados com Content.     }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.Example.ComboBox.Fluent.Runner;

interface

uses
  FMX.Controls,
  FMX.Layouts,
  FMX.Objects,
  FMX.StdCtrls,

  Rick.UIBuilder.Interfaces,
  Rick.UIBuilder.Types,

  RickUIBuilder.Samples.App.Types;

type
  /// <summary>Executa os exemplos visuais e interativos Fluent de ComboBox.</summary>
  TComboBoxFluentRunner = class sealed
  strict private
    FStatusLabel: TLabel;
    procedure RenderData(const AExample: TComboBoxFluentExample;
      const AHost: TLayout);
    procedure RenderPresentation(const AExample: TComboBoxFluentExample;
      const AHost: TLayout);
    procedure RenderInteraction(const AExample: TComboBoxFluentExample;
      const AHost: TLayout);
    procedure RenderBasic(const AHost: TLayout);
    procedure RenderInterface(const AHost: TLayout);
    procedure RenderDisplayValue(const AHost: TLayout);
    procedure RenderStructuredList(const AHost: TLayout);
    procedure RenderInitialSelection(const AHost: TLayout);
    procedure RenderGeometryPopup(const AHost: TLayout);
    procedure RenderDesktopAnchored(const AHost: TLayout);
    procedure RenderFullWindowSearch(const AHost: TLayout);
    procedure RenderCustomConfig(const AHost: TLayout);
    procedure RenderArrow(const AHost: TLayout);
    procedure RenderState(const AHost: TLayout);
    procedure RenderEvents(const AHost: TLayout);
    procedure RenderCustomizeItem(const AHost: TLayout);
    procedure RenderRuntimeHandle(const AHost: TLayout);
    procedure RenderComplete(const AHost: TLayout);
    procedure ComboChanged(ASender: TObject);
    procedure ComboOpened(ASender: TObject);
    procedure ComboClosed(ASender: TObject);
    procedure CustomizeItem(ASender: TObject; AIndex: Integer;
      const AItem: TRickUIBuilderComboBoxItem; AContainer: TControl);
    class procedure ConfigureCustomBadge(ABadge: TRectangle); static;
    class procedure ConfigureCustomBadgeLabel(ALabel: TLabel;
      const AText: string); static;
    procedure SetStatus(const AText: string);
    procedure CreateStatusLabel(const AHost: TLayout; const AText: string);
    class function AdvancedConfig: TRickUIBuilderComboBoxConfig; static;
    class function FixedColumn: TRickUIBuilderComboBoxColumn; static;
    class function ProportionalColumn: TRickUIBuilderComboBoxColumn; static;
    class function AutoColumn: TRickUIBuilderComboBoxColumn; static;
    class procedure ConfigureRuntimeHandle(
      const AHandle: IRickUIBuilderComboBoxHandle); static;
    procedure ShowRuntimeStatus(const AHost: TLayout;
      const AHandle: IRickUIBuilderComboBoxHandle);
    class function CompleteConfig: TRickUIBuilderComboBoxConfig; static;
    class procedure ConfigureCompleteGeometry(
      var AConfig: TRickUIBuilderComboBoxConfig); static;
    class procedure ConfigureCompleteArrowTypography(
      var AConfig: TRickUIBuilderComboBoxConfig); static;
    class procedure ConfigureCompleteColors(
      var AConfig: TRickUIBuilderComboBoxConfig); static;
    class procedure ConfigureCompleteFullWindowGeometry(
      var AConfig: TRickUIBuilderComboBoxConfig); static;
    class procedure ConfigureCompleteFullWindowColors(
      var AConfig: TRickUIBuilderComboBoxConfig); static;
    class procedure ConfigureCompleteContentBehavior(
      var AConfig: TRickUIBuilderComboBoxConfig); static;
    class procedure ConfigureCompleteData(
      const ACombo: IRickUIBuilderComboBox); static;
    class procedure ConfigureCompletePresentation(
      const ACombo: IRickUIBuilderComboBox); static;
    procedure ConfigureCompleteEvents(const ACombo: IRickUIBuilderComboBox);
  public
    procedure Reset;
    procedure Render(const AExample: TComboBoxFluentExample;
      const AHost: TLayout);
  end;

implementation

uses
  System.SysUtils,
  System.UITypes,

  FMX.Graphics,
  FMX.Types,

  Rick.UIBuilder;

procedure TComboBoxFluentRunner.Reset;
begin
  FStatusLabel := nil;
end;

procedure TComboBoxFluentRunner.Render(const AExample: TComboBoxFluentExample;
  const AHost: TLayout);
begin
  if AExample <= TComboBoxFluentExample.InitialSelection then
    RenderData(AExample, AHost)
  else if AExample <= TComboBoxFluentExample.Arrow then
    RenderPresentation(AExample, AHost)
  else
    RenderInteraction(AExample, AHost);
end;

procedure TComboBoxFluentRunner.RenderData(
  const AExample: TComboBoxFluentExample; const AHost: TLayout);
begin
  case AExample of
    TComboBoxFluentExample.Basic: RenderBasic(AHost);
    TComboBoxFluentExample.InterfaceUsage: RenderInterface(AHost);
    TComboBoxFluentExample.DisplayValue: RenderDisplayValue(AHost);
    TComboBoxFluentExample.StructuredList: RenderStructuredList(AHost);
    TComboBoxFluentExample.InitialSelection: RenderInitialSelection(AHost);
  end;
end;

procedure TComboBoxFluentRunner.RenderPresentation(
  const AExample: TComboBoxFluentExample; const AHost: TLayout);
begin
  case AExample of
    TComboBoxFluentExample.GeometryPopup: RenderGeometryPopup(AHost);
    TComboBoxFluentExample.DesktopAnchored: RenderDesktopAnchored(AHost);
    TComboBoxFluentExample.FullWindowSearch: RenderFullWindowSearch(AHost);
    TComboBoxFluentExample.CustomConfig: RenderCustomConfig(AHost);
    TComboBoxFluentExample.Arrow: RenderArrow(AHost);
  end;
end;

procedure TComboBoxFluentRunner.RenderInteraction(
  const AExample: TComboBoxFluentExample; const AHost: TLayout);
begin
  case AExample of
    TComboBoxFluentExample.State: RenderState(AHost);
    TComboBoxFluentExample.Events: RenderEvents(AHost);
    TComboBoxFluentExample.CustomizeItem: RenderCustomizeItem(AHost);
    TComboBoxFluentExample.RuntimeHandle: RenderRuntimeHandle(AHost);
    TComboBoxFluentExample.Complete: RenderComplete(AHost);
  end;
end;

procedure TComboBoxFluentRunner.RenderBasic(const AHost: TLayout);
begin
  TRickUIBuilder
    .ComboBox
      .Placeholder('Escolha um tamanho')
        .Items(['Pequeno', 'Médio', 'Grande', 'Extra grande'])
          .Build(AHost);
end;

procedure TComboBoxFluentRunner.RenderInterface(const AHost: TLayout);
var
  LCombo: IRickUIBuilderComboBox;
begin
  LCombo := TRickUIBuilder.ComboBox;

  LCombo
    .Placeholder('Prioridade')
      .AddItem('Baixa')
      .AddItem('Média')
      .AddItem('Alta')
        .Build(AHost);
end;

procedure TComboBoxFluentRunner.RenderDisplayValue(const AHost: TLayout);
begin
  TRickUIBuilder
    .ComboBox
      .Placeholder('Moeda')
        .AddItem('Real brasileiro', 'BRL')
        .AddItem('Dólar americano', 'USD')
        .AddItem('Euro', 'EUR')
          .SelectedText('Real brasileiro')
            .Build(AHost);
end;

procedure TComboBoxFluentRunner.RenderStructuredList(const AHost: TLayout);
begin
  TRickUIBuilder
    .ComboBox
      .Size(360, 40)
        .Placeholder('Produto')
        .Column(FixedColumn)
        .Column(ProportionalColumn)
        .Column(AutoColumn)
          .AddStructuredItem('Notebook Core i7', 'NBK',
            ['001', 'Notebook Core i7', 'R$ 4.999'])
          .AddStructuredItem('Monitor 27', 'MON',
            ['002', 'Monitor 27 polegadas', 'R$ 1.899'])
          .AddStructuredItem('Teclado mecânico', 'TEC',
            ['003', 'Teclado mecânico', 'R$ 499'])
            .Build(AHost);
end;

procedure TComboBoxFluentRunner.RenderInitialSelection(const AHost: TLayout);
begin
  TRickUIBuilder
    .ComboBox
      .Position(16, 12)
      .Placeholder('Forma de pagamento')
        .Items(['Dinheiro', 'Cartão', 'PIX', 'Boleto'])
          .ItemIndex(2)
            .Build(AHost);

  TRickUIBuilder
    .ComboBox
      .Position(16, 72)
      .Placeholder('Departamento')
        .Items(['Financeiro', 'Comercial', 'Tecnologia', 'Operações'])
          .SelectedText('Tecnologia')
            .Build(AHost);
end;

procedure TComboBoxFluentRunner.RenderGeometryPopup(const AHost: TLayout);
begin
  TRickUIBuilder
    .ComboBox
      .Position(16, 16)
      .Size(280, 44)
        .Placeholder('Mês')
          .Items(['Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
            'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'])
            .ItemHeight(32)
            .PopupMaxHeight(160)
            .PopupWidthOffset(40)
              .Build(AHost);
end;

procedure TComboBoxFluentRunner.RenderDesktopAnchored(const AHost: TLayout);
begin
  TRickUIBuilder
    .ComboBox
      .Placeholder('Categoria')
        .Items(['Eletrônicos', 'Casa', 'Escritório', 'Livros', 'Games'])
          .StyleType(TRickUIBuilderComboBoxStyleType.Desktop)
          .PresentationMode(TRickUIBuilderComboBoxPresentationMode.Anchored)
            .Build(AHost);
end;

procedure TComboBoxFluentRunner.RenderFullWindowSearch(const AHost: TLayout);
begin
  TRickUIBuilder
    .ComboBox
      .Placeholder('Cidade')
        .Items(['Rio de Janeiro', 'Ribeirão Preto', 'Rio das Ostras',
          'São Paulo', 'Curitiba', 'Belo Horizonte', 'Florianópolis',
          'Porto Alegre', 'Salvador', 'Recife'])
          .StyleType(TRickUIBuilderComboBoxStyleType.Mobile)
          .PresentationMode(TRickUIBuilderComboBoxPresentationMode.Auto)
            .SearchPlaceholder('Pesquisar cidade...')
            .NoResultsText('Nenhuma cidade encontrada')
              .Build(AHost);
end;

class function TComboBoxFluentRunner.AdvancedConfig:
  TRickUIBuilderComboBoxConfig;
begin
  Result := TRickUIBuilderComboBoxConfig.Default;
  Result.Width := 340;
  Result.Height := 44;
  Result.PopupWidth := 380;
  Result.FontSize := 15;
  Result.FontStyle := [TFontStyle.fsBold];
  Result.TextAlign := TTextAlign.Leading;
  Result.Trimming := TTextTrimming.Character;
  Result.BackgroundColor := TAlphaColors.White;
  Result.BorderColor := TAlphaColors.Dodgerblue;
  Result.PlaceholderColor := TAlphaColors.Gray;
  Result.PopupColor := TAlphaColors.White;
  Result.HoverColor := $FFE8F3FF;
  Result.SelectedColor := $FFD7EBFF;
  Result.FocusColor := TAlphaColors.Dodgerblue;
end;

procedure TComboBoxFluentRunner.RenderCustomConfig(const AHost: TLayout);
begin
  TRickUIBuilder
    .ComboBox
      .CustomConfig(AdvancedConfig)
        .Placeholder('Cliente')
          .Items(['ACME Comércio e Distribuição Ltda.',
            'Empresa Brasileira de Tecnologia Aplicada S.A.',
            'Serviços Integrados do Atlântico'])
            .Build(AHost);
end;

procedure TComboBoxFluentRunner.RenderArrow(const AHost: TLayout);
begin
  TRickUIBuilder
    .ComboBox
      .Placeholder('Direção')
        .Items(['Norte', 'Sul', 'Leste', 'Oeste'])
          .ArrowColor(TAlphaColors.Dodgerblue)
          .ArrowSize(18)
          .ArrowPosition(TRickUIBuilderComboBoxArrowPosition.Left)
          .ArrowMargins(14, 4, 8, 4)
            .ClosedArrowPath(RICK_COMBOBOX_ARROW_DOWN_PATH)
            .OpenedArrowPath(RICK_COMBOBOX_ARROW_UP_PATH)
              .Build(AHost);
end;

procedure TComboBoxFluentRunner.RenderState(const AHost: TLayout);
begin
  TRickUIBuilder
    .ComboBox
      .Position(16, 12)
      .Placeholder('Nível de acesso')
        .Items(['Leitura', 'Operação', 'Administração'])
          .Enabled(True)
            .Build(AHost);

  TRickUIBuilder
    .ComboBox
      .Position(16, 72)
      .Placeholder('Plano indisponível')
        .Items(['Básico', 'Profissional', 'Enterprise'])
          .Enabled(False)
            .Build(AHost);
end;

procedure TComboBoxFluentRunner.CreateStatusLabel(const AHost: TLayout;
  const AText: string);
begin
  FStatusLabel := TLabel.Create(AHost);
  FStatusLabel.Parent := AHost;
  FStatusLabel.SetBounds(16, 68, 480, 28);
  FStatusLabel.Text := AText;
  FStatusLabel.HitTest := False;
end;

procedure TComboBoxFluentRunner.SetStatus(const AText: string);
begin
  if Assigned(FStatusLabel) then
    FStatusLabel.Text := AText;
end;

procedure TComboBoxFluentRunner.ComboChanged(ASender: TObject);
var
  LHandle: IRickUIBuilderComboBoxHandle;
begin
  if Supports(ASender, IRickUIBuilderComboBoxHandle, LHandle) then
    SetStatus('OnChange: ' + LHandle.SelectedText + ' / ' +
      LHandle.SelectedValue)
  else
    SetStatus('OnChange executado');
end;

procedure TComboBoxFluentRunner.ComboOpened(ASender: TObject);
begin
  SetStatus('OnOpen: lista aberta');
end;

procedure TComboBoxFluentRunner.ComboClosed(ASender: TObject);
begin
  SetStatus('OnClose: lista fechada');
end;

procedure TComboBoxFluentRunner.RenderEvents(const AHost: TLayout);
begin
  CreateStatusLabel(AHost, 'Abra a lista e selecione um status.');
  TRickUIBuilder
    .ComboBox
      .Placeholder('Status do processo')
        .AddItem('Pendente', 'PEN')
        .AddItem('Em análise', 'ANA')
        .AddItem('Aprovado', 'APR')
        .AddItem('Rejeitado', 'REJ')
          .OnOpen(ComboOpened)
          .OnClose(ComboClosed)
          .OnChange(ComboChanged)
            .Build(AHost);
end;

class procedure TComboBoxFluentRunner.ConfigureCustomBadge(
  ABadge: TRectangle);
begin
  ABadge.Align := TAlignLayout.Right;
  ABadge.Width := 72;
  ABadge.Margins.Right := 8;
  ABadge.Margins.Top := 6;
  ABadge.Margins.Bottom := 6;
  ABadge.Fill.Color := TAlphaColors.Dodgerblue;
  ABadge.Stroke.Kind := TBrushKind.None;
  ABadge.XRadius := 8;
  ABadge.YRadius := 8;
  ABadge.HitTest := False;
end;

class procedure TComboBoxFluentRunner.ConfigureCustomBadgeLabel(
  ALabel: TLabel; const AText: string);
begin
  ALabel.Align := TAlignLayout.Client;
  ALabel.Text := AText;
  ALabel.TextSettings.HorzAlign := TTextAlign.Center;
  ALabel.TextSettings.VertAlign := TTextAlign.Center;
  ALabel.TextSettings.FontColor := TAlphaColors.White;
  ALabel.StyledSettings := ALabel.StyledSettings - [TStyledSetting.FontColor];
  ALabel.HitTest := False;
end;

procedure TComboBoxFluentRunner.CustomizeItem(ASender: TObject;
  AIndex: Integer; const AItem: TRickUIBuilderComboBoxItem;
  AContainer: TControl);
var
  LBadge: TRectangle;
  LLabel: TLabel;
  LText: string;
begin
  if SameText(AItem.Value, 'NOVO') then
    LText := 'Novo'
  else
    LText := 'Ativo';
  LBadge := TRectangle.Create(AContainer);
  LBadge.Parent := AContainer;
  ConfigureCustomBadge(LBadge);
  LLabel := TLabel.Create(LBadge);
  LLabel.Parent := LBadge;
  ConfigureCustomBadgeLabel(LLabel, LText);
end;

procedure TComboBoxFluentRunner.RenderCustomizeItem(const AHost: TLayout);
begin
  TRickUIBuilder
    .ComboBox
      .Placeholder('Projeto')
        .StyleType(TRickUIBuilderComboBoxStyleType.Desktop)
        .PresentationMode(TRickUIBuilderComboBoxPresentationMode.Anchored)
          .AddItem('Portal do cliente', 'ATIVO')
          .AddItem('Aplicativo mobile', 'NOVO')
          .AddItem('Integração fiscal', 'ATIVO')
          .AddItem('Painel executivo', 'NOVO')
            .OnCustomizeItem(CustomizeItem)
              .Build(AHost);
end;

class procedure TComboBoxFluentRunner.ConfigureRuntimeHandle(
  const AHandle: IRickUIBuilderComboBoxHandle);
begin
  AHandle.Add('Leitor biométrico');
  AHandle.Add('Mesa digitalizadora', 'MESA');
  AHandle.AddRange(['Microfone USB', 'Webcam 4K']);
  AHandle.SelectIndex(0);
  AHandle.SelectText('Mesa digitalizadora');
  AHandle.SetArrowColor(TAlphaColors.Dodgerblue);
  AHandle.SetArrowSize(18, 12);
  AHandle.SetClosedArrowPath(RICK_COMBOBOX_ARROW_DOWN_PATH);
  AHandle.SetOpenedArrowPath(RICK_COMBOBOX_ARROW_UP_PATH);
  AHandle.Open;
  AHandle.Close;
  AHandle.Open;
end;

procedure TComboBoxFluentRunner.ShowRuntimeStatus(const AHost: TLayout;
  const AHandle: IRickUIBuilderComboBoxHandle);
var
  LAttached: string;
begin
  if AHandle.IsAttached then
    LAttached := 'sim'
  else
    LAttached := 'não';
  CreateStatusLabel(AHost, Format(
    'Attached: %s | Count: %d | Index: %d | Text: %s | Value: %s',
    [LAttached, AHandle.Count, AHandle.ItemIndex, AHandle.SelectedText,
      AHandle.SelectedValue]));
end;

procedure TComboBoxFluentRunner.RenderRuntimeHandle(const AHost: TLayout);
var
  LHandle: IRickUIBuilderComboBoxHandle;
begin
  LHandle := TRickUIBuilder
    .ComboBox
      .Position(16, 110)
      .Placeholder('Periférico')
        .AddItem('Impressora', 'IMP')
        .AddItem('Scanner', 'SCN')
          .BuildHandle(AHost);

  ConfigureRuntimeHandle(LHandle);
  ShowRuntimeStatus(AHost, LHandle);
end;

class function TComboBoxFluentRunner.FixedColumn:
  TRickUIBuilderComboBoxColumn;
begin
  Result := TRickUIBuilderComboBoxColumn.Create(
    TRickUIBuilderComboBoxColumnSizeMode.Fixed, 72);
  Result.SizeMode := TRickUIBuilderComboBoxColumnSizeMode.Fixed;
  Result.SizeValue := 72;
  Result.Alignment := TTextAlign.Leading;
  Result.Visible := True;
end;

class function TComboBoxFluentRunner.ProportionalColumn:
  TRickUIBuilderComboBoxColumn;
begin
  Result := TRickUIBuilderComboBoxColumn.Create(
    TRickUIBuilderComboBoxColumnSizeMode.Proportional, 1);
  Result.SizeMode := TRickUIBuilderComboBoxColumnSizeMode.Proportional;
  Result.SizeValue := 1;
  Result.Alignment := TTextAlign.Leading;
  Result.Visible := True;
end;

class function TComboBoxFluentRunner.AutoColumn:
  TRickUIBuilderComboBoxColumn;
begin
  Result := TRickUIBuilderComboBoxColumn.Create(
    TRickUIBuilderComboBoxColumnSizeMode.Auto, 0);
  Result.SizeMode := TRickUIBuilderComboBoxColumnSizeMode.Auto;
  Result.SizeValue := 0;
  Result.Alignment := TTextAlign.Trailing;
  Result.Visible := True;
end;

class function TComboBoxFluentRunner.CompleteConfig:
  TRickUIBuilderComboBoxConfig;
begin
  Result := TRickUIBuilderComboBoxConfig.Default;
  ConfigureCompleteGeometry(Result);
  ConfigureCompleteArrowTypography(Result);
  ConfigureCompleteColors(Result);
  ConfigureCompleteFullWindowGeometry(Result);
  ConfigureCompleteFullWindowColors(Result);
  ConfigureCompleteContentBehavior(Result);
end;

class procedure TComboBoxFluentRunner.ConfigureCompleteGeometry(
  var AConfig: TRickUIBuilderComboBoxConfig);
begin
  AConfig.Left := 16;
  AConfig.Top := 16;
  AConfig.Width := 360;
  AConfig.Height := 44;
  AConfig.ItemHeight := 40;
  AConfig.PopupWidth := 380;
  AConfig.PopupWidthOffset := 12;
  AConfig.PopupMaxHeight := 260;
  AConfig.CornerRadius := 10;
  AConfig.HorizontalPadding := 14;
end;

class procedure TComboBoxFluentRunner.ConfigureCompleteArrowTypography(
  var AConfig: TRickUIBuilderComboBoxConfig);
begin
  AConfig.ArrowSize := 18;
  AConfig.ArrowMarginLeft := 8;
  AConfig.ArrowMarginTop := 4;
  AConfig.ArrowMarginRight := 12;
  AConfig.ArrowMarginBottom := 4;
  AConfig.ArrowPosition := TRickUIBuilderComboBoxArrowPosition.Right;
  AConfig.FontSize := 14;
  AConfig.FontFamily := '';
  AConfig.FontStyle := [TFontStyle.fsBold];
  AConfig.TextAlign := TTextAlign.Leading;
  AConfig.Trimming := TTextTrimming.Character;
end;

class procedure TComboBoxFluentRunner.ConfigureCompleteColors(
  var AConfig: TRickUIBuilderComboBoxConfig);
begin
  AConfig.BackgroundColor := TAlphaColors.White;
  AConfig.EditBackgroundColor := TAlphaColors.White;
  AConfig.BorderColor := TAlphaColors.Gray;
  AConfig.TextColor := TAlphaColors.Black;
  AConfig.PlaceholderColor := TAlphaColors.Gray;
  AConfig.ArrowColor := TAlphaColors.Dodgerblue;
  AConfig.PopupColor := TAlphaColors.White;
  AConfig.HoverColor := $FFE8F3FF;
  AConfig.SelectedColor := $FFD7EBFF;
  AConfig.FocusColor := TAlphaColors.Dodgerblue;
  AConfig.DisabledOpacity := 0.50;
end;

class procedure TComboBoxFluentRunner.ConfigureCompleteFullWindowGeometry(
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

class procedure TComboBoxFluentRunner.ConfigureCompleteFullWindowColors(
  var AConfig: TRickUIBuilderComboBoxConfig);
begin
  AConfig.FullWindowBackgroundColor := TAlphaColors.White;
  AConfig.SearchFieldBackgroundColor := TAlphaColors.White;
  AConfig.SearchFieldBorderColor := TAlphaColors.Gray;
  AConfig.SearchTextColor := TAlphaColors.Black;
  AConfig.SearchIconColor := TAlphaColors.Dodgerblue;
  AConfig.NoResultsTextColor := TAlphaColors.Gray;
  AConfig.NoResultsIconColor := TAlphaColors.Gray;
end;

class procedure TComboBoxFluentRunner.ConfigureCompleteContentBehavior(
  var AConfig: TRickUIBuilderComboBoxConfig);
begin
  AConfig.SearchPlaceholder := 'Pesquisar produto...';
  AConfig.NoResultsText := 'Nenhum produto encontrado';
  AConfig.BackPath := RICK_COMBOBOX_BACK_PATH;
  AConfig.ClearPath := RICK_COMBOBOX_CLEAR_PATH;
  AConfig.NoResultsPath := RICK_COMBOBOX_NO_RESULTS_PATH;
  AConfig.Enabled := True;
  AConfig.RequestedStyleType := TRickUIBuilderComboBoxStyleType.Custom;
  AConfig.EffectiveStyleType := TRickUIBuilderComboBoxStyleType.Custom;
  AConfig.PresentationMode := TRickUIBuilderComboBoxPresentationMode.Anchored;
  AConfig.ClosedArrowPath := RICK_COMBOBOX_ARROW_DOWN_PATH;
  AConfig.OpenedArrowPath := RICK_COMBOBOX_ARROW_UP_PATH;
  AConfig.SearchTimeout := 900;
end;

class procedure TComboBoxFluentRunner.ConfigureCompleteData(
  const ACombo: IRickUIBuilderComboBox);
begin
  ACombo
    .Items(['Adaptador USB-C', 'Cabo de rede'])
      .AddItem('Fonte universal')
      .AddItem('Estação docking', 'DOCK')
      .AddStructuredItem('Servidor compacto', 'SRV',
        ['900', 'Servidor compacto', 'R$ 8.499'])
        .Column(FixedColumn)
        .Column(ProportionalColumn)
        .Column(AutoColumn);
end;

class procedure TComboBoxFluentRunner.ConfigureCompletePresentation(
  const ACombo: IRickUIBuilderComboBox);
begin
  ACombo
    .Position(16, 16)
    .Size(360, 44)
      .Placeholder('Catálogo completo')
        .ItemIndex(1)
        .SelectedText('Servidor compacto')
          .StyleType(TRickUIBuilderComboBoxStyleType.Custom)
          .PresentationMode(TRickUIBuilderComboBoxPresentationMode.Anchored)
            .ItemHeight(40)
            .PopupMaxHeight(260)
            .PopupWidthOffset(12)
              .ArrowColor(TAlphaColors.Dodgerblue)
              .ArrowSize(18)
              .ArrowPosition(TRickUIBuilderComboBoxArrowPosition.Right)
              .ArrowMargins(8, 4, 12, 4)
                .Enabled(True);
end;

procedure TComboBoxFluentRunner.ConfigureCompleteEvents(
  const ACombo: IRickUIBuilderComboBox);
begin
  ACombo
    .ClosedArrowPath(RICK_COMBOBOX_ARROW_DOWN_PATH)
    .OpenedArrowPath(RICK_COMBOBOX_ARROW_UP_PATH)
      .SearchPlaceholder('Pesquisar produto...')
      .NoResultsText('Nenhum produto encontrado')
        .BackPath(RICK_COMBOBOX_BACK_PATH)
        .ClearPath(RICK_COMBOBOX_CLEAR_PATH)
        .NoResultsPath(RICK_COMBOBOX_NO_RESULTS_PATH)
          .OnChange(ComboChanged)
          .OnOpen(ComboOpened)
          .OnClose(ComboClosed)
          .OnCustomizeItem(CustomizeItem);
end;

procedure TComboBoxFluentRunner.RenderComplete(const AHost: TLayout);
var
  LCombo: IRickUIBuilderComboBox;
  LConfig: TRickUIBuilderComboBoxConfig;
  LHandle: IRickUIBuilderComboBoxHandle;
begin
  LConfig := CompleteConfig;
  CreateStatusLabel(AHost, 'Configuração completa pronta para interação.');
  LCombo := TRickUIBuilder.ComboBox;
  LCombo.CustomConfig(LConfig);
  ConfigureCompleteData(LCombo);
  ConfigureCompletePresentation(LCombo);
  ConfigureCompleteEvents(LCombo);
  LHandle := LCombo.BuildHandle(AHost);
  SetStatus(Format('Itens: %d | Selecionado: %s | Value: %s',
    [LHandle.Count, LHandle.SelectedText, LHandle.SelectedValue]));
end;

end.
