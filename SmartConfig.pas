unit SmartConfig;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls;

type
  TSmartConfigForm = class(TForm)
    SmartConfigPtn: TPaintBox;
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure DrawPart1(Canvas: TPaintbox);
    procedure DrawPart2(Canvas: TPaintbox);
    procedure DrawPart3(Canvas: TPaintbox);
    procedure DrawBarAnimation(Canvas: TPaintbox);
    procedure FormShow(Sender: TObject);
    procedure DrawAnimation;
    procedure TextFileToArray();
    procedure ArrayToTextFile();
    procedure CheckError();
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  SmartConfigForm: TSmartConfigForm;
  OpacityPartOne: Integer = 255;
  OpacityPartTwo: Integer = 255;
  OpacityPartThree: Integer = 255;
  config: String = 'config.txt';
  TextFileStorage: Array[0..100] of String;
  Error: Boolean = false;

implementation

{$R *.dfm}

procedure TSmartConfigForm.CheckError;
var
  Stor: String;
begin
  TextFileToArray;
  Stor:= TextFileStorage[StrToInt(TextFileStorage[0])];
  if StrToInt(Stor) = 1 then Error:= true
  else Error:= false;

  if Error = true then
  begin
    TextFileStorage[0]:= IntToStr(StrToInt(TextFileStorage[0])-1);
    ArrayToTextFile;
  end;
end;

procedure DrawBlack(Canvas: TPaintbox);
var
  StorageBrushColor, StoragePenColor: TColor;
begin
  StorageBrushColor:= Canvas.Canvas.Brush.Color;
  StoragePenColor:=  Canvas.Canvas.Pen.Color;
  Canvas.Canvas.Pen.Color:= clBlack;
  Canvas.Canvas.Brush.Color:= clBlack;
  Canvas.Canvas.Rectangle(0,0,Canvas.Width, Canvas.Height);
  Canvas.Canvas.Pen.Color:= StoragePenColor;
  Canvas.Canvas.Brush.Color:= StorageBrushColor;
end;

procedure DrawDot(Canvas: TPaintbox; x, y: Integer; Color: TColor);
begin
  with Canvas.Canvas do
  begin
    Brush.Color:= Color;
    Pen.Color:= Color;
    Ellipse(x-1, y-1, x+1, y+1);
    Pen.Color:= clWhite;
    //LineTo(x, y);
  end;
end;

procedure DrawForm(Canvas: TPaintbox);
begin
  with Canvas.Canvas do
  begin
    Brush.Color:= clBlack;
    Pen.Color:= clWhite;
    Pen.Width:= 5;
    RoundRect(100,20, 250, 170, 20, 20);
    Brush.Color:= clBlack;
    Pen.Color:= clBlack;
    Rectangle(0, 50, Canvas.Width, 140);
    Rectangle(130, 0, 220, Canvas.Height-80);
    Font.Color:= clWhite;
    Font.Size:= 15;
    TextOut(105, 200, 'AI is Processing');
  end;
end;

procedure TSmartConfigForm.DrawPart1(Canvas: TPaintbox);
var
StorageColor: TColor;
begin
  StorageColor:= rgb(OpacityPartOne, OpacityPartOne, OpacityPartOne);
  Canvas.Canvas.Brush.Color:= StorageColor;
  Canvas.Canvas.Pen.Color:= StorageColor;
  DrawDot(Canvas, 230, 45, StorageColor);
  DrawDot(Canvas, 175, 40, StorageColor);
  DrawDot(Canvas, 120, 45, StorageColor);
  DrawDot(canvas, 130, 95, StorageColor);
  DrawDot(Canvas, 175, 95, StorageColor);
  DrawDot(canvas, 220, 95, StorageColor);
  DrawDot(canvas, 230, 110, StorageColor);
  DrawDot(Canvas, 230, 145, StorageColor);
  DrawDot(Canvas, 175, 150, StorageColor);
  DrawDot(Canvas, 120, 145, StorageColor);

  with Canvas.Canvas do
  begin
    Pen.Color:= rgb(OpacityPartOne, OpacityPartOne, OpacityPartOne);
    Pen.Width:= 1;
    MoveTo(230, 45);
    LineTo(175, 40);
    LineTo(120, 45);
    LineTo(130, 95);
    LineTo(175, 95);
    LineTo(220, 95);
    LineTo(230, 110);
    LineTo(230, 145);
    LineTo(175, 150);
    LineTo(120, 145);

  end;
end;

procedure TSmartConfigForm.DrawPart2(Canvas: TPaintbox);
var
StorageColor: TColor;
begin
  StorageColor:= rgb(OpacityPartTwo, OpacityPartTwo, OpacityPartTwo);
  Canvas.Canvas.Brush.Color:= StorageColor;
  Canvas.Canvas.Pen.Color:= StorageColor;

  DrawDot(Canvas, 150, 122, StorageColor);
  DrawDot(Canvas, 200, 122, StorageColor);


  with Canvas.Canvas do
  begin
    Pen.Color:= rgb(OpacityPartTwo, OpacityPartTwo, OpacityPartTwo);
    Pen.Width:= 1;

    MoveTo(150, 122);
    LineTo(175, 95);
    MoveTo(150, 122);
    LineTo(130, 95);
    MoveTo(150, 122);
    LineTo(175, 150);
    MoveTo(150, 122);
    LineTo(120, 145);

    MoveTo(150, 122);
    LineTo(200, 122);

    MoveTo(200, 122);
    LineTo(230, 145);
    MoveTo(200, 122);
    LineTo(230, 110);
    MoveTo(200, 122);
    LineTo(220, 95);
    MoveTo(200, 122);
    LineTo(175, 150);
    MoveTo(200, 122);
    LineTo(175, 95)
  end;
end;

procedure TSmartConfigForm.DrawPart3(Canvas: TPaintbox);
var
StorageColor: TColor;
begin
  StorageColor:= rgb(OpacityPartThree, OpacityPartThree, OpacityPartThree);
  Canvas.Canvas.Brush.Color:= StorageColor;
  Canvas.Canvas.Pen.Color:= StorageColor;

  DrawDot(Canvas, 150, 57, StorageColor);
  DrawDot(Canvas, 200, 57, StorageColor);


  with Canvas.Canvas do
  begin
    Pen.Color:= rgb(OpacityPartThree, OpacityPartThree, OpacityPartThree);
    Pen.Width:= 1;

    MoveTo(150, 57);
    LineTo(175, 95);
    MoveTo(150, 57);
    LineTo(130, 95);
    MoveTo(150, 57);
    LineTo(175, 40);
    MoveTo(150, 57);
    LineTo(120, 45);

    MoveTo(150, 57);
    LineTo(200, 57);

    MoveTo(200, 57);
    LineTo(230, 45);
    MoveTo(200, 57);
    LineTo(220, 95);
    MoveTo(200, 57);
    LineTo(175, 40);
    MoveTo(200, 57);
    LineTo(175, 95)
  end;
end;

procedure TSmartConfigForm.FormShow(Sender: TObject);
begin
  Timer1.Enabled:= true;
end;

procedure TSmartConfigForm.DrawBarAnimation(Canvas: TPaintbox);
var
  I, II: Integer;
begin

    for I := 18 to 167 do
    begin
      TThread.Synchronize(nil,
        procedure
        begin
          DrawBlack(Canvas);
          DrawForm(Canvas);
          DrawPart1(canvas);
          DrawPart2(canvas);
          DrawPart3(canvas);
          Canvas.Canvas.Pen.Width:= 0;
          Canvas.Canvas.Brush.Color:= clWhite;
          Canvas.Canvas.Pen.Color:= clWhite;
          Canvas.Canvas.Rectangle(110, I, 240, I+5);

          if I > 95 then
          begin
            if OpacityPartThree > 4 then
            begin
              OpacityPartThree:= OpacityPartThree-4
            end
            else
            OpacityPartThree:= 0;
          end;
        end
        );
     sleep(40);
    end;

    for I := 167 downto 18 do
    begin
      TThread.Synchronize(nil,
        procedure
        begin
          DrawBlack(Canvas);
          DrawForm(Canvas);
          DrawPart1(canvas);
          DrawPart2(canvas);
          Canvas.Canvas.Pen.Width:= 0;
          Canvas.Canvas.Brush.Color:= clWhite;
          Canvas.Canvas.Pen.Color:= clWhite;
          Canvas.Canvas.Rectangle(110, I, 240, I+5);

          if OpacityPartTwo > 3 then
            begin
              OpacityPartTwo:= OpacityPartTwo-3
            end
            else
              OpacityPartTwo:= 0;

          if I < 107 then
          begin
            if OpacityPartOne > 3 then
            begin
              OpacityPartOne:= OpacityPartOne-3
            end
            else
              OpacityPartOne:= 0;
          end;
        end
        );
     sleep(40);
    end;
end;

procedure DrawArrow(Canvas: TPaintbox);
begin
  with Canvas.Canvas do
  begin
    Pen.Color:= clWhite;
    Pen.Width:= 5;
    MoveTo(140, 95);
    LineTo(160, 115);
    LineTo(210, 80);
  end;
end;

procedure TSmartConfigForm.TextFileToArray();
var
  ConfigTXT: TextFile;
  i, ConfigTXTLength: Integer;
  StorageString: String;
begin
  if FileExists(config) then
  begin

    AssignFile(ConfigTXT, 'config.txt');
    Reset(ConfigTXT);
    ConfigTXTLength:= 0;
    while not eof(ConfigTXT) do
    begin
      Readln(ConfigTXT, StorageString);
      ConfigTXTLength:= ConfigTXTLength+1;
    end;
    CloseFile(ConfigTXT);

    AssignFile(ConfigTXT, config);
    Reset(ConfigTXT);
    TextFileStorage[0]:= IntToStr(ConfigTXTLength);

    for I := 1 to ConfigTXTLength do
    begin
      Readln(ConfigTXT, StorageString);
      TextFileStorage[i]:= StorageString;

    end;
    CloseFile(ConfigTXT);


  end
end;

procedure TSmartConfigForm.ArrayToTextFile();
var
  ConfigTXT: TextFile;
  i, ConfigTXTLength: Integer;
  StorageString: String;
begin
  if FileExists(config) then
  begin

    AssignFile(ConfigTXT, config);
    Rewrite(ConfigTXT);

    for I := 1 to StrToInt(TextFileStorage[0]) do
    begin
      Writeln(ConfigTXT, TextFileStorage[i]);
    end;
    CloseFile(ConfigTXT);


  end
end;

procedure DrawError(Canvas: TPaintbox);
begin
  with Canvas.Canvas do
  begin
    Brush.Color:= clBlack;
    Pen.Color:= clWhite;
    Pen.Width:= 5;
    Ellipse(132, 53, 220, 138);
    Brush.Color:= clWhite;
    Rectangle(120, 90, 230, 100);
  end;
end;


procedure TSmartConfigForm.DrawAnimation;
begin
  DrawBlack(SmartConfigPtn);
  DrawForm(SmartConfigPtn);
  //DrawDot(SmartConfigPtn, 100, 100);

    TThread.CreateAnonymousThread(
      procedure
      begin

        DrawBarAnimation(SmartConfigPtn);
        //sleep(1000);
        //SmartConfigForm.Close;
        //Application.Terminate;
        if not(Error) then DrawArrow(SmartConfigPtn)
        else
        begin

        end;
        //ShowMessage('Sucess');
      end
    ).Start();

    {DrawPart1(SmartConfigPtn);
    DrawPart2(SmartConfigPtn);
    DrawPart3(SmartConfigPtn); }
    //DrawArrow(SmartConfigPtn);
  Timer1.Enabled:= false;
end;

procedure TSmartConfigForm.Timer1Timer(Sender: TObject);
begin
  DrawBlack(SmartConfigPtn);
  DrawForm(SmartConfigPtn);
  //DrawDot(SmartConfigPtn, 100, 100);

    TThread.CreateAnonymousThread(
      procedure
      begin

        //DrawBarAnimation(SmartConfigPtn);
        //sleep(1000);
        //SmartConfigForm.Close;
        //Application.Terminate;
        CheckError;
        if not(Error) then DrawArrow(SmartConfigPtn)
        else
        begin
          DrawError(SmartConfigPtn);
        end;
        //ShowMessage('Sucess');
      end
    ).Start();

    {DrawPart1(SmartConfigPtn);
    DrawPart2(SmartConfigPtn);
    DrawPart3(SmartConfigPtn); }
    //DrawArrow(SmartConfigPtn);
    //DrawError(SmartConfigPtn);
  Timer1.Enabled:= false;
end;

end.
