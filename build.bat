@echo off

SetLocal EnableDelayedExpansion

set myArg=%1

call :TOUPPERCASE myArg
echo %myArg%

pushd %~dp0

if %myArg% == DEBUG (
  goto :Debug
)

cmake -H%~dp0/FooBar -B%~dp0/FooBar/Release -G "Visual Studio 17 2022" -A "x64" -DRELEASE_SHARED_LIBS=ON
cmake -H%~dp0/FooBarUser -B%~dp0/FooBarUser/Release -G "Visual Studio 17 2022" -A "x64" -DRELEASE_SHARED_LIBS=ON

REM Only debug works using registry. Release Releases we anticipate are installed
cd %~dp0\FooBar\Release
MSBuild.exe -maxCpuCount:20 FooBar.sln /p:Configuration=Debug
cd %~dp0\FooBarUser\Release
MSBuild.exe -maxCpuCount:20 FooBarUser.sln /p:Configuration=Debug

goto :eof

:Debug:

cmake -H%~dp0/FooBar -B%~dp0/FooBar/Debug -G "Visual Studio 17 2022" -A "x64" -DRELEASE_SHARED_LIBS=ON
cmake -H%~dp0/FooBarUser -B%~dp0/FooBarUser/Debug -G "Visual Studio 17 2022" -A "x64" -DRELEASE_SHARED_LIBS=ON

REM Only debug works using registry. Debug Debugs we anticipate are installed
cd %~dp0\FooBar\Debug
MSBuild.exe -maxCpuCount:20 FooBar.sln /p:Configuration=Debug
cd %~dp0\FooBarUser\Debug
MSBuild.exe -maxCpuCount:20 FooBarUser.sln /p:Configuration=Debug

cd %~dp0
