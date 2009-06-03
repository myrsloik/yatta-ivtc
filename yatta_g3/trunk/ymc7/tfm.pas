unit tfm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, asif, asifadditions, ComCtrls, Math,
  GR32_Image;

type
  TTFMForm = class(TForm)
    OrderGroup: TRadioGroup;
    ModeGroup: TRadioGroup;
    PPGroup: TRadioGroup;
    FieldGroup: TRadioGroup;
    MChromaCheckbox: TCheckBox;
    ChromaCheckbox: TCheckBox;
    GroupBox2: TGroupBox;
    CThreshEdit: TLabeledEdit;
    MIEdit: TLabeledEdit;
    BlockXEdit: TLabeledEdit;
    BlockYEdit: TLabeledEdit;
    MThreshEdit: TLabeledEdit;
    DisplayCheckbox: TCheckBox;
    TrackBar: TTrackBar;
    GotoButton: TButton;
    OkButton: TButton;
    SlowGroup: TRadioGroup;
    MicMatchingGroup: TRadioGroup;
    MakeDefault: TCheckBox;
    SetD2VButton: TButton;
    D2VOpenDialog: TOpenDialog;
    Image: TImage32;
    procedure TrackBarChange(Sender: TObject);
    procedure OrderGroupClick(Sender: TObject);
    procedure GotoButtonClick(Sender: TObject);
    procedure SetD2VButtonClick(Sender: TObject);
  private
    FOriginalVideo: IAsifClip;
    FProcessedVideo: IAsifClip;
    FEnv: IAsifScriptEnvironment;
  public
    constructor Create(Env: IAsifScriptEnvironment; Video: IAsifClip; AOwner: TComponent); reintroduce;
    procedure RefreshVideo;
  end;

var
  TFMForm: TTFMForm;

implementation

{$R *.dfm}

procedure TTFMForm.RefreshVideo;
begin
  with FEnv do
  begin
    ClipArg(FOriginalVideo);
    IntArg(OrderGroup.ItemIndex, 'order');
    IntArg(ModeGroup.ItemIndex * 2, 'mode');
    IntArg(PPGroup.ItemIndex, 'pp');
    IntArg(FieldGroup.ItemIndex - 1, 'field');
    IntArg(StrToIntDef(CThreshEdit.Text, 10), 'cthresh');
    IntArg(StrToIntDef(MIEdit.Text, 100), 'mi');
    IntArg(StrToIntDef(BlockXEdit.Text, 16), 'blockx');
    IntArg(StrToIntDef(BlockYEdit.Text, 16), 'blocky');
    IntArg(StrToIntDef(MThreshEdit.Text, 5), 'mthresh');
    IntArg(0, 'y0');
    IntArg(0, 'y1');
    IntArg(SlowGroup.ItemIndex, 'slow');
    IntArg(MicMatchingGroup.ItemIndex * 2, 'micmatching');
    IntArg(0, 'micout');
    IntArg(0, 'metric');
    BoolArg(ChromaCheckbox.Checked, 'chroma');
    BoolArg(MChromaCheckbox.Checked, 'mchroma');
    BoolArg(DisplayCheckbox.Checked, 'display');
    BoolArg(False, 'debug');
    CharArg(PChar(D2VOpenDialog.FileName), 'd2v');

    FProcessedVideo := InvokeWithClipResult('TFM');

    ClipArg(FProcessedVideo);
    FProcessedVideo := InvokeWithClipResult('ConvertToRGB32');

    ClipArg(FProcessedVideo);
    FProcessedVideo := InvokeWithClipResult('Cache');

    with FOriginalVideo.GetVideoInfo do
    begin
      TrackBar.Max := NumFrames - 1;

      ClientWidth := Max(720, Width);
      ClientHeight := Height + 110;
    end;

    TrackBarChange(nil);
  end;
end;

procedure TTFMForm.TrackBarChange(Sender: TObject);
begin
  FullFrame(TrackBar.Position, FProcessedVideo, Image.Bitmap);
  Image.Repaint;
end;

procedure TTFMForm.OrderGroupClick(Sender: TObject);
begin
  RefreshVideo;
end;

procedure TTFMForm.GotoButtonClick(Sender: TObject);
begin
  TrackBar.Position := StrToIntDef(InputBox('Goto', 'Enter the frame number', IntToStr(TrackBar.Position)), TrackBar.Position);
  TrackBarChange(nil);
  ActiveControl := TrackBar;
end;

constructor TTFMForm.Create(Env: IAsifScriptEnvironment; Video: IAsifClip;
  AOwner: TComponent);
begin
  inherited Create(AOwner);

  FEnv := Env;
  FOriginalVideo := Video;
end;

procedure TTFMForm.SetD2VButtonClick(Sender: TObject);
begin
  if not D2VOpenDialog.Execute then
    D2VOpenDialog.FileName := '';

  try
    RefreshVideo;
  except on E: EInvokeFailed do
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
      D2VOpenDialog.FileName := '';
      RefreshVideo;
    end;
  end;
end;

end.
