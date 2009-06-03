unit MarkerLists;

interface

uses SysUtils, Types, Classes, Contnrs, Math, ViewListBox, BitsExt;

type
  TMarkerList = class;
  TMarker = class;
  TLayerBaseList = class;
  TLayerList = class;

  TLayerType = (ltSectionList, ltRangeList, ltDelimiter);

// Presets
  TPreset = class(TObject)
  private
    FName: string;
    FChain: string;
    FId: Integer;
    procedure SetName(Name: string);
    procedure SetChain(Chain: string);
  public
    property Name: string read FName write SetName;
    property Chain: string read FChain write SetChain;
    property Id: Integer read FId;
    constructor Create(Name: string; Chain: string; Id: Integer);
  end;

  TPresetList = class(TObjectList)
  private
    FView: TViewListBox;
    FUsed: TBitsExt;
    procedure SetView(V: TViewListBox);
    function GetItem(Index: Integer): TPreset;
  public
    property Items[Index: Integer]: TPreset read GetItem; default;
    function Add(Name: string; Chain: string; Id: Integer = -1): Integer;
    procedure Delete(Index: Integer);
    function GetPresetById(Id: Integer): TPreset;
    function GetPresetNameById(Id: Integer): string;
    constructor Create;
    destructor Destroy; override;

    property View: TViewListBox read FView write SetView;
  end;

// Markers
  TMarker = class(TObject)
  private
    FStartFrame: Integer;
    FOwner: TMarkerList;
  public
    constructor Create(const StartFrame: Integer; const Owner: TMarkerList);
    property Owner: TMarkerList read FOwner;
    property StartFrame: Integer read FStartFrame;
  end;

  TTimeMarker = class(TMarker)
  private
    FTime: Integer;
    procedure SetTime(Time: Integer);
  public
    constructor Create(const StartFrame, Time: Integer; const Owner: TMarkerList);
    property Time: Integer read FTime write SetTime;
  end;

  TDecimationMarker = class(TMarker)
  private
    FM: Integer;
    FN: Integer;
  public
    constructor Create(const StartFrame, M, N: Integer; const Owner: TMarkerList);
    property M: Integer read FM;
    property N: Integer read FN;
  end;

  TSection = class(TMarker)
  private
    FPreset: Integer;
    procedure SetPreset(Preset: Integer);
  public
    constructor Create(const StartFrame, Preset: Integer; const Owner: TMarkerList);
    property Preset: Integer read FPreset write SetPreset;
  end;

  TRange = class(TMarker)
  private
    FEndFrame: Integer;
  public
    constructor Create(const StartFrame, EndFrame: Integer; const Owner: TMarkerList);
    property EndFrame: Integer read FEndFrame;
  end;

  TFreezeFrameMarker = class(TMarker)
  private
    FEndFrame: Integer;
    FReplaceFrame: Integer;
  public
    constructor Create(const StartFrame, EndFrame, ReplaceFrame: Integer; const Owner: TMarkerList);
    property EndFrame: Integer read FEndFrame;
    property ReplaceFrame: Integer read FReplaceFrame;
  end;

// MarkerLists
  TMarkerList = class(TObjectList)
  protected
    FView: TViewListBox;
    procedure SetView(V: TViewListBox);
    function FindMarkerPos(Frame: Integer): Integer;
    function GetItem(Index: Integer): TMarker;
  public
    function GetByFrame(Frame: Integer): TMarker;
    function GetNext(Marker: TMarker): TMarker;
    function Add(const StartFrame: Integer): Integer;
    procedure Exchange(Index1, Index2: Integer);
    procedure Delete(Index: Integer);
    constructor Create;
    destructor Destroy; override;

    property View: TViewListBox read FView write SetView;
    property Items[Index: Integer]: TMarker read GetItem; default;
  end;

  TTimeMarkerList = class(TMarkerList)
  private
    function GetItem(Index: Integer): TTimeMarker;
  public
    function GetByFrame(Frame: Integer): TTimeMarker;
    function Add(const StartFrame, Time: Integer): Integer;
    function GetNext(Marker: TTimeMarker): TTimeMarker;
    property Items[Index: Integer]: TTimeMarker read GetItem; default;
  end;

  TDecimationMarkerList = class(TMarkerList)
  private
    function GetItem(Index: Integer): TDecimationMarker;
  public
    function GetByFrame(Frame: Integer): TDecimationMarker;
    function Add(const StartFrame, M, N: Integer): Integer;
    function GetNext(Marker: TDecimationMarker): TDecimationMarker;
    property Items[Index: Integer]: TDecimationMarker read GetItem; default;
  end;

  TFreezeFrameMarkerList = class(TMarkerList)
  public
    function GetByFrame(Frame: Integer): TFreezeFrameMarker;
    function Add(const StartFrame, EndFrame, ReplaceFrame: Integer): Integer;
    function GetItem(Index: Integer): TFreezeFrameMarker;
    function GetNext(Marker: TFreezeFrameMarker): TFreezeFrameMarker;
    property Items[Index: Integer]: TFreezeFrameMarker read GetItem; default;
  end;

// Layers
  TLayerBaseList = class(TMarkerList)
  private
    FName: string;
    FOwner: TLayerList;
    procedure SetName(Name: string);
  public
    constructor Create(Name: string; Owner: TLayerList);
    property Name: string read FName write SetName;
    property Owner: TLayerList read FOwner;
  end;

  TSectionList = class(TLayerBaseList)
  public
    function GetByFrame(Frame: Integer): TSection;
    function Add(const StartFrame, Preset: Integer): Integer;
    function GetItem(Index: Integer): TSection;
    function GetNext(Marker: TSection): TSection;
    property Items[Index: Integer]: TSection read GetItem; default;
  end;

  TRangeList = class(TLayerBaseList)
  private
    FProcessing: string;
    function FindMarkerPos(Frame: Integer): Integer;
    procedure SetProcessing(P: string);
  public
    function GetByFrame(Frame: Integer): TRange;
    function Add(const StartFrame, EndFrame: Integer): Integer;
    function GetItem(Index: Integer): TRange;
    function GetNext(Marker: TRange): TRange;
    property Items[Index: Integer]: TRange read GetItem; default;
    property Processing: string read FProcessing write SetProcessing;
  end;

  TListDelimiter = class(TLayerBaseList)
  end;

// Layerlist
  TLayerList = class(TObjectList)
  private
    FDelimiter: TListDelimiter;
    FView: TViewListBox;
    procedure SetView(V: TViewListBox);
  public
    constructor Create;

    function Add(Name: string; ltype: TLayerType): Integer;
    function GetItem(Index: Integer): TLayerBaseList;
    procedure Delete(Index: Integer);
    procedure Exchange(Index1, Index2: Integer);
    procedure ClearEvents(LayerType: TLayerType);

    property Items[Index: Integer]: TLayerBaseList read GetItem; default;
    property View: TViewListBox read FView write SetView;
  end;

implementation

{ TMarker }

constructor TMarker.Create(const StartFrame: Integer; const Owner: TMarkerList);
begin
  FStartFrame := StartFrame;
  FOwner := Owner;
end;

{ TRange }

constructor TRange.Create(const StartFrame, EndFrame: Integer; const Owner: TMarkerList);
begin
  inherited Create(StartFrame, Owner);
  FEndFrame := EndFrame;
end;

{ TSection }

constructor TSection.Create(const StartFrame, Preset: Integer; const Owner: TMarkerList);
begin
  inherited Create(StartFrame, Owner);
  FPreset := Preset;
end;

procedure TSection.SetPreset(Preset: Integer);
begin
  FPreset := Preset;
  if Assigned(Owner.FView) then
    Owner.FView.Invalidate;
end;

{ TTimeMarker }

constructor TTimeMarker.Create(const StartFrame, Time: Integer; const Owner: TMarkerList);
begin
  inherited Create(StartFrame, Owner);
  FTime := Time;
end;

procedure TTimeMarker.SetTime(Time: Integer);
begin
  FTime := Time;
  if Assigned(Owner.FView) then
    Owner.FView.Invalidate;
end;

{ TDecimationMarker }

constructor TDecimationMarker.Create(const StartFrame, M, N: Integer; const Owner: TMarkerList);
begin
  inherited Create(StartFrame, Owner);
  FM := M;
  FN := N;
end;

{ TFreezeFrameMarker }

constructor TFreezeFrameMarker.Create(const StartFrame, EndFrame,
  ReplaceFrame: Integer; const Owner: TMarkerList);
begin
  inherited Create(StartFrame, Owner);
  FEndFrame := EndFrame;
  FReplaceFrame := ReplaceFrame;
end;

{ TMarkerList }

function TMarkerList.FindMarkerPos(Frame: Integer): Integer;
var
  I: Integer;
  SFrame: Integer;
begin
  Result := 0;

  for I := Count - 1 downto 0 do
  begin
    SFrame := TMarker(Items[I]).StartFrame;

    if (SFrame <= Frame) then
    begin
      if SFrame = Frame then
        Result := -1
      else
        Result := I + 1;
      Exit;
    end;
  end;
end;

function TMarkerList.GetNext(Marker: TMarker): TMarker;
var
  MPos: Integer;
begin
  MPos := IndexOf(Marker);

  if (MPos = -1) or (MPos = Count - 1) then
    Result := nil
  else
    Result := TMarker(Items[MPos + 1]);
end;

function TMarkerList.GetByFrame(Frame: Integer): TMarker;
var
  I: Integer;
  Entry: TMarker;
begin
  Result := nil;

  for I := Count - 1 downto 0 do
  begin
    Entry := TMarker(Items[I]);

    if (Entry.StartFrame <= Frame) then
    begin
      Result := Entry;
      Break;
    end;
  end;
end;

function TMarkerList.Add(const StartFrame: Integer): Integer;
begin
  Result := FindMarkerPos(StartFrame);

  if Result >= 0 then
  begin
    inherited Insert(Result, TMarker.Create(StartFrame, Self));

    if Assigned(FView) then
      FView.Count := FView.Count + 1;
  end;
end;

procedure TMarkerList.Delete(Index: Integer);
var
  Selected: TBooleanDynArray;
  I: Integer;
begin
  inherited Delete(Index);

  if Assigned(FView) then
  begin
    SetLength(Selected, FView.Count - 1);

    for I := 0 to Length(Selected) - 1 do
      Selected[I] := FView.Selected[I + IfThen(Index <= I, 1, 0)];

    FView.Count := FView.Count - 1;

    for I := 0 to Length(Selected) - 1 do
      FView.Selected[I] := Selected[I];
  end;
end;

procedure TMarkerList.Exchange(Index1, Index2: Integer);
begin
  inherited Exchange(Index1, Index2);

  if Assigned(FView) then
    FView.Invalidate;
end;

constructor TMarkerList.Create;
begin
  inherited Create(True);
  FView := nil;
end;

destructor TMarkerList.Destroy;
begin
  View := nil;
  inherited;
end;

procedure TMarkerList.SetView(V: TViewListBox);
begin
  if Assigned(FView) then
    FView.DataSource := nil;
  FView := V;

  if V <> nil then
    V.DataSource := Self;
end;

function TMarkerList.GetItem(Index: Integer): TMarker;
begin
  Result := inherited Items[Index] as TMarker;
end;

{ TTimeMarkerList }

function TTimeMarkerList.Add(const StartFrame, Time: Integer): Integer;
begin
  Result := FindMarkerPos(StartFrame);
  if Result >= 0 then
  begin
    Insert(Result, TTimeMarker.Create(StartFrame, Time, Self));

    if Assigned(FView) then
      FView.Count := FView.Count + 1;
  end;

end;

function TTimeMarkerList.GetByFrame(Frame: Integer): TTimeMarker;
begin
  Result := TTimeMarker(inherited GetByFrame(Frame));
end;

function TTimeMarkerList.GetItem(Index: Integer): TTimeMarker;
begin
  Result := TTimeMarker(inherited GetItem(Index));
end;

function TTimeMarkerList.GetNext(Marker: TTimeMarker): TTimeMarker;
begin
  Result := TTimeMarker(inherited GetNext(Marker));
end;

{ TDecimationMarkerList }

function TDecimationMarkerList.Add(const StartFrame, M, N: Integer): Integer;
begin
  Result := FindMarkerPos(StartFrame);

  Assert((M < N) and (M >= 0), 'Invalid decimation added');

  if Result >= 0 then
  begin
    if M = 0 then
      Insert(Result, TDecimationMarker.Create(StartFrame, 0, 1, Self))
    else
      Insert(Result, TDecimationMarker.Create(StartFrame, M, N, Self));

    if Assigned(FView) then
      FView.Count := FView.Count + 1;
  end;
end;

function TDecimationMarkerList.GetByFrame(
  Frame: Integer): TDecimationMarker;
begin
  Result := TDecimationMarker(inherited GetByFrame(Frame));
end;

function TDecimationMarkerList.GetItem(Index: Integer): TDecimationMarker;
begin
  Result := TDecimationMarker(inherited GetItem(Index));
end;

function TDecimationMarkerList.GetNext(
  Marker: TDecimationMarker): TDecimationMarker;
begin
  Result := TDecimationMarker(inherited GetNext(Marker));
end;

{ TLayerBaseList }

constructor TLayerBaseList.Create(Name: string; Owner: TLayerList);
begin
  inherited Create;
  FName := Name;
  FOwner := Owner;
end;

procedure TLayerBaseList.SetName(Name: string);
begin
  FName := Name;

  if Assigned(FOwner.FView) then
    FOwner.FView.Invalidate;
end;

{ TSectionList }

function TSectionList.Add(const StartFrame, Preset: Integer): Integer;
begin
  Result := FindMarkerPos(StartFrame);
  if Result >= 0 then
  begin
    Insert(Result, TSection.Create(StartFrame, Preset, Self));

    if Assigned(FView) then
    begin
      FView.Count := FView.Count + 1;
      FView.Selected[Result] := True;
    end;
  end;
end;

function TSectionList.GetByFrame(Frame: Integer): TSection;
begin
  Result := TSection(inherited GetByFrame(Frame));
end;

function TSectionList.GetItem(Index: Integer): TSection;
begin
  Result := TSection(inherited GetItem(Index));
end;

function TSectionList.GetNext(Marker: TSection): TSection;
begin
  Result := TSection(inherited GetNext(Marker));
end;

{ TRangeList }

function TRangeList.Add(const StartFrame, EndFrame: Integer): Integer;
begin
  Result := FindMarkerPos(StartFrame);
  if Result >= 0 then
  begin
    Insert(Result, TRange.Create(StartFrame, EndFrame, Self));

    if Assigned(FView) then
      FView.Count := FView.Count + 1;
  end;
end;

function TRangeList.GetByFrame(Frame: Integer): TRange;
var
  I: Integer;
  Entry: TRange;
begin
  Result := nil;
  for I := 0 to Count - 1 do
  begin
    Entry := TRange(Items[I]);

    if InRange(Frame, Entry.StartFrame, Entry.EndFrame) then
    begin
      Result := Entry;
      Break; ;
    end;
  end;
end;

function TRangeList.GetItem(Index: Integer): TRange;
begin
  Result := TRange(inherited GetItem(Index));
end;

function TRangeList.GetNext(Marker: TRange): TRange;
begin
  Result := TRange(inherited GetNext(Marker));
end;

function TRangeList.FindMarkerPos(Frame: Integer): Integer;
var
  I: Integer;
begin
  Result := 0;

  for I := Count - 1 downto 0 do
  begin
    if Items[I].StartFrame <= Frame then
    begin
      Result := I + 1;
      Exit;
    end;
  end;
end;

procedure TRangeList.SetProcessing(P: string);
begin
  FProcessing := P;

  if Assigned(Owner.FView) then
    Owner.FView.Invalidate;
end;

{ TLayerList }

function TLayerList.Add(Name: string; ltype: TLayerType): Integer;
begin
  case ltype of
    ltSectionList:
      Result := inherited Add(TSectionList.Create(Name, Self));
    ltRangeList:
      Result := inherited Add(TRangeList.Create(Name, Self));
    ltDelimiter:
      begin
        Move(IndexOf(FDelimiter), Count - 1);
        Result := Count - 1;
      end;
  else
    Result := -1;
  end;

  if (Result <> -1) and Assigned(FView) then
    FView.Count := FView.Count + 1;
end;

procedure TLayerList.ClearEvents(LayerType: TLayerType);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    if (Items[I] is TRangeList) and (LayerType = ltRangeList)
      or (Items[I] is TSectionList) and (LayerType = ltSectionList) then
      Items[I].View := nil;
end;

constructor TLayerList.Create;
begin
  inherited Create(True);
  FDelimiter := TListDelimiter.Create('<this should only be visible in project files>', Self);
  inherited Add(FDelimiter);

  FView := nil;
end;

procedure TLayerList.Delete(Index: Integer);
begin
  if not (Items[Index] is TListDelimiter) then
  begin
    inherited Delete(Index);

    if Assigned(FView) then
      FView.Count := FView.Count - 1;
  end;
end;

procedure TLayerList.Exchange(Index1, Index2: Integer);
begin
  inherited Exchange(Index1, Index2);

  if Assigned(FView) then
    FView.Invalidate;
end;

function TLayerList.GetItem(Index: Integer): TLayerBaseList;
begin
  Result := TLayerBaseList(inherited GetItem(Index));
end;

procedure TLayerList.SetView(V: TViewListBox);
begin
  if Assigned(FView) then
    FView.DataSource := nil;
  FView := V;

  if V <> nil then
    V.DataSource := Self;
end;

{ TFreezeFrameMarkerList }

function TFreezeFrameMarkerList.Add(const StartFrame, EndFrame,
  ReplaceFrame: Integer): Integer;
begin
  if StartFrame > EndFrame then
    Result := -1
  else
    Result := FindMarkerPos(StartFrame);

  if Result >= 0 then
  begin
    Insert(Result, TFreezeFrameMarker.Create(StartFrame, EndFrame, ReplaceFrame, Self));

    if Assigned(FView) then
      FView.Count := FView.Count + 1;
  end;
end;

function TFreezeFrameMarkerList.GetByFrame(
  Frame: Integer): TFreezeFrameMarker;
begin
  Result := TFreezeFrameMarker(inherited GetByFrame(Frame));

  if (Result <> nil) and (Result.EndFrame < Frame) then
    Result := nil;
end;

function TFreezeFrameMarkerList.GetItem(
  Index: Integer): TFreezeFrameMarker;
begin
  Result := TFreezeFrameMarker(inherited GetItem(Index));
end;

function TFreezeFrameMarkerList.GetNext(
  Marker: TFreezeFrameMarker): TFreezeFrameMarker;
begin
  Result := TFreezeFrameMarker(inherited GetNext(Marker));
end;

{ TPresetList }

destructor TPresetList.Destroy;
begin
  FUsed.Free;
  View := nil;
  inherited;
end;

constructor TPresetList.Create;
begin
  inherited Create(True);
  FUsed := TBitsExt.Create;
  FView := nil;
end;

function TPresetList.Add(Name: string; Chain: string; Id: Integer = -1): Integer;
begin
  if Id = -1 then
    Id := FUsed.OpenBit;

  Assert(not FUsed[id], 'Id not unique');

  FUsed[id] := True;

  Result := inherited Add(TPreset.Create(Name, Chain, Id));

  if Assigned(FView) then
    FView.Count := FView.Count + 1;
end;

procedure TPresetList.Delete(Index: Integer);
begin
  FUsed[Items[Index].Id] := False;
  inherited Delete(Index);

  if Assigned(FView) then
    FView.Count := FView.Count - 1;
end;

function TPresetList.GetItem(Index: Integer): TPreset;
begin
  Result := TPreset(inherited GetItem(Index));
end;

function TPresetList.GetPresetNameById(Id: Integer): string;
var Res: TPreset;
begin
  Res := GetPresetById(Id);

  if Res <> nil then
    Result := Res.Name
  else
    Result := Format('[Undefined Id: %d]', [Id])
end;

function TPresetList.GetPresetById(Id: Integer): TPreset;
var
  I: Integer;
begin
  Result := nil;

  if (Id < 0) or not FUsed[Id] then
    Exit;

  for I := 0 to Count - 1 do
  begin
    if TPreset(Items[I]).Id = Id then
    begin
      Result := Items[I];
      Break;
    end;
  end;
end;

procedure TPresetList.SetView(V: TViewListBox);
begin
  if Assigned(FView) then
    FView.DataSource := nil;
  FView := V;

  if V <> nil then
    V.DataSource := Self;
end;


{ TPreset }

constructor TPreset.Create(Name: string; Chain: string; Id: Integer);
begin
  FName := Name;
  FId := Id;
  FChain := Chain;
end;

procedure TPreset.SetChain(Chain: string);
begin
  FChain := Chain;
end;

procedure TPreset.SetName(Name: string);
begin
  FName := Name;
end;

end.
