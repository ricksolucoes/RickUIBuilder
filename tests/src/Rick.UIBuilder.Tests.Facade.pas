unit Rick.UIBuilder.Tests.Facade;
(*
  ==============================================================================
  Unit: Rick.UIBuilder.Tests.Facade
  ==============================================================================

  RESPONSABILIDADE

  Testes de integracao (Category('Integration')) para a fachada
  TRickUIBuilder. Confirma que cada metodo estatico devolve uma
  instancia nova e funcional das tres abordagens (Factory, builders
  fluentes, Composition), e que builders obtidos em chamadas
  separadas de TRickUIBuilder nao compartilham estado entre si.

  ==============================================================================
*)

interface

uses
  DUnitX.TestFramework,
  System.UITypes,
  FMX.Forms, FMX.Types, FMX.Controls, FMX.Objects, FMX.StdCtrls,
  Rick.UIBuilder.Types,
  Rick.UIBuilder.Interfaces,
  Rick.UIBuilder;

type
  [TestFixture]
  [Category('Integration')]
  TRickUIBuilderFacadeTests = class
  private
    FHostForm: TForm;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure Label_DeveCriarLabelFuncional;
    [Test]
    procedure Button_DeveCriarBotaoFuncional;
    [Test]
    procedure Badge_DeveCriarBadgeFuncional;
    [Test]
    procedure Divider_DeveCriarDividerFuncional;
    [Test]
    procedure Factory_DevePermitirChamarMetodosEstaticosDiretamente;
    [Test]
    procedure On_DeveCriarComposerFuncional;
    [Test]
    procedure Label_ChamadoDuasVezes_NaoDeveCompartilharEstadoEntreInstancias;
  end;

implementation

{ TRickUIBuilderFacadeTests }

procedure TRickUIBuilderFacadeTests.Setup;
begin
  FHostForm := TForm.CreateNew(nil);
end;

procedure TRickUIBuilderFacadeTests.TearDown;
begin
  FHostForm.Free;
end;

procedure TRickUIBuilderFacadeTests.Label_DeveCriarLabelFuncional;
var
  LLabel: TLabel;
begin
  LLabel := TRickUIBuilder.Label_
    .Text('EFCompras')
    .Build(FHostForm);

  Assert.IsNotNull(LLabel, 'TRickUIBuilder.Label_ nao deveria retornar nil apos Build.');
  Assert.AreEqual('EFCompras', LLabel.Text, 'Texto do label incorreto.');
end;

procedure TRickUIBuilderFacadeTests.Button_DeveCriarBotaoFuncional;
var
  LButton: TRectangle;
begin
  LButton := TRickUIBuilder.Button
    .Caption('Instalar')
    .Build(FHostForm);

  Assert.IsNotNull(LButton, 'TRickUIBuilder.Button nao deveria retornar nil apos Build.');
  Assert.IsTrue(LButton is TRectangle, 'O componente criado deveria ser TRectangle.');
end;

procedure TRickUIBuilderFacadeTests.Badge_DeveCriarBadgeFuncional;
var
  LHandle: IRickUIBuilderBadgeHandle;
begin
  LHandle := TRickUIBuilder.Badge
    .Text('Ativo')
    .Build(FHostForm);

  Assert.IsNotNull(LHandle, 'TRickUIBuilder.Badge nao deveria retornar handle nulo apos Build.');
  Assert.AreEqual('Ativo', LHandle.TextLabel.Text, 'Texto do Badge incorreto.');
end;

procedure TRickUIBuilderFacadeTests.Divider_DeveCriarDividerFuncional;
var
  LDivider: TRectangle;
begin
  LDivider := TRickUIBuilder.Divider
    .Width(385)
    .Build(FHostForm);

  Assert.IsNotNull(LDivider, 'TRickUIBuilder.Divider nao deveria retornar nil apos Build.');
  Assert.AreEqual<Single>(385, LDivider.Width, 'Width do divisor incorreto.');
end;

procedure TRickUIBuilderFacadeTests.Factory_DevePermitirChamarMetodosEstaticosDiretamente;
var
  LLabel: TLabel;
begin
  LLabel := TRickUIBuilder.Factory.CreateText(FHostForm, FHostForm, 'Teste',
    TRickUIBuilderTextConfig.Default);

  Assert.IsNotNull(LLabel, 'TRickUIBuilder.Factory.CreateText nao deveria retornar nil.');
  Assert.AreEqual('Teste', LLabel.Text, 'Texto do label incorreto.');
end;

procedure TRickUIBuilderFacadeTests.On_DeveCriarComposerFuncional;
var
  LFound: Boolean;
  I: Integer;
begin
  TRickUIBuilder.On(FHostForm)
    .AddText('EFCompras', TRickUIBuilderTextConfig.Default);

  LFound := False;
  for I := 0 to FHostForm.ChildrenCount - 1 do
    if (FHostForm.Children[I] is TLabel) and
       (TLabel(FHostForm.Children[I]).Text = 'EFCompras') then
    begin
      LFound := True;
      Break;
    end;

  Assert.IsTrue(LFound, 'TRickUIBuilder.On deveria produzir um composer funcional.');
end;

procedure TRickUIBuilderFacadeTests.Label_ChamadoDuasVezes_NaoDeveCompartilharEstadoEntreInstancias;
var
  LFirstLabel: TLabel;
  LSecondLabel: TLabel;
begin
  // Cada chamada a TRickUIBuilder.Label_ deveria devolver uma
  // instancia nova de IRickUIBuilderLabel, sem herdar estado
  // (Text, FontColor etc.) configurado em uma chamada anterior.
  LFirstLabel := TRickUIBuilder.Label_
    .Text('Primeiro')
    .FontColor(TAlphaColors.Red)
    .Build(FHostForm);

  LSecondLabel := TRickUIBuilder.Label_
    .Text('Segundo')
    .Build(FHostForm);

  Assert.AreEqual('Primeiro', LFirstLabel.Text, 'Primeiro label perdeu seu proprio texto.');
  Assert.AreEqual('Segundo', LSecondLabel.Text, 'Segundo label nao deveria herdar texto do primeiro.');
  Assert.AreNotEqual<TAlphaColor>(TAlphaColors.Red, LSecondLabel.TextSettings.FontColor,
    'Segundo label nao deveria herdar FontColor configurado no primeiro.');
end;

initialization
  TDUnitX.RegisterTestFixture(TRickUIBuilderFacadeTests);

end.
