unit Unit1;
                                
interface

uses
  Windows, Messages, SysUtils, Types, Clipbrd, Classes, Contnrs, Graphics, Controls, Forms,
  StdCtrls, asif, ComCtrls, strutils, Menus, math, inifiles,
  yshared, AppEvnts, shellapi, keymap, keydefaults, GR32_Layers, GR32_Image, GR32, AsifAdditions,
  ExtCtrls, Dialogs, jpeg;

type
  TCutRange = record
    CutStart, CutEnd: Integer
  end;

  TCutRanges = array of TCutRange;

  TPatternInfo = record
    Pattern: TIntegerDynArray;
    Offset: Integer;
    VMax: Integer;
    MMDev: Int64;
    MMSum: Int64;
    VMDev: Int64;
    VMSum: Int64;
  end;

  TPatternInfoDynArray = array of TPatternInfo;
  TPatternInfoArrayDynArray = array of TPatternInfoDynArray;

  TV1Time = class(TObject)
  private
    FFPS: Double;
    FStartFrame, FEndFrame: Integer;
  public
    property FPS: Double read FFPS;
    property StartFrame: Integer read FStartFrame write FStartFrame;
    property EndFrame: Integer read FEndFrame write FEndFrame;
    constructor Create(StartFrame, EndFrame: Integer; FPS: Double);
  end;

  TFrame = record
    Match: Byte;
    OriginalMatch: Byte;
    PostProcess: Boolean;
    Decimate: Boolean;
    MMetric: array[0..2] of Integer;
    VMetric: array[0..2] of Integer;
    DMetric: Integer;
  end;

  TForm1 = class(TForm)
    TrackBar1: TTrackBar;
    Button2: TButton;
    Button5: TButton;
    StatusBar1: TStatusBar;
    Button7: TButton;
    SaveDialog1: TSaveDialog;
    SaveDialog2: TSaveDialog;
    Button6: TButton;
    PopupMenu1: TPopupMenu;
    SaveTelecide1: TMenuItem;
    SaveDecimate1: TMenuItem;
    Button9: TButton;
    Button1: TButton;
    Timer1: TTimer;
    N2: TMenuItem;
    Button10: TButton;
    N1: TMenuItem;
    Recalculate1: TMenuItem;
    RestoreFromLog1: TMenuItem;
    OnlyCNWithVThreshConsidered1: TMenuItem;
    ShowText1: TMenuItem;
    ClearPostprocessed1: TMenuItem;
    CNOnly1: TMenuItem;
    N3: TMenuItem;
    SaveProject1: TMenuItem;
    SaveDialog5: TSaveDialog;
    Guide0Post01: TMenuItem;
    RecalculatePostprocessed1: TMenuItem;
    PlaybackSpeed1: TMenuItem;
    CombinedVandMmetric1: TMenuItem;
    Button8: TButton;
    Save1: TMenuItem;
    SetPattern1: TMenuItem;
    N4: TMenuItem;
    About1: TMenuItem;
    ClearDecimated1: TMenuItem;
    CopyToClipboard1: TMenuItem;
    ShowFrozen1: TMenuItem;
    Button4: TButton;
    Button13: TButton;
    SaveFreezeFrames1: TMenuItem;
    SaveAllOverrides1: TMenuItem;
    Button14: TButton;
    Button16: TButton;
    Button18: TButton;
    OpenCloseButton: TButton;
    OpenDialog1: TOpenDialog;
    Button20: TButton;
    Button12: TButton;
    SaveVFR1: TMenuItem;
    Additional1: TMenuItem;
    Cropping1: TMenuItem;
    DecimationbyPattern1: TMenuItem;
    SaveDialog3: TSaveDialog;
    Button15: TButton;
    Cmatchestovfr1: TMenuItem;
    PopupMenu2: TPopupMenu;
    About2: TMenuItem;
    Matchbyvmetric1: TMenuItem;
    ShowLogWindow1: TMenuItem;
    PatternGuidance1: TMenuItem;
    SceneChangeFreezeframe2: TMenuItem;
    NoDecimateassections1: TMenuItem;
    SceneChangeFreezeframewithoutthresholds1: TMenuItem;
    Switching1: TMenuItem;
    PCOnly1: TMenuItem;
    PCN1: TMenuItem;
    ApplicationEvents1: TApplicationEvents;
    Savepostprocessingoverride1: TMenuItem;
    Button3: TButton;
    Panel1: TPanel;
    AutoSaveTimer: TTimer;
    PatternGuidance2: TMenuItem;
    N6: TMenuItem;
    Useccccc1: TMenuItem;
    Usecccnn1: TMenuItem;
    Useccnnn1: TMenuItem;
    Setcpenalty1: TMenuItem;
    Setedgecutoff1: TMenuItem;
    Setminimallength1: TMenuItem;
    UseExperimentalAlgorithm1: TMenuItem;
    Image1: TImage32;
    Image2: TImage;
    SelectLowestVmetricatSectionbounds1: TMenuItem;
    SaveAudioAvs1: TMenuItem;
    SaveDialog4: TSaveDialog;
    ImageBox: TScrollBox;
    procedure TrackBar1Change(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure SaveTelecide1Click(Sender: TObject);
    procedure SaveDecimate1Click(Sender: TObject);
    procedure ShowPattern1Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ShowText1Click(Sender: TObject);
    procedure ClearPostprocessed1Click(Sender: TObject);
    procedure SaveProject1Click(Sender: TObject);
    procedure Guide0Post01Click(Sender: TObject);
    procedure RecalculatePostprocessed1Click(Sender: TObject);
    procedure PlaybackSpeed1Click(Sender: TObject);
    procedure CombinedVandMmetric1Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Save1Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure SetPattern1Click(Sender: TObject);
    procedure CopyToClipboard1Click(Sender: TObject);
    procedure Button10MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button10Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure SaveAllOverrides1Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OpenCloseButtonClick(Sender: TObject);
    procedure Button20Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure SaveFreezeFrames1Click(Sender: TObject);
    procedure SaveVFR1Click(Sender: TObject);
    procedure ShowFrozen1Click(Sender: TObject);
    procedure Cropping1Click(Sender: TObject);
    procedure RestoreFromLog1Click(Sender: TObject);
    procedure ClearDecimated1Click(Sender: TObject);
    procedure OnlyCNWithVThreshConsidered1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure DecimationbyPattern1Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Cmatchestovfr1Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Matchbyvmetric1Click(Sender: TObject);
    procedure ShowLogWindow1Click(Sender: TObject);
    procedure PatternGuidance1Click(Sender: TObject);
    procedure SceneChangeFreezeframe2Click(Sender: TObject);
    procedure SceneChangeFreezeframewithoutthresholds1Click(
      Sender: TObject);
    procedure ApplicationEvents1ShortCut(var Msg: TWMKey;
      var Handled: Boolean);
    procedure PCN1Click(Sender: TObject);
    procedure Savepostprocessingoverride1Click(Sender: TObject);
    procedure AutoSaveTimerTimer(Sender: TObject);
    procedure Setcpenalty1Click(Sender: TObject);
    procedure Setedgecutoff1Click(Sender: TObject);
    procedure Setminimallength1Click(Sender: TObject);
    procedure SelectLowestVmetricatSectionbounds1Click(Sender: TObject);
    procedure SaveAudioAvs1Click(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer; Layer: TCustomLayer);
  private
    FMultiple: Integer;
    FFieldClip: IAsifClip;
    FOriginalVideo: IAsifClip;
    FFPS: Double;
    FTBPos: Integer;
    FBuffer: TBitmap32;
    FRange: Integer;
    FRangeOn: Boolean;
    FFileOpen: Boolean;
    FSpeed: integer;
    FTryPattern: Boolean;
    FPatternStartFrame: Integer;
    FFreezeFrame: Integer;
    FInfoText: TStringList;
    FCPenalty: Double;
    FPGFrameLimit: Integer;
    FPGEdgeCutoff: Integer;
    FPanelHeight: Integer;
    FOriginalPos: TPoint;
    FTextLayer: TBitmapLayer;
    FMouseDrag: Boolean;
    FLastX: Integer;
    FLastY: Integer;

    procedure GetNext(Frame: Integer);
    procedure GetCurrent(Frame: Integer);
    procedure GetPrevious(Frame: Integer);
    procedure SetOriginalVideo(Clip: IAsifClip);
    procedure SetMultiple(M: Integer);
    function PrepareVideo(Video: IAsifClip): IAsifClip;
    procedure WMDROPFILES(var Msg: TWMDROPFILES); message WM_DROPFILES;
///////////////////////////////
    procedure SetPattern(s, e: Integer);
    procedure ResetButton;
    procedure UsePatternButton;
    procedure ShiftPattern;
  public
    FCuts: TCutRanges;
    FAudioFile: string;
    FAudioDelay: Integer;
    Distance: Integer;
    OpenMode: Byte;
    PreTelecide, PostTelecide, PreDecimate, PostDecimate, PostResize: Integer;
    BicubicB, BicubicC: Single;
    PostThreshold: Integer;
    SourceFile: string;
    ProjectFile: string;

    MatchPattern: string;
    DropPattern: string;
    PostPattern: string;
    FreezePattern: string;

    VThreshold: Integer;
    FActualFramecount: Integer;
    FrameMap, RevFrameMap: array of integer;

    property FPS: Double read FFPS;
    property FieldClip: IAsifClip read FFieldClip;
    property OriginalVideo: IAsifClip read FOriginalVideo write SetOriginalVideo;
    property Multiple: Integer read FMultiple write SetMultiple;
    property Buffer: TBitmap32 read FBuffer;
    property FileOpen: Boolean read FFileOpen write FFileOpen;
    property CPenalty: Double read FCPenalty write FCPenalty;
    property PGEdgeCutoff: Integer read FPGEdgeCutoff write FPGEdgeCutoff;
    property PGFrameLimit: Integer read FPGFrameLimit write FPGFrameLimit;

    function MakeCutLine: string;
    procedure DrawFrame();
    procedure RedrawFrame();
    procedure DecimateByPattern(S, E: Integer);
    procedure SetDefaults();
    function ConfirmDialog(): Boolean;
    function GetVMetric(Frame: Integer): Integer;
    procedure OpenSource(FileName: string);
    procedure CloseSource();
    procedure FreeProject();
    procedure SaveVOvr(FileName: string);
    procedure SaveTOvr(FileName: string);
    procedure SaveDOvr(FileName: string);
    procedure SaveAvs(FileName: string);
    procedure SaveAudioAvs(FileName: string);
    function MakeTryPattern: string;
    procedure MakePattern;
    procedure PatternGuidance(StartFrame: Integer; EndFrame: Integer; EdgeCutoff: Integer; FrameLimit: Integer; CPenalty: Double);
    function CanDecimate(Frame: Integer): Boolean;
    procedure MatchByVMetric(StartFrame: Integer; EndFrame: Integer; PWeight: Integer);
    procedure SaveProject(Filename: string);
    procedure UpdateFrameMap;
  end;

var
  FrameArray: array of TFrame;
  Form1: TForm1;
  Settings: TMemIniFile;
  MPEG2DecName: string = 'mpeg2dec3';
  PadSize: Integer = 3;
  OriginalCaption: string;
  SE: IAsifScriptEnvironment;
  PluginPath: string;

  IVTCPatternNN: TIntegerDynArray;
  IVTCPatternNNN: TIntegerDynArray;
  IVTCPatternC: TIntegerDynArray;

implementation

{$R *.dfm}

uses Unit6, Unit11, Unit2, crop, Unit7, Unit4, v2projectopen, logbox;

procedure TForm1.WMDROPFILES(var Msg: TWMDROPFILES);
var
  FileName: string;
  BufferSize: Cardinal;
begin
  BufferSize := DragQueryFile(Msg.Drop, 0, nil, 0) + 1;
  SetLength(FileName, BufferSize);
  DragQueryFile(Msg.Drop, 0, PChar(FileName), BufferSize);
  Filename := PChar(FileName);
  OpenSource(FileName);
end;

procedure TForm1.SetDefaults();
begin
  Form2.resizer.ItemIndex := 1;

  BicubicB := 1 / 3;
  BicubicC := 1 / 3;
  PreTelecide := -1;
  PostTelecide := -1;
  PreDecimate := -1;
  PostDecimate := -1;
  PostResize := -1;

  Distance := 5;

  FFreezeFrame := -1;

  PostPattern := 'ooooo';
  DropPattern := 'kkkkd';
  MatchPattern := 'ccnnc';
  FreezePattern := 'ooooo';

  FRange := 0;
  FRangeOn := False;

  FSpeed := 50;

  Multiple := 1;
end;

function TForm1.CanDecimate(Frame: Integer): Boolean;
var
  CycleStart: integer;
  Counter: integer;
begin
  CycleStart := (Frame div Distance) * Distance;
  Result := Form11.Decimation.Checked;

  if not Result then
    Exit;

  Result := Form2.NoDecimateExists(Frame, Frame);

  if Result then
    Result := False
  else
  begin
    Result := True;
    for Counter := CycleStart to Min(CycleStart + Distance - 1, TrackBar1.Max) do
      if FrameArray[Counter].Decimate then
      begin
        Result := False;
        Break;
      end;
  end;
end;

procedure TForm1.MatchByVMetric(StartFrame: Integer; EndFrame: Integer; PWeight: Integer);
var
  Counter: Integer;
begin
  for Counter := StartFrame to EndFrame do
  begin
    with FrameArray[Counter] do
      if (VMetric[1] < VMetric[0]) and (VMetric[1] < VMetric[2]) then
        Match := 1
      else if (VMetric[0] < VMetric[1]) and (VMetric[0] < FrameArray[counter].VMetric[2]) then
        Match := 0
      else if (VMetric[2] + PWeight < VMetric[0]) and (VMetric[2] + 10 < VMetric[1]) then
        Match := 2;
  end;
end;

procedure TForm1.PatternGuidance(StartFrame: Integer; EndFrame: Integer; EdgeCutoff: Integer; FrameLimit: Integer; CPenalty: Double);
  procedure HeapSort(var Arr: TPatternInfoDynArray);
  var
    N, Parent, Child: Cardinal;
    I: Integer;
    T: TPatternInfo;
  begin
    N := Length(Arr);

    if N < 2 then
      Exit;

    I := N div 2;

    while (True) do
    begin
      if (I > 0) then
      begin
        Dec(i);
        T := Arr[I];
      end
      else
      begin
        Dec(N);
        if N = 0 then
          Exit;
        T := Arr[N];
        Arr[N] := Arr[0];
      end;

      Parent := I;
      Child := I * 2 + 1;

      while (Child < n) do
      begin
        if (Child + 1 < N) and (Arr[Child + 1].MMDev > Arr[Child].MMDev) then
          Inc(child);

        if (Arr[Child].MMDev > T.MMDev) then
        begin
          Arr[Parent] := Arr[Child];
          Parent := Child;
          Child := Parent * 2 + 1;
        end
        else
          Break;
      end;

      Arr[Parent] := T;
    end;
  end;
  function GetComplementMatch(Match: Byte): Byte;
  begin
    if Match = 1 then
      Result := 0
    else
      Result := 1;
  end;
  function CalculateMetrics(const StartFrame, EndFrame: Integer; const IVTCPattern: TIntegerDynArray): TPatternInfoDynArray;
  var
    PatternCounter, TempSum, Counter: Integer;
    PatternMatch, ComplementMatch: Byte;
    PatternLength: Integer;
  begin
    PatternLength := Length(IVTCPattern);
    SetLength(Result, PatternLength);

    for PatternCounter := 0 to PatternLength - 1 do
      with Result[PatternCounter] do
      begin
        Pattern := IVTCPattern;
        Offset := PatternCounter;
        VMax := 0;
        MMSum := 0;
        MMDev := 0;
        VMSum := 0;
        VMDev := 0;

        for Counter := StartFrame to EndFrame do
        begin
          with FrameArray[Counter] do
          begin

            PatternMatch := IVTCPattern[(PatternCounter + Counter) mod PatternLength];
            ComplementMatch := GetComplementMatch(PatternMatch);

            Inc(MMSum, MMetric[PatternMatch]);

            TempSum := MMetric[PatternMatch] - MMetric[ComplementMatch];
            Inc(MMDev, Max(TempSum, 0));

            Inc(VMSum, VMetric[PatternMatch]);

            TempSum := VMetric[PatternMatch] - VMetric[ComplementMatch];
            VMax := Max(VMax, VMetric[PatternMatch]);
            Inc(VMDev, Max(TempSum, 0));

          end;
        end;
      end;

    HeapSort(Result);
  end;
var
  FinalIVTCPattern: TIntegerDynArray;
  MatchInfo, TempResult: TPatternInfoDynArray;
  MatchInfoOffset: Integer;
  MatchGroups: TPatternInfoArrayDynArray;
  Counter, FrameCounter, InCounter: Integer;
  BestOffset: Integer;
  MMD, VMD: Int64;
  TempFrame: Integer;
  MLength: Integer;
  CMLength: Integer;
  VLimit: Integer;
  AltPatterns: Integer;
  Distance: Integer;
begin
  if not (Usecccnn1.Checked or Useccnnn1.Checked or Useccccc1.Checked) then
    raise Exception.Create('No patterns selecteed');

  Logwindow.DeleteLogMessage(StartFrame);

  if EndFrame - StartFrame + 1 - 2 * EdgeCutoff < FrameLimit then
  begin
    if Form11.CheckBox15.Checked then
      Logwindow.AddLogMessage('Matching impossible (too short section): ' + IntToStr(StartFrame), StartFrame);
  end
  else
  begin
    if UseExperimentalAlgorithm1.Checked then
    begin

      Distance := 5;
      MLength := 3;
      VLimit := 60;
      AltPatterns := 2;

      SetLength(MatchGroups, (EndFrame - StartFrame) div Distance);

      for FrameCounter := 0 to (EndFrame - StartFrame) div Distance - 1 do
      begin

        SetLength(MatchInfo, 0);
        MatchInfoOffset := 0;

        if Usecccnn1.Checked then
        begin
          TempFrame := StartFrame + FrameCounter * Distance;
          TempResult := CalculateMetrics(TempFrame, TempFrame + Distance, IVTCPatternNN);
          SetLength(MatchInfo, Length(MatchInfo) + Length(TempResult));
          for Counter := 0 to Length(TempResult) - 1 do
            MatchInfo[MatchInfoOffset + Counter] := TempResult[Counter];
          Inc(MatchInfoOffset, Length(TempResult));
        end;

        if Useccnnn1.Checked then
        begin
          TempFrame := StartFrame + FrameCounter * Distance;
          TempResult := CalculateMetrics(TempFrame, TempFrame + Distance, IVTCPatternNNN);
          SetLength(MatchInfo, Length(MatchInfo) + Length(TempResult));
          for Counter := 0 to Length(TempResult) - 1 do
            MatchInfo[MatchInfoOffset + Counter] := TempResult[Counter];
          Inc(MatchInfoOffset, Length(TempResult));
        end;

        if Useccccc1.Checked then
        begin
          TempFrame := StartFrame + FrameCounter * Distance;
          TempResult := CalculateMetrics(TempFrame, TempFrame + Distance, IVTCPatternC);
          SetLength(MatchInfo, Length(MatchInfo) + Length(TempResult));
          for Counter := 0 to Length(TempResult) - 1 do
            MatchInfo[MatchInfoOffset + Counter] := TempResult[Counter];
          Inc(MatchInfoOffset, Length(TempResult));
        end;

        HeapSort(MatchInfo);

        MatchGroups[FrameCounter] := MatchInfo;

      end;

      //find ranges with consecutive similar blocks

      CMLength := 1;

      for Counter := 1 to Length(MatchGroups) - 1 do
      begin
        if (MatchGroups[Counter][0].Pattern = MatchGroups[Counter - 1][0].Pattern)
          and (MatchGroups[Counter][0].Offset = MatchGroups[Counter - 1][0].Offset)
          and (MatchGroups[Counter][0].VMax < VLimit)
          and (MatchGroups[Counter - 1][0].VMax < VLimit) then
          Inc(CMLength, 1)
        else
          CMLength := 1;

        if (CMLength >= MLength) then
        begin
          for InCounter := 0 to CMLength - 1 do
            SetLength(MatchGroups[Counter - InCounter], 1);
        end;
      end;

      //push right

      for Counter := 1 to Length(MatchGroups) - 1 do
      begin
        if (Length(MatchGroups[Counter - 1]) = 1) and (Length(MatchGroups[Counter]) > 1) then
          with MatchGroups[Counter - 1][0] do
          begin
            for InCounter := 1 to AltPatterns do
              if (MatchGroups[Counter][InCounter].Pattern = Pattern) and
                (MatchGroups[Counter][InCounter].Offset = Offset) and
                (MatchGroups[Counter][InCounter].VMax < VLimit) then
              begin
                MatchGroups[Counter][0] := MatchGroups[Counter][InCounter];
                SetLength(MatchGroups[Counter], 1);
                Break;
              end;
          end;
      end;

      //push left

      for Counter := Length(MatchGroups) - 2 downto 0 do
      begin
        if (Length(MatchGroups[Counter + 1]) = 1) and (Length(MatchGroups[Counter]) > 1) then
          with MatchGroups[Counter + 1][0] do
          begin
            for InCounter := 1 to AltPatterns do
              if (MatchGroups[Counter][InCounter].Pattern = Pattern) and
                (MatchGroups[Counter][InCounter].Offset = Offset) and
                (MatchGroups[Counter][InCounter].VMax < VLimit) then
              begin
                MatchGroups[Counter][0] := MatchGroups[Counter][InCounter];
                SetLength(MatchGroups[Counter], 1);
                Break;
              end;
          end;
      end;

      //try to fill in ranges

      //apply matches

      for Counter := 0 to Distance * Length(MatchGroups) - 1 do
        if Length(MatchGroups[Counter div Distance]) = 1 then
          with MatchGroups[Counter div Distance][0] do
            FrameArray[StartFrame + Counter].Match := Pattern[(StartFrame + Counter + Offset) mod Length(Pattern)];

      //push right by frame

      //push left by frame

      InCounter := 0;
      CMLength := 0;

      for Counter := 1 to Length(MatchGroups) - 1 do
      begin
        if Length(MatchGroups[Counter]) > 1 then
          Inc(InCounter, 5);

        if (Length(MatchGroups[Counter - 1]) > 1) and (Length(MatchGroups[Counter]) = 1) then
          CMLength := StartFrame + Counter * Distance;

        if (Length(MatchGroups[Counter - 1]) = 1) and (Length(MatchGroups[Counter]) > 1) then
          Logwindow.AddLogMessage(Format('%d - %d (%d)', [CMLength, StartFrame + Counter * Distance, StartFrame + Counter * Distance - CMLength]), StartFrame + Counter * Distance);
      end;

      Logwindow.AddLogMessage(Format('%d/%d', [InCounter, EndFrame - StartFrame + 1]));
    end
    else
    begin

      FinalIVTCPattern := nil;

      BestOffset := 0;

      MMD := High(MMD);
      VMD := High(VMD);

      if Usecccnn1.Checked then
        with CalculateMetrics(StartFrame + EdgeCutoff, EndFrame - EdgeCutoff, IVTCPatternNN)[0] do
        begin
          if MMDev < MMD then
          begin
            FinalIVTCPattern := IVTCPatternNN;
            BestOffset := Offset;
            MMD := MMDev;
            VMD := VMDev;
          end;
        end;

      if Useccnnn1.Checked then
        with CalculateMetrics(StartFrame + EdgeCutoff, EndFrame - EdgeCutoff, IVTCPatternNNN)[0] do
        begin
          if MMDev < MMD then
          begin
            FinalIVTCPattern := IVTCPatternNNN;
            BestOffset := Offset;
            MMD := MMDev;
            VMD := VMDev;
          end;
        end;

      if Useccccc1.Checked then
        with CalculateMetrics(StartFrame + EdgeCutoff, EndFrame - EdgeCutoff, IVTCPatternC)[0] do
        begin
          if MMDev < MMD then
          begin
            FinalIVTCPattern := IVTCPatternC;
            BestOffset := Offset;
            MMD := MMDev;
            VMD := VMDev;
          end;
        end;

      if (EndFrame - StartFrame + 1) < VMD then
      begin
        Logwindow.AddLogMessage('Matching failure at: ' + IntToStr(StartFrame), StartFrame);
        if not Logwindow.Visible then
          Logwindow.Show;
        Exit;
      end;

      for Counter := StartFrame to EndFrame do
      begin
        FrameArray[Counter].Decimate := False;
        FrameArray[Counter].PostProcess := False;
      end;

      Assert(FinalIVTCPattern <> nil);

      for Counter := StartFrame to EndFrame do
        FrameArray[Counter].Match := FinalIVTCPattern[(Counter + BestOffset) mod Length(FinalIVTCPattern)];

    //use p match if the range end is too bad
      with FrameArray[EndFrame] do
        if MMetric[Match] > MMetric[2] * 1.5 then
          Match := 2;

    end;

    if Form11.PGDecimation.Checked then
      DecimateByPattern(StartFrame, EndFrame);

  //no n match in the last frame
    if EndFrame = TrackBar1.Max then
      FrameArray[EndFrame].Match := Max(1, FrameArray[EndFrame].Match);

  //no p match in the first
    if (StartFrame = 0) then
      FrameArray[0].Match := Min(1, FrameArray[0].Match);

  end;
end;

procedure TForm1.UpdateFrameMap;
  procedure GetNextRange(var B, E: integer);
  var I: Integer;
  begin
    for I := 0 to Form2.Nodecimates.Items.Count - 1 do
      with Form2.Nodecimates.Items.Objects[I] as TDecimateInfo do
        if (StartFrame > B) then
        begin
          B := StartFrame;
          E := EndFrame;
          Exit;
        end;

    B := High(B);
    E := High(E);
  end;

  function CanDecimateQuick(Frame, RangeStart: Integer): Boolean;
  var
    CycleStart: Integer;
    I: Integer;
  begin
    Result := Frame < RangeStart;
    if not Result then
      Exit;

    CycleStart := (Frame div Distance) * Distance;

    if TrackBar1.Max < CycleStart + Distance - 1 then
      Exit;

    for I := CycleStart to CycleStart + Distance - 1 do
      if FrameArray[I].Decimate then
      begin
        Result := False;
        Break;
      end;
  end;

var
  Counter, AFC: Integer;
  NextStart, NextEnd: Integer;
begin
  if (OpenMode in matchingprojects) and Form11.Decimation.Checked then
  begin
    AFC := 0;
    NextStart := -1;
    GetNextRange(NextStart, NextEnd);

    for Counter := 0 to TrackBar1.Max do
    begin
      FrameMap[Counter] := AFC;

      if (Counter > NextEnd) then
        GetNextRange(NextStart, NextEnd);

      Inc(AFC);

      if (CanDecimateQuick(Counter, NextStart) and (Counter mod Distance = 0)) or FrameArray[Counter].Decimate then
        Dec(AFC);
    end;

//ugly fix?
    if TrackBar1.Max mod Distance = 0 then
      Dec(FrameMap[TrackBar1.Max]);

  end
  else
  begin
    for Counter := 0 to TrackBar1.Max do
      FrameMap[Counter] := Counter;
  end;

  // adjust for dropped sections

  for Counter := TrackBar1.Max downto 0 do
    RevFrameMap[FrameMap[Counter]] := Counter;
end;


procedure TForm1.SaveTOvr(FileName: string);
var
  Counter: Integer;
  SL: TStringList;
begin
  SL := TStringList.Create;

  if Form11.RadioGroup1.ItemIndex = 1 then
    for Counter := 0 to TrackBar1.Max do
      case FrameArray[Counter].Match of
        0: SL.Append(Format('%d,%d,%s', [Counter + 1, Counter, IfThen(FrameArray[counter].PostProcess, '+', '-')]));
        1: SL.Append(Format('%d,%d,%s', [Counter, Counter, IfThen(FrameArray[counter].PostProcess, '+', '-')]));
        2: SL.Append(Format('%d,%d,%s', [Counter, Counter - 1, IfThen(FrameArray[counter].PostProcess, '+', '-')]));
      end
  else
    for Counter := 0 to TrackBar1.Max do
    begin
      case FrameArray[counter].Match of
        0: SL.Append(Format('%d,%d,%s', [Counter, Counter + 1, IfThen(FrameArray[counter].PostProcess, '+', '-')]));
        1: SL.Append(Format('%d,%d,%s', [Counter, Counter, IfThen(FrameArray[counter].PostProcess, '+', '-')]));
        2: SL.Append(Format('%d,%d,%s', [Counter - 1, Counter, IfThen(FrameArray[counter].PostProcess, '+', '-')]));
      end;
    end;

  try
    SL.SaveToFile(FileName);
  except
    MessageDlg('Error while saving matching file.', mtError, [mbok], 0);
  end;

  SL.Free;
end;

procedure TForm1.SaveDOvr(FileName: string);
var
  Counter: Integer;
  SL: TStringList;
begin
  SL := TStringList.Create;

  if Form2.DecimateType.ItemIndex = 0 then
  begin
    for Counter := 0 to TrackBar1.Max do
      if FrameArray[Counter].Decimate then
        SL.Append(IntToStr(Counter));
  end
  else
  begin
    for Counter := 0 to TrackBar1.Max do
      if FrameArray[Counter].Decimate then
        SL.Append(IntToStr(Counter) + ' -');
  end;

  try
    SL.SaveToFile(FileName);
  except
    MessageDlg('Error while saving decimation overrides', mtError, [mbok], 0);
  end;

  SL.Free;
end;


function TForm1.GetVMetric(Frame: Integer): Integer;
begin
  if (Frame < 0) or (Frame > TrackBar1.Max) then
    Result := 0
  else
    Result := FrameArray[Frame].VMetric[FrameArray[Frame].Match];
end;

procedure TForm1.FreeProject;
  procedure ClearObjectItems(Items: TStrings);
  var
    Counter: Integer;
  begin
    for Counter := Items.Count - 1 downto 0 do
      Items.Objects[Counter].Free;
    Items.Clear;
  end;
begin
  Timer1.Enabled := False;

  FileOpen := False;

  FOriginalVideo := nil;
  FFieldClip := nil;

  ClearObjectItems(Form2.Freezeframes.Items);
  ClearObjectItems(Form2.Nodecimates.Items);
  ClearObjectItems(Form2.SectionListBox.Items);

  Form2.CustomRanges.Count := 0;

  ClearObjectItems(Form2.CustomRangeLists.Items);
  ClearObjectItems(Form2.PresetListBox.Items);

  Form2.ComboBox2.Clear;

  Logwindow.ClearLog;

  SetLength(FCuts, 0);

  SaveDialog5.FileName := '';

  Form1.FAudioFile := '';
  Form1.FAudioDelay := 0;
  Form11.AudioFileEdit.Text := '';
  Form11.AudioDelayLabeledEdit.Text := '0';

  Form2.Close;
  Logwindow.Close;
  Form4.Close;
  SetLength(FrameMap, 0);
  SetLength(FrameArray, 0);
  SetLength(RevFrameMap, 0);
  SetDefaults;
  OpenCloseButton.Caption := 'Open';
  EnableByProjectType(255);
end;

function TForm1.ConfirmDialog(): Boolean;
begin
  Result := MessageDlg('This operation can''t be undone.'#13'Continue?', mtWarning, mbOKCancel, 0) = mrOk;
end;

function TForm1.MakeTryPattern: string;
var
  Counter: Integer;
begin
  for Counter := IfThen(TrackBar1.Position - 10 >= 0, TrackBar1.Position - 10, 0) to IfThen(TrackBar1.Position + 10 <= TrackBar1.Max, TrackBar1.Position + 10, TrackBar1.Max) do
  begin
    if TrackBar1.Position = Counter then
      Result := Result + UpperCase(MatchPattern[(Counter - FPatternStartFrame + 10 * Length(MatchPattern)) mod length(MatchPattern) + 1])
    else
      Result := Result + MatchPattern[(Counter - FPatternStartFrame + 10 * Length(MatchPattern)) mod length(MatchPattern) + 1];
  end;
end;

procedure TForm1.MakePattern;
var
  TempPattern: Char;
  Counter: Integer;
begin
  FTextLayer.Bitmap.Canvas.MoveTo(15, 25);
  TempPattern := 'A';

  for Counter := IfThen(TrackBar1.Position - 10 >= 0, TrackBar1.Position - 10, 0) to IfThen(TrackBar1.Position + 10 < TrackBar1.Max, TrackBar1.Position + 10, TrackBar1.Max) do
  begin
    if Counter mod Distance = 0 then
      FTextLayer.Bitmap.Canvas.Font.Style := [fsUnderline]
    else
      FTextLayer.Bitmap.Canvas.Font.Style := [];

    if FrameArray[Counter].Decimate then
      FTextLayer.Bitmap.Canvas.Font.Style := FTextLayer.Bitmap.Canvas.Font.Style + [fsStrikeOut];

    case FrameArray[Counter].Match of
      0: TempPattern := 'n';
      1: TempPattern := 'c';
      2: TempPattern := 'p';
    end;

    if TrackBar1.Position = Counter then
      TempPattern := UpCase(TempPattern);

    FTextLayer.Bitmap.Canvas.TextOut(FTextLayer.Bitmap.Canvas.PenPos.X, FTextLayer.Bitmap.Canvas.PenPos.Y, TempPattern);
  end;

  FTextLayer.Bitmap.Canvas.Font.Style := [];
end;

function GetFrozenFrameNumber(Frame: Integer): Integer;
var
  Counter: Integer;
begin
  Result := Frame;
  for Counter := 0 to Form2.Freezeframes.Count - 1 do
    with Form2.Freezeframes.Items.Objects[Counter] as TFreezeInfo do
      if (StartFrame <= Frame) and (EndFrame >= Frame) then
      begin
        Result := From;
        Break;
      end;
end;

procedure TForm1.DrawFrame();
var
  AFN: Integer;
  Rind: TDecimateInfo;
  Counter, C2: Integer;
  FromFrame: Integer;
  Sif: TSectionInfo;
  DecimateCurrent, PostCurrent: Boolean;
begin
  if not FileOpen then
    Exit;

  FTextLayer.Bitmap.Clear(clBlue32);

  FromFrame := GetFrozenFrameNumber(TrackBar1.Position);

  if ShowFrozen1.Checked then
    AFN := FromFrame
  else
    AFN := TrackBar1.Position;

  if FTryPattern and (FPatternStartFrame <= TrackBar1.Position) then
  begin
    case MatchPattern[((TrackBar1.Position - FPatternStartFrame) mod Length(MatchPattern)) + 1] of
      'n': GetNext(TrackBar1.Position);
      'c': GetCurrent(TrackBar1.Position);
      'p': GetPrevious(TrackBar1.Position);
    else
      case FrameArray[TrackBar1.Position].Match of
        0: if TrackBar1.Position < TrackBar1.Max then GetNext(TrackBar1.Position);
        1: GetCurrent(TrackBar1.Position);
        2: if TrackBar1.Position > 0 then GetPrevious(TrackBar1.Position);
      end;
    end;
    if Form11.CheckBox4.Checked then
      FInfoText.Append(MakeTryPattern + ' (Pattern Test)');
  end
  else
  begin
    case FrameArray[AFN].Match of
      0: if TrackBar1.Position < TrackBar1.Max then GetNext(AFN);
      1: GetCurrent(AFN);
      2: if TrackBar1.Position > 0 then GetPrevious(AFN);
    end;
  end;

  Sif := Form2.SectionInfo(TrackBar1.Position);

  if ShowText1.Checked then
  begin

    if form11.CheckBox3.Checked then
      FInfoText.Insert(0, form2.GetPresetName(Sif.Preset) + '; Start: ' + IntToStr(sif.startframe) + '; End: ' + IntToStr(sif.endframe));

    if form11.CheckBox4.Checked and (OpenMode in MatchingProjects) then
      makepattern();

    postcurrent := FrameArray[TrackBar1.Position].postprocess;
    decimatecurrent := FrameArray[TrackBar1.Position].Decimate;

    if FTryPattern and (FPatternStartFrame <= TrackBar1.Position) then
    begin
      case DropPattern[((TrackBar1.Position - FPatternStartFrame) mod Length(droppattern)) + 1] of
        'd': decimatecurrent := true;
        'k': decimatecurrent := false;
      end;

      case postpattern[((TrackBar1.Position - FPatternStartFrame) mod Length(postpattern)) + 1] of
        '+': postcurrent := true;
        '-': postcurrent := false;
      end;

      case freezepattern[((TrackBar1.Position - FPatternStartFrame) mod Length(freezepattern)) + 1] of
        'n': FInfoText.Append('Replace with next');
        'p': FInfoText.Append('Replace with previous');
      end;
    end;

    if form11.ShowCLInfo.Checked and (Form2.CustomRangeLists.ItemIndex >= 0) then
      FInfoText.Append('Range List: ' + Form2.CustomRangeLists.Items[Form2.CustomRangeLists.ItemIndex]);

    if decimatecurrent then
      FInfoText.Append('Decimate')
    else if postcurrent then
      FInfoText.Append('Postprocess');

    FTextLayer.Bitmap.Canvas.Lock;

    if Form11.CheckBox8.Checked and form11.CheckBox2.Checked and (OpenMode in MatchingProjects) then
    begin
      FTextLayer.Bitmap.Canvas.TextOut(15, 10, 'Frame: ' + inttostr(TrackBar1.Position));
      FTextLayer.Bitmap.Canvas.TextOut(90, 10, 'MMetric: ' + inttostr(FrameArray[TrackBar1.Position].mmetric[FrameArray[TrackBar1.Position].Match]));
      FTextLayer.Bitmap.Canvas.TextOut(185, 10, 'DMetric: ' + IntToStr(FrameArray[TrackBar1.Position].DMetric));
      FTextLayer.Bitmap.Canvas.TextOut(275, 10, 'VMetric: ' + inttostr(FrameArray[TrackBar1.Position].vmetric[FrameArray[TrackBar1.Position].Match]));
    end
    else if Form11.CheckBox2.Checked and (OpenMode in MatchingProjects) then
    begin
      FTextLayer.Bitmap.Canvas.TextOut(15, 10, 'MMetric: ' + IntToStr(FrameArray[TrackBar1.Position].mmetric[FrameArray[TrackBar1.Position].Match]));
      FTextLayer.Bitmap.Canvas.TextOut(105, 10, 'DMetric: ' + IntToStr(FrameArray[TrackBar1.Position].DMetric));
      FTextLayer.Bitmap.Canvas.TextOut(195, 10, 'VMetric: ' + IntToStr(FrameArray[TrackBar1.Position].vmetric[FrameArray[TrackBar1.Position].Match]));
    end
    else if Form11.CheckBox8.Checked then
      FTextLayer.Bitmap.Canvas.TextOut(15, 10, 'Frame: ' + IntToStr(TrackBar1.Position));

    FTextLayer.Bitmap.Canvas.Unlock;

    if fromframe <> TrackBar1.Position then
      if form11.CheckBox5.Checked then
        FInfoText.Append('Frozen, Frame used: ' + IntToStr(fromframe));

    Rind := Form2.GetNoDecimateRange(TrackBar1.Position);
    if Rind <> nil then
      FInfoText.Append('NoDecimate, Start: ' + IntToStr(Rind.StartFrame) + '; End: ' + IntToStr(rind.endframe));

    if Form11.ShowCLInfo.Checked then
      for Counter := 0 to form2.CustomRangeLists.Count - 1 do
        with Form2.CustomRangeLists.Items.Objects[counter] as TCustomList do
          for c2 := 0 to Count - 1 do
            with Items[c2] as TCustomRange do
              if (startframe <= TrackBar1.Position) and (endframe >= TrackBar1.Position) then
                FInfoText.Append('CL: ' + name);

    for Counter := 0 to FInfoText.Count - 1 do
      FTextLayer.Bitmap.Canvas.TextOut(15, 40 + counter * 15, FInfoText[counter]);

  end;

  FInfoText.Clear;

  if FTryPattern then
    StatusBar1.SimpleText := 'Frame: ' + inttostr(TrackBar1.Position) + '; Time: ' + timeinsecondstostr(trackbar1.position / fps) + '; Pattern Start: ' + IntToStr(FPatternStartFrame)
  else if FRangeOn then
    StatusBar1.SimpleText := 'Frame: ' + inttostr(TrackBar1.Position) + '; Time: ' + timeinsecondstostr(trackbar1.position / fps) + '; Range Start: ' + IntToStr(FRange)
  else if (distance > 1) and (OpenMode in MatchingProjects) then
    StatusBar1.SimpleText := 'Frame: ' + inttostr(TrackBar1.Position) + '; Decimated Frame: ' + inttostr(framemap[TrackBar1.Position]) + '; Time: ' + timeinsecondstostr(trackbar1.position / fps)
  else
    StatusBar1.SimpleText := 'Frame: ' + IntToStr(TrackBar1.Position) + '; Time: ' + timeinsecondstostr(trackbar1.position / fps);

  Image1.Bitmap.Assign(Buffer);

  Update;

  if Form2.Visible then
    Form2.Update;
end;

procedure TForm1.GetNext(Frame: Integer);
begin
  if Form11.RadioGroup1.ItemIndex = 1 then
    FieldAssemble(Frame, Frame + 1, FieldClip, Buffer)
  else
    FieldAssemble(Frame + 1, Frame, FieldClip, Buffer);
end;

procedure TForm1.GetCurrent(Frame: Integer);
begin
  FieldAssemble(Frame, Frame, FieldClip, Buffer)
end;

procedure TForm1.GetPrevious(Frame: Integer);
begin
  if Form11.RadioGroup1.ItemIndex = 1 then
    FieldAssemble(Frame - 1, Frame, FieldClip, Buffer)
  else
    FieldAssemble(Frame, Frame - 1, FieldClip, Buffer);
end;

procedure TForm1.TrackBar1Change(Sender: TObject);
var
  SectionInfo: TSectionInfo;
  Counter: Integer;
begin
  if not FileOpen then
    Exit;

  if (FTBPos <> TrackBar1.Position) then
  begin

    SectionInfo := Form2.sectioninfo(TrackBar1.Position);
    for Counter := 0 to Form2.PresetCount - 1 do
    begin
      if Form2.Presets[Counter].Id = SectionInfo.Preset then
      begin
        Form2.PresetListBox.ItemIndex := Counter;
        Break;
      end;
    end;


    for Counter := 0 to Form2.SectionCount - 1 do
    begin
      if Form2.Sections[Counter].StartFrame = SectionInfo.StartFrame then
      begin
        Form2.SectionListBox.ItemIndex := Counter;
        Form2.SectionListBox.Selected[Counter] := True;
      end
      else
        Form2.SectionListBox.Selected[Counter] := False;
    end;

    FTBPos := TrackBar1.Position;

    DrawFrame;
  end;
end;

procedure TForm1.Button6Click(Sender: TObject);
var
  Counter: Integer;
begin
  if FRangeOn then
  begin
    for Counter := FRange to TrackBar1.Position do
      FrameArray[Counter].PostProcess := not FrameArray[TrackBar1.Position].PostProcess;
    FRangeOn := False;
  end
  else
    FrameArray[TrackBar1.Position].PostProcess := not FrameArray[TrackBar1.Position].PostProcess;

  DrawFrame;
end;

procedure TForm1.SaveTelecide1Click(Sender: TObject);
begin
  if SaveDialog1.Execute then
    SaveTOvr(SaveDialog1.FileName);
end;

procedure TForm1.SaveDecimate1Click(Sender: TObject);
begin
  if SaveDialog2.Execute then
    SaveDOvr(SaveDialog2.FileName);
end;

procedure TForm1.ShowPattern1Click(Sender: TObject);
begin
  DrawFrame;
end;

procedure TForm1.ShiftPattern;
var
  T: Char;
  I: Integer;
begin
  T := MatchPattern[Length(MatchPattern)];

  for I := Length(MatchPattern) downto 2 do
    MatchPattern[I] := MatchPattern[I - 1];

  MatchPattern[1] := T;

  T := DropPattern[Length(DropPattern)];

  for I := Length(DropPattern) downto 2 do
    DropPattern[I] := DropPattern[I - 1];

  DropPattern[1] := T;

  T := PostPattern[Length(PostPattern)];

  for I := Length(PostPattern) downto 2 do
    PostPattern[I] := PostPattern[I - 1];

  PostPattern[1] := T;

  T := FreezePattern[Length(FreezePattern)];

  for I := Length(FreezePattern) downto 2 do
    FreezePattern[I] := FreezePattern[I - 1];

  FreezePattern[1] := T;
end;

procedure TForm1.Button9Click(Sender: TObject);
begin
  if FTryPattern then
  begin
    ShiftPattern;
  end
  else
  begin
    case FrameArray[TrackBar1.Position].Match of
      0: inc(FrameArray[TrackBar1.Position].Match);
      1: if (TrackBar1.Position = 0) or (CNOnly1.Checked and not (TrackBar1.Position = TrackBar1.Max)) then FrameArray[TrackBar1.Position].Match := 0 else inc(FrameArray[TrackBar1.Position].Match);
      2: if (TrackBar1.Position = TrackBar1.Max) or (PCOnly1.Checked) then FrameArray[TrackBar1.Position].Match := 1 else FrameArray[TrackBar1.Position].Match := 0;
    end;

    FrameArray[TrackBar1.Position].PostProcess := false;
  end;

  DrawFrame();
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Timer1.Interval := 1000 div FSpeed;
  Timer1.Enabled := not Timer1.Enabled;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  TrackBar1.Position := TrackBar1.Position + 1;

  if (VThreshold < GetVMetric(TrackBar1.Position)) and not IsKeyPressed(kIgnoreHighVOnPlay) then
    Timer1.Enabled := false
  else if (TrackBar1.Position = TrackBar1.Max) then
    Timer1.Enabled := false;
end;

procedure TForm1.ShowText1Click(Sender: TObject);
begin
  DrawFrame();
end;

procedure TForm1.ClearPostprocessed1Click(Sender: TObject);
var
  Counter: Integer;
begin
  if ConfirmDialog then
  begin
    for Counter := 0 to Length(FrameArray) - 1 do
      FrameArray[Counter].PostProcess := False;
    DrawFrame();
  end;
end;

procedure TForm1.SaveProject1Click(Sender: TObject);
var nf: boolean;
begin
  nf := SaveDialog5.FileName = '';

  if nf then
    SaveDialog5.FileName := OpenDialog1.FileName + '.yap';

  if SaveDialog5.Execute then
  begin
    OpenDialog1.FileName := SaveDialog5.FileName;
    SaveProject(SaveDialog5.FileName);
  end
  else
  begin

    if nf then
      SaveDialog5.FileName := '';

    Abort;

  end;
end;

procedure TForm1.Guide0Post01Click(Sender: TObject);
var counter: Integer;
begin
  if ConfirmDialog then
  begin
    for counter := 0 to length(FrameArray) - 1 do
      if FrameArray[counter].MMetric[0] < FrameArray[counter].MMetric[1] then
        FrameArray[counter].Match := 0
      else
        FrameArray[counter].Match := 1;

    DrawFrame();
  end;
end;

procedure TForm1.RecalculatePostprocessed1Click(Sender: TObject);
var counter, vt: integer;
begin
  if ConfirmDialog then
  begin
    vt := VThreshold;
    SetVariablePrompt(vt, 0);

    for counter := 0 to length(FrameArray) - 1 do
      FrameArray[counter].PostProcess := vt < FrameArray[counter].VMetric[FrameArray[counter].Match];

    DrawFrame();
  end;
end;

procedure TForm1.PlaybackSpeed1Click(Sender: TObject);
var s: string;
begin
  s := IntToStr(FSpeed);
  if InputQuery('Playback Speed', 'FPS:', s) then
    FSpeed := StrToIntDef(s, -1);

  if FSpeed <= 0 then
    FSpeed := 30;
end;

procedure TForm1.CombinedVandMmetric1Click(Sender: TObject);
var s: string;
  i: integer;
  counter, vt: integer;
begin
  if ConfirmDialog then
  begin
    vt := 50;
    SetVariablePrompt(vt, 0);
    s := '200';
    if InputQuery('VThresh Const', 'Factor:', s) then
    begin
      i := StrToIntDef(s, 200);

      for counter := 0 to Length(FrameArray) - 1 do
        if FrameArray[counter].MMetric[0] + FrameArray[counter].VMetric[0] * i >= FrameArray[counter].MMetric[1] + FrameArray[counter].VMetric[1] * i then
          FrameArray[counter].Match := 1
        else
          FrameArray[counter].Match := 0;

      for counter := 0 to Length(FrameArray) - 1 do
        if (FrameArray[counter].VMetric[FrameArray[counter].Match] > vt) and (FrameArray[counter].VMetric[FrameArray[counter].Match xor 1] < vt) then
          FrameArray[counter].Match := FrameArray[counter].Match xor 1;

    end;

    DrawFrame;
  end;

end;

procedure TForm1.Button8Click(Sender: TObject);
begin
  FRangeOn := not FRangeOn;
  FRange := TrackBar1.Position;

  FFreezeFrame := -1;

  FTryPattern := False;

  DrawFrame();
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FileOpen then
  begin
    case MessageDlg('Do you want to save before quitting?', mtConfirmation, mbYesNoCancel, 0) of
      mrCancel: Abort;
      mrYes: Save1Click(self);
      mrno: ;
    end;
  end;

  if FileOpen then
    FreeProject;
end;

procedure TForm1.SaveProject(Filename: string);
const
  MatchCharLUT: array[0..2] of Char = ('n', 'c', 'p');
var
  SL: TStringList;
  Counter, C2: integer;
  List: TCustomList;
  I: Integer;
  CutList: string;
begin
  if Filename = '' then
    raise Exception.Create('No filename given to save to');

  CutList := '';
  for I := 0 to Length(FCuts) - 1 do
    with FCuts[I] do
      CutList := CutList + Format('%d,%d,', [CutStart, CutEnd]);
  CutList := LeftStr(CutList, Length(CutList) - 1);

  SL := TStringList.Create;

  with SL do
  begin
    Append('[YATTA V2]');
    Append('SAVEDBY=' + OriginalCaption);
    Append('LASTVIDEOPATH=' + SourceFile);
    Append('TYPE=' + IntToStr(OpenMode));
    Append('ORDER=' + IntToStr(Form11.RadioGroup1.ItemIndex));
    Append('FRAME=' + IntToStr(TrackBar1.Position));
    Append('FRAMECOUNT=' + IntToStr(FActualFramecount));
    Append('MPEG2DECODER=' + MPEG2DecName);
    Append('CUTLIST=' + CutList);
    Append('AUDIOFILE=' + FAudioFile);
    Append('AUDIODELAY=' + IntToStr(FAudioDelay));
    Append('HASLOOKEDFORAUDIO=1');
    Append('WITHDECIMATION=' + BoolToStr(Form11.Decimation.Checked));
    Append('DISTANCE=' + IntToStr(Distance));
    Append('DECIMATETYPE=' + IntToStr(Form2.DecimateType.ItemIndex));
    Append('VSETTING=' + IntToStr(Form2.vfindmethod.ItemIndex));
    Append('POSTPATTERN=' + PostPattern);
    Append('MATCHPATTERN=' + MatchPattern);
    Append('DROPPATTERN=' + DropPattern);
    Append('FREEZEPATTERN=' + FreezePattern);
    Append('NOPATTERN=' + BoolToStr(Form6.AskOnTryPattern.Checked));
    Append('RESIZER=' + IntToStr(Form2.Resizer.ItemIndex));
    Append('POSTPROCESSOR=' + IntToStr(Form2.PostProcessor.ItemIndex));
    Append('POSTTHRESHOLD=' + IntToStr(PostThreshold));
    Append('SHARPKERNEL=' + BoolToStr(Form2.SharpKernel.Checked));
    Append('TWOWAYKERNEL=' + BoolToStr(Form2.twowaykernel.Checked));
    Append('XRES=' + IntToStr(CropForm.ResizeWidthUpDown.Position));
    Append('YRES=' + IntToStr(CropForm.ResizeHeightUpDown.Position));
    Append('X1=' + IntToStr(CropForm.CropLeftUpDown.Position));
    Append('X2=' + IntToStr(CropForm.CropRightUpDown.Position));
    Append('Y1=' + IntToStr(CropForm.CropTopUpdown.Position));
    Append('Y2=' + IntToStr(CropForm.CropBottomUpDown.Position));
    Append('ANAMORPHIC=' + BoolToStr(CropForm.Anamorphic.Checked));
    Append('CROP=' + BoolToStr(Form2.CropOn.Checked));
    Append('BICUBIC_B=' + FloatToStr(BicubicB));
    Append('BICUBIC_C=' + FloatToStr(BicubicC));
    Append('PRETELECIDE2=' + IntToStr(PreTelecide));
    Append('POSTTELECIDE2=' + IntToStr(PostTelecide));
    Append('PREDECIMATE2=' + IntToStr(PreDecimate));
    Append('POSTDECIMATE2=' + IntToStr(PostDecimate));
    Append('POSTRESIZE2=' + IntToStr(PostResize));
    Append('HASIMPORTEDDEFAULTSETTINGS=1');
    Append('');
    Append('[PRESETS]');

    for Counter := 0 to Form2.PresetCount - 1 do
      with Form2.Presets[Counter] do
        Append(Format('%d,%d,"%s",%s', [Id, Color, Form2.PresetListBox.Items[Counter], AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(AnsiQuotedStr(Form2.Presets[Counter].chain, '"'), '^', ''), #13#10, '^'), #10, '^'), #13, '^')]));

    Append('');

    if OpenMode in MatchingProjects then
    begin

      for Counter := 0 to TrackBar1.Max do
        with FrameArray[Counter] do
        begin
          if (MMetric[0] <> 0) or (MMetric[1] <> 0) or (MMetric[2] <> 0) or (VMetric[0] <> 0) or (VMetric[1] <> 0) or (VMetric[2] <> 0) then
          begin
            Append('[METRICS]');

            for C2 := 0 to TrackBar1.Max do
              with FrameArray[C2] do
                Append(Format('%d %d %d %d %d %d', [MMetric[0], MMetric[1], MMetric[2], VMetric[0], VMetric[1], VMetric[2]]));

            Break;
          end;
        end;

      Append('');

      Append('[MATCHES]');

      for Counter := 0 to TrackBar1.Max do
        Append(MatchCharLUT[FrameArray[Counter].Match]);

      Append('');
      Append('[ORIGINALMATCHES]');

      for Counter := 0 to TrackBar1.Max do
        Append(MatchCharLUT[FrameArray[Counter].OriginalMatch]);

      Append('');

      Append('[POSTPROCESS]');

      for Counter := 0 to TrackBar1.Max do
        if FrameArray[Counter].PostProcess then
          Append(IntToStr(Counter));

      Append('');

      Append('[DECIMATE]');

      for counter := 0 to TrackBar1.Max do
        if FrameArray[Counter].Decimate then
          Append(IntToStr(Counter));

      Append('');

      Append('[NODECIMATE]');

      for Counter := 0 to Form2.Nodecimates.Items.Count - 1 do
        with Form2.Nodecimates.Items.Objects[Counter] as TDecimateInfo do
          Append(Format('%d^%d^0', [StartFrame, EndFrame]));

      Append('');

    end;

    Append('[FREEZE]');

    for Counter := 0 to Form2.Freezeframes.Items.Count - 1 do
      with Form2.Freezeframes.Items.Objects[Counter] as TFreezeInfo do
        Append(Format('%d,%d,%d', [StartFrame, EndFrame, From]));

    Append('');

    Append('[SECTIONS]');

    for Counter := 0 to Form2.SectionCount - 1 do
      with Form2.Sections[Counter] do
        Append(Format('%d,%d', [StartFrame, Preset]));

    Append('');

    for Counter := 0 to TrackBar1.Max do
    begin
      if FrameArray[Counter].DMetric <> 0 then
      begin
        Append('');
        Append('[DECIMATEMETRICS]');

        for C2 := 0 to TrackBar1.Max do
          Append(IntToStr(FrameArray[C2].DMetric));

        Break;
      end;
    end;

    for Counter := 0 to Form2.CustomRangeLists.Count - 1 do
    begin
      List := Form2.CustomRangeLists.Items.Objects[Counter] as TCustomList;

      Append('');
      Append(Format('[Custom List %d]', [Counter]));
      Append(AnsiQuotedStr(List.Name, '"'));
      Append(AnsiQuotedStr(List.Processing, '"'));
      Append(AnsiQuotedStr(List.Output, '"'));
      Append(IntToStr(Integer(List.OutputMethod)));

      for C2 := 0 to List.Count - 1 do
        with List[C2] do
          Append(Format('%d,%d', [StartFrame, EndFrame]));
    end;


    Append('');
    Append('[ERROR LOG]');
    with Logwindow.LogList.Items do
      for C2 := 0 to Count - 1 do
        SL.Append(Format('%d %s', [Integer(Objects[C2]), Strings[C2]]));

    try
      SaveToFile(Filename + '.tmp');
      if (not FileExists(Filename)) or DeleteFile(Filename) then
      begin
        if not RenameFile(Filename + '.tmp', Filename) then
          raise Exception.Create('Failed to rename temporary saved file "' + Filename + '.tmp"');
      end
      else
        raise Exception.Create('Failed to delete target file when saving, "' + Filename + '.tmp" not renamed properly. You should still be able to get your current project from there.');
    finally
      Free;
    end;
  end;
end;

procedure TForm1.Save1Click(Sender: TObject);
begin
  if SaveDialog5.FileName = '' then
    SaveProject1Click(self)
  else
    SaveProject(SaveDialog5.FileName);

  Caption := 'YATTA - ' + SaveDialog5.FileName;
end;

procedure TForm1.Button7Click(Sender: TObject);
var
  Counter: Integer;
begin
  if FRangeOn then
  begin
    for Counter := FRange to TrackBar1.Position do
    begin
      if (counter - FRange) mod distance = 0 then
      begin
        if CanDecimate(counter) then
          FrameArray[counter].Decimate := true
      end
      else
        FrameArray[counter].Decimate := false;
    end;

    FRangeOn := False;
  end
  else if FrameArray[TrackBar1.Position].Decimate then
    FrameArray[TrackBar1.Position].Decimate := false
  else
  begin
    if CanDecimate(TrackBar1.Position) then
      FrameArray[TrackBar1.Position].Decimate := true
    else
      FInfoText.append('Can''t decimate');
  end;

  UpdateFrameMap;

  DrawFrame();
end;

procedure TForm1.ResetButton;
var counter: integer;
begin
  if not FTryPattern then
  begin
    if FRangeOn then
    begin
      for counter := FRange to TrackBar1.Position do
        FrameArray[counter].Match := FrameArray[counter].OriginalMatch;
      FRangeOn := false;
    end
    else
      FrameArray[TrackBar1.Position].Match := FrameArray[TrackBar1.Position].OriginalMatch;

    DrawFrame;
  end;

end;

procedure TForm1.SetPattern(s, e: Integer);
var counter: integer;
begin
  for counter := s to e do
  begin
    case matchpattern[((counter - s) mod Length(matchpattern)) + 1] of
      'n': FrameArray[counter].Match := 0;
      'c': FrameArray[counter].Match := 1;
      'p': FrameArray[counter].Match := 2;
    end;

    if droppattern[((counter - s) mod Length(droppattern)) + 1] = 'k' then
      FrameArray[counter].Decimate := false;

    case postpattern[((counter - s) mod Length(postpattern)) + 1] of
      '+': FrameArray[counter].PostProcess := true;
      '-': FrameArray[counter].PostProcess := false;
    end;

    case freezepattern[((counter - s) mod Length(freezepattern)) + 1] of
      'n': Form2.addfreezeframe(counter, counter, counter + 1);
      'p': Form2.addfreezeframe(counter, counter, counter - 1);
    end;
  end;

  for counter := s to e do
  begin
    if (droppattern[((counter - s) mod Length(droppattern)) + 1] = 'd') and candecimate(counter) then
      FrameArray[counter].Decimate := true;
  end;

end;

procedure TForm1.UsePatternButton;
begin

  if FTryPattern then
  begin
    SetPattern(FPatternStartFrame, TrackBar1.Position);

    FTryPattern := false;
    Button2.Caption := 'Reset';

    DrawFrame;
  end;

end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  ResetButton;
  UsePatternButton;
end;



procedure TForm1.Button5Click(Sender: TObject);
begin
  FPatternStartFrame := TrackBar1.Position;

  if not FTryPattern then
  begin
    if not form6.AskOnTryPattern.Checked then
      SetPattern1Click(self);
    button2.Caption := 'Use Pattern';
  end
  else
    button2.Caption := 'Reset';

  FTryPattern := not FTryPattern;

  FRangeOn := false;

  DrawFrame();
end;

procedure TForm1.SetPattern1Click(Sender: TObject);
begin
  with Form6 do
  begin
    PatternEdit.Text := MatchPattern;
    DecimationEdit.Text := DropPattern;
    PostEdit.Text := PostPattern;
    FreezeEdit.Text := FreezePattern;

    if ShowModal = mrOk then
    begin

      if PatternEdit.Text <> '' then
        MatchPattern := PatternEdit.Text;

      if DecimationEdit.Text <> '' then
        DropPattern := DecimationEdit.Text;

      if PostEdit.Text <> '' then
        PostPattern := PostEdit.Text;

      if FreezeEdit.Text <> '' then
        FreezePattern := FreezeEdit.Text;
    end;
  end;

  DrawFrame;
end;

procedure TForm1.CopyToClipboard1Click(Sender: TObject);
var
  MyFormat: Word;
  AData: Cardinal;
  APalette: HPALETTE;
  TempImage: TBitmap;
begin
  TempImage := TBitmap.Create;
  TempImage.Assign(Image1.Bitmap);
  TempImage.SaveToClipboardFormat(MyFormat, AData, APalette);
  ClipBoard.SetAsHandle(MyFormat, AData);
  TempImage.Free;
end;

procedure TForm1.Button10MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  fp: integer;
  tt: string;
  rt: Double;
  defstr: string;
begin
  if Button = mbleft then
    Button3Click(sender)
  else if Button = mbright then
  begin
    defstr := timeinsecondstostr(trackbar1.position / fps);

    tt := InputBox('Goto', 'Enter time:', defstr);

    if tt <> defstr then
    begin

      rt := strtotimeinmillisecondsdef(tt, round((trackbar1.position / fps) * 1000)) / 1000;


      for fp := 0 to TrackBar1.Max do
      begin
        if fp / fps > rt then
        begin
          TrackBar1.Position := fp;
          break;
        end;
      end;
    end;
  end;
end;

procedure TForm1.Button10Click(Sender: TObject);
begin
  form2.vnextClick(self);
end;

procedure TForm1.Button3Click(Sender: TObject);
var tt: string;
  tn: integer;
begin
  tt := InputBox('Goto', 'Enter frame number:', IntToStr(TrackBar1.Position));
  if (tt <> '') and (tt[length(tt)] <> 'd') then
    TrackBar1.Position := StrToIntDef(tt, TrackBar1.Position)
  else
  begin
    tt := LeftStr(tt, length(tt) - 1);
    tn := StrToIntDef(tt, -1);
    if (tn >= 0) and (tn <= TrackBar1.Max) then
      TrackBar1.Position := revframemap[tn];
  end;

end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  if (FFreezeFrame < 0) then
  begin
    FFreezeFrame := TrackBar1.Position;
    FInfoText.append('Select frame to replace with');
    DrawFrame();
  end
  else if FRangeOn and (FFreezeFrame > -1) then
  begin
    if Form2.addfreezeframe(FRange, FFreezeFrame, TrackBar1.Position) then
      FInfoText.append('Start: ' + IntToStr(FRange) + '; End: ' + IntToStr(FFreezeFrame) + '; Replace: ' + IntToStr(TrackBar1.Position))
    else
      FInfoText.append('Overlapping/invalid ranges');

    FFreezeFrame := -1;
    FRangeOn := false;
    DrawFrame();
  end
  else if (not FRangeOn) and (FFreezeFrame > -1) then
  begin
    if Form2.addfreezeframe(FFreezeFrame, FFreezeFrame, TrackBar1.Position) then
      FInfoText.append('Start: ' + IntToStr(FFreezeFrame) + '; End: ' + IntToStr(FFreezeFrame) + '; Replace: ' + IntToStr(TrackBar1.Position))
    else
      FInfoText.append('Overlapping/invalid ranges');
    FFreezeFrame := -1;
    DrawFrame();
  end;
end;

procedure TForm1.Button13Click(Sender: TObject);
begin
  Save1Click(self);
  if (form11.CheckBox1.Checked) then
    SaveAllOverrides1Click(self);
end;

procedure TForm1.SaveAllOverrides1Click(Sender: TObject);
begin
  if SaveDialog5.FileName <> '' then
  begin
    if (OpenMode in MatchingProjects) then
    begin
      SaveTOvr(ChangeFileExt(SaveDialog5.FileName, FieldExt));

      if Form11.Decimation.Checked then
      begin
        SaveDOvr(ChangeFileExt(SaveDialog5.FileName, DecExt));
        SaveVOvr(ChangeFileExt(SaveDialog5.FileName, TimeExt));
      end;

    end;

    SaveAvs(ChangeFileExt(SaveDialog5.FileName, AvsExt));

  end
  else
    MessageDlg('You have to save the project before saving all overrides.', mtError, [mbOK], 0);
end;

procedure TForm1.Button16Click(Sender: TObject);
begin
  Form11.Show;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  SetExceptionMask(GetExceptionMask + [exInvalidOp, exOverflow, exZeroDivide]);
  Application.UpdateFormatSettings := False;

  DecimalSeparator := '.';
  LongTimeFormat := 'hh:nn:ss.zzz';
  ShortTimeFormat := 'hh:nn:ss.zzz';

  OriginalCaption := Caption;

  FTextLayer := TBitmapLayer.Create(Image1.Layers);
  FTextLayer.Bitmap.OuterColor := clBlue32;
  FTextLayer.Bitmap.DrawMode := dmTransparent;

  OpenMode := 255;
  Distance := 5;

  SetLength(IVTCPatternNN, 5);
  IVTCPatternNN[0] := 1;
  IVTCPatternNN[1] := 1;
  IVTCPatternNN[2] := 1;
  IVTCPatternNN[3] := 0;
  IVTCPatternNN[4] := 0;

  SetLength(IVTCPatternNNN, 5);
  IVTCPatternNNN[0] := 1;
  IVTCPatternNNN[1] := 1;
  IVTCPatternNNN[2] := 0;
  IVTCPatternNNN[3] := 0;
  IVTCPatternNNN[4] := 0;

  SetLength(IVTCPatternC, 1);
  IVTCPatternC[0] := 1;

  Multiple := 1;
  FFPS := 30;

  FPanelHeight := Panel1.Height;

  Settings := TMemIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));

  FSpeed := settings.ReadInteger('MAIN', 'Speed', 30);
  VThreshold := settings.ReadInteger('MAIN', 'VThresh', 25);

  case Settings.readinteger('MAIN', 'SwitchMethod', 0) of
    0: PCN1.Checked := true;
    1: CNOnly1.Checked := true;
    2: PCOnly1.Checked := true;
  end;

  ShowText1.Checked := Settings.ReadBool('MAIN', 'ShowText', true);
  ShowFrozen1.Checked := Settings.ReadBool('MAIN', 'ShowFrozen', true);
  NoDecimateassections1.Checked := Settings.ReadBool('MAIN', 'NoDecimateToSections', false);
  Useccccc1.Checked := Settings.ReadBool('MAIN', 'PGUseC', True);
  Usecccnn1.Checked := Settings.ReadBool('MAIN', 'PGUseCCCNN', True);
  Useccnnn1.Checked := Settings.ReadBool('MAIN', 'PGUseCCNNN', True);
  CPenalty := Settings.ReadFloat('MAIN', 'PGCPenalty', 1.2);
  PGEdgeCutoff := Settings.ReadInteger('MAIN', 'PGEdgeCutoff', 1);
  PGFrameLimit := Settings.ReadInteger('MAIN', 'PGFrameLimit', 20);

  FileOpen := false;

  FInfoText := TStringList.Create;
  FBuffer := TBitmap32.Create;

  try
    InitializeAvisynth;
  except on E: EAsifException do
    begin
      MessageDlg(E.Message, mtError, [mbok], 0);
      Halt(7000);
    end;
  end;

  try
    SE := TAsifScriptEnvironment.Create;
  except on E: EInitializationFailed do
    begin
      MessageDlg(E.Message, mtError, [mbok], 0);
      Halt(7001);
    end;
  end;

  try
    se.CharArg('assert(false,string(versionnumber()))');
    se.Invoke('Eval');
  except on e: EInvokeFailed do
    try
      if StrToFloat(RightStr(e.Message, length(e.Message) - LastDelimiter(#10, e.Message))) < 2.55 then
        Abort;

    except
      MessageDlg('Too old avisynth version installed.'#13#10'2.5.5 or later required.', mtError, [mbok], 0);
      Halt(7002);
    end;
  end;

  try
    InitializeFilterlist(ExtractFilePath(ParamStr(0)) + 'filterlist.txt');
  except on E: EAsifException do
      MessageDlg(E.Message, mtError, [mbOK], 0);
  end;


  DragAcceptFiles(Handle, True);
end;

procedure TForm1.OpenCloseButtonClick(Sender: TObject);
begin
  if FileOpen then
    CloseSource
  else if OpenDialog1.Execute then
    OpenSource(OpenDialog1.FileName);
end;

procedure TForm1.Button20Click(Sender: TObject);
begin
  Form2.Show;
end;

procedure TForm1.Button14Click(Sender: TObject);
begin
  TrackBar1.Position := form2.sectioninfo(form2.sectioninfo(TrackBar1.Position).endframe + 1).startframe;
end;

procedure TForm1.Button12Click(Sender: TObject);
begin
  Form2.Button5Click(self);
  DrawFrame();
end;

procedure TForm1.SaveFreezeFrames1Click(Sender: TObject);
begin
  if SaveDialog5.FileName <> '' then
  begin
    if Form2.SaveDialog1.Execute then
      SaveAvs(Form2.SaveDialog1.FileName);
  end
  else
    MessageDlg('You have to save the project before saving an avs.', mtError, [mbok], 0);
end;

procedure TForm1.SaveVFR1Click(Sender: TObject);
begin
  if SaveDialog3.Execute then
    SaveVOvr(SaveDialog3.FileName);
end;

procedure TForm1.SaveAvs(FileName: string);
var
  SL: TStringList;
begin
  SL := Form2.MakeOverrideList(nil, False);
  SL.Insert(0, PluginListToScript(GetRequiredPlugins(True, SL.Text, PluginPath, SE), PluginPath));

  try
    SL.SaveToFile(FileName);
  finally
    SL.Free;
  end;
end;

procedure TForm1.SaveVOvr(FileName: string);
var
  SL: TStringList;
  Counter: Integer;
  FNum: Integer;
  Offset: Integer;
  V1Times: TObjectList;
  LastEndFrame: Integer;
begin
  // cutting adjustments here

  SL := TStringList.Create;

  LastEndFrame := -1;
  Offset := 0;
  FNum := 0;

  try
      V1Times := TObjectList.Create(true);

      with Form2.Nodecimates.Items do
        for Counter := 0 to Count - 1 do
          with Objects[Counter] as TDecimateInfo do
          begin
            Inc(FNum, ((StartFrame - LastEndFrame - 1) div Distance) * (Distance - 1));
            V1Times.Add(TV1Time.Create(FNum, FNum + EndFrame - StartFrame, FPS));
            LastEndFrame := EndFrame;
            Inc(FNum, EndFrame - StartFrame + 1);
          end;

      SL.Append('# timecode format v1');
      SL.Append('Assume ' + FloatToStr((FPS * (Distance - 1)) / Distance));

      for Counter := 0 to V1Times.Count - 1 do
        with V1Times[Counter] as TV1Time do
          if EndFrame - Offset >= 0 then
            SL.Append(Format('%d,%d,%f', [Max(StartFrame - Offset, 0), EndFrame - Offset, FPS]));

      V1Times.Free;

    try
      SL.SaveToFile(filename);
    except
      MessageDlg('Error when saving the timecodes.', mtError, [mbOK], 0);
      raise;
    end;

  finally
    SL.Free;
  end;
end;

procedure TForm1.ShowFrozen1Click(Sender: TObject);
begin
  DrawFrame();
end;

procedure TForm1.Cropping1Click(Sender: TObject);
begin
  CropForm.show;
end;

procedure TForm1.RestoreFromLog1Click(Sender: TObject);
var counter: integer;
begin
  if ConfirmDialog then
  begin
    for counter := 0 to TrackBar1.Max do
      FrameArray[counter].Match := FrameArray[counter].OriginalMatch;
    DrawFrame;
  end;
end;

procedure TForm1.ClearDecimated1Click(Sender: TObject);
var counter: integer;
begin
  if ConfirmDialog then
  begin
    for counter := 0 to TrackBar1.Max do
      FrameArray[counter].Decimate := false;
    DrawFrame;
  end;
end;

procedure TForm1.OnlyCNWithVThreshConsidered1Click(Sender: TObject);
var
  counter, vt: integer;
begin
  if ConfirmDialog then
  begin
    vt := 50;
    SetVariablePrompt(vt, 0);

    for counter := 0 to Length(FrameArray) - 1 do
      if FrameArray[counter].MMetric[0] >= FrameArray[counter].MMetric[1] then
        FrameArray[counter].Match := 1
      else
        FrameArray[counter].Match := 0;

    for counter := 0 to Length(FrameArray) - 1 do
      if (FrameArray[counter].VMetric[FrameArray[counter].Match] > vt) and (FrameArray[counter].VMetric[FrameArray[counter].Match xor 1] < vt) then
        FrameArray[counter].Match := FrameArray[counter].Match xor 1;

    DrawFrame;
  end;


end;

procedure TForm1.About1Click(Sender: TObject);
begin
  form7.ShowModal;
end;

procedure TForm1.DecimateByPattern(S, E: Integer);
var
  Counter: Integer;
begin
  for Counter := S to E - 1 do
    if (FrameArray[Counter].Match = 0) and (FrameArray[Counter + 1].Match = 1) and CanDecimate(Counter) then
      FrameArray[Counter].Decimate := True;
end;

procedure TForm1.DecimationbyPattern1Click(Sender: TObject);
begin
  if ConfirmDialog then
  begin
    DecimateByPattern(0, TrackBar1.Max);
    DrawFrame;
  end;
end;

procedure TForm1.Button15Click(Sender: TObject);
var
  SL: TStringList;
  ESL: TStringList;
  SplitList: TStringList;
  Counter: Integer;
  Line: Integer;
begin
  if SaveDialog5.FileName <> '' then
  begin
    if (OpenMode in MatchingProjects) and (Form11.CheckBox13.Checked) then
    begin
      SaveTOvr(ChangeFileExt(SaveDialog5.FileName, FieldExt));
      SaveDOvr(ChangeFileExt(SaveDialog5.FileName, DecExt));
    end;

    ESL := TStringList.Create;
    SplitList := TStringList.Create;
    SplitList.Delimiter := ' ';

    try
      SL := Form2.MakeOverrideList(ESL, True);

      try

        LoadPlugins(SL.Text, PluginPath, SE);

        SL.Append('converttorgb32()');

        SE.CharArg(PChar(SL.Text));

        try
          Form4.PreviewClip := SE.InvokeWithClipResult('Eval');
          Form4.Show;
        except on E: EInvokeFailed do
          begin
            Form4.Close;

            try
              SplitList.DelimitedText := E.Message;
              Line := StrToInt(LeftStr(SplitList[SplitList.IndexOf('line') + 1], Length(SplitList[SplitList.IndexOf('line') + 1]) - 1));
            except
              Line := -1;
            end;

            if Line <> -1 then
            begin
              for Counter := 0 to ESL.Count - 1 do
                with ESL.Objects[Counter] as TCustomRange do
                  if (StartFrame <= Line) and (EndFrame >= Line) then
                  begin
                    MessageDlg('Error in the preset "' + ESL[Counter] + '"' + #13#10 + 'Line: ' + IntToStr(Line - StartFrame - 3) + #13#10#13#10 + E.message, mtError, [mbok], 0);
                    Line := -2;
                    Break;
                  end;
            end;

            if Line <> -2 then
              MessageDlg(E.message, mtError, [mbOK], 0);
          end;
        end;

      finally
        SL.Free;
      end;
    finally
      SplitList.Free;
      for Counter := 0 to ESL.Count - 1 do
        ESL.Objects[Counter].Free;
      ESL.Free;
    end;
  end
  else
    MessageDlg('You have to save the project before previewing.', mtError, [mbOK], 0);
end;

procedure TForm1.Cmatchestovfr1Click(Sender: TObject);
var
  Counter: Integer;
  Consecutive: Integer;
  LastMatch: Byte;
  ANDResult: TNoDecAddRejections;
begin
  if ConfirmDialog then
  begin
    lastmatch := high(lastmatch);
    consecutive := 0;

    for counter := 0 to TrackBar1.Max do
    begin
      if lastmatch = FrameArray[counter].Match then
        Inc(consecutive)
      else
      begin
        if consecutive >= 15 then
        begin
          ANDResult := Form2.AddNoDecimate(Counter - Consecutive - 1, Counter - 1);
          if ndarNoDecimateRangeExists in ANDResult then
            Logwindow.AddLogMessage('Couldn''t mark ' + IntToStr(counter - consecutive - 1) +
              '-' + IntToStr(counter - 1) + ' as nodecimate - range already exists', counter - consecutive - 1);
          if ndarDecimationExists in ANDResult then
            Logwindow.AddLogMessage('Couldn''t mark ' + IntToStr(counter - consecutive - 1) +
              '-' + IntToStr(counter - 1) + ' as nodecimate - decimation already exists', counter - consecutive - 1);
          if ndarInvalidRange in ANDResult then
            Logwindow.AddLogMessage('Couldn''t mark ' + IntToStr(counter - consecutive - 1) +
              '-' + IntToStr(counter - 1) + ' as nodecimate - invalid range', counter - consecutive - 1);
          if ndarFeatureDisabled in ANDResult then
            Logwindow.AddLogMessage('Couldn''t mark ' + IntToStr(counter - consecutive - 1) +
              '-' + IntToStr(counter - 1) + ' as nodecimate - report this as a bug', counter - consecutive - 1);
        end;
        consecutive := 0;
        lastmatch := FrameArray[counter].Match;
      end;

    end;

    DrawFrame;
  end;
end;

procedure TForm1.Button18Click(Sender: TObject);
begin
  if (not form11.Decimation.Checked) and (OpenMode in matchingprojects) then
  begin
    FInfoText.Append('Decimation not activated');
    DrawFrame();
  end
  else if FRangeOn then
  begin
    FRangeOn := false;
    if not (Form2.AddNoDecimate(FRange, TrackBar1.Position) = []) then
      FInfoText.Append('Overlapping/invalid ranges');
    DrawFrame();
  end
  else
    Button8Click(self);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  SE := nil;

  FBuffer.Free;

  FInfoText.Free;

  Settings.writeInteger('MAIN', 'Speed', FSpeed);
  Settings.writeInteger('MAIN', 'VThresh', VThreshold);

  if PCN1.Checked then
    Settings.WriteInteger('MAIN', 'SwitchMethod', 0)
  else if CNOnly1.Checked then
    Settings.WriteInteger('MAIN', 'SwitchMethod', 1)
  else if PCOnly1.Checked then
    Settings.WriteInteger('MAIN', 'SwitchMethod', 2);

  Settings.WriteBool('MAIN', 'ShowText', ShowText1.Checked);
  Settings.WriteBool('MAIN', 'ShowFrozen', ShowFrozen1.Checked);
  Settings.WriteBool('MAIN', 'NoDecimateToSections', NoDecimateassections1.Checked);

  Settings.WriteBool('MAIN', 'PGUseC', Useccccc1.Checked);
  Settings.WriteBool('MAIN', 'PGUseCCCNN', Usecccnn1.Checked);
  Settings.WriteBool('MAIN', 'PGUseCCNNN', Useccnnn1.Checked);
  Settings.WriteFloat('MAIN', 'PGCPenalty', CPenalty);
  Settings.WriteInteger('MAIN', 'PGEdgeCutoff', PGEdgeCutoff);
  Settings.WriteInteger('MAIN', 'PGFrameLimit', PGFrameLimit);

  Settings.UpdateFile;
  Settings.Free;

  DeinitializeAvisynth;
end;

procedure TForm1.Matchbyvmetric1Click(Sender: TObject);
var
  Counter: Integer;
  VWeight: Integer;
begin
  VWeight := 10;
  SetVariablePrompt(VWeight, 1);

  for Counter := 0 to Form2.SectionCount - 2 do
    MatchByVMetric(Form2.Sections[Counter].StartFrame, Form2.Sections[Counter + 1].StartFrame - 1, VWeight);
  MatchByVMetric(Form2.Sections[Form2.SectionCount - 1].StartFrame, TrackBar1.Max, VWeight);

  DrawFrame;
end;


procedure TForm1.ShowLogWindow1Click(Sender: TObject);
begin
  Logwindow.Show;
end;

procedure TForm1.PatternGuidance1Click(Sender: TObject);
var
  Counter: Integer;
begin
  if ConfirmDialog then
  begin
    Logwindow.ClearLog;

    if UseExperimentalAlgorithm1.Checked then
      PatternGuidance(0, TrackBar1.Max, 2, 15, 5)
    else
    begin
      for Counter := 0 to Form2.SectionCount - 2 do
        PatternGuidance(Form2.Sections[Counter].StartFrame, Form2.Sections[Counter + 1].StartFrame - 1, PGEdgeCutoff, PGFrameLimit, CPenalty);
      PatternGuidance(Form2.Sections[Form2.SectionCount - 1].StartFrame, TrackBar1.Max, PGEdgeCutoff, PGFrameLimit, CPenalty);
    end;
    DrawFrame;
  end;
end;

procedure TForm1.SceneChangeFreezeframe2Click(Sender: TObject);
var
  D1, D2, TP, SP, Counter: Integer;
begin
  D1 := 4;
  D2 := 4;

  SetVariablePrompt(D1, 3);
  SetVariablePrompt(D2, 2);

  for Counter := 1 to Form2.SectionCount - 1 do
  begin
    SP := Form2.Sections[Counter].StartFrame - D2;
    for TP := SP to Form2.Sections[Counter].StartFrame - 2 do
      if (SP >= 0) and (SP <= TrackBar1.Max) then
        if FrameArray[TP].MMetric[FrameArray[TP].Match] < FrameArray[SP].MMetric[FrameArray[SP].Match] then
          SP := TP;

    Form2.AddFreezeFrame(SP, Form2.Sections[Counter].StartFrame - 1, SP);

    SP := Form2.Sections[Counter].StartFrame;
    for TP := Form2.Sections[Counter].StartFrame + 1 to Form2.Sections[Counter].StartFrame + D1 - 1 do
      if (SP >= 0) and (SP <= TrackBar1.Max) then
        if FrameArray[TP].MMetric[FrameArray[TP].Match] < FrameArray[SP].MMetric[FrameArray[SP].Match] then
          SP := TP;

    Form2.AddFreezeFrame(Form2.Sections[Counter].StartFrame, SP, SP);

  end;
  DrawFrame();
end;


procedure TForm1.SceneChangeFreezeframewithoutthresholds1Click(
  Sender: TObject);
var
  D1, D2, Counter: Integer;
begin
  D1 := 4;
  D2 := 4;

  SetVariablePrompt(D1, 3);
  SetVariablePrompt(D2, 2);

  for Counter := 0 to Form2.SectionCount - 1 do
    with Form2.Sections[Counter] do
    begin
      form2.AddFreezeFrame(StartFrame - D2, Form2.Sections[Counter].StartFrame - 1, StartFrame - d2);
      form2.addfreezeframe(StartFrame, Form2.Sections[Counter].StartFrame + D1 - 1, StartFrame + d1 - 1);
    end;

  DrawFrame;
end;

procedure TForm1.ApplicationEvents1ShortCut(var Msg: TWMKey;
  var Handled: Boolean);
var
  T1P, TI: Integer;
  PV: Boolean;
  Counter, C2: Integer;
  IPS: set of byte;
  Freq: array[-1..255] of Integer;
  NextLower: Integer;
  NextEqual: Integer;
  CH: Integer;
  SIF: TSectionInfo;
begin
  if Self.Active and FileOpen then
  begin
    Handled := True;

    if IsKeyEvent(kPostprocess, msg.CharCode) and (OpenMode in MatchingProjects) then
      Button6Click(nil)
    else if IsKeyEvent(kSave, msg.CharCode) then
      Button13Click(nil)
    else if IsKeyEvent(kReset, msg.CharCode) and (OpenMode in MatchingProjects) then
      ResetButton
    else if IsKeyEvent(kUsePattern, msg.CharCode) and (OpenMode in MatchingProjects) then
      UsePatternButton
    else if IsKeyEvent(kRangeStart, msg.CharCode) then
      Button8Click(nil)
    else if IsKeyEvent(kGotoFrame, msg.CharCode) then
      Button3Click(nil)
    else if IsKeyEvent(kSwitch, msg.CharCode) and (OpenMode in MatchingProjects) then
      Button9Click(nil)
    else if IsKeyEvent(kTryPattern, msg.CharCode) and (OpenMode in MatchingProjects) then
      Button5Click(nil)
    else if IsKeyEvent(kNoDecimate, msg.CharCode) and (OpenMode in MatchingProjects) and (Form11.Decimation.Checked) then
      Button18Click(nil)
    else if IsKeyEvent(kSectionStart, msg.CharCode) then
      Button12Click(nil)
    else if IsKeyEvent(kDecimate, msg.CharCode) and (OpenMode in MatchingProjects) and (Form11.Decimation.Checked) then
      Button7Click(nil)
    else if IsKeyEvent(kFreezeframe, msg.CharCode) then
      Button4Click(nil)
    else if IsKeyEvent(kPlay, msg.CharCode) then
      Button1Click(nil)
    else if IsKeyEvent(kPreview, msg.CharCode) then
    begin
      Button15Click(nil);
    end
    else if IsKeyEvent(kMarkCustomList, msg.CharCode) then
    begin
      if (Form2.CustomRangeLists.ItemIndex >= 0) and FRangeOn then
      begin
        if Form11.SwapCustomList.Checked and (FRange > TrackBar1.Position) then
          TCustomList(Form2.CustomRangeLists.Items.Objects[form2.CustomRangeLists.ItemIndex]).Add(TCustomRange.Create(TrackBar1.Position, FRange))
        else
          TCustomList(Form2.CustomRangeLists.Items.Objects[form2.CustomRangeLists.ItemIndex]).Add(TCustomRange.Create(FRange, TrackBar1.Position));

        form2.CustomRanges.Count := TCustomList(form2.CustomRangeLists.Items.Objects[form2.CustomRangeLists.ItemIndex]).Count;
        TCustomList(form2.CustomRangeLists.Items.Objects[form2.CustomRangeLists.ItemIndex]).Sort(customlistsort);
        FRangeOn := False;
        FInfoText.Append('Added range; Start: ' + IntToStr(FRange) + '; End: ' + inttostr(TrackBar1.Position));
      end
      else if (form2.CustomRangeLists.ItemIndex >= 0) then
        Button8Click(nil)
      else
        FInfoText.Append('No list selected');

      DrawFrame;
    end
    else if IsKeyEvent(kTogglePBasedOnFreqOfUse, msg.CharCode) then
    begin
      with Form2.SectionInfo(TrackBar1.Position) do
      begin
        // Starts at -1 to handle sections with undefined presets
        for Counter := -1 to 255 do
          Freq[Counter] := 0;

        // Calculate frequency of use
        for Counter := 0 to Form2.SectionCount - 1 do
          Inc(Freq[Form2.Sections[Counter].Preset]);

        // Do not include the current section
        Dec(Freq[Preset]);

        // Undefined should not be included
        Freq[-1] := 0;

        NextLower := -1;
        NextEqual := -1;

        // Scan for a later preset with equal freq or a previous with lower
        for Counter := 0 to 255 do
          if (Freq[Counter] < Freq[Preset]) and (Freq[Counter] > Freq[NextLower]) then
            NextLower := Counter;

        for Counter := Preset + 1 to 255 do
          if (Freq[Counter] = Freq[Preset]) then
          begin
            NextEqual := Counter;
            Break;
          end;

        TI := -1;

        if (NextLower = -1) and (NextEqual = -1) then
        begin
          for Counter := 0 to 255 do
            if Freq[Counter] > Freq[TI] then
              TI := Counter;
        end
        else if NextEqual <> -1 then
          TI := NextEqual
        else if NextLower <> -1 then
          TI := NextLower;

        if TI <> -1 then
        begin
          Form2.Sections[Index].Preset := TI;
          Form2.UpdateSectionList;
        end;
      end;

      DrawFrame;
    end
    else if IsKeyEvent(kTogglePreset, msg.CharCode) then
      with Form2.SectionInfo(TrackBar1.Position) do
      begin

        ips := [];

        for Counter := 0 to Form2.SectionCount - 1 do
          IPS := IPS + [Form2.Sections[Counter].Preset];

        for Counter := 0 to Form2.SectionCount - 1 do
          if Form2.Sections[Counter].StartFrame = StartFrame then
          begin

            with Form2.Sections[Counter] do
              repeat
                Preset := (Preset + 1) and $FF;
              until Preset in IPS;

            Form2.UpdateSectionList;

            Break;
          end;

        DrawFrame;
      end
    else if IsKeyEvent(kZoomIn, msg.CharCode) then
    begin
      if Multiple < 4 then
        Multiple := IfThen(Multiple = -2, 1, Multiple + 1);
        DrawFrame;
    end
    else if IsKeyEvent(kZoomOut, msg.CharCode) then
    begin
      if Multiple > -4 then
        Multiple := IfThen(Multiple = 1, -2, Multiple - 1);
        DrawFrame;
    end
    else if IsKeyEvent(kJumpMinus5frames, msg.CharCode) then
      TrackBar1.Position := TrackBar1.Position - 5
    else if IsKeyEvent(kJumpMinus10frames, msg.CharCode) then
      TrackBar1.Position := TrackBar1.Position - 10
    else if IsKeyEvent(kJumpMinus50frames, msg.CharCode) then
      TrackBar1.Position := TrackBar1.Position - 50
    else if IsKeyEvent(kPreviousFrame, msg.CharCode) then
      TrackBar1.Position := TrackBar1.Position - 1
    else if IsKeyEvent(kJumpPlus5frames, msg.CharCode) then
      TrackBar1.Position := TrackBar1.Position + 5
    else if IsKeyEvent(kJumpPlus10frames, msg.CharCode) then
      TrackBar1.Position := TrackBar1.Position + 10
    else if IsKeyEvent(kJumpPlus50frames, msg.CharCode) then
      TrackBar1.Position := TrackBar1.Position + 50
    else if IsKeyEvent(kNextFrame, msg.CharCode) then
      TrackBar1.Position := TrackBar1.Position + 1
    else if IsKeyEvent(kNextSection, msg.CharCode) then
      Button14Click(self)
    else if IsKeyEvent(kPreviousSection, msg.CharCode) then
    begin
      if form2.sectioninfo(TrackBar1.Position).startframe = TrackBar1.Position then
        TrackBar1.Position := Form2.sectioninfo(form2.sectioninfo(TrackBar1.Position).startframe - 1).startframe
      else
        TrackBar1.Position := Form2.sectioninfo(TrackBar1.Position).startframe;
    end
    else if IsKeyEvent(kNextVMatch, msg.CharCode) and (OpenMode in MatchingProjects) then
      form2.vnextClick(self)
    else if IsKeyEvent(kPreviousVMatch, msg.CharCode) and (OpenMode in MatchingProjects) then
      form2.vprevClick(self)
    else if IsKeyEvent(kJump5frames, msg.CharCode) then
      TrackBar1.Position := TrackBar1.Position + 5
    else if IsKeyEvent(kJump10frames, msg.CharCode) then
      TrackBar1.Position := TrackBar1.Position + 10
    else if IsKeyEvent(kJump15frames, msg.CharCode) then
      TrackBar1.Position := TrackBar1.Position + 15
    else if IsKeyEvent(kJump20frames, msg.CharCode) then
      TrackBar1.Position := TrackBar1.Position + 20
    else if IsKeyEvent(kJump25frames, msg.CharCode) then
      TrackBar1.Position := TrackBar1.Position + 25
    else if IsKeyEvent(kJump35frames, msg.CharCode) then
      TrackBar1.Position := TrackBar1.Position + 35
    else if IsKeyEvent(kJump50frames, msg.CharCode) then
      TrackBar1.Position := TrackBar1.Position + 50
    else if IsKeyEvent(kJump75frames, msg.CharCode) then
      TrackBar1.Position := TrackBar1.Position + 75
    else if IsKeyEvent(kJump100frames, msg.CharCode) then
      TrackBar1.Position := TrackBar1.Position + 100
    else if IsKeyEvent(kFFSBeginningToC, msg.CharCode) then
    begin
      with Form2.SectionInfo(TrackBar1.Position) do
        if Form2.AddFreezeFrame(StartFrame, TrackBar1.Position, TrackBar1.Position) then
          FInfoText.append('Start: ' + IntToStr(startframe) + '; End: ' + IntToStr(TrackBar1.Position) + '; Replace: ' + IntToStr(TrackBar1.Position))
        else
          FInfoText.append('Overlapping/invalid ranges');
      DrawFrame;
    end
    else if IsKeyEvent(kFFCToSEnd, msg.CharCode) then
    begin
      with Form2.SectionInfo(TrackBar1.Position) do
        if Form2.AddFreezeFrame(TrackBar1.Position, endframe, TrackBar1.Position) then
          FInfoText.Append('Start: ' + IntToStr(TrackBar1.Position) + '; End: ' + IntToStr(endframe) + '; Replace: ' + IntToStr(TrackBar1.Position))
        else
          FInfoText.Append('Overlapping/invalid ranges');
      DrawFrame;
    end
    else if IsKeyEvent(kSwitchCMatchToPN, msg.CharCode) and (TrackBar1.Position > 0) and (TrackBar1.Position < TrackBar1.Max) and (OpenMode in MatchingProjects) then
    begin
      if CNOnly1.Checked then
        FrameArray[TrackBar1.Position].Match := 2
      else if PCOnly1.Checked then
        FrameArray[TrackBar1.Position].Match := 0;

      DrawFrame;
    end
    else if IsKeyEvent(kOpenTryPatternDialog, msg.CharCode) and (OpenMode in MatchingProjects) then
      SetPattern1Click(self)
    else if IsKeyEvent(kJumpToRangeStart, msg.CharCode) and FRangeOn then
      TrackBar1.Position := FRange
    else if IsKeyEvent(kSelectLowestVMetricMatches, msg.CharCode) and (OpenMode in MatchingProjects) then
    begin
      with form2.sectioninfo(TrackBar1.Position) do
        matchbyvmetric(startframe, endframe, 10);
      DrawFrame;
    end
    else if IsKeyEvent(kPatternGuidanceOn, msg.CharCode) and (OpenMode in MatchingProjects) then
    begin
      with form2.sectioninfo(TrackBar1.Position) do
        PatternGuidance(StartFrame, EndFrame, PGEdgeCutoff, PGFrameLimit, CPenalty);
      DrawFrame;
    end
    else if IsKeyEvent(kExtendDistanceTo5, msg.CharCode) and (OpenMode in MatchingProjects) then
      with form2.sectioninfo(TrackBar1.Position) do
      begin

        for counter := TrackBar1.Position - 2 to endframe - 5 do
          FrameArray[counter + 5].Match := FrameArray[counter].Match;

        for counter := TrackBar1.Position + 2 downto startframe + 5 do
          FrameArray[counter - 5].Match := FrameArray[counter].Match;

        DrawFrame;
      end
    else if IsKeyEvent(kResetSection, msg.CharCode) and (OpenMode in MatchingProjects) then
    begin
      with form2.sectioninfo(TrackBar1.Position) do
        for counter := startframe to endframe do
          FrameArray[counter].Match := FrameArray[counter].OriginalMatch;
      DrawFrame;
    end
    else if IsKeyEvent(kNoDecimateS, msg.CharCode) and (OpenMode in MatchingProjects) then
      with Form2.SectionInfo(TrackBar1.Position) do
      begin

        if Form2.NoDecimateExists(StartFrame, StartFrame) then
          Inc(StartFrame, Distance);
        if Form2.nodecimateexists(endframe, EndFrame) then
          Dec(EndFrame, Distance);
        if not (Form2.AddNoDecimate(StartFrame, EndFrame) = []) then
          FInfoText.Append('Overlapping/invalid ranges');

        DrawFrame;
      end
    else if IsKeyEvent(kPatternShiftInS, msg.CharCode) and (OpenMode in MatchingProjects) then
    begin
      with form2.sectioninfo(TrackBar1.Position) do
      begin
        ShiftPattern;
        SetPattern(startframe, endframe);
      end;

      DrawFrame;
    end
    else if IsKeyEvent(kJumpToNextPN, msg.CharCode) and (OpenMode in MatchingProjects) then
    begin
      for TI := TrackBar1.Position + 1 to TrackBar1.Max do
        if ((FrameArray[TI].Match = 0) and (PCOnly1.Checked)) or ((FrameArray[TI].Match = 2) and (CNOnly1.Checked)) then
        begin
          TrackBar1.Position := TI;
          Break;
        end;
    end
    else if IsKeyEvent(kJumpToNextPP, msg.CharCode) and (OpenMode in MatchingProjects) then
    begin
      for ti := TrackBar1.Position + 1 to TrackBar1.Max do
        if FrameArray[ti].PostProcess then
        begin
          TrackBar1.Position := ti;
          break;
        end;
    end
    else if IsKeyEvent(kFindVFR1, msg.CharCode) and (OpenMode in MatchingProjects) then
      form2.findvfr1Click(self)
    else if IsKeyEvent(kFindVFR2, msg.CharCode) and (OpenMode in MatchingProjects) then
      form2.findvfr2Click(self)
    else if IsKeyEvent(kDeleteCSection, msg.CharCode) then
    begin
      form2.Button6Click(self);
      DrawFrame();
    end
    else if IsKeyEvent(kDeleteCFreezeframe, msg.CharCode) then
    begin
      for ti := 0 to form2.Freezeframes.Count - 1 do
      begin
        if (TFreezeInfo(form2.Freezeframes.Items.Objects[ti]).startframe <= TrackBar1.Position) and (TFreezeInfo(form2.Freezeframes.Items.Objects[ti]).endframe >= TrackBar1.Position) then
        begin
          TFreezeInfo(form2.Freezeframes.Items.Objects[ti]).Free;
          form2.Freezeframes.Items.Delete(ti);
          break;
        end;
      end;
      DrawFrame();
    end
    else if IsKeyEvent(kPlayFromSStart, msg.CharCode) then
    begin
      TrackBar1.Position := form2.sectioninfo(TrackBar1.Position).startframe;
      Button1Click(self);
    end
    else if IsKeyEvent(kFreezeframeSection, msg.CharCode) then
    begin
      with form2.sectioninfo(TrackBar1.Position) do
        if Form2.addfreezeframe(startframe, endframe, TrackBar1.Position) then
          FInfoText.append('Start: ' + IntToStr(startframe) + '; End: ' + IntToStr(endframe) + '; Replace: ' + IntToStr(TrackBar1.Position))
        else
          FInfoText.append('Overlapping/invalid ranges');

      DrawFrame();
    end
    else if IsKeyEvent(kPostprocessSection, msg.CharCode) and (OpenMode in MatchingProjects) then
    begin
      PV := not FrameArray[TrackBar1.Position].PostProcess;
      with form2.sectioninfo(TrackBar1.Position) do
        for Counter := StartFrame to EndFrame do
          FrameArray[Counter].PostProcess := PV;
      DrawFrame();
    end
    else if IsKeyEvent(kReplaceCFrameWithNext, msg.CharCode) then
    begin
      if Form2.addfreezeframe(TrackBar1.Position, TrackBar1.Position, TrackBar1.Position + 1) then
        FInfoText.append('Start: ' + IntToStr(TrackBar1.Position) + '; End: ' + IntToStr(TrackBar1.Position) + '; Replace: ' + IntToStr(TrackBar1.Position + 1))
      else
        FInfoText.append('Overlapping/invalid ranges');

      DrawFrame();
    end
    else if IsKeyEvent(kReplaceCFrameWithPrevious, msg.CharCode) then
    begin
      if Form2.addfreezeframe(TrackBar1.Position, TrackBar1.Position, TrackBar1.Position - 1) then
        FInfoText.append('Start: ' + IntToStr(TrackBar1.Position) + '; End: ' + IntToStr(TrackBar1.Position) + '; Replace: ' + IntToStr(TrackBar1.Position - 1))
      else
        FInfoText.append('Overlapping/invalid ranges');

      DrawFrame();
    end
    else if IsKeyEvent(kNextCLEntry, msg.CharCode) then
    begin
      if (form2.CustomRangeLists.ItemIndex >= 0) and (form2.CustomRanges.ItemIndex >= 1) then
      begin

        with form2.CustomRangeLists.Items.Objects[form2.CustomRangeLists.ItemIndex] as TCustomList do
          with Items[form2.CustomRanges.ItemIndex - 1] as TCustomRange do
          begin
            TrackBar1.Position := startframe;
            form2.CustomRanges.ItemIndex := form2.CustomRanges.ItemIndex - 1;
            form2.CustomRanges.ClearSelection;
            form2.CustomRanges.Selected[form2.CustomRanges.ItemIndex] := true;
          end;
      end;
    end
    else if IsKeyEvent(kPreviousCLEntry, msg.CharCode) then
    begin
      if (form2.CustomRangeLists.ItemIndex >= 0) and (Form2.CustomRanges.ItemIndex < Form2.CustomRanges.Count - 1) then
      begin

        with form2.CustomRangeLists.Items.Objects[form2.CustomRangeLists.ItemIndex] as TCustomList do
          with Items[form2.CustomRanges.ItemIndex + 1] as TCustomRange do
          begin
            TrackBar1.Position := startframe;
            Form2.CustomRanges.ItemIndex := form2.CustomRanges.ItemIndex + 1;
            Form2.CustomRanges.ClearSelection;
            Form2.CustomRanges.Selected[form2.CustomRanges.ItemIndex] := true;
          end;
      end;
    end
    else if IsKeyEvent(kDeleteCurrentCLEntry, msg.CharCode) then
    begin
      if (Form2.CustomRangeLists.ItemIndex >= 0) then
        with Form2.CustomRangeLists.Items.Objects[form2.CustomRangeLists.ItemIndex] as TCustomList do
          for Counter := Count - 1 downto 0 do
            with Items[counter] as TCustomRange do
              if (startframe <= TrackBar1.Position) and (endframe >= TrackBar1.Position) then
              begin
                Delete(counter);
                Form2.CustomRanges.Count := Count;
              end;
    end
    else if IsKeyEvent(kToggleToolbar, msg.CharCode) then
    begin
      if Panel1.Height <> 0 then
      begin
        FOriginalPos.Y := Top;
        FOriginalPos.X := Left;
        Top := 0;
        Left := 0;
        BorderStyle := bsNone;
        Panel1.Height := 0
      end
      else
      begin
        BorderStyle := bsSingle;
        Panel1.Height := FPanelHeight;
        Top := FOriginalPos.Y;
        Left := FOriginalPos.X;
      end;

      CH := StatusBar1.Height + Panel1.Height + TrackBar1.Height + Multiple * Image1.Bitmap.Height;
      ClientHeight := CH;
      if ClientHeight <> CH then
        Multiple := 1;
    end
    else if IsKeyEvent(kBackPropagatePreset, msg.CharCode) then
    begin
      SIF := Form2.SectionInfo(TrackBar1.Position);
      for Counter := SIF.Index - 1 downto 0 do
          if Form2.Sections[Counter].Preset = SIF.Preset then
          begin
            for C2 := Counter + 1 to SIF.Index - 1 do
              Form2.Sections[C2].Preset := SIF.Preset;
            Form2.UpdateSectionList;
            Break;
          end;
    end
    else if IsKeyEvent(kCycleNextCustomList, msg.CharCode) then
    begin
      with Form2.CustomRangeLists do
        if (ItemIndex < 0) or (ItemIndex >= Count - 1) then
          ItemIndex := 0
        else
          ItemIndex := ItemIndex + 1;
      DrawFrame;
    end
    else if IsKeyEvent(kCyclePrevCustomList, msg.CharCode) then
    begin
      with Form2.CustomRangeLists do
        if ItemIndex <= 0 then
          ItemIndex := Count - 1
        else
          ItemIndex := ItemIndex - 1;
      DrawFrame;
    end
    else if IsKeyEvent(kExtendPresetToPrev, msg.CharCode) then
    begin
      SIF := Form2.SectionInfo(TrackBar1.Position);
      PV := False;

      for Counter := SIF.Index - 1 downto 0 do
        if Form2.Sections[Counter].Preset = SIF.Preset then
        begin
          PV := True;
          Break;
        end;

      if PV then
      begin
        for Counter := SIF.Index - 1 downto 0 do
        begin
          if Form2.Sections[Counter].Preset = SIF.Preset then
            Break;
          Form2.Sections[Counter].Preset := SIF.Preset;
        end;
      Form2.UpdateSectionList;
      end;
    end
    else
      Handled := False;
  end
  else
    Handled := False;
end;

procedure TForm1.PCN1Click(Sender: TObject);
begin
  if not TMenuItem(Sender).Checked then
    TMenuItem(Sender).Checked := true;
end;

procedure TForm1.Savepostprocessingoverride1Click(Sender: TObject);
var sl: tstringlist;
  counter: integer;
begin
  if SaveDialog1.Execute then
  begin
    sl := TStringList.Create;

    for counter := 0 to TrackBar1.Max do
      sl.Append(inttostr(counter) + ' ' + ifthen(FrameArray[counter].PostProcess, '+', '-'));

    try
      sl.SaveToFile(savedialog1.FileName);
    finally
      sl.Free;
    end;
  end;
end;

procedure TForm1.AutoSaveTimerTimer(Sender: TObject);
begin
  if SaveDialog5.FileName <> '' then
    SaveProject(SaveDialog5.FileName + '.bak');
end;

{ TV1Time }

constructor TV1Time.Create(StartFrame, EndFrame: Integer; FPS: Double);
begin
  FStartFrame := StartFrame;
  FEndFrame := EndFrame;
  FFPS := FPS;
end;

procedure TForm1.SetMultiple(M: Integer);
var
  CW, CH: Integer;
begin
    if (M >= 1) or (M <= -1) then
      FMultiple := M;

    if FFieldClip <> nil then
    begin
      with FFieldClip.GetVideoInfo do
      begin
        if M > 0 then
        begin
          CH := StatusBar1.Height + Panel1.Height + TrackBar1.Height + Multiple * Height;
          ImageBox.VertScrollBar.Range := Multiple * Height;
          Image1.Height := Multiple * Height;
        end
        else
        begin
          CH := StatusBar1.Height + Panel1.Height + TrackBar1.Height + Height div -Multiple;
          ImageBox.VertScrollBar.Range := Height div -Multiple;
          Image1.Height := Height div -Multiple;
        end;

        ClientHeight := CH;

        if M > 0 then
        begin
          CW := Max(720, Multiple * Width);
          Image1.Width := Multiple * Width;
          ImageBox.HorzScrollBar.Range := Multiple * Width;
        end
        else
        begin
          CW := Max(720, Width div -Multiple);
          Image1.Width := Width div -Multiple;
          ImageBox.HorzScrollBar.Range := Width div -Multiple;
        end;

        ClientWidth := CW;
      end;

      if Height > Monitor.Height then
        Height := Monitor.Height;

      if Width > Monitor.Width then
        Width := Monitor.Width;

      if Multiple = 1 then
        Image1.ScaleMode := smNormal
      else
        Image1.ScaleMode := smScale;

      if M > 0 then
        Image1.Scale := Multiple
      else
        Image1.Scale := 1/-Multiple;

      FTextLayer.Location := FloatRect(0, 0, Image1.Width, Image1.Height);
      FTextLayer.Bitmap.SetSize(Image1.Width, Image1.Height);
    end;
end;

procedure TForm1.SetOriginalVideo(Clip: IAsifClip);
begin
  FOriginalVideo := Clip;
  FFieldClip := PrepareVideo(FOriginalVideo);

  with FFieldClip.GetVideoInfo do
  begin
    TrackBar1.Max := NumFrames - 1;
    FFPS := FPSNumerator / FPSDenominator;
  end;
end;

function TForm1.PrepareVideo(Video: IAsifClip): IAsifClip;
begin
  se.ClipArg(Video);
  se.BoolArg(True, 'interlaced');
  Result := se.InvokeWithClipResult('ConvertToRGB32');

  se.ClipArg(Result);
  Result := se.InvokeWithClipResult('Cache');
end;

procedure TForm1.RedrawFrame;
begin
  FTBPos := -1;
  TrackBar1Change(self);
end;

procedure TForm1.OpenSource(FileName: string);
var
  FExt: string;
begin
  FExt := AnsiUpperCase(ExtractFileExt(FileName));

  CloseSource;

  OpenDialog1.FileName := FileName;
  OpenCloseButton.Caption := 'Close';

  try
    v2projectopen.OpenSource(OpenDialog1.FileName);
  except
    FreeProject;
    raise;
  end;

  FreeAndNil(Image2);
end;

procedure TForm1.Setcpenalty1Click(Sender: TObject);
begin
  CPenalty := StrToFloatDef(InputBox('Relative c match penalty', 'Factor', FloatToStr(CPenalty)), CPenalty);
end;

procedure TForm1.CloseSource;
begin
  if FileOpen then
  begin
    case MessageDlg('Do you want to save before closing the project?', mtConfirmation, mbYesNoCancel, 0) of
      mrCancel: Abort;
      mrYes: Save1Click(self);
      mrNo: ;
    end;

    FreeProject;
  end;
end;

procedure TForm1.Setedgecutoff1Click(Sender: TObject);
begin
  PGEdgeCutoff := StrToIntDef(InputBox('Edge cutoff', 'Frames', IntToStr(PGEdgeCutoff)), PGEdgeCutoff);
end;

procedure TForm1.Setminimallength1Click(Sender: TObject);
begin
  PGFrameLimit := StrToIntDef(InputBox('Minimal number of considered frames', 'Frames', IntToStr(PGFrameLimit)), PGFrameLimit);
end;

procedure TForm1.SelectLowestVmetricatSectionbounds1Click(Sender: TObject);
var
  I: Integer;
  VThresh: Integer;
  TempFrame: Integer;
begin
  VThresh := 40;
  SetVariablePrompt(VThresh, 0);

  for I := 0 to Form2.SectionCount - 1 do
      with Form2.Sections[I] do
      begin

        if (I > 0) then
        begin
          if GetVMetric(StartFrame) > VThresh then
            with FrameArray[StartFrame] do
            begin
              if (VMetric[0] < VMetric[1]) and (VMetric[0] < VMetric[2]) then
                Match := 0
              else if (VMetric[2] < VMetric[1]) then
                Match := 2
              else
                Match := 1;
            end;
        end;

        if (I < Form2.SectionCount - 1) then
        begin
          TempFrame := Form2.Sections[I+1].StartFrame - 1;
          if GetVMetric(TempFrame) > VThresh then
            with FrameArray[TempFrame] do
            begin
              if (VMetric[0] < VMetric[1]) and (VMetric[0] < VMetric[2]) then
                Match := 0
              else if (VMetric[2] < VMetric[1]) then
                Match := 2
              else
                Match := 1;
            end;
        end;
      end;

  DrawFrame;
end;

procedure TForm1.SaveAudioAvs1Click(Sender: TObject);
begin
  if SaveDialog5.FileName <> '' then
  begin
    if Form1.SaveDialog4.Execute then
      SaveAudioAvs(Form1.SaveDialog4.FileName);
  end
  else
    MessageDlg('You have to save the project before saving an avs.', mtError, [mbok], 0);
end;

procedure TForm1.SaveAudioAvs(FileName: string);
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  with SL, OriginalVideo.GetVideoInfo do
  begin
    if AnsiSameText(ExtractFileExt(FileName), '.wav') then
    begin
      Append('WavSource("' + FAudioFile + '")')
    end
    else                            
    begin
      Append(PluginListToScript(GetRequiredPlugins(True, 'FFmpegSource()', PluginPath, SE), PluginPath));
      Append('FFmpegSource("' + FAudioFile + '", vtrack=-2, atrack=-1)');
    end;

    Append(Format('AudioDub(BlankClip(width=16, height=16, length=%d, fps=%d, fps_denominator=%d), last)', [FActualFramecount, FPSNumerator, FPSDenominator]));
    if FAudioDelay <> 0 then
      Append('DelayAudio(' + FloatToStr(FAudioDelay / 1000) + ')');
    Append('');
    Append(MakeCutLine);
  end;
  try
    SL.SaveToFile(FileName);
  finally
    SL.Free;
  end;
end;

function TForm1.MakeCutLine: string;
var
  TempTrims: TStringDynArray;
  I: Integer;
  TrimLine: string;
begin
  Result := '';
    if Length(FCuts) > 0 then
    begin
      SetLength(TempTrims, 0);

      // first cut
      if FCuts[0].CutStart > 0 then
      begin
        SetLength(TempTrims, Length(TempTrims) + 1);
        TempTrims[0] := Format('Trim(%d,%d)', [0, FCuts[0].CutStart - 1]);
      end;
      
      // middle cuts
      for I := 0 to Length(FCuts) - 2 do
      begin
        SetLength(TempTrims, Length(TempTrims) + 1);
        TempTrims[Length(TempTrims) - 1] := Format('Trim(%d,%d)', [FCuts[I].CutEnd + 1, FCuts[I + 1].CutStart - 1]);
      end;

      // final cut
      if FCuts[Length(FCuts) - 1].CutEnd < FActualFramecount - 1 then
      begin
        SetLength(TempTrims, Length(TempTrims) + 1);
        TempTrims[Length(TempTrims) - 1] := Format('Trim(%d,%d)', [FCuts[Length(FCuts) - 1].CutEnd + 1, FActualFramecount - 1]);
      end;

      if Length(TempTrims) = 0 then
        raise EInitializationFailed.Create('Nothing left after cutting');

      TrimLine := TempTrims[0];
      for I := 1 to Length(TempTrims) - 1 do
        TrimLine := TrimLine + '++' + TempTrims[I];
      Result := TrimLine;
    end;
end;

procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
begin
  if Button = mbMiddle then
    FMouseDrag := not FMouseDrag;
end;

procedure TForm1.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer; Layer: TCustomLayer);
begin
  if FMouseDrag then
  begin
    ImageBox.HorzScrollBar.Position := ImageBox.HorzScrollBar.Position + (X - FLastX) div 2;
    ImageBox.VertScrollBar.Position := ImageBox.VertScrollBar.Position + (Y - FLastY) div 2;
    ImageBox.Update;
  end;

  FLastX := X;
  FLastY := Y;
end;

end.

