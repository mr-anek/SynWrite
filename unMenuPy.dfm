object fmMenuPy: TfmMenuPy
  Left = 314
  Top = 475
  Width = 510
  Height = 322
  ActiveControl = Edit
  BorderIcons = [biSystemMenu, biMaximize]
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnClose = TntFormClose
  OnCreate = TntFormCreate
  OnKeyDown = FormKeyDown
  OnResize = TntFormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object List: TTntListBox
    Left = 0
    Top = 24
    Width = 494
    Height = 243
    Style = lbOwnerDrawFixed
    Align = alClient
    ItemHeight = 33
    TabOrder = 1
    OnDblClick = ListDblClick
    OnDrawItem = ListDrawItem
    OnKeyDown = ListKeyDown
  end
  object Edit: TTntEdit
    Left = 0
    Top = 0
    Width = 494
    Height = 24
    Align = alTop
    TabOrder = 0
    OnChange = EditChange
    OnKeyDown = EditKeyDown
  end
  object Panel1: TPanel
    Left = 0
    Top = 267
    Width = 494
    Height = 16
    Align = alBottom
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object LabelInfo: TTntLabel
      Left = 0
      Top = 0
      Width = 52
      Height = 16
      Align = alLeft
      Caption = '-------------'
    end
  end
  object TimerType: TTimer
    Enabled = False
    Interval = 500
    OnTimer = TimerTypeTimer
    Left = 384
    Top = 4
  end
end
