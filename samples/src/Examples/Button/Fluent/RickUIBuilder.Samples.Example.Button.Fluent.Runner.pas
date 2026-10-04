{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Example.Button.Fluent.Runner                          }
{                                                                              }
{ Esta unit executa os doze exemplos Button - Fluent Builder diretamente       }
{ no ResultHost, mantendo o Runner vivo durante a página para receber os       }
{ eventos funcionais sem componentes auxiliares.                               }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Executar os exemplos reais da abordagem Fluent Builder de Button.           }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Materializa Button por TRickUIBuilder.Button, demonstra uso direto e por    }
{  IRickUIBuilderButton, executa Hover/OnClick funcionais e cobre BuildHandle. }
{  Os dois exemplos completos exercitam os 23 métodos configuráveis da         }
{  interface principal; a variante por interfaces usa também Handle/HoverState.}
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - RickUIBuilder.Samples.App.Types                                           }
{      Fornece TButtonFluentExample usado para selecionar a execução.          }
{  - Rick.UIBuilder                                                            }
{      Fornece TRickUIBuilder.Button, entrada pública do Fluent Builder.       }
{  - Rick.UIBuilder.Interfaces                                                 }
{      Fornece as três interfaces públicas relacionadas ao Button.             }
{  - Rick.UIBuilder.Types                                                      }
{      Fornece TRickUIBuilderSpacing usado por Margin e Padding.               }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - TExampleButtonFluent mantém uma instância deste Runner durante sua vida.  }
{  - Cada método executa somente o exemplo selecionado.                        }
{  - O código executado permanece equivalente ao snippet de Fluent.Content.    }
{                                                                              }
{  Ownership / lifetime                                                        }
{  --------------------                                                        }
{  - O Runner é um objeto comum owned explicitamente por TExampleButtonFluent. }
{  - Seus handlers permanecem válidos enquanto a Sample Page estiver aberta.   }
{  - Build/BuildHandle recebem diretamente ResultHost como Parent.             }
{  - O behavior interno criado pelo builder segue o ownership definido pela    }
{    implementação pública atual de Rick.UIBuilder.Button.                     }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - Não cria container intermediário entre ResultHost e o Button.             }
{  - Não usa TComponent/InsertComponent para manter callbacks vivos.           }
{  - Não usa TRickUIBuilderButtonBuilder ou outras implementações concretas.   }
{  - Não cria navegação e não mantém conteúdo textual da Sample Page.          }
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Os valores, callbacks e a organização Fluent devem permanecer sincronizados }
{  com os snippets apresentados por Button.Fluent.Content.                     }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.Example.Button.Fluent.Runner;

interface

uses
  FMX.Layouts,
  RickUIBuilder.Samples.App.Types;

type
  /// <summary>Executa os resultados visuais e interativos dos exemplos Fluent de Button.</summary>
  TButtonFluentRunner = class sealed
  strict private
    procedure RenderFoundation(const AExample: TButtonFluentExample;
      const AHost: TLayout);
    procedure RenderPresentation(const AExample: TButtonFluentExample;
      const AHost: TLayout);
    procedure RenderInteraction(const AExample: TButtonFluentExample;
      const AHost: TLayout);
    procedure RenderBasic(const AHost: TLayout);
    procedure RenderInterface(const AHost: TLayout);
    procedure RenderGeometry(const AHost: TLayout);
    procedure RenderLayout(const AHost: TLayout);
    procedure RenderAppearance(const AHost: TLayout);
    procedure RenderTypography(const AHost: TLayout);
    procedure RenderState(const AHost: TLayout);
    procedure RenderHover(const AHost: TLayout);
    procedure RenderClick(const AHost: TLayout);
    procedure RenderResult(const AHost: TLayout);
    procedure RenderCompleteDirect(const AHost: TLayout);
    procedure RenderCompleteInterfaces(const AHost: TLayout);
    procedure ButtonClick(ASender: TObject);
    procedure MouseEnter(ASender: TObject);
    procedure MouseLeave(ASender: TObject);
  public
    procedure Render(const AExample: TButtonFluentExample; const AHost: TLayout);
  end;

implementation

uses
  System.UITypes,

  FMX.Types,
  FMX.Objects,

  Rick.UIBuilder,
  Rick.UIBuilder.Interfaces,
  Rick.UIBuilder.Types;

procedure TButtonFluentRunner.ButtonClick(ASender: TObject);
begin
  TRectangle(ASender).Fill.Color := TAlphaColors.Green;
end;

procedure TButtonFluentRunner.MouseEnter(ASender: TObject);
begin
  TRectangle(ASender).Stroke.Thickness := 4;
end;

procedure TButtonFluentRunner.MouseLeave(ASender: TObject);
begin
  TRectangle(ASender).Stroke.Thickness := 2;
end;

procedure TButtonFluentRunner.Render(const AExample: TButtonFluentExample;
  const AHost: TLayout);
begin
  if AExample <= TButtonFluentExample.Layout then
    RenderFoundation(AExample, AHost)
  else if AExample <= TButtonFluentExample.State then
    RenderPresentation(AExample, AHost)
  else
    RenderInteraction(AExample, AHost);
end;

procedure TButtonFluentRunner.RenderFoundation(
  const AExample: TButtonFluentExample; const AHost: TLayout);
begin
  case AExample of
    TButtonFluentExample.Basic: RenderBasic(AHost);
    TButtonFluentExample.InterfaceUsage: RenderInterface(AHost);
    TButtonFluentExample.Geometry: RenderGeometry(AHost);
    TButtonFluentExample.Layout: RenderLayout(AHost);
  end;
end;

procedure TButtonFluentRunner.RenderPresentation(
  const AExample: TButtonFluentExample; const AHost: TLayout);
begin
  case AExample of
    TButtonFluentExample.Appearance: RenderAppearance(AHost);
    TButtonFluentExample.Typography: RenderTypography(AHost);
    TButtonFluentExample.State: RenderState(AHost);
  end;
end;

procedure TButtonFluentRunner.RenderInteraction(
  const AExample: TButtonFluentExample; const AHost: TLayout);
begin
  case AExample of
    TButtonFluentExample.Hover: RenderHover(AHost);
    TButtonFluentExample.Click: RenderClick(AHost);
    TButtonFluentExample.ResultAccess: RenderResult(AHost);
    TButtonFluentExample.CompleteDirect: RenderCompleteDirect(AHost);
    TButtonFluentExample.CompleteInterfaces: RenderCompleteInterfaces(AHost);
  end;
end;

procedure TButtonFluentRunner.RenderBasic(const AHost: TLayout);
begin
  TRickUIBuilder
    .Button
      .Caption('Salvar')
        .Build(AHost);
end;

procedure TButtonFluentRunner.RenderInterface(const AHost: TLayout);
var
  LButton: IRickUIBuilderButton;
begin
  LButton := TRickUIBuilder.Button;

  LButton
    .Caption('Salvar pela interface')
      .Size(220, 52)
        .Build(AHost);
end;

procedure TButtonFluentRunner.RenderGeometry(const AHost: TLayout);
begin
  TRickUIBuilder
    .Button
      .Caption('Geometria')
        .Position(24, 20)
        .Size(210, 52)
          .Build(AHost);
end;

procedure TButtonFluentRunner.RenderLayout(const AHost: TLayout);
begin
  TRickUIBuilder
    .Button
      .Caption('Layout')
        .Position(16, 12)
        .Size(220, 52)
          .Anchors([TAnchorKind.akLeft, TAnchorKind.akTop])
          .Margin(TRickUIBuilderSpacing.Create(8, 6, 4, 2))
          .Padding(TRickUIBuilderSpacing.Create(10, 4, 6, 2))
            .Build(AHost);
end;

procedure TButtonFluentRunner.RenderAppearance(const AHost: TLayout);
begin
  TRickUIBuilder
    .Button
      .Caption('Aparência')
        .Size(220, 52)
          .CornerRadius(10)
            .FillColor(TAlphaColors.Dodgerblue)
            .BorderColor(TAlphaColors.Gray)
            .BorderThickness(2)
              .Build(AHost);
end;

procedure TButtonFluentRunner.RenderTypography(const AHost: TLayout);
begin
  TRickUIBuilder
    .Button
      .Caption('Tipografia')
        .Size(220, 52)
          .TextColor(TAlphaColors.White)
            .FontFamily('Segoe UI')
            .FontSize(18)
            .Bold(True)
              .Build(AHost);
end;

procedure TButtonFluentRunner.RenderState(const AHost: TLayout);
begin
  TRickUIBuilder
    .Button
      .Caption('Ativo')
        .Position(16, 12)
        .Size(220, 52)
          .Opacity(0.80)
          .Visible(True)
          .Cursor(crHandPoint)
          .Tag(501)
            .Build(AHost);

  TRickUIBuilder
    .Button
      .Caption('Desabilitado')
        .Position(16, 80)
        .Size(220, 52)
          .Enabled(False)
          .DisabledOpacity(0.35)
            .Build(AHost);
end;

procedure TButtonFluentRunner.RenderHover(const AHost: TLayout);
begin
  TRickUIBuilder
    .Button
      .Caption('Passe o mouse')
        .Size(220, 52)
          .FillColor(TAlphaColors.Dodgerblue)
          .BorderColor(TAlphaColors.Gray)
          .BorderThickness(2)
            .HoverFillColor(TAlphaColors.Green)
              .OnHover(MouseEnter, MouseLeave)
                .Build(AHost);
end;

procedure TButtonFluentRunner.RenderClick(const AHost: TLayout);
begin
  TRickUIBuilder
    .Button
      .Caption('Clique aqui')
        .Size(220, 52)
          .OnClick(ButtonClick)
            .Build(AHost);
end;

procedure TButtonFluentRunner.RenderResult(const AHost: TLayout);
var
  LHandle: IRickUIBuilderButtonHandle;
begin
  LHandle := TRickUIBuilder
    .Button
      .Caption('Caption original')
        .Size(220, 52)
          .BuildHandle(AHost);

  LHandle.TextLabel.Text := 'Caption acessado';
end;

procedure TButtonFluentRunner.RenderCompleteDirect(const AHost: TLayout);
begin
  TRickUIBuilder
    .Button
      .Caption('Configuração completa')
        .Position(18, 20)
        .Size(280, 62)
          .Anchors([TAnchorKind.akLeft, TAnchorKind.akTop])
          .Margin(TRickUIBuilderSpacing.Create(12, 8, 4, 2))
          .Padding(TRickUIBuilderSpacing.Create(8, 4, 6, 2))
            .CornerRadius(14)
            .FillColor(TAlphaColors.Dodgerblue)
            .BorderColor(TAlphaColors.Gray)
            .BorderThickness(2)
              .TextColor(TAlphaColors.White)
              .FontFamily('Segoe UI')
              .FontSize(17)
              .Bold(True)
                .HoverFillColor(TAlphaColors.Green)
                .DisabledOpacity(0.45)
                .Enabled(True)
                .Cursor(crHandPoint)
                .Opacity(0.92)
                .Visible(True)
                .Tag(2026)
                  .OnClick(ButtonClick)
                  .OnHover(MouseEnter, MouseLeave)
                    .Build(AHost);
end;

procedure TButtonFluentRunner.RenderCompleteInterfaces(const AHost: TLayout);
var
  LButton: IRickUIBuilderButton;
  LHandle: IRickUIBuilderButtonHandle;
  LHoverState: IRickUIBuilderButtonHoverState;
begin
  LButton := TRickUIBuilder.Button;

  LHandle := LButton
    .Caption('Completo com interfaces')
      .Position(18, 20)
      .Size(280, 62)
        .Anchors([TAnchorKind.akLeft, TAnchorKind.akTop])
        .Margin(TRickUIBuilderSpacing.Create(12, 8, 4, 2))
        .Padding(TRickUIBuilderSpacing.Create(8, 4, 6, 2))
          .CornerRadius(14)
          .FillColor(TAlphaColors.Dodgerblue)
          .BorderColor(TAlphaColors.Gray)
          .BorderThickness(2)
            .TextColor(TAlphaColors.White)
            .FontFamily('Segoe UI')
            .FontSize(17)
            .Bold(True)
              .HoverFillColor(TAlphaColors.Green)
              .DisabledOpacity(0.45)
              .Enabled(True)
              .Cursor(crHandPoint)
              .Opacity(0.92)
              .Visible(True)
              .Tag(2026)
                .OnClick(ButtonClick)
                .OnHover(MouseEnter, MouseLeave)
                  .BuildHandle(AHost);

  LHandle.TextLabel.Text := 'Interfaces completas';
  LHoverState := LHandle.HoverState;
  LHoverState
    .FillColor(TAlphaColors.Dodgerblue)
      .HoverFillColor(TAlphaColors.Green)
        .OnEnter(MouseEnter)
        .OnLeave(MouseLeave);
end;

end.
