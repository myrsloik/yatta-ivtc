unit ViewListBox;

interface

uses
  SysUtils, Classes, Controls, StdCtrls, Contnrs;

type
  TViewListBox = class(TListBox)
  private
    FDataSource: TObjectList;
    procedure SetDataSource(S: TObjectList);
  protected
    { Protected declarations }
  public
    constructor Create(AOwner: TComponent); override;
    property DataSource: TObjectList read FDataSource write SetDataSource;
  published
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Yatta', [TViewListBox]);
end;

{ TViewListBox }

constructor TViewListBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDataSource := nil;
end;

procedure TViewListBox.SetDataSource(S: TObjectList);
begin
  FDataSource := S;

  if S = nil then
    Count := 0
  else
    Count := S.Count;
end;

end.
