@echo off

pushd %~dp0

REM We could show STDERR using 1>NUL
del /F /Q /S %~dp0\FooBar\build >NUL 2>&1
del /F /Q /S %~dp0\FooBarUser\build >NUL 2>&1
del /F /Q /S %~dp0\FooBar\release >NUL 2>&1
del /F /Q /S %~dp0\FooBar\debug >NUL 2>&1
del /F /Q /S %~dp0\FooBarUser\release >NUL 2>&1
del /F /Q /S %~dp0\FooBarUser\debug >NUL 2>&1
