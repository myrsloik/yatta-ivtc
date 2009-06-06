object CropForm: TCropForm
  Left = 574
  Top = 546
  AutoSize = True
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Crop'
  ClientHeight = 510
  ClientWidth = 851
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
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    851
    510)
  PixelsPerInch = 96
  TextHeight = 13
  object TrackBar: TTrackBar
    Left = 131
    Top = 480
    Width = 718
    Height = 30
    PageSize = 50
    Frequency = 0
    TabOrder = 9
    TickStyle = tsNone
    OnChange = TrackBarChange
  end
  object Edit2: TEdit
    Left = 14
    Top = 252
    Width = 27
    Height = 21
    TabOrder = 4
    Text = '0'
    OnChange = Edit3Change
  end
  object Edit3: TEdit
    Left = 39
    Top = 230
    Width = 27
    Height = 21
    TabOrder = 2
    Text = '0'
    OnChange = Edit3Change
  end
  object Edit4: TEdit
    Left = 64
    Top = 252
    Width = 27
    Height = 21
    TabOrder = 5
    Text = '0'
    OnChange = Edit3Change
  end
  object Edit5: TEdit
    Left = 39
    Top = 274
    Width = 27
    Height = 21
    TabOrder = 8
    Text = '0'
    OnChange = Edit3Change
  end
  object UpDown1: TUpDown
    Left = 27
    Top = 274
    Width = 11
    Height = 22
    Max = 2000
    Increment = 4
    TabOrder = 7
    OnClick = UpDown1Click
  end
  object UpDown2: TUpDown
    Left = 92
    Top = 251
    Width = 11
    Height = 22
    Max = 2000
    Increment = 2
    TabOrder = 6
    OnClick = UpDown2Click
  end
  object UpDown3: TUpDown
    Left = 27
    Top = 229
    Width = 11
    Height = 22
    Max = 2000
    Increment = 4
    TabOrder = 1
    OnClick = UpDown3Click
  end
  object UpDown4: TUpDown
    Left = 2
    Top = 251
    Width = 11
    Height = 22
    Max = 2000
    Increment = 2
    TabOrder = 3
    OnClick = UpDown4Click
  end
  object RadioGroup1: TRadioGroup
    Left = 2
    Top = 122
    Width = 97
    Height = 87
    Caption = '&Zoom'
    ItemIndex = 0
    Items.Strings = (
      'Upper Left'
      'Upper Right'
      'Lower Left'
      'Lower Right')
    ParentBackground = False
    TabOrder = 0
    OnClick = RadioGroup1Click
  end
  object Panel1: TPanel
    Left = 0
    Top = 296
    Width = 105
    Height = 33
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 10
    object MakeDefault: TCheckBox
      Left = 8
      Top = 16
      Width = 89
      Height = 17
      Caption = 'Default'
      TabOrder = 0
    end
  end
  object ZoomImage: TImage32
    Left = 2
    Top = 0
    Width = 120
    Height = 120
    Bitmap.ResamplerClassName = 'TNearestResampler'
    BitmapAlign = baTopLeft
    Scale = 3.000000000000000000
    ScaleMode = smScale
    TabOrder = 11
  end
  object Image: TImage32
    Left = 131
    Top = 0
    Width = 720
    Height = 480
    AutoSize = True
    Bitmap.ResamplerClassName = 'TNearestResampler'
    BitmapAlign = baTopLeft
    Scale = 1.000000000000000000
    ScaleMode = smNormal
    TabOrder = 12
  end
  object OKButton: TButton
    Left = 20
    Top = 340
    Width = 70
    Height = 26
    Anchors = [akLeft, akBottom]
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 13
  end
end
