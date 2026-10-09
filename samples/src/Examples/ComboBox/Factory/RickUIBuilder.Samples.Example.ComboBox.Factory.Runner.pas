{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Example.ComboBox.Factory.Runner                       }
{                                                                              }
{ Executa os quinze exemplos ComboBox - Factory com dados reais, seleção,      }
{ presentation, callbacks, customização de itens e handle runtime.             }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Demonstrar TRickUIBuilderFactory.CreateComboBox usando contratos públicos.  }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Materializa os três modelos de dados, colunas, seleção, configuração visual,}
{  Anchored, FullWindow/pesquisa, callbacks e operações do handle.             }
{                                                                              }
{  Dependências internas                                                       }
{  ---------------------                                                       }
{  App.Types fornece o enum; Rick.UIBuilder.Factory/Interfaces/Types fornecem  }
{  os contratos públicos executados pelos exemplos.                            }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  A Page chama Reset antes de ClearResult e depois Render para o item ativo.  }
{                                                                              }
{  Ownership / lifetime                                                        }
{  --------------------                                                        }
{  ResultHost é Owner/Parent do principal; FStatusLabel é non-owning;          }
{  controles de OnCustomizeItem usam AContainer como Owner/Parent; o Runner    }
{  vive durante toda a página para callbacks of object.                        }
{                                                                              }
{  Restrições                                                                  }
{  ----------                                                                  }
{  Não usa classes concretas internas e não simula capacidades fora da API.    }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Manter valores e comportamento sincronizados com Factory.Content.           }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.Example.ComboBox.Factory.Runner;

interface

uses
  FMX.Controls,
  FMX.Layouts,
  FMX.Objects,
  FMX.StdCtrls,
  Rick.UIBuilder.Interfaces,
  Rick.UIBuilder.Types,
  Rick.UIBuilder.Factory,
  RickUIBuilder.Samples.App.Types;

type
  TComboBoxFactoryRunner = class sealed
  strict private
    FStatusLabel: TLabel;
    procedure RenderData(const AExample: TComboBoxFactoryExample; const AHost: TLayout);
    procedure RenderVisual(const AExample: TComboBoxFactoryExample; const AHost: TLayout);
    procedure RenderPresentation(const AExample: TComboBoxFactoryExample; const AHost: TLayout);
    procedure RenderInteraction(const AExample: TComboBoxFactoryExample; const AHost: TLayout);
    procedure RenderBasic(const AHost: TLayout);
    procedure RenderDisplayValue(const AHost: TLayout);
    procedure RenderStructuredList(const AHost: TLayout);
    procedure RenderInitialSelection(const AHost: TLayout);
    procedure RenderIndexSelection(const AHost: TLayout);
    procedure RenderTextSelection(const AHost: TLayout);
    procedure RenderGeometryShape(const AHost: TLayout);
    procedure RenderTypographyText(const AHost: TLayout);
    procedure RenderColors(const AHost: TLayout);
    procedure RenderArrow(const AHost: TLayout);
    procedure RenderState(const AHost: TLayout);
    procedure RenderDesktopAnchored(const AHost: TLayout);
    procedure RenderFullWindowSearch(const AHost: TLayout);
    procedure RenderEvents(const AHost: TLayout);
    procedure RenderCustomizeItem(const AHost: TLayout);
    procedure RenderRuntimeHandle(const AHost: TLayout);
    procedure RenderComplete(const AHost: TLayout);
    procedure ComboChanged(ASender: TObject);
    procedure ComboOpened(ASender: TObject);
    procedure ComboClosed(ASender: TObject);
    procedure CustomizeItem(ASender: TObject; AIndex: Integer;
      const AItem: TRickUIBuilderComboBoxItem; AContainer: TControl);
    procedure SetStatus(const AText: string);
    procedure CreateStatusLabel(const AHost: TLayout; const AText: string);
    procedure ConfigureCompleteOptions(var AOptions: TRickUIBuilderComboBoxFactoryOptions);
    class function TextItems(const AValues: array of string): TArray<TRickUIBuilderComboBoxItem>; static;
    class function BasicOptions(const APlaceholder: string;
      const AItems: TArray<TRickUIBuilderComboBoxItem>): TRickUIBuilderComboBoxFactoryOptions; static;
    class function FixedColumn: TRickUIBuilderComboBoxColumn; static;
    class function ProportionalColumn: TRickUIBuilderComboBoxColumn; static;
    class function AutoColumn: TRickUIBuilderComboBoxColumn; static;
    class procedure ConfigureCustomBadge(ABadge: TRectangle); static;
    class procedure ConfigureCustomBadgeLabel(ALabel: TLabel; const AText: string); static;
    class procedure ConfigureRuntimeHandle(const AHandle: IRickUIBuilderComboBoxHandle); static;
    procedure ShowRuntimeStatus(const AHost: TLayout; const AHandle: IRickUIBuilderComboBoxHandle);
    class function CompleteConfig: TRickUIBuilderComboBoxConfig; static;
    class procedure ConfigureCompleteGeometry(var AConfig: TRickUIBuilderComboBoxConfig); static;
    class procedure ConfigureCompleteArrowTypography(var AConfig: TRickUIBuilderComboBoxConfig); static;
    class procedure ConfigureCompleteColors(var AConfig: TRickUIBuilderComboBoxConfig); static;
    class procedure ConfigureCompleteFullWindowGeometry(var AConfig: TRickUIBuilderComboBoxConfig); static;
    class procedure ConfigureCompleteFullWindowColors(var AConfig: TRickUIBuilderComboBoxConfig); static;
    class procedure ConfigureCompleteContentBehavior(var AConfig: TRickUIBuilderComboBoxConfig); static;
  public
    procedure Reset;
    procedure Render(const AExample: TComboBoxFactoryExample; const AHost: TLayout);
  end;

implementation

uses
  System.SysUtils,
  System.UITypes,
  FMX.Graphics,
  FMX.Types;

procedure TComboBoxFactoryRunner.Reset;
begin
  FStatusLabel := nil;
end;

class function TComboBoxFactoryRunner.TextItems(
  const AValues: array of string): TArray<TRickUIBuilderComboBoxItem>;
var
  LIndex: Integer;
begin
  SetLength(Result, Length(AValues));
  for LIndex := Low(AValues) to High(AValues) do
    Result[LIndex] := TRickUIBuilderComboBoxItem.Create(AValues[LIndex]);
end;

class function TComboBoxFactoryRunner.BasicOptions(const APlaceholder: string;
  const AItems: TArray<TRickUIBuilderComboBoxItem>): TRickUIBuilderComboBoxFactoryOptions;
begin
  Result := TRickUIBuilderComboBoxFactoryOptions.Default;
  Result.Placeholder := APlaceholder;
  Result.Items := AItems;
end;

procedure TComboBoxFactoryRunner.Render(const AExample: TComboBoxFactoryExample;
  const AHost: TLayout);
begin
  if AExample <= TComboBoxFactoryExample.InitialSelection then
    RenderData(AExample, AHost)
  else if AExample <= TComboBoxFactoryExample.State then
    RenderVisual(AExample, AHost)
  else if AExample <= TComboBoxFactoryExample.FullWindowSearch then
    RenderPresentation(AExample, AHost)
  else
    RenderInteraction(AExample, AHost);
end;

procedure TComboBoxFactoryRunner.RenderData(const AExample: TComboBoxFactoryExample;
  const AHost: TLayout);
begin
  case AExample of
    TComboBoxFactoryExample.Basic: RenderBasic(AHost);
    TComboBoxFactoryExample.DisplayValue: RenderDisplayValue(AHost);
    TComboBoxFactoryExample.StructuredList: RenderStructuredList(AHost);
    TComboBoxFactoryExample.InitialSelection: RenderInitialSelection(AHost);
  end;
end;

procedure TComboBoxFactoryRunner.RenderVisual(const AExample: TComboBoxFactoryExample;
  const AHost: TLayout);
begin
  case AExample of
    TComboBoxFactoryExample.GeometryShape: RenderGeometryShape(AHost);
    TComboBoxFactoryExample.TypographyText: RenderTypographyText(AHost);
    TComboBoxFactoryExample.Colors: RenderColors(AHost);
    TComboBoxFactoryExample.Arrow: RenderArrow(AHost);
    TComboBoxFactoryExample.State: RenderState(AHost);
  end;
end;

procedure TComboBoxFactoryRunner.RenderPresentation(
  const AExample: TComboBoxFactoryExample; const AHost: TLayout);
begin
  case AExample of
    TComboBoxFactoryExample.DesktopAnchored: RenderDesktopAnchored(AHost);
    TComboBoxFactoryExample.FullWindowSearch: RenderFullWindowSearch(AHost);
  end;
end;

procedure TComboBoxFactoryRunner.RenderInteraction(
  const AExample: TComboBoxFactoryExample; const AHost: TLayout);
begin
  case AExample of
    TComboBoxFactoryExample.Events: RenderEvents(AHost);
    TComboBoxFactoryExample.CustomizeItem: RenderCustomizeItem(AHost);
    TComboBoxFactoryExample.RuntimeHandle: RenderRuntimeHandle(AHost);
    TComboBoxFactoryExample.Complete: RenderComplete(AHost);
  end;
end;

procedure TComboBoxFactoryRunner.RenderBasic(const AHost: TLayout);
var
  LConfig: TRickUIBuilderComboBoxConfig;
  LOptions: TRickUIBuilderComboBoxFactoryOptions;
  LHandle: IRickUIBuilderComboBoxHandle;
begin
  LConfig := TRickUIBuilderComboBoxConfig.Default;
  LOptions := BasicOptions('Escolha um tamanho',
    TextItems(['Pequeno', 'Médio', 'Grande', 'Extra grande']));
  TRickUIBuilderFactory.CreateComboBox(AHost, AHost, LConfig, LOptions, LHandle);
end;

procedure TComboBoxFactoryRunner.RenderDisplayValue(const AHost: TLayout);
var
  LConfig: TRickUIBuilderComboBoxConfig;
  LOptions: TRickUIBuilderComboBoxFactoryOptions;
  LHandle: IRickUIBuilderComboBoxHandle;
begin
  LConfig := TRickUIBuilderComboBoxConfig.Default;
  LOptions := TRickUIBuilderComboBoxFactoryOptions.Default;
  LOptions.Placeholder := 'Moeda';
  LOptions.Items := [
    TRickUIBuilderComboBoxItem.Create('Real brasileiro', 'BRL'),
    TRickUIBuilderComboBoxItem.Create('Dólar americano', 'USD'),
    TRickUIBuilderComboBoxItem.Create('Euro', 'EUR')
  ];
  LOptions.SelectionMode := TRickUIBuilderComboBoxInitialSelectionMode.Text;
  LOptions.SelectedText := 'Real brasileiro';
  TRickUIBuilderFactory.CreateComboBox(AHost, AHost, LConfig, LOptions, LHandle);
end;

class function TComboBoxFactoryRunner.FixedColumn: TRickUIBuilderComboBoxColumn;
begin
  Result := TRickUIBuilderComboBoxColumn.Create(
    TRickUIBuilderComboBoxColumnSizeMode.Fixed, 72);
  Result.SizeMode := TRickUIBuilderComboBoxColumnSizeMode.Fixed;
  Result.SizeValue := 72;
  Result.Alignment := TTextAlign.Leading;
  Result.Visible := True;
end;

class function TComboBoxFactoryRunner.ProportionalColumn: TRickUIBuilderComboBoxColumn;
begin
  Result := TRickUIBuilderComboBoxColumn.Create(
    TRickUIBuilderComboBoxColumnSizeMode.Proportional, 1);
  Result.SizeMode := TRickUIBuilderComboBoxColumnSizeMode.Proportional;
  Result.SizeValue := 1;
  Result.Alignment := TTextAlign.Leading;
  Result.Visible := True;
end;

class function TComboBoxFactoryRunner.AutoColumn: TRickUIBuilderComboBoxColumn;
begin
  Result := TRickUIBuilderComboBoxColumn.Create(
    TRickUIBuilderComboBoxColumnSizeMode.Auto, 0);
  Result.SizeMode := TRickUIBuilderComboBoxColumnSizeMode.Auto;
  Result.SizeValue := 0;
  Result.Alignment := TTextAlign.Trailing;
  Result.Visible := True;
end;

procedure TComboBoxFactoryRunner.RenderStructuredList(const AHost: TLayout);
var
  LConfig: TRickUIBuilderComboBoxConfig;
  LOptions: TRickUIBuilderComboBoxFactoryOptions;
  LHandle: IRickUIBuilderComboBoxHandle;
begin
  LConfig := TRickUIBuilderComboBoxConfig.Default;
  LConfig.Width := 360;
  LOptions := BasicOptions('Produto', nil);
  LOptions.Columns := [FixedColumn, ProportionalColumn, AutoColumn];
  LOptions.Items := [
    TRickUIBuilderComboBoxItem.Structured(
      'Notebook Core i7', 'NBK',
      ['001', 'Notebook Core i7', 'R$ 4.999']),
    TRickUIBuilderComboBoxItem.Structured(
      'Monitor 27', 'MON',
      ['002', 'Monitor 27 polegadas', 'R$ 1.899'])
  ];
  TRickUIBuilderFactory.CreateComboBox(AHost, AHost, LConfig, LOptions, LHandle);
end;

procedure TComboBoxFactoryRunner.RenderInitialSelection(const AHost: TLayout);
begin
  RenderIndexSelection(AHost);
  RenderTextSelection(AHost);
end;

procedure TComboBoxFactoryRunner.RenderIndexSelection(const AHost: TLayout);
var
  LConfig: TRickUIBuilderComboBoxConfig;
  LOptions: TRickUIBuilderComboBoxFactoryOptions;
  LHandle: IRickUIBuilderComboBoxHandle;
begin
  LConfig := TRickUIBuilderComboBoxConfig.Default;
  LConfig.Top := 12;
  LOptions := BasicOptions('Pagamento',
    TextItems(['Dinheiro', 'Cartão', 'PIX']));
  LOptions.SelectionMode := TRickUIBuilderComboBoxInitialSelectionMode.Index;
  LOptions.ItemIndex := 2;
  TRickUIBuilderFactory.CreateComboBox(AHost, AHost, LConfig, LOptions, LHandle);
end;

procedure TComboBoxFactoryRunner.RenderTextSelection(const AHost: TLayout);
var
  LConfig: TRickUIBuilderComboBoxConfig;
  LOptions: TRickUIBuilderComboBoxFactoryOptions;
  LHandle: IRickUIBuilderComboBoxHandle;
begin
  LConfig := TRickUIBuilderComboBoxConfig.Default;
  LConfig.Top := 72;
  LOptions := BasicOptions('Departamento',
    TextItems(['Financeiro', 'Tecnologia', 'Operações']));
  LOptions.SelectionMode := TRickUIBuilderComboBoxInitialSelectionMode.Text;
  LOptions.SelectedText := 'Tecnologia';
  TRickUIBuilderFactory.CreateComboBox(AHost, AHost, LConfig, LOptions, LHandle);
end;

procedure TComboBoxFactoryRunner.RenderGeometryShape(const AHost: TLayout);
var
  LConfig: TRickUIBuilderComboBoxConfig;
  LOptions: TRickUIBuilderComboBoxFactoryOptions;
  LHandle: IRickUIBuilderComboBoxHandle;
begin
  LConfig := TRickUIBuilderComboBoxConfig.Default;
  LConfig.Left := 20;
  LConfig.Top := 20;
  LConfig.Width := 280;
  LConfig.Height := 44;
  LConfig.CornerRadius := 10;
  LConfig.HorizontalPadding := 16;
  LOptions := BasicOptions('Mês', TextItems(['Janeiro', 'Fevereiro']));
  TRickUIBuilderFactory.CreateComboBox(AHost, AHost, LConfig, LOptions, LHandle);
end;

procedure TComboBoxFactoryRunner.RenderTypographyText(const AHost: TLayout);
var
  LConfig: TRickUIBuilderComboBoxConfig;
  LOptions: TRickUIBuilderComboBoxFactoryOptions;
  LHandle: IRickUIBuilderComboBoxHandle;
begin
  LConfig := TRickUIBuilderComboBoxConfig.Default;
  LConfig.Width := 300;
  LConfig.FontSize := 16;
  LConfig.FontFamily := 'Arial';
  LConfig.FontStyle := [TFontStyle.fsBold];
  LConfig.TextAlign := TTextAlign.Center;
  LConfig.Trimming := TTextTrimming.Character;
  LOptions := BasicOptions('Cliente', TextItems(['ACME Comércio e Distribuição Ltda.',
    'Empresa Brasileira de Tecnologia Aplicada S.A.']));
  TRickUIBuilderFactory.CreateComboBox(AHost, AHost, LConfig, LOptions, LHandle);
end;

procedure TComboBoxFactoryRunner.RenderColors(const AHost: TLayout);
var
  LConfig: TRickUIBuilderComboBoxConfig;
  LOptions: TRickUIBuilderComboBoxFactoryOptions;
  LHandle: IRickUIBuilderComboBoxHandle;
begin
  LConfig := TRickUIBuilderComboBoxConfig.Default;
  LConfig.BackgroundColor := TAlphaColors.Dodgerblue;
  LConfig.BorderColor := TAlphaColors.Gray;
  LConfig.TextColor := TAlphaColors.White;
  LConfig.ArrowColor := TAlphaColors.White;
  LConfig.PopupColor := $FF163A5F;
  LConfig.HoverColor := $FF245B8F;
  LConfig.SelectedColor := $FF2F80C9;
  LOptions := BasicOptions('Cor',
    TextItems(['Azul', 'Branco', 'Cinza', 'Verde']));
  LOptions.SelectionMode := TRickUIBuilderComboBoxInitialSelectionMode.Index;
  LOptions.ItemIndex := 1;
  TRickUIBuilderFactory.CreateComboBox(AHost, AHost, LConfig, LOptions, LHandle);
end;

procedure TComboBoxFactoryRunner.RenderArrow(const AHost: TLayout);
var
  LConfig: TRickUIBuilderComboBoxConfig;
  LOptions: TRickUIBuilderComboBoxFactoryOptions;
  LHandle: IRickUIBuilderComboBoxHandle;
begin
  LConfig := TRickUIBuilderComboBoxConfig.Default;
  LConfig.ArrowSize := 18;
  LConfig.ArrowMarginLeft := 14;
  LConfig.ArrowMarginTop := 4;
  LConfig.ArrowMarginRight := 10;
  LConfig.ArrowMarginBottom := 4;
  LConfig.ArrowPosition := TRickUIBuilderComboBoxArrowPosition.Left;
  LConfig.ClosedArrowPath := RICK_COMBOBOX_ARROW_DOWN_PATH;
  LConfig.OpenedArrowPath := RICK_COMBOBOX_ARROW_UP_PATH;
  LOptions := BasicOptions('Direção', TextItems(['Norte', 'Sul', 'Leste']));
  TRickUIBuilderFactory.CreateComboBox(AHost, AHost, LConfig, LOptions, LHandle);
end;

procedure TComboBoxFactoryRunner.RenderState(const AHost: TLayout);
var
  LConfig: TRickUIBuilderComboBoxConfig;
  LOptions: TRickUIBuilderComboBoxFactoryOptions;
  LHandle: IRickUIBuilderComboBoxHandle;
begin
  LConfig := TRickUIBuilderComboBoxConfig.Default;
  LConfig.Enabled := False;
  LConfig.DisabledOpacity := 0.45;
  LOptions := BasicOptions('Plano indisponível',
    TextItems(['Básico', 'Profissional']));
  TRickUIBuilderFactory.CreateComboBox(AHost, AHost, LConfig, LOptions, LHandle);
end;

procedure TComboBoxFactoryRunner.RenderDesktopAnchored(const AHost: TLayout);
var
  LConfig: TRickUIBuilderComboBoxConfig;
  LOptions: TRickUIBuilderComboBoxFactoryOptions;
  LHandle: IRickUIBuilderComboBoxHandle;
begin
  LConfig := TRickUIBuilderComboBoxConfig.Default;
  LConfig.RequestedStyleType := TRickUIBuilderComboBoxStyleType.Desktop;
  LConfig.PresentationMode := TRickUIBuilderComboBoxPresentationMode.Anchored;
  LOptions := BasicOptions('Categoria',
    TextItems(['Eletrônicos', 'Casa', 'Escritório']));
  TRickUIBuilderFactory.CreateComboBox(AHost, AHost, LConfig, LOptions, LHandle);
end;

procedure TComboBoxFactoryRunner.RenderFullWindowSearch(const AHost: TLayout);
var
  LConfig: TRickUIBuilderComboBoxConfig;
  LOptions: TRickUIBuilderComboBoxFactoryOptions;
  LHandle: IRickUIBuilderComboBoxHandle;
begin
  LConfig := TRickUIBuilderComboBoxConfig.Default;
  LConfig.RequestedStyleType := TRickUIBuilderComboBoxStyleType.Mobile;
  LConfig.PresentationMode := TRickUIBuilderComboBoxPresentationMode.Auto;
  LConfig.SearchPlaceholder := 'Pesquisar cidade...';
  LConfig.NoResultsText := 'Nenhuma cidade encontrada';
  LOptions := BasicOptions('Cidade', TextItems(['Rio de Janeiro', 'São Paulo',
    'Curitiba', 'Belo Horizonte', 'Recife']));
  TRickUIBuilderFactory.CreateComboBox(AHost, AHost, LConfig, LOptions, LHandle);
end;

procedure TComboBoxFactoryRunner.CreateStatusLabel(const AHost: TLayout; const AText: string);
begin
  FStatusLabel := TLabel.Create(AHost);
  FStatusLabel.Parent := AHost;
  FStatusLabel.SetBounds(16, 68, 480, 28);
  FStatusLabel.Text := AText;
  FStatusLabel.HitTest := False;
end;

procedure TComboBoxFactoryRunner.SetStatus(const AText: string);
begin
  if Assigned(FStatusLabel) then
    FStatusLabel.Text := AText;
end;

procedure TComboBoxFactoryRunner.ComboChanged(ASender: TObject);
var
  LHandle: IRickUIBuilderComboBoxHandle;
begin
  if Supports(ASender, IRickUIBuilderComboBoxHandle, LHandle) then
    SetStatus('OnChange: ' + LHandle.SelectedText + ' / ' + LHandle.SelectedValue)
  else
    SetStatus('OnChange executado');
end;

procedure TComboBoxFactoryRunner.ComboOpened(ASender: TObject);
begin
  SetStatus('OnOpen: lista aberta');
end;

procedure TComboBoxFactoryRunner.ComboClosed(ASender: TObject);
begin
  SetStatus('OnClose: lista fechada');
end;

procedure TComboBoxFactoryRunner.RenderEvents(const AHost: TLayout);
var
  LConfig: TRickUIBuilderComboBoxConfig;
  LOptions: TRickUIBuilderComboBoxFactoryOptions;
  LHandle: IRickUIBuilderComboBoxHandle;
begin
  CreateStatusLabel(AHost, 'Abra a lista e selecione um status.');
  LConfig := TRickUIBuilderComboBoxConfig.Default;
  LOptions := BasicOptions('Status do processo', [
    TRickUIBuilderComboBoxItem.Create('Pendente', 'PEN'),
    TRickUIBuilderComboBoxItem.Create('Aprovado', 'APR')]);
  LOptions.OnOpen := ComboOpened;
  LOptions.OnClose := ComboClosed;
  LOptions.OnChange := ComboChanged;
  TRickUIBuilderFactory.CreateComboBox(AHost, AHost, LConfig, LOptions, LHandle);
end;

class procedure TComboBoxFactoryRunner.ConfigureCustomBadge(ABadge: TRectangle);
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

class procedure TComboBoxFactoryRunner.ConfigureCustomBadgeLabel(ALabel: TLabel; const AText: string);
begin
  ALabel.Align := TAlignLayout.Client;
  ALabel.Text := AText;
  ALabel.TextSettings.HorzAlign := TTextAlign.Center;
  ALabel.TextSettings.VertAlign := TTextAlign.Center;
  ALabel.TextSettings.FontColor := TAlphaColors.White;
  ALabel.StyledSettings := ALabel.StyledSettings - [TStyledSetting.FontColor];
  ALabel.HitTest := False;
end;

procedure TComboBoxFactoryRunner.CustomizeItem(ASender: TObject; AIndex: Integer;
  const AItem: TRickUIBuilderComboBoxItem; AContainer: TControl);
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

procedure TComboBoxFactoryRunner.RenderCustomizeItem(const AHost: TLayout);
var
  LConfig: TRickUIBuilderComboBoxConfig;
  LOptions: TRickUIBuilderComboBoxFactoryOptions;
  LHandle: IRickUIBuilderComboBoxHandle;
begin
  LConfig := TRickUIBuilderComboBoxConfig.Default;
  LConfig.RequestedStyleType := TRickUIBuilderComboBoxStyleType.Desktop;
  LConfig.PresentationMode := TRickUIBuilderComboBoxPresentationMode.Anchored;
  LOptions := BasicOptions('Projeto', [
    TRickUIBuilderComboBoxItem.Create('Portal do cliente', 'ATIVO'),
    TRickUIBuilderComboBoxItem.Create('Aplicativo mobile', 'NOVO')]);
  LOptions.OnCustomizeItem := CustomizeItem;
  TRickUIBuilderFactory.CreateComboBox(AHost, AHost, LConfig, LOptions, LHandle);
end;

class procedure TComboBoxFactoryRunner.ConfigureRuntimeHandle(const AHandle: IRickUIBuilderComboBoxHandle);
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

procedure TComboBoxFactoryRunner.ShowRuntimeStatus(const AHost: TLayout;
  const AHandle: IRickUIBuilderComboBoxHandle);
var
  LAttached: string;
begin
  if AHandle.IsAttached then
    LAttached := 'sim'
  else
    LAttached := 'não';
  CreateStatusLabel(AHost, Format('Attached: %s | Count: %d | Index: %d | Text: %s | Value: %s',
    [LAttached, AHandle.Count, AHandle.ItemIndex, AHandle.SelectedText, AHandle.SelectedValue]));
end;

procedure TComboBoxFactoryRunner.RenderRuntimeHandle(const AHost: TLayout);
var
  LConfig: TRickUIBuilderComboBoxConfig;
  LOptions: TRickUIBuilderComboBoxFactoryOptions;
  LHandle: IRickUIBuilderComboBoxHandle;
begin
  LConfig := TRickUIBuilderComboBoxConfig.Default;
  LConfig.Top := 110;
  LOptions := BasicOptions('Periférico', [
    TRickUIBuilderComboBoxItem.Create('Impressora', 'IMP'),
    TRickUIBuilderComboBoxItem.Create('Scanner', 'SCN')
  ]);
  TRickUIBuilderFactory.CreateComboBox(AHost, AHost, LConfig, LOptions, LHandle);
  ConfigureRuntimeHandle(LHandle);
  ShowRuntimeStatus(AHost, LHandle);
end;

class function TComboBoxFactoryRunner.CompleteConfig: TRickUIBuilderComboBoxConfig;
begin
  Result := TRickUIBuilderComboBoxConfig.Default;
  ConfigureCompleteGeometry(Result);
  ConfigureCompleteArrowTypography(Result);
  ConfigureCompleteColors(Result);
  ConfigureCompleteFullWindowGeometry(Result);
  ConfigureCompleteFullWindowColors(Result);
  ConfigureCompleteContentBehavior(Result);
end;

class procedure TComboBoxFactoryRunner.ConfigureCompleteGeometry(var AConfig: TRickUIBuilderComboBoxConfig);
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

class procedure TComboBoxFactoryRunner.ConfigureCompleteArrowTypography(var AConfig: TRickUIBuilderComboBoxConfig);
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

class procedure TComboBoxFactoryRunner.ConfigureCompleteColors(var AConfig: TRickUIBuilderComboBoxConfig);
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
  AConfig.SearchTimeout := 900;
end;

class procedure TComboBoxFactoryRunner.ConfigureCompleteFullWindowGeometry(var AConfig: TRickUIBuilderComboBoxConfig);
begin
  AConfig.FullWindowCornerRadius := 24;
  AConfig.FullWindowPadding := 16;
  AConfig.SearchHeaderHeight := 84;
  AConfig.SearchFieldHeight := 52;
  AConfig.SearchFieldCornerRadius := 14;
  AConfig.SearchIconSize := 22;
  AConfig.NoResultsIconSize := 60;
end;

class procedure TComboBoxFactoryRunner.ConfigureCompleteFullWindowColors(var AConfig: TRickUIBuilderComboBoxConfig);
begin
  AConfig.FullWindowBackgroundColor := TAlphaColors.White;
  AConfig.SearchFieldBackgroundColor := TAlphaColors.White;
  AConfig.SearchFieldBorderColor := TAlphaColors.Gray;
  AConfig.SearchTextColor := TAlphaColors.Black;
  AConfig.SearchIconColor := TAlphaColors.Dodgerblue;
  AConfig.NoResultsTextColor := TAlphaColors.Gray;
  AConfig.NoResultsIconColor := TAlphaColors.Gray;
end;

class procedure TComboBoxFactoryRunner.ConfigureCompleteContentBehavior(var AConfig: TRickUIBuilderComboBoxConfig);
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
end;

procedure TComboBoxFactoryRunner.ConfigureCompleteOptions(var AOptions: TRickUIBuilderComboBoxFactoryOptions);
begin
  AOptions.Items := [
    TRickUIBuilderComboBoxItem.Structured(
      'Servidor compacto', 'SRV',
      ['900', 'Servidor compacto', 'R$ 8.499'])
  ];
  AOptions.Columns := [FixedColumn, ProportionalColumn, AutoColumn];
  AOptions.Placeholder := 'Catálogo completo';
  AOptions.SelectionMode := TRickUIBuilderComboBoxInitialSelectionMode.Text;
  AOptions.ItemIndex := 1;
  AOptions.SelectedText := 'Servidor compacto';
  AOptions.OnChange := nil;
  AOptions.OnOpen := nil;
  AOptions.OnClose := nil;
  AOptions.OnCustomizeItem := nil;
  AOptions.PreserveHeight := True;
  AOptions.PreserveItemHeight := True;
  AOptions.PreserveHorizontalPadding := True;
  AOptions.PreserveArrowSize := True;
end;

procedure TComboBoxFactoryRunner.RenderComplete(const AHost: TLayout);
var
  LConfig: TRickUIBuilderComboBoxConfig;
  LOptions: TRickUIBuilderComboBoxFactoryOptions;
  LHandle: IRickUIBuilderComboBoxHandle;
begin
  LConfig := CompleteConfig;
  LOptions := TRickUIBuilderComboBoxFactoryOptions.Default;
  ConfigureCompleteOptions(LOptions);
  CreateStatusLabel(AHost, 'Configuração completa pronta para interação.');
  TRickUIBuilderFactory.CreateComboBox(AHost, AHost, LConfig, LOptions, LHandle);
  SetStatus(Format('Itens: %d | Selecionado: %s | Value: %s',
    [LHandle.Count, LHandle.SelectedText, LHandle.SelectedValue]));
end;

end.
