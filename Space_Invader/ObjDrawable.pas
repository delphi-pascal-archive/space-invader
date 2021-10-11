// classe pour savoir dessiner n'importe quel bitmap sur un canvas
unit ObjDrawable;

interface

uses Windows, SysUtils, Classes, Graphics, Math,Jpeg;

type


  TObjDrawable = class(TObject)
  private
    fAppDir       : String;
    fCanvas      : TCanvas;

    fMoveRect    : TRect;      // Zone d'affichage

    fBitmap      : Tbitmap;    // Bitmap

    fStretch     : Boolean; // si on agrandi , retreci l'image par rapport a Width Height

    fCoord       : TPoint;     // Coordoonées au sommet
    fWidth       : integer;    // TailleX
    fHeight      : integer;    // TailleY

    fEnabled     : boolean;    // True si Canvas assigné sinon False

    procedure SetEnabled(val : boolean);
    function GetEnabled : boolean;
    procedure SetBitmap(val : TBitmap);
    procedure SetAppDir(dir : String);
    function GetAppDir:String;

    procedure SetStretch(s : boolean);
    function GetStretch:boolean;

    function GetCoord:TPoint;
    procedure SetCoord ( p :Tpoint);

  public
    constructor Create(ACanvas : TCanvas; AMoveRect : TRect);
    destructor Destroy; override;

    property Canvas      : TCanvas read fCanvas      write fCanvas;
    property MoveRect    : TRect   read fMoveRect    write fMoveRect;

    property AppDir      : String  read GetAppdir    write SetAppDir;

    property Coord       : TPoint  read GetCoord     write SetCoord;
    property Width       : integer read fWidth       write fWidth ;
    property Height      : integer read fHeight      write fHeight ;

    property Enabled     : boolean read GetEnabled   write SetEnabled default true;

    property Image       : TBitmap read fBitmap      write SetBitmap;

    property Stretch     : Boolean read GetStretch   write SetStretch default false;

    function Collide(Obj:TObjDrawable):Boolean;
    procedure Draw;      // Procedure a appeler pour dessiner sur le canvas

  end;

implementation

constructor TObjDrawable.Create(ACanvas : TCanvas; AMoveRect : TRect);
begin
  {
   Appel du constructeur ancetre de TObject
  }
  inherited Create;
  {
   Assignation du canvas et du rectangle de zone d'affichage
  }
  fCanvas      := ACanvas;
  fMoveRect    := AMoveRect;

  {
   Précalcul de la position
  }
  // par defaut en haut à gauche
  fCoord       := point(0,0);
  // par defaut 0 0
  fWidth       := 0;
  fHeight      := 0;
  {
   Creation du bitmap
  }
  fBitmap      := TBitmap.Create;
  {
   Verification de l'assignation de fCanvas pour eviter les ACanvas = nil
  }
  fEnabled     := Assigned(fCanvas);
end;

destructor TObjDrawable.Destroy;
begin
  {
   Liberation du bitmap
  }
  fBitmap.Free;

  {
   Appel du destructeur de l'ancetre TObject
  }
  inherited destroy;
end;


function TObjDrawable.Collide(Obj:TObjDrawable):Boolean;
var
  Dummy:TRect;
begin
  if(Obj = nil ) then begin
    result:=false;
    exit;
  end;
  Result:=IntersectRect(Dummy,Rect(fCoord.X,fCoord.Y,fCoord.X+fWidth,fCoord.Y+fHeight),rect(obj.Coord.X,obj.Coord.Y,obj.Coord.X+obj.Width,obj.Coord.Y+obj.Height));
end;


procedure TObjDrawable.SetEnabled(val : boolean);
begin
  {
   On verifie l'assignation de fCanvas quand le developeur
   tente de modifier la propriété Enabled.
  }
  fEnabled := assigned(fCanvas) and val;
end;

function TObjDrawable.GetEnabled : boolean;
begin
  {
   On renvois un resultat en fonction de l'assignation de fCanvas
  }
  fEnabled := assigned(fCanvas);
  result   := fEnabled;
end;

procedure TObjDrawable.SetAppDir(dir : String);
begin
  AppDir := dir;
end;

function TObjDrawable.GetAppDir:String;
begin
  result := fAppDir;
end;

procedure TObjDrawable.SetBitmap(val : TBitmap);
begin
  {
   Assignation au bitmap
  }
  fBitmap.Assign(val);
end;

procedure TObjDrawable.SetStretch(s : boolean);
begin
  fStretch := s;
end;

function TObjDrawable.GetStretch:boolean;
begin
  result := fStretch;
end;

procedure TObjDrawable.SetCoord (p :Tpoint);
begin
  fCoord := p;
end;

function TObjDrawable.GetCoord:TPoint;
begin
  result := fCoord;
end;

procedure TObjDrawable.Draw;
begin
  if not fEnabled then exit;

  with fCanvas do
  begin
    if(fStretch) then
      StretchDraw(Rect(fCoord.X,fCoord.Y,fWidth,fHeight),fBitmap)
    else
      Draw(fCoord.X,fCoord.Y,fBitmap);
  end;
end;

end.
