; FreeWallet.iss
;
; Config file for creating a windows installer file for tbe
;


[Setup]
AppName=FreeWallet
AppVersion=0.9.2
DefaultDirName={pf}\FreeWallet
DefaultGroupName=FreeWallet
UninstallDisplayIcon={app}\FreeWallet.exe
Compression=lzma2
SolidCompression=yes
OutputDir=C:\Users\J-Dog\Desktop\
OutputBaseFilename=FreeWallet

; "ArchitecturesInstallIn64BitMode=x64" requests that the install be
; done in "64-bit mode" on x64, meaning it should use the native
; 64-bit Program Files directory and the 64-bit view of the registry.
; On all other architectures it will install in "32-bit mode".
ArchitecturesInstallIn64BitMode=x64

[Registry]
; Add support for unobtanium: urls
Root: HKCR; Subkey: "unobtanium"; ValueType: "string"; ValueData: "URL:unobtanium Protocol"; Flags: uninsdeletekey
Root: HKCR; Subkey: "unobtanium"; ValueType: "string"; ValueName: "URL Protocol"; ValueData: ""
Root: HKCR; Subkey: "unobtanium\DefaultIcon"; ValueType: "string"; ValueData: "{app}\FreeWallet.exe,0"
Root: HKCR; Subkey: "unobtanium\shell\open\command"; ValueType: "string"; ValueData: """{app}\FreeWallet.exe"" ""%1"""
; Add support for unoparty: urls
Root: HKCR; Subkey: "unoparty"; ValueType: "string"; ValueData: "URL:unoparty Protocol"; Flags: uninsdeletekey
Root: HKCR; Subkey: "unoparty"; ValueType: "string"; ValueName: "URL Protocol"; ValueData: ""
Root: HKCR; Subkey: "unoparty\DefaultIcon"; ValueType: "string"; ValueData: "{app}\FreeWallet.exe,0"
Root: HKCR; Subkey: "unoparty\shell\open\command"; ValueType: "string"; ValueData: """{app}\FreeWallet.exe"" ""%1"""
; Add support for freewallet: urls
Root: HKCR; Subkey: "freewallet"; ValueType: "string"; ValueData: "URL:freewallet Protocol"; Flags: uninsdeletekey
Root: HKCR; Subkey: "freewallet"; ValueType: "string"; ValueName: "URL Protocol"; ValueData: ""
Root: HKCR; Subkey: "freewallet\DefaultIcon"; ValueType: "string"; ValueData: "{app}\FreeWallet.exe,0"
Root: HKCR; Subkey: "freewallet\shell\open\command"; ValueType: "string"; ValueData: """{app}\FreeWallet.exe"" ""%1"""

; Override some default messages
[Messages]
WelcomeLabel1=Welcome to [name] Setup Wizard
WelcomeLabel2=This will install [name] on your computer.%n%nIt is recommended that you close all other applications before continuing.

; Include all the files necessary for the tbe build
[Files]
Source: "C:\Users\J-Dog\Desktop\FreeWallet\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs

; Setup icon group and icon on desktop
[Icons]
Name: "{group}\FreeWallet";          Filename: "{app}\FreeWallet.exe"
Name: "{commondesktop}\FreeWallet";  Filename: "{app}\FreeWallet.exe"
