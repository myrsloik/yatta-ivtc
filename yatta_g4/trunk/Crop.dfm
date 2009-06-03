object CropForm: TCropForm
  Left = 287
  Top = 223
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Crop and Resize'
  ClientHeight = 610
  ClientWidth = 915
  Color = clBtnFace
  DefaultMonitor = dmMainForm
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PrintScale = poNone
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ResolutionSeparator: TLabel
    Left = 51
    Top = 348
    Width = 23
    Height = 24
    Alignment = taCenter
    AutoSize = False
    Caption = 'X'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object TrackBar: TTrackBar
    Left = 132
    Top = 577
    Width = 720
    Height = 45
    PageSize = 50
    Frequency = 0
    TabOrder = 19
    TickStyle = tsNone
    OnChange = TrackBarChange
  end
  object CropLeftEdit: TEdit
    Left = 17
    Top = 222
    Width = 33
    Height = 21
    TabOrder = 4
    Text = '0'
    OnChange = UpDownEditChange
  end
  object CropTopEdit: TEdit
    Left = 46
    Top = 198
    Width = 33
    Height = 21
    TabOrder = 2
    Text = '0'
    OnChange = UpDownEditChange
  end
  object CropRightEdit: TEdit
    Left = 75
    Top = 222
    Width = 33
    Height = 21
    TabOrder = 5
    Text = '0'
    OnChange = UpDownEditChange
  end
  object CropBottomEdit: TEdit
    Left = 46
    Top = 246
    Width = 33
    Height = 21
    TabOrder = 8
    Text = '0'
    OnChange = UpDownEditChange
  end
  object AvisynthCropLine: TLabeledEdit
    Left = 2
    Top = 286
    Width = 120
    Height = 21
    EditLabel.Width = 83
    EditLabel.Height = 13
    EditLabel.Caption = 'Avisynth crop line'
    ReadOnly = True
    TabOrder = 9
  end
  object CropBottomUpDown: TUpDown
    Left = 32
    Top = 246
    Width = 13
    Height = 21
    Max = 4096
    TabOrder = 7
    OnClick = CropUpDownClick
  end
  object CropRightUpDown: TUpDown
    Left = 109
    Top = 222
    Width = 13
    Height = 21
    Max = 4096
    TabOrder = 6
    OnClick = CropUpDownClick
  end
  object CropTopUpDown: TUpDown
    Left = 32
    Top = 198
    Width = 13
    Height = 21
    Max = 4096
    TabOrder = 1
    OnClick = CropUpDownClick
  end
  object CropLeftUpDown: TUpDown
    Left = 3
    Top = 222
    Width = 13
    Height = 21
    Max = 4096
    TabOrder = 3
    OnClick = CropUpDownClick
  end
  object AspectRatioError: TLabeledEdit
    Left = 2
    Top = 324
    Width = 120
    Height = 21
    EditLabel.Width = 83
    EditLabel.Height = 13
    EditLabel.Caption = ' Aspect ratio error'
    ReadOnly = True
    TabOrder = 10
  end
  object ZoomGroup: TRadioGroup
    Left = 2
    Top = 120
    Width = 120
    Height = 73
    Caption = 'Zoom'
    ItemIndex = 0
    Items.Strings = (
      'Upper Left'
      'Upper Right'
      'Lower Left'
      'Lower Right')
    ParentBackground = False
    TabOrder = 0
    OnClick = GenericFormUpdate
  end
  object ResizeWidthEdit: TEdit
    Left = 16
    Top = 350
    Width = 33
    Height = 21
    TabOrder = 12
    Text = '640'
    OnChange = UpDownEditChange
  end
  object ResizeWidthUpDown: TUpDown
    Left = 2
    Top = 350
    Width = 13
    Height = 21
    Min = 16
    Max = 4096
    Increment = 4
    Position = 640
    TabOrder = 11
    OnClick = ResizeUpDownClick
  end
  object ResizeHeightEdit: TEdit
    Left = 75
    Top = 350
    Width = 33
    Height = 21
    TabOrder = 13
    Text = '480'
    OnChange = UpDownEditChange
  end
  object ResizeHeightUpDown: TUpDown
    Left = 109
    Top = 350
    Width = 13
    Height = 21
    Min = 16
    Max = 4096
    Increment = 4
    Position = 480
    TabOrder = 14
    OnClick = ResizeUpDownClick
  end
  object PARGroup: TRadioGroup
    Left = 2
    Top = 375
    Width = 120
    Height = 90
    Caption = 'Pixel Aspect Ratio'
    ItemIndex = 1
    Items.Strings = (
      '1:1'
      '4:3 NTSC DVD'
      '16:9 NTSC DVD'
      '4:3 PAL DVD'
      '16:9 PAL DVD')
    ParentBackground = False
    TabOrder = 15
    OnClick = GenericFormUpdate
  end
  object Anamorphic: TCheckBox
    Left = 8
    Top = 468
    Width = 113
    Height = 17
    Caption = 'Anamorphic'
    TabOrder = 16
    OnClick = AnamorphicClick
  end
  object ShowResized: TCheckBox
    Left = 8
    Top = 485
    Width = 113
    Height = 17
    Caption = 'Show Resized'
    TabOrder = 17
    OnClick = GenericFormUpdate
  end
  object MPlayerPAR: TCheckBox
    Left = 8
    Top = 502
    Width = 113
    Height = 17
    Caption = 'MPlayer PAR'
    TabOrder = 18
    OnClick = GenericFormUpdate
  end
  object Image: TImage32
    Left = 132
    Top = 0
    Width = 493
    Height = 393
    Bitmap.ResamplerClassName = 'TKernelResampler'
    Bitmap.Resampler.KernelClassName = 'TLanczosKernel'
    Bitmap.Resampler.Kernel.Width = 3.000000000000000000
    Bitmap.Resampler.KernelMode = kmDynamic
    Bitmap.Resampler.TableSize = 32
    BitmapAlign = baTopLeft
    Scale = 1.000000000000000000
    ScaleMode = smNormal
    TabOrder = 20
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
    TabOrder = 21
  end
end
