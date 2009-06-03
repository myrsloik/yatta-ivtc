object TFMForm: TTFMForm
  Left = 333
  Top = 228
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'TFM Configuration'
  ClientHeight = 590
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
    590)
  PixelsPerInch = 96
  TextHeight = 13
  object OrderGroup: TRadioGroup
    Left = 0
    Top = 483
    Width = 49
    Height = 53
    Anchors = [akLeft, akBottom]
    Caption = 'Order'
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
  object ModeGroup: TRadioGroup
    Left = 56
    Top = 483
    Width = 49
    Height = 53
    Anchors = [akLeft, akBottom]
    Caption = 'Mode'
    ItemIndex = 0
    Items.Strings = (
      '0'
      '2')
    ParentBackground = False
    TabOrder = 1
    OnClick = OrderGroupClick
  end
  object PPGroup: TRadioGroup
    Left = 112
    Top = 483
    Width = 73
    Height = 106
    Anchors = [akLeft, akBottom]
    Caption = 'PP'
    Columns = 2
    ItemIndex = 6
    Items.Strings = (
      '0'
      '1'
      '2'
      '3'
      '4'
      '5'
      '6'
      '7')
    ParentBackground = False
    TabOrder = 2
    OnClick = OrderGroupClick
  end
  object FieldGroup: TRadioGroup
    Left = 192
    Top = 483
    Width = 65
    Height = 71
    Anchors = [akLeft, akBottom]
    Caption = 'Field'
    ItemIndex = 0
    Items.Strings = (
      'Auto'
      'B'
      'T')
    ParentBackground = False
    TabOrder = 3
    OnClick = OrderGroupClick
  end
  object GroupBox2: TGroupBox
    Left = 320
    Top = 483
    Width = 400
    Height = 73
    Anchors = [akLeft, akRight, akBottom]
    Caption = 'Options'
    ParentBackground = False
    TabOrder = 4
    object CThreshEdit: TLabeledEdit
      Left = 8
      Top = 17
      Width = 41
      Height = 21
      EditLabel.Width = 35
      EditLabel.Height = 13
      EditLabel.Caption = 'cthresh'
      LabelPosition = lpRight
      TabOrder = 0
      OnChange = OrderGroupClick
    end
    object MIEdit: TLabeledEdit
      Left = 8
      Top = 43
      Width = 41
      Height = 21
      EditLabel.Width = 12
      EditLabel.Height = 13
      EditLabel.Caption = 'MI'
      LabelPosition = lpRight
      TabOrder = 3
      OnChange = OrderGroupClick
    end
    object BlockXEdit: TLabeledEdit
      Left = 104
      Top = 17
      Width = 41
      Height = 21
      EditLabel.Width = 31
      EditLabel.Height = 13
      EditLabel.Caption = 'blockx'
      LabelPosition = lpRight
      TabOrder = 1
      OnChange = OrderGroupClick
    end
    object BlockYEdit: TLabeledEdit
      Left = 104
      Top = 43
      Width = 41
      Height = 21
      EditLabel.Width = 31
      EditLabel.Height = 13
      EditLabel.Caption = 'blocky'
      LabelPosition = lpRight
      TabOrder = 4
      OnChange = OrderGroupClick
    end
    object MThreshEdit: TLabeledEdit
      Left = 192
      Top = 17
      Width = 41
      Height = 21
      EditLabel.Width = 37
      EditLabel.Height = 13
      EditLabel.Caption = 'mthresh'
      LabelPosition = lpRight
      TabOrder = 2
      OnChange = OrderGroupClick
    end
    object MakeDefault: TCheckBox
      Left = 216
      Top = 47
      Width = 72
      Height = 17
      Caption = 'Default'
      TabOrder = 5
    end
    object ChromaCheckbox: TCheckBox
      Left = 312
      Top = 13
      Width = 81
      Height = 17
      Caption = 'chroma'
      TabOrder = 6
      OnClick = OrderGroupClick
    end
    object MChromaCheckbox: TCheckBox
      Left = 312
      Top = 30
      Width = 81
      Height = 17
      Caption = 'mChroma'
      Checked = True
      State = cbChecked
      TabOrder = 7
      OnClick = OrderGroupClick
    end
    object DisplayCheckbox: TCheckBox
      Left = 312
      Top = 47
      Width = 81
      Height = 17
      Caption = 'display'
      Checked = True
      State = cbChecked
      TabOrder = 8
      OnClick = OrderGroupClick
    end
  end
  object TrackBar: TTrackBar
    Left = 192
    Top = 560
    Width = 281
    Height = 26
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 5
    TickStyle = tsNone
    OnChange = TrackBarChange
  end
  object GotoButton: TButton
    Left = 561
    Top = 562
    Width = 70
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Goto'
    TabOrder = 6
    OnClick = GotoButtonClick
  end
  object OkButton: TButton
    Left = 642
    Top = 562
    Width = 70
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 7
  end
  object SlowGroup: TRadioGroup
    Left = 264
    Top = 483
    Width = 49
    Height = 73
    Anchors = [akLeft, akBottom]
    Caption = 'Slow'
    ItemIndex = 1
    Items.Strings = (
      '0'
      '1'
      '2')
    ParentBackground = False
    TabOrder = 8
    OnClick = OrderGroupClick
  end
  object MicMatchingGroup: TRadioGroup
    Left = 0
    Top = 537
    Width = 49
    Height = 53
    Anchors = [akLeft, akBottom]
    Caption = 'MicM'
    ItemIndex = 0
    Items.Strings = (
      '0'
      '2')
    ParentBackground = False
    TabOrder = 9
  end
  object SetD2VButton: TButton
    Left = 481
    Top = 562
    Width = 70
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Set d2v'
    TabOrder = 10
    OnClick = SetD2VButtonClick
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
    TabOrder = 11
  end
  object D2VOpenDialog: TOpenDialog
    DefaultExt = 'd2v'
    Filter = 'D2V Files (*.d2v)|*.d2v'
    Options = [ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 496
    Top = 408
  end
end
