@echo off

setlocal

pushd "%~dp0"
call src\scripts\setup_msys2.cmd

for /f "usebackq tokens=*" %%i in (`cygpath "%~2"`) do set ARG1=%%i
call mingw64 -no-start ./create_project.sh "%~1" "%ARG1%"
popd

endlocal
