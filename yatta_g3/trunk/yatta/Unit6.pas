unit Unit6;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TForm6 = class(TForm)
    AskOnTryPattern: TCheckBox;
    PatternEdit: TLabeledEdit;
    OkButton: TButton;
    CancelButton: TButton;
    DecimationEdit: TLabeledEdit;
    PostEdit: TLabeledEdit;
    FreezeEdit: TLabeledEdit;
    GroupBox1: TGroupBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form6: TForm6;

implementation

{$R *.dfm}

uses unit1;

end.
