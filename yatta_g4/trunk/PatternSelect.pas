unit PatternSelect;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TPatternSelectForm = class(TForm)
    AskOnTryPattern: TCheckBox;
    MatchPattern: TLabeledEdit;
    OkButton: TButton;
    CancelButton: TButton;
    DecimationPattern: TLabeledEdit;
    PostprocessPattern: TLabeledEdit;
    FreezeFramePattern: TLabeledEdit;
    GroupBox1: TGroupBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PatternSelectForm: TPatternSelectForm;

implementation

{$R *.dfm}

end.
