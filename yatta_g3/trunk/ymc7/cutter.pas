unit cutter;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, GR32_Image, ComCtrls, Asif, AsifAdditions, Math;

type
  TCutRange = class
  private
    FCutStart: Integer;
    FCutEnd: Integer;
  public
    constructor Create(ACutStart, ACutEnd: Integer);
    property CutStart: Integer read FCutStart;
    property CutEnd: Integer read FCutEnd;
  end;

  TCutterForm = class(TForm)
    GotoButton: TButton;
    OKButton: TButton;
    FrameTrackbar: TTrackBar;
    Image: TImage32;
    CutListBox: TListBox;
    AddCutButton: TButton;
    DeleteCutButton: TButton;
    CutStartButton: TButton;
    CutEndButton: TButton;
    CutStartEdit: TEdit;
    CutEndEdit: TEdit;
    procedure GotoButtonClick(Sender: TObject);
    procedure FrameTrackbarChange(Sender: TObject);
    procedure AddCutButtonClick(Sender: TObject);
    procedure CutListBoxDblClick(Sender: TObject);
    procedure CutEndButtonClick(Sender: TObject);
    procedure CutStartButtonClick(Sender: TObject);
    procedure DeleteCutButtonClick(Sender: TObject);
    procedure CutEndEditExit(Sender: TObject);
    procedure CutStartEditExit(Sender: TObject);
  private
    FVideo: IAsifClip;
  public
    constructor Create(Env: IAsifScriptEnvironment; Video: IAsifClip; AOwner: TComponent); reintroduce;
  end;

var
  CutterForm: TCutterForm;

implementation

{$R *.dfm}

procedure TCutterForm.GotoButtonClick(Sender: TObject);
begin
  FrameTrackbar.Position := StrToIntDef(InputBox('Goto', 'Enter the frame number', IntToStr(FrameTrackbar.Position)), FrameTrackbar.Position);
  FrameTrackbarChange(Self);
  ActiveControl := FrameTrackbar;
end;

procedure TCutterForm.FrameTrackbarChange(Sender: TObject);
begin
  FullFrame(FrameTrackbar.Position, FVideo, Image.Bitmap);
  Image.Repaint;
  Caption := 'Cutter - Frame: ' + IntToStr(FrameTrackbar.Position); 
end;

constructor TCutterForm.Create(Env: IAsifScriptEnvironment; Video: IAsifClip; AOwner: TComponent);
begin
  inherited Create(AOwner);

  with Env do
  begin
    ClipArg(Video);
    FVideo := InvokeWithClipResult('ConvertToRGB32');

    ClipArg(FVideo);
    FVideo := InvokeWithClipResult('Cache');
  end;
  
  with FVideo.GetVideoInfo do
  begin
    FrameTrackbar.Max := NumFrames - 1;
    ClientWidth := Max(Width + 128, 720);
    ClientHeight := Height + 62;
  end;
end;

{ TCutRange }

constructor TCutRange.Create(ACutStart, ACutEnd: Integer);
begin
  FCutStart := ACutStart;
  FCutEnd := ACutEnd;
end;

procedure TCutterForm.AddCutButtonClick(Sender: TObject);
var
  I: Integer;
begin
  for I := CutListBox.Count - 1 downto 0 do
    with (CutListBox.Items.Objects[I] as TCutRange) do
      if (CutStart >= FrameTrackbar.SelStart) and (CutStart <= FrameTrackbar.SelEnd) or
        (CutEnd >= FrameTrackbar.SelStart) and (CutEnd <= FrameTrackbar.SelEnd) then
        Exit;

  for I := CutListBox.Count downto 0 do
    if (I = 0) or (FrameTrackbar.SelStart > (CutListBox.Items.Objects[I - 1] as TCutRange).CutStart) then
    begin
      CutListBox.Items.InsertObject(I, Format('%d,%d', [FrameTrackbar.SelStart, FrameTrackbar.SelEnd]), Cutter.TCutRange.Create(FrameTrackbar.SelStart, FrameTrackbar.SelEnd));
      Break;
    end;
end;

procedure TCutterForm.CutListBoxDblClick(Sender: TObject);
begin
  FrameTrackbar.Position := (CutListBox.Items.Objects[CutListBox.ItemIndex] as TCutRange).CutStart;
end;

procedure TCutterForm.CutEndButtonClick(Sender: TObject);
begin
  FrameTrackbar.SelEnd := FrameTrackbar.Position;
  if FrameTrackbar.SelStart > FrameTrackbar.SelEnd then
    FrameTrackbar.SelStart := FrameTrackbar.SelEnd;
  CutStartEdit.Text := IntToStr(FrameTrackbar.SelStart);
  CutEndEdit.Text := IntToStr(FrameTrackbar.SelEnd);
end;

procedure TCutterForm.CutStartButtonClick(Sender: TObject);
begin
  if FrameTrackbar.Position = 1 then
    MessageDlg('Cuts may not start on frame 1', mtError, [mbOK], 0)
  else
  begin
    FrameTrackbar.SelStart := FrameTrackbar.Position;
    if FrameTrackbar.SelStart > FrameTrackbar.SelEnd then
      FrameTrackbar.SelEnd := FrameTrackbar.SelStart;
    CutStartEdit.Text := IntToStr(FrameTrackbar.SelStart);
    CutEndEdit.Text := IntToStr(FrameTrackbar.SelEnd);
  end;
end;

procedure TCutterForm.DeleteCutButtonClick(Sender: TObject);
var
  I: Integer;
begin
  for I := CutListBox.Count - 1 downto 0 do
    if CutListBox.Selected[I] then
    begin
      CutListBox.Items.Objects[I].Free;
      CutListBox.Items.Delete(I);
    end;
end;

procedure TCutterForm.CutEndEditExit(Sender: TObject);
begin
  try
    FrameTrackbar.SelEnd := StrToInt(CutEndEdit.Text);
    if FrameTrackbar.SelStart > FrameTrackbar.SelEnd then
      FrameTrackbar.SelStart := FrameTrackbar.SelEnd;
    CutStartEdit.Text := IntToStr(FrameTrackbar.SelStart);
    CutEndEdit.Text := IntToStr(FrameTrackbar.SelEnd);
  except
  end;
end;

procedure TCutterForm.CutStartEditExit(Sender: TObject);
begin
  try
    FrameTrackbar.SelStart := StrToInt(CutStartEdit.Text);;
    if FrameTrackbar.SelStart > FrameTrackbar.SelEnd then
      FrameTrackbar.SelEnd := FrameTrackbar.SelStart;
    CutStartEdit.Text := IntToStr(FrameTrackbar.SelStart);
    CutEndEdit.Text := IntToStr(FrameTrackbar.SelEnd);
  except
  end;
end;

end.
