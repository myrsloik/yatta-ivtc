object Logwindow: TLogwindow
  Left = 360
  Top = 205
  Caption = 'Log'
  ClientHeight = 367
  ClientWidth = 550
  Color = clBtnFace
  DefaultMonitor = dmMainForm
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  PrintScale = poNone
  PixelsPerInch = 96
  TextHeight = 13
  object LogList: TListBox
    Left = 0
    Top = 0
    Width = 550
    Height = 367
    Align = alClient
    ItemHeight = 13
    MultiSelect = True
    TabOrder = 0
    OnDblClick = LogListDblClick
    OnKeyDown = LogListKeyDown
  end
end
