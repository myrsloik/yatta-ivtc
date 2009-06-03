unit BitsExt;

interface

uses Classes;

type
  TBitsExt = class(TBits)
  private
    function GetBit(Index: Integer): Boolean;
    procedure SetBit(Index: Integer; Value: Boolean);
  public
    //next (un)set bit?
    procedure Clear();
    procedure Shrink();
    property Bits[Index: Integer]: Boolean read GetBit write SetBit; default;
  end;

implementation

procedure TBitsExt.Clear;
begin
  Size := 0;
end;

function TBitsExt.GetBit(Index: Integer): Boolean;
begin
  if Index >= Size then
    Result := False
  else
    Result := inherited Bits[Index];
end;

procedure TBitsExt.SetBit(Index: Integer; Value: Boolean);
begin
  if Index >= Size then
    Size := Index;

  inherited Bits[Index] := Value;
end;

procedure TBitsExt.Shrink;
var
  I: Integer;
begin
  for I := Size - 1 downto 0 do
    if inherited Bits[I] then
    begin
      Size := I + 1;
      Break;
    end;
end;

end.
