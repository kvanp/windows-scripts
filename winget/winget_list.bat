@echo off

set FILE=""
if not "%~2" == "" set FILE=%~2
set WINGET=winget
set SUBCOMMAND=%~1
set OPTIONS=

if not exist "%FILE%" call :error "File '%FILE%' do not exist" || goto :eof

for /f "delims=; eol=#" %%i in (%FILE%) do call :strip "%%i"
goto :eof

:strip
	if "%~1" == "" exit /b 0

	set recursiv=0
	if not "%~2" == "" set recursiv=%~2

	set str2=%~1
	set str=%str2:  =%

	if "%str:~-1%" == " " call :strip "%str% " 1
	if "%str:~0,1%" == " " call :strip " %str%" 1

	rem makeshift location because the string cannot be transported back.
	if %recursiv% EQU 0 call :command "%str%"
	set rc=%errorlevel%
	set recursiv=0
	exit /b %rc%

:command
	if "%~1" == "" exit /b

	"%WINGET%" %SUBCOMMAND% %OPTIONS% "%~1"
	exit /b %errorlevel%

:err_msg
	echo %~1: %~2 1>&2
	exit /b 0

:error
	call :err_msg "error" "%~1"
	exit /b 1

:eof
exit /b
