@echo off

rem https://learn.microsoft.com/en-us/troubleshoot/windows-server/user-profiles-and-logon/turn-on-automatic-logon

set SUBKEY=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon
set EX_OUTPUT=%USERPROFILE%\auto-login

set _USERNAME=%~1
set _PASSWORD=%~2
set _DOMAINNAME=%~3

if "%_USERNAME%" == "" set /p USERNAME=Enter Username: 
if "%_PASSWORD%" == "" set /p PASSWORD=Enter Password: 

set ENTRYS=%_ENTRYS%

call :add DefaultUserName REG_SZ "%USERNAME%" "%EX_OUTPUT%"
call :add DefaultPassword REG_SZ "%PASSWORD%" "%EX_OUTPUT%"
call :add AutoAdminLogon REG_SZ 0 "%EX_OUTPUT%"

if not "%DOMAINNAME%" == "" call :add DefaultDomainName REG_SZ "%DOMAINNAME%" "%EX_OUTPUT%"

echo.
echo done
goto :eof

:add
	set VALUE=%~1
	set TYPE=%~2
	set DATA=%~3
	set OUTPUT=%~4

	if not "%OUTPUT%" == "" call :export "%ENTRY%" || exit /b %errorlevel%
 
	reg add "%SUBKEY%" /v "%VALUE%" /t "%TYPE%" /d "%DATA%"

	exit /b %errorlevel%

:export
	set ENTRY=%~1
	set OUTPUT=%~2

	call :query "%ENTRY%" || exit /b %errorlevel%

	set FULL_ENTRY=%SUBKEY%
	if not "%ENTRY%" == "" set OUTPUT=%~1_%ENTRY%
	if not "%ENTRY%" == "" set FULL_ENTRY=%SUBKEY%\%ENTRY%

	reg export %FULL_ENTRY%" "%OUTPUT%.reg"
	exit /b %errorlevel%

:query
	set ENTRY=%~1
	set FULL_ENTRY=%SUBKEY%

	if not "%ENTRY%" == "" set FULL_ENTRY=%SUBKEY%\%ENTRY%
	
	reg query "%FULL_ENTRY%"
	exit /b %errorlevel%

:err_msg
	echo %~1: %~2 1>&2
	exit /b 0

:error
	call :err_msg "error" "%~1"
	exit /b 1

:eof
