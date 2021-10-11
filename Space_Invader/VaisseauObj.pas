unit VaisseauObj;

interface

uses Windows, SysUtils, Classes, Graphics, Math,objDrawable,objMovable,LaserObj;

type
  // les types de vaisseaux , bleu , rouge et jaune ...
  TVaiseauType = (vtBlue,vtRed,vtYellow);

  TVaisseau = class(TobjMovable)
  private
    fVaisseauType: TVaiseauType;  // type du vaisseau
    fLaserType   : TLaserType;
    fPower : integer;
  protected
    procedure CheckOut;override;
  public
    constructor Create(ACanvas : TCanvas; AMoveRect : TRect ; AVaisseauType : TVaiseauType);
    destructor Destroy; override;

    property VaisseauType    : TVaiseauType read fVaisseauType write fVaisseauType;
    property Power           : integer      read fPower        write fPower default 100;
    property LaserType       : TLaserType   read fLaserType    write fLaserType;
    procedure Draw; overload;
    procedure Progress;overload;
  end;

implementation

function Middle(const ALeftOrTop, ARightOrBottom : integer) : integer;
begin
  {
   Calcul du millieu d'une droite.
   shr 1 = div 2
  }
  result := (ARightOrBottom-ALeftOrTop) shr 1;
end;


constructor TVaisseau.Create(ACanvas : TCanvas; AMoveRect : TRect ; AVaisseauType : TVaiseauType);
var
  i:integer;
begin
  inherited Create(ACanvas,AMoveRect);

  Coord := point(Middle(AMoveRect.Left,AMoveRect.Right),Middle(AMoveRect.Top,AMoveRect.Bottom));

  Width:= 52;
  Height:= 60;

  Direction:= 0;
  Speed:= 0;
  fVaisseauType := AVaisseauType;
  fLaserType := ltSimple;
  fPower:=100;
  case fVaisseauType of
    vtBlue :
      Image.LoadFromFile(AppDir + 'MEDIA\Vaisseau\VaisseauBlue.bmp');
    vtRed :
      Image.LoadFromFile(AppDir + 'MEDIA\Vaisseau\VaisseauRed.bmp');
    vtYellow :
      Image.LoadFromFile(AppDir + 'MEDIA\Vaisseau\VaisseauYellow.bmp');
  end;

  Image.Transparent:=True;
  Image.TransparentColor:=ClWhite;

end;

destructor TVaisseau.Destroy;
begin
  inherited destroy;
end;

procedure TVaisseau.CheckOut;
begin
  if (Coord.X ) >  MoveRect.Right then Coord := point(0,Coord.Y);
  if (Coord.X ) <  MoveRect.Left then  Coord := point(MoveRect.Right,Coord.Y);
end;


procedure TVaisseau.Draw;
var
  i:integer;
begin
  inherited Draw;
end;

procedure TVaisseau.Progress;
var
  i:integer;
begin
  inherited Progress;
end;

end.
