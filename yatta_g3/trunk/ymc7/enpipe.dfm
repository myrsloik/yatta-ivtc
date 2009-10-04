object ENPipeForm: TENPipeForm
  Left = 281
  Top = 292
  Width = 536
  Height = 316
  Caption = 'ENPipe'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    528
    289)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 95
    Height = 13
    Caption = 'Video command line'
  end
  object Label2: TLabel
    Left = 8
    Top = 120
    Width = 95
    Height = 13
    Caption = 'Audio command line'
  end
  object Memo1: TMemo
    Left = 8
    Top = 24
    Width = 513
    Height = 89
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
  end
  object Memo2: TMemo
    Left = 8
    Top = 136
    Width = 513
    Height = 89
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 1
  end
  object CheckBox1: TCheckBox
    Left = 152
    Top = 256
    Width = 97
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = 'Y4M Headers'
    TabOrder = 2
  end
  object LabeledEdit1: TLabeledEdit
    Left = 8
    Top = 256
    Width = 121
    Height = 21
    Anchors = [akLeft, akBottom]
    EditLabel.Width = 38
    EditLabel.Height = 13
    EditLabel.Caption = 'WaitMS'
    TabOrder = 3
  end
end
