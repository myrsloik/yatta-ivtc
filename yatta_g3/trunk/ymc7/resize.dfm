object ResizeForm: TResizeForm
  Left = 288
  Top = 538
  BorderStyle = bsDialog
  Caption = 'Resize'
  ClientHeight = 178
  ClientWidth = 327
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
  object ResizerGroup: TRadioGroup
    Left = 0
    Top = 8
    Width = 185
    Height = 129
    Caption = 'Resizer'
    ItemIndex = 0
    Items.Strings = (
      'Bilinear'
      'Bicubic'
      'Lanczos'
      'Lanczos4'
      'Spline16'
      'Spline36')
    TabOrder = 0
  end
  object WidthEdit: TLabeledEdit
    Left = 200
    Top = 32
    Width = 121
    Height = 21
    EditLabel.Width = 28
    EditLabel.Height = 13
    EditLabel.Caption = 'Width'
    TabOrder = 1
  end
  object HeightEdit: TLabeledEdit
    Left = 200
    Top = 80
    Width = 121
    Height = 21
    EditLabel.Width = 31
    EditLabel.Height = 13
    EditLabel.Caption = 'Height'
    TabOrder = 2
  end
  object OKButton: TButton
    Left = 8
    Top = 145
    Width = 70
    Height = 26
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
  object MakeDefault: TCheckBox
    Left = 88
    Top = 152
    Width = 89
    Height = 17
    Caption = 'Default'
    TabOrder = 4
  end
end
