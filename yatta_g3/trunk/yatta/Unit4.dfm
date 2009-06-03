object Form4: TForm4
  Left = 436
  Top = 210
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Preview'
  ClientHeight = 566
  ClientWidth = 816
  Color = clBtnFace
  DefaultMonitor = dmMainForm
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefaultPosOnly
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object TrackBar1: TTrackBar
    Left = 0
    Top = 521
    Width = 816
    Height = 45
    Align = alBottom
    PageSize = 50
    PopupMenu = PopupMenu1
    TabOrder = 0
    TickStyle = tsNone
    OnChange = TrackBar1Change
  end
  object Image1: TImage32
    Left = 0
    Top = 0
    Width = 816
    Height = 521
    Align = alClient
    Bitmap.ResamplerClassName = 'TNearestResampler'
    BitmapAlign = baTopLeft
    Scale = 1.000000000000000000
    ScaleMode = smNormal
    TabOrder = 1
    OnMouseDown = Image1MouseDown
  end
  object PopupMenu1: TPopupMenu
    Left = 216
    Top = 136
    object CopyFrametoClipboard1: TMenuItem
      Caption = 'Copy Frame to Clipboard'
      OnClick = CopyFrametoClipboard1Click
    end
  end
end
