object AboutBox: TAboutBox
  Left = 200
  Top = 108
  BorderStyle = bsDialog
  Caption = 'O programie'
  ClientHeight = 305
  ClientWidth = 281
  Color = clWhite
  Font.Charset = EASTEUROPE_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = True
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 8
    Top = 272
    Width = 107
    Height = 13
    Hint = 'Kopiuj prawo :]'
    Caption = 'Copyright '#169' 2006 '
    Enabled = False
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Verdana'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
  end
  object Copyright: TLabel
    Left = 112
    Top = 24
    Width = 33
    Height = 13
    Caption = 'Berus'
    IsControl = True
  end
  object Version: TLabel
    Left = 152
    Top = 8
    Width = 94
    Height = 13
    Caption = 'Wersja 0.56 alfa'
    IsControl = True
  end
  object ProductName: TLabel
    Left = 64
    Top = 8
    Width = 79
    Height = 13
    Caption = 'Myszometer'
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
    IsControl = True
  end
  object Label1: TLabel
    Left = 64
    Top = 24
    Width = 40
    Height = 13
    Caption = 'Autor:'
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 8
    Top = 192
    Width = 127
    Height = 13
    Caption = 'Wielkie Thanks dla:'
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Image1: TImage
    Left = 8
    Top = 8
    Width = 49
    Height = 41
    Center = True
  end
  object Label4: TLabel
    Left = 64
    Top = 40
    Width = 44
    Height = 13
    Caption = 'E-Mail:'
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 120
    Top = 40
    Width = 66
    Height = 13
    Hint = 'berus4@o2.pl'
    Caption = 'berus4@o2.pl'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    OnClick = Label6Click
    OnMouseEnter = Label5MouseEnter
    OnMouseLeave = Label5MouseLeave
  end
  object Label6: TLabel
    Left = 16
    Top = 208
    Width = 23
    Height = 13
    Hint = 'arhi15@o2.pl'
    Caption = 'Arhi'
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Verdana'
    Font.Style = []
    ParentFont = False
    OnClick = Label6Click
    OnMouseEnter = Label6MouseEnter
    OnMouseLeave = Label6MouseLeave
  end
  object Label7: TLabel
    Left = 56
    Top = 208
    Width = 118
    Height = 13
    Caption = 'za wykonanie strony'
  end
  object Label8: TLabel
    Left = 16
    Top = 224
    Width = 74
    Height = 13
    Hint = 'PoP_Gniezno@interia.pl'
    Caption = 'PoP_Gniezno'
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Verdana'
    Font.Style = []
    ParentFont = False
    OnClick = Label6Click
    OnMouseEnter = Label6MouseEnter
    OnMouseLeave = Label6MouseLeave
  end
  object Label9: TLabel
    Left = 96
    Top = 224
    Width = 88
    Height = 13
    Caption = ' za beta testy:)'
  end
  object Bevel1: TBevel
    Left = 8
    Top = 256
    Width = 265
    Height = 9
    Shape = bsTopLine
  end
  object Label10: TLabel
    Left = 8
    Top = 56
    Width = 87
    Height = 13
    Caption = 'Strona WWW:'
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label11: TLabel
    Left = 104
    Top = 56
    Width = 101
    Height = 13
    Hint = 'http://dcm.ar-net.eu/'
    Caption = 'http://dcm.ar-net.eu/'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    OnClick = Label11Click
    OnMouseEnter = Label5MouseEnter
    OnMouseLeave = Label5MouseLeave
  end
  object Label12: TLabel
    Left = 8
    Top = 72
    Width = 261
    Height = 13
    Caption = 'Myszometer przechwytuje zdarzenia jakie s'#261' '
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Verdana'
    Font.Style = []
    ParentFont = False
  end
  object Label13: TLabel
    Left = 8
    Top = 88
    Width = 190
    Height = 13
    Caption = 'wywo'#322'ywane za pomoc'#261' myszki. '
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Verdana'
    Font.Style = []
    ParentFont = False
  end
  object Label14: TLabel
    Left = 8
    Top = 104
    Width = 245
    Height = 13
    Caption = 'Rejestrowane, zliczane i wizualizowane s'#261':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label15: TLabel
    Left = 16
    Top = 120
    Width = 189
    Height = 13
    Caption = '1. Odleg'#322'o'#347#263' jak'#261' pokona'#322' kursor'
  end
  object Label16: TLabel
    Left = 16
    Top = 136
    Width = 182
    Height = 13
    Caption = '2. LMB - lewe klikni'#281'cia myszk'#261
  end
  object Label17: TLabel
    Left = 16
    Top = 152
    Width = 193
    Height = 13
    Caption = '3. RMB - prawe klikni'#281'cia myszk'#261
  end
  object Label18: TLabel
    Left = 16
    Top = 168
    Width = 214
    Height = 13
    Caption = '4. MMB - '#347'rodkowe klikni'#281'cia myszk'#261
  end
  object Label19: TLabel
    Left = 16
    Top = 240
    Width = 27
    Height = 13
    Hint = 'markovcd@gmail.com'
    Caption = 'Pixel'
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Verdana'
    Font.Style = []
    ParentFont = False
    OnClick = Label6Click
    OnMouseEnter = Label6MouseEnter
    OnMouseLeave = Label6MouseLeave
  end
  object Label20: TLabel
    Left = 48
    Top = 240
    Width = 202
    Height = 13
    Caption = ' za beta testy + za szat'#281' graficzn'#261' '
  end
  object Button1: TButton
    Left = 199
    Top = 268
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
end
