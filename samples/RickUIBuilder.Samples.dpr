program RickUIBuilder.Samples;

uses
  System.StartUpCopy,
  FMX.Forms,
  RickUIBuilder.Samples.Home.ApproachCard in 'src\RickUIBuilder.Samples.Home.ApproachCard.pas',
  RickUIBuilder.Samples.Home in 'src\RickUIBuilder.Samples.Home.pas',
  RickUIBuilder.Samples.Home.Style in 'src\RickUIBuilder.Samples.Home.Style.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TPageSamplesHome, PageSamplesHome);
  Application.Run;
end.
