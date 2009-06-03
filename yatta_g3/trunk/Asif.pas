unit Asif;

interface

uses classes, sysutils;

const
  // Colorspace properties.
  AVS_CS_BGR = 1 shl 28;
  AVS_CS_YUV = 1 shl 29;
  AVS_CS_INTERLEAVED = 1 shl 30;
  AVS_CS_PLANAR = Cardinal(1 shl 31);
  AVS_CS_UNKNOWN = 0;

  // Specific colorformats
  AVS_CS_BGR24 = 1 shl 0 or AVS_CS_BGR or AVS_CS_INTERLEAVED;
  AVS_CS_BGR32 = 1 shl 1 or AVS_CS_BGR or AVS_CS_INTERLEAVED;
  AVS_CS_YUY2 = 1 shl 2 or AVS_CS_YUV or AVS_CS_INTERLEAVED;
  AVS_CS_YV12 = Cardinal(1 shl 3 or AVS_CS_YUV or AVS_CS_PLANAR);
  AVS_CS_I420 = Cardinal(1 shl 4 or AVS_CS_YUV or AVS_CS_PLANAR);
  AVS_CS_IYUV = 1 shl 4 or AVS_CS_YUV or AVS_CS_PLANAR;

type
  EAsifException = class(Exception);
  EInvokeFailed = class(EAsifException);
  EInitializationFailed = class(EAsifException);

  PAsifData = Pointer;
  PAsifScriptEnvironment = Pointer;
  PAsifClip = Pointer;
  PAsifVideoFrame = Pointer;
  TApplyfunc = Pointer;
  TShutdownFunc = Pointer;

  AVSValueStruct = record
    Errors: Integer;
    ArraySize: Integer;
    case AVSType: Integer of
      1: (ClipVal: PAsifClip);
      2: (BoolVal: Boolean);
      3: (IntVal: Integer);
      4: (FloatVal: Single);
      5: (StringVal: PChar);
  end;

  VideoInfo = record
    Width, Height: Integer;
    FPSNumerator, FPSDenominator: Cardinal;
    NumFrames: Integer;
    PixelType: Integer;
    AudioSamplesPerSecond, SampleType: Integer;
    NumAudioSamples: Int64;
    NChannels: Integer;
    ImageType: Integer;
  end;

  IAsifVideoFrame = interface(IInterface)
    function GetFramePointer: PAsifVideoFrame;
    function GetPitch(Plane: Integer): Integer;
    function GetHeight(Plane: Integer): Integer;
    function GetRowSize(Plane: Integer): Integer;
    function GetReadPtr(Plane: Integer): PByte;
  end;

  TAsifVideoFrame = class(TInterfacedObject, IAsifVideoFrame)
  private
    FFrame: PAsifVideoFrame;
  public
    function GetFramePointer: PAsifVideoFrame;
    function GetPitch(Plane: Integer): Integer;
    function GetHeight(Plane: Integer): Integer;
    function GetRowSize(Plane: Integer): Integer;
    function GetReadPtr(Plane: Integer): PByte;
    constructor Create(Source: PAsifVideoFrame);
    destructor Destroy; override;
  end;

  IAsifClip = interface(IInterface)
    function GetClipPointer: PAsifClip;
    function GetFrame(N: Integer): IAsifVideoFrame;
    function GetParity(N: Integer): Boolean;
    procedure GetAudio(Buffer: Pointer; Start: Int64; Count: Int64);
    function GetVideoInfo: VideoInfo;
  end;

  TAsifClip = class(TInterfacedObject, IAsifClip)
  private
    FClip: PAsifClip;
  public
    function GetClipPointer: PAsifClip;
    function GetFrame(N: Integer): IAsifVideoFrame;
    function GetParity(N: Integer): Boolean;
    procedure GetAudio(Buffer: Pointer; Start: Int64; Count: Int64);
    function GetVideoInfo: VideoInfo;
    constructor Create(Source: PAsifClip);
    destructor Destroy; override;
  end;

  IAsifScriptEnvironment = interface(IInterface)
    procedure SetVar(VarName: string; Value: AVSValueStruct);
    procedure SetGlobalVar(VarName: string; Value: AVSValueStruct);
    procedure SetGlobalMemoryLimit(MaxLimit: Integer);
    function Invoke(Command: string): AVSValueStruct;
    function InvokeWithClipResult(Command: string): IAsifClip;
    procedure CharArg(Arg: PChar; ArgName: PChar = nil);
    procedure IntArg(Arg: Integer; ArgName: PChar = nil);
    procedure BoolArg(Arg: Boolean; ArgName: PChar = nil);
    procedure FloatArg(Arg: Single; ArgName: PChar = nil);
    procedure ClipArg(Video: IAsifClip; ArgName: PChar = nil);
    procedure CheckVersion(Version: Integer);
    function FunctionExists(Name: string): Boolean;
    function MakeWritable(PVF: IAsifVideoFrame): Boolean;
    procedure SaveString(S: PChar; Length: Integer);
    procedure BitBlt(DSTP: PByte; DSTPitch: Integer; SRCP: PByte; SRCPitch: Integer; RowSize: Integer; Height: Integer);
  end;

  TAsifScriptEnvironment = class(TInterfacedObject, IAsifScriptEnvironment)
  private
    FEnv: PAsifScriptEnvironment;
  public
    constructor Create;
    destructor Destroy; override;
    procedure SetVar(VarName: string; Value: AVSValueStruct);
    procedure SetGlobalVar(VarName: string; Value: AVSValueStruct);
    procedure SetGlobalMemoryLimit(MaxLimit: Integer);
    function Invoke(Command: string): AVSValueStruct;
    function InvokeWithClipResult(Command: string): IAsifClip;
    procedure CharArg(Arg: PChar; ArgName: PChar = nil);
    procedure IntArg(Arg: Integer; ArgName: PChar = nil);
    procedure BoolArg(Arg: Boolean; ArgName: PChar = nil);
    procedure FloatArg(Arg: Single; ArgName: PChar = nil);
    procedure ClipArg(Video: IAsifClip; ArgName: PChar = nil);
    procedure CheckVersion(Version: Integer);
    function FunctionExists(Name: string): Boolean;
    function MakeWritable(PVF: IAsifVideoFrame): Boolean;
    procedure SaveString(S: PChar; Length: Integer);
    procedure BitBlt(DSTP: PByte; DSTPitch: Integer; SRCP: PByte; SRCPitch: Integer; RowSize: Integer; Height: Integer);
  end;

procedure InitializeAvisynth;
procedure DeinitializeAvisynth;

function InitializeAsif: PAsifData; cdecl; external 'asif.dll';
procedure DeInitializeAsif(Data: PAsifData); cdecl; external 'asif.dll';
function NewAsifScriptEnvironment(Data: PAsifData): PAsifScriptEnvironment; cdecl; external 'asif.dll';
procedure DeleteAsifClip(Clip: PAsifClip); cdecl; external 'asif.dll';
procedure DeleteAsifScriptEnvironment(Env: PAsifScriptEnvironment); cdecl; external 'asif.dll';
function CharArg(Arg: PChar; ArgName: PChar; Env: PAsifScriptEnvironment): Integer; cdecl; external 'asif.dll';
function IntArg(Arg: Integer; ArgName: PChar; Env: PAsifScriptEnvironment): Integer; cdecl; external 'asif.dll';
function BoolArg(Arg: Boolean; ArgName: PChar; Env: PAsifScriptEnvironment): Integer; cdecl; external 'asif.dll';
function FloatArg(Arg: Single; ArgName: PChar; Env: PAsifScriptEnvironment): Integer; cdecl; external 'asif.dll';
function ClipArg(Clip: PAsifClip; ArgName: PChar; Env: PAsifScriptEnvironment): Integer; cdecl; external 'asif.dll';
function SetWorkingDir(Dir: PChar; Env: PAsifScriptEnvironment): Integer; cdecl; external 'asif.dll';
function SetMemoryMax(MB: Integer; Env: PAsifScriptEnvironment): Integer; cdecl; external 'asif.dll';
procedure BitBltExp(DSTP: PByte; DSTPitch: Integer; SRCP: PByte; SRCPitch: Integer; RowSize: Integer; Height: Integer; Env: PAsifScriptEnvironment); cdecl; external 'asif.dll';
procedure AddFunction(Name: PChar; Params: PChar; Apply: TApplyfunc; UserData: Pointer; Env: PAsifScriptEnvironment); cdecl; external 'asif.dll';
function GetCPUFlags(Env: PAsifScriptEnvironment): Cardinal; cdecl; external 'asif.dll';
procedure SetGlobalVar(VarName: PChar; VarValue: AVSValueStruct; Env: PAsifScriptEnvironment); cdecl; external 'asif.dll';
procedure CheckVersion(Version: Integer; Env: PAsifScriptEnvironment); cdecl; external 'asif.dll';
function FunctionExists(Name: PChar; Env: PAsifScriptEnvironment): Boolean; cdecl; external 'asif.dll';
function MakeWritable(PVF: PAsifVideoFrame; Env: PAsifScriptEnvironment): Boolean; cdecl; external 'asif.dll';
procedure AtExit(ShutdownFunc: TShutdownFunc; UserData: Pointer; Env: PAsifScriptEnvironment); cdecl; external 'asif.dll';
function NewVideoFrame(var VI: VideoInfo; Align: Integer; Env: PAsifScriptEnvironment): PAsifVideoFrame; cdecl; external 'asif.dll';
function Subframe(SRC: PAsifVideoFrame; RelOffset: Integer; NewPitch: Integer; NewRowSize: Integer; NewHeight: Integer; Env: PAsifScriptEnvironment): PAsifVideoFrame; cdecl; external 'asif.dll';
procedure SaveString(S: PChar; Length: Integer; Env: PAsifScriptEnvironment); cdecl; external 'asif.dll';
function GetFrame(N: Integer; Clip: PAsifClip): PAsifVideoFrame; cdecl; external 'asif.dll';
procedure SetCacheHints(CacheHints: Integer; FrameRange: Integer; Clip: PAsifClip); cdecl; external 'asif.dll';
function GetParity(N: Integer; Clip: PAsifClip): Boolean; cdecl; external 'asif.dll';
procedure GetAudio(Buffer: Pointer; Start: Int64; Count: Int64; Clip: PAsifClip); cdecl; external 'asif.dll';
function GetPitch(Plane: Integer; VF: PAsifVideoFrame): Integer; cdecl; external 'asif.dll';
function GetHeight(Plane: Integer; VF: PAsifVideoFrame): Integer; cdecl; external 'asif.dll';
function GetRowSize(Plane: Integer; VF: PAsifVideoFrame): Integer; cdecl; external 'asif.dll';
function IsWritable(VF: PAsifVideoFrame): Boolean; cdecl; external 'asif.dll';
function GetWritePtr(Plane: Integer; VF: PAsifVideoFrame): PByte; cdecl; external 'asif.dll';
function GetReadPtr(Plane: Integer; VF: PAsifVideoFrame): PByte; cdecl; external 'asif.dll';
procedure SetVar(VarName: PChar; VarValue: AVSValueStruct; Env: PAsifScriptEnvironment); cdecl; external 'asif.dll';
function Invoke(Command: PChar; Env: PAsifScriptEnvironment): AVSValueStruct; cdecl; external 'asif.dll';
function GetVideoInfo(Clip: PAsifClip): VideoInfo; cdecl; external 'asif.dll';
function GetVideoPointer(N: Integer; Clip: PAsifClip): PAsifVideoFrame; cdecl; external 'asif.dll';
procedure DeleteAsifVideoFrame(Frame: PAsifVideoFrame); cdecl; external 'asif.dll';

function avs_is_rgb(p: VideoInfo): Boolean;
function avs_is_rgb24(p: VideoInfo): Boolean;
function avs_is_rgb32(p: VideoInfo): Boolean;
function avs_is_yuy(p: VideoInfo): Boolean;
function avs_is_yuy2(p: VideoInfo): Boolean;
function avs_is_yv12(p: VideoInfo): Boolean;

implementation

var
  AsifData: PAsifData;

function avs_is_rgb(p: VideoInfo): Boolean;
begin
  Result := p.PixelType and AVS_CS_BGR <> 0;
end;

function avs_is_rgb24(p: VideoInfo): Boolean;
begin
  Result := p.PixelType and AVS_CS_BGR24 = AVS_CS_BGR24;
end;

function avs_is_rgb32(p: VideoInfo): Boolean;
begin
  Result := p.PixelType and AVS_CS_BGR32 = AVS_CS_BGR32;
end;

function avs_is_yuy(p: VideoInfo): Boolean;
begin
  Result := p.PixelType and AVS_CS_YUV <> 0;
end;

function avs_is_yuy2(p: VideoInfo): Boolean;
begin
  Result := p.PixelType and AVS_CS_YUY2 = AVS_CS_YUY2;
end;

function avs_is_yv12(p: VideoInfo): Boolean;
begin
  Result := (p.PixelType and AVS_CS_YV12 = AVS_CS_YV12) or (p.PixelType and AVS_CS_I420 = AVS_CS_I420);
end;

procedure TAsifScriptEnvironment.SetGlobalVar(Varname: string; Value: AVSValueStruct);
begin
  Asif.SetGlobalVar(PChar(Varname), Value, FEnv);
end;

procedure TAsifScriptEnvironment.CheckVersion(Version: Integer);
begin
  Asif.CheckVersion(Version, FEnv);
end;

function TAsifScriptEnvironment.FunctionExists(Name: string): Boolean;
begin
  Result := Asif.FunctionExists(PChar(Name), FEnv);
end;

function TAsifScriptEnvironment.MakeWritable(PVF: IAsifVideoFrame): Boolean;
begin
  Result := Asif.MakeWritable(PVF.GetFramePointer, FEnv);
end;

procedure TAsifScriptEnvironment.SaveString(S: PChar; Length: Integer);
begin
  Asif.SaveString(S, Length, FEnv);
end;

function TAsifClip.GetFrame(N: Integer): IAsifVideoFrame;
begin
  Result := TAsifVideoFrame.Create(Asif.GetFrame(N, FClip));
end;

function TAsifClip.GetParity(N: Integer): Boolean;
begin
  Result := Asif.GetParity(N, FClip);
end;

procedure TAsifClip.GetAudio(Buffer: Pointer; Start: Int64; Count: Int64);
begin
  Asif.GetAudio(Buffer, Start, Count, FClip);
end;


function TAsifClip.GetClipPointer: PAsifClip;
begin
  Result := FClip;
end;

function TAsifVideoFrame.GetFramePointer: PAsifVideoFrame;
begin
  Result := FFrame;
end;

function TAsifVideoFrame.GetPitch(Plane: Integer): Integer;
begin
  Result := Asif.GetPitch(Plane, FFrame);
end;

function TAsifVideoFrame.GetHeight(Plane: Integer): Integer;
begin
  Result := Asif.GetHeight(Plane, FFrame);
end;

function TAsifVideoFrame.GetRowSize(Plane: Integer): Integer;
begin
  Result := Asif.GetRowSize(Plane, FFrame);
end;

function TAsifVideoFrame.GetReadPtr(Plane: Integer): PByte;
begin
  Result := Asif.GetReadPtr(Plane, FFrame);
end;

constructor TAsifVideoFrame.Create(Source: PAsifVideoFrame);
begin
  FFrame := Source;
end;

destructor TAsifVideoFrame.Destroy;
begin
  DeleteAsifVideoFrame(FFrame);
end;

procedure TAsifScriptEnvironment.SetVar(VarName: string; Value: AVSValueStruct);
begin
  Asif.SetVar(PChar(Varname), Value, FEnv);
end;

function TAsifClip.GetVideoInfo: VideoInfo;
begin
  Result := Asif.GetVideoInfo(FClip);
end;


constructor TAsifClip.Create(Source: PAsifClip);
begin
  FClip := Source;
end;

destructor TAsifClip.Destroy;
begin
  Asif.DeleteAsifClip(FClip);
end;

procedure TAsifScriptEnvironment.SetGlobalMemoryLimit(MaxLimit: Integer);
begin
  Asif.SetMemoryMax(MaxLimit, FEnv);
end;

constructor TAsifScriptEnvironment.Create;
begin
  FEnv := Asif.NewAsifScriptEnvironment(AsifData);
  if FEnv = nil then
    raise EInitializationFailed.Create('Avisynth 2.5 failed to initialize.');
end;

function TAsifScriptEnvironment.Invoke(Command: string): AVSValueStruct;
var
  StringPointer: PChar;
begin
  StringPointer := PChar(Command);

  if not FunctionExists(StringPointer) then
    raise EInvokeFailed.Create('Function "' + Command + '" does not exist.');

  Result := Asif.Invoke(StringPointer, FEnv);
  if Result.Errors = 1 then
    raise EInvokeFailed.Create('Failed to invoke "' + Command + '"'#13#10 + Result.StringVal);
end;

function TAsifScriptEnvironment.InvokeWithClipResult(Command: string): IAsifClip;
var
  Res: AVSValueStruct;
begin
  Res := Invoke(command);
  if Res.AVSType <> 1 then
    raise EInvokeFailed.Create('Clip not returned for "' + Command + '"');

  Result := TAsifClip.Create(Res.ClipVal);
end;

procedure TAsifScriptEnvironment.CharArg(Arg: PChar; ArgName: PChar);
begin
  Asif.CharArg(Arg, ArgName, FEnv);
end;

procedure TAsifScriptEnvironment.IntArg(Arg: Integer; ArgName: PChar);
begin
  Asif.IntArg(Arg, ArgName, FEnv);
end;

procedure TAsifScriptEnvironment.BoolArg(Arg: Boolean; ArgName: PChar);
begin
  Asif.BoolArg(Arg, ArgName, FEnv);
end;

procedure TAsifScriptEnvironment.FloatArg(Arg: Single; ArgName: PChar);
begin
  Asif.FloatArg(Arg, ArgName, FEnv);
end;

procedure TAsifScriptEnvironment.ClipArg(Video: IAsifClip; ArgName: PChar);
begin
  Asif.ClipArg(Video.GetClipPointer, ArgName, FEnv);
end;

destructor TAsifScriptEnvironment.Destroy;
begin
  Asif.DeleteAsifScriptEnvironment(FEnv);
end;

procedure TAsifScriptEnvironment.BitBlt(DSTP: PByte; DSTPitch: Integer;
  SRCP: PByte; SRCPitch, RowSize, Height: Integer);
begin
  BitBltExp(DSTP, DSTPitch, SRCP, SRCPitch, RowSize, Height, FEnv);
end;

procedure InitializeAvisynth;
begin
  AsifData := InitializeAsif;
  if AsifData = nil then
    raise EAsifException.Create('Failed to load avisynth library');
end;

procedure DeinitializeAvisynth;
begin
  if AsifData <> nil then
    DeInitializeAsif(AsifData);
end;

end.
