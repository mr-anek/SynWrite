unit unLexerLib;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  TntForms,
  Dialogs, StdCtrls, Buttons, ActnList, ImgList, ToolWin,
  CheckLst, ComCtrls,
  ecSyntAnal, DKLang, TntCheckLst;

type
  TfmLexerLibrary = class(TTntForm)
    ToolBar1: TToolBar;
    ImageList1: TImageList;
    ActionList1: TActionList;
    actOpenLib: TAction;
    actSaveLib: TAction;
    actLexerProps: TAction;
    actImportLexer: TAction;
    actExportLexer: TAction;
    actDeleteLexer: TAction;
    actNewLexer: TAction;
    btnOpen: TToolButton;
    btnSaveAs: TToolButton;
    btnNew: TToolButton;
    btnConf: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    btnImport: TToolButton;
    btnExport: TToolButton;
    btnDelete: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    actClose: TAction;
    btnClose: TToolButton;
    ToolButton13: TToolButton;
    DlgOpenLib: TOpenDialog;
    DlgSaveLib: TSaveDialog;
    DlgOpenLexer: TOpenDialog;
    DlgSaveLexer: TSaveDialog;
    btnCopy: TToolButton;
    ToolButton16: TToolButton;
    actCopy: TAction;
    actClear: TAction;
    btnClear: TToolButton;
    DKLanguageController1: TDKLanguageController;
    LV: TTntCheckListBox;
    procedure actLexerPropsUpdate(Sender: TObject);
    procedure actOpenLibExecute(Sender: TObject);
    procedure actSaveLibExecute(Sender: TObject);
    procedure actImportLexerExecute(Sender: TObject);
    procedure actLexerPropsExecute(Sender: TObject);
    procedure actExportLexerExecute(Sender: TObject);
    procedure actNewLexerExecute(Sender: TObject);
    procedure actDeleteLexerExecute(Sender: TObject);
    procedure actCloseExecute(Sender: TObject);
    procedure actCopyExecute(Sender: TObject);
    procedure actClearUpdate(Sender: TObject);
    procedure actClearExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure LVClickCheck(Sender: TObject);
    procedure TntFormCreate(Sender: TObject);
  private
    FLexLib: TSyntaxManager;
    procedure UpdateTitle;
    procedure UpdateList;
  public
  end;

procedure DoCustomizeLexerLibrary(LexerLib: TSyntaxManager);

implementation

uses
  StrUtils, unProc;

{$R *.dfm}

procedure DoCustomizeLexerLibrary(LexerLib: TSyntaxManager);
begin
  with TfmLexerLibrary.Create(nil) do
  try
    FLexLib:= LexerLib;
    ShowModal;
  finally
    Free;
  end;
end;

procedure TfmLexerLibrary.FormShow(Sender: TObject);
begin
  UpdateList;
end;

procedure TfmLexerLibrary.actCloseExecute(Sender: TObject);
begin
  Close;
end;

procedure TfmLexerLibrary.actLexerPropsUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled:= LV.ItemIndex>=0;
end;

function LexerNameWithLinks(an: TSyntAnalyzer): Widestring;
var
  sl: TStringList;
  i: integer;
begin
  Result:= an.LexerName;

  sl:= TStringList.Create;
  try
    sl.Duplicates:= dupIgnore;
    sl.Sorted:= true;
    
    for i:= 0 to an.SubAnalyzers.Count-1 do
    begin
      if an.SubAnalyzers[i].SyntAnalyzer=nil then
      begin
        Result:= an.LexerName + '   (' + DKLangConstW('zMLexerLinkBroken') + ')';
        Exit
      end;
      sl.Add(an.SubAnalyzers[i].SyntAnalyzer.LexerName);
    end;

    for i:= 0 to sl.Count-1 do
    begin
      if i=0 then
        Result:= Result + '   ('+DKLangConstW('zMLexerLinks') + ': ';
      Result:= Result + sl[i] + IfThen(i<sl.Count-1, ', ', ')');
    end;
  finally
    FreeAndNil(sl);
  end;    
end;

procedure TfmLexerLibrary.UpdateList;
var
  i, cur: Integer;
  sl: TStringList;
  an: TSyntAnalyzer;
begin
  UpdateTitle;
  sl:= TStringList.Create;
  try
    sl.Duplicates:= dupAccept;
    sl.Sorted:= true;
    for i:= 0 to FLexLib.AnalyzerCount-1 do
      sl.AddObject(FLexLib.Analyzers[i].LexerName, FLexLib.Analyzers[i]);

    LV.Items.BeginUpdate;
    try
      cur:= LV.ItemIndex;
      LV.Items.Clear;
      for i:= 0 to sl.Count-1 do
      begin
        an:= sl.Objects[i] as TSyntAnalyzer;
        LV.Items.AddObject(LexerNameWithLinks(an), an);
        LV.Checked[LV.Items.Count-1]:= not an.Internal;
      end;
      //restore ItemIndex
      if cur>=LV.Items.Count then
        cur:= LV.Items.Count-1;
      LV.ItemIndex:= cur;
    finally
      LV.Items.EndUpdate;
    end;
  finally
    FreeAndNil(sl);
  end;  
end;

procedure TfmLexerLibrary.actOpenLibExecute(Sender: TObject);
begin
  if FLexLib.FileName<>'' then
  begin
    DlgOpenLib.InitialDir:= ExtractFileDir(FLexLib.FileName);
    DlgOpenLib.FileName:= ExtractFileName(FLexLib.FileName);
  end;

  if DlgOpenLib.Execute then
  begin
    FLexLib.LoadFromFile(DlgOpenLib.FileName);
    UpdateList;
  end;
end;

procedure TfmLexerLibrary.actSaveLibExecute(Sender: TObject);
begin
  if FLexLib.FileName <> '' then
  begin
    DlgSaveLib.InitialDir:= ExtractFileDir(FLexLib.FileName);
    DlgSaveLib.FileName:= ExtractFileName(FLexLib.FileName);
  end;

  if DlgSaveLib.Execute then
  begin
    FLexLib.SaveToFile(DlgSaveLib.FileName);
    UpdateTitle;
  end;
end;

procedure TfmLexerLibrary.actImportLexerExecute(Sender: TObject);
var
  an: TSyntAnalyzer;
begin
  if DlgOpenLexer.Execute then
  begin
    an:= FLexLib.AddAnalyzer;
    try
      an.LoadFromFile(DlgOpenLexer.FileName);
    except
      FreeAndNil(an);
    end;
    UpdateList;
  end;
end;

procedure TfmLexerLibrary.actLexerPropsExecute(Sender: TObject);
var
  an: TSyntAnalyzer;
begin
  if LV.ItemIndex>=0 then
  begin
    an:= LV.Items.Objects[LV.ItemIndex] as TSyntAnalyzer;
    if an.CustomizeLexer then
    begin
      LV.Items[LV.ItemIndex]:= LexerNameWithLinks(an);
      FLexLib.Modified:= True;
    end;
  end;
end;

procedure TfmLexerLibrary.actExportLexerExecute(Sender: TObject);
var
  S: string;
begin
  if LV.ItemIndex>=0 then
  begin
    S:= LV.Items[LV.ItemIndex];
    S:= StringReplace(S, '/', '_', [rfReplaceAll]);
    S:= StringReplace(S, '\', '_', [rfReplaceAll]);
    S:= StringReplace(S, ':', '_', [rfReplaceAll]);
    S:= StringReplace(S, '|', '_', [rfReplaceAll]);
    DlgSaveLexer.FileName:= S;
    if DlgSaveLexer.Execute then
      (LV.Items.Objects[LV.ItemIndex] as TSyntAnalyzer).SaveToFile(DlgSaveLexer.FileName);
  end;
end;

procedure TfmLexerLibrary.actNewLexerExecute(Sender: TObject);
var
  an: TSyntAnalyzer;
begin
  an:= FLexLib.AddAnalyzer;
  if an.CustomizeLexer then
    UpdateList
  else
    FreeAndNil(an);
end;

procedure TfmLexerLibrary.actDeleteLexerExecute(Sender: TObject);
begin
  if (LV.ItemIndex>=0) then
    if MsgConfirm(DKLangConstW('MDLex'), Handle) then
    begin
      LV.Items.Objects[LV.ItemIndex].Free;
      FLexLib.Modified:= True;
      UpdateList;
    end;
end;

procedure TfmLexerLibrary.actCopyExecute(Sender: TObject);
var
  an, anPrev: TSyntAnalyzer;
begin
  if LV.ItemIndex>=0 then
  begin
    anPrev:= LV.Items.Objects[LV.ItemIndex] as TSyntAnalyzer;
    an:= FLexLib.AddAnalyzer;
    an.Assign(anPrev);
    an.LexerName:= anPrev.LexerName+' (copy)';
    LV.Items.AddObject(an.LexerName, an);
    LV.Checked[LV.Items.Count-1]:= not an.Internal;
    UpdateList;
  end;
end;

procedure TfmLexerLibrary.actClearUpdate(Sender: TObject);
begin
  actClear.Enabled:= FLexLib.AnalyzerCount > 0;
end;

procedure TfmLexerLibrary.actClearExecute(Sender: TObject);
begin
  if MsgConfirm(DKLangConstW('MDLexx'), Handle) then
  begin
    FLexLib.Clear;
    UpdateList;
  end;
end;

procedure TfmLexerLibrary.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key=vk_delete) and (Shift=[]) then
    if LV.ItemIndex>=0 then
    begin
      actDeleteLexer.Execute;
      Key:= 0;
      Exit
    end;

  if (Key=vk_escape) and (Shift=[]) then
  begin
    Close;
    Key:= 0;
    Exit
  end;  
end;

procedure TfmLexerLibrary.UpdateTitle;
begin
  Caption:= DKLangConstW('zMLexerLib') + ' - '+ ExtractFileName(FLexLib.FileName);
end;

procedure TfmLexerLibrary.LVClickCheck(Sender: TObject);
var
  an: TSyntAnalyzer;
begin
  if LV.ItemIndex>=0 then
  begin
    an:= LV.Items.Objects[LV.ItemIndex] as TSyntAnalyzer;
    an.Internal:= not LV.Checked[LV.ItemIndex];
    FLexLib.Modified:= True;
  end;
end;

procedure TfmLexerLibrary.TntFormCreate(Sender: TObject);
begin
  DlgOpenLib.DefaultExt:= 'lxl';
  DlgSaveLib.DefaultExt:= 'lxl';
  DlgOpenLexer.DefaultExt:= 'lcf';
  DlgSaveLexer.DefaultExt:= 'lcf';

  DlgOpenLib.Filter:= '*.lxl|*.lxl';
  DlgSaveLib.Filter:= DlgOpenLib.Filter;

  DlgOpenLexer.Filter:= '*.lcf|*.lcf';
  DlgSaveLexer.Filter:= DlgOpenLexer.Filter;
end;

end.

