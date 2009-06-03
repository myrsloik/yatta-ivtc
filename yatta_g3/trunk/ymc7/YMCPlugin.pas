unit YMCPlugin;

interface

uses
  Windows, Forms, SysUtils, Types, Classes, Asif;

type
  EYMCException = class(Exception);
  EYMCPluginException = class(EYMCException);

  TYMCPluginClass = class of TYMCPlugin;
  TYMCPluginClassDynArray = array of TYMCPluginClass;

  TMpeg2Decoder = (mdMpeg2Dec3 = 0, mdDGDecode = 1);
  TPostProcessor = (ppDecombBlend = 0, ppDecombInterpolate = 1, ppKernelDeint = 2, ppLeakKernelDeint = 3, ppSangnom = 4, ppTDeint = 5);

  TYMCProjectHeader = record
    ProjectType: 0..1;
    Order: 0..1;
    FrameCount: Integer;
    Decoder: TMpeg2Decoder;
    PostProcessor: TPostProcessor;
    CutList: string;
  end;

  TYMCPluginConfig = (pcNone = 0, pcNormal = 1, pcVideo = 2);
  TYMCPluginType = (ypMetricsCollector, ypVideoFilter);
  TColorSpace = (csNone, csYV12, csYUY2, csRGB24, csRGB32);
  TColorSpaces = set of TColorSpace;

  TYMCPlugin = class(TObject)
  protected
    FSelected: Boolean;

    function GetSettings: string; virtual;
  public
    constructor Create(Settings: string; Selected: Boolean); virtual;
    procedure Configure(Env: IAsifScriptEnvironment; Video: IAsifClip; out NewDefault: string); virtual;
    function Invoke(Env: IAsifScriptEnvironment; Video: IAsifClip; Preview: Boolean): IAsifClip; virtual; abstract;
    procedure ProcessLog(Log: TStrings; Outfile: TStrings; var Header: TYMCProjectHeader); virtual;

    class function GetConfiguration: TYMCPluginConfig; virtual;
    class function GetName: string; virtual; abstract;
    class function GetPluginType: TYMCPluginType; virtual; abstract;
    class function GetSupportedColorSpaces: TColorSpaces; virtual; abstract;
    class function GetUsedFunctions: TStringDynArray; virtual; abstract;
    class function GetTempFile: string; virtual;
    class function MTSafe: Boolean; virtual;

    property Settings: string read GetSettings;
    property Selected: Boolean read FSelected write FSelected;
  end;

  TYMCPluginDynArray = array of TYMCPlugin;

  TAddPlugin = procedure(Plugin: TYMCPluginClass);

implementation

var
  TempFiles: TStringList = nil;

{ TYMCPlugin }

constructor TYMCPlugin.Create(Settings: string; Selected: Boolean);
begin
  FSelected := Selected;
end;

procedure TYMCPlugin.ProcessLog(Log: TStrings; Outfile: TStrings; var Header: TYMCProjectHeader);
begin
  raise EYMCPluginException.Create('The plugin ' + GetName + ' is a metrics collector but has no log processing.');
end;

class function TYMCPlugin.GetConfiguration: TYMCPluginConfig;
begin
  Result := pcNone;
end;

function TYMCPlugin.GetSettings: string;
begin
  Result := '';
end;

procedure TYMCPlugin.Configure(Env: IAsifScriptEnvironment;
  Video: IAsifClip; out NewDefault: string);
begin
  raise EYMCPluginException.Create('The plugin ' + GetName + ' has no configuration.');
end;

class function TYMCPlugin.MTSafe: Boolean;
begin
  Result := False;
end;

class function TYMCPlugin.GetTempFile: string;
begin
  SetLength(Result, MAX_PATH + 1);
  GetTempFileName(PChar(ExtractFilePath(Application.ExeName)), 'YMC', 0, PChar(Result));
  Result := PChar(Result);
  TempFiles.Append(Result);
end;

initialization
  TempFiles := nil;
  TempFiles := TStringList.Create;
finalization
  if Assigned(TempFiles) then
  begin
    while TempFiles.Count > 0 do
    begin
      DeleteFile(TempFiles[0]);
      TempFiles.Delete(0);
    end;
    TempFiles.Free;
  end;
end.
