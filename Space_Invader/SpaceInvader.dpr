program SpaceInvader;

uses
  Forms,
  Main in 'Main.pas' {Form1},
  VaisseauObj in 'VaisseauObj.pas',
  ObjDrawable in 'ObjDrawable.pas',
  ObjMovable in 'ObjMovable.pas',
  MeteorObj in 'MeteorObj.pas',
  LaserObj in 'LaserObj.pas',
  Plateau in 'Plateau.pas',
  ThreadMouvement in 'ThreadMouvement.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
