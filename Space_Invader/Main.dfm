object Form1: TForm1
  Left = 220
  Top = 128
  Width = 840
  Height = 653
  Caption = 'Space Invader'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 120
  TextHeight = 16
  object PanelInfo: TPanel
    Left = 0
    Top = 0
    Width = 832
    Height = 129
    Align = alTop
    BevelOuter = bvNone
    Color = clWindowText
    TabOrder = 0
    DesignSize = (
      832
      129)
    object Label1: TLabel
      Left = 98
      Top = 5
      Width = 72
      Height = 28
      Caption = 'Power'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindow
      Font.Height = -25
      Font.Name = 'Zombie Guts Yanked'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object PowerGauge: TGauge
      Left = 39
      Top = 39
      Width = 189
      Height = 25
      BackColor = clWindow
      Color = clBlack
      ForeColor = clLime
      ParentColor = False
      Progress = 0
    end
    object Label2: TLabel
      Left = 864
      Top = 15
      Width = 89
      Height = 28
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = 'SCORE'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindow
      Font.Height = -25
      Font.Name = 'Zombie Guts Yanked'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object LabScore: TLabel
      Left = 864
      Top = 74
      Width = 89
      Height = 28
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = 'SCORE'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindow
      Font.Height = -25
      Font.Name = 'Zombie Guts Yanked'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
  end
  object MainMenu1: TMainMenu
    Left = 8
    Top = 136
    object mFichier: TMenuItem
      Caption = 'File'
      object miNewP: TMenuItem
        Caption = 'New game'
        OnClick = miNewPClick
      end
      object miPause: TMenuItem
        Caption = 'Pause'
        Enabled = False
        OnClick = miPauseClick
      end
      object miQuitter: TMenuItem
        Caption = 'Exit'
        OnClick = miQuitterClick
      end
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 25
    OnTimer = Timer1Timer
    Left = 40
    Top = 136
  end
end
