@echo off

set SERVICES=sshd uvnc_service

for %%i in (%SERVICES%) do (

	sc stop %%i
)

timeout 5