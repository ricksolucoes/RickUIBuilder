unit Rick.UIBuilder.Edit.VisualState;

interface

uses
  System.Classes,

  FMX.Edit;

type
  TRickUIBuilderEditVisualState = class(TComponent)
  private
    FHandlers: array of TNotifyEvent;
    FKeepAlive: array of IInterface;
    FFocused: Boolean;
    FInvalid: Boolean;
    FReadOnly: Boolean;
    procedure ExecuteHandlers;
    procedure HandleEnter(ASender: TObject);
    procedure HandleExit(ASender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Attach(AOwner: TComponent);
    procedure Bind(AControl: TEdit);
    procedure RegisterHandler(AHandler: TNotifyEvent; const AKeepAlive: IInterface);
    procedure SetInvalid(AValue: Boolean);
    procedure SetReadOnly(AValue: Boolean);
    function IsFocused: Boolean;
    function IsInvalid: Boolean;
    function IsReadOnly: Boolean;
    procedure Apply;
  end;

implementation

constructor TRickUIBuilderEditVisualState.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SetLength(FHandlers, 0);
  SetLength(FKeepAlive, 0);
end;

destructor TRickUIBuilderEditVisualState.Destroy;
begin
  SetLength(FHandlers, 0);
  SetLength(FKeepAlive, 0);
  inherited;
end;

procedure TRickUIBuilderEditVisualState.Attach(AOwner: TComponent);
begin
  if not Assigned(Owner) then
    AOwner.InsertComponent(Self);
end;

procedure TRickUIBuilderEditVisualState.Bind(AControl: TEdit);
begin
  AControl.OnEnter := HandleEnter;
  AControl.OnExit := HandleExit;
end;

procedure TRickUIBuilderEditVisualState.RegisterHandler(AHandler: TNotifyEvent; const AKeepAlive: IInterface);
begin
  SetLength(FHandlers, Length(FHandlers) + 1);
  SetLength(FKeepAlive, Length(FKeepAlive) + 1);
  FHandlers[High(FHandlers)] := AHandler;
  FKeepAlive[High(FKeepAlive)] := AKeepAlive;
end;

procedure TRickUIBuilderEditVisualState.SetInvalid(AValue: Boolean);
begin
  FInvalid := AValue;
  Apply;
end;

procedure TRickUIBuilderEditVisualState.SetReadOnly(AValue: Boolean);
begin
  FReadOnly := AValue;
  Apply;
end;

function TRickUIBuilderEditVisualState.IsFocused: Boolean;
begin
  Result := FFocused;
end;

function TRickUIBuilderEditVisualState.IsInvalid: Boolean;
begin
  Result := FInvalid;
end;

function TRickUIBuilderEditVisualState.IsReadOnly: Boolean;
begin
  Result := FReadOnly;
end;

procedure TRickUIBuilderEditVisualState.HandleEnter(ASender: TObject);
begin
  FFocused := True;
  Apply;
end;

procedure TRickUIBuilderEditVisualState.HandleExit(ASender: TObject);
begin
  FFocused := False;
  Apply;
end;

procedure TRickUIBuilderEditVisualState.ExecuteHandlers;
var
  LIndex: Integer;
begin
  for LIndex := 0 to High(FHandlers) do
    FHandlers[LIndex](Self);
end;

procedure TRickUIBuilderEditVisualState.Apply;
begin
  ExecuteHandlers;
end;

end.
