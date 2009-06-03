unit YShared;

interface

uses SysUtils, StrUtils;

type
  TMpeg2Decoder = (mdNone, mdMpeg2Dec3, mdDGDecode);

  TAnsiCharSet = set of AnsiChar;

  TMatch = record
    Top, Bottom: Integer;
  end;

  TIntPair = class(TObject)
  private
    FI1, FI2: Integer;
  public
    property I1: Integer read FI1;
    property I2: Integer read FI2;
    constructor Create(I1, I2: Integer);
  end;

function AnsiDequotedStrY(const S: string; AQuote: Char): string;
function M(Top, Bottom: Integer): TMatch;

function GetNextToken(const S: string; var Offset: Integer; const Separators: TAnsiCharSet = [' ', #13, #10]): string;
function GetToken(const S: string; const Token: Integer; const Separators: TAnsiCharSet = [' ', #13, #10]): string;

const
  MainProjectSection = 'YATTA V3';
  V2ProjectSection = 'YATTA V2';
  YattaExt = '.yap';
  AvisynthExt = '.avs';
  FieldHintExt = '.fh.txt';
  TimecodeExt = '.vfr.txt';

implementation

function GetNextToken(const S: string; var Offset: Integer; const Separators: TAnsiCharSet): string;
var
  TokenStart: Integer;
  TokenEnd: Integer;
  I: Integer;
begin
  Assert(Offset > 0);

  TokenStart := -1;
  TokenEnd := -1;
  Result := '';

  for I := Offset to Length(S) do
  begin
    if (TokenStart = -1) and not (S[I] in Separators) then
      TokenStart := I
    else if (TokenStart <> -1) and (S[I] in Separators) then
    begin
      TokenEnd := I;
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
  I: Integer;
  Offset: Integer;
begin
  Offset := 1;

  for I := 0 to Token do
    Result := GetNextToken(S, Offset, Separators);
end;

function AnsiDequotedStrY(const S: string; AQuote: Char): string;
var
  L: Integer;
begin
  L := Length(S);
  if (L < 2) or (S[1] <> AQuote) or (S[l] <> AQuote) then
    Result := S
  else
    Result := AnsiReplaceStr(AnsiMidStr(S, 2, L - 2), AQuote + AQuote, AQuote);
end;

function M(Top, Bottom: Integer): TMatch;
begin
  Result.Top := Top;
  Result.Bottom := Bottom;
end;

{ TIntPair }

constructor TIntPair.Create(I1, I2: Integer);
begin
  FI1 := I1;
  FI2 := I2;
end;

end.

