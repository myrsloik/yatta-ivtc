unit YattaVideo;

interface

uses
  Asif, Graphics, YShared, SysUtils, FrameDiff, GR32, AsifAdditions;

type
  EVideoException = class(Exception);

  TVideo = class(TObject)
  private
    FEnv: IAsifScriptEnvironment;

    FSourceVideo: IAsifClip;
    FRGB32Video: IAsifClip;

    FVideoFilename: string;
    FScript: string;

    function OpenVideo(Filename: string; PluginPath: string; Mpeg2Dec: TMpeg2Decoder): IAsifClip;
    procedure CloseVideo;
    procedure AddCache(var Video: IAsifClip);
    function GetVideoInfo: VideoInfo;
    function GetRGB32Video: IAsifClip;
  public
    constructor Create(Filename: string; PluginPath: string; Mpeg2Dec: TMpeg2Decoder);
    destructor Destroy; override;

    procedure BindToVariable(const Name: string);
    procedure GetFrame(Frame: Integer; Output: TBitmap32); overload;
    procedure GetFrame(Frame: TMatch; Output: TBitmap32); overload;

    function CalculateDMetric(Frame1, Frame2: TMatch): Integer;

    property Script: string read FScript;
    property Env: IAsifScriptEnvironment read FEnv;
    property VideoFilename: string read FVideoFilename;
    property VideoInfo: VideoInfo read GetVideoInfo;
    property SourceVideo: IAsifClip read FSourceVideo;
    property RGB32Video: IAsifClip read GetRGB32Video;
  end;

implementation

{ TVideo }

procedure TVideo.AddCache(var Video: IAsifClip);
begin
  FEnv.ClipArg(Video);
  Video := FEnv.InvokeWithClipResult('Cache');
end;

procedure TVideo.BindToVariable(const Name: string);
var
  SV: AVSValueStruct;
begin
  SV.AVSType := 1;
  SV.ClipVal := FSourceVideo.GetClipPointer;
  FEnv.SetVar('YattaVideoSource', SV);
end;

function TVideo.CalculateDMetric(Frame1, Frame2: TMatch): Integer;
begin
  Result := FramediffMetric(Frame1, Frame2, SourceVideo);
end;

procedure TVideo.CloseVideo;
begin
  FRGB32Video := nil;
  FSourceVideo := nil;
  FEnv := nil;
end;

constructor TVideo.Create(Filename: string; PluginPath: string; Mpeg2Dec: TMpeg2Decoder);
var
  TempVideo: IAsifClip;
begin
  FVideoFilename := '';
  FEnv := TAsifScriptEnvironment.Create;

  try
    TempVideo := OpenVideo(Filename, PluginPath, Mpeg2Dec);
    if FEnv.FunctionExists('SetPlanarLegacyAlignment') and (Mpeg2Dec = mdMpeg2Dec3) then
    begin
      FEnv.ClipArg(TempVideo);
      FEnv.BoolArg(True);
      TempVideo := FEnv.InvokeWithClipResult('SetPlanarLegacyAlignment');
    end;

    FSourceVideo := TempVideo;
    AddCache(FSourceVideo);

    FVideoFilename := Filename;
  except
    CloseVideo;
    raise;
  end;
end;

destructor TVideo.Destroy;
begin
  CloseVideo;
  inherited;
end;

procedure TVideo.GetFrame(Frame: Integer; Output: TBitmap32);
begin
  FullFrame(Frame, RGB32Video, Output);
end;

procedure TVideo.GetFrame(Frame: TMatch; Output: TBitmap32);
begin
  if Frame.Top = Frame.Bottom then
    GetFrame(Frame.Top, Output)
  else
    FieldAssemble(Frame.Top, Frame.Bottom, RGB32Video, Output);
end;

function TVideo.GetRGB32Video: IAsifClip;
begin
  if FRGB32Video = nil then
  begin
    FEnv.ClipArg(FSourceVideo);
    FEnv.BoolArg(True, 'interlaced');
    FRGB32Video := FEnv.InvokeWithClipResult('ConvertToRGB32');
    AddCache(FRGB32Video);
  end;

  Result := FRGB32Video;
end;

function TVideo.GetVideoInfo: VideoInfo;
begin
  Result := SourceVideo.GetVideoInfo;
end;

function TVideo.OpenVideo(Filename: string; PluginPath: string; Mpeg2Dec: TMpeg2Decoder): IAsifClip;
var
  FilenameExt: string;
  Prefix: string;
begin
  FilenameExt := AnsiLowerCase(ExtractFileExt(FileName));

  if FilenameExt = '.d2v' then
  begin
    if Mpeg2Dec = mdDGDecode then
      Prefix := 'DGDecode'
    else if Mpeg2Dec = mdMpeg2Dec3 then
      Prefix := 'Mpeg2Dec3'
    else
      raise EVideoException.Create('No mpeg2 decoder selected');

    LoadPlugins(Prefix + '_Mpeg2Source', PluginPath, FEnv);
    FEnv.CharArg(PChar(Filename));
    Result := FEnv.InvokeWithClipResult(Prefix + '_Mpeg2Source');
    FScript := Format(Prefix + '_Mpeg2Source("%s")', [Filename]);
    if FEnv.FunctionExists('SetPlanarLegacyAlignment') and (Mpeg2Dec = mdMpeg2Dec3) then
      FScript := FScript + #13#10 + 'SetPlanarLegacyAlignment(true)';
  end
  else if AnsiLowerCase(ExtractFileExt(FileName)) = '.avs' then
  begin
    FEnv.CharArg(PChar(Filename));
    Result := FEnv.InvokeWithClipResult('Import');
    FScript := Format('Import("%s")', [Filename]);
  end
  else if AnsiLowerCase(ExtractFileExt(FileName)) = '.avi' then
  begin
    FEnv.CharArg(PChar(Filename));
    Result := FEnv.InvokeWithClipResult('AviSource');
    FScript := Format('AviSource("%s")', [Filename]);
  end
  else
    raise EVideoException.Create('Unknown file extension, ' + FilenameExt + ' not supported');
end;

end.

