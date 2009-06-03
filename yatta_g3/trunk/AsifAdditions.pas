unit AsifAdditions;

interface

uses
  Asif, Windows, Graphics, Types, Classes, SysUtils, StrUtils, GR32, YShared;

type
  TFilterType = (ft25, ft20, ft20Compat, ft25STDCALL, ftImport, ftError);

  PAvisynthFilter = ^TAvisynthFilter;
  TAvisynthFilter = record
    FunctionName: string;
    FileName: string;
    FilterType: TFilterType;
  end;

  TAvisynthFilterDynArray = array of TAvisynthFilter;

procedure InitializeFilterlist(Filename: string = '');
procedure FieldAssemble(Top, Bottom: Integer; Clip: IAsifClip; OutImage: TBitmap32);
procedure FullFrame(AFrame: Integer; Clip: IAsifClip; OutImage: TBitmap32);
procedure LoadPlugins(PluginText: string; PluginPath: string; Env: IAsifScriptEnvironment; Level: Integer = 1);
function GetRequiredPlugins(AllPlugins: Boolean; PluginText: string; PluginPath: string; Env: IAsifScriptEnvironment; Level: Integer = 1; ExistingPlugins: TAvisynthFilterDynArray = nil): TAvisynthFilterDynArray;
function PluginListToScript(Plugins: TAvisynthFilterDynArray; PluginPath: string): string;

implementation

var
  FilterList: TAvisynthFilterDynArray;

function PluginListToScript(Plugins: TAvisynthFilterDynArray; PluginPath: string): string;
var
  Counter: Integer;
  Hasft20: Boolean;
begin
  Hasft20 := False;
  Result := '';

  //multiple passess to get the right order since the list is unsorted
  for Counter := 0 to Length(Plugins) - 1 do
    with Plugins[Counter] do
      case FilterType of
        ft25: Result := Format('%sLoadPlugin("%s%s")'#13#10, [Result, PluginPath, FileName]);
        ft25STDCALL: Result := Format('%sload_stdcall_plugin("%s%s")'#13#10, [Result, PluginPath, FileName]);
        ft20: Hasft20 := True;
      end;

  if Hasft20 then
  begin
    for Counter := 0 to Length(FilterList) - 1 do
      with FilterList[Counter] do
        if FilterType = ft20Compat then
          Result := Format('%sLoadPlugin("%s%s")'#13#10, [Result, PluginPath, FileName]);

    for Counter := 0 to Length(Plugins) - 1 do
      with Plugins[Counter] do
        if FilterType = ft20 then
          Result := Format('%sLoadPlugin("%s%s")'#13#10, [Result, PluginPath, FileName]);
  end;

  for Counter := 0 to Length(Plugins) - 1 do
    with Plugins[Counter] do
      if FilterType = ftImport then
        Result := Format('%sImport("%s%s")'#13#10, [Result, PluginPath, FileName]);
end;

function StrToFilterType(const S: string): TFilterType;
begin
  if SameText(S, '25') then
    Result := ft25
  else if SameText(S, '20') then
    Result := ft20
  else if SameText(S, '20Compat') then
    Result := ft20Compat
  else if SameText(S, '25STDCALL') then
    Result := ft25STDCALL
  else if SameText(S, 'Import') then
    Result := ftImport
  else
    Result := ftError;
end;

procedure InitializeFilterlist(Filename: string = '');
var
  TempList: TStringList;
  Counter: Integer;
  Line: string;
begin
  SetLength(FilterList, 0);

  if (Filename <> '') and FileExists(Filename) then
  begin
    TempList := TStringList.Create;

    try
      TempList.LoadFromFile(Filename);

      for Counter := 0 to TempList.Count - 1 do
      begin
        Line := TempList[Counter];

        if (Line <> '') and (Line[1] <> '#') then
        begin
          SetLength(FilterList, Length(FilterList) + 1);
          with FilterList[High(FilterList)] do
          begin
            FilterType := StrToFilterType(GetToken(Line, 0));
            FileName := GetToken(Line, 1);
            FunctionName := GetToken(Line, 2);

            if (FilterType = ftError) or (FileName = '') or (FunctionName = '') then
              raise EAsifException.CreateFmt('Incorrect filter declaration on line %d'#13#10'%s', [Counter + 1, Line]);
          end;
        end;
      end;
    finally
      TempList.Free;
    end;
  end;
end;

function GetRequiredPlugins(AllPlugins: Boolean; PluginText: string; PluginPath: string; Env: IAsifScriptEnvironment; Level: Integer; ExistingPlugins: TAvisynthFilterDynArray): TAvisynthFilterDynArray;
  function PluginAlreadyAdded(CurrentFilters: TAvisynthFilterDynArray; Plugin: TAvisynthFilter): Boolean;
  var
    Counter: Integer;
  begin
    Result := False;
    for Counter := 0 to Length(CurrentFilters) - 1 do
      with CurrentFilters[Counter] do
        if (Plugin.FilterType = FilterType) and (Plugin.FileName = FileName) then
        begin
          Result := True;
          Break;
        end;
  end;
var
  Counter, MergeCounter: Integer;
  IncludeContents: TStringList;
  TempPlugins: TAvisynthFilterDynArray;
  Tokens: TStringList;
  Offset: Integer;
  Token: string;
  PreviousToken: string;
begin
  Result := nil;
  Tokens := TStringList.Create;
  Tokens.CaseSensitive := False;
  Offset := 1;
  PreviousToken := '';

  try

    while True do
    begin
      Token := GetNextToken(PluginText, Offset, [#0..#255] - ['1'..'9', '0', 'a'..'z', 'A'..'Z', '_']);
      if Token = '' then
        Break;
      if (Offset <= Length(PluginText)) and (PluginText[Offset] = '(') and (PreviousToken <> 'function') then
        Tokens.Append(Token);
      PreviousToken := Token;
    end;

    for Counter := 0 to Length(FilterList) - 1 do
      with FilterList[Counter] do
      begin
        if (AnsiSameText(PluginText, FunctionName) or (Tokens.IndexOf(FunctionName) <> -1)) and ((not Env.FunctionExists(FunctionName)) or AllPlugins) and not PluginAlreadyAdded(Result, FilterList[Counter]) then
        begin
          SetLength(Result, Length(Result) + 1);
          Result[High(Result)] := FilterList[Counter];

          if FilterType = ftImport then
            if Level = 1 then
            begin
              if not FileExists(PluginPath + FileName) then
                raise EAsifException.Create('Couldn''t locate "' + FileName + '"');
              IncludeContents := TStringList.Create;
              try
                IncludeContents.LoadFromFile(PluginPath + FileName);
                TempPlugins := GetRequiredPlugins(AllPlugins, IncludeContents.Text, PluginPath, Env, Level + 1);
                for MergeCounter := 0 to Length(TempPlugins) - 1 do
                  if not PluginAlreadyAdded(Result, TempPlugins[MergeCounter]) then
                  begin
                    SetLength(Result, Length(Result) + 1);
                    Result[High(Result)] := TempPlugins[MergeCounter];
                  end;

                TempPlugins := nil;
              finally
                IncludeContents.Free;
              end;
            end;
        end;
      end;

  finally
    Tokens.Free;
  end;
end;

procedure LoadPlugins(PluginText: string; PluginPath: string; Env: IAsifScriptEnvironment; Level: Integer);
var
  Plugins: TAvisynthFilterDynArray;
  Counter: Integer;
  CurrentPath: string;
begin
  CurrentPath := GetCurrentDir;

  try
    Plugins := GetRequiredPlugins(False, PluginText, PluginPath, Env);
    SetCurrentDir(PluginPath);

    for Counter := 0 to Length(Plugins) - 1 do
      with Plugins[Counter] do
      begin
        if FileExists(PluginPath + FileName) then
        begin
          if FilterType = ft25STDCALL then
          begin
            try
              Env.CharArg(PChar(PluginPath + FileName));
              Env.Invoke('load_stdcall_plugin');
            except on EAsifException do
                raise EAsifException.Create('Couldn''t load the plugin "' + FileName + '"');
            end;
          end
          else if FilterType = ft25 then
          begin
            try
              Env.CharArg(PChar(PluginPath + FileName));
              Env.Invoke('LoadPlugin');
            except on EAsifException do
                raise EAsifException.Create('Couldn''t load the plugin "' + FileName + '"');
            end;
          end;
        end
        else
          raise EAsifException.Create('Couldn''t locate "' + FileName + '"');
      end;

    for Counter := 0 to Length(Plugins) - 1 do
      with Plugins[Counter] do
      begin
        if FileExists(PluginPath + FileName) then
        begin
          if FilterType = ft20Compat then
          begin
            try
              Env.CharArg(PChar(PluginPath + FileName));
              Env.Invoke('LoadPlugin');
            except on EAsifException do
                raise EAsifException.Create('Couldn''t load the plugin "' + FileName + '"');
            end;
          end;
        end
        else
          raise EAsifException.Create('Couldn''t locate "' + FileName + '"');
      end;

    for Counter := 0 to Length(Plugins) - 1 do
      with Plugins[Counter] do
      begin
        if FileExists(PluginPath + FileName) then
        begin
          if FilterType = ftImport then
          begin
            try
              Env.CharArg(PChar(PluginPath + FileName));
              Env.Invoke('Import');
            except on EAsifException do
                raise EAsifException.Create('Couldn''t import the script "' + FileName + '"');
            end;
          end;
        end
        else
          raise EAsifException.Create('Couldn''t locate "' + FileName + '"');
      end;
  finally
    SetCurrentDir(CurrentPath);
  end;
end;

procedure FieldAssemble(Top, Bottom: Integer; Clip: IAsifClip; OutImage: TBitmap32);
var
  VI: VideoInfo;
  Counter, DSTRow: integer;
  SRCP: PByte;
  Frame: IAsifVideoFrame;
  SrcPitch: Integer;
  RowSize: Integer;
begin
  if Top = Bottom then
    FullFrame(Top, Clip, OutImage)
  else
  begin
    VI := Clip.GetVideoInfo;

    OutImage.Height := VI.Height;
    OutImage.Width := VI.Width;

    Frame := Clip.GetFrame(Top);
    SRCP := Frame.GetReadPtr(0);
    RowSize := Frame.GetRowSize(0);
    SrcPitch := Frame.GetPitch(0);

    DSTRow := VI.Height - 1;

    for Counter := VI.Height div 2 - 1 downto 0 do
    begin
      CopyMemory(OutImage.ScanLine[DSTRow], SRCP, RowSize);
      Inc(SRCP, 2 * SrcPitch);
      Dec(DSTRow, 2)
    end;

    Frame := Clip.GetFrame(Bottom);
    SRCP := Frame.GetReadPtr(0);
    RowSize := Frame.GetRowSize(0);
    SrcPitch := Frame.GetPitch(0);
    Inc(SRCP, SrcPitch);

    DSTRow := VI.Height - 2;

    for Counter := VI.Height div 2 - 1 downto 0 do
    begin
      CopyMemory(OutImage.ScanLine[DSTRow], SRCP, RowSize);
      Inc(SRCP, 2 * SrcPitch);
      Dec(DSTRow, 2)
    end;
  end;
end;

procedure FullFrame(AFrame: Integer; Clip: IAsifClip; OutImage: TBitmap32);
var
  VI: VideoInfo;
  Counter: Integer;
  SRCP: PByte;
  Frame: IAsifVideoFrame;
  SrcPitch: Integer;
  RowSize: Integer;
begin
  VI := Clip.GetVideoInfo;

  OutImage.Height := VI.Height;
  OutImage.Width := VI.Width;

  Frame := Clip.GetFrame(AFrame);
  SRCP := Frame.GetReadPtr(0);
  RowSize := Frame.GetRowSize(0);
  SrcPitch := Frame.GetPitch(0);

  for Counter := VI.Height - 1 downto 0 do
  begin
    CopyMemory(OutImage.ScanLine[Counter], SRCP, RowSize);
    Inc(SRCP, SrcPitch);
  end;
end;

end.
