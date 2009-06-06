object CutterForm: TCutterForm
  Left = 312
  Top = 310
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Cutter'
  ClientHeight = 542
  ClientWidth = 848
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefaultPosOnly
  DesignSize = (
    848
    542)
  PixelsPerInch = 96
  TextHeight = 13
  object GotoButton: TButton
    Left = 336
    Top = 512
    Width = 70
    Height = 26
    Anchors = [akLeft, akBottom]
    Caption = '&Goto'
    TabOrder = 0
    OnClick = GotoButtonClick
  end
  object OKButton: TButton
    Left = 412
    Top = 512
    Width = 70
    Height = 26
    Anchors = [akLeft, akBottom]
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object FrameTrackbar: TTrackBar
    Left = 0
    Top = 483
    Width = 849
    Height = 27
    Anchors = [akLeft, akRight, akBottom]
    PageSize = 50
    TabOrder = 2
    TickStyle = tsNone
    OnChange = FrameTrackbarChange
  end
  object Image: TImage32
    Left = 128
    Top = 0
    Width = 720
    Height = 480
    Anchors = [akLeft, akTop, akRight, akBottom]
    Bitmap.ResamplerClassName = 'TNearestResampler'
    BitmapAlign = baTopLeft
    Scale = 1.000000000000000000
    ScaleMode = smNormal
    TabOrder = 3
  end
  object CutListBox: TListBox
    Left = 0
    Top = 0
    Width = 124
    Height = 480
    Anchors = [akLeft, akTop, akBottom]
    ItemHeight = 13
    MultiSelect = True
    TabOrder = 4
    OnDblClick = CutListBoxDblClick
  end
  object AddCutButton: TButton
    Left = 6
    Top = 512
    Width = 70
    Height = 26
    Anchors = [akLeft, akBottom]
    Caption = '&Add Cut'
    TabOrder = 5
    OnClick = AddCutButtonClick
  end
  object DeleteCutButton: TButton
    Left = 82
    Top = 512
    Width = 70
    Height = 26
    Anchors = [akLeft, akBottom]
    Caption = '&Delete Cut'
    TabOrder = 6
    OnClick = DeleteCutButtonClick
  end
  object CutStartButton: TButton
    Left = 158
    Top = 512
    Width = 27
    Height = 26
    Anchors = [akLeft, akBottom]
    Caption = '&['
    TabOrder = 7
    OnClick = CutStartButtonClick
  end
  object CutEndButton: TButton
    Left = 191
    Top = 512
    Width = 27
    Height = 26
    Anchors = [akLeft, akBottom]
    Caption = '&]'
    TabOrder = 8
    OnClick = CutEndButtonClick
  end
  object CutStartEdit: TEdit
    Left = 224
    Top = 512
    Width = 49
    Height = 21
    Anchors = [akLeft, akBottom]
    TabOrder = 9
    OnExit = CutStartEditExit
  end
  object CutEndEdit: TEdit
    Left = 280
    Top = 512
    Width = 49
    Height = 21
    Anchors = [akLeft, akBottom]
    TabOrder = 10
    OnExit = CutEndEditExit
  end
end
