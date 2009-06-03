object TelecideForm: TTelecideForm
  Left = 325
  Top = 198
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Telecide Configuration'
  ClientHeight = 570
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
    570)
  PixelsPerInch = 96
  TextHeight = 13
  object TrackBar: TTrackBar
    Left = 272
    Top = 488
    Width = 217
    Height = 40
    Anchors = [akLeft, akRight, akBottom]
    PageSize = 50
    TabOrder = 1
    TickStyle = tsNone
    OnChange = TrackBarChange
  end
  object GotoButton: TButton
    Left = 342
    Top = 535
    Width = 70
    Height = 26
    Anchors = [akLeft, akBottom]
    Caption = '&Goto'
    TabOrder = 2
    OnClick = GotoButtonClick
  end
  object Panel1: TPanel
    Left = 1
    Top = 485
    Width = 264
    Height = 84
    Anchors = [akLeft, akBottom]
    ParentBackground = False
    TabOrder = 0
    object OrderGroup: TRadioGroup
      Left = 8
      Top = 8
      Width = 49
      Height = 65
      Caption = '&Order'
      ItemIndex = 1
      Items.Strings = (
        '0'
        '1')
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = OrderGroupClick
    end
    object GuideGroup: TRadioGroup
      Left = 64
      Top = 8
      Width = 65
      Height = 65
      Caption = '&Guide'
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        '0'
        '1'
        '2'
        '3')
      TabOrder = 1
      OnClick = GuideGroupClick
    end
    object NTEdit: TLabeledEdit
      Left = 184
      Top = 14
      Width = 41
      Height = 21
      EditLabel.Width = 9
      EditLabel.Height = 13
      EditLabel.Caption = 'nt'
      LabelPosition = lpRight
      TabOrder = 3
      OnChange = NTEditChange
    end
    object GThreshEdit: TLabeledEdit
      Left = 184
      Top = 49
      Width = 41
      Height = 21
      EditLabel.Width = 18
      EditLabel.Height = 13
      EditLabel.Caption = 'gthr'
      Enabled = False
      LabelPosition = lpRight
      TabOrder = 4
      OnChange = GThreshEditChange
    end
    object BackGroup: TRadioGroup
      Left = 136
      Top = 8
      Width = 41
      Height = 65
      Caption = '&Back'
      ItemIndex = 0
      Items.Strings = (
        '0'
        '1'
        '2')
      TabOrder = 2
      OnClick = BackGroupClick
    end
  end
  object Panel2: TPanel
    Left = 496
    Top = 485
    Width = 221
    Height = 84
    Anchors = [akRight, akBottom]
    ParentBackground = False
    TabOrder = 4
    object PostCheckbox: TCheckBox
      Left = 122
      Top = 24
      Width = 89
      Height = 16
      Caption = '&PostProcess'
      Checked = True
      State = cbChecked
      TabOrder = 4
      OnClick = PostCheckboxClick
    end
    object BlendCheckbox: TCheckBox
      Left = 122
      Top = 5
      Width = 65
      Height = 16
      Caption = '&Blend'
      Checked = True
      State = cbChecked
      TabOrder = 3
      OnClick = BlendCheckboxClick
    end
    object VThreshEdit: TLabeledEdit
      Left = 12
      Top = 30
      Width = 41
      Height = 21
      EditLabel.Width = 35
      EditLabel.Height = 13
      EditLabel.Caption = 'vthresh'
      LabelPosition = lpRight
      TabOrder = 1
      OnChange = VThreshEditChange
    end
    object DThreshEdit: TLabeledEdit
      Left = 12
      Top = 56
      Width = 41
      Height = 21
      EditLabel.Width = 35
      EditLabel.Height = 13
      EditLabel.Caption = 'dthresh'
      LabelPosition = lpRight
      TabOrder = 2
      OnChange = DThreshEditChange
    end
    object BThreshEdit: TLabeledEdit
      Left = 12
      Top = 4
      Width = 41
      Height = 21
      EditLabel.Width = 35
      EditLabel.Height = 13
      EditLabel.Caption = 'bthresh'
      LabelPosition = lpRight
      TabOrder = 0
      OnChange = BThreshEditChange
    end
    object ChromaCheckbox: TCheckBox
      Left = 122
      Top = 43
      Width = 97
      Height = 16
      Caption = '&Chroma'
      Checked = True
      State = cbChecked
      TabOrder = 5
      OnClick = ChromaCheckboxClick
    end
    object ShowCheckbox: TCheckBox
      Left = 122
      Top = 61
      Width = 97
      Height = 16
      Caption = 'S&how'
      Checked = True
      State = cbChecked
      TabOrder = 6
      OnClick = ShowCheckboxClick
    end
  end
  object OkButton: TButton
    Left = 418
    Top = 535
    Width = 70
    Height = 26
    Anchors = [akLeft, akBottom]
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
  object Panel3: TPanel
    Left = 268
    Top = 533
    Width = 69
    Height = 28
    Anchors = [akLeft, akBottom]
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 5
    DesignSize = (
      69
      28)
    object MakeDefault: TCheckBox
      Left = 2
      Top = 8
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
    TabOrder = 6
  end
end
