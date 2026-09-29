unit RickUIBuilderSample.Edit;
{$SCOPEDENUMS ON}

interface

uses
  System.Classes,
  System.UITypes,

  FMX.Types,
  FMX.Controls,
  FMX.Edit,
  FMX.StdCtrls,

  Rick.UIBuilder.Interfaces,
  Rick.UIBuilder.Types;

type
  TRickUIBuilderEditShowcase = class(TComponent)
  strict private
    FParent: TFmxObject;
    FCopyValid: IRickUIBuilderEditHandle;
    FCopyInvalid: IRickUIBuilderEditHandle;
    FPasteTarget: IRickUIBuilderEditHandle;
    FCopyCNPJValid: IRickUIBuilderEditHandle;
    FCopyCNPJInvalid: IRickUIBuilderEditHandle;
    FPasteCNPJTarget: IRickUIBuilderEditHandle;
    FInvalidHandle: IRickUIBuilderEditHandle;
    FRequirementHandle: IRickUIBuilderEditHandle;
    function AddTitle(const AText: string; ATop: Single): Single;
    function AddNote(const AText: string; ATop: Single): Single;
    function AddPreset(const ALabel: string; APreset: TRickUIBuilderEditPreset;
      ATop: Single): Single;
    procedure AddButton(const ACaption: string; ALeft, ATop: Single;
      AOnClick: TNotifyEvent);
    procedure BuildDocumentPresets(var ATop: Single);
    procedure BuildContactPresets(var ATop: Single);
    procedure BuildNumericPresets(var ATop: Single);
    procedure BuildTextPresets(var ATop: Single);
    procedure BuildCaseAndUrl(var ATop: Single);
    procedure BuildRequired(var ATop: Single);
    procedure BuildCounterClearPassword(var ATop: Single);
    function AddInvalidExample(const ALabel: string;
      AFeedback: TRickUIBuilderEditInvalidFeedback; ATop: Single): Single;
    procedure BuildFeedback(var ATop: Single);
    procedure BuildRequirement(var ATop: Single);
    function AddReadOnlySource(const ALabel, AText: string;
      ATop: Single): IRickUIBuilderEditHandle;
    procedure BuildClipboard(var ATop: Single);
    procedure BuildCustomAppearance(var ATop: Single);
    procedure CopyValid(ASender: TObject);
    procedure CopyInvalid(ASender: TObject);
    procedure PasteTarget(ASender: TObject);
    procedure CopyCNPJValid(ASender: TObject);
    procedure CopyCNPJInvalid(ASender: TObject);
    procedure PasteCNPJTarget(ASender: TObject);
    procedure MarkInvalid(ASender: TObject);
    procedure MarkValid(ASender: TObject);
    procedure RequirementMet(ASender: TObject);
    procedure RequirementNotMet(ASender: TObject);
  public
    constructor Create(AOwner: TComponent; AParent: TFmxObject); reintroduce;
    procedure Build(var ATop: Single);
  end;

implementation

uses
  Rick.UIBuilder;

const
  _CONTENT_LEFT_ = 24;
  _CONTENT_WIDTH_ = 552;
  _FIELD_WIDTH_ = 360;
  _FIELD_HEIGHT_ = 58;
  _TEXT_PRIMARY_ = $FF1A1D21;
  _TEXT_SECONDARY_ = $FF6B7280;

constructor TRickUIBuilderEditShowcase.Create(AOwner: TComponent;
  AParent: TFmxObject);
begin
  inherited Create(AOwner);
  FParent := AParent;
end;

function TRickUIBuilderEditShowcase.AddTitle(const AText: string;
  ATop: Single): Single;
begin
  TRickUIBuilder.Label_.Text(AText).Position(_CONTENT_LEFT_, ATop)
    .Size(_CONTENT_WIDTH_, 26).FontSize(18).FontColor(_TEXT_PRIMARY_)
    .Bold.Build(FParent);
  Result := ATop + 34;
end;

function TRickUIBuilderEditShowcase.AddNote(const AText: string;
  ATop: Single): Single;
begin
  TRickUIBuilder.Label_.Text(AText).Position(_CONTENT_LEFT_, ATop)
    .Size(_CONTENT_WIDTH_, 36).FontSize(12).FontColor(_TEXT_SECONDARY_)
    .Build(FParent);
  Result := ATop + 42;
end;

function TRickUIBuilderEditShowcase.AddPreset(const ALabel: string;
  APreset: TRickUIBuilderEditPreset; ATop: Single): Single;
begin
  TRickUIBuilder.Edit.LabelText(ALabel).Preset(APreset)
    .Position(_CONTENT_LEFT_, ATop).Size(_FIELD_WIDTH_, _FIELD_HEIGHT_)
    .ClearButton.Build(FParent);
  Result := ATop + 70;
end;

procedure TRickUIBuilderEditShowcase.AddButton(const ACaption: string;
  ALeft, ATop: Single; AOnClick: TNotifyEvent);
var
  LButton: TButton;
begin
  LButton := TButton.Create(Self);
  LButton.Parent := FParent;
  LButton.SetBounds(ALeft, ATop, 166, 34);
  LButton.Text := ACaption;
  LButton.OnClick := AOnClick;
end;

procedure TRickUIBuilderEditShowcase.BuildDocumentPresets(var ATop: Single);
begin
  ATop := AddTitle('5. Edit - documentos e máscaras', ATop);
  ATop := AddNote('Digite progressivamente; CPF, CNPJ e CEP aplicam a máscara durante a entrada.', ATop);
  ATop := AddPreset('CPF - 000.000.000-00', TRickUIBuilderEditPreset.CPF, ATop);
  ATop := AddPreset('CNPJ alfanumérico - AA.AAA.AAA/AAAA-00', TRickUIBuilderEditPreset.CNPJ, ATop);
  ATop := AddPreset('CEP - 00000-000', TRickUIBuilderEditPreset.CEP, ATop);
end;

procedure TRickUIBuilderEditShowcase.BuildContactPresets(var ATop: Single);
begin
  ATop := AddTitle('Contato', ATop);
  TRickUIBuilder.Edit.LabelText('E-mail - lowercase automático')
    .Preset(TRickUIBuilderEditPreset.Email).ClearButton
    .InvalidFeedback(TRickUIBuilderEditInvalidFeedback.AlertAndIcon)
    .InvalidMessage('E-mail incompleto ou inválido')
    .InvalidBorderColor($FFD32F2F).InvalidBackgroundColor($FFFFF1F1)
    .InvalidLabelColor($FFD32F2F).ErrorTextColor($FFD32F2F)
    .AlertIconColor($FFD32F2F).ClearIconColor($FF616161)
    .Position(_CONTENT_LEFT_, ATop).Size(_FIELD_WIDTH_, _FIELD_HEIGHT_)
    .Build(FParent);
  ATop := ATop + 84;
  ATop := AddPreset('Telefone - DDD opcional', TRickUIBuilderEditPreset.Phone, ATop);
  ATop := AddPreset('Celular - DDD opcional', TRickUIBuilderEditPreset.Mobile, ATop);
end;

procedure TRickUIBuilderEditShowcase.BuildNumericPresets(var ATop: Single);
begin
  ATop := AddTitle('Números', ATop);
  TRickUIBuilder.Edit.LabelText('Inteiro - negativo permitido')
    .Preset(TRickUIBuilderEditPreset.IntegerNumber).AllowNegative
    .Position(_CONTENT_LEFT_, ATop).Size(_FIELD_WIDTH_, _FIELD_HEIGHT_).Build(FParent);
  ATop := ATop + 70;
  TRickUIBuilder.Edit.LabelText('Float - formatação do locale')
    .Preset(TRickUIBuilderEditPreset.FloatNumber).DecimalPlaces(2)
    .NumberFormatMode(TRickUIBuilderEditNumberFormatMode.Locale)
    .Position(_CONTENT_LEFT_, ATop).Size(_FIELD_WIDTH_, _FIELD_HEIGHT_).Build(FParent);
  ATop := ATop + 70;
  TRickUIBuilder.Edit.LabelText('Float custom - 2 casas, decimal vírgula')
    .Preset(TRickUIBuilderEditPreset.FloatNumber).AllowNegative.DecimalPlaces(2)
    .NumberFormatMode(TRickUIBuilderEditNumberFormatMode.Custom)
    .DecimalSeparator(',').ThousandSeparator('.').UseThousandSeparator
    .Position(_CONTENT_LEFT_, ATop).Size(_FIELD_WIDTH_, _FIELD_HEIGHT_).Build(FParent);
  ATop := ATop + 70;
end;

procedure TRickUIBuilderEditShowcase.BuildTextPresets(var ATop: Single);
begin
  ATop := AddTitle('Texto', ATop);
  ATop := AddPreset('Sem acentos', TRickUIBuilderEditPreset.TextNoAccents, ATop);
  ATop := AddPreset('Sem acentos + pontuação', TRickUIBuilderEditPreset.TextPunctuationNoAccents, ATop);
  ATop := AddPreset('Com acentos', TRickUIBuilderEditPreset.TextWithAccents, ATop);
  ATop := AddPreset('Com acentos + pontuação', TRickUIBuilderEditPreset.TextPunctuationWithAccents, ATop);
  ATop := AddPreset('Todos os caracteres', TRickUIBuilderEditPreset.AllCharacters, ATop);
end;

procedure TRickUIBuilderEditShowcase.BuildCaseAndUrl(var ATop: Single);
begin
  ATop := AddTitle('Case e URL', ATop);
  TRickUIBuilder.Edit.LabelText('Uppercase').CaseMode(TRickUIBuilderEditCaseMode.Uppercase)
    .Position(_CONTENT_LEFT_, ATop).Size(_FIELD_WIDTH_, _FIELD_HEIGHT_).Build(FParent);
  ATop := ATop + 70;
  TRickUIBuilder.Edit.LabelText('Lowercase').CaseMode(TRickUIBuilderEditCaseMode.Lowercase)
    .Position(_CONTENT_LEFT_, ATop).Size(_FIELD_WIDTH_, _FIELD_HEIGHT_).Build(FParent);
  ATop := ATop + 70;
  TRickUIBuilder.Edit.LabelText('URL - somente scheme + host em lowercase')
    .Preset(TRickUIBuilderEditPreset.URL).UrlCaseMode(TRickUIBuilderEditUrlCaseMode.SchemeAndHost)
    .Position(_CONTENT_LEFT_, ATop).Size(_FIELD_WIDTH_, _FIELD_HEIGHT_).Build(FParent);
  ATop := ATop + 70;
  TRickUIBuilder.Edit.LabelText('URL - conteúdo inteiro em lowercase')
    .Preset(TRickUIBuilderEditPreset.URL).UrlCaseMode(TRickUIBuilderEditUrlCaseMode.EntireValue)
    .Position(_CONTENT_LEFT_, ATop).Size(_FIELD_WIDTH_, _FIELD_HEIGHT_).Build(FParent);
  ATop := ATop + 70;
end;

procedure TRickUIBuilderEditShowcase.BuildRequired(var ATop: Single);
var
  LHandle: IRickUIBuilderEditHandle;
begin
  ATop := AddTitle('Obrigatoriedade', ATop);
  ATop := AddNote(
    'Required é uma capacidade geral do Edit. Espaços em branco também são tratados como vazio.',
    ATop);

  LHandle := TRickUIBuilder.Edit
    .LabelText('Campo obrigatório')
    .Required
    .InvalidFeedback(TRickUIBuilderEditInvalidFeedback.AlertAndIcon)
    .InvalidMessage('Este campo é obrigatório')
    .Position(_CONTENT_LEFT_, ATop)
    .Size(_FIELD_WIDTH_, _FIELD_HEIGHT_)
    .Build(FParent);
  ATop := ATop + LHandle.Container.Height + 12;

  LHandle := TRickUIBuilder.Edit
    .LabelText('Campo opcional')
    .InvalidFeedback(TRickUIBuilderEditInvalidFeedback.AlertAndIcon)
    .InvalidMessage('Este campo é opcional')
    .Position(_CONTENT_LEFT_, ATop)
    .Size(_FIELD_WIDTH_, _FIELD_HEIGHT_)
    .Build(FParent);
  ATop := ATop + LHandle.Container.Height + 12;
end;

procedure TRickUIBuilderEditShowcase.BuildCounterClearPassword(var ATop: Single);
begin
  ATop := AddTitle('Limite, clear e senha', ATop);
  TRickUIBuilder.Edit.LabelText('Máximo 20 caracteres + contador')
    .MaxLength(20).CharacterCounter.ClearButton.Position(_CONTENT_LEFT_, ATop)
    .Size(_FIELD_WIDTH_, _FIELD_HEIGHT_).Build(FParent);
  ATop := ATop + 70;
  TRickUIBuilder.Edit.LabelText('Senha - use o ícone para mostrar/ocultar')
    .Password.ClearButton.Position(_CONTENT_LEFT_, ATop)
    .Size(_FIELD_WIDTH_, _FIELD_HEIGHT_).Build(FParent);
  ATop := ATop + 70;
end;

function TRickUIBuilderEditShowcase.AddInvalidExample(const ALabel: string;
  AFeedback: TRickUIBuilderEditInvalidFeedback; ATop: Single): Single;
var
  LHandle: IRickUIBuilderEditHandle;
begin
  LHandle := TRickUIBuilder.Edit.LabelText(ALabel).InvalidFeedback(AFeedback)
    .Position(_CONTENT_LEFT_, ATop).Size(_FIELD_WIDTH_, _FIELD_HEIGHT_).Build(FParent);
  LHandle.SetInvalid(True, 'Valor inválido');
  Result := ATop + 70;
end;

procedure TRickUIBuilderEditShowcase.BuildFeedback(var ATop: Single);
begin
  ATop := AddTitle('Estado inválido e feedback', ATop);
  ATop := AddInvalidExample('Feedback: somente mensagem',
    TRickUIBuilderEditInvalidFeedback.AlertOnly, ATop);
  ATop := AddInvalidExample('Feedback: somente ícone',
    TRickUIBuilderEditInvalidFeedback.IconOnly, ATop);
  FInvalidHandle := TRickUIBuilder.Edit.LabelText('Feedback: mensagem + ícone')
    .InvalidFeedback(TRickUIBuilderEditInvalidFeedback.AlertAndIcon)
    .Position(_CONTENT_LEFT_, ATop).Size(_FIELD_WIDTH_, _FIELD_HEIGHT_).Build(FParent);
  AddButton('Marcar inválido', _CONTENT_LEFT_ + 374, ATop, MarkInvalid);
  AddButton('Marcar válido', _CONTENT_LEFT_ + 374, ATop + 38, MarkValid);
  ATop := ATop + 84;
end;

procedure TRickUIBuilderEditShowcase.BuildRequirement(var ATop: Single);
begin
  ATop := AddTitle('Indicador de requisito', ATop);
  FRequirementHandle := TRickUIBuilder.Edit.LabelText('Requisito controlado externamente')
    .RequirementIndicator.Position(_CONTENT_LEFT_, ATop)
    .Size(_FIELD_WIDTH_, _FIELD_HEIGHT_).Build(FParent);
  AddButton('Requisito atendido', _CONTENT_LEFT_ + 374, ATop, RequirementMet);
  AddButton('Não atendido', _CONTENT_LEFT_ + 374, ATop + 38, RequirementNotMet);
  ATop := ATop + 84;
end;

function TRickUIBuilderEditShowcase.AddReadOnlySource(const ALabel,
  AText: string; ATop: Single): IRickUIBuilderEditHandle;
begin
  Result := TRickUIBuilder.Edit.LabelText(ALabel).Text(AText).ReadOnly
    .ReadOnlyBackgroundColor($FFF5F5F5).ReadOnlyBorderColor($FFD8D8D8)
    .ReadOnlyTextColor($FF8A8A8A).ReadOnlyLabelColor($FF8A8A8A)
    .Position(_CONTENT_LEFT_, ATop).Size(_FIELD_WIDTH_, _FIELD_HEIGHT_).Build(FParent);
end;

procedure TRickUIBuilderEditShowcase.BuildClipboard(var ATop: Single);
begin
  ATop := AddTitle('Copiar e colar - validação operacional', ATop);
  ATop := AddNote('Copie um valor abaixo e cole no alvo CPF. O paste sem máscara deve ser rejeitado.', ATop);
  FCopyValid := AddReadOnlySource('Fonte válida', '123.456.789-01', ATop);
  AddButton('Copiar válido', _CONTENT_LEFT_ + 374, ATop + 12, CopyValid);
  ATop := ATop + 70;
  FCopyInvalid := AddReadOnlySource('Fonte inválida', '12345678901', ATop);
  AddButton('Copiar sem máscara', _CONTENT_LEFT_ + 374, ATop + 12, CopyInvalid);
  ATop := ATop + 70;
  FPasteTarget := TRickUIBuilder.Edit.LabelText('Alvo CPF - cole aqui')
    .Preset(TRickUIBuilderEditPreset.CPF).ClearButton
    .BackgroundColor($FFF2F7FF).BorderColor($FF7A9CC6)
    .FocusBorderColor($FF245A9C).TextColor($FF17365D).FontSize(15)
    .LabelColor($FF6B4F1D).LabelFontSize(12).InvalidLabelColor($FF6B4F1D)
    .AlertIconColor($FFD32F2F).ClearIconColor($FF245A9C)
    .InvalidFeedback(TRickUIBuilderEditInvalidFeedback.AlertAndIcon)
    .InvalidMessage('CPF incompleto ou paste inválido').ErrorTextColor($FFD32F2F)
    .ErrorFontFamily('Arial').ErrorFontSize(11)
    .ErrorFontStyles([TFontStyle.fsBold]).ErrorSpacing(8)
    .Position(_CONTENT_LEFT_, ATop).Size(_FIELD_WIDTH_, _FIELD_HEIGHT_).Build(FParent);
  AddButton('Colar no alvo', _CONTENT_LEFT_ + 374, ATop + 12, PasteTarget);
  ATop := ATop + 98;

  ATop := AddNote('CNPJ: copie um valor abaixo e cole no alvo CNPJ. O paste sem máscara deve ser rejeitado.', ATop);
  FCopyCNPJValid := AddReadOnlySource('Fonte CNPJ válida', '12.ABC.345/01DE-35', ATop);
  AddButton('Copiar CNPJ válido', _CONTENT_LEFT_ + 374, ATop + 12, CopyCNPJValid);
  ATop := ATop + 70;
  FCopyCNPJInvalid := AddReadOnlySource('Fonte CNPJ sem máscara', '12ABC34501DE35', ATop);
  AddButton('Copiar CNPJ sem máscara', _CONTENT_LEFT_ + 374, ATop + 12, CopyCNPJInvalid);
  ATop := ATop + 70;
  FPasteCNPJTarget := TRickUIBuilder.Edit.LabelText('Alvo CNPJ - cole aqui')
    .Preset(TRickUIBuilderEditPreset.CNPJ).ClearButton
    .BackgroundColor($FFF3FAF5).BorderColor($FF77A887)
    .FocusBorderColor($FF287A46).TextColor($FF1E5130).FontSize(15)
    .LabelColor($FF6B4F1D).LabelFontSize(12).InvalidLabelColor($FF6B4F1D)
    .AlertIconColor($FFD32F2F).ClearIconColor($FF287A46)
    .InvalidFeedback(TRickUIBuilderEditInvalidFeedback.AlertAndIcon)
    .InvalidMessage('CNPJ incompleto ou paste inválido').ErrorTextColor($FFD32F2F)
    .ErrorFontFamily('Arial').ErrorFontSize(11)
    .ErrorFontStyles([TFontStyle.fsBold]).ErrorSpacing(8)
    .Position(_CONTENT_LEFT_, ATop).Size(_FIELD_WIDTH_, _FIELD_HEIGHT_).Build(FParent);
  AddButton('Colar no alvo CNPJ', _CONTENT_LEFT_ + 374, ATop + 12, PasteCNPJTarget);
  ATop := ATop + 98;
end;

procedure TRickUIBuilderEditShowcase.BuildCustomAppearance(var ATop: Single);
begin
  ATop := AddTitle('Edit customizado e somente leitura', ATop);
  ATop := AddNote('Exemplos com linha inferior customizável e estado somente leitura.', ATop);
  TRickUIBuilder.Edit.LabelText('Linha inferior - foco altera a cor')
    .Appearance(TRickUIBuilderEditAppearance.Underline)
    .UnderlineColor($FFB0B0B0).FocusUnderlineColor($FF202124)
    .InvalidUnderlineColor($FFD93025).UnderlineThickness(2)
    .Position(_CONTENT_LEFT_, ATop).Size(_FIELD_WIDTH_, _FIELD_HEIGHT_).Build(FParent);
  ATop := ATop + 70;
  TRickUIBuilder.Edit.LabelText('Campo somente leitura').Text('Informação fornecida')
    .Appearance(TRickUIBuilderEditAppearance.Underline).ReadOnly
    .ReadOnlyBackgroundColor($00FFFFFF).ReadOnlyTextColor($FFB8B8B8)
    .ReadOnlyLabelColor($FFB8B8B8).ReadOnlyUnderlineColor($FFD8D8D8)
    .Position(_CONTENT_LEFT_, ATop).Size(_FIELD_WIDTH_, _FIELD_HEIGHT_).Build(FParent);
  ATop := ATop + 70;
end;

procedure TRickUIBuilderEditShowcase.CopyValid(ASender: TObject);
begin
  FCopyValid.EditControl.SelectAll;
  FCopyValid.EditControl.CopyToClipboard;
end;

procedure TRickUIBuilderEditShowcase.CopyInvalid(ASender: TObject);
begin
  FCopyInvalid.EditControl.SelectAll;
  FCopyInvalid.EditControl.CopyToClipboard;
end;

procedure TRickUIBuilderEditShowcase.PasteTarget(ASender: TObject);
begin
  FPasteTarget.EditControl.SetFocus;
  FPasteTarget.EditControl.SelectAll;
  FPasteTarget.EditControl.PasteFromClipboard;
end;

procedure TRickUIBuilderEditShowcase.CopyCNPJValid(ASender: TObject);
begin
  FCopyCNPJValid.EditControl.SelectAll;
  FCopyCNPJValid.EditControl.CopyToClipboard;
end;

procedure TRickUIBuilderEditShowcase.CopyCNPJInvalid(ASender: TObject);
begin
  FCopyCNPJInvalid.EditControl.SelectAll;
  FCopyCNPJInvalid.EditControl.CopyToClipboard;
end;

procedure TRickUIBuilderEditShowcase.PasteCNPJTarget(ASender: TObject);
begin
  FPasteCNPJTarget.EditControl.SetFocus;
  FPasteCNPJTarget.EditControl.SelectAll;
  FPasteCNPJTarget.EditControl.PasteFromClipboard;
end;

procedure TRickUIBuilderEditShowcase.MarkInvalid(ASender: TObject);
begin
  FInvalidHandle.SetInvalid(True, 'Valor inválido definido pelo Sample');
end;

procedure TRickUIBuilderEditShowcase.MarkValid(ASender: TObject);
begin
  FInvalidHandle.SetInvalid(False);
end;

procedure TRickUIBuilderEditShowcase.RequirementMet(ASender: TObject);
begin
  FRequirementHandle.SetRequirementMet(True);
end;

procedure TRickUIBuilderEditShowcase.RequirementNotMet(ASender: TObject);
begin
  FRequirementHandle.SetRequirementMet(False);
end;

procedure TRickUIBuilderEditShowcase.Build(var ATop: Single);
begin
  BuildDocumentPresets(ATop);
  BuildContactPresets(ATop);
  BuildNumericPresets(ATop);
  BuildTextPresets(ATop);
  BuildCaseAndUrl(ATop);
  BuildRequired(ATop);
  BuildCounterClearPassword(ATop);
  BuildFeedback(ATop);
  BuildRequirement(ATop);
  BuildClipboard(ATop);
  BuildCustomAppearance(ATop);
end;

end.
