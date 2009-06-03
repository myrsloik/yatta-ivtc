unit Matching;

interface

uses
  Windows, Messages, SysUtils, Classes, IniFiles, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Math, ComCtrls, strutils, Menus, YattaProject,
  AppEvnts, YShared, ActnList, GR32_Image, AsifAdditions;

type
  TMatchForm = class(TForm)
    FrameTrackBar: TTrackBar;
    ResetMatchButton: TButton;
    GotoButton: TButton;
    TryPatternButton: TButton;
    StatusBar: TStatusBar;
    DecimateButton: TButton;
    FieldMatchSaveDialog: TSaveDialog;
    PostprocessButton: TButton;
    PopupMenu: TPopupMenu;
    SwitchButton: TButton;
    PlayButton: TButton;
    N2: TMenuItem;
    RangeButton: TButton;
    N1: TMenuItem;
    Project1: TMenuItem;
    ShowText1: TMenuItem;
    UsePatternButton: TButton;
    ClearPostprocessed1: TMenuItem;
    N3: TMenuItem;
    SaveProject1: TMenuItem;
    ProjectSaveDialog: TSaveDialog;
    PlaybackSpeed1: TMenuItem;
    Save1: TMenuItem;
    SetPattern1: TMenuItem;
    N4: TMenuItem;
    About1: TMenuItem;
    ClearDecimated1: TMenuItem;
    CopyToClipboard1: TMenuItem;
    FreezeFrameButton: TButton;
    SaveButton: TButton;
    SaveAvisynthScript1: TMenuItem;
    SaveAllOverrides1: TMenuItem;
    DecimationMarkerButton: TButton;
    SettingsButton: TButton;
    QuickRangeButton: TButton;
    OpenCloseButton: TButton;
    ProjectOpenDialog: TOpenDialog;
    ToolsButton: TButton;
    AddSectionButton: TButton;
    SaveTimecodes1: TMenuItem;
    Cropping1: TMenuItem;
    DecimationbyPattern1: TMenuItem;
    TimecodeSaveDialog: TSaveDialog;
    PreviewButton: TButton;
    Cmatchestovfr1: TMenuItem;
    TFFSwitching1: TMenuItem;
    Switchcnonly1: TMenuItem;
    Switching1: TMenuItem;
    Switchpconly1: TMenuItem;
    Switchncp1: TMenuItem;
    N5: TMenuItem;
    BFF1: TMenuItem;
    AlignPanel: TPanel;
    ActionList: TActionList;
    SwitchAction: TAction;
    TryPatternAction: TAction;
    SetRangeAction: TAction;
    PostprocessAction: TAction;
    DecimateAction: TAction;
    ResetAction: TAction;
    GotoAction: TAction;
    SaveAction: TAction;
    OpenAction: TAction;
    SaveFieldHints1: TMenuItem;
    PreviewAction: TAction;
    SettingsAction: TAction;
    ToolsAction: TAction;
    PlayAction: TAction;
    Image: TImage32;
    ShowFrozen1: TMenuItem;
    PatternGuidance1: TMenuItem;
    AddRangeAction: TAction;
    AddDecimationAction: TAction;
    AddFreezeFrameAction: TAction;
    AddSectionAction: TAction;
    CloseAction: TAction;
    SwitchToComplementAction: TAction;
    SetPatternAction: TAction;
    ResetSectionAction: TAction;
    ShiftPatternInSectionAction: TAction;
    JumpToNextPPAction: TAction;
    FindVFRType1Action: TAction;
    FindVFRType2Action: TAction;
    DeleteCurrentSectionAction: TAction;
    DeleteCurrentFreezeFrameAction: TAction;
    PostprocessSectionAction: TAction;
    ReplaceFrameWithNextAction: TAction;
    ReplaceFrameWithPreviousAction: TAction;
    DeleteCurrentRangeAction: TAction;
    ToggleToolbarAction: TAction;
    ToggleZoomAction: TAction;
    PlayFromSectionStartAction: TAction;
    NoDecimateSectionAction: TAction;
    JumpPlus5FramesAction: TAction;
    JumpPlus50FramesAction: TAction;
    JumpPlus10FramesAction: TAction;
    NextFrameAction: TAction;
    PreviousFrameAction: TAction;
    JumpMinus5FramesAction: TAction;
    JumpMinus10FramesAction: TAction;
    JumpMinus50FramesAction: TAction;
    JumpToNextSectionAction: TAction;
    JumpToPreviousSectionAction: TAction;
    UsePatternAction: TAction;
    PatternGuidanceOnSectionAction: TAction;
    procedure About1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FrameTrackBarChange(Sender: TObject);
    procedure ApplicationEventsShortCut(var Msg: TWMKey;
      var Handled: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure SwitchActionExecute(Sender: TObject);
    procedure TryPatternActionExecute(Sender: TObject);
    procedure SetRangeActionExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PostprocessActionExecute(Sender: TObject);
    procedure DecimateActionExecute(Sender: TObject);
    procedure ResetActionExecute(Sender: TObject);
    procedure GotoActionExecute(Sender: TObject);
    procedure OpenActionExecute(Sender: TObject);
    procedure CloseActionExecute(Sender: TObject);
    procedure ProjectOpenUpdate(Sender: TObject);
    procedure SettingsActionExecute(Sender: TObject);
    procedure ToolsActionExecute(Sender: TObject);
    procedure SaveActionExecute(Sender: TObject);
    procedure TFFSwitching1Click(Sender: TObject);
    procedure BFF1Click(Sender: TObject);
    procedure PreviewActionExecute(Sender: TObject);
    procedure GenericUpdateFrame(Sender: TObject);
    procedure ClearPostprocessed1Click(Sender: TObject);
    procedure ClearDecimated1Click(Sender: TObject);
    procedure Cropping1Click(Sender: TObject);
    procedure AddRangeActionExecute(Sender: TObject);
    procedure AddDecimationActionExecute(Sender: TObject);
    procedure AddFreezeFrameActionExecute(Sender: TObject);
    procedure AddSectionActionExecute(Sender: TObject);
    procedure ActionListExecute(Action: TBasicAction;
      var Handled: Boolean);
    procedure ToggleZoomActionExecute(Sender: TObject);
    procedure ToggleToolbarActionExecute(Sender: TObject);
    procedure NextFrameActionExecute(Sender: TObject);
    procedure JumpMinus5FramesActionExecute(Sender: TObject);
    procedure PreviousFrameActionExecute(Sender: TObject);
    procedure JumpPlus5FramesActionExecute(Sender: TObject);
    procedure JumpPlus10FramesActionExecute(Sender: TObject);
    procedure JumpPlus50FramesActionExecute(Sender: TObject);
    procedure JumpMinus50FramesActionExecute(Sender: TObject);
    procedure JumpMinus10FramesActionExecute(Sender: TObject);
    procedure SaveAllOverrides1Click(Sender: TObject);
    procedure SaveFieldHints1Click(Sender: TObject);
    procedure SaveTimecodes1Click(Sender: TObject);
    procedure UsePatternActionExecute(Sender: TObject);
    procedure UsePatternActionUpdate(Sender: TObject);
  private
    FRangeStart: Integer;
    FFFRangeStart: Integer;

    FLastFrame: Integer;
    FDisplayText: TStringList;

    FTryPattern: Boolean;
    FAskOnTryPattern: Boolean;
    FTryPatternStart: Integer;
    FMatchPattern: string;
    FDecimationPattern: string;
    FPostprocessPattern: string;
    FFreezePattern: string;
    
    FMultiple: Integer;
    FPanelHeight: Integer;
    FSettings: TMemIniFile;
    FPluginPath: string;

    procedure ShiftPattern;
    procedure SetPattern(AStart, AEnd: Integer);
    procedure SetMultiple(M: Integer);
  public
    procedure ShowText(Text: string);
    procedure UpdateFrame;

    property PluginPath: string read FPluginPath write FPluginPath;
    property Settings: TMemIniFile read FSettings;
    property RangeStart: Integer read FRangeStart write FRangeStart;
    property FFRangeStart: Integer read FFFRangeStart write FFFRangeStart;
    property Multiple: Integer read FMultiple write SetMultiple;
  end;

var
  MatchForm: TMatchForm;
  CLOpen: Boolean;
  Project: TYattaProject = nil;

implementation

uses
  Tools, About, Settings, patternselect, MarkerLists,
  ScriptPreview, Asif, Preview, Crop;

{$R *.dfm}

procedure TMatchForm.SetMultiple(M: Integer);
var
  CalculatedWidth: Integer;
  CalculatedHeight: Integer;
begin
  if (FMultiple <> M) then
  begin
    if (M >= 1) then
      FMultiple := M;

    with Project.Video.RGB32Video.GetVideoInfo do
    begin
      CalculatedHeight := StatusBar.Height + AlignPanel.Height + FrameTrackBar.Height + Multiple * Height;
      ClientHeight := CalculatedHeight;

      CalculatedWidth := Max(720, Multiple * Width);
      ClientWidth := CalculatedWidth;

      if ((ClientHeight <> CalculatedHeight) or (ClientWidth <> ClientWidth)) and (Multiple > 1) then
        Multiple := 1;

      if Multiple = 1 then
        Image.ScaleMode := smNormal
      else
        Image.ScaleMode := smScale;
      Image.Scale := Multiple;
    end;
  end;
end;

procedure TMatchForm.ShiftPattern;
  function ShiftString(const S: string): string;
  begin
    Assert(S <> '');
    Result := S[Length(S)] + LeftStr(S, Length(S) - 1);
  end;
begin
  FMatchPattern := ShiftString(FMatchPattern);
  FPostprocessPattern := ShiftString(FPostprocessPattern);
  FDecimationPattern := ShiftString(FDecimationPattern);
  FFreezePattern := ShiftString(FFreezePattern);
end;

procedure TMatchForm.About1Click(Sender: TObject);
begin
  with TAboutForm.Create(nil) do
  begin
    ShowModal;
    Free;
  end;
end;

procedure TMatchForm.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  SetExceptionMask(GetExceptionMask + [exInvalidOp, exOverflow, exZeroDivide]);

  Application.UpdateFormatSettings := False;

  // Save defaults
  for I := 0 to ActionList.ActionCount - 1 do
    with ActionList.Actions[I] as TAction do
      Tag := ShortCut;

  Project := nil;
  FLastFrame := -1;
  FTryPattern := False;
  RangeStart := -1;
  FFRangeStart := -1;
  FPanelHeight := AlignPanel.Height;
  FMultiple := 1;
  FAskOnTryPattern := True;

  InitializeFilterlist(ExtractFilePath(Application.ExeName) + 'FilterList.txt');

  FDisplayText := TStringList.Create;

  FSettings := TMemIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));

  for I := 0 to ActionList.ActionCount - 1 do
    with ActionList.Actions[I] as TAction do
      ShortCut := TextToShortCut(FSettings.ReadString('Key Mapping', Caption, ShortCutToText(ShortCut)));

  FPluginPath := FSettings.ReadString('Main', 'PluginDir', '');
end;

procedure TMatchForm.FrameTrackBarChange(Sender: TObject);
begin
  if (Project <> nil) and (FLastFrame <> FrameTrackBar.Position) then
    UpdateFrame;

  FLastFrame := FrameTrackBar.Position;
end;

procedure TMatchForm.ApplicationEventsShortCut(var Msg: TWMKey;
  var Handled: Boolean);
begin
  if Active then
  begin
    Handled := True;

    if Msg.CharCode = vk_left then
      FrameTrackBar.Position := FrameTrackBar.Position - 1
    else if Msg.CharCode = vk_right then
      FrameTrackBar.Position := FrameTrackBar.Position + 1
    else
      Handled := False;
  end;
end;

procedure TMatchForm.ShowText(Text: string);
begin
  FDisplayText.Append(Text);
end;

procedure TMatchForm.UpdateFrame;
  procedure MakePattern(const X, Y: Integer);
  var
    TempPattern: Char;
    I: Integer;
  begin
    Image.Bitmap.Canvas.MoveTo(X, Y);

    //Project.Decimates.GetByFrame()

    for I := Max(FrameTrackBar.Position - 10, 0) to Min(FrameTrackBar.Position + 10, FrameTrackBar.Max) do
    begin
      if I mod 5 = 0 then
        Image.Bitmap.Canvas.Font.Style := [fsUnderline]
      else
        Image.Bitmap.Canvas.Font.Style := [];

      if Project.Decimated[I] then
        Image.Bitmap.Canvas.Font.Style := Image.Bitmap.Font.Style + [fsStrikeOut];

      TempPattern := Project.MatchChar[I];

      if FrameTrackBar.Position = I then
        TempPattern := UpCase(TempPattern);

      Image.Bitmap.Canvas.TextOut(Image.Bitmap.Canvas.PenPos.X, Image.Bitmap.Canvas.PenPos.Y, TempPattern);
    end;

    Image.Bitmap.Canvas.Font.Style := [];
  end;
var
  I: Integer;
  Decimated: Boolean;
  DPos: Integer;
  DType: string;
begin
  Project.Video.GetFrame(Project.FFMatch[FrameTrackBar.Position], Image.Bitmap);

  if ShowText1.Checked then
  begin
    FDisplayText.Insert(0, Format('DMetric: %d', [Project.DMetric[FrameTrackBar.Position]]));
    FDisplayText.Insert(0, '<pattern>');

    with Project.VMetrics do
      case MetricMode of
        mm3Way: FDisplayText.Insert(0, Format('VMetrics: %d, %d, %d', [Metrics[FrameTrackBar.Position, 'p'], Metrics[FrameTrackBar.Position, 'c'], Metrics[FrameTrackBar.Position, 'n']]));
        mm5Way: FDisplayText.Insert(0, Format('VMetrics: %d, %d, %d, %d, %d', [Metrics[FrameTrackBar.Position, 'b'], Metrics[FrameTrackBar.Position, 'p'], Metrics[FrameTrackBar.Position, 'c'], Metrics[FrameTrackBar.Position, 'n'], Metrics[FrameTrackBar.Position, 'u']]));
      end;

    with Project.MMetrics do
      case MetricMode of
        mm3Way: FDisplayText.Insert(0, Format('MMetrics: %d, %d, %d', [Metrics[FrameTrackBar.Position, 'p'], Metrics[FrameTrackBar.Position, 'c'], Metrics[FrameTrackBar.Position, 'n']]));
        mm5Way: FDisplayText.Insert(0, Format('MMetrics: %d, %d, %d, %d, %d', [Metrics[FrameTrackBar.Position, 'b'], Metrics[FrameTrackBar.Position, 'p'], Metrics[FrameTrackBar.Position, 'c'], Metrics[FrameTrackBar.Position, 'n'], Metrics[FrameTrackBar.Position, 'u']]));
      end;

    with Image.Bitmap.Canvas do
      for I := 0 to FDisplayText.Count - 1 do
        if FDisplayText[I] = '<pattern>' then
          MakePattern(15, I * (Abs(Font.Height) + 5) + 15)
        else
          TextOut(15, I * (Abs(Font.Height) + 5) + 15, FDisplayText[I]);
  end;

  FDisplayText.Clear;

  DPos := Project.GetDecimatedPos(FrameTrackBar.Position, Decimated);

  if Project.Decimated[FrameTrackBar.Position] then
    DType := 'Hard '
  else if Decimated then
    DType := 'Soft '
  else
    DType := '';

  StatusBar.SimpleText := Format('Frame: %d; %sDecimated: %d', [FrameTrackBar.Position, DType, DPos]);
  Image.Repaint;
end;

procedure TMatchForm.FormDestroy(Sender: TObject);
var
  I: Integer;
begin
  FSettings.WriteString('Main', 'PluginDir', FPluginPath);

  for I := 0 to ActionList.ActionCount - 1 do
    with ActionList.Actions[I] as TAction do
      FSettings.WriteString('Key Mapping', Caption, ShortCutToText(ShortCut));

  FSettings.UpdateFile;
  FSettings.Free;
  FDisplayText.Free;
end;

procedure TMatchForm.SwitchActionExecute(Sender: TObject);
begin
  if FTryPattern then
    ShiftPattern
  else
    case Project.MatchChar[FrameTrackBar.Position] of
      'n': if Switchcnonly1.Checked then Project.MatchChar[FrameTrackBar.Position] := 'c' else Project.MatchChar[FrameTrackBar.Position] := 'p';
      'c': if Switchpconly1.Checked then Project.MatchChar[FrameTrackBar.Position] := 'p' else Project.MatchChar[FrameTrackBar.Position] := 'n';
      'p': Project.MatchChar[FrameTrackBar.Position] := 'c';
    else
      Project.MatchChar[FrameTrackBar.Position] := 'c';
    end;

  UpdateFrame;
end;

procedure TMatchForm.TryPatternActionExecute(Sender: TObject);
begin
  FTryPattern := (not FTryPattern);
  if FTryPattern and FAskOnTryPattern then
  begin
    with TPatternSelectForm.Create(Self) do
    begin
      MatchPattern.Text := FMatchPattern;
      DecimationPattern.Text := FDecimationPattern;
      PostprocessPattern.Text := FPostprocessPattern;
      FreezeFramePattern.Text := FFreezePattern;
      AskOnTryPattern.Checked := FAskOnTryPattern;

      if ShowModal = mrOk then
      begin
        FMatchPattern := MatchPattern.Text;
        FDecimationPattern := DecimationPattern.Text;
        FPostprocessPattern := PostprocessPattern.Text;
        FFreezePattern := FreezeFramePattern.Text;
        FAskOnTryPattern := AskOnTryPattern.Checked;
      end
      else
        FTryPattern := False;

      Free;
    end;
  end;

  FTryPatternStart := FrameTrackBar.Position;

  UpdateFrame;
end;

procedure TMatchForm.SetRangeActionExecute(Sender: TObject);
begin
  if RangeStart = -1 then
  begin
    RangeStart := FrameTrackBar.Position;
    ShowText(Format('Range start: %d', [RangeStart]));
  end
  else
  begin
    RangeStart := -1;
    ShowText('Range off');
  end;

  UpdateFrame;
end;

procedure TMatchForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Project <> nil then
    case MessageDlg('Do you want to save before quitting?', mtConfirmation, mbYesNoCancel, 0) of
      mrYes: Project.SaveProject;
      mrNo:;
      mrCancel: Abort;
    end;
  CloseAction.Execute;
end;

procedure TMatchForm.PostprocessActionExecute(Sender: TObject);
begin
  Project.Postprocessed[FrameTrackBar.Position] := not Project.Postprocessed[FrameTrackBar.Position];
  UpdateFrame;
end;

procedure TMatchForm.DecimateActionExecute(Sender: TObject);
var
  DState: Boolean;
begin
  DState := Project.Decimated[FrameTrackBar.Position];
  Project.Decimated[FrameTrackBar.Position] := not Project.Decimated[FrameTrackBar.Position];
  if Project.Decimated[FrameTrackBar.Position] = DState then
    ShowText('Frame cannot be decimated');
  UpdateFrame;
end;

procedure TMatchForm.ResetActionExecute(Sender: TObject);
begin
  if RangeStart = -1 then
    Project.ResetMatch(FrameTrackBar.Position, FrameTrackBar.Position)
  else
    Project.ResetMatch(RangeStart, FrameTrackBar.Position);
end;

procedure TMatchForm.GotoActionExecute(Sender: TObject);
var
  GotoText: string;
  GotoFrame: Integer;
begin
  GotoText := InputBox('Goto', 'Enter frame number:', IntToStr(FrameTrackBar.Position));
  if (GotoText <> '') and (GotoText[Length(GotoText)] <> 'd') then
    FrameTrackBar.Position := StrToIntDef(GotoText, FrameTrackBar.Position)
  else
  begin
    GotoText := LeftStr(GotoText, Length(GotoText) - 1);
    GotoFrame := StrToIntDef(GotoText, -1);
    if (GotoFrame >= 0) and (GotoFrame < Project.Framecount) then
      FrameTrackBar.Position := Project.GetDecimatedPos(GotoFrame);
  end;
end;

procedure TMatchForm.OpenActionExecute(Sender: TObject);
begin
  if CLOpen or ProjectOpenDialog.Execute then
  begin
    //Sleep(100); //fix me, hangs without it
    if SettingsForm.MPEG2DecRadioGroup.ItemIndex = 0 then
      Project := TYattaProject.Create(Caption, FPluginPath, ProjectOpenDialog.FileName, mdMpeg2Dec3)
    else
      Project := TYattaProject.Create(Caption, FPluginPath, ProjectOpenDialog.FileName, mdDGDecode);

    with ToolForm, Project do
    begin
      FreezeFrames.View := FreezeFrameList;
      Decimates.View := DecimateList;
      Presets.View := PresetList;
      Layers.View := LayerList;
    end;

    FrameTrackBar.Max := Project.Framecount - 1;
    Multiple := -1;

    UpdateFrame;

    Project.CollectDMetrics := True;

    OpenCloseButton.Action := CloseAction;
  end;
end;

procedure TMatchForm.CloseActionExecute(Sender: TObject);
begin
  PreviewForm.Close;
  ToolForm.Close;
  FreeAndNil(Project);
  OpenCloseButton.Action := OpenAction;
end;

procedure TMatchForm.ProjectOpenUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := Project <> nil;
end;

procedure TMatchForm.SettingsActionExecute(Sender: TObject);
begin
  SettingsForm.Show;
end;

procedure TMatchForm.ToolsActionExecute(Sender: TObject);
begin
  ToolForm.Show;
end;

procedure TMatchForm.SaveActionExecute(Sender: TObject);
begin
  if Project.ProjectFilename <> '' then
    Project.SaveProject()
  else if ProjectSaveDialog.Execute then
    Project.SaveProject(ProjectSaveDialog.FileName);
end;

procedure TMatchForm.TFFSwitching1Click(Sender: TObject);
begin
  Project.FieldOrder := foTFF;
  UpdateFrame;
end;

procedure TMatchForm.BFF1Click(Sender: TObject);
begin
  Project.FieldOrder := foBFF;
  UpdateFrame;
end;

procedure TMatchForm.PreviewActionExecute(Sender: TObject);
var
  SL: TStringList;
begin
  if Project.ProjectFilename <> '' then
  begin
    Project.SaveFieldHints;

    SL := TStringList.Create;

    try
      Project.GenerateAvisynthScript(SL);
      Project.Video.BindToVariable('YattaVideoSource');
      LoadPlugins(SL.Text, FPluginPath, Project.Video.Env);
      SL.Append('ConvertToRGB32()');

      try
        Project.Video.Env.CharArg(PChar(SL.Text));
        PreviewForm.PreviewClip := Project.Video.Env.InvokeWithClipResult('Eval');
        PreviewForm.Show;
      except on E: EInvokeFailed do
        begin
          PreviewForm.Close;
          MessageDlg(E.message, mtError, [mbOK], 0);
        end;
      end;

    finally
      SL.Free;
    end;
  end
  else
    MessageDlg('You have to save the project before previewing.', mtError, [mbOK], 0);
end;

procedure TMatchForm.GenericUpdateFrame(Sender: TObject);
begin
  UpdateFrame;
end;

procedure TMatchForm.ClearPostprocessed1Click(Sender: TObject);
var
  I: Integer;
begin
  if MessageDlg('Do you really clear all frames marked for postprocess?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    for I := 0 to Project.Framecount - 1 do
      Project.Postprocessed[I] := False;
end;

procedure TMatchForm.ClearDecimated1Click(Sender: TObject);
var
  I: Integer;
begin
  if MessageDlg('Do you really clear all frames marked for decimation?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    for I := 0 to Project.Framecount - 1 do
      Project.Decimated[I] := False;
end;

procedure TMatchForm.Cropping1Click(Sender: TObject);
begin
  CropForm.Show;
end;

procedure TMatchForm.AddRangeActionExecute(Sender: TObject);
begin
  with ToolForm do
    if (RangesList.DataSource <> nil) then
    begin
      if (RangeStart = -1) then
        SetRangeAction.Execute
      else if (RangeStart <> -1) then
      begin
        (RangesList.DataSource as TRangeList).Add(RangeStart, FrameTrackBar.Position);
        RangeStart := -1;
        UpdateFrame;
      end;
    end;
end;

procedure TMatchForm.AddDecimationActionExecute(Sender: TObject);
var
  M, N: Integer;
begin
  with ToolForm do
  try
    M := StrToIntDef(GetToken(MinN.Text, 0, [':']), -1);
    N := StrToIntDef(GetToken(MinN.Text, 1, [':']), -1);

    (DecimateList.DataSource as TDecimationMarkerList).Add(FrameTrackBar.Position, M, N);
    UpdateFrame;
  except
  end;
end;

procedure TMatchForm.AddFreezeFrameActionExecute(Sender: TObject);
begin
  with ToolForm do
  begin
    if FFRangeStart = -1 then
    begin
      FFRangeStart := FrameTrackBar.Position;
      ShowText('Select frame to replace with');
    end
    else
    begin
      if RangeStart = -1 then
        RangeStart := FFRangeStart;

      Project.FreezeFrames.Add(RangeStart, FFRangeStart, FrameTrackBar.Position);

      ShowText(Format('Replaced from %d to %d with %d', [RangeStart, FFRangeStart, FrameTrackBar.Position]));

      RangeStart := -1;
      FFRangeStart := -1;
    end;

    UpdateFrame;
  end;
end;

procedure TMatchForm.AddSectionActionExecute(Sender: TObject);
var
  Section: TSection;
begin
  with ToolForm do
    if (SectionList.DataSource <> nil) then
    begin
      with SectionList.DataSource as TSectionList do
      begin
        Section := GetByFrame(FrameTrackBar.Position);

        if Section = nil then
          Add(FrameTrackBar.Position, -1)
        else
          Add(FrameTrackBar.Position, Section.Preset);
      end;
    end;
end;

procedure TMatchForm.ActionListExecute(Action: TBasicAction;
  var Handled: Boolean);
begin
  Handled := not Active;
end;

procedure TMatchForm.ToggleZoomActionExecute(Sender: TObject);
begin
  Multiple := Multiple xor 3;
end;

procedure TMatchForm.ToggleToolbarActionExecute(Sender: TObject);
var
  FinalHeight: Integer;
begin
  if AlignPanel.Height <> 0 then
  begin
    Top := 0;
    Left := 0;
    BorderStyle := bsNone;
    AlignPanel.Height := 0
  end
  else
  begin
    BorderStyle := bsSingle;
    AlignPanel.Height := FPanelHeight;
  end;

  FinalHeight := StatusBar.Height + AlignPanel.Height + FrameTrackBar.Height + Multiple * Image.Bitmap.Height;
  ClientHeight := FinalHeight;
  if ClientHeight <> FinalHeight then
    Multiple := 1;
end;

procedure TMatchForm.NextFrameActionExecute(Sender: TObject);
begin
  FrameTrackBar.Position := FrameTrackBar.Position + 1;
end;

procedure TMatchForm.JumpMinus5FramesActionExecute(Sender: TObject);
begin
  FrameTrackBar.Position := FrameTrackBar.Position - 5;
end;

procedure TMatchForm.PreviousFrameActionExecute(Sender: TObject);
begin
  FrameTrackBar.Position := FrameTrackBar.Position - 1;
end;

procedure TMatchForm.JumpPlus5FramesActionExecute(Sender: TObject);
begin
  FrameTrackBar.Position := FrameTrackBar.Position + 5;
end;

procedure TMatchForm.JumpPlus10FramesActionExecute(Sender: TObject);
begin
  FrameTrackBar.Position := FrameTrackBar.Position + 10;
end;

procedure TMatchForm.JumpPlus50FramesActionExecute(Sender: TObject);
begin
  FrameTrackBar.Position := FrameTrackBar.Position + 50;
end;

procedure TMatchForm.JumpMinus50FramesActionExecute(Sender: TObject);
begin
  FrameTrackBar.Position := FrameTrackBar.Position - 50;
end;

procedure TMatchForm.JumpMinus10FramesActionExecute(Sender: TObject);
begin
  FrameTrackBar.Position := FrameTrackBar.Position - 10;
end;

procedure TMatchForm.SaveAllOverrides1Click(Sender: TObject);
begin
  with Project do
  begin
    SaveAvisynthScript;
    SaveFieldHints;
    SaveTimecodes;
  end;
end;

procedure TMatchForm.SaveFieldHints1Click(Sender: TObject);
begin
  if FieldMatchSaveDialog.Execute then
    Project.SaveFieldHints(FieldMatchSaveDialog.FileName);
end;

procedure TMatchForm.SaveTimecodes1Click(Sender: TObject);
begin
  if TimecodeSaveDialog.Execute then
    Project.SaveTimecodes(TimecodeSaveDialog.FileName);
end;

procedure TMatchForm.UsePatternActionExecute(Sender: TObject);
begin
  SetPattern(FTryPatternStart, FrameTrackBar.Position);
  FTryPattern := False;
  UpdateFrame;
end;

procedure TMatchForm.UsePatternActionUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := FTryPattern;
end;

procedure TMatchForm.SetPattern(AStart, AEnd: Integer);
var
  I: Integer;
  CurrentChar: Char;
begin
  for I := AStart to AEnd do
  begin
    CurrentChar := FMatchPattern[((I - AStart) mod Length(FMatchPattern)) + 1];
    if CurrentChar in ['b','p','c','n','u'] then
      Project.MatchChar[I] := CurrentChar;

    if FDecimationPattern[((I - AStart) mod Length(FDecimationPattern)) + 1] = 'k' then
      Project.Decimated[I] := False;

    case FPostprocessPattern[((I - AStart) mod Length(FPostprocessPattern)) + 1] of
      '+': Project.Postprocessed[I] := True;
      '-': Project.Postprocessed[I] := False;
    end;

    case FFreezePattern[((I - AStart) mod Length(FFreezePattern)) + 1] of
      'n': Project.FreezeFrames.Add(I, I, I + 1);
      'p': Project.FreezeFrames.Add(I, I, I - 1);
    end;
  end;

  for I := AStart to AEnd do
    if FDecimationPattern[((I - AStart) mod Length(FDecimationPattern)) + 1] = 'k' then
      Project.Decimated[I] := True;
end;

end.

