{******************************************************************************}
{                                                                              }
{  RickUIBuilder.Samples.Example.Common.Navigation                             }
{                                                                              }
{ Esta unit implementa a navegação lateral reutilizável usando o layout        }
{ efetivo recebido da Sample Page Base e preservando seleção/scroll comuns.    }
{                                                                              }
{  Finalidade                                                                  }
{  ----------                                                                  }
{  Encapsular a navegação lateral reutilizável da Sample Page Base.            }
{                                                                              }
{  Funcionalidade                                                              }
{  --------------                                                              }
{  Materializa a superfície lateral, o scroll vertical, os itens de navegação  }
{  e o estado visual selecionado usando o TExamplePageLayout efetivo recebido  }
{  da Sample Page Base.                                                        }
{                                                                              }
{  Dependências do projeto                                                     }
{  -----------------------                                                     }
{  - RickUIBuilder.Samples.App.Typography                                      }
{      Fornece o token tipográfico dos itens de navegação.                     }
{  - RickUIBuilder.Samples.Example.Common.Style                                }
{      Fornece TExamplePageLayout, espaçamentos e cores da navegação.      }
{                                                                              }
{  Fluxo / colaboração                                                         }
{  -------------------                                                         }
{  - TExampleCommon cria TExampleNavigation e delega AddItem/SelectItem.       }
{  - A página derivada associa a ação do item retornado por AddItem.           }
{                                                                              }
{  Ownership / lifetime                                                        }
{  --------------------                                                        }
{  - A navegação é owned pelo body da página.                                  }
{  - O scroll e os itens são owned pela própria árvore visual da navegação.    }
{                                                                              }
{  Restrições e responsabilidades                                              }
{  -----------------------------                                               }
{  - Não conhece categorias fixas nem significado funcional dos itens.         }
{  - Selecionar um item altera somente seu estado visual.                      }
{  - TTextAlign exige FMX.Types e TBrushKind exige FMX.Graphics explicitamente.}
{                                                                              }
{  Manutenção                                                                  }
{  ----------                                                                  }
{  Este cabeçalho deve ser atualizado quando responsabilidade, dependências,   }
{  fluxo, ownership/lifetime ou restrições desta unit mudarem.                 }
{                                                                              }
{******************************************************************************}

unit RickUIBuilder.Samples.Example.Common.Navigation;

interface

uses
  System.Classes,
  FMX.Layouts,
  FMX.Objects,

  RickUIBuilder.Samples.Example.Common.Style;

type
  /// <summary>Item visual reutilizável da navegação lateral.</summary>
  TExampleNavigationItem = class(TRectangle)
  strict private
    FSelectionIndicator: TRectangle;
    FLabel: TText;
    procedure ConfigureSurface;
    procedure BuildSelectionIndicator(const AHeight: Single);
    procedure BuildLabel;
  public
    constructor Create(AOwner: TComponent; const AIndicatorHeight: Single); reintroduce;
    procedure SetCaption(const ACaption: string);
    procedure SetSelected(const ASelected: Boolean);
  end;

  /// <summary>Container rolável responsável pela navegação lateral comum.</summary>
  TExampleNavigation = class(TRectangle)
  strict private
    FLayout: TExamplePageLayout;
    FHost: TVertScrollBox;
    FSelectedItem: TExampleNavigationItem;
    FItemTop: Single;
    procedure ConfigureSurface;
    procedure BuildHost;
  public
    constructor Create(AOwner: TComponent;
      const ALayout: TExamplePageLayout); reintroduce;
    function AddItem(const ACaption: string): TExampleNavigationItem;
    procedure SelectItem(const AItem: TExampleNavigationItem);
  end;

implementation

uses
  System.UITypes,
  FMX.Graphics,
  FMX.Types,
  RickUIBuilder.Samples.App.Typography;

{ TExampleNavigationItem }

constructor TExampleNavigationItem.Create(AOwner: TComponent;
  const AIndicatorHeight: Single);
begin
  inherited Create(AOwner);
  ConfigureSurface;
  BuildSelectionIndicator(AIndicatorHeight);
  BuildLabel;
end;

procedure TExampleNavigationItem.ConfigureSurface;
begin
  Fill.Kind := TBrushKind.Solid;
  Fill.Color := _EXAMPLE_PAGE_SURFACE_BACKGROUND_;
  Stroke.Kind := TBrushKind.None;
  XRadius := _EXAMPLE_PAGE_NAV_ITEM_RADIUS_;
  YRadius := _EXAMPLE_PAGE_NAV_ITEM_RADIUS_;
  Cursor := crHandPoint;
end;

procedure TExampleNavigationItem.BuildSelectionIndicator(
  const AHeight: Single);
begin
  FSelectionIndicator := TRectangle.Create(Self);
  FSelectionIndicator.Parent := Self;
  FSelectionIndicator.SetBounds(0, _EXAMPLE_PAGE_NAV_INDICATOR_TOP_,
    _EXAMPLE_PAGE_NAV_INDICATOR_WIDTH_, AHeight);
  FSelectionIndicator.Fill.Kind := TBrushKind.Solid;
  FSelectionIndicator.Fill.Color := _EXAMPLE_PAGE_PRIMARY_;
  FSelectionIndicator.Stroke.Kind := TBrushKind.None;
  FSelectionIndicator.HitTest := False;
  FSelectionIndicator.Visible := False;
end;

procedure TExampleNavigationItem.BuildLabel;
begin
  FLabel := TText.Create(Self);
  FLabel.Parent := Self;
  FLabel.Align := TAlignLayout.Client;
  FLabel.Margins.Left := 10;
  FLabel.Margins.Right := 8;
  FLabel.TextSettings.Font.Size := _FONT_SIZE_NAVIGATION_;
  FLabel.TextSettings.FontColor := _EXAMPLE_PAGE_TEXT_SECONDARY_;
  FLabel.TextSettings.HorzAlign := TTextAlign.Leading;
  FLabel.TextSettings.VertAlign := TTextAlign.Center;
  FLabel.HitTest := False;
end;

procedure TExampleNavigationItem.SetCaption(const ACaption: string);
begin
  FLabel.Text := ACaption;
end;

procedure TExampleNavigationItem.SetSelected(const ASelected: Boolean);
begin
  Fill.Color := _EXAMPLE_PAGE_SURFACE_BACKGROUND_;
  FLabel.TextSettings.FontColor := _EXAMPLE_PAGE_TEXT_SECONDARY_;
  FLabel.TextSettings.Font.Style := [];
  FSelectionIndicator.Visible := ASelected;
  if not ASelected then
    Exit;
  Fill.Color := _EXAMPLE_PAGE_NAV_SELECTED_BACKGROUND_;
  FLabel.TextSettings.FontColor := _EXAMPLE_PAGE_PRIMARY_;
end;

{ TExampleNavigation }

constructor TExampleNavigation.Create(AOwner: TComponent;
  const ALayout: TExamplePageLayout);
begin
  inherited Create(AOwner);
  FLayout := ALayout;
  ConfigureSurface;
  BuildHost;
end;

procedure TExampleNavigation.ConfigureSurface;
begin
  SetBounds(0, 0, FLayout.NavigationWidth, FLayout.BodyHeight);
  Fill.Kind := TBrushKind.Solid;
  Fill.Color := _EXAMPLE_PAGE_SURFACE_BACKGROUND_;
  Stroke.Kind := TBrushKind.Solid;
  Stroke.Color := _EXAMPLE_PAGE_BORDER_;
end;

procedure TExampleNavigation.BuildHost;
begin
  FHost := TVertScrollBox.Create(Self);
  FHost.Parent := Self;
  FHost.SetBounds(_EXAMPLE_PAGE_NAV_PADDING_, _EXAMPLE_PAGE_NAV_PADDING_,
    FLayout.NavigationItemWidth,
    FLayout.BodyHeight - (_EXAMPLE_PAGE_NAV_PADDING_ * 2));
  FItemTop := 0;
end;

function TExampleNavigation.AddItem(
  const ACaption: string): TExampleNavigationItem;
begin
  Result := TExampleNavigationItem.Create(FHost,
    FLayout.NavigationIndicatorHeight);
  Result.Parent := FHost;
  Result.SetBounds(0, FItemTop, FLayout.NavigationItemWidth,
    FLayout.NavigationItemHeight);
  Result.SetCaption(ACaption);
  FItemTop := FItemTop + FLayout.NavigationItemHeight +
    _EXAMPLE_PAGE_NAV_ITEM_GAP_;
end;

procedure TExampleNavigation.SelectItem(const AItem: TExampleNavigationItem);
begin
  if Assigned(FSelectedItem) then
    FSelectedItem.SetSelected(False);
  FSelectedItem := AItem;
  if Assigned(FSelectedItem) then
    FSelectedItem.SetSelected(True);
end;

end.
