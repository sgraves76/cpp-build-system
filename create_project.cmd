@echo off

setlocal

pushd "%~dp0%"
call src\scripts\setup_msys2.cmd
call mingw64 -no-start ./create_project.sh "%1" "%2"
popd
