@echo off

setlocal

pushd "%~dp0%"
call mingw64 -no-start ./update_project.sh "%1" "%2"
popd
