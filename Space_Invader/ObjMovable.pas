// classe pour savoir dessiner n'importe quel bitmap pouvant bouger sur un canvas 
unit ObjMovable;

interface

uses Windows, SysUtils, Classes, Graphics, Math,ObjDrawable;

type

  TObjMovable = class(TObjDrawable)
  private

    fXvel        : single;
    fYvel        : single;

    fSpeed       : single;     // Vitesse de deplacement -8..-4  4..8
    fDirection   : single;     // Direction en degrés -80..-20  20..80

    _SpCosMul    : integer;    // arrondis de fSpeed * Cos(fDirection)
    _SpSinMul    : integer;    // arrondis de fSpeed * Sin(fDirection)

    fToDeleted    : boolean;
    procedure SetSingle(index : integer; val : single);

  protected
    procedure ComputeSPD;virtual;     // Calcul direction vitesse
    procedure Move;virtual;           // Calcul du deplacement
    procedure CheckOut;virtual;Abstract;       // Verification des limites de deplacement

  public
    property ToDeleted   : boolean         read fToDeleted   write fToDeleted default false;
    property XVel        : single          read fXVel        write fXVel;
    property YVel        : single          read fYVel        write fYVel;

    property Speed       : single  index 0 read fSpeed       write SetSingle;
    property Direction   : single  index 1 read fDirection   write SetSingle;

    procedure Progress;  // Procedure a appeler pour effectuer le deplacement

  end;

implementation

procedure TObjMovable.SetSingle(index : integer; val : single);
begin
  {
   fDirection est convertis en radian
   enfin, il faut appeler ComputeSPD pour recalculer les parametres
   vitesse/direction
  }
  case index of
    0 : fSpeed     := val;
    1 : fDirection := DegToRad(val);
  end;
  ComputeSPD;
end;

procedure TObjMovable.ComputeSPD;
var ST,CT : extended;
begin
  {
   Rien de bien compliqué.
   ComputeSPD est placée de maniere strategique dans les methodes notament :
      -creation de l'objet
      -changement des valeurs Vitesse/Direction.
      -inversion Vitesse/Direction.
   On l'appelle donc le moins souvent possible, ce qui augmente les performances
   car Round, Sin, Cos et multiplication demande beaucoups de cycles CPU.
   Pour Sin et Cos on prefere l'utilisation de SinCos qui vas beaucoup plus vite.
  }
  SinCos(fDirection,ST,CT);
  _SpCosMul := round(fSpeed * CT);
  _SpSinMul := round(fSpeed * ST);
end;

procedure TObjMovable.Move;
var
x,y : integer;
begin
  {
   Calcul de la position de la balle.
   On reduit a sa plus simple expression la formule de deplacement.
   grace a ComputeSPD, le calcul se resume a 2 additions par passe.
  }
  x := Coord.X;
  y := Coord.Y;
  x := x + _SpCosMul;
  y := y + _SpSinMul;
  Coord:=point(x,y);
end;

procedure TObjMovable.Progress;
begin

  if not Enabled then exit;
  Move;
  CheckOut;
end;

end.
