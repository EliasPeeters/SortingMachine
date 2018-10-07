unit OpenImage;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls;

  procedure LoadImage(imageName: String; image: TImage);

implementation

procedure LoadImage(imageName: String; image: TImage);
var S: TResourceStream;
begin
   S:= TResourceStream.Create(0, imageName, 'IMAGE');
  try
    image.Picture.LoadFromStream(S);
  finally
    S.Free;
  end;
end;

end.
