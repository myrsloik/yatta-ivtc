unit presetimport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TPresetImportForm = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Presets: TListBox;
    PresetContent: TMemo;
    GroupBox3: TGroupBox;
    ImportAllButton: TButton;
    CancelButton: TButton;
    ImportSelectedButton: TButton;
    procedure PresetsClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PresetImportForm: TPresetImportForm;

implementation

uses unit2;

{$R *.dfm}

procedure TPresetImportForm.PresetsClick(Sender: TObject);
begin
  if (Presets.ItemIndex >= 0) and (Presets.SelCount = 1) then
    PresetContent.Text := TPreset(Presets.Items.Objects[Presets.ItemIndex]).chain
  else
    PresetContent.Clear;
end;

end.
