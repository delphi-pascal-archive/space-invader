unit LaserObj;

interface

uses Windows, SysUtils, Classes, Graphics, Math,objMovable,Dialogs;

type
  // les types de laser
  TLaserType = (ltSimple,ltDouble);
  TLaser = class(TobjMovable)
  private
    fLaserType: TLaserType;
    fDegat : integer;
  protected
    procedure CheckOut;override;
  public
    constructor Create(ACanvas : TCanvas; AMoveRect : TRect ; ACoord : TPoint;ALaserType : TLaserType);
    destructor Destroy; override;

    property LaserType    : TLaserType read fLaserType write fLaserType default ltSimple;
    property Degat        : integer    read fDegat     write fDegat;
  end;

implementation



constructor TLaser.Create(ACanvas : TCanvas; AMoveRect : TRect ; ACoord : TPoint;ALaserType : TLaserType);
begin

  inherited Create(ACanvas,AMoveRect);

  Coord := ACoord;

  Direction:= -90;

  fLaserType := ALaserType;

  ToDeleted := false;

  case fLaserType of

    ltSimple : begin
      Width := 2;
      Height := 8;
      Image.LoadFromFile(AppDir + 'MEDIA\Laser\LaserSimple.bmp');
      Speed:=15;
      fDegat := 25;
    end;

    ltDouble : begin
      Width := 6;
      Height := 8;
      Image.LoadFromFile(AppDir + 'MEDIA\Laser\LaserDouble.bmp');
      Speed:=10;
      fDegat := 50;
    end;
  end;

  Image.Transparent:=True;
  Image.TransparentColor:=ClBlack;

end;

destructor TLaser.Destroy;
begin
  inherited destroy;
end;

procedure TLaser.CheckOut;
begin
  if (Coord.X ) >  MoveRect.Right then Coord := point(0,Coord.Y);
  if (Coord.X ) <  MoveRect.Left then  Coord := point(MoveRect.Right,Coord.Y);

  if (Coord.Y) < MoveRect.Top then self.ToDeleted:=True;
end;



end.

