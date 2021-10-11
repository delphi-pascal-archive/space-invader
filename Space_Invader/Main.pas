unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, Gauges, StdCtrls, Jpeg, Menus;

type
  TForm1 = class(TForm)
    PanelInfo: TPanel;
    Label1: TLabel;
    PowerGauge: TGauge;
    Label2: TLabel;
    MainMenu1: TMainMenu;
    mFichier: TMenuItem;
    miNewP: TMenuItem;
    miPause: TMenuItem;
    miQuitter: TMenuItem;
    LabScore: TLabel;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure miPauseClick(Sender: TObject);
    procedure miNewPClick(Sender: TObject);
    procedure miQuitterClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private

  public
      AppDir : String;
      procedure MakeFullScreen;
      procedure CreateObj;
      procedure DestroyObj;
  end;

const
  FULLSCREEN = true;
var
  Form1: TForm1;
implementation

{$R *.dfm}

uses Vaisseauobj,Plateau;
var
  Plateau : TPlateau;

procedure TForm1.MakeFullScreen;
begin
  Left := 0;
  Top:=0;
  Width := Screen.Monitors[0].Width;
  Height := Screen.Monitors[0].Height;
end;
{
  On place ici tous les objects qu'on créés
}

procedure TForm1.CreateObj;
begin
  Plateau := TPlateau.Create(self,self);
  Plateau.ApplicationDirectory := AppDir;
  Plateau.Load;
end;
{
  on libère ici tous les objects precedement crées
}

procedure TForm1.DestroyObj;
begin
  Plateau.Free;
end;

{
  Create Form
}
procedure TForm1.FormCreate(Sender: TObject);
begin
  PanelInfo.Height:=0;
  Randomize;
  // indispensable si on veut pas terminer aveugle !
  DoubleBuffered := True;
  // dossier de l'appli
  AppDir := ExtractFileDir(Application.ExeName);
  //fullscreen
  if(FULLSCREEN) then MakeFullScreen;
end;


procedure TForm1.FormDestroy(Sender: TObject);
begin
  DestroyObj;
end;

procedure TForm1.miPauseClick(Sender: TObject);
begin
  miPause.Checked := not miPause.Checked;
end;

procedure TForm1.miNewPClick(Sender: TObject);
var
  i : integer;
begin
  i:=PanelInfo.Height;
  if(i = 0 ) then begin
    while(i<65) do begin
      PanelInfo.Height :=PanelInfo.Height+1;
      i:=i+1;
      Application.ProcessMessages;
    end;
  end;
  CreateObj;
  miPause.Enabled:=True;
  Timer1.Enabled := True;
end;

procedure TForm1.miQuitterClick(Sender: TObject);
begin
  close;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  PowerGauge.Progress := TVaisseau(Plateau.VecteurVaissseau.First).Power;
end;

end.
