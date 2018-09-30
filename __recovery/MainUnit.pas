unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, OpenImage;

type
  TMainForm = class(TForm)
    SideBar: TPaintBox;
    Timer1: TTimer;
    Image1: TImage;
    procedure Timer1Timer(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure DrawSideBar(Canvas: TPaintbox);
begin
  with Canvas.Canvas do
  begin
    Pen.Color:= rgb(48, 61, 78);
    Brush.Color:= rgb(48, 61, 78);

    Rectangle(0,0, 70, Canvas.Height);
  end;

end;

procedure UI();
begin
  DrawSideBar();
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
  DrawSideBar(SideBar);
  Timer1.Enabled:= false;
end;

end.
