@echo off

setlocal

pushd "%~dp0"
for /f "usebackq tokens=*" %%i in (`cygpath "%~2"`) do set ARG1=%%i
call mingw64 -no-start ./update_project.sh "%~1" "%ARG1%"
popd

endlocal
