{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Example.Edit.Fluent.Runner                            }
{                                                                              }
{ Esta unit executa os vinte e nove exemplos Edit - Fluent Builder usando      }
{ somente contratos públicos, cobrindo presets, validação e runtime.           }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Executar exemplos reais da API pública TRickUIBuilder.Edit.                 }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Demonstra os 14 presets, case/URL, números, validação, senha, clipboard,    }
{  aparências e IRickUIBuilderEditHandle. O Completo cobre 62/62 métodos.      }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - Rick.UIBuilder / Interfaces / Types                                       }
{      Fornecem o Fluent Builder, contratos públicos, presets e config default.}
{  - RickUIBuilder.Samples.App.Types                                           }
{      Fornece TEditFluentExample para o dispatch.                             }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - TExampleEditFluent chama Reset antes de destruir o resultado anterior.    }
{  - Render executa somente o exemplo selecionado.                             }
{  - Botões do resultado chamam handlers desta instância do Runner.            }
{                                                                              }
{  Ownership / lifetime                                                        }
{  --------------------                                                        }
{  - Build recebe AHost diretamente como Parent.                               }
{  - Botões e labels auxiliares são owned pelo AHost.                          }
{  - Handles retidos mantêm referências ao resultado atual; FRuntimeStatus é  }
{    non-owning. Reset libera essas referências antes de ClearResult.          }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - Não usa TComponent/InsertComponent para lifetime.                         }
{  - Não usa classes concretas internas de Behavior/Handle/Input/Presentation. }
{  - Não contém textos de navegação/documentação da Sample Page.               }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Manter métodos, valores e ações sincronizados com Fluent.Content.           }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.Example.Edit.Fluent.Runner;

interface

uses
  System.Classes,

  FMX.Layouts,
  FMX.StdCtrls,

  Rick.UIBuilder.Interfaces,
  RickUIBuilder.Samples.App.Types;

type
  /// <summary>Executa os exemplos visuais e interativos Fluent de Edit.</summary>
  TEditFluentRunner = class sealed
  strict private
    FCopyCPFValid: IRickUIBuilderEditHandle;
    FCopyCPFInvalid: IRickUIBuilderEditHandle;
    FPasteCPF: IRickUIBuilderEditHandle;
    FCopyCNPJValid: IRickUIBuilderEditHandle;
    FCopyCNPJInvalid: IRickUIBuilderEditHandle;
    FPasteCNPJ: IRickUIBuilderEditHandle;
    FInvalidHandle: IRickUIBuilderEditHandle;
    FRequirementHandle: IRickUIBuilderEditHandle;
    FRuntimeHandle: IRickUIBuilderEditHandle;
    FRuntimeStatus: TLabel;
    procedure RenderFoundation(const AExample: TEditFluentExample; const AHost: TLayout);
    procedure RenderPresetContact(const AExample: TEditFluentExample; const AHost: TLayout);
    procedure RenderNumbersText(const AExample: TEditFluentExample; const AHost: TLayout);
    procedure RenderTextBehavior(const AExample: TEditFluentExample; const AHost: TLayout);
    procedure RenderValidation(const AExample: TEditFluentExample; const AHost: TLayout);
    procedure RenderAdvanced(const AExample: TEditFluentExample; const AHost: TLayout);
    procedure RenderBasic(const AHost: TLayout);
    procedure RenderInterface(const AHost: TLayout);
    procedure RenderAllCharacters(const AHost: TLayout);
    procedure RenderCPF(const AHost: TLayout);
    procedure RenderCNPJ(const AHost: TLayout);
    procedure RenderCEP(const AHost: TLayout);
    procedure RenderEmail(const AHost: TLayout);
    procedure RenderURL(const AHost: TLayout);
    procedure RenderPhone(const AHost: TLayout);
    procedure RenderMobile(const AHost: TLayout);
    procedure RenderIntegerNumber(const AHost: TLayout);
    procedure RenderFloatLocale(const AHost: TLayout);
    procedure RenderFloatCustom(const AHost: TLayout);
    procedure RenderTextNoAccents(const AHost: TLayout);
    procedure RenderTextPunctuationNoAccents(const AHost: TLayout);
    procedure RenderTextWithAccents(const AHost: TLayout);
    procedure RenderTextPunctuationWithAccents(const AHost: TLayout);
    procedure RenderCaseMode(const AHost: TLayout);
    procedure RenderRequired(const AHost: TLayout);
    procedure RenderCounterClear(const AHost: TLayout);
    procedure RenderPassword(const AHost: TLayout);
    procedure RenderInvalidFeedback(const AHost: TLayout);
    procedure RenderRequirement(const AHost: TLayout);
    procedure RenderClipboardMasked(const AHost: TLayout);
    procedure RenderAppearance(const AHost: TLayout);
    procedure RenderReadOnly(const AHost: TLayout);
    procedure RenderVisualCustomization(const AHost: TLayout);
    procedure RenderRuntimeHandle(const AHost: TLayout);
    procedure RenderComplete(const AHost: TLayout);
    procedure AddButton(const AHost: TLayout; const ACaption: string;
      ALeft, ATop, AWidth: Single; AOnClick: TNotifyEvent);
    procedure CopyCPFValid(ASender: TObject);
    procedure CopyCPFInvalid(ASender: TObject);
    procedure PasteCPF(ASender: TObject);
    procedure CopyCNPJValid(ASender: TObject);
    procedure CopyCNPJInvalid(ASender: TObject);
    procedure PasteCNPJ(ASender: TObject);
    procedure MarkInvalid(ASender: TObject);
    procedure MarkValid(ASender: TObject);
    procedure RequirementMet(ASender: TObject);
    procedure RequirementNotMet(ASender: TObject);
    procedure RuntimeSetText(ASender: TObject);
    procedure RuntimeClear(ASender: TObject);
    procedure RuntimeInvalid(ASender: TObject);
    procedure RuntimeValid(ASender: TObject);
    procedure RuntimeRequirementMet(ASender: TObject);
    procedure RuntimeRequirementNotMet(ASender: TObject);
    procedure RuntimeShowText(ASender: TObject);
    procedure CreateRuntimeStatus(const AHost: TLayout);
    procedure SetRuntimeStatus(const AText: string);
  public
    procedure Reset;
    procedure Render(const AExample: TEditFluentExample; const AHost: TLayout);
  end;

implementation

uses
  System.UITypes,

  FMX.Edit,

  Rick.UIBuilder,
  Rick.UIBuilder.Types;

procedure TEditFluentRunner.Reset;
begin
  FCopyCPFValid := nil;
  FCopyCPFInvalid := nil;
  FPasteCPF := nil;
  FCopyCNPJValid := nil;
  FCopyCNPJInvalid := nil;
  FPasteCNPJ := nil;
  FInvalidHandle := nil;
  FRequirementHandle := nil;
  FRuntimeHandle := nil;
  FRuntimeStatus := nil;
end;

procedure TEditFluentRunner.Render(const AExample: TEditFluentExample;
  const AHost: TLayout);
begin
  if AExample <= TEditFluentExample.CNPJ then
    RenderFoundation(AExample, AHost)
  else if AExample <= TEditFluentExample.Mobile then
    RenderPresetContact(AExample, AHost)
  else if AExample <= TEditFluentExample.TextPunctuationNoAccents then
    RenderNumbersText(AExample, AHost)
  else if AExample <= TEditFluentExample.CounterClear then
    RenderTextBehavior(AExample, AHost)
  else if AExample <= TEditFluentExample.Appearance then
    RenderValidation(AExample, AHost)
  else
    RenderAdvanced(AExample, AHost);
end;

procedure TEditFluentRunner.RenderFoundation(const AExample: TEditFluentExample;
  const AHost: TLayout);
begin
  case AExample of
    TEditFluentExample.Basic: RenderBasic(AHost);
    TEditFluentExample.InterfaceUsage: RenderInterface(AHost);
    TEditFluentExample.AllCharacters: RenderAllCharacters(AHost);
    TEditFluentExample.CPF: RenderCPF(AHost);
    TEditFluentExample.CNPJ: RenderCNPJ(AHost);
  end;
end;

procedure TEditFluentRunner.RenderPresetContact(const AExample: TEditFluentExample;
  const AHost: TLayout);
begin
  case AExample of
    TEditFluentExample.CEP: RenderCEP(AHost);
    TEditFluentExample.Email: RenderEmail(AHost);
    TEditFluentExample.URL: RenderURL(AHost);
    TEditFluentExample.Phone: RenderPhone(AHost);
    TEditFluentExample.Mobile: RenderMobile(AHost);
  end;
end;

procedure TEditFluentRunner.RenderNumbersText(const AExample: TEditFluentExample;
  const AHost: TLayout);
begin
  case AExample of
    TEditFluentExample.IntegerNumber: RenderIntegerNumber(AHost);
    TEditFluentExample.FloatLocale: RenderFloatLocale(AHost);
    TEditFluentExample.FloatCustom: RenderFloatCustom(AHost);
    TEditFluentExample.TextNoAccents: RenderTextNoAccents(AHost);
    TEditFluentExample.TextPunctuationNoAccents: RenderTextPunctuationNoAccents(AHost);
  end;
end;

procedure TEditFluentRunner.RenderTextBehavior(const AExample: TEditFluentExample;
  const AHost: TLayout);
begin
  case AExample of
    TEditFluentExample.TextWithAccents: RenderTextWithAccents(AHost);
    TEditFluentExample.TextPunctuationWithAccents: RenderTextPunctuationWithAccents(AHost);
    TEditFluentExample.CaseMode: RenderCaseMode(AHost);
    TEditFluentExample.Required: RenderRequired(AHost);
    TEditFluentExample.CounterClear: RenderCounterClear(AHost);
  end;
end;

procedure TEditFluentRunner.RenderValidation(const AExample: TEditFluentExample;
  const AHost: TLayout);
begin
  case AExample of
    TEditFluentExample.Password: RenderPassword(AHost);
    TEditFluentExample.InvalidFeedback: RenderInvalidFeedback(AHost);
    TEditFluentExample.Requirement: RenderRequirement(AHost);
    TEditFluentExample.ClipboardMasked: RenderClipboardMasked(AHost);
    TEditFluentExample.Appearance: RenderAppearance(AHost);
  end;
end;

procedure TEditFluentRunner.RenderAdvanced(const AExample: TEditFluentExample;
  const AHost: TLayout);
begin
  case AExample of
    TEditFluentExample.ReadOnly: RenderReadOnly(AHost);
    TEditFluentExample.VisualCustomization: RenderVisualCustomization(AHost);
    TEditFluentExample.RuntimeHandle: RenderRuntimeHandle(AHost);
    TEditFluentExample.Complete: RenderComplete(AHost);
  end;
end;

procedure TEditFluentRunner.RenderBasic(const AHost: TLayout);
begin
  TRickUIBuilder
    .Edit
      .Text('Rick.UIBuilder')
      .LabelText('Nome')
        .Position(16, 16)
        .Size(340, 64)
          .Build(AHost);
end;

procedure TEditFluentRunner.RenderInterface(const AHost: TLayout);
var LEdit: IRickUIBuilderEdit;
begin
  LEdit := TRickUIBuilder.Edit;
  LEdit
    .Text('IRickUIBuilderEdit')
    .LabelText('Interface pública')
      .Position(16, 16)
      .Size(340, 64)
        .Build(AHost);
end;

procedure TEditFluentRunner.RenderAllCharacters(const AHost: TLayout);
begin
  TRickUIBuilder
    .Edit
      .Text('ABC áé 123 !@#$%')
      .LabelText('Todos os caracteres')
        .Position(16, 16)
        .Size(340, 64)
          .Preset(TRickUIBuilderEditPreset.AllCharacters)
            .ClearButton
              .Build(AHost);
end;

procedure TEditFluentRunner.RenderCPF(const AHost: TLayout);
begin
  TRickUIBuilder
    .Edit
      .Text('123.456.789-01')
      .LabelText('CPF - 000.000.000-00')
        .Position(16, 16)
        .Size(340, 64)
          .Preset(TRickUIBuilderEditPreset.CPF)
            .ClearButton
              .Build(AHost);
end;

procedure TEditFluentRunner.RenderCNPJ(const AHost: TLayout);
begin
  TRickUIBuilder
    .Edit
      .Text('12.ABC.345/01DE-35')
      .LabelText('CNPJ alfanumérico - AA.AAA.AAA/AAAA-00')
        .Position(16, 16)
        .Size(340, 64)
          .Preset(TRickUIBuilderEditPreset.CNPJ)
            .ClearButton
              .Build(AHost);
end;

procedure TEditFluentRunner.RenderCEP(const AHost: TLayout);
begin
  TRickUIBuilder
    .Edit
      .Text('20040-020')
      .LabelText('CEP - 00000-000')
        .Position(16, 16)
        .Size(340, 64)
          .Preset(TRickUIBuilderEditPreset.CEP)
            .ClearButton
              .Build(AHost);
end;

procedure TEditFluentRunner.RenderEmail(const AHost: TLayout);
begin
  TRickUIBuilder
    .Edit
      .Text('Nome@Exemplo.COM')
      .LabelText('E-mail - lowercase automático')
        .Position(16, 16)
        .Size(340, 72)
          .Preset(TRickUIBuilderEditPreset.Email)
            .ClearButton
              .InvalidFeedback(TRickUIBuilderEditInvalidFeedback.AlertAndIcon)
              .InvalidMessage('E-mail incompleto ou inválido')
                .Build(AHost);
end;

procedure TEditFluentRunner.RenderURL(const AHost: TLayout);
begin
  TRickUIBuilder
    .Edit
      .Text('HTTPS://Example.COM/Path?Token=ABC')
      .LabelText('URL - scheme + host')
        .Position(16, 12)
        .Size(380, 64)
          .Preset(TRickUIBuilderEditPreset.URL)
          .UrlCaseMode(TRickUIBuilderEditUrlCaseMode.SchemeAndHost)
            .Build(AHost);

  TRickUIBuilder
    .Edit
      .Text('HTTPS://Example.COM/Path?Token=ABC')
      .LabelText('URL - conteúdo inteiro')
        .Position(16, 92)
        .Size(380, 64)
          .Preset(TRickUIBuilderEditPreset.URL)
          .UrlCaseMode(TRickUIBuilderEditUrlCaseMode.EntireValue)
            .Build(AHost);
end;

procedure TEditFluentRunner.RenderPhone(const AHost: TLayout);
begin
  TRickUIBuilder
    .Edit
      .Text('(21) 3333-4444')
      .LabelText('Telefone - DDD opcional')
        .Position(16, 16)
        .Size(340, 64)
          .Preset(TRickUIBuilderEditPreset.Phone)
            .ClearButton
              .Build(AHost);
end;

procedure TEditFluentRunner.RenderMobile(const AHost: TLayout);
begin
  TRickUIBuilder
    .Edit
      .Text('(21) 99999-8888')
      .LabelText('Celular - DDD opcional')
        .Position(16, 16)
        .Size(340, 64)
          .Preset(TRickUIBuilderEditPreset.Mobile)
            .ClearButton
              .Build(AHost);
end;

procedure TEditFluentRunner.RenderIntegerNumber(const AHost: TLayout);
begin
  TRickUIBuilder
    .Edit
      .Text('150')
      .LabelText('Inteiro positivo')
        .Position(16, 12)
        .Size(340, 64)
          .Preset(TRickUIBuilderEditPreset.IntegerNumber)
            .AllowNegative(False)
              .Build(AHost);

  TRickUIBuilder
    .Edit
      .Text('-42')
      .LabelText('Inteiro com negativo')
        .Position(16, 92)
        .Size(340, 64)
          .Preset(TRickUIBuilderEditPreset.IntegerNumber)
            .AllowNegative(True)
              .Build(AHost);
end;

procedure TEditFluentRunner.RenderFloatLocale(const AHost: TLayout);
begin
  TRickUIBuilder
    .Edit
      .LabelText('Float - formatação do locale')
        .Position(16, 16)
        .Size(340, 64)
          .Preset(TRickUIBuilderEditPreset.FloatNumber)
            .DecimalPlaces(2)
            .NumberFormatMode(TRickUIBuilderEditNumberFormatMode.Locale)
              .Build(AHost);
end;

procedure TEditFluentRunner.RenderFloatCustom(const AHost: TLayout);
begin
  TRickUIBuilder
    .Edit
      .LabelText('Float custom - negativo e milhar')
        .Position(16, 16)
        .Size(340, 64)
          .Preset(TRickUIBuilderEditPreset.FloatNumber)
            .AllowNegative
            .DecimalPlaces(2)
            .NumberFormatMode(TRickUIBuilderEditNumberFormatMode.Custom)
            .DecimalSeparator(',')
            .ThousandSeparator('.')
            .UseThousandSeparator
              .Build(AHost);
end;

procedure TEditFluentRunner.RenderTextNoAccents(const AHost: TLayout);
begin
  TRickUIBuilder
    .Edit
      .Text('Cafe sem acentos')
      .LabelText('Texto sem acentos')
        .Position(16, 16)
        .Size(340, 64)
          .Preset(TRickUIBuilderEditPreset.TextNoAccents)
            .ClearButton
              .Build(AHost);
end;

procedure TEditFluentRunner.RenderTextPunctuationNoAccents(const AHost: TLayout);
begin
  TRickUIBuilder
    .Edit
      .Text('Cafe, preco: 12.50!')
      .LabelText('Sem acentos + pontuação')
        .Position(16, 16)
        .Size(340, 64)
          .Preset(TRickUIBuilderEditPreset.TextPunctuationNoAccents)
            .ClearButton
              .Build(AHost);
end;

procedure TEditFluentRunner.RenderTextWithAccents(const AHost: TLayout);
begin
  TRickUIBuilder
    .Edit
      .Text('Café, ação e coração')
      .LabelText('Texto com acentos')
        .Position(16, 16)
        .Size(340, 64)
          .Preset(TRickUIBuilderEditPreset.TextWithAccents)
            .ClearButton
              .Build(AHost);
end;

procedure TEditFluentRunner.RenderTextPunctuationWithAccents(const AHost: TLayout);
begin
  TRickUIBuilder
    .Edit
      .Text('Olá, João! Café: R$ 12,50.')
      .LabelText('Com acentos + pontuação')
        .Position(16, 16)
        .Size(360, 64)
          .Preset(TRickUIBuilderEditPreset.TextPunctuationWithAccents)
            .ClearButton
              .Build(AHost);
end;

procedure TEditFluentRunner.RenderCaseMode(const AHost: TLayout);
begin
  TRickUIBuilder
    .Edit
      .Text('Rick UiBuilder')
      .LabelText('Preserve')
        .Position(16, 8)
        .Size(340, 56)
          .CaseMode(TRickUIBuilderEditCaseMode.Preserve)
            .Build(AHost);

  TRickUIBuilder
    .Edit
      .Text('rick uibuilder')
      .LabelText('Uppercase')
        .Position(16, 76)
        .Size(340, 56)
          .CaseMode(TRickUIBuilderEditCaseMode.Uppercase)
            .Build(AHost);

  TRickUIBuilder
    .Edit
      .Text('RICK UIBUILDER')
      .LabelText('Lowercase')
        .Position(16, 144)
        .Size(340, 56)
          .CaseMode(TRickUIBuilderEditCaseMode.Lowercase)
            .Build(AHost);
end;

procedure TEditFluentRunner.RenderRequired(const AHost: TLayout);
begin
  TRickUIBuilder
    .Edit
      .LabelText('Campo obrigatório')
        .Position(16, 12)
        .Size(360, 72)
          .Required(True)
          .InvalidFeedback(TRickUIBuilderEditInvalidFeedback.AlertAndIcon)
          .InvalidMessage('Este campo é obrigatório')
            .Build(AHost);
  TRickUIBuilder
    .Edit
      .LabelText('Campo opcional')
        .Position(16, 104)
        .Size(360, 64)
          .Required(False)
            .Build(AHost);
end;

procedure TEditFluentRunner.RenderCounterClear(const AHost: TLayout);
begin
  TRickUIBuilder
    .Edit
      .Text('Rick.UIBuilder')
      .LabelText('Máximo 20 caracteres')
        .Position(16, 16)
        .Size(360, 68)
          .MaxLength(20)
          .CharacterCounter(True)
          .ClearButton(True)
            .Build(AHost);
end;

procedure TEditFluentRunner.RenderPassword(const AHost: TLayout);
begin
  TRickUIBuilder
    .Edit
      .Text('SenhaSegura123')
      .LabelText('Senha - mostrar/ocultar')
        .Position(16, 16)
        .Size(360, 64)
          .ClearButton(True)
          .Password(True)
            .Build(AHost);
end;

procedure TEditFluentRunner.RenderInvalidFeedback(const AHost: TLayout);
var
  LHandle: IRickUIBuilderEditHandle;
begin
  LHandle := TRickUIBuilder
    .Edit
      .LabelText('Somente mensagem')
        .Position(8, 4)
        .Size(190, 60)
          .InvalidFeedback(TRickUIBuilderEditInvalidFeedback.AlertOnly)
            .Build(AHost);
  LHandle.SetInvalid(True, 'Valor inválido');

  LHandle := TRickUIBuilder
    .Edit
      .LabelText('Somente ícone')
        .Position(210, 4)
        .Size(190, 60)
          .InvalidFeedback(TRickUIBuilderEditInvalidFeedback.IconOnly)
            .Build(AHost);
  LHandle.SetInvalid(True, 'Valor inválido');

  FInvalidHandle := TRickUIBuilder
    .Edit
      .LabelText('Mensagem + ícone')
        .Position(8, 100)
        .Size(248, 68)
          .InvalidFeedback(TRickUIBuilderEditInvalidFeedback.AlertAndIcon)
            .Build(AHost);
  FInvalidHandle.SetInvalid(True, 'Valor inválido');
  AddButton(AHost, 'Inválido', 268, 114, 64, MarkInvalid);
  AddButton(AHost, 'Válido', 336, 114, 64, MarkValid);
end;

procedure TEditFluentRunner.RenderRequirement(const AHost: TLayout);
begin
  FRequirementHandle := TRickUIBuilder
    .Edit
      .LabelText('Requisito externo')
        .Position(16, 16)
        .Size(360, 64)
          .RequirementIndicator(True)
            .Build(AHost);
  AddButton(AHost, 'Atendido', 16, 96, 100, RequirementMet);
  AddButton(AHost, 'Não atendido', 124, 96, 116, RequirementNotMet);
end;

procedure TEditFluentRunner.RenderClipboardMasked(const AHost: TLayout);
begin
  FCopyCPFValid := TRickUIBuilder
    .Edit
      .Text('123.456.789-01')
      .LabelText('CPF válido')
        .Position(4, 4)
        .Size(118, 52)
          .ReadOnly
            .ReadOnlyBackgroundColor($FFF5F5F5)
            .ReadOnlyBorderColor($FFD8D8D8)
            .ReadOnlyTextColor($FF707070)
              .Build(AHost);

  FCopyCPFInvalid := TRickUIBuilder
    .Edit
      .Text('12345678901')
      .LabelText('CPF sem máscara')
        .Position(4, 68)
        .Size(118, 52)
          .ReadOnly
            .ReadOnlyBackgroundColor($FFF5F5F5)
            .ReadOnlyBorderColor($FFD8D8D8)
            .ReadOnlyTextColor($FF707070)
              .Build(AHost);

  FPasteCPF := TRickUIBuilder
    .Edit
      .LabelText('Alvo CPF')
        .Position(4, 132)
        .Size(118, 52)
          .Preset(TRickUIBuilderEditPreset.CPF)
            .ClearButton
              .Build(AHost);
  AddButton(AHost, 'Copiar', 126, 14, 70, CopyCPFValid);
  AddButton(AHost, 'Copiar', 126, 80, 70, CopyCPFInvalid);
  AddButton(AHost, 'Colar', 126, 144, 70, PasteCPF);

  FCopyCNPJValid := TRickUIBuilder
    .Edit
      .Text('12.ABC.345/01DE-35')
      .LabelText('CNPJ válido')
        .Position(208, 4)
        .Size(118, 52)
          .ReadOnly
            .ReadOnlyBackgroundColor($FFF5F5F5)
            .ReadOnlyBorderColor($FFD8D8D8)
            .ReadOnlyTextColor($FF707070)
              .Build(AHost);

  FCopyCNPJInvalid := TRickUIBuilder
    .Edit
      .Text('12ABC34501DE35')
      .LabelText('CNPJ sem máscara')
        .Position(208, 68)
        .Size(118, 52)
          .ReadOnly
            .ReadOnlyBackgroundColor($FFF5F5F5)
            .ReadOnlyBorderColor($FFD8D8D8)
            .ReadOnlyTextColor($FF707070)
              .Build(AHost);

  FPasteCNPJ := TRickUIBuilder
    .Edit
      .LabelText('Alvo CNPJ')
        .Position(208, 132)
        .Size(118, 52)
          .Preset(TRickUIBuilderEditPreset.CNPJ)
            .ClearButton
              .Build(AHost);
  AddButton(AHost, 'Copiar', 330, 14, 70, CopyCNPJValid);
  AddButton(AHost, 'Copiar', 330, 80, 70, CopyCNPJInvalid);
  AddButton(AHost, 'Colar', 330, 144, 70, PasteCNPJ);
end;

procedure TEditFluentRunner.RenderAppearance(const AHost: TLayout);
begin
  TRickUIBuilder
    .Edit
      .Text('Borda completa')
      .LabelText('Outlined')
        .Position(16, 12)
        .Size(360, 64)
          .Appearance(TRickUIBuilderEditAppearance.Outlined)
            .Build(AHost);
  TRickUIBuilder
    .Edit
      .Text('Linha inferior')
      .LabelText('Underline')
        .Position(16, 92)
        .Size(360, 64)
          .Appearance(TRickUIBuilderEditAppearance.Underline)
            .UnderlineThickness(2)
              .Build(AHost);
end;

procedure TEditFluentRunner.RenderReadOnly(const AHost: TLayout);
begin
  TRickUIBuilder
    .Edit
      .Text('Informação fornecida')
      .LabelText('Somente leitura')
        .Position(16, 16)
        .Size(360, 64)
          .ReadOnly(True)
            .ReadOnlyBackgroundColor($FFF5F5F5)
            .ReadOnlyBorderColor($FFD8D8D8)
            .ReadOnlyTextColor($FF8A8A8A)
            .ReadOnlyLabelColor($FF8A8A8A)
              .Build(AHost);
end;

procedure TEditFluentRunner.RenderVisualCustomization(const AHost: TLayout);
var
  LHandle: IRickUIBuilderEditHandle;
  LDefaults: TRickUIBuilderEditConfig;
begin
  LDefaults := TRickUIBuilderEditConfig.Default;

  LHandle := TRickUIBuilder
    .Edit
      .Text('Visual personalizado')
      .LabelText('Edit customizado')
        .Position(16, 8)
        .Size(360, 76)
          .ClearButton(True)
          .RequirementIndicator(True)
          .InvalidFeedback(TRickUIBuilderEditInvalidFeedback.AlertAndIcon)
            .Appearance(TRickUIBuilderEditAppearance.Outlined)
              .BackgroundColor(TAlphaColors.White)
              .EditBackgroundColor($FFF2F7FF)
              .BorderColor($FF7A9CC6)
              .FocusBorderColor(TAlphaColors.Dodgerblue)
              .InvalidBorderColor($FFD32F2F)
              .InvalidBackgroundColor($FFFFF1F1)
                .TextColor($FF17365D)
                .LabelColor($FF6B4F1D)
                .InvalidLabelColor($FFD32F2F)
                  .FontSize(15)
                  .LabelFontSize(12)
                    .ErrorTextColor($FFD32F2F)
                    .ErrorFontFamily('Arial')
                    .ErrorFontSize(11)
                    .ErrorFontStyles([TFontStyle.fsBold])
                    .ErrorSpacing(6)
                      .CornerRadius(10)
                      .BorderThickness(2)
                        .IconColor($FF245A9C)
                        .AlertIconColor($FFD32F2F)
                        .ClearIconColor($FF245A9C)
                        .PasswordIconColor($FF245A9C)
                        .RequirementIconColor($FF287A46)
                        .IconSize(18)
                          .AlertPath(LDefaults.AlertPath)
                          .ClearPath(LDefaults.ClearPath)
                          .VisibilityPath(LDefaults.VisibilityPath)
                          .VisibilityOffPath(LDefaults.VisibilityOffPath)
                          .RequirementMetPath(LDefaults.RequirementMetPath)
                          .RequirementNotMetPath(LDefaults.RequirementNotMetPath)
                            .Build(AHost);
  LHandle.SetInvalid(True,
    'Mensagem com tipografia e espaçamento customizados');

  TRickUIBuilder
    .Edit
      .Text('Senha visual')
      .LabelText('Senha customizada')
        .Position(16, 104)
        .Size(360, 68)
          .Password(True)
            .Appearance(TRickUIBuilderEditAppearance.Outlined)
              .BackgroundColor(TAlphaColors.White)
              .EditBackgroundColor($FFF2F7FF)
              .BorderColor($FF7A9CC6)
              .FocusBorderColor(TAlphaColors.Dodgerblue)
              .InvalidBorderColor($FFD32F2F)
              .InvalidBackgroundColor($FFFFF1F1)
                .TextColor($FF17365D)
                .LabelColor($FF6B4F1D)
                .InvalidLabelColor($FFD32F2F)
                  .FontSize(15)
                  .LabelFontSize(12)
                    .ErrorTextColor($FFD32F2F)
                    .ErrorFontFamily('Arial')
                    .ErrorFontSize(11)
                    .ErrorFontStyles([TFontStyle.fsBold])
                    .ErrorSpacing(6)
                      .CornerRadius(10)
                      .BorderThickness(2)
                        .IconColor($FF245A9C)
                        .AlertIconColor($FFD32F2F)
                        .ClearIconColor($FF245A9C)
                        .PasswordIconColor($FF245A9C)
                        .RequirementIconColor($FF287A46)
                        .IconSize(18)
                          .AlertPath(LDefaults.AlertPath)
                          .ClearPath(LDefaults.ClearPath)
                          .VisibilityPath(LDefaults.VisibilityPath)
                          .VisibilityOffPath(LDefaults.VisibilityOffPath)
                          .RequirementMetPath(LDefaults.RequirementMetPath)
                          .RequirementNotMetPath(LDefaults.RequirementNotMetPath)
                            .Build(AHost);
end;

procedure TEditFluentRunner.RenderRuntimeHandle(const AHost: TLayout);
begin
  FRuntimeHandle := TRickUIBuilder
    .Edit
      .Text('Valor inicial')
      .LabelText('Handle runtime')
        .Position(16, 8)
        .Size(360, 64)
          .RequirementIndicator(True)
            .Build(AHost);
  CreateRuntimeStatus(AHost);
  AddButton(AHost, 'Texto', 16, 124, 58, RuntimeSetText);
  AddButton(AHost, 'Limpar', 78, 124, 62, RuntimeClear);
  AddButton(AHost, 'Inválido', 144, 124, 68, RuntimeInvalid);
  AddButton(AHost, 'Válido', 216, 124, 60, RuntimeValid);
  AddButton(AHost, 'Req. OK', 280, 124, 62, RuntimeRequirementMet);
  AddButton(AHost, 'Req. não', 346, 124, 62, RuntimeRequirementNotMet);
  AddButton(AHost, 'Ler Text', 16, 164, 82, RuntimeShowText);
end;

procedure TEditFluentRunner.RenderComplete(const AHost: TLayout);
var
  LDefaults: TRickUIBuilderEditConfig;
begin
  LDefaults := TRickUIBuilderEditConfig.Default;

  TRickUIBuilder
    .Edit
      .Text('Referência completa')
      .LabelText('Edit completo')
        .Position(16, 16)
        .Size(380, 86)
          .Preset(TRickUIBuilderEditPreset.AllCharacters)
          .CaseMode(TRickUIBuilderEditCaseMode.Preserve)
          .UrlCaseMode(TRickUIBuilderEditUrlCaseMode.SchemeAndHost)
            .MaxLength(80)
            .CharacterCounter(True)
            .ClearButton(True)
            .Password(False)
              .AllowNegative(True)
              .DecimalPlaces(2)
              .NumberFormatMode(TRickUIBuilderEditNumberFormatMode.Custom)
              .DecimalSeparator(',')
              .ThousandSeparator('.')
              .UseThousandSeparator(True)
                .Required(True)
                .RequirementIndicator(True)
                .InvalidFeedback(
                  TRickUIBuilderEditInvalidFeedback.AlertAndIcon)
                .InvalidMessage('Valor inválido')
                  .Appearance(TRickUIBuilderEditAppearance.Underline)
                  .ReadOnly(False)
                    .BackgroundColor(TAlphaColors.White)
                    .EditBackgroundColor($FFF7FAFE)
                    .BorderColor($FF9AA9B8)
                    .FocusBorderColor(TAlphaColors.Dodgerblue)
                    .InvalidBorderColor($FFD93025)
                    .InvalidBackgroundColor($FFFFF0F0)
                      .TextColor(TAlphaColors.Black)
                      .LabelColor($FF506070)
                      .InvalidLabelColor($FFD93025)
                        .FontSize(14)
                        .LabelFontSize(12)
                          .ErrorTextColor($FFD93025)
                          .ErrorFontFamily('Arial')
                          .ErrorFontSize(11)
                          .ErrorFontStyles([TFontStyle.fsBold])
                          .ErrorSpacing(6)
                            .ReadOnlyBackgroundColor($FFF7F7F7)
                            .ReadOnlyBorderColor($FFD8D8D8)
                            .ReadOnlyTextColor($FF888888)
                            .ReadOnlyLabelColor($FF888888)
                              .UnderlineColor($FFB0B0B0)
                              .FocusUnderlineColor(TAlphaColors.Dodgerblue)
                              .InvalidUnderlineColor($FFD93025)
                              .ReadOnlyUnderlineColor($FFD8D8D8)
                              .UnderlineThickness(2)
                                .CornerRadius(8)
                                .BorderThickness(1)
                                  .IconColor($FF506070)
                                  .AlertIconColor($FFD93025)
                                  .ClearIconColor($FF245A9C)
                                  .PasswordIconColor($FF245A9C)
                                  .RequirementIconColor($FF287A46)
                                  .IconSize(20)
                                    .AlertPath(LDefaults.AlertPath)
                                    .ClearPath(LDefaults.ClearPath)
                                    .VisibilityPath(LDefaults.VisibilityPath)
                                    .VisibilityOffPath(
                                      LDefaults.VisibilityOffPath)
                                    .RequirementMetPath(
                                      LDefaults.RequirementMetPath)
                                    .RequirementNotMetPath(
                                      LDefaults.RequirementNotMetPath)
                                        .Build(AHost);
end;

procedure TEditFluentRunner.AddButton(const AHost: TLayout; const ACaption: string;
  ALeft, ATop, AWidth: Single; AOnClick: TNotifyEvent);
var LButton: TButton;
begin
  LButton := TButton.Create(AHost);
  LButton.Parent := AHost;
  LButton.SetBounds(ALeft, ATop, AWidth, 30);
  LButton.Text := ACaption;
  LButton.OnClick := AOnClick;
end;


procedure TEditFluentRunner.CopyCPFValid(ASender: TObject);
begin
  FCopyCPFValid.EditControl.SelectAll;
  FCopyCPFValid.EditControl.CopyToClipboard;
end;
procedure TEditFluentRunner.CopyCPFInvalid(ASender: TObject);
begin
  FCopyCPFInvalid.EditControl.SelectAll;
  FCopyCPFInvalid.EditControl.CopyToClipboard;
end;
procedure TEditFluentRunner.PasteCPF(ASender: TObject);
begin
  FPasteCPF.EditControl.SetFocus;
  FPasteCPF.EditControl.SelectAll;
  FPasteCPF.EditControl.PasteFromClipboard;
end;
procedure TEditFluentRunner.CopyCNPJValid(ASender: TObject);
begin
  FCopyCNPJValid.EditControl.SelectAll;
  FCopyCNPJValid.EditControl.CopyToClipboard;
end;
procedure TEditFluentRunner.CopyCNPJInvalid(ASender: TObject);
begin
  FCopyCNPJInvalid.EditControl.SelectAll;
  FCopyCNPJInvalid.EditControl.CopyToClipboard;
end;
procedure TEditFluentRunner.PasteCNPJ(ASender: TObject);
begin
  FPasteCNPJ.EditControl.SetFocus;
  FPasteCNPJ.EditControl.SelectAll;
  FPasteCNPJ.EditControl.PasteFromClipboard;
end;

procedure TEditFluentRunner.MarkInvalid(ASender: TObject);
begin
  FInvalidHandle.SetInvalid(True, 'Valor inválido definido pelo Sample');
end;
procedure TEditFluentRunner.MarkValid(ASender: TObject);
begin
  FInvalidHandle.SetInvalid(False);
end;
procedure TEditFluentRunner.RequirementMet(ASender: TObject);
begin
  FRequirementHandle.SetRequirementMet(True);
end;
procedure TEditFluentRunner.RequirementNotMet(ASender: TObject);
begin
  FRequirementHandle.SetRequirementMet(False);
end;

procedure TEditFluentRunner.RuntimeSetText(ASender: TObject);
begin
  FRuntimeHandle.Text('Texto alterado pelo Handle');
  SetRuntimeStatus('Text setter aplicado');
end;
procedure TEditFluentRunner.RuntimeClear(ASender: TObject);
begin
  FRuntimeHandle.Clear;
  SetRuntimeStatus('Clear executado');
end;
procedure TEditFluentRunner.RuntimeInvalid(ASender: TObject);
begin
  FRuntimeHandle.SetInvalid(True, 'Inválido via Handle');
  SetRuntimeStatus('Estado inválido');
end;
procedure TEditFluentRunner.RuntimeValid(ASender: TObject);
begin
  FRuntimeHandle.SetInvalid(False);
  SetRuntimeStatus('Estado válido');
end;
procedure TEditFluentRunner.RuntimeRequirementMet(ASender: TObject);
begin
  FRuntimeHandle.SetRequirementMet(True);
  SetRuntimeStatus('Requisito atendido');
end;
procedure TEditFluentRunner.RuntimeRequirementNotMet(ASender: TObject);
begin
  FRuntimeHandle.SetRequirementMet(False);
  SetRuntimeStatus('Requisito não atendido');
end;
procedure TEditFluentRunner.RuntimeShowText(ASender: TObject);
begin
  SetRuntimeStatus('Text getter: ' + FRuntimeHandle.Text);
end;

procedure TEditFluentRunner.CreateRuntimeStatus(const AHost: TLayout);
begin
  FRuntimeStatus := TLabel.Create(AHost);
  FRuntimeStatus.Parent := AHost;
  FRuntimeStatus.SetBounds(16, 88, 380, 28);
  FRuntimeStatus.Text := 'Use as ações para alterar o Handle.';
end;

procedure TEditFluentRunner.SetRuntimeStatus(const AText: string);
begin
  if Assigned(FRuntimeStatus) then
    FRuntimeStatus.Text := AText;
end;


end.
