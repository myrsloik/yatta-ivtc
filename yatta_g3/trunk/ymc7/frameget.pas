unit FrameGet;

interface

uses
  Windows, Messages, SysUtils, Classes, Asif, YMCPlugin;

const
  WMYMCProgressUpdate = WM_USER + 10;

type
  TYMCProgressUpdate = record
    MessageId: Word;
    CurrentFrame: Integer;
    ElapsedTime: Cardinal;
    RemainingTime: Cardinal;
  end;

  TFrameGetThread = class(TThread)
  private
    FOwner: TObject;
    FVideo: IAsifClip;
    FStartTime: Cardinal;
    FCancelled: Boolean;
  protected
    procedure Execute; override;
  public
    constructor Create(Video: IAsifClip; Owner: TObject; StartPriority: TThreadPriority; AOnTerminate: TNotifyEvent);
    procedure Terminate;

    property Cancelled: Boolean read FCancelled;
  end;

implementation

uses
  Progress;

const
  StatusRefresh = 1000;

constructor TFrameGetThread.Create(Video: IAsifClip; Owner: TObject; StartPriority: TThreadPriority; AOnTerminate: TNotifyEvent);
begin
  inherited Create(False);
  FCancelled := False;
  Priority := StartPriority;
  FreeOnTerminate := True;
  FVideo := Video;
  FOwner := Owner;
  FStartTime := GetTickCount;
  OnTerminate := AOnTerminate;
end;

procedure TFrameGetThread.Execute;
var
  Counter: Integer;
  NextUpdate: Cardinal;
  UpdateMessage: TYMCProgressUpdate;
  FrameCount: Integer;
  CurrentTime: Cardinal;
begin
  NextUpdate := 0;
  FrameCount := FVideo.GetVideoInfo.NumFrames;

  UpdateMessage.MessageId := WMYMCProgressUpdate;

  for Counter := 0 to FrameCount - 1 do
  begin
    if Terminated then
      Break;

    CurrentTime := GetTickCount;

    if (Counter and $0F = 0) and (CurrentTime > NextUpdate) then
    begin
      NextUpdate := CurrentTime + StatusRefresh;

      with UpdateMessage do
      begin
        CurrentFrame := Counter;
        ElapsedTime := CurrentTime - FStartTime;
        RemainingTime := Round((CurrentTime - FStartTime) / (Counter + 1) * (FrameCount - Counter - 1));
      end;

      FOwner.Dispatch(UpdateMessage);
    end;

    FVideo.GetFrame(Counter);
  end;

  FVideo := nil;
end;

procedure TFrameGetThread.Terminate;
begin
  inherited;
  FCancelled := True;
end;

end.
