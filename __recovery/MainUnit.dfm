object MainForm: TMainForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Sorting Machine'
  ClientHeight = 660
  ClientWidth = 1110
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object SideBar: TPaintBox
    Left = 0
    Top = 0
    Width = 70
    Height = 650
  end
  object Image1: TImage
    Left = 0
    Top = 208
    Width = 70
    Height = 70
  end
  object Timer1: TTimer
    Interval = 1
    OnTimer = Timer1Timer
    Left = 8
  end
end
