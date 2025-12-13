@echo off

setlocal

pushd "%~dp0"
call src\scripts\setup_msys2.cmd

call mingw64 -no-start ./grab_packages.sh
popd

endlocal
