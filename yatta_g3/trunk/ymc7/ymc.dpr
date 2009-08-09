program YMC;

uses
  FastMM4,
  Forms,
  Main in 'Main.pas' {MainForm},
  FrameGet in 'frameget.pas',
  progress in 'progress.pas' {ProgressForm},
  YMCPlugin in 'YMCPlugin.pas',
  YMCInternalPlugins in 'YMCInternalPlugins.pas',
  telecide in 'telecide.pas' {TelecideForm},
  sc in 'sc.pas' {SClavcForm},
  crop in 'crop.pas' {CropForm},
  Asif in '..\Asif.pas',
  AsifAdditions in '..\AsifAdditions.pas',
  tfm in 'tfm.pas' {TFMForm},
  it in 'it.pas' {ITForm},
  YMCTask in 'YMCTask.pas',
  FunctionHooking in 'FunctionHooking.pas',
  yshared in '..\yshared.pas',
  scxvid in 'scxvid.pas' {SCXvidForm},
  cutter in 'cutter.pas' {CutterForm},
  resize in 'resize.pas' {ResizeForm},
  enpipe in 'enpipe.pas' {ENPipeForm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Yatta Metrics Collector';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

