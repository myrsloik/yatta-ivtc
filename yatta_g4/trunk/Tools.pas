unit Tools;

interface

uses
  Windows, Math, StrUtils, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, Menus, yshared, MarkerLists, ActnList,
  ViewListBox, YattaProject;

type
  TToolForm = class(TForm)
    Button1: TButton;
    PageControl: TPageControl;
    SectionSheet: TTabSheet;
    PresetSheet: TTabSheet;
    UpdatePreset: TButton;
    NewPreset: TButton;
    DeletePreset: TButton;
    PresetSelect: TComboBox;
    PresetEditText: TMemo;
    ScriptSheet: TTabSheet;
    DecimationSheet: TTabSheet;
    DecimateList: TViewListBox;
    PreviewAvs: TButton;
    saveliteavs: TButton;
    Button4: TButton;
    SectionBox: TGroupBox;
    PresetBox: TGroupBox;
    SectionList: TViewListBox;
    SectionSelect: TComboBox;
    PresetList: TViewListBox;
    LayerSheet: TTabSheet;
    LayerBox: TGroupBox;
    LayerList: TViewListBox;
    LayerMoveDown: TButton;
    LayerMoveUp: TButton;
    RenameLayer: TButton;
    SectionlistNew: TButton;
    LayerDelete: TButton;
    AddSection: TButton;
    DeleteSection: TButton;
    RangelistNew: TButton;
    FreezeFrameList: TViewListBox;
    MinN: TEdit;
    AddDecimate: TButton;
    DeleteDecimate: TButton;
    AddFreezeFrame: TButton;
    DeleteFreezeFrame: TButton;
    PresetSetupBox: TGroupBox;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    ImportPresets: TButton;
    DecimationBox: TGroupBox;
    FreezeFrameBox: TGroupBox;
    Splitter3: TSplitter;
    AVSGenerationBox: TGroupBox;
    AutoUpdatePreset: TCheckBox;
    RenamePreset: TButton;
    RangeGroupBox: TGroupBox;
    RangesList: TViewListBox;
    RangeProcessText: TEdit;
    AddRangeButton: TButton;
    DeleteRangeButton: TButton;
    ActionList: TActionList;
    AddRangeAction: TAction;
    AddDecimationAction: TAction;
    AddSectionAction: TAction;
    AddFreezeFrameAction: TAction;
    DeleteSectionAction: TAction;
    DeleteFreezeFrameAction: TAction;
    DeleteDecimationAction: TAction;
    AddSectionListAction: TAction;
    AddRangeListAction: TAction;
    DeleteLayerAction: TAction;
    RenameLayerAction: TAction;
    MoveLayerUpAction: TAction;
    MoveLayerDownAction: TAction;
    DeleteRangeAction: TAction;
    RenamePresetAction: TAction;
    DeletePresetAction: TAction;
    UpdatePresetAction: TAction;
    NewPresetAction: TAction;
    ImportPresetAction: TAction;
    procedure PresetListClick(Sender: TObject);
    procedure SectionListData(Control: TWinControl; Index: Integer;
      var Data: string);
    procedure LayerListData(Control: TWinControl; Index: Integer;
      var Data: string);
    procedure PresetSelectChange(Sender: TObject);
    procedure PresetListData(Control: TWinControl; Index: Integer;
      var Data: string);
    procedure DecimateListData(Control: TWinControl; Index: Integer;
      var Data: string);
    procedure FreezeFrameListData(Control: TWinControl; Index: Integer;
      var Data: string);
    procedure DecimateListClick(Sender: TObject);
    procedure PresetEditTextChange(Sender: TObject);
    procedure SectionSelectSelect(Sender: TObject);
    procedure PreviewAvsClick(Sender: TObject);
    procedure SectionSelectDropDown(Sender: TObject);
    procedure LayerListClick(Sender: TObject);
    procedure RangesListDblClick(Sender: TObject);
    procedure RangesListData(Control: TWinControl; Index: Integer;
      var Data: string);
    procedure RangeProcessTextChange(Sender: TObject);
    procedure PresetSelectDropDown(Sender: TObject);
    procedure AddFreezeFrameClick(Sender: TObject);
    procedure AddSectionActionExecute(Sender: TObject);
    procedure AddFreezeFrameActionExecute(Sender: TObject);
    procedure DeleteSectionActionExecute(Sender: TObject);
    procedure DeleteDecimationActionExecute(Sender: TObject);
    procedure DeleteFreezeFrameActionExecute(Sender: TObject);
    procedure MoveLayerUpActionExecute(Sender: TObject);
    procedure MoveLayerDownActionExecute(Sender: TObject);
    procedure AddSectionListActionExecute(Sender: TObject);
    procedure AddRangeListActionExecute(Sender: TObject);
    procedure DeleteLayerActionExecute(Sender: TObject);
    procedure RenameLayerActionExecute(Sender: TObject);
    procedure DeleteRangeActionExecute(Sender: TObject);
    procedure RangeUpButtonClick(Sender: TObject);
    procedure RangeDownButtonClick(Sender: TObject);
    procedure RenamePresetActionExecute(Sender: TObject);
    procedure UpdatePresetActionExecute(Sender: TObject);
    procedure NewPresetActionExecute(Sender: TObject);
    procedure PresetSelectedUpdate(Sender: TObject);
    procedure DeletePresetActionExecute(Sender: TObject);
    procedure MoveLayerUpActionUpdate(Sender: TObject);
    procedure MoveLayerDownActionUpdate(Sender: TObject);
    procedure LayerSelectedUpdate(Sender: TObject);
    procedure AddRangeActionExecute(Sender: TObject);
    procedure AddDecimationActionExecute(Sender: TObject);
    procedure MarkerListDblClick(Sender: TObject);
  private
  public
    procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  ToolForm: TToolForm;

implementation

uses Matching, presetimport, Contnrs, ScriptPreview;

{$R *.dfm}

procedure TToolForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent := HWND_DESKTOP; // More elegant than 0
end;

procedure TToolForm.PresetListClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to SectionList.Count - 1 do
    if SectionList.Selected[I] then
      with (PresetList.DataSource as TPresetList)[PresetList.ItemIndex] do
        (SectionList.DataSource as TSectionList)[I].Preset := Id;
end;

procedure TToolForm.SectionListData(Control: TWinControl; Index: Integer;
  var Data: string);
begin
  if (SectionSelect.ItemIndex >= 0) then
    with (SectionList.DataSource as TSectionList)[Index] do
      Data := Format('#%d, %s', [StartFrame, (PresetList.DataSource as TPresetList).GetPresetNameById(Preset)]);
end;

procedure TToolForm.LayerListData(Control: TWinControl; Index: Integer;
  var Data: string);
var
  Entry: TLayerBaseList;
begin
  Entry := LayerList.DataSource[Index] as TLayerBaseList;

  if Entry is TSectionList then
    Data := Entry.Name + ' (Sections)'
  else if Entry is TRangeList then
    Data := Entry.Name + ' (Ranges)'
  else if Entry is TListDelimiter then
    Data := '<Matching>';
end;

procedure TToolForm.PresetSelectChange(Sender: TObject);
begin
  PresetEditText.Text := (PresetList.DataSource as TPresetList)[PresetSelect.ItemIndex].Chain
end;

procedure TToolForm.PresetListData(Control: TWinControl; Index: Integer;
  var Data: string);
begin
  with (PresetList.DataSource as TPresetList)[Index] do
    Data := Name;
end;

procedure TToolForm.DecimateListData(Control: TWinControl; Index: Integer;
  var Data: string);
begin
  with (DecimateList.DataSource as TDecimationMarkerList)[Index] do
    Data := Format('#%d %d:%d', [StartFrame, M, N]);
end;

procedure TToolForm.FreezeFrameListData(Control: TWinControl; Index: Integer;
  var Data: string);
begin
  with (FreezeFrameList.DataSource as TFreezeFrameMarkerList)[Index] do
    Data := Format('%d,%d,%d', [StartFrame, EndFrame, ReplaceFrame]);
end;

procedure TToolForm.DecimateListClick(Sender: TObject);
begin
  if DecimateList.ItemIndex >= 0 then
    with DecimateList.DataSource[DecimateList.ItemIndex] as TDecimationMarker do
      MinN.Text := Format('%d:%d', [M, N]);
end;

procedure TToolForm.PresetEditTextChange(Sender: TObject);
begin
  if AutoUpdatePreset.Checked then
    UpdatePresetAction.Execute;
end;

procedure TToolForm.SectionSelectSelect(Sender: TObject);
begin
  if (SectionSelect.ItemIndex >= 0) and (Project.Layers.Items[SectionSelect.ItemIndex] is TSectionList) then
    Project.Layers.Items[SectionSelect.ItemIndex].View := SectionList;
end;

procedure TToolForm.PreviewAvsClick(Sender: TObject);
begin
  ScriptPreviewForm.Script.Clear;
  try
    Project.GenerateAvisynthScript(ScriptPreviewForm.Script.Lines, [soLoadPlugin]);
    ScriptPreviewForm.Show;
  except on E: EYattaProjectException do
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
      ScriptPreviewForm.Hide;
    end;
  end;
end;

procedure TToolForm.SectionSelectDropDown(Sender: TObject);
begin
  if SectionSelect.ItemIndex >= 0 then
    Project.Layers.Items[SectionSelect.ItemIndex].View := nil;
  SectionSelect.Items.Assign(LayerList.Items);
end;

procedure TToolForm.LayerListClick(Sender: TObject);
begin
  if (LayerList.ItemIndex >= 0) and ((LayerList.DataSource as TLayerList)[LayerList.ItemIndex] is TRangeList) then
    with ((LayerList.DataSource as TLayerList)[LayerList.ItemIndex] as TRangeList) do
    begin
      (LayerList.DataSource as TLayerList).ClearEvents(ltRangeList);
      View := RangesList;
      RangeProcessText.Text := Processing;
    end;
end;

procedure TToolForm.RangesListDblClick(Sender: TObject);
begin
  if (RangesList.ItemIndex >= 0) then
    with (RangesList.DataSource as TRangeList)[RangesList.ItemIndex] do
      MatchForm.FrameTrackBar.Position := StartFrame;
end;

procedure TToolForm.RangesListData(Control: TWinControl; Index: Integer;
  var Data: string);
begin
  with (RangesList.DataSource as TRangeList)[Index] do
    Data := Format('%d,%d', [StartFrame, EndFrame]);
end;

procedure TToolForm.RangeProcessTextChange(Sender: TObject);
begin
  if RangesList.DataSource <> nil then
    (RangesList.DataSource as TRangeList).Processing := RangeProcessText.Text;
end;

procedure TToolForm.PresetSelectDropDown(Sender: TObject);
begin
  PresetSelect.Items.Assign(PresetList.Items);
end;

procedure TToolForm.AddFreezeFrameClick(Sender: TObject);
begin
//(FreezeFrameList.DataSource as TFreezeFrameMarkerList)
end;

procedure TToolForm.AddSectionActionExecute(Sender: TObject);
begin
  MatchForm.AddSectionAction.OnExecute(Sender);
end;

procedure TToolForm.AddFreezeFrameActionExecute(Sender: TObject);
begin
  MatchForm.AddFreezeFrameAction.OnExecute(Sender);
end;

procedure TToolForm.DeleteSectionActionExecute(Sender: TObject);
var
  I: Integer;
begin
  if (SectionList.DataSource <> nil) and (SectionList.ItemIndex >= 0) then
  begin
    for I := SectionList.Count - 1 downto 0 do
      if SectionList.Selected[I] then
        (SectionList.DataSource as TSectionList).Delete(I);
  end;
end;

procedure TToolForm.DeleteDecimationActionExecute(Sender: TObject);
var
  I: Integer;
begin
  for I := DecimateList.Count - 1 downto 0 do
    if DecimateList.Selected[I] then
      (DecimateList.DataSource as TDecimationMarkerList).Delete(I);
end;

procedure TToolForm.DeleteFreezeFrameActionExecute(Sender: TObject);
var
  I: Integer;
begin
  for I := FreezeFrameList.Count - 1 downto 0 do
    if FreezeFrameList.Selected[I] then
      (FreezeFrameList.DataSource as TFreezeFrameMarkerList).Delete(I);
end;

procedure TToolForm.MoveLayerUpActionExecute(Sender: TObject);
begin
  (LayerList.DataSource as TLayerList).Exchange(LayerList.ItemIndex, LayerList.ItemIndex - 1);
  LayerList.ItemIndex := LayerList.ItemIndex - 1;
end;

procedure TToolForm.MoveLayerDownActionExecute(Sender: TObject);
begin
  (LayerList.DataSource as TLayerList).Exchange(LayerList.ItemIndex, LayerList.ItemIndex + 1);
  LayerList.ItemIndex := LayerList.ItemIndex + 1;
end;

procedure TToolForm.AddSectionListActionExecute(Sender: TObject);
var
  Name: string;
begin
  Name := '';
  if InputQuery('New Layer', 'Name', Name) and (Name <> '') then
    if AnsiContainsStr(Name, ',') then
      MessageDlg('Commas aren''t allowed in layer names', mtError, [mbOK], 0)
    else
      (LayerList.DataSource as TLayerList).Add(Name, ltSectionList);
end;

procedure TToolForm.AddRangeListActionExecute(Sender: TObject);
var
  Name: string;
begin
  if InputQuery('New Layer', 'Name', Name) and (Name <> '') then
    if AnsiContainsStr(Name, ',') then
      MessageDlg('Commas aren''t allowed in layer names', mtError, [mbOK], 0)
    else
      (LayerList.DataSource as TLayerList).Add(Name, ltRangeList);
end;

procedure TToolForm.DeleteLayerActionExecute(Sender: TObject);
begin
  if LayerList.ItemIndex >= 0 then
    (LayerList.DataSource as TLayerList).Delete(LayerList.ItemIndex);
end;

procedure TToolForm.RenameLayerActionExecute(Sender: TObject);
var
  Name: string;
begin
  with (LayerList.DataSource as TLayerList) do
    if (LayerList.ItemIndex >= 0) and not (Items[LayerList.ItemIndex] is TListDelimiter) then
    begin
      Name := Items[LayerList.ItemIndex].Name;

      if InputQuery('Rename Layer', 'Name', Name) and (Name <> '') and (Name <> Items[LayerList.ItemIndex].Name) then
        if AnsiContainsStr(Name, ',') then
          MessageDlg('Commas aren''t allowed in layer names', mtError, [mbOK], 0)
        else
          Items[LayerList.ItemIndex].Name := Name;
    end;
end;

procedure TToolForm.DeleteRangeActionExecute(Sender: TObject);
var
  I: Integer;
begin
  if (RangesList.DataSource <> nil) then
    with RangesList.DataSource as TRangeList do
    begin
      for I := Count - 1 downto 0 do
        if RangesList.Selected[I] then
          Delete(I);
    end;
end;

procedure TToolForm.RangeUpButtonClick(Sender: TObject);
begin
  if RangesList.ItemIndex >= 1 then
  begin
    (RangesList.DataSource as TRangeList).Exchange(RangesList.ItemIndex, RangesList.ItemIndex - 1);
    RangesList.ItemIndex := RangesList.ItemIndex - 1;
  end;
end;

procedure TToolForm.RangeDownButtonClick(Sender: TObject);
begin
  if (RangesList.ItemIndex >= 0) and (RangesList.ItemIndex + 1 < RangesList.Count) then
  begin
    (RangesList.DataSource as TRangeList).Exchange(RangesList.ItemIndex, RangesList.ItemIndex + 1);
    RangesList.ItemIndex := RangesList.ItemIndex + 1;
  end;
end;

procedure TToolForm.RenamePresetActionExecute(Sender: TObject);
var
  Name: string;
begin
  Name := (PresetSelect.Items.Objects[PresetSelect.ItemIndex] as TPreset).Name;
  if InputQuery('New Preset', 'Name:', Name) and (Name <> '') then
    if AnsiContainsStr(Name, ',') then
      MessageDlg('Commas aren''t allowed in preset names', mtError, [mbOK], 0)
    else
      (PresetSelect.Items.Objects[PresetSelect.ItemIndex] as TPreset).Name := Name;
end;

procedure TToolForm.UpdatePresetActionExecute(Sender: TObject);
begin
  (PresetList.DataSource as TPresetList)[PresetSelect.ItemIndex].Chain := PresetEditText.Text;
end;

procedure TToolForm.NewPresetActionExecute(Sender: TObject);
var
  Name: string;
begin
  Name := '';
  if InputQuery('New Preset', 'Name:', Name) and (Name <> '') then
    if AnsiContainsStr(Name, ',') then
      MessageDlg('Commas aren''t allowed in preset names', mtError, [mbOK], 0)
    else
      (PresetList.DataSource as TPresetList).Add(Name, PresetEditText.Text);
end;

procedure TToolForm.PresetSelectedUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := PresetSelect.ItemIndex >= 0;
end;

procedure TToolForm.DeletePresetActionExecute(Sender: TObject);
begin
  (PresetList.DataSource as TPresetList).Delete(PresetSelect.ItemIndex);
  PresetSelect.Items.Assign(PresetList.Items);
end;

procedure TToolForm.MoveLayerUpActionUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := LayerList.ItemIndex >= 1;
end;

procedure TToolForm.MoveLayerDownActionUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := (LayerList.ItemIndex >= 0) and (LayerList.ItemIndex + 1 < LayerList.Count)
end;

procedure TToolForm.LayerSelectedUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := LayerList.ItemIndex >= 0;
end;

procedure TToolForm.AddRangeActionExecute(Sender: TObject);
begin
  MatchForm.AddRangeAction.OnExecute(Sender);
end;

procedure TToolForm.AddDecimationActionExecute(Sender: TObject);
begin
  MatchForm.AddDecimationAction.OnExecute(Sender);
end;

procedure TToolForm.MarkerListDblClick(Sender: TObject);
var
  ListBox: TViewListBox;
begin
  ListBox := (Sender as TViewListBox);
  with ListBox.DataSource as TMarkerList do
    MatchForm.FrameTrackBar.Position := Items[ListBox.ItemIndex].StartFrame;
end;

end.

