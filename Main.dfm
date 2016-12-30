object MainFrm: TMainFrm
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Thread Cam'
  ClientHeight = 421
  ClientWidth = 608
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object PaintBox: TPaintBox
    Left = 299
    Top = 8
    Width = 297
    Height = 273
    OnPaint = PaintBoxPaint
  end
  object Label6: TLabel
    Left = 11
    Top = 10
    Width = 57
    Height = 13
    Caption = 'Frame rate:'
  end
  object Memo: TMemo
    Left = 8
    Top = 32
    Width = 273
    Height = 233
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object FrameRateEdit: TSpinEdit
    Left = 74
    Top = 6
    Width = 47
    Height = 22
    AutoSelect = False
    MaxValue = 99
    MinValue = 0
    TabOrder = 1
    Value = 50
    OnChange = FrameRateEditChange
  end
  object Timer: TTimer
    Enabled = False
    Interval = 20
    OnTimer = TimerTimer
    Left = 32
    Top = 136
  end
  object AutoTimer: TTimer
    Enabled = False
    Interval = 1
    OnTimer = NewImageBtnClick
    Left = 96
    Top = 136
  end
end
