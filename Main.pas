unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, Vcl.StdCtrls, AprChkBx, NBFill, AprSpin, FlyCapture2_C,
  FlyCapture2Defs_C, FlyCapUtils, Vcl.Buttons, Vcl.Samples.Spin;

type
  TMainFrm = class(TForm)
    Memo: TMemo;
    PaintBox: TPaintBox;
    Timer: TTimer;
    Label6: TLabel;
    AutoTimer: TTimer;
    FrameRateEdit: TSpinEdit;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PaintBoxPaint(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FrameRateEditChange(Sender: TObject);
    procedure NewImageBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);

  private
    procedure CamStatus(Sender:TObject;Txt:String);
    procedure NewCamImage(Sender:TObject);

  public
    Bmp : TBitmap;

  end;

var
  MainFrm: TMainFrm;

implementation

{$R *.dfm}

uses
  CameraU, BmpUtils;

procedure TMainFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Camera[1].Terminate;
end;

procedure TMainFrm.FormCreate(Sender: TObject);
const
  BORDER = 10;
var
  I : Integer;
begin
  CreateCameras;
  for I:=1 to Cameras do begin
    Camera[I].OnStatus:=CamStatus;
    Camera[I].OnNewImage:=NewCamImage;
  end;

  if not AbleToInitFlyCap2 then begin
    ShowMessage('Error initializing FlyCapture2');
    Halt;
  end;

  Bmp:=TBitmap.Create;
  Bmp.PixelFormat:=pf24Bit;

  Bmp.Width:=FlyCapW div 2;
  Bmp.Height:=FlyCapH div 2;

  PaintBox.Width:=Bmp.Width;
  PaintBox.Height:=Bmp.Height;

  ClientWidth:=PaintBox.Left+PaintBox.Width+BORDER;
  ClientHeight:=PaintBox.Top+PaintBox.Height+BORDER;

  Left:=(Screen.Width-ClientWidth) div 2;
  Top:=(Screen.Height-ClientHeight) div 2;

  Memo.Height:=ClientHeight-Memo.Top-Border;

  Camera[1].Start;
//  Camera[1].StartCapture;

  Timer.Enabled:=True;

  Camera[1].ShowTriggerInfo;
end;

procedure TMainFrm.FormDestroy(Sender: TObject);
begin
  ShutDownFlyCap2;
  FreeCameras;
  if Assigned(Bmp) then Bmp.Free;
end;

procedure TMainFrm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#13 then Perform(WM_NEXTDLGCTL,0,0);
end;

procedure TMainFrm.FrameRateEditChange(Sender: TObject);
var
  V : Single;
begin
  V:=FrameRateEdit.Value;
  Camera[1].SetFrameRate(V);
end;

procedure TMainFrm.CamStatus(Sender: TObject; Txt: String);
begin
  Memo.Lines.Add(Txt);
end;

procedure TMainFrm.NewCamImage(Sender: TObject);
begin
  Camera[1].MeasureFPS;
end;

procedure TMainFrm.NewImageBtnClick(Sender: TObject);
begin
  Camera[1].RetrieveImage;
  Camera[1].MeasureFPS;
end;

procedure TMainFrm.PaintBoxPaint(Sender: TObject);
begin
  PaintBox.Canvas.Draw(0,0,Bmp);
end;

procedure TMainFrm.TimerTimer(Sender: TObject);
begin
  EnterCriticalSection(Camera[1].CS);
    Camera[1].DrawQuarterSizedBmp;
    ShowFrameRateOnBmp(Camera[1].Bmp,Camera[1].MeasuredFPS);
  LeaveCriticalSection(Camera[1].CS);

  PaintBox.Canvas.Draw(0,0,Camera[1].Bmp);
end;

end.


