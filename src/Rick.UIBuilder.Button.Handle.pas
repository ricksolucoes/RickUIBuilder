unit Rick.UIBuilder.Button.Handle;
(*
  ==============================================================================
  Unit: Rick.UIBuilder.Button.Handle
  ==============================================================================

  RESPONSABILIDADE

  Implementa IRickUIBuilderButtonHandle, que representa o acesso pos-Build
  produzido pela criacao de um Button: Container (TRectangle), TextLabel
  (TLabel) e, quando disponivel, o HoverState associado.

  O handle nao possui os controles. O ownership e o lifetime permanecem sob
  responsabilidade dos Owners informados na criacao pelo Rick.UIBuilder.

  ==============================================================================
*)

interface

uses
  FMX.Objects,
  FMX.StdCtrls,
  Rick.UIBuilder.Interfaces;

type
  /// <summary>
  ///    Implementacao non-owning de IRickUIBuilderButtonHandle.
  /// </summary>
  /// <remarks>
  ///    A interface controla somente o lifetime do proprio handle. As
  ///    referencias armazenadas nao mantem os controles FMX vivos.
  /// </remarks>
  TRickUIBuilderButtonHandle = class(TInterfacedObject, IRickUIBuilderButtonHandle)
  private
    FContainer: TRectangle;
    FTextLabel: TLabel;
    FHoverState: IRickUIBuilderButtonHoverState;
  protected
    function Container: TRectangle;
    function TextLabel: TLabel;
    function HoverState: IRickUIBuilderButtonHoverState;

    constructor Create(AContainer: TRectangle; ATextLabel: TLabel); overload;
    constructor Create(AContainer: TRectangle; ATextLabel: TLabel;
      const AHoverState: IRickUIBuilderButtonHoverState); overload;
  public
    /// <summary>
    ///    Cria um handle para referencias de controles ja existentes.
    /// </summary>
    /// <param name="AContainer">
    ///    TRectangle criado para o Button.
    /// </param>
    /// <param name="ATextLabel">
    ///    TLabel de Caption criado para o Button.
    /// </param>
    /// <returns>
    ///    Um IRickUIBuilderButtonHandle que nao assume ownership dos
    ///    controles recebidos.
    /// </returns>
    class function New(AContainer: TRectangle;
      ATextLabel: TLabel): IRickUIBuilderButtonHandle; overload; static;

    /// <summary>
    ///    Cria um handle para controles existentes e o HoverState associado.
    /// </summary>
    /// <param name="AContainer">TRectangle criado para o Button.</param>
    /// <param name="ATextLabel">TLabel de Caption criado para o Button.</param>
    /// <param name="AHoverState">
    ///    Estado de hover utilizado pelo behavior materializado do Button.
    /// </param>
    /// <returns>
    ///    Um IRickUIBuilderButtonHandle non-owning em relacao aos controles.
    /// </returns>
    class function New(AContainer: TRectangle; ATextLabel: TLabel;
      const AHoverState: IRickUIBuilderButtonHoverState):
      IRickUIBuilderButtonHandle; overload; static;
  end;

implementation

{ TRickUIBuilderButtonHandle }

constructor TRickUIBuilderButtonHandle.Create(AContainer: TRectangle;
  ATextLabel: TLabel);
begin
  inherited Create;
  FContainer := AContainer;
  FTextLabel := ATextLabel;
  FHoverState := nil;
end;

constructor TRickUIBuilderButtonHandle.Create(AContainer: TRectangle;
  ATextLabel: TLabel; const AHoverState: IRickUIBuilderButtonHoverState);
begin
  inherited Create;
  FContainer := AContainer;
  FTextLabel := ATextLabel;
  FHoverState := AHoverState;
end;

class function TRickUIBuilderButtonHandle.New(AContainer: TRectangle;
  ATextLabel: TLabel): IRickUIBuilderButtonHandle;
begin
  Result := TRickUIBuilderButtonHandle.Create(AContainer, ATextLabel);
end;

class function TRickUIBuilderButtonHandle.New(AContainer: TRectangle;
  ATextLabel: TLabel; const AHoverState: IRickUIBuilderButtonHoverState):
  IRickUIBuilderButtonHandle;
begin
  Result := TRickUIBuilderButtonHandle.Create(AContainer, ATextLabel,
    AHoverState);
end;

function TRickUIBuilderButtonHandle.Container: TRectangle;
begin
  Result := FContainer;
end;

function TRickUIBuilderButtonHandle.TextLabel: TLabel;
begin
  Result := FTextLabel;
end;

function TRickUIBuilderButtonHandle.HoverState: IRickUIBuilderButtonHoverState;
begin
  Result := FHoverState;
end;

end.
