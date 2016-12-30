unit FlyCapture2Defs_C;

interface

uses
  Windows;

const
  FULL_32BIT_VALUE :  Integer = $7FFFFFFF;

  MAX_STRING_LENGTH = 512;

type
  TCallBackData = Pointer;
  PCallBackData = ^TCallBackData;

  TFC2String = array[1..MAX_STRING_LENGTH] of Char;

  TFC2Version = record
    Major  : DWord;
    Minor  : DWord;
    VType  : DWord;
    Build  : DWord;
  end;

// A context to the FlyCapture2 C library. It must be created before
// performing any calls to the library.
  TFC2Context = Pointer;
  PFC2Context = ^TFC2Context;

 // A context to the FlyCapture2 C GUI library. It must be created before
 // performing any calls to the library.
  TFC2GuiContext = Pointer;

  TFC2Error = Integer;

const
  FC2_ERROR_UNDEFINED = -1;      // ???
  FC2_ERROR_OK = 0;      // /**< Function returned with no errors. */
  FC2_ERROR_FAILED = 1;      // /**< General failure. */
  FC2_ERROR_NOT_IMPLEMENTED = 2;      // /**< Function has not been implemented. */
  FC2_ERROR_FAILED_BUS_MASTER_CONNECTION = 3;      // /**< Could not connect to Bus Master. */
  FC2_ERROR_NOT_CONNECTED = 4;      // /**< Camera has not been connected. */
  FC2_ERROR_INIT_FAILED = 5;      // /**< Initialization failed. */
  FC2_ERROR_NOT_INTITIALIZED = 6;      // /**< Camera has not been initialized. */
  FC2_ERROR_INVALID_PARAMETER = 7;      // /**< Invalid parameter passed to function. */
  FC2_ERROR_INVALID_SETTINGS = 8;      // /**< Setting set to camera is invalid. */
  FC2_ERROR_INVALID_BUS_MANAGER = 9;      // /**< Invalid Bus Manager object. */
  FC2_ERROR_MEMORY_ALLOCATION_FAILED = 10;      // /**< Could not allocate memory. */
  FC2_ERROR_LOW_LEVEL_FAILURE = 11;      // /**< Low level error. */
  FC2_ERROR_NOT_FOUND = 12;      // /**< Device not found. */
  FC2_ERROR_FAILED_GUID = 13;      // /**< GUID failure. */
  FC2_ERROR_INVALID_PACKET_SIZE = 14;      // /**< Packet size set to camera is invalid. */
  FC2_ERROR_INVALID_MODE = 15;      // /**< Invalid mode has been passed to function. */
  FC2_ERROR_NOT_IN_FORMAT7 = 16;      // /**< Error due to not being in Format7. */
  FC2_ERROR_NOT_SUPPORTED = 17;      // /**< This feature is unsupported. */
  FC2_ERROR_TIMEOUT = 18;      // /**< Timeout error. */
  FC2_ERROR_BUS_MASTER_FAILED = 19;      // /**< Bus Master Failure. */
  FC2_ERROR_INVALID_GENERATION = 20;      // /**< Generation Count Mismatch. */
  FC2_ERROR_LUT_FAILED = 21;      // /**< Look Up Table failure. */
  FC2_ERROR_IIDC_FAILED = 22;      // /**< IIDC failure. */
  FC2_ERROR_STROBE_FAILED = 23;      // /**< Strobe failure. */
  FC2_ERROR_TRIGGER_FAILED = 24;      // /**< Trigger failure. */
  FC2_ERROR_PROPERTY_FAILED = 25;      // /**< Property failure. */
  FC2_ERROR_PROPERTY_NOT_PRESENT = 26;      // /**< Property is not present. */
  FC2_ERROR_REGISTER_FAILED = 27;      // /**< Register access failed. */
  FC2_ERROR_READ_REGISTER_FAILED = 28;      // /**< Register read failed. */
  FC2_ERROR_WRITE_REGISTER_FAILED = 29;      // /**< Register write failed. */
  FC2_ERROR_ISOCH_FAILED = 30;      // /**< Isochronous failure. */
  FC2_ERROR_ISOCH_ALREADY_STARTED = 31;      // /**< Isochronous transfer has already been started. */
  FC2_ERROR_ISOCH_NOT_STARTED = 32;      // /**< Isochronous transfer has not been started. */
  FC2_ERROR_ISOCH_START_FAILED = 33;      // /**< Isochronous start failed. */
  FC2_ERROR_ISOCH_RETRIEVE_BUFFER_FAILED = 34;      // /**< Isochronous retrieve buffer failed. */
  FC2_ERROR_ISOCH_STOP_FAILED = 35;      // /**< Isochronous stop failed. */
  FC2_ERROR_ISOCH_SYNC_FAILED = 36;      // /**< Isochronous image synchronization failed. */
  FC2_ERROR_ISOCH_BANDWIDTH_EXCEEDED = 37;      // /**< Isochronous bandwidth exceeded. */
  FC2_ERROR_IMAGE_CONVERSION_FAILED = 38;      // /**< Image conversion failed. */
  FC2_ERROR_IMAGE_LIBRARY_FAILURE = 39;      // /**< Image library failure. */
  FC2_ERROR_BUFFER_TOO_SMALL = 40;      // /**< Buffer is too small. */
  FC2_ERROR_IMAGE_CONSISTENCY_ERROR = 41;      // /**< There is an image consistency error. */
  FC2_ERROR_INCOMPATIBLE_DRIVER = 42;      // /**< The installed driver is not compatible with the library. */

type
  TFC2Interface = Integer;

const
	FC2_INTERFACE_IEEE1394 = 0;//Integer = 0;
  FC2_INTERFACE_USB_2    = 1;
	FC2_INTERFACE_USB_3    = 2;
	FC2_INTERFACE_GIGE     = 3;
	FC2_INTERFACE_UNKNOWN  = 4;

type
  TFC2PGRGuid = record
    Value : array[1..4] of DWord;
  end;

  TFC2CallbackHandle = Pointer;

// An internal pointer used in the fc2Image structure.
	TFC2ImageImpl = Pointer;

  TFC2BusCallbackType = Integer;

const
	FC2_BUS_RESET = 0;
 	FC2_ARRIVAL = 1;
	FC2_REMOVAL = 2;

type
  TFC2PropertyType = Integer;

const
	FC2_BRIGHTNESS                = 0;
	FC2_AUTO_EXPOSURE             = 1;
	FC2_SHARPNESS                 = 2;
	FC2_WHITE_BALANCE             = 3;
	FC2_HUE                       = 4;
	FC2_SATURATION                = 5;
	FC2_GAMMA                     = 6;
	FC2_IRIS                      = 7;
	FC2_FOCUS                     = 8;
	FC2_ZOOM                      = 9;
	FC2_PAN                       = 10;
	FC2_TILT                      = 11;
	FC2_SHUTTER                   = 12;
	FC2_GAIN                      = 13;
	FC2_TRIGGER_MODE              = 14;
	FC2_TRIGGER_DELAY             = 15;
	FC2_FRAME_RATE                = 16;
	FC2_TEMPERATURE               = 17;
	FC2_UNSPECIFIED_PROPERTY_TYPE = 18;

type
	TFC2Property = record
    PropertyType   : TFC2PropertyType;
		Present        : Bool;
		AbsControl     : Bool;
		OnePush        : Bool;
		OnOff          : Bool;
		AutoManualMode : Bool;
    ValueA         : DWord; // All but white balance blue
    ValueB         : DWord; // only for white balance blue
    AbsValue       : Single;
    Reserved       : array[1..8] of DWord;
  end;

// For convenience, trigger delay is the same structure
// used in a separate function along with trigger mode.
  TFC2TriggerDelay = TFC2Property;

type
  TFC2PropertyInfo = record
    PropertyType     : TFC2PropertyType;
		Present          : Bool;
		AutoSupported    : Bool;
		ManualSupported  : Bool;
		OnOffSupported   : Bool;
		OnePushSupported : Bool;
		AbsValSupported  : Bool;
		ReadOutSupported : Bool;
    Min              : DWord;
    Max              : DWord;
    AbsMin           : Single;
    AbsMax           : Single;
    Units            : TFC2String; //array[1..MAX_STRING_LENGTH] of Char;
    Reserved         : array[1..8] of DWord;
  end;

  TFC2PixelFormat = Integer;

const
	FC2_PIXEL_FORMAT_MONO8		   	= $80000000; // 8 bits of mono information.
	FC2_PIXEL_FORMAT_411YUV8	   	= $40000000; // YUV 4:1:1.
	FC2_PIXEL_FORMAT_422YUV8	  	= $20000000; // YUV 4:2:2.
	FC2_PIXEL_FORMAT_444YUV8	  	= $10000000; // YUV 4:4:4.
	FC2_PIXEL_FORMAT_RGB8		    	= $08000000; // R = G = B = 8 bits.
	FC2_PIXEL_FORMAT_MONO16	  		= $04000000; // 16 bits of mono information.
	FC2_PIXEL_FORMAT_RGB16	  		= $02000000; // R = G = B = 16 bits.
	FC2_PIXEL_FORMAT_S_MONO16	  	= $01000000; // 16 bits of signed mono information.
	FC2_PIXEL_FORMAT_S_RGB16	  	= $00800000; // R = G = B = 16 bits signed.
	FC2_PIXEL_FORMAT_RAW8		    	= $00400000; // 8 bit raw data output of sensor.
	FC2_PIXEL_FORMAT_RAW16		   	= $00200000; // 16 bit raw data output of sensor.
	FC2_PIXEL_FORMAT_MONO12		  	= $00100000; // 12 bits of mono information.
	FC2_PIXEL_FORMAT_RAW12	  		= $00080000; // 12 bit raw data output of sensor.
	FC2_PIXEL_FORMAT_BGR		    	= $80000008; // 24 bit BGR.
	FC2_PIXEL_FORMAT_BGRU		    	= $40000008; // 32 bit BGRU.
	FC2_PIXEL_FORMAT_RGB		    	= FC2_PIXEL_FORMAT_RGB8; // 24 bit RGB
	FC2_PIXEL_FORMAT_RGBU		    	= $40000002; // 32 bit RGBU
	FC2_PIXEL_FORMAT_BGR16			  = $02000001; // R = G = B = 16 bits.
	FC2_PIXEL_FORMAT_BGRU16			  = $02000002; // 64 bit BGRU.
	FC2_PIXEL_FORMAT_422YUV8_JPEG	= $40000001; // JPEG compressed stream.
	FC2_NUM_PIXEL_FORMATS	    		= 20;        //  Number of pixel formats
	FC2_UNSPECIFIED_PIXEL_FORMAT	= 0;         //  Unspecified pixel format.

type
  TFC2BayerTileFormat = Integer;

const
	FC2_BT_NONE = 0; // No bayer tile format.
	FC2_BT_RGGB = 1; // Red-Green-Green-Blue.
	FC2_BT_GRBG = 2; // Green-Red-Blue-Green.
	FC2_BT_GBRG = 3; // Green-Blue-Red-Green.
	FC2_BT_BGGR = 4; // Blue-Green-Green-Red.

type
	TFC2DriverType = Integer;

const
	FC2_DRIVER_1394_CAM       = 0; // PGRCam.sys
	FC2_DRIVER_1394_PRO       = 1; // PGR1394.sys
	FC2_DRIVER_1394_JUJU      = 2; // firewire_core
	FC2_DRIVER_1394_VIDEO1394 = 3; // video1394
	FC2_DRIVER_1394_RAW1394   = 4; // raw1394
	FC2_DRIVER_USB_NONE       = 5; // No usb driver used just BSD stack. (Linux only)
	FC2_DRIVER_USB_CAM        = 6; // PGRUsbCam.sys
	FC2_DRIVER_USB3_PRO       = 7; // PGRXHCI.sys
	FC2_DRIVER_GIGE_NONE      = 8; // no gige drivers used,MS/BSD stack.
	FC2_DRIVER_GIGE_FILTER    = 9; // PGRGigE.sys
	FC2_DRIVER_GIGE_PRO       = 10; // PGRGigEPro.sys
	FC2_DRIVER_GIGE_LWF       = 11; // PgrLwf.sys
	FC2_DRIVER_UNKNOWN        = -1; // Unknown driver type

type
  TFC2Image = record
    Rows        : DWord;
    Cols        : DWord;
    Stride      : DWord;
    Data        : PByte;
    DataSize    : DWord;
    RxDataSize  : DWord;
    Format      : TFC2PixelFormat;
    BayerFormat : TFC2BayerTileFormat;
    ImageImpl   : TFC2ImageImpl;
  end;

  TFC2BusSpeed = Integer;

const
	FC2_BUSSPEED_S100 = 0;           // 100Mbits/sec. */
	FC2_BUSSPEED_S200 = 1;           // 200Mbits/sec. */
	FC2_BUSSPEED_S400 = 2;           // 400Mbits/sec. */
	FC2_BUSSPEED_S480 = 3;           // 480Mbits/sec. Only for USB2 cameras. */
	FC2_BUSSPEED_S800 = 4;           // 800Mbits/sec. */
	FC2_BUSSPEED_S1600 = 5;          // 1600Mbits/sec. */
	FC2_BUSSPEED_S3200 = 6;          // 3200Mbits/sec. */
	FC2_BUSSPEED_S5000 = 7;          // 5000Mbits/sec. Only for USB3 cameras. */
	FC2_BUSSPEED_10BASE_T = 8;       // 10Base-T. Only for GigE cameras. */
	FC2_BUSSPEED_100BASE_T = 9;      // 100Base-T.  Only for GigE cameras.*/
	FC2_BUSSPEED_1000BASE_T = 10;    // 1000Base-T (Gigabit Ethernet).  Only for GigE cameras. */
	FC2_BUSSPEED_10000BASE_T = 11;   // 10000Base-T.  Only for GigE cameras. */
	FC2_BUSSPEED_S_FASTEST = 12;     // The fastest speed available. */
	FC2_BUSSPEED_ANY = 13;           // Any speed that is available. */
	FC2_BUSSPEED_SPEED_UNKNOWN = -1; // Unknown bus speed. */

type
  TFC2PCIeBusSpeed = Integer;

const
	FC2_PCIE_BUSSPEED_2_5     = 0;  // 2.5 Gb/s
	FC2_PCIE_BUSSPEED_5_0     = 1;  // 5.0 Gb/s */
  FC2_PCIE_BUSSPEED_UNKNOWN = -1; // ???

type
  TFC2ConfigROM = record
		NodeVendorId       : DWord;
		ChipIdHi           : DWord;
		ChipIdLo           : DWord;
		UnitSpecId         : DWord;
		UnitSWVer          : DWord;
		UnitSubSWVer       : DWord;
		VendorUniqueInfo_0 : DWord;
		VendorUniqueInfo_1 : DWord;
		VendorUniqueInfo_2 : DWord;
		VendorUniqueInfo_3 : DWord;
    PszKeyword         : TFC2String;
    Reserved           : array[1..16] of DWord;
  end;

  TFC2IpAddress = record
    Octets : array[1..4] of Byte;
  end;

	TFC2MACAddress = record
    Octets : array[1..6] of Byte;
  end;

  TFC2CameraInfo = record
    SerialNumber         : DWord;
    InterfaceType        : TFC2Interface;
		DriverType           : TFC2DriverType;
    IsColorCamera        : Bool;
    ModelName            : TFC2String;
    VendorName           : TFC2String;
    SensorInfo           : TFC2String;
    SensorResolution     : TFC2String;
		DriverName           : TFC2String;
		FirmwareVersion      : TFC2String;
		FirmwareBuildTime    : TFC2String;
    MaximumBusSpeed      : TFC2BusSpeed;
    PcieBusSpeed         : TFC2PCIeBusSpeed;
    BayerTileFormat      : TFC2BayerTileFormat;
    BusNumber            : Word;
		NodeNumber           : Word;
		IIDCVer              : DWord;
    ConfigRom            : TFC2ConfigROM;
		GigEMajorVersion     : DWord;
		GigEMinorVersion     : DWord;
    UserDefinedName      : TFC2String;
		XmlURL1              : TFC2String;
		XmlURL2              : TFC2String;
    MacAddress           : TFC2MacAddress;
    IPAddress            : TFC2IpAddress;
    SubnetMask           : TFC2IPAddress;
		DefaultGateway       : TFC2IPAddress;
    CcpStatus            : DWord;
		ApplicationIPAddress : DWord;
		ApplicationPort      : DWord;
    Reserved             : array[1..16] of DWord;
	end;

  TFC2BusEventCallBack = procedure(UserData:Pointer; SerialNumber:DWord); cdecl;

  TFC2ImageEventCallBack = procedure(var Image:TFC2Image; Data:Pointer); cdecl;
  PFC2ImageEventCallBack = ^TFC2ImageEventCallBack;

  TFC2AsyncCommandCallBack = procedure(Error:TFC2Error; Data:Pointer); cdecl;

	TFC2GigEStreamChannel = record
		NetworkInterfaceIndex : DWord;
		HostPort              : DWord;
		DoNotFragment         : Bool;
		PacketSize            : DWord;
		InterPacketDelay      : DWord;
		DestinationIP         : TFC2IPAddress;
		SourcePort            : DWord;
    Reserved              : array[1..8] of DWord;
  end;

	TFC2GigEImageSettingsInfo = record
		MaxWidth                  : DWord;
		MaxHeight                 : DWord;
		OffsetHStepSize           : DWord;
		OffsetVStepSize           : DWord;
		ImageHStepSize            : DWord;
		ImageVStepSize            : DWord;
		PixelFormatBitField       : DWord;
		VendorPixelFormatBitField : DWord;
    Reserved                  : array[1..16] of DWord;
  end;

	TFC2GigEImageSettings = record
    OffsetX     : DWord;
    OffsetY     : DWord;
    Width       : DWord;
    Height      : DWord;
    PixelFormat : TFC2PixelFormat;
    Reserved    : array[1..8] of DWord;
  end;

	TFC2AVIContext = Pointer;

  TFC2ImageStatisticsContext = Pointer;

	TFC2FrameRate = Integer;

const
	FC2_FRAMERATE_1_875 = 0;   // 1.875 fps. */
	FC2_FRAMERATE_3_75 = 1;    // 3.75 fps. */
	FC2_FRAMERATE_7_5 = 2;     // 7.5 fps. */
	FC2_FRAMERATE_15 = 3;      // 15 fps. */
	FC2_FRAMERATE_30 = 4;      // 30 fps. */
	FC2_FRAMERATE_60 = 5;      // 60 fps. */
	FC2_FRAMERATE_120 = 6;     // 120 fps. */
	FC2_FRAMERATE_240 = 7;     // 240 fps. */
	FC2_FRAMERATE_FORMAT7 = 8; // Custom frame rate for Format7 functionality. */
	FC2_NUM_FRAMERATES = 9;    // Number of possible camera frame rates. */

type
  TFC2TriggerModeInfo = record
		Present                  : Bool;
		ReadOutSupported         : Bool;
		OnOffSupported           : Bool;
		PolaritySupported        : Bool;
		ValueReadable            : Bool;
    SourceMask               : DWord;
		SoftwareTriggerSupported : Bool;
		ModeMask                 : DWord;
		Reserved                 : array[1..8] of DWord;
  end;

	TFC2TriggerMode = record
		OnOff     : Bool;
		Polarity  : DWord;
		Source    : DWord;
		Mode      : DWord;
    Parameter : DWord;
		Reserved  : array[1..8] of DWord;
  end;

  TFC2GrabMode = Integer;

const
  FC2_DROP_FRAMES           = 0;
  FC2_BUFFER_FRAMES         = 1;
  FC2_UNSPECIFIED_GRAB_MODE = 2;

type
  TFC2GrabTimeout = Integer;

const
  FC2_TIMEOUT_NONE = 0;
  FC2_TIMEOUT_INFINITE = -1;
  FC2_TIMEOUT_UNSPECIFIED = -2;

type
  TFC2BandwidthAllocation = Integer;

const
  FC2_BANDWIDTH_ALLOCATION_OFF = 0;
  FC2_BANDWIDTH_ALLOCATION_ON = 1;
  FC2_BANDWIDTH_ALLOCATION_UNSUPPORTED = 2;
  FC2_BANDWIDTH_ALLOCATION_UNSPECIFIED = 3;

type
  TFC2Config = record
    NumBuffers               : DWord;
    NumImageNotifications    : DWord;
    MinNumImageNotifications : DWord;
    GrabTimeout              : Integer;
    GrabMode	               : TFC2GrabMode;
    HighPerfRetrieveBuffer   : Bool;
    IsochBusSpeed	           : TFC2BusSpeed;
    AsyncBusSpeed	           : TFC2BusSpeed;
    BandwidthAllocation	     : TFC2BandwidthAllocation;
    RegisterTimeoutRetries   : DWord;
    RegisterTimeout	         : DWord;
    Reserved                 : array[1..16] of DWord;
  end;

	TFC2TimeStamp = record
	  Seconds      : Int64;
		MicroSeconds : DWord;
		CycleSeconds : DWord;
		CycleCount   : DWord;
		CycleOffset  : DWord;
		Reserved     : array[1..8] of DWord;
  end;

	TFC2StrobeInfo = record
    Source            : DWord;
		Present           : Bool;
		ReadOutSupported  : Bool;
		OnOffSupported    : Bool;
	  PolaritySupported : Bool;
    MinValue          : Single;
    MaxValue          : Single;
    Reserved          : array[1..8] of DWord;
  end;

	TFC2StrobeControl = record
    Source   : DWord;
		OnOff    : Bool;
		Polarity : DWord;
		Delay    : Single;
		Duration : Single;
    Reserved : array[1..8] of DWord;
  end;

	TFC2EmbeddedImageInfoProperty = record
    Available : Bool;
    OnOff     : Bool;
  end;

  TFC2EmbeddedImageInfo = record
    Timestamp     : TFC2EmbeddedImageInfoProperty;
    Gain          : TFC2EmbeddedImageInfoProperty;
    Shutter       : TFC2EmbeddedImageInfoProperty;
    Brightness    : TFC2EmbeddedImageInfoProperty;
    Exposure      : TFC2EmbeddedImageInfoProperty;
    WhiteBalance  : TFC2EmbeddedImageInfoProperty;
    FrameCounter  : TFC2EmbeddedImageInfoProperty;
    StrobePattern : TFC2EmbeddedImageInfoProperty;
    GPIOPinState  : TFC2EmbeddedImageInfoProperty;
    ROIPosition   : TFC2EmbeddedImageInfoProperty;
  end;

	TFC2ImageMetaData = record
		EmbeddedTimeStamp     : DWord;
		EmbeddedGain          : DWord;
		EmbeddedShutter       : DWord;
		EmbeddedBrightness    : DWord;
		EmbeddedExposure      : DWord;
		EmbeddedWhiteBalance  : DWord;
		EmbeddedFrameCounter  : DWord;
		EmbeddedStrobePattern : DWord;
		EmbeddedGPIOPinState  : DWord;
		EmbeddedROIPosition   : DWord;
		Reserved              : array[1..31] of DWord;
  end;

implementation

end.


	typedef enum _fc2GrabMode
	{
		FC2_DROP_FRAMES,
		FC2_BUFFER_FRAMES,
		FC2_UNSPECIFIED_GRAB_MODE,
		FC2_GRAB_MODE_FORCE_32BITS = FULL_32BIT_VALUE

	} fc2GrabMode;

	typedef enum _fc2GrabTimeout
	{
		FC2_TIMEOUT_NONE = 0,
		FC2_TIMEOUT_INFINITE = -1,
		FC2_TIMEOUT_UNSPECIFIED = -2,
		FC2_GRAB_TIMEOUT_FORCE_32BITS = FULL_32BIT_VALUE

	} fc2GrabTimeout;

	typedef enum _fc2BandwidthAllocation
	{
		FC2_BANDWIDTH_ALLOCATION_OFF = 0,
		FC2_BANDWIDTH_ALLOCATION_ON = 1,
		FC2_BANDWIDTH_ALLOCATION_UNSUPPORTED = 2,
		FC2_BANDWIDTH_ALLOCATION_UNSPECIFIED = 3,
		FC2_BANDWIDTH_ALLOCATION_FORCE_32BITS = FULL_32BIT_VALUE

	}fc2BandwidthAllocation;


	typedef enum _fc2VideoMode
	{
		FC2_VIDEOMODE_160x120YUV444 = ; // 160x120 YUV444. */
		FC2_VIDEOMODE_320x240YUV422 = ; // 320x240 YUV422. */
		FC2_VIDEOMODE_640x480YUV411 = ; // 640x480 YUV411. */
		FC2_VIDEOMODE_640x480YUV422 = ; // 640x480 YUV422. */
		FC2_VIDEOMODE_640x480RGB = ; // 640x480 24-bit RGB. */
		FC2_VIDEOMODE_640x480Y8 = ; // 640x480 8-bit. */
		FC2_VIDEOMODE_640x480Y16 = ; // 640x480 16-bit. */
		FC2_VIDEOMODE_800x600YUV422 = ; // 800x600 YUV422. */
		FC2_VIDEOMODE_800x600RGB = ; // 800x600 RGB. */
		FC2_VIDEOMODE_800x600Y8 = ; // 800x600 8-bit. */
		FC2_VIDEOMODE_800x600Y16 = ; // 800x600 16-bit. */
		FC2_VIDEOMODE_1024x768YUV422 = ; // 1024x768 YUV422. */
		FC2_VIDEOMODE_1024x768RGB = ; // 1024x768 RGB. */
		FC2_VIDEOMODE_1024x768Y8 = ; // 1024x768 8-bit. */
		FC2_VIDEOMODE_1024x768Y16 = ; // 1024x768 16-bit. */
		FC2_VIDEOMODE_1280x960YUV422 = ; // 1280x960 YUV422. */
		FC2_VIDEOMODE_1280x960RGB = ; // 1280x960 RGB. */
		FC2_VIDEOMODE_1280x960Y8 = ; // 1280x960 8-bit. */
		FC2_VIDEOMODE_1280x960Y16 = ; // 1280x960 16-bit. */
		FC2_VIDEOMODE_1600x1200YUV422 = ; // 1600x1200 YUV422. */
		FC2_VIDEOMODE_1600x1200RGB = ; // 1600x1200 RGB. */
		FC2_VIDEOMODE_1600x1200Y8 = ; // 1600x1200 8-bit. */
		FC2_VIDEOMODE_1600x1200Y16 = ; // 1600x1200 16-bit. */
		FC2_VIDEOMODE_FORMAT7 = ; // Custom video mode for Format7 functionality. */
		FC2_NUM_VIDEOMODES = ; // Number of possible video modes. */
		FC2_VIDEOMODE_FORCE_32BITS = FULL_32BIT_VALUE

	} fc2VideoMode;

	typedef enum _fc2Mode
	{
		FC2_MODE_0 = 0,
		FC2_MODE_1,
		FC2_MODE_2,
		FC2_MODE_3,
		FC2_MODE_4,
		FC2_MODE_5,
		FC2_MODE_6,
		FC2_MODE_7,
		FC2_MODE_8,
		FC2_MODE_9,
		FC2_MODE_10,
		FC2_MODE_11,
		FC2_MODE_12,
		FC2_MODE_13,
		FC2_MODE_14,
		FC2_MODE_15,
		FC2_MODE_16,
		FC2_MODE_17,
		FC2_MODE_18,
		FC2_MODE_19,
		FC2_MODE_20,
		FC2_MODE_21,
		FC2_MODE_22,
		FC2_MODE_23,
		FC2_MODE_24,
		FC2_MODE_25,
		FC2_MODE_26,
		FC2_MODE_27,
		FC2_MODE_28,
		FC2_MODE_29,
		FC2_MODE_30,
		FC2_MODE_31,
		FC2_NUM_MODES = ; // Number of modes */
		FC2_MODE_FORCE_32BITS = FULL_32BIT_VALUE

	} fc2Mode;


	typedef enum _fc2ColorProcessingAlgorithm
	{
		FC2_DEFAULT,
		FC2_NO_COLOR_PROCESSING,
		FC2_NEAREST_NEIGHBOR_FAST,
		FC2_EDGE_SENSING,
		FC2_HQ_LINEAR,
		FC2_RIGOROUS,
		FC2_IPP,
		FC2_DIRECTIONAL,
		FC2_COLOR_PROCESSING_ALGORITHM_FORCE_32BITS = FULL_32BIT_VALUE

	} fc2ColorProcessingAlgorithm;


	typedef enum _fc2ImageFileFormat
	{
		FC2_FROM_FILE_EXT = -1 = ; // Determine file format from file extension. */
		FC2_PGM = ; // Portable gray map. */
		FC2_PPM = ; // Portable pixmap. */
		FC2_BMP = ; // Bitmap. */
		FC2_JPEG = ; // JPEG. */
		FC2_JPEG2000 = ; // JPEG 2000. */
		FC2_TIFF = ; // Tagged image file format. */
		FC2_PNG = ; // Portable network graphics. */
		FC2_RAW = ; // Raw data. */
		FC2_IMAGE_FILE_FORMAT_FORCE_32BITS = FULL_32BIT_VALUE

	} fc2ImageFileFormat;

	typedef enum _fc2GigEPropertyType
	{
		FC2_HEARTBEAT,
		FC2_HEARTBEAT_TIMEOUT

	} fc2GigEPropertyType;

	typedef enum _fc2StatisticsChannel
	{
		FC2_STATISTICS_GREY,
		FC2_STATISTICS_RED,
		FC2_STATISTICS_GREEN,
		FC2_STATISTICS_BLUE,
		FC2_STATISTICS_HUE,
		FC2_STATISTICS_SATURATION,
		FC2_STATISTICS_LIGHTNESS,
		FC2_STATISTICS_FORCE_32BITS = FULL_32BIT_VALUE
	} fc2StatisticsChannel;


	typedef enum _fc2OSType
	{
		FC2_WINDOWS_X86,
		FC2_WINDOWS_X64,
		FC2_LINUX_X86,
		FC2_LINUX_X64,
		FC2_MAC,
		FC2_UNKNOWN_OS,
		FC2_OSTYPE_FORCE_32BITS = FULL_32BIT_VALUE
	} fc2OSType;

	typedef enum _fc2ByteOrder
	{
		FC2_BYTE_ORDER_LITTLE_ENDIAN,
		FC2_BYTE_ORDER_BIG_ENDIAN,
		FC2_BYTE_ORDER_FORCE_32BITS = FULL_32BIT_VALUE
	} fc2ByteOrder;

	//=============================================================================
	// Structures
	//=============================================================================

	//
	// Description:
	//	 An image. It is comparable to the Image class in the C++ library.
	//   The fields in this structure should be considered read only.
	//
	typedef struct _fc2SystemInfo
	{
		fc2OSType osType;
		char osDescription[ MAX_STRING_LENGTH];
		fc2ByteOrder byteOrder;
		size_t	sysMemSize;
		char cpuDescription[ MAX_STRING_LENGTH];
		size_t	numCpuCores;
		char driverList[ MAX_STRING_LENGTH];
		char libraryList[ MAX_STRING_LENGTH];
		char gpuDescription[ MAX_STRING_LENGTH];
		size_t screenWidth;
		size_t screenHeight;
		unsigned int reserved[16];

	} fc2SystemInfo;

	typedef struct _fc2Config
	{
		unsigned int numBuffers;
		unsigned int numImageNotifications;
		unsigned int minNumImageNotifications;
		int grabTimeout;
		fc2GrabMode grabMode;
		fc2BusSpeed isochBusSpeed;
		fc2BusSpeed asyncBusSpeed;
		fc2BandwidthAllocation bandwidthAllocation;
		unsigned int registerTimeoutRetries;
		unsigned int registerTimeout;
		unsigned int reserved[16];

	} fc2Config;

	typedef struct _fc2StrobeInfo
	{
		unsigned int source;
		BOOL present;
		BOOL readOutSupported;
		BOOL onOffSupported;
		BOOL polaritySupported;
		float minValue;
		float maxValue;
		unsigned int reserved[8];

	} fc2StrobeInfo;

	typedef struct _fc2StrobeControl
	{
		unsigned int source;
		BOOL onOff;
		unsigned int polarity;
		float delay;
		float duration;
		unsigned int reserved[8];

	} fc2StrobeControl;

	typedef struct _fc2Format7ImageSettings
	{
		fc2Mode mode;
		unsigned int offsetX;
		unsigned int offsetY;
		unsigned int width;
		unsigned int height;
		fc2PixelFormat pixelFormat;
		unsigned int reserved[8];

	} fc2Format7ImageSettings;

	typedef struct _fc2Format7Info
	{
		fc2Mode         mode;

		unsigned int maxWidth;
		unsigned int maxHeight;
		unsigned int offsetHStepSize;
		unsigned int offsetVStepSize;
		unsigned int imageHStepSize;
		unsigned int imageVStepSize;
		unsigned int pixelFormatBitField;
		unsigned int vendorPixelFormatBitField;
		unsigned int packetSize;
		unsigned int minPacketSize;
		unsigned int maxPacketSize;
		float percentage;
		unsigned int reserved[16];

	} fc2Format7Info;

	typedef struct _fc2Format7PacketInfo
	{
		unsigned int recommendedBytesPerPacket;
		unsigned int maxBytesPerPacket;
		unsigned int unitBytesPerPacket;
		unsigned int reserved[8];

	} fc2Format7PacketInfo;

	typedef struct _fc2GigEProperty
	{
		fc2GigEPropertyType propType;
		BOOL isReadable;
		BOOL isWritable;
		unsigned int min;
		unsigned int max;
		unsigned int value;

		unsigned int reserved[8];
	} fc2GigEProperty;

	typedef struct _fc2GigEStreamChannel
	{
		unsigned int networkInterfaceIndex;
		unsigned int hostPost;
		BOOL doNotFragment;
		unsigned int packetSize;
		unsigned int interPacketDelay;
		fc2IPAddress destinationIpAddress;
		unsigned int sourcePort;

		unsigned int reserved[8];
	} fc2GigEStreamChannel;

	typedef struct _fc2GigEConfig
	{
		/** Turn on/off packet resend functionality */
		BOOL enablePacketResend;
		/** The number of miliseconds to wait for each requested packet */
		unsigned int timeoutForPacketResend;
		/** The max number of packets that can be requested to be resend */
		unsigned int maxPacketsToResend;

		unsigned int reserved[8];
	} fc2GigEConfig;


	typedef struct _fc2TimeStamp
	{
		long long seconds;
		unsigned int microSeconds;
		unsigned int cycleSeconds;
		unsigned int cycleCount;
		unsigned int cycleOffset;
		unsigned int reserved[8];

	} fc2TimeStamp;

	typedef struct _fc2LUTData
	{
		BOOL supported;
		BOOL enabled;
		unsigned int numBanks;
		unsigned int numChannels;
		unsigned int inputBitDepth;
		unsigned int outputBitDepth;
		unsigned int numEntries;
		unsigned int reserved[8];

	} fc2LUTData;

	typedef struct _fc2PNGOption
	{
		BOOL interlaced;
		unsigned int compressionLevel;
		unsigned int reserved[16];

	} fc2PNGOption;

	typedef struct _fc2PPMOption
	{
		BOOL binaryFile;
		unsigned int reserved[16];

	} fc2PPMOption ;

	typedef struct _fc2PGMOption
	{
		BOOL binaryFile;
		unsigned int reserved[16];

	} fc2PGMOption;

	typedef enum _fc2TIFFCompressionMethod
	{
		FC2_TIFF_NONE = 1,
		FC2_TIFF_PACKBITS,
		FC2_TIFF_DEFLATE,
		FC2_TIFF_ADOBE_DEFLATE,
		FC2_TIFF_CCITTFAX3,
		FC2_TIFF_CCITTFAX4,
		FC2_TIFF_LZW,
		FC2_TIFF_JPEG,
	} fc2TIFFCompressionMethod;

	typedef struct _fc2TIFFOption
	{
		fc2TIFFCompressionMethod compression;
		unsigned int reserved[16];

	} fc2TIFFOption;

	typedef struct _fc2JPEGOption
	{
		BOOL progressive;
		unsigned int quality;
		unsigned int reserved[16];

	} fc2JPEGOption;

	typedef struct _fc2JPG2Option
	{
		unsigned int quality;
		unsigned int reserved[16];
	} fc2JPG2Option;

	typedef struct _fc2AVIOption
	{
		float frameRate;
		unsigned int reserved[256];

	} fc2AVIOption;

	typedef struct _fc2MJPGOption
	{
		float frameRate;
		unsigned int quality;
		unsigned int reserved[256];

	} fc2MJPGOption;


	typedef struct _fc2H264Option
	{
		float frameRate;
		unsigned int width;
		unsigned int height;
		unsigned int bitrate;
		unsigned int reserved[256];

	} fc2H264Option;



