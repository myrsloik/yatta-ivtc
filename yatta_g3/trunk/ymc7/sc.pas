unit sc;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, strutils, math;

type
  TSClavcForm = class(TForm)
    LogEdit: TLabeledEdit;
    PresetSelect: TComboBox;
    StaticText1: TStaticText;
    V4MVCheckbox: TCheckBox;
    PreMeGroup: TRadioGroup;
    CmpGroup: TRadioGroup;
    SubCmpGroup: TRadioGroup;
    DiaEdit: TLabeledEdit;
    PreDiaEdit: TLabeledEdit;
    SaveDialog: TSaveDialog;
    GroupBox1: TGroupBox;
    Button1: TButton;
    MbCmpGroup: TRadioGroup;
    MakeDefault: TCheckBox;
    Panel1: TPanel;
    procedure LogEditDblClick(Sender: TObject);
    procedure PresetSelectChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SClavcForm: TSClavcForm;

implementation

{$R *.dfm}

procedure TSClavcForm.LogEditDblClick(Sender: TObject);
begin
  if SaveDialog.Execute then
    LogEdit.Text := SaveDialog.FileName;
end;

procedure TSClavcForm.PresetSelectChange(Sender: TObject);
begin
  DiaEdit.Text := '1';
  PreDiaEdit.Text := IfThen(PresetSelect.ItemIndex = 2, '-1', '1');
  PreMeGroup.ItemIndex := IfThen(PresetSelect.ItemIndex = 2, 2, 1); ;
  SubCmpGroup.ItemIndex := PresetSelect.ItemIndex;
  MbCmpGroup.ItemIndex := IfThen(PresetSelect.ItemIndex = 0, 0, 2); ;
  CmpGroup.ItemIndex := PresetSelect.ItemIndex;
  V4MVCheckbox.Checked := PresetSelect.ItemIndex <> 0;
end;

end.
