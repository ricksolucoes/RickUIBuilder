unit Rick.UIBuilder.Tests.Composition;
(*
  ==============================================================================
  Unit: Rick.UIBuilder.Tests.Composition
  ==============================================================================

  RESPONSABILIDADE

  Testes de integracao (Category('Integration')) para
  TRickUIBuilderComposer. Cada teste exige um host FMX valido (TForm
  criado via TForm.CreateNew, nunca exibido), pois o composer cria
  controles FMX reais a cada chamada de Add*.

  Cobertura: cada Add* cria o controle esperado no Parent correto, o
  encadeamento retorna sempre a mesma instancia do composer (sem
  recriar estado a cada chamada), e uma sequencia completa
  (AddText + AddDivider + AddButton) produz os 3 controles, todos
  filhos do mesmo Parent, na ordem de criacao.

  ==============================================================================
*)

interface

uses
  DUnitX.TestFramework,
  System.UITypes,
  FMX.Forms, FMX.Types, FMX.Controls, FMX.Objects, FMX.StdCtrls,
  Rick.UIBuilder.Types,
  Rick.UIBuilder.Interfaces,
  Rick.UIBuilder.Composition;

type
  [TestFixture]
  [Category('Integration')]
  TRickUIBuilderComposerTests = class
  private
    FHostForm: TForm;
    FButtonClickCount: Integer;
    procedure HandleButtonClick(Sender: TObject);
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure AddText_DeveCriarLabelNoParentAssociado;
    [Test]
    procedure AddText_DeveRetornarAMesmaInstanciaDoComposer;
    [Test]
    procedure AddDivider_DeveCriarDividerNoParentAssociado;
    [Test]
    procedure AddBadge_DeveRetornarHandleComContainerETextLabel;
    [Test]
    procedure AddButton_DeveCriarBotaoComOnClickInformado;
    [Test]
    procedure SequenciaCompleta_DeveCriarTresControlesTodosFilhosDoMesmoParent;
    [Test]
    procedure SequenciaCompleta_DeveCriarControlesNaOrdemDeChamada;
  end;

implementation

{ TRickUIBuilderComposerTests }

procedure TRickUIBuilderComposerTests.HandleButtonClick(Sender: TObject);
begin
  Inc(FButtonClickCount);
end;

procedure TRickUIBuilderComposerTests.Setup;
begin
  FHostForm         := TForm.CreateNew(nil);
  FButtonClickCount := 0;
end;

procedure TRickUIBuilderComposerTests.TearDown;
begin
  FHostForm.Free;
end;

procedure TRickUIBuilderComposerTests.AddText_DeveCriarLabelNoParentAssociado;
var
  LComposer: IRickUIBuilderComposer;
  LFound: Boolean;
  I: Integer;
begin
  LComposer := TRickUIBuilderComposer.New(FHostForm);
  LComposer.AddText('EFCompras', TRickUIBuilderTextConfig.Default);

  LFound := False;
  for I := 0 to FHostForm.ChildrenCount - 1 do
    if (FHostForm.Children[I] is TLabel) and
       (TLabel(FHostForm.Children[I]).Text = 'EFCompras') then
    begin
      LFound := True;
      Break;
    end;

  Assert.IsTrue(LFound, 'AddText deveria criar um TLabel filho do Parent associado.');
end;

procedure TRickUIBuilderComposerTests.AddText_DeveRetornarAMesmaInstanciaDoComposer;
var
  LComposer: IRickUIBuilderComposer;
  LResult: IRickUIBuilderComposer;
begin
  LComposer := TRickUIBuilderComposer.New(FHostForm);
  LResult   := LComposer.AddText('Teste', TRickUIBuilderTextConfig.Default);

  Assert.AreEqual<IRickUIBuilderComposer>(LComposer, LResult,
    'AddText deveria retornar a mesma instancia do composer.');
end;

procedure TRickUIBuilderComposerTests.AddDivider_DeveCriarDividerNoParentAssociado;
var
  LComposer: IRickUIBuilderComposer;
  LFound: Boolean;
  I: Integer;
begin
  LComposer := TRickUIBuilderComposer.New(FHostForm);
  LComposer.AddDivider(TRickUIBuilderDividerConfig.Default);

  LFound := False;
  for I := 0 to FHostForm.ChildrenCount - 1 do
    if FHostForm.Children[I] is TRectangle then
    begin
      LFound := True;
      Break;
    end;

  Assert.IsTrue(LFound, 'AddDivider deveria criar um TRectangle filho do Parent associado.');
end;

procedure TRickUIBuilderComposerTests.AddBadge_DeveRetornarHandleComContainerETextLabel;
var
  LComposer: IRickUIBuilderComposer;
  LHandle: IRickUIBuilderBadgeHandle;
begin
  LComposer := TRickUIBuilderComposer.New(FHostForm);
  LComposer.AddBadge('Ativo', TRickUIBuilderBadgeConfig.Default, LHandle);

  Assert.IsNotNull(LHandle, 'AddBadge deveria retornar um handle nao nulo.');
  Assert.IsNotNull(LHandle.Container, 'O Container do handle nao deveria ser nil.');
  Assert.IsNotNull(LHandle.TextLabel, 'O TextLabel do handle nao deveria ser nil.');
  Assert.AreEqual('Ativo', LHandle.TextLabel.Text, 'Texto do Badge incorreto.');
end;

procedure TRickUIBuilderComposerTests.AddButton_DeveCriarBotaoComOnClickInformado;
var
  LComposer: IRickUIBuilderComposer;
  LButton: TRectangle;
  I: Integer;
begin
  LComposer := TRickUIBuilderComposer.New(FHostForm);
  LComposer.AddButton('Instalar', TRickUIBuilderButtonConfig.Default,
    HandleButtonClick);

  LButton := nil;
  for I := 0 to FHostForm.ChildrenCount - 1 do
    if FHostForm.Children[I] is TRectangle then
    begin
      LButton := TRectangle(FHostForm.Children[I]);
      Break;
    end;

  Assert.IsNotNull(LButton, 'AddButton deveria criar um TRectangle filho do Parent associado.');

  if Assigned(LButton.OnClick) then
    LButton.OnClick(LButton);

  Assert.AreEqual(1, FButtonClickCount, 'OnClick informado em AddButton nao foi disparado.');
end;

procedure TRickUIBuilderComposerTests.SequenciaCompleta_DeveCriarTresControlesTodosFilhosDoMesmoParent;
var
  LComposer: IRickUIBuilderComposer;
  LHandle: IRickUIBuilderBadgeHandle;
begin
  LComposer := TRickUIBuilderComposer.New(FHostForm);
  LComposer
    .AddText('EFCompras', TRickUIBuilderTextConfig.Default)
    .AddDivider(TRickUIBuilderDividerConfig.Default)
    .AddButton('Instalar', TRickUIBuilderButtonConfig.Default, nil);

  // 2 TRectangle (divider + botao) + 1 TLabel (texto) + 1 TLabel
  // interno do botao = 4 filhos diretos/indiretos, mas apenas 3
  // controles de topo devem estar diretamente sob FHostForm.
  Assert.AreEqual(3, FHostForm.ChildrenCount,
    'A sequencia deveria produzir exatamente 3 controles de topo no Parent.');
end;

procedure TRickUIBuilderComposerTests.SequenciaCompleta_DeveCriarControlesNaOrdemDeChamada;
var
  LComposer: IRickUIBuilderComposer;
begin
  LComposer := TRickUIBuilderComposer.New(FHostForm);
  LComposer
    .AddText('Primeiro', TRickUIBuilderTextConfig.Default)
    .AddDivider(TRickUIBuilderDividerConfig.Default)
    .AddText('Terceiro', TRickUIBuilderTextConfig.Default);

  Assert.IsTrue(FHostForm.Children[0] is TLabel, 'O primeiro filho deveria ser o TLabel de AddText.');
  Assert.AreEqual('Primeiro', TLabel(FHostForm.Children[0]).Text,
    'O primeiro filho deveria ser o TLabel "Primeiro".');

  Assert.IsTrue(FHostForm.Children[1] is TRectangle, 'O segundo filho deveria ser o TRectangle de AddDivider.');

  Assert.IsTrue(FHostForm.Children[2] is TLabel, 'O terceiro filho deveria ser o TLabel de AddText.');
  Assert.AreEqual('Terceiro', TLabel(FHostForm.Children[2]).Text,
    'O terceiro filho deveria ser o TLabel "Terceiro".');
end;

initialization
  TDUnitX.RegisterTestFixture(TRickUIBuilderComposerTests);

end.
