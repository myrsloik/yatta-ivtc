unit scxvid;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TSCXvidForm = class(TForm)
    LogEdit: TLabeledEdit;
    SaveDialog: TSaveDialog;
    MakeDefault: TCheckBox;
    OKButton: TButton;
    procedure LogEditChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SCXvidForm: TSCXvidForm;

implementation

{$R *.dfm}

procedure TSCXvidForm.LogEditChange(Sender: TObject);
begin
  if SaveDialog.Execute then
    LogEdit.Text := SaveDialog.FileName;
end;

end.
