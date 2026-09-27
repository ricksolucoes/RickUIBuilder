unit Rick.UIBuilder.Edit.Handle;

interface

uses
  FMX.Objects,
  FMX.Edit,
  Rick.UIBuilder.Interfaces,
  Rick.UIBuilder.Edit.Behavior;

type
  TRickUIBuilderEditHandle = class(TInterfacedObject, IRickUIBuilderEditHandle)
  strict private
    FContainer: TRectangle;
    FEdit: TEdit;
    FBehavior: TRickUIBuilderEditBehavior;
  protected
    function Container: TRectangle;
    function EditControl: TEdit;
    function Text: string; overload;
    procedure Text(const AValue: string); overload;
    procedure Clear;
    procedure SetInvalid(AValue: Boolean; const AMessage: string = '');
    procedure SetRequirementMet(AValue: Boolean);
  public
    constructor Create(AContainer: TRectangle; AEdit: TEdit;
      ABehavior: TRickUIBuilderEditBehavior);
    class function New(AContainer: TRectangle; AEdit: TEdit;
      ABehavior: TRickUIBuilderEditBehavior): IRickUIBuilderEditHandle; static;
  end;

implementation

constructor TRickUIBuilderEditHandle.Create(AContainer: TRectangle;
  AEdit: TEdit; ABehavior: TRickUIBuilderEditBehavior);
begin
  inherited Create;
  FContainer := AContainer;
  FEdit := AEdit;
  FBehavior := ABehavior;
end;

class function TRickUIBuilderEditHandle.New(AContainer: TRectangle;
  AEdit: TEdit; ABehavior: TRickUIBuilderEditBehavior): IRickUIBuilderEditHandle;
begin
  Result := TRickUIBuilderEditHandle.Create(AContainer, AEdit, ABehavior);
end;

function TRickUIBuilderEditHandle.Container: TRectangle;
begin
  Result := FContainer;
end;

function TRickUIBuilderEditHandle.EditControl: TEdit;
begin
  Result := FEdit;
end;

function TRickUIBuilderEditHandle.Text: string;
begin
  Result := FEdit.Text;
end;

procedure TRickUIBuilderEditHandle.Text(const AValue: string);
begin
  FBehavior.SetText(AValue);
end;

procedure TRickUIBuilderEditHandle.Clear;
begin
  FBehavior.Clear;
end;

procedure TRickUIBuilderEditHandle.SetInvalid(AValue: Boolean;
  const AMessage: string);
begin
  FBehavior.SetInvalid(AValue, AMessage);
end;

procedure TRickUIBuilderEditHandle.SetRequirementMet(AValue: Boolean);
begin
  FBehavior.SetRequirementMet(AValue);
end;

end.
