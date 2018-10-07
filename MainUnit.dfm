object MainForm: TMainForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Sorting Machine'
  ClientHeight = 800
  ClientWidth = 1280
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 168
    Top = 80
    Width = 31
    Height = 13
    Caption = 'Label1'
  end
  object Timer1: TTimer
    Interval = 30
    OnTimer = Timer1Timer
    Left = 8
  end
  object Timer2: TTimer
    Interval = 30
    OnTimer = Timer2Timer
    Left = 40
  end
  object ApplicationEvents1: TApplicationEvents
    OnMessage = ApplicationEvents1Message
    Left = 80
    Top = 8
  end
end
