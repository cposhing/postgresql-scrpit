@echo off 

:: 启动postgresql

set DIRNAME=%~dp0
if "%DIRNAME%"=="" set DIRNAME=.

set SCRPIT_BASE_NAME=%~f0

set SCRPIT_HOME=%DIRNAME%
for %%i in ("%SCRPIT_HOME%") do set SCRPIT_HOME=%%~fi

for %%I in ("%SCRPIT_HOME%..\") do set PGHOME=%%~dpfI
set PG_CTL_EXE=%PGHOME%bin\pg_ctl.exe

"%PG_CTL_EXE%" -V >NUL 2>&1
if %ERRORLEVEL% equ 0 goto init
echo [错误]当前脚本"%SCRPIT_BASE_NAME%"似乎在一个错误的位置
goto fail

:init
:: if not input find then set %PGHOME%data as a default data dir 1
@rem set SRC=%~df1
if "%~1" == "" goto noinput
set DATADIR=%~1
goto validation

:noinput
set DATADIR=%PGHOME%data

:validation
:: a simple validation 
if exist "%DATADIR%\pg_hba.conf" goto start
echo [错误]"%DATADIR%"似乎是一个错误的位置
goto fail

:start
set FILENAME=%PGHOME%postgresql.log
cmd /s /c ""%PG_CTL_EXE%" start --pgdata="%DATADIR%" --log="%FILENAME%" --mode=smart"

if %ERRORLEVEL% equ 1 goto fail
goto end

:fail
echo [错误]请解决错误后, 继续执行操作
pause

:end
exit

