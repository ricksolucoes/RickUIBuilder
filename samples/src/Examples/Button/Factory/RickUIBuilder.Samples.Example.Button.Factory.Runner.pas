{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Example.Button.Factory.Runner                         }
{                                                                              }
{ Esta unit executa os oito exemplos Button - Factory no ResultHost,           }
{ incluindo feedback real de clique e um exemplo Completo que materializa      }
{ todos os campos públicos atuais de TRickUIBuilderButtonConfig.               }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Executar os exemplos reais da abordagem Factory de Button.                  }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Materializa TRectangle + TLabel por TRickUIBuilderFactory.CreateButton,     }
{  demonstra as duas sobrecargas públicas e associa OnClick ao TRectangle      }
{  retornado no exemplo interativo.                                            }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - RickUIBuilder.Samples.App.Types                                           }
{      Fornece TButtonFactoryExample usado para selecionar a execução.         }
{  - Rick.UIBuilder.Factory                                                    }
{      Fornece as duas sobrecargas públicas de CreateButton.                   }
{  - Rick.UIBuilder.Types                                                      }
{      Fornece TRickUIBuilderButtonConfig e seus defaults.                     }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - TExampleButtonFactory limpa ResultHost e solicita Render.                 }
{  - Cada método materializa somente o resultado do exemplo selecionado.       }
{  - No exemplo Clique, um TComponent owned pelo próprio Button recebe OnClick }
{    e altera a cor do TRectangle; sua vida termina junto com o resultado.     }
{                                                                              }
{  Ownership / lifetime                                                        }
{  --------------------                                                        }
{  - ResultHost é usado como Owner e Parent dos controles criados pela Factory.}
{  - O helper de clique é owned pelo TRectangle retornado e não possui controle.}
{  - ClearResult libera o Button e, por ownership, o helper antes do próximo   }
{    exemplo; nenhuma referência é mantida entre renderizações.                }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - Não cria navegação, não define textos da página e não conhece Fluent.     }
{  - OnClick não é tratado como campo de TRickUIBuilderButtonConfig.           }
{  - O exemplo Completo deve atribuir todos os nove campos públicos do record. }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Os valores executados devem permanecer sincronizados com os snippets        }
{  apresentados por Factory.Content.                                           }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.Example.Button.Factory.Runner;

interface

uses
  FMX.Layouts,
  RickUIBuilder.Samples.App.Types;

type
  /// <summary>Executa o resultado visual e interativo dos exemplos Factory de Button.</summary>
  TButtonFactoryRunner = class sealed
  strict private
    class procedure RenderVisual(const AExample: TButtonFactoryExample;
      const AHost: TLayout); static;
    class procedure RenderBehavior(const AExample: TButtonFactoryExample;
      const AHost: TLayout); static;
    class procedure RenderBasic(const AHost: TLayout); static;
    class procedure RenderGeometry(const AHost: TLayout); static;
    class procedure RenderColors(const AHost: TLayout); static;
    class procedure RenderTypography(const AHost: TLayout); static;
    class procedure RenderIdentification(const AHost: TLayout); static;
    class procedure RenderCaptionAccess(const AHost: TLayout); static;
    class procedure RenderClick(const AHost: TLayout); static;
    class procedure RenderComplete(const AHost: TLayout); static;
  public
    class procedure Render(const AExample: TButtonFactoryExample;
      const AHost: TLayout); static;
  end;

implementation

uses
  System.Classes,
  System.SysUtils,
  System.UITypes,

  FMX.Objects,
  FMX.StdCtrls,

  Rick.UIBuilder.Factory,
  Rick.UIBuilder.Types;

type
  TButtonFactoryClickFeedback = class(TComponent)
  public
    procedure ButtonClick(ASender: TObject);
  end;

procedure TButtonFactoryClickFeedback.ButtonClick(ASender: TObject);
begin
  TRectangle(ASender).Fill.Color := TAlphaColors.Green;
end;

class procedure TButtonFactoryRunner.Render(
  const AExample: TButtonFactoryExample; const AHost: TLayout);
begin
  case AExample of
    TButtonFactoryExample.Basic,
    TButtonFactoryExample.Geometry,
    TButtonFactoryExample.Colors,
    TButtonFactoryExample.Typography:
      RenderVisual(AExample, AHost);
  else
    RenderBehavior(AExample, AHost);
  end;
end;

class procedure TButtonFactoryRunner.RenderVisual(
  const AExample: TButtonFactoryExample; const AHost: TLayout);
begin
  case AExample of
    TButtonFactoryExample.Basic: RenderBasic(AHost);
    TButtonFactoryExample.Geometry: RenderGeometry(AHost);
    TButtonFactoryExample.Colors: RenderColors(AHost);
    TButtonFactoryExample.Typography: RenderTypography(AHost);
  end;
end;

class procedure TButtonFactoryRunner.RenderBehavior(
  const AExample: TButtonFactoryExample; const AHost: TLayout);
begin
  case AExample of
    TButtonFactoryExample.Identification: RenderIdentification(AHost);
    TButtonFactoryExample.CaptionAccess: RenderCaptionAccess(AHost);
    TButtonFactoryExample.Click: RenderClick(AHost);
    TButtonFactoryExample.Complete: RenderComplete(AHost);
  end;
end;

class procedure TButtonFactoryRunner.RenderBasic(const AHost: TLayout);
var
  LConfig: TRickUIBuilderButtonConfig;
begin
  LConfig := TRickUIBuilderButtonConfig.Default;
  TRickUIBuilderFactory.CreateButton(AHost, AHost, 'Salvar', LConfig);
end;

class procedure TButtonFactoryRunner.RenderGeometry(const AHost: TLayout);
var
  LConfig: TRickUIBuilderButtonConfig;
begin
  LConfig := TRickUIBuilderButtonConfig.Default;
  LConfig.Left := 24;
  LConfig.Top := 20;
  LConfig.Width := 210;
  LConfig.Height := 52;
  TRickUIBuilderFactory.CreateButton(AHost, AHost, 'Geometria', LConfig);
end;

class procedure TButtonFactoryRunner.RenderColors(const AHost: TLayout);
var
  LConfig: TRickUIBuilderButtonConfig;
begin
  LConfig := TRickUIBuilderButtonConfig.Default;
  LConfig.FillColor := TAlphaColors.Dodgerblue;
  LConfig.BorderColor := TAlphaColors.Gray;
  LConfig.TextColor := TAlphaColors.White;
  TRickUIBuilderFactory.CreateButton(AHost, AHost, 'Cores', LConfig);
end;

class procedure TButtonFactoryRunner.RenderTypography(const AHost: TLayout);
var
  LConfig: TRickUIBuilderButtonConfig;
begin
  LConfig := TRickUIBuilderButtonConfig.Default;
  LConfig.Width := 200;
  LConfig.Height := 50;
  LConfig.FontSize := 20;
  TRickUIBuilderFactory.CreateButton(AHost, AHost, 'Tipografia', LConfig);
end;

class procedure TButtonFactoryRunner.RenderIdentification(const AHost: TLayout);
var
  LButton: TRectangle;
  LTextLabel: TLabel;
  LConfig: TRickUIBuilderButtonConfig;
begin
  LConfig := TRickUIBuilderButtonConfig.Default;
  LConfig.Tag := 42;
  LButton := TRickUIBuilderFactory.CreateButton(AHost, AHost, 'Identificação',
    LConfig, LTextLabel);
  LTextLabel.Text := Format('Tag = %d', [LButton.Tag]);
end;

class procedure TButtonFactoryRunner.RenderCaptionAccess(const AHost: TLayout);
var
  LTextLabel: TLabel;
  LConfig: TRickUIBuilderButtonConfig;
begin
  LConfig := TRickUIBuilderButtonConfig.Default;
  TRickUIBuilderFactory.CreateButton(AHost, AHost, 'Caption original', LConfig,
    LTextLabel);
  LTextLabel.Text := 'Caption acessado';
end;

class procedure TButtonFactoryRunner.RenderClick(const AHost: TLayout);
var
  LButton: TRectangle;
  LFeedback: TButtonFactoryClickFeedback;
  LConfig: TRickUIBuilderButtonConfig;
begin
  LConfig := TRickUIBuilderButtonConfig.Default;
  LButton := TRickUIBuilderFactory.CreateButton(AHost, AHost, 'Clique aqui', LConfig);
  LFeedback := TButtonFactoryClickFeedback.Create(LButton);
  LButton.OnClick := LFeedback.ButtonClick;
end;

class procedure TButtonFactoryRunner.RenderComplete(const AHost: TLayout);
var
  LTextLabel: TLabel;
  LConfig: TRickUIBuilderButtonConfig;
begin
  LConfig := TRickUIBuilderButtonConfig.Default;
  LConfig.Left := 18;
  LConfig.Top := 20;
  LConfig.Width := 240;
  LConfig.Height := 54;
  LConfig.FillColor := TAlphaColors.Dodgerblue;
  LConfig.BorderColor := TAlphaColors.Gray;
  LConfig.TextColor := TAlphaColors.White;
  LConfig.Tag := 2026;
  LConfig.FontSize := 17;
  TRickUIBuilderFactory.CreateButton(AHost, AHost, 'Configuração completa',
    LConfig, LTextLabel);
end;

end.
