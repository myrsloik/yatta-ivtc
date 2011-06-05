unit FunctionHooking;

interface

uses
  SysUtils, Windows, Types, Classes;

type
  TDWORDArray = array[0..10000] of DWORD;
  PDWORDArray = ^TDWORDArray;

  TWORDArray = array[0..10000] of WORD;
  PWORDArray = ^TWORDArray;

  PIMAGE_EXPORT_DIRECTORY = ^IMAGE_EXPORT_DIRECTORY;
  PIMAGE_DOS_HEADER = ^IMAGE_DOS_HEADER;
  PIMAGE_NT_HEADERS = ^IMAGE_NT_HEADERS;

  TOutputDebugStringAFunc = procedure(Str: PAnsiChar); stdcall;
  TOutputDebugStringWFunc = procedure(Str: PWideChar); stdcall;

procedure HookDbgOut(AOutput: TStrings);
procedure SetDbgOutput(AOutput: TStrings);

implementation

const
  IMAGE_NT_OPTIONAL_HDR32_MAGIC = $10B;

var
  g_origOutputDebugStringA: TOutputDebugStringAFunc = nil;
  g_origOutputDebugStringW: TOutputDebugStringWFunc = nil;
  Output: TStrings = nil;

procedure SetDbgOutput(AOutput: TStrings);
begin
  Output := AOutput;
end;

procedure WriteModName(Ptr: Pointer);
var
  MemInfo: MEMORY_BASIC_INFORMATION;
  FileName: array[0..MAX_PATH] of AnsiChar;
  FNEnd: PAnsiChar;
begin
  if VirtualQuery(Ptr, MemInfo, SizeOf(MemInfo)) < SizeOf(MemInfo) then
    Exit;

  if GetModuleFileNameA(HMODULE(MemInfo.AllocationBase), FileName, SizeOf(FileName)) = 0 then
    Exit;

  FNEnd := FileName + StrLen(FileName);

  while (FNEnd > FileName) and (FNEnd[-1] <> '/') and (FNEnd[-1] <> '\') do
    Dec(FNEnd);
end;

procedure MyOutputDebugStringA(Str: PAnsiChar); stdcall;
begin
  if Output <> nil then
    Output.Append(Str);
  g_origOutputDebugStringA(Str);
end;

procedure MyOutputDebugStringW(Str: PWideChar); stdcall;
begin
  if Output <> nil then
    Output.Append(Str);
  g_origOutputDebugStringW(Str);
end;

function FindName(Name: PAnsiChar; Base: PAnsiChar; Names: PDWORDArray; Count: Cardinal): Integer;
var
  I, J: Integer;
  Mid, CMP: Integer;
begin
  I := 0;
  J := Count - 1;

  while (I <= J) do
  begin
    Mid := (I + J) shr 1;
    CMP := StrComp(Name, (Base + Names[Mid]));
    if CMP = 0 then
    begin
      Result := Mid;
      Exit;
    end
    else if CMP < 0 then
      J := Mid - 1
    else
      I := Mid + 1;
  end;

  Result := -1;
end;

procedure ReplaceFunc(Name: PAnsiChar; NewFunc: Pointer; var OldFunc: Pointer;
  Base: PAnsiChar;
  EDir: PIMAGE_EXPORT_DIRECTORY;
  ESize: DWORD;
  var JmpTmp: PByte);
var
  Pos: Integer;
  Ent: PDWORD;
  OldProt: DWORD;
begin
  Pos := FindName(Name, Base, PDWORDArray(Base + DWORD(EDir^.AddressOfNames)), EDir.NumberOfNames);
  if Pos < 0 then
    Exit;

  Ent := PDWORD(Base + DWORD(EDir^.AddressOfFunctions) +
    SizeOf(DWORD) * PWORDArray(Base + DWORD(EDir^.AddressOfNameOrdinals))[Pos]);

  if (PAnsiChar(Ent^) >= PAnsiChar(EDir)) and (PAnsiChar(Ent^) < PAnsiChar(EDir) + ESize) then
    Exit; // this is a forward to another dll, we don't support it

  if not VirtualProtect(Ent, SizeOf(DWORD), PAGE_EXECUTE_WRITECOPY, OldProt) then
    Exit;

  OldFunc := (Base + Ent^);
  JmpTmp^ := $E9;
  Inc(JmpTmp, 1);
  PDWORD(JmpTmp)^ := DWORD(PAnsiChar(NewFunc) - JmpTmp - 4);
  Ent^ := JmpTmp - Base - 1;
  Inc(JmpTmp, 7);
end;

procedure HookDbgOut(AOutput: TStrings);
var
  Base: PAnsiChar;
  MemInfo: MEMORY_BASIC_INFORMATION;
  DosHdr: PIMAGE_DOS_HEADER;
  NTHdr: PIMAGE_NT_HEADERS;
  EDir: PIMAGE_EXPORT_DIRECTORY;
  JmpTmp: PByte;
  IOHDDOffset: Cardinal;
begin
  Output := AOutput;

  //fixme, no normal offset available?
  asm
    mov IOHDDOffset, OFFSET IMAGE_OPTIONAL_HEADER.DataDirectory[IMAGE_DIRECTORY_ENTRY_EXPORT+1]
  end;

  Base := PAnsiChar(GetModuleHandle('kernel32.dll'));
  if Base = nil then
    Exit;

  if (VirtualQuery(Base, MemInfo, SizeOf(MemInfo)) < SizeOf(MemInfo)) or (MemInfo.State <> MEM_COMMIT) then
    Exit;

  DosHdr := PIMAGE_DOS_HEADER(Base);
  NTHdr := PIMAGE_NT_HEADERS(Base + DosHdr^._lfanew);
  if (NTHdr^.FileHeader.SizeOfOptionalHeader < IOHDDOffset) or
    (NTHdr^.OptionalHeader.Magic <> IMAGE_NT_OPTIONAL_HDR32_MAGIC) then // we only support 32-bit for now
    Exit;

  EDir := PIMAGE_EXPORT_DIRECTORY(Base + NTHdr^.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_EXPORT].VirtualAddress);
  if EDir^.NumberOfNames = 0 then
    Exit;

  JmpTmp := VirtualAlloc(nil, 16, MEM_COMMIT or MEM_TOP_DOWN, PAGE_EXECUTE_READWRITE);
  if JmpTmp = nil then
    Exit;

  ReplaceFunc('OutputDebugStringA', @MyOutputDebugStringA, @g_origOutputDebugStringA, Base, EDir, NTHdr^.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_EXPORT].Size, JmpTmp);
  ReplaceFunc('OutputDebugStringW', @MyOutputDebugStringW, @g_origOutputDebugStringW, Base, EDir, NTHdr^.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_EXPORT].Size, JmpTmp);
end;

end.
