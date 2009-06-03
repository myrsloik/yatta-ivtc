unit YSort;

interface

uses Types;

procedure HeapSort(var Arr: TIntegerDynArray);

implementation

procedure HeapSort(var Arr: TIntegerDynArray);
var
  N, Parent, Child: Cardinal;
  T, I: Integer;
begin
  N := Length(Arr);

  if N < 2 then
    Exit;

  I := N div 2;

  while (True) do
  begin
    if (I > 0) then
    begin
      Dec(i);
      T := Arr[I];
    end
    else
    begin
      Dec(N);
      if N = 0 then
        Exit;
      T := Arr[N];
      Arr[N] := Arr[0];
    end;

    Parent := I;
    Child := I * 2 + 1;

    while (Child < n) do
    begin
      if (Child + 1 < N) and (Arr[Child + 1] > Arr[Child]) then
        Inc(child);

      if (Arr[Child] > T) then
      begin
        Arr[Parent] := Arr[Child];
        Parent := Child;
        Child := Parent * 2 + 1;
      end
      else
        Break;
    end;

    Arr[Parent] := T;
  end;
end;

end.
