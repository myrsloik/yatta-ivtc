object PresetImportForm: TPresetImportForm
  Left = 305
  Top = 388
  AutoScroll = False
  AutoSize = True
  Caption = 'Preset Import'
  ClientHeight = 370
  ClientWidth = 554
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefaultPosOnly
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 554
    Height = 153
    Align = alTop
    Caption = 'Presets'
    TabOrder = 0
    DesignSize = (
      554
      153)
    object Presets: TListBox
      Left = 8
      Top = 16
      Width = 538
      Height = 129
      Anchors = [akLeft, akTop, akRight, akBottom]
      ItemHeight = 13
      MultiSelect = True
      TabOrder = 0
      OnClick = PresetsClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 153
    Width = 554
    Height = 176
    Align = alClient
    Caption = 'Contents'
    TabOrder = 1
    DesignSize = (
      554
      176)
    object PresetContent: TMemo
      Left = 8
      Top = 16
      Width = 538
      Height = 150
      Anchors = [akLeft, akTop, akRight, akBottom]
      ReadOnly = True
      TabOrder = 0
    end
  end
  object GroupBox3: TGroupBox
    Left = 0
    Top = 329
    Width = 554
    Height = 41
    Align = alBottom
    TabOrder = 2
    DesignSize = (
      554
      41)
    object ImportAllButton: TButton
      Left = 458
      Top = 11
      Width = 89
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Import All'
      ModalResult = 8
      TabOrder = 2
    end
    object CancelButton: TButton
      Left = 266
      Top = 11
      Width = 89
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 0
    end
    object ImportSelectedButton: TButton
      Left = 362
      Top = 11
      Width = 89
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Import Selected'
      ModalResult = 1
      TabOrder = 1
    end
  end
end
