object PresetImportForm: TPresetImportForm
  Left = 289
  Top = 224
  Caption = 'Project Settings Import'
  ClientHeight = 403
  ClientWidth = 668
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 668
    Height = 153
    Align = alTop
    Caption = 'Presets'
    TabOrder = 0
    DesignSize = (
      668
      153)
    object Presets: TListBox
      Left = 8
      Top = 16
      Width = 660
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
    Width = 668
    Height = 208
    Align = alClient
    Caption = 'Contents'
    TabOrder = 1
    DesignSize = (
      668
      208)
    object PresetContent: TMemo
      Left = 8
      Top = 16
      Width = 660
      Height = 194
      Anchors = [akLeft, akTop, akRight, akBottom]
      ReadOnly = True
      TabOrder = 0
    end
  end
  object GroupBox3: TGroupBox
    Left = 0
    Top = 361
    Width = 668
    Height = 42
    Align = alBottom
    TabOrder = 2
    DesignSize = (
      668
      42)
    object ImportAllButton: TButton
      Left = 580
      Top = 11
      Width = 89
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Import All'
      ModalResult = 8
      TabOrder = 2
    end
    object CancelButton: TButton
      Left = 388
      Top = 11
      Width = 89
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 0
    end
    object ImportSelectedButton: TButton
      Left = 484
      Top = 11
      Width = 89
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Import Selected'
      ModalResult = 1
      TabOrder = 1
    end
    object CustomLists: TCheckBox
      Left = 288
      Top = 16
      Width = 97
      Height = 17
      Anchors = [akTop, akRight]
      Caption = 'Custom Lists'
      Checked = True
      State = cbChecked
      TabOrder = 3
    end
    object AVSSettings: TCheckBox
      Left = 168
      Top = 16
      Width = 113
      Height = 17
      Anchors = [akTop, akRight]
      Caption = 'Common Settings'
      Checked = True
      State = cbChecked
      TabOrder = 4
    end
  end
end
