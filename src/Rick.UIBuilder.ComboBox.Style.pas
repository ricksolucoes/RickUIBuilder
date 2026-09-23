unit Rick.UIBuilder.ComboBox.Style;
(*
  ============================================================================
  Unit: Rick.UIBuilder.ComboBox.Style
  ============================================================================

  RESPONSABILIDADE

  Resolve RequestedStyleType em EffectiveStyleType e, em etapa separada,
  resolve PresentationMode.Auto. Nao contem estado visual ou dados.
  ============================================================================
*)

interface

uses
  Rick.UIBuilder.Types;

type
  TRickUIBuilderComboBoxStyleResolver = class sealed
  strict private
    class function AdaptiveStyle: TRickUIBuilderComboBoxStyleType; static;
    class procedure ApplyDesktopDefaults(
      var AConfig: TRickUIBuilderComboBoxConfig); static;
    class procedure ApplyMobileDefaults(
      var AConfig: TRickUIBuilderComboBoxConfig); static;
    class procedure ResolvePresentation(
      var AConfig: TRickUIBuilderComboBoxConfig); static;
  public
    class function Resolve(const AConfig: TRickUIBuilderComboBoxConfig):
      TRickUIBuilderComboBoxConfig; static;
  end;

implementation

class function TRickUIBuilderComboBoxStyleResolver.AdaptiveStyle:
  TRickUIBuilderComboBoxStyleType;
begin
{$IF Defined(ANDROID) or Defined(IOS)}
  Result := TRickUIBuilderComboBoxStyleType.Mobile;
{$ELSE}
  Result := TRickUIBuilderComboBoxStyleType.Desktop;
{$ENDIF}
end;

class procedure TRickUIBuilderComboBoxStyleResolver.ApplyDesktopDefaults(
  var AConfig: TRickUIBuilderComboBoxConfig);
begin
  AConfig.Height := 40;
  AConfig.ItemHeight := 36;
  AConfig.HorizontalPadding := 12;
  AConfig.ArrowSize := 20;
end;

class procedure TRickUIBuilderComboBoxStyleResolver.ApplyMobileDefaults(
  var AConfig: TRickUIBuilderComboBoxConfig);
begin
  AConfig.Height := 48;
  AConfig.ItemHeight := 48;
  AConfig.HorizontalPadding := 16;
  AConfig.ArrowSize := 22;
end;

class procedure TRickUIBuilderComboBoxStyleResolver.ResolvePresentation(
  var AConfig: TRickUIBuilderComboBoxConfig);
begin
  if AConfig.PresentationMode <> TRickUIBuilderComboBoxPresentationMode.Auto then
    Exit;

  if AConfig.EffectiveStyleType = TRickUIBuilderComboBoxStyleType.Mobile then
    AConfig.PresentationMode := TRickUIBuilderComboBoxPresentationMode.Overlay
  else
    AConfig.PresentationMode := TRickUIBuilderComboBoxPresentationMode.Anchored;
end;

class function TRickUIBuilderComboBoxStyleResolver.Resolve(
  const AConfig: TRickUIBuilderComboBoxConfig): TRickUIBuilderComboBoxConfig;
begin
  Result := AConfig;
  Result.EffectiveStyleType := AConfig.RequestedStyleType;

  if Result.EffectiveStyleType = TRickUIBuilderComboBoxStyleType.Adaptive then
    Result.EffectiveStyleType := AdaptiveStyle;

  case Result.EffectiveStyleType of
    TRickUIBuilderComboBoxStyleType.Desktop:
      ApplyDesktopDefaults(Result);
    TRickUIBuilderComboBoxStyleType.Mobile:
      ApplyMobileDefaults(Result);
  end;

  ResolvePresentation(Result);
end;

end.
