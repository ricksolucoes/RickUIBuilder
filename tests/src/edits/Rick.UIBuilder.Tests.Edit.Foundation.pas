unit Rick.UIBuilder.Tests.Edit.Foundation;

{$SCOPEDENUMS ON}

interface

uses
  DUnitX.TestFramework,
  FMX.Forms,

  Rick.UIBuilder.Edit.Interfaces;

type
  [TestFixture]
  [Category('Integration')]
  TRickUIBuilderEditFoundationTests = class
  private
    FHost: TForm;
    FEdit: IRickUIBuilderEdit;
  public
    [Setup] procedure Setup;
    [TearDown] procedure TearDown;
    [Test] procedure Root_DeveCachearRamosPrincipais;
    [Test] procedure ParentBuild_DeveAssociarContainerAoHost;
    [Test] procedure Build_DeveManterDesignerDentroDoContainer;
    [Test] procedure ParentLiberado_ToBackDeveFalhar;
  end;

implementation

uses
  System.SysUtils,

  Rick.UIBuilder.Edit.Builder;

procedure TRickUIBuilderEditFoundationTests.Setup;
begin
  FHost := TForm.CreateNew(nil);
  FEdit := TRickUIBuilderEdit.New;
end;

procedure TRickUIBuilderEditFoundationTests.TearDown;
begin
  FEdit := nil;
  FHost.Free;
  FHost := nil;
end;

procedure TRickUIBuilderEditFoundationTests.Root_DeveCachearRamosPrincipais;
begin
  Assert.IsTrue(FEdit.Rectangle = FEdit.Rectangle);
  Assert.IsTrue(FEdit.Labels = FEdit.Labels);
  Assert.IsTrue(FEdit.Designer = FEdit.Designer);
  Assert.IsTrue(FEdit.Line = FEdit.Line);
  Assert.IsTrue(FEdit.Config = FEdit.Config);
end;

procedure TRickUIBuilderEditFoundationTests.ParentBuild_DeveAssociarContainerAoHost;
var
  LResult: IRickUIBuilderEdit;
begin
  LResult := FEdit.Parent(FHost).Build;
  Assert.IsTrue(LResult = FEdit);
  Assert.IsTrue(FEdit.Rectangle.Control.Parent = FHost);
end;

procedure TRickUIBuilderEditFoundationTests.Build_DeveManterDesignerDentroDoContainer;
begin
  FEdit.Parent(FHost).Build;
  Assert.IsTrue(FEdit.Designer.Control.Parent = FEdit.Rectangle.Control);
end;

procedure TRickUIBuilderEditFoundationTests.ParentLiberado_ToBackDeveFalhar;
var
  LMessage: string;
  LRectangle: IRickUIBuilderEditRetangle;
begin
  LRectangle := FEdit.Rectangle;
  FEdit := nil;
  LMessage := EmptyStr;
  try
    LRectangle.ToBack;
  except
    on LE: Exception do
      LMessage := LE.Message;
  end;
  Assert.AreEqual('O Parent da interface não foi informado para retornar.', LMessage);
end;

initialization
  TDUnitX.RegisterTestFixture(TRickUIBuilderEditFoundationTests);

end.
