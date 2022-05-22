program YMC;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  frameget in 'frameget.pas',
  progress in 'progress.pas' {ProgressForm},
  YMCPlugin in 'YMCPlugin.pas',
  YMCInternalPlugins in 'YMCInternalPlugins.pas',
  telecide in 'telecide.pas' {TelecideForm},
  crop in 'crop.pas' {CropForm},
  Asif in '..\Asif.pas',
  AsifAdditions in '..\AsifAdditions.pas',
  tfm in 'tfm.pas' {TFMForm},
  YMCTask in 'YMCTask.pas',
  FunctionHooking in 'FunctionHooking.pas',
  yshared in '..\yshared.pas',
  scxvid in 'scxvid.pas' {SCXvidForm},
  cutter in 'cutter.pas' {CutterForm},
  resize in 'resize.pas' {ResizeForm},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Yatta Metrics Collector';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

