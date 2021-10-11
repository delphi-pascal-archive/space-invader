unit MeteorObj;

interface

uses Windows, SysUtils, Classes, Graphics,objMovable, Math;

type
  // les types de méteorite
  TMeteoriteType = (mtBig,mtMedium,mtTiny);

  TMeteorite = class(TobjMovable)
  private
    fMeteorType: TMeteoriteType;
    fPower     : integer;
  protected
    procedure CheckOut;override;
  public
    constructor Create(ACanvas : TCanvas; AMoveRect : TRect ; AMeteorType : TMeteoriteType);
    destructor Destroy; override;

    property MeteoriteType    : TMeteoriteType read fMeteorType write fMeteorType;
    property Power            : integer        read fPower      write fPower;
  end;

implementation



constructor TMeteorite.Create(ACanvas : TCanvas; AMoveRect : TRect ; AMeteorType : TMeteoriteType);
begin

  inherited Create(ACanvas,AMoveRect);
  // quelle n'arrvie pas tt de suite de la MoveRect
  Coord := point(Random(MoveRect.Right),MoveRect.Top-200);
  fMeteorType := AMeteorType;

  case fMeteorType of

    mtBig : begin
      Width := 119;
      Height := 76;
      Image.LoadFromFile(AppDir + 'MEDIA\Meteorite\MeteoriteBig.bmp');
      Direction:= 90 + Random(30);
      Speed:=1+Random(3);
      fPower := 100;
      end;

    mtMedium : begin
      Width := 74;
      Height := 58;
      Image.LoadFromFile(AppDir + 'MEDIA\Meteorite\MeteoriteMedium.bmp');
      Direction:= 90 + Random(50);
      Speed:=6+Random(2);
      fPower := 50;
      end;


    mtTiny : begin
      Width := 41;
      Height := 44;
      Image.LoadFromFile(AppDir + 'MEDIA\Meteorite\MeteoriteTiny.bmp');
      Direction:= 90 + Random(80);
      Speed:=8+Random(2);
      fPower := 25;
      end;
  end;

  Image.Transparent:=True;
  Image.TransparentColor:=ClLime;

end;

destructor TMeteorite.Destroy;
begin
  inherited destroy;
end;

procedure TMeteorite.CheckOut;
begin
  if (Coord.X ) >  MoveRect.Right then Coord := point(0,Coord.Y);
  if (Coord.X ) <  MoveRect.Left then  Coord := point(MoveRect.Right,Coord.Y);

  if (Coord.Y) > MoveRect.Bottom then ToDeleted:=true;
end;

end.
 