@echo off 

:: ����postgresql

set DIRNAME=%~dp0
if "%DIRNAME%"=="" set DIRNAME=.

set SCRPIT_BASE_NAME=%~f0

set SCRPIT_HOME=%DIRNAME%
for %%i in ("%SCRPIT_HOME%") do set SCRPIT_HOME=%%~fi

for %%I in ("%SCRPIT_HOME%..\") do set PGHOME=%%~dpfI
set PG_CTL_EXE=%PGHOME%bin\pg_ctl.exe

"%PG_CTL_EXE%" -V >NUL 2>&1
if %ERRORLEVEL% equ 0 goto init
echo [����]��ǰ�ű�"%SCRPIT_BASE_NAME%"�ƺ���һ�������λ��
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
echo [����]"%DATADIR%"�ƺ���һ�������λ��
goto fail

:start
set FILENAME=%PGHOME%postgresql.log
cmd /s /c ""%PG_CTL_EXE%" start --pgdata="%DATADIR%" --log="%FILENAME%" --mode=smart"

if %ERRORLEVEL% equ 1 goto fail
goto end

:fail
echo [����]���������, ����ִ�в���
pause

:end
exit

