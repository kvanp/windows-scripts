@echo off

set SERVICES=sshd uvnc_service

for %%i in (%SERVICES%) do (

	sc start %%i
)

timeout 5