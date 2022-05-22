unit logbox;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, keymap, keydefaults;

type
  TLogwindow = class(TForm)
    LogList: TListBox;
    procedure LogListKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure LogListDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure CreateParams(var Params: TCreateParams); override;
    procedure AddLogMessage(LogMessage: string; Frame: Integer = -1);
    procedure DeleteLogMessage(Frame: Integer);
    procedure ClearLog;
  end;

var
  Logwindow: TLogwindow;

implementation

uses Unit1;

{$R *.dfm}

procedure TLogwindow.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent := HWND_DESKTOP; // More elegant than 0
end;

procedure TLogwindow.LogListKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  Counter: integer;
begin
  if IsKeyEvent(kGenericDelete, Key) then
  begin
    if LogList.SelCount = 0 then
      LogList.SelectAll;

    for Counter := LogList.Count - 1 downto 0 do
      if LogList.Selected[Counter] then
        LogList.Items.Delete(Counter);
  end;
end;

procedure TLogwindow.AddLogMessage(LogMessage: string; Frame: Integer);
begin
  LogList.Items.InsertObject(0, LogMessage, TObject(Frame));
  Logwindow.Show;
end;

procedure TLogwindow.DeleteLogMessage(Frame: Integer);
var
  Counter: Integer;
begin
  for Counter := LogList.Count - 1 downto 0 do
    if Integer(LogList.Items.Objects[Counter]) = Frame then
      LogList.Items.Delete(Counter);
end;

procedure TLogwindow.ClearLog;
begin
  LogList.Clear;
end;

procedure TLogwindow.LogListDblClick(Sender: TObject);
begin
  if LogList.ItemIndex >= 0 then
    Form1.TrackBar1.Position := Integer(LogList.Items.Objects[LogList.ItemIndex]);
end;

end.
