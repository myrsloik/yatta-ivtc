object MainForm: TMainForm
  Left = 352
  Top = 182
  AutoScroll = False
  Caption = 'Yatta Metrics Collector 7.8'
  ClientHeight = 450
  ClientWidth = 622
  Color = clBtnFace
  Constraints.MinHeight = 330
  Constraints.MinWidth = 489
  DefaultMonitor = dmDesktop
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefaultPosOnly
  Visible = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    622
    450)
  PixelsPerInch = 96
  TextHeight = 13
  object Jobs: TGroupBox
    Left = 0
    Top = 0
    Width = 425
    Height = 450
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'Job List'
    ParentBackground = False
    TabOrder = 0
    DesignSize = (
      425
      450)
    object MoveJobUpButton: TSpeedButton
      Left = 398
      Top = 13
      Width = 22
      Height = 22
      Action = MoveJobUpAction
      Anchors = [akTop, akRight]
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333000333
        3333333333777F33333333333309033333333333337F7F333333333333090333
        33333333337F7F33333333333309033333333333337F7F333333333333090333
        33333333337F7F33333333333309033333333333FF7F7FFFF333333000090000
        3333333777737777F333333099999990333333373F3333373333333309999903
        333333337F33337F33333333099999033333333373F333733333333330999033
        3333333337F337F3333333333099903333333333373F37333333333333090333
        33333333337F7F33333333333309033333333333337373333333333333303333
        333333333337F333333333333330333333333333333733333333}
      NumGlyphs = 2
    end
    object MoveJobDownButton: TSpeedButton
      Left = 398
      Top = 35
      Width = 22
      Height = 22
      Action = MoveJobDownAction
      Anchors = [akTop, akRight]
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333303333
        333333333337F33333333333333033333333333333373F333333333333090333
        33333333337F7F33333333333309033333333333337373F33333333330999033
        3333333337F337F33333333330999033333333333733373F3333333309999903
        333333337F33337F33333333099999033333333373333373F333333099999990
        33333337FFFF3FF7F33333300009000033333337777F77773333333333090333
        33333333337F7F33333333333309033333333333337F7F333333333333090333
        33333333337F7F33333333333309033333333333337F7F333333333333090333
        33333333337F7F33333333333300033333333333337773333333}
      NumGlyphs = 2
    end
    object JobList: TListBox
      Left = 7
      Top = 13
      Width = 386
      Height = 401
      Style = lbVirtual
      Anchors = [akLeft, akTop, akRight, akBottom]
      ItemHeight = 13
      ParentShowHint = False
      PopupMenu = JobPopupMenu
      ShowHint = True
      TabOrder = 0
      OnClick = JobListClick
      OnData = JobListData
      OnDataObject = JobListDataObject
      OnDblClick = SetOutputActionExecute
    end
    object AddButton: TButton
      Left = 7
      Top = 419
      Width = 75
      Height = 25
      Action = AddAction
      Anchors = [akLeft, akBottom]
      TabOrder = 1
    end
    object RemoveButton: TButton
      Left = 94
      Top = 419
      Width = 75
      Height = 25
      Action = RemoveAction
      Anchors = [akLeft, akBottom]
      TabOrder = 2
    end
    object SetOutputButton: TButton
      Left = 181
      Top = 419
      Width = 75
      Height = 25
      Action = SetOutputAction
      Anchors = [akLeft, akBottom]
      TabOrder = 3
    end
  end
  object Settings: TGroupBox
    Left = 430
    Top = 0
    Width = 191
    Height = 62
    Anchors = [akTop, akRight]
    Caption = 'Settings'
    ParentBackground = False
    TabOrder = 1
    object CloseWhenDone: TCheckBox
      Left = 7
      Top = 17
      Width = 143
      Height = 18
      Caption = 'Close when done'
      TabOrder = 0
    end
    object LaunchWhenDone: TCheckBox
      Left = 7
      Top = 37
      Width = 162
      Height = 18
      Caption = 'Launch YATTA'
      TabOrder = 1
    end
  end
  object Mpeg2DecRadioGroup: TRadioGroup
    Left = 430
    Top = 68
    Width = 191
    Height = 69
    Anchors = [akTop, akRight]
    Caption = 'Mpeg2Dec'
    ItemIndex = 0
    Items.Strings = (
      'Mpeg2Dec3'
      'DGDecode')
    ParentBackground = False
    TabOrder = 2
    OnClick = Mpeg2DecRadioGroupClick
  end
  object Metrics: TGroupBox
    Left = 430
    Top = 144
    Width = 191
    Height = 306
    Anchors = [akTop, akRight, akBottom]
    Caption = 'Metric Collection'
    ParentBackground = False
    TabOrder = 3
    DesignSize = (
      191
      306)
    object MoveFilterUpButton: TSpeedButton
      Left = 164
      Top = 13
      Width = 22
      Height = 22
      Action = MoveFilterUpAction
      Anchors = [akTop, akRight]
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333000333
        3333333333777F33333333333309033333333333337F7F333333333333090333
        33333333337F7F33333333333309033333333333337F7F333333333333090333
        33333333337F7F33333333333309033333333333FF7F7FFFF333333000090000
        3333333777737777F333333099999990333333373F3333373333333309999903
        333333337F33337F33333333099999033333333373F333733333333330999033
        3333333337F337F3333333333099903333333333373F37333333333333090333
        33333333337F7F33333333333309033333333333337373333333333333303333
        333333333337F333333333333330333333333333333733333333}
      NumGlyphs = 2
    end
    object MoveFilterDownButton: TSpeedButton
      Left = 164
      Top = 35
      Width = 22
      Height = 22
      Action = MoveFilterDownAction
      Anchors = [akTop, akRight]
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333303333
        333333333337F33333333333333033333333333333373F333333333333090333
        33333333337F7F33333333333309033333333333337373F33333333330999033
        3333333337F337F33333333330999033333333333733373F3333333309999903
        333333337F33337F33333333099999033333333373333373F333333099999990
        33333337FFFF3FF7F33333300009000033333337777F77773333333333090333
        33333333337F7F33333333333309033333333333337F7F333333333333090333
        33333333337F7F33333333333309033333333333337F7F333333333333090333
        33333333337F7F33333333333300033333333333337773333333}
      NumGlyphs = 2
    end
    object ConfigureButton: TButton
      Left = 7
      Top = 246
      Width = 177
      Height = 25
      Action = ConfigureAction
      Anchors = [akLeft, akRight, akBottom]
      TabOrder = 1
    end
    object StartButton: TButton
      Left = 7
      Top = 275
      Width = 177
      Height = 25
      Action = StartAction
      Anchors = [akLeft, akRight, akBottom]
      TabOrder = 2
    end
    object MetricFilterList: TCheckListBox
      Left = 7
      Top = 13
      Width = 152
      Height = 227
      OnClickCheck = MetricFilterListClickCheck
      Anchors = [akLeft, akTop, akRight, akBottom]
      ItemHeight = 13
      TabOrder = 0
      OnDblClick = MetricFilterListDblClick
    end
  end
  object OpenDialog: TOpenDialog
    Filter = 
      'Video (*.avi;*.avs;*.d2v;*.dga)|*.avi;*.avs;*.d2v;*.dga|All File' +
      's (*.*)|*.*'
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 184
    Top = 136
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'yap'
    Filter = 'Yatta V2 projects (*.yap)|*.yap'
    FilterIndex = 0
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 216
    Top = 136
  end
  object ActionList: TActionList
    Left = 248
    Top = 136
    object AddAction: TAction
      Category = 'JobList'
      Caption = '&Add'
      ShortCut = 65
      OnExecute = AddActionExecute
    end
    object MoveJobDownAction: TAction
      Category = 'JobList'
      ShortCut = 68
      OnExecute = MoveJobDownActionExecute
      OnUpdate = MoveJobDownActionUpdate
    end
    object MoveJobUpAction: TAction
      Category = 'JobList'
      ShortCut = 85
      OnExecute = MoveJobUpActionExecute
      OnUpdate = MoveJobUpActionUpdate
    end
    object SetOutputAction: TAction
      Category = 'JobList'
      Caption = 'Set &Output'
      ShortCut = 79
      OnExecute = SetOutputActionExecute
      OnUpdate = SetOutputActionUpdate
    end
    object RemoveAction: TAction
      Category = 'JobList'
      Caption = '&Remove'
      ShortCut = 82
      OnExecute = RemoveActionExecute
      OnUpdate = RemoveActionUpdate
    end
    object ConfigureAction: TAction
      Category = 'MetricsCollection'
      Caption = '&Configure'
      ShortCut = 67
      OnExecute = ConfigureActionExecute
      OnUpdate = ConfigureActionUpdate
    end
    object StartAction: TAction
      Category = 'MetricsCollection'
      Caption = '&Start'
      ShortCut = 83
      OnExecute = StartActionExecute
      OnUpdate = StartActionUpdate
    end
    object MarkAsReadyAction: TAction
      Category = 'JobList'
      Caption = 'Mark As Ready'
      OnExecute = MarkAsReadyActionExecute
      OnUpdate = MarkAsReadyActionUpdate
    end
    object MoveFilterUpAction: TAction
      Category = 'MetricsCollection'
      OnExecute = MoveFilterUpActionExecute
      OnUpdate = MoveFilterUpActionUpdate
    end
    object MoveFilterDownAction: TAction
      Category = 'MetricsCollection'
      OnExecute = MoveFilterDownActionExecute
      OnUpdate = MoveFilterDownActionUpdate
    end
  end
  object JobPopupMenu: TPopupMenu
    Left = 280
    Top = 136
    object ClearErrors1: TMenuItem
      Action = MarkAsReadyAction
      Caption = 'Clear Errors'
    end
    object ClearAllErrors1: TMenuItem
      Caption = 'Clear All Errors'
      OnClick = ClearAllErrors1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object SetAvisynthPluginDirectory1: TMenuItem
      Caption = 'Set Avisynth Plugin Directory'
      OnClick = SetAvisynthPluginDirectory1Click
    end
    object SetDefaultTaskPriority1: TMenuItem
      Caption = 'Set Default Task Priority'
      object Higher1: TMenuItem
        Tag = 4
        AutoCheck = True
        Caption = 'Higher'
        GroupIndex = 1
        RadioItem = True
        OnClick = SetDefaultPriorityClick
      end
      object Normal1: TMenuItem
        Tag = 3
        AutoCheck = True
        Caption = 'Normal'
        GroupIndex = 1
        RadioItem = True
        OnClick = SetDefaultPriorityClick
      end
      object Lower1: TMenuItem
        Tag = 2
        AutoCheck = True
        Caption = 'Lower'
        GroupIndex = 1
        RadioItem = True
        OnClick = SetDefaultPriorityClick
      end
      object Lowest1: TMenuItem
        Tag = 1
        AutoCheck = True
        Caption = 'Lowest'
        GroupIndex = 1
        RadioItem = True
        OnClick = SetDefaultPriorityClick
      end
      object Idle1: TMenuItem
        AutoCheck = True
        Caption = 'Idle'
        GroupIndex = 1
        RadioItem = True
        OnClick = SetDefaultPriorityClick
      end
    end
    object SetMaxRunningJobs1: TMenuItem
      Caption = 'Set Max Running Jobs'
      Enabled = False
      OnClick = SetMaxRunningJobs1Click
    end
  end
  object XPManifest: TXPManifest
    Left = 312
    Top = 136
  end
end
