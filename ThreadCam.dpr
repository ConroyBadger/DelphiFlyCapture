program ThreadCam;

uses
  Vcl.Forms,
  Main in 'Main.pas' {MainFrm},
  CameraU in 'CameraU.pas',
  FlyCapture2Defs_C in 'FlyCapture2Defs_C.pas',
  FlyCapture2_C in 'FlyCapture2_C.pas',
  FlyCapUtils in 'FlyCapUtils.pas',
  BmpUtils in 'BmpUtils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainFrm, MainFrm);
  Application.Run;
end.
