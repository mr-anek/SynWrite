unit unMenuPy;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  TntStdCtrls, TntForms, TntClasses, DKLang;

type
  TSynPyMenuStyle = (cSynPyMenuSingle, cSynPyMenuDouble);

type
  TfmMenuPy = class(TTntForm)
    List: TTntListBox;
    Edit: TTntEdit;
    TimerType: TTimer;
    Panel1: TPanel;
    LabelInfo: TTntLabel;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure ListDblClick(Sender: TObject);
    procedure EditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditChange(Sender: TObject);
    procedure TimerTypeTimer(Sender: TObject);
    procedure ListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure TntFormResize(Sender: TObject);
    procedure TntFormCreate(Sender: TObject);
    procedure TntFormClose(Sender: TObject; var Action: TCloseAction);
    procedure ListKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    FFuzzy: boolean;
    procedure DoFilter;
  public
    { Public declarations }
    FIniFN: string;
    FColorSel: TColor;
    FColorSelBk: TColor;
    FListItems: TTntStringList;
    FListStyle: TSynPyMenuStyle;
    FInitFocusedIndex: integer;
  end;

implementation

uses
  TntSysUtils,
  TntWideStrings,
  Math,
  IniFiles,
  ecUnicode,
  ecStrUtils,
  unProc,
  ATxSProc;

{$R *.dfm}

procedure TfmMenuPy.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //Esc
  if (Key=vk_escape) and (Shift=[]) then
  begin
    ModalResult:= mrCancel;
    Key:= 0;
    Exit
  end;
  //Enter
  if (Key=vk_return) and (Shift=[]) then
  begin
    if List.ItemIndex>=0 then
      ModalResult:= mrOk;
    Key:= 0;
    Exit
  end;
  //F4
  if (Key=vk_f4) and (Shift=[]) then
  begin
    FFuzzy:= not FFuzzy;
    DoFilter;
    Key:= 0;
    Exit
  end;
end;

procedure TfmMenuPy.FormShow(Sender: TObject);
var
  NFocused: integer;
begin
  case FListStyle of
    cSynPyMenuSingle: List.ItemHeight:= FontHeightToItemHeight(Font);
    cSynPyMenuDouble: List.ItemHeight:= FontHeightToItemHeight(Font)*2;
  end;

  DoFilter;

  if (FInitFocusedIndex>=0) and (FInitFocusedIndex<List.Count) then
    List.ItemIndex:= FInitFocusedIndex;

  if FIniFN<>'' then
  with TIniFile.Create(FIniFN) do
  try
    FFuzzy:= ReadBool('Win', 'PyListFuzzy', false);
  finally
    Free
  end;

  LabelInfo.Caption:= WideFormat(' F4: %s',
    [DKLangConstW('zMHintFuzzy')]);
end;

procedure TfmMenuPy.DoFilter;
  //----------------
  function SFiltered(const Str: Widestring): boolean;
  var
    SFilter,
    SItem, SItemName: Widestring;
    IsFuzzy: boolean;
  begin
    SFilter:= Edit.Text;
    IsFuzzy:= FFuzzy;

    SItem:= Str;
    SItemName:= SGetItem(SItem, #9);

    if IsFuzzy then
      Result:= SFuzzyMatch(SItemName, SFilter)
    else
      Result:= SSubstringMatch(SItemName, SFilter);
  end;
  //----------------
var
  i: Integer;
  S: Widestring;
begin
  if not Assigned(FListItems) then
    raise Exception.Create('File list not passed to form');

  List.Items.BeginUpdate;
  Screen.Cursor:= crHourGlass;
  try
    List.Items.Clear;
    for i:= 0 to FListItems.Count-1 do
    begin
      S:= FListItems[i];
      if SFiltered(S) then
        List.Items.AddObject(S, Pointer(i));
    end;
  finally
    Screen.Cursor:= crDefault;
    List.Items.EndUpdate;
  end;

  List.ItemIndex:= 0;
end;

procedure TfmMenuPy.ListDblClick(Sender: TObject);
begin
  if List.ItemIndex>=0 then
    ModalResult:= mrOk;
end;

procedure TfmMenuPy.EditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (((Key=vk_prior) or (Key=vk_next) or (key=vk_up) or (key=vk_down)) and (Shift=[])) or
    (((key=vk_home) or (key=vk_end)) and (Shift=[ssCtrl])) then
    begin
      List.Perform(wm_keydown, key, 0);
      Key:= 0;
      Exit
    end;
end;

procedure TfmMenuPy.EditChange(Sender: TObject);
begin
  TimerType.Enabled:= false;
  TimerType.Enabled:= true;
end;

procedure TfmMenuPy.TimerTypeTimer(Sender: TObject);
begin
  TimerType.Enabled:= false;
  DoFilter;
end;

procedure TfmMenuPy.ListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  S, SName, SDesc: Widestring;
  i, n: Integer;
  Arr: TSynCharArray;
begin
  with Control as TTntListbox do
  begin
    if odSelected in State then
      Canvas.Brush.Color:= FColorSelBk
    else
      Canvas.Brush.Color:= Color;
    Canvas.FillRect(Rect);
    Inc(Rect.Left, 2);

    S:= Items[Index];
    SName:= SGetItem(S, #9);
    SDesc:= SGetItem(S, #9);


    //desc
    case FListStyle of
      cSynPyMenuSingle:
        begin
          Canvas.Font.Size:= Self.Font.Size;
          Canvas.Font.Color:= IfThen(odSelected in State, clYellow, clNavy);
          n:= ecTextExtent(Canvas, SDesc).cx+4;
          ecTextOut(Canvas, rect.right-n, rect.top, SDesc);
        end;
      cSynPyMenuDouble:
        begin
          //desc
          Canvas.Font.Size:= Self.Font.Size-2;
          Canvas.Font.Color:= IfThen(odSelected in State, clYellow, clNavy);
          ecTextOut(Canvas, rect.left, rect.top + List.ItemHeight div 2, SDesc);

          //separator
          Canvas.Pen.Color:= clLtGray;
          n:= rect.top+ List.ItemHeight-1;
          Canvas.MoveTo(2, n);
          Canvas.LineTo(ClientWidth-2, n);
        end;
    end;

    //name
    Canvas.Font.Size:= Self.Font.Size;
    Canvas.Font.Color:= IfThen(odSelected in State, FColorSel, Font.Color);
    ecTextOut(Canvas, rect.left, rect.top, SName);

    //filter chars
    if FFuzzy then
    begin
      Canvas.Font.Size:= Self.Font.Size;
      Canvas.Font.Color:= IfThen(odSelected in State, clYellow, clBlue);
      SGetCharArray(SName, Edit.Text, Arr);
      for i:= Low(Arr) to High(Arr) do
        if Arr[i]>0 then
        begin
          n:= ecTextExtent(Canvas, Copy(SName, 1, Arr[i]-1)).cx;
          ecTextOut(Canvas, rect.left+n, rect.top, Copy(SName, Arr[i], 1));
        end
        else
          Break;
    end;
  end;
end;

procedure TfmMenuPy.TntFormResize(Sender: TObject);
begin
  List.Invalidate;
end;

procedure TfmMenuPy.TntFormCreate(Sender: TObject);
begin
  List.ItemHeight:= ScaleFontSize(List.ItemHeight, Self);
end;

procedure TfmMenuPy.TntFormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if FIniFN<>'' then
  with TIniFile.Create(FIniFN) do
  try
    WriteBool('Win', 'PyListFuzzy', FFuzzy);
  finally
    Free
  end;
end;

procedure TfmMenuPy.ListKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key=vk_up) and (List.ItemIndex=0) then
  begin
    List.ItemIndex:= List.Items.Count-1;
    Key:= 0;
    Exit
  end;
  if (Key=vk_down) and (List.ItemIndex=List.Items.Count-1) then
  begin
    List.ItemIndex:= 0;
    Key:= 0;
    Exit
  end;
end;

end.
