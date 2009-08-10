unit YMCInternalPlugins;

interface

uses
  Windows, SysUtils, StrUtils, Controls, Forms, YMCPlugin,
  Types, Classes, Asif, Math, YShared;

type
  TCutRange = record
    CutStart, CutEnd: Integer
  end;

  TFrame = record
    Match: Integer;
    MMetric: array[0..2] of Integer;
    VMetric: array[0..2] of Integer;
    PostProcess: Boolean;
    Decimate: Boolean;
  end;

  TSmallFrame = record
    MMetric: array[0..2] of Integer;
    VMetric: array[0..2] of Integer;
  end;

  TITsettings = record
    Order: 0..1;
  end;

  TTelecidesettings = record
    Guide: 0..3;
    VThresh: 0..255;
    DThresh: 0..255;
    NT: Integer;
    Order: 0..1;
    Back: 0..2;
    GThresh: 0..100;
    BThresh: 0..255;
    Y0: Integer;
    Y1: Integer;
    PostProcess: Boolean;
    Blend: Boolean;
    Chroma: Boolean;
    Show: Boolean;
  end;

  TSClavcSettings = record
    MBCmp, Cmp, SubCmp, PreMe, Dia, PreDia: Integer;
    V4MV: Boolean;
    LogOutput: array[0..2047] of AnsiChar;
  end;

  TSCXvidSettings = record
    LogOutput: string;
  end;

  TCropsettings = record
    X1, X2, Y1, Y2: Integer;
  end;

  TTFMSettings = record
    Order: 0..1;
    Mode: 0..7;
    PP: 0..7;
    Slow: 0..2;
    Field: - 1..1;
    CThresh: Integer;
    MI: Integer;
    BlockX: Integer;
    BlockY: Integer;
    MThresh: Integer;
    Y0: Integer;
    Y1: Integer;
    Metric: 0..1;
    MicMatching: 0..4;
    Chroma: Boolean;
    MChroma: Boolean;
    Display: Boolean;
    D2VPath: array[0..2047] of AnsiChar;
  end;

  TCutterSettings = record
    Cuts: array of TCutRange;
  end;

  TResizeSettings = record
    Width, Height: Integer;
    Resizer: string;
  end;

  TENPipeSettings = record
    VideoCL, AudioCL: string;
    WaitMS: Integer;
    Y4M: Boolean;
  end;

  TIT = class(TYMCPlugin)
  private
    FFramecount: Integer;
    FSettings: TITsettings;
  protected
    FLogPath: string;
    function GetSettings: string; override;
  public
    constructor Create(Settings: string; Selected: Boolean); override;
    procedure Configure(Env: IAsifScriptEnvironment; Video: IAsifClip; out NewDefault: string); override;
    function Invoke(Env: IAsifScriptEnvironment; Video: IAsifClip; Preview: Boolean): IAsifClip; override;
    procedure ProcessLog(Log: TStrings; Outfile: TStrings; var Header: TYMCProjectHeader); override;

    class function GetConfiguration: TYMCPluginConfig; override;
    class function GetName: string; override;
    class function GetPluginType: TYMCPluginType; override;
    class function GetSupportedColorSpaces: TColorSpaces; override;
    class function GetUsedFunctions: TStringDynArray; override;
    class function MTSafe: Boolean; override;
  end;

  TTelecide = class(TYMCPlugin)
  private
    FFramecount: Integer;
    FSettings: TTelecidesettings;
  protected
    function GetSettings: string; override;
  public
    constructor Create(Settings: string; Selected: Boolean); override;
    procedure Configure(Env: IAsifScriptEnvironment; Video: IAsifClip; out NewDefault: string); override;
    function Invoke(Env: IAsifScriptEnvironment; Video: IAsifClip; Preview: Boolean): IAsifClip; override;
    procedure ProcessLog(Log: TStrings; Outfile: TStrings; var Header: TYMCProjectHeader); override;

    class function GetConfiguration: TYMCPluginConfig; override;
    class function GetName: string; override;
    class function GetPluginType: TYMCPluginType; override;
    class function GetSupportedColorSpaces: TColorSpaces; override;
    class function GetUsedFunctions: TStringDynArray; override;
  end;

  TSClavc = class(TYMCPlugin)
  private
    FBlockCount: Integer;
    FSettings: TSClavcSettings;
  protected
    FLogPath: string;
    function GetSettings: string; override;
  public
    constructor Create(Settings: string; Selected: Boolean); override;
    procedure Configure(Env: IAsifScriptEnvironment; Video: IAsifClip; out NewDefault: string); override;
    function Invoke(Env: IAsifScriptEnvironment; Video: IAsifClip; Preview: Boolean): IAsifClip; override;
    procedure ProcessLog(Log: TStrings; Outfile: TStrings; var Header: TYMCProjectHeader); override;

    class function GetConfiguration: TYMCPluginConfig; override;
    class function GetName: string; override;
    class function GetPluginType: TYMCPluginType; override;
    class function GetSupportedColorSpaces: TColorSpaces; override;
    class function GetUsedFunctions: TStringDynArray; override;
    class function MTSafe: Boolean; override;
  end;

  TSCXvid = class(TYMCPlugin)
  private
    FSettings: TSCXvidSettings;
  protected
    FLogPath: string;
    function GetSettings: string; override;
  public
    constructor Create(Settings: string; Selected: Boolean); override;
    procedure Configure(Env: IAsifScriptEnvironment; Video: IAsifClip; out NewDefault: string); override;
    function Invoke(Env: IAsifScriptEnvironment; Video: IAsifClip; Preview: Boolean): IAsifClip; override;
    procedure ProcessLog(Log: TStrings; Outfile: TStrings; var Header: TYMCProjectHeader); override;

    class function GetConfiguration: TYMCPluginConfig; override;
    class function GetName: string; override;
    class function GetPluginType: TYMCPluginType; override;
    class function GetSupportedColorSpaces: TColorSpaces; override;
    class function GetUsedFunctions: TStringDynArray; override;
    class function MTSafe: Boolean; override;
  end;

  TDecimate = class(TYMCPlugin)
  private
    FFramecount: Integer;
  public
    function Invoke(Env: IAsifScriptEnvironment; Video: IAsifClip; Preview: Boolean): IAsifClip; override;
    procedure ProcessLog(Log: TStrings; Outfile: TStrings; var Header: TYMCProjectHeader); override;

    class function GetName: string; override;
    class function GetPluginType: TYMCPluginType; override;
    class function GetSupportedColorSpaces: TColorSpaces; override;
    class function GetUsedFunctions: TStringDynArray; override;
  end;

  TTDecimate = class(TYMCPlugin)
  private
    FFramecount: Integer;
  protected
    FLogPath: string;
  public
    function Invoke(Env: IAsifScriptEnvironment; Video: IAsifClip; Preview: Boolean): IAsifClip; override;
    procedure ProcessLog(Log: TStrings; Outfile: TStrings; var Header: TYMCProjectHeader); override;

    class function GetName: string; override;
    class function GetPluginType: TYMCPluginType; override;
    class function GetSupportedColorSpaces: TColorSpaces; override;
    class function GetUsedFunctions: TStringDynArray; override;
    class function MTSafe: Boolean; override;
  end;

  TCrop = class(TYMCPlugin)
  private
    FSettings: TCropsettings;
  protected
    function GetSettings: string; override;
  public
    constructor Create(Settings: string; Selected: Boolean); override;
    procedure Configure(Env: IAsifScriptEnvironment; Video: IAsifClip; out NewDefault: string); override;
    function Invoke(Env: IAsifScriptEnvironment; Video: IAsifClip; Preview: Boolean): IAsifClip; override;

    class function GetConfiguration: TYMCPluginConfig; override;
    class function GetName: string; override;
    class function GetPluginType: TYMCPluginType; override;
    class function GetSupportedColorSpaces: TColorSpaces; override;
    class function GetUsedFunctions: TStringDynArray; override;
    class function MTSafe: Boolean; override;
  end;

  TTFM = class(TYMCPlugin)
  private
    FSettings: TTFMSettings;
  protected
    FLogPath: string;
    FFramecount: Integer;
    function GetSettings: string; override;
    procedure InternalProcessLog(Log: TStrings; Outfile: TStrings; var Header: TYMCProjectHeader; WithMetrics: Boolean);
  public
    constructor Create(Settings: string; Selected: Boolean); override;
    procedure Configure(Env: IAsifScriptEnvironment; Video: IAsifClip; out NewDefault: string); override;
    function Invoke(Env: IAsifScriptEnvironment; Video: IAsifClip; Preview: Boolean): IAsifClip; override;
    procedure ProcessLog(Log: TStrings; Outfile: TStrings; var Header: TYMCProjectHeader); override;

    class function GetConfiguration: TYMCPluginConfig; override;
    class function GetName: string; override;
    class function GetPluginType: TYMCPluginType; override;
    class function GetSupportedColorSpaces: TColorSpaces; override;
    class function GetUsedFunctions: TStringDynArray; override;
    class function MTSafe: Boolean; override;
  end;


  TTFMAndTelecide = class(TTFM)
  public
    function Invoke(Env: IAsifScriptEnvironment; Video: IAsifClip; Preview: Boolean): IAsifClip; override;
    procedure ProcessLog(Log: TStrings; Outfile: TStrings; var Header: TYMCProjectHeader); override;

    class function GetName: string; override;
    class function GetUsedFunctions: TStringDynArray; override;
    class function MTSafe: Boolean; override;
  end;

  TCutter = class(TYMCPlugin)
  private
    FSettings: TCutterSettings;
    FFramecount: Integer;
  protected
    function GetSettings: string; override;
  public
    constructor Create(Settings: string; Selected: Boolean); override;
    procedure Configure(Env: IAsifScriptEnvironment; Video: IAsifClip; out NewDefault: string); override;
    function Invoke(Env: IAsifScriptEnvironment; Video: IAsifClip; Preview: Boolean): IAsifClip; override;
    procedure ProcessLog(Log: TStrings; Outfile: TStrings; var Header: TYMCProjectHeader); override;

    class function GetConfiguration: TYMCPluginConfig; override;
    class function GetName: string; override;
    class function GetPluginType: TYMCPluginType; override;
    class function GetSupportedColorSpaces: TColorSpaces; override;
    class function GetUsedFunctions: TStringDynArray; override;
    class function MTSafe: Boolean; override;
  end;

  TResize = class(TYMCPlugin)
  private
    FSettings: TResizeSettings;
  protected
    function GetSettings: string; override;
  public
    constructor Create(Settings: string; Selected: Boolean); override;
    procedure Configure(Env: IAsifScriptEnvironment; Video: IAsifClip; out NewDefault: string); override;
    function Invoke(Env: IAsifScriptEnvironment; Video: IAsifClip; Preview: Boolean): IAsifClip; override;

    class function GetConfiguration: TYMCPluginConfig; override;
    class function GetName: string; override;
    class function GetPluginType: TYMCPluginType; override;
    class function GetSupportedColorSpaces: TColorSpaces; override;
    class function GetUsedFunctions: TStringDynArray; override;
    class function MTSafe: Boolean; override;
  end;

  TENPipe = class(TYMCPlugin)
  private
    FSettings: TENPipeSettings;
  protected
    function GetSettings: string; override;
  public
    constructor Create(Settings: string; Selected: Boolean); override;
    procedure Configure(Env: IAsifScriptEnvironment; Video: IAsifClip; out NewDefault: string); override;
    function Invoke(Env: IAsifScriptEnvironment; Video: IAsifClip; Preview: Boolean): IAsifClip; override;

    class function GetConfiguration: TYMCPluginConfig; override;
    class function GetName: string; override;
    class function GetPluginType: TYMCPluginType; override;
    class function GetSupportedColorSpaces: TColorSpaces; override;
    class function GetUsedFunctions: TStringDynArray; override;
    class function MTSafe: Boolean; override;
  end;


procedure YMCPluginInit(AddPlugin: TAddPlugin);

implementation

uses
  telecide, sc, crop, it, tfm, scxvid, cutter, resize;

const
  PluginClasses: array[0..10] of TYMCPluginClass =
  (TCutter, TCrop, TIT, TTelecide, TTFM, TTFMandTelecide, TSCXvid, TSClavc, TDecimate, TTDecimate, TResize);

function MemoryToHex(Ptr: Pointer; Size: Integer): string;
var
  Counter: Integer;
  SrcPtr: PByte;
begin
  Result := '';
  SrcPtr := Ptr;

  for Counter := 0 to Size - 1 do
  begin
    Result := Result + IntToHex(SrcPtr^, 2);
    Inc(SrcPtr);
  end;
end;

procedure HexToMemory(Hex: string; Ptr: Pointer);
var
  Counter: Integer;
  DstPtr: PByte;
begin
  DstPtr := Ptr;

  for Counter := 1 to Length(Hex) div 2 do
  begin
    DstPtr^ := StrToInt('0x' + Hex[Counter * 2 - 1] + Hex[Counter * 2]);
    Inc(DstPtr);
  end;
end;

procedure YMCPluginInit(AddPlugin: TAddPlugin);
var
  Counter: Integer;
begin
  for Counter := 0 to Length(PluginClasses) - 1 do
    AddPlugin(PluginClasses[Counter]);
end;

{ TCrop }

function TCrop.Invoke(Env: IAsifScriptEnvironment; Video: IAsifClip; Preview: Boolean): IAsifClip;
begin
  with Env do
  begin
    ClipArg(Video);
    IntArg(FSettings.X1);
    IntArg(FSettings.Y1);
    IntArg(-FSettings.X2);
    IntArg(-FSettings.Y2);

    Result := InvokeWithClipResult('Crop');
  end;
end;

procedure TCrop.Configure(Env: IAsifScriptEnvironment; Video: IAsifClip; out NewDefault: string);
begin
  with TCropForm.Create(Env, Video, nil), FSettings do
  try
    UpDown4.Position := X1;
    UpDown2.Position := X2;
    UpDown3.Position := Y1;
    UpDown1.Position := Y2;

    Edit2.Text := IntToStr(UpDown4.Position);
    Edit3.Text := IntToStr(UpDown3.Position);
    Edit5.Text := IntToStr(UpDown1.Position);
    Edit4.Text := IntToStr(UpDown2.Position);

    TrackBarChange(nil);
    ShowModal;

    X1 := UpDown4.Position;
    X2 := UpDown2.Position;
    Y1 := UpDown3.Position;
    Y2 := UpDown1.Position;

    if MakeDefault.Checked then
      NewDefault := GetSettings;

  finally
    Free;
  end;
end;

constructor TCrop.Create(Settings: string; Selected: Boolean);
begin
  inherited;

  with FSettings do
  begin
    X1 := 0;
    X2 := 0;
    Y1 := 0;
    Y2 := 0;
  end;

  if Settings <> '' then
    with FSettings do
    begin
      X1 := StrToInt(GetToken(Settings, 0, [',']));
      X2 := StrToInt(GetToken(Settings, 1, [',']));
      Y1 := StrToInt(GetToken(Settings, 2, [',']));
      Y2 := StrToInt(GetToken(Settings, 3, [',']));
    end;
end;

class function TCrop.GetConfiguration: TYMCPluginConfig;
begin
  Result := pcVideo;
end;

class function TCrop.GetName: string;
begin
  Result := 'Crop';
end;

class function TCrop.GetPluginType: TYMCPluginType;
begin
  Result := ypVideoFilter;
end;

function TCrop.GetSettings: string;
begin
  with FSettings do
    Result := Format('%d,%d,%d,%d', [X1, X2, Y1, Y2]);
end;

class function TCrop.GetSupportedColorSpaces: TColorSpaces;
begin
  Result := [csYV12, csYUY2, csRGB24, csRGB32];
end;

class function TCrop.GetUsedFunctions: TStringDynArray;
begin

end;

class function TCrop.MTSafe: Boolean;
begin
  Result := True;
end;

{ TTelecide }

procedure TTelecide.ProcessLog(Log: TStrings; Outfile: TStrings; var Header: TYMCProjectHeader);
var
  FrameArray: array of TFrame;
  Counter: integer;
  FN: Integer;
  Line, Wt: string;
begin
  SetLength(FrameArray, FFramecount + 25);

  for Counter := 0 to Log.Count - 1 do
  begin
    Line := Log[Counter];

    if AnsiContainsStr(Line, 'Telecide:') then
    begin

      Wt := GetToken(Line, 2);
      FN := StrToInt(LeftStr(Wt, Length(Wt) - 1));

      if AnsiContainsStr(Line, 'using') then
      begin
        Wt := GetToken(Line, 4);

        if Wt = 'c]' then
          FrameArray[FN].Match := 1
        else if Wt = 'n]' then
          FrameArray[FN].Match := 0
        else if Wt = 'p]' then
          FrameArray[FN].Match := 2;

      end
      else if AnsiContainsStr(Line, 'matches') then
      begin
        FrameArray[FN].MMetric[2] := StrToInt(GetToken(Line, 4));
        FrameArray[FN].MMetric[1] := StrToInt(GetToken(Line, 5));
        FrameArray[FN].MMetric[0] := StrToInt(GetToken(Line, 6));
      end
      else if AnsiContainsStr(Line, 'vmetrics') then
      begin
        FrameArray[fn].VMetric[2] := StrToInt(GetToken(Line, 4));
        FrameArray[fn].VMetric[1] := StrToInt(GetToken(Line, 5));
        FrameArray[fn].VMetric[0] := StrToInt(GetToken(Line, 6));
      end;

      FrameArray[FN].PostProcess := FSettings.PostProcess and AnsiContainsStr(Line, 'interlaced');
    end;
  end;

  Header.ProjectType := 1;
  Header.Order := FSettings.Order;
  if Header.FrameCount <= 0 then
    Header.FrameCount := FFramecount;
  if FSettings.Blend then
    Header.PostProcessor := ppDecombBlend
  else
    Header.PostProcessor := ppDecombInterpolate;

  Outfile.Append('[METRICS]');
  for Counter := 0 to FFramecount - 1 do
    with FrameArray[Counter] do
      Outfile.Append(Format('%d %d %d %d %d %d', [MMetric[0], MMetric[1], MMetric[2], VMetric[0], VMetric[1], VMetric[2]]));
  Outfile.Append('');

  Outfile.Append('[MATCHES]');
  for Counter := 0 to FFramecount - 1 do
    case FrameArray[Counter].Match of
      0: Outfile.Append('n');
      1: Outfile.Append('c');
      2: Outfile.Append('p');
    end;

  Outfile.Append('');

  Outfile.Append('[ORIGINALMATCHES]');

  for Counter := 0 to FFramecount - 1 do
    case FrameArray[Counter].Match of
      0: Outfile.Append('n');
      1: Outfile.Append('c');
      2: Outfile.Append('p');
    end;

  Outfile.Append('');

  Outfile.Append('[POSTPROCESS]');

  for Counter := 0 to FFramecount - 1 do
    if FrameArray[Counter].PostProcess then
      Outfile.Append(IntToStr(Counter));

  Outfile.Append('');
end;


class function TTelecide.GetName: string;
begin
  Result := 'Telecide';
end;

function TTelecide.Invoke(Env: IAsifScriptEnvironment; Video: IAsifClip; Preview: Boolean): IAsifClip;
begin
  FFramecount := Video.GetVideoInfo.NumFrames;

  with Env do
  begin
    ClipArg(Video);

    if FSettings.Order = 0 then
      Result := InvokeWithClipResult('AssumeBFF')
    else
      Result := InvokeWithClipResult('AssumeTFF');

    ClipArg(Result);
    BoolArg(not Preview, 'debug');
    BoolArg(FSettings.Blend, 'blend');
    BoolArg(False, 'show');
    IntArg(FSettings.Guide, 'guide');
    IntArg(FSettings.Back, 'back');
    IntArg(FSettings.NT, 'nt');
    IntArg(FSettings.GThresh, 'gthresh');
    IntArg(FSettings.VThresh, 'vthresh');
    IntArg(FSettings.BThresh, 'bthresh');
    IntArg(FSettings.DThresh, 'dthresh');
    BoolArg(FSettings.Chroma, 'chroma');
    IntArg(FSettings.Y0, 'y0');
    IntArg(FSettings.Y1, 'y1');

    if FSettings.PostProcess then
      IntArg(2, 'post')
    else
      IntArg(1, 'post');

    Result := InvokeWithClipResult('Telecide');
  end;
end;


function TTelecide.GetSettings: string;
begin
  Result := MemoryToHex(@FSettings, SizeOf(FSettings));
end;

procedure TTelecide.Configure(Env: IAsifScriptEnvironment; Video: IAsifClip; out NewDefault: string);
begin
  with TTelecideForm.Create(Env, Video, nil), FSettings do
  try
    GuideGroup.ItemIndex := Guide;
    OrderGroup.ItemIndex := Order;
    OrderGroup.Hint := Format('Avisynth reports the correct order as %s but this is far from reliable for sources that aren''t d2v.', [IfThen(Video.GetVideoInfo.ImageType and 1 = 1, '0 (bff)', '1 (tff)')]);
    BlendCheckbox.Checked := Blend;
    PostCheckbox.Checked := PostProcess;
    BackGroup.ItemIndex := Back;
    NTEdit.Text := IntToStr(NT);
    GThreshEdit.Text := IntToStr(GThresh);
    VThreshEdit.Text := IntToStr(VThresh);
    DThreshEdit.Text := IntToStr(DThresh);
    BThreshEdit.Text := IntToStr(BThresh);
    ChromaCheckbox.Checked := Chroma;
    ShowCheckbox.Checked := Show;
    BackGroupClick(nil);
    RefreshVideo;
    ShowModal;

    Guide := GuideGroup.ItemIndex;
    Order := OrderGroup.ItemIndex;
    Blend := BlendCheckbox.Checked;
    PostProcess := PostCheckbox.Checked;
    Back := BackGroup.ItemIndex;
    NT := StrToIntDef(NTEdit.Text, 10);
    GThresh := StrToIntDef(GThreshEdit.Text, 10);
    VThresh := StrToIntDef(VThreshEdit.Text, 35);
    DThresh := StrToIntDef(DThreshEdit.Text, 7);
    BThresh := StrToIntDef(BThreshEdit.Text, 50);
    Chroma := ChromaCheckbox.Checked;
    Show := ShowCheckbox.Checked;

    if MakeDefault.Checked then
      NewDefault := GetSettings;

  finally
    Free;
  end;
end;

class function TDecimate.GetName: string;
begin
  Result := 'Decimate';
end;


class function TDecimate.GetPluginType: TYMCPluginType;
begin
  Result := ypMetricsCollector;
end;

class function TDecimate.GetSupportedColorSpaces: TColorSpaces;
begin
  Result := [csYV12, csYUY2];
end;

class function TDecimate.GetUsedFunctions: TStringDynArray;
begin
  SetLength(Result, 1);
  Result[0] := 'Decimate';
end;

function TDecimate.Invoke(Env: IAsifScriptEnvironment; Video: IAsifClip; Preview: Boolean): IAsifClip;
begin
  FFramecount := Video.GetVideoInfo.NumFrames;
  Env.ClipArg(video);
  Env.IntArg(2, 'mode');
  Env.IntArg(5, 'cycle');
  Env.BoolArg(True, 'debug');
  Result := Env.InvokeWithClipResult('Decimate');
end;

procedure TDecimate.ProcessLog(Log: TStrings; Outfile: TStrings; var Header: TYMCProjectHeader);
var
  DMetrics: array of Integer;
  Counter: Integer;
  FN: integer;
  Line, Wt: string;
begin
  SetLength(DMetrics, FFramecount + 25);

  for Counter := 0 to Log.Count - 1 do
  begin
    Line := Log[Counter];

    if AnsiContainsStr(Line, 'Decimate:') and AnsiStartsStr('Decimate:', Line) then
    begin
      Wt := GetToken(Line, 1);
      FN := StrToIntDef(LeftStr(Wt, Length(Wt) - 1), -1);

      if (FN > -1) and (StrToIntDef(GetToken(Line, 2), -1) = -1) then
      begin
        DMetrics[fn + 0] := Round(100 * StrToFloat(GetToken(Line, 2)));
        DMetrics[fn + 1] := Round(100 * StrToFloat(GetToken(Line, 3)));
        DMetrics[fn + 2] := Round(100 * StrToFloat(GetToken(Line, 4)));
        DMetrics[fn + 3] := Round(100 * StrToFloat(GetToken(Line, 5)));
        DMetrics[fn + 4] := Round(100 * StrToFloat(GetToken(Line, 6)));
      end;
    end;
  end;

  Outfile.Append('[DECIMATEMETRICS]');
  for Counter := 0 to FFramecount - 1 do
    Outfile.Append(IntToStr(DMetrics[Counter]));
end;

{ TTFM }

procedure TTFM.Configure(Env: IAsifScriptEnvironment; Video: IAsifClip; out NewDefault: string);
begin
  with TTFMForm.Create(Env, Video, nil), FSettings do
  try
    OrderGroup.ItemIndex := Order;
    OrderGroup.Hint := Format('Avisynth reports the correct order as %s but this is far from reliable for sources that aren''t d2v.', [IfThen(Video.GetVideoInfo.ImageType and 1 = 1, '0 (bff)', '1 (tff)')]);
    ModeGroup.ItemIndex := Mode div 2;
    PPGroup.ItemIndex := PP;
    FieldGroup.ItemIndex := Field + 1;
    SlowGroup.ItemIndex := Slow;
    MicMatchingGroup.ItemIndex := MicMatching div 2;
    MChromaCheckbox.Checked := MChroma;
    ChromaCheckbox.Checked := Chroma;
    DisplayCheckbox.Checked := Display;
    MIEdit.Text := IntToStr(MI);
    BlockXEdit.Text := IntToStr(BlockX);
    BlockYEdit.Text := IntToStr(BlockY);
    CThreshEdit.Text := IntToStr(CThresh);
    MThreshEdit.Text := IntToStr(MThresh);
    D2VOpenDialog.FileName := D2VPath;
    RefreshVideo;
    ShowModal;

    Order := OrderGroup.ItemIndex;
    Mode := ModeGroup.ItemIndex * 2;
    PP := PPGroup.ItemIndex;
    Field := FieldGroup.ItemIndex - 1;
    Slow := SlowGroup.ItemIndex;
    MicMatching := MicMatchingGroup.ItemIndex * 2;
    MChroma := MChromaCheckbox.Checked;
    Chroma := ChromaCheckbox.Checked;
    Display := DisplayCheckbox.Checked;
    MI := StrToIntDef(MIEdit.Text, 100);
    BlockX := StrToIntDef(BlockXEdit.Text, 16);
    BlockY := StrToIntDef(BlockYEdit.Text, 16);
    CThresh := StrToIntDef(CThreshEdit.Text, 10);
    MThresh := StrToIntDef(MThreshEdit.Text, 5);
    StrLCopy(D2VPath, PChar(D2VOpenDialog.FileName), SizeOf(D2VPath) - 1);

    if MakeDefault.Checked then
      NewDefault := GetSettings;

  finally
    Free;
  end;
end;

constructor TTFM.Create(Settings: string; Selected: Boolean);
begin
  inherited;

  with FSettings do
  begin
    Order := 1;
    Mode := 0;
    PP := 6;
    Field := -1;
    Slow := 1;
    MChroma := True;
    Y0 := 0;
    Y1 := 0;
    MicMatching := 0;
    CThresh := 9;
    Chroma := False;
    BlockX := 16;
    BlockY := 16;
    MI := 80;
    Metric := 0;
    Display := True;
    D2VPath := '';
  end;

  if Settings <> '' then
    HexToMemory(Settings, @FSettings);
end;

class function TTFM.GetConfiguration: TYMCPluginConfig;
begin
  Result := pcVideo;
end;

class function TTFM.GetName: string;
begin
  Result := 'TFM';
end;

class function TTFM.GetPluginType: TYMCPluginType;
begin
  Result := ypMetricsCollector;
end;

function TTFM.GetSettings: string;
begin
  Result := MemoryToHex(@FSettings, SizeOf(FSettings));
end;

class function TTFM.GetSupportedColorSpaces: TColorSpaces;
begin
  Result := [csYV12, csYUY2];
end;

class function TTFM.GetUsedFunctions: TStringDynArray;
begin
  SetLength(Result, 1);
  Result[0] := 'TFM';
end;

function TTFM.Invoke(Env: IAsifScriptEnvironment; Video: IAsifClip; Preview: Boolean): IAsifClip;
begin
  FFramecount := Video.GetVideoInfo.NumFrames;

  with Env, FSettings do
  begin
    ClipArg(Video);
    IntArg(Order, 'order');
    IntArg(Mode, 'mode');
    IntArg(Max(PP, 1), 'pp');
    IntArg(Field, 'field');
    IntArg(CThresh, 'cthresh');
    IntArg(MI, 'mi');
    IntArg(BlockX, 'blockx');
    IntArg(BlockY, 'blocky');
    IntArg(MThresh, 'mthresh');
    IntArg(Y0, 'y0');
    IntArg(Y1, 'y1');
    IntArg(Slow, 'slow');
    IntArg(MicMatching, 'micmatching');
    IntArg(2, 'micout');
    IntArg(Metric, 'metric');
    BoolArg(Chroma, 'chroma');
    BoolArg(MChroma, 'mchroma');
    BoolArg(False, 'display');
    BoolArg(False, 'debug');
    IntArg(4, 'flags');
    CharArg(D2VPath, 'd2v');

    if not Preview then
    begin
      FLogPath := GetTempFile;
      CharArg(PChar(FLogPath), 'output');
    end;

    Result := InvokeWithClipResult('TFM');
  end;
end;

procedure TTFM.InternalProcessLog(Log: TStrings; Outfile: TStrings; var Header: TYMCProjectHeader; WithMetrics: Boolean);
var
  FrameArray: array of TFrame;
  Counter, FrameNumber: Integer;
  TFMLog: TStringList;
  Line: string;
  SubDivCount: Integer;
  CNPrimary: Boolean;
begin
  SetLength(FrameArray, FFramecount + 25);
  TFMLog := TStringList.Create;

  // Are the first choice matches c/n or p/c?
  CNPrimary := FSettings.Field <> -1;
  if CNPrimary then
    CNPrimary := FSettings.Order <> FSettings.Field;

  try
    TFMLog.LoadFromFile(FLogPath);

    for Counter := 0 to TFMLog.Count - 1 do
    begin
      Line := TFMLog[Counter];

      if (Line = '') then
        Continue;

      FrameNumber := StrToIntDef(GetToken(Line, 0), -1);
      if FrameNumber < 0 then
        Continue;

      with FrameArray[FrameNumber] do
      begin
        case GetToken(Line, 1)[1] of
          'c', 'l', 'h': Match := 1;
          'n', 'u': Match := 0;
          'p', 'b': Match := 2;
        else
          raise EYMCPluginException.CreateFmt('''%s'' is an unknown match', [GetToken(Line, 1)[1]]);
        end;

        if GetToken(Line, 9) <> '' then
          SubDivCount := 10
        else
          SubDivCount := 9;

        //if SubDivCount = 10 then
        //d2v override used

        VMetric[1] := StrToInt(GetToken(Line, SubDivCount - 4, [#13, #10, ' ', '(', ')']));

        if CNPrimary then
        begin
          VMetric[0] := StrToInt(GetToken(Line, SubDivCount - 3, [#13, #10, ' ', '(', ')']));
          VMetric[2] := StrToInt(GetToken(Line, SubDivCount - 2, [#13, #10, ' ', '(', ')']));
        end
        else
        begin
          VMetric[0] := StrToInt(GetToken(Line, SubDivCount - 1, [#13, #10, ' ', '(', ')']));
          VMetric[2] := StrToInt(GetToken(Line, SubDivCount - 5, [#13, #10, ' ', '(', ')']));
        end;

        PostProcess := (FSettings.PP > 0) and (GetToken(Line, 2) = '+');
      end;
    end;

    with Header do
    begin
      ProjectType := 1;
      Order := FSettings.Order;
      if FrameCount <= 0 then
        FrameCount := FFramecount;
      PostProcessor := ppTDeint;
    end;

    Outfile.Append('[MATCHES]');
    for Counter := 0 to FFramecount - 1 do
    begin
      case FrameArray[Counter].Match of
        0: Outfile.Append('n');
        1: Outfile.Append('c');
        2: Outfile.Append('p');
      end;
    end;

    Outfile.Append('');

    Outfile.Append('[ORIGINALMATCHES]');

    for Counter := 0 to FFramecount - 1 do
    begin
      case FrameArray[Counter].Match of
        0: Outfile.Append('n');
        1: Outfile.Append('c');
        2: Outfile.Append('p');
      end;
    end;

    Outfile.Append('');

    Outfile.Append('[POSTPROCESS]');

    for Counter := 0 to FFramecount - 1 do
    begin
      if FrameArray[Counter].PostProcess then
        Outfile.Append(IntToStr(Counter));
    end;

    Outfile.Append('');

    if WithMetrics then
    begin
      Outfile.Append('[METRICS]');
      for Counter := 0 to FFramecount - 1 do
        with FrameArray[Counter] do
          Outfile.Append(Format('0 0 0 %d %d %d', [VMetric[0], VMetric[1], VMetric[2]]));

      Outfile.Append('');
    end;

  finally
    TFMLog.Free;
  end;
end;

procedure TTFM.ProcessLog(Log, Outfile: TStrings;
  var Header: TYMCProjectHeader);
begin
  InternalProcessLog(Log, Outfile, Header, True);
  DeleteFile(FLogPath);
end;

class function TTFM.MTSafe: Boolean;
begin
  Result := True;
end;

{ TTDecimate }

class function TTDecimate.GetName: string;
begin
  Result := 'TDecimate';
end;

class function TTDecimate.GetPluginType: TYMCPluginType;
begin
  Result := ypMetricsCollector;
end;

class function TTDecimate.GetSupportedColorSpaces: TColorSpaces;
begin
  Result := [csYV12, csYUY2];
end;

class function TTDecimate.GetUsedFunctions: TStringDynArray;
begin
  SetLength(Result, 1);
  Result[0] := 'TDecimate';
end;

function TTDecimate.Invoke(Env: IAsifScriptEnvironment; Video: IAsifClip; Preview: Boolean): IAsifClip;
begin
  FFramecount := Video.GetVideoInfo.NumFrames;

  Env.ClipArg(video);
  Env.IntArg(1, 'mode');
  Env.IntArg(5, 'cycle');

  if not Preview then
  begin
    FLogPath := GetTempFile;
    Env.CharArg(PChar(FLogPath), 'Output');
  end;

  Result := Env.InvokeWithClipResult('TDecimate');
end;

class function TTDecimate.MTSafe: Boolean;
begin
  Result := True;
end;

procedure TTDecimate.ProcessLog(Log: TStrings; Outfile: TStrings; var Header: TYMCProjectHeader);
var
  DMetrics: array of Integer;
  SCMetrics: array of Integer;
  Counter: Integer;
  FN: Integer;
  TDecimateLog: TStringList;
  Line: string;
begin
  SetLength(DMetrics, FFramecount);
  SetLength(SCMetrics, FFramecount);

  TDecimateLog := TStringList.Create;

  try
    TDecimateLog.LoadFromFile(FLogPath);

    for Counter := 0 to TDecimateLog.Count - 1 do
    begin
      Line := TDecimateLog[Counter];

      if Line = '' then
        Continue;

      FN := StrToIntDef(GetToken(Line, 0), -1);

      if FN >= 0 then
      begin
        DMetrics[FN] := StrToInt(GetToken(Line, 1));
        SCMetrics[FN] := StrToInt(GetToken(Line, 2));
      end;
    end;

    Outfile.Append('[DECIMATEMETRICS]');

    for Counter := 0 to FFramecount - 1 do
      Outfile.Append(IntToStr(DMetrics[Counter]));

  finally
    TDecimateLog.Free;
  end;
end;

constructor TTelecide.Create(Settings: string; Selected: Boolean);
begin
  inherited;

  with FSettings do
  begin
    Order := 1;
    Guide := 0;
    GThresh := 10;
    PostProcess := True;
    VThresh := 50;
    DThresh := 7;
    Blend := True;
    Show := True;
    Chroma := True;
    Back := 0;
    BThresh := 50;
    NT := 10;
    Y0 := 0;
    Y1 := 0;
  end;

  if Settings <> '' then
    HexToMemory(Settings, @FSettings);
end;

class function TTelecide.GetConfiguration: TYMCPluginConfig;
begin
  Result := pcVideo;
end;

class function TTelecide.GetPluginType: TYMCPluginType;
begin
  Result := ypMetricsCollector;
end;

class function TTelecide.GetSupportedColorSpaces: TColorSpaces;
begin
  Result := [csYV12, csYUY2];
end;

class function TTelecide.GetUsedFunctions: TStringDynArray;
begin
  SetLength(Result, 1);
  Result[0] := 'Telecide';
end;

{ TIT }

procedure TIT.Configure(Env: IAsifScriptEnvironment; Video: IAsifClip; out NewDefault: string);
begin
  with TITForm.Create(Env, Video, nil) do
  try
    OrderGroup.ItemIndex := FSettings.Order;
    OrderGroup.Hint := Format('Avisynth reports the correct order as %s but this is far from reliable for sources that aren''t d2v.', [IfThen(Video.GetVideoInfo.ImageType and 1 = 1, '0 (bff)', '1 (tff)')]);
    RefreshVideo;
    ShowModal;

    FSettings.Order := OrderGroup.ItemIndex;
    if MakeDefault.Checked then
      NewDefault := GetSettings;

  finally
    Free;
  end;
end;

constructor TIT.Create(Settings: string; Selected: Boolean);
begin
  inherited;
  FSettings.Order := StrToIntDef(Settings, 1);
end;

class function TIT.GetConfiguration: TYMCPluginConfig;
begin
  Result := pcVideo;
end;

class function TIT.GetName: string;
begin
  Result := 'IT';
end;

class function TIT.GetPluginType: TYMCPluginType;
begin
  Result := ypMetricsCollector;
end;

function TIT.GetSettings: string;
begin
  Result := IntToStr(FSettings.Order);
end;

class function TIT.GetSupportedColorSpaces: TColorSpaces;
begin
  Result := [csYUY2];
end;

class function TIT.GetUsedFunctions: TStringDynArray;
begin
  SetLength(Result, 1);
  Result[0] := 'IT';
end;

function TIT.Invoke(Env: IAsifScriptEnvironment; Video: IAsifClip; Preview: Boolean): IAsifClip;
begin
  FFramecount := Video.GetVideoInfo.NumFrames;

  with Env do
  begin
    ClipArg(Video);
    CharArg(PChar(IfThen(FSettings.Order = 1, 'TOP', 'BOTTOM')), 'ref');

    if not Preview then
    begin
      FLogPath := GetTempFile;
      DeleteFile(FLogPath);
      CharArg(PChar(FLogPath), 'log');
    end;

    Result := InvokeWithClipResult('IT')
  end;
end;

class function TIT.MTSafe: Boolean;
begin
  Result := True;
end;

procedure TIT.ProcessLog(Log, Outfile: TStrings;
  var Header: TYMCProjectHeader);
var
  FrameArray: array of TFrame;
  Counter, C2: integer;
  FN: Integer;
  ITLog: TStringList;
  Line: string;
begin
  with Header do
  begin
    ProjectType := 1;
    Order := FSettings.Order;
  end;

  SetLength(FrameArray, FFramecount + 25);

  ITLog := TStringList.Create;

  try
    ITLog.LoadFromFile(FLogPath);

    FN := 0;

    for Counter := 0 to ITLog.Count - 1 do
    begin
      for C2 := 0 to 4 do
      begin
        Line := ITLog[Counter];

        case UpCase(Line[9 + C2]) of
          'P': FrameArray[FN + C2].Match := 2;
          'C': FrameArray[FN + C2].Match := 1;
          'N': FrameArray[FN + C2].Match := 0;
        end;

        FrameArray[FN + C2].Decimate := UpCase(Line[15 + C2]) = 'D';
        FrameArray[FN + C2].PostProcess := Line[21 + C2] = 'I';
      end;

      Inc(FN, 5);
    end;

    with Outfile do
    begin
      Append('[MATCHES]');

      for Counter := 0 to FFramecount - 1 do
      begin
        case FrameArray[Counter].Match of
          0: Append('n');
          1: Append('c');
          2: Append('p');
        end;
      end;

      Append('');

      Append('[ORIGINALMATCHES]');

      for Counter := 0 to FFramecount - 1 do
      begin
        case FrameArray[Counter].Match of
          0: Append('n');
          1: Append('c');
          2: Append('p');
        end;
      end;

      Append('');

      Append('[POSTPROCESS]');

      for Counter := 0 to FFramecount - 1 do
      begin
        if FrameArray[Counter].PostProcess then
          Append(IntToStr(Counter));
      end;

      Append('');

      Append('[DECIMATE]');

      for Counter := 0 to FFramecount - 1 do
      begin
        if FrameArray[Counter].Decimate then
          Append(IntToStr(Counter));
      end;

    end;

    //DeleteFile(FLogPath);

  finally
    ITLog.Free;
  end;
end;

{ TTFMandTelecide }

class function TTFMAndTelecide.GetName: string;
begin
  Result := 'TFM+TelecideMetrics';
end;

class function TTFMAndTelecide.GetUsedFunctions: TStringDynArray;
begin
  Result := inherited GetUsedFunctions;
  SetLength(Result, Length(Result) + 1);
  Result[Length(Result) - 1] := 'Telecide';
end;

function TTFMAndTelecide.Invoke(Env: IAsifScriptEnvironment; Video: IAsifClip; Preview: Boolean): IAsifClip;
var
  TFMClip: IAsifClip;
  TelecideClip: IAsifClip;
  StackedClip: IAsifClip;
begin
  TFMClip := inherited Invoke(Env, Video, Preview);

  with Env do
    if not Preview then
    begin
      ClipArg(Video);

      if FSettings.Order = 0 then
        TelecideClip := InvokeWithClipResult('AssumeBFF')
      else
        TelecideClip := InvokeWithClipResult('AssumeTFF');

      ClipArg(TelecideClip);
      IntArg(1, 'post');
      BoolArg(True, 'debug');
      TelecideClip := InvokeWithClipResult('Telecide');

      ClipArg(TFMClip);
      ClipArg(TelecideClip);
      StackedClip := InvokeWithClipResult('StackVertical');

      ClipArg(StackedClip);
      IntArg(0);
      IntArg(0);
      IntArg(0);
      IntArg(TFMClip.GetVideoInfo.Height);

      Result := InvokeWithClipResult('Crop');
    end
    else
      Result := TFMClip;
end;

class function TTFMAndTelecide.MTSafe: Boolean;
begin
  Result := False;
end;

procedure TTFMAndTelecide.ProcessLog(Log: TStrings; Outfile: TStrings; var Header: TYMCProjectHeader);
var
  FrameArray: array of TSmallFrame;
  Counter: Integer;
  FN: Integer;
  Line, Wt: string;
begin
  InternalProcessLog(Log, Outfile, Header, False);

  SetLength(FrameArray, FFramecount + 25);

  for Counter := 0 to Log.Count - 1 do
  begin
    Line := Log[Counter];

    if AnsiContainsStr(Line, 'Telecide:') then
    begin
      Wt := GetToken(Line, 2);
      FN := StrToInt(LeftStr(Wt, Length(Wt) - 1));

      if AnsiContainsStr(Line, 'using') then
          //not interesting
      else if AnsiContainsStr(Line, 'matches') then
      begin
        FrameArray[FN].MMetric[2] := StrToInt(GetToken(Line, 4));
        FrameArray[FN].MMetric[1] := StrToInt(GetToken(Line, 5));
        FrameArray[FN].MMetric[0] := StrToInt(GetToken(Line, 6));
      end
      else if AnsiContainsStr(Line, 'vmetrics') then
      begin
        FrameArray[fn].VMetric[2] := StrToInt(GetToken(Line, 4));
        FrameArray[fn].VMetric[1] := StrToInt(GetToken(Line, 5));
        FrameArray[fn].VMetric[0] := StrToInt(GetToken(Line, 6));
      end;
    end;
  end;

  Outfile.Append('[METRICS]');
  for Counter := 0 to FFramecount - 1 do
    with FrameArray[Counter] do
      Outfile.Append(Format('%d %d %d %d %d %d', [MMetric[0], MMetric[1], MMetric[2], VMetric[0], VMetric[1], VMetric[2]]));
  Outfile.Append('');

  DeleteFile(FLogPath);
end;

{ TSClavc }

constructor TSClavc.Create(Settings: string; Selected: Boolean);
begin
  inherited;

  with FSettings do
  begin
    PreMe := 1;
    Cmp := 0;
    SubCmp := 0;
    MBCmp := 0;
    Dia := 1;
    PreDia := 1;
    V4MV := False;
    LogOutput := '';
  end;

  if Settings <> '' then
    HexToMemory(Settings, @FSettings);
end;

class function TSClavc.GetConfiguration: TYMCPluginConfig;
begin
  Result := pcNormal;
end;

class function TSClavc.GetPluginType: TYMCPluginType;
begin
  Result := ypMetricsCollector;
end;

function TSClavc.GetSettings: string;
begin
  Result := MemoryToHex(@FSettings, SizeOf(FSettings));
end;

class function TSClavc.GetSupportedColorSpaces: TColorSpaces;
begin
  Result := [csYV12];
end;

class function TSClavc.GetUsedFunctions: TStringDynArray;
begin
  SetLength(Result, 1);
  Result[0] := 'SClavc';
end;

procedure TSClavc.ProcessLog(Log: TStrings; Outfile: TStrings; var Header: TYMCProjectHeader);
var
  Counter: Integer;
  SCLavcLog: TStringList;
  TS: string;
  Line: string;
begin
  SCLavcLog := TStringList.Create;

  try
    SCLavcLog.LoadFromFile(FLogPath);

    Outfile.Append('[SECTIONS]');

    for Counter := 0 to SCLavcLog.Count - 1 do
    begin
      Line := SCLavcLog[Counter];

      if not AnsiStartsStr('#', Line) then
      begin
        TS := GetToken(Line, 12);
        TS := RightStr(TS, Length(TS) - AnsiPos(':', TS));
        TS := LeftStr(TS, Length(TS) - 1);

        if StrToInt(TS) > 0.85 * FBlockCount then
        begin
          TS := GetToken(Line, 0);
          Outfile.Append(RightStr(TS, Length(TS) - AnsiPos(':', TS)) + ',0');
        end;
      end;
    end;
  finally
    SCLavcLog.Free;
  end;

  if FSettings.LogOutput <> '' then
    CopyFile('', FSettings.LogOutput, False);

  DeleteFile(FLogPath);
end;

procedure TSClavc.Configure(Env: IAsifScriptEnvironment; Video: IAsifClip; out NewDefault: string);
begin
  with TSClavcForm.Create(nil), FSettings do
  try
    CmpGroup.ItemIndex := Cmp;
    PreMeGroup.ItemIndex := PreMe;
    SubCmpGroup.ItemIndex := SubCmp;
    MbCmpGroup.ItemIndex := MBCmp;
    V4MVCheckbox.Checked := V4MV;
    LogEdit.Text := LogOutput;
    DiaEdit.Text := IntToStr(Dia);
    PreDiaEdit.Text := IntToStr(PreDia);
    ShowModal;

    Cmp := CmpGroup.ItemIndex;
    PreMe := PreMeGroup.ItemIndex;
    SubCmp := SubCmpGroup.ItemIndex;
    MBCmp := MbCmpGroup.ItemIndex;
    V4MV := V4MVCheckbox.Checked;
    StrCopy(LogOutput, PChar(LogEdit.Text));
    Dia := strtointdef(DiaEdit.Text, 1);
    PreDia := strtointdef(PreDiaEdit.Text, 1);

    if MakeDefault.Checked then
      NewDefault := GetSettings;

  finally
    Free;
  end;
end;

class function TSClavc.GetName: string;
begin
  Result := 'SClavc';
end;

function TSClavc.Invoke(Env: IAsifScriptEnvironment; Video: IAsifClip; Preview: Boolean): IAsifClip;
begin
  with Video.GetVideoInfo do
    FBlockCount := ((Width + 15) div 16) * ((Height + 15) div 16);

  if Preview then
    Result := Video
  else
    with Env, FSettings do
    begin
      ClipArg(Video);
      IntArg(MBCmp, 'mbcmp');
      IntArg(Cmp, 'cmp');
      IntArg(SubCmp, 'subcmp');
      IntArg(PreMe, 'preme');
      IntArg(Dia, 'dia');
      IntArg(PreDia, 'predia');
      BoolArg(V4MV, 'v4mv');

      FLogPath := GetTempFile;
      CharArg(PChar(FLogPath), 'log');

      Result := InvokeWithClipResult('SClavc');
    end;
end;

class function TSClavc.MTSafe: Boolean;
begin
  Result := True;
end;

{ TSCXvid }

procedure TSCXvid.Configure(Env: IAsifScriptEnvironment; Video: IAsifClip;
  out NewDefault: string);
begin
  with TSCXvidForm.Create(nil), FSettings do
  try
    LogEdit.Text := LogOutput;

    ShowModal;

    LogOutput := LogEdit.Text;

    if MakeDefault.Checked then
      NewDefault := GetSettings;
  finally
    Free;
  end;
end;

constructor TSCXvid.Create(Settings: string; Selected: Boolean);
begin
  inherited;

  FSettings.LogOutput := '';
  if Settings <> '' then
    FSettings.LogOutput := Settings;
end;

class function TSCXvid.GetConfiguration: TYMCPluginConfig;
begin
  Result := pcNormal;
end;

class function TSCXvid.GetName: string;
begin
  Result := 'SCXvid';
end;

class function TSCXvid.GetPluginType: TYMCPluginType;
begin
  Result := ypMetricsCollector;
end;

function TSCXvid.GetSettings: string;
begin
  Result := FSettings.LogOutput;
end;

class function TSCXvid.GetSupportedColorSpaces: TColorSpaces;
begin
  Result := [csYV12, csYUY2, csRGB24, csRGB32];
end;

class function TSCXvid.GetUsedFunctions: TStringDynArray;
begin
  SetLength(Result, 1);
  Result[0] := 'SCXvid';
end;

function TSCXvid.Invoke(Env: IAsifScriptEnvironment; Video: IAsifClip;
  Preview: Boolean): IAsifClip;
begin
  if not Preview then
    with Env do
    begin
      ClipArg(Video);
      FLogPath := GetTempFile;
      CharArg(PChar(FLogPath), 'log');
      Result := InvokeWithClipResult('SCXvid');
    end
  else
    Result := Video;
end;

class function TSCXvid.MTSafe: Boolean;
begin
  Result := True;
end;

procedure TSCXvid.ProcessLog(Log, Outfile: TStrings;
  var Header: TYMCProjectHeader);
var
  I: Integer;
  SCXvidLog: TStringList;
  Line: string;
begin
  SCXvidLog := TStringList.Create;

  try
    SCXvidLog.LoadFromFile(FLogPath);

    Outfile.Append('[SECTIONS]');

    for I := SCXvidLog.Count - 1 downto 0 do
      if (SCXvidLog[I] = '') or (SCXvidLog[I][1] = '#') then
        SCXvidLog.Delete(I);

    for I := 0 to SCXvidLog.Count - 1 do
    begin
      Line := SCXvidLog[I];

      if Line[1] = 'i' then
        Outfile.Append(IntToStr(I) + ',0');
    end;
  finally
    SCXvidLog.Free;
  end;

  if FSettings.LogOutput <> '' then
    CopyFile(PChar(FLogPath), PChar(FSettings.LogOutput), False);

  DeleteFile(FLogPath);
end;

{ TCutter }

constructor TCutter.Create(Settings: string; Selected: Boolean);
var
  Offset: Integer;
  StartToken: string;
  EndToken: string;
begin
  inherited;
  Offset := 1;
  while True do
  begin
    StartToken := GetNextToken(Settings, Offset, [',']);
    EndToken := GetNextToken(Settings, Offset, [',']);
    if (StartToken = '') or (EndToken = '') then
      Break;
    SetLength(FSettings.Cuts, Length(FSettings.Cuts) + 1);
    with FSettings.Cuts[Length(FSettings.Cuts) - 1] do
    begin
      CutStart := StrToInt(StartToken);
      CutEnd := StrToInt(EndToken);
    end;
  end;
end;

procedure TCutter.Configure(Env: IAsifScriptEnvironment; Video: IAsifClip;
  out NewDefault: string);
var
  I: Integer;
begin
  with TCutterForm.Create(Env, Video, nil) do
  try
    for I := 0 to Length(FSettings.Cuts) - 1 do
      with FSettings.Cuts[I] do
        CutListBox.AddItem(Format('%d,%d', [CutStart, CutEnd]), Cutter.TCutRange.Create(CutStart, CutEnd));

    FrameTrackbarChange(nil);
    ShowModal;

    SetLength(FSettings.Cuts, CutListBox.Count);
    for I := 0 to CutListBox.Count - 1 do
      with FSettings.Cuts[I] do
      begin
        CutStart := (CutListBox.Items.Objects[I] as Cutter.TCutRange).CutStart;
        CutEnd := (CutListBox.Items.Objects[I] as Cutter.TCutRange).CutEnd;
        CutListBox.Items.Objects[I].Free;
      end;
  finally
    Free;
  end;
end;

class function TCutter.GetConfiguration: TYMCPluginConfig;
begin
  Result := pcVideo;
end;

class function TCutter.GetName: string;
begin
  Result := 'Cutter';
end;

class function TCutter.GetPluginType: TYMCPluginType;
begin
  Result := ypMetricsCollector;
end;

function TCutter.GetSettings: string;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to Length(Fsettings.Cuts) - 1 do
    with FSettings.Cuts[I] do
      Result := Result + Format('%d,%d,', [CutStart, CutEnd]);
  Result := LeftStr(Result, Length(Result) - 1);
end;

class function TCutter.GetSupportedColorSpaces: TColorSpaces;
begin
  Result := [csYV12, csYUY2, csRGB24, csRGB32];
end;

class function TCutter.GetUsedFunctions: TStringDynArray;
begin
  SetLength(Result, 1);
  Result[0] := 'Trim';
end;

function TCutter.Invoke(Env: IAsifScriptEnvironment; Video: IAsifClip;
  Preview: Boolean): IAsifClip;
var
  TempTrims: array of IAsifClip;
  I: Integer;
begin
  FFramecount := Video.GetVideoInfo.NumFrames;

  with Env do
    if Length(FSettings.Cuts) = 0 then
      Result := Video
    else
    begin
      SetLength(TempTrims, 0);

      // first cut
      if FSettings.Cuts[0].CutStart > 0 then
      begin
        SetLength(TempTrims, Length(TempTrims) + 1);
        ClipArg(Video);
        IntArg(0);
        IntArg(FSettings.Cuts[0].CutStart - 1);
        TempTrims[0] := InvokeWithClipResult('Trim');
      end;
      
      // middle cuts
      for I := 0 to Length(FSettings.Cuts) - 2 do
      begin
        SetLength(TempTrims, Length(TempTrims) + 1);
        ClipArg(Video);
        IntArg(FSettings.Cuts[I].CutEnd + 1);
        IntArg(FSettings.Cuts[I + 1].CutStart - 1);
        TempTrims[Length(TempTrims) - 1] := InvokeWithClipResult('Trim');
      end;

      // final cut
      if FSettings.Cuts[Length(FSettings.Cuts) - 1].CutEnd < Video.GetVideoInfo.NumFrames - 1 then
      begin
        SetLength(TempTrims, Length(TempTrims) + 1);
        ClipArg(Video);
        IntArg(FSettings.Cuts[Length(FSettings.Cuts) - 1].CutEnd + 1);
        IntArg(0);
        TempTrims[Length(TempTrims) - 1] := InvokeWithClipResult('Trim');
      end;

      if Length(TempTrims) = 0 then
        raise EYMCPluginException.Create('Nothing left after cutting');

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

class function TCutter.MTSafe: Boolean;
begin
  Result := True;
end;

procedure TCutter.ProcessLog(Log, Outfile: TStrings;
  var Header: TYMCProjectHeader);
begin
  if Header.FrameCount <= 0 then
    Header.FrameCount := FFramecount;
  Header.CutList := Settings;
end;

{ TResize }

procedure TResize.Configure(Env: IAsifScriptEnvironment; Video: IAsifClip;
  out NewDefault: string);
  var Index: Integer;
begin
  with TResizeForm.Create(nil), FSettings do
  begin
    WidthEdit.Text := IntToStr(Width);
    HeightEdit.Text := IntToStr(Height);
    Index := ResizerGroup.Items.IndexOf(Resizer);
    ResizerGroup.ItemIndex := Max(Index, 0);

    ShowModal;

    Width := StrToIntDef(WidthEdit.Text, Width);
    Height := StrToIntDef(HeightEdit.Text, Height);
    Resizer := ResizerGroup.Items[ResizerGroup.Itemindex];

    if MakeDefault.Checked then
      NewDefault := GetSettings;

    Free;
  end;
end;

constructor TResize.Create(Settings: string; Selected: Boolean);
begin
  inherited;
  FSettings.Width := StrToIntDef(GetToken(Settings, 0, [',']), 720);
  FSettings.Height := StrToIntDef(GetToken(Settings, 1, [',']), 480);
  FSettings.Resizer := GetToken(Settings, 2, [',']);
end;

class function TResize.GetConfiguration: TYMCPluginConfig;
begin
  Result := pcNormal;
end;

class function TResize.GetName: string;
begin
  Result := 'Resize';
end;

class function TResize.GetPluginType: TYMCPluginType;
begin
  Result := ypVideoFilter;
end;

function TResize.GetSettings: string;
begin
  Result := Format('%d,%d,%s', [FSettings.Width, FSettings.Height, FSettings.Resizer]);
end;

class function TResize.GetSupportedColorSpaces: TColorSpaces;
begin
  Result := [csYV12, csYUY2, csRGB24, csRGB32];
end;

class function TResize.GetUsedFunctions: TStringDynArray;
begin
  SetLength(Result, 0);
end;

function TResize.Invoke(Env: IAsifScriptEnvironment; Video: IAsifClip;
  Preview: Boolean): IAsifClip;
begin
  Env.ClipArg(Video);
  Env.IntArg(FSettings.Width);
  Env.IntArg(FSettings.Height);
  Result := Env.InvokeWithClipResult(FSettings.Resizer);
end;

class function TResize.MTSafe: Boolean;
begin
  Result := True;
end;

{ TENPipe }

procedure TENPipe.Configure(Env: IAsifScriptEnvironment; Video: IAsifClip;
  out NewDefault: string);
begin

end;

constructor TENPipe.Create(Settings: string; Selected: Boolean);
begin
  inherited;

  FSettings.WaitMS := StrToIntDef(GetToken(Settings, 0, [',']), 2000);
  FSettings.Y4M := StrToBoolDef(GetToken(Settings, 1, [',']), false);
  FSettings.VideoCL := GetToken(Settings, 3, [',']);
  FSettings.AudioCL := GetToken(Settings, 4, [',']);
end;

class function TENPipe.GetConfiguration: TYMCPluginConfig;
begin
  Result := pcNormal;
end;

class function TENPipe.GetName: string;
begin
  Result := 'ENPipe';
end;

class function TENPipe.GetPluginType: TYMCPluginType;
begin
  Result := ypMetricsCollector;
end;

function TENPipe.GetSettings: string;
begin

end;

class function TENPipe.GetSupportedColorSpaces: TColorSpaces;
begin
  Result := [csYV12, csYUY2, csRGB24, csRGB32];
end;

class function TENPipe.GetUsedFunctions: TStringDynArray;
begin
  SetLength(Result, 1);
  Result[0] := 'ENPipe';
end;

function TENPipe.Invoke(Env: IAsifScriptEnvironment; Video: IAsifClip;
  Preview: Boolean): IAsifClip;
var
  VTemp, ATemp: string;
  VI: VideoInfo;
begin
  if Preview then
    Result := Video
  else
    with Env, FSettings do
    begin
      VI := Video.GetVideoInfo;
      VTemp := VideoCL;
      VTemp := AnsiReplaceStr(VTemp, '$width$', IntToStr(VI.Width));
      VTemp := AnsiReplaceStr(VTemp, '$height$', IntToStr(VI.Height));
      ATemp := AudioCL;

      ClipArg(Video);
      CharArg(PChar(VTemp), 'videocl');
      CharArg(PChar(ATemp), 'audiocl');
      IntArg(WaitMS, 'waitms');
      BoolArg(Y4M, 'y4m');

      Result := InvokeWithClipResult('ENPipe');
    end;
end;

class function TENPipe.MTSafe: Boolean;
begin
  Result := True;
end;

end.
