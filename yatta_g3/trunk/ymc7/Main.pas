unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, StrUtils, ExtCtrls, Buttons, Math, YMCTask, YMCPlugin, YMCInternalPlugins, asif, frameget, inifiles,
  filectrl, CheckLst, shellapi, AsifAdditions, ActnList, AppEvnts, Menus, YShared,
  XPMan;

const
  INIVersion = 19;
  MainIniKey = 'YMC7';

type
  TMainForm = class(TForm)
    ConfigureButton: TButton;
    StartButton: TButton;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    Jobs: TGroupBox;
    JobList: TListBox;
    AddButton: TButton;
    RemoveButton: TButton;
    SetOutputButton: TButton;
    Settings: TGroupBox;
    CloseWhenDone: TCheckBox;
    LaunchWhenDone: TCheckBox;
    Mpeg2DecRadioGroup: TRadioGroup;
    Metrics: TGroupBox;
    MetricFilterList: TCheckListBox;
    MoveFilterUpButton: TSpeedButton;
    MoveFilterDownButton: TSpeedButton;
    ActionList: TActionList;
    AddAction: TAction;
    MoveJobDownAction: TAction;
    MoveJobUpAction: TAction;
    SetOutputAction: TAction;
    RemoveAction: TAction;
    ConfigureAction: TAction;
    StartAction: TAction;
    JobPopupMenu: TPopupMenu;
    MoveJobUpButton: TSpeedButton;
    MoveJobDownButton: TSpeedButton;
    XPManifest: TXPManifest;
    ClearErrors1: TMenuItem;
    N1: TMenuItem;
    SetAvisynthPluginDirectory1: TMenuItem;
    SetDefaultTaskPriority1: TMenuItem;
    Higher1: TMenuItem;
    Normal1: TMenuItem;
    Lower1: TMenuItem;
    Lowest1: TMenuItem;
    Idle1: TMenuItem;
    MarkAsReadyAction: TAction;
    MoveFilterUpAction: TAction;
    MoveFilterDownAction: TAction;
    ClearAllErrors1: TMenuItem;
    SetMaxRunningJobs1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure JobListClick(Sender: TObject);
    procedure MetricFilterListClickCheck(Sender: TObject);
    procedure JobListData(Control: TWinControl; Index: Integer;
      var Data: string);
    procedure AddActionExecute(Sender: TObject);
    procedure RemoveActionExecute(Sender: TObject);
    procedure RemoveActionUpdate(Sender: TObject);
    procedure SetOutputActionExecute(Sender: TObject);
    procedure MoveJobUpActionExecute(Sender: TObject);
    procedure MoveJobUpActionUpdate(Sender: TObject);
    procedure MoveJobDownActionExecute(Sender: TObject);
    procedure MoveJobDownActionUpdate(Sender: TObject);
    procedure SetOutputActionUpdate(Sender: TObject);
    procedure ConfigureActionUpdate(Sender: TObject);
    procedure ConfigureActionExecute(Sender: TObject);
    procedure StartActionUpdate(Sender: TObject);
    procedure StartActionExecute(Sender: TObject);
    procedure JobListDataObject(Control: TWinControl; Index: Integer;
      var DataObject: TObject);
    procedure SetAvisynthPluginDirectory1Click(Sender: TObject);
    procedure Mpeg2DecRadioGroupClick(Sender: TObject);
    procedure MarkAsReadyActionExecute(Sender: TObject);
    procedure MarkAsReadyActionUpdate(Sender: TObject);
    procedure SetDefaultPriorityClick(Sender: TObject);
    procedure MoveFilterUpActionExecute(Sender: TObject);
    procedure MoveFilterUpActionUpdate(Sender: TObject);
    procedure MoveFilterDownActionExecute(Sender: TObject);
    procedure MoveFilterDownActionUpdate(Sender: TObject);
    procedure ClearAllErrors1Click(Sender: TObject);
    procedure SetMaxRunningJobs1Click(Sender: TObject);
    procedure MetricFilterListDblClick(Sender: TObject);
  private
    FIni: TMemIniFile;
    FTaskList: TYMCTaskList;

    procedure WMDropFiles(var Msg: TWMDropFiles); message WM_DROPFILES;
    procedure AddFile(Filename: string);
    procedure RemoveFile(Index: Integer);
    procedure SetAvisynthPluginDirectory();
  public
    procedure UpdateSelectedJob;
    property Ini: TMemIniFile read FIni;
    property TaskList: TYMCTaskList read FTaskList;
    procedure Hide;
    procedure Show;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  Progress;

procedure TMainForm.WMDropFiles(var Msg: TWMDropFiles);
var
  Filename: string;
  Counter: Integer;
  BufferSize: Cardinal;
begin
  JobList.Items.BeginUpdate;
  for Counter := 0 to DragQueryFile(Msg.Drop, High(Cardinal), nil, 0) - 1 do
  begin
    BufferSize := DragQueryFile(Msg.Drop, Counter, nil, 0) + 1;
    SetLength(FileName, BufferSize);
    DragQueryFile(Msg.Drop, Counter, PChar(FileName), BufferSize);
    Filename := PChar(FileName);
    AddFile(Filename);
  end;
  JobList.Items.EndUpdate;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  PluginPath: string;
  Errors: string;
begin
  SetExceptionMask(GetExceptionMask + [exInvalidOp, exOverflow, exZeroDivide]);

  Application.UpdateFormatSettings := False;

  DecimalSeparator := '.';
  LongTimeFormat := 'hh:nn:ss';
  ShortTimeFormat := 'hh:nn:ss';

  try
    InitializeFilterlist(ExtractFilePath(Application.ExeName) + 'filterlist.txt');
  except on E: EAsifException do
      MessageDlg(E.Message, mtError, [mbOK], 0);
  end;

  FINI := TMemIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));

  if INI.ReadInteger(MainIniKey, 'Version', -1) <> INIVersion then
  begin
    INI.Clear;
    DeleteFile(ChangeFileExt(Application.ExeName, '.tasks'));
  end;

  PluginPath := INI.ReadString(MainIniKey, 'PluginDir', '');

  YMCPluginInit(@AddPlugin);

  FTaskList := TYMCTaskList.Create(PluginPath, TMpeg2Decoder(INI.ReadInteger(MainIniKey, 'Mpeg2Decoder', Integer(mdMpeg2Dec3))), INI);
  FTaskList.SavedBy := Caption;
  FTaskList.DefaultPriority := TThreadPriority(INI.ReadInteger(MainIniKey, 'DefaultPriority', Integer(tpLowest)));

  FTaskList.MaxThreads := INI.ReadInteger(MainIniKey, 'MaxJobs', 1);

  if PluginPath = '' then
    if MessageDlg('Avisynth plugin path has to be set. If you want to change it later delete or edit the ini file.', mtWarning, [mbok, mbcancel], 0) = mrok then
      SetAvisynthPluginDirectory;

  Mpeg2DecRadioGroup.ItemIndex := Integer(FTaskList.Mpeg2Decoder);

  case FTaskList.DefaultPriority of
    tpIdle: Idle1.Checked := True;
    tpLowest: Lowest1.Checked := True;
    tpLower: Lower1.Checked := True;
    tpNormal: Normal1.Checked := True;
    tpHigher: Higher1.Checked := True;
  end;

  LaunchWhenDone.Checked := INI.ReadBool(MainIniKey, 'LaunchYatta', False);
  CloseWhenDone.Checked := INI.ReadBool(MainIniKey, 'CloseWhenDone', False);

  try
    InitializeAvisynth;
  except on E: EAsifException do
    begin
      MessageDlg(E.Message, mtError, [mbok], 0);
      Halt(7000);
    end;
  end;

  DragAcceptFiles(Handle, True);

  JobList.Count := FTaskList.LoadTasks(ChangeFileExt(Application.ExeName, '.tasks'), Errors);
  if Errors <> '' then
    MessageDlg(Errors, mtError, [mbOK], 0);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  with INI do
  begin
    WriteInteger(MainIniKey, 'Version', INIVersion);
    WriteBool(MainIniKey, 'CloseWhenDone', CloseWhenDone.Checked);
    WriteBool(MainIniKey, 'LaunchYatta', LaunchWhenDone.Checked);
    WriteInteger(MainIniKey, 'Mpeg2Decoder', Mpeg2DecRadioGroup.ItemIndex);
    WriteString(MainIniKey, 'PluginDir', FTaskList.PluginPath);
    WriteInteger(MainIniKey, 'MaxJobs', FTaskList.MaxThreads);

    UpdateFile;
    Free;
  end;

  FTaskList.SaveTasks(ChangeFileExt(Application.ExeName, '.tasks'));
  FTaskList.Free;

  DeinitializeAvisynth;
end;

procedure TMainForm.AddFile(Filename: string);
var
  FileExt: string;
begin
  FileExt := AnsiLowerCase(ExtractFileExt(Filename));
  
  if FileExists(Filename + '.yap') then
    if MessageDlg('The default output file "' + Filename + '.yap' + '" already exists.'#13#10'Add the file anyway?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
      Exit;

  FTaskList.AddTask(Filename, Filename + '.yap');
  JobList.Count := JobList.Count + 1;
  JobList.ItemIndex := JobList.Count - 1;

  UpdateSelectedJob;
end;

procedure TMainForm.JobListClick(Sender: TObject);
begin
  UpdateSelectedJob;
end;

procedure TMainForm.MetricFilterListClickCheck(Sender: TObject);
begin
  if (JobList.ItemIndex >= 0) then
  begin
    with FTaskList[JobList.ItemIndex][MetricFilterList.ItemIndex] do
      Selected := not Selected;
  end;
end;

procedure TMainForm.JobListData(Control: TWinControl; Index: Integer;
  var Data: string);
begin
  Data := FTaskList[Index].InputFile;
end;

procedure TMainForm.RemoveFile(Index: Integer);
var NewIndex: Integer;
begin
  with JobList do
  begin
    NewIndex := ItemIndex - 1;
    FTaskList.Delete(Index);
    Count := Count - 1;

    if (NewIndex < 0) and (Count > 0) then
      ItemIndex := 0
    else
      ItemIndex := NewIndex;
  end;

  UpdateSelectedJob;
end;

procedure TMainForm.UpdateSelectedJob;
var Counter: Integer;
begin
  if JobList.ItemIndex < 0 then
    JobList.Hint := ''
  else
  begin
    with FTaskList[JobList.ItemIndex] do
      JobList.Hint := 'Task Id: ' + IntToStr(TaskId) + #13#10'Destination: ' +
        OutputFile + #13#10'Status: ' + TaskStatusToText(Status);
  end;

  MetricFilterList.Clear;
  if JobList.ItemIndex >= 0 then
    with FTaskList[JobList.ItemIndex] do
      for Counter := 0 to Count - 1 do
      begin
        MetricFilterList.Items.Add(Items[Counter].GetName);
        MetricFilterList.Checked[Counter] := Items[Counter].Selected;
      end;
end;

procedure TMainForm.AddActionExecute(Sender: TObject);
var
  Counter: Integer;
begin
  if OpenDialog.Execute then
  begin
    //fixme, adds magic sleep when being debugged or it hangs
    //if DebugHook <> 0 then
    Sleep(100);

    JobList.Items.BeginUpdate;
    for Counter := 0 to OpenDialog.Files.Count - 1 do
      AddFile(OpenDialog.Files[Counter]);
    JobList.Items.EndUpdate;
  end;
end;

procedure TMainForm.RemoveActionExecute(Sender: TObject);
begin
  RemoveFile(JobList.ItemIndex);
end;

procedure TMainForm.RemoveActionUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := JobList.ItemIndex >= 0;
end;

procedure TMainForm.SetOutputActionExecute(Sender: TObject);
begin
  SaveDialog.FileName := FTaskList[JobList.ItemIndex].OutputFile;

  if SaveDialog.Execute then
  begin
    FTaskList[JobList.ItemIndex].OutputFile := SaveDialog.FileName;
    UpdateSelectedJob;
  end;
end;

procedure TMainForm.MoveJobUpActionExecute(Sender: TObject);
var
  NewIndex: Integer;
begin
  with JobList do
  begin
    NewIndex := ItemIndex - 1;
    FTaskList.Move(ItemIndex, ItemIndex - 1);
    ItemIndex := NewIndex;
  end;
end;

procedure TMainForm.MoveJobUpActionUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := JobList.ItemIndex > 0;
end;

procedure TMainForm.MoveJobDownActionExecute(Sender: TObject);
var
  NewIndex: Integer;
begin
  with JobList do
  begin
    NewIndex := ItemIndex + 1;
    FTaskList.Move(ItemIndex, ItemIndex + 1);
    ItemIndex := NewIndex;
  end;
end;

procedure TMainForm.MoveJobDownActionUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := (JobList.ItemIndex >= 0) and (JobList.ItemIndex < JobList.Count - 1);
end;

procedure TMainForm.SetOutputActionUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := JobList.ItemIndex >= 0;
end;

procedure TMainForm.ConfigureActionUpdate(Sender: TObject);
begin
  with MetricFilterList do
    (Sender as TAction).Enabled := (ItemIndex >= 0) and
      (FTaskList[JobList.ItemIndex][ItemIndex].GetConfiguration <> pcNone) and
      (FTaskList[JobList.ItemIndex][ItemIndex].Selected);
end;

procedure TMainForm.ConfigureActionExecute(Sender: TObject);
begin
  if FTaskList[JobList.ItemIndex][MetricFilterList.ItemIndex].Selected then
    FTaskList[JobList.ItemIndex].Configure(MetricFilterList.ItemIndex);
end;

procedure TMainForm.StartActionUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := JobList.Count > 0;
end;

procedure TMainForm.StartActionExecute(Sender: TObject);
begin
  try
    FTaskList.CollectMetrics;
    if FTaskList.RunningThreads > 0 then
      Hide;
  except
    UpdateSelectedJob;
    raise;
  end;
end;

procedure TMainForm.JobListDataObject(Control: TWinControl; Index: Integer;
  var DataObject: TObject);
begin
  DataObject := FTaskList[Index];
end;

procedure TMainForm.SetAvisynthPluginDirectory1Click(Sender: TObject);
begin
  SetAvisynthPluginDirectory;
end;

procedure TMainForm.Mpeg2DecRadioGroupClick(Sender: TObject);
begin
  FTaskList.Mpeg2Decoder := TMpeg2Decoder(Mpeg2DecRadioGroup.ItemIndex);
end;

procedure TMainForm.SetAvisynthPluginDirectory;
var
  NewPluginPath: string;
begin
  SelectDirectory('Plugin Path', '', NewPluginPath);

  if (NewPluginPath <> '') then
  begin
    if (not AnsiEndsStr('\', NewPluginPath)) then
      NewPluginPath := NewPluginPath + '\';
    FTaskList.PluginPath := NewPluginPath;
  end;
end;

procedure TMainForm.MarkAsReadyActionExecute(Sender: TObject);
begin
  FTaskList[JobList.ItemIndex].ResetStatus;
  UpdateSelectedJob;
end;

procedure TMainForm.MarkAsReadyActionUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := JobList.ItemIndex >= 0;
end;

procedure TMainForm.SetDefaultPriorityClick(Sender: TObject);
begin
  with FTaskList do
    case (Sender as TMenuItem).Tag of
      0: DefaultPriority := tpIdle;
      1: DefaultPriority := tpLowest;
      2: DefaultPriority := tpLower;
      3: DefaultPriority := tpNormal;
      4: DefaultPriority := tpHigher;
    end;
end;

procedure TMainForm.MoveFilterUpActionExecute(Sender: TObject);
var
  NewIndex: Integer;
begin
  with MetricFilterList do
  begin
    NewIndex := ItemIndex - 1;
    FTaskList[JobList.ItemIndex].Move(ItemIndex, ItemIndex - 1);
    Items.Move(ItemIndex, ItemIndex - 1);
    ItemIndex := NewIndex;
  end;
end;

procedure TMainForm.MoveFilterUpActionUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := (JobList.ItemIndex >= 0) and (MetricFilterList.ItemIndex > 0);
end;

procedure TMainForm.MoveFilterDownActionExecute(Sender: TObject);
var
  NewIndex: Integer;
begin
  with MetricFilterList do
  begin
    NewIndex := ItemIndex + 1;
    FTaskList[JobList.ItemIndex].Move(ItemIndex, ItemIndex + 1);
    Items.Move(ItemIndex, ItemIndex + 1);
    ItemIndex := NewIndex;
  end;
end;

procedure TMainForm.MoveFilterDownActionUpdate(Sender: TObject);
begin
  with MetricFilterList do
    (Sender as TAction).Enabled := (JobList.ItemIndex >= 0) and (ItemIndex >= 0) and (ItemIndex < Count - 1);
end;

procedure TMainForm.Hide;
begin
  ShowWindow(Application.Handle, SW_HIDE);
  inherited;
end;

procedure TMainForm.Show;
begin
  inherited;
  ShowWindow(Application.Handle, SW_SHOW);
end;

procedure TMainForm.ClearAllErrors1Click(Sender: TObject);
var
  Counter: Integer;
begin
  for Counter := 0 to FTaskList.Count - 1 do
    FTaskList[Counter].ResetStatus;
  UpdateSelectedJob;
end;

procedure TMainForm.SetMaxRunningJobs1Click(Sender: TObject);
begin
  try
    FTaskList.MaxThreads := StrToInt(InputBox('Max Running Jobs', 'Number:', IntToStr(FTaskList.MaxThreads)));
  except
  end;
end;

procedure TMainForm.MetricFilterListDblClick(Sender: TObject);
begin
  if FTaskList[JobList.ItemIndex][MetricFilterList.ItemIndex].Selected then
    ConfigureAction.Execute
  else
  begin
    FTaskList[JobList.ItemIndex][MetricFilterList.ItemIndex].Selected := True;
    MetricFilterList.Checked[MetricFilterList.ItemIndex] := True;
  end;
end;

end.

