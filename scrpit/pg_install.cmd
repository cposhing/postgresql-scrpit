@echo off

:: postgresql ��װ�ű�
:: ���ð汾 postgresql-9.3.25-1-windows-x64-binaries
:: https://www.postgresql.org/docs/9.3/app-initdb.htm

@rem get the current scrpit path set as  SCRPIT_HOME
set DIRNAME=%~dp0
if "%DIRNAME%"=="" set DIRNAME=.

set SCRPIT_BASE_NAME=%~f0

set SCRPIT_HOME=%DIRNAME%
for %%i in ("%SCRPIT_HOME%") do set SCRPIT_HOME=%%~fi

for %%I in ("%SCRPIT_HOME%..\") do set PGHOME=%%~dpfI
set INITDB_EXE=%PGHOME%bin\initdb.exe

"%INITDB_EXE%" -V >NUL 2>&1
if %ERRORLEVEL% equ 0 goto init
echo [����]��ǰ�ű�"%SCRPIT_BASE_NAME%"�ƺ���һ�������λ��
goto fail

:init

set DATADIR=%PGHOME%data
set PW_FILE=%SCRPIT_HOME%pw.txt

:: locale Chinese_China.utf8 or zh_CN
:: auth-host md5 or scram-sha-256

"%INITDB_EXE%"^
 --pgdata="%DATADIR%"^
 --locale=Chinese_China.utf8^
 --encoding=UTF8^
 --auth-host=scram-sha-256^
 --username=postgres^
 --pwfile="%PW_FILE%"

if %ERRORLEVEL% equ 1 goto fail

set START_SCRPIT=%SCRPIT_HOME%pg_strat.cmd
call "%START_SCRPIT%" "%DATADIR%" || goto fail

goto end

:fail 
echo [����]���������, ����ִ�в���
pause

:end
exit

