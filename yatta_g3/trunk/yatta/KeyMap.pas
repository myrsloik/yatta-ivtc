unit keymap;

interface

uses Windows, Classes, Menus, keydefaults;

type
  TKeyRecord = record
    Name: string;
    KeyC: TShortCut;
  end;

  TKeyIterator = procedure(const EventId: TKeyEvent; var KeyRec: TKeyRecord);

procedure InitKeyMap;
procedure UpdateMapping(const EventId: TKeyEvent; const Key: Word; const ShiftState: TShiftState); overload;
procedure UpdateMapping(const EventId: TKeyEvent; const Key: Word; const ShiftState: TShiftState; const DisplayName: string); overload;
procedure ClearMappings;

procedure ForEachKeyMapping(const Iterator: TKeyIterator);
function IsKeyEvent(const EventId: TKeyEvent; const CharCode: Word): Boolean;
function IsKeyPressed(const EventId: TKeyEvent): Boolean;

function VKDown(const Key: Integer): Boolean;

const
  NoKeyShortcut = 0;

implementation

uses SysUtils;

var
  KeyMappings: array of TKeyRecord;

procedure ForEachKeyMapping(const Iterator: TKeyIterator);
var
  Counter: Integer;
begin
  for Counter := 0 to Length(KeyMappings) - 1 do
    Iterator(TKeyEvent(Counter), KeyMappings[Counter]);
end;

procedure InitKeyMap;
begin
  SetLength(KeyMappings, Ord(High(TKeyEvent)) + 1);
  ClearMappings;
end;

function VKDown(const Key: Integer): Boolean;
begin
  Result := (GetKeyState(Key) and $80) <> 0;
end;

function GetSS(): TShiftState;
begin
  Result := [];
  if VKDown(VK_CONTROL) then
    Include(Result, ssCtrl);
  if VKDown(VK_MENU) then
    Include(Result, ssAlt);
  if VKDown(VK_SHIFT) then
    Include(Result, ssShift);
end;

function IsKeyPressed(const EventId: TKeyEvent): Boolean;
var
  Key: Word;
  SS: TShiftState;
begin
  ShortCutToKey(KeyMappings[Ord(EventId)].KeyC, Key, SS);
  Result := VKDown(Key) and (SS = GetSS());
end;

function IsKeyEvent(const EventId: TKeyEvent; const CharCode: Word): Boolean;
var
  Key: Word;
  SS: TShiftState;
begin
  ShortCutToKey(KeyMappings[Ord(EventId)].KeyC, Key, SS);
  Result := (Key = CharCode) and (SS = GetSS());
end;

procedure UpdateMapping(const EventId: TKeyEvent; const Key: Word; const ShiftState: TShiftState);
begin
  KeyMappings[Ord(EventId)].KeyC := ShortCut(Key, ShiftState);
end;

procedure UpdateMapping(const EventId: TKeyEvent; const Key: Word; const ShiftState: TShiftState; const DisplayName: string);
begin
  UpdateMapping(EventId, Key, ShiftState);
  KeyMappings[Ord(EventId)].Name := DisplayName;
end;

procedure ClearMappings;
var
  Counter: Integer;
begin
  for Counter := 0 to Length(KeyMappings) - 1 do
    KeyMappings[Counter].KeyC := NoKeyShortcut;
end;

end.
