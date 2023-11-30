@echo off

if not "%~1" == "on" if not "%~1" == "off" (
	echo.Wrong parameter, only on or off!
) else (
	powercfg -h %~1
)
