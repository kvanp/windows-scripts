@echo off
rem **************************************************
rem Wrapper for OpenVPN Connect v3 service daemon mode
rem **************************************************

setlocal
set cmd_name=%~nx0

set "OPENVPN_DIR=%ProgramFiles%\OpenVPN Connect\"
set "OPENVPN_EXE=ovpnconnector.exe"
set "OPENVPN=%OPENVPN_DIR%\%OPENVPN_EXE%"

call :main %*
exit /b

:usage
	echo.Wrapper for OpenVPN Connect v3 service daemon mode
	echo.Usage:
	echo.  %cmd_name% COMMAND [ARGUMENTS]
	echo.
	echo.Commands:
	echo.  help            Show this help.
	echo.  install         Install the system service
	echo.  set-profile ^<FULL_PATH_AND_FILENAME_TO_PROFILE.OVPN^>
	echo.                  Specify connection profile to use
	echo.  set-log ^<FULL_PATH_AND_FILENAME_TO_LOGFILE.LOG^>
	echo.                  Specify the path to a log file
	echo.  start           Start the service
	echo.  stop            Stop the service
	echo.  restart         Restart the service
	echo.  unset-profile   Undo the configuration of connection profile
	echo.  unset-log       Undo the configuration of the path to a log file
	echo.  unsintall       Uninstall the system service
	echo.
	echo.Help source:
	echo.  https://openvpn.net/vpn-server-resources/use-openvpn-connect-v3-on-windows-in-service-daemon-mode/
	echo.
	echo.Example:
	echo.  1. Install the system service:
	echo.    %cmd_name% install
	echo.  2. Set the profile:
	echo.    %cmd_name% set-profile ^<FULL_PATH_AND_FILENAME_TO_PROFILE.OVPN^>
	echo.  3. Set the path to the log file (optional):
	echo.    %cmd_name% set-log ^<FULL_PATH_AND_FILENAME_TO_LOGFILE.LOG^>
	echo.  4. Start the service
	echo.    %cmd_name% start

	exit /b

rem Install the system service
:install
	shift
	"%OPENVPN%" install
	exit /b

rem Specify connection profile to use (optional)
:set-profile
	shift
	"%OPENVPN%" set-config profile "%~1"
	exit /b
rem Note: if your OpenVPN Connect installation file was downloaded from Access
rem Server or OpenVPN Cloud and came with a bundled autologin connection
rem profile, then you can skip step 3. It will then simply default to the
rem bundled connection profile. It can be found in the program location with
rem the name "ovpnconnector.ovpn" - that is the bundled connection profile.

rem Specify the path to a log file (optional)
:set-log
	shift
	"%OPENVPN%" set-config log "%~1"
	exit /b
rem Note: if you skip step 4, the service will write to the default log file
rem in the program location with the name "ovpnconnector.log".

rem Start the service
:start
	shift
	"%OPENVPN%" start
	exit /b

rem Stop the service
:stop
	shift
	"%OPENVPN%" stop
	exit /b

rem Restart the service
:restart
	shift
	"%OPENVPN%" restart
	exit /b

rem Undo the configuration of connection profile
:unset-profile
	shift
	"%OPENVPN%" unset-config profile
	exit /b

rem Undo the configuration of the path to a log file
:unset-log
	shift
	"%OPENVPN%" unset-config log
	exit /b

rem If you want to remove the system service then run this command
:uninstall
	shift
	"%OPENVPN%" remove
	exit /b

:main
	setlocal
	set func_array=install set-profile set-log start stop restart unset-profile unset-log uninstall
	set fcall=%~1

	for %%i in (%func_array%) do (
		if "%fcall%" == "%%i" (
			call :%%i %*
			exit /b
		)
	)
	call :usage
	exit /b
