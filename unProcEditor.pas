unit unProcEditor;

interface

uses
  Classes,
  TntClasses,
  Types,
  Forms,
  Graphics,

  ecSyntAnal,
  ecSyntMemo,
  ATSyntMemo,
  ecMemoStrings,
  ecStrUtils,
  ecPrint,
  unGlobData;

function LexerCommentsProperty(const ALexerName, AKey: string): string;
  
procedure LexerEnumSublexers(An: TSyntAnalyzer; List: TTntStringList);
procedure LexerEnumStyles(An: TSyntAnalyzer; List: TTntStringList);
procedure LexerSetSublexers(SyntaxManager: TSyntaxManager; An: TSyntAnalyzer; const Links: string);

function EditorGetWordLengthForSpellCheck(Ed: TSyntaxMemo; APos: Integer): Integer;
function EditorGotoModifiedLine(Ed: TSyntaxMemo; ANext: boolean; ASavedToo: boolean): boolean;
procedure EditorPrint(Ed: TSyntaxMemo; ASelOnly: boolean;
  const ATitle: string; APrinter: TecSyntPrinter);
function EditorGetBlockStaple(Ed: TSyntaxMemo; PosX, PosY: Integer): TBlockStaple;
function EditorGetColorPropertyById(Ed: TSyntaxMemo; const Id: string): Longint;
procedure EditorSetColorPropertyById(Ed: TSyntaxMemo; const Id: string; Color: Longint);

type
  TATCaretShape = (
    cCrVert1px,
    cCrVert2px,
    cCrVert3px,
    cCrVertHalf,
    cCrFull,
    cCrHorz1px,
    cCrHorz2px,
    cCrHorz20perc,
    cCrHorzHalf
    );
const
  cCaretDesc: array[TATCaretShape] of string = (
    '| 1px',
    '| 2px',
    '| 3px',
    '| 50%',
    '100%',
    '_ 1px',
    '_ 2px',
    '_ 20%',
    '_ 50%'
    );

procedure EditorSetCaretShape(Ed: TSyntaxMemo; AShape: TATCaretShape; AInsMode: boolean);

procedure EditorUnderlineColorItem(Ed: TSyntaxMemo;
  const StrItem: Widestring;
  NLine, NPosStart, NPosEnd, NUnderSize: Integer);

const
  cRegexColorRgb = '\bRGBA?\s*\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*\,?\s*(\d*\.?\d+)?\s*\)';

procedure EditorInsertColorCode(Ed: TSyntaxMemo; Code: Integer);
procedure EditorGetColorCodeRange(Ed: TSyntaxMemo; var NStart, NEnd: integer; var NColor: integer);

function EditorGetTokenName(Ed: TSyntaxMemo; StartPos, EndPos: integer): string;
procedure EditorGetTokenType(Ed: TSyntaxMemo; StartPos, EndPos: Integer;
  var IsCmt, IsStr: boolean);

procedure EditorBookmarkCommand(Ed: TSyntaxMemo; NCmd, NPos, NIcon, NColor: Integer; const SHint: string);
//^-- deprecated, delete ltr
procedure EditorBookmarkAddWithTag(Ed: TSyntaxMemo; NTag, NPos, NIcon, NColor: Integer; const SHint: string);
procedure EditorClearBookmarks(Ed: TSyntaxMemo);
procedure EditorSetBookmarkUnnumbered(Ed: TSyntaxMemo; NPos, NIcon, NColor: Integer; const SHint: string);
function EditorGetBookmarkDesc(Ed: TSyntaxMemo;
  AIndex: Integer;
  ALenLimit: Integer = 30;
  AShowLineNum: boolean = false;
  AShowNumberedChar: boolean = false): WideString;

procedure FixLineEnds(var S: Widestring; ATextFormat: TTextFormat);
procedure FixLineEnds_AtEnd(var S: Widestring; Ed: TSyntaxMemo);
function EditorGetBottomLineIndex(Ed: TSyntaxMemo): Integer;
function EditorGetWordBeforeCaret(Ed: TSyntaxMemo; AllowDot: boolean): Widestring;
procedure EditorInsertSnippet(Ed: TSyntaxMemo; const AText, ASelText, AFilename: Widestring);

function EditorMouseCursorOnNumbers(Ed: TSyntaxMemo): boolean;
function EditorIndentStringForLine(Ed: TSyntaxMemo; Line: Integer): Widestring;
function EditorIndentStringForPos(Ed: TSyntaxMemo; PntPos: TPoint): Widestring;
procedure EditorUpdateCaretPosFromMousePos(Ed: TSyntaxMemo);
procedure EditorJumpToLastMarker(Ed: TSyntaxMemo);
procedure EditorJumpSelectionStartEnd(Ed: TSyntaxMemo);
function EditorJumpBlankLine(Ed: TSyntaxMemo; AOffsetTop: Integer; ANext: boolean): boolean;
procedure EditorSelectOrJumpToWordEnd(Ed: TSyntaxMemo; ASelect: boolean);
procedure EditorSelectParagraph(Ed: TSyntaxMemo);
  
procedure EditorSetSelCoordAsString(Ed: TSyntaxMemo; const Str: string);
function EditorGetSelCoordAsString(Ed: TSyntaxMemo): string;
procedure EditorSetBookmarksAsString(Ed: TCustomSyntaxMemo; const Str: string);
function EditorGetBookmarksAsString(Ed: TCustomSyntaxMemo): string;
procedure EditorGetBookmarksAsSortedList(Ed: TSyntaxMemo; L: TList);
procedure EditorGetBookmarksAsSortedList_Ex(Ed: TSyntaxMemo; L: TList);

function EditorPasteAsColumnBlock(Ed: TSyntaxMemo): boolean;
procedure EditorPasteToFirstColumn(Ed: TSyntaxMemo);
procedure EditorPasteNoCaretChange(Ed: TSyntaxMemo);
procedure EditorCopyAsRtf(Ed: TSyntaxMemo);
procedure EditorCopyAsHtml(Ed: TSyntaxMemo);
procedure EditorCopyOrCutCurrentLine(Ed: TSyntaxMemo; ACut: boolean);
procedure EditorCopyOrCutAndAppend(Ed: TSyntaxMemo; ACut: boolean);

procedure EditorClearMarkers(Ed: TSyntaxMemo);
function EditorAutoCloseBracket(Ed: TSyntaxMemo; ch: Widechar;
  opAutoCloseBrackets,
  opAutoCloseQuotes1,
  opAutoCloseQuotes2,
  opAutoCloseBracketsNoEsc: boolean): boolean;
procedure EditorDeleteToFileBegin(Ed: TSyntaxMemo);
procedure EditorDeleteToFileEnd(Ed: TSyntaxMemo);
procedure EditorJoinLines(Ed: TSyntaxMemo);
procedure EditorMoveCaretByNChars(Ed: TSyntaxMemo; DX, DY: Integer);
function EditorToggleSyncEditing(Ed: TSyntaxMemo): boolean;
procedure EditorKeepCaretOnScreen(Ed: TSyntaxMemo);
procedure EditorDoHomeKey(Ed: TSyntaxMemo);
procedure EditorInsertBlankLineAboveOrBelow(Ed: TSyntaxMemo; ABelow: boolean);
procedure EditorPasteAndSelect(Ed: TSyntaxMemo);

procedure EditorExtendSelectionByLexer_All(Ed: TSyntaxMemo; var Err: string);
procedure EditorExtendSelectionByLexer_HTML(Ed: TSyntaxMemo);
procedure EditorExtendSelectionByOneLine(Ed: TSyntaxMemo);
procedure EditorExtendSelectionByPosition(Ed: TSyntaxMemo;
  AOldStart, AOldLength, ANewStart, ANewLength: integer);

procedure EditorSplitLinesByPosition(Ed: TSyntaxMemo; nCol: Integer);
procedure EditorScrollToSelection(Ed: TSyntaxMemo; NSearchOffsetY: Integer);
function EditorDeleteSelectedLines(Ed: TSyntaxMemo): Integer;
function EditorEOL(Ed: TCustomSyntaxMemo): Widestring;
procedure EditorFillBlockRect(Ed: TSyntaxMemo; SData: Widestring; bKeep: boolean);

function EditorCurrentAnalyzerForPos(Ed: TSyntaxMemo; NPos: integer): TSyntAnalyzer;
function EditorCurrentLexerForPos(Ed: TSyntaxMemo; NPos: integer): string;

function EditorTokenString(Ed: TSyntaxMemo; TokenIndex: Integer): Widestring;
function EditorTokenFullString(Ed: TSyntaxMemo; TokenIndex: Integer; IsDotNeeded: boolean): Widestring;
procedure EditorFoldLevel(Ed: TSyntaxMemo; NLevel: Integer);
function EditorSelectToken(Ed: TSyntaxMemo; SkipQuotes: boolean = false): boolean;
procedure EditorMarkSelStart(Ed: TSyntaxMemo);
procedure EditorMarkSelEnd(Ed: TSyntaxMemo);

type
  TSynEditorInsertMode = (mTxt, mNum, mBul);
  TSynEditorInsertPos = (pCol, pAfterSp, pAfterStr);

type
  TSynHintEvent = procedure(Msg: Widestring) of object;
  TSynScrollLineTo = (cScrollToTop, cScrollToBottom, cScrollToMiddle);

procedure EditorScrollCurrentLineTo(Ed: TSyntaxMemo; Mode: TSynScrollLineTo);
procedure EditorDuplicateLine(Ed: TSyntaxMemo);
procedure EditorDeleteLine(Ed: TSyntaxMemo; NLine: integer; AUndo: boolean);
procedure EditorReplaceLine(Ed: TSyntaxMemo; NLine: integer;
  const S: WideString; AUndo: boolean);

function EditorCaretAfterUnclosedQuote(Ed: TSyntaxMemo; var QuoteChar: WideChar): boolean;
function EditorNeedsHtmlOpeningBracket(Ed: TSyntaxMemo): boolean;

function EditorHasNoCaret(Ed: TSyntaxMemo): boolean;
function EditorTabSize(Ed: TSyntaxMemo): Integer;
function EditorTabExpansion(Ed: TSyntaxMemo): Widestring;

type
  TSynSelSave = record
    FSelStream: boolean;
    FSelStart, FSelEnd: TPoint;
    FSelRect: TRect;
    FCaretPos: TPoint;
  end;

procedure EditorSaveSel(Ed: TSyntaxMemo; var Sel: TSynSelSave);
procedure EditorRestoreSel(Ed: TSyntaxMemo; const Sel: TSynSelSave);


procedure EditorGetSelLines(Ed: TSyntaxMemo; var Ln1, Ln2: Integer);
function EditorHasMultilineSelection(Ed: TSyntaxMemo): boolean;
procedure EditorAddLineToEnd(Ed: TSyntaxMemo);
function EditorSelectionForGotoCommand(Ed: TSyntaxMemo): Widestring;
function EditorSelectWord(Ed: TSyntaxMemo): boolean;
procedure EditorSearchMarksToList(Ed: TSyntaxmemo; List: TTntStrings);
function EditorSelectedTextForWeb(Ed: TSyntaxMemo): Widestring;

procedure EditorSelectToPosition(Ed: TSyntaxMemo; NTo: Integer);
procedure EditorCheckCaretOverlappedByForm(Ed: TCustomSyntaxMemo; Form: TForm);
function SyntaxManagerFilesFilter(M: TSyntaxManager; const SAllText: Widestring): Widestring;

function EditorWordLength(Ed: TSyntaxMemo): Integer;
function EditorGetSelTextLimited(Ed: TSyntaxMemo; MaxLen: Integer): Widestring;
function EditorGetCollapsedRanges(Ed: TSyntaxMemo): string;
procedure EditorSetCollapsedRanges(Ed: TSyntaxMemo; S: Widestring);

procedure EditorCollapseWithNested(Ed: TSyntaxMemo; Line: Integer);
procedure EditorCollapseParentRange(Ed: TSyntaxMemo; APos: Integer);
procedure EditorUncollapseLine(Ed: TCustomSyntaxMemo; Line: Integer);
function IsEditorLineCollapsed(Ed: TCustomSyntaxMemo; Line: Integer): boolean;

procedure EditorCenterPos(Ed: TCustomSyntaxMemo; AGotoMode: boolean; NOffsetY: Integer);

type
  TSynTextCase = (
    cTextCaseUpper,
    cTextCaseLower,
    cTextCaseToggle,
    cTextCaseTitle,
    cTextCaseSent,
    cTextCaseRandom
    );

procedure EditorChangeBlockCase(Ed: TSyntaxMemo; Op: TSynTextCase);
    

implementation

uses
  Windows,
  Math,
  Clipbrd,
  Dialogs,
  TntClipbrd,
  SysUtils,
  StrUtils,
  Controls,
  TntSysUtils,
  TntWideStrUtils,
  ATxSProc,
  IniFiles,
  unProc,
  ecCmdConst,
  ecExports;

var
  _TokenLexer: string = '';
  _TokenStylesStrings: string = '';
  _TokenStylesComments: string = '';


function LexerFilenameEx(const ALexerName, AExt: string): string;
begin
  Result:= ALexerName;
  Result:= StringReplace(Result, ':', '_', [rfReplaceAll]);
  Result:= StringReplace(Result, '/', '_', [rfReplaceAll]);
  Result:= StringReplace(Result, '\', '_', [rfReplaceAll]);
  Result:= StringReplace(Result, '*', '_', [rfReplaceAll]);

  Result:= SynLexerDir+'\'+Result+AExt;
end;

function LexerFilenameMap(const ALexName: string): string;
begin
  Result:= LexerFilenameEx(ALexName, '.cuda-lexmap');
end;

function LexerCommentsProperty(const ALexerName, AKey: string): string;
begin
  with TIniFile.Create(LexerFilenameMap(ALexerName)) do
  try
    Result:= Trim(ReadString('comments', AKey, ''));
  finally
    Free
  end;
end;


procedure EditorSearchMarksToList(Ed: TSyntaxmemo; List: TTntStrings);
var
  i: Integer;
begin
  List.Clear;
  with Ed.SearchMarks do
    for i:= 0 to Count-1 do
      List.Add(Copy(Ed.Text, Items[i].StartPos+1, Items[i].Size));
end;

function EditorSelectedTextForWeb(Ed: TSyntaxMemo): Widestring;
begin
  with Ed do
    if SelLength>0 then
      Result:= SelText
    else
      Result:= WordAtPos(CaretPos);

  SReplaceAllW(Result, #13, ' ');
  SReplaceAllW(Result, #10, ' ');
  SReplaceAllW(Result, '  ', ' ');
  SReplaceAllW(Result, ' ', '+');
end;

procedure EditorSelectToPosition(Ed: TSyntaxMemo; NTo: Integer);
var
  N1, N2, NFrom: Integer;
begin
  NFrom:= Ed.CaretStrPos;
  if NFrom<=NTo then
    begin N1:= NFrom; N2:= NTo end
  else
    begin N2:= NFrom; N1:= NTo end;
  Ed.SetSelection(N1, N2-N1);
end;

procedure EditorCheckCaretOverlappedByForm(Ed: TCustomSyntaxMemo; Form: TForm);
const
  cDY = 35; //minimal offset from form's border to caret position
var
  P, P2: TPoint;
  NStart, NLen: Integer;
begin
  if Form=nil then Exit;
  P:= Ed.CaretPos;

  //uncollapse found line
  if IsEditorLineCollapsed(Ed, P.Y) then
  begin
    EditorUncollapseLine(Ed, P.Y);
    NStart:= Ed.SelStart;
    NLen:= Ed.SelLength;
    Ed.SetSelection(NStart, NLen);
  end;

  P:= Ed.CaretToMouse(P.X, P.Y);
  P:= Ed.ClientToScreen(P);
  P2:= Point(P.X, P.Y + cDY);
  //P is coord of top caret point,
  //P2 is coord of bottom caret point
  if PtInRect(Form.BoundsRect, P) or
    PtInRect(Form.BoundsRect, P2) then
  begin
    if P.Y >= Form.Height + cDY then
      //move form up
      Form.Top:= P.Y - Form.Height - cDY
    else
      //move form down
      Form.Top:= P.Y + cDY * 2;
  end;
end;

function SyntaxManagerFilesFilter(M: TSyntaxManager; const SAllText: Widestring): Widestring;
  //
  function GetExtString(const Extentions: string): string;
  var
    SAll, SItem: Widestring;
  begin
    Result:= '';
    SAll:= Extentions;
    repeat
      SItem:= SGetItem(SAll, ' ');
      if SItem='' then Break;
      if Pos('/', SItem)=0 then //Makefiles lexer has "/mask"
        SItem:= '*.' + SItem
      else
        SReplaceAllW(SItem, '/', '');
      Result:= Result + IfThen(Result<>'', ';') + SItem;
    until false;
  end;
  //
var
  s: string;
  o: TStringList;
  i, j: integer;
begin
  Result := '';
  o:= TStringList.Create;
  try
    o.Duplicates:= dupIgnore;
    o.Sorted:= True;

    for i:= 0 to M.AnalyzerCount-1 do
      if not M.Analyzers[i].Internal then
        with M.Analyzers[i] do
          o.Add(LexerName);

    for j:= 0 to o.Count-1 do
      for i:= 0 to M.AnalyzerCount-1 do
        if not M.Analyzers[i].Internal then
          with M.Analyzers[i] do
           if LexerName=o[j] then
           begin
             s:= GetExtString(Extentions);
             if s<>'' then
               Result:= Result + Format('%s (%s)|%1:s|', [LexerName, s]);
           end;
  finally
    FreeAndNil(o);
  end;

  Result:= Result + SAllText + ' (*.*)|*.*';
end;

function EditorWordLength(Ed: TSyntaxMemo): Integer;
var
  S: Widestring;
  N: Integer;
begin
  Result:= 0;
  N:= Ed.CurrentLine;
  if (N>=0) and (N<Ed.Lines.Count) then
    S:= Ed.Lines[N]
  else
    Exit;

  N:= Ed.CaretPos.X+1;
  if N>Length(S) then
    N:= Length(S)+1;
  repeat
    Dec(N);
    if N=0 then Break;
    if not IsWordChar(S[N]) then Break;
    Inc(Result);
  until false;
end;

function EditorGetSelTextLimited(Ed: TSyntaxMemo; MaxLen: Integer): Widestring;
begin
  Result:= Ed.SelText;
  if Length(Result)>MaxLen then
    SetLength(Result, MaxLen);
end;

function EditorGetCollapsedRanges(Ed: TSyntaxMemo): string;
var
  i: Integer;
begin
  Result:= '';
  for i:= 0 to Ed.Lines.Count-1 do
    if Ed.IsLineCollapsed(i)=1 then
      Result:= Result+IntToStr(i)+',';
end;

procedure EditorSetCollapsedRanges(Ed: TSyntaxMemo; S: Widestring);
var
  S1: Widestring;
  N: Integer;
begin
  repeat
    S1:= SGetItem(S);
    if S1='' then Break;
    N:= StrToIntDef(S1, -1);
    if (N>=0) and (N<Ed.Lines.Count) then
      Ed.CollapseNearest(N);
  until false;
  Ed.Invalidate;
end;

function EditorGetTokenName(Ed: TSyntaxMemo; StartPos, EndPos: integer): string;
var
  n: integer;
  t: TSyntToken;
begin
  Result:= '';
  Dec(StartPos);
  Dec(EndPos);

  if Ed.SyntObj=nil then Exit;
  n:= Ed.SyntObj.TokenAtPos(StartPos);
  if n<0 then Exit;
  t:= Ed.SyntObj.Tags[n];
  if t=nil then Exit;
  if t.Style=nil then Exit;

  //t.StartPos, t.EndPos
  if (StartPos>=t.StartPos) and (EndPos<=t.EndPos) then
    Result:= t.Style.DisplayName;
end;
 
procedure EditorCollapseWithNested(Ed: TSyntaxMemo; Line: Integer);
var
  i: Integer;
begin
  if not ((Line>=0) and (Line<Ed.Lines.Count)) then Exit;

  case Ed.IsLineCollapsed(Line) of
    1:
      Ed.ToggleCollapseChildren(Line);
    0:
      begin
      end;
    else
      begin
        for i:= Line-1 downto 0 do
          if Ed.IsLineCollapsed(i)>=0 then
          begin
            Ed.ToggleCollapseChildren(i);
            Exit
          end;
      end;
  end;
end;

procedure EditorCollapseParentRange(Ed: TSyntaxMemo; APos: Integer);
var
  r, r2: TTextRange;
begin
  with Ed do
    if Assigned(SyntObj) then
    begin
      r:= SyntObj.NearestRangeAtPos(APos);
      if r=nil then Exit;
      r2:= r.Parent;
      if r2<>nil then
        r:= r2;
      CollapseRange(r);
      Exit;
    end;
end;

procedure EditorUncollapseLine(Ed: TCustomSyntaxMemo; Line: Integer);
var
  i, AStartPos, AEndPos: Integer;
  Upd: boolean;
begin
  if (Line>=0) and (Line<Ed.Lines.Count) then
  begin
    AStartPos:= Ed.CaretPosToStrPos(Point(0, Line));
    AEndPos:= Ed.CaretPosToStrPos(Point(Ed.Lines.LineLength(Line), Line));
    Upd:= false;
    with Ed do
    begin
      for i:= Collapsed.Count - 1 downto 0 do
       with Collapsed[i] do
         if (StartPos <= AStartPos) and (EndPos >= AEndPos) then
         begin
           Collapsed.Delete(i);
           Upd:= true;
         end;
      if Upd then
      begin
        CollapsedChanged; //need to be in public (ecSyntMemo.pas)
      end;
    end;
  end;
end;

function IsEditorLineCollapsed(Ed: TCustomSyntaxMemo; Line: Integer): boolean;
var
  i, AStartPos, AEndPos: Integer;
begin
  Result:= false;
  if (Line>=0) and (Line<Ed.Lines.Count) then
  begin
    AStartPos:= Ed.CaretPosToStrPos(Point(0, Line));
    AEndPos:= Ed.CaretPosToStrPos(Point(Ed.Lines.LineLength(Line), Line));
    with Ed do
      for i:= Collapsed.Count - 1 downto 0 do
       with Collapsed[i] do
         if (StartPos <= AStartPos) and (EndPos >= AEndPos) then
         begin
           Result:= true;
           Exit
         end;
  end;
end;

procedure EditorCenterPos(Ed: TCustomSyntaxMemo; AGotoMode: boolean; NOffsetY: Integer);
var
  p: TPoint;
  w, h: integer;
  dx, dy: integer; //indents from sr result to window edge
begin
  dy:= NOffsetY;
  dx:= dy;
  with Ed do
  begin
    p:= CaretPos;
    w:= VisibleCols;
    h:= VisibleLines;

    {
    //uncollapse - buggy on big Python file folded line
    EditorUncollapseLine(Ed, p.Y);
    }

    //center Y
    if p.Y <= TopLine + 1 then
      TopLine:= TopLine - dy
    else
    if p.Y >= TopLine + h - dy then
      TopLine:= p.Y - dy;

    if WordWrap then
      ScrollCaret
    else
    //center X
    begin
      //ZD start
      if VisibleLinesWidth <= ClientWidth then
        ScrollPosX := 0
      else
      //ZD end
      if AGotoMode or (SelLength=0) then
      begin
        {//center caret
        if (p.X <= ScrollPosX + dx) or
          (p.X >= ScrollPosX + w - dx) then
        ScrollPosX:= p.X - w div 2;}

        //ZD start
        if (p.X <= ScrollPosX + dx) then
          ScrollPosX := p.X - dx
        else if (p.X >= ScrollPosX + w - dx) then
          ScrollPosX := p.X - w + dx;
        //ZD end
      end
      else
      begin
        {//center seltext
        if (StrPosToCaretPos(SelStart).X <= ScrollPosX + dx) or
        (StrPosToCaretPos(SelStart+SelLength).X >= ScrollPosX + w - dx) then
          ScrollPosX:= StrPosToCaretPos(SelStart + SelLength div 2).X - w div 2 + 1;}

        //ZD start
        // Centered selected text doesn't have too much sense when it is
        // on the end of line and none editor has such behavior, they instead
        // try to bring it into the view to the nearest side of editor.
        if (StrPosToCaretPos(SelStart).X <= ScrollPosX + dx) then
          ScrollPosX := StrPosToCaretPos(SelStart).X - dx
        else if (StrPosToCaretPos(SelStart + SelLength).X >= ScrollPosX + w - dx) then
          ScrollPosX := StrPosToCaretPos(SelStart + SelLength).X - w + dx;
        //ZD end
      end;

      //this UpdateEditor call doesn't help: still bug:
      //http://synwrite.sourceforge.net/forums/viewtopic.php?p=5225#p5225
      //ZD - this bug doesn't exist anymore
      UpdateEditor;
    end;
  end;
end;


function EditorSelectWord(Ed: TSyntaxMemo): boolean;
var
  NPos: integer;
begin
  Result:= false;
  NPos:= Ed.CaretStrPos;
  if (NPos>=0) then
  begin
    if (NPos=Ed.TextLength) //caret at EOF
      or not IsWordChar(Ed.Text[NPos+1]) then //caret not under wordchar
    begin
      //previous char is wordchar?
      if (NPos>=1) and IsWordChar(Ed.Text[NPos]) then
        Ed.CaretStrPos:= NPos-1
      else
        Exit;
    end;
    Ed.SelectWord;
    Result:= true;
  end;
end;

function EditorSelectionForGotoCommand(Ed: TSyntaxMemo): Widestring;
const
  cMaxNameLen = 20; //max len of filename in popup menu
begin
  Result:= Ed.SelText;

  //don't show multi-line selection here
  if (Pos(#13, Result)>0) or
     (Pos(#10, Result)>0) or
     (Pos(#9, Result)>0) then
    Result:= '';

  if Length(Result)>cMaxNameLen then
    Result:= Copy(Result, 1, cMaxNameLen) + '...';
end;

procedure EditorAddLineToEnd(Ed: TSyntaxMemo);
var
  n: Integer;
begin
  //Fix: last line must be with EOL
  with Ed do
    if (CaretPos.Y = Lines.Count-1) and (Lines[Lines.Count-1]<>'') then
    begin
      n:= CaretStrPos;
      CaretStrPos:= TextLength;
      InsertNewLine(0, True, false);
      CaretStrPos:= n;
    end;
end;

//Get selected lines nums: from Ln1 to Ln2
procedure EditorGetSelLines(Ed: TSyntaxMemo; var Ln1, Ln2: Integer);
var
  p: TPoint;
begin
  with Ed do
    if HaveSelection then
    begin
      if SelLength>0 then
      begin
        Ln1:= StrPosToCaretPos(SelStart).Y;
        p:= StrPosToCaretPos(SelStart+SelLength);
        Ln2:= p.Y;
        if p.X = 0 then
          Dec(Ln2);
      end
      else
      begin
        Ln1:= SelRect.Top;
        Ln2:= SelRect.Bottom;
      end
    end
    else
    begin
      //no selection
      Ln1:= CaretPos.Y;
      Ln2:= Ln1;
    end;
end;


function EditorHasMultilineSelection(Ed: TSyntaxMemo): boolean;
var
  Ln1, Ln2: integer;
begin
  if not Ed.HaveSelection then
    Result:= false
  else
  begin
    EditorGetSelLines(Ed, Ln1, Ln2);
    Result:= Ln2 > Ln1;
  end;
end;


function EditorTabSize(Ed: TSyntaxMemo): Integer;
begin
  if Ed.TabList.Count>0 then
    Result:= Ed.TabList[0]
  else
    Result:= 8;
end;

function EditorTabExpansion(Ed: TSyntaxMemo): Widestring;
begin
  Result:= StringOfChar(' ', EditorTabSize(Ed));
end;

function EditorHasNoCaret(Ed: TSyntaxMemo): boolean;
begin
  with Ed do
    Result:= ReadOnly and not (soAlwaysShowCaret in Options);
end;


procedure EditorSaveSel(Ed: TSyntaxMemo; var Sel: TSynSelSave);
begin
  FillChar(Sel, SizeOf(Sel), 0);
  with Ed do
  begin
    Sel.FSelStream:= Ed.SelLength>0;
    if Sel.FSelStream then
    begin
      Sel.FSelStart:= Ed.StrPosToCaretPos(Ed.SelStart);
      Sel.FSelEnd:= Ed.StrPosToCaretPos(Ed.SelStart+Ed.SelLength);
    end
    else
      Sel.FSelRect:= SelRect;
    Sel.FCaretPos:= CaretPos;
  end;
end;

procedure EditorRestoreSel(Ed: TSyntaxMemo; const Sel: TSynSelSave);
begin
  with Ed do
  begin
    BeginUpdate;
    try
      CaretPos:= Sel.FCaretPos;
      if Sel.FSelStream then
      begin
        SelStart:= Ed.CaretPosToStrPos(Sel.FSelStart);
        SelLength:= Ed.CaretPosToStrPos(Sel.FSelEnd) - SelStart;
      end
      else
        SelRect:= Sel.FSelRect;
    finally
      EndUpdate;
    end;
  end;
end;


procedure EditorDuplicateLine(Ed: TSyntaxMemo);
var
  n, nn: Integer;
  s: ecString;
begin
  with Ed do
  if SelLength>0 then
  begin
    n:= SelStart;
    nn:= SelLength;
    s:= SelText;
    SetSelection(n, 0);
    InsertText(s);
    SetSelection(n, nn);
  end
  else
  try
    Ed.BeginUpdate;
    EditorAddLineToEnd(Ed);
    Ed.DuplicateLine(Ed.CaretPos.Y);
    Ed.ExecCommand(smDown);
    //EditorSetModified(Ed);
  finally
    Ed.EndUpdate;
  end;
end;


procedure EditorDeleteLine(Ed: TSyntaxMemo; NLine: integer; AUndo: boolean);
var
  p: TPoint;
begin
  //save caret
  p:= Ed.CaretPos;
  if NLine <= p.Y then
    Dec(p.Y); //fix caret pos

  if AUndo then
    with Ed do
    begin
      CaretPos:= Point(0, NLine);
      DeleteText(Lines.LineSpace(NLine));
    end
  else
  begin
    Ed.ClearUndo;
    Ed.Lines.Delete(NLine);
    Ed.Modified:= true;
  end;

  //restore caret
  Ed.CaretPos:= p;
end;


procedure EditorReplaceLine(Ed: TSyntaxMemo; NLine: integer;
  const S: WideString; AUndo: boolean);
var
  p: TPoint;
begin
  if AUndo then
    with Ed do
    begin
      BeginUpdate;
      try
        p:= CaretPos;
        CaretPos:= Point(0, NLine);
        DeleteText(Lines.LineLength(NLine));
        InsertText(S);
        CaretPos:= p;
      finally
        EndUpdate;
      end;    
    end
  else
  begin
    Ed.Lines[NLine]:= S;
    Ed.Modified:= true;
  end;
end;

var
  _CmpMemo: TCustomSyntaxMemo = nil;

function _BookmarkCompare(N1, N2: Pointer): Integer;
begin
  if not Assigned(_CmpMemo) then
    raise Exception.Create('CmpMemo nil');
  with _CmpMemo do
    Result:= Bookmarks[Integer(N1)] - Bookmarks[Integer(N2)];
end;

function _BookmarkCompareEx(N1, N2: Pointer): Integer;
begin
  Result:= TBookmark(N1).Position - TBookmark(N2).Position;
end;


procedure EditorGetBookmarksAsSortedList(Ed: TSyntaxMemo; L: TList);
var
  i: Integer;
begin
  with Ed.BookmarkObj do
    for i:= 0 to Count-1 do
      L.Add(Pointer(Items[i].BmIndex));

  _CmpMemo:= Ed;
  L.Sort(_BookmarkCompare);
end;

procedure EditorGetBookmarksAsSortedList_Ex(Ed: TSyntaxMemo; L: TList);
var
  i: Integer;
begin
  with Ed.BookmarkObj do
    for i:= 0 to Count-1 do
      L.Add(Items[i]);

  L.Sort(_BookmarkCompareEx);
end;


function EditorCaretAfterUnclosedQuote(Ed: TSyntaxMemo; var QuoteChar: WideChar): boolean;
var
  i: Integer;
  ch: WideChar;
begin
  Result:= false;
  QuoteChar:= #0;

  if Ed.TextLength=0 then Exit;
  i:= Ed.CaretStrPos;
  if not IsWordChar(Ed.Lines.Chars[i]) then Exit;
  while IsWordChar(Ed.Lines.Chars[i]) do Dec(i);
  ch:= Ed.Lines.Chars[i];
  Result:= IsQuoteChar(ch);
  if Result then
    QuoteChar:= ch;
end;

//Result must be true only when
//- TextLength=0
//- caret on space/tab/EOL
//- caret prev char is not wordchar, not '<', '/'
function EditorNeedsHtmlOpeningBracket(Ed: TSyntaxMemo): boolean;
var
  i: Integer;
  ch: Widechar;
begin
  Result:= true;
  with Ed do
    if (TextLength>0) then
    begin
      i:= CaretStrPos;
      //check for previous char
      if (i<=TextLength) then
      begin
        ch:= Lines.Chars[i];
        if IsWordChar(ch) or (ch='<') or (ch='/')
          //or (ch=' ') {fix for unneeded "<" at text end}
          then
            Result:= false;
      end;
      //check for current char
      if (i+1<=TextLength) then
      begin
        ch:= Lines.Chars[i+1];
        if not IsSpaceChar(ch) then
          Result:= false;
      end;
    end;
end;

procedure EditorMarkSelStart(Ed: TSyntaxMemo);
begin
  with Ed do
    SelStartMarked:= CaretStrPos;
end;

procedure EditorMarkSelEnd(Ed: TSyntaxMemo);
var
  nFrom, nTo: Integer;
  pFrom, pTo: TPoint;
begin
  with Ed do
    if SelStartMarked>=0 then
    begin
      nTo:= CaretStrPos;
      if SelStartMarked>nTo then
      begin
        nFrom:= nTo;
        nTo:= SelStartMarked;
      end
      else
        nFrom:= SelStartMarked;

      if SelectModeDefault in [msNone, msNormal] then
        //normal select mode
        SetSelection(nFrom, nTo-nFrom)
      else
      begin
        pFrom:= StrPosToCaretPos(nFrom);
        pTo:= StrPosToCaretPos(nTo);
        if SelectModeDefault = msColumn then
          //column select mode
          SelRect:= Rect(pFrom.X, pFrom.Y, pTo.X, pTo.Y)
        else
          //line select mode
          SelectLines(pFrom.Y, pTo.Y);
      end;
    end;
end;

procedure EditorScrollCurrentLineTo(Ed: TSyntaxMemo; Mode: TSynScrollLineTo);
var
  p: TPoint;
  dy, minY, newY, i: Integer;
begin
  if Ed.Lines.Count>1 then
  case Mode of
    cScrollToTop:
      Ed.TopLine:= Ed.CaretPos.Y;

    cScrollToBottom,
    cScrollToMiddle:
      begin
        dy:= Ed.ClientHeight;
        if Mode=cScrollToMiddle then
          dy:= dy div 2 + Ed.DefLineHeight;

        p:= Ed.CaretPos;
        Inc(p.Y); //make next line fully visible
        Ed.TopLine:= p.Y;
        minY:= Ed.ScrollPosY - dy;

        newY:= Ed.ScrollPosY;
        for i:= p.Y-1 downto 0 do
        begin
          Dec(newY, Ed.LineHeight(i));
          if newY<minY then
          begin
            Ed.TopLine:= i+1;
            Exit;
          end;  
        end;
        Ed.TopLine:= 0;
      end;
    else
      raise Exception.Create('Unknown scroll mode');
  end;
end;


function EditorSelectToken(Ed: TSyntaxMemo; SkipQuotes: boolean = false): boolean;
var
  n, nStart, nLen: integer;
  t: TSyntToken;
begin
  Result:= false;
  if Ed.SyntObj=nil then Exit;

  n:= Ed.SyntObj.TokenAtPos(Ed.CaretStrPos);
  if n<0 then Exit;

  t:= Ed.SyntObj.Tags[n];
  if t=nil then Exit;

  nStart:= t.StartPos;
  nLen:= t.EndPos - t.StartPos;
  if (nStart<0) or (nLen<=0) then Exit;

  if SkipQuotes then
  begin
    //skip ending quotes
    while (nLen>0) and IsQuoteChar(Ed.Lines.Chars[nStart+nLen]) do
      Dec(nLen);
    //skip starting quotes
    while (nLen>0) and IsQuoteChar(Ed.Lines.Chars[nStart+1]) do
    begin
      Inc(nStart);
      Dec(nLen);
    end;
  end;

  Ed.SetSelection(nStart, nLen);
  Result:= true;
end;


procedure EditorFoldLevel(Ed: TSyntaxMemo; NLevel: Integer);
var
  An: TClientSyntAnalyzer;
  i: Integer;
begin
  An:= Ed.SyntObj;
  if An=nil then Exit;

  Ed.BeginUpdate;
  try
    Ed.FullExpand;
    for i:= 0 to An.RangeCount-1 do
      if An.Ranges[i].Level > NLevel then
        Ed.CollapseRange(An.Ranges[i]);
  finally
    Ed.EndUpdate;
  end;
end;

function EditorCurrentAnalyzerForPos(Ed: TSyntaxMemo; NPos: integer): TSyntAnalyzer;
begin
  Result:= nil;
  if Assigned(Ed) and Assigned(Ed.SyntObj) then
    Result:= Ed.SyntObj.AnalyzerAtPos(NPos);
end;

function EditorCurrentLexerForPos(Ed: TSyntaxMemo; NPos: integer): string;
var
  An: TSyntAnalyzer;
begin
  Result:= '';
  An:= EditorCurrentAnalyzerForPos(Ed, NPos);
  if An<>nil then
    Result:= An.LexerName;
end;


function EditorTokenString(Ed: TSyntaxMemo; TokenIndex: Integer): Widestring;
begin
  Result:= '';
  if Ed.SyntObj<>nil then
    with Ed.SyntObj do
      Result:= TagStr[TokenIndex];
end;

function EditorTokenFullString(Ed: TSyntaxMemo; TokenIndex: Integer; IsDotNeeded: boolean): Widestring;
var
  i: Integer;
begin
  Result:= '';
  if Ed.SyntObj<>nil then
    with Ed.SyntObj do
    begin
      Result:= TagStr[TokenIndex];

      //add lefter tokens
      //(needed for complex id.id.id, e.g. for C#)
      i:= TokenIndex;
      while (i-2>=0) do
      begin
        if not ((TagStr[i-1]='.') and IsDotNeeded) then
          Break;
        Insert(TagStr[i-2]+TagStr[i-1], Result, 1);
        Dec(i, 2);
      end;

      //add righter tokens
      i:= TokenIndex;
      while (i+2<=TagCount-1) do
      begin
        if not ((TagStr[i+1]='.') and IsDotNeeded) then
          Break;
        Result:= Result+TagStr[i+1]+TagStr[i+2];
        Inc(i, 2);
      end;
    end;
end;

procedure EditorExtendSelectionByPosition(
  Ed: TSyntaxMemo;
  AOldStart, AOldLength,
  ANewStart, ANewLength: integer);
var
  AOldEnd, ANewEnd: integer;
begin
  AOldEnd:= AOldStart+AOldLength;
  ANewEnd:= ANewStart+ANewLength;
  ANewStart:= Min(AOldStart, ANewStart);
  ANewEnd:= Max(AOldEnd, ANewEnd);
  ANewLength:= ANewEnd-ANewStart;
  Ed.SetSelection(ANewStart, ANewLength, true);
end;


procedure EditorFillBlockRect(Ed: TSyntaxMemo; SData: Widestring; bKeep: boolean);
var
  R: TRect;
  s: Widestring;
  OldCaret: TPoint;
  nLen, i: Integer;
begin
  with Ed do
  begin
    if not HaveSelection then Exit;
    if SelectMode<>msColumn then Exit;
    
    R:= SelRect;
    OldCaret:= CaretPos;
    if bKeep then
    begin
      if Length(sData) > R.Right - R.Left then
        SetLength(sData, R.Right - R.Left);
      nLen:= Length(sData);
    end
    else
      nLen:= R.Right - R.Left;

    BeginUpdate;
    try
      for i:= R.Top to R.Bottom do
      begin
        s:= Lines[i];

        //expand tabs to spaces
        if Pos(#9, s)>0 then
        begin
          s:= SUntab(s, EditorTabSize(Ed));
          EditorReplaceLine(Ed, i, s, true{ForceUndo});
        end;

        //fill line tail with spaces
        if Length(s)<R.Right then
        begin
          CaretPos:= Point(Length(s), i);
          InsertText(StringOfChar(' ', R.Right-Length(s)));
        end;

        //replace block line
        ReplaceText(
          CaretPosToStrPos(Point(R.Left, i)),
          nLen, sData);
      end;

      if bKeep then
        nLen:= R.Right - R.Left
      else
        nLen:= Length(sData);

      CaretPos:= Point(R.Left + nLen, OldCaret.Y);
      SelRect:= Rect(R.Left, R.Top, R.Left + nLen, R.Bottom);
    finally
      EndUpdate;
    end;
  end;
end;

function EditorEOL(Ed: TCustomSyntaxMemo): Widestring;
begin
  case Ed.Lines.TextFormat of
    tfCR: Result:= #13;
    tfNL: Result:= #10;
    else Result:= #13#10;
  end;
end;


function EditorDeleteSelectedLines(Ed: TSyntaxMemo): Integer;
var
  i, Ln1, Ln2, NCol, NScroll: Integer;
begin
  Result:= 0;
  if Ed.ReadOnly then Exit;

  EditorGetSelLines(Ed, Ln1, Ln2);
  if Ln1=Ln2 then
  begin
    NCol:= Ed.CaretPos.X;
    NScroll:= Ed.ScrollPosX;
  end
  else
  begin
    NCol:= 0;
    NScroll:= 0;
  end;  

  Ed.BeginUpdate;
  try
    for i:= Ln2 downto Ln1 do
    begin
      EditorDeleteLine(ed, i, true{ForceUndo});
      Inc(Result);
    end;
    Ed.CaretPos:= Point(NCol, Ln1);
    Ed.ScrollPosX:= NScroll;
  finally
    Ed.EndUpdate;
  end;
end;


procedure EditorExtendSelectionByOneLine(Ed: TSyntaxMemo);
var
  r: TRect;
  p: TPoint;
  n1, n2: Integer;
begin
  if Ed.HaveSelection then
  begin
    case Ed.SelectMode of
      msColumn:
        begin
          r:= Ed.SelRect;
          Inc(r.Bottom);
          Ed.CaretPos:= Point(r.Right, r.Bottom);
          Ed.SelRect:= r;
        end;
      else
        begin
          n1:= Ed.SelStart;
          n2:= Ed.SelStart+Ed.SelLength;
          p:= Ed.StrPosToCaretPos(n2);
          p.X:= 0;
          Inc(p.Y);
          n2:= Ed.CaretPosToStrPos(p);
          Ed.SetSelection(n1, n2-n1);
        end;
    end;
  end
  else
  begin
    Ed.CaretPos:= Point(0, Ed.CaretPos.Y);
    Ed.ExecCommand(smSelDown);
  end;
end;

//this one mimics ST2 more. above one is more handy.
procedure EditorExtendSelectionByOneLine_Prev(Ed: TSyntaxMemo);
var
  DoNext: boolean;
  NStart, NEnd: Integer;
begin
  NStart:= Ed.SelStart;
  NEnd:= Ed.SelStart+Ed.SelLength;

  DoNext:=
    (Ed.SelLength>0) and
    (Ed.CaretStrPos = NEnd) and
    (Ed.StrPosToCaretPos(NStart).X = 0) and
    ((Ed.StrPosToCaretPos(NEnd).X = 0) or (NEnd = Ed.TextLength));

  if not DoNext then
  begin
    Ed.ResetSelection;
    Ed.ExecCommand(smLineStart);
  end;
  Ed.ExecCommand(smSelDown);
end;


procedure EditorScrollToSelection(Ed: TSyntaxMemo; NSearchOffsetY: Integer);
var
  Save: TSynSelSave;
begin
  with Ed do
    if HaveSelection then
    begin
      EditorSaveSel(Ed, Save);
      if SelLength>0 then
        CaretStrPos:= SelStart
      else
        CaretPos:= Point(SelRect.Left, SelRect.Top);
      EditorCenterPos(Ed, true{GotoMode}, NSearchOffsetY);
      EditorRestoreSel(Ed, Save);
    end;
end;


procedure EditorExtendSelectionByLexer_All(Ed: TSyntaxMemo; var Err: string);
var
  An: TClientSyntAnalyzer;
  R: TTextRange;
  SelSave: TSynSelSave;
  EndPos: Integer;
begin
  Err:= '';
  An:= Ed.SyntObj;
  if An=nil then
    begin Err:= 'No lexer active'; Exit end;

  EditorSaveSel(Ed, SelSave);

  //if selection is made, it may be selection from prev ExtendSel call,
  //so need to increment caret pos, to extend selection further
  if Ed.HaveSelection then
  begin
    Ed.ResetSelection;
    Ed.CaretStrPos:= Ed.CaretStrPos+2;
  end;

  R:= An.NearestRangeAtPos(Ed.CaretStrPos);
  if (R=nil) or not R.IsClosed then
  begin
    Err:= 'Extend selection: no range at caret';
    EditorRestoreSel(Ed, SelSave);
    Exit
  end;

  EndPos:= R.EndIdx;
  if not ((EndPos>=0) and (EndPos<An.TagCount)) then
  begin
    Err:= 'Extend selection: no closed range';
    Exit
  end;

  EndPos:= An.Tags[EndPos].EndPos;
  Ed.SetSelection(R.StartPos, EndPos-R.StartPos);
end;


procedure EditorExtendSelectionByLexer_HTML(Ed: TSyntaxMemo);
var
  An: TClientSyntAnalyzer;
  i, StPos, EndPos, NCaret: Integer;
begin
  An:= Ed.SyntObj;
  if An=nil then Exit;

  NCaret:= Ed.CaretStrPos;
  for i:= An.RangeCount-1 downto 0 do
  begin
    //get StPos start of range, EndPos end of range
    StPos:= An.Ranges[i].StartPos;
    EndPos:= An.Ranges[i].EndIdx;
    if EndPos<0 then Continue;
    EndPos:= An.Tags[EndPos].EndPos;

    //take only range, which starts before NCaret, and ends after NCaret
    if (StPos<NCaret) and (EndPos>=NCaret) then
      //and not range which is from "<" to ">" - this is just tag
      if not (Ed.Lines.Chars[StPos+1]='<') then
      begin
        //correct StPos, EndPos coz they don't include "<" and ">" in HTML
        Dec(StPos);
        Inc(EndPos);
        Ed.SetSelection(StPos, EndPos-StPos);
        Break
      end;
  end;
end;


procedure EditorSplitLinesByPosition(Ed: TSyntaxMemo; nCol: Integer);
var
  Ln1, Ln2, i: Integer;
  s, sEol: Widestring;
  nTabSize: Integer;
  nTotalLines: Integer;
begin
  if Ed.ReadOnly then Exit;
  EditorGetSelLines(Ed, Ln1, Ln2);
  sEol:= EditorEOL(Ed);
  nTabSize:= EditorTabSize(Ed);
  nTotalLines:= 0;

  Ed.BeginUpdate;
  try
    for i:= Ln2 downto Ln1 do
    begin
      //WideWrapText is bad in Tnt Controls, doesn't count leading line spaces
      s:= SWrapText(Ed.Lines[i], sEol, ' -+'#9, sEol, nTabSize, nCol);
      SReplaceAllW(s, ' '+sEol, sEol); //trim trailing blanks

      Inc(nTotalLines, 1+SCountOccurrences(s, sEol));

      EditorReplaceLine(Ed, i, s, true{Undo});
    end;

    Ed.SelectLines(Ln1, Ln1+nTotalLines-1);
  finally
    Ed.EndUpdate;
  end;
end;

procedure FixLineEnds(var S: Widestring; ATextFormat: TTextFormat);
begin
  case ATextFormat of
    tfCR: ReplaceStr(S, #13#10, #13);
    tfNL: ReplaceStr(S, #13#10, #10);
  end;
end;

procedure FixLineEnds_AtEnd(var S: Widestring; Ed: TSyntaxMemo);
var
  Eol: Widestring;
begin
  Eol:= EditorEOL(Ed);
  if SEnd(S, Eol+Eol) then
    Delete(S, Length(S)-Length(Eol), Length(Eol));
end;



procedure EditorPasteAndSelect(Ed: TSyntaxMemo);
var
  ins_text: Widestring;
  NStart, NLen: Integer;
begin
  if Ed.ReadOnly then Exit;
  if not Clipboard.HasFormat(CF_TEXT) then Exit;

  //column block?
  if (GetClipboardBlockType <> 2) then
  begin
    //part copied from ecSyntMemo.PasteFromClipboard
    //yes, not DRY
    if soSmartPaste in Ed.OptionsEx then
      ins_text:= GetClipboardTextEx(Ed.Charset)
    else
      ins_text:= GetClipboardText(Ed.Charset);
      
    FixLineEnds(ins_text, Ed.Lines.TextFormat);

    Ed.InsertText(''); //fix CaretStrPos when caret is after EOL
    NStart:= Ed.CaretStrPos;
    NLen:= Length(ins_text);

    Ed.InsertText(ins_text);
    Ed.SetSelection(NStart, NLen);
  end
  else
    Ed.PasteFromClipboard();
end;


procedure EditorInsertBlankLineAboveOrBelow(Ed: TSyntaxMemo; ABelow: boolean);
var
  p: TPoint;
  nX: Integer;
begin
  if Ed.ReadOnly then Exit;
  p:= Ed.CaretPos;
  nX:= Ed.ScrollPosX;
  if ABelow then
  begin
    if Ed.CaretPos.Y < Ed.Lines.Count-1 then
    begin
      Ed.CaretPos:= Point(0, Ed.CaretPos.Y+1);
      Ed.InsertNewLine(0, true{DoNotMoveCaret}, false);
    end
    else
    begin
      Ed.ExecCommand(smEditorBottom);
      Ed.InsertNewLine(0, false{DoNotMoveCaret}, false);
    end;
  end
  else
  begin
    Ed.CaretPos:= Point(0, Ed.CaretPos.Y);
    Ed.InsertNewLine(0, true{DoNotMoveCaret}, false);
  end;
  //restore caret X
  Ed.CaretPos:= Point(p.X, Ed.CaretPos.Y);
  Ed.ScrollPosX:= nX;
end;


procedure EditorDoHomeKey(Ed: TSyntaxMemo);
//do Eclipse/Sublime-like jump by Home key
var
  p: TPoint;
  s: Widestring;
  NIndent: Integer;
begin
  p:= Ed.CaretPos;
  if (p.Y>=0) and (p.Y<Ed.Lines.Count) then
  begin
    s:= Ed.Lines[p.Y];
    NIndent:= Length(SIndentOf(s));
    if p.X = NIndent then
      p.X:= 0
    else
      p.X:= NIndent;
    Ed.CaretPos:= p;
  end;
end;


procedure EditorKeepCaretOnScreen(Ed: TSyntaxMemo);
var
  p: TPoint;
  n: Integer;
begin
  with Ed do
  begin
    p:= CaretPos;
    n:= TopLine + 1;
    if p.Y < n then
      CaretPos:= Point(p.X, n) else
    begin
      n:= TopLine + VisibleLines - 2;
      if p.Y > n then
        CaretPos:= Point(p.X, n);
    end;
  end;  
end;

function EditorToggleSyncEditing(Ed: TSyntaxMemo): boolean;
begin
  Result:= true;
  with Ed do
    if SyncEditing.Count>0 then
    begin
      SyncEditing.Clear;
      Invalidate;
    end
    else
    begin
      if SelLength>0 then
      begin
        SyncEditing.Clear;
        SyncEditing.AddCurSelection;
        SyncEditing.Enabled:= true;
      end
      else
        Result:= false;
    end;
end;


procedure EditorMoveCaretByNChars(Ed: TSyntaxMemo; DX, DY: Integer);
begin
  with Ed do
    if DY <> 0 then
      CaretPos:= Point(CaretPos.X, CaretPos.Y + DY)
    else
      //need to goto next/prev line if at edge
      CaretStrPos:= CaretStrPos + DX;
end;

procedure EditorCopyOrCutCurrentLine(Ed: TSyntaxMemo; ACut: boolean);
begin
  with Ed do
    if CaretPos.Y < Lines.Count then
    begin
      TntClipboard.AsWideText:= Lines[CaretPos.Y] + sLineBreak;
      if ACut then
        ExecCommand(smDeleteLine);
    end;
end;

procedure EditorCopyAsHtml(Ed: TSyntaxMemo);
var
  Exp: THTMLSyntExport;
begin
  Exp:= THTMLSyntExport.Create(nil);
  try
    Exp.SyntMemo:= Ed;
    Exp.ExportType:= etSelection;
    Exp.SaveToClipboard;
  finally
    FreeAndNil(Exp);
  end;
end;

procedure EditorCopyAsRtf(Ed: TSyntaxMemo);
var
  Exp: TRtfSyntExport;
begin
  Exp:= TRtfSyntExport.Create(nil);
  try
    Exp.SyntMemo:= Ed;
    Exp.ExportType:= etSelection;
    Exp.SaveToClipboard;
  finally
    FreeAndNil(Exp);
  end;
end;

procedure EditorCopyOrCutAndAppend(Ed: TSyntaxMemo; ACut: boolean);
begin
  with TntClipboard do
    AsWideText:= AsWideText + Ed.SelText;
  if ACut then
    Ed.ClearSelection;
end;

procedure EditorJoinLines(Ed: TSyntaxMemo);
const
  cSep = '-+'; //after these chars don't add space
var
  Ln1, Ln2, i: Integer;
  S, SLine, SEol: Widestring;
  SpaceNeeded: boolean;
  P: TPoint;
begin
  if Ed.ReadOnly then Exit;
  with Ed do
    if HaveSelection then
    begin
      EditorGetSelLines(Ed, Ln1, Ln2);
      if Ln2=Ln1 then Exit;

      S:= '';
      SEol:= EditorEOL(Ed);
      for i:= Ln1 to Ln2 do
      begin
        SLine:= Lines[i];
        SpaceNeeded:= (SLine<>'') and (Pos(SLine[Length(SLine)], cSep)=0);
        S:= S + SLine + IfThen(i<Ln2, IfThen(SpaceNeeded, ' '), SEol);
      end;

      BeginUpdate;
      try
        //delete block
        SelectLines(Ln1, Ln2);
        ClearSelection;

        //insert new line
        P:= Point(0, Ln1);
        CaretPos:= P;
        InsertText(S);

        //select it
        SelectLines(Ln1, Ln1);
      finally
        EndUpdate;
      end;
    end;
end;

procedure EditorJoinLines_Prev(Ed: TSyntaxMemo);
var
  s: Widestring;
  nPos, nLen, i, i1: Integer;
begin
  with Ed do
  if SelLength>0 then
  begin
    s:= SelText;
    nLen:= Length(s);
    nPos:= SelStart;

    repeat
      //find CR/LF
      i1:= 0;
      for i:= 1 to Length(s) do
        if IsLineBreakChar(s[i]) then
          begin i1:= i; Break end;
      if i1=0 then Break;
      //delete CR/LF's here
      i:= i1;
      while (i<=Length(s)) and IsLineBreakChar(s[i]) do
        Delete(s, i, 1);
      //if spaces at this pos, continue
      if (i-1>0) and (i-1<=Length(s)) and IsSpaceChar(s[i-1]) then Continue;
      if (i>0) and (i<=Length(s)) and IsSpaceChar(s[i]) then Continue;
      //insert space
      Insert(' ', s, i);
    until false;
    
    CaretStrPos:= nPos;
    DeleteText(nLen);
    InsertText(s);
  end;
end;


procedure EditorPasteNoCaretChange(Ed: TSyntaxMemo);
var
  NPos: TPoint;
  NLine: Integer;
begin
  with Ed do
    if not ReadOnly then
    begin
      NPos:= CaretPos;
      NLine:= TopLine;
      ExecCommand(smPaste);
      CaretPos:= NPos;
      TopLine:= NLine;
    end;
end;

procedure EditorPasteToFirstColumn(Ed: TSyntaxMemo);
var
  P: TPoint;
begin
  with Ed do
  begin
    P:= CaretPos;
    CaretPos:= Point(0, P.Y);
    PasteFromClipboard;
    CaretPos:= Point(P.X, CaretPos.Y);
  end;
end;

procedure EditorDeleteToFileBegin(Ed: TSyntaxMemo);
var
  NCaret: Integer;
begin
  with Ed do
    if not ReadOnly then
    begin
      NCaret:= CaretStrPos;
      CaretStrPos:= 0;
      DeleteText(NCaret);
    end;
end;

procedure EditorDeleteToFileEnd(Ed: TSyntaxMemo);
begin
  with Ed do
    if not ReadOnly then
      DeleteText(TextLength);
end;


function EditorAutoCloseBracket(Ed: TSyntaxMemo; ch: Widechar;
  opAutoCloseBrackets,
  opAutoCloseQuotes1,
  opAutoCloseQuotes2,
  opAutoCloseBracketsNoEsc: boolean): boolean;
var
  ch2: Widechar;
  NStart, NLen: Integer;
begin
  Result:= false;
  if Ed.ReadOnly then Exit;
  NStart:= Ed.CaretStrPos;

  //options enabled?
  if IsBracketChar(ch) and not opAutoCloseBrackets then Exit;
  if (ch='''') and not opAutoCloseQuotes1 then Exit;
  if (ch='"') and not opAutoCloseQuotes2 then Exit;

  //bracket is escaped?
  if opAutoCloseBracketsNoEsc then
    if (NStart>0) and (Ed.Lines.Chars[NStart]='\') then Exit;

  //closing bracket is already under caret?
  if (Pos(ch, ')]}')>0) then
    if Ed.Lines.Chars[NStart+1]=ch then
    begin
      //right 1 char
      Ed.CaretPos:= Point(Ed.CaretPos.X+1, Ed.CaretPos.Y);
      Result:= true;
      Exit
    end;

  case ch of
    '(': ch2:= ')';
    '[': ch2:= ']';
    '{': ch2:= '}';
    '"',
    '''': ch2:= ch;
    else Exit
  end;

  if Ed.SelLength=0 then
  //simply input start+end brackets
  begin
    Ed.InsertText(WideString(ch)+WideString(ch2));
    Ed.CaretStrPos:= Ed.CaretStrPos-1;
  end
  else
  //code to wrap selection with brackets
  begin
    Ed.BeginUpdate;
    try
      NStart:= Ed.SelStart;
      NLen:= Ed.SelLength;
      Ed.ResetSelection;
      Ed.CaretStrPos:= NStart+NLen;
      Ed.InsertText(ch2);
      Ed.CaretStrPos:= NStart;
      Ed.InsertText(ch);
      Ed.SetSelection(NStart+1, NLen);
    finally
      Ed.EndUpdate;
    end;
  end;

  Result:= true;
end;


function EditorGetBookmarksAsString(Ed: TCustomSyntaxMemo): string;
const
  cMaxItems = 200;
var
  i, NIndex: Integer;
begin
  Result:= '';
  with Ed.BookmarkObj do
    for i:= 0 to Min(Count, cMaxItems) - 1 do
    begin
      //don't read bookmarks from SynLint (hint begins with "!")
      if SBegin(Items[i].Hint, '!') then Continue;

      NIndex:= Items[i].BmIndex;
      Result:= Result +
        IfThen(NIndex < 10, ':'+IntToStr(NIndex)+':') +
        IntToStr(Items[i].Position) + ',';
    end;
end;


procedure EditorSetBookmarksAsString(Ed: TCustomSyntaxMemo; const Str: string);
var
  S, SItem: Widestring;
  NIndexCount, NIndexThis, NPos: Integer;
begin
  Ed.ClearBookmarks;
  NIndexCount:= 10; //minimal BmIndex for unnumbered bookmarks is 10
  S:= Str;

  repeat
    SItem:= SGetItem(S, ',');
    if SItem='' then Break;

    //'NNN' for unnumbered bkmk, or ':N:NNN' for numbered bkmk
    if (Length(SItem)>3) and (SItem[1]=':') and (SItem[3]=':') then
    begin
      //numbered
      NIndexThis:= StrToIntDef(SItem[2], 0);
      Delete(SItem, 1, 3);
    end
    else
    begin
      //unnumbered
      NIndexThis:= NIndexCount;
      Inc(NIndexCount);
    end;

    NPos:= StrToIntDef(SItem, -1);
    if NPos>=0 then
      Ed.Bookmarks[NIndexThis]:= NPos;
  until false;
end;

procedure EditorSetSelCoordAsString(Ed: TSyntaxMemo; const Str: string);
var
  S: Widestring;
  p1, p2: TPoint;
  n1, n2: Integer;
begin
  Ed.BeginUpdate;
  try
    Ed.ResetSelection;

    S:= Str;
    Ed.SelectMode:= TSyntSelectionMode(StrToIntDef(SGetItem(S), 0));
    p1.X:= StrToIntDef(SGetItem(S), 0);
    p1.Y:= StrToIntDef(SGetItem(S), 0);
    p2.X:= StrToIntDef(SGetItem(S), 0);
    p2.Y:= StrToIntDef(SGetItem(S), 0);
    if (p1.X=0) and (p1.Y=0) and (p2.X=0) and (p2.Y=0) then Exit;

    case Ed.SelectMode of
      msColumn:
        Ed.SelRect:= Rect(p1.X, p1.Y, p2.X, p2.Y);
      msLine:
        Ed.SelectLines(p1.Y, p2.Y-1);
      else
      begin
        n1:= Ed.CaretPosToStrPos(p1);
        n2:= Ed.CaretPosToStrPos(p2);
        Ed.SetSelection(n1, n2-n1);
      end;
    end;
  finally
    Ed.EndUpdate;
  end;
end;

function EditorGetSelCoordAsString(Ed: TSyntaxMemo): string;
var
  p1, p2: TPoint;
  rect: TRect;
  mode: Integer;
begin
  mode:= Ord(Ed.SelectMode);
  p1:= Point(0, 0);
  p2:= Point(0, 0);
  if Ed.HaveSelection then
  begin
    if Ed.SelectMode=msColumn then
    begin
      rect:= Ed.SelRect;
      p1.X:= rect.Left;
      p1.Y:= rect.Top;
      p2.X:= rect.Right;
      p2.Y:= rect.Bottom;
    end
    else
    begin
      p1:= Ed.StrPosToCaretPos(Ed.SelStart);
      p2:= Ed.StrPosToCaretPos(Ed.SelStart+Ed.SelLength);
    end;
  end;
  Result:= Format('%d,%d,%d,%d,%d,', [mode, p1.X, p1.Y, p2.X, p2.Y]);
end;

procedure EditorSelectParagraph(Ed: TSyntaxMemo);
var
  n1, n2: Integer;
begin
  with Ed do
  if Lines.Count>0 then
  begin
    n1:= CaretPos.Y;
    n2:= n1;
    if Trim(Lines[n1])='' then Exit;

    //n2: last para line
    repeat
      Inc(n2);
      if (n2>=Lines.Count) then Break;
      if Trim(Lines[n2])='' then Break;
    until false;
    Dec(n2);

    //n1: first para line
    repeat
      Dec(n1);
      if (n1<0) then Break;
      if Trim(Lines[n1])='' then Break;
    until false;
    Inc(n1);

    n1:= CaretPosToStrPos(Point(0, n1));
    n2:= CaretPosToStrPos(Point(Lines.LineSpace(n2), n2));
    SetSelection(n1, n2-n1);
  end;
end;

procedure EditorSelectOrJumpToWordEnd(Ed: TSyntaxMemo; ASelect: boolean);
var
  wEnd, wStart, n: Integer;
begin
  with Ed do
  begin
    WordRangeAtPos(CaretPos, wStart, wEnd);
    if (wEnd <= wStart) or (wEnd = CaretStrPos) then
    begin
      if ASelect then
        ExecCommand(smSelWordRight)
      else
        ExecCommand(smWordRight);
      Exit
    end;
    n:= SelStart;
    CaretStrPos:= wEnd;
    if ASelect then
      SetSelection(n, wEnd-n);
  end;
end;


function EditorJumpBlankLine(Ed: TSyntaxMemo; AOffsetTop: Integer; ANext: boolean): boolean;
var
  n: Integer;
begin
  Result:= false;
  with Ed do
  begin
    n:= CaretPos.Y;
    repeat
      if ANext then Inc(n) else Dec(n);
      if (n<0) or (n>=Lines.Count) then Exit;
      if Trim(Lines[n])='' then Break;
    until false;

    CaretPos:= Point(0, n);
    EditorCenterPos(Ed, true, AOffsetTop);
    Result:= true;
  end;
end;

procedure EditorJumpSelectionStartEnd(Ed: TSyntaxMemo);
var
  IsStart: boolean;
  NStart, NLen: integer;
begin
  with Ed do
    if SelLength=0 then
      Exit
    else
    begin
      NStart:= SelStart;
      NLen:= SelLength;
      IsStart:= CaretStrPos = NStart;
      if not IsStart then
        CaretStrPos:= NStart
      else
        CaretStrPos:= NStart + NLen;
      SetSelection(NStart, NLen, true{DoNotMovecaret});
    end;
end;


function EditorPasteAsColumnBlock(Ed: TSyntaxMemo): boolean;
begin
  Result:= TntClipboard.HasFormat(CF_TEXT);
  if Result then
    Ed.PasteFromClipboard(true);
end;

procedure EditorClearMarkers(Ed: TSyntaxMemo);
begin
  with Ed do
  begin
    Markers.Clear;
    MarkersLen.Clear;
    Invalidate;
  end;
end;

procedure EditorJumpToLastMarker(Ed: TSyntaxMemo);
begin
  with Ed do
    if Markers.Count>0 then
      GotoMarker(TMarker(Markers.Last))
end;

procedure EditorUpdateCaretPosFromMousePos(Ed: TSyntaxMemo);
var
  p: TPoint;
begin
  p:= Mouse.CursorPos;
  p:= Ed.ScreenToClient(p);
  Ed.CaretPos:= Ed.MouseToCaret(p.x, p.y);
end;


function EditorIndentStringForPos(Ed: TSyntaxMemo; PntPos: TPoint): Widestring;
var
  NPos: Integer;
begin
  NPos:= Ed.LinesPosToLog(PntPos).X;
  Result:= StringOfChar(' ', NPos);
  if Ed.TabMode=tmTabChar then
    SReplaceAllW(Result, EditorTabExpansion(Ed), #9);
end;

function EditorIndentStringForLine(Ed: TSyntaxMemo; Line: Integer): Widestring;
begin
  Result:= '';
  if (Line>=0) and (Line<Ed.Lines.Count) then
    Result:= SIndentOf(Ed.Lines[Line]);
end;

function SIndentedSnippetString(const StrText, StrSnippet, StrTextEol, StrSnippetEol: Widestring; NStart: Integer): Widestring;
var
  StrIndent: Widestring;
  Decode: TStringDecodeRecW;
  i: Integer;
begin
  StrIndent:= '';
  i:= NStart;
  while (i>1) and not IsLineBreakChar(StrText[i-1]) do
  begin
    Dec(i);
    if StrText[i]=#9 then
      StrIndent:= StrText[i] + StrIndent
    else
      StrIndent:= ' ' + StrIndent;
  end;

  Decode.SFrom:= StrSnippetEol;
  Decode.STo:= StrTextEol + StrIndent;

  Result:= SDecodeW(StrSnippet, Decode);
end;

procedure EditorInsertSnippet(Ed: TSyntaxMemo;
  const AText, ASelText, AFilename: Widestring);
var
  NInsertStart: Integer;
  NInsertPos: array[0..100] of Integer;
  NInsertLen: array[0..100] of Integer;
  //
  procedure DoInsPnt(N: Integer);
  var
    NPos, NLenFull, NLenReal: Integer;
  begin
    if NInsertPos[N]>=0 then
    begin
      NLenFull:= NInsertLen[N];
      NLenReal:= LoWord(NLenFull);
      NPos:= NInsertStart + NInsertPos[N] + NLenReal;
      Ed.DropMarker(Ed.StrPosToCaretPos(NPos));
      Ed.CaretStrPos:= NPos;
      Ed.MarkersLen.Add(Pointer(NLenFull));
    end;
  end;
  //
var
  Str, SId, SVal: Widestring;
  Decode: TStringDecodeRecW;
  NStart, NEnd, i: Integer;
  NIdStart, NIdEnd: Integer;
  NMirrorCnt: Integer;
begin
  //make string, which gives corrent indent
  Str:= Ed.Lines[Ed.CurrentLine];
  Insert('x', Str, Ed.CaretPos.X+1);

  //replace #13 with real_eol + indent
  Decode.SFrom:= #13;
  Decode.STo:= EditorEOL(Ed) + SIndentOf(Str);
  Str:= SDecodeW(AText, Decode);

  //snippet may have Tabs
  if Ed.TabMode=tmSpaces then
  begin
    SReplaceAllW(Str, #9, EditorTabExpansion(Ed));
  end;  

  for i:= Low(NInsertLen) to High(NInsertLen) do
  begin
    NInsertLen[i]:= -1;
    NInsertPos[i]:= -1;
  end;

  SReplaceAllW(Str, '\\', #1); //replace double-slashes (so only single slashes remain)
  NMirrorCnt:= 9; //first mirrors index is 10
  NStart:= 0;

  //process macros
  repeat
    NStart:= PosEx('${', Str, NStart+1);
    if NStart=0 then Break;

    //skip escaped "$"
    if (NStart>1) and (Str[NStart-1]='\') then
    begin
      Delete(Str, NStart-1, 1);
      Continue;
    end;

    NEnd:= PosEx('}', Str, NStart);
    if NEnd=0 then Continue;

    NIdStart:= NStart+2;
    NIdEnd:= NIdStart;
    while (NIdEnd<=Length(Str)) and IsWordChar(Str[NIdEnd]) do Inc(NIdEnd);
    SVal:= Copy(Str, NIdStart, NEnd-NIdStart);
    SId:= SGetItem(SVal, ':');

    //is tabstop found?
    for i:= 0 to 9 do
      if SId=IntToStr(i) then
      begin
        if NInsertPos[i]>=0 then
        begin
          //mirror tabstop
          Inc(NMirrorCnt);
          if NMirrorCnt<=High(NInsertPos) then
          begin
            NInsertPos[NMirrorCnt]:= NStart-1;
            NInsertLen[NMirrorCnt]:= MakeLong(Length(SVal), i);
          end;
        end
        else
        begin
          //original tabstop
          NInsertPos[i]:= NStart-1;
          NInsertLen[i]:= MakeLong(Length(SVal), i);
        end;
      end;

    if SId='date' then
    begin
      SVal:= FormatDateTime(SVal, Now);
    end;

    if SId='sel' then
    begin
      SVal:= SIndentedSnippetString(Str, ASelText, EditorEOL(Ed), EditorEOL(Ed), NStart);
    end;

    if SId='cp' then
    begin
      SVal:= SIndentedSnippetString(Str, TntClipboard.AsWideText, EditorEOL(Ed), #13#10, NStart);
    end;

    if SId='fname' then
    begin
      SVal:= WideChangeFileExt(WideExtractFileName(AFilename), '');
    end;

    Delete(Str, NStart, NEnd-NStart+1);
    Insert(SVal, Str, NStart);

    Inc(NStart, Length(SVal)-1); //skip this macro
  until false;

  SReplaceAllW(Str, #1, '\'); //replace #1 to slash

  //insert text
  Ed.BeginUpdate;
  try
    //fix CaretStrPos, for virtual caret pos
    Ed.InsertText('');
    //remember caret pos
    NInsertStart:= Ed.CaretStrPos;
    Ed.InsertText(Str);
  finally
    Ed.EndUpdate;
  end;

  //place markers (0 is last one, place first)
  Ed.Markers.Clear;
  Ed.MarkersLen.Clear;

  for i:= High(NInsertLen) downto 10 do
    DoInsPnt(i);

  DoInsPnt(0);
  for i:= 9 downto 1 do
    DoInsPnt(i);

  if Ed.IsTabstopMode then
    Ed.DoJumpToNextTabstop;

  //update statusbar  
  if Assigned(Ed.OnSelectionChanged) then
    Ed.OnSelectionChanged(Ed);
end;


function EditorGetWordBeforeCaret(Ed: TSyntaxMemo; AllowDot: boolean): Widestring;
var
  N: Integer;
  ch: WideChar;
begin
  Result:= '';
  N:= Ed.CaretStrPos+1;
  //if IsWordChar(Ed.Lines.Chars[N]) then Exit; //don't allow letter after caret
  repeat
    Dec(N);
    ch:= Ed.Lines.Chars[N];
    if IsWordChar(ch) or (ch='$') or (AllowDot and (ch='.')) then
      Insert(ch, Result, 1)
    else
      Break;
  until false;
end;

function EditorGetBottomLineIndex(Ed: TSyntaxMemo): Integer;
begin
  Result:= Ed.MouseToCaret(0, Ed.ClientHeight-1).Y;
end;

procedure EditorSetBookmarkUnnumbered(Ed: TSyntaxMemo;
  NPos, NIcon, NColor: Integer;
  const SHint: string);
const
  cMaxBk = 1*1000*1000;
var
  nIndex, i: Integer;
begin
  //find free bookmark-index
  nIndex:= -1;
  for i:= 10 to cMaxBk do
    if Ed.Bookmarks[i]<0 then
    begin
      nIndex:= i;
      Break;
    end;

  if nIndex<0 then Exit;
  Ed.Bookmarks[nIndex]:= NPos;

  //correct bookmark color and icon
  if (NIcon<0) and (NColor<0) then Exit;
  
  for i:= 0 to Ed.BookmarkObj.Count-1 do
    if Ed.BookmarkObj.Items[i].BmIndex= nIndex then
    begin
      if NIcon>=0 then
        Ed.BookmarkObj.Items[i].ImageIndex:= NIcon;
      if NColor>=0 then
        Ed.BookmarkObj.Items[i].BgColor:= NColor;
      if SHint<>'' then
        Ed.BookmarkObj.Items[i].Hint:= SHint;
      Break
    end;
end;

procedure EditorClearBookmarks(Ed: TSyntaxMemo);
begin
  Ed.BookmarkObj.Clear;
  Ed.Invalidate;
end;

procedure EditorBookmarkCommand(Ed: TSyntaxMemo; NCmd, NPos, NIcon, NColor: Integer; const SHint: string);
//deprecated, delete ltr
begin
  case NCmd of
    0..9:
      begin
        Ed.Bookmarks[NCmd]:= NPos;
        Ed.Invalidate;
      end;
    -1: EditorSetBookmarkUnnumbered(Ed, NPos, NIcon, NColor, SHint);
    -2: EditorClearBookmarks(Ed);
  end;
end;

procedure EditorBookmarkAddWithTag(Ed: TSyntaxMemo; NTag, NPos, NIcon, NColor: Integer; const SHint: string);
begin
  case NTag of
    0:
      EditorSetBookmarkUnnumbered(Ed, NPos, NIcon, NColor, SHint);
    1..10:
      begin
        Ed.Bookmarks[NTag-1]:= NPos;
        Ed.Invalidate;
      end;
  end;
end;

function EditorMouseCursorOnNumbers(Ed: TSyntaxMemo): boolean;
var
  P: TPoint;
begin
  P:= Mouse.CursorPos;
  P:= Ed.ScreenToClient(P);
  Result:= Ed.LineNumbers.Visible and
    //assume that line-numbers column is 0
    (P.X >= 0) and (P.X < Ed.Gutter.Bands[0].Width);
end;


procedure EditorGetTokenType(Ed: TSyntaxMemo;
  StartPos, EndPos: Integer;
  var IsCmt, IsStr: boolean);
var
  Lexer, Style: string;
begin
  IsCmt:= false;
  IsStr:= false;
  Lexer:= EditorCurrentLexerForPos(Ed, StartPos);
  if Lexer='' then Exit;
  Style:= EditorGetTokenName(Ed, StartPos, EndPos);

  if _TokenLexer<>Lexer then
  begin
    _TokenLexer:= Lexer;
    _TokenStylesStrings:= LexerCommentsProperty(Lexer, 'styles_str');
    _TokenStylesComments:= LexerCommentsProperty(Lexer, 'styles_cmt');
  end;

  IsCmt:= IsStringListed(Style, _TokenStylesComments);
  IsStr:= IsStringListed(Style, _TokenStylesStrings);

  //treat empty style as "string", but only for lexers, which aren't described
  if (Style='') and
    (_TokenStylesComments='') and
    (_TokenStylesStrings='') then
  begin
    IsCmt:= false;
    IsStr:= true;
  end;
end;


procedure EditorGetColorCodeRange(Ed: TSyntaxMemo; var NStart, NEnd: integer; var NColor: integer);
var
  p: TPoint;
  s: ecString;
  wStart, wEnd: integer;
begin
  NColor:= $FFFFFF;
  NStart:= 0;
  NEnd:= 0;
  with Ed do
    if (Lines.Count>0) then
    begin
      s:= Lines.FText;
      p:= CaretPos;
      if (CaretStrPos<Length(s)) and
        (s[CaretStrPos+1]='#') then Inc(p.X);
      WordRangeAtPos(p, wStart, wEnd);

      //needed for fixed ecSyntMemo's WordRangeAtPos
      if (wStart+1<=Length(s)) and (s[wStart+1]='#') then
        Inc(wStart);

      if (wStart>0) and (wStart<=Length(s)) and (s[wStart]='#') and
        (wEnd>wStart) then
      begin
        s:= Copy(s, wStart+1, wEnd-wStart);
        if IsHexColorString(s) then
        begin
          NColor:= SHtmlCodeToColor(s);
          NStart:= wStart-1;
          NEnd:= wEnd;
        end;
      end;
    end;
end;


procedure EditorInsertColorCode(Ed: TSyntaxMemo; Code: Integer);
var
  wStart, wEnd, NColor: Integer;
  SCode: string;
begin
  //get color for HTML
  SCode:= SColorToHtmlCode(Code);

  with Ed do
    if not ReadOnly then
    begin
      BeginUpdate;
      try
        EditorGetColorCodeRange(Ed, wStart, wEnd, NColor);
        if (wEnd>wStart) then
        begin
          CaretStrPos:= wStart;
          DeleteText(wEnd-wStart);
        end;
        InsertText(SCode);
      finally
        EndUpdate;
      end;
    end;
end;


const
  PROP_COLOR_TEXT                  = 'text';
  PROP_COLOR_TEXT_BG               = 'text_bg';
  PROP_COLOR_SELECTION_TEXT        = 'sel_text';
  PROP_COLOR_SELECTION_BG          = 'sel_bg';
  PROP_COLOR_CURRENT_LINE_TEXT     = 'curline_text';
  PROP_COLOR_CURRENT_LINE_BG       = 'curline_bg';
  PROP_COLOR_LINE_NUMBERS_TEXT     = 'numbers_text';
  PROP_COLOR_LINE_NUMBERS_BG       = 'numbers_bg';
  PROP_COLOR_COLLAPSE_LINE         = 'collapse_line';
  PROP_COLOR_COLLAPSE_MARK_TEXT    = 'collapse_mark_text';
  PROP_COLOR_COLLAPSE_MARK_BG      = 'collapse_mark_bg';
  PROP_COLOR_FOLDING_LINES         = 'folding_lines';
  PROP_COLOR_FOLDING_BAR_BG        = 'folding_bar_bg';
  PROP_COLOR_MARGIN                = 'margin';
  PROP_COLOR_HINTS_TEXT            = 'hints_text';
  PROP_COLOR_HINTS_BG              = 'hints_bg';
  PROP_COLOR_NONPRINTABLE_TEXT     = 'nonprint_text';
  PROP_COLOR_NONPRINTABLE_BG       = 'nonprint_bg';
  PROP_COLOR_INDENT_STAPLES        = 'indent_staples';
  PROP_COLOR_RULER_TEXT            = 'ruler_text';
  PROP_COLOR_RULER_BG              = 'ruler_bg';
  PROP_COLOR_MARKS_TEXT            = 'marks_text';
  PROP_COLOR_MARKS_BG              = 'marks_bg';
  PROP_COLOR_LINE_STATE_MODIFIED   = 'state_mod';
  PROP_COLOR_LINE_STATE_NEW        = 'state_new';
  PROP_COLOR_LINE_STATE_SAVED      = 'state_saved';
  PROP_COLOR_LINE_STATE_UNCHANGED  = 'state_unchanged';
  PROP_COLOR_LINE_STATE_DEFAULT    = 'state_def';
  PROP_COLOR_SYNCEDIT_BG           = 'syncedit_bg';   

procedure EditorSetColorPropertyById(Ed: TSyntaxMemo; const Id: string; Color: Longint);
begin
  if Id=PROP_COLOR_TEXT then
    Ed.Font.Color:= Color
  else
  if Id=PROP_COLOR_TEXT_BG then
    Ed.Color:= Color
  else
  if Id=PROP_COLOR_SELECTION_TEXT then
    Ed.DefaultStyles.SelectioMark.Font.Color:= Color
  else
  if Id=PROP_COLOR_SELECTION_BG then
    Ed.DefaultStyles.SelectioMark.BgColor:= Color
  else
  if Id=PROP_COLOR_CURRENT_LINE_TEXT then
    Ed.DefaultStyles.CurrentLine.Font.Color:= Color
  else
  if Id=PROP_COLOR_CURRENT_LINE_BG then
    Ed.DefaultStyles.CurrentLine.BgColor:= Color
  else
  if Id=PROP_COLOR_LINE_NUMBERS_TEXT then
  begin
    Ed.LineNumbers.Font.Color:= Color;
    Ed.LineNumbers.UnderColor:= Color;
  end
  else
  if Id=PROP_COLOR_LINE_NUMBERS_BG then
  begin
    Ed.Gutter.Bands[0].Color:= Color;
    Ed.Gutter.Bands[1].Color:= Color;
  end
  else
  if Id=PROP_COLOR_COLLAPSE_LINE then
    Ed.CollapseBreakColor:= Color
  else
  if Id=PROP_COLOR_COLLAPSE_MARK_TEXT then
    Ed.DefaultStyles.CollapseMark.Font.Color:= Color
  else
  if Id=PROP_COLOR_COLLAPSE_MARK_BG then
    Ed.DefaultStyles.CollapseMark.BgColor:= Color
  else
  if Id=PROP_COLOR_FOLDING_LINES then
    Ed.Gutter.CollapsePen.Color:= Color
  else
  if Id=PROP_COLOR_FOLDING_BAR_BG then
    Ed.Gutter.Bands[3].Color:= Color
  else
  if Id=PROP_COLOR_MARGIN then
    Ed.RightMarginColor:= Color
  else
  if Id=PROP_COLOR_HINTS_TEXT then
    Ed.HintProps.Font.Color:= Color
  else
  if Id=PROP_COLOR_HINTS_BG then
    Ed.HintProps.Color:= Color
  else
  if Id=PROP_COLOR_NONPRINTABLE_TEXT then
    Ed.NonPrinted.Color:= Color
  else
  if Id=PROP_COLOR_NONPRINTABLE_BG then
    ecSyntMemo.opColorNonPrintedBG:= Color
  else
  if Id=PROP_COLOR_INDENT_STAPLES then
    Ed.StaplePen.Color:= Color
  else
  if Id=PROP_COLOR_RULER_TEXT then
    Ed.HorzRuler.Font.Color:= Color
  else
  if Id=PROP_COLOR_RULER_BG then
    Ed.HorzRuler.Color:= Color
  else
  if Id=PROP_COLOR_MARKS_TEXT then
    Ed.DefaultStyles.SearchMark.Font.Color:= Color
  else
  if Id=PROP_COLOR_MARKS_BG then
    Ed.DefaultStyles.SearchMark.BgColor:= Color
  else
  if Id=PROP_COLOR_LINE_STATE_MODIFIED then
    Ed.LineStateDisplay.ModifiedColor:= Color
  else
  if Id=PROP_COLOR_LINE_STATE_NEW then
    Ed.LineStateDisplay.NewColor:= Color
  else
  if Id=PROP_COLOR_LINE_STATE_SAVED then
    Ed.LineStateDisplay.SavedColor:= Color
  else
  if Id=PROP_COLOR_LINE_STATE_UNCHANGED then
    Ed.LineStateDisplay.UnchangedColor:= Color
  else
  if Id=PROP_COLOR_LINE_STATE_DEFAULT then
    Ed.Gutter.Bands[2].Color:= Color
  else
  if Id=PROP_COLOR_SYNCEDIT_BG then
    Ed.SyncEditing.SyncRangeStyle.BgColor:= Color
  else
    begin end;
end;

function EditorGetColorPropertyById(Ed: TSyntaxMemo; const Id: string): Longint;
begin
  if Id=PROP_COLOR_TEXT then
    Result:= Ed.Font.Color
  else
  if Id=PROP_COLOR_TEXT_BG then
    Result:= Ed.Color
  else
  if Id=PROP_COLOR_SELECTION_TEXT then
    Result:= Ed.DefaultStyles.SelectioMark.Font.Color
  else
  if Id=PROP_COLOR_SELECTION_BG then
    Result:= Ed.DefaultStyles.SelectioMark.BgColor
  else
  if Id=PROP_COLOR_CURRENT_LINE_TEXT then
    Result:= Ed.DefaultStyles.CurrentLine.Font.Color
  else
  if Id=PROP_COLOR_CURRENT_LINE_BG then
    Result:= Ed.DefaultStyles.CurrentLine.BgColor
  else
  if Id=PROP_COLOR_LINE_NUMBERS_TEXT then
    Result:= Ed.LineNumbers.Font.Color
  else
  if Id=PROP_COLOR_LINE_NUMBERS_BG then
    Result:= Ed.Gutter.Bands[1].Color
  else
  if Id=PROP_COLOR_COLLAPSE_LINE then
    Result:= Ed.CollapseBreakColor
  else
  if Id=PROP_COLOR_COLLAPSE_MARK_TEXT then
    Result:= Ed.DefaultStyles.CollapseMark.Font.Color
  else
  if Id=PROP_COLOR_COLLAPSE_MARK_BG then
    Result:= Ed.DefaultStyles.CollapseMark.BgColor
  else
  if Id=PROP_COLOR_FOLDING_LINES then
    Result:= Ed.Gutter.CollapsePen.Color
  else
  if Id=PROP_COLOR_FOLDING_BAR_BG then
    Result:= Ed.Gutter.Bands[3].Color
  else
  if Id=PROP_COLOR_MARGIN then
    Result:= Ed.RightMarginColor
  else
  if Id=PROP_COLOR_HINTS_TEXT then
    Result:= Ed.HintProps.Font.Color
  else
  if Id=PROP_COLOR_HINTS_BG then
    Result:= Ed.HintProps.Color
  else
  if Id=PROP_COLOR_NONPRINTABLE_TEXT then
    Result:= Ed.NonPrinted.Color
  else
  if Id=PROP_COLOR_NONPRINTABLE_BG then
    Result:= ecSyntMemo.opColorNonPrintedBG
  else
  if Id=PROP_COLOR_INDENT_STAPLES then
    Result:= Ed.StaplePen.Color
  else
  if Id=PROP_COLOR_RULER_TEXT then
    Result:= Ed.HorzRuler.Font.Color
  else
  if Id=PROP_COLOR_RULER_BG then
    Result:= Ed.HorzRuler.Color
  else
  if Id=PROP_COLOR_MARKS_TEXT then
    Result:= Ed.DefaultStyles.SearchMark.Font.Color
  else
  if Id=PROP_COLOR_MARKS_BG then
    Result:= Ed.DefaultStyles.SearchMark.BgColor
  else
  if Id=PROP_COLOR_LINE_STATE_MODIFIED then
    Result:= Ed.LineStateDisplay.ModifiedColor
  else
  if Id=PROP_COLOR_LINE_STATE_NEW then
    Result:= Ed.LineStateDisplay.NewColor
  else
  if Id=PROP_COLOR_LINE_STATE_SAVED then
    Result:= Ed.LineStateDisplay.SavedColor
  else
  if Id=PROP_COLOR_LINE_STATE_UNCHANGED then
    Result:= Ed.LineStateDisplay.UnchangedColor
  else
  if Id=PROP_COLOR_LINE_STATE_DEFAULT then
    Result:= Ed.Gutter.Bands[2].Color
  else
  if Id=PROP_COLOR_SYNCEDIT_BG then
    Result:= Ed.SyncEditing.SyncRangeStyle.BgColor
  else
    Result:= 0;
end;

procedure EditorSetCaretShape(Ed: TSyntaxMemo; AShape: TATCaretShape; AInsMode: boolean);
var
  sh: TecCaretShape;
begin
  if AInsMode then
    sh:= Ed.Caret.Insert
  else
    sh:= Ed.Caret.Overwrite;

  case AShape of
    cCrVert1px:
      begin
        sh.Width:= -1; //negative: vertical line x1
        sh.Height:= 100;
      end;
    cCrVert2px:
      begin
        sh.Width:= -2; //negative: vertical line x2
        sh.Height:= 100;
      end;
    cCrVert3px:
      begin
        sh.Width:= -3; //negative: vertical line x3
        sh.Height:= 100;
      end;
    cCrVertHalf:
      begin
        sh.Width:= 50; //percents
        sh.Height:= 100;
      end;
    cCrFull:
      begin
        sh.Width:= 100;
        sh.Height:= 100;
      end;
    cCrHorz1px:
      begin
        sh.Width:= 100;
        sh.Height:= -1;
      end;
    cCrHorz2px:
      begin
        sh.Width:= 100;
        sh.Height:= -2;
      end;
    cCrHorz20perc:
      begin
        sh.Width:= 100;
        sh.Height:= 20;
      end;
    cCrHorzHalf:
      begin
        sh.Width:= 100;
        sh.Height:= 50;
      end;
    else
      raise Exception.Create('Unknown caret shape');
  end;
end;


function EditorGetBookmarkDesc(Ed: TSyntaxMemo;
  AIndex: Integer;
  ALenLimit: Integer;
  AShowLineNum, AShowNumberedChar: boolean): WideString;
var
  NLine: integer;
  SMark: Widestring;
begin
  Result:= '';
  NLine:= 0;
  if (AIndex<=9) and AShowNumberedChar then SMark:= '*' else SMark:= '';

  with Ed do
    if Bookmarks[AIndex]<>-1 then
    begin
      NLine:= StrPosToCaretPos(Bookmarks[AIndex]).Y;
      Result:= Lines[NLine];
    end;

  SReplaceAllW(Result, #9, EditorTabExpansion(Ed));

  if Length(Result)>ALenLimit then
    Result:= Copy(Result, 1, ALenLimit) + '...';

  if AShowLineNum then
    Result:= WideFormat('%d%s: %s', [NLine+1, SMark, Result])
  else
    Result:= WideFormat('%d: %s', [AIndex, Result]);
end;

function EditorGetBlockStaple(Ed: TSyntaxMemo; PosX, PosY: Integer): TBlockStaple;
var
  P: TPoint;
begin
  P:= Ed.CaretToMouse(PosX, PosY);
  Result:= Ed.IsOverStaple(P.X - Ed.StapleOffset, P.Y);
    //move TSyntaxMemo.IsOverStaple from "private" to "public"
end;

procedure EditorPrint(Ed: TSyntaxMemo; ASelOnly: boolean;
  const ATitle: string; APrinter: TecSyntPrinter);
var
  PrevTitle: string;
  PrevEd: TCustomSyntaxMemo;
begin
  with APrinter do
  begin
    PrevTitle:= Title;
    PrevEd:= SyntMemo;
    try
      Title:= ATitle;
      SyntMemo:= Ed;
      PrintSelection:= ASelOnly;
      Print;
    finally
      SyntMemo:= PrevEd;
      Title:= PrevTitle;
    end;
  end;
end;

procedure EditorUnderlineColorItem(Ed: TSyntaxMemo;
  const StrItem: Widestring;
  NLine, NPosStart, NPosEnd, NUnderSize: Integer);
var
  PosLeft: TPoint;
  NPosBottom, NColor, NItemWidth: Integer;
  ResStart, ResLen: TSynIntArray4;
  C: TCanvas;
begin
  C:= Ed.Canvas;

  //#rrggbb
  if IsHexColorString(StrItem) then
    NColor:= SHtmlCodeToColor(StrItem)
  else
  //rgb(...)
  if SFindRegexEx(StrItem, cRegexColorRgb, 1, ResStart, ResLen) then
    NColor:= RGB(
      StrToIntDef(Copy(StrItem, ResStart[1], ResLen[1]), 0),
      StrToIntDef(Copy(StrItem, ResStart[2], ResLen[2]), 0),
      StrToIntDef(Copy(StrItem, ResStart[3], ResLen[3]), 0))
  else
    Exit;

  PosLeft:= Ed.CaretToMouse(NPosStart-1, NLine);
  NItemWidth:= ecTextExtent(C, StrItem).cx;
  NPosBottom:= PosLeft.Y + Ed.DefLineHeight;

  C.Brush.Color:= NColor;
  C.FillRect(Types.Rect(
    PosLeft.X,
    NPosBottom - NUnderSize,
    PosLeft.X + NItemWidth,
    NPosBottom));
end;

function EditorGotoModifiedLine(Ed: TSyntaxMemo; ANext: boolean; ASavedToo: boolean): boolean;
var
  N, NCount: Integer;
  st: TLineState;
begin
  Result:= false;
  N:= Ed.CurrentLine;
  NCount:= Ed.Lines.Count;
  repeat
    if ANext then Inc(N) else Dec(N);
    if (N<0) or (N>=NCount) then Exit;
    st:= Ed.Lines.LineState[N];
    if (st=lsModified) or (st=lsNew) or (ASavedToo and (st=lsSaved)) then
    begin
      Result:= true;
      Ed.CaretPos:= Point(0, N);
      Exit
    end;
  until false;
end;

function EditorGetWordLengthForSpellCheck(Ed: TSyntaxMemo; APos: Integer): Integer;
var
  ch: WideChar;
begin
  Result:= 0;
  repeat
    ch:= Ed.Lines.Chars[APos+Result+1]; //no range-check needed, in Chars[]
    if not (IsWordChar(ch) or (ch='''')) then Break;
    Inc(Result);
  until false;
end;


procedure _ConvertCaseSent(var s: ecString);
var
  dot: boolean;
  i: Integer;
begin
  dot:= True;
  for i:= 1 to Length(s) do
  begin
    if IsAlphaChar(s[i]) then
    begin
      if dot then
        s[i]:= ecUpCase(s[i])
      else
        s[i]:= ecLoCase(s[i]);
      dot:= False;
    end
    else
      if (s[i] = '.') or (s[i] = '!') or (s[i] = '?') then
        dot:= True;
  end;
end;

//from ecSyntMemo.pas, function TCustomSyntaxMemo.ChangeCase
function _ChangeCase(Ed: TSyntaxMemo; Pos, Count: integer; Op: TSynTextCase): Boolean;
var
  s, s1: ecString;
  i: integer;
  c: ecChar;
begin
  s := Ed.Lines.SubString(Pos + 1, Count);
  s1 := s;
  case Op of
    cTextCaseUpper:
      for i := 1 to Length(s) do
        s[i] := ecUpCase(s[i]);
        
    cTextCaseLower:
      for i := 1 to Length(s) do
        s[i] := ecLoCase(s[i]);

    cTextCaseToggle:
      for i := 1 to Length(s) do
      begin
        c := ecUpCase(s[i]);
        if c = s[i] then s[i] := ecLoCase(c)
          else s[i] := c;
      end;

    cTextCaseTitle:
      begin
        for i := 1 to Length(s) do
          if IsAlphaChar(s[i]) then
            if (Pos + i - 1 = 0) or
               not IsAlphaChar(Ed.Lines.Chars[Pos + i - 1]) then
              s[i] := ecUpCase(s[i])
            else
              s[i] := ecLoCase(s[i]);
      end;

    cTextCaseSent:
      _ConvertCaseSent(s);

    cTextCaseRandom:
      begin
        for i:= 1 to Length(s) do
          if Odd(Random(100)) then
            s[i]:= ecUpCase(s[i])
          else
            s[i]:= ecLoCase(s[i]);
      end;
  end;
  Result := s <> s1;
  if Result then
    Ed.ReplaceText(Pos, Count, s);
end;


//from ecSyntMemo.pas, procedure BlockCase(Oper: TChangeCase);
procedure _ChangeCaseRect(Ed: TSyntaxMemo; Op: TSynTextCase);
var
  i, sLeft, sRight, cnt: integer;
  R: TRect;
begin
  Ed.BeginUpdate;
  try
    R := Ed.SelRect;
    for i := R.Top to R.Bottom do
    begin
      sLeft := Ed.LogToLinesPos(Point(R.Left, i)).X;
      sRight := Ed.LogToLinesPos(Point(R.Right, i)).X;
      cnt := Min(Ed.Lines.LineLength(i), sRight) - sLeft;
      if cnt > 0 then
      begin
        sLeft := Ed.CaretPosToStrPos(Point(sLeft, i));
        _ChangeCase(Ed, sLeft, cnt, Op);
      end;
    end;
  finally
    Ed.EndUpdate;
  end;
end;

//this wrapper is to apply case-convert to word under caret.
//if nothing selected, word changed and caret restored.
procedure EditorChangeBlockCase(Ed: TSyntaxMemo; Op: TSynTextCase);
var
  Sel: TSynSelSave;
  en: boolean;
begin
  EditorSaveSel(Ed, Sel);

  en:= true;
  //select current word, if no selection
  if not Ed.HaveSelection then
    en:= EditorSelectWord(Ed);

  //change case
  if en then
  begin
    if not Ed.HaveSelection then
      _ChangeCase(Ed, Ed.CaretStrPos, 1, Op)
    else
    if Ed.SelectMode <> msColumn then
      _ChangeCase(Ed, Ed.SelStart, Ed.SelLength, Op)
    else
      _ChangeCaseRect(Ed, Op);
  end;

  EditorRestoreSel(Ed, Sel);
end;

procedure LexerEnumSublexers(An: TSyntAnalyzer; List: TTntStringList);
var
  i: Integer;
  AnLink: TSyntAnalyzer;
begin
  List.Clear;
  for i:= 0 to An.SubAnalyzers.Count-1 do
  begin
    AnLink:= An.SubAnalyzers[i].SyntAnalyzer;
    if AnLink<>nil then
      List.Add(AnLink.LexerName)
    else
      List.Add('');
  end;      
end;

procedure LexerEnumStyles(An: TSyntAnalyzer; List: TTntStringList);
var
  i: Integer;
begin
  List.Clear;
  for i:= 0 to An.Formats.Count-1 do
    List.Add(An.Formats[i].DisplayName);
end;

procedure LexerSetSublexers(SyntaxManager: TSyntaxManager; An: TSyntAnalyzer; const Links: string);
var
  S, SItem: Widestring;
  Cnt: Integer;
begin
  S:= Links;
  Cnt:= 0;
  repeat
    SItem:= SGetItem(S, '|');
    if Cnt>=An.SubAnalyzers.Count then Break;
    An.SubAnalyzers[Cnt].SyntAnalyzer:= SyntaxManager.FindAnalyzer(SItem);
    Inc(Cnt);
  until false;
end;


end.
