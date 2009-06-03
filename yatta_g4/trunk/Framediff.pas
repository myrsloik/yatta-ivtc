unit Framediff;

interface

uses
  Asif, YShared;

function FramediffMetric(F1, F2: TMatch; Clip: IAsifClip): Integer;

implementation

function FramediffYV12ISSE(Clip: IAsifClip; const F1Num, F2Num: Integer; const TopField: Boolean): Integer; forward;

function FramediffMetric(F1, F2: TMatch; Clip: IAsifClip): Integer;
begin
  Result := 0;

  if avs_is_yv12(Clip.GetVideoInfo) then
    Result := FramediffYV12ISSE(clip, F1.Top, F2.Top, True) + FramediffYV12ISSE(clip, F1.Bottom, F2.Bottom, False)
  else
    Assert(False, 'Unsupported colorspace');
end;

function FramediffYV12ISSE(Clip: IAsifClip; const F1Num, F2Num: Integer; const TopField: Boolean): Integer;
var
  F1, F2: IAsifVideoFrame;
  F1Mod, F2Mod: Integer;
  F1SrcP, F2SrcP: PByte;
  Height, Width: Integer;
  Plane: Integer;
begin
  F1 := clip.GetFrame(F1Num);
  F2 := clip.GetFrame(F2Num);

  Result := 0;

  for Plane := 0 to 2 do
  begin
    Width := F1.GetRowSize(Plane) div 8;
    Height := F1.GetHeight(Plane) div 2;

    F1SrcP := F1.GetReadPtr(Plane);
    F2SrcP := F2.GetReadPtr(Plane);

    if not TopField then
    begin
      Inc(F1SrcP, F1.GetPitch(Plane));
      Inc(F2SrcP, F2.GetPitch(Plane));
    end;

    F1Mod := F1.GetPitch(Plane) * 2 - Width * 8;
    F2Mod := F2.GetPitch(Plane) * 2 - Width * 8;

    asm
      pxor mm0,mm0
      mov eax,F1SrcP
      mov edx,F2SrcP

    @@yloop:
      mov ecx,Width
    @@xloop:
      movq mm1,[eax]
      psadbw mm1,[edx]
      paddd mm0,mm1

      add eax,8
      add edx,8

      sub ecx,1
      jnz @@xloop

      add eax,F1Mod
      add edx,F2Mod

      sub Height,1
      jnz @@yloop

      movd eax,mm0
      add Result,eax
    end;
  end;

  asm
    emms
  end;
end;

end.
