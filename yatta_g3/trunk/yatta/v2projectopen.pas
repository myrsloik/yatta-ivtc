unit v2projectopen;

interface

uses unit6, graphics, math, unit1, inifiles, asif, strutils, sysutils, unit11, classes, unit2, crop, dialogs, controls, yshared, logbox;

procedure OpenSource(Filename: string);
procedure OpenProject(IniFile: TMemIniFile); // not cleaned
procedure newproject(pt: integer);
procedure projectcheck(inifile: TMemIniFile);
procedure projectinit;
function OpenVideo(Filename: string; Mpeg2Dec: string): IAsifClip; // not cleaned
procedure EnableByProjectType(PT: Integer);
procedure GetType0Values(IniFile: TMemIniFile);
procedure GetType0SharedValues(IniFile: TMemIniFile);
procedure GetTypeCustomLists(IniFile: TMemIniFile; NamesOnly: Boolean = False);
procedure GetType1Values(IniFile: TMemIniFile);
procedure GetSections(IniFile: TMemIniFile);
procedure GetNoDecimateType1(IniFile: TMemIniFile);

const
  AllProjects = [0, 1];
  MatchingProjects = [1];

implementation

uses Forms, asifadditions;

procedure GetNoDecimateType1(IniFile: TMemIniFile);
var
  SL: TStringList;
  Counter: Integer;
  Line: string;
begin
  SL := TStringList.Create;

  IniFile.ReadSectionValues('NODECIMATE', SL);

  for Counter := 0 to SL.Count - 1 do
  begin
    Line := SL[Counter];

    if (Line <> '') then
      Form2.AddNoDecimate(StrToInt(GetToken(Line, 0, ['^'])), StrToInt(GetToken(Line, 1, ['^'])))
  end;

  SL.Free;
end;

procedure OpenSource(Filename: string);
var
  VideoSource: string;
  IniFile: TMemIniFile;
  FileExt: string;
  Line: string;
  Offset: Integer;
  StartToken: string;
  EndToken: string;
label
  RetryOpen;
begin
  FileExt := AnsiLowerCase(ExtractFileExt(Filename));

  if (FileExt = '.yap') then
  begin
    Form1.SaveDialog5.FileName := Filename;
    IniFile := nil;

    try
      IniFile := TMemIniFile.Create(Form1.SaveDialog5.FileName);

      MPEG2DecName := ChangeFileExt(IniFile.ReadString('YATTA V2', 'MPEG2DECODER', 'mpeg2dec3.dll'), '');
      VideoSource := LeftStr(Filename, Length(Filename) - 4);
      Line := IniFile.ReadString('YATTA V2', 'CUTLIST', '');
      SetLength(Form1.FCuts, 0);
      Offset := 1;
      while True do
      begin
        StartToken := GetNextToken(Line, Offset, [',']);
        EndToken := GetNextToken(Line, Offset, [',']);
        if (StartToken = '') or (EndToken = '') then
          Break;
        SetLength(Form1.FCuts, Length(Form1.FCuts) + 1);
        with Form1.FCuts[Length(Form1.FCuts) - 1] do
        begin
          CutStart := StrToInt(StartToken);
          CutEnd := StrToInt(EndToken);
        end;
      end;

      if (FileExists(VideoSource)) then
      begin
        RetryOpen:
        Form1.OriginalVideo := OpenVideo(VideoSource, mpeg2decname);
        Form1.SourceFile := VideoSource;
       end
      else
      begin
        VideoSource := IniFile.ReadString('YATTA V2', 'LASTVIDEOPATH', '');
        if (VideoSource <> '') and FileExists(VideoSource) then
          goto RetryOpen;

        MessageDlg('Video source not found. Select a matching file.', mtInformation, [mbok], 0);
        if Form1.OpenDialog1.Execute then
        begin
          VideoSource := Form1.OpenDialog1.FileName;
          goto RetryOpen;
        end
        else
          Abort;

      end;

      OpenProject(IniFile);

    finally
      IniFile.Free;
    end;
  end
  else
  begin
    MPEG2DecName := Form11.RadioGroup2.Items[Form11.RadioGroup2.ItemIndex];
    Form1.OriginalVideo := OpenVideo(filename, mpeg2decname);

    Form1.SourceFile := Filename;

    NewProject(IfThen(Form11.RadioGroup3.ItemIndex >= 2, Form11.RadioGroup3.ItemIndex + 1, Form11.RadioGroup3.ItemIndex))
  end;
end;


procedure OpenProject(IniFile: TMemIniFile);
var
  SV: AVSValueStruct;
  TempName: string;
  SearchPath, SearchString: string;
  FR: TSearchRec;
  AudioDelay: Integer;
  const AudioExts: array[0..4] of string = ('.ac3', '.aac', '.wav', '.w64', '.mp2');
begin
  Form1.SetDefaults;

  SV.AVSType := 1;
  SV.ClipVal := Form1.OriginalVideo.GetClipPointer;

  SE.SetVar('yattavideosource', SV);

  projectcheck(IniFile);

  projectinit;

  Form1.OpenMode := IniFile.ReadInteger('YATTA V2', 'TYPE', -1);

  gettype0values(IniFile);

  getsections(IniFile);

  if Form1.OpenMode in MatchingProjects then
  begin
    GetNoDecimateType1(IniFile);
    gettype1values(IniFile);
  end;

  enablebyprojecttype(Form1.OpenMode);

  Form1.UpdateFrameMap;

  Form2.SectionListBox.ItemIndex := 0;

  Form1.Caption := 'YATTA - ' + Form1.SaveDialog5.FileName;

  CropForm.FormShow(nil);

  TempName := LowerCase(MPEG2DecName);

  if TempName = 'mpeg2dec3' then
    Form11.RadioGroup2.ItemIndex := 0
  else if TempName = 'dgdecode' then
    Form11.RadioGroup2.ItemIndex := 1;

  Form1.FileOpen := True;

  if not IniFile.ReadBool('YATTA V2', 'HasImportedDefaultSettings', False) then
    if MessageDlg('No default settings have been imported for this project. Import settings now?', mtInformation, [mbYes, mbNo], 0) = mrYes then
      try
        Form2.ImportFromProject(Form11.DefaultSettingsProject.Text);
      except
      end;

  if not IniFile.ReadBool('YATTA V2', 'HasLookedForAudio', False) then
  begin
    SearchPath := LeftStr(Form1.SourceFile, Length(Form1.SourceFile) - Length(ExtractFileExt(Form1.SourceFile)));
    SearchPath := SearchPath + '*.*';
    if FindFirst(SearchPath, faReadOnly, FR) = 0 then
      repeat
        if AnsiMatchText(ExtractFileExt(FR.Name), AudioExts) then
        begin
          AudioDelay := 0;
          SearchString := AnsiLowerCaseFileName(ExtractFileName(FR.Name));
          if AnsiPos(' delay ', SearchString) <> 0 then
          begin
            SearchString := RightStr(SearchString, Length(SearchString) - AnsiPos(' delay ', SearchString) - 6);
            SearchString := LeftStr(SearchString, AnsiPos('ms', SearchString) - 1);
            AudioDelay := StrToIntDef(SearchString, 0);
          end;

          case MessageDlg('Do you want to set "' + FR.Name + '" with '
          + IntToStr(AudioDelay) + ' ms delay as the project audio file?',
          mtConfirmation, mbYesNoCancel, 0) of
          mrYes:
          begin
            Form1.FAudioFile := FR.Name;
            Form11.AudioFileEdit.Text := Form1.FAudioFile;
            Form1.FAudioDelay := AudioDelay;
            Form11.AudioDelayLabeledEdit.Text := IntToStr(Form1.FAudioDelay);
            Break;
          end;
          mrNo:
            Continue;
          mrCancel:
            Break;
          end;
        end;
      until FindNext(FR) <> 0;
    FindClose(FR);
  end;
  Form1.RedrawFrame;
end;

procedure newproject(pt: integer);
var
  sv: AVSValueStruct;
begin
  Form1.SetDefaults();

  sv.AVSType := 1;
  sv.ClipVal := Form1.OriginalVideo.GetClipPointer;

  se.SetVar('yattavideosource', sv);

  projectinit();

  Form1.OpenMode := pt;

  if Form2.PresetCount = 0 then
    Form2.AddPreset('Default', 0, '');

  Form2.AddSection(0, 0, 0);

  enablebyprojecttype(Form1.OpenMode);

  Form1.UpdateFrameMap;

  Form2.SectionListBox.ItemIndex := 0;

  form1.Caption := 'YATTA - New Project';

  CropForm.FormShow(nil);

  form1.fileopen := true;

  Form2.ComboBox2.Items.Assign(Form2.PresetListBox.Items);

  Form1.Multiple := 1;
  Form1.RedrawFrame;
end;

procedure projectcheck(inifile: TMemIniFile);
begin
  if not (inifile.ReadInteger('YATTA V2', 'TYPE', 255) in AllProjects) then
  begin
    MessageDlg('Unknown project type. Try an older version if you want to convert a v1 project.', mtError, [mbok], 0);
    Abort;
  end;

  if inifile.ReadInteger('YATTA V2', 'FRAMECOUNT', Form1.FActualFramecount) <> Form1.FActualFramecount then
  begin
    MessageDlg('Video source and project framecount doesn''t match. Corrupt project or video?', mtError, [mbok], 0);
    Abort;
  end;
end;

procedure projectinit;
var counter: integer;
begin
  with Form1.FieldClip.GetVideoInfo do
  begin
    Form1.Buffer.Width := Width;
    Form1.Buffer.Height := Height;

    SetLength(FrameArray, NumFrames);

    for counter := 0 to NumFrames - 1 do
    begin
      FillChar(FrameArray[counter], sizeof(TFrame), 0);
      FrameArray[counter].Match := 1;
      FrameArray[counter].OriginalMatch := 1;
    end;

    SetLength(form1.revframemap, NumFrames);
    SetLength(form1.framemap, NumFrames);
  end;
end;

function OpenVideo(Filename: string; Mpeg2Dec: string): IAsifClip;
var
  FileExt: string;
  TempTrims: array of IAsifClip;
  I: Integer;
begin
  if not FileExists(Filename) then
    raise EInitializationFailed.Create('Video file not found.');

  FileExt := AnsiLowerCase(ExtractFileExt(Filename));

  if FileExt = '.d2v' then
  begin
    LoadPlugins(Mpeg2Dec + '_mpeg2source', PluginPath, SE);
    SE.CharArg(PChar(Filename));
    Result := SE.InvokeWithClipResult(PChar(Mpeg2Dec + '_Mpeg2Source'));

    if not AnsiSameText('DGDecode', Mpeg2Dec) and SE.FunctionExists('SetPlanarLegacyAlignment') then
    begin
      SE.ClipArg(Result);
      SE.BoolArg(True);
      Result := SE.InvokeWithClipResult('SetPlanarLegacyAlignment');
    end;
  end
  else if FileExt = '.dga' then
  begin
    LoadPlugins('AVCSource', PluginPath, SE);
    SE.CharArg(PChar(Filename));
    Result := SE.InvokeWithClipResult('AVCSource');
  end
  else if FileExt = '.avs' then
  begin
    SE.CharArg(PChar(Filename));
    Result := SE.InvokeWithClipResult('Import');
  end
  else if FileExt = '.avi' then
  begin
    SE.CharArg(PChar(Filename));
    Result := SE.InvokeWithClipResult('AviSource');
  end
  else
  begin
    LoadPlugins('FFVideoSource', PluginPath, SE);
    SE.CharArg(PChar(Filename));
    Result := SE.InvokeWithClipResult('FFVideoSource');
  end;

  Form1.FActualFramecount := Result.GetVideoInfo.NumFrames;

  with SE do
    if Length(Form1.FCuts) = 0 then
      // do nothing
    else
    begin
      SetLength(TempTrims, 0);

      // first cut
      if Form1.FCuts[0].CutStart > 0 then
      begin
        SetLength(TempTrims, Length(TempTrims) + 1);
        ClipArg(Result);
        IntArg(0);
        IntArg(Form1.FCuts[0].CutStart - 1);
        TempTrims[0] := InvokeWithClipResult('Trim');
      end;
      
      // middle cuts
      for I := 0 to Length(Form1.FCuts) - 2 do
      begin
        SetLength(TempTrims, Length(TempTrims) + 1);
        ClipArg(Result);
        IntArg(Form1.FCuts[I].CutEnd + 1);
        IntArg(Form1.FCuts[I + 1].CutStart - 1);
        TempTrims[Length(TempTrims) - 1] := InvokeWithClipResult('Trim');
      end;

      // final cut
      if Form1.FCuts[Length(Form1.FCuts) - 1].CutEnd < Result.GetVideoInfo.NumFrames - 1 then
      begin
        SetLength(TempTrims, Length(TempTrims) + 1);
        ClipArg(Result);
        IntArg(Form1.FCuts[Length(Form1.FCuts) - 1].CutEnd + 1);
        IntArg(0);
        TempTrims[Length(TempTrims) - 1] := InvokeWithClipResult('Trim');
      end;

      if Length(TempTrims) = 0 then
        raise EInitializationFailed.Create('Nothing left after cutting');

      if Length(TempTrims) = 1 then
        Result := TempTrims[0]
      else
      begin
        for I := 0 to Length(TempTrims) - 1 do
          ClipArg(TempTrims[I]);
        Result := InvokeWithClipResult('AlignedSplice');
      end;
    end;
end;

procedure EnableByProjectType(PT: Integer);
begin
  with Form1 do
  begin

    if not (PT in AllProjects) then
      Caption := OriginalCaption;

    if PT in AllProjects then
      Image1.PopupMenu := PopupMenu1
    else
      Image1.PopupMenu := PopupMenu2;

    TrackBar1.Enabled := pt in AllProjects;
    Button13.Enabled := pt in AllProjects;
    Button12.Enabled := pt in AllProjects;
    Button3.Enabled := pt in AllProjects;
    Button4.Enabled := pt in AllProjects;
    Button1.Enabled := pt in AllProjects;
    Button20.Enabled := pt in AllProjects;
    Button8.Enabled := pt in AllProjects;
    Button14.Enabled := pt in AllProjects;
    Button15.Enabled := pt in AllProjects;

    Switching1.Enabled := pt in MatchingProjects;
    SetPattern1.Enabled := pt in MatchingProjects;
    SaveTelecide1.Enabled := pt in MatchingProjects;
    SaveDecimate1.Enabled := pt in MatchingProjects;

    PatternGuidance2.Enabled := pt in MatchingProjects;
    Recalculate1.Enabled := pt in MatchingProjects;
    SaveVFR1.Enabled := pt in MatchingProjects;
    Button2.Enabled := pt in MatchingProjects;
    Button5.Enabled := pt in MatchingProjects;
    Button9.Enabled := pt in MatchingProjects;
    Button7.Enabled := pt in MatchingProjects;
    Button6.Enabled := pt in MatchingProjects;
    Button10.Enabled := pt in MatchingProjects;
    Button18.Enabled := pt in MatchingProjects;

    AutoSaveTimer.Enabled := pt in AllProjects;
  end;

  Form2.TabSheet3.TabVisible := PT in MatchingProjects;
  case pt of
    0: Form11.RadioGroup3.ItemIndex := 0;
    1: Form11.RadioGroup3.ItemIndex := 1;
    3: Form11.RadioGroup3.ItemIndex := 2;
    4: Form11.RadioGroup3.ItemIndex := 3;
  end;
  Form11.RadioGroup1.Enabled := (PT in MatchingProjects);
  Form11.RadioGroup3.Enabled := not (PT in AllProjects);
  Form11.RadioGroup2.Enabled := not (PT in AllProjects);
  Form11.LabeledEdit2.Enabled := PT in MatchingProjects;
  Form11.Decimation.Enabled := PT in [1];
  Form11.AudioFileEdit.Enabled := PT in AllProjects;
  Form11.AudioDelayLabeledEdit.Enabled := PT in AllProjects;
  form2.PostProcessor.Visible := PT in MatchingProjects;
  form2.PostThreshold.Visible := PT in MatchingProjects;
end;

procedure GetTypeCustomLists(IniFile: TMemIniFile; NamesOnly: Boolean);
var
  SL: tstringlist;
  Counter, C2: Integer;
  N: TCustomList;
  Line: string;
begin
  SL := TStringList.Create;

  try
    with IniFile do
    begin
      Counter := 0;

      while SectionExists('Custom List ' + IntToStr(Counter)) do
      begin
        ReadSectionValues('Custom List ' + IntToStr(Counter), SL);

        N := TCustomList.Create(AnsiDequotedStrY(SL[0], '"'), AnsiDequotedStrY(SL[1], '"'), AnsiDequotedStrY(SL[2], '"'), TOutputMethod(StrToInt(SL[3])));
        Form2.CustomRangeLists.AddItem(AnsiDequotedStrY(SL[0], '"'), N);

        if not NamesOnly then
          for C2 := 4 to SL.Count - 1 do
          begin
            Line := SL[c2];
            N.Add(TCustomRange.Create(StrToInt(GetToken(Line, 0, [','])), StrToInt(GetToken(Line, 1, [',']))));
          end;

        Inc(counter);
      end;

    end;

  finally
    SL.Free;
  end;
end;

procedure GetType0SharedValues(IniFile: TMemIniFile);
begin
    with IniFile do
    begin
      Form1.FAudioDelay := ReadInteger('YATTA V2', 'AUDIODELAY', 0);
      Form11.AudioDelayLabeledEdit.Text := IntToStr(Form1.FAudioDelay);

      Form2.Resizer.ItemIndex := ReadInteger('YATTA V2', 'RESIZER', 1);

      try
        Form1.BicubicB := ReadFloat('YATTA V2', 'bicubic_b', 1 / 3);
        Form1.BicubicC := ReadFloat('YATTA V2', 'bicubic_c', 1 / 3);
      finally
      end;

      Form2.BicubicB.Text := FloatToStrF(Form1.BicubicB, ffFixed, 18, 3);
      Form2.BicubicC.Text := FloatToStrF(Form1.BicubicC, ffFixed, 18, 3);

      Form2.CropOn.Checked := ReadBool('YATTA V2', 'CROP', True);

      with CropForm do
      begin
        TrackBarChange(nil);
        ResizeWidthUpDown.Position := ReadInteger('YATTA V2', 'xres', 640);
        ResizeHeightUpDown.Position := ReadInteger('YATTA V2', 'yres', 480);
        CropLeftUpDown.Position := ReadInteger('YATTA V2', 'x1', 0);
        CropRightUpDown.Position := ReadInteger('YATTA V2', 'x2', 0);
        CropTopUpdown.Position := ReadInteger('YATTA V2', 'y1', 0);
        CropBottomUpDown.Position := ReadInteger('YATTA V2', 'y2', 0);
        Anamorphic.Checked := Readbool('YATTA V2', 'Anamorphic', False);
      end;

      Form2.ResizeOn.Checked := not Readbool('YATTA V2', 'Anamorphic', False);
    end;
end;

procedure GetType0Values(IniFile: TMemIniFile);
var
  SL, SubDiv: tstringlist;
  HH: string;
  Counter: Integer;
  Line: string;
  StarCount: Integer;
  I: Integer;
begin
  GetType0SharedValues(IniFile);

  SL := TStringList.Create;
  SubDiv := TStringList.Create;

  try
    with IniFile do
    begin
      Form1.FAudioFile := ReadString('YATTA V2', 'AUDIOFILE', '');
      Form11.AudioFileEdit.Text := Form1.FAudioFile;

      Form1.FAudioDelay := ReadInteger('YATTA V2', 'AUDIODELAY', 0);
      Form11.AudioDelayLabeledEdit.Text := IntToStr(Form1.FAudioDelay);

      Form1.TrackBar1.Position := ReadInteger('YATTA V2', 'FRAME', 0);

      ReadSectionValues('DECIMATEMETRICS', SL);

      with Form1.FieldClip.GetVideoInfo do
        for Counter := 0 to IfThen(NumFrames > SL.Count, SL.Count - 1, NumFrames - 1) do
          FrameArray[Counter].DMetric := StrToInt(SL[Counter]);

      ReadSectionValues('FREEZE', SL);

      for Counter := 0 to SL.Count - 1 do
      begin
        Line := SL[Counter];
        if Line <> '' then
          Form2.AddFreezeFrame(StrToInt(GetToken(Line, 0, [','])), StrToInt(GetToken(Line, 1, [','])), StrToInt(GetToken(Line, 2, [','])), True);
      end;

      for Counter := 0 to Form2.PresetCount - 1 do
        Form2.Presets[Counter].Free;
      Form2.PresetListBox.Clear;

      ReadSectionValues('PRESETS', sl);

      SubDiv.Delimiter := ',';
      for Counter := 0 to SL.Count - 1 do
      begin
        Line := SL[Counter];
        StarCount := 0;
        for I := 1 to Length(Line) do
          if Line[I] = '¤' then
            Inc(StarCount);
        if StarCount >= 3 then
          SubDiv.Delimiter := '¤';

        if Line <> '' then
        begin
          SubDiv.DelimitedText := Line;
          HH := AnsiDequotedStrY(AnsiReplaceStr(SubDiv[3], '^', #13#10), '"');

          Form2.AddPreset(AnsiDequotedStrY(SubDiv[2], '"'), StrToInt(SubDiv[0]), HH);
        end;
      end;

      ReadSectionValues('ERROR LOG', SL);

      for Counter := 0 to SL.Count - 1 do
      begin
        Line := SL[Counter];
        if Line <> '' then
          Logwindow.LogList.AddItem(RightStr(Line, Length(Line) - AnsiPos(' ', Line)), TObject(StrToInt(GetToken(Line, 0, [' ']))));
      end;

      if Form2.PresetCount = 0 then
        Form2.PresetListBox.AddItem('Default', TPreset.Create(0, ''));

      Form2.ComboBox2.Items.Assign(Form2.PresetListBox.Items);

      with Form1 do
      begin
        PreTelecide := ReadInteger('YATTA V2', 'PRETELECIDE2', -1);
        PostTelecide := ReadInteger('YATTA V2', 'POSTTELECIDE2', -1);
        PreDecimate := ReadInteger('YATTA V2', 'PREDECIMATE2', -1);
        PostDecimate := ReadInteger('YATTA V2', 'POSTDECIMATE2', -1);
        PostResize := ReadInteger('YATTA V2', 'POSTRESIZE2', -1);
      end;

      with Form2 do
      begin
        LabeledEdit3.Text := GetPresetName(Form1.PreTelecide);
        LabeledEdit4.Text := GetPresetName(Form1.PostTelecide);
        LabeledEdit5.Text := GetPresetName(Form1.PreDecimate);
        LabeledEdit6.Text := GetPresetName(Form1.PostDecimate);
        LabeledEdit7.Text := GetPresetName(Form1.PostResize);
      end;
    end;

  finally
    SubDiv.Free;
    SL.Free;
  end;

  GetTypeCustomLists(IniFile);
end;

procedure GetType1Values(IniFile: TMemIniFile);
var
  SL: TStringList;
  Counter, FCount: Integer;
  Line: string;
begin
  SL := THashedStringList.Create;

  try

    FCount := Form1.FieldClip.getvideoinfo.NumFrames;


    with IniFile do
    begin
      Form2.PostProcessor.ItemIndex := ReadInteger('YATTA V2', 'POSTPROCESSOR', 0);
      Form1.PostThreshold := ReadInteger('YATTA V2', 'POSTTHRESHOLD', 0);
      Form2.SharpKernel.Checked := ReadBool('YATTA V2', 'SHARPKERNEL', True);
      Form2.TwoWayKernel.Checked := ReadBool('YATTA V2', 'TWOWAYKERNEL', False);

      if ReadString('YATTA V2', 'POSTPATTERN', 'ooooo') <> '' then
        Form1.PostPattern := ReadString('YATTA V2', 'POSTPATTERN', 'ooooo');
      if ReadString('YATTA V2', 'MATCHPATTERN', 'ccnnc') <> '' then
        Form1.MatchPattern := ReadString('YATTA V2', 'MATCHPATTERN', 'ccnnc');
      if ReadString('YATTA V2', 'DROPPATTERN', 'kkkkd') <> '' then
        Form1.DropPattern := ReadString('YATTA V2', 'DROPPATTERN', 'kkkkd');
      if ReadString('YATTA V2', 'FREEZEPATTERN', 'ooooo') <> '' then
        Form1.FreezePattern := ReadString('YATTA V2', 'FREEZEPATTERN', 'ooooo');

      Form2.DecimateType.ItemIndex := ReadInteger('YATTA V2', 'DECIMATETYPE', 0);

      Form11.RadioGroup1.ItemIndex := ReadInteger('YATTA V2', 'ORDER', 1);
      Form1.Distance := ReadInteger('YATTA V2', 'DISTANCE', 5);

      Form2.vfindmethod.ItemIndex := ReadInteger('YATTA V2', 'VSETTING', 3);

      Form11.Decimation.Checked := ReadBool('YATTA V2', 'WITHDECIMATION', True);
      Form6.AskOnTryPattern.Checked := ReadBool('YATTA V2', 'NOPATTERN', True);

      ReadSectionValues('METRICS', SL);

      for Counter := 0 to IfThen(FCount > SL.Count, SL.Count - 1, FCount - 1) do
      begin
        Line := SL[Counter];
        if Line <> '' then
          with FrameArray[Counter] do
          begin
            MMetric[0] := StrToInt(GetToken(Line, 0));
            MMetric[1] := StrToInt(GetToken(Line, 1));
            MMetric[2] := StrToInt(GetToken(Line, 2));
            VMetric[0] := StrToInt(GetToken(Line, 3));
            VMetric[1] := StrToInt(GetToken(Line, 4));
            VMetric[2] := StrToInt(GetToken(Line, 5));
          end;
      end;

      ReadSectionValues('MATCHES', SL);
      for Counter := 0 to ifthen(FCount > SL.Count, SL.Count - 1, FCount - 1) do
        with FrameArray[Counter] do
          case SL[Counter][1] of
            'c': Match := 1;
            'n': Match := 0;
            'p': Match := 2;
          end;

      ReadSectionValues('ORIGINALMATCHES', SL);

      for Counter := 0 to IfThen(FCount > SL.Count, SL.Count - 1, FCount - 1) do
        with FrameArray[Counter] do
          case SL[Counter][1] of
            'c': OriginalMatch := 1;
            'n': OriginalMatch := 0;
            'p': OriginalMatch := 2;
          end;

      ReadSectionValues('POSTPROCESS', SL);

      for Counter := 0 to SL.Count - 1 do
        if StrToInt(SL[Counter]) < FCount then
          FrameArray[StrToInt(SL[Counter])].PostProcess := True;

      ReadSectionValues('DECIMATE', SL);

      for Counter := 0 to SL.Count - 1 do
        if StrToInt(SL[Counter]) < FCount then
          FrameArray[StrToInt(SL[Counter])].Decimate := True;

    end;
  finally
    SL.Free;
  end;
end;

procedure GetSections(IniFile: TMemIniFile);
var
  SL: TStringList;
  Counter: Integer;
  Line: string;
begin
  SL := TStringList.Create;

  try

    IniFile.ReadSectionValues('SECTIONS', SL);

    for Counter := 0 to SL.Count - 1 do
    begin
      Line := SL[Counter];
      if Line <> '' then
      begin

        if (GetToken(Line, 2, [',']) <> '') then
          Form2.AddSection(StrToInt(GetToken(Line, 0, [','])), StrToInt(GetToken(Line, 1, [','])), StrTofloat(GetToken(Line, 2, [','])))
        else
          Form2.AddSection(StrToInt(GetToken(Line, 0, [','])), StrToInt(GetToken(Line, 1, [','])), StrToInt(GetToken(Line, 0, [','])) / Form1.FPS);
      end;
    end;

    if (Form2.SectionCount = 0) or (Form2.Sections[0].StartFrame <> 0) then
      Form2.AddSection(0, 0, 0);

  finally
    SL.Free;
  end;
end;

end.

