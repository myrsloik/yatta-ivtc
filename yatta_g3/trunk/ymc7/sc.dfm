object SClavcForm: TSClavcForm
  Left = 860
  Top = 252
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'SClavcForm'
  ClientHeight = 281
  ClientWidth = 492
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
  PixelsPerInch = 96
  TextHeight = 13
  object LogEdit: TLabeledEdit
    Left = 8
    Top = 24
    Width = 233
    Height = 21
    EditLabel.Width = 51
    EditLabel.Height = 13
    EditLabel.Caption = 'Log output'
    TabOrder = 0
    OnDblClick = LogEditDblClick
  end
  object PresetSelect: TComboBox
    Left = 248
    Top = 24
    Width = 241
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 1
    Text = 'lavc default'
    OnChange = PresetSelectChange
    Items.Strings = (
      'lavc default'
      'fast'
      'slow')
  end
  object StaticText1: TStaticText
    Left = 248
    Top = 6
    Width = 81
    Height = 14
    AutoSize = False
    Caption = 'Preset'
    TabOrder = 2
  end
  object PreMeGroup: TRadioGroup
    Left = 1
    Top = 144
    Width = 240
    Height = 81
    Caption = 'preme'
    ItemIndex = 1
    Items.Strings = (
      '0 => never'
      '1 => only after I-frames'
      '2 => always')
    ParentBackground = False
    TabOrder = 5
  end
  object CmpGroup: TRadioGroup
    Left = 1
    Top = 48
    Width = 240
    Height = 89
    Caption = 'cmp'
    ItemIndex = 1
    Items.Strings = (
      '0 => absolute difference (fast)'
      '1 => squared difference (fast)'
      '2 => Hadamard transform (medium)'
      '3 => DCT (slow)')
    ParentBackground = False
    TabOrder = 3
  end
  object SubCmpGroup: TRadioGroup
    Left = 248
    Top = 48
    Width = 241
    Height = 89
    Caption = 'subcmp'
    ItemIndex = 1
    Items.Strings = (
      '0 => absolute difference (fast)'
      '1 => squared difference (fast)'
      '2 => Hadamard transform (medium)'
      '3 => DCT (slow)')
    ParentBackground = False
    TabOrder = 4
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 232
    Width = 241
    Height = 49
    ParentBackground = False
    TabOrder = 7
    object V4MVCheckbox: TCheckBox
      Left = 176
      Top = 20
      Width = 49
      Height = 17
      Caption = 'v4mv'
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
    object DiaEdit: TLabeledEdit
      Left = 32
      Top = 16
      Width = 33
      Height = 21
      EditLabel.Width = 17
      EditLabel.Height = 13
      EditLabel.Caption = 'dia:'
      LabelPosition = lpLeft
      TabOrder = 0
    end
    object PreDiaEdit: TLabeledEdit
      Left = 120
      Top = 16
      Width = 33
      Height = 21
      EditLabel.Width = 32
      EditLabel.Height = 13
      EditLabel.Caption = 'predia:'
      LabelPosition = lpLeft
      TabOrder = 1
    end
  end
  object Button1: TButton
    Left = 405
    Top = 250
    Width = 75
    Height = 25
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 8
  end
  object MbCmpGroup: TRadioGroup
    Left = 249
    Top = 144
    Width = 240
    Height = 89
    Caption = 'mbcmp'
    ItemIndex = 2
    Items.Strings = (
      '0 => absolute difference (fast)'
      '1 => squared difference (fast)'
      '2 => Hadamard transform (medium)'
      '3 => DCT (slow)')
    ParentBackground = False
    TabOrder = 6
  end
  object Panel1: TPanel
    Left = 256
    Top = 248
    Width = 105
    Height = 25
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 9
    object MakeDefault: TCheckBox
      Left = 8
      Top = 4
      Width = 97
      Height = 17
      Caption = 'Default'
      TabOrder = 0
    end
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'txt'
    Filter = 'SClavc log (*.txt)|*.txt'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 152
    Top = 64
  end
end
