unit it;

interface

uses
  Windows, Messages, SysUtils, Classes, StrUtils, Math, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, asif, asifadditions, GR32_Image;

type
  TITForm = class(TForm)
    GotoButton: TButton;
    OKButton: TButton;
    FrameTrackbar: TTrackBar;
    OrderGroup: TRadioGroup;
    MakeDefault: TCheckBox;
    Panel1: TPanel;
    Image: TImage32;
    procedure FrameTrackbarChange(Sender: TObject);
    procedure OrderGroupClick(Sender: TObject);
    procedure GotoButtonClick(Sender: TObject);
  private
    FOriginalVideo: IAsifClip;
    FProcessedVideo: IAsifClip;
    FEnv: IAsifScriptEnvironment;
  public
    constructor Create(Env: IAsifScriptEnvironment; Video: IAsifClip; AOwner: TComponent); reintroduce;
    procedure RefreshVideo;
  end;

var
  ITForm: TITForm;

implementation

{$R *.dfm}

procedure TITForm.FrameTrackbarChange(Sender: TObject);
begin
  FullFrame(FrameTrackbar.Position, FProcessedVideo, Image.Bitmap);
  Image.Repaint;
end;

procedure TITForm.OrderGroupClick(Sender: TObject);
begin
  RefreshVideo;
end;

procedure TITForm.GotoButtonClick(Sender: TObject);
begin
  FrameTrackbar.Position := StrToIntDef(InputBox('Goto', 'Enter the frame number', IntToStr(FrameTrackbar.Position)), FrameTrackbar.Position);
  FrameTrackbarChange(Self);
  ActiveControl := FrameTrackbar;
end;

procedure TITForm.RefreshVideo;
begin
  with FEnv do
  begin
    ClipArg(FOriginalVideo);
    CharArg(PChar(IfThen(OrderGroup.itemindex = 1, 'TOP', 'BOTTOM')), 'ref');
    FProcessedVideo := InvokeWithClipResult('IT');

    ClipArg(FProcessedVideo);
    FProcessedVideo := InvokeWithClipResult('ConvertToRGB32');

    ClipArg(FProcessedVideo);
    FProcessedVideo := InvokeWithClipResult('Cache');

    FrameTrackbar.Max := FProcessedVideo.GetVideoInfo.NumFrames - 1;

    ClientWidth := Max(FOriginalVideo.GetVideoInfo.Width, 720);
    ClientHeight := FOriginalVideo.GetVideoInfo.Height + 60;

    FrameTrackbarChange(Self);
  end;
end;

constructor TITForm.Create(Env: IAsifScriptEnvironment; Video: IAsifClip; AOwner: TComponent);
begin
  inherited Create(AOwner);

  FEnv := Env;
  FOriginalVideo := Video;
end;

end.
