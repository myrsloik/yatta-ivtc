unit progress;

interface

uses
  Windows, SysUtils, Classes, Forms,
  Dialogs, StdCtrls, Controls, ComCtrls, Menus, Contnrs, FrameGet,
  ConvUtils, StdConvs;

type
  TProgressForm = class;

  TProgressListing = class(TObject)
  private
    FParentForm: TProgressForm;
    FTaskId: Integer;
    FFrameCount: Integer;
    FProjectType: string;
    FInputFile: string;
    FOutputFile: string;
    FBox: TGroupBox;
    FBar: TProgressBar;
  public
    property TaskId: Integer read FTaskId;
    property FrameCount: Integer read FFrameCount;
    property ProjectType: string read FProjectType;
    property InputFile: string read FInputFile;
    property OutputFile: string read FOutputFile;

    procedure Update(var Msg: TYMCProgressUpdate);
    constructor Create(Id: Integer; ProjectType, InputFile: string; OutputFile: string; FrameCount: Integer; ParentForm: TProgressForm);
    destructor Destroy; override;
  end;

  TProgressList = class(TObjectList)
  private
    function GetItem(Index: Integer): TProgressListing;
  public
    property Items[Index: Integer]: TProgressListing read GetItem; default;
  end;

  TProgressForm = class(TForm)
    PopupMenu: TPopupMenu;
    Idle1: TMenuItem;
    Higher1: TMenuItem;
    Normal1: TMenuItem;
    Lower1: TMenuItem;
    Lowest1: TMenuItem;
    Priority1: TMenuItem;
    Closewhendone1: TMenuItem;
    LaunchYatta1: TMenuItem;
    GroupBox2: TGroupBox;
    CancelButton: TButton;
    N1: TMenuItem;
    Cancel1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CancelButtonClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SetJobPriorityClick(Sender: TObject);
    procedure PopupMenuPopup(Sender: TObject);
    procedure JobContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure Cancel1Click(Sender: TObject);
    procedure Closewhendone1Click(Sender: TObject);
    procedure LaunchYatta1Click(Sender: TObject);
  private
    FProgressList: TProgressList;
  public
    procedure CreateParams(var Params: TCreateParams); override;

    procedure CreateProgress(Id: Integer; ProjectType, InputFile: string; OutputFile: string; FrameCount: Integer);
    procedure UpdateProgress(Id: Integer; var Msg: TYMCProgressUpdate);
    procedure DestroyProgress(Id: Integer);
  end;

var
  ProgressForm: TProgressForm;

implementation

uses Main, YMCTask;

{$R *.dfm}

procedure TProgressForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent := HWND_DESKTOP; // More elegant than 0
end;

procedure TProgressForm.FormCreate(Sender: TObject);
begin
  FProgressList := TProgressList.Create;
end;

procedure TProgressForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caNone;
  CancelButtonClick(Sender);
end;

procedure TProgressForm.UpdateProgress(Id: Integer; var Msg: TYMCProgressUpdate);
var
  Counter: Integer;
begin
  for Counter := 0 to FProgressList.Count - 1 do
    if FProgressList[Counter].TaskId = Id then
    begin
      FProgressList[Counter].Update(Msg);
      Break;
    end;
end;

procedure TProgressForm.CreateProgress(Id: Integer; ProjectType: string; InputFile: string; OutputFile: string; FrameCount: Integer);
var
  Counter: Integer;
begin
  for Counter := 0 to FProgressList.Count - 1 do
    if FProgressList[Counter].TaskId = Id then
      raise Exception.CreateFmt('Duplicate progress id (%d)', [Id]);

  FProgressList.Add(TProgressListing.Create(Id, ProjectType, InputFile, OutputFile, FrameCount, Self));

  if FProgressList.Count = 1 then
    Show;
end;

procedure TProgressForm.DestroyProgress(Id: Integer);
var
  Counter: Integer;
begin
  for Counter := 0 to FProgressList.Count - 1 do
    if FProgressList[Counter].TaskId = Id then
    begin
      FProgressList.Delete(Counter);
      if FProgressList.Count = 0 then
        Hide;

      Exit;
    end;

  raise Exception.CreateFmt('No matching progress id (%d)', [Id]);
end;

procedure TProgressForm.CancelButtonClick(Sender: TObject);
begin
  if MessageDlg('Do you really want to cancel all jobs in progress?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    MainForm.TaskList.CancelCollection;
end;

procedure TProgressForm.FormDestroy(Sender: TObject);
begin
  FProgressList.Free;
end;

procedure TProgressForm.PopupMenuPopup(Sender: TObject);
begin
  with MainForm do
  begin
    LaunchYatta1.Checked := LaunchWhenDone.Checked;
    Closewhendone1.Checked := CloseWhenDone.Checked;
  end;

  case MainForm.TaskList.TaskId[PopupMenu.Tag].Priority of
    tpIdle: Idle1.Checked := True;
    tpLowest: Lowest1.Checked := True;
    tpLower: Lower1.Checked := True;
    tpNormal: Normal1.Checked := True;
    tpHigher: Higher1.Checked := True;
  end;
end;

procedure TProgressForm.JobContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
begin
  PopupMenu.Tag := (Sender as TGroupBox).Tag;
end;

{ TProgressListing }

constructor TProgressListing.Create(Id: Integer; ProjectType, InputFile,
  OutputFile: string; FrameCount: Integer; ParentForm: TProgressForm);
begin
  inherited Create();

  FParentForm := ParentForm;
  FTaskId := Id;
  FProjectType := ProjectType;
  FInputFile := InputFile;
  FOutputFile := OutputFile;
  FFrameCount := FrameCount;

  FBox := TGroupBox.Create(ParentForm);
  FBar := TProgressBar.Create(FBox);

  with FBox do
  begin
    Caption := Format('Task #%d: %s', [Id, OutputFile]);
    Parent := ParentForm;
    Height := 49;
    Width := 414;
    Tag := Id;
    PopupMenu := ParentForm.PopupMenu;
    Hint := 'Initializing';
    ShowHint := True;
    ParentBackground := False;
    OnContextPopup := ParentForm.JobContextPopup;
  end;

  with FBar do
  begin
    Parent := FBox;
    Height := 25;
    Width := 398;
    Left := 8;
    Top := 15;
    Tag := Id;
    Max := FrameCount - 1;
    Smooth := True;
    Anchors := [akLeft, akTop, akRight, akBottom];
  end;

  FBox.ScaleBy(Screen.PixelsPerInch, 96);

  FBox.Align := alTop;
  FParentForm.ClientHeight := FParentForm.ClientHeight + FBox.Height;
end;

destructor TProgressListing.Destroy;
begin
  FParentForm.ClientHeight := FParentForm.ClientHeight - FBox.Height;
  FBar.Free;
  FBox.Free;

  inherited;
end;

procedure TProgressListing.Update(var Msg: TYMCProgressUpdate);
begin
  with Msg do
  begin
    FBox.Hint := Format('Task #%d'#13#10'Type: %s'#13#10'Frame: %d/%d'#13#10'Elapsed: %s'#13#10'Remaining: %s'#13#10'Input: %s'#13#10'Output: %s',
      [TaskId, ProjectType, CurrentFrame, FrameCount, TimeToStr(ConvertFrom(tuMilliSeconds, Msg.ElapsedTime)), TimeToStr(ConvertFrom(tuMilliSeconds, Msg.RemainingTime)), InputFile, OutputFile]);
    FBar.Position := CurrentFrame;
  end;
end;

{ TProgressList }

function TProgressList.GetItem(Index: Integer): TProgressListing;
begin
  Result := inherited Items[Index] as TProgressListing;
end;

procedure TProgressForm.SetJobPriorityClick(Sender: TObject);
var
  Task: TYMCTask;
begin
  Task := MainForm.TaskList.TaskId[PopupMenu.Tag];
  if Task <> nil then
    case (Sender as TMenuItem).Tag of
      0: Task.Priority := tpIdle;
      1: Task.Priority := tpLowest;
      2: Task.Priority := tpLower;
      3: Task.Priority := tpNormal;
      4: Task.Priority := tpHigher;
    end;
end;

procedure TProgressForm.Cancel1Click(Sender: TObject);
var
  Task: TYMCTask;
begin
  if MessageDlg('Do you really want to cancel this job?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    Task := MainForm.TaskList.TaskId[PopupMenu.Tag];
    if Task <> nil then
      Task.CancelCollection;
  end;
end;

procedure TProgressForm.Closewhendone1Click(Sender: TObject);
begin
  MainForm.CloseWhenDone.Checked := (Sender as TMenuItem).Checked;
end;

procedure TProgressForm.LaunchYatta1Click(Sender: TObject);
begin
  MainForm.LaunchWhenDone.Checked := (Sender as TMenuItem).Checked;
end;

end.
