object Form2: TForm2
  Left = 451
  Top = 178
  AutoScroll = False
  Caption = 'Tools'
  ClientHeight = 311
  ClientWidth = 519
  Color = clBtnFace
  Constraints.MinHeight = 338
  Constraints.MinWidth = 527
  DefaultMonitor = dmMainForm
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefaultPosOnly
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 519
    Height = 311
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet8: TTabSheet
      Caption = 'Sections'
      ImageIndex = 7
      DesignSize = (
        511
        283)
      object PresetListBox: TListBox
        Left = 257
        Top = 0
        Width = 254
        Height = 256
        Anchors = [akLeft, akTop, akRight, akBottom]
        ItemHeight = 13
        Sorted = True
        TabOrder = 0
        OnClick = ListBox2Change
        OnDblClick = PresetListBoxDblClick
        OnKeyDown = SectionListBoxKeyDown
      end
      object Button8: TButton
        Left = 142
        Top = 260
        Width = 75
        Height = 22
        Anchors = [akLeft, akBottom]
        Caption = 'S From File'
        TabOrder = 3
        OnClick = Button8Click
      end
      object Button6: TButton
        Left = 71
        Top = 260
        Width = 71
        Height = 22
        Anchors = [akLeft, akBottom]
        Caption = 'Delete'
        TabOrder = 2
        OnClick = Button6Click
      end
      object Button5: TButton
        Left = 0
        Top = 260
        Width = 71
        Height = 22
        Anchors = [akLeft, akBottom]
        Caption = 'New Section'
        TabOrder = 1
        OnClick = Button5Click
      end
      object SectionListbox: TListBox
        Left = 0
        Top = 0
        Width = 254
        Height = 256
        Anchors = [akLeft, akTop, akBottom]
        ItemHeight = 13
        TabOrder = 4
        OnDblClick = ListBox1Change
        OnKeyDown = SectionListBoxKeyDown
        OnMouseDown = SectionListBoxMouseDown
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'Presets'
      DesignSize = (
        511
        283)
      object updatepreset: TButton
        Left = 48
        Top = 260
        Width = 46
        Height = 22
        Anchors = [akLeft, akBottom]
        Caption = 'Update'
        TabOrder = 3
        OnClick = updatepresetClick
      end
      object newpreset: TButton
        Left = 0
        Top = 260
        Width = 48
        Height = 22
        Anchors = [akLeft, akBottom]
        Caption = 'New'
        TabOrder = 2
        OnClick = newpresetClick
      end
      object deletepreset: TButton
        Left = 232
        Top = 260
        Width = 46
        Height = 22
        Anchors = [akLeft, akBottom]
        Caption = 'Delete'
        TabOrder = 6
        OnClick = deletepresetClick
      end
      object ComboBox2: TComboBox
        Left = 0
        Top = 0
        Width = 511
        Height = 21
        AutoDropDown = True
        AutoCloseUp = True
        Style = csDropDownList
        Anchors = [akLeft, akTop, akRight]
        ItemHeight = 13
        Sorted = True
        TabOrder = 0
        OnChange = ComboBox2Change
      end
      object Memo1: TMemo
        Left = 0
        Top = 24
        Width = 511
        Height = 232
        Anchors = [akLeft, akTop, akRight, akBottom]
        ScrollBars = ssBoth
        TabOrder = 1
        WordWrap = False
      end
      object Button19: TButton
        Left = 317
        Top = 260
        Width = 72
        Height = 22
        Anchors = [akRight, akBottom]
        Caption = 'Assign to'
        TabOrder = 7
        OnClick = Button19Click
      end
      object ComboBox3: TComboBox
        Left = 392
        Top = 260
        Width = 120
        Height = 21
        Style = csDropDownList
        Anchors = [akRight, akBottom]
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 8
        Text = 'Pre Telecide'
        Items.Strings = (
          'Pre Telecide'
          'Post Telecide'
          'Pre Decimate'
          'Post Decimate'
          'Post Resize')
      end
      object Button3: TButton
        Left = 186
        Top = 260
        Width = 46
        Height = 22
        Anchors = [akLeft, akBottom]
        Caption = 'Import'
        TabOrder = 5
        OnClick = Button3Click
      end
      object Button20: TButton
        Left = 140
        Top = 260
        Width = 46
        Height = 22
        Anchors = [akLeft, akBottom]
        Caption = 'Rename'
        TabOrder = 4
        OnClick = Button20Click
      end
      object Button1: TButton
        Left = 94
        Top = 260
        Width = 46
        Height = 22
        Anchors = [akLeft, akBottom]
        Caption = 'Revert'
        TabOrder = 9
        OnClick = Button1Click
      end
    end
    object TabSheet7: TTabSheet
      Caption = 'AVS Generation'
      ImageIndex = 6
      OnShow = TabSheet7Show
      object PostProcessor: TRadioGroup
        Left = 417
        Top = 0
        Width = 93
        Height = 135
        Caption = 'PostProcessor'
        ItemIndex = 0
        Items.Strings = (
          'Blend'
          'Interpolate'
          'Sangnom'
          'KernelDeint'
          'LeakKDeint'
          'TDeint'
          'NNEDI'
          'NNEDI2')
        TabOrder = 7
        OnClick = PostProcessorClick
      end
      object SaveAvs: TButton
        Left = 421
        Top = 214
        Width = 86
        Height = 22
        Caption = '&Save Avs'
        TabOrder = 11
        OnClick = SaveAvsClick
      end
      object ResizeOn: TCheckBox
        Left = 8
        Top = 232
        Width = 81
        Height = 16
        Caption = 'Resize'
        Checked = True
        State = cbChecked
        TabOrder = 3
        OnClick = ResizeOnClick
      end
      object Resizer: TRadioGroup
        Left = 0
        Top = 0
        Width = 113
        Height = 137
        Caption = 'Resizing'
        ItemIndex = 0
        Items.Strings = (
          'Lanczos4'
          'Lanczos'
          'Bicubic'
          'Bilinear'
          'Spline36'
          'Spline16'
          'Gauss')
        TabOrder = 0
        OnClick = ResizerClick
      end
      object BicubicC: TLabeledEdit
        Left = 8
        Top = 205
        Width = 97
        Height = 21
        EditLabel.Width = 44
        EditLabel.Height = 13
        EditLabel.Caption = 'Bicubic c'
        TabOrder = 2
        OnChange = BicubicCChange
      end
      object BicubicB: TLabeledEdit
        Left = 8
        Top = 165
        Width = 97
        Height = 21
        EditLabel.Width = 44
        EditLabel.Height = 13
        EditLabel.Caption = 'Bicubic b'
        TabOrder = 1
        OnChange = BicubicBChange
      end
      object GroupBox1: TGroupBox
        Left = 120
        Top = 0
        Width = 289
        Height = 225
        Caption = 'Special Presets'
        TabOrder = 5
        object LabeledEdit3: TLabeledEdit
          Left = 16
          Top = 32
          Width = 225
          Height = 21
          EditLabel.Width = 60
          EditLabel.Height = 13
          EditLabel.Caption = 'Pre Telecide'
          ReadOnly = True
          TabOrder = 0
          OnDblClick = Button12Click
        end
        object LabeledEdit4: TLabeledEdit
          Left = 16
          Top = 72
          Width = 225
          Height = 21
          EditLabel.Width = 65
          EditLabel.Height = 13
          EditLabel.Caption = 'Post Telecide'
          ReadOnly = True
          TabOrder = 2
          OnDblClick = Button13Click
        end
        object LabeledEdit5: TLabeledEdit
          Left = 16
          Top = 112
          Width = 225
          Height = 21
          EditLabel.Width = 64
          EditLabel.Height = 13
          EditLabel.Caption = 'Pre Decimate'
          ReadOnly = True
          TabOrder = 4
          OnDblClick = Button14Click
        end
        object LabeledEdit6: TLabeledEdit
          Left = 16
          Top = 152
          Width = 225
          Height = 21
          EditLabel.Width = 69
          EditLabel.Height = 13
          EditLabel.Caption = 'Post Decimate'
          ReadOnly = True
          TabOrder = 6
          OnDblClick = Button15Click
        end
        object LabeledEdit7: TLabeledEdit
          Left = 16
          Top = 192
          Width = 225
          Height = 21
          EditLabel.Width = 56
          EditLabel.Height = 13
          EditLabel.Caption = 'Post Resize'
          ReadOnly = True
          TabOrder = 8
          OnDblClick = Button16Click
        end
        object Button2: TButton
          Left = 248
          Top = 31
          Width = 35
          Height = 23
          Caption = 'Clear'
          TabOrder = 1
          OnClick = Button2Click
        end
        object Button4: TButton
          Left = 248
          Top = 71
          Width = 35
          Height = 23
          Caption = 'Clear'
          TabOrder = 3
          OnClick = Button4Click
        end
        object Button9: TButton
          Left = 248
          Top = 111
          Width = 35
          Height = 23
          Caption = 'Clear'
          TabOrder = 5
          OnClick = Button9Click
        end
        object Button10: TButton
          Left = 248
          Top = 151
          Width = 35
          Height = 23
          Caption = 'Clear'
          TabOrder = 7
          OnClick = Button10Click
        end
        object Button11: TButton
          Left = 248
          Top = 191
          Width = 35
          Height = 23
          Caption = 'Clear'
          TabOrder = 9
          OnClick = Button11Click
        end
      end
      object PreviewAvs: TButton
        Left = 421
        Top = 236
        Width = 86
        Height = 22
        Caption = '&Preview Avs'
        TabOrder = 12
        OnClick = PreviewAvsClick
      end
      object SaveLiteAvs: TButton
        Left = 421
        Top = 258
        Width = 86
        Height = 22
        Caption = 'Save Small AVS'
        TabOrder = 13
        OnClick = SaveLiteAvsClick
      end
      object PostThreshold: TLabeledEdit
        Left = 416
        Top = 153
        Width = 89
        Height = 21
        EditLabel.Width = 41
        EditLabel.Height = 13
        EditLabel.Caption = 'DThresh'
        TabOrder = 8
        OnChange = PostThresholdChange
      end
      object SharpKernel: TCheckBox
        Left = 415
        Top = 178
        Width = 57
        Height = 16
        Caption = 'Sharp'
        Checked = True
        State = cbChecked
        TabOrder = 9
        Visible = False
      end
      object TwoWayKernel: TCheckBox
        Left = 415
        Top = 195
        Width = 66
        Height = 16
        Caption = 'TwoWay'
        TabOrder = 10
        Visible = False
      end
      object CropOn: TCheckBox
        Left = 8
        Top = 248
        Width = 97
        Height = 17
        Caption = 'Crop'
        Checked = True
        State = cbChecked
        TabOrder = 4
      end
      object DecimateType: TRadioGroup
        Left = 120
        Top = 232
        Width = 289
        Height = 41
        Caption = 'Decimation'
        Columns = 2
        ItemIndex = 0
        Items.Strings = (
          'Decimate'
          'TDecimate')
        TabOrder = 6
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Ranges'
      ImageIndex = 3
      DesignSize = (
        511
        283)
      object deleteff: TButton
        Left = 71
        Top = 260
        Width = 71
        Height = 22
        Anchors = [akLeft, akBottom]
        Caption = 'Delete FF'
        TabOrder = 3
        OnClick = deleteffClick
      end
      object savevfr: TButton
        Left = 0
        Top = 260
        Width = 71
        Height = 22
        Anchors = [akLeft, akBottom]
        Caption = 'Save &VFR'
        TabOrder = 2
        OnClick = savevfrClick
      end
      object deletend: TButton
        Left = 142
        Top = 260
        Width = 71
        Height = 22
        Anchors = [akLeft, akBottom]
        Caption = 'Delete ND'
        TabOrder = 4
        OnClick = deletendClick
      end
      object Freezeframes: TListBox
        Left = 0
        Top = 0
        Width = 254
        Height = 256
        Anchors = [akLeft, akTop, akBottom]
        ItemHeight = 13
        MultiSelect = True
        TabOrder = 0
        OnDblClick = FreezeframesDblClick
        OnKeyDown = FreezeframesKeyDown
      end
      object Nodecimates: TListBox
        Left = 257
        Top = 0
        Width = 254
        Height = 256
        Anchors = [akLeft, akTop, akRight, akBottom]
        ItemHeight = 13
        MultiSelect = True
        TabOrder = 1
        OnDblClick = NodecimatesDblClick
        OnKeyDown = NodecimatesKeyDown
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Find'
      ImageIndex = 4
      TabVisible = False
      OnShow = TabSheet3Show
      object GroupBox2: TGroupBox
        Left = 164
        Top = 0
        Width = 217
        Height = 113
        Caption = 'VFR'
        TabOrder = 1
        object vfrthresholds: TButton
          Left = 10
          Top = 16
          Width = 191
          Height = 25
          Caption = 'Set Thresholds'
          TabOrder = 0
          OnClick = vfrthresholdsClick
        end
        object findvfr1: TButton
          Left = 10
          Top = 48
          Width = 191
          Height = 25
          Caption = 'Find Method 1'
          TabOrder = 1
          OnClick = findvfr1Click
        end
        object findvfr2: TButton
          Left = 9
          Top = 80
          Width = 192
          Height = 25
          Caption = 'Find Method 2'
          TabOrder = 2
          OnClick = findvfr2Click
        end
      end
      object vfindmethod: TRadioGroup
        Left = 0
        Top = 0
        Width = 161
        Height = 113
        Caption = 'Value to use'
        ItemIndex = 3
        Items.Strings = (
          '&V'
          'V &Difference from previous'
          '&% Difference from previous'
          'V &Difference on both sides'
          '&% Difference on both sides')
        TabOrder = 0
        OnClick = vfindmethodClick
      end
      object vprev: TButton
        Left = 86
        Top = 118
        Width = 60
        Height = 25
        Caption = '&Previous'
        TabOrder = 3
        OnClick = vprevClick
      end
      object vnext: TButton
        Left = 149
        Top = 118
        Width = 60
        Height = 25
        Caption = '&Next'
        Default = True
        TabOrder = 4
        OnClick = vnextClick
      end
      object vlimit: TLabeledEdit
        Left = 48
        Top = 120
        Width = 33
        Height = 21
        EditLabel.Width = 43
        EditLabel.Height = 13
        EditLabel.Caption = 'Value (V)'
        LabelPosition = lpLeft
        TabOrder = 2
        OnChange = vlimitChange
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Custom Lists'
      ImageIndex = 5
      object Splitter1: TSplitter
        Left = 137
        Top = 0
        Height = 283
      end
      object GroupBox3: TGroupBox
        Left = 0
        Top = 0
        Width = 137
        Height = 283
        Align = alLeft
        Caption = 'Lists'
        TabOrder = 0
        DesignSize = (
          137
          283)
        object CustomRangeLists: TListBox
          Left = 8
          Top = 16
          Width = 121
          Height = 257
          Anchors = [akLeft, akTop, akRight, akBottom]
          ItemHeight = 13
          PopupMenu = PopupMenu2
          TabOrder = 0
          OnClick = CustomRangeListsClick
        end
      end
      object GroupBox4: TGroupBox
        Left = 140
        Top = 0
        Width = 371
        Height = 283
        Align = alClient
        Caption = 'Entries'
        TabOrder = 1
        OnClick = Edit1Change
        DesignSize = (
          371
          283)
        object CustomRanges: TListBox
          Left = 8
          Top = 16
          Width = 355
          Height = 204
          Style = lbVirtual
          Anchors = [akLeft, akTop, akRight, akBottom]
          ItemHeight = 16
          MultiSelect = True
          PopupMenu = PopupMenu1
          TabOrder = 0
          OnData = CustomRangesData
          OnDblClick = CustomRangesDblClick
        end
        object Edit1: TEdit
          Left = 8
          Top = 226
          Width = 355
          Height = 21
          Anchors = [akLeft, akRight, akBottom]
          TabOrder = 1
          OnChange = Edit1Change
        end
        object Edit2: TEdit
          Left = 8
          Top = 253
          Width = 355
          Height = 21
          Anchors = [akLeft, akRight, akBottom]
          TabOrder = 2
          OnChange = Edit2Change
        end
      end
    end
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = '.avs'
    Filter = 'Avisynth Scripts (*.avs)|*.avs'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 464
    Top = 8
  end
  object OpenDialog1: TOpenDialog
    Filter = 
      'First pass log files (*.pass;*.ffstats;*.txt)|*.pass;*.ffstats;*' +
      '.txt'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 432
    Top = 8
  end
  object OpenDialog3: TOpenDialog
    Filter = 'Projects|*.yap'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 400
    Top = 8
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 368
    Top = 8
    object Delete1: TMenuItem
      Caption = 'Delete'
      OnClick = Delete1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object MoveTo1: TMenuItem
      Caption = 'Move To'
    end
    object CopyTo1: TMenuItem
      Caption = 'Copy To'
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object CopytoSections1: TMenuItem
      Caption = 'Copy to Sections'
      OnClick = CopytoSections1Click
    end
  end
  object PopupMenu2: TPopupMenu
    Left = 336
    Top = 8
    object NewList1: TMenuItem
      Caption = 'New List'
      object Empty1: TMenuItem
        Caption = 'Empty'
        OnClick = Empty1Click
      end
      object FromVMetric1: TMenuItem
        Caption = 'From VMetric'
        OnClick = FromVMetric1Click
      end
    end
    object DeleteList1: TMenuItem
      Caption = 'Delete List'
      OnClick = DeleteList1Click
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object Save1: TMenuItem
      Caption = 'Save'
      OnClick = Save1Click
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object MoveUp1: TMenuItem
      Caption = 'Move Up'
      OnClick = MoveUp1Click
    end
    object MoveDown1: TMenuItem
      Caption = 'Move Down'
      OnClick = MoveDown1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object ExternalFile1: TMenuItem
      AutoCheck = True
      Caption = 'External File'
      GroupIndex = 1
      RadioItem = True
      OnClick = ExternalFile1Click
    end
    object PreTelecide1: TMenuItem
      Tag = 1
      AutoCheck = True
      Caption = 'Pre Telecide'
      GroupIndex = 1
      RadioItem = True
      OnClick = ExternalFile1Click
    end
    object PostTelecide1: TMenuItem
      Tag = 2
      AutoCheck = True
      Caption = 'Post Telecide'
      GroupIndex = 1
      RadioItem = True
      OnClick = ExternalFile1Click
    end
    object PreDecimate1: TMenuItem
      Tag = 3
      AutoCheck = True
      Caption = 'Pre Decimate'
      GroupIndex = 1
      RadioItem = True
      OnClick = ExternalFile1Click
    end
    object PostDecimate1: TMenuItem
      Tag = 4
      AutoCheck = True
      Caption = 'Post Decimate'
      GroupIndex = 1
      RadioItem = True
      OnClick = ExternalFile1Click
    end
    object PostResize1: TMenuItem
      Tag = 5
      AutoCheck = True
      Caption = 'Post Resize'
      GroupIndex = 1
      RadioItem = True
      OnClick = ExternalFile1Click
    end
  end
end
