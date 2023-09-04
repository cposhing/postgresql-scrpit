@echo off

:: postgresql ��װ�ű�
:: ���ð汾 postgresql-9.3.25-1-windows-x64-binaries
:: https://www.postgresql.org/docs/9.3/app-initdb.htm

set EXIT_CODE=0

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
:: some init env list  locale=Chinese_China.utf8
:: set PGLIB=%PGHOME%lib

set DATADIR=%PGHOME%data
set PW_FILE=%SCRPIT_HOME%pw.txt

"%INITDB_EXE%"^
 --pgdata="%DATADIR%"^
 --locale=Chinese_China.utf8^
 --encoding=UTF8^
 --auth-host=md5^
 --username=postgres^
 --pwfile="%PW_FILE%"

if %ERRORLEVEL% equ 1 goto fail

set START_SCRPIT=%SCRPIT_HOME%pg_strat.cmd
call "%START_SCRPIT%" "%DATADIR%" || goto fail

goto end

:fail 
set EXIT_CODE=%ERRORLEVEL%
echo [����]���������, ����ִ�в���
pause

:end
exit /b %EXIT_CODE%

