program RickUIBuilder.Sample;

uses
  System.StartUpCopy,
  FMX.Forms,
  RickUIBuilderSample.Main in 'src\RickUIBuilderSample.Main.pas' {PageSampleMain};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TPageSampleMain, PageSampleMain);
  Application.Run;
end.
