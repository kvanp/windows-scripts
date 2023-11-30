@echo off

rem https://learn.microsoft.com/en-us/troubleshoot/windows-server/user-profiles-and-logon/turn-on-automatic-logon

set _SUBKEY=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon
set EX_OUTPUT=%USERPROFILE%\auto-login

set _USERNAME=%~1
set _PASSWORD=%~2
set _DOMAINNAME=%~3

if "%_USERNAME%" == "" set /p USERNAME=Enter Username:
if "%_PASSWORD%" == "" set /p PASSWORD=Enter Password:

set ENTRYS=%_ENTRYS%

call :reg_add_with_backup "%_SUBKEY%" DefaultUserName REG_SZ "%USERNAME%" "%EX_OUTPUT%"
call :reg_add_with_backup "%_SUBKEY%" DefaultPassword REG_SZ "%PASSWORD%" "%EX_OUTPUT%"
call :reg_add_with_backup "%_SUBKEY%" AutoAdminLogon  REG_SZ 0            "%EX_OUTPUT%"

if not "%DOMAINNAME%" == "" call :add DefaultDomainName REG_SZ "%DOMAINNAME%" "%EX_OUTPUT%"

echo.
echo done
goto :eof

:reg_add_with_backup
	set SUBKEY=%~1
	set VALUE=%~2
	set TYPE=%~3
	set DATA=%~4
	set TMP=%~5

	set NAME=%TMP%
	if "%NAME:~0,1%" == ":" set NAME=%TMP:~1%

	set OUTPUT=%VALUE%
	if not "%NAME%" == "" set OUTPUT=%NAME%_%VALUE%

	call :reg_add "%SUBKEY%" "%VALUE%" "%TYPE%" "%DATA%" "%OUTPUT%"
	exit /b %errorlevel%

:reg_add
	set SUBKEY=%~1
	set VALUE=%~2
	set TYPE=%~3
	set DATA=%~4
	set OUTPUT=%~5

	if not "%OUTPUT%" == "" call :reg_export "%SUBKEY%" "%VALUE%" "%OUTPUT%" || exit /b %errorlevel%

	reg add "%SUBKEY%" /v "%VALUE%" /t "%TYPE%" /d "%DATA%" /f
	exit /b %errorlevel%

:reg_export
	set SUBKEY=%~1
	set VALUE=%~2
	set OUTPUT=%~3

	call :reg_query "%SUBKEY%" "%VALUE%" || exit /b %errorlevel%

	set ENTRY=
	if not "%VALUE%" == "" set ENTRY=/v %VALUE%

	if not exist "%OUTPUT%.reg" reg query "%SUBKEY%" %ENTRY% > "%OUTPUT%.reg"

	rem set FULL_ENTRY=%SUBKEY%
	rem if not "%VALUE%" == "" set FULL_ENTRY=%SUBKEY%\%VALUE%

	rem reg export "%FULL_ENTRY%" "%OUTPUT%.reg"
	exit /b %errorlevel%

:reg_query
	set SUBKEY=%~1
	set VALUE=%~2

	set ENTRY=
	if not "%VALUE%" == "" set ENTRY=/v %VALUE%

	reg query "%SUBKEY%" %ENTRY%
	exit /b %errorlevel%

:err_msg
	echo %~1: %~2 1>&2
	exit /b 0

:error
	call :err_msg "error" "%~1"
	exit /b 1

:eof
