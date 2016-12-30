unit FlyCapture2_C;

interface

uses
  Windows, FlyCapture2Defs_C;

function fc2GetLibraryVersion(var Version:TFC2Version):TFC2Error; cdecl;

function fc2CreateContext(var Context:TFC2Context):TFC2Error; cdecl;

function fc2CreateGigEContext(var Context:TFC2Context):TFC2Error; cdecl;

function fc2DestroyContext(Context:TFC2Context):TFC2Error; cdecl;

function fc2GetNumOfCameras(Context:TFC2Context;
                            var Count:DWord):TFC2Error; cdecl;


function fc2GetCameraFromIndex(Context:TFC2Context; Index:DWord;
                               var GUID:TFC2PGRGuid):TFC2Error; cdecl;

// Register a callback function that will be called when the specified
// callback event occurs.
// enumCallback Pointer to function that will receive the callback.
// callbackType Type of callback to register for.
// pParameter Callback parameter to be passed to callback.
// pCallbackHandle Unique callback handle used for unregistering callback.
function fc2RegisterCallback(Context:TFC2Context; CallBack:TFC2BusEventCallback;
                             CallBackType:TFC2BusCallBackType; UserData:Pointer;
                             var Handle:TFC2CallBackHandle):TFC2Error; cdecl;

function fc2UnregisterCallback(Context:TFC2Context;
                               Handle:TFC2CallBackHandle):TFC2Error; cdecl;

function fc2ConvertImageTo(Format:TFC2PixelFormat;var ImageIn:TFC2Image;
                           var ImageOut:TFC2Image):TFC2Error; cdecl;

function fc2GetInterfaceTypeFromGuid(Context:TFC2Context;var GUID:TFC2PGRGuid;
                          			 InterfaceType:TFC2Interface):TFC2Error; cdecl;

function fc2GetCameraInfo(Context:TFC2Context;
                          var Info:TFC2CameraInfo):TFC2Error; cdecl;

function fc2Connect(Context:TFC2Context;var GUID:TFC2PGRGuid):TFC2Error; cdecl;

function fc2Disconnect(Context:TFC2Context):TFC2Error; cdecl;

function fc2StartCapture(Context:TFC2Context):TFC2Error; cdecl;

function fc2StartCaptureCallback(Context:TFC2Context;
                                 CallBack:TFC2ImageEventCallBack;
                                 UserData:Pointer):TFC2Error; cdecl;

function fc2StartSyncCapture(Cameras:DWord;
                             Contexts:PFC2Context):TFC2Error; cdecl;

function fc2StartSyncCaptureCallback(Cameras:DWord;Contexts:PFC2Context;
       CallBacks:PFC2ImageEventCallBack;Data:PCallBackData):TFC2Error; cdecl;

function fc2StopCapture(Context:TFC2Context):TFC2Error; cdecl;

function fc2GetNumStreamChannels(Context:TFC2Context;
                                 var Channels:DWord):TFC2Error; cdecl;

function fc2GetGigEStreamChannelInfo(Context:TFC2Context;
                     			 var Channel:TFC2GigEStreamChannel):TFC2Error; cdecl;

function fc2SetGigEStreamChannelInfo(Context:TFC2Context;
                     			 var Channel:TFC2GigEStreamChannel):TFC2Error; cdecl;

function fc2GetGigEImageSettingsInfo(Context:TFC2Context;
                              Info:TFC2GigEImageSettingsInfo):TFC2Error; cdecl;

function fc2GetGigEImageSettings(Context:TFC2Context;
              			 var ImageSettings:TFC2GigEImageSettings):TFC2Error; cdecl;

function fc2SetGigEImageSettings(Context:TFC2Context;
                      var ImageSettings:TFC2GigEImageSettings):TFC2Error; cdecl;

function fc2CreateImage(var Image:TFC2Image):TFC2Error; cdecl;

function fc2DestroyImage(var Image:TFC2Image):TFC2Error; cdecl;

function fc2RetrieveBuffer(Context:TFC2Context;var Image:TFC2Image):TFC2Error; cdecl;

// Sets the callback data to be used on completion of image transfer.
// To clear the current stored callback data, pass in NULL for both arguments
function fc2SetCallback(Context:TFC2Context;ImageEventCB:TFC2ImageEventCallback;
                        UserData:Pointer):TFC2Error; cdecl;

function fc2GetPropertyInfo(Context:TFC2Context;
                            var Info:TFC2PropertyInfo):TFC2Error; cdecl;

function fc2GetProperty(Context:TFC2Context;var Prop:TFC2Property):TFC2Error; cdecl;

function fc2SetProperty(Context:TFC2Context;var Prop:TFC2Property):TFC2Error; cdecl;

function fc2GetTriggerModeInfo(Context:TFC2Context;
                     var TriggerModeInfo:TFC2TriggerModeInfo):TFC2Error; cdecl;

function fc2GetTriggerMode(Context:TFC2Context;
                     var TriggerMode:TFC2TriggerMode):TFC2Error; cdecl;

function fc2SetTriggerMode(Context:TFC2Context;
                           var TriggerMode:TFC2TriggerMode):TFC2Error; cdecl;

function fc2GetConfiguration(Context:TFC2Context;var Config:TFC2Config):TFC2Error; cdecl;

function fc2SetConfiguration(Context:TFC2Context; var Config:TFC2Config):TFC2Error; cdecl;

function fc2GetStrobeInfo(Context:TFC2Context;
                          var StrobeInfo:TFC2StrobeInfo):TFC2Error; cdecl;

function fc2GetStrobe(Context:TFC2Context;
                      var StrobeControl:TFC2StrobeControl):TFC2Error; cdecl;

function fc2SetStrobe(Context:TFC2Context;
               				var StrobeControl:TFC2StrobeControl):TFC2Error; cdecl;

function fc2WriteRegister(Context:TFC2Context;Address,Value:DWord):TFC2Error; cdecl;

function fc2ReadRegister(Context:TFC2Context;Address:DWord;var Value:DWord):TFC2Error; cdecl;

function fc2WriteGVCPRegister(Context:TFC2Context;Address,Value:DWord):TFC2Error; cdecl;

function fc2ReadGVCPRegister(Context:TFC2Context;Address:DWord;var Value:DWord):TFC2Error; cdecl;

function fc2GetEmbeddedImageInfo(Context:TFC2Context;var Info:TFC2EmbeddedImageInfo):TFC2Error; cdecl;
function fc2SetEmbeddedImageInfo(Context:TFC2Context;var Info:TFC2EmbeddedImageInfo):TFC2Error; cdecl;

function fc2GetImageTimeStamp(var Image:TFC2Image):TFC2TimeStamp; cdecl;

implementation

const
  FlyCapture2_C_DLL = 'FlyCapture2_C.dll';
//  FlyCapture2_C_DLL = 'c:\FlyCapture2\Delphi\FlyTest\FlyCapture2_C.dll';

function fc2GetLibraryVersion; external FlyCapture2_C_DLL;
function fc2CreateContext; external FlyCapture2_C_DLL;
function fc2CreateGigEContext; external FlyCapture2_C_DLL;
function fc2GetNumOfCameras; external FlyCapture2_C_DLL;
function fc2DestroyContext; external FlyCapture2_C_DLL;
function fc2GetCameraFromIndex; external FlyCapture2_C_DLL;

function fc2RegisterCallback; external FlyCapture2_C_DLL;
function fc2UnregisterCallback; external FlyCapture2_C_DLL;

function fc2ConvertImageTo; external FlyCapture2_C_DLL;

function fc2GetInterfaceTypeFromGuid; external FlyCapture2_C_DLL;

function fc2GetCameraInfo; external FlyCapture2_C_DLL;

function fc2Connect; external FlyCapture2_C_DLL;
function fc2Disconnect; external FlyCapture2_C_DLL;

function fc2StartCapture; external FlyCapture2_C_DLL;

function fc2StartCaptureCallback; external FlyCapture2_C_DLL;

function fc2StartSyncCapture; external FlyCapture2_C_DLL;

function fc2StartSyncCaptureCallback; external FlyCapture2_C_DLL;

function fc2StopCapture; external FlyCapture2_C_DLL;

function fc2GetNumStreamChannels; external FlyCapture2_C_DLL;

function fc2GetGigEStreamChannelInfo; external FlyCapture2_C_DLL;

function fc2SetGigEStreamChannelInfo; external FlyCapture2_C_DLL;

function fc2GetGigEImageSettingsInfo; external FlyCapture2_C_DLL;

function fc2SetGigEImageSettings; external FlyCapture2_C_DLL;

function fc2GetGigEImageSettings; external FlyCapture2_C_DLL;

function fc2CreateImage; external FlyCapture2_C_DLL;

function fc2DestroyImage; external FlyCapture2_C_DLL;

function fc2RetrieveBuffer; external FlyCapture2_C_DLL;

function fc2SetCallback; external FlyCapture2_C_DLL;

function fc2GetPropertyInfo; external FlyCapture2_C_DLL;

function fc2GetProperty; external FlyCapture2_C_DLL;

function fc2SetProperty; external FlyCapture2_C_DLL;

function fc2GetTriggerModeInfo; external FlyCapture2_C_DLL;

function fc2GetTriggerMode; external FlyCapture2_C_DLL;

function fc2SetTriggerMode; external FlyCapture2_C_DLL;

function fc2GetConfiguration; external FlyCapture2_C_DLL;

function fc2SetConfiguration; external FlyCapture2_C_DLL;

function fc2GetStrobeInfo; external FlyCapture2_C_DLL;

function fc2GetStrobe; external FlyCapture2_C_DLL;

function fc2SetStrobe; external FlyCapture2_C_DLL;

function fc2WriteRegister; external FlyCapture2_C_DLL;

function fc2ReadRegister; external FlyCapture2_C_DLL;

function fc2WriteGVCPRegister; external FlyCapture2_C_DLL;

function fc2ReadGVCPRegister; external FlyCapture2_C_DLL;

function fc2GetEmbeddedImageInfo; external FlyCapture2_C_DLL;

function fc2SetEmbeddedImageInfo; external FlyCapture2_C_DLL;

function fc2GetImageTimeStamp; external FlyCapture2_C_DLL;

end.

	FLYCAPTURE2_C_API fc2Error fc2FireBusReset(fc2Context context,fc2PGRGuid* pGuid);
	FLYCAPTURE2_C_API fc2Error fc2IsCameraControlable(fc2Context context,fc2PGRGuid* pGuid,BOOL* pControlable);

	FLYCAPTURE2_C_API fc2Error fc2GetCameraFromIPAddress(fc2Context context,fc2IPAddress ipAddress,fc2PGRGuid* pGuid);

	FLYCAPTURE2_C_API fc2Error fc2GetCameraFromSerialNumber(fc2Context context,	unsigned int serialNumber,fc2PGRGuid* pGuid );

	FLYCAPTURE2_C_API fc2Error fc2GetCameraSerialNumberFromIndex(fc2Context context,
				unsigned int index,	unsigned int* pSerialNumber );

	FLYCAPTURE2_C_API fc2Error fc2GetNumOfDevices(fc2Context context,unsigned int* pNumDevices );

	FLYCAPTURE2_C_API fc2Error fc2GetDeviceFromIndex(fc2Context context,unsigned int index,fc2PGRGuid*     pGuid );

	FLYCAPTURE2_C_API fc2Error fc2RescanBus( fc2Context context);

	FLYCAPTURE2_C_API fc2Error fc2ForceIPAddressToCamera(fc2Context context,
				fc2MACAddress macAddress,fc2IPAddress ipAddress,
				fc2IPAddress subnetMask,fc2IPAddress defaultGateway );

	FLYCAPTURE2_C_API fc2Error fc2ForceAllIPAddressesAutomatically();

	FLYCAPTURE2_C_API fc2Error fc2ForceIPAddressAutomatically(unsigned int serialNumber);

	FLYCAPTURE2_C_API fc2Error fc2DiscoverGigECameras(fc2Context context,
				fc2CameraInfo* gigECameras,unsigned int* arraySize  );

	FLYCAPTURE2_C_API fc2Error fc2WriteRegister(fc2Context context,
				unsigned int address,	unsigned int value);

	FLYCAPTURE2_C_API fc2Error fc2WriteRegisterBroadcast(fc2Context context,
				unsigned int address,	unsigned int value);

	FLYCAPTURE2_C_API fc2Error fc2ReadRegister(fc2Context context,
				unsigned int address,	unsigned int* pValue );

	FLYCAPTURE2_C_API fc2Error
		fc2WriteRegisterBlock(
				fc2Context context,
				unsigned short addressHigh,
				unsigned int addressLow,
				const unsigned int* pBuffer,
				unsigned int length );

	FLYCAPTURE2_C_API fc2Error
		fc2ReadRegisterBlock(
				fc2Context context,
				unsigned short addressHigh,
				unsigned int addressLow,
				unsigned int* pBuffer,
				unsigned int length );



	/**
	 * Specify user allocated buffers to use as image data buffers.
	 *
	 * @param context The fc2Context to be used.
	 * @param ppMemBuffers Pointer to memory buffers to be written to. The
	 *                     size of the data should be equal to
	 *                     (size * numBuffers) or larger.
	 * @param size The size of each buffer (in bytes).
	 * @param nNumBuffers Number of buffers in the array.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2SetUserBuffers(
				fc2Context context,
				unsigned char* const ppMemBuffers,
				int size,
				int nNumBuffers );

	/**
	 * Get the configuration associated with the camera.
	 *
	 * @param context The fc2Context to be used.
	 * @param config Pointer to the configuration structure to be filled.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2GetConfiguration(
				fc2Context context,
				fc2Config* config );

	/**
	 * Set the configuration associated with the camera.
	 *
	 * @param context The fc2Context to be used.
	 * @param config Pointer to the configuration structure to be used.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2SetConfiguration(
				fc2Context context,
				fc2Config* config );


	/**
	 * Writes the settings for the specified property to the camera. The
	 * property type must be specified in the Property structure passed
	 * into the function in order for the function to succeed.
	 * The absControl flag controls whether the absolute or integer value
	 * is written to the camera.
	 *
	 * @param context The fc2Context to be used.
	 * @param prop Pointer to the Property structure to be used.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2SetPropertyBroadcast(
				fc2Context context,
				fc2Property* prop );

	/**
	 * Get the GPIO pin direction for the specified pin. This is not a
	 * required call when using the trigger or strobe functions as
	 * the pin direction is set automatically internally.
	 *
	 * @param context The fc2Context to be used.
	 * @param pin Pin to get the direction for.
	 * @param pDirection Direction of the pin. 0 for input, 1 for output.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2GetGPIOPinDirection(
				fc2Context context,
				unsigned int pin,
				unsigned int* pDirection );

	/**
	 * Set the GPIO pin direction for the specified pin. This is useful if
	 * there is a need to set the pin into an input pin (i.e. to read the
	 * voltage) off the pin without setting it as a trigger source. This
	 * is not a required call when using the trigger or strobe functions as
	 * the pin direction is set automatically internally.
	 *
	 * @param context The fc2Context to be used.
	 * @param pin Pin to get the direction for.
	 * @param direction Direction of the pin. 0 for input, 1 for output.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2SetGPIOPinDirection(
				fc2Context context,
				unsigned int pin,
				unsigned int direction);

	/**
	 * Set the GPIO pin direction for the specified pin. This is useful if
	 * there is a need to set the pin into an input pin (i.e. to read the
	 * voltage) off the pin without setting it as a trigger source. This
	 * is not a required call when using the trigger or strobe functions as
	 * the pin direction is set automatically internally.
	 *
	 * @param context The fc2Context to be used.
	 * @param pin Pin to get the direction for.
	 * @param direction Direction of the pin. 0 for input, 1 for output.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2SetGPIOPinDirectionBroadcast(
				fc2Context context,
				unsigned int pin,
				unsigned int direction);


	/**
	 * Set the specified trigger settings to the camera.
	 *
	 * @param context The fc2Context to be used.
	 * @param triggerMode Structure providing trigger mode settings.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2SetTriggerModeBroadcast(
				fc2Context context,
				fc2TriggerMode* triggerMode );

	/**
	 *
	 *
	 * @param context The fc2Context to be used.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2FireSoftwareTrigger(
				fc2Context context );

	/**
	 * Fire the software trigger according to the DCAM specifications.
	 *
	 * @param context The fc2Context to be used.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2FireSoftwareTriggerBroadcast(
				fc2Context context );

	/**
	 * Retrieve trigger delay information from the camera.
	 *
	 * @param context The fc2Context to be used.
	 * @param triggerDelayInfo Structure to receive trigger delay information.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2GetTriggerDelayInfo(
				fc2Context context,
				fc2TriggerDelayInfo* triggerDelayInfo );

	/**
	 * Retrieve current trigger delay settings from the camera.
	 *
	 * @param context The fc2Context to be used.
	 * @param triggerDelay Structure to receive trigger delay settings.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2GetTriggerDelay(
				fc2Context context,
				fc2TriggerDelay* triggerDelay );

	/**
	 * Set the specified trigger delay settings to the camera.
	 *
	 * @param context The fc2Context to be used.
	 * @param triggerDelay Structure providing trigger delay settings.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2SetTriggerDelay(
				fc2Context context,
				fc2TriggerDelay* triggerDelay );

	/**
	 * Set the specified trigger delay settings to the camera.
	 *
	 * @param context The fc2Context to be used.
	 * @param triggerDelay Structure providing trigger delay settings.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2SetTriggerDelayBroadcast(
				fc2Context context,
				fc2TriggerDelay* triggerDelay );

	/**
	 * Retrieve strobe information from the camera.
	 *
	 * @param context The fc2Context to be used.
	 * @param strobeInfo Structure to receive strobe information.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2GetStrobeInfo(
				fc2Context context,
				fc2StrobeInfo* strobeInfo );

	/**
	 * Retrieve current strobe settings from the camera. The strobe pin
	 * must be specified in the structure before being passed in to
	 * the function.
	 *
	 * @param context The fc2Context to be used.
	 * @param strobeControl Structure to receive strobe settings.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2GetStrobe(
				fc2Context context,
				fc2StrobeControl* strobeControl );

	/**
	 * Set current strobe settings to the camera. The strobe pin
	 * must be specified in the structure before being passed in to
	 * the function.
	 *
	 * @param context The fc2Context to be used.
	 * @param strobeControl Structure providing strobe settings.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2SetStrobe(
				fc2Context context,
				fc2StrobeControl* strobeControl );

	/**
	 * Set current strobe settings to the camera. The strobe pin
	 * must be specified in the structure before being passed in to
	 * the function.
	 *
	 * @param context The fc2Context to be used.
	 * @param strobeControl Structure providing strobe settings.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2SetStrobeBroadcast(
				fc2Context context,
				fc2StrobeControl* strobeControl );

	/**
	 * Query the camera to determine if the specified video mode and
	 * frame rate is supported.
	 *
	 * @param context The fc2Context to be used.
	 * @param videoMode Video mode to check.
	 * @param frameRate Frame rate to check.
	 * @param pSupported Whether the video mode and frame rate is supported.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2GetVideoModeAndFrameRateInfo(
				fc2Context context,
				fc2VideoMode videoMode,
				fc2FrameRate frameRate,
				BOOL* pSupported);

	/**
	 * Get the current video mode and frame rate from the camera. If
	 * the camera is in Format7, the video mode will be VIDEOMODE_FORMAT7
	 * and the frame rate will be FRAMERATE_FORMAT7.
	 *
	 * @param context The fc2Context to be used.
	 * @param videoMode Current video mode.
	 * @param frameRate Current frame rate.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2GetVideoModeAndFrameRate(
				fc2Context context,
				fc2VideoMode* videoMode,
				fc2FrameRate* frameRate );

	/**
	 * Set the specified video mode and frame rate to the camera. It is
	 * not possible to set the camera to VIDEOMODE_FORMAT7 or
	 * FRAMERATE_FORMAT7. Use the Format7 functions to set the camera
	 * into Format7.
	 *
	 * @param context The fc2Context to be used.
	 * @param videoMode Video mode to set to camera.
	 * @param frameRate Frame rate to set to camera.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2SetVideoModeAndFrameRate(
				fc2Context context,
				fc2VideoMode videoMode,
				fc2FrameRate frameRate );

	/**
	 * Retrieve the availability of Format7 custom image mode and the
	 * camera capabilities for the specified Format7 mode. The mode must
	 * be specified in the Format7Info structure in order for the
	 * function to succeed.
	 *
	 * @param context The fc2Context to be used.
	 * @param info Structure to be filled with the capabilities of the specified
	 *             mode and the current state in the specified mode.
	 * @param pSupported Whether the specified mode is supported.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2GetFormat7Info(
				fc2Context context,
				fc2Format7Info* info,
				BOOL* pSupported );

	/**
	 * Validates Format7ImageSettings structure and returns valid packet
	 * size information if the image settings are valid. The current
	 * image settings are cached while validation is taking place. The
	 * cached settings are restored when validation is complete.
	 *
	 * @param context The fc2Context to be used.
	 * @param imageSettings Structure containing the image settings.
	 * @param settingsAreValid Whether the settings are valid.
	 * @param packetInfo Packet size information that can be used to
	 *                   determine a valid packet size.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2ValidateFormat7Settings(
				fc2Context context,
				fc2Format7ImageSettings* imageSettings,
				BOOL* settingsAreValid,
				fc2Format7PacketInfo* packetInfo );

	/**
	 * Get the current Format7 configuration from the camera. This call
	 * will only succeed if the camera is already in Format7.
	 *
	 * @param context The fc2Context to be used.
	 * @param imageSettings Current image settings.
	 * @param packetSize Current packet size.
	 * @param percentage Current packet size as a percentage.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2GetFormat7Configuration(
				fc2Context context,
				fc2Format7ImageSettings* imageSettings,
				unsigned int* packetSize,
				float* percentage );

	/**
	 * Set the current Format7 configuration to the camera.
	 *
	 * @param context The fc2Context to be used.
	 * @param imageSettings Image settings to be written to the camera.
	 * @param packetSize Packet size to be written to the camera.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2SetFormat7ConfigurationPacket(
				fc2Context context,
				fc2Format7ImageSettings* imageSettings,
				unsigned int packetSize );

	/**
	 * Set the current Format7 configuration to the camera.
	 *
	 * @param context The fc2Context to be used.
	 * @param imageSettings Image settings to be written to the camera.
	 * @param percentSpeed Packet size as a percentage to be written to the camera.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2SetFormat7Configuration(
				fc2Context context,
				fc2Format7ImageSettings* imageSettings,
				float percentSpeed );

	/**
	 * Write a GVCP register.
	 *
	 * @param context The fc2Context to be used.
	 * @param address GVCP address to be written to.
	 * @param value The value to be written.
	 *
	 * @return An Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2WriteGVCPRegister(
				fc2Context context,
				unsigned int address,
				unsigned int value);

	/**
	 * Write a GVCP register with broadcast
	 *
	 * @param context The fc2Context to be used.
	 * @param address GVCP address to be written to.
	 * @param value The value to be written.
	 *
	 * @return An Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2WriteGVCPRegisterBroadcast(
				fc2Context context,
				unsigned int address,
				unsigned int value);

	/**
	 * Read a GVCP register.
	 *
	 * @param context The fc2Context to be used.
	 * @param address GVCP address to be read from.
	 * @param pValue The value that is read.
	 *
	 * @return An Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2ReadGVCPRegister(
				fc2Context context,
				unsigned int address,
				unsigned int* pValue );

	/**
	 * Write a GVCP register block.
	 *
	 * @param context The fc2Context to be used.
	 * @param address GVCP address to be write to.
	 * @param pBuffer Array containing data to be written.
	 * @param length Size of array, in quadlets.
	 *
	 * @return An Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2WriteGVCPRegisterBlock(
				fc2Context context,
				unsigned int address,
				const unsigned int* pBuffer,
				unsigned int length );

	/**
	 * Read a GVCP register block.
	 *
	 * @param context The fc2Context to be used.
	 * @param address GVCP address to be read from.
	 * @param pBuffer Array containing data to be written.
	 * @param length Size of array, in quadlets.
	 *
	 * @return An Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2ReadGVCPRegisterBlock(
				fc2Context context,
				unsigned int address,
				unsigned int* pBuffer,
				unsigned int length );

	/**
	 * Write a GVCP memory block.
	 *
	 * @param context The fc2Context to be used.
	 * @param address GVCP address to be write to.
	 * @param pBuffer Array containing data to be written.
	 * @param length Size of array, in quadlets.
	 *
	 * @return An Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2WriteGVCPMemory(
				fc2Context context,
				unsigned int address,
				const unsigned char* pBuffer,
				unsigned int length );

	/**
	 * Read a GVCP memory block.
	 *
	 * @param context The fc2Context to be used.
	 * @param address GVCP address to be read from.
	 * @param pBuffer Array containing data to be written.
	 * @param length Size of array, in quadlets.
	 *
	 * @return An Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2ReadGVCPMemory(
				fc2Context context,
				unsigned int address,
				unsigned char* pBuffer,
				unsigned int length );

	/**
	 * Get the specified GigEProperty. The GigEPropertyType field must
	 * be set in order for this function to succeed.
	 *
	 * @param context The fc2Context to be used.
	 * @param pGigEProp The GigE property to get.
	 *
	 * @return An Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2GetGigEProperty(
				fc2Context context,
				fc2GigEProperty* pGigEProp );

	/**
	 * Set the specified GigEProperty. The GigEPropertyType field must
	 * be set in order for this function to succeed.
	 *
	 * @param context The fc2Context to be used.
	 * @param pGigEProp The GigE property to set.
	 *
	 * @return An Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2SetGigEProperty(
				fc2Context context,
				const fc2GigEProperty* pGigEProp );

	FLYCAPTURE2_C_API fc2Error
		fc2QueryGigEImagingMode(
				fc2Context context,
				fc2Mode mode,
				BOOL* isSupported );

	FLYCAPTURE2_C_API fc2Error
		fc2GetGigEImagingMode(
				fc2Context context,
				fc2Mode* mode );

	FLYCAPTURE2_C_API fc2Error
		fc2SetGigEImagingMode(
				fc2Context context,
				fc2Mode mode );


	FLYCAPTURE2_C_API fc2Error
		fc2GetGigEConfig(
				fc2Context context,
				fc2GigEConfig* pConfig );

	FLYCAPTURE2_C_API fc2Error
		fc2SetGigEConfig(
				fc2Context context,
				const fc2GigEConfig* pConfig );

	FLYCAPTURE2_C_API fc2Error
		fc2GetGigEImageBinningSettings(
				fc2Context context,
				unsigned int* horzBinnningValue,
				unsigned int* vertBinnningValue );

	FLYCAPTURE2_C_API fc2Error
		fc2SetGigEImageBinningSettings(
				fc2Context context,
				unsigned int horzBinnningValue,
				unsigned int vertBinnningValue );

	/**
	 * Query if LUT support is available on the camera. Note that some cameras
	 * may report support for the LUT and return an inputBitDepth of 0. In these
	 * cases use log2(numEntries) for the inputBitDepth.
	 *
	 * @param context The fc2Context to be used.
	 * @param pData The LUT structure to be filled.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2GetLUTInfo(
				fc2Context context,
				fc2LUTData* pData );

	/**
	 * Query the read/write status of a single LUT bank.
	 *
	 * @param context The fc2Context to be used.
	 * @param bank The bank to query.
	 * @param pReadSupported Whether reading from the bank is supported.
	 * @param pWriteSupported Whether writing to the bank is supported.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2GetLUTBankInfo(
				fc2Context context,
				unsigned int bank,
				BOOL* pReadSupported,
				BOOL* pWriteSupported );

	/**
	 * Get the LUT bank that is currently being used. For cameras with
	 * PGR LUT, the active bank is always 0.
	 *
	 * @param context The fc2Context to be used.
	 * @param pActiveBank The currently active bank.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2GetActiveLUTBank(
				fc2Context context,
				unsigned int* pActiveBank );

	/**
	 * Set the LUT bank that will be used.
	 *
	 * @param context The fc2Context to be used.
	 * @param activeBank The bank to be set as active.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2SetActiveLUTBank(
				fc2Context context,
				unsigned int activeBank );

	/**
	 * Enable or disable LUT functionality on the camera.
	 *
	 * @param context The fc2Context to be used.
	 * @param on Whether to enable or disable LUT.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2EnableLUT(
				fc2Context context,
				BOOL on );

	/**
	 * Get the LUT channel settings from the camera.
	 *
	 * @param context The fc2Context to be used.
	 * @param bank Bank to retrieve.
	 * @param channel Channel to retrieve.
	 * @param sizeEntries Number of entries in LUT table to read.
	 * @param pEntries Array to store LUT entries.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2GetLUTChannel(
				fc2Context context,
				unsigned int bank,
				unsigned int channel,
				unsigned int sizeEntries,
				unsigned int* pEntries );

	/**
	 * Set the LUT channel settings to the camera.
	 *
	 * @param context The fc2Context to be used.
	 * @param bank Bank to set.
	 * @param channel Channel to set.
	 * @param sizeEntries Number of entries in LUT table to write. This must be the
	 *					  same size as numEntries returned by GetLutInfo().
	 * @param pEntries Array containing LUT entries to write.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2SetLUTChannel(
				fc2Context context,
				unsigned int bank,
				unsigned int channel,
				unsigned int sizeEntries,
				unsigned int* pEntries );

	/**
	 * Retrieve the current memory channel from the camera.
	 *
	 * @param context The fc2Context to be used.
	 * @param pCurrentChannel Current memory channel.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2GetMemoryChannel(
				fc2Context context,
				unsigned int* pCurrentChannel );

	/**
	 * Save the current settings to the specfied current memory channel.
	 *
	 * @param context The fc2Context to be used.
	 * @param channel Memory channel to save to.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2SaveToMemoryChannel(
				fc2Context context,
				unsigned int channel );

	/**
	 * Restore the specfied current memory channel.
	 *
	 * @param context The fc2Context to be used.
	 * @param channel Memory channel to restore from.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2RestoreFromMemoryChannel(
				fc2Context context,
				unsigned int channel );

	/**
	 * Query the camera for memory channel support. If the number of
	 * channels is 0, then memory channel support is not available.
	 *
	 * @param context The fc2Context to be used.
	 * @param pNumChannels Number of memory channels supported.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2GetMemoryChannelInfo(
				fc2Context context,
				unsigned int* pNumChannels );

	/**
	 * Returns a text representation of the register value.
	 *
	 * @param registerVal The register value to query.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API const char*
		fc2GetRegisterString(
				unsigned int registerVal);
	/**
	 * Set the default color processing algorithm.  This method will be
	 * used for any image with the DEFAULT algorithm set. The method used
	 * is determined at the time of the Convert() call, therefore the most
	 * recent execution of this function will take precedence. The default
	 * setting is shared within the current process.
	 *
	 * @param defaultMethod The color processing algorithm to set.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2SetDefaultColorProcessing(
				fc2ColorProcessingAlgorithm defaultMethod );

	/**
	 * Get the default color processing algorithm.
	 *
	 * @param pDefaultMethod The default color processing algorithm.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2GetDefaultColorProcessing(
				fc2ColorProcessingAlgorithm* pDefaultMethod );

	/**
	 * Set the default output pixel format. This format will be used for any
	 * call to Convert() that does not specify an output format. The format
	 * used will be determined at the time of the Convert() call, therefore
	 * the most recent execution of this function will take precedence.
	 * The default is shared within the current process.
	 *
	 * @param format The output pixel format to set.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2SetDefaultOutputFormat(
				fc2PixelFormat format );

	/**
	 * Get the default output pixel format.
	 *
	 * @param pFormat The default pixel format.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2GetDefaultOutputFormat(
				fc2PixelFormat* pFormat );

	/**
	 * Calculate the bits per pixel for the specified pixel format.
	 *
	 * @param format The pixel format.
	 * @param pBitsPerPixel The bits per pixel.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2DetermineBitsPerPixel(
				fc2PixelFormat format,
				unsigned int* pBitsPerPixel );

	/**
	 * Save the image to the specified file name with the file format
	 * specified.
	 *
	 * @param pImage The fc2Image to be used.
	 * @param pFilename Filename to save image with.
	 * @param format File format to save in.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2SaveImage(
				fc2Image* pImage,
				const char* pFilename,
				fc2ImageFileFormat format );

	/**
	 * Save the image to the specified file name with the file format
	 * specified.
	 *
	 * @param pImage The fc2Image to be used.
	 * @param pFilename Filename to save image with.
	 * @param format File format to save in.
	 * @param pOption Options for saving image.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2SaveImageWithOption(
				fc2Image* pImage,
				const char* pFilename,
				fc2ImageFileFormat format,
				void* pOption );

	/**
	 *
	 *
	 * @param pImageIn
	 * @param pImageOut
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2ConvertImage(
				fc2Image* pImageIn,
				fc2Image* pImageOut );

	/**
	 * Converts the current image buffer to the specified output format and
	 * stores the result in the specified image. The destination image
	 * does not need to be configured in any way before the call is made.
	 *
	 * @param format Output format of the converted image.
	 * @param pImageIn Input image.
	 * @param pImageOut Output image.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2ConvertImageTo(
				fc2PixelFormat format,
				fc2Image* pImageIn,
				fc2Image* pImageOut );

	/**
	 * Get a pointer to the data associated with the image. This function
	 * is considered unsafe. The pointer returned could be invalidated if
	 * the buffer is resized or released. The pointer may also be
	 * invalidated if the Image object is passed to fc2RetrieveBuffer().
	 *
	 * @param pImage The fc2Image to be used.
	 * @param ppData A pointer to the image data.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2GetImageData(
				fc2Image* pImage,
				unsigned char** ppData);

	/**
	 * Set the data of the Image object.
	 * Ownership of the image buffer is not transferred to the Image object.
	 * It is the user's responsibility to delete the buffer when it is
	 * no longer in use.
	 *
	 * @param pImage The fc2Image to be used.
	 * @param pData Pointer to the image buffer.
	 * @param dataSize Size of the image buffer.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2SetImageData(
				fc2Image* pImage,
				const unsigned char* pData,
				unsigned int dataSize);

	/**
	 * Sets the dimensions of the image object.
	 *
	 * @param pImage The fc2Image to be used.
	 * @param rows Number of rows to set.
	 * @param cols Number of cols to set.
	 * @param stride Stride to set.
	 * @param pixelFormat Pixel format to set.
	 * @param bayerFormat Bayer tile format to set.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2SetImageDimensions(
				fc2Image* pImage,
				unsigned int rows,
				unsigned int cols,
				unsigned int stride,
				fc2PixelFormat pixelFormat,
				fc2BayerTileFormat bayerFormat);

	/**
	 * Calculate statistics associated with the image. In order to collect
	 * statistics for a particular channel, the enabled flag for the
	 * channel must be set to true. Statistics can only be collected for
	 * images in Mono8, Mono16, RGB, RGBU, BGR and BGRU.
	 *
	 * @param pImage The fc2Image to be used.
	 * @param pImageStatisticsContext The fc2ImageStatisticsContext to hold the
	 *                                statistics.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2CalculateImageStatistics(
				fc2Image* pImage,
				fc2ImageStatisticsContext* pImageStatisticsContext );

	/**
	 * Create a statistics context.
	 *
	 * @param pImageStatisticsContext A statistics context.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2CreateImageStatistics(
				fc2ImageStatisticsContext* pImageStatisticsContext );

	/**
	 * Destroy a statistics context.
	 *
	 * @param imageStatisticsContext A statistics context.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2DestroyImageStatistics(
				fc2ImageStatisticsContext imageStatisticsContext );

	/**
	 * Get the status of a statistics channel.
	 *
	 * @param imageStatisticsContext A statistics context.
	 * @param channel The statistics channel.
	 * @param pEnabled Whether the channel is enabled.
	 *
	 * @see SetChannelStatus()
	 *
	 * @return An Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API const fc2Error
		fc2GetChannelStatus(
				fc2ImageStatisticsContext imageStatisticsContext,
				fc2StatisticsChannel channel,
				BOOL* pEnabled );

	/**
	 * Set the status of a statistics channel.
	 *
	 * @param imageStatisticsContext A statistics context.
	 * @param channel The statistics channel.
	 * @param enabled Whether the channel should be enabled.
	 *
	 * @see GetChannelStatus()
	 *
	 * @return An Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2SetChannelStatus(
				fc2ImageStatisticsContext imageStatisticsContext,
				fc2StatisticsChannel channel,
				BOOL enabled );

	/**
	 * Get all statistics for the image.
	 *
	 * @param imageStatisticsContext The statistics context.
	 * @param channel The statistics channel.
	 * @param pRangeMin The minimum possible value.
	 * @param pRangeMax The maximum possible value.
	 * @param pPixelValueMin The minimum pixel value.
	 * @param pPixelValueMax The maximum pixel value.
	 * @param pNumPixelValues The number of unique pixel values.
	 * @param pPixelValueMean The mean of the image.
	 * @param ppHistogram Pointer to an array containing the histogram.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2GetImageStatistics(
				fc2ImageStatisticsContext imageStatisticsContext,
				fc2StatisticsChannel channel,
				unsigned int* pRangeMin,
				unsigned int* pRangeMax,
				unsigned int* pPixelValueMin,
				unsigned int* pPixelValueMax,
				unsigned int* pNumPixelValues,
				float* pPixelValueMean,
				int** ppHistogram );

	/**
	 * Create a AVI context.
	 *
	 * @param pAVIContext A AVI context.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2CreateAVI(
				fc2AVIContext* pAVIContext );

	/**
	 * Open an AVI file in preparation for writing Images to disk.
	 * The size of AVI files is limited to 2GB. The filenames are
	 * automatically generated using the filename specified.
	 *
	 * @param AVIContext The AVI context to use.
	 * @param pFileName The filename of the AVI file.
	 * @param pOption Options to apply to the AVI file.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2AVIOpen(
				fc2AVIContext AVIContext,
				const char*  pFileName,
				fc2AVIOption* pOption );

	/**
	 * Open an MJPEG file in preparation for writing Images to disk.
	 * The size of AVI files is limited to 2GB. The filenames are
	 * automatically generated using the filename specified.
	 *
	 * @param AVIContext The AVI context to use.
	 * @param pFileName The filename of the AVI file.
	 * @param pOption Options to apply to the AVI file.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2MJPGOpen(
				fc2AVIContext AVIContext,
				const char*  pFileName,
				fc2MJPGOption* pOption );

	/**
	 * Open an H.264 file in preparation for writing Images to disk.
	 * The size of AVI files is limited to 2GB. The filenames are
	 * automatically generated using the filename specified.
	 *
	 * @param AVIContext The AVI context to use.
	 * @param pFileName The filename of the AVI file.
	 * @param pOption Options to apply to the AVI file.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2H264Open(
				fc2AVIContext AVIContext,
				const char*  pFileName,
				fc2H264Option* pOption );

	/**
	 * Append an image to the AVI file.
	 *
	 * @param AVIContext The AVI context to use.
	 * @param pImage The image to append.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2AVIAppend(
				fc2AVIContext AVIContext,
				fc2Image* pImage );

	/**
	 * Close the AVI file.
	 *
	 * @param AVIContext The AVI context to use.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2AVIClose(
				fc2AVIContext AVIContext );

	/**
	 * Destroy a AVI context.
	 *
	 * @param AVIContext A AVI context.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2DestroyAVI(
				fc2AVIContext AVIContext );

	/**
	 * Get system information.
	 *
	 * @param pSystemInfo Structure to receive system information.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2GetSystemInfo( fc2SystemInfo* pSystemInfo);

	/**
	 * Get library version.
	 *
	 * @param pVersion Structure to receive the library version.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2GetLibraryVersion( fc2Version* pVersion);

	/**
	 * Launch a URL in the system default browser.
	 *
	 * @param pAddress URL to open in browser.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2LaunchBrowser( const char* pAddress);

	/**
	 * Open a CHM file in the system default CHM viewer.
	 *
	 * @param pFileName Filename of CHM file to open.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2LaunchHelp( const char* pFileName);

	/**
	 * Execute a command in the terminal. This is a blocking call that
	 * will return when the command completes.
	 *
	 * @param pCommand Command to execute.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2LaunchCommand( const char* pCommand);

	/**
	 * Execute a command in the terminal. This is a non-blocking call that
	 * will return immediately. The return value of the command can be
	 * retrieved in the callback.
	 *
	 * @param pCommand Command to execute.
	 * @param pCallback Callback to fire when command is complete.
	 * @param pUserData Data pointer to pass to callback.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2LaunchCommandAsync(
				const char* pCommand,
				fc2AsyncCommandCallback pCallback,
				void* pUserData );

	/**
	 * Get a string representation of an error.
	 *
	 * @param error Error to be parsed.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API const char*
		fc2ErrorToDescription(
				fc2Error error);

	/**
	 * Get cycle time from camera
	 *
	 * @param Timestamp struct.
	 *
	 * @return A fc2Error indicating the success or failure of the function.
	 */
	FLYCAPTURE2_C_API fc2Error
		fc2GetCycleTime( fc2Context context, fc2TimeStamp* pTimeStamp );

#ifdef __cplusplus
};
#endif

#endif // PGR_FC2_FLYCAPTURE2_C_H

