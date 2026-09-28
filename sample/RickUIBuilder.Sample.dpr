program RickUIBuilder.Sample;

uses
  System.StartUpCopy,
  FMX.Forms,
  RickUIBuilderSample.Main in 'src\RickUIBuilderSample.Main.pas' {PageSampleMain},
  RickUIBuilderSample.Edit in 'src\RickUIBuilderSample.Edit.pas',
  Rick.UIBuilder._Label in '..\src\Rick.UIBuilder._Label.pas',
  Rick.UIBuilder.Badge.Handle in '..\src\Rick.UIBuilder.Badge.Handle.pas',
  Rick.UIBuilder.Badge in '..\src\Rick.UIBuilder.Badge.pas',
  Rick.UIBuilder.Button.Handle in '..\src\Rick.UIBuilder.Button.Handle.pas',
  Rick.UIBuilder.Button.HoverBehavior in '..\src\Rick.UIBuilder.Button.HoverBehavior.pas',
  Rick.UIBuilder.Button.HoverState in '..\src\Rick.UIBuilder.Button.HoverState.pas',
  Rick.UIBuilder.Button in '..\src\Rick.UIBuilder.Button.pas',
  Rick.UIBuilder.ComboBox.Behavior in '..\src\Rick.UIBuilder.ComboBox.Behavior.pas',
  Rick.UIBuilder.ComboBox.Data in '..\src\Rick.UIBuilder.ComboBox.Data.pas',
  Rick.UIBuilder.ComboBox.Handle in '..\src\Rick.UIBuilder.ComboBox.Handle.pas',
  Rick.UIBuilder.ComboBox in '..\src\Rick.UIBuilder.ComboBox.pas',
  Rick.UIBuilder.ComboBox.Presentation in '..\src\Rick.UIBuilder.ComboBox.Presentation.pas',
  Rick.UIBuilder.ComboBox.State in '..\src\Rick.UIBuilder.ComboBox.State.pas',
  Rick.UIBuilder.ComboBox.Style in '..\src\Rick.UIBuilder.ComboBox.Style.pas',
  Rick.UIBuilder.ComboBox.Virtualization in '..\src\Rick.UIBuilder.ComboBox.Virtualization.pas',
  Rick.UIBuilder.Composition in '..\src\Rick.UIBuilder.Composition.pas',
  Rick.UIBuilder.Divider in '..\src\Rick.UIBuilder.Divider.pas',
  Rick.UIBuilder.Edit.Behavior in '..\src\Rick.UIBuilder.Edit.Behavior.pas',
  Rick.UIBuilder.Edit.Handle in '..\src\Rick.UIBuilder.Edit.Handle.pas',
  Rick.UIBuilder.Edit.Input in '..\src\Rick.UIBuilder.Edit.Input.pas',
  Rick.UIBuilder.Edit in '..\src\Rick.UIBuilder.Edit.pas',
  Rick.UIBuilder.Factory in '..\src\Rick.UIBuilder.Factory.pas',
  Rick.UIBuilder.Interfaces in '..\src\Rick.UIBuilder.Interfaces.pas',
  Rick.UIBuilder in '..\src\Rick.UIBuilder.pas',
  Rick.UIBuilder.Types in '..\src\Rick.UIBuilder.Types.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TPageSampleMain, PageSampleMain);
  Application.Run;
end.
