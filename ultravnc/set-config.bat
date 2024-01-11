@echo off

setlocal

set cd_=

if "%cd%" == "C:\WINDOWS\system32" (
	set "cd_=%~dp0"
)

set "ssh=sshd"
set "vnc=uvnc_service"
set "vnc_default_depend=Tcpip"
set "vnc_path=%ProgramFiles%\uvnc bvba\UltraVNC"
set "vnc_config_filename=ultravnc.ini"

sc config %ssh% start=auto
sc start %ssh%

sc config %vnc% depend=%vnc_default_depend%/%ssh%
sc config %vnc% start=auto
sc start %vnc%

sc qc %ssh%
sc qc %vnc%

xcopy "%cd_%%vnc_config_filename%" "%vnc_path%" /Y
pause
