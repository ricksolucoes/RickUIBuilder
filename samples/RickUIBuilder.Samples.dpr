program RickUIBuilder.Samples;

uses
  System.StartUpCopy,
  FMX.Forms,
  RickUIBuilder.Samples.App.Bootstrap in 'src\App\RickUIBuilder.Samples.App.Bootstrap.pas',
  RickUIBuilder.Samples.App.Coordinator in 'src\App\RickUIBuilder.Samples.App.Coordinator.pas',
  RickUIBuilder.Samples.App.Types in 'src\App\RickUIBuilder.Samples.App.Types.pas',
  RickUIBuilder.Samples.App.Typography in 'src\App\RickUIBuilder.Samples.App.Typography.pas',
  RickUIBuilder.Samples.Home in 'src\Home\RickUIBuilder.Samples.Home.pas',
  RickUIBuilder.Samples.Home.ComponentCard in 'src\Home\RickUIBuilder.Samples.Home.ComponentCard.pas',
  RickUIBuilder.Samples.Home.Icons in 'src\Home\RickUIBuilder.Samples.Home.Icons.pas',
  RickUIBuilder.Samples.Home.Presenter.Intf in 'src\Home\RickUIBuilder.Samples.Home.Presenter.Intf.pas',
  RickUIBuilder.Samples.Home.Presenter in 'src\Home\RickUIBuilder.Samples.Home.Presenter.pas',
  RickUIBuilder.Samples.Home.Style in 'src\Home\RickUIBuilder.Samples.Home.Style.pas',
  RickUIBuilder.Samples.ComponentPage in 'src\Components\Common\RickUIBuilder.Samples.ComponentPage.pas';

{$R *.res}

begin
  Application.Initialize;
  ExitCode := TSampleApplication.Run;
end.
