unit Crop;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  ExtCtrls, StdCtrls, ComCtrls, StrUtils, Math, YShared, GR32,
  GR32_Image, AsifAdditions;

type
  TCropForm = class(TForm)
    TrackBar: TTrackBar;
    CropLeftEdit: TEdit;
    CropTopEdit: TEdit;
    CropRightEdit: TEdit;
    CropBottomEdit: TEdit;
    AvisynthCropLine: TLabeledEdit;
    CropRightUpDown: TUpDown;
    CropTopUpDown: TUpDown;
    CropLeftUpDown: TUpDown;
    AspectRatioError: TLabeledEdit;
    ZoomGroup: TRadioGroup;
    ResizeWidthEdit: TEdit;
    ResizeWidthUpDown: TUpDown;
    ResizeHeightEdit: TEdit;
    ResizeHeightUpDown: TUpDown;
    ResolutionSeparator: TLabel;
    PARGroup: TRadioGroup;
    Anamorphic: TCheckBox;
    ShowResized: TCheckBox;
    MPlayerPAR: TCheckBox;
    Image: TImage32;
    ZoomImage: TImage32;
    CropBottomUpDown: TUpDown;
    procedure FormShow(Sender: TObject);
    procedure TrackBarChange(Sender: TObject);
    procedure CropUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure GenericFormUpdate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ResizeUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure AnamorphicClick(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure UpDownEditChange(Sender: TObject);
  private
  public
    procedure UpdateForm;
    procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  CropForm: TCropForm;

implementation

{$R *.dfm}

uses
  Unit2, Unit1;

var
  CFP: TBitmap32;

procedure TCropForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent := HWND_DESKTOP; // More elegant than 0
end;

procedure TCropForm.FormShow(Sender: TObject);
begin
  TrackBar.Max := Form1.TrackBar1.Max;

  ResizeWidthEdit.Text := IntToStr(ResizeWidthUpDown.Position);
  ResizeHeightEdit.Text := IntToStr(ResizeHeightUpDown.Position);
  CropLeftEdit.Text := IntToStr(CropLeftUpDown.Position);
  CropTopEdit.Text := IntToStr(CropTopUpDown.Position);
  CropBottomEdit.Text := IntToStr(CropBottomUpDown.Position);
  CropRightEdit.Text := IntToStr(CropRightUpDown.Position);
  TrackBarChange(nil);
end;

procedure TCropForm.TrackBarChange(Sender: TObject);
begin
  FullFrame(TrackBar.Position, Form1.FieldClip, CFP);
  Caption := 'Cropping and Resizing - Frame: ' + IntToStr(TrackBar.Position);
  UpdateForm;
end;

procedure TCropForm.UpdateForm;
var
  PAR: Double;
  TW, TH: integer;
begin
  Image.Bitmap.Assign(CFP);

  TW := CFP.Width - CropRightUpDown.Position - CropLeftUpDown.Position;
  TH := CFP.Height - CropBottomUpDown.Position - CropTopUpDown.Position;

//PAR
  PAR := 0;

  if not MPlayerPAR.Checked then
    case PARGroup.ItemIndex of
      0: PAR := 1;
      1: PAR := 10 / 11;
      2: PAR := 40 / 33;
      3: PAR := 12 / 11;
      4: PAR := 16 / 11;
    end
  else
    case PARGroup.ItemIndex of
      0: PAR := 1;
      1: PAR := 8 / 9;
      2: PAR := 32 / 27;
      3: PAR := 16 / 15;
      4: PAR := 1.4222;
    end;

//coloring

  if ResizeWidthUpDown.Position mod 16 <> 0 then
    ResizeWidthEdit.Color := clYellow
  else
    ResizeWidthEdit.Color := clWindow;
  if ResizeHeightUpDown.Position mod 16 <> 0 then
    ResizeHeightEdit.Color := clYellow
  else
    ResizeHeightEdit.Color := clWindow;

//zoom window

  with ZoomImage.Bitmap do
    case ZoomGroup.ItemIndex of
      0: Draw(-CropLeftUpDown.Position, -CropTopUpDown.Position, cfp);
      1: Draw(-CFP.Width + 40 + CropRightUpDown.Position, -CropTopUpDown.Position, cfp);
      2: Draw(-CropLeftUpDown.Position, -CFP.Height + 40 + CropBottomUpDown.Position, cfp);
      3: Draw(-CFP.Width + 40 + CropRightUpDown.Position, -CFP.Height + 40 + CropBottomUpDown.Position, cfp);
    end;

//resizing

  if ShowResized.Checked then
  begin
    Image.Bitmap.Width := TW;
    Image.Bitmap.Height := TH;
    Image.Bitmap.Draw(-CropLeftUpDown.Position, -CropTopUpDown.Position, CFP);

    if Anamorphic.Checked then
    begin
      Image.Width := TW;
      Image.Height := Round(TH / PAR);
    end
    else
    begin
      Image.Width := ResizeWidthUpDown.Position;
      Image.Height := ResizeHeightUpDown.Position;
    end;

    ClientWidth := Image.Width + 132;
    ClientHeight := Max(Image.Height + TrackBar.Height, MPlayerPAR.Top + MPlayerPAR.Height + 2);
    TrackBar.Width := Image.Width;
    TrackBar.Top := Image.Height;
    Image.ScaleMode := smStretch;
  end
  else
  begin

//show cropping

    Image.Width := CFP.width;
    Image.Height := CFP.height;
    Image.ScaleMode := smNormal;
    ClientWidth := CFP.Width + 132;
    ClientHeight := Max(CFP.Height + TrackBar.Height, MPlayerPAR.Top + MPlayerPAR.Height + 2);

    with Image.Bitmap.Canvas do
    begin
      Pen.Color := clRed;
      Brush.Color := clRed;
      Rectangle(0, 0, CropLeftUpDown.Position, Image.Height);
      Rectangle(0, 0, Image.Width, CropTopUpDown.Position);
      Rectangle(0, Image.Height - CropBottomUpDown.Position, Image.Width, Image.Height);
      Rectangle(Image.Width - CropRightUpDown.Position, 0, Image.Width, Image.Height);
    end;

    TrackBar.Top := Image.Height;
    TrackBar.Width := Image.Width;
  end;


  //Aspect error/display size

  if Anamorphic.Checked then
  begin
    if PAR < 1 then
      AspectRatioError.Text := Format('%dx%d', [TW, Round(TH / PAR)])
    else
      AspectRatioError.Text := Format('%dx%d', [Round(TW * PAR), TH]);
  end
  else
  begin
    PAR := Abs((TW / TH) / ((ResizeWidthUpDown.Position / ResizeHeightUpDown.Position / PAR)) * 100 - 100);
    AspectRatioError.Text := FloatToStrF(PAR, ffFixed, 18, 2) + '%';
  end;

//aspect ratio error %

  if (PAR > 3) and not Anamorphic.Checked then
    AspectRatioError.Color := clYellow
  else
    AspectRatioError.Color := clWindow;

//crop line
  if (CropBottomUpDown.Position or CropRightUpDown.Position or CropTopUpDown.Position or CropLeftUpDown.Position) and 1 = 1 then
    AvisynthCropLine.Color := clYellow
  else
    AvisynthCropLine.Color := clWindow;
  AvisynthCropLine.Text := Format('Crop(%d,%d,%d,%d)',
    [CropLeftUpDown.Position, CropTopUpDown.Position, -CropRightUpDown.Position, -CropBottomUpDown.Position]);

  Image.Repaint;
end;

procedure TCropForm.CropUpDownClick(Sender: TObject; Button: TUDBtnType);
begin
  CropTopEdit.Text := IntToStr(CropTopUpDown.Position);
  CropBottomEdit.Text := IntToStr(CropBottomUpDown.Position);
  CropLeftEdit.Text := IntToStr(CropLeftUpDown.Position);
  CropRightEdit.Text := IntToStr(CropRightUpDown.Position);
  UpdateForm;
end;

procedure TCropForm.GenericFormUpdate(Sender: TObject);
begin
  UpdateForm;
end;


procedure TCropForm.FormCreate(Sender: TObject);
begin
  ZoomImage.Bitmap.Width := 40;
  ZoomImage.Bitmap.Height := 40;
  CFP := TBitmap32.Create;

  CropTopEdit.Tag := Integer(CropTopUpDown);
  CropLeftEdit.Tag := Integer(CropLeftUpDown);
  CropRightEdit.Tag := Integer(CropRightUpDown);
  CropBottomEdit.Tag := Integer(CropBottomUpDown);
  ResizeWidthEdit.Tag := Integer(ResizeWidthUpDown);
  ResizeHeightEdit.Tag := Integer(ResizeHeightUpDown);
end;

procedure TCropForm.ResizeUpDownClick(Sender: TObject; Button: TUDBtnType);
begin
  ResizeWidthEdit.Text := IntToStr(ResizeWidthUpDown.Position);
  ResizeHeightEdit.Text := IntToStr(ResizeHeightUpDown.Position);
  UpdateForm;
end;

procedure TCropForm.AnamorphicClick(Sender: TObject);
begin
  ResizeWidthUpDown.Enabled := not Anamorphic.Checked;
  ResizeHeightUpDown.Enabled := not Anamorphic.Checked;
  ResizeHeightEdit.Enabled := not Anamorphic.Checked;
  ResizeWidthEdit.Enabled := not Anamorphic.Checked;
  Form2.ResizeOn.Checked := not Anamorphic.Checked;
  if Anamorphic.Checked then
    AspectRatioError.EditLabel.Caption := 'Display size'
  else
    AspectRatioError.EditLabel.Caption := 'Aspect ratio error';
  UpdateForm;
end;

procedure TCropForm.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbleft then
    TrackBar.Position := Form1.TrackBar1.Position
  else
    Form1.TrackBar1.Position := TrackBar.Position;
end;

procedure TCropForm.FormDestroy(Sender: TObject);
begin
  CFP.Free;
end;

procedure TCropForm.UpDownEditChange(Sender: TObject);
var
  Value: Integer;
  Edit: TEdit;
begin
  Edit := (Sender as TEdit);

  try
    Value := StrToInt(Edit.Text);
    if Value < 0 then
      Abort;
    Edit.Color := clWindow;
    TUpDown(Edit.Tag).Position := Value;
    UpdateForm;
  except
    Edit.Color := clYellow;
  end;
end;

end.

