@echo off

rem ****************************************************************************
rem	My Command Line Prompt
rem ****************************************************************************

rem Set for current session
set prompt=%USERNAME%@%COMPUTERNAME%$S$S$D$S$S$T$S$S$M$S$P$_$G$S

rem For ever
setx prompt %prompt%
