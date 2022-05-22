unit resize;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TResizeForm = class(TForm)
    ResizerGroup: TRadioGroup;
    WidthEdit: TLabeledEdit;
    HeightEdit: TLabeledEdit;
    OKButton: TButton;
    MakeDefault: TCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ResizeForm: TResizeForm;

implementation

{$R *.dfm}

end.
