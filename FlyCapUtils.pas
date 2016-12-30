unit FlyCapUtils;

interface

uses
  Classes, SysUtils, Graphics, FlyCapture2_C, FlyCapture2Defs_C;

function  FlyCap2VersionStr(Version:TFC2Version):String;
function  FlyCap2GUIDStr(GUID:TFC2PGRGuid):String;
function  FlyCap2InterfaceStr(IFace:TFC2Interface):String;

procedure DrawBmpFromFlyCap2Image(Bmp:TBitmap;var Image:TFC2Image);
procedure DrawQuartedSizedBmpFromFlyCap2Image(Bmp:TBitmap;var Image:TFC2Image);

procedure ShowCameraInfo(Info:TFC2CameraInfo;Lines:TStrings);
procedure ShowStreamChannel(Channel:TFC2GigEStreamChannel;Lines:TStrings);

function FC2ErrorStr(Error:TFC2Error):String;

function FC2PropertyTypeStr(Prop:TFC2PropertyType):String;

procedure ShowFC2PropertyInfo(PropInfo:TFC2PropertyInfo;Lines:TStrings);

function FlyCapVersion:String;

function TimeStampStr(var TimeStamp:TFC2TimeStamp):String;

implementation

type
  TBGRPixel = packed record
    B,G,R : Byte;
  end;
  PBGRPixel = ^TBGRPixel;

function TimeStampStr(var TimeStamp:TFC2TimeStamp):String;
var
  S : Single;
begin
//  S:=TimeStamp.Seconds+TimeStamp.MicroSeconds/1000000;
 // S:=TimeStamp.CycleSeconds*8000 + TimeStamp.CycleCount;
  S:=TimeStamp.CycleSeconds*0.8+TimeStamp.CycleCount/10000;

  Result:=FloatToStrF(S,ffFixed,9,3);
end;

function FlyCap2VersionStr(Version:TFC2Version):String;
begin
  with Version do begin
    Result:='FlyCap2 version: '+IntToStr(Major)+'.'+IntToStr(Minor)+
            ' Type: '+IntToStr(VType)+' Build: '+IntToStr(Build);
  end;
end;

function FlyCapVersion:String;
var
  Version : TFC2Version;
  Error   : TFC2Error;
begin
  Error:=FC2GetLibraryVersion(Version);
  if Error=FC2_ERROR_OK then Result:=FlyCap2VersionStr(Version)
  else Result:='Error getting library version';
end;

function FlyCap2GUIDStr(GUID:TFC2PGRGuid):String;
var
  I : Integer;
begin
  Result:='GUID: [';
  for I:=1 to 4 do begin
    Result:=Result+IntToStr(GUID.Value[I]);
    if I<4 then Result:=Result+', ';
  end;
  Result:=Result+']';
end;

function FlyCap2InterfaceStr(IFace:TFC2Interface):String;
begin
  Result:='Interface: ';
  Case IFace of
    7 : Result:='';
  	FC2_INTERFACE_IEEE1394 : Result:=Result+'Firewire';
    FC2_INTERFACE_USB_2    : Result:=Result+'USB 2';
  	FC2_INTERFACE_USB_3    : Result:=Result+'USB 3';
  	FC2_INTERFACE_GIGE     : Result:=Result+'GigE';
  	FC2_INTERFACE_UNKNOWN  : Result:=Result+'???';
  end;
end;

function FC2Str(InStr:TFC2String):AnsiString;
var
  I,Size : Integer;
begin
  I:=0;
  repeat
    Inc(I);
  until (InStr[I]=#0) or (I=MAX_STRING_LENGTH);

  Size:=I;
  SetLength(Result,Size);
  Move(InStr[1],Result[1],Size);
end;

procedure ShowCameraInfo(Info:TFC2CameraInfo;Lines:TStrings);
begin
  with Info do begin
    Lines.Add('');
    Lines.Add('Serial number : '+IntToStr(SerialNumber));
	  Lines.Add('Model         : '+FC2Str(ModelName));
	  Lines.Add('Vendor        : '+FC2Str(VendorName));
    Lines.Add('Sensor        : '+FC2Str(SensorInfo));
    Lines.Add('Resolution    : '+FC2Str(SensorResolution));
    Lines.Add('Firmware      : '+FC2Str(FirmwareVersion));
    Lines.Add('FW Build time : '+FC2Str(FirmwareBuildTime));
  end;
end;

function FC2IPStr(var IP:TFC2IpAddress):String;
var
  I : Integer;
begin
  Result:='';
  for I:=1 to 4 do begin
    Result:=Result+IntToStr(IP.Octets[I]);
    if I<4 then Result:=Result+'.';
  end;
end;

procedure ShowStreamChannel(Channel:TFC2GigEStreamChannel;Lines:TStrings);
begin
  with Channel do begin
    Lines.Add('Network index  : '+IntToStr(NetworkInterfaceIndex));
		Lines.Add('Host port      : '+IntToStr(HostPort));
		Lines.Add('Packet size    : '+IntToStr(PacketSize));
    Lines.Add('Packet delay   : '+IntToStr(InterPacketDelay));
    Lines.Add('Destination IP : '+FC2IPStr(DestinationIP));
		Lines.Add('Source port    : '+IntToStr(SourcePort));

    if DoNotFragment then Lines.Add('Do not fragment')
    else Lines.Add('Fragment allowed');
  end;
end;

procedure DrawBmpFromFlyCap2Image(Bmp:TBitmap;var Image:TFC2Image);
var
  SrcPtr    : PByte;
  DestPixel : PBGRPixel;
  V         : Byte;
  X,Y,I     : Integer;
begin
  with Image do begin

// make sure the bitmap is right
    Bmp.Width:=Cols;
    Bmp.Height:=Rows;
    Bmp.PixelFormat:=pf24Bit;

// copy the data
    SrcPtr:=Data;
    for Y:=0 to Rows-1 do begin
      DestPixel:=PBGRPixel(Bmp.ScanLine[Y]);
      I:=0;
      for X:=0 to Cols-1 do begin
        V:=SrcPtr^;
        DestPixel^.B:=V;
        DestPixel^.G:=V;
        DestPixel^.R:=V;

        Inc(SrcPtr);
        Inc(DestPixel);
      end;
    end;
  end;
end;

procedure DrawQuartedSizedBmpFromFlyCap2Image(Bmp:TBitmap;var Image:TFC2Image);
var
  SrcPtr    : PByte;
  DestPixel : PBGRPixel;
  V         : Byte;
  X,Y,I     : Integer;
begin
  with Image do begin

// make sure the bitmap is right
    Bmp.Width:=Cols div 2;
    Bmp.Height:=Rows div 2;
    Bmp.PixelFormat:=pf24Bit;

// copy the data
    SrcPtr:=Data;
    for Y:=0 to Bmp.Height-1 do begin
      DestPixel:=PBGRPixel(Bmp.ScanLine[Y]);
      I:=0;
      for X:=0 to Bmp.Width-1 do begin
        V:=SrcPtr^;
        DestPixel^.B:=V;
        DestPixel^.G:=V;
        DestPixel^.R:=V;
        Inc(DestPixel);

// skip the next source column
        Inc(SrcPtr,2);
      end;

// skip
      Inc(SrcPtr,Cols);
    end;
  end;
end;

function FC2ErrorStr(Error:TFC2Error):String;
begin
  Case Error of
    FC2_ERROR_UNDEFINED                    : Result:='???';
    FC2_ERROR_OK                           : Result:='Function returned with no errors';
    FC2_ERROR_FAILED                       : Result:='General failure';
    FC2_ERROR_NOT_IMPLEMENTED              : Result:='Function has not been implemented';
    FC2_ERROR_FAILED_BUS_MASTER_CONNECTION : Result:='Could not connect to Bus Master';
    FC2_ERROR_NOT_CONNECTED                : Result:='Camera has not been connected';
    FC2_ERROR_INIT_FAILED                  : Result:='Initialization failed';
    FC2_ERROR_NOT_INTITIALIZED             : Result:='Camera has not been initialized';
    FC2_ERROR_INVALID_PARAMETER            : Result:='Invalid parameter passed to function';
    FC2_ERROR_INVALID_SETTINGS             : Result:='Setting set to camera is invalid';
    FC2_ERROR_INVALID_BUS_MANAGER          : Result:='Invalid Bus Manager object';
    FC2_ERROR_MEMORY_ALLOCATION_FAILED     : Result:='Could not allocate memory';
    FC2_ERROR_LOW_LEVEL_FAILURE            : Result:='Low level error';
    FC2_ERROR_NOT_FOUND                    : Result:='Device not found';
    FC2_ERROR_FAILED_GUID                  : Result:='GUID failure';
    FC2_ERROR_INVALID_PACKET_SIZE          : Result:='Packet size set to camera is invalid';
    FC2_ERROR_INVALID_MODE                 : Result:='Invalid mode has been passed to function';
    FC2_ERROR_NOT_IN_FORMAT7               : Result:='Error due to not being in Format7';
    FC2_ERROR_NOT_SUPPORTED                : Result:='This feature is unsupported';
    FC2_ERROR_TIMEOUT                      : Result:='Timeout error';
    FC2_ERROR_BUS_MASTER_FAILED            : Result:='Bus Master Failure';
    FC2_ERROR_INVALID_GENERATION           : Result:='Generation Count Mismatch';
    FC2_ERROR_LUT_FAILED                   : Result:='Look Up Table failure';
    FC2_ERROR_IIDC_FAILED                  : Result:='IIDC failure';
    FC2_ERROR_STROBE_FAILED                : Result:='Strobe failure';
    FC2_ERROR_TRIGGER_FAILED               : Result:='Trigger failure';
    FC2_ERROR_PROPERTY_FAILED              : Result:='Property failure';
    FC2_ERROR_PROPERTY_NOT_PRESENT         : Result:='Property is not present';
    FC2_ERROR_REGISTER_FAILED              : Result:='Register access failed';
    FC2_ERROR_READ_REGISTER_FAILED         : Result:='Register read failed';
    FC2_ERROR_WRITE_REGISTER_FAILED        : Result:='Register write failed';
    FC2_ERROR_ISOCH_FAILED                 : Result:='Isochronous failure';
    FC2_ERROR_ISOCH_ALREADY_STARTED        : Result:='Isochronous transfer has already been started';
    FC2_ERROR_ISOCH_NOT_STARTED            : Result:='Isochronous transfer has not been started';
    FC2_ERROR_ISOCH_START_FAILED           : Result:='Isochronous start failed';
    FC2_ERROR_ISOCH_RETRIEVE_BUFFER_FAILED : Result:='Isochronous retrieve buffer failed';
    FC2_ERROR_ISOCH_STOP_FAILED            : Result:='Isochronous stop failed';
    FC2_ERROR_ISOCH_SYNC_FAILED            : Result:='Isochronous image synchronization failed';
    FC2_ERROR_ISOCH_BANDWIDTH_EXCEEDED     : Result:='Isochronous bandwidth exceeded';
    FC2_ERROR_IMAGE_CONVERSION_FAILED      : Result:='Image conversion failed';
    FC2_ERROR_IMAGE_LIBRARY_FAILURE        : Result:='Image library failure';
    FC2_ERROR_BUFFER_TOO_SMALL             : Result:='Buffer is too small';
    FC2_ERROR_IMAGE_CONSISTENCY_ERROR      : Result:='There is an image consistency error';
    FC2_ERROR_INCOMPATIBLE_DRIVER          : Result:='The installed driver is not compatible with the library';
  end;
end;

function FC2PropertyTypeStr(Prop:TFC2PropertyType):String;
begin
  Case Prop of
  	FC2_BRIGHTNESS    : Result:='BRIGHTNESS';
  	FC2_AUTO_EXPOSURE : Result:='AUTO_EXPOSURE';
	  FC2_SHARPNESS     : Result:='SHARPNESS';
  	FC2_WHITE_BALANCE : Result:='WHITE BALANCE';
	  FC2_HUE           : Result:='HUE';
  	FC2_SATURATION    : Result:='SATURATION';
  	FC2_GAMMA         : Result:='GAMMA';
	  FC2_IRIS          : Result:='IRIS';
  	FC2_FOCUS         : Result:='FOCUS';
	  FC2_ZOOM          : Result:='ZOOM';
  	FC2_PAN           : Result:='PAN';
  	FC2_TILT          : Result:='TILT';
  	FC2_SHUTTER       : Result:='SHUTTER';
  	FC2_GAIN          : Result:='GAIN';
  	FC2_TRIGGER_MODE  : Result:='TRIGGER_MODE';
  	FC2_TRIGGER_DELAY : Result:='TRIGGER_DELAY';
  	FC2_FRAME_RATE    : Result:='FRAME_RATE';
	  FC2_TEMPERATURE   : Result:='TEMPERATURE';
    else Result:='???';
  end;
end;

procedure ShowFC2PropertyInfo(PropInfo:TFC2PropertyInfo;Lines:TStrings);
begin
  Lines.Add('');
  Lines.Add('Properties:');
  with PropInfo do begin
    Lines.Add(FC2PropertyTypeStr(PropertyType)+':');

    if Present then begin
      Lines.Add('Present');

      if AutoSupported then Lines.Add('Auto')
      else Lines.Add('No auto');

      if ManualSupported  then Lines.Add('Manual')
      else Lines.Add('No manual');

      if OnOffSupported then Lines.Add('On/off')
      else Lines.Add('No on/off');

      if OnePushSupported then Lines.Add('One push')
      else Lines.Add('No one push');

      if AbsValSupported then Lines.Add('ABS value')
      else Lines.Add('No ABS value');

      if AbsValSupported then Lines.Add('Read out')
      else Lines.Add('No read out');

      Lines.Add('Min : '+IntToStr(Min));
      Lines.Add('Max : '+IntToStr(Max));

      Lines.Add('AbsMin : '+FloatToStrF(AbsMin,ffFixed,9,3));
      Lines.Add('AbsMax : '+FloatToStrF(AbsMax,ffFixed,9,3));

      Lines.Add('Units : '+FC2Str(Units));
    end
    else Lines.Add('Not available');

    Lines.Add('');
  end;
end;

end.

FC2PropertyInfo = record
    PropertyType     : TFC2Property;
		Present          : Bool;
		autoSupported    : Bool;
		manualSupported  : Bool;
		onOffSupported   : Bool;
		onePushSupported : Bool;
		absValSupported  : Bool;
		readOutSupported : Bool;
    Min              : DWord;
    Max              : DWord;
    AbsMin           : Single;
    AbsMax           : Single;
    Units            : TFC2String; //array[1..MAX_STRING_LENGTH] of Char;
    Reserved         : array[1..8] of DWord;
  end;



  FC2_ERROR_UNDEFINED : Integer = -1;      // ???
  FC2_ERROR_OK : Integer = 0;      // /**< Function returned with no errors. */
  FC2_ERROR_FAILED : Integer = 1;      // /**< General failure. */
  FC2_ERROR_NOT_IMPLEMENTED : Integer = 2;      // /**< Function has not been implemented. */
  FC2_ERROR_FAILED_BUS_MASTER_CONNECTION : Integer = 3;      // /**< Could not connect to Bus Master. */
  FC2_ERROR_NOT_CONNECTED : Integer = 4;      // /**< Camera has not been connected. */
  FC2_ERROR_INIT_FAILED : Integer = 5;      // /**< Initialization failed. */
  FC2_ERROR_NOT_INTITIALIZED : Integer = 6;      // /**< Camera has not been initialized. */
  FC2_ERROR_INVALID_PARAMETER : Integer = 7;      // /**< Invalid parameter passed to function. */
  FC2_ERROR_INVALID_SETTINGS : Integer = 8;      // /**< Setting set to camera is invalid. */
  FC2_ERROR_INVALID_BUS_MANAGER : Integer = 9;      // /**< Invalid Bus Manager object. */
  FC2_ERROR_MEMORY_ALLOCATION_FAILED : Integer = 10;      // /**< Could not allocate memory. */
  FC2_ERROR_LOW_LEVEL_FAILURE : Integer = 11;      // /**< Low level error. */
  FC2_ERROR_NOT_FOUND : Integer = 12;      // /**< Device not found. */
  FC2_ERROR_FAILED_GUID : Integer = 13;      // /**< GUID failure. */
  FC2_ERROR_INVALID_PACKET_SIZE : Integer = 14;      // /**< Packet size set to camera is invalid. */
  FC2_ERROR_INVALID_MODE : Integer = 15;      // /**< Invalid mode has been passed to function. */
  FC2_ERROR_NOT_IN_FORMAT7 : Integer = 16;      // /**< Error due to not being in Format7. */
  FC2_ERROR_NOT_SUPPORTED : Integer = 17;      // /**< This feature is unsupported. */
  FC2_ERROR_TIMEOUT : Integer = 18;      // /**< Timeout error. */
  FC2_ERROR_BUS_MASTER_FAILED : Integer = 19;      // /**< Bus Master Failure. */
  FC2_ERROR_INVALID_GENERATION : Integer = 20;      // /**< Generation Count Mismatch. */
  FC2_ERROR_LUT_FAILED : Integer = 21;      // /**< Look Up Table failure. */
  FC2_ERROR_IIDC_FAILED : Integer = 22;      // /**< IIDC failure. */
  FC2_ERROR_STROBE_FAILED : Integer = 23;      // /**< Strobe failure. */
  FC2_ERROR_TRIGGER_FAILED : Integer = 24;      // /**< Trigger failure. */
  FC2_ERROR_PROPERTY_FAILED : Integer = 25;      // /**< Property failure. */
  FC2_ERROR_PROPERTY_NOT_PRESENT : Integer = 26;      // /**< Property is not present. */
  FC2_ERROR_REGISTER_FAILED : Integer = 27;      // /**< Register access failed. */
  FC2_ERROR_READ_REGISTER_FAILED : Integer = 28;      // /**< Register read failed. */
  FC2_ERROR_WRITE_REGISTER_FAILED : Integer = 29;      // /**< Register write failed. */
  FC2_ERROR_ISOCH_FAILED : Integer = 30;      // /**< Isochronous failure. */
  FC2_ERROR_ISOCH_ALREADY_STARTED : Integer = 31;      // /**< Isochronous transfer has already been started. */
  FC2_ERROR_ISOCH_NOT_STARTED : Integer = 32;      // /**< Isochronous transfer has not been started. */
  FC2_ERROR_ISOCH_START_FAILED : Integer = 33;      // /**< Isochronous start failed. */
  FC2_ERROR_ISOCH_RETRIEVE_BUFFER_FAILED : Integer = 34;      // /**< Isochronous retrieve buffer failed. */
  FC2_ERROR_ISOCH_STOP_FAILED : Integer = 35;      // /**< Isochronous stop failed. */
  FC2_ERROR_ISOCH_SYNC_FAILED : Integer = 36;      // /**< Isochronous image synchronization failed. */
  FC2_ERROR_ISOCH_BANDWIDTH_EXCEEDED : Integer = 37;      // /**< Isochronous bandwidth exceeded. */
  FC2_ERROR_IMAGE_CONVERSION_FAILED : Integer = 38;      // /**< Image conversion failed. */
  FC2_ERROR_IMAGE_LIBRARY_FAILURE : Integer = 39;      // /**< Image library failure. */
  FC2_ERROR_BUFFER_TOO_SMALL : Integer = 40;      // /**< Buffer is too small. */
  FC2_ERROR_IMAGE_CONSISTENCY_ERROR : Integer = 41;      // /**< There is an image consistency error. */
  FC2_ERROR_INCOMPATIBLE_DRIVER : Integer = 42;      // /**< The installed driver is not compatible with the library. */

