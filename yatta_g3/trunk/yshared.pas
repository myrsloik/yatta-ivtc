unit yshared;

interface

uses SysUtils, Math, Dialogs, Controls, ConvUtils, StdConvs, Classes, StrUtils;

type
  TAnsiCharSet = set of AnsiChar;

function TimeInSecondsToStr(Time: Double): string;
function TimeInMillisecondsToStr(Time: Double): string;
function StrToTimeInMilliseconds(Time: string): Integer;
function StrToTimeInMillisecondsDef(Time: string; Default: Integer): Integer;

function ConfirmDialog(WarningText: string = 'This operation can''t be undone.'#13#10'Continue?'): Boolean;

function AnsiDequotedStrY(const S: string; const AQuote: Char): string;

function ZeroPad(S: string; PadSize: Integer): string;
procedure SetVariablePrompt(var Result: Integer; AType: Integer);

function GetNextToken(const S: string; var Offset: Integer; const Separators: TAnsiCharSet = [' ', #13, #10]): string;
function GetToken(const S: string; const Token: Integer; const Separators: TAnsiCharSet = [' ', #13, #10]): string;

const
  YattaExt = '.yap';
  AvsExt = '.avs';
  FieldExt = '.fh.txt';
  DecExt = '.dec.txt';
  TimeExt = '.vfr.txt';

implementation

function GetNextToken(const S: string; var Offset: Integer; const Separators: TAnsiCharSet): string;
var
  TokenStart: Integer;
  TokenEnd: Integer;
  Counter: Integer;
begin
  Assert(Offset > 0);

  TokenStart := -1;
  TokenEnd := -1;
  Result := '';

  for Counter := Offset to Length(S) do
  begin
    if (TokenStart = -1) and not (S[Counter] in Separators) then
      TokenStart := Counter
    else if (TokenStart <> -1) and (S[Counter] in Separators) then
    begin
      TokenEnd := Counter;
      Break;
    end;
  end;

  if TokenStart <> -1 then
  begin
    if TokenEnd = -1 then
      TokenEnd := Length(S) + 1;
    Offset := TokenEnd;
    Result := MidStr(S, TokenStart, TokenEnd - TokenStart);
  end;
end;

function GetToken(const S: string; const Token: Integer; const Separators: TAnsiCharSet): string;
var
  Counter: Integer;
  Offset: Integer;
begin
  Offset := 1;

  for Counter := 0 to Token do
    Result := GetNextToken(S, Offset, Separators);
end;

procedure SetVariablePrompt(var Result: Integer; AType: Integer);
var S, Si: string;
begin
  S := IntToStr(Result);

  case AType of
    0: Si := 'VThresh';
    1: Si := 'DMetric Threshold';
    2: Si := 'Previous Freeze Distance';
    3: Si := 'Next Freeze Distance';
    4: Si := 'Offset';
    5: Si := 'FreezeFrame Threshold';
    6: Si := 'Edge';
    7: Si := 'Framelimit';
  end;

  if InputQuery(Si, 'Limit:', S) then
  try
    Result := StrToInt(S);
  except
    Abort;
  end
  else
    Abort;
end;

function ZeroPad(S: string; PadSize: Integer): string;
begin
  Result := StringOfChar('0', PadSize - Length(S)) + S;
end;

function AnsiDequotedStrY(const S: string; const AQuote: Char): string;
var l: integer;
begin
  l := Length(S);
  if (l < 2) or (S[1] <> AQuote) or (S[l] <> AQuote) then
    Result := S
  else
    Result := AnsiReplaceStr(AnsiMidStr(S, 2, l - 2), AQuote + AQuote, AQuote);
end;

function ConfirmDialog(WarningText: string): Boolean;
begin
  Result := MessageDlg(WarningText, mtWarning, mbOKCancel, 0) = mrOk;
end;

function StrToTimeInMilliseconds(Time: string): Integer;
begin
  Result := Floor(ConvertTo(StrToTime(Time), tuMilliSeconds));
end;

function StrToTimeInMillisecondsDef(Time: string; Default: Integer): Integer;
begin
  Result := Floor(ConvertTo(StrToTimeDef(Time, Default), tuMilliSeconds));
end;

function TimeInMillisecondsToStr(Time: Double): string;
begin
  Result := TimeToStr(ConvertFrom(tuMilliSeconds, Time))
end;

function TimeInSecondsToStr(Time: Double): string;
begin
  Result := TimeToStr(ConvertFrom(tuSeconds, Time));
end;

end.
