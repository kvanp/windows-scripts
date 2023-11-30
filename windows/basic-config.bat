@echo off

call :telemetry_data_disable
call :cortana_disable
call :lockscreen_disable
rem call :rtc_in_utc
rem call :win_update_auto_disable
call :win_use_stat_del

goto :eof
rem ********           Disable Windows telemetry data                    ********
:telemetry_data_disable
	echo.
	echo.Disable Windows telemetry data
	call :service_disable DiagTrack
	call :service_disable dmwappushservice

	echo "" > C:\ProgramData\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl

	call :reg_add_dword "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" AllowTelemetry 0 %0
	exit /b %errorlevel%

rem ********           Disable Cortana                                   ********
:cortana_disable
	echo.
	echo.Disable Cortana
	set _SUBKEY=HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search
	call :reg_add_dword "%_SUBKEY%" AllowCortana             0 %0
	call :reg_add_dword "%_SUBKEY%" AllowSearchToUseLocation 0 %0
	call :reg_add_dword "%_SUBKEY%" AllowCortanaAboveLock    0 %0
	exit /b %errorlevel%

rem ********           Disable Lockscreen                                ********
:lockscreen_disable
	echo.
	echo.Disable Lockscreen
	call :reg_add_dword "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" NoLockScreen 1 %0
	exit /b %errorlevel%

rem ********           RTC in UTC                                        ********
:rtc_in_utc
	echo.
	echo.RTC in UTC
	call :reg_add_dword "HKLM\SOFTWARE\CurrentControlSet\Control\TimeZoneInformation" RealTimeIsUniversal 1 %0
	exit /b %errorlevel%

rem ********           No automatic Windows updates                      ********
:win_update_auto_disable
	echo.No automatic Windows updates
	set _SUBKEY=HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU
	call :reg_add_dword "%_SUBKEY%" NoAutoUpdate 0 %0
	call :reg_add_dword "%_SUBKEY%" AUOptions 2 %0
	exit /b %errorlevel%

rem ********           Delete Windows usage statistics                   ********
:win_use_stat_del
	echo.
	echo.Delete Windows usage statistics
	call :dir_del_all C:\Windows\System32\sru
	exit /b %errorlevel%


rem ********           Little helper                                     ********

:service_disable
	set SERVICE=%~1

	sc delete "%SERVICE%"
	exit /b %errorlevel%

:reg_add_dword
	set SUBKEY=%~1
	set VALUE=%~2
	set DATA=%~3
	set NAME=%~4
	set TYPE=REG_DWORD

	call :reg_add_with_backup "%SUBKEY%" "%VALUE%" "%TYPE%" "%DATA%" "%NAME%"
	exit /b %errorlevel%

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

:dir_del_all
	call :file_del_all "%~1"\*
	exit /b %errorlevel%

:file_del_all
	del /F /S /Q %1
	exit /b %errorlevel%


:err_msg
	echo %~1: %~2 1>&2
	exit /b 0

:error
	call :err_msg "error" "%~1"
	exit /b 1

:eof
