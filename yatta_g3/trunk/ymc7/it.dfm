object ITForm: TITForm
  Left = 208
  Top = 152
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'IT Configuration'
  ClientHeight = 540
  ClientWidth = 720
  Color = clBtnFace
  DefaultMonitor = dmMainForm
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  DesignSize = (
    720
    540)
  PixelsPerInch = 96
  TextHeight = 13
  object GotoButton: TButton
    Left = 158
    Top = 514
    Width = 70
    Height = 26
    Anchors = [akLeft, akBottom]
    Caption = '&Goto'
    TabOrder = 2
    OnClick = GotoButtonClick
  end
  object OKButton: TButton
    Left = 234
    Top = 514
    Width = 70
    Height = 26
    Anchors = [akLeft, akBottom]
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
  object FrameTrackbar: TTrackBar
    Left = 56
    Top = 487
    Width = 664
    Height = 27
    Anchors = [akLeft, akRight, akBottom]
    PageSize = 50
    TabOrder = 1
    TickStyle = tsNone
    OnChange = FrameTrackbarChange
  end
  object OrderGroup: TRadioGroup
    Left = 0
    Top = 483
    Width = 49
    Height = 57
    Anchors = [akLeft, akBottom]
    Caption = '&Order'
    ItemIndex = 1
    Items.Strings = (
      '0'
      '1')
    ParentBackground = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnClick = OrderGroupClick
  end
  object Panel1: TPanel
    Left = 56
    Top = 512
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 4
    DesignSize = (
      97
      25)
    object MakeDefault: TCheckBox
      Left = 4
      Top = 5
      Width = 81
      Height = 17
      Anchors = [akLeft, akBottom]
      Caption = 'Default'
      TabOrder = 0
    end
  end
  object Image: TImage32
    Left = 0
    Top = 0
    Width = 720
    Height = 480
    Anchors = [akLeft, akTop, akRight, akBottom]
    Bitmap.ResamplerClassName = 'TNearestResampler'
    BitmapAlign = baTopLeft
    Scale = 1.000000000000000000
    ScaleMode = smNormal
    TabOrder = 5
  end
end
