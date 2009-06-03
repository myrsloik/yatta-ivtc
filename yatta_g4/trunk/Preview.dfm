object PreviewForm: TPreviewForm
  Left = 842
  Top = 280
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Preview'
  ClientHeight = 525
  ClientWidth = 720
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefaultPosOnly
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object TrackBar: TTrackBar
    Left = 0
    Top = 480
    Width = 720
    Height = 45
    Align = alBottom
    PageSize = 50
    PopupMenu = PopupMenu
    TabOrder = 0
    TickStyle = tsNone
    OnChange = TrackBarChange
  end
  object Image: TImage32
    Left = 0
    Top = 0
    Width = 720
    Height = 480
    Align = alClient
    Bitmap.ResamplerClassName = 'TNearestResampler'
    BitmapAlign = baTopLeft
    Scale = 1.000000000000000000
    ScaleMode = smNormal
    TabOrder = 1
    OnMouseDown = ImageMouseDown
  end
  object PopupMenu: TPopupMenu
    Left = 216
    Top = 136
    object CopyFrametoClipboard1: TMenuItem
      Caption = 'Copy Frame to Clipboard'
      OnClick = CopyFrametoClipboard1Click
    end
  end
end
