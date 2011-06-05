unit YMCTask;

interface

uses
  SysUtils, Forms, Types, Windows, Classes, Contnrs, YMCPlugin, YMCInternalPlugins,
  Asif, AsifAdditions, FrameGet, Progress, IniFiles, StrUtils, FunctionHooking;

type
  EYMCTaskException = class(EYMCException);

  TTaskStatus = (tsReady = 0, tsRunning = 1, tsFailed = 2);

  TYMCTaskList = class;

  TYMCTask = class(TObjectList)
  private
    FStatus: TTaskStatus;
    FInputFile: string;
    FOutputFile: string;
    FScriptEnvironment: IAsifScriptEnvironment;
    FOwner: TYMCTaskList;
    FWorkerThread: TFrameGetThread;
    FTaskId: Integer;
    function GetItem(Index: Integer): TYMCPlugin;
    function OpenVideo(Filename: string): IAsifClip;
    procedure ProcessMetrics;
    procedure UpdateProgress(var Msg: TYMCProgressUpdate); message WMYMCProgressUpdate;
    procedure WorkerThreadDone(Sender: TObject);
    procedure SetInputFile(Filename: string);
    function PromoteVideo(Video: IAsifClip; Target: TColorSpaces): IAsifClip;
    procedure SetPriority(Priority: TThreadPriority);
    function GetPriority: TThreadPriority;
    function GetMTSafe: Boolean;
    function GetProjectType: string;
  public
    constructor Create(AFilterOrder: string; AInputFile: string; AOutputFile: string; Filters: TYMCPluginClassDynArray; Settings: string; Owner: TYMCTaskList);
    destructor Destroy; override;

    function GetSettings: string;
    procedure Configure(Index: Integer);
    procedure CollectMetrics;
    procedure CancelCollection;
    procedure ResetStatus;

    property MTSafe: Boolean read GetMTSafe;
    property TaskId: Integer read FTaskId;
    property Items[Index: Integer]: TYMCPlugin read GetItem; default;
    property InputFile: string read FInputFile write SetInputFile;
    property OutputFile: string read FOutputFile write FOutputFile;
    property Status: TTaskStatus read FStatus;
    property Priority: TThreadPriority read GetPriority write SetPriority;
    property ProjectType: string read GetProjectType;
  end;

  TYMCTaskList = class(TObjectList)
  private
    FProgressForm: TProgressForm;
    FPluginPath: string;
    FMaxThreads: Integer;
    FSavedBy: string;
    FMpeg2Decoder: TMpeg2Decoder;
    FIni: TCustomIniFile;
    FCancelled: Boolean;
    FDefaultPriority: TThreadPriority;

    function GetItem(Index: Integer): TYMCTask;
    function GetRunningThreads: Integer;
    procedure SetMaxThreads(Threads: Integer);
    function GetMpeg2DecoderString: string;
    procedure TaskDone(Task: TYMCTask; Success: Boolean);
    function GetTaskById(TaskId: Integer): TYMCTask;
  public
    constructor Create(PluginPath: string; Mpeg2Decoder: TMpeg2Decoder; Ini: TCustomIniFile);
    destructor Destroy; override;

    function AddTask(InputFile: string; OutputFile: string; Settings: string = ''): Integer;
    function LoadTasks(Filename: string; out Errors: string): Integer;
    procedure SaveTasks(Filename: string);
    procedure CollectMetrics;
    procedure CancelCollection;

    property TaskId[Index: Integer]: TYMCTask read GetTaskById;
    property Ini: TCustomIniFile read FIni;
    property Mpeg2Decoder: TMpeg2Decoder read FMpeg2Decoder write FMpeg2Decoder;
    property Mpeg2DecoderString: string read GetMpeg2DecoderString;
    property SavedBy: string read FSavedBy write FSavedBy;
    property Items[Index: Integer]: TYMCTask read GetItem; default;
    property RunningThreads: Integer read GetRunningThreads;
    property MaxThreads: Integer read FMaxThreads write SetMaxThreads;
    property PluginPath: string read FPluginPath write FPluginPath;
    property ProgressForm: TProgressForm read FProgressForm;
    property Cancelled: Boolean read FCancelled;
    property DefaultPriority: TThreadPriority read FDefaultPriority write FDefaultPriority;
  end;

procedure AddPlugin(Plugin: TYMCPluginClass);

function TaskStatusToText(Status: TTaskStatus): string;
function Mpeg2DecoderToString(Decoder: TMpeg2Decoder): string;

implementation

uses Main;

var
  LoadedPlugins: TYMCPluginClassDynArray;
  GlobalTaskId: Integer = 0;
  DebugStrings: TStringList;

procedure AddPlugin(Plugin: TYMCPluginClass);
begin
  SetLength(LoadedPlugins, Length(LoadedPlugins) + 1);
  LoadedPlugins[Length(LoadedPlugins) - 1] := Plugin;
end;

function Mpeg2DecoderToString(Decoder: TMpeg2Decoder): string;
begin
  case Decoder of
    mdMpeg2Dec3: Result := 'Mpeg2Dec3';
    mdDGDecode: Result := 'DGDecode';
  end;
end;

function TaskStatusToText(Status: TTaskStatus): string;
begin
  case Status of
    tsReady: Result := 'Ready';
    tsRunning: Result := 'Running';
    tsFailed: Result := 'Failed';
  end;
end;

procedure ExecNewProcess(ProgramName: string; Arguments: string; Wait: Boolean = False);
var
  StartInfo: TStartupInfo;
  ProcInfo: TProcessInformation;
  CreateOK: Boolean;
begin
  FillChar(StartInfo, SizeOf(TStartupInfo), #0);
  FillChar(ProcInfo, SizeOf(TProcessInformation), #0);
  StartInfo.cb := SizeOf(TStartupInfo);
  CreateOK := CreateProcess(PChar(ProgramName), PChar(Arguments), nil, nil, False,
    CREATE_NEW_PROCESS_GROUP + NORMAL_PRIORITY_CLASS,
    nil, nil, StartInfo, ProcInfo);
  if CreateOK then
  begin
    if Wait then
      WaitForSingleObject(ProcInfo.hProcess, INFINITE);
  end
  else
    raise EYMCException.Create('Couldn''t start ' + ProgramName);

  CloseHandle(ProcInfo.hProcess);
  CloseHandle(ProcInfo.hThread);
end;

{ TYMCTask }

constructor TYMCTask.Create(AFilterOrder: string; AInputFile: string;
  AOutputFile: string; Filters: TYMCPluginClassDynArray; Settings: string;
  Owner: TYMCTaskList);
var
  Counter, FCounter: Integer;
  UsedFunctions: TStringDynArray;
  SL: TStringList;
  Selected: Boolean;
  FilterName: string;
  SavedSettings: string;
begin
  inherited Create(True);

  Inc(GlobalTaskId);
  FTaskId := GlobalTaskId;

  InputFile := AInputFile;
  FStatus := tsReady;
  FOwner := Owner;
  FWorkerThread := nil;
  FOutputFile := AOutputFile;
  FScriptEnvironment := TAsifScriptEnvironment.Create;
  SL := TStringList.Create;
  SL.Text := Settings;

  try

    for Counter := 0 to Length(Filters) - 1 do
    begin
      try
        UsedFunctions := Filters[Counter].GetUsedFunctions;

        //load all required plugins
        for FCounter := 0 to Length(UsedFunctions) - 1 do
          LoadPlugins(UsedFunctions[FCounter], Owner.PluginPath, FScriptEnvironment);

        FilterName := Filters[Counter].GetName;

        Selected := SL.IndexOfName(FilterName) >= 0;
        SavedSettings := SL.Values[FilterName];

        if SavedSettings = '' then
          SavedSettings := FOwner.Ini.ReadString('DEFAULTS', FilterName, '');
        Add(Filters[Counter].Create(SavedSettings, Selected));

      except on E: EAsifException do
          Continue;
      end;
    end;

    //rearrange to the right order
    SL.CommaText := AFilterOrder;

    for Counter := 0 to SL.Count - 1 do
      for FCounter := 0 to Count - 1 do
        if Items[FCounter].GetName = SL[Counter] then
        begin
          Exchange(Counter, FCounter);
          Break;
        end;

  finally
    SL.Free;
  end;
end;

function TYMCTask.GetItem(Index: Integer): TYMCPlugin;
begin
  Result := inherited Items[Index] as TYMCPlugin;
end;

function TYMCTask.GetSettings: string;
var
  Counter: Integer;
  FilterOrder: string;
begin
  if Count > 0 then
  begin
    FilterOrder := Items[0].GetName;
    for Counter := 1 to Count - 1 do
      FilterOrder := FilterOrder + ',' + Items[Counter].GetName;
  end;

  Result := 'SourceFile=' + FInputFile + #13#10;
  Result := Result + 'DestinationFile=' + FOutputFile + #13#10;
  Result := Result + 'FilterOrder=' + FilterOrder + #13#10;

  for Counter := 0 to Count - 1 do
    with Items[Counter] do
      if Selected then
        Result := Result + GetName + '=' + Settings + #13#10;
end;

function TYMCTask.PromoteVideo(Video: IAsifClip; Target: TColorSpaces): IAsifClip;
var
  CurrentColorSpace: TColorSpace;
  VI: VideoInfo;
begin
  VI := Video.GetVideoInfo;

  CurrentColorSpace := csNone;

  if avs_is_yv12(VI) then
    CurrentColorSpace := csYV12
  else if avs_is_yuy2(VI) then
    CurrentColorSpace := csYUY2
  else if avs_is_rgb32(VI) then
    CurrentColorSpace := csRGB32
  else if avs_is_rgb24(VI) then
    CurrentColorSpace := csRGB24;

  Assert(CurrentColorSpace <> csNone);

  if CurrentColorSpace in Target then
    Result := Video
  else
  begin
    if (CurrentColorSpace = csYV12) and (csYUY2 in Target) then
    begin
      FScriptEnvironment.ClipArg(Video);
      FScriptEnvironment.BoolArg(True, 'interlaced');
      Result := FScriptEnvironment.InvokeWithClipResult('ConvertToYUY2');
    end
    else
      raise EYMCTaskException.Create('Target filter doesn''t support the current colorspace and no suitable promotion possible.');
  end;
end;

procedure TYMCTask.CollectMetrics;
var
  Video: IAsifClip;
  Counter: Integer;
  HasMetricsCollection: Boolean;
begin
  try
    HasMetricsCollection := False;
    for Counter := 0 to Count - 1 do
      HasMetricsCollection := HasMetricsCollection or ((Items[Counter].GetPluginType = ypMetricsCollector) and Items[Counter].Selected);

    if not HasMetricsCollection then
      raise EYMCTaskException.Create('No metric collection filter selected');

    Video := OpenVideo(InputFile);

    for Counter := 0 to Count - 1 do
      if Items[Counter].Selected then
      begin
        Video := PromoteVideo(Video, Items[Counter].GetSupportedColorSpaces);
        FScriptEnvironment.ClipArg(Video);
        Video := FScriptEnvironment.InvokeWithClipResult('Cache');
        Video := Items[Counter].Invoke(FScriptEnvironment, Video, False);
      end;

    if not MTSafe then
      DebugStrings.Clear;
    FOwner.ProgressForm.CreateProgress(TaskId, ProjectType, FInputFile, FOutputFile, Video.GetVideoInfo.NumFrames);
    FWorkerThread := TFrameGetThread.Create(Video, Self, FOwner.DefaultPriority, WorkerThreadDone);
  except
    FStatus := tsFailed;
    raise;
  end;

  FStatus := tsRunning;
end;

procedure TYMCTask.Configure(Index: Integer);
var
  Video: IAsifClip;
  Counter: Integer;
  Config: TYMCPluginConfig;
  NewDefault: string;
begin
  Config := Items[Index].GetConfiguration;

  if (not Items[Index].Selected) or (Config = pcNone) then
    raise EYMCTaskException.Create('No configuration possible');

  if Config = pcVideo then
  begin
    Video := OpenVideo(InputFile);

    for Counter := 0 to Index - 1 do
      if Items[Counter].Selected then
      begin
        Video := PromoteVideo(Video, Items[Counter].GetSupportedColorSpaces);
        FScriptEnvironment.ClipArg(Video);
        Video := FScriptEnvironment.InvokeWithClipResult('Cache');
        Video := Items[Counter].Invoke(FScriptEnvironment, Video, True);
      end;
  end;

  if Config in [pcVideo, pcNormal] then
  begin
    Items[Index].Configure(FScriptEnvironment, Video, NewDefault);

    if NewDefault <> '' then
      FOwner.Ini.WriteString('DEFAULTS', Items[Index].GetName, NewDefault);
  end;
end;

function TYMCTask.OpenVideo(Filename: string): IAsifClip;
var
  FileExt: string;
begin
  if not FileExists(Filename) then
    raise EYMCTaskException.Create('Video file not found.');

  FileExt := AnsiLowerCase(ExtractFileExt(Filename));

  if FileExt = '.d2v' then
  begin
    LoadPlugins(FOwner.Mpeg2DecoderString + '_Mpeg2Source', FOwner.PluginPath, FScriptEnvironment);
    FScriptEnvironment.CharArg(PChar(Filename));
    Result := FScriptEnvironment.InvokeWithClipResult(PChar(FOwner.Mpeg2DecoderString + '_Mpeg2Source'));

    if (FOwner.Mpeg2Decoder <> mdDGDecode) and FScriptEnvironment.FunctionExists('SetPlanarLegacyAlignment') then
    begin
      FScriptEnvironment.ClipArg(Result);
      FScriptEnvironment.BoolArg(True);
      Result := FScriptEnvironment.InvokeWithClipResult('SetPlanarLegacyAlignment');
    end;
  end
  else if FileExt = '.dga' then
  begin
    LoadPlugins('AVCSource', FOwner.PluginPath, FScriptEnvironment);
    FScriptEnvironment.CharArg(PChar(Filename));
    Result := FScriptEnvironment.InvokeWithClipResult('AVCSource');
  end
  else if FileExt = '.avs' then
  begin
    FScriptEnvironment.CharArg(PChar(Filename));
    Result := FScriptEnvironment.InvokeWithClipResult('Import');
  end
  else if FileExt = '.avi' then
  begin
    FScriptEnvironment.CharArg(PChar(Filename));
    Result := FScriptEnvironment.InvokeWithClipResult('AviSource');
  end
  else
  begin
    LoadPlugins('FFVideoSource', FOwner.PluginPath, FScriptEnvironment);
    FScriptEnvironment.CharArg(PChar(Filename));
    Result := FScriptEnvironment.InvokeWithClipResult('FFVideoSource');
  end;
end;

procedure TYMCTask.ProcessMetrics;
var
  Counter: Integer;
  Header: TYMCProjectHeader;
  MetricsFile: TStringList;
begin
  with Header do
  begin
    Order := 0;
    Decoder := FOwner.Mpeg2Decoder;
    ProjectType := 0;
    PostProcessor := ppDecombBlend;
    FrameCount := 0;
    CutList := '';
  end;

  MetricsFile := TStringList.Create;

  try
    for Counter := 0 to Count - 1 do
      if Items[Counter].Selected then
        Items[Counter].ProcessLog(DebugStrings, MetricsFile, Header);

    MetricsFile.Insert(0, '');
    if Header.CutList <> '' then
      MetricsFile.Insert(0, 'CUTLIST=' + Header.CutList);
    if Header.Framecount > 0 then
      MetricsFile.Insert(0, 'FRAMECOUNT=' + IntToStr(Header.Framecount));
    MetricsFile.Insert(0, 'MPEG2DECODER=' + Mpeg2DecoderToString(Header.Decoder));
    MetricsFile.Insert(0, 'ORDER=' + IntToStr(Header.Order));
    MetricsFile.Insert(0, 'TYPE=' + IntToStr(Header.ProjectType));
    MetricsFile.Insert(0, 'LASTVIDEOPATH=' + FInputFile);
    MetricsFile.Insert(0, 'SAVEDBY=' + FOwner.SavedBy);
    MetricsFile.Insert(0, '[YATTA V2]');

    MetricsFile.SaveToFile(OutputFile);
  finally
    MetricsFile.Free;
  end;
end;

destructor TYMCTask.Destroy;
begin
  CancelCollection;
  inherited;
end;

procedure TYMCTask.UpdateProgress(var Msg: TYMCProgressUpdate);
begin
  FOwner.ProgressForm.UpdateProgress(TaskId, Msg);
end;

procedure TYMCTask.CancelCollection;
begin
  if FWorkerThread <> nil then
    FWorkerThread.Terminate;
end;

procedure TYMCTask.WorkerThreadDone(Sender: TObject);
begin
  with Sender as TFrameGetThread do
  begin
    FWorkerThread := nil;
    if not FOwner.Cancelled then
      FScriptEnvironment := nil;

    try
      if not Cancelled then
        ProcessMetrics
      else
        FStatus := tsFailed;
    except
      FStatus := tsFailed;
    end;

    if not MTSafe then
      DebugStrings.Clear;

    FOwner.ProgressForm.DestroyProgress(TaskId);
    FOwner.TaskDone(Self, FStatus <> tsFailed);
  end;
end;

procedure TYMCTask.ResetStatus;
begin
  if FStatus = tsRunning then
    raise EYMCTaskException.Create('Task is already running');
  FStatus := tsReady;
end;

procedure TYMCTask.SetInputFile(Filename: string);
begin
  if not FileExists(Filename) then
    raise EYMCTaskException.Create('The file "' + Filename + '" doesn''t exist.');
  FInputFile := Filename;
end;

procedure TYMCTask.SetPriority(Priority: TThreadPriority);
begin
  if FWorkerThread <> nil then
    FWorkerThread.Priority := Priority;
end;

function TYMCTask.GetPriority: TThreadPriority;
begin
  Result := tpIdle;
  if FWorkerThread <> nil then
    Result := FWorkerThread.Priority;
end;

function TYMCTask.GetMTSafe: Boolean;
var
  Counter: Integer;
begin
  Result := True;

  for Counter := 0 to Count - 1 do
    with Items[Counter] do
      Result := Result and (MTSafe or not Selected);
end;

function TYMCTask.GetProjectType: string;
var
  Counter: Integer;
begin
  Result := '';

  for Counter := 0 to Count - 1 do
    if Items[Counter].Selected then
      Result := Result + ', ' + Items[Counter].GetName;

  Result := RightStr(Result, Length(Result) - 2);

  if Result = '' then
    Result := '<none>';
end;

{ TYMCTaskList }

function TYMCTaskList.AddTask(InputFile, OutputFile: string; Settings: string): Integer;
begin
  Result := Add(TYMCTask.Create('', InputFile, OutputFile, LoadedPlugins, Settings, Self));
end;

procedure TYMCTaskList.CancelCollection;
var
  Counter: Integer;
begin
  FCancelled := True;

  for Counter := 0 to Count - 1 do
    Items[Counter].CancelCollection;
end;

procedure TYMCTaskList.CollectMetrics;
  function MTSafeRunning: Boolean;
  var
    Counter: Integer;
  begin
    Result := True;

    for Counter := 0 to Count - 1 do
      with Items[Counter] do
        if (Status = tsRunning) then
          Result := Result and MTSafe;
  end;
var
  Counter: Integer;
begin
  for Counter := 0 to Count - 1 do
    with Items[Counter] do
    begin
      if (RunningThreads >= MaxThreads) then
        Break;

      if (Status = tsReady) and (MTSafe or MTSafeRunning) then
        CollectMetrics;
    end;
end;

constructor TYMCTaskList.Create(PluginPath: string; Mpeg2Decoder: TMpeg2Decoder; Ini: TCustomIniFile);
begin
  inherited Create(True);

  FDefaultPriority := tpIdle;
  SavedBy := 'TYMCTaskList';
  FCancelled := False;
  FIni := Ini;
  FMpeg2Decoder := Mpeg2Decoder;
  FPluginPath := PluginPath;
  FMaxThreads := 1;
  FProgressForm := TProgressForm.Create(nil);
end;

destructor TYMCTaskList.Destroy;
begin
  FProgressForm.Free;
  inherited;
end;

function TYMCTaskList.GetItem(Index: Integer): TYMCTask;
begin
  Result := inherited Items[Index] as TYMCTask;
end;

function TYMCTaskList.GetMpeg2DecoderString: string;
begin
  Result := Mpeg2DecoderToString(Mpeg2Decoder);
end;

function TYMCTaskList.GetRunningThreads: Integer;
var
  Counter: Integer;
begin
  Result := 0;

  for Counter := 0 to Count - 1 do
    if Items[Counter].Status = tsRunning then
      Inc(Result);
end;

function TYMCTaskList.GetTaskById(TaskId: Integer): TYMCTask;
var
  Counter: Integer;
begin
  Result := nil;

  for Counter := 0 to Count - 1 do
    if Items[Counter].TaskId = TaskId then
    begin
      Result := Items[Counter];
      Break;
    end;
end;

function TYMCTaskList.LoadTasks(Filename: string; out Errors: string): Integer;
var
  TaskIni: TMemIniFile;
  SL: TStringList;
  Counter: Integer;
  SettingsCounter: Integer;
  Settings: string;
  SectionName: string;
begin
  Result := 0;
  Errors := '';
  TaskIni := TMemIniFile.Create(Filename);
  SL := TStringList.Create;

  if TaskIni.ReadInteger('MAIN', 'Version', INIVersion) = INIVersion then
  begin
    Result := TaskIni.ReadInteger('MAIN', 'ProjectCount', 0);

    for Counter := 0 to Result - 1 do
    begin
      try
        Settings := '';
        SectionName := 'Project' + IntToStr(Counter);
        TaskIni.ReadSection(SectionName, SL);

        for SettingsCounter := 3 to SL.Count - 1 do
          Settings := Settings + SL[SettingsCounter] + '=' + TaskIni.ReadString(SectionName, SL[SettingsCounter], '') + #13#10;

        Add(TYMCTask.Create(
          TaskIni.ReadString(SectionName, 'FilterOrder', ''),
          TaskIni.ReadString(SectionName, 'SourceFile', ''),
          TaskIni.ReadString(SectionName, 'DestinationFile', ''),
          LoadedPlugins,
          Settings,
          Self));

      except on E: EYMCTaskException do
        begin
          Dec(Result);
          Errors := Errors + E.Message + ' Failed to load task.' + #13#10;
        end;
      end;
    end;
  end;

  SL.Free;
  TaskIni.Free;
end;

procedure TYMCTaskList.SaveTasks(Filename: string);
var
  SL: TStringList;
  Counter: Integer;
begin
  SL := TStringList.Create;

  SL.Append('[MAIN]');
  SL.Append('Version=' + IntToStr(INIVersion));
  SL.Append('ProjectCount=' + IntToStr(Count));
  SL.Append('');

  for Counter := 0 to Count - 1 do
  begin
    SL.Append('[Project' + IntToStr(Counter) + ']');
    SL.Append(Items[Counter].GetSettings);
    SL.Append('');
  end;

  try
    SL.SaveToFile(Filename);
  finally
    SL.Free;
  end;
end;

procedure TYMCTaskList.SetMaxThreads(Threads: Integer);
begin
  if Threads < 1 then
    raise EYMCTaskException.Create('At least one worker thread must be allowed');
  FMaxThreads := Threads;
end;

procedure TYMCTaskList.TaskDone(Task: TYMCTask; Success: Boolean);
var
  ProjectFilename: string;
begin
  //fixme, knows too much?

  ProjectFilename := Task.OutputFile;

  if not Cancelled then
  begin
    if Success then
    begin
      Delete(IndexOf(Task));
      MainForm.JobList.Count := MainForm.JobList.Count - 1;
    end;

    //start new tasks if available
    CollectMetrics;
  end;

  //no running tasks left
  if RunningThreads = 0 then
  begin
    if not Cancelled and MainForm.LaunchWhenDone.Checked and Success then
      ExecNewProcess(ExtractFilePath(Application.ExeName) + 'yatta.exe', '"' + ExtractFilePath(Application.ExeName) + 'yatta.exe" "' + ProjectFilename + '"');

    if not Cancelled and MainForm.CloseWhenDone.Checked and Success then
    begin
      MainForm.Close;
    end
    else
    begin
      MainForm.UpdateSelectedJob;
      MainForm.Show;                                                                            
    end;

    FCancelled := False;
  end;
end;

initialization
  DebugStrings := TStringList.Create;
  HookDbgOut(DebugStrings);
finalization
  SetDbgOutput(nil);
  DebugStrings.Free
end.

