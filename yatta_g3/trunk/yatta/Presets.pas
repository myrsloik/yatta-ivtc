unit Presets;

interface

uses sysutils, contnrs, classes, bitsext;

type
  TPreset = class(TObject)
  public
    name: string;
    chain: string;
    id: Cardinal;
    constructor Create(name_: string; id_: Cardinal; chain_: string);
  end;

  TPresets = class(TObjectList)
  private
    Used: TBitField;
  public
    function GetItem(Index: Integer): TPreset;
    procedure SetItem(Index: Integer; APreset: TPreset);
    property Items[Index: Integer]: TPreset read GetItem write SetItem; default;
    function AddNew(name: string; id: Cardinal; chain: string): Boolean;
    function AddNewNoId(name: string; chain: string): Cardinal;
    function DeletePreset(Preset: TPreset): Boolean;
    function GetPresetById(id: Cardinal): TPreset;
    function GetPresetNameById(id: Cardinal): string;
    constructor Create();
    destructor Destroy(); override;
  end;

implementation

destructor TPresets.Destroy();
begin
  used.Free;
end;

constructor TPresets.Create();
begin
  Used := TBitField.Create;
end;

function TPresets.AddNew(name: string; id: cardinal; chain: string): boolean;
begin
  assert(not used[id], 'Id not unique');

  Add(TPreset.Create(name, id, chain));

  Result := true;
end;

function TPresets.DeletePreset(Preset: TPreset): Boolean;
begin
  Result := -1 <> Remove(Preset);
  if Result then
    used[preset.id] := false;
end;

function TPresets.GetItem(Index: Integer): TPreset;
begin
  Result := TPreset(inherited GetItem(Index));
end;

procedure TPresets.SetItem(Index: Integer; APreset: TPreset);
begin
  inherited SetItem(Index, APreset);
end;

function TPresets.GetPresetNameById(id: cardinal): string;
var res: TPreset;
begin
  res := GetPresetById(id);

  if res <> nil then
    Result := res.name
  else
    Result := '[Empty Preset]'
end;

function TPresets.GetPresetById(id: Cardinal): TPreset;
var counter: integer;
begin
  Result := nil;
  for counter := 0 to Count - 1 do
  begin
    if TPreset(Items[counter]).id = id then
    begin
      Result := Items[counter];
      break;
    end;
  end;
end;

constructor TPreset.Create(name_: string; id_: Cardinal; chain_: string);
begin
  name := name_;
  id := id_;
  chain := chain_;
end;

function TPresets.AddNewNoId(name, chain: string): Cardinal;
begin
  Result := Used.GetFirstUnset;
  Add(TPreset.Create(name, Result, chain));
end;

end.
