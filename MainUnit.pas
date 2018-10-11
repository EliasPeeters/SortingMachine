unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, OpenImage, Vcl.StdCtrls,
  Vcl.AppEvnts, DrawDiagram, StrUtils, SmartConfig;

type

  TText = Record
    Text: String;
    x: Integer;
    y: Integer;
  End;

  TClickAbleArea = Record
    x1: Integer;
    x2: Integer;
    y1: Integer;
    y2: Integer;
    Text: TText;
    Position: Integer;
  End;




  TMainForm = class(TForm)
    Timer1: TTimer;
    Timer2: TTimer;
    Label1: TLabel;
    ApplicationEvents1: TApplicationEvents;
    Button1: TButton;

    //!!
    procedure Error(ErrorInteger: Integer);
    //!!

    procedure Timer1Timer(Sender: TObject);

    procedure CreateButton(var ButtonName: TButton; Form: TForm; HeightInteger, WidthInteger, LeftInteger, TopInteger: Integer; CaptionString: String);
    procedure CreateImage(var ImageName: TImage; Form: TForm; HeightInteger, WidthInteger, LeftInteger, TopInteger: Integer; LoadImageName: String);
    procedure CreatePaintbox(var PaintboxName: TPaintbox; Form: TForm; HeightInteger, WidthInteger, LeftInteger, TopInteger: Integer);


    procedure buttonClick(Sender: TObject);
    procedure PaintboxClick(Sender: TObject);
    procedure ImageClick(Sender: TObject);

    procedure FormCreate(Sender: TObject);
    procedure CreateUI();

    procedure DrawSideBar(Canvas: TPaintbox);
    procedure DrawTopBar();
    procedure DrawSelector(Selected: String; Opened: Boolean);
    procedure DrawBox(Ptn: TPaintbox);

    procedure Timer2Timer(Sender: TObject);
    procedure ApplicationEvents1Message(var Msg: tagMSG; var Handled: Boolean);

    procedure DefineRects();
    procedure DefineColors();
    procedure CreateArea(PositionInt: Integer; TextString: string);

    function CursorIsInArea(Area: TClickAbleArea):Boolean;
    function AnimationSpeed():Double;
    function CheckIfConfigIsCorrect():Boolean;
    function ReadCustomln(FileName: String; Line: Integer): String;
    procedure Button1Click(Sender: TObject);

    procedure AddStringToConfig(AddString: String);
    procedure TextFileToArray();
    procedure ArrayToTextFile();
    procedure LoadSampleConfig();
    procedure AddErrorToConfig;

  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  config: String = 'config.txt';
  MainForm: TMainForm;
  Test: TButton;
  BackgroundColor: TColor;
  PieChart, BarChart, ColumnChart: TImage;
  PtnSideBar, PtnTopBar, PtnSortingSelection, PtnSortingSelectionDropDown: TPaintbox;
  SettingsBoxImage, StatusBoxImage, DiagramBoxImage, ListboxImage: TPaintbox;
  BlueSelected, GreyCustom: TColor;
  DropDownOpended: Boolean = false;
  Working: Boolean = false;
  SelectedChartType: Integer = 1;
  SelectedSorting: Integer = 0;
  CursorPosition: TPoint;
  BubbleSortButton, QuickSortButton, BoggoSortButton: TClickAbleArea;
  DropDownItems: Array[0..2] of TClickAbleArea;
  TextFileStorage: Array[0..100] of String;
  SampleConfig: Array[0..10] of String;
  ErrorBoolean: Boolean = false;
  ErrorFirst: Boolean = false;
  ErrorAccured: Boolean = false;

  {
    1 = PieChart
    2 = BarChart
    3 = ColumnChart
  }

  {
    1 = QuickSort
    2 = BubbleSort
    3 = BoggoSort
  }


  (*
    Template for a config

   1     config of SortingMachine
   2     by Elias Peeters
   3
   4     {
   5         dark-theme: false;
   6         animation-speed: 1.5;
   7
   8
   9
   10
   11
   12
   13
   14
   15    }


   *)



implementation

{$R *.dfm}


procedure TMainForm.Error(ErrorInteger: Integer);
var
  Stor: Double;
  Error: Boolean;
begin
  case ErrorInteger of
    1:
      begin
        with TTaskDialog.Create(self) do
          begin
           try
            Caption := 'Error 1';
            Title := 'Error 1';
            Text := 'This is a test error and means nothing. You can keep going with any further thoughts';
            CommonButtons := [];
            with TTaskDialogButtonItem(Buttons.Add) do
            begin
              Caption := 'Close Dialog';
              CommandLinkHint := 'You can ignore this type of error';
              ModalResult := mrClose;
            end;

             Flags := [tfUseCommandLinks];
            MainIcon := tdiNone;
            if execute then

            if ModalResult = mrClose then
            begin
              //nothing
            end;

          finally
            Free;
          end;
        end;
      end;

    300:
      begin
        with TTaskDialog.Create(self) do
          begin
           try
            Caption := 'Error 300';
            Title := 'FATAL ERROR: Error 300';
            Text := 'Not able to find config file';
            CommonButtons := [];
            with TTaskDialogButtonItem(Buttons.Add) do
            begin
              Caption := 'CloseProgram';
              CommandLinkHint := 'Error 300 is a fatal error';
              ModalResult := mrClose;
            end;

            with TTaskDialogButtonItem(Buttons.Add) do
            begin
              Caption := 'Try fix';
              CommandLinkHint := 'Try to add default config file';
              ModalResult := mrYes;
            end;

            Flags := [tfUseCommandLinks];
            MainIcon := tdiError;
            if execute then

            if ModalResult = mrClose then
            begin
              Application.Terminate;
            end;

            if ModalResult = mrYes then
            begin
              //AddStringToConfig('ja moin');
              LoadSampleConfig();
            end;

          finally
            Free;
          end;
        end;
      end;

    306:
      begin
        with TTaskDialog.Create(self) do
          begin
           try
            Caption := 'Error 306';
            Title := 'FATAL ERROR: Error 306';
            Text := 'Not able to find "animation-speed" in config file';
            CommonButtons := [];
            with TTaskDialogButtonItem(Buttons.Add) do
            begin
              Caption := 'CloseProgram';
              CommandLinkHint := 'Error 306 is a fatal error';
              ModalResult := mrClose;
            end;

            with TTaskDialogButtonItem(Buttons.Add) do
            begin
              Caption := 'Try fix';
              CommandLinkHint := 'Try to add default animation-speed to config file';
              ModalResult := mrYes;
            end;

            Flags := [tfUseCommandLinks];
            MainIcon := tdiError;
            if execute then

            if ModalResult = mrClose then
            begin
              Application.Terminate;
            end;

            if ModalResult = mrYes then
            begin
              ErrorFirst:= true;
              AddStringToConfig('  animation-speed: 1,5');
              try
                stor:= AnimationSpeed;
              except
                ErrorAccured:= true;
                AddErrorToConfig;
              end;

              SmartConfigForm.Show;
              ErrorFirst:= false;
              ErrorAccured:= false;
              abort;
            end;

          finally
            Free;
          end;
        end;
      end;

    404:
      begin
        with TTaskDialog.Create(self) do
          begin
           try
            Caption := 'Error 404';
            Title := 'Error 404';
            Text := 'The requested resource could not be found but may be available in the future. Subsequent requests by the client are permissible.';
            CommonButtons := [];
            with TTaskDialogButtonItem(Buttons.Add) do
            begin
              Caption := 'Ignore';
              CommandLinkHint := 'Igrnore and abort the current action';
              ModalResult := mrClose;
            end;

             Flags := [tfUseCommandLinks];
            //MainIcon := tdiNone;
            if execute then

            if ModalResult = mrClose then
            begin
              //nothing
            end;

          finally
            Free;
          end;
        end;
      end;

    //404: ShowMessage('Error 404'+#10#13+ 'Something not found');
  end;
end;



procedure TMainForm.LoadSampleConfig;
var
  I: Integer;
  ConfigTXT: TextFile;
begin
  TextFileStorage[0]:= '7';
  TextFileStorage[1]:= 'config of SortingMachine';
  TextFileStorage[2]:= 'by Elias Peeters';
  TextFileStorage[3]:= '';
  TextFileStorage[4]:= '{';
  TextFileStorage[5]:= '  dark-theme: false';
  TextFileStorage[6]:= '  animation-speed: 1,5';
  TextFileStorage[7]:= '}';

  AssignFile(ConfigTXT, config);
  Rewrite(ConfigTXT);

  for I := 1 to StrToInt(TextFileStorage[0]) do
  begin
    Writeln(ConfigTXT, TextFileStorage[i]);
  end;
  CloseFile(ConfigTXT);
end;

procedure ClearArray();
var
I: Integer;
begin
  if TextFileStorage[0] = '' then TextFileStorage[0]:= '0';

  for I := 1 to StrToInt(TextFileStorage[0]) do
  begin
    TextFileStorage[i]:= '';
  end;

end;

procedure TMainForm.AddErrorToConfig;
begin
  ClearArray;
  TextFileToArray;
  TextFileStorage[0]:= IntToStr(StrToInt(TextFileStorage[0])-1);
  ErrorBoolean:= true;
  ArrayToTextFile;
end;

procedure TMainForm.TextFileToArray();
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

    for I := 1 to ConfigTXTLength-1 do
    begin
      Readln(ConfigTXT, StorageString);
      TextFileStorage[i]:= StorageString;

    end;
    CloseFile(ConfigTXT);


  end
  else
  begin
    Error(300);
  end;
end;

procedure TMainForm.ArrayToTextFile();
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
    Writeln(ConfigTXT, '}');

    if ErrorAccured then
    begin
      Writeln(ConfigTXT, '1');
    end;
    CloseFile(ConfigTXT);


  end
  else
  begin
    Error(300);
  end;
end;


procedure TMainForm.AddStringToConfig(AddString: string);
begin
  TextFileToArray;
  TextFileStorage[StrToInt(TextFileStorage[0])]:= AddString;
  ArrayToTextFile;

end;

function TMainForm.ReadCustomln(FileName: String; Line: Integer):String;
var
  CustomFile: TextFile;
  i: Integer;
  StringToRead: String;
begin
  AssignFile(CustomFile, FileName);
  Reset(CustomFile);
  for i := 1 to 10000000 do
  begin
    Readln(CustomFile, StringToRead);
    if i = Line then
    begin
      result:= StringToRead;
      break;
    end;
  end;
  CloseFile(CustomFile);
end;

function MakeStringBetter(InputString: String): String;
var
  HelpString: String;
begin
  HelpString:= InputString;
  HelpString:= Copy(InputString,1,2);
  if Helpstring = '  ' then
  begin
    Delete(InputString, 1, 2);

  end;
  result:= InputString;
end;

function CalculateDropDownHeight(NumberOfItems: Integer): Integer;
begin
  result:= 30+10+NumberOfItems*40;
end;



function TMainForm.AnimationSpeed;
var
  StorageString: String;
  AnimationSpeedString: String;
  FoundInLine, i, ConfigTXTLength: Integer;
  ConfigTXT: TextFile;
begin
  ClearArray;
  TextFileToArray;
  for I := 1 to StrToInt(TextFileStorage[0])  do
  begin
    StorageString:= TextFileStorage[i];
    StorageString:= MakeStringBetter(StorageString);
    StorageString:= Copy(StorageString, 1, 15);
    if StorageString = 'animation-speed' then
    begin
      result:= StrToFloat(Copy(TextFileStorage[i], 20, Length(TextFileStorage[i])-19));
      break;
    end;
  end;

  if i-1 = StrToInt(TextFileStorage[0]) then
  begin
    ErrorBoolean:= true;

    if not(ErrorFirst) then error(306);
    Abort;
  end;

end;




function TMainForm.CheckIfConfigIsCorrect;
var
  Config: TextFile;

begin
  //if CheckIfConfigIsCorrect then ShowMessage('Worked');
  AssignFile(Config, 'config.txt');
  //ReWrite(config);

  //WriteLn(config, '1 2 3 4');
  Reset(config);

end;


function TMainForm.CursorIsInArea(Area: TClickAbleArea):Boolean;
var
  XAchsTrue, YAchsTrue: Boolean;
begin
  XAchsTrue:= False;
  YAchsTrue:= False;

  if (CursorPosition.x >= Area.x1) and (CursorPosition.x <= Area.x2) then
  begin
    XAchsTrue:= True;
  end;

   if (CursorPosition.y >= Area.y1) and (CursorPosition.y <= Area.y2) then
  begin
    YAchsTrue:= True;
  end;

  if (YAchsTrue) and (XAchsTrue) then
  begin
    result:= true;
  end
  else
  begin
    result:= false;
  end;
end;


procedure TMainForm.CreateArea(PositionInt: Integer; TextString: string);
begin
  with DropDownItems[PositionInt] do
  begin
    Text.Text:= TextString;
    Text.x:= 30;
    Text.y:= 30+(PositionInt*40);
    x1:= 948;
    x2:= 1248;
    y1:= 330+(PositionInt*40);
    y2:= 370+(PositionInt*40);
    Position:= PositionInt;
  end;
end;

procedure TMainForm.DefineRects;
begin
  BubbleSortButton.x1:= 948;
  BubbleSortButton.x2:= 1248;
  BubbleSortButton.y1:= 370;
  BubbleSortButton.y2:= 410;

  QuickSortButton.x1:= 948;
  QuickSortButton.x2:= 1248;
  QuickSortButton.y1:= 330;
  QuickSortButton.y2:= 369;
end;

procedure TMainForm.DefineColors;
begin
  BlueSelected:= rgb(96, 157, 254);
  GreyCustom:= rgb(231,231, 231);
end;

procedure TMainForm.CreateButton(var ButtonName: TButton; Form: TForm; HeightInteger, WidthInteger, LeftInteger, TopInteger: Integer; CaptionString: String);
begin
  ButtonName:= TButton.Create(Form);

  with ButtonName do
  begin
    Visible:= false;
    Caption:= CaptionString;
    Parent := Form;
    Height := HeightInteger;
    Width := WidthInteger;
    Left:= LeftInteger;
    Top:= TopInteger;
    OnClick:= ButtonClick;
    Visible:= true;
  end;

end;

procedure TMainForm.CreatePaintbox(var PaintboxName: TPaintbox; Form: TForm; HeightInteger, WidthInteger, LeftInteger, TopInteger: Integer);
begin
  PaintboxName:= TPaintbox.Create(Form);

  with PaintboxName do
  begin
    Visible:= false;
    Parent := Form;
    Height := HeightInteger;
    Width := WidthInteger;
    Left:= LeftInteger;
    Top:= TopInteger;
    //Canvas.Rectangle(0,0, Width, Height);
    OnClick:= PaintboxClick;
    Visible:= true;
  end;
end;


procedure TMainForm.CreateImage(var ImageName: TImage; Form: TForm; HeightInteger, WidthInteger, LeftInteger, TopInteger: Integer; LoadImageName: String);
begin
  ImageName:= TImage.Create(Form);

  with ImageName do
  begin
    Parent := Form;
    Height := HeightInteger;
    Width := WidthInteger;
    Left:= LeftInteger;
    Top:= TopInteger;
    Proportional:= True;
    OnClick:= ImageClick;

  end;

  LoadImage(LoadImageName, ImageName);

end;



procedure TMainForm.FormCreate(Sender: TObject);
var
config: TextFile;
S: String;


begin


  DefineColors();
  //DefineRects();
  CreateArea(0, 'QuickSort');
  CreateArea(1, 'BubbleSort');
  BackgroundColor:= GreyCustom;
  color:= BackgroundColor;

end;

procedure TMainForm.ApplicationEvents1Message(var Msg: tagMSG;
  var Handled: Boolean);
begin
  if Msg.message=WM_LBUTTONDOWN then
  begin


    if DropDownOpended and CursorIsInArea(BubbleSortButton) then
    begin
      Label1.Font.Color:= clGreen;
      DrawSelector('BubbleSort', true);
      SelectedSorting:= 2;
    end;
  end;
end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  //ShowMessage(MakeStringBetter(ReadCustomln('config.txt', 5)));
  //ShowMessage(FloatToStr(AnimationSpeed));
  SmartConfigForm.Show;
end;

procedure TMainForm.buttonClick(Sender: TObject);
var
  Button: TButton;
begin
  Button:= Sender as TButton;
end;

procedure TMainForm.ImageClick(Sender: TObject);
var
  Image: TImage;
begin
  Image:= Sender as TImage;
  if not(DropDownOpended) then
  begin
    if Image.Left = 958 then
    begin
      LoadImage('PieChartPressed', PieChart);

      if SelectedChartType = 2 then
      begin
        LoadImage('BarChart', BarChart);
      end

      else if SelectedChartType = 3 then
      begin
        LoadImage('ColumnChart', Columnchart);
      end;

      SelectedChartType:= 1;
    end;

    if Image.Left = 1053 then
    begin

      LoadImage('BarChartPressed', BarChart);

      if SelectedChartType = 1 then
      begin
        LoadImage('PieChart', PieChart);
      end

      else if SelectedChartType = 3 then
      begin
        LoadImage('ColumnChart', Columnchart);
      end;

      SelectedChartType:= 2;

    end;

    if Image.Left = 1151 then
    begin
      LoadImage('ColumnChartPressed', ColumnChart);

      if SelectedChartType = 1 then
      begin
        LoadImage('PieChart', PieChart);
      end

      else if SelectedChartType = 2 then
      begin
        LoadImage('BarChart', Barchart);
      end;

      SelectedChartType:= 3;

    end;
  end;
end;

{
procedure TMainForm.ImageMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  //test
end;
}
procedure TMainForm.PaintboxClick(Sender: TObject);
var
  Paintbox: TPaintbox;
  I: Integer;
  test2: Boolean;
  AnimationSpeedDouble: Double;
begin
  Paintbox:= Sender as TPaintbox;

  if Paintbox.Height = 60 then
  begin

      if (not(DropDownOpended)) and (not(working)) then
      begin
        PtnSortingSelectionDropDown.Height:= CalculateDropDownHeight(Length(DropDownItems));
        CreateButton(Test, MainForm, 0, 0, 0, 0, '');
        PtnSortingSelectionDropDown.Canvas.Pen.Color:= clWhite;
        PtnSortingSelectionDropDown.Canvas.Brush.Color:= clWhite;

        PtnSortingSelectionDropDown.Canvas.Rectangle(0,0, PtnSortingSelectionDropDown.Width, PtnSortingSelectionDropDown.Height);

        PtnSortingSelectionDropDown.Canvas.Brush.Color:= clWhite;
        PtnSortingSelectionDropDown.Canvas.Pen.Color:= GreyCustom;
        PtnSortingSelectionDropDown.Canvas.Pen.Width:= 3;


        TThread.CreateAnonymousThread(
        procedure
        var I: Integer;
        begin
          Working:= true;
          AnimationSpeedDouble:= 0;
          AnimationSpeedDouble:= AnimationSpeed;
          for I := 20 to Round((PtnSortingSelectionDropDown.Height) / AnimationSpeedDouble) do
          begin
            PtnSortingSelectionDropDown.Canvas.Brush.Color:= clWhite;
            PtnSortingSelectionDropDown.Canvas.Pen.Color:= GreyCustom;
            PtnSortingSelectionDropDown.Canvas.Pen.Width:= 3;
            PtnSortingSelectionDropDown.Canvas.RoundRect(10,5, PtnSortingSelectionDropDown.Width-20, Round(I*AnimationSpeedDouble), 30, 30);
            //PtnSortingSelectionDropDown.Canvas.Rectangle(10, 5, Round(I*1.11)*2, I*2);
            sleep(1);
          end;

          with PtnSortingSelectionDropDown.Canvas do
          begin
            with font do
            begin
              Name:= 'Arial';
              Size:= 15;
              Color:=  clBlack;;
            end;


            for i := 0 to length(DropDownItems)-1 do
            begin
              TextOut(DropDownItems[I].Text.x, DropDownItems[I].Text.y, DropDownItems[I].Text.Text);
            end;
            {
            TextOut(30, 30,  'QuickSort');
            TextOut(30, 70,  'BubbleSort');
            TextOut(30, 110,  'BoggoSort');
            }
          end;

          Working:= false;
        end
        ).Start();




        with PtnSortingSelection.Canvas do
        begin
          pen.Color:= BlueSelected;
          pen.Color:= clWhite;
          Brush.Color:= clWhite;
          for I := 0 to 7 do
          begin
            pen.Color:= clWhite;
            Brush.Color:= clWhite;
            Rectangle(220, 10, 260, 40);

            pen.Color:= BlueSelected;
            MoveTo(230, 22+i);
            LineTo(240, 29-i);
            LineTo(250, 22+i);
            sleep(10);
          end;
          {
          MoveTo(230, 22);
          LineTo(240, 29);
          LineTo(250, 22);}
        end;

        {
        with PtnSortingSelectionDropDown.Canvas do
        begin
          Pen.Color:= clWhite;
          Brush.Color:= clWhite;
          //Pen.Width:= 3;
          //Rectangle(0,0, PtnSortingSelectionDropDown.Width, PtnSortingSelectionDropDown.Height);
          for I := 0 to 130 do
          begin

            //RoundRect(10,5,Round(I*1.11)*2, I*2, 30, 30);
            PtnSortingSelectionDropDown.Canvas.Rectangle(10, 5, Round(I*1.11)*2, I*2);
            sleep(1);
          end;

          Brush.Color:= clWhite;
          Pen.Color:= GreyCustom;
          Pen.Width:= 3;
          //RoundRect(10, 10, 280, 250, 30, 30);

          //RoundRect(10,5,PtnSortingSelectionDropDown.Width-10, PtnSortingSelectionDropDown.Height-10, 30, 30);

          Brush.Color:= clWhite;
          //Rectangle(0,0, PtnSortingSelectionDropDown.Width, PtnSortingSelectionDropDown.Height);
        end;
         }
         DropDownOpended:= true;
      end

      else if not(working) then

      begin
        TThread.CreateAnonymousThread(
        procedure
        var I: Integer;
        begin

          working:= true;
          {
          with PtnSortingSelectionDropDown.Canvas do
          begin
            Brush.Color:= clWhite;
            Pen.Color:= clWhite;
            Rectangle(29, 30, 275, 240);

          end;

          for I := 125 downto 20 do
          begin

            PtnSortingSelectionDropDown.Canvas.Pen.Color:= clWhite;
            PtnSortingSelectionDropDown.Canvas.Rectangle(0, 0, PtnSortingSelectionDropDown.Width, PtnSortingSelectionDropDown.Height);
            PtnSortingSelectionDropDown.Canvas.Brush.Color:= clWhite;
            PtnSortingSelectionDropDown.Canvas.Pen.Color:= GreyCustom;
            PtnSortingSelectionDropDown.Canvas.Pen.Width:= 3;
            PtnSortingSelectionDropDown.Canvas.RoundRect(10,5,Round(I*1.11)*2, I*2, 30, 30);
            //PtnSortingSelectionDropDown.Canvas.Rectangle(10, 5, Round(I*1.11)*2, I*2);
            sleep(1);
          end;

          PtnSortingSelectionDropDown.Canvas.Pen.Color:= clWhite;
          PtnSortingSelectionDropDown.Canvas.Rectangle(0, 0, PtnSortingSelectionDropDown.Width, PtnSortingSelectionDropDown.Height);
          Working:= false;}

          with PtnSortingSelection.Canvas do
          begin
            pen.Color:= BlueSelected;
            pen.Color:= clWhite;
            Brush.Color:= clWhite;
            for I := 0 to 7 do
            begin
              pen.Color:= clWhite;
              Brush.Color:= clWhite;
              Rectangle(220, 10, 260, 40);

              pen.Color:= BlueSelected;
              MoveTo(230, 29-i);
              LineTo(240, 22+i);
              LineTo(250, 29-i);
              sleep(10);
            end;
          end;
        end
        ).Start();


        with PtnSortingSelectionDropDown.Canvas do
          begin
            Brush.Color:= clWhite;
            Pen.Color:= clWhite;
            Rectangle(29, 30, 275, 240);

          end;

          for I := 97 downto 10 do
          begin

            PtnSortingSelectionDropDown.Canvas.Pen.Color:= clWhite;
            PtnSortingSelectionDropDown.Canvas.Rectangle(0, 0, PtnSortingSelectionDropDown.Width, PtnSortingSelectionDropDown.Height);
            PtnSortingSelectionDropDown.Canvas.Brush.Color:= clWhite;
            PtnSortingSelectionDropDown.Canvas.Pen.Color:= GreyCustom;
            PtnSortingSelectionDropDown.Canvas.Pen.Width:= 3;
            PtnSortingSelectionDropDown.Canvas.RoundRect(10,5,Round(I*1.11)*2, I*2, 30, 30);
            //PtnSortingSelectionDropDown.Canvas.Rectangle(10, 5, Round(I*1.11)*2, I*2);
            sleep(1);

            if i < 120 then
            LoadImage('ColumnChart', Columnchart);

          end;


          if SelectedChartType = 1 then
          begin
            LoadImage('PieChartPressed', PieChart);
            LoadImage('BarChart', BarChart);
            LoadImage('ColumnChart', Columnchart);
          end;

          if SelectedChartType = 2 then
          begin
            LoadImage('BarChartPressed', BarChart);
            LoadImage('ColumnChart', Columnchart);
            LoadImage('PieChart', PieChart);
          end;

          if SelectedChartType = 3 then
          begin
            LoadImage('ColumnChartPressed', Columnchart);
            LoadImage('PieChart', PieChart);
            LoadImage('BarChart', BarChart);
          end;
          //CreateImage(PieChart, MainForm, 83, 83, 958, 324, 'PieChartPressed');

          PtnSortingSelectionDropDown.Canvas.Pen.Color:= clWhite;
          PtnSortingSelectionDropDown.Canvas.Rectangle(0, 0, PtnSortingSelectionDropDown.Width, PtnSortingSelectionDropDown.Height);
          Working:= false;



        //PtnSortingSelectionDropDown.Height:= 10;
        PtnSortingSelectionDropDown.Canvas.Rectangle(0, 0, PtnSortingSelectionDropDown.Width, PtnSortingSelectionDropDown.Height);
        CreateButton(Test, MainForm, 0, 0, 0, 0, '');
        DropDownOpended:= false;
      end;
  end;

  if Paintbox.Height = 260 then
  begin
    //CursorPosition:= Mouse.CursorPos;


    {
    if ((CursorPosition.X >= 948 ) and (CursorPosition.X <= 1248 )) and ((CursorPosition.Y >= 400) and (CursorPosition.Y <= 440)) then
    begin
      with PtnSortingSelection.Canvas do
      begin
        RoundRect(10,5,PtnSortingSelection.Width-10, PtnSortingSelection.Height-10, PtnSortingSelection.Height-10, PtnSortingSelection.Height-10);
        with font do
        begin
          Name:= 'Arial';
          Size:= 15;
          Color:=  GreyCustom;
        end;
        TextOut(PtnSortingSelection.Height div 2, 17, 'Test');
      end;
    end;}
  end;

end;

procedure TMainForm.DrawSideBar(Canvas: TPaintbox);
begin
  with PtnSideBar.Canvas do
  begin
    Pen.Color:= clWhite;
    Brush.Color:= clWhite;

    Rectangle(0,0, MainForm.Width, MainForm.Height);
  end;

end;

procedure TMainForm.DrawTopBar;
begin
  with PtnTopBar.Canvas do
  begin
    Pen.Color:= clWhite;
    Brush.Color:= clWhite;

    Rectangle(0,0, MainForm.Width, MainForm.Height);
  end;

end;

procedure TMainForm.DrawSelector(Selected: String; Opened: Boolean);
begin
  with PtnSortingSelection.Canvas do
  begin
    Brush.Color:= clWhite;
    Pen.Color:= GreyCustom;
    Pen.Width:= 3;
    RoundRect(10,5,PtnSortingSelection.Width-10, PtnSortingSelection.Height-10, PtnSortingSelection.Height-10, PtnSortingSelection.Height-10);
    with font do
    begin
      Name:= 'Arial';
      Size:= 15;
      if Selected = 'Select' then Color:=  GreyCustom
      else Color:= clBlack;
    end;
    TextOut(PtnSortingSelection.Height div 2, 17, Selected);
    pen.Color:= BlueSelected;
    if Opened then
    begin
      MoveTo(230, 29);
      LineTo(240, 22);
      LineTo(250, 29);
    end
    else
    begin
      MoveTo(230, 22);
      LineTo(240, 29);
      LineTo(250, 22);
    end;
  end;

end;

procedure TMainForm.DrawBox(Ptn: TPaintbox);
begin
  with Ptn.Canvas do
  begin
    Brush.Color:= clWhite;
    Pen.Color:= clWhite;
    RoundRect(0,0,Ptn.Width, Ptn.Height, 30, 30);
  end;
end;




procedure TMainForm.CreateUI;
begin

  //Create All Objects
  CreatePaintbox(PtnSideBar, MainForm, MainForm.Height, 70, 0,0);
  CreatePaintbox(PtnTopBar, MainForm, 50, MainForm.Width, 0,0);

  //Setting
  CreatePaintbox(SettingsBoxImage, MainForm, 536, 330, 928, 215);
  CreatePaintbox(PtnSortingSelection, MainForm, 60, 290, 948, 247);
  CreatePaintbox(PtnSortingSelectionDropDown, MainForm, 0, 300, 948, 310);
  CreateImage(PieChart, MainForm, 83, 83, 958, 324, 'PieChartPressed');
  CreateImage(BarChart, MainForm, 83, 83, 1053, 324, 'BarChart');
  CreateImage(ColumnChart, MainForm, 83, 83, 1151, 324, 'ColumnChart');

  //Listbox
  CreatePaintbox(ListBoxImage, MainForm, 650, 96 , 793, 100);

  //Diagram
  CreatePaintbox(DiagramBoxImage, MainForm, 650, 650, 100, 100);

  //Status
  CreatePaintbox(StatusBoxImage, MainForm, 93, 329, 928, 100);

  CreateButton(Test, MainForm, 0, 0, 0, 0, 'Test');

  //Draw the UI on specific objects

  PtnSideBar.Canvas.LineTo(100, 100);
  DrawSideBar(PtnSideBar);
  DrawTopBar;
  DrawBox(SettingsBoxImage);
  DrawBox(ListBoxImage);
  DrawBox(DiagramBoxImage);
  DrawBox(StatusBoxImage);
  DrawSelector('Select', false);


end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin

  CreateUI;
  Timer1.Enabled:= false;
end;

procedure TMainForm.Timer2Timer(Sender: TObject);
begin
  CursorPosition:= ScreenToClient(Mouse.CursorPos);
  label1.Caption:= IntToStr(CursorPosition.X )+ ',' +IntToStr(CursorPosition.y);

  if DropDownOpended then
  begin


    //Hover Animations
    {
    //BubbleSort
    if CursorIsInArea(BubbleSortButton) then
    //If cursor is in the specific Area
    begin
      //Draw it Blue and wirte the Text again
      PtnSortingSelectionDropDown.Canvas.Brush.Color:= BlueSelected;
      PtnSortingSelectionDropDown.Canvas.Pen.Color:= BlueSelected;
      PtnSortingSelectionDropDown.Canvas.Rectangle(13, 60, 282, 100);
      PtnSortingSelectionDropDown.Canvas.TextOut(30, 70,  'BubbleSort');
    end
    else
    begin
      PtnSortingSelectionDropDown.Canvas.Brush.Color:= clWhite;
      PtnSortingSelectionDropDown.Canvas.Pen.Color:= clWhite;
      PtnSortingSelectionDropDown.Canvas.Rectangle(13, 60, 282, 100);
      PtnSortingSelectionDropDown.Canvas.TextOut(30, 70,  'BubbleSort');
    end;

    //QuickSort
    if CursorIsInArea(QuickSortButton) then
    begin
      PtnSortingSelectionDropDown.Canvas.Brush.Color:= BlueSelected;
      PtnSortingSelectionDropDown.Canvas.Pen.Color:= BlueSelected;
      PtnSortingSelectionDropDown.Canvas.Rectangle(13, 20, 282, 60);
      PtnSortingSelectionDropDown.Canvas.TextOut(30, 30,  'QuickSort');
    end
    else
    begin
      PtnSortingSelectionDropDown.Canvas.Brush.Color:= clWhite;
      PtnSortingSelectionDropDown.Canvas.Pen.Color:= clWhite;
      PtnSortingSelectionDropDown.Canvas.Rectangle(13, 20, 282, 60);
      //PtnSortingSelectionDropDown.Canvas.Font.Color:= clBlack;
      PtnSortingSelectionDropDown.Canvas.TextOut(30, 30,  'QuickSort');
    end;
     }
    //BubbleSort

  end;
end;

end.
