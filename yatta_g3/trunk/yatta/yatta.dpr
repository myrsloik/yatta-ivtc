program yatta;

uses
  FastMM4,
  Forms,
  windows,
  sysutils,
  dialogs,
  inifiles,
  Unit1 in 'Unit1.pas' {Form1},
  Unit6 in 'Unit6.pas' {Form6},
  Unit11 in 'Unit11.pas' {Form11},
  Unit2 in 'Unit2.pas' {Form2},
  Unit4 in 'Unit4.pas' {Form4},
  crop in 'crop.pas' {CropForm},
  Unit7 in 'Unit7.pas' {Form7},
  Unit3 in 'Unit3.pas' {Form3},
  v2projectopen in 'v2projectopen.pas',
  logbox in 'logbox.pas' {Logwindow},
  presetimport in 'presetimport.pas' {PresetImportForm},
  yshared in '..\yshared.pas',
  Asif in '..\Asif.pas',
  AsifAdditions in '..\AsifAdditions.pas',
  keydefaults in 'keydefaults.pas',
  keymap in 'KeyMap.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'YATTA';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm6, Form6);
  Application.CreateForm(TForm11, Form11);
  Application.CreateForm(TForm4, Form4);
  Application.CreateForm(TForm7, Form7);
  Application.CreateForm(TCropForm, CropForm);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TLogwindow, Logwindow);
  Application.CreateForm(TPresetImportForm, PresetImportForm);
  Form1.Show;
  Form1.Repaint;

  if (ParamCount = 1) and FileExists(ParamStr(1)) then
    Form1.OpenSource(ParamStr(1));

  Application.Run;

end.

