unit YattaProject;

interface

uses
  SysUtils, Classes, StrUtils, Math, Types, BitsExt,
  Contnrs, MarkerLists, YSort, YShared, YattaVideo,
  Framediff, IniFiles, Asif, AsifAdditions;

type
  EYattaProjectException = class(Exception);
  EMissingPresetException = class(EYattaProjectException);
  EMissingMetricsException = class(EYattaProjectException);

  TFrameFlag = (ffPostprocess, ffDecimate);
  TFrameFlags = set of TFrameFlag;
  TFieldOrder = (foAuto = -1, foBFF = 0, foTFF = 1);
  TMetricMode = (mmNone = 0, mm3Way = 3, mm5way = 5);
  TScriptOptions = set of (soLoadPlugin, soPreview);

  TFrame = record
    Match: TMatch;
    OriginalMatch: TMatch;
    DMetric: Integer;
    Flags: TFrameFlags;
  end;

  TFrameDynArray = array of TFrame;

  TYattaProject = class;

  TDMetricThread = class(TThread)
  private
    FOwner: TYattaProject;
    FVideo: TVideo;
  protected
    procedure Execute; override;
  public
    constructor Create(AOwner: TYattaProject; AVideo: TVideo);
    destructor Destroy; override;
  end;

  TYattaMetrics = class(TObject)
  protected
    FMetricMode: TMetricMode;
    FMatchOrder: TFieldOrder;
    FMetricOrder: TFieldOrder;
    FMetricCount: Integer;
    FUMetrics: TIntegerDynArray;
    FBMetrics: TIntegerDynArray;
    FCMetrics: TIntegerDynArray;
    FNMetrics: TIntegerDynArray;
    FPMetrics: TIntegerDynArray;

    function GetMetric(AFrame: Integer; AMatch: AnsiChar): Integer;
  public
    constructor Create(AMatchOrder: TFieldOrder; AMetrics: TStrings = nil); overload;
    constructor Create; overload;
    procedure AsText(AOutput: TStrings);

    property MetricMode: TMetricMode read FMetricMode;
    property Metrics[Frame: Integer; Match: AnsiChar]: Integer read GetMetric; default;
    property MetricOrder: TFieldOrder read FMetricOrder;
    property MatchOrder: TFieldOrder read FMatchOrder write FMatchOrder;
  end;

  TYattaProject = class(TObject)
  private
    FVideo: TVideo;
    FProjectFilename: string;
    FSavedBy: string;
    FPluginPath: string;

    FFieldOrder: TFieldOrder;
    FFramecount: Integer;
    FFrames: TFrameDynArray;
    FFramerate: Double;

    FMMetrics: TYattaMetrics;
    FVMetrics: TYattaMetrics;

    FLayers: TLayerList;
    FPresets: TPresetList;
    FDecimates: TDecimationMarkerList;
    FFreezeFrames: TFreezeFrameMarkerList;

    FCutStart: Integer;
    FCutEnd: Integer;

    FMpeg2Dec: TMpeg2Decoder;
    FMetricThread: TDMetricThread;

    procedure OpenVideo(Filename: string);
    function CalculateDMetric(Frame: Integer; Video: TVideo): Integer;
    procedure SetCollectDMetrics(Collect: Boolean);
    function GetCollectDMetrics: Boolean;
    procedure OpenV3Project(const ProjectIni: TMemIniFile);
    procedure OpenV2Project(const ProjectIni: TMemIniFile);
    procedure DestroyData;
////////////////////////////////////////////////////////////////////////////////
// Frame functions
    function GetDMetric(Frame: Integer): Integer;
    procedure SetFrameCount(Count: Integer);
    function GetMatch(Frame: Integer): TMatch;
    procedure SetMatch(Frame: Integer; Match: TMatch);
    function GetOriginalMatch(Frame: Integer): TMatch;
    procedure SetOriginalMatch(Frame: Integer; Match: TMatch);
    function GetMatchChanged(Frame: Integer): Boolean;
    function GetDecimate(Frame: Integer): Boolean;
    procedure SetDecimate(Frame: Integer; State: Boolean);
    function GetPostprocess(Frame: Integer): Boolean;
    procedure SetPostprocess(Frame: Integer; State: Boolean);
    function GetMatchChar(Frame: Integer): Char;
    procedure SetMatchChar(Frame: Integer; MatchChar: Char);
    function GetFFMatch(Index: Integer): TMatch;
  public
    constructor Create(ApplicationName: string; PluginPath: string; Filename: string; Mpeg2Dec: TMpeg2Decoder = mdNone);
    destructor Destroy; override;

////////////////////////////////////////////////////////////////////////////////
// Main properties
    property Video: TVideo read FVideo;
    property Layers: TLayerList read FLayers;
    property Presets: TPresetList read FPresets;
    property Decimates: TDecimationMarkerList read FDecimates;
    property FreezeFrames: TFreezeFrameMarkerList read FFreezeFrames;

////////////////////////////////////////////////////////////////////////////////
// Mixed junk
    function GetDecimatedPos(Frame: Integer): Integer; overload;
    function GetDecimatedPos(Frame: Integer; var ADecimated: Boolean): Integer; overload;

    procedure ResetMatch(FromFrame, ToFrame: Integer);

    property FieldOrder: TFieldOrder read FFieldOrder write FFieldOrder;
    property Framerate: Double read FFramerate;
    property Framecount: Integer read FFramecount write SetFrameCount;
    property MMetrics: TYattaMetrics read FMMetrics;
    property VMetrics: TYattaMetrics read FVMetrics;
    property DMetric[index: Integer]: Integer read GetDMetric;
    property Match[index: Integer]: TMatch read GetMatch write SetMatch;
    property FFMatch[index: Integer]: TMatch read GetFFMatch;
    property OriginalMatch[index: Integer]: TMatch read GetOriginalMatch write SetOriginalMatch;
    property MatchChanged[index: Integer]: Boolean read GetMatchChanged;
    property MatchChar[index: Integer]: Char read GetMatchChar write SetMatchChar;
    property CollectDMetrics: Boolean read GetCollectDMetrics write SetCollectDMetrics;
    property Decimated[Frame: Integer]: Boolean read GetDecimate write SetDecimate;
    property Postprocessed[Frame: Integer]: Boolean read GetPostprocess write SetPostprocess;
    property ProjectFilename: string read FProjectFilename;
    property CutStart: Integer read FCutStart write FCutStart;
    property CutEnd: Integer read FCutEnd write FCutEnd;

////////////////////////////////////////////////////////////////////////////////
// Output generation
    procedure GenerateAvisynthScript(Output: TStrings; Options: TScriptOptions = []);
    procedure GenerateFieldHints(Output: TStrings);
    procedure GenerateVFR(Output: TStrings);

    procedure SaveProject(Filename: string = ''; SetProjectFilename: Boolean = True);
    procedure SaveAvisynthScript(Filename: string = '');
    procedure SaveFieldHints(Filename: string = '');
    procedure SaveTimecodes(Filename: string = '');
  end;

implementation

{ TDMetricThread }

constructor TDMetricThread.Create(AOwner: TYattaProject; AVideo: TVideo);
begin
  inherited Create(False);
  FreeOnTerminate := False;
  FOwner := AOwner;
  FVideo := AVideo;
  Priority := tpIdle;
end;

destructor TDMetricThread.Destroy;
begin
  FVideo.Free;
  inherited;
end;

procedure TDMetricThread.Execute;
var
  Frame: Integer;
  Framecount: Integer;
begin
  Frame := 0;
  Framecount := FVideo.SourceVideo.GetVideoInfo.NumFrames;

  repeat
{$IFDEF DMetricDebug}
    Writeln(Frame, ' ', FOwner.CalculateDMetric(Frame, FVideo));
{$ELSE}
    FOwner.CalculateDMetric(Frame, FVideo);
{$ENDIF}
    Inc(Frame);

    if Frame >= Framecount then
    begin
      Frame := 0;
      Sleep(100);
    end;
  until Terminated;
end;

{ TProject }

procedure TYattaProject.OpenV3Project(const ProjectIni: TMemIniFile);
var
  I, J: Integer;
  IniSection: TStringList;
  TempFramecount: Integer;
  TempName, TempType, TempProcessing: string;
  TempVideo: string;
  TempId: Integer;
  Index: Integer;
  Line: string;
  Offset: Integer;
begin
  IniSection := TStringList.Create;
  with ProjectIni do
  try
    TempFramecount := ReadInteger(MainProjectSection, 'Framecount', -1);
    if TempFramecount < 0 then
      raise EYattaProjectException.Create('Invalid number of frames specified in project');

    TempVideo := ReadString(MainProjectSection, 'Video', '');
    if (TempVideo = '') then
      raise EYattaProjectException.Create('No video specified in project');

    OpenVideo(TempVideo);

    if Video.VideoInfo.NumFrames <> TempFramecount then
      raise EYattaProjectException.Create('Framecount mismatch between project and video');

    Framecount := TempFramecount;

    FieldOrder := TFieldOrder(ReadInteger(MainProjectSection, 'Order', Integer(foBFF)));

    ReadSectionValues('Matches', IniSection);
    for I := 0 to Min(Framecount, IniSection.Count) - 1 do
    begin
      Line := IniSection[I];
      Match[I] := M(StrToInt(GetToken(Line, 0, [','])), StrToInt(GetToken(Line, 1, [','])));
    end;

    ReadSectionValues('Original Matches', IniSection);
    for I := 0 to Min(Framecount, IniSection.Count) - 1 do
    begin
      Line := IniSection[I];
      OriginalMatch[I] := M(StrToInt(GetToken(Line, 0, [','])), StrToInt(GetToken(Line, 1, [','])));
    end;

    ReadSectionValues('DMetrics', IniSection);
    for I := 0 to Min(Framecount, IniSection.Count) - 1 do
      FFrames[I].DMetric := StrToInt(IniSection[I]);

    ReadSectionValues('Decimate', IniSection);
    for I := 0 to IniSection.Count - 1 do
      Decimated[StrToInt(IniSection[I])] := True;

    ReadSectionValues('Postprocess', IniSection);
    for I := 0 to IniSection.Count - 1 do
      Postprocessed[StrToInt(IniSection[I])] := True;

    ReadSectionValues('Decimation', IniSection);
    for I := 0 to IniSection.Count - 1 do
    begin
      Line := IniSection[I];
      Decimates.Add(StrToInt(GetToken(Line, 0, [','])), StrToInt(GetToken(Line, 1, [','])), StrToInt(GetToken(Line, 2, [','])));
    end;

    ReadSectionValues('FreezeFrames', IniSection);
    for I := 0 to IniSection.Count - 1 do
    begin
      Line := IniSection[I];
      FreezeFrames.Add(StrToInt(GetToken(Line, 0, [','])), StrToInt(GetToken(Line, 1, [','])), StrToInt(GetToken(Line, 2, [','])));
    end;

    ReadSectionValues('MMetrics', IniSection);
    FMMetrics := TYattaMetrics.Create(FieldOrder, IniSection);

    ReadSectionValues('VMetrics', IniSection);
    FVMetrics := TYattaMetrics.Create(FieldOrder, IniSection);

    ReadSectionValues('Presets', IniSection);
    for I := 0 to IniSection.Count - 1 do
    begin
      Line := IniSection[I];
      Offset := 1;
      TempId := StrToInt(GetNextToken(Line, Offset, [',']));
      TempName := GetNextToken(Line, Offset, [',']);
      Presets.Add(TempName, MidStr(Line, Offset + 1, Length(Line)), TempId); //fix me, unescape
    end;

    J := 0;
    Index := -1;

    ReadSectionValues('Layers', IniSection);
    for I := 0 to IniSection.Count - 1 do
    begin
      Line := IniSection[I];

      if J = 0 then
      begin
        Offset := 1;
        TempType := GetNextToken(Line, Offset, [',']);
        TempName := GetNextToken(Line, Offset, [',']);
        J := StrToInt(GetNextToken(Line, Offset, [',']));
        TempProcessing := MidStr(Line, Offset + 1, Length(Line));

        if TempType = 'SectionList' then
          Index := Layers.Add(TempName, ltSectionList)
        else if TempType = 'RangeList' then
        begin
          Index := Layers.Add(TempName, ltRangeList);
          (Layers.Items[Index] as TRangeList).Processing := TempProcessing;
        end
        else if TempType = 'ListDelimiter' then
          Index := Layers.Add(TempName, ltDelimiter);
      end
      else
      begin
        if TempType = 'SectionList' then
          (Layers.Items[Index] as TSectionList).Add(StrToInt(GetToken(Line, 0, [','])), StrToInt(GetToken(Line, 1, [','])))
        else if TempType = 'RangeList' then
          (Layers.Items[Index] as TRangeList).Add(StrToInt(GetToken(Line, 0, [','])), StrToInt(GetToken(Line, 1, [','])));
        Dec(J);
      end;
    end;

  finally
    IniSection.Free;
  end;
end;

procedure TYattaProject.OpenV2Project(const ProjectIni: TMemIniFile);
  procedure LoadCommonValues(const ProjectIni: TMemIniFile);
  var
    SL, SubDiv: TStringList;
    I, J: Integer;
    RangeList: TRangeList;
    Line: string;
    TempLayer: Integer;
    Index: Integer;
  begin
    SL := TStringList.Create;
    SubDiv := TStringList.Create;

    with ProjectIni do
    try

          //add resizing layer?
          //Form2.Resizer.ItemIndex := ReadInteger('YATTA V2', 'RESIZER', 1);
          //try
          //  Form1.BicubicB := ReadFloat('YATTA V2', 'bicubic_b', 1 / 3);
          //  Form1.BicubicC := ReadFloat('YATTA V2', 'bicubic_c', 1 / 3);
          //finally
          //end;

          //set position?
          //Form1.TrackBar1.Position := ReadInteger('YATTA V2', 'FRAME', 0);

          //read cropping?
          //with CropForm do
          //begin
          //  TrackBarChange(nil);
          //  ResizeWidthUpDown.Position := ReadInteger('YATTA V2', 'xres', 640);
          //  ResizeHeightUpDown.Position := ReadInteger('YATTA V2', 'yres', 480);
          //  CropLeftUpDown.Position := ReadInteger('YATTA V2', 'x1', 0);
          //  CropRightUpDown.Position := ReadInteger('YATTA V2', 'x2', 0);
          //  CropTopUpdown.Position := ReadInteger('YATTA V2', 'y1', 0);
          //  CropBottomUpDown.Position := ReadInteger('YATTA V2', 'y2', 0);
          //  Anamorphic.Checked := Readbool('YATTA V2', 'Anamorphic', False);
          //end;

      ReadSectionValues('FREEZE', SL);
      for I := 0 to SL.Count - 1 do
      begin
        Line := SL[I];
        if Line <> '' then
          FreezeFrames.Add(StrToInt(GetToken(Line, 0, [','])), StrToInt(GetToken(Line, 1, [','])), StrToInt(GetToken(Line, 2, [','])));
      end;

      ReadSectionValues('PRESETS', sl);
      SubDiv.Delimiter := '¤';
      for I := 0 to sl.Count - 1 do
      begin
        Line := SL[I];
        if Line <> '' then
        begin
          SubDiv.DelimitedText := Line;
          Presets.Add(AnsiDequotedStrY(SubDiv[2], '"'), AnsiDequotedStrY(AnsiReplaceStr(SubDiv[3], '^', #13#10), '"'), StrToInt(SubDiv[0]));
        end;
      end;

      //load layers

      TempLayer := ReadInteger(V2ProjectSection, 'PRETELECIDE2', -1);
      if TempLayer <> -1 then
      begin
        Index := Layers.Add('PreTelecide', ltSectionList);
        (Layers[Index] as TSectionList).Add(0, TempLayer);
      end;

      Layers.Add('', ltDelimiter);

      TempLayer := ReadInteger(V2ProjectSection, 'POSTTELECIDE2', -1);
      if TempLayer <> -1 then
      begin
        Index := Layers.Add('PostTelecide', ltSectionList);
        (Layers[Index] as TSectionList).Add(0, TempLayer);
      end;

      ProjectIni.ReadSectionValues('SECTIONS', SL);
      Index := Layers.Add('Sections', ltSectionList);

      for I := 0 to SL.Count - 1 do
      begin
        Line := SL[I];
        if Line <> '' then
          (Layers[Index] as TSectionList).Add(StrToInt(GetToken(Line, 0, [','])), StrToInt(GetToken(Line, 1, [','])));
      end;

      TempLayer := ReadInteger(V2ProjectSection, 'PREDECIMATE2', -1);
      if TempLayer <> -1 then
      begin
        Index := Layers.Add('PreDecimate', ltSectionList);
        (Layers[Index] as TSectionList).Add(0, TempLayer);
      end;

      TempLayer := ReadInteger(V2ProjectSection, 'POSTDECIMATE2', -1);
      if TempLayer <> -1 then
      begin
        Index := Layers.Add('PostDecimate', ltSectionList);
        (Layers[Index] as TSectionList).Add(0, TempLayer);
      end;

      TempLayer := ReadInteger(V2ProjectSection, 'POSTRESIZE2', -1);
      if TempLayer <> -1 then
      begin
        Index := Layers.Add('PostResize', ltSectionList);
        (Layers[Index] as TSectionList).Add(0, TempLayer);
      end;

      CutStart := ReadInteger(V2ProjectSection, 'CUTSTART', -1);
      CutEnd := ReadInteger(V2ProjectSection, 'CUTEND', -1);

      I := 0;

      while SectionExists('Custom List ' + IntToStr(I)) do
      begin
        ReadSectionValues('Custom List ' + IntToStr(I), SL);

        Index := Layers.Add(AnsiDequotedStrY(SL[0], '"'), ltRangeList);
        RangeList := Layers[Index] as TRangeList;
        RangeList.Processing := AnsiDequotedStrY(SL[1], '"');

        for J := 4 to SL.Count - 1 do
        begin
          Line := SL[J];
          RangeList.Add(StrToInt(GetToken(Line, 0, [','])), StrToInt(GetToken(Line, 1, [','])));
        end;

        Inc(I);
      end;

    finally
      SubDiv.Free;
      SL.Free;
    end;
  end;

  procedure LoadType1Values(const ProjectIni: TMemIniFile);
  var
    IniSection, TempMetrics: TStringList;
    I: Integer;
    Distance: Integer;
    Line: string;
  begin
    IniSection := THashedStringList.Create;

    with ProjectIni do
    try
        //load shift patterns?
        //if ReadString('YATTA V2', 'POSTPATTERN', 'ooooo') <> '' then
        //  Form1.PostPattern := ReadString('YATTA V2', 'POSTPATTERN', 'ooooo');
        //if ReadString('YATTA V2', 'MATCHPATTERN', 'ccnnc') <> '' then
        //  Form1.MatchPattern := ReadString('YATTA V2', 'MATCHPATTERN', 'ccnnc');
        //if ReadString('YATTA V2', 'DROPPATTERN', 'kkkkd') <> '' then
        //  Form1.DropPattern := ReadString('YATTA V2', 'DROPPATTERN', 'kkkkd');
        //if ReadString('YATTA V2', 'FREEZEPATTERN', 'ooooo') <> '' then
        //  Form1.FreezePattern := ReadString('YATTA V2', 'FREEZEPATTERN', 'ooooo');

      Distance := ReadInteger(V2ProjectSection, 'DISTANCE', 5);

      ReadSectionValues('METRICS', IniSection);
      TempMetrics := TStringList.Create;

      try
        TempMetrics.Append(Format('%d,%d,%d', [IfThen(IniSection.Count > 0, Integer(mm3Way), Integer(mmNone)), Integer(FieldOrder), Min(Framecount, IniSection.Count)]));
        for I := 0 to Min(Framecount, IniSection.Count) - 1 do
        begin
          Line := IniSection[I];
          TempMetrics.Append(GetToken(Line, 0) + ',' + GetToken(Line, 1) + ',' + GetToken(Line, 2));
        end;
        FreeAndNil(FMMetrics);
        FMMetrics := TYattaMetrics.Create(FieldOrder, TempMetrics);

        TempMetrics.Clear;
        TempMetrics.Append(Format('%d,%d,%d', [IfThen(IniSection.Count > 0, Integer(mm3Way), Integer(mmNone)), Integer(FieldOrder), Min(Framecount, IniSection.Count)]));
        for I := 0 to Min(Framecount, IniSection.Count) - 1 do
        begin
          Line := IniSection[I];
          TempMetrics.Append(GetToken(Line, 4) + ',' + GetToken(Line, 4) + ',' + GetToken(Line, 5));
        end;
        FreeAndNil(FVMetrics);
        FVMetrics := TYattaMetrics.Create(FieldOrder, TempMetrics);
      finally
        TempMetrics.Free;
      end;

      ReadSectionValues('NODECIMATE', IniSection);
      for I := 0 to IniSection.Count - 1 do
      begin
        Line := IniSection[I];
        if (Line <> '') then
        begin
          Decimates.Add(StrToInt(GetToken(Line, 0, ['^'])), 1, Distance);
          Decimates.Add(StrToInt(GetToken(Line, 1, ['^'])) + 1, 0, 1);
        end;
      end;

      ReadSectionValues('MATCHES', IniSection);
      for I := 0 to Min(Framecount, IniSection.Count) - 1 do
        MatchChar[I] := IniSection[I][1];

      ReadSectionValues('ORIGINALMATCHES', IniSection);
      for I := 0 to Min(Framecount, IniSection.Count) - 1 do
        MatchChar[I] := IniSection[I][1];

      ReadSectionValues('POSTPROCESS', IniSection);
      for I := 0 to IniSection.Count - 1 do
        if StrToInt(IniSection[I]) < Framecount then
          Postprocessed[StrToInt(IniSection[I])] := True;

      ReadSectionValues('DECIMATE', IniSection);
      for I := 0 to IniSection.Count - 1 do
        if StrToInt(IniSection[I]) < Framecount then
          Decimated[StrToInt(IniSection[I])] := True;
    finally
      IniSection.Free;
    end;
  end;
var
  IniSection: TStringList;
  TempFramecount: Integer;
  TempVideo: string;
begin
  FMMetrics := TYattaMetrics.Create;
  FVMetrics := TYattaMetrics.Create;

  with ProjectIni do
  begin
    IniSection := TStringList.Create;

    try
      TempFramecount := ReadInteger(V2ProjectSection, 'Framecount', -1);
      if TempFramecount < 0 then
        raise EYattaProjectException.Create('Invalid number of frames specified in project');

      TempVideo := ReadString(V2ProjectSection, 'LastVideoPath', '');
      if (TempVideo = '') then
        raise EYattaProjectException.Create('No video specified in project');

      OpenVideo(TempVideo);

      if Video.VideoInfo.NumFrames <> TempFramecount then
        raise EYattaProjectException.Create('Framecount mismatch between project and video');

      Framecount := TempFramecount;

      FieldOrder := TFieldOrder(ReadInteger(V2ProjectSection, 'Order', Integer(foBFF)));

      LoadCommonValues(ProjectIni);
      LoadType1Values(ProjectIni);
    finally
      IniSection.Free;
    end;
  end;
end;

constructor TYattaProject.Create(ApplicationName: string; PluginPath: string; Filename: string; Mpeg2Dec: TMpeg2Decoder);
var
  ProjectIni: TMemIniFile;
  FileExt: string;
begin
  FSavedBy := ApplicationName;
  FFieldOrder := foTFF;
  FMetricThread := nil;
  FVideo := nil;
  FPresets := TPresetList.Create;
  FLayers := TLayerList.Create;
  FDecimates := TDecimationMarkerList.Create;
  FFreezeFrames := TFreezeFrameMarkerList.Create;
  FProjectFilename := ProjectFilename;
  FPluginPath := PluginPath;
  FMpeg2Dec := Mpeg2Dec;
  FMMetrics := nil;
  FVMetrics := nil;

  FCutStart := -1;
  FCutEnd := -1;

  Framecount := 0;
  FFramerate := 30;

  FileExt := UpperCase(ExtractFileExt(Filename));

  if Filename <> '' then
  begin
    try
      if FileExt = '.YAP' then
      begin
        FProjectFilename := Filename;
        if (ProjectFilename <> '') and not FileExists(ProjectFilename) then
          raise EYattaProjectException.Create('Project file doesn''t exist');

        ProjectIni := TMemIniFile.Create(ProjectFilename);

        try
          if ProjectIni.SectionExists(MainProjectSection) then
            OpenV3Project(ProjectIni)
          else if ProjectIni.SectionExists(V2ProjectSection) then
            OpenV2Project(ProjectIni)
          else
            raise EYattaProjectException.Create('Not a valid project file');
        finally
          ProjectIni.Free;
        end;

      end
      else if (FileExt = '.D2V') or (FileExt = '.AVI') then
      begin
        OpenVideo(Filename);
        FMMetrics := TYattaMetrics.Create;
        FVMetrics := TYattaMetrics.Create;
      end;
    except
      DestroyData;
      raise;
    end;
  end;
end;

procedure TYattaProject.DestroyData;
begin
  CollectDMetrics := False;

  FreeAndNil(FVideo);
  FreeAndNil(FVMetrics);
  FreeAndNil(FMMetrics);

  FreeAndNil(FPresets);
  FreeAndNil(FLayers);
  FreeAndNil(FDecimates);
  FreeAndNil(FFreezeFrames);
end;

destructor TYattaProject.Destroy;
begin
  DestroyData;
end;

procedure TYattaProject.ResetMatch(FromFrame, ToFrame: Integer);
var
  I: Integer;
begin
  for I := FromFrame to ToFrame do
    Match[I] := FFrames[I].OriginalMatch;
end;

procedure TYattaProject.SetFrameCount(Count: Integer);
var
  I: Integer;
begin
  SetLength(FFrames, Count);
  FFramecount := Count;

  for I := 0 to Framecount - 1 do
    with FFrames[I] do
    begin
      Match.Top := I;
      Match.Bottom := I;
      OriginalMatch.Top := I;
      OriginalMatch.Bottom := I;
      Flags := [];
      DMetric := -1;
    end;
end;

function TYattaProject.GetDecimate(Frame: Integer): Boolean;
begin
  Result := ffDecimate in FFrames[Frame].Flags;
end;

function TYattaProject.GetMatch(Frame: Integer): TMatch;
begin
  Result := FFrames[Frame].Match;
end;

function TYattaProject.GetMatchChanged(Frame: Integer): Boolean;
begin
  Result := (FFrames[Frame].Match.Top <> FFrames[Frame].OriginalMatch.Top) or (FFrames[Frame].Match.Bottom <> FFrames[Frame].OriginalMatch.Bottom);
end;

function TYattaProject.GetOriginalMatch(Frame: Integer): TMatch;
begin
  Result := FFrames[frame].OriginalMatch;
end;

function TYattaProject.GetPostprocess(Frame: Integer): Boolean;
begin
  Result := ffPostprocess in FFrames[Frame].Flags;
end;

procedure TYattaProject.SetDecimate(Frame: Integer; State: Boolean);
var
  CEntry, NEntry: TDecimationMarker;
  I: Integer;
  DCount: Integer;
  SDCFrame: Integer;
  NEnd: Integer;
begin
  if State then
  begin
    CEntry := FDecimates.GetByFrame(Frame);
    if CEntry <> nil then
    begin
      NEntry := FDecimates.GetNext(CEntry);

      if NEntry = nil then
        NEnd := Framecount
      else
        NEnd := NEntry.StartFrame;

      if Frame < NEnd - (NEnd - CEntry.StartFrame) mod CEntry.N then
      begin
        DCount := 0;

        SDCFrame := CEntry.StartFrame + ((Frame - CEntry.StartFrame) div CEntry.N) * CEntry.N;
        for I := SDCFrame to SDCFrame + CEntry.N - 1 do
          if Decimated[I] then
            Inc(DCount);

        if DCount < CEntry.M then
          Include(FFrames[Frame].Flags, ffDecimate);
      end;
    end;
  end
  else
    Exclude(FFrames[Frame].Flags, ffDecimate);
end;

procedure TYattaProject.SetMatch(Frame: Integer; Match: TMatch);
begin
  if (FFrames[frame].Match.Top <> Match.Top) or (FFrames[frame].Match.Bottom <> Match.Bottom) then
  begin
    FFrames[Frame].DMetric := -1;
    if (Frame + 1 < Framecount) then
      FFrames[Frame + 1].DMetric := -1
  end;

  FFrames[Frame].Match := Match;
end;

procedure TYattaProject.SetOriginalMatch(Frame: Integer; Match: TMatch);
begin
  FFrames[Frame].OriginalMatch := Match;
end;

procedure TYattaProject.SetPostprocess(Frame: Integer; State: Boolean);
begin
  if State then
    Include(FFrames[Frame].Flags, ffPostprocess)
  else
    Exclude(FFrames[Frame].Flags, ffPostprocess);
end;

function TYattaProject.GetMatchChar(Frame: Integer): Char;
var
  FieldOrder: Boolean;
begin
  FieldOrder := FFieldOrder = foTFF;

  with Match[Frame] do
  begin
    if (Top = Frame) and (Bottom = Frame) then
      Result := 'c'
    else if (Top = Frame + 1) and (Bottom = Frame) then
    begin
      if FieldOrder then
        Result := 'u'
      else
        Result := 'n';
    end
    else if (Top = Frame) and (Bottom = Frame + 1) then
    begin
      if FieldOrder then
        Result := 'n'
      else
        Result := 'u';
    end
    else if (Top = Frame) and (Bottom = Frame - 1) then
    begin
      if FieldOrder then
        Result := 'b'
      else
        Result := 'p';
    end
    else if (Top = Frame - 1) and (Bottom = Frame) then
    begin
      if FieldOrder then
        Result := 'p'
      else
        Result := 'b';
    end
    else
      Result := 'g';
  end;
end;

procedure TYattaProject.SetMatchChar(Frame: Integer; MatchChar: Char);
var
  FieldOrder: Boolean;
begin
  FieldOrder := FFieldOrder = foTFF;

  case MatchChar of
    'c': Match[Frame] := M(Frame, Frame);
    'u': if FieldOrder then Match[Frame] := M(Frame + 1, Frame) else Match[Frame] := M(Frame, Frame + 1);
    'n': if FieldOrder then Match[Frame] := M(Frame, Frame + 1) else Match[Frame] := M(Frame + 1, Frame);
    'b': if FieldOrder then Match[Frame] := M(Frame, Frame - 1) else Match[Frame] := M(Frame - 1, Frame);
    'p': if FieldOrder then Match[Frame] := M(Frame - 1, Frame) else Match[Frame] := M(Frame, Frame - 1);
  else
    raise EYattaProjectException.Create('Invalid matching char specified');
  end;
end;

function TYattaProject.GetDMetric(Frame: Integer): Integer;
begin
  Result := FFrames[Frame].DMetric;

  if Result < 0 then
  begin
    CalculateDMetric(Frame, Video);
    Result := FFrames[Frame].DMetric;
  end;
end;

procedure TYattaProject.GenerateFieldHints(Output: TStrings);
var
  Fields: array of TMatch;
  I, J: Integer;
begin
  SetLength(Fields, Framecount);

  //copy matches
  for I := 0 to Framecount - 1 do
    Fields[I] := Match[I];

  //apply freezeframes
  for I := 0 to FreezeFrames.Count - 1 do
    with FreezeFrames[I] do
      for J := StartFrame to EndFrame do
        Fields[J] := Match[ReplaceFrame];

  //apply decimation
  //fix me, incomplete

  //output
  for I := 0 to Framecount - 1 do
    with Fields[I] do
      if Top <> -1 then
        Output.Append(Format('%d,%d', [Top, Bottom]));
end;

procedure TYattaProject.GenerateAvisynthScript(Output: TStrings; Options: TScriptOptions);
  procedure WriteMatchingLayer(Output: TStrings; Filename: string);
  begin
    Output.Append('FieldHint(ovr="' + Filename + '")');
  end;

  procedure WriteRangeLayer(Output: TStrings; LayerNumber: Integer; AfterDecimation: Boolean);
  var
    Ranges: TRangeList;
    I: Integer;
    SF, EF: Integer;
  begin
    Ranges := Layers.Items[LayerNumber] as TRangeList;

    for I := 0 to Ranges.Count - 1 do
      with Ranges[I] do
      begin
        if AfterDecimation then
        begin
          SF := GetDecimatedPos(StartFrame);
          EF := GetDecimatedPos(EndFrame);

          if (SF < 0) or (EF < 0) then
            raise EMissingMetricsException.Create('Not enough metrics available to generate layer');
        end
        else
        begin
          SF := StartFrame;
          EF := EndFrame;
        end;

        Output.Append(AnsiReplaceStr(AnsiReplaceStr(Ranges.Processing, '%s', IntToStr(SF)), '%e', IntToStr(EF)));
      end;
  end;

  procedure WriteSectionLayer(Output: TStrings; LayerNumber: Integer; LayerUsedPresets: TIntegerDynArray; AfterDecimation: Boolean);
  var
    LPreset: Integer;
    I: Integer;
    CPreset: TPreset;
    Sections: TSectionList;
    SF, EF: Integer;
  begin
    HeapSort(LayerUsedPresets);

    LPreset := Low(LPreset);

    for I := 0 to Length(LayerUsedPresets) - 1 do
      if LPreset <> LayerUsedPresets[I] then
      begin
        LPreset := LayerUsedPresets[I];

        CPreset := Presets.GetPresetById(LPreset);

        if CPreset = nil then
          raise EMissingPresetException.CreateFmt('The preset with the id %d doesn''t exists', [LPreset]);

        Output.Append(Format('L%dPreset%dClip = Preset%1:d()', [LayerNumber, CPreset.Id]));
      end;

    Sections := Layers.Items[LayerNumber] as TSectionList;

    if (Sections.Count = 0) then
      Exit;

    if (Sections[0].StartFrame > 0) then
      Output.Append(Format('Trim(0,%d)+\',
        [Sections[0].StartFrame - 1]));

    for I := 0 to Sections.Count - 2 do
    begin
      if AfterDecimation then
      begin
        SF := GetDecimatedPos(Sections[I].StartFrame);
        EF := GetDecimatedPos(Sections[I - 1].StartFrame) - 1;

        if (SF < 0) or (EF < 0) then
          raise EMissingMetricsException.Create('Not enough metrics available to generate layer');
      end
      else
      begin
        SF := Sections[I].StartFrame;
        EF := Sections[I - 1].StartFrame - 1;
      end;

      Output.Append(Format('L%dPreset%dClip.Trim(%d,%d)+\',
        [LayerNumber, Sections[I].Preset, SF, EF]));
    end;


    if AfterDecimation then
    begin
      SF := GetDecimatedPos(Sections[Sections.Count - 1].StartFrame);

      if SF < 0 then
        raise EMissingMetricsException.Create('Not enough metrics available to generate layer');
    end
    else
      SF := Sections[Sections.Count - 1].StartFrame;

    Output.Append(Format('L%dPreset%dClip.Trim(%d,0)',
      [LayerNumber, Sections[Sections.Count - 1].Preset, SF]));
  end;

  procedure WriteUsedPresets(Output: TStrings; UsedPresets: TIntegerDynArray);
  var
    UP: TIntegerDynArray;
    LPreset: Integer;
    I: Integer;
    CPreset: TPreset;
  begin
    UP := Copy(UsedPresets);
    HeapSort(UP);

    LPreset := Low(LPreset);

    for I := 0 to Length(UP) - 1 do
      if LPreset <> UP[I] then
      begin
        LPreset := UP[I];

        CPreset := Presets.GetPresetById(LPreset);

        if CPreset = nil then
          raise EMissingPresetException.CreateFmt('The preset with id %d doesn''t exists', [LPreset]);

        with Output, CPreset do
        begin
          Append(Format('function Preset%d(clip c) {', [Id]));
          Append('#Name: ' + Name);
          Append('c');
          Append(Chain);
          Append('}');
          Append('');
        end;
      end;
  end;
  function GetUsedPresets(): TIntegerDynArray;
  var
    I, J: Integer;
    PresetOffset: Integer;
    SectionCount: Integer;
  begin
    PresetOffset := 0;
    SectionCount := 0;

  // collect number of sections
    for I := 0 to Layers.Count - 1 do
      if Layers.Items[I] is TSectionList then
        Inc(SectionCount, (Layers.Items[I] as TSectionList).Count);

    SetLength(Result, SectionCount);

  // collect number of presets used
    for I := 0 to Layers.Count - 1 do
      if Layers[I] is TSectionList then
        with Layers.Items[I] as TSectionList do
        begin
          for J := 0 to Count - 1 do
            Result[PresetOffset + J] := Items[J].Preset;
          Inc(PresetOffset, Count);
        end;
  end;
var
  I: Integer;
  AfterDecimation: Boolean;
  UsedPresets: TIntegerDynArray;
  PresetOffset: Integer;
begin
  PresetOffset := 0;
  AfterDecimation := False;

  if soPreview in Options then
    Output.Append('YattaVideoSource')
  else
    Output.Append(Video.Script);

  UsedPresets := GetUsedPresets();

  WriteUsedPresets(Output, UsedPresets);

  // generate layers

  for I := 0 to Layers.Count - 1 do
    if Layers.Items[I] is TSectionList then
    begin
      WriteSectionLayer(Output, I, Copy(UsedPresets, PresetOffset, Layers.Items[I].Count), AfterDecimation);
      Inc(PresetOffset, Layers.Items[I].Count);
    end
    else if Layers.Items[I] is TRangeList then
    begin
      WriteRangeLayer(Output, I, AfterDecimation);
    end
    else if Layers.Items[I] is TListDelimiter then
    begin
      WriteMatchingLayer(Output, ProjectFilename + FieldHintExt);
      AfterDecimation := True;
    end;

  if soLoadPlugin in Options then
    Output.Insert(0, PluginListToScript(GetRequiredPlugins(True, Output.Text, FPluginPath, Video.Env), FPluginPath));
end;

procedure TYattaProject.GenerateVFR(Output: TStrings);
var
  I: Integer;
  DLength: Integer;
  Frame: Integer;
begin
  if Decimates.Count > 0 then
  begin
    Output.Append('# timecode v1');
    Output.Append('Assume ' + FloatToStr(Framerate));

    Frame := 0;

    for I := 0 to Decimates.Count - 1 do
      with Decimates[I] do
      begin
        if I = Decimates.Count - 1 then
          DLength := Framecount - StartFrame
        else
          DLength := Decimates[I + 1].StartFrame - StartFrame;

        if (M > 0) and (DLength div N > 0) then
          Output.Append(Format('%d,%d,%g', [Frame,
            Frame + DLength div N * (N - M) - 1, Framerate * (N - M) / N]));

        Inc(Frame, DLength div N * (N - M) + DLength mod N);
      end;
  end;
end;

function TYattaProject.GetDecimatedPos(Frame: Integer): Integer;
var
  Dummy: Boolean;
begin
  Result := GetDecimatedPos(Frame, Dummy);
end;

function DSortProc1(Item1, Item2: Pointer): Integer;
var
  T1, T2: TIntPair;
begin
  T1 := TIntPair(Item1);
  T2 := TIntPair(Item2);

  if T1.I1 > T2.I1 then
    Result := 1
  else if T1.I1 < T2.I1 then
    Result := -1
  else
    Result := 0;
end;

function TYattaProject.GetDecimatedPos(Frame: Integer;
  var ADecimated: Boolean): Integer;
var
  MissingMetrics: Boolean;
  I: Integer;
  Cyclecount, PFramecycle, DecCount: Integer;
  CurrentFrame: Integer;
  PMarked, PM, PN: Integer;
  Len: Integer;
  LoopEntry, CEntry: TDecimationMarker;
  SortList: TObjectList;
begin
  Assert((Frame >= 0) and (Frame < Framecount));

  //Returns the decimated position, -1 means not enough metrics
  //available
  ADecimated := Decimated[Frame];

  CEntry := FDecimates.GetByFrame(Frame);

  //Not contained in any marker => no decimation
  if CEntry = nil then
  begin
    Result := Frame;
    Exit;
  end;

  //Add the number of decimated frames up to the current dmarker
  LoopEntry := Decimates[0];
  CurrentFrame := LoopEntry.StartFrame;

  while LoopEntry <> CEntry do
  begin
    PMarked := LoopEntry.StartFrame;
    PM := LoopEntry.M;
    PN := LoopEntry.N;

    LoopEntry := FDecimates.GetNext(LoopEntry);
    Len := LoopEntry.StartFrame - PMarked;
    Inc(CurrentFrame, Len div PN * (PN - PM) + Len mod PN);
  end;

  //Determine the length of the containing section
  LoopEntry := FDecimates.GetNext(LoopEntry);

  if LoopEntry = nil then
    Len := Framecount - CEntry.StartFrame
  else
    Len := LoopEntry.StartFrame - CEntry.StartFrame;

  //Cycle position
  Cyclecount := Len div CEntry.N;
  PFramecycle := (Frame - CEntry.StartFrame) div CEntry.N;

  Inc(CurrentFrame, PFramecycle * (CEntry.N - CEntry.M));

  //Is in the undecimated trailing part?
  if (PFramecycle = Cyclecount) then
    Result := CurrentFrame + Len mod CEntry.N
  else
  begin
    PFramecycle := CEntry.StartFrame + PFramecycle * CEntry.N;

    DecCount := CEntry.M;
    MissingMetrics := False;

    for I := PFramecycle to PFramecycle + CEntry.N - 1 do
    begin
      if Decimated[I] then
        Dec(DecCount);
      MissingMetrics := MissingMetrics or (DMetric[I] = -1);
    end;

    //All frames marked for decimation
    if DecCount = 0 then
    begin
      Result := CurrentFrame;

      for I := PFramecycle to Frame - 1 do
        if not Decimated[I] then
          Inc(Result);
    end
    else
    begin
      //Not enough metrics (calculate and retry?)
      if MissingMetrics then
        Result := -1
      else
      begin
      //Actual decimation decisions here
      //Determine frames with lowest dmetric
        SortList := TObjectList.Create;

        for I := PFramecycle to PFramecycle + CEntry.N - 1 do
          if not Decimated[I] then
            SortList.Add(TIntPair.Create(DMetric[I], I));

        SortList.Sort(DSortProc1);

        SortList.Count := DecCount;

        for DecCount := 0 to SortList.Count - 1 do
          if TIntPair(SortList[DecCount]).I2 = Frame then
            ADecimated := True;

        Result := CurrentFrame;

        for I := PFramecycle to Frame - 1 do
        begin

          if Decimated[I] then
            Continue;

          for DecCount := 0 to SortList.Count - 1 do
            if TIntPair(SortList[DecCount]).I2 = I then
              Dec(Result);

          Inc(Result);
        end;

        SortList.Free;
      end;
    end;
  end;
end;

function TYattaProject.GetFFMatch(Index: Integer): TMatch;
var Entry: TFreezeFrameMarker;
begin
  Entry := FreezeFrames.GetByFrame(Index);

  if Entry = nil then
    Result := Match[Index]
  else
    Result := Match[Entry.ReplaceFrame];
end;

procedure TYattaProject.OpenVideo(Filename: string);
begin
  FVideo := TVideo.Create(Filename, FPluginPath, FMpeg2Dec);

  with FVideo.VideoInfo do
  begin
    FFramerate := FPSNumerator / FPSDenominator;
    Framecount := NumFrames;
  end;
end;

function TYattaProject.CalculateDMetric(Frame: Integer; Video: TVideo): Integer;
begin
  Assert(Video <> nil);
  if FFrames[Frame].DMetric = -1 then
    FFrames[Frame].DMetric := FramediffMetric(Match[Max(Frame - 1, 0)], Match[Frame], Video.SourceVideo);
  Result := FFrames[Frame].DMetric;
end;

function TYattaProject.GetCollectDMetrics: Boolean;
begin
  Result := FMetricThread <> nil;
end;

procedure TYattaProject.SetCollectDMetrics(Collect: Boolean);
begin
  if Collect and (FMetricThread = nil) then
  begin
    if Video = nil then
      raise EYattaProjectException.Create('No video open');

    FMetricThread := TDMetricThread.Create(Self, TVideo.Create(Video.VideoFilename, FPluginPath, FMpeg2Dec));
  end
  else if not Collect and (FMetricThread <> nil) then
  begin
    FMetricThread.Terminate;
    FMetricThread.WaitFor;
    FreeAndNil(FMetricThread);
  end;
end;

procedure TYattaProject.SaveAvisynthScript(Filename: string);
var
  Output: TStringList;
begin
  if Filename = '' then
    Filename := ProjectFilename + AvisynthExt;

  Output := TStringList.Create;
  try
    GenerateAvisynthScript(Output);
    Output.SaveToFile(Filename);
  finally
    Output.Free;
  end;
end;

procedure TYattaProject.SaveFieldHints(Filename: string);
var
  Output: TStringList;
begin
  if Filename = '' then
    Filename := ProjectFilename + FieldHintExt;

  Output := TStringList.Create;
  try
    GenerateFieldHints(Output);
    Output.SaveToFile(Filename);
  finally
    Output.Free;
  end;
end;

procedure TYattaProject.SaveTimecodes(Filename: string);
var
  Output: TStringList;
begin
  if Filename = '' then
    Filename := ProjectFilename + TimecodeExt;

  Output := TStringList.Create;
  try
    GenerateVFR(Output);
    Output.SaveToFile(Filename);
  finally
    Output.Free;
  end;
end;

procedure TYattaProject.SaveProject(Filename: string; SetProjectFilename: Boolean);
var
  Output: TStringList;
  I, J: Integer;
  TempProcessing: string;
begin
  if Filename = '' then
    Filename := ProjectFilename;

  if Filename = '' then
    raise EYattaProjectException.Create('No filename specified');

  Output := TStringList.Create;

  with Output do
  begin
    Append('[YATTA V3]');
    Append('SavedBy=' + FSavedBy);
    Append('Framecount=' + IntToStr(Framecount));
    Append('Order=' + IntToStr(Integer(FieldOrder)));
    Append('Video=' + Video.VideoFilename);
    Append('');

    Append('[Matches]');
    for I := 0 to Framecount - 1 do
      with FFrames[I].Match do
        Append(Format('%d,%d', [Top, Bottom]));
    Append('');

    Append('[Original Matches]');
    for I := 0 to Framecount - 1 do
      with FFrames[I].OriginalMatch do
        Append(Format('%d,%d', [Top, Bottom]));
    Append('');

    Append('[DMetrics]');
    for I := 0 to Framecount - 1 do
      Append(IntToStr(FFrames[I].DMetric));
    Append('');

    Append('[Postprocess]');
    for I := 0 to Framecount - 1 do
      if Postprocessed[I] then
        Append(IntToStr(I));
    Append('');

    Append('[Decimate]');
    for I := 0 to Framecount - 1 do
      if Decimated[I] then
        Append(IntToStr(I));
    Append('');

    Append('[FreezeFrames]');
    for I := 0 to FreezeFrames.Count - 1 do
      with FreezeFrames[I] do
        Append(Format('%d,%d,%d', [StartFrame, EndFrame, ReplaceFrame]));
    Append('');

    Append('[Decimation]');
    for I := 0 to Decimates.Count - 1 do
      with Decimates[I] do
        Append(Format('%d,%d,%d', [StartFrame, M, N]));
    Append('');

    Append('[Presets]');
    for I := 0 to Presets.Count - 1 do
      with Presets[I] do
        Append(Format('%d,%s,%s', [Id, Name, AnsiReplaceStr(AnsiReplaceStr(Chain, '\', '\\'), #13#10, '\N')]));
    Append('');

    Append('[Layers]');
    for I := 0 to Layers.Count - 1 do
    begin
      TempProcessing := '';
      if Layers[I] is TRangeList then
        TempProcessing := (Layers[I] as TRangeList).Processing;
      Append(Format('%s,%s,%d,%s', [MidStr(Layers[I].ClassName, 2, 255), Layers[I].Name, Layers[I].Count, TempProcessing]));

      if Layers[I] is TSectionList then
        with Layers[I] as TSectionList do
          for J := 0 to Count - 1 do
            with Items[J] do
              Append(Format('%d,%d', [StartFrame, Preset]));
              
      if Layers[I] is TRangeList then
        with Layers[I] as TRangeList do
          for J := 0 to Count - 1 do
            with Items[J] do
              Append(Format('%d,%d', [StartFrame, EndFrame]));
    end;

    Append('[MMetrics]');
    MMetrics.AsText(Output);
    Append('');

    Append('[VMetrics]');
    VMetrics.AsText(Output);
    Append('');
  end;

  try
    Output.SaveToFile(Filename);
  finally
    Output.Free;
  end;

  if SetProjectFilename then
    FProjectFilename := Filename;
end;

{ TMetrics }

constructor TYattaMetrics.Create(AMatchOrder: TFieldOrder;
  AMetrics: TStrings);
var
  I: Integer;
  MetricCount: Integer;
  MetricOrder: TFieldOrder;
  MetricMode: TMetricMode;
  Line: string;
begin
  Create;

  FMatchOrder := AMatchOrder;

  if (AMetrics <> nil) and (AMetrics.Count > 0) then
  begin
    Line := AMetrics[0];

    MetricMode := TMetricMode(StrToInt(GetToken(Line, 0, [','])));
    MetricOrder := TFieldOrder(StrToInt(GetToken(Line, 1, [','])));
    MetricCount := StrToInt(GetToken(Line, 2, [',']));

    if (MetricMode = mm5Way) then
    begin
      SetLength(FUMetrics, MetricCount);
      SetLength(FBMetrics, MetricCount);
    end;

    if (MetricMode = mm3Way) or (MetricMode = mm5Way) then
    begin
      SetLength(FCMetrics, MetricCount);
      SetLength(FNMetrics, MetricCount);
      SetLength(FPMetrics, MetricCount);

      for I := 0 to MetricCount - 1 do
      begin
        Line := AMetrics[I + 1];
        FCMetrics[I] := StrToIntDef(GetToken(Line, 0, [',']), -1);
        FNMetrics[I] := StrToIntDef(GetToken(Line, 1, [',']), -1);
        FPMetrics[I] := StrToIntDef(GetToken(Line, 2, [',']), -1);
        if (MetricMode = mm5Way) then
        begin
          FBMetrics[I] := StrToIntDef(GetToken(Line, 3, [',']), -1);
          FUMetrics[I] := StrToIntDef(GetToken(Line, 4, [',']), -1);
        end;
      end;

      FMetricCount := MetricCount;
      FMetricMode := MetricMode;
      FMetricOrder := MetricOrder
    end;
  end;
end;

function TYattaMetrics.GetMetric(AFrame: Integer; AMatch: AnsiChar): Integer;
var
  Metrics: TIntegerDynArray;
begin
  Metrics := nil;
  Result := -1;

  if (FMatchOrder = FMetricOrder) then
  begin
    case AMatch of
      'c': Metrics := FCMetrics;
      'b': Metrics := FBMetrics;
      'p': Metrics := FPMetrics;
      'u': Metrics := FUMetrics;
      'n': Metrics := FNMetrics;
    end;
  end
  else
  begin
    case AMatch of
      'c': Metrics := FCMetrics;
      'b': Metrics := FBMetrics;
      'p': Metrics := FPMetrics;
      'u': Metrics := FUMetrics;
      'n': Metrics := FNMetrics;
    end;
  end;

  if FMetricCount > AFrame then
    Result := Metrics[AFrame];
end;


procedure TYattaMetrics.AsText(AOutput: TStrings);
var
  I: Integer;
begin
  AOutput.Append(Format('%d,%d,%d', [Integer(FMetricMode), Integer(FMetricOrder), FMetricCount]));
  if FMetricMode = mm5way then
    for I := 0 to Length(FCMetrics) do
      AOutput.Append(Format('%d,%d,%d,%d,%d', [FBMetrics[I], FPMetrics[I], FCMetrics[I], FNMetrics[I], FUMetrics[I]]))
  else if FMetricMode = mm3way then
    for I := 0 to Length(FCMetrics) do
      AOutput.Append(Format('%d,%d,%d', [FPMetrics[I], FCMetrics[I], FNMetrics[I]]));
end;

constructor TYattaMetrics.Create;
begin
  FUMetrics := nil;
  FBMetrics := nil;
  FCMetrics := nil;
  FNMetrics := nil;
  FPMetrics := nil;

  FMetricCount := 0;
  FMetricMode := mmNone;
  FMetricOrder := foAuto;
  FMatchOrder := foAuto;
end;

end.

