unit crop;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Asif, AsifAdditions, ExtCtrls, StdCtrls, Math, ComCtrls, GR32, GR32_Image;

type
  TCropForm = class(TForm)
    TrackBar: TTrackBar;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    UpDown1: TUpDown;
    UpDown2: TUpDown;
    UpDown3: TUpDown;
    UpDown4: TUpDown;
    RadioGroup1: TRadioGroup;
    MakeDefault: TCheckBox;
    Panel1: TPanel;
    ZoomImage: TImage32;
    Image: TImage32;
    procedure TrackBarChange(Sender: TObject);
    procedure UpDown3Click(Sender: TObject; Button: TUDBtnType);
    procedure UpDown2Click(Sender: TObject; Button: TUDBtnType);
    procedure UpDown4Click(Sender: TObject; Button: TUDBtnType);
    procedure UpDown1Click(Sender: TObject; Button: TUDBtnType);
    procedure RadioGroup1Click(Sender: TObject);
    procedure RadioGroup2Click(Sender: TObject);
    procedure showresized1Click(Sender: TObject);
    procedure PengvadoaspectClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FProcessedVideo: IAsifClip;
  public
    constructor Create(Env: IAsifScriptEnvironment; Video: IAsifClip; AOwner: TComponent); reintroduce;
    procedure UpdateForm;
    procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  CropForm: TCropForm;

implementation

{$R *.dfm}

var
  CFP: TBitmap32;

procedure TCropForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent := HWND_DESKTOP; // More elegant than 0
end;

procedure TCropForm.TrackBarChange(Sender: TObject);
begin
  FullFrame(TrackBar.Position, FProcessedVideo, CFP);
  UpdateForm;
  Caption := 'Crop - Frame: ' + IntToStr(TrackBar.Position);
  Update;
end;

procedure TCropForm.UpDown3Click(Sender: TObject; Button: TUDBtnType);
begin
  Edit3.Text := IntToStr(UpDown3.Position);
  UpdateForm;
end;

procedure TCropForm.UpDown2Click(Sender: TObject; Button: TUDBtnType);
begin
  Edit4.Text := IntToStr(UpDown2.Position);
  UpdateForm;
end;

procedure TCropForm.UpDown4Click(Sender: TObject; Button: TUDBtnType);
begin
  Edit2.Text := IntToStr(UpDown4.Position);
  UpdateForm;
end;

procedure TCropForm.UpDown1Click(Sender: TObject; Button: TUDBtnType);
begin
  Edit5.Text := IntToStr(UpDown1.Position);
  UpdateForm;
end;

procedure TCropForm.RadioGroup1Click(Sender: TObject);
begin
  UpdateForm;
end;

procedure TCropForm.RadioGroup2Click(Sender: TObject);
begin
  UpdateForm;
end;


procedure TCropForm.showresized1Click(Sender: TObject);
begin
  UpdateForm;
end;

procedure TCropForm.PengvadoaspectClick(Sender: TObject);
begin
  UpdateForm;
end;

procedure TCropForm.FormDestroy(Sender: TObject);
begin
  CFP.Free;
end;

procedure TCropForm.Edit3Change(Sender: TObject);
var
  Val: Integer;
begin
  try
    Val := StrToInt(TEdit(Sender).Text);
    if Val < 0 then
      Abort;
    (Sender as TEdit).Color := clWindow;
    TUpDown((Sender as TEdit).Tag).Position := val;
    UpdateForm;
  except
    (Sender as TEdit).Color := clYellow;
  end;
end;

constructor TCropForm.Create(Env: IAsifScriptEnvironment; Video: IAsifClip;
  AOwner: TComponent);
begin
  inherited Create(AOwner);

  with Env do
  begin
    ClipArg(Video);
    FProcessedVideo := InvokeWithClipResult('ConvertToRGB32');
  end;

  TrackBar.Max := FProcessedVideo.GetVideoInfo.NumFrames - 1;
end;

procedure TCropForm.UpdateForm;
begin
  Image.Bitmap.Assign(CFP);

//zoom window

  with FProcessedVideo.GetVideoInfo do
    case RadioGroup1.ItemIndex of
      0: ZoomImage.Bitmap.Draw(-UpDown4.Position, -UpDown3.Position, CFP);
      1: ZoomImage.Bitmap.Draw(-Width + 40 + UpDown2.Position, -UpDown3.Position, CFP);
      2: ZoomImage.Bitmap.Draw(-UpDown4.Position, -Height + 40 + UpDown1.Position, CFP);
      3: ZoomImage.Bitmap.Draw(-Width + 40 + UpDown2.Position, -Height + 40 + UpDown1.Position, CFP);
    end;

//show cropping

  Image.Bitmap.Canvas.Pen.Color := clRed;
  Image.Bitmap.Canvas.Brush.Color := clRed;
  Image.Bitmap.Canvas.Rectangle(0, 0, UpDown4.Position, Image.Height);
  Image.Bitmap.Canvas.Rectangle(0, 0, Image.Width, UpDown3.Position);
  Image.Bitmap.Canvas.Rectangle(0, Image.Height - UpDown1.Position, Image.Width, Image.Height);
  Image.Bitmap.Canvas.Rectangle(Image.Width - UpDown2.Position, 0, Image.Width, Image.Height);

  TrackBar.Top := Image.Height;
  TrackBar.Width := Image.Width;
end;

procedure TCropForm.FormCreate(Sender: TObject);
begin
  MakeDefault.ControlStyle := MakeDefault.ControlStyle - [csParentBackground];
  ControlStyle := ControlStyle - [csParentBackground];

  ZoomImage.Bitmap.Width := 40;
  ZoomImage.Bitmap.Height := 40;
  CFP := TBitmap32.Create;

  Edit3.Tag := Integer(UpDown3);
  Edit4.Tag := Integer(UpDown2);
  Edit2.Tag := Integer(UpDown4);
  Edit5.Tag := Integer(UpDown1);

  TrackBarChange(Self);
end;

end.
