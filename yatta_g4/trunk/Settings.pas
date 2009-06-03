unit Settings;

interface

uses
  Windows, Forms, Controls, StdCtrls, ExtCtrls, ComCtrls, Classes, Grids,
  ValEdit, Menus, ActnList, Dialogs, FileCtrl, Buttons, StrUtils;

type
  TActionDynArray = array of TAction;

  TSettingsForm = class(TForm)
    PluginDirEdit: TLabeledEdit;
    SaveAllOverrides: TCheckBox;
    PageControl1: TPageControl;
    GlobalSettings: TTabSheet;
    JumpToCurrentFrameOnPreview: TCheckBox;
    PGTooShortWarning: TCheckBox;
    MPEG2DecRadioGroup: TRadioGroup;
    KeyMappings: TTabSheet;
    KeyMappingEditor: TValueListEditor;
    Panel1: TPanel;
    ResetAllKeysButton: TButton;
    ResetKeyButton: TButton;
    SetPluginDirButton: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure KeyMappingEditorKeyPress(Sender: TObject; var Key: Char);
    procedure KeyMappingEditorKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ResetAllKeysButtonClick(Sender: TObject);
    procedure ResetKeyButtonClick(Sender: TObject);
    procedure SetPluginDirButtonClick(Sender: TObject);
  private
    FActionMap: TActionDynArray;
  public
    procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  SettingsForm: TSettingsForm;

implementation

uses Matching;

{$R *.dfm}

procedure TSettingsForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent := HWND_DESKTOP; // More elegant than 0
end;

procedure TSettingsForm.FormCreate(Sender: TObject);
var
  I: Integer;
  Row: Integer;
begin
  PluginDirEdit.Text := MatchForm.PluginPath;

  SetLength(FActionMap, MatchForm.ActionList.ActionCount);

  for I := 0 to MatchForm.ActionList.ActionCount - 1 do
    with MatchForm.ActionList[I] as TAction do
      KeyMappingEditor.Values[Caption] := ShortCutToText(ShortCut);

  for I := 0 to MatchForm.ActionList.ActionCount - 1 do
    if KeyMappingEditor.FindRow((MatchForm.ActionList[I] as TAction).Caption, Row) then
      FActionMap[Row] := MatchForm.ActionList[I] as TAction;
end;

procedure TSettingsForm.KeyMappingEditorKeyPress(Sender: TObject;
  var Key: Char);
begin
  Key := #0;
end;

procedure TSettingsForm.KeyMappingEditorKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
  TempShortCut: TShortCut;
begin
  if (KeyMappingEditor.Row >= 0) and (Key <> VK_SHIFT) and (Key <> VK_MENU) and (Key <> VK_CONTROL) then
  begin
    if Key = VK_ESCAPE then
    begin
      Key := 0;
      Shift := [];
    end
    else
      Shift := Shift * [ssShift, ssAlt, ssCtrl];

    TempShortCut := ShortCut(Key, Shift);
    FActionMap[KeyMappingEditor.Row].ShortCut := TempShortCut;
    KeyMappingEditor.Values[FActionMap[KeyMappingEditor.Row].Caption] := ShortCutToText(TempShortCut);

    Key := 0;
  end;
end;

procedure TSettingsForm.ResetAllKeysButtonClick(Sender: TObject);
var
  I: Integer;
begin
  if MessageDlg('Do you really want to reset all key mappings?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    for I := 0 to MatchForm.ActionList.ActionCount - 1 do
      with MatchForm.ActionList.Actions[I] as TAction do
      begin
        ShortCut := Tag;
        KeyMappingEditor.Values[Caption] := ShortCutToText(ShortCut);
      end;
end;

procedure TSettingsForm.ResetKeyButtonClick(Sender: TObject);
begin
  if KeyMappingEditor.Row >= 0 then
  with FActionMap[KeyMappingEditor.Row] do
  begin
    ShortCut := Tag;
    KeyMappingEditor.Values[Caption] := ShortCutToText(ShortCut);
  end;
end;

procedure TSettingsForm.SetPluginDirButtonClick(Sender: TObject);
var
  PluginPath: string;
begin
  PluginPath := MatchForm.PluginPath;
  SelectDirectory('Plugin Path', '', PluginPath);

  if (PluginPath <> '') and (not AnsiEndsStr('\', PluginPath)) then
    PluginPath := PluginPath + '\';

  PluginDirEdit.Text := PluginPath;
  MatchForm.PluginPath := PluginPath;

  BringToFront;
end;

end.

else if IsKeyEvent(kMarkCustomList, msg.CharCode) then
begin
  if (form2.CustomRangeLists.ItemIndex >= 0) and FRangeOn then
  begin
    if Form11.SwapCustomList.Checked and (FRange > TrackBar1.Position) then
      TCustomList(form2.CustomRangeLists.Items.Objects[form2.CustomRangeLists.ItemIndex]).Add(TCustomRange.Create(TrackBar1.Position, FRange))
    else
      TCustomList(form2.CustomRangeLists.Items.Objects[form2.CustomRangeLists.ItemIndex]).Add(TCustomRange.Create(FRange, TrackBar1.Position));

    form2.CustomRanges.Count := TCustomList(form2.CustomRangeLists.Items.Objects[form2.CustomRangeLists.ItemIndex]).Count;
    TCustomList(form2.CustomRangeLists.Items.Objects[form2.CustomRangeLists.ItemIndex]).Sort(customlistsort);
    FRangeOn := false;
    FInfoText.Append('Added range; Start: ' + inttostr(FRange) + '; End: ' + inttostr(TrackBar1.Position));
  end
  else if (form2.CustomRangeLists.ItemIndex >= 0) then
    Button8Click(nil)
  else
    FInfoText.Append('No list selected');

  DrawFrame;
end
else if IsKeyEvent(kTogglePBasedOnFreqOfUse, msg.CharCode) then
begin
  for counter := -1 to 255 do
    freq[counter] := 0;

  with form2.sectioninfo(TrackBar1.Position) do
  begin

    for Counter := 0 to Form2.SectionCount - 1 do
      inc(freq[Form2.Sections[Counter].Preset]);

    for counter := 0 to Form2.SectionCount - 1 do
      if Form2.Sections[Counter].StartFrame = StartFrame then
      begin
        Dec(freq[Form2.Sections[Counter].Preset]);

        tp := freq[Form2.Sections[Counter].Preset];
        ti := -1;

        for c2 := -1 to 255 do
          if ((freq[ti] < freq[c2]) and (freq[c2] < tp)) or ((freq[c2] = tp) and (Form2.Sections[Counter].Preset > c2)) then
            ti := c2;

        if ti = -1 then
          for c2 := 0 to 255 do
            if (freq[ti] < freq[c2]) then
              ti := c2;

        Form2.Sections[Counter].Preset := ti;
        Form2.UpdateSectionList;
        Form2.ComboBox1Change(nil);

        Break;
      end;

  end;

  DrawFrame;
end
else if IsKeyEvent(kTogglePreset, msg.CharCode) then
  with form2.sectioninfo(TrackBar1.Position) do
  begin

    ips := [];

    for counter := 0 to Form2.SectionCount - 1 do
      ips := ips + [Form2.Sections[Counter].Preset];

    for counter := 0 to Form2.SectionCount - 1 do
      if Form2.Sections[Counter].StartFrame = startframe then
      begin

        with Form2.Sections[Counter] do
          repeat
            Preset := (Preset + 1) and $FF;
          until Preset in ips;

        Form2.UpdateSectionList;
        Form2.ComboBox1Change(nil);

        Break;
      end;

    DrawFrame;
  end
else if IsKeyEvent(kNextVMatch, msg.CharCode) and (openmode in matchingprojects) then
  form2.vnextClick(self)
else if IsKeyEvent(kPreviousVMatch, msg.CharCode) and (openmode in matchingprojects) then
  form2.vprevClick(self)
else if IsKeyEvent(kJump5frames, msg.CharCode) then
  TrackBar1.Position := TrackBar1.Position + 5
else if IsKeyEvent(kJump10frames, msg.CharCode) then
  TrackBar1.Position := TrackBar1.Position + 10
else if IsKeyEvent(kJump15frames, msg.CharCode) then
  TrackBar1.Position := TrackBar1.Position + 15
else if IsKeyEvent(kJump20frames, msg.CharCode) then
  TrackBar1.Position := TrackBar1.Position + 20
else if IsKeyEvent(kJump25frames, msg.CharCode) then
  TrackBar1.Position := TrackBar1.Position + 25
else if IsKeyEvent(kJump35frames, msg.CharCode) then
  TrackBar1.Position := TrackBar1.Position + 35
else if IsKeyEvent(kJump50frames, msg.CharCode) then
  TrackBar1.Position := TrackBar1.Position + 50
else if IsKeyEvent(kJump75frames, msg.CharCode) then
  TrackBar1.Position := TrackBar1.Position + 75
else if IsKeyEvent(kJump100frames, msg.CharCode) then
  TrackBar1.Position := TrackBar1.Position + 100
else if IsKeyEvent(kFFSBeginningToC, msg.CharCode) then
begin
  with form2.sectioninfo(TrackBar1.Position) do
    if form2.addfreezeframe(startframe, TrackBar1.Position, TrackBar1.Position) then
      FInfoText.append('Start: ' + IntToStr(startframe) + '; End: ' + IntToStr(TrackBar1.Position) + '; Replace: ' + IntToStr(TrackBar1.Position))
    else
      FInfoText.append('Overlapping/invalid ranges');
  DrawFrame;
end
else if IsKeyEvent(kFFCToSEnd, msg.CharCode) then
begin
  with form2.sectioninfo(TrackBar1.Position) do
    if form2.addfreezeframe(TrackBar1.Position, endframe, TrackBar1.Position) then
      FInfoText.append('Start: ' + IntToStr(TrackBar1.Position) + '; End: ' + IntToStr(endframe) + '; Replace: ' + IntToStr(TrackBar1.Position))
    else
      FInfoText.append('Overlapping/invalid ranges');
  DrawFrame;
end
else if IsKeyEvent(kJumpToRangeStart, msg.CharCode) and FRangeOn then
  TrackBar1.Position := FRange
else if IsKeyEvent(kSelectLowestVMetricMatches, msg.CharCode) and (openmode in matchingprojects) then
begin
  with form2.sectioninfo(TrackBar1.Position) do
    matchbyvmetric(startframe, endframe, 10);
  DrawFrame;
end
else if IsKeyEvent(kExtendDistanceTo5, msg.CharCode) and (openmode in matchingprojects) then
  with form2.sectioninfo(TrackBar1.Position) do
  begin

    for counter := TrackBar1.Position - 2 to endframe - 5 do
      FrameArray[counter + 5].Match := FrameArray[counter].Match;

    for counter := TrackBar1.Position + 2 downto startframe + 5 do
      FrameArray[counter - 5].Match := FrameArray[counter].Match;

    DrawFrame;
  end
else if IsKeyEvent(kJumpToNextPN, msg.CharCode) and (openmode in matchingprojects) then
begin
  for ti := TrackBar1.Position + 1 to TrackBar1.Max do
    if ((FrameArray[ti].Match = 0) and (PCOnly1.Checked)) or ((FrameArray[ti].Match = 2) and (CNOnly1.Checked)) then
    begin
      TrackBar1.Position := ti;
      break;
    end;
end
else if IsKeyEvent(kFreezeframeSection, msg.CharCode) then
begin
  with form2.sectioninfo(TrackBar1.Position) do
    if Form2.addfreezeframe(startframe, endframe, TrackBar1.Position) then
      FInfoText.append('Start: ' + IntToStr(startframe) + '; End: ' + IntToStr(endframe) + '; Replace: ' + IntToStr(TrackBar1.Position))
    else
      FInfoText.append('Overlapping/invalid ranges');

  DrawFrame();
end
else if IsKeyEvent(kNextCLEntry, msg.CharCode) then
begin
  if (form2.CustomRangeLists.ItemIndex >= 0) and (form2.CustomRanges.ItemIndex >= 1) then
  begin

    with form2.CustomRangeLists.Items.Objects[form2.CustomRangeLists.ItemIndex] as TCustomList do
      with Items[form2.CustomRanges.ItemIndex - 1] as TCustomRange do
      begin
        TrackBar1.Position := startframe;
        form2.CustomRanges.ItemIndex := form2.CustomRanges.ItemIndex - 1;
        form2.CustomRanges.ClearSelection;
        form2.CustomRanges.Selected[form2.CustomRanges.ItemIndex] := true;
      end;
  end;
end
else if IsKeyEvent(kPreviousCLEntry, msg.CharCode) then
begin
  if (form2.CustomRangeLists.ItemIndex >= 0) and (Form2.CustomRanges.ItemIndex < Form2.CustomRanges.Count - 1) then
  begin

    with form2.CustomRangeLists.Items.Objects[form2.CustomRangeLists.ItemIndex] as TCustomList do
      with Items[form2.CustomRanges.ItemIndex + 1] as TCustomRange do
      begin
        TrackBar1.Position := startframe;
        form2.CustomRanges.ItemIndex := form2.CustomRanges.ItemIndex + 1;
        form2.CustomRanges.ClearSelection;
        form2.CustomRanges.Selected[form2.CustomRanges.ItemIndex] := true;
      end;
  end;
end

