program SortingMachine;

{$R 'Ressources.res' 'Ressources.rc'}

uses
  Vcl.Forms,
  MainUnit in 'MainUnit.pas' {MainForm},
  OpenImage in 'OpenImage.pas',
  DrawDiagram in 'DrawDiagram.pas',
  SmartConfig in 'SmartConfig.pas' {SmartConfigForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TSmartConfigForm, SmartConfigForm);
  Application.Run;
end.
