unit FunctionHooking;

interface

uses
  SysUtils, Windows, Types, Classes, AnsiStrings, System.SyncObjs;

const
  MH_OK = 0;

type
  TOutputDebugStringAFunc = procedure(Str: PAnsiChar); stdcall;
  TOutputDebugStringWFunc = procedure(Str: PWideChar); stdcall;

procedure HookDbgOut(AOutput: TStrings);
procedure SetDbgOutput(AOutput: TStrings);

function MH_Initialize: Integer; stdcall; external 'minhook.dll';
function MH_CreateHook(pTarget: Pointer; pDetour: Pointer; var pOriginal: Pointer): Integer; stdcall; external 'minhook.dll';
function MH_CreateHookApiEx(pszModule: PWideChar; pszProcName: PAnsiChar; pDetour: Pointer; var pOriginal: Pointer; var pTarget: Pointer): Integer; stdcall; external 'minhook.dll';
function MH_EnableHook(pTarget: Pointer): Integer; stdcall; external 'minhook.dll';

implementation

var
  g_origOutputDebugStringA: TOutputDebugStringAFunc = nil;
  g_origOutputDebugStringW: TOutputDebugStringWFunc = nil;
  OutputDebugStringLock: TCriticalSection = nil;
  Output: TStrings = nil;

procedure SetDbgOutput(AOutput: TStrings);
begin
  Output := AOutput;
end;

procedure MyOutputDebugStringA(Str: PAnsiChar); stdcall;
begin
  if Output <> nil then
  begin
    OutputDebugStringLock.Acquire;
    Output.Append(Str);
    OutputDebugStringLock.Release;
  end;
  g_origOutputDebugStringA(Str);
end;

procedure MyOutputDebugStringW(Str: PWideChar); stdcall;
begin
  if Output <> nil then
  begin
    OutputDebugStringLock.Acquire;
    Output.Append(Str);
    OutputDebugStringLock.Release;
  end;
  g_origOutputDebugStringW(Str);
end;

procedure HookDbgOut(AOutput: TStrings);
var
  Target: Pointer;
begin
  if OutputDebugStringLock = nil then
    OutputDebugStringLock := TCriticalSection.Create;
  MH_Initialize;
  MH_CreateHookApiEx('kernel32', 'OutputDebugStringA', @MyOutputDebugStringA, @g_origOutputDebugStringA, Target);
  MH_EnableHook(Target);
  MH_CreateHookApiEx('kernel32', 'OutputDebugStringW', @MyOutputDebugStringW, @g_origOutputDebugStringW, Target);
  MH_EnableHook(Target);
  Output := AOutput;
end;

end.
