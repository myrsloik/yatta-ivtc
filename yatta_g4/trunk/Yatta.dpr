program Yatta;

{$IFDEF DMetricDebug}
{$APPTYPE Console}
{$ENDIF}

uses
  FastMM4,
  Forms,
  Matching in 'Matching.pas' {MatchForm},
  PatternSelect in 'PatternSelect.pas' {PatternForm},
  Settings in 'Settings.pas' {SettingsForm},
  Tools in 'Tools.pas' {ToolForm},
  Preview in 'Preview.pas' {PreviewForm},
  About in 'About.pas' {AboutForm},
  ScriptPreview in 'ScriptPreview.pas' {ScriptPreviewForm},
  YShared in 'YShared.pas',
  YattaProject in 'YattaProject.pas',
  MarkerLists in 'MarkerLists.pas',
  BitsExt in 'BitsExt.pas',
  PresetImport in 'PresetImport.pas' {PresetImportForm},
  Framediff in 'Framediff.pas',
  YSort in 'YSort.pas',
  YattaVideo in 'YattaVideo.pas',
  ViewListBox in 'ViewListBox.pas',
  AsifAdditions in 'AsifAdditions.pas',
  Asif in 'Asif.pas',
  LogBox in 'LogBox.pas' {Logwindow},
  Crop in 'Crop.pas' {CropForm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'YATTA';
  Application.CreateForm(TMatchForm, MatchForm);
  Application.CreateForm(TToolForm, ToolForm);
  Application.CreateForm(TSettingsForm, SettingsForm);
  Application.CreateForm(TPreviewForm, PreviewForm);
  Application.CreateForm(TScriptPreviewForm, ScriptPreviewForm);
  Application.CreateForm(TPresetImportForm, PresetImportForm);
  Application.CreateForm(TLogwindow, Logwindow);
  Application.CreateForm(TCropForm, CropForm);
  CLOpen := ParamCount = 1;
  MatchForm.Show;
  MatchForm.Repaint;
  //MatchForm.OpenAction.Execute;
  Application.Run;
end.

