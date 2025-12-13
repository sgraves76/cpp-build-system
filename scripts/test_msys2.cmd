@echo off

setlocal EnableExtensions

set "SED=sed"

set "SCRIPTS_DIR=%~dp0"
pushd "%SCRIPTS_DIR%"
set "SCRIPTS_DIR=%CD%"
popd

set "SOURCE_DIR=%~dp0.."
pushd "%SOURCE_DIR%"
set "SOURCE_DIR=%CD%"
popd

set "TEST_DIR=%SOURCE_DIR%\build"

set "PLATFORM=msys2"
set "BUILD_TYPE=%1"
set "WITH_TYPE=%2"

if /I not "%BUILD_TYPE%"=="shared" if /I not "%BUILD_TYPE%"=="static" (
  call :ERROR_EXIT "Must specify 'shared' or 'static'." 1
)

if not defined TEST_DIR (
  call :ERROR_EXIT "TEST_DIR is not set." 1
)

if not exist "%TEST_DIR%" mkdir "%TEST_DIR%"

set "NAME=%BUILD_TYPE%"
if "%WITH_TYPE%"=="1" set "NAME=%NAME%_crypto"
if "%WITH_TYPE%"=="2" set "NAME=%NAME%_dsm"
if "%WITH_TYPE%"=="3" set "NAME=%NAME%_sqlite"
if "%WITH_TYPE%"=="4" set "NAME=%NAME%_errors_v1"
if "%WITH_TYPE%"=="5" set "NAME=%NAME%_fmt"
if "%WITH_TYPE%"=="6" set "NAME=%NAME%_libevent"
if "%WITH_TYPE%"=="7" set "NAME=%NAME%_crypto_no_boost"

if exist "%TEST_DIR%\%NAME%\" rd /s /q "%TEST_DIR%\%NAME%"

pushd "%SOURCE_DIR%"
call ".\create_project.cmd" "%NAME%" "%TEST_DIR%" || (
  call :ERROR_EXIT "Failed to create %PLATFORM% project." 2
)
popd

pushd "%TEST_DIR%\%NAME%"
if "%WITH_TYPE%"=="1" (
  %SED% -i "s/PROJECT_ENABLE_LIBSODIUM=OFF/PROJECT_ENABLE_LIBSODIUM=ON/g" ".\config.sh"
  %SED% -i "s/PROJECT_ENABLE_BOOST=OFF/PROJECT_ENABLE_BOOST=ON/g"         ".\config.sh"
  %SED% -i "s/PROJECT_ENABLE_JSON=OFF/PROJECT_ENABLE_JSON=ON/g"           ".\config.sh"
)
if "%WITH_TYPE%"=="2" %SED% -i "s/PROJECT_ENABLE_LIBDSM=OFF/PROJECT_ENABLE_LIBDSM=ON/g" ".\config.sh"
if "%WITH_TYPE%"=="3" %SED% -i "s/PROJECT_ENABLE_SQLITE=OFF/PROJECT_ENABLE_SQLITE=ON/g" ".\config.sh"
if "%WITH_TYPE%"=="4" %SED% -i "s/PROJECT_ENABLE_V2_ERRORS=ON/PROJECT_ENABLE_V2_ERRORS=OFF/g" ".\config.sh"
if "%WITH_TYPE%"=="5" %SED% -i "s/PROJECT_ENABLE_FMT=OFF/PROJECT_ENABLE_FMT=ON/g" ".\config.sh"
if "%WITH_TYPE%"=="6" %SED% -i "s/PROJECT_ENABLE_LIBEVENT=OFF/PROJECT_ENABLE_LIBEVENT=ON/g" ".\config.sh"
if "%WITH_TYPE%"=="7" %SED% -i "s/PROJECT_ENABLE_LIBSODIUM=OFF/PROJECT_ENABLE_LIBSODIUM=ON/g" ".\config.sh"

if /I "%BUILD_TYPE%"=="shared" (
  %SED% -i "s/PROJECT_STATIC_LINK=ON/PROJECT_STATIC_LINK=OFF/g" ".\config.sh"
)

call .\scripts\make_win32.cmd || (
  call :ERROR_EXIT "build %PLATFORM% failed." 3
)

call .\scripts\run_tests.cmd || (
  call :ERROR_EXIT "testing %PLATFORM% failed." 3
)
popd

if exist "%TEST_DIR%\%NAME%\" rd /s /q "%TEST_DIR%\%NAME%"

exit 0

:ERROR_EXIT
echo %1
exit %2
