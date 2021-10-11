unit Plateau;

interface

uses Windows,Classes,Controls,ExtCtrls,Messages,Contnrs,Jpeg,
     ObjDrawable,VaisseauObj,MeteorObj,LaserObj;

type
  TMouseEvent = procedure (Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer) of object;

  TPlateau = class (TPaintBox)

  private
    BackGround          : TObjDrawable;
    // j'ai utilisé 1 TListObject pour Vaisseau si par exemple , on veut gérér le
    // multi-joueur ... chose que je ne ferais certainement pas ;)
    ListVaisseau        : TObjectList;
    ListEnnemi          : TObjectList;
    ListLaser           : TObjectList;
    fAppDir             : String;
    // Guillemouze
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    // moi
    procedure WMMouseMove (var Message: TMessage); message WM_MOUSEMOVE;
    procedure WMMouseLeftClick(var Message: TMessage); message WM_LBUTTONDOWN;
    procedure WMMouseRightClick(var Message: TMessage); message WM_RBUTTONDOWN;
  public
    constructor Create(AOwner: TComponent;Parent : TWinControl);
    destructor  Destroy;overload;
    procedure   Paint; override;
    function    Load : boolean;
    procedure   CreerEnnemi;

    property ApplicationDirectory   :String           read fAppDir             write fAppDir;
    property VecteurVaissseau       : TObjectList     read ListVaisseau        write ListVaisseau;
    property VecteurEnnemi          : TObjectList     read ListEnnemi          write ListEnnemi;
    property VecteurLaser           : TObjectList     read ListLaser           write ListLaser;
end;

const
  NAME_BACKGROUND = '\MEDIA\BACKGROUND\Stars.jpg';
  MAX_METEORITE = 20;

implementation
uses ThreadMouvement;
var
  ThreadM     : TThreadMouvement;

constructor TPlateau.Create(AOwner: TComponent ; Parent : TWinControl);
begin
  inherited Create(AOwner);
  self.Parent:=Parent;
  self.Align:=alClient;
  // true , gère la libération des objects de la liste tt seul
  ListVaisseau:=TObjectList.Create(True);
  ListEnnemi:=TObjectList.Create(True);
  ListLaser := TObjectList.Create(True);
end;

destructor TPlateau.Destroy;
begin
  // TObjectList s'occupe de tOut
  ListVaisseau.Free;
  ListEnnemi.Free;
  ThreadM.Free;
  BackGround.Free;
  ListLaser.Free;
  inherited destroy;
end;

procedure TPlateau.CreerEnnemi;
var
  Meteor : TMeteorite;
  i   : integer;
begin
  for i:= 0 to MAX_METEORITE do begin
    Meteor := TMeteorite.Create(Canvas , ClientRect , mtMedium);
    ListEnnemi.Add(Meteor);
  end;
end;

function TPlateau.Load : boolean;
var
  jpg : TJpegImage;
  MonVaisseau: TVaisseau;
begin
  if  fAppDir='' then begin
    result:=false;
    exit;
  end;

  jpg := TJpegImage.Create;

  BackGround := TObjDrawable.Create(Canvas,ClientRect);
  jpg.LoadFromFile(fAppDir+NAME_BACKGROUND);
  BackGround.Image.Assign(jpg);
  jpg.Free;

  MonVaisseau := TVaisseau.Create(Canvas,ClientRect,vtBlue);
  ListVaisseau.Add(MonVaisseau);

  // mettre à true si on se sert de CMMouseEnter et leave ...
  ThreadM := TThreadMouvement.Create(false,self);

  result := true;
end;

{
  1 petit exemple à uoi ca pourrait servir , si tu sort de la fenetre , c que tu joue plus
  donc ca stop le thread , ainsi pas de prob :)
}
procedure TPlateau.CMMouseEnter(var Message: TMessage);
begin
  ShowCursor(False);
  //ThreadM.Resume;
end;

procedure TPlateau.CMMouseLeave(var Message: TMessage);
begin
  ShowCursor(True);
  //ThreadM.Suspend;
end;

procedure TPlateau.WMMouseMove(var Message: TMessage);
begin
  TVaisseau(ListVaisseau.First).Coord:=Point(Message.LParamLo,Message.LParamHi);
end;

procedure TPlateau.WMMouseLeftClick(var Message: TMessage);
var
  LaserTmp : TLaser;
  CoordV : TPoint;
begin
  CoordV := TVaisseau(ListVaisseau.First).Coord;
  LaserTmp := TLaser.Create(Canvas,ClientRect,Point(CoordV.X +TVaisseau(ListVaisseau.First).Width div 2,CoordV.Y-10),TVaisseau(ListVaisseau.First).LaserType);
  ListLaser.Add(LaserTmp)
end;

procedure TPlateau.WMMouseRightClick(var Message: TMessage);
begin
  if( TVaisseau(ListVaisseau.First).LaserType = ltDouble)then
     TVaisseau(ListVaisseau.First).LaserType := ltSimple
  else
     TVaisseau(ListVaisseau.First).LaserType := ltDouble;
end;



procedure TPlateau.Paint;
var
i :integer;
begin
    BackGround.Draw;
    for i:=0 to ListEnnemi.Count-1 do
       TObjDrawable(ListEnnemi.items[i]).Draw;

    for i:=0 to ListVaisseau.Count-1 do
       TObjDrawable(ListVaisseau.items[i]).Draw;
    for i:=0 to ListLaser.Count-1 do
       TObjDrawable(ListLaser.items[i]).Draw;
end;

end.
