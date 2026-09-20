unit Rick.UIBuilder.Button.Handle;
(*
  ==============================================================================
  Unit: Rick.UIBuilder.Button.Handle
  ==============================================================================

  RESPONSABILIDADE

  Implementa IRickUIBuilderButtonHandle, que representa as duas referencias
  produzidas pela criacao de um Button: Container (TRectangle) e TextLabel
  (TLabel).

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
  protected
    function Container: TRectangle;
    function TextLabel: TLabel;

    constructor Create(AContainer: TRectangle; ATextLabel: TLabel);
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
      ATextLabel: TLabel): IRickUIBuilderButtonHandle; static;
  end;

implementation

{ TRickUIBuilderButtonHandle }

constructor TRickUIBuilderButtonHandle.Create(AContainer: TRectangle;
  ATextLabel: TLabel);
begin
  inherited Create;
  FContainer := AContainer;
  FTextLabel := ATextLabel;
end;

class function TRickUIBuilderButtonHandle.New(AContainer: TRectangle;
  ATextLabel: TLabel): IRickUIBuilderButtonHandle;
begin
  Result := TRickUIBuilderButtonHandle.Create(AContainer, ATextLabel);
end;

function TRickUIBuilderButtonHandle.Container: TRectangle;
begin
  Result := FContainer;
end;

function TRickUIBuilderButtonHandle.TextLabel: TLabel;
begin
  Result := FTextLabel;
end;

end.
