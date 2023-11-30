@echo off

rem ********           Windows Telemetriedaten abschalten                ********
echo.
echo.Windows Telemetriedaten abschalten
sc delete DiagTrack

sc delete dmwappushservice

echo "" > C:\ProgramData\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f

rem ********           Cortana abschalten                                ********
echo.
echo.Cortana abschalten
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana             /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowSearchToUseLocation /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortanaAboveLock    /t REG_DWORD /d 0 /f

rem ********           Lockscreen abschalten                             ********
echo.
echo.Lockscreen abschalten
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v NoLockScreen /t REG_DWORD /d 1 /f

rem ********           RTC in UTC                                        ********
echo.
echo.RTC in UTC
reg add "HKLM\SOFTWARE\CurrentControlSet\Control\TimeZoneInformation" /v RealTimeIsUniversal /t REG_DWORD /d 1 /f

rem ********           Windows Update nicht automatisch                  ********
echo.Windows Update nicht automatisch
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v AUOptions /t REG_DWORD /d 2 /f

rem ********           Windows Nutzungsstatistik loeschen                ********
echo.
echo.Windows Nutzungsstatistik loeschen
del /F /S /Q C:\Windows\System32\sru\*

pause
