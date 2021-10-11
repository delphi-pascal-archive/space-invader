unit ThreadMouvement;

interface

uses Windows, Classes, SysUtils,Plateau,dialogs,ObjMovable,VaisseauObj,MeteorObj,LaserObj;

type
  TThreadMouvement = class(TThread)

  private
    fPlateau : TPlateau;
    procedure CentralControl;
    procedure ProgressEnnemi;
    procedure ProgressVaisseau;
    procedure ProgressLaser;
  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended:boolean;APlateau : TPlateau);overload;
    destructor  Destroy; override;
end;

implementation

constructor TThreadMouvement.Create(CreateSuspended:boolean;APlateau : TPlateau);
begin
  inherited Create(CreateSuspended);
  FreeOnTerminate:=false;
  Priority:=tpNormal;

  fPlateau := APlateau;
end;

destructor TThreadMouvement.Destroy;
begin
  inherited;
end;

procedure TThreadMouvement.ProgressEnnemi;
var
  i,j : integer;
begin
  for i:=0 to fPlateau.VecteurEnnemi.Count-1 do
  begin
    // on regarde si sont pas en collision % à 1 laser
    for j:=0 to fPlateau.VecteurLaser.Count-1 do begin
      if(TObjMovable(fPlateau.VecteurEnnemi.Items[i]).
         Collide(TLaser(fPlateau.VecteurLaser.Items[j])) )then begin
        // suppression  laser , ToDeleted := true Meteorite := Power - LaserDegat;
        TLaser(fPlateau.VecteurLaser.Items[j]).ToDeleted:=True;
        TMeteorite(fPlateau.VecteurEnnemi.Items[i]).Power:=TMeteorite(fPlateau.VecteurEnnemi.Items[i]).Power-TLaser(fPlateau.VecteurLaser.Items[j]).Degat;
      end;
    end;
    // on verifie si power Meteorite <0 , si oui ToDeleted := true
    if(TMeteorite(fPlateau.VecteurEnnemi.Items[i]).Power<0) then
       TMeteorite(fPlateau.VecteurEnnemi.Items[i]).ToDeleted := true;
    // on les fait avancé
    TObjMovable(fPlateau.VecteurEnnemi.Items[i]).Progress;
    // on regarde s'ils sont à deleted ... si oui , nil -> pack -> delete
    if(TObjMovable(fPlateau.VecteurEnnemi.Items[i]).ToDeleted) then
       fPlateau.VecteurEnnemi.Items[i]:=nil;
  end;

end;

procedure TThreadMouvement.ProgressVaisseau;
var
  i,j : integer;
begin

for i:=0 to fPlateau.VecteurVaissseau.Count-1 do
  begin
    // on regarde s'il n'est pas en collision ... , on doit parcourir l'ensemble de la
    // liste ennemi % a un vaisseau ...
    for j:=0 to fPlateau.VecteurEnnemi.Count-1 do begin
      if(TVaisseau(fPlateau.VecteurVaissseau.Items[i])).
         Collide(TObjMovable(fPlateau.VecteurEnnemi.Items[j])) then begin
          // retire les points de vie à notre joeur , mes a ToDeleted l'ennemi ...
          TVaisseau(fPlateau.VecteurVaissseau.Items[i]).Power :=TVaisseau(fPlateau.VecteurVaissseau.Items[i]).Power -10;
          TObjMovable(fPlateau.VecteurEnnemi.Items[j]).ToDeleted := true;
      end;
    end;

    // on les fait avancé
    TObjMovable(fPlateau.VecteurVaissseau.Items[i]).Progress;
    // si la vie < 0 toDeleted = true
   // A géré par après 
   (* if(TVaisseau(fPlateau.VecteurVaissseau.Items[i]).Power<=0) then
       TVaisseau(fPlateau.VecteurVaissseau.Items[i]).ToDeleted:=true;
       *)


    // on regarde s'ils sont à deleted ... si oui , nil -> pack -> delete
    if(TObjMovable(fPlateau.VecteurVaissseau.Items[i]).ToDeleted) then
       fPlateau.VecteurVaissseau.Items[i]:=nil;
  end;

end;

procedure TThreadMouvement.ProgressLaser;
var
  i : integer;
begin
  for i:=0 to fPlateau.VecteurLaser.Count-1 do begin
    TLaser(fPlateau.VecteurLaser.items[i]).Progress;
    if(TLaser(fPlateau.VecteurLaser.items[i]).ToDeleted)then
    fPlateau.VecteurLaser.Items[i]:=nil;
   end;
end;

procedure TThreadMouvement.CentralControl;
begin
   // quand il n'y a plus rien , il y en a encore , boucles ...
   if(fPlateau.VecteurEnnemi.Count = 0) then fPlateau.CreerEnnemi;

   ProgressEnnemi;
   ProgressVaisseau;
   ProgressLaser;

   // Pack delete ts les objects mis à nil , magique :)
  // merci encore TObjectList ;)
  fPlateau.VecteurEnnemi.Pack;
  fPlateau.VecteurVaissseau.Pack;
  fPlateau.VecteurLaser.Pack;

  // declenche onpaint de Plateau ...
  fPlateau.Refresh;
end;

procedure TThreadMouvement.Execute;
begin
  repeat
    Sleep(25); //en millisecondes
    Synchronize(CentralControl);
  until Terminated;
end;


end.
