unit Rick.UIBuilder.Badge.Handle;
(*
  ==============================================================================
  Unit: Rick.UIBuilder.Badge.Handle
  ==============================================================================

  RESPONSABILIDADE

  Implementa exclusivamente IRickUIBuilderBadgeHandle: o resultado
  imutavel de um Badge criado por TRickUIBuilderBadgeBuilder.Build,
  encapsulando o Container (TRectangle) e o TextLabel (TLabel) interno.

  Esta unit NAO conhece TRickUIBuilderBadgeBuilder nem qualquer logica
  de construcao - representa somente o resultado ja criado, em
  observancia ao Principio de Responsabilidade Unica (SRP): "montar o
  Badge" e "representar o Badge montado" sao responsabilidades
  distintas e vivem em units distintas.

  ==============================================================================
*)

interface

uses
  FMX.Objects,
  FMX.StdCtrls,
  Rick.UIBuilder.Interfaces;

type
  /// <summary>
  ///    Implementacao de IRickUIBuilderBadgeHandle. Encapsula os dois
  ///    controles resultantes da criacao de um Badge: o Container
  ///    (TRectangle) e o TextLabel (TLabel) interno.
  /// </summary>
  TRickUIBuilderBadgeHandle = class(TInterfacedObject, IRickUIBuilderBadgeHandle)
  private
    FContainer : TRectangle;
    FTextLabel : TLabel;
  protected
    function Container: TRectangle;
    function TextLabel: TLabel;

    constructor Create(AContainer: TRectangle; ATextLabel: TLabel);
  public
    /// <summary>
    ///    Cria um handle a partir dos controles ja criados.
    /// </summary>
    /// <param name="AContainer">
    ///    Retangulo que forma o fundo do Badge.
    /// </param>
    /// <param name="ATextLabel">
    ///    Label de texto interno do Badge.
    /// </param>
    /// <returns>
    ///    Uma nova instancia de IRickUIBuilderBadgeHandle pronta para
    ///    encadeamento.
    /// </returns>
    class function New(AContainer: TRectangle; ATextLabel: TLabel): IRickUIBuilderBadgeHandle; static;
  end;

implementation

{ TRickUIBuilderBadgeHandle }

constructor TRickUIBuilderBadgeHandle.Create(AContainer: TRectangle;
  ATextLabel: TLabel);
begin
  inherited Create;
  FContainer := AContainer;
  FTextLabel := ATextLabel;
end;

class function TRickUIBuilderBadgeHandle.New(AContainer: TRectangle;
  ATextLabel: TLabel): IRickUIBuilderBadgeHandle;
begin
  Result := TRickUIBuilderBadgeHandle.Create(AContainer, ATextLabel);
end;

function TRickUIBuilderBadgeHandle.Container: TRectangle;
begin
  Result := FContainer;
end;

function TRickUIBuilderBadgeHandle.TextLabel: TLabel;
begin
  Result := FTextLabel;
end;

end.
