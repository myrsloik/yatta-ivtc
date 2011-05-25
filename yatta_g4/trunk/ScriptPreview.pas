unit ScriptPreview;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TScriptPreviewForm = class(TForm)
    Script: TMemo;
  private
    { Private declarations }
  public
    procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  ScriptPreviewForm: TScriptPreviewForm;

implementation

{$R *.dfm}

procedure TScriptPreviewForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent := HWND_DESKTOP; // More elegant than 0
end;

end.
