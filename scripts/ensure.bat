@echo off

setlocal
set venv=%~1
set pylsp=%venv%\Scripts\pylsp.exe


if "%venv%"=="" (
  echo venv is not specified.
  exit /b 5
)


if exist "%pylsp%" (
  echo %pylsp%
  exit /b 0
)


for /f %%i in ('where pylsp 2^>NUL') do (
  echo pylsp
  exit /b 0
)


set python="%venv%\Scripts\python.exe"
%python% "%~dp0check.py" 2>NUL && goto :INSTALL_PYLSP

set python=python
%python% "%~dp0check.py" 2>NUL && goto :CREATE_VENV

echo Python check failed.
exit /b 1


:CREATE_VENV

%python% -m venv "%venv%" && goto :INSTALL_PYLSP

echo Unable to create Python venv %venv%
exit /b 2


:INSTALL_PYLSP

call "%venv%\Scripts\activate" ^
  && python -m pip install --upgrade pip ^
  && python -m pip install --force-reinstall "python-lsp-server[all]" ^
  && goto :DONE

echo Unable to install pylsp.
exit /b 3


:DONE

if exist "%pylsp%" (
  echo %pylsp%
  exit /b 0
)

echo Not found: %pylsp%
exit /b 4

endlocal
