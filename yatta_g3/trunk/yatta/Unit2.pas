unit Unit2;

interface

uses
  Windows, Math, StrUtils, Messages, SysUtils, Types, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, asif, asifadditions, inifiles, contnrs,
  Menus, keymap, keydefaults, GR32_Image, GR32, CheckLst;

type
  TNoDecAddRejection = (ndarNoDecimateRangeExists, ndarDecimationExists, ndarInvalidRange, ndarFeatureDisabled);
  TNoDecAddRejections = set of TNoDecAddRejection;
  TOutputMethod = (omNone = -1, omFile = 0, omPreTelecide = 1, omPostTelecide = 2, omPreDecimate = 3, omPostDecimate = 4, omPostResize = 5);

  EPresetError = class(exception);

  TCustomRange = class
  private
    FStartFrame, FEndFrame: Integer;
  public
    property StartFrame: Integer read FStartFrame;
    property EndFrame: Integer read FEndFrame;
    constructor Create(StartFrame, EndFrame: Integer);
  end;

  TCustomList = class(TObjectList)
  private
    FName: string;
    FProcessing: string;
    FOutput: string;
    FOutputMethod: TOutputMethod;
    function GetItem(Index: Integer): TCustomRange;
    procedure SetItem(Index: Integer; Item: TCustomRange);
  public
    property Name: string read FName;
    property Processing: string read FProcessing write FProcessing;
    property Output: string read FOutput write FOutput;
    property OutputMethod: TOutputMethod read FOutputMethod write FOutputMethod;
    property Items[Index: Integer]: TCustomRange read GetItem write SetItem; default;
    constructor Create(Name: string; Processing: string = ''; Output: string = ''; OutputMethod: TOutputMethod = omNone);
  end;

  TByteSet = set of byte;

  TFreezeInfo = class(TCustomRange)
  private
    FFrom: Integer;
  public
    property From: Integer read FFrom;
    constructor Create(StartFrame, EndFrame, From: Integer);
  end;

  TDecimateInfo = class(TCustomRange);

  TSectionEntry = class(TObject)
  private
    FStartFrame: Integer;
    FPreset: Byte;
    FTime: Double;
  public
    property StartFrame: Integer read FStartFrame;
    property Preset: Byte read FPreset write FPreset;
    property Time: Double read FTime write FTime;
    constructor Create(StartFrame, Preset: Integer; Time: Double);
  end;

  TSectionInfo = record
    StartFrame, EndFrame, Preset, Index: Integer;
    CTime, NTime: Double;
  end;

  TPreset = class(TObject)
  private
    FId: Byte;
    FChain: string;
  public
    property Id: Byte read FId;
    property Chain: string read FChain write FChain;
    constructor Create(Id: Integer; Chain: string);
  end;

  TForm2 = class(TForm)
    Button5: TButton;
    Button6: TButton;
    SaveAvs: TButton;
    SaveDialog1: TSaveDialog;
    PresetListBox: TListBox;
    PostProcessor: TRadioGroup;
    Button8: TButton;
    PageControl1: TPageControl;
    TabSheet8: TTabSheet;
    TabSheet1: TTabSheet;
    updatepreset: TButton;
    newpreset: TButton;
    deletepreset: TButton;
    ComboBox2: TComboBox;
    Memo1: TMemo;
    TabSheet7: TTabSheet;
    ResizeOn: TCheckBox;
    Resizer: TRadioGroup;
    BicubicC: TLabeledEdit;
    BicubicB: TLabeledEdit;
    TabSheet2: TTabSheet;
    deleteff: TButton;
    savevfr: TButton;
    deletend: TButton;
    Freezeframes: TListBox;
    Nodecimates: TListBox;
    GroupBox1: TGroupBox;
    LabeledEdit3: TLabeledEdit;
    LabeledEdit4: TLabeledEdit;
    LabeledEdit5: TLabeledEdit;
    LabeledEdit6: TLabeledEdit;
    LabeledEdit7: TLabeledEdit;
    PreviewAvs: TButton;
    Button2: TButton;
    Button4: TButton;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    TabSheet3: TTabSheet;
    GroupBox2: TGroupBox;
    vfrthresholds: TButton;
    findvfr1: TButton;
    findvfr2: TButton;
    vfindmethod: TRadioGroup;
    vprev: TButton;
    vnext: TButton;
    vlimit: TLabeledEdit;
    OpenDialog1: TOpenDialog;
    SaveLiteAvs: TButton;
    PostThreshold: TLabeledEdit;
    SharpKernel: TCheckBox;
    TwoWayKernel: TCheckBox;
    CropOn: TCheckBox;
    TabSheet4: TTabSheet;
    Button19: TButton;
    ComboBox3: TComboBox;
    DecimateType: TRadioGroup;
    Button3: TButton;
    OpenDialog3: TOpenDialog;
    Button20: TButton;
    GroupBox3: TGroupBox;
    Splitter1: TSplitter;
    GroupBox4: TGroupBox;
    CustomRanges: TListBox;
    CustomRangeLists: TListBox;
    Edit1: TEdit;
    Edit2: TEdit;
    PopupMenu1: TPopupMenu;
    PopupMenu2: TPopupMenu;
    MoveUp1: TMenuItem;
    MoveDown1: TMenuItem;
    Delete1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    PreTelecide1: TMenuItem;
    PostTelecide1: TMenuItem;
    PreDecimate1: TMenuItem;
    PostDecimate1: TMenuItem;
    PostResize1: TMenuItem;
    MoveTo1: TMenuItem;
    CopyTo1: TMenuItem;
    ExternalFile1: TMenuItem;
    N3: TMenuItem;
    Save1: TMenuItem;
    N4: TMenuItem;
    NewList1: TMenuItem;
    FromVMetric1: TMenuItem;
    Empty1: TMenuItem;
    N5: TMenuItem;
    CopytoSections1: TMenuItem;
    DeleteList1: TMenuItem;
    Button1: TButton;
    SectionListbox: TListBox;
    procedure FormCreate(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure ListBox2Click(Sender: TObject);
    procedure ListBox1Change(Sender: TObject);
    procedure ListBox2Change(Sender: TObject);
    procedure SaveAvsClick(Sender: TObject);
    procedure updatepresetClick(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure newpresetClick(Sender: TObject);
    procedure deletepresetClick(Sender: TObject);
    procedure BicubicBChange(Sender: TObject);
    procedure BicubicCChange(Sender: TObject);
    procedure PresetListBoxDblClick(Sender: TObject);
    procedure FreezeframesDblClick(Sender: TObject);
    procedure NodecimatesDblClick(Sender: TObject);
    procedure savevfrClick(Sender: TObject);
    procedure deleteffClick(Sender: TObject);
    procedure deletendClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PretelecideClick(Sender: TObject);
    procedure PosttelecideClick(Sender: TObject);
    procedure PredecimateClick(Sender: TObject);
    procedure PostdecimateClick(Sender: TObject);
    procedure PostresizeClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure PreviewAvsClick(Sender: TObject);
    procedure vprevClick(Sender: TObject);
    procedure vnextClick(Sender: TObject);
    procedure vlimitChange(Sender: TObject);
    procedure vfindmethodClick(Sender: TObject);
    procedure vfrthresholdsClick(Sender: TObject);
    procedure findvfr1Click(Sender: TObject);
    procedure findvfr2Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure TabSheet3Show(Sender: TObject);
    procedure SaveLiteAvsClick(Sender: TObject);
    procedure PostProcessorClick(Sender: TObject);
    procedure PostThresholdChange(Sender: TObject);
    procedure TabSheet7Show(Sender: TObject);
    procedure ResizeOnClick(Sender: TObject);
    procedure ResizerClick(Sender: TObject);
    procedure Button19Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button20Click(Sender: TObject);
    procedure CustomRangeListsClick(Sender: TObject);
    procedure CustomRangesData(Control: TWinControl; Index: Integer;
      var Data: string);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure mclick1Click(Sender: TObject);
    procedure cclick1Click(Sender: TObject);
    procedure CustomRangesDblClick(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure ExternalFile1Click(Sender: TObject);
    procedure MoveUp1Click(Sender: TObject);
    procedure MoveDown1Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure SectionListBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FreezeframesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure NodecimatesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SectionListBoxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Empty1Click(Sender: TObject);
    procedure FromVMetric1Click(Sender: TObject);
    procedure CopytoSections1Click(Sender: TObject);
    procedure DeleteList1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    MouseDown: Boolean;
    sthd: Integer;
    stlt: Integer;

    function FindNoDecimatePos(StartFrame: Integer): Integer;
    function FindFreezeFramePos(StartFrame: Integer): Integer;
    function FindCustomRangePos(StartFrame: Integer; List: TStrings): Integer;
    function CanAddNoDecimate(StartFrame, EndFrame: Integer): TNoDecAddRejections;
    function CanAddFreezeFrame(StartFrame, EndFrame, Source: Integer): Boolean;

    function GetSection(Index: Integer): TSectionEntry;
    function GetSectionSelected(Index: Integer): Boolean;
    function GetSectionCount: Integer;
    function GetPresetProperty(Index: Integer): TPreset;
    function GetPresetCount: Integer;

    function GetSelectedCustomList: TCustomList;
  public
    procedure CreateParams(var Params: TCreateParams); override;
    procedure AddPreset(Name: string; Id: Integer; Chain: string);
    function GetCustomRange(InRange: Integer; List: TStrings): TCustomRange;
    function AddFreezeFrame(StartFrame, EndFrame, SourceFrame: Integer; Force: Boolean = False): Boolean;
    function SectionInfo(Frame: Integer): TSectionInfo;
    function GetPreset(Id: Integer): TPreset;
    function GetPresetName(Id: Integer): string;
    function AddSection(StartFrame: Integer; Preset: Integer; Time: Double): Boolean;
    function RemSection(StartFrame: Integer): Boolean;
    function NoDecimateExists(StartFrame, EndFrame: Integer): Boolean;
    function GetFreezeFrameRange(InRange: Integer): TFreezeInfo;
    function GetNoDecimateRange(InRange: Integer): TDecimateInfo;
    function AddNoDecimate(StartFrame, EndFrame: Integer): TNoDecAddRejections;
    function MakeOverrideList(FunctionList: TStringList; PreviewScript: Boolean): TStringList;
    
    procedure ImportFromProject(Filename: string);
    procedure DeleteSection(Index: Integer);
    procedure UpdateSectionList;

    property Sections[Index: Integer]: TSectionEntry read GetSection;
    property SectionSelected[Index: Integer]: Boolean read GetSectionSelected;
    property SectionCount: Integer read GetSectionCount;
    property Presets[Index: Integer]: TPreset read GetPresetProperty;
    property PresetCount: Integer read GetPresetCount;
    property SelectedCustomList: TCustomList read GetSelectedCustomList;
  end;

function CustomListSort(Item1, Item2: Pointer): Integer;

var
  Form2: TForm2;

implementation

uses Unit1, Unit11, unit4, crop, Unit3, v2projectopen, yshared,
  presetimport;

{$R *.dfm}

constructor TFreezeInfo.Create(StartFrame, EndFrame, From: Integer);
begin
  inherited Create(StartFrame, EndFrame);
  FFrom := From;
end;

function TForm2.FindCustomRangePos(StartFrame: Integer; List: TStrings): Integer;
var
  Counter: Integer;
begin
  Result := 0;

  for Counter := List.Count - 1 downto 0 do
  begin
    if (List.Objects[Counter] as TCustomRange).StartFrame < StartFrame then
    begin
      Result := Counter + 1;
      Exit;
    end;
  end;
end;

function TForm2.FindNoDecimatePos(StartFrame: Integer): Integer;
begin
  Result := FindCustomRangePos(StartFrame, Nodecimates.Items);
end;

function TForm2.FindFreezeFramePos(StartFrame: Integer): Integer;
begin
  Result := FindCustomRangePos(StartFrame, Freezeframes.Items);
end;

function TForm2.GetCustomRange(InRange: Integer; List: TStrings): TCustomRange;
var
  Counter: Integer;
begin
  Result := nil;

  for Counter := 0 to List.Count - 1 do
  begin
    with List.Objects[Counter] as TCustomRange do
      if (StartFrame <= InRange) and (EndFrame >= InRange) then
      begin
        Result := List.Objects[Counter] as TCustomRange;
        Exit;
      end;
  end;
end;

function TForm2.GetNoDecimateRange(InRange: Integer): TDecimateInfo;
begin
  Result := GetCustomRange(InRange, Nodecimates.Items) as TDecimateInfo;
end;

function TForm2.GetFreezeFrameRange(InRange: Integer): TFreezeInfo;
begin
  Result := GetCustomRange(InRange, Freezeframes.Items) as TFreezeInfo;
end;

//getpos, then check inrange for index

function TForm2.NoDecimateExists(StartFrame, EndFrame: Integer): Boolean;
var
  Counter: Integer;
  Entry: TDecimateInfo;
begin
  Result := False;

  for Counter := 0 to Nodecimates.Items.Count - 1 do
  begin
    Entry := TDecimateInfo(Nodecimates.Items.Objects[Counter]);
    if (Entry.StartFrame >= StartFrame) and (Entry.StartFrame <= EndFrame)
      or (Entry.EndFrame <= EndFrame) and (Entry.EndFrame >= StartFrame)
      or (Entry.StartFrame <= StartFrame) and (Entry.EndFrame >= EndFrame) then
    begin
      Result := True;
      Break;
    end;
  end;
end;


function TForm2.CanAddNoDecimate(StartFrame, EndFrame: Integer): TNoDecAddRejections;
var
  Counter: Integer;
begin
  Result := [];

  if NoDecimateExists(StartFrame, EndFrame) then
    Include(Result, ndarNoDecimateRangeExists);
  if (StartFrame >= EndFrame) then
    Include(Result, ndarInvalidRange);

  if Form1.OpenMode in MatchingProjects then
    for Counter := StartFrame to EndFrame do
      if FrameArray[Counter].Decimate then
      begin
        Include(Result, ndarDecimationExists);
        Break;
      end;
end;

function TForm2.CanAddFreezeFrame(StartFrame, EndFrame, Source: Integer): Boolean;
var
  Counter: Integer;
  Entry: TFreezeInfo;
begin
  if (StartFrame > EndFrame) or ((StartFrame = EndFrame) and (Source = EndFrame)) or (EndFrame > Form1.TrackBar1.Max) or (StartFrame < 0) then
    Result := False
  else
  begin
    Result := True;

    for Counter := 0 to Freezeframes.Items.Count - 1 do
    begin
      Entry := TFreezeInfo(Freezeframes.Items.Objects[Counter]);

      if (Entry.StartFrame <= Source) and (Entry.EndFrame >= Source)
        or (Entry.StartFrame >= StartFrame) and (Entry.StartFrame <= EndFrame)
        or (Entry.EndFrame <= EndFrame) and (Entry.EndFrame >= StartFrame)
        or (Entry.StartFrame <= StartFrame) and (Entry.EndFrame >= EndFrame)
        or (Entry.From >= StartFrame) and (Entry.From <= EndFrame) then
        Result := False;
    end;
  end;
end;

procedure TForm2.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent := HWND_DESKTOP; // More elegant than 0
end;

function TForm2.AddFreezeFrame(StartFrame, EndFrame, SourceFrame: Integer; Force: Boolean = False): Boolean;
var
  FPos: Integer;
begin
  if Force or CanAddFreezeFrame(StartFrame, EndFrame, SourceFrame) then
  begin
    FPos := FindFreezeFramePos(StartFrame);
    Freezeframes.Items.InsertObject(FPos, Format('FreezeFrame(%d,%d,%d)', [StartFrame, EndFrame, SourceFrame]), TFreezeInfo.Create(StartFrame, EndFrame, SourceFrame));
    Freezeframes.ItemIndex := FPos;
    Result := True;
  end
  else
    Result := False;
end;

constructor TSectionEntry.Create(StartFrame, Preset: Integer; Time: Double);
begin
  FStartFrame := StartFrame;
  FPreset := Preset;
  FTime := Time;
end;

function TForm2.GetPresetName(Id: Integer): string;
var
  Counter: Integer;
begin
  if Id < 0 then
    Result := ''
  else
  begin
    Result := '[error, preset missing]';

    for Counter := 0 to PresetCount - 1 do
      if Presets[Counter].Id = Id then
      begin
        Result := PresetListBox.Items[Counter];
        Break;
      end;
  end;
end;

function TForm2.GetPreset(Id: Integer): TPreset;
var
  Counter: Integer;
begin
  for Counter := 0 to PresetCount - 1 do
  begin
    Result := Presets[Counter];
    if Result.Id = Id then
      Exit;
  end;

  Result := nil;
end;

function TForm2.SectionInfo(Frame: Integer): TSectionInfo;
var
  Counter: Integer;
  Entry: TSectionEntry;
begin
  for Counter := SectionCount - 1 downto 0 do
  begin
    Entry := Sections[Counter];

    if Entry.StartFrame <= Frame then
      with Result do
      begin
        Index := Counter;
        StartFrame := Entry.StartFrame;
        Preset := Entry.Preset;
        CTime := Entry.Time;

        if Counter = SectionCount - 1 then
        begin
          EndFrame := Form1.TrackBar1.Max;
          NTime := (Form1.TrackBar1.Max + 1) / Form1.FPS;
        end
        else
        begin
          Entry := Sections[Counter + 1];
          NTime := Entry.Time;
          EndFrame := Entry.StartFrame - 1;
        end;
        Break;
      end;
  end;
end;

constructor TPreset.Create(Id: Integer; Chain: string);
begin
  FId := Id;
  FChain := Chain;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  MouseDown := False;
  sthd := 500;
  stlt := 10;
  SectionListBox.MultiSelect := True;
end;

function TForm2.AddSection(StartFrame: Integer; Preset: Integer; Time: Double): Boolean;
var
  Counter: Integer;
begin
  Result := StartFrame <= Form1.TrackBar1.Max;
  if not Result then
    Exit;

  for Counter := SectionCount downto 0 do
  begin
    if (Counter = 0) or (Sections[Counter - 1].StartFrame < StartFrame) then
    begin
      SectionListBox.Items.InsertObject(Counter, '#' + ZeroPad(IntToStr(StartFrame), PadSize) + ' (' + TimeInSecondsToStr(StartFrame / Form1.FPS) + ') ' + GetPresetName(Preset), TSectionEntry.Create(StartFrame, Preset, Time));
      Exit;
    end
    else if (Sections[Counter - 1].StartFrame = StartFrame) then
    begin
      Result := False;
      Exit;
    end;
  end;
end;

function TForm2.RemSection(StartFrame: Integer): Boolean;
var
  Counter: Integer;
begin
  Result := False;

  for Counter := 0 to SectionCount - 1 do
  begin
    if (Sections[Counter].StartFrame <= StartFrame) and (StartFrame > 0) then
    begin
      DeleteSection(Counter);
      Result := True;
      Exit;
    end;
  end;
end;

procedure TForm2.Button6Click(Sender: TObject);
var
  Counter: Integer;
begin
  for Counter := SectionCount - 1 downto 1 do
    if SectionListBox.Selected[Counter] then
      DeleteSection(Counter);

  Form1.RedrawFrame;
end;

procedure TForm2.Button5Click(Sender: TObject);
begin
  AddSection(Form1.TrackBar1.Position, SectionInfo(Form1.TrackBar1.Position).Preset, Form1.TrackBar1.Position / Form1.FPS);
  Form1.DrawFrame;
end;

procedure TForm2.Button8Click(Sender: TObject);
var
  SL: TStringList;
  Counter: Integer;
  BlockCount: Integer;
  TS: string;
begin
  if OpenDialog1.Execute then
  begin
    for Counter := SectionCount - 1 downto 0 do
    begin
      SectionListBox.Items.Objects[Counter].Free;
      SectionListBox.Items.Delete(Counter);
      SectionListBox.ItemIndex := 0;
    end;

    SL := TStringList.Create;

    try
      SL.LoadFromFile(OpenDialog1.FileName);

      for Counter := SL.Count - 1 downto 0 do
        if (SL[Counter] = '') or (SL[Counter][1] = '#') then
          SL.Delete(Counter);

      if Form1.TrackBar1.Max + 10 < SL.Count then
      begin
        MessageDlg('Log file doesn''t match the video.', mtError, [mbok], 0);
        Exit;
      end;

      if SL[0] = 'simple section list' then
      begin
        for Counter := 1 to SL.Count - 1 do
          AddSection(StrToIntDef(SL[Counter], 0), 0, StrToIntDef(SL[Counter], 0) / Form1.FPS);
      end
      else if (Length(SL[0]) >= 2) and (SL[0][1] = 'i') and (SL[0][2] = ' ') then
      begin
        for Counter := 0 to SL.Count - 1 do
          if (SL[Counter] <> '') and (SL[Counter][1] = 'i') then
            AddSection(Counter, 0, (Counter - 3) / Form1.FPS);
      end
      else
      begin
        BlockCount := ((Form1.Image1.Width + 15) div 16) * ((Form1.Image1.Height + 15) div 16);

        try
          for Counter := 0 to SL.Count - 1 do
          begin
            TS := GetToken(SL[Counter], 12);
            TS := RightStr(TS, Length(TS) - AnsiPos(':', TS));
            TS := LeftStr(TS, Length(TS) - 1);

            if StrToInt(TS) > 0.85 * BlockCount then
              AddSection(Counter, 0, Counter / Form1.FPS);

          end;
        finally

        end;
      end;

      AddSection(0, 0, 0);

    finally
      SL.Free;
    end;
  end;
end;

procedure TForm2.ListBox2Click(Sender: TObject);
begin
  Sections[SectionListBox.ItemIndex].Preset := Presets[PresetListBox.ItemIndex].Id;
end;

procedure TForm2.ListBox1Change(Sender: TObject);
begin
  Form1.TrackBar1.Position := Sections[SectionListBox.ItemIndex].StartFrame;
end;

procedure TForm2.ListBox2Change(Sender: TObject);
var
  Counter: Integer;
begin
  for Counter := 0 to SectionCount - 1 do
    if SectionListBox.Selected[Counter] then
      Sections[Counter].Preset := Presets[PresetListBox.ItemIndex].Id;

  UpdateSectionList;

  Form1.DrawFrame;
end;

function TForm2.MakeOverrideList(FunctionList: TStringList; PreviewScript: Boolean): TStringList;
  procedure AddPresetClips(SL: TStrings; UsedPresets: TByteSet);
  var
    Counter: Integer;
  begin
    for Counter := 0 to PresetCount - 1 do
      with Presets[Counter] do
        if Id in UsedPresets then
          SL.Append(Format('PresetClip%d=Preset%d()', [Id, Id]));
  end;

  function GetFramePos(Frame: Integer; AfterDecimate: Boolean): Integer;
  begin
    if AfterDecimate then
      Result := Form1.FrameMap[Frame]
    else
      Result := Frame;
  end;

  procedure AddCustomLists(SL: TStrings; Location: TOutputMethod; AfterDecimate: Boolean);
  var
    Counter, C2: integer;
  begin
    for Counter := 0 to CustomRangeLists.Count - 1 do
      with CustomRangeLists.Items.Objects[Counter] as TCustomList do
        if OutputMethod = Location then
          for C2 := 0 to Count - 1 do
            with Items[C2] as TCustomRange do
              SL.Append(AnsiReplaceStr(AnsiReplaceStr(Processing, '%s', IntToStr(GetFramePos(StartFrame, AfterDecimate))), '%e', IntToStr(GetFramePos(EndFrame, AfterDecimate))));
  end;

var
  SL: TStringList;
  TempTrims: TStringList;
  Counter, InCounter, DropCounter: Integer;
  Pixels: array of Smallint;
  LastStart: Integer;
  FCounter: Integer;
  DecimateLine: string;
  LEndFr: Integer;
  UsedPresets: TByteSet;
  SpecialUsedPresets: TByteSet;
  IsVFR: Boolean;
  TempExt: string;
  TempString: string;
  FunctionStart: Integer;
  IsDecimated: Boolean;
  I: Integer;
begin
  IsVFR := Nodecimates.Count > 0;
  IsDecimated := (Form1.OpenMode in MatchingProjects) and Form11.Decimation.Checked;

  SL := TStringList.Create;

  SL.Append('');

  UsedPresets := [];
  SpecialUsedPresets := [];

  for Counter := 0 to SectionCount - 1 do
    Include(UsedPresets, Sections[Counter].Preset);

  if Form1.PreTelecide >= 0 then
    Include(SpecialUsedPresets, Form1.PreTelecide);
  if Form1.PostTelecide >= 0 then
    Include(SpecialUsedPresets, Form1.PostTelecide);
  if Form1.PreDecimate >= 0 then
    Include(SpecialUsedPresets, Form1.PreDecimate);
  if Form1.PostDecimate >= 0 then
    Include(SpecialUsedPresets, Form1.PostDecimate);
  if Form1.PostResize >= 0 then
    Include(SpecialUsedPresets, Form1.PostResize);

  for Counter := 0 to PresetCount - 1 do
    with Presets[Counter] do
      if (Id in UsedPresets) or (Id in SpecialUsedPresets) then
      begin
        FunctionStart := SL.Add('function Preset' + IntToStr(Id) + '(clip c) {');
        SL.Append('#Name: ' + PresetListBox.Items[Counter]);
        SL.Append('c');
        if Chain <> '' then
          SL.Append(Chain);
        SL.Append('return last');
        SL.Append('}');
        if FunctionList <> nil then
          FunctionList.AddObject(PresetListBox.Items[Counter], TCustomRange.Create(FunctionStart, SL.Add('')))
        else
          SL.Append('');
      end;

  if PreviewScript then
  begin
    SL.Append('yattavideosource');
  end
  else
  begin
    TempExt := AnsiLowerCase(ExtractFileExt(Form1.SourceFile));
    if (TempExt = '.d2v') then
    begin
      SL.Append(MPEG2DecName + '_Mpeg2Source("' + Form1.SourceFile + '")');
      if not AnsiSameText('DGDecode', MPEG2DecName) and se.FunctionExists('SetPlanarLegacyAlignment') then
        SL.Append('SetPlanarLegacyAlignment(true)');
    end
    else if TempExt = '.dga' then
      SL.Append('AVCSource("' + Form1.SourceFile + '")')
    else if TempExt = '.avs' then
      SL.Append('Import("' + Form1.SourceFile + '")')
    else
      SL.Append('AviSource("' + Form1.SourceFile + '")');


    if Length(Form1.FCuts) > 0 then
    begin
      TempTrims := TStringList.Create;

      // first cut
      if Form1.FCuts[0].CutStart > 0 then
        TempTrims.Append(Format('Trim(%d,%d)', [0, Form1.FCuts[0].CutStart - 1]));

      // middle cuts
      for I := 0 to Length(Form1.FCuts) - 2 do
        TempTrims.Append(Format('Trim(%d,%d)', [Form1.FCuts[I].CutEnd + 1, Form1.FCuts[I + 1].CutStart - 1]));

      // final cut
      if Form1.FCuts[Length(Form1.FCuts) - 1].CutEnd < Form1.FActualFramecount - 1 then
        TempTrims.Append(Format('Trim(%d,%d)', [Form1.FCuts[Length(Form1.FCuts) - 1].CutEnd + 1, 0]));

      if TempTrims.Count = 0 then
        raise EInitializationFailed.Create('Nothing left after cutting');

      TempString := TempTrims[0];
      for I := 1 to TempTrims.Count - 1 do
        TempString := TempString + '++' + TempTrims[i];
      TempTrims.Free;
    end;

    SL.Append(TempString);
  end;

  SL.Append('');

  if Form1.PreTelecide >= 0 then
  begin
    SL.Append(Format('Preset%d()', [Form1.PreTelecide]));
    SL.Append('');
  end;

  AddCustomLists(SL, omPreTelecide, False);

  SL.Append('');

  if Form1.OpenMode in MatchingProjects then
  begin
    if PostProcessor.ItemIndex = 5 then
      SL.Append('YattaPreMatchClip = last');

    SL.Append('FieldHint(ovr="' + ChangeFileExt(Form1.SaveDialog5.FileName, FieldExt) + '")');

    case PostProcessor.ItemIndex of
      0..1: SL.Append(Format('FieldDeinterlace(blend=%s,dthreshold=%d)', [IfThen(PostProcessor.ItemIndex = 1, 'false', 'true'), Form1.PostThreshold]));
      2: SL.Append(Format('TelecideHints(sangnom(order=%d,aa=%d))', [Form11.RadioGroup1.ItemIndex xor 1, Form1.PostThreshold]));
      3..4: SL.Append(Format('%sKernelDeint(order=%d,sharp=%s,twoway=%s,threshold=%d)', [IfThen(PostProcessor.ItemIndex = 4, 'Leak'), Form11.RadioGroup1.ItemIndex, IfThen(not SharpKernel.Checked, 'false', 'true'), IfThen(not TwoWayKernel.Checked, 'false', 'true'), Form1.PostThreshold]));
      5: SL.Append(Format('TDeint(clip2=YattaPreMatchClip,hints=true,order=%d,type=%d,sharp=%s)', [Form11.RadioGroup1.ItemIndex, Form1.PostThreshold, IfThen(not SharpKernel.Checked, 'false', 'true')]));
      6: SL.Append(Format('TelecideHints(NNEDI())', []));
      7: SL.Append(Format('TelecideHints(NNEDI2())', []));
      8: SL.Append(Format('TelecideHints(NNEDI3())', []));
      9: SL.Append(Format('TelecideHints(EEDI3())', []));
    end;
    SL.Append('');
  end;

  if Form1.PostTelecide >= 0 then
  begin
    SL.Append(Format('Preset%d()', [Form1.PostTelecide]));
    SL.Append('');
  end;

  AddCustomLists(SL, omPostTelecide, False);

  /////////////////////

  SL.Append('');


    AddPresetClips(SL, UsedPresets);

    SetLength(Pixels, (Form1.TrackBar1.Max + 1));

    for InCounter := 0 to SectionCount - 2 do
      with Sections[InCounter] do
        for Counter := StartFrame to Sections[InCounter + 1].StartFrame do
            Pixels[Counter] := Preset;

    if SectionCount > 0 then
      with Sections[SectionCount - 1] do
        for Counter := StartFrame to Form1.TrackBar1.Max do
            Pixels[Counter] := Preset;

    LastStart := 0;

    SL.Append('');

    TempString := '';

    for Counter := 0 to Form1.TrackBar1.Max do
    begin
      if (Pixels[LastStart] <> Pixels[Counter]) or (Counter = Form1.TrackBar1.Max) then
      begin
        if (Pixels[LastStart] >= 0) then
          TempString := TempString + Format('PresetClip%d.Trim(%d,%d)+', [Pixels[LastStart], LastStart, Counter - IfThen(Counter <> Form1.TrackBar1.Max, 1, 0)]);
        LastStart := Counter;
      end;
    end;

    // fix odd avisynth trim syntax
    TempString := AnsiReplaceStr(TempString, 'Trim(0,0)+', 'Trim(0,1).deleteframe(1)+');
    SL.Append(LeftStr(TempString, Length(TempString) - 1));

    SL.Append('');

  for Counter := 0 to Freezeframes.Items.Count - 1 do
    SL.Append(Freezeframes.Items[Counter]);

  SL.Append('');

  if Form1.PreDecimate >= 0 then
  begin
    SL.Append(Format('Preset%d()', [Form1.PreDecimate]));
    SL.Append('');
  end;

  AddCustomLists(SL, omPreDecimate, False);

  SL.Append('');

  if IsDecimated then
  begin

    if IsVFR then
    begin

      if DecimateType.ItemIndex = 0 then
        SL.Append(Format('DClip = Decimate(cycle=%d,quality=3,ovr="%s").assumefps(last.framerate)', [Form1.Distance, ChangeFileExt(Form1.SaveDialog5.FileName, DecExt)]))
      else
        SL.Append(Format('DClip = TDecimate(mode=1,cycle=%d,ovr="%s").assumefps(last.framerate)', [Form1.Distance, ChangeFileExt(Form1.SaveDialog5.FileName, DecExt)]));

      LEndFr := -1;
      FCounter := 0;
      DecimateLine := '';

        if not Form2.NoDecimateExists(0, 0) then
          DecimateLine := Format('DClip.Trim(0,%d)+', [((Nodecimates.Items.Objects[0] as TDecimateInfo).StartFrame div Form1.Distance) * (Form1.Distance - 1) - 1]);

        for Counter := 0 to Nodecimates.Count - 1 do
          with Nodecimates.Items.Objects[Counter] as TDecimateInfo do
          begin

            if NoDecimateExists(EndFrame + 1, EndFrame + 1) then
            begin
              if LEndFr = -1 then
                LEndFr := StartFrame;
              Continue;
            end;

            if LEndFr = -1 then
              LEndFr := StartFrame;

            DecimateLine := DecimateLine + Format('Trim(%d,%d)+', [LEndFr, EndFrame]);

            LEndFr := -1;

            if Counter <> Nodecimates.Count - 1 then
              DecimateLine := DecimateLine + Format('DClip.Trim(%d,%d)+', [((EndFrame + 1) div Form1.Distance) * (Form1.Distance - 1), ((Nodecimates.Items.Objects[Counter + 1] as TDecimateInfo).StartFrame div Form1.Distance) * (Form1.Distance - 1) - 1])
            else if not NoDecimateExists(Form1.TrackBar1.Max, Form1.TrackBar1.Max) then
              DecimateLine := DecimateLine + Format('DClip.Trim(%d,0)+', [((EndFrame + 1) div Form1.Distance) * (Form1.Distance - 1)]);
          end;

        SL.Append(LeftStr(DecimateLine, Length(DecimateLine) - 1));
    end
    else
    begin
      if DecimateType.ItemIndex = 0 then
        SL.Append(Format('Decimate(cycle=%d,quality=3,ovr="%s")', [Form1.Distance, ChangeFileExt(Form1.SaveDialog5.FileName, DecExt)]))
      else
        SL.Append(Format('TDecimate(mode=1,cycle=%d,ovr="%s")', [Form1.Distance, ChangeFileExt(Form1.SaveDialog5.FileName, DecExt)]));
    end;
  end;

  SL.Append('');

  if Form1.PostDecimate >= 0 then
  begin
    SL.Append(Format('Preset%d()', [Form1.PostDecimate]));
    SL.Append('');
  end;

  AddCustomLists(SL, omPostDecimate, IsDecimated);

  SL.Append('');

  if (CropForm.AvisynthCropLine.Text <> 'Crop(0,0,0,0)') and CropOn.Checked then
    SL.Append(CropForm.AvisynthCropLine.Text);

  if ResizeOn.Checked then
  begin
    if Resizer.ItemIndex <> 2 then
      SL.Append(Format('%sResize(%d,%d)', [Resizer.Items[Resizer.ItemIndex], CropForm.ResizeWidthUpDown.Position, CropForm.ResizeHeightUpDown.Position]))
    else
      SL.Append(Format('%sResize(%d,%d,%s,%s)', [Resizer.Items[Resizer.ItemIndex], CropForm.ResizeWidthUpDown.Position, CropForm.ResizeHeightUpDown.Position, FloatToStrF(Form1.BicubicB, ffFixed, 18, 3), FloatToStrF(Form1.BicubicC, ffFixed, 18, 3)]));
  end;

  SL.Append('');

  if Form1.PostResize >= 0 then
  begin
    SL.Append(Format('Preset%d()', [Form1.PostResize]));
    SL.Append('');
  end;

  AddCustomLists(SL, omPostResize, IsDecimated);

  Result := SL;
end;

procedure TForm2.SaveAvsClick(Sender: TObject);
begin
  Form1.SaveFreezeFrames1Click(nil);
end;

procedure TForm2.updatepresetClick(Sender: TObject);
var
  TempIndex: Integer;
begin
  if ComboBox2.ItemIndex >= 0 then
  begin
    TempIndex := ComboBox2.ItemIndex;
    TPreset(ComboBox2.Items.Objects[TempIndex]).Chain := Memo1.Text;
    ComboBox2.Items[TempIndex] := ComboBox2.Text;
    ComboBox2.ItemIndex := TempIndex;
    PresetListBox.Items.Assign(ComboBox2.Items);
  end;
end;

procedure TForm2.ComboBox2Change(Sender: TObject);
begin
  if ComboBox2.ItemIndex > -1 then
    Memo1.Text := TPreset(combobox2.Items.Objects[combobox2.ItemIndex]).chain;
end;

procedure TForm2.newpresetClick(Sender: TObject);
var
  PresetName: string;
begin
  PresetName := InputBox('Preset', 'Name:', '');
  if (PresetName <> '') then
    AddPreset(PresetName, -1, Memo1.Text);
end;

procedure TForm2.deletepresetClick(Sender: TObject);
var
  TIdx, Counter: Integer;
begin
  if ComboBox2.ItemIndex >= 0 then
  begin
    for counter := 0 to SectionCount - 1 do
      if Sections[Counter].Preset = TPreset(combobox2.Items.Objects[combobox2.ItemIndex]).id then
      begin
        MessageDlg('Can''t delete. Preset in use.', mtError, [mbok], 0);
        Exit;
      end;

    if (form1.pretelecide = TPreset(combobox2.Items.Objects[combobox2.ItemIndex]).id) or (form1.posttelecide = TPreset(combobox2.Items.Objects[combobox2.ItemIndex]).id) or (form1.predecimate = TPreset(combobox2.Items.Objects[combobox2.ItemIndex]).id) or (form1.postdecimate = TPreset(combobox2.Items.Objects[combobox2.ItemIndex]).id) or (form1.postresize = TPreset(combobox2.Items.Objects[combobox2.ItemIndex]).id) then
    begin
      MessageDlg('Can''t delete. Preset in use.', mtError, [mbok], 0);
      Exit;
    end;

    if (TPreset(combobox2.Items.Objects[combobox2.ItemIndex]).id = 0) then
    begin
      MessageDlg('Can''t delete the Default preset.', mtError, [mbok], 0);
      Exit;
    end;

    if MessageDlg('Are you sure you want to delete the preset "' + ComboBox2.Items[ComboBox2.ItemIndex] + '"?', mtConfirmation, [mbyes, mbno], 0) = mryes then
    begin
      tidx := IfThen(combobox2.ItemIndex > 0, combobox2.ItemIndex - 1, 0);
      TPreset(combobox2.Items.Objects[combobox2.ItemIndex]).Free;
      ComboBox2.Items.Delete(combobox2.ItemIndex);
      combobox2.ItemIndex := tidx;
      ComboBox2Change(self);
      PresetListBox.Items.Assign(ComboBox2.Items);
    end;
  end;
end;

procedure TForm2.BicubicBChange(Sender: TObject);
begin
  try
    Form1.BicubicB := StrToFloat(BicubicB.Text);
    BicubicB.Color := clWindow;
  except
    BicubicB.Color := clYellow;
  end;
end;

procedure TForm2.BicubicCChange(Sender: TObject);
begin
  try
    Form1.BicubicC := StrToFloat(BicubicC.Text);
    BicubicC.Color := clWindow;
  except
    BicubicC.Color := clYellow;
  end;
end;

procedure TForm2.PresetListBoxDblClick(Sender: TObject);
begin
  ComboBox2.ItemIndex := PresetListBox.ItemIndex;
  ComboBox2Change(Self);
  PageControl1.ActivePage := TabSheet1;
end;

procedure TForm2.FreezeframesDblClick(Sender: TObject);
begin
  if Freezeframes.ItemIndex > -1 then
    form1.TrackBar1.Position := TfreezeInfo(Freezeframes.Items.Objects[Freezeframes.ItemIndex]).startframe;
end;

procedure TForm2.NodecimatesDblClick(Sender: TObject);
begin
  if Nodecimates.ItemIndex > -1 then
    form1.TrackBar1.Position := TdecimateInfo(Nodecimates.Items.Objects[Nodecimates.ItemIndex]).startframe;

end;

procedure TForm2.savevfrClick(Sender: TObject);
begin
  form1.SaveVFR1Click(self);
end;

procedure TForm2.deleteffClick(Sender: TObject);
var counter: integer;
begin
  for counter := Freezeframes.Count - 1 downto 0 do
  begin
    if Freezeframes.Selected[counter] then
    begin
      Freezeframes.Items.Objects[counter].Free;
      Freezeframes.Items.Delete(counter);
    end;
  end;
  form1.DrawFrame;
end;

procedure TForm2.deletendClick(Sender: TObject);
var
  counter, c2: integer;
begin
  for counter := Nodecimates.Count - 1 downto 0 do
  begin
    if Nodecimates.Selected[counter] then
    begin
      for c2 := TDecimateInfo(Nodecimates.Items.Objects[counter]).startframe to TDecimateInfo(Nodecimates.Items.Objects[counter]).endframe do
        FrameArray[c2].Decimate := false;

      Nodecimates.Items.Objects[counter].Free;
      Nodecimates.Items.Delete(counter);
    end;
  end;
  Form1.UpdateFrameMap;
  form1.DrawFrame;
end;

procedure TForm2.FormDestroy(Sender: TObject);
var
  Counter: Integer;
begin
  for Counter := 0 to PresetCount - 1 do
    Presets[Counter].Free;

  for Counter := 0 to SectionCount - 1 do
    Sections[Counter].Free;
end;

procedure TForm2.PretelecideClick(Sender: TObject);
begin
  if ComboBox2.ItemIndex >= 0 then
  begin
    form1.pretelecide := TPreset(ComboBox2.Items.Objects[ComboBox2.ItemIndex]).id;
    LabeledEdit3.Text := ComboBox2.Items[ComboBox2.ItemIndex];
  end;
end;

procedure TForm2.PosttelecideClick(Sender: TObject);
begin
  if ComboBox2.ItemIndex >= 0 then
  begin
    form1.posttelecide := TPreset(ComboBox2.Items.Objects[ComboBox2.ItemIndex]).id;
    LabeledEdit4.Text := ComboBox2.Items[ComboBox2.ItemIndex];
  end;
end;

procedure TForm2.PredecimateClick(Sender: TObject);
begin
  if ComboBox2.ItemIndex >= 0 then
  begin
    form1.predecimate := TPreset(ComboBox2.Items.Objects[ComboBox2.ItemIndex]).id;
    LabeledEdit5.Text := ComboBox2.Items[ComboBox2.ItemIndex];
  end;
end;

procedure TForm2.PostdecimateClick(Sender: TObject);
begin
  if ComboBox2.ItemIndex >= 0 then
  begin
    form1.postdecimate := TPreset(ComboBox2.Items.Objects[ComboBox2.ItemIndex]).id;
    LabeledEdit6.Text := ComboBox2.Items[ComboBox2.ItemIndex];
  end;
end;

procedure TForm2.PostresizeClick(Sender: TObject);
begin
  if ComboBox2.ItemIndex >= 0 then
  begin
    form1.postresize := TPreset(ComboBox2.Items.Objects[ComboBox2.ItemIndex]).id;
    LabeledEdit7.Text := ComboBox2.Items[ComboBox2.ItemIndex];
  end;
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
  form1.pretelecide := -1;
  LabeledEdit3.Text := '';
end;

procedure TForm2.Button4Click(Sender: TObject);
begin
  form1.posttelecide := -1;
  LabeledEdit4.Text := '';
end;

procedure TForm2.Button9Click(Sender: TObject);
begin
  form1.predecimate := -1;
  LabeledEdit5.Text := '';
end;

procedure TForm2.Button10Click(Sender: TObject);
begin
  form1.postdecimate := -1;
  LabeledEdit6.Text := '';
end;

procedure TForm2.Button11Click(Sender: TObject);
begin
  form1.postresize := -1;
  LabeledEdit7.Text := '';
end;

procedure TForm2.PreviewAvsClick(Sender: TObject);
var
  TFList: TStringList;
begin
  Form3.Memo1.Lines.Clear;
  TFList := MakeOverrideList(nil, False);
  Form3.Memo1.Lines.Assign(TFList);
  TFList.Free;

  Form3.Memo1.Lines.Insert(0, PluginListToScript(GetRequiredPlugins(True, Form3.Memo1.Lines.Text, PluginPath, SE), PluginPath));

  Form3.Show;
end;

procedure TForm2.vprevClick(Sender: TObject);
var
  vt: Integer;
  counter: Integer;
  vc: Double;
begin
  vt := Form1.VThreshold;

  for counter := Form1.TrackBar1.Position - 1 downto 0 do
  begin

    case vfindmethod.ItemIndex of
      0: vc := Form1.GetVMetric(counter);
      1: vc := Form1.GetVMetric(counter) - Form1.GetVMetric(counter - 1);
      2: begin
          if Form1.GetVMetric(counter - 1) = 0 then
            vc := 79999
          else
            vc := (Form1.GetVMetric(counter) / Form1.GetVMetric(counter - 1) - 1) * 100;

        end;
      3: vc := min(Form1.GetVMetric(counter) - Form1.GetVMetric(counter - 1), Form1.GetVMetric(counter) - Form1.GetVMetric(counter + 1));
    else
      begin

        if Form1.GetVMetric(counter - 1) = 0 then
          vc := 79999
        else
          vc := (Form1.GetVMetric(counter) / Form1.GetVMetric(counter - 1) - 1) * 100;

        if Form1.GetVMetric(counter + 1) <> 0 then
          vc := min((Form1.GetVMetric(counter) / Form1.GetVMetric(counter + 1) - 1) * 100, vc);

      end;
    end;


    if vt < vc then
    begin
      form1.TrackBar1.Position := counter; form1.Update;
      Break;
    end;

  end;
end;

procedure TForm2.vnextClick(Sender: TObject);
var vt: integer;
  counter: integer;
  vc: Double;
begin

  vt := Form1.VThreshold;

  for counter := Form1.TrackBar1.Position + 1 to form1.TrackBar1.Max do
  begin

    case vfindmethod.ItemIndex of
      0: vc := Form1.GetVMetric(counter);
      1: vc := Form1.GetVMetric(counter) - Form1.GetVMetric(counter - 1);
      2: begin
          if Form1.GetVMetric(counter - 1) = 0 then
            vc := 79999
          else
            vc := (Form1.GetVMetric(counter) / Form1.GetVMetric(counter - 1) - 1) * 100;

        end;
      3: vc := min(Form1.GetVMetric(counter) - Form1.GetVMetric(counter - 1), Form1.GetVMetric(counter) - Form1.GetVMetric(counter + 1));
    else
      begin

        if Form1.GetVMetric(counter - 1) = 0 then
          vc := 79999
        else
          vc := (Form1.GetVMetric(counter) / Form1.GetVMetric(counter - 1) - 1) * 100;

        if Form1.GetVMetric(counter + 1) <> 0 then
          vc := min((Form1.GetVMetric(counter) / Form1.GetVMetric(counter + 1) - 1) * 100, vc);

      end;
    end;


    if vt < vc then
    begin
      form1.TrackBar1.Position := counter; form1.Update;
      Break;
    end;


  end;

end;

procedure TForm2.vlimitChange(Sender: TObject);
begin
  try
    if StrToInt(vlimit.Text) < 0 then abort;
    Form1.VThreshold := StrToInt(vlimit.Text);
    vlimit.Color := clWindow;
  except
    vlimit.Color := clYellow;
  end;
end;

procedure TForm2.vfindmethodClick(Sender: TObject);
begin
  case vfindmethod.ItemIndex of
    0, 1, 3: vlimit.EditLabel.Caption := 'Value (V)';
  else
    vlimit.EditLabel.Caption := 'Value (%)';
  end;
end;

procedure TForm2.vfrthresholdsClick(Sender: TObject);
begin
  SetVariablePrompt(stlt, 1);
  SetVariablePrompt(sthd, 1);
end;

procedure TForm2.findvfr1Click(Sender: TObject);
var counter, c2: integer;
  mi: integer;
begin
  for counter := form1.TrackBar1.Position + 1 to form1.TrackBar1.Max - stlt do
  begin
    mi := FrameArray[counter].DMetric;
    for c2 := 1 to stlt do
      mi := Min(mi, FrameArray[counter + c2].DMetric);

    if (sthd < mi) then
    begin
      Form1.TrackBar1.Position := counter;
      Break;
    end;
  end;
end;

procedure TForm2.findvfr2Click(Sender: TObject);
var counter, c2: integer;
  mi, ma: integer;
begin
  for counter := form1.TrackBar1.Position + 1 to form1.TrackBar1.Max - stlt do
  begin
    mi := FrameArray[counter].Match;
    for c2 := 1 to stlt do
      mi := Min(mi, FrameArray[counter + c2].Match);

    ma := FrameArray[counter].Match;
    for c2 := 1 to stlt do
      ma := Max(ma, FrameArray[counter + c2].Match);

    if ma = mi then
    begin
      Form1.TrackBar1.Position := counter;
      exit;
    end;
  end;
end;

procedure TForm2.Button12Click(Sender: TObject);
var counter: integer;
begin
  for counter := 0 to ComboBox2.Items.Count - 1 do
  begin
    if TPreset(ComboBox2.Items.Objects[counter]).id = form1.pretelecide then
    begin
      ComboBox2.ItemIndex := counter;
      ComboBox2Change(self);
      PageControl1.ActivePage := TabSheet1;
      break;
    end;
  end;
end;

procedure TForm2.Button13Click(Sender: TObject);
var counter: integer;
begin
  for counter := 0 to ComboBox2.Items.Count - 1 do
  begin
    if TPreset(ComboBox2.Items.Objects[counter]).id = form1.posttelecide then
    begin
      ComboBox2.ItemIndex := counter;
      ComboBox2Change(self);
      PageControl1.ActivePage := TabSheet1;
      break;
    end;
  end;
end;

procedure TForm2.Button14Click(Sender: TObject);
var counter: integer;
begin
  for counter := 0 to ComboBox2.Items.Count - 1 do
  begin
    if TPreset(ComboBox2.Items.Objects[counter]).id = form1.predecimate then
    begin
      ComboBox2.ItemIndex := counter;
      ComboBox2Change(self);
      PageControl1.ActivePage := TabSheet1;
      break;
    end;
  end;
end;

procedure TForm2.Button15Click(Sender: TObject);
var counter: integer;
begin
  for counter := 0 to ComboBox2.Items.Count - 1 do
  begin
    if TPreset(ComboBox2.Items.Objects[counter]).id = form1.postdecimate then
    begin
      ComboBox2.ItemIndex := counter;
      ComboBox2Change(self);
      PageControl1.ActivePage := TabSheet1;
      break;
    end;
  end;
end;

procedure TForm2.Button16Click(Sender: TObject);
var counter: integer;
begin
  for counter := 0 to ComboBox2.Items.Count - 1 do
  begin
    if TPreset(ComboBox2.Items.Objects[counter]).id = form1.postresize then
    begin
      ComboBox2.ItemIndex := counter;
      ComboBox2Change(self);
      PageControl1.ActivePage := TabSheet1;
      break;
    end;
  end;
end;

procedure TForm2.TabSheet3Show(Sender: TObject);
begin
  vlimit.Text := inttostr(Form1.VThreshold);
end;

procedure TForm2.SaveLiteAvsClick(Sender: TObject);
var
  SL: TStringList;
  TempExt: string;
begin
  if SaveDialog1.Execute then
  begin
    TempExt := AnsiLowerCase(ExtractFileExt(Form1.SourceFile));

    SL := TStringList.Create;

    try
      if TempExt = '.d2v' then
      begin
        SL.Append(MPEG2DecName + '_Mpeg2Source("' + Form1.SourceFile + '")');
        if not AnsiSameText('DGDecode', MPEG2DecName) and SE.FunctionExists('SetPlanarLegacyAlignment') then
          SL.Append('SetPlanarLegacyAlignment(true)');
      end
      else if TempExt = '.dga' then
        SL.Append('AVCSource("' + Form1.SourceFile + '")')
      else if TempExt = '.avs' then
        SL.Append('Import("' + Form1.SourceFile + '")')
      else
        SL.Append('AviSource("' + Form1.SourceFile + '")');

      SL.Append(Form1.MakeCutLine);
      SL.Append('');

      if Form1.OpenMode in MatchingProjects then
      begin
        if PostProcessor.ItemIndex = 5 then
          SL.Append('YattaPreMatchClip = last');

        SL.Append('FieldHint(ovr="' + ChangeFileExt(Form1.SaveDialog5.FileName, FieldExt) + '")');

        with SL do
          case PostProcessor.ItemIndex of
            0, 1: Append(Format('FieldDeinterlace(blend=%s,dthreshold=%d)', [IfThen(PostProcessor.ItemIndex = 1, 'false', 'true'), Form1.PostThreshold]));
            2: Append(Format('TelecideHints(sangnom(order=%d,aa=%d))', [Form11.RadioGroup1.ItemIndex xor 1, Form1.PostThreshold]));
            3: Append(Format('KernelDeint(order=%d,sharp=%s,twoway=%s,threshold=%d)', [Form11.RadioGroup1.ItemIndex, IfThen(not SharpKernel.Checked, 'false', 'true'), IfThen(not TwoWayKernel.Checked, 'false', 'true'), Form1.PostThreshold]));
            4: Append(Format('LeakKernelDeint(order=%d,sharp=%s,twoway=%s,threshold=%d)', [Form11.RadioGroup1.ItemIndex, IfThen(not SharpKernel.Checked, 'false', 'true'), IfThen(not TwoWayKernel.Checked, 'false', 'true'), Form1.PostThreshold]));
            5: Append(Format('TDeint(clip2=YattaPreMatchClip,hints=true,order=%d,type=%d,sharp=%s)', [Form11.RadioGroup1.ItemIndex, Form1.PostThreshold, IfThen(not SharpKernel.Checked, 'false', 'true')]));
          end;

        SL.Append('');
      end;

      SL.AddStrings(Freezeframes.Items);

      SL.Insert(0, PluginListToScript(GetRequiredPlugins(True, SL.Text, PluginPath, SE), PluginPath));

      // cutting was done here

      SL.SaveToFile(SaveDialog1.FileName);

    finally
      SL.Free
    end;

    Form1.SaveAllOverrides1Click(nil);
  end;
end;

procedure TForm2.PostProcessorClick(Sender: TObject);
begin
  case PostProcessor.ItemIndex of
    0..1: PostThreshold.EditLabel.Caption := 'DThresh';
    2: PostThreshold.EditLabel.Caption := 'AA';
    3..4: PostThreshold.EditLabel.Caption := 'Threshold';
    5: PostThreshold.EditLabel.Caption := 'Type';
  end;

  SharpKernel.Visible := PostProcessor.ItemIndex in [3..5];
  TwoWayKernel.Visible := PostProcessor.ItemIndex in [3..4];
  PostThreshold.Visible := PostProcessor.ItemIndex in [0..5];
end;

procedure TForm2.PostThresholdChange(Sender: TObject);
begin
  try
    Form1.PostThreshold := StrToInt(PostThreshold.Text);
    PostThreshold.Color := clWindow;
  except
    PostThreshold.Color := clYellow;
  end;
end;

procedure TForm2.TabSheet7Show(Sender: TObject);
begin
  PostThreshold.Text := IntToStr(Form1.PostThreshold);
end;

procedure TForm2.ResizeOnClick(Sender: TObject);
begin
  CropForm.Anamorphic.Checked := not ResizeOn.Checked;
end;

procedure TForm2.ResizerClick(Sender: TObject);
begin
  BicubicB.Visible := Resizer.ItemIndex = 2;
  BicubicC.Visible := Resizer.ItemIndex = 2;
end;

procedure TForm2.Button19Click(Sender: TObject);
begin
  case ComboBox3.ItemIndex of
    0: PretelecideClick(nil);
    1: PosttelecideClick(nil);
    2: PredecimateClick(nil);
    3: PostdecimateClick(nil);
    4: PostresizeClick(nil);
  end;
end;

procedure TForm2.ImportFromProject(Filename: string);
var
  pf: TMemIniFile;
  sl, subdiv: tstringlist;
  Counter: integer;
  hh: string;
  mr: TModalResult;
  I: Integer;
  StarCount: Integer;
  CurrentLine: string;
begin
    pf := nil;

    PresetImportForm.Presets.Clear;
    PresetImportForm.PresetContent.Clear;

    sl := tstringlist.Create;
    subdiv := TStringList.Create;

    try
      pf := TMemIniFile.Create(Filename);

      pf.ReadSectionValues('PRESETS', sl);

      if sl.Count = 0 then
        Abort;

      subdiv.Delimiter := ',';

      for counter := 0 to sl.Count - 1 do
      begin
        StarCount := 0;
        CurrentLine := sl[counter];
        for I := 1 to Length(CurrentLine) do
          if CurrentLine[I] = '¤' then
            Inc(StarCount);
        if StarCount >= 3 then
          subdiv.Delimiter := '¤';

        subdiv.DelimitedText := CurrentLine;

        hh := AnsiDequotedStrY(AnsiReplaceStr(subdiv[3], '^', #13#10), '"');
        PresetImportForm.Presets.AddItem(AnsiDequotedStrY(subdiv[2], '"'), TPreset.Create(strtoint(subdiv[0]), hh));
      end;

      mr := PresetImportForm.ShowModal;

      if mr = mrall then
        PresetImportForm.Presets.SelectAll;

      if (mr = mrok) or (mr = mrall) then
      begin
        for Counter := 0 to PresetImportForm.Presets.Count - 1 do
        begin
          if PresetImportForm.Presets.Selected[Counter] then
            with PresetImportForm.Presets.Items do
              with Objects[Counter] as TPreset do
                AddPreset(Strings[Counter], -1, Chain);
        end;

        if PresetImportForm.CustomLists.Checked then
          GetTypeCustomLists(pf, True);

        if PresetImportForm.AVSSettings.Checked then
          GetType0SharedValues(pf);
      end;

    finally
      subdiv.Free;
      sl.Free;
      pf.Free;

      for Counter := 0 to PresetImportForm.Presets.Count - 1 do
        PresetImportForm.Presets.Items.Objects[Counter].Free;
    end;
end;

procedure TForm2.Button3Click(Sender: TObject);
begin
  if OpenDialog3.Execute then
    ImportFromProject(OpenDialog3.FileName);
end;

procedure TForm2.Button20Click(Sender: TObject);
var
  PName: string;
  TIdx: Integer;
begin
  if ComboBox2.ItemIndex >= 0 then
  begin
    PName := InputBox('Preset', 'Name:', ComboBox2.Items[ComboBox2.ItemIndex]);
    if (PName <> '') and not AnsiContainsStr(PName, '"') then
    begin
      TIdx := ComboBox2.ItemIndex;

      ComboBox2.Items[ComboBox2.ItemIndex] := PName;
      PresetListBox.Items.Assign(ComboBox2.Items);

      UpdateSectionList;

      ComboBox2.ItemIndex := tidx;

      // Update special preset names after renaming
      LabeledEdit3.Text := GetPresetName(Form1.PreTelecide);
      LabeledEdit4.Text := GetPresetName(Form1.PostTelecide);
      LabeledEdit5.Text := GetPresetName(Form1.PreDecimate);
      LabeledEdit6.Text := GetPresetName(Form1.PostDecimate);
      LabeledEdit7.Text := GetPresetName(Form1.PostResize);

      Form1.DrawFrame;
    end;
  end;
end;

{ TCustomList }

constructor TCustomList.Create(Name: string; Processing: string; Output: string; OutputMethod: TOutputMethod);
begin
  inherited Create(True);

  FName := Name;
  FProcessing := Processing;
  FOutput := Output;
  FOutputMethod := OutputMethod;
end;

procedure TForm2.CustomRangeListsClick(Sender: TObject);
var
  Counter: Integer;
begin
  if SelectedCustomList <> nil then
    with SelectedCustomList do
    begin
      Edit1.Text := Processing;
      Edit2.Enabled := OutputMethod = omFile;
      Edit2.Text := Output;

      // Very clever code, will break
      for Counter := 8 to 13 do
        PopupMenu2.Items[Counter].Checked := Integer(OutputMethod) = Counter - 8;

      CustomRanges.Count := Count;
    end;
    Form1.DrawFrame;
end;

procedure TForm2.CustomRangesData(Control: TWinControl; Index: Integer;
  var Data: string);
begin
  if SelectedCustomList <> nil then
    Data := Format('%d %d', [SelectedCustomList[Index].StartFrame, SelectedCustomList[Index].EndFrame])
  else
    Data := 'Internal error';
end;

function TCustomList.GetItem(Index: Integer): TCustomRange;
begin
  Result := inherited GetItem(Index) as TCustomRange;
end;

procedure TCustomList.SetItem(Index: Integer; Item: TCustomRange);
begin
  inherited SetItem(Index, Item);
end;

{ TCustomRange }

constructor TCustomRange.Create(StartFrame, EndFrame: Integer);
begin
  FStartFrame := StartFrame;
  FEndFrame := EndFrame;
end;

procedure TForm2.PopupMenu1Popup(Sender: TObject);
var
  Counter: Integer;
begin
  MoveTo1.Clear;
  CopyTo1.Clear;

  for Counter := 0 to CustomRangeLists.Count - 1 do
  begin
    moveto1.Add(TMenuItem.Create(MoveTo1));
    with Moveto1.Items[Counter] do
    begin
      Caption := CustomRangeLists.Items[counter];
      OnClick := mclick1Click;
    end;

    CopyTo1.Add(TMenuItem.Create(CopyTo1));
    with CopyTo1.Items[Counter] do
    begin
      Caption := CustomRangeLists.Items[Counter];
      OnClick := cclick1Click;
    end;
  end;
end;

procedure TForm2.Delete1Click(Sender: TObject);
var Counter: Integer;
begin
  if SelectedCustomList <> nil then
  begin
    for Counter := CustomRanges.Count - 1 downto 0 do
      if CustomRanges.Selected[Counter] then
        SelectedCustomList.Delete(Counter);

    CustomRanges.Count := SelectedCustomList.Count;
  end;
end;

function CustomListSort(Item1, Item2: Pointer): Integer;
var
  I1, I2: TCustomRange;
begin
  I1 := TCustomRange(Item1);
  I2 := TCustomRange(Item2);

  if I1.StartFrame > I2.StartFrame then
    Result := 1
  else if I1.StartFrame < I2.StartFrame then
    Result := -1
  else if I1.EndFrame > I2.EndFrame then
    Result := 1
  else if I1.EndFrame < I2.EndFrame then
    Result := -1
  else
    Result := 0;
end;

procedure TForm2.mclick1Click(Sender: TObject);
var
  Dest: TCustomList;
  Counter: Integer;
begin
  if SelectedCustomList <> nil then
  begin
    Dest := CustomRangeLists.Items.Objects[MoveTo1.IndexOf(TMenuItem(Sender))] as TCustomList;

    for Counter := CustomRanges.Count - 1 downto 0 do
      if CustomRanges.Selected[Counter] then
        Dest.Add(SelectedCustomList.Extract(SelectedCustomList[Counter]));

    Dest.Sort(CustomListSort);

    CustomRanges.Count := SelectedCustomList.Count;
  end;
end;

procedure TForm2.cclick1Click(Sender: TObject);
var Dest: TCustomList;
  Counter: Integer;
begin
  if SelectedCustomList <> nil then
  begin
    Dest := TCustomList(CustomRangeLists.Items.Objects[CopyTo1.IndexOf(TMenuItem(Sender))]);

    for Counter := CustomRanges.Count - 1 downto 0 do
      if CustomRanges.Selected[Counter] then
        with SelectedCustomList[Counter] do
          Dest.Add(TCustomRange.Create(StartFrame, EndFrame));

    Dest.Sort(CustomListSort);
  end;
end;

procedure TForm2.CustomRangesDblClick(Sender: TObject);
begin
  if SelectedCustomList <> nil then
    Form1.TrackBar1.Position := SelectedCustomList[CustomRanges.ItemIndex].StartFrame;
end;

procedure TForm2.Edit1Change(Sender: TObject);
begin
  if SelectedCustomList <> nil then
    SelectedCustomList.Processing := Edit1.Text;
end;

procedure TForm2.Edit2Change(Sender: TObject);
begin
  if SelectedCustomList <> nil then
    SelectedCustomList.Output := Edit2.Text;
end;

procedure TForm2.ExternalFile1Click(Sender: TObject);
begin
  if SelectedCustomList <> nil then
  begin
    with TMenuItem(sender) do
      if Checked then
        SelectedCustomList.OutputMethod := TOutputMethod(Tag)
      else
        SelectedCustomList.OutputMethod := omNone;

    Edit2.Enabled := SelectedCustomList.OutputMethod = omFile;
  end;
end;

procedure TForm2.MoveUp1Click(Sender: TObject);
begin
  if CustomRangeLists.ItemIndex >= 1 then
    CustomRangeLists.Items.Exchange(CustomRangeLists.ItemIndex, CustomRangeLists.ItemIndex - 1);
end;

procedure TForm2.MoveDown1Click(Sender: TObject);
begin
  if (CustomRangeLists.ItemIndex >= 0) and (CustomRangeLists.ItemIndex < CustomRangeLists.Count - 1) then
    CustomRangeLists.Items.Exchange(CustomRangeLists.ItemIndex, CustomRangeLists.ItemIndex + 1);
end;

procedure TForm2.Save1Click(Sender: TObject);
var
  c2: integer;
  sl: TStringList;
begin
  if SelectedCustomList <> nil then
  begin

    with SelectedCustomList do
    begin
      if OutputMethod <> omFile then
      begin
        MessageDlg('Only custom lists of the file type may be explicitly saved.', mtError, [mbOK], 0);
        Exit;
      end
      else if output = '' then
      begin
        MessageDlg('No filename specified.', mtError, [mbOK], 0);
        Exit;
      end;

      sl := TStringList.Create;

      for c2 := 0 to count - 1 do
        with Items[c2] do
          sl.Append(AnsiReplaceStr(AnsiReplaceStr(processing, '%s', inttostr(startframe)), '%e', inttostr(endframe)));

      try
        sl.SaveToFile(output);
      finally
        sl.Free;
      end;

    end;
  end;
end;

procedure TForm2.SectionListBoxKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  Counter: Integer;
  Pid: Byte;
begin
  if IsKeyEvent(kGenericDelete, Key) then
    Button6Click(nil)
  else if IsKeyEvent(kSelectSWithSameP, Key) and (PresetListBox.ItemIndex >= 0) then
  begin
    Pid := Presets[PresetListBox.ItemIndex].Id;
    for Counter := 0 to SectionCount - 1 do
      SectionListBox.Selected[Counter] := Sections[Counter].Preset = Pid;
  end;
end;

procedure TForm2.FreezeframesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if IsKeyEvent(kGenericDelete, Key) then
    deleteffClick(nil);
end;

procedure TForm2.NodecimatesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if IsKeyEvent(kGenericDelete, Key) then
    deletendClick(nil);
end;

procedure TForm2.SectionListBoxMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  InCounter: Integer;
begin
  if not (ssDouble in Shift) then
  begin

    for InCounter := 0 to PresetCount - 1 do
    begin
      if Presets[InCounter].Id = Sections[SectionListBox.Itemindex].Preset then
      begin
        PresetListBox.ItemIndex := InCounter;
        Break;
      end;
    end;

    Exclude(Shift, ssLeft);
    Exclude(Shift, ssRight);
    Exclude(Shift, ssMiddle);

    if Form11.CheckBox7.Checked and (Shift = []) then
      ListBox1Change(nil);
  end;
end;

procedure TForm2.Empty1Click(Sender: TObject);
var n: string;
begin
  n := InputBox('New List', 'Name:', '');
  if n <> '' then
    CustomRangeLists.AddItem(n, TCustomList.Create(n));
end;

procedure TForm2.FromVMetric1Click(Sender: TObject);
var
  l, c: Integer;
  counter, nl: Integer;
  n: string;
  entry: TCustomList;
begin
  n := InputBox('New List', 'Name:', '');
  if n = '' then
    Exit;

  l := StrToInt(InputBox('VMetric', 'Upper limit?', '50'));
  c := StrToInt(InputBox('Length', 'Consecutive frames?', '5'));

  entry := TCustomList.Create(n);
  CustomRangeLists.AddItem(n, entry);

  nl := 0;

  for counter := 0 to form1.TrackBar1.Max do
    if FrameArray[counter].VMetric[FrameArray[counter].Match] > l then
      Inc(nl)
    else
    begin
      if (nl > c) then
        entry.Add(TCustomRange.Create(counter - nl, counter - 1));

      nl := 0;
    end;
end;

procedure TForm2.CopytoSections1Click(Sender: TObject);
var counter: integer;
begin
  if SelectedCustomList <> nil then
    with SelectedCustomList do
      for counter := 0 to Count - 1 do
        if CustomRanges.Selected[counter] then
          with Items[counter] as TCustomRange do
          begin
            addSection(startframe, sectioninfo(startframe).preset, startframe / form1.fps);
            addSection(endframe + 1, sectioninfo(endframe + 1).preset, (endframe + 1) / form1.fps);
          end;
end;

procedure TForm2.AddPreset(Name: string; Id: Integer;
  Chain: string);
var
  Counter: Integer;
  ByteCounter: Byte;
  ByteSet: set of Byte;
begin
  case Id of
    0..255:
      begin
        for Counter := 0 to ComboBox2.Items.Count - 1 do
          if TPreset(ComboBox2.Items.Objects[Counter]).Id = Id then
            raise EPresetError.Create('Duplicate preset id');

        ComboBox2.ItemIndex := ComboBox2.Items.AddObject(Name, TPreset.Create(Id, Chain));
        PresetListBox.Items.Assign(ComboBox2.Items);
        Exit;
      end;
  else
    begin
      for Counter := 0 to ComboBox2.Items.Count - 1 do
        Include(ByteSet, TPreset(ComboBox2.Items.Objects[Counter]).Id);

      for ByteCounter := 0 to 255 do
        if not (ByteCounter in ByteSet) then
        begin
          ComboBox2.ItemIndex := ComboBox2.Items.AddObject(Name, TPreset.Create(ByteCounter, Chain));
          PresetListBox.Items.Assign(ComboBox2.Items);
          Exit;
        end;

      MessageDlg('No free slots. Only 256 presets allowed.', mtError, [mbOK], 0);
    end;
  end;
end;

procedure TForm2.DeleteList1Click(Sender: TObject);
begin
  if CustomRangeLists.ItemIndex >= 0 then
  begin
    CustomRangeLists.Items.Objects[CustomRangeLists.ItemIndex].Free;
    CustomRangeLists.Items.Delete(CustomRangeLists.ItemIndex);
    CustomRanges.Count := 0;
  end;
end;

function TForm2.AddNoDecimate(StartFrame, EndFrame: Integer): TNoDecAddRejections;
var
  Counter: Integer;
  StartFr, EndFr, InsertPos: Integer;
  NDS: TDecimateInfo;
begin
  if not Form11.Decimation.Checked then
  begin
    Result := [ndarFeatureDisabled];
    Exit;
  end;

  StartFr := 0;
  EndFr := 0;

  for Counter := StartFrame downto 0 do
    if Counter mod Form1.Distance = 0 then
    begin
      StartFr := Counter;
      Break;
    end;

  for Counter := EndFrame to Form1.TrackBar1.Max do
    if ((Counter + 1) mod Form1.Distance = 0) or (Counter = Form1.TrackBar1.Max) then
    begin
      EndFr := Counter;
      Break;
    end;

  Result := CanAddNoDecimate(StartFr, EndFr);
  if Result = [] then
  begin
    InsertPos := findnodecimatepos(StartFr);
    Nodecimates.Items.Insert(InsertPos, Format('NoDecimate(%d,%d,%s)', [StartFr, EndFr, IfThen(Form1.OpenMode in MatchingProjects, FloatToStr(Form1.FPS), 'Freedecimate')]));
    Nodecimates.Items.Objects[InsertPos] := TDecimateInfo.Create(StartFr, EndFr);
    Nodecimates.ItemIndex := InsertPos;

    if Form11.CheckBox6.Checked then
      for Counter := StartFrame to EndFrame do
        FrameArray[Counter].Match := 1;

    if Form1.NoDecimateassections1.Checked then
    begin
      AddSection(StartFrame, SectionInfo(StartFrame).Preset, StartFrame / Form1.FPS);
      AddSection(EndFrame + 1, Form2.SectionInfo(EndFrame + 1).Preset, (EndFrame + 1) / Form1.FPS);
      Form1.RedrawFrame;
    end;

    Form1.UpdateFrameMap;
    Result := [];
  end
  else if Result = [ndarNoDecimateRangeExists] then
  begin
    NDS := GetNoDecimateRange(StartFrame);
    if (NDS <> nil) and (CanAddNoDecimate(NDS.EndFrame + 1, EndFr) = []) then
    begin
      NDS.FEndFrame := EndFr;
      Nodecimates.Items[Nodecimates.Items.IndexOfObject(NDS)] := Format('NoDecimate(%d,%d,%s)', [NDS.StartFrame, NDS.EndFrame, IfThen(Form1.OpenMode in MatchingProjects, FloatToStr(Form1.FPS), 'Freedecimate')]);
      Form1.UpdateFrameMap;
      Result := [];
    end;
  end;
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
  ComboBox2Change(nil);
end;

function TForm2.GetSection(Index: Integer): TSectionEntry;
begin
  Result := (SectionListBox.Items.Objects[Index] as TSectionEntry);
end;

function TForm2.GetPresetCount: Integer;
begin
  Result := PresetListBox.Items.Count;
end;

function TForm2.GetPresetProperty(Index: Integer): TPreset;
begin
  Result := (PresetListBox.Items.Objects[Index] as TPreset);
end;

function TForm2.GetSectionCount: Integer;
begin
  Result := SectionListBox.Items.Count;
end;

procedure TForm2.DeleteSection(Index: Integer);
begin
  Sections[Index].Free;
  SectionListBox.Items.Delete(Index);
end;

procedure TForm2.UpdateSectionList;
var
  Counter: Integer;
  AOS: TBooleanDynArray;
begin
  SetLength(AOS, SectionCount);

  for Counter := 0 to SectionCount - 1 do
    AOS[counter] := SectionListBox.Selected[Counter];

  for Counter := 0 to SectionCount - 1 do
    with Sections[Counter] do
      SectionListBox.Items[Counter] := Format('#%s (%s) %s', [ZeroPad(IntToStr(StartFrame), PadSize), TimeInSecondsToStr(StartFrame / Form1.FPS), GetPresetName(Preset)]);

  for Counter := 0 to SectionCount - 1 do
    SectionListBox.Selected[Counter] := AOS[Counter];
end;

function TForm2.GetSectionSelected(Index: Integer): Boolean;
begin
  Result := SectionListBox.Selected[Index];
end;

function TForm2.GetSelectedCustomList: TCustomList;
begin
  Result := nil;
  if CustomRangeLists.ItemIndex >= 0 then
    Result := CustomRangeLists.Items.Objects[CustomRangeLists.ItemIndex] as TCustomList;
end;

end.

