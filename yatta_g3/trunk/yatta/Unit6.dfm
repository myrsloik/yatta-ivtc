object Form6: TForm6
  Left = 313
  Top = 286
  AutoSize = True
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Pattern'
  ClientHeight = 265
  ClientWidth = 282
  Color = clBtnFace
  DefaultMonitor = dmMainForm
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 282
    Height = 265
    Align = alClient
    TabOrder = 0
    DesignSize = (
      282
      265)
    object OkButton: TButton
      Left = 144
      Top = 224
      Width = 121
      Height = 25
      Caption = '&OK'
      Default = True
      ModalResult = 1
      TabOrder = 6
    end
    object AskOnTryPattern: TCheckBox
      Left = 24
      Top = 201
      Width = 241
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Don'#39't ask on "Try Pattern"'
      TabOrder = 4
    end
    object PatternEdit: TLabeledEdit
      Left = 16
      Top = 32
      Width = 249
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      EditLabel.Width = 44
      EditLabel.Height = 13
      EditLabel.Caption = 'Matches:'
      TabOrder = 0
    end
    object CancelButton: TButton
      Left = 16
      Top = 224
      Width = 121
      Height = 25
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 5
    end
    object DecimationEdit: TLabeledEdit
      Left = 16
      Top = 80
      Width = 249
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      EditLabel.Width = 56
      EditLabel.Height = 13
      EditLabel.Caption = 'Decimation:'
      TabOrder = 1
    end
    object PostEdit: TLabeledEdit
      Left = 16
      Top = 125
      Width = 249
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      EditLabel.Width = 75
      EditLabel.Height = 13
      EditLabel.Caption = 'Postprocessing:'
      TabOrder = 2
    end
    object FreezeEdit: TLabeledEdit
      Left = 16
      Top = 172
      Width = 249
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      EditLabel.Width = 69
      EditLabel.Height = 13
      EditLabel.Caption = 'FreezeFraming'
      TabOrder = 3
    end
  end
end
