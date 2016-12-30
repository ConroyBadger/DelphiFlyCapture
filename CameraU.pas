unit CameraU;

interface

uses
  Classes, Windows, Graphics, FlyCapture2_C, FlyCapture2Defs_C, FlyCapUtils,
  SysUtils;

const
  CAMERAS = 1;
  FrameRateAverages  = 10;

type
  TOnStatus = procedure(Sender:TObject;Txt:String) of Object;

  TCamera = class(TThread)
  private
    FOnStatus   : TOnStatus;
    FOnNewImage : TNotifyEvent;
    LastFPSTime : DWord;
    FrameRateFrame  : Integer;

  protected
    procedure Execute; override;

  public
    CS  : TRtlCriticalSection;
    Tag : Integer;
    Bmp : TBitmap;

    GUID : TFC2PGRGuid;

    RawImage  : TFC2Image; // raw
    MonoImage : TFC2Image; // mono

    TimeStamp : TFC2TimeStamp;

    FrameCount  : Integer;
    MeasuredFPS : Single;

    constructor Create(iTag:Integer);
    destructor  Destroy; override;

    property OnStatus : TOnStatus read FOnStatus write FOnStatus;
    property OnNewImage : TNotifyEvent read FOnNewImage write FOnNewImage;

//    procedure Execute;

    procedure NewImage(Image: TFC2Image);

    procedure DrawBmp;
    procedure DrawQuarterSizedBmp;

    function NameStr:String;

    procedure FindProperties;
    procedure Connect;
  //  procedure Start;

    procedure CreateImages;
    procedure FreeImages;

    procedure SetupCommunication;
    procedure SetupTriggering;
    procedure SetupEmbeddedImageInfo;
    procedure SetupStrobe;

    function  TriggerReady:Boolean;
    procedure Trigger;

    procedure ShowTriggerInfo;
    procedure SetFrameRate(FrameRate: Single);
    procedure SetProperties;
    procedure SetProperty(iProp: TFC2Property);
    procedure MeasureFPS;
    procedure RetrieveImage;
    procedure StartCapture;
    procedure StartCaptureCallBack;
  end;
  TCameraArray = array[1..CAMERAS] of TCamera;

var
  Camera  : TCameraArray;
  FlyCapW : Integer;
  FlyCapH : Integer;

function  AbleToInitFlyCap2:Boolean;
procedure ShutDownFlyCap2;

procedure CreateCameras;
procedure ConnectCameras;
procedure FreeCameras;

function  FlyCapCamerasFound:Integer;

implementation

var
  CBHandle   : TFC2CallBackHandle;
  FC2Context : TFC2Context;

procedure NewImageCB(var Image:TFC2Image;Data:Pointer); cdecl;
var
  Cam   : TCamera;
begin
  Cam:=Camera[1];//TCamera(Data);
  if Image.DataSize=0 then Exit;

  Cam.NewImage(Image);
end;

function FlyCapCamerasFound:Integer;
var
  Error : TFC2Error;
  Count : DWord;
begin
// find out how many IIDC cameras there are
  Error:=FC2GetNumOfCameras(FC2Context,Count);
  if Error=FC2_ERROR_OK then Result:=Count
  else Result:=0;
end;

function AbleToInitFlyCap2:Boolean;
var
  Error         : TFC2Error;
  ImageSettings : TFC2GigEImageSettings;
begin
  Result:=False;

// create a context
  Error:=FC2CreateGigEContext(FC2Context);
  if Error<>FC2_ERROR_OK then Exit;

// connect the cameras
  ConnectCameras;

// get the image settings
  Error:=FC2GetGigEImageSettings(FC2Context,ImageSettings);
  if Error<>FC2_ERROR_OK then Exit;

  FlyCapW:=ImageSettings.Width;
  FlyCapH:=ImageSettings.Height;

  Result:=True;
end;

procedure ShutDownFlyCap2;
var
  I : Integer;
begin
  FC2Disconnect(FC2Context);
  FC2StopCapture(FC2Context);
  for I:=1 to CAMERAS do Camera[I].FreeImages;

  if Assigned(FC2Context) then fc2DestroyContext(FC2Context);
end;

procedure CreateCameras;
var
  I : Integer;
begin
  for I:=1 to CAMERAS do Camera[I]:=TCamera.Create(I);
end;

procedure ConnectCameras;
var
  Error : TFC2Error;
  Count : DWord;
  I     : Integer;
begin
  Error:=FC2GetNumOfCameras(FC2Context,Count);
  if Error<>FC2_ERROR_OK then  Exit;

  if Count>CAMERAS then Count:=1;
  for I:=1 to Count do Camera[I].Connect;
end;

procedure FreeCameras;
var
  I : Integer;
begin
  for I:=1 to CAMERAS do if Assigned(Camera[I]) then Camera[I].Free;
end;

constructor TCamera.Create(iTag:Integer);
begin
  inherited Create(True);

  Tag:=iTag;

  FrameCount:=0;

  InitializeCriticalSection(CS);

  FOnNewImage:=nil;
  FOnStatus:=nil;

  Bmp:=TBitmap.Create;
  Bmp.PixelFormat:=pf24Bit;

  CreateImages;

  FreeOnTerminate:=False;
  Priority:=tpHighest;
end;

destructor TCamera.Destroy;
begin
  if Assigned(Bmp) then Bmp.Free;

  DeleteCriticalSection(CS);

  inherited;
end;

procedure TCamera.CreateImages;
var
  Error : TFC2Error;
begin
  Error:=FC2CreateImage(RawImage);
  if Error<>FC2_ERROR_OK then Exit;

  Error:=FC2CreateImage(MonoImage);
  if Error<>FC2_ERROR_OK then Exit;
end;

procedure TCamera.FreeImages;
begin
  FC2DestroyImage(RawImage);
  FC2DestroyImage(MonoImage);
end;

procedure TCamera.NewImage(Image:TFC2Image);
var
  Error : TFC2Error;
begin
  EnterCriticalSection(CS);
    TimeStamp:=FC2GetImageTimeStamp(Image);
    Error:=FC2ConvertImageTo(FC2_PIXEL_FORMAT_MONO8,Image,MonoImage);
  LeaveCriticalSection(CS);

  if Error=FC2_ERROR_OK then begin
    if Assigned(FOnNewImage) then FOnNewImage(Self);
  end;
end;

procedure TCamera.DrawBmp;
begin
  DrawBmpFromFlyCap2Image(Bmp,MonoImage);
end;

procedure TCamera.DrawQuarterSizedBmp;
begin
  DrawQuartedSizedBmpFromFlyCap2Image(Bmp,MonoImage);
end;

function TCamera.NameStr:String;
begin
  Result:='Camera #'+IntToStr(Tag);
end;

procedure TCamera.Connect;
var
  Error : TFC2Error;
begin
// get the GUID
  Error:=FC2GetCameraFromIndex(FC2Context,Tag-1,GUID);
  if Error<>FC2_ERROR_OK then Exit;

// connect to the camera
  Error:=FC2Connect(FC2Context,GUID);
  if Error<>FC2_ERROR_OK then Exit;

// setup the communication
  SetupCommunication;

// enable the strobe output
  SetupStrobe;

// setup the triggering
  SetupTriggering;

// setup the timestamp
  SetupEmbeddedImageInfo;

  if Assigned(FOnStatus) then FOnStatus(Self,'Camera #'+IntToStr(Tag)+' ready');
end;

procedure TCamera.FindProperties;
begin
end;

procedure TCamera.SetupEmbeddedImageInfo;
var
  Error : TFC2Error;
  Info  : TFC2EmbeddedImageInfo;
begin
  Error:=FC2GetEmbeddedImageInfo(FC2Context,Info);
  if Error<>FC2_ERROR_OK then begin
    if Assigned(FOnStatus) then begin
      FOnStatus(Self,'Error getting embedded image info');
    end;
    Exit;
  end;

  if Info.Timestamp.Available then Info.TimeStamp.OnOff:=True
  else if Assigned(FOnStatus) then FOnStatus(Self,'Timestamp not available');

  Error:=FC2SetEmbeddedImageInfo(FC2Context,Info);
  if Error<>FC2_ERROR_OK then begin
    if Assigned(FOnStatus) then begin
      FOnStatus(Self,'Error setting embedded image info');
    end;
  end;
end;

procedure TCamera.SetupCommunication;
var
  Error : TFC2Error;
  Cfg   : TFC2Config;
begin
  Error:=fc2GetConfiguration(FC2Context,Cfg);
  if Error<>FC2_ERROR_OK then begin
    if Assigned(FOnStatus) then FOnStatus(Self,'Error getting cfg');
    Exit;
  end;

  Cfg.GrabTimeout:=5000; // milliseconds
  Cfg.HighPerfRetrieveBuffer:=True;

  Error:=FC2SetConfiguration(FC2Context,Cfg);
  if Error<>FC2_ERROR_OK then begin
    if Assigned(FOnStatus) then FOnStatus(Self,'Error setting cfg');
  end;
end;

procedure TCamera.ShowTriggerInfo;
var
  Error : TFC2Error;
  Info  : TFC2TriggerModeInfo;
begin
// get the trigger mode
  Error:=fc2GetTriggerModeInfo(FC2Context,Info);
  if Error<>FC2_ERROR_OK then begin
    if Assigned(FOnStatus) then begin
      FOnStatus(Self,'Error getting trigger mode info '+NameStr);
    end;
    Exit;
  end;

  if Assigned(FOnStatus) then begin
    FOnStatus(Self,'Trigger mode info:');
    if Info.Present then FOnStatus(Self,'Trigger present');
    if Info.SoftwareTriggerSupported then begin
      FOnStatus(Self,'Software trigger present');
    end;
    FOnStatus(Self,'Mode mask: $'+IntToHex(Info.ModeMask,8));

// Also:
//		ReadOutSupported         : Bool;
//		OnOffSupported           : Bool;
//		PolaritySupported        : Bool;
//		ValueReadable            : Bool;
//    SourceMask               : DWord;
  end;
end;

procedure TCamera.SetupTriggering;
var
  Error  : TFC2Error;
  TriggerMode : TFC2TriggerMode;
begin
// get the trigger mode
  Error:=FC2GetTriggerMode(FC2Context,TriggerMode);
  if Error<>FC2_ERROR_OK then begin
    if Assigned(FOnStatus) then FOnStatus(Self,'Error getting trigger mode '+NameStr);
    Exit;
  end;

// assert these
  TriggerMode.OnOff:=False;
  TriggerMode.Mode:=0;
  TriggerMode.Parameter:=0;
  TriggerMode.Source:=7;

// set the trigger mode
  Error:=FC2SetTriggerMode(FC2Context,TriggerMode);
  if Error<>FC2_ERROR_OK then begin
    if Assigned(FOnStatus) then FOnStatus(Self,'Error setting trigger mode '+NameStr);
    Exit;
  end;
  if Assigned(FOnStatus) then FOnStatus(Self,'Trigger setup '+NameStr);
end;

procedure TCamera.SetupStrobe;
var
  Strobe : TFC2StrobeControl;
  Error  : TFC2Error;
begin
  Strobe.Source:=1;
  Strobe.OnOff:=True;
  Strobe.Polarity:=1;
  Strobe.Delay:=0;
  Strobe.Duration:=0;
  FillChar(Strobe.Reserved,SizeOf(Strobe.Reserved),0);

  Error:=FC2SetStrobe(FC2Context,Strobe);
end;

const
  TriggerBit = $80000000;

function TCamera.TriggerReady:Boolean;
var
  V     : DWord;
  Error : TFC2Error;
begin
  V:=0;
  Error:=fc2ReadRegister(FC2Context,$62C,V);
  if Error<>FC2_ERROR_OK then begin
    if Assigned(FOnStatus) then FOnStatus(Self,'Error reading trigger');
    Result:=False;
  end
  else Result:=((V and TriggerBit)=0);
end;

procedure TCamera.Trigger;
var
  Error : TFC2Error;
begin
  EnterCriticalSection(CS);
    Error:=fc2WriteRegister(FC2Context,$62C,TriggerBit);
  LeaveCriticalSection(CS);
  if Error<>FC2_ERROR_OK then begin
    if Assigned(FOnStatus) then FOnStatus(Self,'Error setting trigger');
  end;
end;

procedure TCamera.SetFrameRate(FrameRate:Single);
var
  Prop  : TFC2Property;
  Error : TFC2Error;
begin
  Prop.PropertyType:=FC2_FRAME_RATE;
  Error:=FC2GetProperty(FC2Context,Prop);
  if Error<>FC2_ERROR_OK then begin
    if Assigned(FOnStatus) then FOnStatus(Self,'Error getting frame rate');
    Exit;
  end;

  Prop.OnOff:=True;
  Prop.AutoManualMode:=False;
  Prop.AbsControl:=True;
  Prop.AbsValue:=FrameRate;

  Error:=FC2SetProperty(FC2Context,Prop);
  if Error<>FC2_ERROR_OK then begin
    if Assigned(FOnStatus) then FOnStatus(Self,'Error setting frame rate');
  end;
end;

procedure TCamera.SetProperty(iProp:TFC2Property);
var
  Prop  : TFC2Property;
  Error : TFC2Error;
begin
  Prop.PropertyType:=iProp.PropertyType;
  Error:=FC2GetProperty(FC2Context,Prop);
  if Error<>FC2_ERROR_OK then begin
    if Assigned(FOnStatus) then FOnStatus(Self,'Error getting property');
    Exit;
  end;

  with iProp do begin
    Prop.OnOff:=OnOff;
    Prop.AutoManualMode:=AutoManualMode;
    Prop.AbsControl:=AbsControl;

    Prop.ValueA:=ValueA;
    Prop.AbsValue:=AbsValue;
  end;

  Error:=FC2SetProperty(FC2Context,Prop);
  if Error<>FC2_ERROR_OK then begin
    if Assigned(FOnStatus) then FOnStatus(Self,'Error setting property');
  end;
end;

procedure TCamera.SetProperties;
var
  Prop : TFC2Property;
begin
// sharpness
  Prop.PropertyType:=FC2_SHARPNESS;
  Prop.OnOff:=False;
  Prop.AutoManualMode:=False;
  Prop.AbsControl:=False;
  Prop.ValueA:=0;
  Prop.AbsValue:=0;
  SetProperty(Prop);

// gain
  Prop.PropertyType:=FC2_GAIN;
  Prop.OnOff:=True;
  Prop.AutoManualMode:=False;
  Prop.AbsControl:=True;
  Prop.ValueA:=0;
  Prop.AbsValue:=0;
  SetProperty(Prop);

// gamma
  Prop.PropertyType:=FC2_GAMMA;
  Prop.OnOff:=False;
  Prop.AutoManualMode:=False;
  Prop.AbsControl:=False;
  Prop.ValueA:=0;
  Prop.AbsValue:=0;
  SetProperty(Prop);
end;

procedure TCamera.MeasureFPS;
var
  Time        : DWord;
  ElapsedTime : Single;
begin
  Inc(FrameCount);
  if (FrameCount-FrameRateFrame)>=FrameRateAverages then begin
    Time:=GetTickCount;
    ElapsedTime:=(Time-LastFPSTime)/1000;

    EnterCriticalSection(CS);
      if ElapsedTime=0 then MeasuredFPS:=0
      else MeasuredFPS:=FrameRateAverages/ElapsedTime;
    LeaveCriticalSection(CS);

    LastFPSTime:=Time;

    FrameRateFrame:=FrameCount;
  end;
end;

procedure TCamera.RetrieveImage;
var
  Error : TFC2Error;
begin
	Error:=fc2RetrieveBuffer(FC2Context,&RawImage);
	if Error<>FC2_ERROR_OK  then begin
    Exit;
  end;

// Convert the raw image
	Error:=FC2ConvertImageTo(FC2_PIXEL_FORMAT_MONO8,RawImage,MonoImage);
	if Error<>FC2_ERROR_OK  then begin
    Exit;
  end;
end;

procedure TCamera.StartCapture;
var
  Error : TFC2Error;
  Count : Integer;
  I     : Integer;
begin
  Error:=fc2StartCapture(FC2Context);
  if Error<>FC2_ERROR_OK then begin
    Exit;
  end;
end;

procedure TCamera.StartCaptureCallBack;
var
  Error : TFC2Error;
  Count : Integer;
  I     : Integer;
begin
  Error:=fc2StartCaptureCallback(FC2Context,NewImageCB,nil);
  if Error<>FC2_ERROR_OK then begin
    Exit;
  end;
end;

procedure TCamera.Execute;
var
  Error : TFC2Error;
begin
  StartCapture;
  while not Terminated do begin

// get the latest buffer
   	Error:=FC2RetrieveBuffer(FC2Context,&RawImage);
  	if Error=FC2_ERROR_OK  then begin

// convert to a mono image
      EnterCriticalSection(CS);
        Error:=FC2ConvertImageTo(FC2_PIXEL_FORMAT_MONO8,RawImage,MonoImage);
        MeasureFPS;
      LeaveCriticalSection(CS);
    end;
  end;
end;

end.
