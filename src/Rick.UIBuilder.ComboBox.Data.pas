unit Rick.UIBuilder.ComboBox.Data;
(*
  ============================================================================
  Unit: Rick.UIBuilder.ComboBox.Data
  ============================================================================

  RESPONSABILIDADE

  Mantem exclusivamente o modelo logico de itens, selecao e a view filtrada
  do ComboBox. Nao conhece controles FMX, presentation ou lifecycle visual.

  DisplayText e a representacao visual primaria, Value e um valor semantico
  sem requisito de unicidade e ItemIndex representa a posicao selecionada na
  colecao original. A pesquisa cria apenas um mapeamento ViewIndex ->
  SourceIndex; a colecao original nunca e removida ou reordenada pelo filtro.
  ============================================================================
*)

interface

uses
  System.SysUtils,
  System.StrUtils,
  System.Generics.Collections,
  Rick.UIBuilder.Types;

type
  TRickUIBuilderComboBoxData = class
  strict private
    FItems: TList<TRickUIBuilderComboBoxItem>;
    FFilteredIndexes: TList<Integer>;
    FItemIndex: Integer;
    FFilterText: string;
    function IsValidIndex(AIndex: Integer): Boolean;
    function HasFilter: Boolean;
    procedure RebuildFilter;
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
    procedure SetFilterText(const AText: string);
    procedure ClearFilter;
    function FilterText: string;
    function ViewCount: Integer;
    function ViewItem(AViewIndex: Integer): TRickUIBuilderComboBoxItem;
    function SourceIndexFromView(AViewIndex: Integer): Integer;
    function ViewIndexFromSource(ASourceIndex: Integer): Integer;
  end;

implementation

constructor TRickUIBuilderComboBoxData.Create;
begin
  inherited Create;
  FItems := TList<TRickUIBuilderComboBoxItem>.Create;
  FFilteredIndexes := TList<Integer>.Create;
  FItemIndex := -1;
end;

destructor TRickUIBuilderComboBoxData.Destroy;
begin
  FFilteredIndexes.Free;
  FItems.Free;
  inherited;
end;

function TRickUIBuilderComboBoxData.HasFilter: Boolean;
begin
  Result := FFilterText <> '';
end;

procedure TRickUIBuilderComboBoxData.RebuildFilter;
var
  LIndex: Integer;
begin
  FFilteredIndexes.Clear;
  if not HasFilter then
    Exit;

  for LIndex := 0 to FItems.Count - 1 do
    if ContainsText(FItems[LIndex].DisplayText, FFilterText) then
      FFilteredIndexes.Add(LIndex);
end;

procedure TRickUIBuilderComboBoxData.Add(
  const AItem: TRickUIBuilderComboBoxItem);
begin
  FItems.Add(AItem);
  if HasFilter then
    RebuildFilter;
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
    FItems.Add(TRickUIBuilderComboBoxItem.Create(LItem));
  if HasFilter then
    RebuildFilter;
end;

procedure TRickUIBuilderComboBoxData.AddRange(
  const AItems: array of TRickUIBuilderComboBoxItem);
var
  LItem: TRickUIBuilderComboBoxItem;
begin
  for LItem in AItems do
    FItems.Add(LItem);
  if HasFilter then
    RebuildFilter;
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

procedure TRickUIBuilderComboBoxData.SetFilterText(const AText: string);
begin
  FFilterText := AText;
  RebuildFilter;
end;

procedure TRickUIBuilderComboBoxData.ClearFilter;
begin
  if FFilterText = '' then
    Exit;
  FFilterText := '';
  FFilteredIndexes.Clear;
end;

function TRickUIBuilderComboBoxData.FilterText: string;
begin
  Result := FFilterText;
end;

function TRickUIBuilderComboBoxData.ViewCount: Integer;
begin
  if HasFilter then
    Result := FFilteredIndexes.Count
  else
    Result := FItems.Count;
end;

function TRickUIBuilderComboBoxData.SourceIndexFromView(
  AViewIndex: Integer): Integer;
begin
  Result := -1;
  if (AViewIndex < 0) or (AViewIndex >= ViewCount) then
    Exit;
  if HasFilter then
    Result := FFilteredIndexes[AViewIndex]
  else
    Result := AViewIndex;
end;

function TRickUIBuilderComboBoxData.ViewIndexFromSource(
  ASourceIndex: Integer): Integer;
begin
  Result := -1;
  if not IsValidIndex(ASourceIndex) then
    Exit;
  if not HasFilter then
    Exit(ASourceIndex);
  Result := FFilteredIndexes.IndexOf(ASourceIndex);
end;

function TRickUIBuilderComboBoxData.ViewItem(
  AViewIndex: Integer): TRickUIBuilderComboBoxItem;
var
  LSourceIndex: Integer;
begin
  LSourceIndex := SourceIndexFromView(AViewIndex);
  Result := Item(LSourceIndex);
end;

end.
