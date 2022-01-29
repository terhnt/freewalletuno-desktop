; FreeWalletUno.iss
;
; Config file for creating a windows installer file for tbe
;


[Setup]
AppName=FreeWalletUno
AppVersion=0.9.2
DefaultDirName={pf}\FreeWalletUno
DefaultGroupName=FreeWalletUno
UninstallDisplayIcon={app}\FreeWalletUno.exe
Compression=lzma2
SolidCompression=yes
OutputDir=C:\
OutputBaseFilename=FreeWalletUno

; "ArchitecturesInstallIn64BitMode=x64" requests that the install be
; done in "64-bit mode" on x64, meaning it should use the native
; 64-bit Program Files directory and the 64-bit view of the registry.
; On all other architectures it will install in "32-bit mode".
ArchitecturesInstallIn64BitMode=x64

[Registry]
; Add support for unobtanium: urls
Root: HKCR; Subkey: "unobtanium"; ValueType: "string"; ValueData: "URL:unobtanium Protocol"; Flags: uninsdeletekey
Root: HKCR; Subkey: "unobtanium"; ValueType: "string"; ValueName: "URL Protocol"; ValueData: ""
Root: HKCR; Subkey: "unobtanium\DefaultIcon"; ValueType: "string"; ValueData: "{app}\FreeWalletUno.exe,0"
Root: HKCR; Subkey: "unobtanium\shell\open\command"; ValueType: "string"; ValueData: """{app}\FreeWalletUno.exe"" ""%1"""
; Add support for unoparty: urls
Root: HKCR; Subkey: "unoparty"; ValueType: "string"; ValueData: "URL:unoparty Protocol"; Flags: uninsdeletekey
Root: HKCR; Subkey: "unoparty"; ValueType: "string"; ValueName: "URL Protocol"; ValueData: ""
Root: HKCR; Subkey: "unoparty\DefaultIcon"; ValueType: "string"; ValueData: "{app}\FreeWalletUno.exe,0"
Root: HKCR; Subkey: "unoparty\shell\open\command"; ValueType: "string"; ValueData: """{app}\FreeWalletUno.exe"" ""%1"""
; Add support for freewalletuno: urls
Root: HKCR; Subkey: "freewalletuno"; ValueType: "string"; ValueData: "URL:freewalletuno Protocol"; Flags: uninsdeletekey
Root: HKCR; Subkey: "freewalletuno"; ValueType: "string"; ValueName: "URL Protocol"; ValueData: ""
Root: HKCR; Subkey: "freewalletuno\DefaultIcon"; ValueType: "string"; ValueData: "{app}\FreeWalletUno.exe,0"
Root: HKCR; Subkey: "freewalletuno\shell\open\command"; ValueType: "string"; ValueData: """{app}\FreeWalletUno.exe"" ""%1"""

; Override some default messages
[Messages]
WelcomeLabel1=Welcome to [name] Setup Wizard
WelcomeLabel2=This will install [name] on your computer.%n%nIt is recommended that you close all other applications before continuing.

; Include all the files necessary for the tbe build
[Files]
Source: "C:\FreeWalletUno\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs

; Setup icon group and icon on desktop
[Icons]
Name: "{group}\FreeWalletUno";          Filename: "{app}\FreeWalletUno.exe"
Name: "{commondesktop}\FreeWalletUno";  Filename: "{app}\FreeWalletUno.exe"
