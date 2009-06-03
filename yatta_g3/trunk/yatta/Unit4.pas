unit Unit4;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, asif, math, asifadditions, Menus, clipbrd,
  GR32_Image, GR32_Layers;

type
  TForm4 = class(TForm)
    TrackBar1: TTrackBar;
    PopupMenu1: TPopupMenu;
    CopyFrametoClipboard1: TMenuItem;
    Image1: TImage32;
    procedure FormCreate(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CopyFrametoClipboard1Click(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
  private
    FPreviewClip: IAsifClip;
    procedure SetPreviewClip(Clip: IAsifClip);
  public
    property PreviewClip: IAsifClip read FPreviewClip write SetPreviewClip;
    procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  Form4: TForm4;

implementation

uses Unit1, Unit11;

{$R *.dfm}

procedure TForm4.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent := HWND_DESKTOP; // More elegant than 0
end;

procedure TForm4.FormCreate(Sender: TObject);
begin
  FPreviewClip := nil;
end;

procedure TForm4.TrackBar1Change(Sender: TObject);
begin
  FullFrame(TrackBar1.Position, FPreviewClip, Image1.Bitmap);
  Image1.Repaint;

  Caption := 'Preview - Frame: ' + IntToStr(TrackBar1.Position);
end;

procedure TForm4.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FPreviewClip := nil;
end;

procedure TForm4.CopyFrametoClipboard1Click(Sender: TObject);
var
  MyFormat: Word;
  AData: Cardinal;
  APalette: HPALETTE;
  TempImage: TBitmap;
begin
  TempImage := TBitmap.Create;
  TempImage.Assign(Image1.Bitmap);
  TempImage.SaveToClipboardFormat(MyFormat, AData, APalette);
  ClipBoard.SetAsHandle(MyFormat, AData);
  TempImage.Free;
end;

procedure TForm4.SetPreviewClip(Clip: IAsifClip);
begin
  FPreviewClip := Clip;

  if Clip <> nil then
    with FPreviewClip.GetVideoInfo do
    begin
      TrackBar1.Max := NumFrames - 1;
      ClientHeight := Height + TrackBar1.Height;
      ClientWidth := Width;

      if Form11.CheckBox10.Checked then
        TrackBar1.Position := Form1.FrameMap[Form1.TrackBar1.Position];

      TrackBar1Change(Self);
    end;
end;

procedure TForm4.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
begin
  if Button = mbLeft then
    TrackBar1.Position := Form1.FrameMap[Form1.TrackBar1.Position]
  else if Button = mbRight then
    Form1.TrackBar1.Position := Form1.RevFrameMap[TrackBar1.Position];
end;

end.
