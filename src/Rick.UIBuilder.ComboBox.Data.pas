unit Rick.UIBuilder.ComboBox.Data;
(*
  ============================================================================
  Unit: Rick.UIBuilder.ComboBox.Data
  ============================================================================

  RESPONSABILIDADE

  Mantem exclusivamente o modelo logico de itens e selecao do ComboBox.
  Nao conhece controles FMX, popup, virtualizacao ou lifecycle visual.

  DisplayText e a representacao visual primaria, Value e um valor semantico
  sem requisito de unicidade e ItemIndex representa a posicao selecionada.
  ============================================================================
*)

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  Rick.UIBuilder.Types;

type
  TRickUIBuilderComboBoxData = class
  strict private
    FItems: TList<TRickUIBuilderComboBoxItem>;
    FItemIndex: Integer;
    function IsValidIndex(AIndex: Integer): Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(const AItem: TRickUIBuilderComboBoxItem);
    procedure AddText(const AText: string);
    procedure AddRange(const AItems: array of string); overload;
    procedure AddRange(
      const AItems: array of TRickUIBuilderComboBoxItem); overload;
    function Count: Integer;
    function Item(AIndex: Integer): TRickUIBuilderComboBoxItem;
    function ItemIndex: Integer;
    function SelectedText: string;
    function SelectedValue: string;
    function SelectIndex(AIndex: Integer): Boolean;
    function TrySelectText(const AText: string): Boolean;
    function FindPrefix(const APrefix: string): Integer;
  end;

implementation

constructor TRickUIBuilderComboBoxData.Create;
begin
  inherited Create;
  FItems := TList<TRickUIBuilderComboBoxItem>.Create;
  FItemIndex := -1;
end;

destructor TRickUIBuilderComboBoxData.Destroy;
begin
  FItems.Free;
  inherited;
end;

procedure TRickUIBuilderComboBoxData.Add(
  const AItem: TRickUIBuilderComboBoxItem);
begin
  FItems.Add(AItem);
end;

procedure TRickUIBuilderComboBoxData.AddText(const AText: string);
begin
  Add(TRickUIBuilderComboBoxItem.Create(AText));
end;

procedure TRickUIBuilderComboBoxData.AddRange(const AItems: array of string);
var
  LItem: string;
begin
  for LItem in AItems do
    AddText(LItem);
end;

procedure TRickUIBuilderComboBoxData.AddRange(
  const AItems: array of TRickUIBuilderComboBoxItem);
var
  LItem: TRickUIBuilderComboBoxItem;
begin
  for LItem in AItems do
    Add(LItem);
end;

function TRickUIBuilderComboBoxData.Count: Integer;
begin
  Result := FItems.Count;
end;

function TRickUIBuilderComboBoxData.IsValidIndex(AIndex: Integer): Boolean;
begin
  Result := (AIndex >= 0) and (AIndex < FItems.Count);
end;

function TRickUIBuilderComboBoxData.Item(
  AIndex: Integer): TRickUIBuilderComboBoxItem;
begin
  if not IsValidIndex(AIndex) then
    raise EArgumentOutOfRangeException.CreateFmt(
      'ComboBox item index %d is invalid', [AIndex]);
  Result := FItems[AIndex];
end;

function TRickUIBuilderComboBoxData.ItemIndex: Integer;
begin
  Result := FItemIndex;
end;

function TRickUIBuilderComboBoxData.SelectedText: string;
begin
  Result := '';
  if IsValidIndex(FItemIndex) then
    Result := FItems[FItemIndex].DisplayText;
end;

function TRickUIBuilderComboBoxData.SelectedValue: string;
begin
  Result := '';
  if IsValidIndex(FItemIndex) then
    Result := FItems[FItemIndex].Value;
end;

function TRickUIBuilderComboBoxData.SelectIndex(AIndex: Integer): Boolean;
begin
  Result := (AIndex = -1) or IsValidIndex(AIndex);
  if Result then
    FItemIndex := AIndex;
end;

function TRickUIBuilderComboBoxData.TrySelectText(
  const AText: string): Boolean;
var
  LIndex: Integer;
begin
  Result := False;
  for LIndex := 0 to FItems.Count - 1 do
    if SameText(FItems[LIndex].DisplayText, AText) then
    begin
      FItemIndex := LIndex;
      Exit(True);
    end;
end;

function TRickUIBuilderComboBoxData.FindPrefix(const APrefix: string): Integer;
var
  LIndex: Integer;
begin
  Result := -1;
  if APrefix = '' then
    Exit;

  for LIndex := 0 to FItems.Count - 1 do
    if SameText(Copy(FItems[LIndex].DisplayText, 1, Length(APrefix)), APrefix) then
      Exit(LIndex);
end;

end.
