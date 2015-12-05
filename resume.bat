@echo off
echo Initializing NSL environment variables

set NSLJ_ROOT=C:\Salvador\NSL3_0_s
set JAVA_HOME=C:\j2sdk1.4.1_01
set NSL_OS=windows

echo Updating path and classpath

set NSL_SIM=%NSLJ_ROOT%\nslj\src
set PATH=%JAVA_HOME%\bin;%NSLJ_ROOT%\nslj\bin;%NSLJ_ROOT%\nslc\bin;%PATH%
set CLASSPATH=.;%NSLJ_ROOT%\nslc\src;%NSLJ_ROOT%;%NSL_SIM%\main;%NSL_SIM%\nsls\jacl;%NSL_SIM%\nsls\tcljava
doskey /insert
@echo on
