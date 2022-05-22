object ProgressForm: TProgressForm
  Left = 425
  Top = 235
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Yatta Metrics Collector'
  ClientHeight = 49
  ClientWidth = 414
  Color = clBtnFace
  DefaultMonitor = dmMainForm
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox2: TGroupBox
    Left = 0
    Top = 0
    Width = 414
    Height = 49
    Align = alBottom
    ParentBackground = False
    TabOrder = 0
    DesignSize = (
      414
      49)
    object CancelButton: TButton
      Left = 328
      Top = 16
      Width = 75
      Height = 25
      Anchors = [akTop, akRight, akBottom]
      Cancel = True
      Caption = '&Cancel'
      TabOrder = 0
      OnClick = CancelButtonClick
    end
  end
  object PopupMenu: TPopupMenu
    OnPopup = PopupMenuPopup
    Left = 16
    Top = 17
    object Closewhendone1: TMenuItem
      AutoCheck = True
      Caption = 'Close when done'
      OnClick = Closewhendone1Click
    end
    object LaunchYatta1: TMenuItem
      AutoCheck = True
      Caption = 'Launch Yatta'
      OnClick = LaunchYatta1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Priority1: TMenuItem
      Caption = 'Priority'
      object Higher1: TMenuItem
        Tag = 4
        AutoCheck = True
        Caption = 'Higher'
        GroupIndex = 1
        RadioItem = True
        OnClick = SetJobPriorityClick
      end
      object Normal1: TMenuItem
        Tag = 3
        AutoCheck = True
        Caption = 'Normal'
        GroupIndex = 1
        RadioItem = True
        OnClick = SetJobPriorityClick
      end
      object Lower1: TMenuItem
        Tag = 2
        AutoCheck = True
        Caption = 'Lower'
        GroupIndex = 1
        RadioItem = True
        OnClick = SetJobPriorityClick
      end
      object Lowest1: TMenuItem
        Tag = 1
        AutoCheck = True
        Caption = 'Lowest'
        GroupIndex = 1
        RadioItem = True
        OnClick = SetJobPriorityClick
      end
      object Idle1: TMenuItem
        AutoCheck = True
        Caption = 'Idle'
        GroupIndex = 1
        RadioItem = True
        OnClick = SetJobPriorityClick
      end
    end
    object Cancel1: TMenuItem
      Caption = 'Cancel'
      OnClick = Cancel1Click
    end
  end
end
