object SCXvidForm: TSCXvidForm
  Left = 345
  Top = 259
  AutoSize = True
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  BorderWidth = 10
  Caption = 'SCXvid'
  ClientHeight = 74
  ClientWidth = 289
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object LogEdit: TLabeledEdit
    Left = 0
    Top = 16
    Width = 289
    Height = 21
    EditLabel.Width = 51
    EditLabel.Height = 13
    EditLabel.Caption = 'Log output'
    TabOrder = 0
    OnDblClick = LogEditChange
  end
  object MakeDefault: TCheckBox
    Left = 0
    Top = 52
    Width = 97
    Height = 17
    Caption = 'Default'
    TabOrder = 1
  end
  object OKButton: TButton
    Left = 213
    Top = 49
    Width = 75
    Height = 25
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 2
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'txt'
    Filter = 'SCXvid log (*.txt)|*.txt'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 88
  end
end
