object SettingsForm: TSettingsForm
  Left = 714
  Top = 178
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Settings'
  ClientHeight = 260
  ClientWidth = 387
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PrintScale = poNone
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 387
    Height = 260
    ActivePage = GlobalSettings
    Align = alClient
    TabOrder = 0
    object GlobalSettings: TTabSheet
      Caption = 'Global Settings'
      object SetPluginDirButton: TSpeedButton
        Left = 352
        Top = 16
        Width = 23
        Height = 22
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000120B0000120B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
          5555555555555555555555555555555555555555555555555555555555555555
          55555555FFFFFFFFFF5555500000000005555557777777777F55550BFBFBFBFB
          0555557F555555557F55550FBFBFBFBF0555557F555555557F55550BFBFBFBFB
          0555557F555555557F55550FBFBFBFBF0555557F555555557F55550BFBFBFBFB
          0555557F555555557F55550FBFBFBFBF0555557FFFFFFFFF7555550000000000
          555555777777777755555550FBFB0555555555575FFF75555555555700007555
          5555555577775555555555555555555555555555555555555555555555555555
          5555555555555555555555555555555555555555555555555555}
        NumGlyphs = 2
        OnClick = SetPluginDirButtonClick
      end
      object SaveAllOverrides: TCheckBox
        Left = 136
        Top = 72
        Width = 233
        Height = 16
        Caption = 'Save all override files too on project save'
        TabOrder = 1
      end
      object PluginDirEdit: TLabeledEdit
        Left = 8
        Top = 16
        Width = 337
        Height = 21
        EditLabel.Width = 45
        EditLabel.Height = 13
        EditLabel.Caption = 'Plugin Dir'
        ReadOnly = True
        TabOrder = 0
      end
      object JumpToCurrentFrameOnPreview: TCheckBox
        Left = 136
        Top = 88
        Width = 214
        Height = 16
        Caption = 'Jump to current frame when previewing'
        Checked = True
        State = cbChecked
        TabOrder = 2
      end
      object PGTooShortWarning: TCheckBox
        Left = 136
        Top = 55
        Width = 217
        Height = 17
        Caption = 'Show too short section PG warning'
        Checked = True
        State = cbChecked
        TabOrder = 3
      end
      object MPEG2DecRadioGroup: TRadioGroup
        Left = 5
        Top = 48
        Width = 121
        Height = 57
        Caption = 'MPEG2Dec'
        ItemIndex = 0
        Items.Strings = (
          'Mpeg2Dec3'
          'DGDecode')
        TabOrder = 4
      end
    end
    object KeyMappings: TTabSheet
      Caption = 'Key Mappings'
      ImageIndex = 1
      object KeyMappingEditor: TValueListEditor
        Left = 0
        Top = 0
        Width = 379
        Height = 204
        Align = alClient
        KeyOptions = [keyUnique]
        ScrollBars = ssVertical
        Strings.Strings = (
          '')
        TabOrder = 0
        TitleCaptions.Strings = (
          'Action'
          'Key')
        OnKeyDown = KeyMappingEditorKeyDown
        OnKeyPress = KeyMappingEditorKeyPress
        ColWidths = (
          204
          169)
      end
      object Panel1: TPanel
        Left = 0
        Top = 204
        Width = 379
        Height = 28
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 1
        DesignSize = (
          379
          28)
        object ResetAllKeysButton: TButton
          Left = 302
          Top = 2
          Width = 75
          Height = 25
          Anchors = [akRight, akBottom]
          Caption = 'Reset All'
          TabOrder = 0
          OnClick = ResetAllKeysButtonClick
        end
        object ResetKeyButton: TButton
          Left = 227
          Top = 2
          Width = 75
          Height = 25
          Anchors = [akRight, akBottom]
          Caption = 'Reset'
          TabOrder = 1
          OnClick = ResetKeyButtonClick
        end
      end
    end
  end
end
