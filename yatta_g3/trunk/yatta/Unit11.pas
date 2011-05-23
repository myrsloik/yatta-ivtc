unit Unit11;

interface

uses
  Windows, StrUtils, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, FileCtrl, Grids, ValEdit, menus;

type
  TForm11 = class(TForm)
    RadioGroup1: TRadioGroup;
    LabeledEdit1: TLabeledEdit;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox8: TCheckBox;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet3: TTabSheet;
    CheckBox10: TCheckBox;
    RadioGroup2: TRadioGroup;
    RadioGroup3: TRadioGroup;
    Decimation: TCheckBox;
    CheckBox15: TCheckBox;
    GroupBox1: TGroupBox;
    CheckBox13: TCheckBox;
    PGDecimation: TCheckBox;
    TabSheet2: TTabSheet;
    ValueListEditor1: TValueListEditor;
    Splitter1: TSplitter;
    Panel1: TPanel;
    Button4: TButton;
    SwapCustomList: TCheckBox;
    ShowCLInfo: TCheckBox;
    GroupBox2: TGroupBox;
    AudioFileEdit: TEdit;
    LabeledEdit2: TLabeledEdit;
    AudioDelayLabeledEdit: TLabeledEdit;
    AudioSelectOpenDialog: TOpenDialog;
    CheckBox7: TCheckBox;
    DefaultSettingsProject: TLabeledEdit;
    procedure LabeledEdit2Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure LabeledEdit1DblClick(Sender: TObject);
    procedure DecimationClick(Sender: TObject);
    procedure ValueListEditor1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ValueListEditor1KeyPress(Sender: TObject; var Key: Char);
    procedure Button4Click(Sender: TObject);
    procedure AudioFileEditClick(Sender: TObject);
    procedure AudioDelayLabeledEditChange(Sender: TObject);
    procedure DefaultSettingsProjectClick(Sender: TObject);
  private

  public
    procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  Form11: TForm11;

implementation

{$R *.dfm}

uses unit1, math, Unit2, v2projectopen, asif, asifadditions, keymap, keydefaults,
  IniFiles;

procedure LoadKeyMapping(const EventId: TKeyEvent; var KeyRec: TKeyRecord);
var IniKey: Integer;
begin
  IniKey := settings.ReadInteger('KEYS', KeyRec.Name, -1);
  if IniKey <> -1 then
    KeyRec.KeyC := IniKey;
end;

procedure SaveKeyMapping(const EventId: TKeyEvent; var KeyRec: TKeyRecord);
begin
  if KeyRec.Name <> '' then
    settings.WriteInteger('KEYS', KeyRec.Name, KeyRec.KeyC)
end;

procedure LoadDisplayMapping(const EventId: TKeyEvent; var KeyRec: TKeyRecord);
begin
  form11.ValueListEditor1.Values[KeyRec.Name] := ShortCutToText(KeyRec.KeyC);
end;

procedure SaveDisplayMapping(const EventId: TKeyEvent; var KeyRec: TKeyRecord);
begin
  KeyRec.KeyC := TextToShortCut(form11.ValueListEditor1.Values[KeyRec.Name]);
end;

procedure TForm11.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent := HWND_DESKTOP; // More elegant than 0
end;

procedure TForm11.LabeledEdit2Change(Sender: TObject);
begin
  try
    if (StrToInt(LabeledEdit2.Text) <= 1) or (StrToInt(LabeledEdit2.Text) > 25) then abort;
    form1.distance := StrToInt(LabeledEdit2.Text);
    LabeledEdit2.Color := clWindow;
  except
    LabeledEdit2.Color := clYellow;
  end;
end;

procedure TForm11.FormShow(Sender: TObject);
begin
  LabeledEdit2.Text := IntToStr(Form1.Distance);
end;

procedure TForm11.RadioGroup1Click(Sender: TObject);
begin
  if Form1.FileOpen then
    Form1.DrawFrame;
end;

procedure TForm11.FormCreate(Sender: TObject);
var
  sl: TStringList;
begin
  PluginPath := Settings.ReadString('MAIN', 'PluginDir', '');

  if pluginpath = '' then
    if MessageDlg('Avisynth plugin path not set. Set it now?', mtWarning, [mbyes, mbno], 0) = mryes then
      SelectDirectory('Plugin Path', '', pluginpath);

  if (pluginpath <> '') and (not AnsiEndsStr('\', pluginpath)) then
    pluginpath := pluginpath + '\';

  LabeledEdit1.Text := pluginpath;

  DefaultSettingsProject.Text := Settings.ReadString('MAIN', 'DefaultSettingsProject', '');

  CheckBox1.Checked := Settings.Readbool('MAIN', 'FullSave', false);
  CheckBox2.Checked := Settings.Readbool('MAIN', 'ShowMetric', true);
  CheckBox3.Checked := Settings.Readbool('MAIN', 'ShowSection', true);
  CheckBox4.Checked := Settings.Readbool('MAIN', 'ShowPattern', true);
  CheckBox5.Checked := Settings.Readbool('MAIN', 'ShowFF', true);
  CheckBox6.Checked := Settings.Readbool('MAIN', 'NodecimateC', false);
  CheckBox7.Checked := Settings.Readbool('MAIN', 'Singleclicksectionjump', false);
  CheckBox8.Checked := Settings.Readbool('MAIN', 'ShowFrameNumber', false);
  CheckBox10.Checked := Settings.ReadBool('MAIN', 'PreviewCurrentFrame', true);
  CheckBox13.Checked := Settings.ReadBool('MAIN', 'SaveOVROnPreview', true);
  pgdecimation.Checked := Settings.ReadBool('MAIN', 'PatterguidanceDecimation', true);
  CheckBox15.Checked := Settings.ReadBool('MAIN', 'PatternGuidanceTooShortWarning', true);
  Decimation.Checked := settings.ReadBool('MAIN', 'WithDecimation', true);
  SwapCustomList.Checked := settings.ReadBool('MAIN', 'SwapCustomList', true);
  ShowCLInfo.Checked := settings.ReadBool('MAIN', 'ShowCLInfo', true);


  RadioGroup2.ItemIndex := settings.readInteger('MAIN', 'Mpeg2Decoder', 2);
  RadioGroup3.ItemIndex := settings.readInteger('MAIN', 'DefaultProjectType', 0);

  InitKeyMap;
  SetDefaultKeys;
  ForEachKeyMapping(LoadKeyMapping);
  ForEachKeyMapping(LoadDisplayMapping);

  sl := TStringList.Create;
  sl.Assign(ValueListEditor1.Strings);
  sl.Sort;
  ValueListEditor1.Strings.Assign(sl);
  sl.Free;
end;

procedure TForm11.FormDestroy(Sender: TObject);
begin
  with Settings do
  begin
    WriteInteger('MAIN', 'MPEG2DECODER', form11.RadioGroup2.ItemIndex);
    WriteInteger('MAIN', 'DEFAULTPROJECTTYPE', form11.RadioGroup3.ItemIndex);
    WriteBool('MAIN', 'PreviewCurrentFrame', form11.CheckBox10.Checked);
    WriteString('MAIN', 'PluginDir', form11.LabeledEdit1.Text);
    WriteString('MAIN', 'DefaultSettingsProject', DefaultSettingsProject.Text);

    WriteBool('MAIN', 'FullSave', form11.CheckBox1.Checked);
    WriteBool('MAIN', 'ShowMetric', form11.CheckBox2.Checked);
    WriteBool('MAIN', 'ShowSection', form11.CheckBox3.Checked);
    WriteBool('MAIN', 'ShowPattern', form11.CheckBox4.Checked);
    WriteBool('MAIN', 'ShowFF', form11.CheckBox5.Checked);
    WriteBool('MAIN', 'NodecimateC', form11.CheckBox6.Checked);
    WriteBool('MAIN', 'Singleclicksectionjump', form11.CheckBox7.Checked);
    WriteBool('MAIN', 'ShowFrameNumber', form11.CheckBox8.Checked);
    writebool('MAIN', 'SaveOVROnPreview', form11.CheckBox13.Checked);
    WriteBool('MAIN', 'PatterguidanceDecimation', form11.pgdecimation.Checked);
    WriteBool('MAIN', 'WithDecimation', form11.Decimation.Checked);
    WriteBool('MAIN', 'PatternGuidanceTooShortWarning', form11.CheckBox15.Checked);
    WriteBool('MAIN', 'SwapCustomList', form11.SwapCustomList.Checked);

    WriteBool('MAIN', 'ShowCLInfo', ShowCLInfo.Checked);
  end;

  ForEachKeyMapping(SaveKeyMapping);
end;

procedure TForm11.LabeledEdit1DblClick(Sender: TObject);
begin
  SelectDirectory('Plugin Path', '', pluginpath);

  if (pluginpath <> '') and (not AnsiEndsStr('\', pluginpath)) then
    pluginpath := pluginpath + '\';

  form11.LabeledEdit1.Text := pluginpath;

  BringToFront;
end;

procedure TForm11.DecimationClick(Sender: TObject);
begin
  if Form1.FileOpen then
  begin
    Form1.UpdateFrameMap;
    form1.DrawFrame;
  end;
end;

procedure TForm11.ValueListEditor1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  SS: TShiftState;
  SC: TShortCut;
begin
  if (ValueListEditor1.Row >= 0) and (Key <> vk_shift) and (Key <> vk_menu) and (Key <> vk_control) then
  begin
    SS := [];

    if Key = vk_escape then
      Key := 0
    else
    begin
      if vkdown(VK_CONTROL) then
        Include(SS, ssCtrl);
      if vkdown(VK_MENU) then
        Include(SS, ssAlt);
      if vkdown(VK_SHIFT) then
        Include(SS, ssShift);
    end;

    SC := ShortCut(Key, SS);
    ValueListEditor1.Values[ValueListEditor1.Keys[ValueListEditor1.Row]] := ShortCutToText(SC);
    ForEachKeyMapping(SaveDisplayMapping);

    Key := 0;
  end;
end;

procedure TForm11.ValueListEditor1KeyPress(Sender: TObject; var Key: Char);
begin
  Key := #0;
end;

procedure TForm11.Button4Click(Sender: TObject);
begin
  if MessageDlg('Do you really want to reset all key associations?', mtConfirmation, [mbyes, mbno], 0) = mryes then
  begin
    SetDefaultKeys;
    ForEachKeyMapping(LoadDisplayMapping);
  end;
end;

procedure TForm11.AudioFileEditClick(Sender: TObject);
begin
  if AudioSelectOpenDialog.Execute then
    AudioFileEdit.Text := AudioSelectOpenDialog.FileName
  else
    AudioFileEdit.Text := '';

  Form1.FAudioFile := AudioFileEdit.Text;
end;

procedure TForm11.AudioDelayLabeledEditChange(Sender: TObject);
var
  I: Integer;
begin
  try
    I := StrToInt(AudioDelayLabeledEdit.Text);
    Form1.FAudioDelay := I;
    AudioDelayLabeledEdit.Color := clWindow;
  except
    AudioDelayLabeledEdit.Color := clYellow;
    Form1.FAudioDelay := 0;
  end;
end;

procedure TForm11.DefaultSettingsProjectClick(Sender: TObject);
begin
  if Form1.OpenDialog1.Execute then
    DefaultSettingsProject.Text := Form1.OpenDialog1.FileName;
end;

end.
