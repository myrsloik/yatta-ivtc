unit bitsext;

interface

uses classes;

type
  IBitField = interface(IInterface)
    function GetFirstUnset(): Cardinal;
    procedure SetBit(Bit: Cardinal; const Value: Boolean);
    function GetBit(Bit: Cardinal): Boolean;

    property FirstUnset: Cardinal read GetFirstUnset;
    property Bits[index: Cardinal]: Boolean read GetBit write SetBit;
  end;

  TBitField = class(TInterfacedObject, IBitField)
  private
    Field: TList;

  public
    constructor Create();
    destructor Destroy(); override;

    function GetFirstUnset(): Cardinal;
    procedure SetBit(Bit: Cardinal; const Value: Boolean);
    function GetBit(Bit: Cardinal): Boolean;

    property FirstUnset: Cardinal read GetFirstUnset;
    property Bits[index: Cardinal]: Boolean read GetBit write SetBit; default;
  end;

  TBitFieldEntry = record
    Start, Length: Cardinal;
  end;

  PBitFieldEntry = ^TBitFieldEntry;

implementation

constructor TBitField.Create();
begin
  Field := TList.Create;
end;

destructor TBitField.Destroy();
var
  counter: Cardinal;
begin
  if field.Count > 0 then
    for counter := Field.Count - 1 downto 0 do
      FreeMem(Field[counter]);

  Field.Free;
end;

function TBitField.GetFirstUnset(): Cardinal;
var
  counter: Cardinal;
  Entry: PBitFieldEntry;
begin
  Result := 0;

  if Field.Count > 0 then
    for counter := 0 to Field.Count - 1 do
    begin
      Entry := Field[counter];

      if Entry.Start = 0 then
      begin
        Result := Entry.Length;
        Break;
      end;
    end;

end;

procedure TBitField.SetBit(Bit: Cardinal; const Value: Boolean);
var
  counter, templength: Cardinal;
  Entry: PBitFieldEntry;
  BitP, BitN: Boolean;
begin
  if GetBit(Bit) = Value then
    Exit;

  templength := 0;

  if Bit = High(Bit) then
  begin
    BitP := GetBit(Bit - 1);
    BitN := False;
  end
  else if Bit = Low(Bit) then
  begin
    BitN := GetBit(Bit + 1);
    BitP := False;
  end
  else
  begin
    BitP := GetBit(Bit - 1);
    BitN := GetBit(Bit + 1);
  end;

  if Value then
  begin
    if (not BitP) and (not BitN) then
    begin
      GetMem(Entry, sizeof(TBitFieldEntry));
      Entry.Start := Bit;
      Entry.Length := 1;
      Field.Add(Entry);
    end
    else if BitP and (not BitN) then
    begin

      for counter := 0 to Field.Count - 1 do
      begin
        Entry := Field[counter];

        if Entry.Start + Entry.Length = Bit then
        begin
          Inc(Entry.Length);
          Break;
        end;

      end;

    end
    else if (not BitP) and BitN then
    begin

      for counter := 0 to Field.Count - 1 do
      begin
        Entry := Field[counter];

        if Entry.Start - 1 = Bit then
        begin
          Dec(Entry.Start);
          Inc(Entry.Length);
          Break;
        end;

      end;

    end
    else if BitP and BitN then
    begin

      for counter := 0 to Field.Count - 1 do
      begin
        Entry := Field[counter];

        if Entry.Start + Entry.Length = Bit then
        begin
          templength := Entry.Length;
          FreeMem(Entry);
          Field.Delete(counter);
          Break;
        end;

      end;

      for counter := 0 to Field.Count - 1 do
      begin
        Entry := Field[counter];

        if Entry.Start - 1 = Bit then
        begin
          Entry.Length := Entry.Length + templength + 1;
          Break;
        end;

      end;

    end;
  end
  else ///////////////////////////////////
  begin
    if (not BitP) and (not BitN) then
    begin

      for counter := 0 to Field.Count - 1 do
      begin
        Entry := Field[counter];

        if Entry.Start = Bit then
        begin
          FreeMem(Entry);
          Field.Delete(counter);
          Break;
        end;

      end;

    end
    else if BitP and (not BitN) then
    begin

      for counter := 0 to Field.Count - 1 do
      begin
        Entry := Field[counter];

        if Entry.Start + Entry.Length - 1 = Bit then
        begin
          Dec(Entry.Length);
          Break;
        end;

      end;

    end
    else if (not BitP) and BitN then
    begin

      for counter := 0 to Field.Count - 1 do
      begin
        Entry := Field[counter];

        if Entry.Start = Bit then
        begin
          Inc(Entry.Start);
          Dec(Entry.Length);
          Break;
        end;

      end;

    end
    else if BitP and BitN then
    begin

      for counter := 0 to Field.Count - 1 do
      begin
        Entry := Field[counter];

        if (Entry.Start <= Bit) and (Entry.Start + Entry.Length - 1 >= Bit) then
        begin
          templength := Entry.Length;
          Entry.Length := Bit - Entry.Start;

          templength := templength - Entry.Length - 1;

          GetMem(Entry, sizeof(TBitFieldEntry));

          Entry.Start := Bit + 1;
          Entry.Length := templength;

          Break;
        end;

      end;

    end;

  end;

end;

function TBitField.GetBit(Bit: Cardinal): Boolean;
var
  counter: Cardinal;
  Entry: PBitFieldEntry;
begin
  Result := false;

  if field.Count > 0 then
  begin

    for counter := 0 to Field.Count - 1 do
    begin
      Entry := Field[counter];

      if (Entry.Start <= Bit) and (Entry.Start + Entry.Length - 1 >= Bit) then
      begin
        Result := true;
        Break;
      end;

    end;

  end;
end;

end.
