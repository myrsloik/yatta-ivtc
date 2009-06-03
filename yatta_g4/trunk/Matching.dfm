object MatchForm: TMatchForm
  Left = 388
  Top = 424
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'YATTA - Test'
  ClientHeight = 570
  ClientWidth = 720
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  PopupMenu = PopupMenu
  Position = poScreenCenter
  PrintScale = poNone
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object FrameTrackBar: TTrackBar
    Left = 0
    Top = 480
    Width = 720
    Height = 30
    Align = alBottom
    PageSize = 50
    TabOrder = 0
    TickStyle = tsNone
    OnChange = FrameTrackBarChange
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 551
    Width = 720
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object AlignPanel: TPanel
    Left = 0
    Top = 510
    Width = 720
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object UsePatternButton: TButton
      Left = 631
      Top = 21
      Width = 78
      Height = 19
      Action = UsePatternAction
      TabOrder = 17
    end
    object OpenCloseButton: TButton
      Left = 7
      Top = 21
      Width = 78
      Height = 19
      Action = OpenAction
      TabOrder = 9
    end
    object SaveButton: TButton
      Left = 7
      Top = 2
      Width = 78
      Height = 19
      Action = SaveAction
      TabOrder = 0
    end
    object SwitchButton: TButton
      Left = 163
      Top = 21
      Width = 78
      Height = 19
      Action = SwitchAction
      TabOrder = 11
    end
    object TryPatternButton: TButton
      Left = 163
      Top = 2
      Width = 78
      Height = 19
      Action = TryPatternAction
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
    object ResetMatchButton: TButton
      Left = 319
      Top = 21
      Width = 78
      Height = 19
      Action = ResetAction
      TabOrder = 13
    end
    object PreviewButton: TButton
      Left = 475
      Top = 2
      Width = 78
      Height = 19
      Action = PreviewAction
      TabOrder = 6
    end
    object ToolsButton: TButton
      Left = 85
      Top = 2
      Width = 78
      Height = 19
      Action = ToolsAction
      TabOrder = 1
    end
    object SettingsButton: TButton
      Left = 85
      Top = 21
      Width = 78
      Height = 19
      Action = SettingsAction
      TabOrder = 10
    end
    object DecimateButton: TButton
      Left = 553
      Top = 21
      Width = 78
      Height = 19
      Action = DecimateAction
      TabOrder = 16
    end
    object AddSectionButton: TButton
      Left = 475
      Top = 21
      Width = 78
      Height = 19
      Action = AddSectionAction
      TabOrder = 15
    end
    object FreezeFrameButton: TButton
      Left = 319
      Top = 2
      Width = 78
      Height = 18
      Action = AddFreezeFrameAction
      TabOrder = 4
    end
    object PostprocessButton: TButton
      Left = 553
      Top = 2
      Width = 78
      Height = 19
      Action = PostprocessAction
      TabOrder = 7
    end
    object PlayButton: TButton
      Left = 241
      Top = 2
      Width = 78
      Height = 19
      Action = PlayAction
      TabOrder = 3
    end
    object GotoButton: TButton
      Left = 241
      Top = 21
      Width = 78
      Height = 19
      Action = GotoAction
      TabOrder = 12
    end
    object DecimationMarkerButton: TButton
      Left = 397
      Top = 21
      Width = 78
      Height = 19
      Action = AddDecimationAction
      TabOrder = 14
    end
    object RangeButton: TButton
      Left = 397
      Top = 2
      Width = 78
      Height = 19
      Action = AddRangeAction
      TabOrder = 5
    end
    object QuickRangeButton: TButton
      Left = 631
      Top = 2
      Width = 78
      Height = 19
      Action = SetRangeAction
      TabOrder = 8
    end
  end
  object Image: TImage32
    Left = 0
    Top = 0
    Width = 720
    Height = 480
    Align = alClient
    Bitmap.ResamplerClassName = 'TNearestResampler'
    BitmapAlign = baTopLeft
    Scale = 1.000000000000000000
    ScaleMode = smNormal
    TabOrder = 3
  end
  object FieldMatchSaveDialog: TSaveDialog
    DefaultExt = 'fh.txt'
    Filter = 'Fieldmatch Information (*.fh.txt)|*.fh.txt'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 64
    Top = 40
  end
  object PopupMenu: TPopupMenu
    Left = 160
    Top = 40
    object SaveProject1: TMenuItem
      Caption = 'Save Project As'
    end
    object Save1: TMenuItem
      Caption = 'Save Project'
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object SaveAllOverrides1: TMenuItem
      Caption = 'Save All Overrides (Project Path)'
      OnClick = SaveAllOverrides1Click
    end
    object SaveFieldHints1: TMenuItem
      Caption = 'Save FieldHints'
      OnClick = SaveFieldHints1Click
    end
    object SaveTimecodes1: TMenuItem
      Caption = 'Save Timecodes'
      OnClick = SaveTimecodes1Click
    end
    object SaveAvisynthScript1: TMenuItem
      Caption = 'Save Avisynth Script'
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object CopyToClipboard1: TMenuItem
      Caption = 'Copy Frame to Clipboard'
    end
    object ShowText1: TMenuItem
      AutoCheck = True
      Caption = 'Show Text'
      Checked = True
      OnClick = GenericUpdateFrame
    end
    object ShowFrozen1: TMenuItem
      AutoCheck = True
      Caption = 'Show Frozen'
      Checked = True
    end
    object PlaybackSpeed1: TMenuItem
      Caption = 'Playback Speed'
    end
    object SetPattern1: TMenuItem
      Caption = 'Set Pattern'
    end
    object Switching1: TMenuItem
      Caption = 'Switching'
      object TFFSwitching1: TMenuItem
        AutoCheck = True
        Caption = 'TFF'
        Checked = True
        RadioItem = True
        OnClick = TFFSwitching1Click
      end
      object BFF1: TMenuItem
        AutoCheck = True
        Caption = 'BFF'
        RadioItem = True
        OnClick = BFF1Click
      end
      object N5: TMenuItem
        Caption = '-'
        GroupIndex = 1
      end
      object Switchcnonly1: TMenuItem
        AutoCheck = True
        Caption = 'Switch c/n only'
        Checked = True
        GroupIndex = 2
        RadioItem = True
        OnClick = GenericUpdateFrame
      end
      object Switchpconly1: TMenuItem
        AutoCheck = True
        Caption = 'Switch p/c only'
        GroupIndex = 2
        RadioItem = True
        OnClick = GenericUpdateFrame
      end
      object Switchncp1: TMenuItem
        AutoCheck = True
        Caption = 'Switch n/c/p'
        GroupIndex = 2
        RadioItem = True
        OnClick = GenericUpdateFrame
      end
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Project1: TMenuItem
      Caption = 'Project'
      object ClearPostprocessed1: TMenuItem
        Caption = 'Clear Postprocessed'
        OnClick = ClearPostprocessed1Click
      end
      object ClearDecimated1: TMenuItem
        Caption = 'Clear Decimated'
        OnClick = ClearDecimated1Click
      end
      object DecimationbyPattern1: TMenuItem
        Caption = 'Decimation by Pattern'
      end
      object Cmatchestovfr1: TMenuItem
        Caption = 'C Matches to VFR'
      end
    end
    object PatternGuidance1: TMenuItem
      Caption = 'Pattern Guidance'
    end
    object Cropping1: TMenuItem
      Caption = 'Crop and Resize'
      OnClick = Cropping1Click
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object About1: TMenuItem
      Caption = 'About'
      OnClick = About1Click
    end
  end
  object ProjectSaveDialog: TSaveDialog
    DefaultExt = 'yap'
    Filter = 'Yatta Project (*.yap)|*.yap'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 32
    Top = 40
  end
  object ProjectOpenDialog: TOpenDialog
    FileName = 'C:\Project\Fruits Basket - 01_Project4.d2v.yap'
    Filter = 
      'All Supported|*.avi;*.d2v;*.avs;*.yap|Projects|*.yap|Video|*.avi' +
      ';*.d2v;*.avs'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 128
    Top = 40
  end
  object TimecodeSaveDialog: TSaveDialog
    DefaultExt = 'vfr.txt'
    Filter = 'Timecode Format V1/2 (*.vfr.txt)|*.vfr.txt'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 96
    Top = 40
  end
  object ActionList: TActionList
    OnExecute = ActionListExecute
    Left = 192
    Top = 40
    object JumpPlus5FramesAction: TAction
      Category = 'FrameJump'
      Caption = 'Jump +5 Frames'
      OnExecute = JumpPlus5FramesActionExecute
    end
    object JumpPlus10FramesAction: TAction
      Category = 'FrameJump'
      Caption = 'Jump +10 Frames'
      OnExecute = JumpPlus10FramesActionExecute
    end
    object SwitchAction: TAction
      Category = 'MainActions'
      Caption = 'Switch'
      ShortCut = 83
      OnExecute = SwitchActionExecute
      OnUpdate = ProjectOpenUpdate
    end
    object JumpPlus50FramesAction: TAction
      Category = 'FrameJump'
      Caption = 'Jump +50 Frames'
      OnExecute = JumpPlus50FramesActionExecute
    end
    object SetRangeAction: TAction
      Category = 'MainActions'
      Caption = 'Range Start'
      ShortCut = 69
      OnExecute = SetRangeActionExecute
      OnUpdate = ProjectOpenUpdate
    end
    object TryPatternAction: TAction
      Category = 'MainActions'
      Caption = 'Try Pattern'
      ShortCut = 84
      OnExecute = TryPatternActionExecute
      OnUpdate = ProjectOpenUpdate
    end
    object PostprocessAction: TAction
      Category = 'MainActions'
      Caption = 'Postprocess'
      ShortCut = 80
      OnExecute = PostprocessActionExecute
      OnUpdate = ProjectOpenUpdate
    end
    object DecimateAction: TAction
      Category = 'MainActions'
      Caption = 'Decimate'
      ShortCut = 68
      OnExecute = DecimateActionExecute
      OnUpdate = ProjectOpenUpdate
    end
    object ResetAction: TAction
      Category = 'MainActions'
      Caption = 'Reset'
      ShortCut = 82
      OnExecute = ResetActionExecute
      OnUpdate = ProjectOpenUpdate
    end
    object GotoAction: TAction
      Category = 'MainActions'
      Caption = 'Goto'
      ShortCut = 71
      OnExecute = GotoActionExecute
      OnUpdate = ProjectOpenUpdate
    end
    object SaveAction: TAction
      Category = 'MainActions'
      Caption = 'Save'
      OnExecute = SaveActionExecute
      OnUpdate = ProjectOpenUpdate
    end
    object OpenAction: TAction
      Category = 'MainActions'
      Caption = 'Open'
      ShortCut = 16463
      OnExecute = OpenActionExecute
    end
    object CloseAction: TAction
      Category = 'MainActions'
      Caption = 'Close'
      OnExecute = CloseActionExecute
      OnUpdate = ProjectOpenUpdate
    end
    object PreviewAction: TAction
      Category = 'MainActions'
      Caption = 'Preview'
      ShortCut = 115
      OnExecute = PreviewActionExecute
      OnUpdate = ProjectOpenUpdate
    end
    object SettingsAction: TAction
      Category = 'MainActions'
      Caption = 'Settings'
      OnExecute = SettingsActionExecute
    end
    object ToolsAction: TAction
      Category = 'MainActions'
      Caption = 'Tools'
      OnExecute = ToolsActionExecute
      OnUpdate = ProjectOpenUpdate
    end
    object PlayAction: TAction
      Category = 'MainActions'
      Caption = 'Play'
      OnUpdate = ProjectOpenUpdate
    end
    object AddRangeAction: TAction
      Category = 'ToolActions'
      Caption = 'Range'
      ShortCut = 67
      OnExecute = AddRangeActionExecute
      OnUpdate = ProjectOpenUpdate
    end
    object AddDecimationAction: TAction
      Category = 'ToolActions'
      Caption = 'Decimation'
      ShortCut = 79
      OnExecute = AddDecimationActionExecute
      OnUpdate = ProjectOpenUpdate
    end
    object AddFreezeFrameAction: TAction
      Category = 'ToolActions'
      Caption = 'FreezeFrame'
      ShortCut = 70
      OnExecute = AddFreezeFrameActionExecute
      OnUpdate = ProjectOpenUpdate
    end
    object AddSectionAction: TAction
      Category = 'ToolActions'
      Caption = 'Section'
      ShortCut = 73
      OnExecute = AddSectionActionExecute
      OnUpdate = ProjectOpenUpdate
    end
    object SwitchToComplementAction: TAction
      Caption = 'SwitchToComplementAction'
    end
    object SetPatternAction: TAction
      Caption = 'SetPatternAction'
    end
    object ResetSectionAction: TAction
      Caption = 'ResetSectionAction'
    end
    object ShiftPatternInSectionAction: TAction
      Caption = 'Shift Pattern In Section'
    end
    object JumpToNextPPAction: TAction
      Caption = 'JumpToNextPPAction'
    end
    object FindVFRType1Action: TAction
      Caption = 'FindVFRType1Action'
    end
    object FindVFRType2Action: TAction
      Caption = 'FindVFRType2Action'
    end
    object DeleteCurrentSectionAction: TAction
      Caption = 'DeleteCurrentSectionAction'
    end
    object DeleteCurrentFreezeFrameAction: TAction
      Caption = 'DeleteCurrentFreezeFrameAction'
    end
    object PostprocessSectionAction: TAction
      Caption = 'PostprocessSectionAction'
    end
    object ReplaceFrameWithNextAction: TAction
      Caption = 'ReplaceFrameWithNextAction'
    end
    object ReplaceFrameWithPreviousAction: TAction
      Caption = 'ReplaceFrameWithPreviousAction'
    end
    object DeleteCurrentRangeAction: TAction
      Caption = 'DeleteCurrentRangeAction'
    end
    object ToggleToolbarAction: TAction
      Caption = 'Toggle Toolbar'
      ShortCut = 32852
      OnExecute = ToggleToolbarActionExecute
    end
    object ToggleZoomAction: TAction
      Caption = 'Toggle Zoom'
      ShortCut = 8299
      OnExecute = ToggleZoomActionExecute
    end
    object PlayFromSectionStartAction: TAction
      Caption = 'Play From Section Start'
    end
    object NoDecimateSectionAction: TAction
      Caption = 'NoDecimateSectionAction'
    end
    object NextFrameAction: TAction
      Category = 'FrameJump'
      Caption = 'Next Frame'
      ShortCut = 39
      OnExecute = NextFrameActionExecute
    end
    object PreviousFrameAction: TAction
      Category = 'FrameJump'
      Caption = 'Previous Frame'
      ShortCut = 37
      OnExecute = PreviousFrameActionExecute
    end
    object JumpMinus5FramesAction: TAction
      Category = 'FrameJump'
      Caption = 'Jump -5 Frames'
      OnExecute = JumpMinus5FramesActionExecute
    end
    object JumpMinus10FramesAction: TAction
      Category = 'FrameJump'
      Caption = 'Jump -10 Frames'
      OnExecute = JumpMinus10FramesActionExecute
    end
    object JumpMinus50FramesAction: TAction
      Category = 'FrameJump'
      Caption = 'Jump -50 Frames'
      OnExecute = JumpMinus50FramesActionExecute
    end
    object JumpToNextSectionAction: TAction
      Category = 'FrameJump'
      Caption = 'Jump To Next Section'
    end
    object JumpToPreviousSectionAction: TAction
      Category = 'FrameJump'
      Caption = 'Jump To Previous Section'
    end
    object UsePatternAction: TAction
      Category = 'MainActions'
      Caption = 'Use Pattern'
      ShortCut = 85
      OnExecute = UsePatternActionExecute
      OnUpdate = UsePatternActionUpdate
    end
    object PatternGuidanceOnSectionAction: TAction
      Caption = 'PatternGuidanceOnSectionAction'
    end
  end
end
