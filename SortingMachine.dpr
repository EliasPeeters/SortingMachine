program SortingMachine;

{$R 'Ressources.res' 'Ressources.rc'}

uses
  Vcl.Forms,
  MainUnit in 'MainUnit.pas' {MainForm},
  OpenImage in 'OpenImage.pas',
  DrawDiagram in 'DrawDiagram.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
