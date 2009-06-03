unit telecide;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, math, Controls, Forms,
  StdCtrls, ExtCtrls, ComCtrls, YMCPlugin, Asif, GR32_Image, Dialogs;

type
  TTelecideForm = class(TForm)
    PostCheckbox: TCheckBox;
    BlendCheckbox: TCheckBox;
    VThreshEdit: TLabeledEdit;
    OrderGroup: TRadioGroup;
    GuideGroup: TRadioGroup;
    NTEdit: TLabeledEdit;
    GThreshEdit: TLabeledEdit;
    TrackBar: TTrackBar;
    DThreshEdit: TLabeledEdit;
    GotoButton: TButton;
    Panel1: TPanel;
    Panel2: TPanel;
    BackGroup: TRadioGroup;
    OkButton: TButton;
    BThreshEdit: TLabeledEdit;
    ChromaCheckbox: TCheckBox;
    ShowCheckbox: TCheckBox;
    MakeDefault: TCheckBox;
    Panel3: TPanel;
    Image: TImage32;
    procedure TrackBarChange(Sender: TObject);
    procedure GotoButtonClick(Sender: TObject);
    procedure PostCheckboxClick(Sender: TObject);
    procedure GuideGroupClick(Sender: TObject);
    procedure BackGroupClick(Sender: TObject);
    procedure NTEditChange(Sender: TObject);
    procedure GThreshEditChange(Sender: TObject);
    procedure BThreshEditChange(Sender: TObject);
    procedure VThreshEditChange(Sender: TObject);
    procedure DThreshEditChange(Sender: TObject);
    procedure OrderGroupClick(Sender: TObject);
    procedure BlendCheckboxClick(Sender: TObject);
    procedure ChromaCheckboxClick(Sender: TObject);
    procedure ShowCheckboxClick(Sender: TObject);
  private
    FOriginalVideo: IAsifClip;
    FProcessedVideo: IAsifClip;
    FEnv: IAsifScriptEnvironment;
  public
    constructor Create(Env: IAsifScriptEnvironment; Video: IAsifClip; AOwner: TComponent); reintroduce;
    procedure RefreshVideo;
  end;

var
  TelecideForm: TTelecideForm;

implementation

uses asifadditions, main;

{$R *.dfm}

procedure TTelecideForm.RefreshVideo;
begin
  with FEnv do
  begin
    ClipArg(FOriginalVideo);
    if OrderGroup.ItemIndex = 0 then
      FProcessedVideo := InvokeWithClipResult('AssumeBFF')
    else
      FProcessedVideo := InvokeWithClipResult('AssumeTFF');

    ClipArg(FProcessedVideo);
    BoolArg(False, 'debug');
    BoolArg(BlendCheckbox.Checked, 'blend');
    BoolArg(ShowCheckbox.Checked, 'show');
    IntArg(GuideGroup.ItemIndex, 'guide');
    IntArg(BackGroup.ItemIndex, 'back');
    IntArg(StrToIntDef(NTEdit.Text, 10), 'nt');
    IntArg(StrToIntDef(GThreshEdit.Text, 10), 'gthresh');
    IntArg(StrToIntDef(VThreshEdit.Text, 35), 'vthresh');
    IntArg(StrToIntDef(BThreshEdit.Text, 50), 'bthresh');
    IntArg(IfThen(PostCheckbox.Checked, 2, 0), 'post');
    IntArg(StrToIntDef(DThreshEdit.Text, 7), 'dthresh');
    BoolArg(ChromaCheckbox.Checked, 'chroma');
    IntArg(0, 'y0');
    IntArg(0, 'y1');
    CharArg('', 'ovr');
    FProcessedVideo := InvokeWithClipResult('Telecide');

    ClipArg(FProcessedVideo);
    FProcessedVideo := InvokeWithClipResult('ConvertToRGB32');

    ClipArg(FProcessedVideo);
    FProcessedVideo := InvokeWithClipResult('Cache');

    with FOriginalVideo.GetVideoInfo do
    begin
      TrackBar.Max := NumFrames - 1;
      ClientWidth := Max(720, Width);
      ClientHeight := Height + 90;
    end;

    TrackBarChange(Self);
  end;
end;

procedure TTelecideForm.TrackBarChange(Sender: TObject);
begin
  FullFrame(TrackBar.Position, FProcessedVideo, Image.Bitmap);
  Image.Repaint;
  Update;
end;

procedure TTelecideForm.GotoButtonClick(Sender: TObject);
begin
  TrackBar.Position := StrToIntDef(InputBox('Goto', 'Enter the frame number', IntToStr(TrackBar.Position)), TrackBar.Position);
  TrackBarChange(nil);
  ActiveControl := TrackBar;
end;

procedure TTelecideForm.PostCheckboxClick(Sender: TObject);
begin
  BlendCheckbox.Enabled := PostCheckbox.Checked;
  VThreshEdit.Enabled := PostCheckbox.Checked;
  RefreshVideo;
end;

procedure TTelecideForm.GuideGroupClick(Sender: TObject);
begin
  GThreshEdit.Enabled := GuideGroup.ItemIndex = 1;
  RefreshVideo;
end;

procedure TTelecideForm.BackGroupClick(Sender: TObject);
begin
  BThreshEdit.Enabled := BackGroup.ItemIndex = 1;
  RefreshVideo;
end;

procedure TTelecideForm.NTEditChange(Sender: TObject);
begin
  try
    if StrToInt(NTEdit.Text) < 0 then
      Abort;

    NTEdit.Color := clWindow;
  except
    NTEdit.Color := clYellow;
  end;
  RefreshVideo;
end;

procedure TTelecideForm.GThreshEditChange(Sender: TObject);
begin
  try
    if StrToInt(GThreshEdit.Text) < 0 then
      Abort;

    GThreshEdit.Color := clWindow;
  except
    GThreshEdit.Color := clYellow;
  end;
  RefreshVideo;
end;

procedure TTelecideForm.BThreshEditChange(Sender: TObject);
begin
  try
    if StrToInt(BThreshEdit.Text) < 0 then
      Abort;

    BThreshEdit.Color := clWindow;
  except
    BThreshEdit.Color := clYellow;
  end;
  RefreshVideo;
end;

procedure TTelecideForm.VThreshEditChange(Sender: TObject);
begin
  try
    if StrToInt(VThreshEdit.Text) < 0 then
      Abort;

    VThreshEdit.Color := clWindow;
  except
    VThreshEdit.Color := clYellow;
  end;
  RefreshVideo;
end;

procedure TTelecideForm.DThreshEditChange(Sender: TObject);
begin
  try
    if StrToInt(DThreshEdit.Text) < 0 then
      Abort;

    DThreshEdit.Color := clWindow;
  except
    DThreshEdit.Color := clYellow;
  end;
  RefreshVideo;
end;

procedure TTelecideForm.OrderGroupClick(Sender: TObject);
begin
  RefreshVideo;
end;

procedure TTelecideForm.BlendCheckboxClick(Sender: TObject);
begin
  RefreshVideo;
end;

procedure TTelecideForm.ChromaCheckboxClick(Sender: TObject);
begin
  RefreshVideo;
end;

procedure TTelecideForm.ShowCheckboxClick(Sender: TObject);
begin
  RefreshVideo;
end;

constructor TTelecideForm.Create(Env: IAsifScriptEnvironment;
  Video: IAsifClip; AOwner: TComponent);
begin
  inherited Create(AOwner);

  FEnv := Env;
  FOriginalVideo := Video;
end;

end.
