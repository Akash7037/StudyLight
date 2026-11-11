@echo off
setlocal
set "APP_DIR=%~dp0"

if not exist "%APP_DIR%.venv\Scripts\python.exe" (
    echo StudyLight is not installed correctly. Run install.bat first.
    exit /b 1
)

"%APP_DIR%.venv\Scripts\python.exe" "%APP_DIR%screen.py" %*
exit /b %ERRORLEVEL%
