object Form11: TForm11
  Left = 194
  Top = 107
  AutoSize = True
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Settings'
  ClientHeight = 221
  ClientWidth = 386
  Color = clBtnFace
  DefaultMonitor = dmMainForm
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 386
    Height = 221
    ActivePage = TabSheet3
    Align = alClient
    TabOrder = 0
    object TabSheet3: TTabSheet
      Caption = 'Project Settings'
      ImageIndex = 2
      DesignSize = (
        378
        193)
      object RadioGroup1: TRadioGroup
        Left = 256
        Top = 0
        Width = 121
        Height = 49
        Caption = '&Order'
        Columns = 2
        ItemIndex = 1
        Items.Strings = (
          '&0'
          '&1')
        TabOrder = 1
        OnClick = RadioGroup1Click
      end
      object RadioGroup2: TRadioGroup
        Left = 256
        Top = 55
        Width = 121
        Height = 58
        Anchors = [akLeft, akTop, akBottom]
        Caption = 'Mpeg2Dec'
        ItemIndex = 1
        Items.Strings = (
          'Mpeg2Dec3'
          'DGDecode')
        TabOrder = 3
      end
      object RadioGroup3: TRadioGroup
        Left = 0
        Top = 54
        Width = 251
        Height = 59
        Anchors = [akLeft, akTop, akBottom]
        Caption = 'New Project Type'
        ItemIndex = 0
        Items.Strings = (
          '0 (freezeframing and sectioning only)'
          '1 (with decomb overrides and vfr)')
        TabOrder = 2
      end
      object GroupBox1: TGroupBox
        Left = 0
        Top = 0
        Width = 251
        Height = 49
        Caption = 'Decimation'
        TabOrder = 0
        object Decimation: TCheckBox
          Left = 8
          Top = 20
          Width = 97
          Height = 17
          Caption = 'Decimate'
          Checked = True
          Enabled = False
          State = cbChecked
          TabOrder = 0
          OnClick = DecimationClick
        end
        object LabeledEdit2: TLabeledEdit
          Left = 147
          Top = 17
          Width = 94
          Height = 21
          EditLabel.Width = 26
          EditLabel.Height = 13
          EditLabel.Caption = 'Cycle'
          LabelPosition = lpLeft
          TabOrder = 1
          OnChange = LabeledEdit2Change
        end
      end
      object GroupBox2: TGroupBox
        Left = 0
        Top = 120
        Width = 377
        Height = 71
        Caption = 'Audio'
        TabOrder = 4
        object AudioFileEdit: TEdit
          Left = 8
          Top = 16
          Width = 361
          Height = 21
          Enabled = False
          TabOrder = 0
          OnClick = AudioFileEditClick
        end
        object AudioDelayLabeledEdit: TLabeledEdit
          Left = 275
          Top = 42
          Width = 94
          Height = 21
          EditLabel.Width = 49
          EditLabel.Height = 13
          EditLabel.Caption = 'Delay (ms)'
          Enabled = False
          LabelPosition = lpLeft
          TabOrder = 1
          OnChange = AudioDelayLabeledEditChange
        end
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'Global Settings'
      object CheckBox1: TCheckBox
        Left = 3
        Top = 56
        Width = 206
        Height = 16
        Caption = 'Save all override files too (save button)'
        TabOrder = 2
      end
      object CheckBox2: TCheckBox
        Left = 216
        Top = 104
        Width = 209
        Height = 16
        Caption = 'Show Metrics'
        Checked = True
        State = cbChecked
        TabOrder = 10
        OnClick = RadioGroup1Click
      end
      object CheckBox3: TCheckBox
        Left = 216
        Top = 120
        Width = 145
        Height = 16
        Caption = 'Show Section Info'
        Checked = True
        State = cbChecked
        TabOrder = 11
        OnClick = RadioGroup1Click
      end
      object CheckBox4: TCheckBox
        Left = 216
        Top = 88
        Width = 97
        Height = 16
        Caption = 'Show Pattern'
        Checked = True
        State = cbChecked
        TabOrder = 9
        OnClick = RadioGroup1Click
      end
      object CheckBox5: TCheckBox
        Left = 216
        Top = 72
        Width = 137
        Height = 16
        Caption = 'Show Freezeframes'
        Checked = True
        State = cbChecked
        TabOrder = 8
        OnClick = RadioGroup1Click
      end
      object CheckBox6: TCheckBox
        Left = 3
        Top = 72
        Width = 193
        Height = 16
        Caption = 'Set nodecimate to c match'
        TabOrder = 3
      end
      object CheckBox8: TCheckBox
        Left = 3
        Top = 88
        Width = 153
        Height = 16
        Caption = 'Show Frame Number'
        TabOrder = 4
        OnClick = RadioGroup1Click
      end
      object LabeledEdit1: TLabeledEdit
        Left = 0
        Top = 16
        Width = 377
        Height = 21
        EditLabel.Width = 45
        EditLabel.Height = 13
        EditLabel.Caption = 'Plugin Dir'
        ReadOnly = True
        TabOrder = 0
        OnClick = LabeledEdit1DblClick
      end
      object CheckBox10: TCheckBox
        Left = 3
        Top = 104
        Width = 206
        Height = 16
        Caption = 'Jump to current frame when previewing'
        Checked = True
        State = cbChecked
        TabOrder = 5
      end
      object CheckBox15: TCheckBox
        Left = 216
        Top = 56
        Width = 145
        Height = 17
        Caption = 'Show too short warning'
        Checked = True
        State = cbChecked
        TabOrder = 7
      end
      object CheckBox13: TCheckBox
        Left = 3
        Top = 40
        Width = 190
        Height = 17
        Caption = 'Save relevant overrides on preview'
        Checked = True
        State = cbChecked
        TabOrder = 1
      end
      object PGDecimation: TCheckBox
        Left = 216
        Top = 41
        Width = 153
        Height = 17
        Caption = 'Pattern guidance with dec.'
        Checked = True
        State = cbChecked
        TabOrder = 6
      end
      object SwapCustomList: TCheckBox
        Left = 3
        Top = 119
        Width = 190
        Height = 17
        Caption = 'Swap Custom List Entries'
        TabOrder = 12
      end
      object ShowCLInfo: TCheckBox
        Left = 216
        Top = 136
        Width = 97
        Height = 17
        Caption = 'Show CL Info'
        Checked = True
        State = cbChecked
        TabOrder = 13
      end
      object CheckBox7: TCheckBox
        Left = 3
        Top = 136
        Width = 177
        Height = 16
        Caption = 'Single click jumps to section'
        TabOrder = 14
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Key Associations'
      ImageIndex = 2
      object Splitter1: TSplitter
        Left = 0
        Top = 162
        Width = 378
        Height = 3
        Cursor = crVSplit
        Align = alBottom
      end
      object ValueListEditor1: TValueListEditor
        Left = 0
        Top = 0
        Width = 378
        Height = 162
        Align = alClient
        KeyOptions = [keyUnique]
        ScrollBars = ssVertical
        Strings.Strings = (
          '')
        TabOrder = 0
        TitleCaptions.Strings = (
          'Event'
          'Key')
        OnKeyDown = ValueListEditor1KeyDown
        OnKeyPress = ValueListEditor1KeyPress
        ColWidths = (
          204
          168)
      end
      object Panel1: TPanel
        Left = 0
        Top = 165
        Width = 378
        Height = 28
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 1
        object Button4: TButton
          Left = 302
          Top = 2
          Width = 75
          Height = 25
          Caption = 'Reset All'
          TabOrder = 0
          OnClick = Button4Click
        end
      end
    end
  end
  object AudioSelectOpenDialog: TOpenDialog
    Options = [ofFileMustExist, ofEnableSizing]
    Left = 108
    Top = 96
  end
end
