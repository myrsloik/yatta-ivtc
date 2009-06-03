object ToolForm: TToolForm
  Left = 807
  Top = 426
  Width = 545
  Height = 369
  Caption = 'Tools'
  Color = clBtnFace
  Constraints.MinHeight = 338
  Constraints.MinWidth = 527
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefaultPosOnly
  PrintScale = poNone
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 537
    Height = 342
    ActivePage = LayerSheet
    Align = alClient
    TabOrder = 0
    object LayerSheet: TTabSheet
      Caption = 'Layers'
      ImageIndex = 5
      object Splitter1: TSplitter
        Left = 249
        Top = 0
        Height = 314
      end
      object LayerBox: TGroupBox
        Left = 0
        Top = 0
        Width = 249
        Height = 314
        Align = alLeft
        Caption = 'Layers'
        TabOrder = 0
        DesignSize = (
          249
          314)
        object LayerList: TViewListBox
          Left = 8
          Top = 16
          Width = 233
          Height = 249
          Style = lbVirtual
          Anchors = [akLeft, akTop, akRight, akBottom]
          ItemHeight = 13
          TabOrder = 0
          OnClick = LayerListClick
          OnData = LayerListData
        end
        object LayerMoveDown: TButton
          Left = 8
          Top = 289
          Width = 75
          Height = 17
          Action = MoveLayerDownAction
          Anchors = [akLeft, akBottom]
          TabOrder = 1
        end
        object LayerMoveUp: TButton
          Left = 8
          Top = 272
          Width = 75
          Height = 17
          Action = MoveLayerUpAction
          Anchors = [akLeft, akBottom]
          TabOrder = 2
        end
        object RenameLayer: TButton
          Left = 158
          Top = 289
          Width = 75
          Height = 17
          Action = RenameLayerAction
          Anchors = [akLeft, akBottom]
          TabOrder = 3
        end
        object SectionlistNew: TButton
          Left = 83
          Top = 272
          Width = 75
          Height = 17
          Action = AddSectionListAction
          Anchors = [akLeft, akBottom]
          TabOrder = 4
        end
        object LayerDelete: TButton
          Left = 83
          Top = 289
          Width = 75
          Height = 17
          Action = DeleteLayerAction
          Anchors = [akLeft, akBottom]
          TabOrder = 5
        end
        object RangelistNew: TButton
          Left = 158
          Top = 272
          Width = 75
          Height = 17
          Action = AddRangeListAction
          Anchors = [akLeft, akBottom]
          TabOrder = 6
        end
      end
      object RangeGroupBox: TGroupBox
        Left = 252
        Top = 0
        Width = 277
        Height = 314
        Align = alClient
        Caption = 'Ranges'
        TabOrder = 1
        DesignSize = (
          277
          314)
        object RangesList: TViewListBox
          Left = 8
          Top = 16
          Width = 259
          Height = 233
          Style = lbVirtual
          Anchors = [akLeft, akTop, akRight, akBottom]
          ItemHeight = 13
          TabOrder = 0
          OnData = RangesListData
          OnDblClick = RangesListDblClick
        end
        object RangeProcessText: TEdit
          Left = 8
          Top = 252
          Width = 259
          Height = 21
          Anchors = [akLeft, akRight, akBottom]
          TabOrder = 1
          OnChange = RangeProcessTextChange
        end
        object AddRangeButton: TButton
          Left = 8
          Top = 283
          Width = 94
          Height = 25
          Action = AddRangeAction
          Anchors = [akLeft, akBottom]
          TabOrder = 2
        end
        object DeleteRangeButton: TButton
          Left = 102
          Top = 283
          Width = 94
          Height = 25
          Action = DeleteRangeAction
          Anchors = [akLeft, akBottom]
          TabOrder = 3
        end
      end
    end
    object SectionSheet: TTabSheet
      Caption = 'Sections'
      ImageIndex = 7
      object Splitter2: TSplitter
        Left = 249
        Top = 0
        Height = 314
      end
      object SectionBox: TGroupBox
        Left = 0
        Top = 0
        Width = 249
        Height = 314
        Align = alLeft
        Caption = 'Sections'
        TabOrder = 0
        DesignSize = (
          249
          314)
        object SectionList: TViewListBox
          Left = 8
          Top = 40
          Width = 233
          Height = 233
          Style = lbVirtual
          Anchors = [akLeft, akTop, akRight, akBottom]
          ItemHeight = 13
          MultiSelect = True
          TabOrder = 0
          OnData = SectionListData
          OnDblClick = MarkerListDblClick
        end
        object SectionSelect: TComboBox
          Left = 8
          Top = 16
          Width = 233
          Height = 21
          Style = csDropDownList
          Anchors = [akLeft, akTop, akRight]
          ItemHeight = 13
          TabOrder = 1
          OnDropDown = SectionSelectDropDown
          OnSelect = SectionSelectSelect
        end
        object AddSection: TButton
          Left = 8
          Top = 283
          Width = 105
          Height = 25
          Action = AddSectionAction
          Anchors = [akLeft, akBottom]
          TabOrder = 2
        end
        object DeleteSection: TButton
          Left = 113
          Top = 283
          Width = 105
          Height = 25
          Action = DeleteSectionAction
          Anchors = [akLeft, akBottom]
          TabOrder = 3
        end
      end
      object PresetBox: TGroupBox
        Left = 252
        Top = 0
        Width = 277
        Height = 314
        Align = alClient
        Caption = 'Presets'
        TabOrder = 1
        DesignSize = (
          277
          314)
        object PresetList: TViewListBox
          Left = 9
          Top = 16
          Width = 259
          Height = 290
          Style = lbVirtual
          Anchors = [akLeft, akTop, akRight, akBottom]
          ItemHeight = 13
          TabOrder = 0
          OnClick = PresetListClick
          OnData = PresetListData
        end
      end
    end
    object PresetSheet: TTabSheet
      Caption = 'Presets'
      object PresetSetupBox: TGroupBox
        Left = 0
        Top = 0
        Width = 529
        Height = 314
        Align = alClient
        Caption = 'Presets'
        TabOrder = 0
        DesignSize = (
          529
          314)
        object PresetEditText: TMemo
          Left = 8
          Top = 40
          Width = 514
          Height = 233
          Anchors = [akLeft, akTop, akRight, akBottom]
          ScrollBars = ssBoth
          TabOrder = 0
          WordWrap = False
          OnChange = PresetEditTextChange
        end
        object UpdatePreset: TButton
          Left = 83
          Top = 283
          Width = 75
          Height = 25
          Action = UpdatePresetAction
          Anchors = [akLeft, akBottom]
          TabOrder = 1
        end
        object NewPreset: TButton
          Left = 8
          Top = 283
          Width = 75
          Height = 25
          Action = NewPresetAction
          Anchors = [akLeft, akBottom]
          TabOrder = 2
        end
        object DeletePreset: TButton
          Left = 158
          Top = 283
          Width = 75
          Height = 25
          Action = DeletePresetAction
          Anchors = [akLeft, akBottom]
          TabOrder = 3
        end
        object PresetSelect: TComboBox
          Left = 8
          Top = 16
          Width = 514
          Height = 21
          AutoDropDown = True
          AutoCloseUp = True
          Style = csDropDownList
          Anchors = [akLeft, akTop, akRight]
          ItemHeight = 13
          TabOrder = 4
          OnChange = PresetSelectChange
          OnDropDown = PresetSelectDropDown
        end
        object ImportPresets: TButton
          Left = 308
          Top = 283
          Width = 75
          Height = 25
          Anchors = [akLeft, akBottom]
          Caption = 'Import'
          TabOrder = 5
        end
        object AutoUpdatePreset: TCheckBox
          Left = 388
          Top = 287
          Width = 97
          Height = 17
          Anchors = [akLeft, akBottom]
          Caption = 'Auto Update'
          TabOrder = 6
        end
        object RenamePreset: TButton
          Left = 233
          Top = 283
          Width = 75
          Height = 25
          Action = RenamePresetAction
          Anchors = [akLeft, akBottom]
          TabOrder = 7
        end
      end
    end
    object DecimationSheet: TTabSheet
      Caption = 'Decimation'
      ImageIndex = 3
      object Splitter3: TSplitter
        Left = 257
        Top = 0
        Height = 314
      end
      object DecimationBox: TGroupBox
        Left = 0
        Top = 0
        Width = 257
        Height = 314
        Align = alLeft
        Caption = 'Decimation'
        TabOrder = 0
        DesignSize = (
          257
          314)
        object DecimateList: TViewListBox
          Left = 8
          Top = 16
          Width = 241
          Height = 257
          Style = lbVirtual
          Anchors = [akLeft, akTop, akRight, akBottom]
          ItemHeight = 13
          MultiSelect = True
          TabOrder = 0
          OnClick = DecimateListClick
          OnData = DecimateListData
          OnDblClick = MarkerListDblClick
        end
        object AddDecimate: TButton
          Left = 8
          Top = 283
          Width = 94
          Height = 25
          Action = AddDecimationAction
          Anchors = [akLeft, akBottom]
          TabOrder = 1
        end
        object DeleteDecimate: TButton
          Left = 102
          Top = 283
          Width = 94
          Height = 25
          Action = DeleteDecimationAction
          Anchors = [akLeft, akBottom]
          TabOrder = 2
        end
        object MinN: TEdit
          Left = 202
          Top = 285
          Width = 47
          Height = 21
          Anchors = [akLeft, akBottom]
          AutoSize = False
          TabOrder = 3
          Text = '0:1'
        end
      end
      object FreezeFrameBox: TGroupBox
        Left = 260
        Top = 0
        Width = 269
        Height = 314
        Align = alClient
        Caption = 'FreezeFrames'
        TabOrder = 1
        DesignSize = (
          269
          314)
        object FreezeFrameList: TViewListBox
          Left = 9
          Top = 16
          Width = 251
          Height = 257
          Style = lbVirtual
          Anchors = [akLeft, akTop, akRight, akBottom]
          ItemHeight = 13
          MultiSelect = True
          TabOrder = 0
          OnData = FreezeFrameListData
          OnDblClick = MarkerListDblClick
        end
        object AddFreezeFrame: TButton
          Left = 8
          Top = 283
          Width = 105
          Height = 25
          Action = AddFreezeFrameAction
          Anchors = [akLeft, akBottom]
          TabOrder = 1
        end
        object DeleteFreezeFrame: TButton
          Left = 114
          Top = 283
          Width = 105
          Height = 25
          Action = DeleteFreezeFrameAction
          Anchors = [akLeft, akBottom]
          TabOrder = 2
        end
      end
    end
    object ScriptSheet: TTabSheet
      Caption = 'Script Generation'
      ImageIndex = 6
      object AVSGenerationBox: TGroupBox
        Left = 0
        Top = 0
        Width = 529
        Height = 314
        Align = alClient
        Caption = 'Script Generation'
        TabOrder = 0
        DesignSize = (
          529
          314)
        object saveliteavs: TButton
          Left = 431
          Top = 250
          Width = 94
          Height = 25
          Anchors = [akTop, akRight]
          Caption = 'Save Small AVS'
          TabOrder = 0
        end
        object PreviewAvs: TButton
          Left = 431
          Top = 225
          Width = 94
          Height = 25
          Anchors = [akTop, akRight]
          Caption = '&Preview Avs'
          TabOrder = 1
          OnClick = PreviewAvsClick
        end
        object Button4: TButton
          Left = 431
          Top = 175
          Width = 94
          Height = 25
          Anchors = [akTop, akRight]
          Caption = 'Add PP Layer'
          TabOrder = 2
        end
        object Button1: TButton
          Left = 431
          Top = 200
          Width = 94
          Height = 25
          Anchors = [akTop, akRight]
          Caption = '&Save Avs'
          TabOrder = 3
        end
      end
    end
  end
  object ActionList: TActionList
    Left = 36
    Top = 64
    object AddRangeAction: TAction
      Category = 'ToolActions'
      Caption = 'Add Range'
      OnExecute = AddRangeActionExecute
    end
    object AddDecimationAction: TAction
      Category = 'ToolActions'
      Caption = 'Add Decimation'
      OnExecute = AddDecimationActionExecute
    end
    object AddSectionAction: TAction
      Category = 'ToolActions'
      Caption = 'Add Section'
      OnExecute = AddSectionActionExecute
    end
    object AddFreezeFrameAction: TAction
      Category = 'ToolActions'
      Caption = 'Add FreezeFrame'
      OnExecute = AddFreezeFrameActionExecute
    end
    object DeleteSectionAction: TAction
      Category = 'ToolActions'
      Caption = 'Delete Section'
      OnExecute = DeleteSectionActionExecute
    end
    object DeleteFreezeFrameAction: TAction
      Category = 'ToolActions'
      Caption = 'Delete FreezeFrame'
      OnExecute = DeleteFreezeFrameActionExecute
    end
    object DeleteDecimationAction: TAction
      Category = 'ToolActions'
      Caption = 'Delete Decimation'
      OnExecute = DeleteDecimationActionExecute
    end
    object AddSectionListAction: TAction
      Category = 'ToolActions'
      Caption = 'Add Section List'
      OnExecute = AddSectionListActionExecute
    end
    object AddRangeListAction: TAction
      Category = 'ToolActions'
      Caption = 'Add Range List'
      OnExecute = AddRangeListActionExecute
    end
    object DeleteLayerAction: TAction
      Category = 'ToolActions'
      Caption = 'Delete Layer '
      OnExecute = DeleteLayerActionExecute
      OnUpdate = LayerSelectedUpdate
    end
    object RenameLayerAction: TAction
      Category = 'ToolActions'
      Caption = 'Rename Layer'
      OnExecute = RenameLayerActionExecute
      OnUpdate = LayerSelectedUpdate
    end
    object MoveLayerUpAction: TAction
      Category = 'ToolActions'
      Caption = 'Move Up'
      OnExecute = MoveLayerUpActionExecute
      OnUpdate = MoveLayerUpActionUpdate
    end
    object MoveLayerDownAction: TAction
      Category = 'ToolActions'
      Caption = 'Move Down'
      OnExecute = MoveLayerDownActionExecute
      OnUpdate = MoveLayerDownActionUpdate
    end
    object DeleteRangeAction: TAction
      Category = 'ToolActions'
      Caption = 'Delete Range'
      OnExecute = DeleteRangeActionExecute
    end
    object RenamePresetAction: TAction
      Category = 'ToolActions'
      Caption = 'Rename'
      OnExecute = RenamePresetActionExecute
      OnUpdate = PresetSelectedUpdate
    end
    object DeletePresetAction: TAction
      Category = 'ToolActions'
      Caption = 'Delete'
      OnExecute = DeletePresetActionExecute
      OnUpdate = PresetSelectedUpdate
    end
    object UpdatePresetAction: TAction
      Category = 'ToolActions'
      Caption = 'Update'
      OnExecute = UpdatePresetActionExecute
      OnUpdate = PresetSelectedUpdate
    end
    object NewPresetAction: TAction
      Category = 'ToolActions'
      Caption = 'New'
      OnExecute = NewPresetActionExecute
    end
    object ImportPresetAction: TAction
      Category = 'ToolActions'
      Caption = 'Import'
    end
  end
end
