@echo off
setlocal
rem Codepage UTF-8
chcp 65001 > /NUL

set cmd_name=%~nx0

call :main %*
exit /b

:usage
:help
	echo.Wrapper für netsh wlan
	echo.Usage:
	echo.  %cmd_name% BEFEHL [NAME] [ORDNER]
	echo.
	echo.BEFEHL
	echo.    help            Die Hilfe anzeigen.
	echo.    show            Anzeigen vorhandener Profile.
	echo.    show PROFILNAME Anzeigen des Profiles "PROFILNAME".
	echo.    add PROFILNAME  Profil "PROFILENAME" importieren.
	echo.    del PROFILNAME  Profil "PROFILENAME" löschen.
	echo.    export          Alle Profile ins Arbeitsverzeichnus exportieren.
	echo.    export "" FOLDER
	echo.                    Alle Profile ins Verzeichnus "FOLDER" exportieren.
	echo.    export PROFILNAME           
	echo.                    Profil "PROFILENAME" exportieren.
	echo.    export PROFILNAME FOLDER    
	echo.                    Profil "PROFILENAME" ins Verzeichnus "FOLDER" exportieren.
	exit /b

:add
	netsh wlan add profile filename=%1
	exit /b

:show
	setlocal
	set name=

	if not "%~1" == "" set name=name=%1 key=clear

	netsh wlan show profiles %name%
	exit /b

:del
	netsh wlan delete profile name=%1
	exit /b

:export
	setlocal
	set name=
	set folder=

	if not "%~1" == "" set name=name=%1
	if not "%~2" == "" set folder=folder=%2

	netsh wlan export profile %nam% %folder%
	exit /b

:main
	setlocal
	set func_array=add show del export help
	set fcall=%~1
	set name=%2
	set folder=%3

	for %%i in (%func_array%) do (
		if "%~1" == "%%i" (
			call :%%i %name% %folder%
			exit /b
		)
	)
	call :usage
	exit /b
