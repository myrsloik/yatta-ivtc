unit enpipe;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TENPipeForm = class(TForm)
    Memo1: TMemo;
    Memo2: TMemo;
    CheckBox1: TCheckBox;
    LabeledEdit1: TLabeledEdit;
    Label1: TLabel;
    Label2: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ENPipeForm: TENPipeForm;

implementation

{$R *.dfm}

end.
