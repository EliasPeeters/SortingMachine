unit DrawDiagram;

interface
  uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls;

  procedure DrawBarChart(Height, Width, x, y, CurrentElement, MaxNum: Integer; Canvas: TPaintbox; Numbers: Array of Integer; ColorMode, HeightMode: Boolean);

implementation


procedure DrawBarChart(Height, Width, x, y, CurrentElement, MaxNum: Integer; Canvas: TPaintbox; Numbers: Array of Integer; ColorMode, HeightMode: Boolean);
var
  BarWidth, BarHeight, x1, ExtraDistanz, GreyColor, I: Integer;

begin
  barWidth:= Width div (length(Numbers));
  //ExtraDistanz:= BarWidth div length(Numbers);
  ExtraDistanz:= 0;
  x1:= x;
  with Canvas.Canvas do
  begin
    Brush.Color:= clWhite;
    Pen.Color:= clWhite;
    Rectangle(x,y, Width, Height);

    MoveTo(x, Height+y);
    GreyColor:= 140;
    Pen.Style:= psSolid;
    Pen.Color:= rgb(GreyColor, GreyColor, GreyColor);
    LineTo(Width+x, Height+y);

    GreyColor:= 190;
    Pen.Style:= psDot;
    Pen.Color:= rgb(GreyColor, GreyColor, GreyColor);

    MoveTo(x, Round(Height * 1/4)+y);
    LineTo(Width+x, Round(Height * 1/4)+y);

    MoveTo(x, Round(Height * 2/4)+y);
    LineTo(Width+x, Round(Height * 2/4)+y);

    MoveTo(x, Round(Height * 3/4)+y);
    LineTo(Width+x, Round(Height * 3/4)+y);


    if CurrentElement = 10000 then
    begin
      Pen.Style:= psSolid;
      Pen.Color:= clwhite;
      Brush.Color:= rgb(88, 206, 162);


      for I := 0 to length(Numbers)-1 do
      begin
        BarHeight:= (Height div MaxNum)*Numbers[i];
        Rectangle(x1, Height+y, x1+barWidth, Height-BarHeight+y);
        x1:= x1+BarWidth+ExtraDistanz;
      end;
    end

    else
    begin
      Pen.Style:= psSolid;
      Pen.Color:= clwhite;
      Brush.Color:= rgb(233, 233, 233);

      for I := 0 to length(Numbers)-1 do
      begin
        if I = CurrentElement then Brush.Color:= rgb(88, 206, 162)
        else Brush.Color:= rgb(233, 233, 233);

        BarHeight:= (Height div MaxNum)*Numbers[i];
        Rectangle(x1, Height, x1+barWidth, Height-BarHeight);
        x1:= x1+BarWidth+ExtraDistanz;
      end;
    end;

  end;
end;

end.

