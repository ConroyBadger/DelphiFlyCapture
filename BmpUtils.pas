unit BmpUtils;

interface

uses
  Windows, Graphics, Global, ExtCtrls;//, Bitmap;

type
  T3x3StructuredElement = array[1..3,1..3] of Boolean;
  T2x2StructuredElement = array[1..2,1..2] of Boolean;

const
  Simple3x3Element : T3x3StructuredElement =
    ((True,True,True),(True,True,True),(True,True,True));

function  CreateImageBmp:TBitmap;

procedure ClearBmp(Bmp:TBitmap;Color:TColor);
procedure ClearBmpAsm(Bmp:TBitmap);

procedure DrawSobelBmp(SrcBmp,SobelBmp:TBitmap;Threshold:Integer);
procedure DrawAnalogSobelBmp(SrcBmp,SobelBmp:TBitmap;Scale:Single);
procedure DrawShadows(Bmp:TBitmap;Threshold:Integer);
procedure DrawGradientBmp(SrcBmp,DestBmp:TBitmap;Threshold:Integer);
procedure DrawSmoothBmp(SrcBmp,DestBmp:TBitmap);
procedure DrawMonoBmp(SrcBmp,DestBmp:TBitmap);
procedure SubtractBmp(Bmp1,Bmp2,Bmp3:TBitmap);
procedure IntensifyBmp(Bmp:TBitmap;Scale:Single);
procedure ThresholdBmp(Bmp:TBitmap;Threshold:Integer);
procedure ConvertBmpToIntensityMap(Bmp:TBitmap;Threshold:Byte);
procedure DrawHistogram(SourceBmp,DestBmp:TBitmap);

procedure DrawTextOnBmp(Bmp:TBitmap;TextStr:String);
procedure DrawTextOnBmp2(TextStr:String;Bmp:TBitmap);

procedure ShowFrameRateOnBmp(Bmp:TBitmap;FrameRate:Single);
procedure SubtractColorBmp(Bmp1,Bmp2,Bmp3:TBitmap);
procedure MagnifyScreen(Bmp:TBitmap;Scale:Integer);
procedure MagnifyCopy(SrcBmp,IBmp,DestBmp:TBitmap;Xc,Yc,Scale:Integer);
procedure SwapRB(Bmp:TBitmap);

procedure SubtractBmpAsm(Bmp1,Bmp2,TargetBmp:TBitmap);
procedure SubtractBmpAsmAbs(Bmp1,Bmp2,TargetBmp:TBitmap);
procedure SubtractBmpAsmAbsSquared(Bmp1,Bmp2,TargetBmp:TBitmap);

procedure SubtractColorBmpAsm(Bmp1,Bmp2,TargetBmp:TBitmap);

procedure DrawSmoothBmpAsm(SrcBmp,DestBmp:TBitmap);
procedure DilateBmp3x3Asm(SrcBmp,DestBmp:TBitmap;Threshold:Byte);
procedure ThresholdBmpAsm(Bmp:TBitmap;Threshold:Byte);
function  BytesPerPixel(Bmp:TBitmap):Integer;

procedure DrawXHairs(Bmp:TBitmap;X,Y,R:Integer);

procedure FlipBmp(SrcBmp,DestBmp:TBitmap);
procedure MirrorBmp(SrcBmp,DestBmp:TBitmap);
procedure FlipAndMirrorBmp(SrcBmp,DestBmp:TBitmap);
procedure OrientBmp(SrcBmp,DestBmp:TBitmap;FlipImage,MirrorImage:Boolean);

function  CreateBmpForPaintBox(PaintBox:TPaintBox):TBitmap;
procedure InitBmpDataFromBmp(BmpData:PByte;Bmp:TBitmap;X1,Y1,X2,Y2:Integer);
procedure InitBmpFromBmpData(Bmp:TBitmap;BmpData:PByte;BmpW,BmpH:Integer);

procedure SubtractColorBmpAsmAbs(Bmp1,Bmp2,TargetBmp:TBitmap);
procedure OutlinePixel(Bmp:TBitmap;X,Y:Integer);
procedure DrawTestPatternOnBmp(Bmp:TBitmap;BackColor,LineColor:TColor;Spacing:Integer);

procedure HalfScaleBmp(SrcBmp,DestBmp:TBitmap);
procedure QuarterScaleBmp(SrcBmp,DestBmp:TBitmap);

function AverageI(Bmp:TBitmap):Single;

function BiggestFontSize(Bmp:TBitmap;Txt:String;W,H:Integer):Integer;

implementation

uses
  SysUtils, Classes, CameraU;

function BiggestFontSize(Bmp:TBitmap;Txt:String;W,H:Integer):Integer;
var
  TW,TH : Integer;
begin
  Result:=6;
  repeat
    Inc(Result);
    Bmp.Canvas.Font.Size:=Result;
    TW:=Bmp.Canvas.TextWidth(Txt);
    TH:=Bmp.Canvas.TextHeight(Txt);
  until (TW>W) or (TH>H);
  Dec(Result);
end;

function CreateBmpForPaintBox(PaintBox:TPaintBox):TBitmap;
begin
  Result:=TBitmap.Create;
  Result.Width:=PaintBox.Width;
  Result.Height:=PaintBox.Height;
  Result.PixelFormat:=pf24Bit;
end;

function CreateImageBmp:TBitmap;
begin
  Result:=TBitmap.Create;
  Result.PixelFormat:=pf24Bit;
end;

procedure ClearBmp(Bmp:TBitmap;Color:TColor);
begin
  Bmp.Canvas.Brush.Color:=Color;
  Bmp.Canvas.FillRect(Rect(0,0,Bmp.Width,Bmp.Height));
end;

procedure DrawSobelBmp(SrcBmp,SobelBmp:TBitmap;Threshold:Integer);
var
  Line1     : PByteArray;
  Line2     : PByteArray;
  Line3     : PByteArray;
  SobelLine : PByteArray;
  S1,S2,S   : Integer;
  X,Y       : Integer;
  P1,P2,P3  : Integer;
  P4,P5,P6  : Integer;
  P7,P8,P9  : Integer;
begin
  SobelBmp.Canvas.Brush.Color:=clBlack;
  SobelBmp.Canvas.FillRect(Rect(0,0,SobelBmp.Width,SobelBmp.Height));
  for Y:=1 to SrcBmp.Height-2 do begin
    Line1:=SrcBmp.ScanLine[Y-1];
    Line2:=SrcBmp.ScanLine[Y];
    Line3:=SrcBmp.ScanLine[Y+1];
    SobelLine:=SobelBmp.ScanLine[Y];
    for X:=1 to SrcBmp.Width-2 do begin
      P1:=Line1^[(X-1)*3];  P2:=Line1^[X*3]; P3:=Line1^[(X+1)*3];
      P4:=Line2^[(X-1)*3];  P5:=Line2^[X*3]; P6:=Line2^[(X+1)*3];
      P7:=Line3^[(X-1)*3];  P8:=Line3^[X*3]; P9:=Line3^[(X+1)*3];
      S1:=P3+2*P6+P9-P1-2*P4-P7;
      S2:=P1+2*P2+P3-P7-2*P8-P9;
      S:=Sqr(S1)+Sqr(S2);
      if S>Threshold then SobelLine^[X*3+0]:=255;
    end;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Same as "DrawSobelBmp" except that the actual intensity value is scaled
// instead of set to 255 or 0
////////////////////////////////////////////////////////////////////////////////
procedure DrawAnalogSobelBmp(SrcBmp,SobelBmp:TBitmap;Scale:Single);
var
  Line1     : PByteArray;
  Line2     : PByteArray;
  Line3     : PByteArray;
  SobelLine : PByteArray;
  S1,S2,S   : Integer;
  X,Y       : Integer;
  P1,P2,P3  : Integer;
  P4,P5,P6  : Integer;
  P7,P8,P9  : Integer;
begin
  SobelBmp.Canvas.Brush.Color:=clBlack;
  SobelBmp.Canvas.FillRect(Rect(0,0,SobelBmp.Width,SobelBmp.Height));
  for Y:=1 to SrcBmp.Height-2 do begin
    Line1:=SrcBmp.ScanLine[Y-1];
    Line2:=SrcBmp.ScanLine[Y];
    Line3:=SrcBmp.ScanLine[Y+1];
    SobelLine:=SobelBmp.ScanLine[Y];
    for X:=1 to SrcBmp.Width-2 do begin
      P1:=Line1^[(X-1)*3];  P2:=Line1^[X*3]; P3:=Line1^[(X+1)*3];
      P4:=Line2^[(X-1)*3];  P5:=Line2^[X*3]; P6:=Line2^[(X+1)*3];
      P7:=Line3^[(X-1)*3];  P8:=Line3^[X*3]; P9:=Line3^[(X+1)*3];
      S1:=P3+2*P6+P9-P1-2*P4-P7;
      S2:=P1+2*P2+P3-P7-2*P8-P9;
      S:=Round((Sqr(S1)+Sqr(S2))*Scale);
      if S>255 then SobelLine^[X*3+0]:=255
      else SobelLine^[X*3+0]:=S;
    end;
  end;
end;

procedure DrawShadows(Bmp:TBitmap;Threshold:Integer);
const
  EdgeColor = clRed;
  MinSize = 3;
var
  X,Y,DarkY,LightY    : Integer;
  LookingForDark,Dark : Boolean;
  Intensity           : Single;
begin
  for X:=0 to Bmp.Width-1 do begin
    LookingForDark:=True;
    Y:=0; DarkY:=0; LightY:=0;
    Bmp.Canvas.Pen.Color:=EdgeColor;
    repeat
      Inc(Y,MinSize);
      Intensity:=Bmp.Canvas.Pixels[X,Y];
      Dark:=Intensity<Threshold;
      if LookingForDark and Dark then begin
        DarkY:=Y;

// back up until we're in the light again
        repeat
          Dec(DarkY);
          Intensity:=Bmp.Canvas.Pixels[X,DarkY] and $FF;
          Dark:=Intensity<Threshold;
        until (not Dark) or (DarkY=LightY);
        Bmp.Canvas.Pixels[X,DarkY]:=EdgeColor;
        DarkY:=Y;
        LookingForDark:=False;
      end
      else if (not LookingForDark) and (not Dark) then begin
        LightY:=Y;

// back up until we're in the dark again
        repeat
          Dec(LightY);
          Intensity:=Bmp.Canvas.Pixels[X,LightY] and $FF;
          Dark:=Intensity<Threshold;
        until Dark or (LightY=DarkY);
        Bmp.Canvas.Pixels[X,LightY+1]:=EdgeColor;
        LookingForDark:=True;
        LightY:=Y;
      end;
    until (Y+MinSize>=Bmp.Height-1);
  end;
end;

procedure DrawGradientBmp(SrcBmp,DestBmp:TBitmap;Threshold:Integer);
var
  X,Y,I1,I2   : Integer;
  Gx,Gy,Gt    : Single;
  Line1,Line2 : PByteArray;
  DestLine    : PByteArray;
begin
  DestBmp.Canvas.Brush.Color:=clBlack;
  DestBmp.Canvas.FillRect(Rect(0,0,DestBmp.Width,DestBmp.Height));
  for Y:=1 to SrcBmp.Height-1 do begin
    Line1:=SrcBmp.ScanLine[Y-1];
    Line2:=SrcBmp.ScanLine[Y];
    DestLine:=DestBmp.ScanLine[Y];
    for X:=1 to SrcBmp.Width-1 do begin
      I1:=Line2[X*3];
      I2:=Line2[(X-1)*3];
      Gx:=I1-I2;
      I2:=Line1[X*3];
      Gy:=I1-I2;
      Gt:=Sqr(Gx)+Sqr(Gy);
      if Gt>Threshold then DestLine[X*3]:=255;
    end;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// 123
// 456  Pixel #5 = (P2+P4+P5+P6+P8)/5
// 789
////////////////////////////////////////////////////////////////////////////////
procedure DrawSmoothBmp(SrcBmp,DestBmp:TBitmap);
var
  Line1,Line2,Line3 : PByteArray;
  DestLine          : PByteArray;
  X,Y,V4,V6,V,I     : Integer;
begin
  for Y:=0 to SrcBmp.Height-1 do begin
    if Y=0 then Line1:=SrcBmp.ScanLine[0]
    else Line1:=SrcBmp.ScanLine[Y-1];
    Line2:=SrcBmp.ScanLine[Y];
    DestLine:=DestBmp.ScanLine[Y];
    if Y=SrcBmp.Height-1 then Line3:=Line2
    else Line3:=SrcBmp.ScanLine[Y+1];
    for X:=0 to SrcBmp.Width-1 do begin
      I:=X*3;
      if X=0 then V4:=Line2[0]
      else V4:=Line2[I-3];
      if X=SrcBmp.Width-1 then V6:=Line2[I]
      else V6:=Line2[I+3];
      V:=(Line1[I]+V4+Line2[I]+V6+Line3[I]) div 5;
      if V>255 then V:=255;
      DestLine[I+0]:=V; // blue
      DestLine[I+1]:=V; // green
      DestLine[I+2]:=V; // red
    end;
  end;
end;

procedure DrawMonoBmp(SrcBmp,DestBmp:TBitmap);
var
  I,V,X,Y          : Integer;
  SrcLine,DestLine : PByteArray;
begin
  for Y:=0 to SrcBmp.Height-1 do begin
    SrcLine:=SrcBmp.ScanLine[Y];
    DestLine:=DestBmp.ScanLine[Y];
    for X:=0 to SrcBmp.Width-1 do begin
      I:=X*3;
      V:=SrcLine[I];
      DestLine[I+0]:=V;
      DestLine[I+1]:=V;
      DestLine[I+2]:=V;
    end;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Bmp3 = Bmp1 - Bmp2
////////////////////////////////////////////////////////////////////////////////
procedure SubtractBmp(Bmp1,Bmp2,Bmp3:TBitmap);
var
  Line1,Line2,Line3 : PByteArray;
  X,Y,I,V           : Integer;
begin
  for Y:=0 to Bmp1.Height-1 do begin
    Line1:=Bmp1.ScanLine[Y];
    Line2:=Bmp2.ScanLine[Y];
    Line3:=Bmp3.ScanLine[Y];
    for X:=0 to Bmp1.Width-1 do begin
      I:=X*3;
      V:=Line1^[I]-Line2^[I];
      if V<0 then V:=0;
      Line3^[I+0]:=V;
      Line3^[I+1]:=V;
      Line3^[I+2]:=V;
    end;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Bmp3 = Bmp1 - Bmp2
////////////////////////////////////////////////////////////////////////////////
procedure SubtractColorBmp(Bmp1,Bmp2,Bmp3:TBitmap);
var
  Line1,Line2,Line3 : PByteArray;
  X,Y,I,V           : Integer;
begin
  for Y:=0 to Bmp1.Height-1 do begin
    Line1:=Bmp1.ScanLine[Y];
    Line2:=Bmp2.ScanLine[Y];
    Line3:=Bmp3.ScanLine[Y];
    for X:=0 to Bmp1.Width-1 do begin
      V:=0;
      for I:=X*3 to X*3+2 do begin
        V:=V+Abs(Line1^[I]-Line2^[I]);
      end;
      if V>255 then V:=255;
      for I:=X*3 to X*3+2 do Line3^[I]:=V;
    end;
  end;
end;

function ClipToByte(V:Single):Byte;
begin
  if V<0 then Result:=0
  else if V>255 then Result:=255
  else Result:=Round(V);
end;

procedure IntensifyBmp(Bmp:TBitmap;Scale:Single);
var
  I,X,Y : Integer;
  Line  : PByteArray;
begin
  for Y:=0 to Bmp.Height-1 do begin
    Line:=Bmp.ScanLine[Y];
    for X:=0 to Bmp.Width-1 do begin
      I:=X*3;
      Line^[I+0]:=ClipToByte(Line^[I+0]*Scale);
      Line^[I+1]:=ClipToByte(Line^[I+1]*Scale);
      Line^[I+2]:=ClipToByte(Line^[I+2]*Scale);
    end;
  end;
end;

procedure ThresholdBmp(Bmp:TBitmap;Threshold:Integer);
var
  I,X,Y : Integer;
  Line  : PByteArray;
begin
  for Y:=0 to Bmp.Height-1 do begin
    Line:=Bmp.ScanLine[Y];
    for X:=0 to Bmp.Width-1 do begin
      I:=X*3;
      if Line^[I+0]<Threshold then begin
        Line^[I+0]:=0;
        Line^[I+1]:=0;
        Line^[I+2]:=0;
      end;
    end;
  end;
end;

procedure ConvertBmpToIntensityMap(Bmp:TBitmap;Threshold:Byte);
var
  X,Y,V : Integer;
  Line  : PByteArray;
begin
  for Y:=0 to Bmp.Height-1 do begin
    Line:=Bmp.ScanLine[Y];
    for X:=0 to Bmp.Width-1 do begin
      if Line^[X*3]>Threshold then V:=$FF
      else V:=0;
      Line^[X*3+0]:=0; // blue
      Line^[X*3+1]:=V; // green
      Line^[X*3+2]:=V; // red
    end;
  end;
end;

procedure DrawHistogram(SourceBmp,DestBmp:TBitmap);
var
  Red   : array[0..255] of Integer;
  Green : array[0..255] of Integer;
  Blue  : array[0..255] of Integer;
  Line  : PByteArray;
  X,Y,I : Integer;
  Max   : Integer;
  R,G,B : Integer;
begin
  if SourceBmp.Width=0 then Exit;

// find the values
  FillChar(Red,SizeOf(Red),0);
  FillChar(Green,SizeOf(Green),0);
  FillChar(Blue,SizeOf(Blue),0);
  for Y:=0 to SourceBmp.Height-1 do begin
    Line:=SourceBmp.ScanLine[Y];
    for X:=0 to SourceBmp.Width-1 do begin
      I:=X*3;
      R:=Line^[I+2];
      G:=Line^[I+1];
      B:=Line^[I+0];
      Inc(Red[R]);
      Inc(Green[G]);
      Inc(Blue[B]);
    end;
  end;

// find the peak value for scaling
  Max:=0;
  for I:=0 to 255 do begin
    if Red[I]>Max then Max:=Red[I];
    if Green[I]>Max then Max:=Green[I];
    if Blue[I]>Max then Max:=Blue[I];
  end;

// draw the bmp
  with DestBmp.Canvas do begin

// clear it
    Brush.Color:=$C8FAFA;
    FillRect(Rect(0,0,DestBmp.Width,DestBmp.Height));

// draw the red
    for I:=0 to 255 do begin
      X:=Round(DestBmp.Width*I/255);
      Y:=Round(DestBmp.Height*(1-Red[I]/Max));
      Pen.Color:=clRed;
      if I=0 then MoveTo(X,Y)
      else LineTo(X,Y);
    end;

// draw the green
    for I:=0 to 255 do begin
      X:=Round(DestBmp.Width*I/255);
      Y:=Round(DestBmp.Height*(1-Green[I]/Max));
      Pen.Color:=clGreen;
      if I=0 then MoveTo(X,Y)
      else LineTo(X,Y);
    end;

// draw the blue
    for I:=0 to 255 do begin
      X:=Round(DestBmp.Width*I/255);
      Y:=Round(DestBmp.Height*(1-Blue[I]/Max));
      Pen.Color:=clBlue;
      if I=0 then MoveTo(X,Y)
      else LineTo(X,Y);
    end;
  end;
end;

procedure DrawTextOnBmp(Bmp:TBitmap;TextStr:String);
var
  X,Y : Integer;
begin
  with Bmp.Canvas do begin
    Font.Color:=clYellow;
    Font.Size:=12;
    Brush.Color:=clBlack;
    FillRect(Rect(0,0,Bmp.Width,Bmp.Height));
    X:=(Bmp.Width-TextWidth(TextStr)) div 2;
    Y:=(Bmp.Height-TextHeight(TextStr)) div 2;
    TextOut(X,Y,TextStr);
  end;
end;

procedure DrawTextOnBmp2(TextStr:String;Bmp:TBitmap);
var
  X,Y : Integer;
begin
  with Bmp.Canvas do begin
    X:=(Bmp.Width-TextWidth(TextStr)) div 2;
    Y:=(Bmp.Height-TextHeight(TextStr)) div 2;
    TextOut(X,Y,TextStr);
  end;
end;

procedure ShowFrameRateOnBmp(Bmp:TBitmap;FrameRate:Single);
begin
  with Bmp.Canvas do begin
    Font.Color:=clYellow;
    Font.Size:=8;
    Brush.Color:=clBlack;
    TextOut(5,Bmp.Height-15,FloatToStrF(FrameRate,ffFixed,9,3));
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Magnifies a region of the screen around the mouse cursor.
// Source rect width = scale*bmp.width
// Source rect height = scale*bmp.height
//////////////////////////////////////////////////////////////////////////////////
procedure MagnifyScreen(Bmp:TBitmap;Scale:Integer);
var
  DeskTopHandle : THandle;
  DeskTopDC     : HDC;
  MousePt       : TPoint;
  SrcW,SrcH,X,Y : Integer;
begin
  GetCursorPos(MousePt);
  DeskTopHandle:=GetDeskTopWindow;
  if DeskTopHandle>0 then with Bmp do begin
    DeskTopDC:=GetDC(DeskTopHandle);
    SrcW:=Width div Scale;
    SrcH:=Height div Scale;
    X:=MousePt.X-SrcW div 2;
    Y:=MousePt.Y-SrcH div 2;
    StretchBlt(Canvas.Handle,0,0,Width,Height,DeskTopDC,X,Y,SrcW,SrcH,SRCCOPY);
  end;
end;

procedure MagnifyCopy(SrcBmp,IBmp,DestBmp:TBitmap;Xc,Yc,Scale:Integer);
const
  ShortR = 3;
  LongR  = 8;
var
  SrcW,SrcH,X,Y : Integer;
begin
  SrcW:=DestBmp.Width div Scale;
  SrcH:=DestBmp.Height div Scale;
  X:=Xc-SrcW div 2;
  Y:=Yc-SrcH div 2;

// copy the source over onto the intermediate bmp
  BitBlt(IBmp.Canvas.Handle,0,0,SrcW,SrcH,SrcBmp.Canvas.Handle,X,Y,SrcCopy);

// draw some cross hairs in the middle
  with IBmp.Canvas do begin
    Pen.Color:=clLime;
    X:=SrcW div 2;
    Y:=SrcH div 2;
    MoveTo(X-LongR,Y);  LineTo(X-ShortR+1,Y);
    MoveTo(X+ShortR,Y); LineTo(X+LongR+1,Y);
    MoveTo(X,Y-LongR);  LineTo(X,Y-ShortR+1);
    MoveTo(X,Y+ShortR); LineTo(X,Y+LongR+1);
  end;

// stretch it onto the dest bmp
  StretchBlt(DestBmp.Canvas.Handle,0,0,DestBmp.Width,DestBmp.Height,
             IBmp.Canvas.Handle,0,0,SrcW,SrcH,SrcCopy);
end;

procedure SwapRB(Bmp:TBitmap);
var
  X,Y,R,B : Integer;
  Bpp,I   : Integer;
  Line    : PByteArray;
begin
  Bpp:=BytesPerPixel(Bmp);
  for Y:=0 to Bmp.Height-1 do begin
    Line:=Bmp.ScanLine[Y];
    for X:=0 to Bmp.Width-1 do begin
      I:=X*Bpp;
      B:=Line^[I];
      R:=Line^[I+2];
      Line^[I]:=R;
      Line^[I+2]:=B;
    end;
  end;
end;

function BytesPerPixel(Bmp:TBitmap):Integer;
begin
  Case Bmp.PixelFormat of
    pf8Bit  : Result:=1;
    pf16Bit : Result:=2;
    pf24Bit : Result:=3;
    pf32Bit : Result:=4;
    else Result:=4;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// 123
// 456  Pixel #5 = (P2+P4+P5+P6+P8)/5
// 789
////////////////////////////////////////////////////////////////////////////////
procedure DrawSmoothBmpAsm24Bit(SrcBmp,DestBmp:TBitmap);
var
  Line1,Line2,Line3,DestLine : Pointer;
  BytesPerRow,MaxX,Row       : DWord;
  Bpp                        : Integer;
begin
// Windows bitmaps start from the bottom
  Line1:=SrcBmp.ScanLine[0];
  Line2:=SrcBmp.ScanLine[1];
  Line3:=SrcBmp.ScanLine[2];
  DestLine:=DestBmp.ScanLine[1];

// find how many bytes per row there are -> width*Bpp + a byte or two for padding
  BytesPerRow:=Integer(SrcBmp.ScanLine[0])-Integer(SrcBmp.ScanLine[1]);
  Bpp:=BytesPerPixel(SrcBmp);
  MaxX:=(SrcBmp.Width-2)*Bpp;
  Row:=DWord(SrcBmp.Height-3);

  asm
    PUSHA
    MOV   EBX, Line1    // EBX = Line1
    MOV   ECX, Line2    // ECX = Line2
    MOV   ESI, Line3    // ESI = Line3
    MOV   EDI, DestLine // EDI = DestLine

@YLoop :
    MOV   EDX, 3        // EDX = column offset

@XLoop :
    XOR   AH, AH
    MOV   AL, BYTE Ptr[EBX+EDX]     //   pixel #2
    ADD   AL, BYTE Ptr[ECX+EDX-3] // + pixel #4
    JNC   @NC1
    INC   AH

@NC1 :
    ADD   AL, BYTE Ptr[ECX+EDX]     // + pixel #5
    JNC   @NC2
    INC   AH

@NC2 :
    ADD   AL, BYTE Ptr[ECX+EDX+3] // + pixel #6
    JNC   @NC3
    INC   AH

@NC3 :
    ADD   AL, BYTE Ptr[ESI+EDX]   // + pixel #7
    JNC   @NC4
    INC   AH

@NC4 :
    SHR   AX, 2
    CMP   AX, 256
    JL    @Store
    MOV   AX, 255

@Store :
    MOV   BYTE Ptr[EDI+EDX+0], AL // store it in the target's blue pixel
    MOV   BYTE Ptr[EDI+EDX+1], AL // store it in the target's green pixel
    MOV   BYTE Ptr[EDI+EDX+2], AL // store it in the target's red pixel

    ADD   EDX, 3                  // select the next pixel index
    CMP   EDX, MaxX               // done this row?
    JL    @XLoop                  // no: continue to the next pixel in the row

    SUB   EBX, BytesPerRow         // go to the next row
    SUB   ECX, BytesPerRow
    SUB   ESI, BytesPerRow         // go to the next row
    SUB   EDI, BytesPerRow

    DEC   DWord Ptr[Row]
    JGE   @YLOOP
    POPA
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// 123
// 456  Pixel #5 = (P2+P4+P5+P6+P8)/5
// 789
////////////////////////////////////////////////////////////////////////////////
procedure DrawSmoothBmpAsm32Bit(SrcBmp,DestBmp:TBitmap);
var
  Line1,Line2,Line3,DestLine : Pointer;
  BytesPerRow,MaxX,Row       : DWord;
begin
// Windows bitmaps start from the bottom
  Line1:=SrcBmp.ScanLine[0];
  Line2:=SrcBmp.ScanLine[1];
  Line3:=SrcBmp.ScanLine[2];
  DestLine:=DestBmp.ScanLine[1];

// find how many bytes per row there are -> width*Bpp + a byte or two for padding
  BytesPerRow:=Integer(SrcBmp.ScanLine[0])-Integer(SrcBmp.ScanLine[1]);
  MaxX:=(SrcBmp.Width-2)*4;
  Row:=DWord(SrcBmp.Height-3);

  asm
    PUSHA
    MOV   EBX, Line1    // EBX = Line1
    MOV   ECX, Line2    // ECX = Line2
    MOV   ESI, Line3    // ESI = Line3
    MOV   EDI, DestLine // EDI = DestLine

@YLoop :
    MOV   EDX, 4        // EDX = column offset

@XLoop :
    XOR   AH, AH
    MOV   AL, BYTE Ptr[EBX+EDX]     //   pixel #2
    ADD   AL, BYTE Ptr[ECX+EDX-4] // + pixel #4
    JNC   @NC1
    INC   AH

@NC1 :
    ADD   AL, BYTE Ptr[ECX+EDX]     // + pixel #5
    JNC   @NC2
    INC   AH

@NC2 :
    ADD   AL, BYTE Ptr[ECX+EDX+4] // + pixel #6
    JNC   @NC3
    INC   AH

@NC3 :
    ADD   AL, BYTE Ptr[ESI+EDX]   // + pixel #7
    JNC   @NC4
    INC   AH

@NC4 :
    SHR   AX, 2
    CMP   AX, 256
    JL    @Store
    MOV   AX, 255

@Store :
    MOV   BYTE Ptr[EDI+EDX+0], AL // store it in the target's blue pixel
    MOV   BYTE Ptr[EDI+EDX+1], AL // store it in the target's green pixel
    MOV   BYTE Ptr[EDI+EDX+2], AL // store it in the target's red pixel

    ADD   EDX, 4                  // select the next pixel index
    CMP   EDX, MaxX               // done this row?
    JL    @XLoop                  // no: continue to the next pixel in the row

    SUB   EBX, BytesPerRow         // go to the next row
    SUB   ECX, BytesPerRow
    SUB   ESI, BytesPerRow         // go to the next row
    SUB   EDI, BytesPerRow

    DEC   DWord Ptr[Row]
    JGE   @YLOOP
    POPA
  end;
end;


////////////////////////////////////////////////////////////////////////////////
// 123
// 456  Pixel #5 = (P2+P4+P5+P6+P8)/5
// 789
////////////////////////////////////////////////////////////////////////////////
procedure DrawSmoothBmpAsm(SrcBmp,DestBmp:TBitmap);
var
  Bpp : Integer;
begin
  Bpp:=BytesPerPixel(SrcBmp);
  if Bpp=3 then DrawSmoothBmpAsm24Bit(SrcBmp,DestBmp)
  else DrawSmoothBmpAsm32Bit(SrcBmp,DestBmp);
end;

procedure DilateBmp3x3Asm24Bit(SrcBmp,DestBmp:TBitmap;Threshold:Byte);
var
  SrcLine,DestLine1,DestLine2,DestLine3 : Pointer;
  BytesPerRow,MaxX,Row                  : DWord;
begin
//  ClearBmp(SrcBmp,clBlack);
  ClearBmp(DestBmp,clBlack);

// Windows bitmaps start from the bottom
  SrcLine:=SrcBmp.ScanLine[1];
  DestLine1:=DestBmp.ScanLine[0];
  DestLine2:=DestBmp.ScanLine[1];
  DestLine3:=DestBmp.ScanLine[2];

// find how many bytes per row there are -> width*Bpp + a byte or two for padding
  BytesPerRow:=Integer(SrcBmp.ScanLine[0])-Integer(SrcBmp.ScanLine[1]);
  MaxX:=(SrcBmp.Width-2)*3;
  Row:=DWord(SrcBmp.Height-3);

  asm
    PUSHA
    MOV   EBX, SrcLine   // EBX = SrcLine1
    MOV   ECX, DestLine1 // ECX = DestLine1
    MOV   ESI, DestLine2 // ESI = DestLine2
    MOV   EDI, DestLine3 // EDI = DestLine3
    MOV   AL, Threshold

@YLoop :
    MOV   EDX, 3        // EDX = column offset

@XLoop :
//    MOV   AH, BYTE Ptr[EBX+EDX]
//    CMP   AH, AL
//    JL    @NextX
//    CMP   AL, BYTE Ptr[EBX+EDX]

    CMP   AL, BYTE Ptr[EBX+EDX] //, AL
    JA    @NextX

    MOV   BYTE Ptr[ECX+EDX+0], 255
    MOV   BYTE Ptr[ESI+EDX-3], 255
    MOV   BYTE Ptr[ESI+EDX+0], 255
    MOV   BYTE Ptr[ESI+EDX+3], 255
    MOV   BYTE Ptr[EDI+EDX+0], 255

@NextX :
    ADD   EDX, 3    // select the next pixel index
    CMP   EDX, MaxX // done this row?
    JL    @XLoop    // no: continue to the next pixel in the row

// go to the next row
    SUB   EBX, BytesPerRow
    SUB   ECX, BytesPerRow
    SUB   ESI, BytesPerRow
    SUB   EDI, BytesPerRow

    DEC   DWord Ptr[Row]
    JGE   @YLOOP
    POPA
  end;
end;

procedure DilateBmp3x3Asm32Bit(SrcBmp,DestBmp:TBitmap;Threshold:Byte);
var
  SrcLine,DestLine1,DestLine2,DestLine3 : Pointer;
  BytesPerRow,MaxX,Row                  : DWord;
begin
//  ClearBmp(SrcBmp,clBlack);
  ClearBmp(DestBmp,clBlack);

// Windows bitmaps start from the bottom
  SrcLine:=SrcBmp.ScanLine[1];
  DestLine1:=DestBmp.ScanLine[0];
  DestLine2:=DestBmp.ScanLine[1];
  DestLine3:=DestBmp.ScanLine[2];

// find how many bytes per row there are -> width*Bpp + a byte or two for padding
  BytesPerRow:=Integer(SrcBmp.ScanLine[0])-Integer(SrcBmp.ScanLine[1]);
  MaxX:=(SrcBmp.Width-2)*4;
  Row:=DWord(SrcBmp.Height-3);

  asm
    PUSHA
    MOV   EBX, SrcLine   // EBX = SrcLine1
    MOV   ECX, DestLine1 // ECX = DestLine1
    MOV   ESI, DestLine2 // ESI = DestLine2
    MOV   EDI, DestLine3 // EDI = DestLine3
    MOV   AL, Threshold

@YLoop :
    MOV   EDX, 4        // EDX = column offset

@XLoop :
//    MOV   AH, BYTE Ptr[EBX+EDX]
//    CMP   AH, AL
//    JL    @NextX
//    CMP   AL, BYTE Ptr[EBX+EDX]

    CMP   AL, BYTE Ptr[EBX+EDX] //, AL
    JA    @NextX

    MOV   BYTE Ptr[ECX+EDX+0], 255
    MOV   BYTE Ptr[ESI+EDX-4], 255
    MOV   BYTE Ptr[ESI+EDX+0], 255
    MOV   BYTE Ptr[ESI+EDX+4], 255
    MOV   BYTE Ptr[EDI+EDX+0], 255

@NextX :
    ADD   EDX, 4    // select the next pixel index
    CMP   EDX, MaxX // done this row?
    JL    @XLoop    // no: continue to the next pixel in the row

// go to the next row
    SUB   EBX, BytesPerRow
    SUB   ECX, BytesPerRow
    SUB   ESI, BytesPerRow
    SUB   EDI, BytesPerRow

    DEC   DWord Ptr[Row]
    JGE   @YLOOP
    POPA
  end;
end;

procedure DilateBmp3x3Asm(SrcBmp,DestBmp:TBitmap;Threshold:Byte);
var
  Bpp : Integer;
begin
  Bpp:=BytesPerPixel(SrcBmp);
  if Bpp=3 then DilateBmp3x3Asm24Bit(SrcBmp,DestBmp,Threshold)
  else DilateBmp3x3Asm32Bit(SrcBmp,DestBmp,Threshold);
end;

procedure ThresholdBmpAsm(Bmp:TBitmap;Threshold:Byte);
var
  Line         : Pointer;
  MaxX,Row     : DWord;
  BytesPerRow  : DWord;
  Bpp          : Integer;
begin
// Windows bitmaps start from the bottom
  Line:=Bmp.ScanLine[0];

// find how many bytes per row there are -> width*Bpp+ a byte or two
  BytesPerRow:=Integer(Bmp.ScanLine[0])-Integer(Bmp.ScanLine[1]);
  Bpp:=BytesPerPixel(Bmp);
  MaxX:=Bmp.Width*Bpp;
  Row:=DWord(Bmp.Height-2);
  asm
    PUSHA
    MOV   EBX, Line // EBX = Line
    MOV   AL, Threshold

@YLoop :
    MOV   EDX, 0    // EDX = column offset

@XLoop :
    CMP   AL, BYTE Ptr[EBX+EDX]
    JA    @ClearPixel
    MOV   BYTE Ptr[EBX+EDX+0], 255  // store it in the target's blue pixel
    MOV   BYTE Ptr[EBX+EDX+1], 255  // store it in the target's green pixel
    MOV   BYTE Ptr[EBX+EDX+2], 255  // store it in the target's red pixel
    JMP   @NextX

@ClearPixel :
    MOV   BYTE Ptr[EBX+EDX+0], 0  // store it in the target's blue pixel
    MOV   BYTE Ptr[EBX+EDX+1], 0  // store it in the target's green pixel
    MOV   BYTE Ptr[EBX+EDX+2], 0  // store it in the target's red pixel

@NextX :
    ADD   EDX, Bpp  // select the next pixel index
    CMP   EDX, MaxX // done this row?
    JL    @XLoop    // no: continue to the next pixel in the row

// go to the next row
    SUB   EBX, BytesPerRow
    DEC   DWord Ptr[Row]
    JGE   @YLOOP
    POPA
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// TargetBmp = Bmp1 - Bmp2
// They should probably all be the same size. :)
////////////////////////////////////////////////////////////////////////////////
procedure SubtractBmpAsmAbs(Bmp1,Bmp2,TargetBmp:TBitmap);
var
  Bmp1Ptr,Bmp2Ptr : Pointer;
  TargetPtr       : Pointer;
  MaxX,Row        : DWord;
  BytesPerRow     : DWord;
  Bpp             : Integer;
begin
// Windows bitmaps start from the bottom
  Bmp1Ptr:=Bmp1.ScanLine[0];
  Bmp2Ptr:=Bmp2.ScanLine[0];
  TargetPtr:=TargetBmp.ScanLine[0];

// find how many bytes per row there are -> width*4+ a byte or two
  BytesPerRow:=Integer(Bmp1.ScanLine[0])-Integer(Bmp1.ScanLine[1]);
  Bpp:=BytesPerPixel(Bmp1);
  MaxX:=Bmp1.Width*Bpp;
  Row:=DWord(Bmp1.Height-1);
  asm
    PUSHA
    MOV   ESI, Bmp1Ptr           // ESI = Bmp1
    MOV   EBX, Bmp2Ptr           // EBX = Bmp2
    MOV   EDI, TargetPtr         // EDI = TargetBmp

@YLoop :
    MOV   EDX, 0                 // EDX = column offset

@XLoop :
    MOV   AL, BYTE Ptr[ESI+EDX]  // load bmp1's blue pixel
    SUB   AL, BYTE Ptr[EBX+EDX]  // subtract bmp2's blue pixel
    JNC   @Positive
    MOV   AL, BYTE Ptr[EBX+EDX]  // load bmp2's blue pixel
    SUB   AL, BYTE Ptr[ESI+EDX]  // subtract bmp1's blue pixel

@Positive:
    MOV   BYTE Ptr[EDI+EDX+0], AL  // store it in the target's blue pixel
    MOV   BYTE Ptr[EDI+EDX+1], AL  // store it in the target's green pixel
    MOV   BYTE Ptr[EDI+EDX+2], AL  // store it in the target's red pixel

    ADD   EDX, Bpp                 // select the next pixel index
    CMP   EDX, MaxX                // done this row?
    JL    @XLoop                   // no: continue to the next pixel in the row

    SUB   ESI, BytesPerRow         // go to the next row
    SUB   EBX, BytesPerRow
    SUB   EDI, BytesPerRow

    DEC   DWord Ptr[Row]
    JGE   @YLOOP
    POPA
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// TargetBmp = Bmp1 - Bmp2
// They should probably all be the same size. :)
////////////////////////////////////////////////////////////////////////////////
procedure SubtractBmpAsmAbs32Bit(Bmp1,Bmp2,TargetBmp:TBitmap);
var
  Bmp1Ptr,Bmp2Ptr : Pointer;
  TargetPtr       : Pointer;
  MaxX,Row        : DWord;
  BytesPerRow     : DWord;
  Bpp             : Integer;
begin
// Windows bitmaps start from the bottom
  Bmp1Ptr:=Bmp1.ScanLine[0];
  Bmp2Ptr:=Bmp2.ScanLine[0];
  TargetPtr:=TargetBmp.ScanLine[0];

// find how many bytes per row there are -> width*4+ a byte or two
  BytesPerRow:=Integer(Bmp1.ScanLine[0])-Integer(Bmp1.ScanLine[1]);
  Bpp:=BytesPerPixel(Bmp1);
  MaxX:=Bmp1.Width*Bpp;
  Row:=DWord(Bmp1.Height-2);
  asm
    PUSHA
    MOV   ESI, Bmp1Ptr           // ESI = Bmp1
    MOV   EBX, Bmp2Ptr           // EBX = Bmp2
    MOV   EDI, TargetPtr         // EDI = TargetBmp

@YLoop :
    MOV   EDX, 0                 // EDX = column offset

@XLoop :
    MOV   AL, BYTE Ptr[ESI+EDX]  // load bmp1's blue pixel
    SUB   AL, BYTE Ptr[EBX+EDX]  // subtract bmp2's blue pixel
    JNC   @Positive
    MOV   AL, BYTE Ptr[EBX+EDX]  // load bmp2's blue pixel
    SUB   AL, BYTE Ptr[ESI+EDX]  // subtract bmp1's blue pixel

@Positive:
    MOV   BYTE Ptr[EDI+EDX+0], AL  // store it in the target's blue pixel
    MOV   BYTE Ptr[EDI+EDX+1], AL  // store it in the target's green pixel
    MOV   BYTE Ptr[EDI+EDX+2], AL  // store it in the target's red pixel

    ADD   EDX, Bpp                 // select the next pixel index
    CMP   EDX, MaxX                // done this row?
    JL    @XLoop                   // no: continue to the next pixel in the row

    SUB   ESI, BytesPerRow         // go to the next row
    SUB   EBX, BytesPerRow
    SUB   EDI, BytesPerRow

    DEC   DWord Ptr[Row]
    JGE   @YLOOP
    POPA
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// TargetBmp = Bmp1 - Bmp2
// They should probably all be the same size. :)
////////////////////////////////////////////////////////////////////////////////
procedure SubtractBmpAsm(Bmp1,Bmp2,TargetBmp:TBitmap);
var
  Bmp1Ptr,Bmp2Ptr : Pointer;
  TargetPtr       : Pointer;
  MaxX,Row        : DWord;
  BytesPerRow     : DWord;
  Bpp             : Integer;
begin
// Windows bitmaps start from the bottom
  Bmp1Ptr:=Bmp1.ScanLine[0];
  Bmp2Ptr:=Bmp2.ScanLine[0];
  TargetPtr:=TargetBmp.ScanLine[0];

// find how many bytes per row there are -> width*4+ a byte or two
  BytesPerRow:=Integer(Bmp1.ScanLine[0])-Integer(Bmp1.ScanLine[1]);
  Bpp:=BytesPerPixel(Bmp1);
  MaxX:=Bmp1.Width*Bpp; // 3
  Row:=DWord(Bmp1.Height-2);
  asm
    PUSHA
    MOV   ESI, Bmp1Ptr           // ESI = Bmp1
    MOV   EBX, Bmp2Ptr           // EBX = Bmp2
    MOV   EDI, TargetPtr         // EDI = TargetBmp

@YLoop :
    MOV   EDX, 0                 // EDX = column offset

@XLoop :
    MOV   AL, BYTE Ptr[ESI+EDX]  // load bmp1's blue pixel
    SUB   AL, BYTE Ptr[EBX+EDX]  // subtract bmp2's blue pixel
    JNC   @Positive
    XOR   AL, AL

@Positive:
    MOV   BYTE Ptr[EDI+EDX+0], AL  // store it in the target's blue pixel
    MOV   BYTE Ptr[EDI+EDX+1], AL  // store it in the target's green pixel
    MOV   BYTE Ptr[EDI+EDX+2], AL  // store it in the target's red pixel

    ADD   EDX, Bpp                 // select the next pixel index
    CMP   EDX, MaxX                // done this row?
    JL    @XLoop                   // no: continue to the next pixel in the row

    SUB   ESI, BytesPerRow         // go to the next row
    SUB   EBX, BytesPerRow
    SUB   EDI, BytesPerRow

    DEC   DWord Ptr[Row]
    JGE   @YLOOP
    POPA
  end;
end;

procedure SubtractBmpAsmAbsSquared(Bmp1,Bmp2,TargetBmp:TBitmap);
var
  Bmp1Ptr,Bmp2Ptr : Pointer;
  TargetPtr       : Pointer;
  MaxX,Row        : DWord;
  BytesPerRow     : DWord;
begin
// Windows bitmaps start from the bottom
  Bmp1Ptr:=Bmp1.ScanLine[0];
  Bmp2Ptr:=Bmp2.ScanLine[0];
  TargetPtr:=TargetBmp.ScanLine[0];

// find how many bytes per row there are -> width*4+ a byte or two
  BytesPerRow:=Integer(Bmp1.ScanLine[0])-Integer(Bmp1.ScanLine[1]);
  MaxX:=Bmp1.Width*4; // 3
  Row:=DWord(Bmp1.Height-2);
  asm
    PUSHA
    MOV   ESI, Bmp1Ptr           // ESI = Bmp1
    MOV   EBX, Bmp2Ptr           // EBX = Bmp2
    MOV   EDI, TargetPtr         // EDI = TargetBmp

@YLoop :
    MOV   EDX, 0                 // EDX = column offset

@XLoop :
    MOV   AL, BYTE Ptr[ESI+EDX]  // load bmp1's blue pixel
    SUB   AL, BYTE Ptr[EBX+EDX]  // subtract bmp2's blue pixel
    JNC   @Positive
    MOV   AL, BYTE Ptr[EBX+EDX]  // load bmp2's blue pixel
    SUB   AL, BYTE Ptr[ESI+EDX]  // subtract bmp1's blue pixel

@Positive:
    CMP   AL, 16
    JL    @NoOverV
    MOV   AL, 255
    JMP   @Store

@NoOverV:
    MUL   AL, AL

@Store:
    MOV   BYTE Ptr[EDI+EDX+0], AL  // store it in the target's blue pixel
    MOV   BYTE Ptr[EDI+EDX+1], AL  // store it in the target's green pixel
    MOV   BYTE Ptr[EDI+EDX+2], AL  // store it in the target's red pixel

    ADD   EDX, 4                   // select the next pixel index
    CMP   EDX, MaxX                // done this row?
    JL    @XLoop                   // no: continue to the next pixel in the row

    SUB   ESI, BytesPerRow         // go to the next row
    SUB   EBX, BytesPerRow
    SUB   EDI, BytesPerRow

    DEC   DWord Ptr[Row]
    JGE   @YLOOP
    POPA
  end;
end;

procedure DrawXHairs(Bmp:TBitmap;X,Y,R:Integer);
begin
  with Bmp.Canvas do begin
    MoveTo(X-R,Y);
    LineTo(X+R+1,Y);
    MoveTo(X,Y-R);
    LineTo(X,Y+R+1);
  end;
end;

procedure ClearBmpAsm(Bmp:TBitmap);
var
  DestPtr     : PByte;
  BytesPerRow : Integer;
  Bpp         : DWord;
  LineOffset  : DWord;
  MaxOffset   : Integer;
  RowsLeft    : Integer;
begin
// find how many bytes per row there are -> width*3+ a byte or two for padding
  BytesPerRow:=Integer(Bmp.ScanLine[0])-Integer(Bmp.ScanLine[1]);
  Bpp:=BytesPerPixel(Bmp);

// pointer to the bmp's data area - highest address is the top line
  DestPtr:=Pointer(Bmp.ScanLine[0]);

// start at the given X,Y upper left corner
  MaxOffset:=(Bmp.Width-1)*Bpp-1;
  RowsLeft:=Bmp.Height-1;

  asm
    PUSHA

    MOV   EAX, 0       // AL is a temp holder
    MOV   EBX, DestPtr // EBX = Bmp

@YLoop :
    MOV   ESI, 0

@XLoop :
    MOV   [EBX+ESI], EAX // store it in the bmp

    ADD   ESI, Bpp       // select the next Bmp line offset
    CMP   ESI, MaxOffset // done this row?

    JLE   @XLoop     // no: continue to the next pixel in the row

    SUB   EBX, BytesPerRow   // select the next bmp scanline

    DEC   DWord Ptr[RowsLeft]
    JGE   @YLOOP
    POPA
  end;
end;

procedure SubtractColorBmpAsm(Bmp1,Bmp2,TargetBmp:TBitmap);
var
  Bmp1Ptr,Bmp2Ptr : Pointer;
  TargetPtr       : Pointer;
  MaxX,Row        : DWord;
  BytesPerRow     : DWord;
  Bpp             : Integer;
begin
// Windows bitmaps start from the bottom
  Bmp1Ptr:=Bmp1.ScanLine[0];
  Bmp2Ptr:=Bmp2.ScanLine[0];
  TargetPtr:=TargetBmp.ScanLine[0];

// find how many bytes per row there are -> width*4+ a byte or two
  BytesPerRow:=Integer(Bmp1.ScanLine[0])-Integer(Bmp1.ScanLine[1]);
  Bpp:=BytesPerPixel(Bmp1);
  MaxX:=Bmp1.Width*Bpp; // 3
  Row:=DWord(Bmp1.Height-1);
  asm
    PUSHA
    MOV   ESI, Bmp1Ptr           // ESI = Bmp1
    MOV   EBX, Bmp2Ptr           // EBX = Bmp2
    MOV   EDI, TargetPtr         // EDI = TargetBmp

@YLoop :
    MOV   EDX, 0                 // EDX = column offset

@XLoop :

// blue
    MOV   AL, BYTE Ptr[ESI+EDX]  // load bmp1's blue pixel
    SUB   AL, BYTE Ptr[EBX+EDX]  // subtract bmp2's blue pixel
    JNC   @Green
    MOV   AL, BYTE Ptr[EBX+EDX]  // load bmp2's blue pixel
    SUB   AL, BYTE Ptr[ESI+EDX]  // subtract bmp1's blue pixel

@Green :
    MOV   CL, AL
    MOV   AL, BYTE Ptr[ESI+EDX+1]  // load bmp1's green pixel
    SUB   AL, BYTE Ptr[EBX+EDX+1]  // subtract bmp2's green pixel
    JNC   @Red
    MOV   AL, BYTE Ptr[EBX+EDX+1]  // load bmp2's green pixel
    SUB   AL, BYTE Ptr[ESI+EDX+1]  // subtract bmp1's green pixel

@Red :
    ADD   CL, AL
    JC    @ClipTo255
    MOV   AL, BYTE Ptr[ESI+EDX+2]  // load bmp1's red pixel
    SUB   AL, BYTE Ptr[EBX+EDX+2]  // subtract bmp2's red pixel
    JNC   @DoneRed
    MOV   AL, BYTE Ptr[EBX+EDX+2]  // load bmp2's red pixel
    SUB   AL, BYTE Ptr[ESI+EDX+2]  // subtract bmp1's red pixel

@DoneRed :
    ADD   CL, AL
    JNC   @StoreResult

@ClipTo255 :
    MOV   CL, 255

@StoreResult :
    MOV   BYTE Ptr[EDI+EDX+0], CL  // store it in the target's blue pixel
    MOV   BYTE Ptr[EDI+EDX+1], CL  // store it in the target's green pixel
    MOV   BYTE Ptr[EDI+EDX+2], CL  // store it in the target's red pixel

    ADD   EDX, Bpp                 // select the next pixel index
    CMP   EDX, MaxX                // done this row?
    JL    @XLoop                   // no: continue to the next pixel in the row

    SUB   ESI, BytesPerRow         // go to the next row
    SUB   EBX, BytesPerRow
    SUB   EDI, BytesPerRow

    DEC   DWord Ptr[Row]
    JGE   @YLOOP
    POPA
  end;
end;

procedure FlipBmp(SrcBmp,DestBmp:TBitmap);
var
  Bpp,Bpr,Y : Integer;
  SrcLine   : PByteArray;
  DestLine  : PByteArray;
begin
  Bpp:=BytesPerPixel(SrcBmp);
  Bpr:=Bpp*SrcBmp.Width;
  for Y:=0 to SrcBmp.Height-1 do begin
    SrcLine:=SrcBmp.ScanLine[Y];
    DestLine:=DestBmp.ScanLine[(SrcBmp.Height-1)-Y];
    Move(SrcLine^,DestLine^,Bpr);
  end;
end;

procedure MirrorBmp(SrcBmp,DestBmp:TBitmap);
var
  Bpr,X,Y  : Integer;
  DestX    : Integer;
  Bpp      : Integer;
  SrcLine  : PByteArray;
  DestLine : PByteArray;
begin
  Bpp:=BytesPerPixel(SrcBmp);
  Bpr:=Bpp*SrcBmp.Width;
  for Y:=0 to SrcBmp.Height-1 do begin
    SrcLine:=SrcBmp.ScanLine[Y];
    DestLine:=DestBmp.ScanLine[Y];
    DestX:=SrcBmp.Width-1;
    for X:=0 to SrcBmp.Width-1 do begin
      Move(SrcLine^[X*Bpp],DestLine^[DestX*Bpp],3);
      Dec(DestX);
    end;
  end;
end;

procedure FlipAndMirrorBmp(SrcBmp,DestBmp:TBitmap);
var
  Bpr,X,Y  : Integer;
  DestX    : Integer;
  Bpp      : Integer;
  SrcLine  : PByteArray;
  DestLine : PByteArray;
begin
  Bpp:=BytesPerPixel(SrcBmp);
  Bpr:=Bpp*SrcBmp.Width;
  for Y:=0 to SrcBmp.Height-1 do begin
    SrcLine:=SrcBmp.ScanLine[Y];
    DestLine:=DestBmp.ScanLine[(SrcBmp.Height-1)-Y];
    DestX:=SrcBmp.Width-1;
    for X:=0 to SrcBmp.Width-1 do begin
      Move(SrcLine^[X*Bpp],DestLine^[DestX*Bpp],3);
      Dec(DestX);
    end;
  end;
end;

procedure OrientBmp(SrcBmp,DestBmp:TBitmap;FlipImage,MirrorImage:Boolean);
begin
  if FlipImage then begin
    if MirrorImage then FlipAndMirrorBmp(SrcBmp,DestBmp)
    else FlipBmp(SrcBmp,DestBmp);
  end
  else if MirrorImage then MirrorBmp(SrcBmp,DestBmp)
  else DestBmp.Canvas.Draw(0,0,SrcBmp);
end;

procedure InitBmpDataFromBmp(BmpData:PByte;Bmp:TBitmap;X1,Y1,X2,Y2:Integer);
var
  W,H,Y,Bpr : Integer;
  SrcPtr    : PByte;
  DestPtr   : PByte;
begin
  Assert(Y2<Bmp.Height);
  W:=X2-X1+1;
  H:=Y2-Y1+1;
  Bpr:=W*3;
  DestPtr:=PByte(BmpData);
//  for Y:=Y2 downto Y1 do begin
  for Y:=Y1 to Y2 do begin

    SrcPtr:=PByte(Bmp.ScanLine[Y]);
    Inc(SrcPtr,X1*3);
    Move(SrcPtr^,DestPtr^,Bpr);
    Inc(DestPtr,Bpr);
  end;
end;

procedure InitBmpFromBmpData(Bmp:TBitmap;BmpData:PByte;BmpW,BmpH:Integer);
var
  Bpr,Y   : Integer;
  DataPtr : PByte;
  Line    : PByteArray;
begin
  Bpr:=BmpW*3;
  DataPtr:=BmpData;
  for Y:=BmpH-1 downto 0 do begin
    Line:=Bmp.ScanLine[Y];
    Move(DataPtr^,Line^,Bpr);
    Inc(DataPtr,Bpr);
  end;
end;

procedure SubtractColorBmpAsmAbs(Bmp1,Bmp2,TargetBmp:TBitmap);
var
  Bmp1Ptr,Bmp2Ptr : Pointer;
  TargetPtr       : Pointer;
  MaxX,Row        : DWord;
  BytesPerRow     : DWord;
  Bpp             : Integer;
begin
// Windows bitmaps start from the bottom
  Bmp1Ptr:=Bmp1.ScanLine[0];
  Bmp2Ptr:=Bmp2.ScanLine[0];
  TargetPtr:=TargetBmp.ScanLine[0];

// find how many bytes per row there are -> width*4+ a byte or two
  BytesPerRow:=Integer(Bmp1.ScanLine[0])-Integer(Bmp1.ScanLine[1]);
  Bpp:=BytesPerPixel(Bmp1);
  MaxX:=Bmp1.Width*Bpp;
  Row:=DWord(Bmp1.Height-1);
  asm
    PUSHA
    MOV   ESI, Bmp1Ptr           // ESI = Bmp1
    MOV   EBX, Bmp2Ptr           // EBX = Bmp2
    MOV   EDI, TargetPtr         // EDI = TargetBmp

@YLoop :
    MOV   EDX, 0                 // EDX = column offset

@XLoop :
    MOV   AL, BYTE Ptr[ESI+EDX]  // load bmp1's blue pixel
    SUB   AL, BYTE Ptr[EBX+EDX]  // subtract bmp2's blue pixel
    JNC   @BluePositive
    MOV   AL, BYTE Ptr[EBX+EDX]  // load bmp2's blue pixel
    SUB   AL, BYTE Ptr[ESI+EDX]  // subtract bmp1's blue pixel

@BluePositive:
    MOV   BYTE Ptr[EDI+EDX+0], AL  // store it in the target's blue pixel

    MOV   AL, BYTE Ptr[ESI+EDX+1]  // load bmp1's green pixel
    SUB   AL, BYTE Ptr[EBX+EDX+1]  // subtract bmp2's green pixel
    JNC   @GreenPositive
    MOV   AL, BYTE Ptr[EBX+EDX+1]  // load bmp2's green pixel
    SUB   AL, BYTE Ptr[ESI+EDX+1]  // subtract bmp1's green pixel

@GreenPositive:
    MOV   BYTE Ptr[EDI+EDX+1], AL  // store it in the target's blue pixel

    MOV   AL, BYTE Ptr[ESI+EDX+2]  // load bmp1's red pixel
    SUB   AL, BYTE Ptr[EBX+EDX+2]  // subtract bmp2's red pixel
    JNC   @RedPositive
    MOV   AL, BYTE Ptr[EBX+EDX+2]  // load bmp2's red pixel
    SUB   AL, BYTE Ptr[ESI+EDX+2]  // subtract bmp1's red pixel

@RedPositive:
    MOV   BYTE Ptr[EDI+EDX+2], AL  // store it in the target's red pixel

    ADD   EDX, Bpp                 // select the next pixel index
    CMP   EDX, MaxX                // done this row?
    JL    @XLoop                   // no: continue to the next pixel in the row

    SUB   ESI, BytesPerRow         // go to the next row
    SUB   EBX, BytesPerRow
    SUB   EDI, BytesPerRow

    DEC   DWord Ptr[Row]
    JGE   @YLOOP
    POPA
  end;
end;

procedure OutlinePixel(Bmp:TBitmap;X,Y:Integer);
const
  Red   = 128;//255;
  Green = 128;//255;
  Blue  = 128;//255;
var
  X2,Y2,I : Integer;
  Line    : PByteArray;
begin
  for Y2:=Y-1 to Y do if (Y2>=0) and (Y2<Bmp.Height) then begin
    Line:=Bmp.ScanLine[Y2];
    for X2:=X-1 to X do if (X2>0) and (X2<(Bmp.Width-1)) then begin
      I:=X2*3;
      Line^[I+0]:=Blue;
      Line^[I+1]:=Green;
      Line^[I+2]:=Red;
    end;
  end;
end;

procedure DrawTestPatternOnBmp(Bmp:TBitmap;BackColor,LineColor:TColor;Spacing:Integer);
var
  I : Integer;
begin
  ClearBmp(Bmp,BackColor);
  Bmp.Canvas.Pen.Color:=LineColor;
  I:=Spacing;
  while (I<Bmp.Width) do begin
    Bmp.Canvas.MoveTo(I,0);
    Bmp.Canvas.LineTo(I,Bmp.Height);
    Inc(I,Spacing);
  end;
  I:=Spacing;
  while (I<Bmp.Height) do begin
    Bmp.Canvas.MoveTo(0,I);
    Bmp.Canvas.LineTo(Bmp.Width,I);
    Inc(I,Spacing);
  end;
end;

procedure HalfScaleBmp(SrcBmp,DestBmp:TBitmap);
var
  X,Y,SrcY,DestY   : Integer;
  SrcI,DestI       : Integer;
  SrcLine,DestLine : PByteArray;
begin
  for DestY:=0 to DestBmp.Height-1 do begin
    SrcY:=DestY*2;
    SrcLine:=SrcBmp.ScanLine[SrcY];
    DestLine:=DestBmp.ScanLine[DestY];
    for X:=0 to DestBmp.Width-1 do begin
      SrcI:=(X*6);
      DestI:=X*3;
      DestLine^[DestI]:=SrcLine^[SrcI];
      DestLine^[DestI+1]:=SrcLine^[SrcI+1];
      DestLine^[DestI+2]:=SrcLine^[SrcI+2];
    end;
  end;
end;

procedure QuarterScaleBmp(SrcBmp,DestBmp:TBitmap);
var
  X,Y,SrcY,DestY   : Integer;
  SrcI,DestI       : Integer;
  SrcLine,DestLine : PByteArray;
begin
  for DestY:=0 to DestBmp.Height-1 do begin
    SrcY:=DestY*4;
    SrcLine:=SrcBmp.ScanLine[SrcY];
    DestLine:=DestBmp.ScanLine[DestY];
    for X:=0 to DestBmp.Width-1 do begin
      SrcI:=(X*12);
      DestI:=X*3;
      DestLine^[DestI]:=SrcLine^[SrcI];
      DestLine^[DestI+1]:=SrcLine^[SrcI+1];
      DestLine^[DestI+2]:=SrcLine^[SrcI+2];
    end;
  end;
end;

function AverageI(Bmp:TBitmap):Single;
var
  X,Y,I : Integer;
  Sum   : Integer;
  Line  : PByteArray;
begin
  Sum:=0;
  for Y:=0 to Bmp.Height-1 do begin
    Line:=Bmp.ScanLine[Y];
    for X:=0 to Bmp.Width-1 do begin
      I:=X*3;
      Sum:=Sum+Line^[I]+Line^[I+1]+Line^[I+2];
    end;
  end;
  Result:=Sum/(Bmp.Width*Bmp.Height*3);
end;

end.



