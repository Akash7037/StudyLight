@echo off
setlocal
set "APP_DIR=%~dp0"

if /i "%~1"=="--uninstall" goto uninstall

if not exist "%APP_DIR%.venv\Scripts\python.exe" (
    echo StudyLight is not installed correctly. Run install.bat first.
    exit /b 1
)

"%APP_DIR%.venv\Scripts\python.exe" "%APP_DIR%screen.py" %*
exit /b %ERRORLEVEL%

:uninstall
if not "%~2"=="" (
    echo Usage: studylight --uninstall
    exit /b 1
)
if not exist "%APP_DIR%uninstall.ps1" (
    echo ERROR: uninstall.ps1 is missing. Reinstall StudyLight before uninstalling.
    exit /b 1
)
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%APP_DIR%uninstall.ps1"
exit /b %ERRORLEVEL%
