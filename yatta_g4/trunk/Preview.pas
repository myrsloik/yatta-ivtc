unit Preview;

interface

uses
  Windows, SysUtils, Graphics, ClipBrd, Controls, Classes, Forms, ExtCtrls, ComCtrls, GR32_Layers, GR32_Image,
  Menus, Asif, AsifAdditions;

type
  TPreviewForm = class(TForm)
    TrackBar: TTrackBar;
    Image: TImage32;
    PopupMenu: TPopupMenu;
    CopyFrametoClipboard1: TMenuItem;
    procedure TrackBarChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
    procedure CopyFrametoClipboard1Click(Sender: TObject);
  private
    FPreviewClip: IAsifClip;
    procedure SetPreviewClip(Clip: IAsifClip);
  public
    procedure CreateParams(var Params: TCreateParams); override;
    property PreviewClip: IAsifClip read FPreviewClip write SetPreviewClip;
  end;

var
  PreviewForm: TPreviewForm;

implementation

uses
  Matching, YattaProject;

{$R *.dfm}

procedure TPreviewForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent := HWND_DESKTOP; // More elegant than 0
end;

procedure TPreviewForm.TrackBarChange(Sender: TObject);
begin
  FullFrame(TrackBar.Position, FPreviewClip, Image.Bitmap);
  Caption := 'Preview - Frame: ' + IntToStr(TrackBar.Position);
  Image.Refresh;
end;

procedure TPreviewForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  PreviewClip := nil;
end;

procedure TPreviewForm.SetPreviewClip(Clip: IAsifClip);
begin
  FPreviewClip := Clip;

  if Clip <> nil then
    with FPreviewClip.GetVideoInfo do
    begin
      TrackBar.Max := NumFrames - 1;
      ClientHeight := Height + TrackBar.Height;
      ClientWidth := Width;
      TrackBar.Position := Project.GetDecimatedPos(MatchForm.FrameTrackBar.Position);
      TrackBarChange(nil);
    end;
end;

procedure TPreviewForm.ImageMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer;
  Layer: TCustomLayer);
begin
  if Button = mbLeft then
    TrackBar.Position := Project.GetDecimatedPos(MatchForm.FrameTrackBar.Position)
  else if Button = mbRight then //fix me, no reverse map exists
  //  Form1.TrackBar1.Position := Form1.RevFrameMap[TrackBar1.Position];
end;

procedure TPreviewForm.CopyFrametoClipboard1Click(Sender: TObject);
var
  MyFormat: Word;
  AData: Cardinal;
  APalette: HPALETTE;
  TempImage: TBitmap;
begin
  TempImage := TBitmap.Create;
  TempImage.Assign(Image.Bitmap);
  TempImage.SaveToClipboardFormat(MyFormat, AData, APalette);
  ClipBoard.SetAsHandle(MyFormat, AData);
  TempImage.Free;
end;

end.
